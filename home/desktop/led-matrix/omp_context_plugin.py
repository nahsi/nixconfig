"""Display context usage for up to four omp instances on the right LED panel.

Usage fills pixels left to right, from bottom to top, capped at 100%.
A top dash without a fill means unknown usage. Animated dots identify instances
when multiple tiles are visible. A pulsing border indicates attention.

The receiver accepts newline-delimited JSON over a Unix socket and assigns
instance numbers 1..4. Additional instances wait for a free number.
Valid snapshots renew a three-second lease. Disconnects hide tiles but reserve
their numbers until expiry. The monitor owns the serial devices.
"""

import atexit
import json
import math
import os
import re
import select
import socket
import stat
import time
from typing import NamedTuple

import numpy as np


class Usage(NamedTuple):
    tokens: float
    context_window: float


class Snapshot(NamedTuple):
    instance: str
    usage: Usage | None
    attention: bool


class Tile(NamedTuple):
    slot: int
    usage: Usage | None
    attention: bool


_MAX_LINE = 4096
_MAX_CLIENTS = 16
_MAX_READS = 4
_MAX_FRAMES = 32
_LEASE_SECONDS = 3


def _snapshot(line: bytes) -> Snapshot | None:
    try:
        value = json.loads(line)
        if not isinstance(value, dict) or type(value.get("v")) is not int or value["v"] != 1:
            return None
        instance = value.get("id")
        if not isinstance(instance, str) or not re.fullmatch(r"[A-Za-z0-9_-]{1,64}", instance):
            return None
        if type(value.get("attention")) is not bool:
            return None
        keys = {"v", "id", "kind", "attention"}
        if value.get("kind") == "unknown" and set(value) == keys:
            return Snapshot(instance, None, value["attention"])
        if value.get("kind") != "usage" or set(value) != keys | {"tokens", "contextWindow"}:
            return None
        tokens, window = value["tokens"], value["contextWindow"]
        if type(tokens) not in (int, float) or type(window) not in (int, float):
            return None
        if not math.isfinite(tokens) or not math.isfinite(window) or tokens < 0 or window <= 0:
            return None
        return Snapshot(instance, Usage(tokens, window), value["attention"])
    except (ValueError, UnicodeError, OverflowError, RecursionError):
        return None


class Connection:
    def __init__(self, client):
        self.socket = client
        self.pending = bytearray()
        self.snapshot: Snapshot | None = None
        self.slot: int | None = None
        self.deadline = time.monotonic() + _LEASE_SECONDS
        self.received = False
        self.outgoing = b""
        self.next_reply = b""

    def receive(self):
        reads = frames = 0
        self.received = False
        while frames < _MAX_FRAMES:
            end = self.pending.find(b"\n")
            if end >= 0:
                snapshot = _snapshot(bytes(self.pending[:end]))
                if snapshot is None or (self.snapshot and snapshot.instance != self.snapshot.instance):
                    return False
                self.snapshot = snapshot
                self.deadline = time.monotonic() + _LEASE_SECONDS
                self.received = True
                del self.pending[:end + 1]
                frames += 1
                continue
            if len(self.pending) == _MAX_LINE:
                return False
            if reads == _MAX_READS:
                break
            try:
                chunk = self.socket.recv(_MAX_LINE - len(self.pending))
            except BlockingIOError:
                break
            except OSError:
                return False
            reads += 1
            if not chunk:
                return False
            self.pending.extend(chunk)
        return True

    def reply(self):
        self.next_reply = (json.dumps({"v": 1, "slot": self.slot}, separators=(",", ":")) + "\n").encode()

    def flush(self):
        # Never replace a partially sent frame. Coalesce only the next reply.
        if not self.outgoing:
            self.outgoing, self.next_reply = self.next_reply, b""
        if not self.outgoing:
            return True
        try:
            sent = self.socket.send(self.outgoing)
        except BlockingIOError:
            return True
        except OSError:
            return False
        if not sent:
            return False
        self.outgoing = self.outgoing[sent:]
        return True


class SnapshotReceiver:
    def __init__(self, path=None):
        runtime_dir = os.environ.get("XDG_RUNTIME_DIR")
        self._path = path if path is not None else os.environ.get("OMP_LED_SOCKET")
        if self._path is None and runtime_dir:
            self._path = os.path.join(runtime_dir, "led-matrix", "omp.sock")
        self._listener = None
        self._clients: list[Connection] = []
        # Includes disconnected slot owners until their lease expires.
        self._instances: dict[str, Connection] = {}
        self._inode = None
        self._started = False
        self._closed = False

    def _start(self):
        self._started = True
        if not self._path:
            return
        listener = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        try:
            listener.setblocking(False)
            listener.bind(self._path)
            info = os.lstat(self._path)
            self._inode = (info.st_dev, info.st_ino)
            os.chmod(self._path, 0o600)
            listener.listen(_MAX_CLIENTS)
            self._listener = listener
        except OSError:
            listener.close()
            self._unlink_owned()

    def _unlink_owned(self):
        if self._inode is None:
            return
        try:
            info = os.lstat(self._path)
            if stat.S_ISSOCK(info.st_mode) and (info.st_dev, info.st_ino) == self._inode:
                os.unlink(self._path)
        except OSError:
            pass
        self._inode = None

    def _drop(self, connection):
        connection.socket.close()
        self._clients.remove(connection)
        if connection.slot is None and connection.snapshot is not None:
            instance = connection.snapshot.instance
            if self._instances.get(instance) is connection:
                del self._instances[instance]

    def sample(self) -> tuple[Tile, ...]:
        if self._closed:
            return ()
        if not self._started:
            self._start()
        if self._listener is None:
            return ()
        now = time.monotonic()
        for instance, owner in list(self._instances.items()):
            if now >= owner.deadline:
                del self._instances[instance]
        for connection in self._clients[:]:
            if now >= connection.deadline:
                self._drop(connection)
        for _ in range(_MAX_CLIENTS):
            try:
                client, _address = self._listener.accept()
                client.setblocking(False)
            except BlockingIOError:
                break
            except OSError:
                break
            if len(self._clients) == _MAX_CLIENTS:
                client.close()
            else:
                self._clients.append(Connection(client))
        for connection in self._clients[:]:
            if not connection.receive():
                self._drop(connection)

        # A replacement connection takes over its own slot, never another ID's.
        for connection in self._clients[:]:
            if connection.snapshot is None:
                continue
            instance = connection.snapshot.instance
            previous = self._instances.get(instance)
            if previous is not None and previous is not connection:
                connection.slot = previous.slot
                if previous in self._clients:
                    self._drop(previous)
            self._instances[instance] = connection
        occupied = {c.slot for c in self._instances.values() if c.slot is not None}
        for connection in self._clients[:]:
            if connection.snapshot is None:
                continue
            if connection.slot is None:
                slot = next((slot for slot in range(1, 5) if slot not in occupied), None)
                if slot is not None:
                    connection.slot = slot
                    occupied.add(slot)
                    connection.reply()
            if connection.received:
                connection.reply()
            if not connection.flush():
                self._drop(connection)

        # A flood or partial frame affects only its publisher, not healthy tiles.
        readiness = select.poll()
        for connection in self._clients:
            readiness.register(connection.socket, select.POLLIN)
        unread = {fd for fd, _events in readiness.poll(0)}
        tiles = []
        for connection in self._clients:
            if connection.slot is None or connection.snapshot is None:
                continue
            fresh = not connection.pending and connection.socket.fileno() not in unread
            tiles.append(Tile(connection.slot, connection.snapshot.usage if fresh else None,
                              connection.snapshot.attention if fresh else False))
        return tuple(sorted(tiles))

    def close(self):
        self._closed = True
        for connection in self._clients[:]:
            self._drop(connection)
        self._instances.clear()
        if self._listener is not None:
            self._listener.close()
            self._listener = None
        self._unlink_owned()


def _rectangles(count):
    if count == 1:
        return ((0, 0, 9, 34),)
    if count == 2:
        return ((0, 0, 9, 17), (0, 16, 9, 34))
    if count == 3:
        return ((0, 0, 5, 17), (0, 16, 9, 34), (4, 0, 9, 17))
    if count == 4:
        return ((0, 0, 5, 17), (0, 16, 5, 34), (4, 0, 9, 17), (4, 16, 9, 34))
    return ()


def render(tiles, grid, brightness, border, now):
    grid.fill(0)
    rectangles = _rectangles(len(tiles))
    charging_level = round(brightness + 10 * math.sin(now / 3))
    for tile, (x0, y0, x1, y1) in zip(tiles, rectangles):
        grid[x0:x1, y0] = border
        grid[x0:x1, y1 - 1] = border
        grid[x0, y0:y1] = border
        grid[x1 - 1, y0:y1] = border
        if tile.usage is None:
            grid[x0 + 1:x1 - 1, y0 + 1] = brightness
        else:
            width = x1 - x0 - 2
            pixels = round(min(tile.usage.tokens / tile.usage.context_window, 1) * width * (y1 - y0 - 2))
            rows, remainder = divmod(pixels, width)
            if rows:
                grid[x0 + 1:x1 - 1, y1 - 1 - rows:y1 - 1] = brightness
            if remainder:
                grid[x0 + 1:x0 + 1 + remainder, y1 - 2 - rows] = brightness
        if len(tiles) == 1:
            continue
        x = x0 + (x1 - x0 - 3) // 2
        y = y0 + (y1 - y0 - 3) // 2
        for dot in range(tile.slot):
            dx, dy = (x + 1, y + 1) if tile.slot == 1 else (x + 2 * (dot % 2), y + 2 * (dot // 2))
            grid[dx, dy] = abs(grid[dx, dy] - charging_level)
    # Draw attention edges last; a steady neighbour must not erase a shared edge.
    pulse = round(border + (brightness - border) * (1 + math.cos(now * 2 * math.pi / 1.8)) / 2)
    for tile, (x0, y0, x1, y1) in zip(tiles, rectangles):
        if tile.attention:
            grid[x0:x1, y0] = pulse
            grid[x0:x1, y1 - 1] = pulse
            grid[x0, y0:y1] = pulse
            grid[x1 - 1, y0:y1] = pulse


_receiver = SnapshotReceiver()
atexit.register(_receiver.close)


def draw_context(arg, grid, foreground_value, idx, **kwargs):
    from led_mon.monitors import get_monitor_brightness
    border = max(0, min(255, int(get_monitor_brightness() * (35 - 12) + 12)))
    render(_receiver.sample(), grid, foreground_value, border, time.time())


app_funcs = [{"name": "omp-context", "fn": draw_context}]
direct_draw_funcs = {}
_id_grid = np.zeros((9, 34), dtype=int)
_id_grid[2:7, 8:25] = np.array([
        [0, 1, 1, 1, 0],
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
        [0, 1, 1, 1, 0],
        [0, 0, 0, 0, 0],
        [1, 0, 0, 0, 1],
        [1, 1, 0, 1, 1],
        [1, 0, 1, 0, 1],
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
        [0, 0, 0, 0, 0],
        [1, 1, 1, 1, 0],
        [1, 0, 0, 0, 1],
        [1, 1, 1, 1, 0],
        [1, 0, 0, 0, 0],
        [1, 0, 0, 0, 0],
    ], dtype=int).T
id_patterns = {"omp-context": _id_grid}
