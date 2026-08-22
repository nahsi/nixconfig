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

Use one OMP `task` batch with three review items. The prompt forbids writes; the parent applies edits.

| Lens | OMP agent | Prompt template |
|---|---|---|
| Judgment | `task` | `skill://reflect/references/judgment-reviewer.md` |
| Tooling | `task` | `skill://reflect/references/tooling-reviewer.md` |
| Divergent | `task` | `skill://reflect/references/divergent-reviewer.md` |

These are independent review contexts using the configured `task` role, not model-diverse reviewers.

Pass each template verbatim, substituting the transcript path or digest where marked. Reviewers return findings through their `task` results and `agent://` artifacts.

### 3. Synthesize

Spawn one OMP `task` item for synthesis. Use `skill://reflect/references/synthesizer.md` verbatim, with each reviewer's full output inlined where marked. The synthesizer returns a structured Accepted / Rejected / Backlog list.

### 4. Structural enforcement check

Sanity-check the synthesizer's Accepted list. For any item that would be enforced more reliably by a lint rule, script, metadata flag, or runtime check, move it from Accepted to Backlog. The synthesizer already applies this criterion; this is a final pass before edits land. See the **encode-lessons-in-structure** principle skill.

### 5. Apply

Before applying any Accepted edit, present the synthesizer's full Accepted/Rejected/Backlog output to the user and wait for explicit approval. The user picks which subset to apply and may redirect routings. Skill changes affect every future agent in the org; do not auto-apply.

Backlog items file to whatever devex / backlog tracker your team uses automatically. Those are tracker submissions, not skill edits. Only the Accepted list waits for approval.

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
- Backlog filed to the devex tracker: `<issue title>` (`<tags>`). One line each.
- Dropped: one line per rejected finding + reason from the synthesizer.
