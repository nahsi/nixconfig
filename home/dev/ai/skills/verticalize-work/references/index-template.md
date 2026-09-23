# <Work title>

- **Work slug:** `<slug>`
- **Coordinator:** parent/root
- **Status:** shaped | active | blocked | integrated | verified | paused

## Outcome

<Observable condition that makes the whole effort done.>

## Non-goals

- <explicitly excluded work>

## Slice strategy

<Tracer/depth or expand/migrate/contract, with rationale.>

## Dependency graph and frontier

- Current frontier: `<slice ids safe to start now>`
- Next wave: `<slice ids and blocking conditions>`

```text
S01 ──► S03
S02 ──► S03 ──► S04
```

## Status

This table summarizes the slice files. Refresh it from their status and evidence.

| Slice | Value | Status | Owner | Blocked by | Verification |
|---|---|---|---|---|---|
| [S01](slices/01-example.md) | <observable value> | ready | unassigned | none | `<command/surface>` |

## Confirmed decisions

- <decision and evidence/source>

## Open decisions and blockers

- <decision that must not be guessed>

## Integration verification

Completing every slice does not complete the effort.
Run the integration checks below before marking the effort verified.

- [ ] <end-to-end acceptance condition and exact surface>
- [ ] <cross-slice/shared-boundary check>

## External export mapping

<!-- Populate only after explicit approval to create tracker objects. -->

| Local slice | Tracker | External id/url |
|---|---|---|