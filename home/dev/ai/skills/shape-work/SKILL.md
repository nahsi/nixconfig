---
name: shape-work
description: Shape ambiguous product or engineering work into a tracker-neutral contract or brief with outcome, domain language, scope cuts, requirements, risks, decisions, and verification. Use before implementation when intent, terminology, sequencing, UX wiring, or safety is unclear.
license: MIT
---

# Shape Work

Turn fuzzy intent into a decision-complete contract without over-planning simple work or publishing tracker objects.

## Choose depth

- **Fast contract:** local reversible change with a clear outcome.
- **Product brief:** user-visible behavior, multiple actors, or durable requirements.
- **Decision shaping:** terminology, architecture, or product choices can invalidate implementation.
- **Breadboard:** a multi-step UI/code flow is unclear at the wiring boundaries.

## Workflow

1. **Ground in reality.** Read nearby code, tests, docs, `CONTEXT.md`, and ADRs. Use a read-only child only when a broad context search would pollute the coordinator.
2. **Name the outcome.** What external behavior or delivery signal should be true? Who observes it? What is explicitly not the goal?
3. **Cut scope.** Classify proposed work as:
   - `keep` — required for the outcome;
   - `defer` — useful later but not required now;
   - `freeze` — do not disturb this surface;
   - `remove` — actively weakens signal or adds accidental complexity.
4. **Resolve language.** Identify overloaded terms and state the canonical project vocabulary. Test fuzzy terms with one concrete scenario.
5. **Separate facts from decisions.** Inspect the repo for answerable facts. Ask the human only for judgment, preference, authority, or missing domain knowledge. When several independent decisions are unblocked, ask a short numbered frontier and give a recommended answer with tradeoffs.
6. **Write requirements and non-goals.** Use observable behavior, not implementation wishes. Mark uncertain claims.
7. **Assign risk and proof:**
   - `low` — local, reversible;
   - `medium` — cross-module or user-visible;
   - `high` — data, auth, permissions, concurrency, migration, billing, security, or hard rollback;
   - `critical` — irreversible/external impact or severe trust boundary.
8. **Set verification level.** Focused check, heightened broader checks, or critical regression/rollback evidence.
9. **Record decision gates.** Include only unresolved choices that block safe work. Offer an ADR only when a confirmed decision is hard to reverse, surprising, and tradeoff-driven.
10. **Prepare execution.** Hand the contract to `skill://verticalize-work` for local slices. Do not create issues unless asked.

## Optional breadboard

Use only when interaction wiring is the risk. List:

- **Places:** bounded user/caller contexts.
- **UI affordances:** visible action/state, trigger, destination, return path.
- **Code affordances:** loader/action/job/API, input, call target, returned data/control.
- **Boundaries:** browser/server/service/queue/database or trust transitions.

Mark tentative affordances with `?`. Skip this for a one-step flow.

## Guardrails

- Do not interview for facts the repo can answer.
- Do not invent abstractions before reading existing patterns.
- Do not turn preferences into hidden requirements.
- Do not create ADRs, specs, or tracker objects as ceremony.
- Do not proceed while an unresolved decision could invalidate the work.
- Do not let planning consume more effort than the reversible implementation warrants.

## Output

- `Outcome and actors`
- `Canonical terms`
- `Scope: keep/defer/freeze/remove`
- `Requirements and non-goals`
- `Risk and verification level`
- `Confirmed decisions`
- `Decision gates/open questions`
- `Breadboard` when useful
- `Recommended next artifact`
