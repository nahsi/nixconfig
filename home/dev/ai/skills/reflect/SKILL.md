---
name: reflect
description: Spawn three parallel review subagents over the active transcript, surface learnings, and route each to a concrete edit on an existing skill. Use when the user says reflect.
disable-model-invocation: true
---

# Reflect

Mine the current conversation for durable learnings, then route them into skill edits.

## When to invoke

- The user said "reflect" or "/skill:reflect".
- A complex task (5+ tool calls) just landed cleanly and the recipe is worth keeping.
- The agent hit dead ends, found the working path, and the path generalizes.
- The user corrected the agent's approach mid-task.
- A non-trivial workflow emerged that isn't captured anywhere.

Skip when the conversation is trivial, off-topic, or already covered by an existing skill the parent followed correctly. One-offs are not learnings.

## Process

### 1. Locate the active transcript

The parent finds its own OMP transcript before fanning out. Sessions live under `~/.omp/agent/sessions/<encoded-cwd>/`, with top-level files named `<timestamp>_<sessionId>.jsonl` and subagent transcripts stored in the parent session's artifact directory. Stay within the active workspace bucket.

Order candidates by modification time. Read the physical title slot, session header, and opening user message. Match the header `cwd` and the conversation's opening prompt. Take the matching path. If no path resolves, write a tight digest of the session and pass that instead.

### 2. Spawn three reviewers in parallel

Use one OMP `task` batch with three read-only review items. Set `agent: reviewer` on every item, name the corresponding reference below as the parent-supplied method and lens, and state that the reference's numbered-list contract controls the result format. Forbid writes and subdelegation; the coordinator owns synthesis and edits.

| Lens | Profile | Assigned method and lens |
|---|---|---|
| Judgment | `reviewer` | `skill://reflect/references/judgment-reviewer.md` |
| Tooling | `reviewer` | `skill://reflect/references/tooling-reviewer.md` |
| Divergent | `reviewer` | `skill://reflect/references/divergent-reviewer.md` |

These are independent lenses using the same configured reviewer profile. The lens reference is the only intended difference; model routing stays in profile configuration.

Pass each reference verbatim, substituting the transcript path or digest where marked. Reviewers return findings through their native task results and `agent://` artifacts.

### 3. Synthesize

The coordinator reads all three full results and applies `skill://reflect/references/synthesizer.md` directly, substituting the reviewer outputs where marked. Do not spawn a fourth worker merely to combine results: disposition and routing remain coordinator decisions. Preserve the reference's structured Accepted / Rejected / Backlog output.

### 4. Structural enforcement check

Sanity-check the Accepted list. For any item that would be enforced more reliably by a lint rule, script, metadata flag, or runtime check, move it from Accepted to Backlog. The synthesis reference already applies this criterion; this is a final pass before edits land.

### 5. Apply

Before applying any Accepted edit, present the full Accepted/Rejected/Backlog output to the user and wait for explicit approval. The user picks which subset to apply and may redirect routings. Skill changes affect every future agent in the org; do not auto-apply.

Backlog rows remain proposals until the user explicitly approves filing them to a devex or backlog tracker. Tracker submissions are external writes, so never file them implicitly.

For each approved Accepted item, follow the Routing field exactly:

- Trivial existing-skill edit (a one-line bullet, a tightened sentence, a stale fact corrected): parent does directly.
- Substantive existing-skill edit (a new section, a new pattern table, more than ~10 lines): read and apply `skill://create-skill`.
- `tune description: <skill path>`: use `skill://create-skill` for its description review.
- `new skill via create-skill: <kebab-name>`: author it through `skill://create-skill`. Do not invent the shape ad hoc.

If your environment ships a SKILL.md validator, run it on every touched skill before declaring done. Skip this step if it doesn't.

### 6. Summarize for the user

Short list, no preamble:

- Edits applied: `<skill path>`. What changed, one line each.
- New skills created: `<skill path>`. One line each (rare).
- Backlog: `<issue title>` (`<tags>`), marked as filed only when the user approved the tracker submission.
- Dropped: one line per rejected finding + reason from the synthesizer.
