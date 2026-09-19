---
name: prototype
description: Build a disposable artifact to answer one product, interaction, state-model, integration, or architecture question before production implementation. Use when discussion is stuck on an empirical fork or several genuinely different approaches need comparison.
license: MIT
---

# Prototype

A prototype buys a decision. It is not an early production implementation.

## Workflow

1. **State one question.** Write the decision the prototype must enable and the observation that distinguishes the options.
2. **Choose minimum fidelity:**
   - logic/state: visible transitions and representative inputs;
   - UI: critical flow and meaningful states, not decorative completeness;
   - integration: narrow real boundary with fake/non-production data where safe;
   - architecture: executable seam or types/signatures sufficient to expose friction.
3. **Define disposal and authority.** Use an isolated path/branch/worktree or clearly marked local artifact. Record what may be created and who may remove it. Do not entangle production files without explicit approval.
4. **Build the smallest observable artifact.** Reuse the real project's vocabulary and constraints where they affect the question.
5. **Compare alternatives only when materially different.** For genuine design breadth, use `skill://prime-delegate` arena mode with identical question, constraints, and judging criteria. Give every candidate a separate output path.
6. **Exercise scenarios.** Include the normal path, one edge/failure state, and any transition central to the decision.
7. **Record the findings.** State what was observed, which option the evidence favors and why, what remains unknown, and which prototype assumptions must not leak into production. Separate a recommendation from a confirmed user choice.
8. **Dispose or preserve intentionally.** Default to reporting the artifact and recommended disposition. Delete files, branches, or worktrees only when that cleanup was in the approved prototype scope or the user confirms it; otherwise preserve them in an explicitly non-production location.
9. **Return to the decision.** Feed the result to `skill://shape-work` or `skill://verticalize-work`. A user-facing choice remains open until shape-work's Shared understanding discussion confirms it; a working demo is not that confirmation. Shape production work separately; never promote prototype code by inertia.

## Guardrails

- No prototype without a named question and decision rule.
- No fake data when the uncertainty is the real integration behavior.
- No production hardening, comprehensive tests, or abstraction for a disposable artifact.
- No cosmetic variant fan-out.
- No winning candidate selected by child consensus alone; the parent/user judges the observed tradeoff.
- No destructive cleanup, merge, deploy, or publish of prototype code without explicit scope and authority.

## Output

- `Question and decision rule`
- `Artifact path/run instructions`
- `Scenarios exercised`
- `Observations`
- `Decision and tradeoffs`
- `Unknowns`
- `Disposition`
- `Production follow-up`
