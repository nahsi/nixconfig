---
name: primestack
description: Route broad, risky, multi-stage, or long-running engineering through shaping, local slices, delegation, delivery, review, and proof. Use as the coordinator for compound work; bypass it for a single already-shaped leaf task or obvious local edit.
disable-model-invocation: true
license: MIT
---

# PrimeStack

Go deep before going wide. Produce less code, stronger structure, explicit evidence, and reviewable progress. PrimeStack is a task-level workflow policy, not a daemon mode and not permission to take external or irreversible actions.

## Entry gate

Use PrimeStack for broad, risky, ambiguous, multi-stage, cross-surface, or long-running work. Bypass it for a trivial lookup or obvious local edit; apply only the relevant leaf skill and verify normally.

On activation:

1. Restate the outcome and non-goals.
2. Identify authority boundaries: files/state, secrets, external services, cost, merge/deploy/publish/destructive actions.
3. Classify the task and read one primary playbook.
4. Delegate only independent/context-heavy work; the root owns synthesis and final proof.

## Route

| Task | Playbook |
|---|---|
| New or changed behavior | [feature](skill://primestack/playbooks/feature.md) |
| Bug, regression, flake, incident, performance | [bug](skill://primestack/playbooks/bug.md) |
| Behavior-preserving redesign/migration | [refactor](skill://primestack/playbooks/refactor.md) |
| Read-only “how/why/impact” | [investigation](skill://primestack/playbooks/investigation.md) |
| Empirical design fork | [prototype](skill://primestack/playbooks/prototype.md) |
| Existing artifact needs judgment or release readiness | [review-and-ship](skill://primestack/playbooks/review-and-ship.md) |
| Plan must become local worker-ready slices | [verticalized-delivery](skill://primestack/playbooks/verticalized-delivery.md) |
| Work must pause, compact, or resume | [pause-resume](skill://primestack/playbooks/pause-resume.md) |

When several match, pick the playbook for the current uncertainty. A feature with an unresolved product decision starts in shaping; a feature with a reproduced bug starts in repair.

## Leaf skills

- [shape-work](skill://shape-work) — outcome, domain language, scope, decisions, risk, proof level.
- [context-map](skill://context-map) — how/why/impact evidence before change.
- [verticalize-work](skill://verticalize-work) — tracker-neutral local slices and dependency waves.
- [implement](skill://implement) — ordinary incremental non-TDD implementation and integration.
- [prime-delegate](skill://prime-delegate) — fan-out, arena, review panel, or pipeline.
- [proof-repair](skill://proof-repair) — exact repro, minimized failure, root cause, minimal fix.
- [tdd](skill://tdd) — behavior through a stable public seam.
- [architect-work](skill://architect-work) — modules/types/interfaces, alternatives, migration, deletion.
- [prototype](skill://prototype) — disposable artifact that buys one decision.
- [contract-review](skill://contract-review) — spec, standards, safety, blast radius, and proof.

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

### Selecting additional principles

Before starting work, use `find` on `skill://primestack/principles`. Describe the engineering concern you need guidance on in one short sentence, not the whole task. Keep details that change which guidance applies; omit project names, workflow narration, and unrelated constraints. For example: "Multiple sessions competing to control one shared device."

Read selected documents in full before applying them. Scores are retrieval hints, not instructions to apply every result. If nothing matches, try one simpler formulation of the concern, then continue if no principle applies. Search again when the engineering concern changes.

## Delegation

Before delegating, read [prime-delegate](skill://prime-delegate).

If delegation is unavailable or provides no useful independence, execute serially and disclose the lost coverage—not a fake parallel run.

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
