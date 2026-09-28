"""Consumer-visible protocol and display invariants; no hardware or daemon needed."""
import json
import socket
import tempfile
import unittest
from unittest.mock import patch

import numpy as np
import omp_context_plugin as led


class ReceiverTests(unittest.TestCase):
    def setUp(self):
        self.directory = tempfile.TemporaryDirectory()
        self.now = 0
        self.clock = patch.object(led.time, "monotonic", lambda: self.now)
        self.clock.start()
        self.receiver = led.SnapshotReceiver(self.directory.name + "/s")
        self.receiver.sample()
        self.peers = []

    def tearDown(self):
        for peer in self.peers:
            peer.close()
        self.receiver.close()
        self.clock.stop()
        self.directory.cleanup()

    def connect(self, identity, tokens=25):
        peer = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        peer.settimeout(1)
        peer.connect(self.directory.name + "/s")
        self.peers.append(peer)
        self.send(peer, identity, tokens)
        self.receiver.sample()
        return peer, json.loads(peer.recv(256))["slot"]

    def send(self, peer, identity, tokens=25):
        peer.sendall((json.dumps(dict(v=1, id=identity, kind="usage", tokens=tokens,
                                      contextWindow=100, attention=False)) + "\n").encode())

    def test_overflow_waits_and_reconnect_preserves_reserved_slot(self):
        peers = [self.connect(str(n)) for n in range(5)]
        self.assertEqual([slot for _, slot in peers], [1, 2, 3, 4, None])
        peers[1][0].close()
        self.assertEqual([t.slot for t in self.receiver.sample()], [1, 3, 4])
        replacement, slot = self.connect("1", 60)
        self.assertEqual(slot, 2)
        self.assertEqual(next(t.usage.tokens for t in self.receiver.sample() if t.slot == 2), 60)
        replacement.close()
        self.receiver.sample()
        self.now = 2.9
        for n in (0, 2, 3, 4):
            self.send(peers[n][0], str(n))
        self.receiver.sample()
        self.now = 3.1
        tiles = self.receiver.sample()
        self.assertEqual([t.slot for t in tiles], [1, 2, 3, 4])
        replies = [json.loads(line) for line in peers[4][0].recv(256).splitlines()]
        self.assertEqual(replies[-1]["slot"], 2)

    def test_replacement_socket_cannot_create_duplicate_tile(self):
        self.connect("same", 10)
        self.connect("other", 20)
        replacement, slot = self.connect("same", 90)
        self.assertEqual(slot, 1)
        self.assertEqual([(t.slot, t.usage.tokens) for t in self.receiver.sample()], [(1, 90), (2, 20)])
        self.send(replacement, "changed-id")
        self.assertEqual([t.slot for t in self.receiver.sample()], [2])

    def test_bad_peer_does_not_blank_healthy_instance(self):
        good, _ = self.connect("good", 40)
        bad, _ = self.connect("bad")
        bad.sendall(b'{"v":1,"id":"bad","kind":"usage","tokens":-1,"contextWindow":100,"attention":false}\n')
        self.assertEqual(self.receiver.sample(), (led.Tile(1, led.Usage(40, 100), False),))
        self.send(good, "good", 45)
        self.assertEqual(self.receiver.sample()[0].usage.tokens, 45)

    def test_partial_frame_is_unknown_only_for_its_owner(self):
        first, _ = self.connect("first", 40)
        self.connect("second", 60)
        first.sendall(b'{"v":1,"id":"first",')
        tiles = self.receiver.sample()
        self.assertIsNone(tiles[0].usage)
        self.assertEqual(tiles[1].usage.tokens, 60)
        first.sendall(b'"kind":"usage","tokens":80,"contextWindow":100,"attention":true}\n')
        tiles = self.receiver.sample()
        self.assertEqual(tiles[0], led.Tile(1, led.Usage(80, 100), True))

    def test_queued_or_partial_bytes_cannot_revive_expired_lease(self):
        peer, _ = self.connect("frozen")
        self.now = 2.9
        peer.sendall(b'{"v":1,')
        self.receiver.sample()
        self.now = 3.1
        peer.sendall(b'"id":"frozen","kind":"unknown","attention":false}\n')
        self.assertEqual(self.receiver.sample(), ())

    def test_invalid_measurements_are_rejected_at_boundary(self):
        for tokens, window in ((True, 100), (-1, 100), (1, 0), (float("nan"), 100), (1, float("inf"))):
            with self.subTest(tokens=tokens, window=window):
                value = dict(v=1, id="x", kind="usage", tokens=tokens, contextWindow=window, attention=False)
                self.assertIsNone(led._snapshot(json.dumps(value).encode()))


class RenderingTests(unittest.TestCase):
    def test_pixel_fill_rolls_over_rows_in_every_layout(self):
        grid = np.zeros((9, 34), dtype=int)
        for count, width, height in ((1, 7, 32), (2, 7, 15), (3, 3, 15), (4, 3, 15)):
            tiles = tuple(led.Tile(slot, led.Usage(0, 100), False)
                          for slot in range(1, count + 1))
            led.render(tiles, grid, 24, 12, 0)
            identity = grid[1:1 + width, 1:1 + height] == 24
            capacity = width * height
            for pixels in (0, 1, width - 1, width, width + 1, capacity, capacity + 1, 1):
                with self.subTest(count=count, pixels=pixels):
                    first = tiles[0]._replace(usage=led.Usage(pixels, capacity))
                    led.render((first, *tiles[1:]), grid, 24, 12, 0)
                    expected = np.zeros((width, height), dtype=int)
                    positions = [(x, y) for y in reversed(range(height)) for x in range(width)]
                    for x, y in positions[:min(pixels, capacity)]:
                        expected[x, y] = 24
                    expected[identity] = 24 - expected[identity]
                    np.testing.assert_array_equal(grid[1:1 + width, 1:1 + height], expected)
                    self.assertTrue((grid[0, :] == 12).all())
                    self.assertTrue((grid[:, 0] == 12).all())

    def test_unknown_dash_is_not_an_empty_usage_bar(self):
        unknown = np.zeros((9, 34), dtype=int)
        empty = unknown.copy()
        led.render((led.Tile(1, None, False),), unknown, 24, 12, 0)
        led.render((led.Tile(1, led.Usage(0, 100), False),), empty, 24, 12, 0)
        self.assertTrue((unknown[1:8, 1] == 24).all())
        self.assertTrue((empty[1:8, 1] == 0).all())
        self.assertTrue(np.array_equal(unknown[:, 2:], empty[:, 2:]))

    def test_identity_uses_slot_not_tile_position(self):
        grid = np.zeros((9, 34), dtype=int)
        led.render((led.Tile(2, led.Usage(0, 100), False),
                    led.Tile(4, led.Usage(0, 100), False)), grid, 24, 12, 0)
        self.assertEqual(np.argwhere(grid[1:8, 17:33] == 24).tolist(),
                         [[2, 6], [2, 8], [4, 6], [4, 8]])

    def test_single_tile_has_unobstructed_fill_after_multiple_tiles(self):
        grid = np.zeros((9, 34), dtype=int)
        led.render((led.Tile(1, led.Usage(0, 100), False),
                    led.Tile(4, led.Usage(50, 100), False)), grid, 24, 12, 0)
        for slot in (1, 4):
            for tokens in (0, 50, 100):
                with self.subTest(slot=slot, tokens=tokens):
                    led.render((led.Tile(slot, led.Usage(tokens, 100), False),),
                               grid, 24, 12, 0)
                    expected = np.zeros((7, 32), dtype=int)
                    rows = round(tokens / 100 * 32)
                    if rows:
                        expected[:, -rows:] = 24
                    np.testing.assert_array_equal(grid[1:8, 1:33], expected)

    def test_attention_changes_only_selected_outline_including_shared_edge(self):
        base = (led.Tile(1, led.Usage(0, 100), False), led.Tile(2, led.Usage(50, 100), False),
                led.Tile(3, led.Usage(75, 100), False))
        normal = np.zeros((9, 34), dtype=int)
        attention = normal.copy()
        led.render(base, normal, 24, 12, 0)
        led.render((base[0], base[1]._replace(attention=True), base[2]), attention, 24, 12, 0)
        outline = np.zeros_like(normal, dtype=bool)
        outline[:, 16] = outline[:, 33] = True
        outline[0, 16:] = outline[8, 16:] = True
        self.assertTrue((attention[outline] == 24).all())
        self.assertTrue(np.array_equal(attention[~outline], normal[~outline]))


if __name__ == "__main__":
    unittest.main()
