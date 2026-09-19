---
name: context-map
description: Build a compact evidence-backed map of an unfamiliar codebase, subsystem, behavior, or historical decision before changing it. Use for code walkthroughs, ownership questions, call/data flow, impact analysis, or “how/why does this work?” investigations.
license: MIT
---

# Context Map

Orient before acting. Produce the smallest map that lets the next decision be made without dumping the repository into context.

## Choose the question

- **How:** ownership, entry points, calls, data flow, state, boundaries, and extension seams.
- **Why:** design rationale, regressions, thresholds, historical constraints, and discarded alternatives.
- **Change impact:** callers, contracts, persisted data, permissions, concurrency, tests, operations, and user surfaces.

## Workflow

1. State the question and what decision the map should enable.
2. Read repo guidance, domain docs, ADRs, and the nearest entry point.
3. Trace behavior from an external trigger through ownership boundaries to effects and return path.
4. Identify authoritative types/interfaces, state, invariants, and tests.
5. For “why,” search primary evidence: commit history/blame, issues or PRs if locally referenced/available, docs, incidents, and code evolution. Separate evidence from inference.
6. For impact, search real callers and dynamic/external boundaries; do not stop at direct imports.
7. Record what can safely be ignored for this question.
8. Name the next inspection or decision, not a generic list of files.

For a genuinely broad subsystem, use `skill://prime-delegate` in read-only fan-out mode by distinct evidence source or boundary. Keep raw exploration in children; verify load-bearing claims in the coordinator.

## Evidence standard

- Prefer code, tests, version history, specifications, and first-party documentation.
- Cite file/line, command, commit, or URL for important claims.
- Label `observed`, `inferred`, and `unknown` explicitly.
- Do not claim intent from current code alone.
- Do not edit while mapping unless the user separately requests implementation.

## Output

- `Question and enabled decision`
- `Actors and entry points`
- `Ownership/module map`
- `Call and data flow`
- `State, invariants, and boundaries`
- `Tests and real verification surface`
- `Historical rationale` when asked
- `Change impact` when asked
- `Ignored surface`
- `Unknowns and next inspection`
