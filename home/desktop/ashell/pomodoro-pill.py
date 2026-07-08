"""Feed ashell's Pomodoro module: tomat's timer JSON + the active task name."""
import json
import subprocess
import time

TRUNCATE = 25


def active_desc():
    out = subprocess.run(
        ["task", "+ACTIVE", "export"], capture_output=True, text=True
    ).stdout
    tasks = json.loads(out or "[]")
    if not tasks:
        return ""
    desc = max(tasks, key=lambda t: t.get("start", ""))["description"]
    return desc[: TRUNCATE - 1] + "…" if len(desc) > TRUNCATE else desc


def run():
    proc = subprocess.Popen(["tomat", "watch"], stdout=subprocess.PIPE, text=True)
    for line in iter(proc.stdout.readline, ""):
        state = json.loads(line)
        desc = active_desc()
        text = f"{desc} · {state['text']}" if desc else state["text"]
        print(json.dumps({"text": text, "alt": state["class"]}), flush=True)
    proc.wait()


while True:  # daemon restart → watch exits → reconnect
    run()
    time.sleep(1)
