---
name: implement
description: Implement an already-shaped slice incrementally through bounded edits, focused checks, integration, documentation/config/migration updates, and real-surface proof. Use for ordinary non-TDD feature or refactor execution after scope and acceptance criteria are clear.
license: MIT
---

# Implement

Execute a decision-complete slice without reopening settled scope or hiding new decisions inside code.

## Entry contract

Require:

- observable goal and acceptance criteria;
- scope/non-goals and ownership surface;
- relevant context pointers;
- risk and authority boundaries;
- exact focused verification plus integration surface.

If a product/architecture decision is unresolved, return to `skill://shape-work`. If the work is too large for one context, use `skill://verticalize-work` before implementation.

## Loop

1. **Read the owned surface completely enough.** Inspect local patterns, callers, tests, types, configuration, and docs that define the contract.
2. **Choose the smallest coherent increment.** It must move observable behavior or the approved migration, not merely create scaffolding.
3. **Edit within ownership.** Keep one owner per file/state surface. Do not opportunistically redesign unrelated code.
4. **Run the focused check immediately.** Stop on an unexpected failure; do not stack more changes over a broken signal.
5. **Inspect the diff.** Remove accidental churn, temporary code, duplicate guards, compatibility residue, and changes outside scope.
6. **Advance incrementally.** Repeat until the slice's acceptance criteria are present.
7. **Close adjacent artifacts.** Update required types, tests, configuration, migrations, docs, generated outputs, and cleanup in the same slice when they are part of correctness.
8. **Integrate.** Reconcile boundaries with neighboring slices/modules and run broader checks according to risk.
9. **Prove the real surface.** Exercise the behavior as the user/caller experiences it and record the evidence.
10. **Review.** Use `skill://contract-review` for consequential or cross-boundary work.

Use `skill://tdd` instead when the user requested TDD or a stable representative seam makes red-green feedback the best implementation loop. Use `skill://proof-repair` when behavior is already broken and root cause is unknown.

## OMP task execution

Use `skill://prime-delegate` only for slices with disjoint files/worktrees/state. Every task worker receives the frozen slice contract and returns a result through automatic delivery, available afterward at `agent://<id>`; the root integrates, checks shared boundaries, and proves the whole outcome.

## Guardrails

- No implementation before blocking decisions are resolved.
- No horizontal batch that leaves verification until the end.
- No silent scope expansion or invented requirement.
- No parallel mutation of shared state.
- No commit, push, merge, deploy, publish, destructive cleanup, paid action, or external message without matching user authority.
- No completion based only on task results or a narrow check when the real surface remains untested.

## Output

- `Slice and acceptance criteria`
- `Changed behavior/artifacts`
- `Focused checks`
- `Integration and real-surface proof`
- `Deviations/decisions discovered`
- `Residual risk`
