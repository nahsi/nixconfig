import { expect, test } from "bun:test";
import potetomode from "./index.js";

const entry = (pinned) => ({ type: "custom", customType: "poteto-mode", data: { pinned } });
function host(flag = true) {
  const events = new Map();
  let command, shortcut, entries = [], badge;
  const ctx = {
    sessionManager: { getBranch: () => entries },
    ui: {
      setModeBadge: (_key, value) => { badge = value; },
      notify() {},
    },
  };
  potetomode({
    registerCommand: (_name, value) => { command = value.handler; },
    registerFlag() {},
    registerShortcut: (_name, value) => { shortcut = value.handler; },
    on: (name, handler) => events.set(name, handler),
    getFlag: () => flag,
    appendEntry: (_name, data) => entries.push(entry(data.pinned)),
    sendUserMessage() {},
  });
  return {
    start: async (branch = []) => { entries = branch; await events.get("session_start")({}, ctx); },
    before: (systemPrompt = ["original"]) => events.get("before_agent_start")({ systemPrompt }),
    command: (args) => command(args, ctx),
    shortcut: () => shortcut(ctx),
    badge: () => badge,
    lifecycle: async (name) => events.get(name)?.({}, ctx),
  };
}

test("persisted explicit off survives a restart with --poteto", async () => {
  const session = host();
  await session.start([entry(false)]);
  expect(await session.before()).toBeUndefined();
});

test("--poteto still enables a session without a saved override", async () => {
  const session = host();
  await session.start();
  expect(await session.before()).toBeDefined();
});

test("malformed stored booleans never activate the pin", async () => {
  const session = host();
  for (const pinned of ["false", 1, null, undefined]) {
    await session.start([entry(pinned)]);
    expect(await session.before()).toBeUndefined();
  }
});

test("latest entry wins and a new session resets the previous override", async () => {
  const session = host();
  await session.start([entry(true), entry(false)]);
  expect(await session.before()).toBeUndefined();
  await session.start();
  expect(await session.before()).toBeDefined();
  await session.start([entry(false), entry(true)]);
  expect(await session.before()).toBeDefined();
});

test("shortcut, badge, command and injection share one effective state", async () => {
  const session = host();
  await session.start();
  await session.command("status");
  expect(session.badge()).toBe("🥔");
  session.shortcut();
  expect(session.badge()).toBeUndefined();
  expect(await session.before()).toBeUndefined();
  await session.command("on");
  expect(session.badge()).toBe("🥔");
  expect(await session.before()).toBeDefined();
  await session.command("off");
  expect(session.badge()).toBeUndefined();
  expect(await session.before()).toBeUndefined();
});

test("the badge stays stable across agent lifecycle transitions", async () => {
  const session = host();
  await session.start();
  await session.lifecycle("agent_start");
  expect(session.badge()).toBe("🥔");
  await session.lifecycle("agent_end");
  expect(session.badge()).toBe("🥔");
});

test("prompt block boundaries and input blocks remain intact", async () => {
  const session = host();
  await session.start();
  const blocks = ["first", "second"];
  const result = await session.before(blocks);
  expect(result.systemPrompt.slice(0, 2)).toEqual(blocks);
  expect(blocks).toEqual(["first", "second"]);
  expect(result.systemPrompt).toHaveLength(3);
});
