---
name: prime-delegate
description: Provide the PrimeStack orchestration mechanism for task fan-out, arena candidates, independent reviewers, or staged children. Pair it with the method-owning skill such as contract-review or verticalize-work; use when isolation or parallelism adds information.
license: MIT
compatibility: Oh My Pi with task agents, hub coordination, agent and history URIs, and native session continuation.
---

# Prime Delegate

Delegate only when isolation or parallelism improves the result. A child is not a function call: `task` admits work and returns job identities immediately. Results arrive later through automatic delivery and `agent://<id>`.

## Choose a mode

| Mode | Use when | Shape |
|---|---|---|
| `fan-out` | Independent surfaces can be inspected in parallel | Distinct questions → one synthesis |
| `arena` | Several plausible solutions should compete | Same contract → independent candidates → judge/graft |
| `review-panel` | A change needs independent standards, spec, safety, or proof review | Read-only reviewers with non-overlapping lenses |
| `pipeline` | Later work truly depends on earlier output | One bounded stage at a time; pass artifacts, not transcript dumps |
| `single-child` | One context-heavy investigation would pollute the coordinator | One specialist → concise evidence report |

Do not delegate a trivial lookup, tightly coupled edits, or work the coordinator can finish faster than specifying and reviewing it.

## Select the profile

Choose the role for the work first, then choose its configured tier from difficulty, risk, and coupling. A profile supplies capabilities and a model tier, not a permanent methodology or a mandatory pipeline stage.

| Role | Profile | Tier | Use |
|---|---|---|---|
| General execution | `sonic` | Mechanical | Prescribed work with an obvious correctness check |
| General execution | `task` | Deep | Difficult, coupled, or judgment-heavy execution |
| Local evidence | `scout` | Standard | Bounded repository or transcript discovery |
| Local evidence | `scout-deep` | Deep | Ambiguous or cross-cutting local investigation |
| External evidence | `researcher` | Standard | Focused published-source research |
| External evidence | `researcher-deep` | Deep | Difficult synthesis or disputed external evidence |
| General evaluation | `reviewer` | Standard | Default review against assigned criteria |
| General evaluation | `reviewer-deep` | Deep | Complex reasoning across interacting behavior or conflicting evidence |
| Security evaluation | `security-reviewer` | Deep | Security work requiring the specialized bundled method |

Prefer the lower tier only when its contract is genuinely bounded. Start high when failure impact, ambiguity, or cross-boundary coupling warrants it. Escalate to the corresponding high-tier profile only after an evidenced capability blocker; do not automatically retry the same assignment.

After selecting the profile, set per-item effort to `lo`, `med`, or `hi` only when the live `task` schema exposes that field and `task.enableEffort` is enabled. Otherwise omit it and preserve the profile default. There is no per-call model selector.

All profiles except `task` are leaf profiles. `task` may spawn descendants only when its assignment explicitly grants a budget, relay contract, and cleanup responsibility. An explicitly assigned PrimeStack workflow is allowed within that scope; loading a skill alone never grants broader authority.

## Assignment contract

Every child assignment names:

1. **Method.** Name the governing skill/reference or give a direct procedure. For controlled evaluations, explicitly identify a no-skill baseline. The profile alone does not choose a method.
2. **Scope.** State the outcome, owned paths or read-only boundary, inputs, working directory, and acceptance check.
3. **Evidence and output.** Name the required proof and terminal result shape, including paths and blockers.
4. **Authority.** Bound side effects and destructive/publish/deploy actions. Prompt policy and worktree isolation are not security sandboxes.
5. **Validation owner.** Say which child checks are allowed and which integration checks remain with the parent.
6. **Subdelegation.** Forbid it, or grant an explicit budget, relay contract, and descendant cleanup duty to `task`.

Parallel writers need disjoint files, branches, keys, and state. While a worker is active, the parent does not investigate, edit, or validate that delegated scope; it resumes ownership after the worker's terminal result.

## Spawn

Admit independent children together in one `task` batch and keep the returned job identities:

```yaml
context: shared goal, constraints, cross-slice contracts, and parent-owned validation
tasks:
  - name: ApiInvestigator
    agent: scout
    task: Read skill://context-map. Inspect the API boundary read-only. Return cited evidence in the terminal result. Do not spawn children.
  - name: TestInvestigator
    agent: scout
    task: Inspect the named test files and report uncovered behaviors with citations. Do not spawn children.
```

Once admitted, continue only work outside delegated scopes and let results arrive automatically. Do not busy-poll, duplicate a worker's investigation, or pretend admission returned an answer.

The `agent` field selects one configured profile from the table. Concrete model routing remains in OMP/Nix configuration, never in task briefs or skills.

## Fan in

- Treat child claims as evidence to verify, not authority.
- Synthesize agreements, contradictions, and missing coverage.
- For a follow-up, send one focused request through `hub` to the existing child's exact roster ID. Keep the child until the follow-up finishes.
- After continuation or checkpoint restoration, recover peer and job state with bounded `hub list`/`hub jobs` inspection and recover results through `agent://<id>` or `history://<id>`.
- Use `history://<id>` only for bounded status/stall diagnosis. Ask the user before steering a child based on observed transcript content.
- OMP has no Prime-equivalent child-deletion lifecycle call. Do not use job cancellation as cleanup. Complete replies and follow-ups, retain the necessary IDs/artifacts, and let OMP park or release the session. When nesting was explicitly granted, the direct child remains responsible for relaying descendant results and completing descendant cleanup before its own terminal report.

## Mode rules

### Fan-out

Partition by evidence source, subsystem, or review lens—not arbitrary equal chunks. Cap the first wave at three children unless broader coverage clearly pays for itself. Give each child a distinct question and request a short result.

### Arena

Give every candidate the same goal, constraints, and verification target. Keep candidates isolated. The coordinator or a fresh judge selects a base using named criteria, then grafts only independently valuable parts. Never merge all candidates by default.

### Review panel

Reviewers are read-only. Select each profile using the table above, then assign its lens and governing method; both reviewer tiers follow the same review contract. Use `contract-review` for its contract rubric, or another named method when the assignment needs a different evaluation. Select `security-reviewer` only for specifically warranted security work. The coordinator decides which findings are accepted.

### Pipeline

Use only for real dependencies. Each stage writes a compact artifact with a defined schema. The next stage receives that artifact and the original goal, not the entire prior transcript.

## Safety

- Never allow parallel writes to the same file, branch, key, or state object.
- Children do not merge, deploy, publish, delete, or spend money unless the user explicitly granted that authority.
- Do not delegate merely to look busy; every child needs a unique information gain.
- For a missing report: inspect bounded status, send one compact reply request to the existing child, then mark the lens blocked/dropped and proceed serially or disclose incomplete coverage. An artifact is fallback payload, not the normal completion signal.
- Never use cancellation as a claimed cleanup operation. Treat nested work as complete only after the authorized child has relayed descendant results and discharged its stated cleanup duty.
- Child subdelegation is forbidden unless the brief explicitly grants a budget and makes that child responsible for relay and descendant cleanup. Use exact hub roster IDs; reachability never widens authority.
- Role selection is not a workflow: spawn only the roles that add information or execute an owned slice.

Read [the OMP task and hub contract](references/omp-runtime.md) before the first orchestration run.
