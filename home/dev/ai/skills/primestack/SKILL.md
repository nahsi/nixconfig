---
name: primestack
description: Route broad, risky, multi-stage, or long-running engineering through PrimeStack shaping, local slices, OMP task delegation, delivery, review, and proof. Use as the coordinator for compound work; bypass it for a single already-shaped leaf task or obvious local edit.
license: MIT
compatibility: Oh My Pi with task agents, hub coordination, skill resources, and native session continuation.
---

# PrimeStack

Go deep before going wide. Produce less code, stronger structure, explicit evidence, and reviewable progress. PrimeStack is a task-level workflow policy, not a daemon mode and not permission to take external or irreversible actions.

## Entry gate

Use PrimeStack for broad, risky, ambiguous, multi-stage, cross-surface, or long-running work. Bypass it for a trivial lookup or obvious local edit; apply only the relevant leaf skill and verify normally.

On activation:

1. Restate the outcome and non-goals.
2. Identify authority boundaries: files/state, secrets, external services, cost, merge/deploy/publish/destructive actions.
3. Classify the task and read one primary playbook.
4. Keep a compact phase ledger in the native todo list and session artifacts.
5. Delegate only independent/context-heavy work; the root owns synthesis and final proof.

## Route

| Task | Playbook |
|---|---|
| New or changed behavior | [feature](playbooks/feature.md) |
| Bug, regression, flake, incident, performance | [bug](playbooks/bug.md) |
| Behavior-preserving redesign/migration | [refactor](playbooks/refactor.md) |
| Read-only “how/why/impact” | [investigation](playbooks/investigation.md) |
| Empirical design fork | [prototype](playbooks/prototype.md) |
| Existing artifact needs judgment or release readiness | [review-and-ship](playbooks/review-and-ship.md) |
| Plan must become local worker-ready slices | [verticalized-delivery](playbooks/verticalized-delivery.md) |
| Work must pause, compact, or resume | [pause-resume](playbooks/pause-resume.md) |

When several match, pick the playbook for the current uncertainty. A feature with an unresolved product decision starts in shaping. A feature with a reproduced bug starts in repair.

## Leaf skills

- [`shape-work`](skill://shape-work) — outcome, domain language, scope, decisions, risk, proof level.
- [`context-map`](skill://context-map) — how/why/impact evidence before change.
- [`verticalize-work`](skill://verticalize-work) — tracker-neutral local slices and dependency waves.
- [`implement`](skill://implement) — ordinary incremental non-TDD implementation and integration.
- [`prime-delegate`](skill://prime-delegate) — OMP task fan-out, arena, review panel, or pipeline.
- [`proof-repair`](skill://proof-repair) — exact repro, minimized failure, root cause, minimal fix.
- [`tdd`](skill://tdd) — behavior through a stable public seam.
- [`architect-work`](skill://architect-work) — modules/types/interfaces, alternatives, migration, deletion.
- [`prototype`](skill://prototype) — disposable artifact that buys one decision.
- [`contract-review`](skill://contract-review) — spec, standards, safety, blast radius, and proof.

Read the installed sibling through its `skill://` URI when the router must transition explicitly; never invent a wrapper API.

## Principles

1. **Outcome over throughput.** Optimize for the observable goal, not LOC or worker count.
2. **Inspect before inventing.** Read local code, tests, docs, and conventions first.
3. **Shape the domain.** Put invariants in types, structures, and ownership.
4. **Subtract before adding.** Delete dead weight, compatibility residue, and duplicate validation.
5. **Guard boundaries.** Validate external input and keep the trusted core simple.
6. **Fix causes.** Reproduce and trace before patching symptoms.
7. **Sequence proof.** Every unit ends useful, integrated, and green.
8. **Separate shared state.** Do not parallelize conflicting writes; isolate ownership first.
9. **Guard coordinator context.** Put bulk exploration in children/artifacts; retain decisions and evidence.
10. **Prove the real artifact.** Tests are necessary evidence, not a substitute for the user surface.
11. **Encode repeated lessons structurally.** Prefer a test, lint, type, script, or existing skill edit over another reminder.

## OMP-native orchestration

Before using `task`, read [`prime-delegate`](skill://prime-delegate). Remember:

- task admission returns job identities, never an answer;
- results auto-deliver and remain available through `agent://<id>`;
- continue available coordinator work after admitting independent children instead of polling;
- use exact peer IDs with `hub`; use `history://<id>` only for bounded diagnosis or follow-up;
- prompt-only “read-only” instructions and isolated worktrees are policy/isolation mechanisms, not security sandboxes;
- the root validates child claims and owns integration;
- complete replies and follow-ups before treating child work as finished; OMP owns agent parking and release rather than exposing Prime's child-deletion API.

If task agents are unavailable or provide no useful independence, execute serially and disclose the lost coverage—not a fake parallel run.

## Phase ledger

Track only control state in the native todo list and, when a durable handoff is needed, one compact session artifact:

```yaml
outcome: "..."
playbook: feature
phase: shape
authority: []
artifacts: []
children: []
verification: []
open_gaps: []
```

At a natural high-context boundary, rely on OMP's native continuation/checkpoint behavior. If an explicit handoff is needed, preserve the ledger, child IDs, artifact paths, decisions, remaining proof, and cleanup obligations in a compact `local://` artifact.

## Completion contract

Do not declare done until:

- the requested outcome exists on the real artifact/surface;
- acceptance criteria and non-goals were checked;
- load-bearing verification was actually run and reported;
- child work was synthesized and independently checked;
- shared-state integration, blast radius, and residual risk were reviewed;
- temporary probes/worktrees/artifacts and direct children were handled intentionally;
- external actions taken match explicit user authority.

If a browser, device, credential, environment, or other real-surface tool is unavailable, name the verification gap and provide the smallest manual handoff; never imply the surface was tested.

Report: `Outcome`, `Changed`, `Evidence`, `Review`, `Residual risk`, and `Next step` only when one is genuinely needed.
