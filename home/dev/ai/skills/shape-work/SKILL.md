---
name: shape-work
description: Establish shared understanding of ambiguous product or engineering work through guided discussion, then capture the outcome, domain language, scope, requirements, risks, and decisions. Use before implementation when intent or tradeoffs are unclear; keep already-shaped work lightweight.
license: MIT
---

# Shape Work

Turn fuzzy intent into a decision-complete contract without over-planning simple work or publishing tracker objects.

## Choose depth

- **Fast contract:** local reversible change with a clear outcome.
- **Product brief:** user-visible behavior, multiple actors, or durable requirements.
- **Decision shaping:** terminology, architecture, or product choices can invalidate implementation.
- **Breadboard:** a multi-step UI/code flow is unclear at the wiring boundaries.

For substantial ambiguous work or a request to think a design through together, read and follow [Shared understanding](references/shared-understanding.md) before writing a settled contract. It owns the question-and-answer rounds, active domain modeling, and confirmation boundary. The workflow below supplies the topics to resolve, not permission to fill them in autonomously. A fast contract with an explicit, already-understood outcome does not require an extended interview.

An interrupted conversation remains a draft with unresolved questions.

## Workflow

1. **Ground in reality.** Read nearby code, tests, docs, `CONTEXT.md`, and ADRs. Use a read-only child only when a broad context search would pollute the coordinator.
2. **Name the outcome.** What external behavior or delivery signal should be true? Who observes it? What is explicitly not the goal?
3. **Cut scope.** Classify proposed work as:
   - `keep` — required for the outcome;
   - `defer` — useful later but not required now;
   - `freeze` — do not disturb this surface;
   - `remove` — actively weakens signal or adds accidental complexity.
4. **Resolve language.** Use the project's canonical terms and concrete scenarios. For active terminology changes, follow Shared understanding's domain-modeling discipline and update the authorized glossary as terms settle.
5. **Separate facts from decisions.** Resolve answerable facts with the relevant evidence method. In shared-understanding mode, discuss the consequential choices through its rounds and wait for the user; findings and recommendations are not user decisions.
6. **Write requirements and non-goals.** Use observable behavior, not implementation wishes. Distinguish confirmed choices from proposals and unknowns. In shared-understanding mode, confirm the synthesis before treating it as settled.
7. **Assign risk and proof:**
   - `low` — local, reversible;
   - `medium` — cross-module or user-visible;
   - `high` — data, auth, permissions, concurrency, migration, billing, security, or hard rollback;
   - `critical` — irreversible/external impact or severe trust boundary.
8. **Set verification level.** Focused check, heightened broader checks, or critical regression/rollback evidence.
9. **Record decision gates.** Include only unresolved choices that block safe work. Link existing authoritative answers; use Shared understanding's criteria for ADRs rather than generating one for every choice.
10. **Hand off within scope.** Recommend the next artifact and use `skill://verticalize-work` when execution planning is requested. Neither a confirmed contract nor an ADR authorizes implementation or tracker publication.

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
