# OMP Task and Hub Contract

This reference records the Oh My Pi runtime semantics that preserve PrimeStack orchestration behavior.

## Runtime model

- A `task` call admits its `tasks` array and returns job identities. It does not wait for or return the children's answers.
- Results auto-deliver when jobs settle and remain available through `agent://<id>`. Tell children whose answers matter to finish with a concise terminal result.
- A task item `name` is the unique per-run identity. Its `agent` field selects a reusable configured profile; profile IDs and run names are separate.
- Each profile's capabilities and model are defined in OMP/Nix configuration. Skills and task briefs select the profile, never a provider model literal; OMP has no per-call model selector.
- When `task.enableEffort` is enabled **and** the live task-item schema exposes effort, use `lo`, `med`, or `hi`. Otherwise omit effort so the profile default remains in force.
- Effort hints select the model's lowest, middle, or highest supported level, subject to `task.maxEffort`; `hi` can resolve to `max`, not literal `high`. After configuration changes, reload or start a session with the updated tool schema before sending the field.
- Native todo and session state persist through normal continuation/checkpoint behavior. Record job IDs, run metadata, and artifact URIs there instead of inventing a kernel ledger or compaction API.
- `hub list` and `hub jobs` provide bounded peer/job state. `agent://<id>` holds the terminal result and `history://<id>` holds the transcript.
- OMP exposes job cancellation but no Prime-equivalent child-deletion lifecycle call. Cancellation is not cleanup. Finish pending replies and follow-ups, preserve needed references, and let OMP park or release settled sessions.

The authoritative role/tier selection table lives in `skill://prime-delegate`. Runtime profiles provide capabilities and configured model tiers; they do not select a method or imply that every role must participate.

## Messaging topology

Use `hub` with exact roster IDs:

- parent → existing child: `hub send` to the child's exact peer ID;
- child → parent: `hub send` to the parent's exact peer ID supplied in the delegation context; direct children of the root use `Main`;
- peers may coordinate only within the authority in their briefs;
- if subdelegation was explicitly granted, the authorized child owns descendant relay and cleanup and reports both to its parent.

`hub send` is fire-and-forget unless the sender explicitly waits for a reply. A delivery receipt is not the recipient's answer. Prime's direct-family messaging topology has no exact OMP equivalent; do not treat hub reachability as authority or silently broaden a delegation budget.

## Observation

Use bounded `hub list` or `hub jobs` snapshots for status. `history://<id>` is read-only evidence for focused follow-up, failure diagnosis, or a missing decision. Ask the user before using observed transcript content to steer another session. Normal results arrive through automatic delivery and `agent://<id>`, not transcript scraping.

## Recommended child prompt fields

```text
Run name: <unique task-item name>
Profile: <configured agent profile>
Method: <skill/reference URI, direct procedure, or explicit evaluation baseline>
Goal: <one outcome and acceptance check>
Inputs: <paths, refs, facts>
Working directory: <path>
Scope: read-only | owns <disjoint paths>
Authority: <allowed>; no merge/deploy/publish/destructive actions
Evidence: <commands, file/line refs, primary sources>
Output: <short schema>; write large detail to <unique URI/path>
Validation owner: <child checks>; <parent integration checks>
Completion: terminal result with summary, evidence, paths, blockers
Subdelegation: forbidden | task-only explicit budget, relay contract, descendant cleanup duty
```

Prompt-level read-only instructions and isolated worktrees are not security sandboxes. Inspect the selected profile's actual capabilities and keep the same authority limits in the brief.

While a worker is active, the parent stays outside that delegated scope: it does not investigate, edit, or validate the same work until the terminal result returns ownership.

## Coordinator state

For non-trivial runs, keep a small native todo/session record rather than rereading transcripts:

```yaml
goal: "..."
mode: fan-out
children: []
artifacts: {}
accepted_findings: []
verification: []
```

Track each child through `planned → admitted → delivered → parent-verified → settled`, with `blocked` or `dropped` as disclosed work outcomes. A follow-up returns the child to active work until a new terminal report arrives. OMP session parking/release is runtime lifecycle, not a documented cancellation or timeout primitive.

Use a compact report schema for larger runs: `run_id`, `PASS | ISSUES | BLOCKED`, artifact paths, evidence/checks, findings or decision, gaps, and requested follow-up.

At a natural high-context boundary, rely on OMP's native continuation/checkpoint behavior. If a separate handoff is required, preserve the run goal, child IDs, artifact URIs, accepted findings, remaining verification, and descendant cleanup obligations in one compact `local://` artifact.

## Failure handling

- Admission failure: narrow the task, fix the invalid name/profile, or proceed in the coordinator.
- Missing reply: inspect bounded peer/job status, send one direct follow-up to the existing child if appropriate, then proceed serially or disclose the blocked/dropped lens.
- Child error: preserve its evidence, mark the slice blocked, and apply `skill://prime-delegate`'s evidenced escalation rule; never retry automatically.
- Conflicting answers: verify the disputed fact directly or assign a fresh read-only judge with both claims and the original evidence standard.
- Partial fan-out: synthesize completed coverage and name the missing lens.
