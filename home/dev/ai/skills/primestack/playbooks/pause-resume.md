# Pause and resume playbook

Use when work must stop safely, context is high, or a later turn/session will continue.

## Pause

1. Preserve the outcome, current phase, decisions, artifacts, child assignments, verification, gaps, and cleanup obligations.
2. Ensure parallel writers have stopped at a coherent boundary and shared state is not half-integrated.
3. Collect child terminal reports; keep children available while follow-ups remain.
4. Write a local resume artifact under `.scratch/` only when session continuity is insufficient or another human/session needs it.

## Resume

1. Reconcile child status, reports, and artifact paths before continuing.
2. Read artifacts and actual repository state; do not trust a stale checklist over the working tree.
3. Re-run the narrowest load-bearing check.
4. Restate the next dependency frontier and authority boundaries.
5. Continue the current playbook; do not restart completed discovery.
