---
name: omp-mechanics
description: The omp-specific levers for every pstack skill. Read it after `skill://poteto-mode`, and again whenever a pstack skill or playbook tells you to spawn a subagent, pick a model, drive a surface, or wake yourself later. Every entry names the upstream step it amends and the omp instruction that replaces or extends it.
disable-model-invocation: true
---

# omp mechanics

pstack's skills are mirrored from Cursor and their mechanics are rewritten for omp by
`omp-port/rules.sed`. That rewrite is a token substitution, so anything omp does differently in
kind rather than in name lands here instead. Each section names a skill or playbook and amends a
numbered step.

The port preserves its runtime adapters through `omp-port/owned.txt`. Read
`skill://pstack-omp` before dispatch; its live-tool contract overrides task-specific examples here and in imported references. These examples apply only when the corresponding surface is exposed, not to vibe workers.

## Reading skills

The system's skill list shows model-discoverable skills, not the complete installation.
Skills with `disable-model-invocation: true` remain readable through explicit
`skill://<name>` references. Read a referenced skill before declaring it unavailable;
absence from the displayed list is not a failed lookup.

## Coordination

Use `skill://pstack-omp` for dispatch. Never block inside an agent that still owes its parent a turn.
Run verification checks to completion and inspect their results. Non-zero exit is a fail.

## architect, arena, interrogate, reflect

These workflows need independent contexts and benefit from different model priors. Resolve roles
through `skill://pstack-omp`; never require extra agent files or operator configuration changes.
Use configured model diversity when available and record resolved-model/fallback evidence.
When only one family is available, keep the independent participant count and report weaker
model diversity. When independent execution itself is unavailable, report the blocked gate.
- [**arena**](skill://arena) Phase C and [**interrogate**](skill://interrogate): the judge's and reviewers' read-only grant is posture, not a sandbox.
- [**reflect**](skill://reflect) step 3: prefer a different model family for Divergent and Judgment when configured.
  Otherwise keep independent contexts and report the missing model diversity.
- [**interrogate**](skill://interrogate) step 2: Reviewer A with no override entry runs on the parent chat model, which is
  the case where the family spread collapses first.
- A retry can move a slot off the model its entry named, because `retry.fallbackChains` is keyed by
  the same role names and an aliased spawn inherits that role's chain instead of `default`. Record
  the model each arm actually ran on. `task.showResolvedModelBadge` prints it in the task widget.

## bug-fix

Amends step 2. Before reaching for runtime evidence, narrow the suspect set statically with `lsp`
action `definition` for where a value is set and `lsp` action `references` for every caller of a
suspect function. `task.enableLsp` is off by default, so a delegated worker has no `lsp` tool at
all and this narrowing is the parent's job unless that setting is on.

When program state is unclear the `debug` tool is the first instrument, ahead of bespoke logging.
With `debug.enabled` on, launch the reproducing path with action `launch`, drop a `set_breakpoint`
on the suspect line, drive it with `step_over` and `step_in`, and read exact state with `evaluate`.
Fall back to logging only when the tool is off or the runtime has no adapter.

## feature

Amends step 5. Run the typecheck and lint lane with `lsp` action `diagnostics` alongside the test
lane, and require the new code clean before the surface check. `file` set to `"*"` is not a
whole-workspace sweep. It runs one external checker for the first project type it matches, in the
order Rust, TypeScript, Go, Python, caps its output at the first 50 lines, and spawns nothing at all
for a project type it does not recognise. So name concrete files or a glob when the change spans
languages, and cap a glob at 20 files. A server failure is softened rather than fatal, so a clean
result means nothing was reported and not that nothing is wrong. Confirm a server is live with
action `status` before treating clean as proof. With `lsp.enabled` off, fall back to the project's
own typecheck and lint commands.

## refactoring

Amends step 5. A text rename silently misses callsites, so the language server is the guard and not
an eyeball spot-check. With `lsp.enabled` on, take the migrate-every-caller inventory from `lsp`
action `references` and apply each rename with action `rename`, which builds and applies a real
`WorkspaceEdit`. For a module move use action `rename_file`, which rewrites every import across
files. Both actions apply by default, so pass `apply: false` to preview one. Run action
`diagnostics` over the touched files afterwards, naming them rather than `"*"`. Then grep string
literals, prose, and back-references by hand, which a symbol rename never touches. With the tool
off, or in a worker spawned while `task.enableLsp` is false, a project-wide grep of the symbol name
is the whole guard.

## typescript-best-practices

omp carries `globs` as skill metadata and does not auto-attach a skill on a file match. Read
`skill://typescript-best-practices` yourself when you touch a `.ts` or `.tsx` file.

## recall, reflect, eval, session-pickup, show-me-your-work

All five read the session store. `references/session-store-on-omp.md` holds the layout. Four facts
decide whether a glob finds anything.

- The root is resolved, not fixed. It defaults to `~/.omp/agent/sessions/`, and a named profile,
  `PI_CODING_AGENT_DIR`, or `XDG_DATA_HOME` can move it. Resolve it before globbing.
- The bucket is the canonicalized cwd with each `/` rewritten to `-`, which leaves a leading
  hyphen for a path under `$HOME`, so `~/Desktop/proj` is the directory `-Desktop-proj`. Stay
  inside your own bucket. Globbing sibling buckets reads private sessions from unrelated projects.
- A transcript's first line is a fixed-width `type:title` slot and not a message, and persisted
  roles are camelCase, so the spelling is `toolResult` rather than `tool_result`.
- For an agent in this process, skip the glob. Bare `history://` lists every agent with its status
  and its parent, `history://<id>:1-50` pages one transcript, and `agent://<id>` serves that
  agent's final output.

## Upstream text that does not apply here

These stay as upstream wrote them, because the port has nothing to substitute.

- [**poteto-mode**](skill://poteto-mode) routers and **babysit** step 0 warn against Cursor's built-in `babysit` skill.
  omp ships no such skill, so the warning is inert and the playbook is the only route anyway.
- **bugbot-triage** rates Bugbot, which is Cursor's hosted review product. On a repository without
  it, apply the rubric to whatever review bot posts on your PRs, omp's own `security-reviewer`
  included.
- **worktree-cleanup** step 6 lists `~/Library/Application Support/Cursor` among macOS reclaimers.
  There is no omp equivalent worth pruning, and the rest of that step is Xcode and package caches.
