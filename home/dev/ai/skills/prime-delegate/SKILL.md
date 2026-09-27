---
name: prime-delegate
description: Provide orchestration for context-heavy work, fan-out, arena candidates, independent reviewers, or staged children. Pair it with the method-owning skill such as contract-review or verticalize-work.
disable-model-invocation: true
license: MIT
---

# Prime Delegate

Before delegating, read the [OMP contract](skill://prime-delegate/references/omp-contract.md).

## Choose a mode

| Mode | Use when | Shape |
|---|---|---|
| `fan-out` | Independent surfaces can be inspected in parallel | Distinct questions → one synthesis |
| `arena` | Several plausible solutions should compete | Same contract → independent candidates → judge/graft |
| `review-panel` | A change needs independent standards, spec, safety, or proof review | Read-only reviewers with non-overlapping lenses |
| `pipeline` | Later work truly depends on earlier output | One bounded stage at a time; pass artifacts, not transcript dumps |
| `single-child` | One context-heavy investigation would pollute the coordinator | One specialist → concise evidence report |

Do not delegate a trivial lookup, tightly coupled edits, or work the coordinator can finish faster than specifying and reviewing it.

## Contract

1. **Define the deliverable.** State the exact question, acceptance check, and expected reply.
2. **Separate ownership.** Parallel children are instructed read-only by default, but prompt policy is not a sandbox. If they edit, give disjoint files/worktrees and one owner per artifact; snapshot or diff shared state afterward.
3. **Bound authority.** State working directory, allowed side effects, forbidden destructive/publish/deploy actions, and whether follow-up questions are allowed. Forbid child subdelegation by default; if granted, set a child budget and relay schema.
4. **Require a reply.** Every task whose answer matters must return a concise result, evidence, file paths, and blockers.
5. **Name stable roles.** Use unique names such as `ApiInvestigator` or `SpecReviewer`, not generated anonymous workers.

## Fan in

- Treat child claims as evidence to verify, not authority.
- Synthesize agreements, contradictions, and missing coverage.
- Keep the child available until any follow-up finishes.
- After compaction or restart, reconcile child status, reports, and artifact paths before continuing.
- Inspect child status or history only for bounded status/stall diagnosis. Ask the user before steering a child based on observed transcript content.

## Mode rules

### Fan-out

Partition by evidence source, subsystem, or review lens—not arbitrary equal chunks. Cap the first wave at three children unless broader coverage clearly pays for itself. Give each child a distinct question and request a short result.

### Arena

Give every candidate the same goal, constraints, and verification target. Keep candidates isolated. The coordinator or a fresh judge selects a base using named criteria, then grafts only independently valuable parts. Never merge all candidates by default.

### Review panel

Use independent contexts for:

- standards and maintainability;
- spec and acceptance criteria;
- safety, permissions, data, and concurrency;
- verification and blast radius.

Reviewers are read-only. Findings need file/line or command evidence, severity, and a concrete failure mode. The coordinator decides which findings are accepted.

### Pipeline

Use only for real dependencies. Each stage writes a compact artifact with a defined schema. The next stage receives that artifact and the original goal, not the entire prior transcript.

## Safety

- Never allow parallel writes to the same file, branch, key, or state object.
- Children do not merge, deploy, publish, delete, or spend money unless the user explicitly granted that authority.
- Do not delegate merely to look busy; every child needs a unique information gain.
- For a missing report: inspect bounded status, send one compact reply request, then mark the lens blocked/dropped and proceed serially or disclose incomplete coverage.
- Child subdelegation is forbidden unless the brief explicitly grants a budget and makes that child responsible for relay.
