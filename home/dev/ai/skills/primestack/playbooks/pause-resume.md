# Pause and resume playbook

Use when work must stop safely, context is high, or a later turn/session will continue.

## Pause

1. Update the native todo/session ledger: outcome, current phase, decisions, artifacts, children, verification, gaps, and cleanup obligations.
2. Ensure parallel writers have stopped at a coherent boundary and shared state is not half-integrated.
3. Collect child terminal results; keep existing children available while follow-ups are pending.
4. Write a local resume artifact only when native session continuity is insufficient or another human/session needs it.
5. If context is high, rely on OMP's native continuation/checkpoint behavior with focused preservation of the ledger, child IDs, artifact URIs, decisions, remaining proof, and cleanup obligations.

## Resume

1. Reconcile saved child IDs with bounded `hub list`/`hub jobs` state and their `agent://<id>` results.
2. Read artifacts and actual repository state; do not trust a stale checklist over the working tree.
3. Re-run the narrowest load-bearing check.
4. Restate the next dependency frontier and authority boundaries.
5. Continue the current playbook; do not restart completed discovery.
