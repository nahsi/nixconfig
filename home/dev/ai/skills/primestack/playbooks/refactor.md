# Refactor and migration playbook

Use when behavior should remain stable while ownership, modules, types, interfaces, or data shape changes.

1. State the preserved behavior and the observed friction that justifies change.
2. Use [`context-map`](skill://context-map) to find real callers, external/dynamic contracts, persisted state, and verification seams.
3. Characterize current behavior where existing proof is weak.
4. Run [`architect-work`](skill://architect-work): subtract residue, compare real alternatives, and choose the intended end state.
5. Use [`verticalize-work`](skill://verticalize-work). Prefer direct caller migration; for wide work use expand → migrate independently verifiable groups → contract/delete.
6. Execute each slice with [`implement`](skill://implement) or [`tdd`](skill://tdd); isolate write ownership before [`prime-delegate`](skill://prime-delegate) task fan-out. Migrations touching shared central state remain serialized unless worktrees/artifacts truly separate them.
7. Keep every slice behavior-green. Avoid compatibility layers unless an external constraint requires one and has a deletion trigger.
8. Delete legacy APIs, flags, wrappers, and stale tests/docs as part of the bounded migration.
9. Run [`contract-review`](skill://contract-review) for behavior preservation, blast radius, residue, and real proof.
