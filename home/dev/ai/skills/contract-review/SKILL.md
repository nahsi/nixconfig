---
name: contract-review
description: Own the review method for a diff, plan, or boundary against intent, repository standards, safety, blast radius, and verification. Use for code review or pre-ship judgment; skill://prime-delegate is only the optional independent-panel mechanism.
license: MIT
---

# Contract Review

Review the actual artifact against a fixed intent and evidence. Findings come first; praise and summaries do not hide defects.

## Freeze the review package

1. Identify the exact artifact or Git fixed point (`merge-base`, commit, branch, files, plan version).
2. Load the originating request/spec/slice acceptance criteria.
3. Load repo guidance, domain docs, and the checks that define local standards.
4. Record already-run verification and known gaps.

If intent is missing, say so. Do not invent requirements to create findings.

## Review axes

### 1. Spec and behavior

- Does every acceptance criterion exist in behavior?
- Are non-goals respected?
- Do edge/failure states preserve the intended contract?
- Is there gold-plating or silent scope loss?

### 2. Repository standards and design

- Does the change match local patterns and domain language?
- Are types, ownership, boundaries, and interfaces coherent?
- Does it add duplication, shallow wrappers, speculative abstraction, or reader load?
- Are tests coupled to behavior rather than internals?

### 3. Safety and blast radius

Inspect when relevant:

- trust/permission/auth boundaries;
- persisted data and migrations;
- retries, idempotency, concurrency, and shared state;
- external/dynamic callers and compatibility;
- secrets, destructive actions, rollback, and operational failure;
- user-visible and accessibility states.

### 4. Proof

- Can the claimed behavior be reproduced on the real surface?
- Do tests fail for the right reason without the change?
- Which one load-bearing fact proves the change is safe?
- What important surface remains unverified?

## OMP review panel

For a consequential change where independent contexts add information, read `skill://prime-delegate` and use its profile selection for each review assignment. Use `security-reviewer` only when the artifact specifically warrants its specialized security method.

Choose only the lenses the change needs, give them the same immutable artifact and intent, and name `skill://contract-review` as the method when this rubric governs their work. Under this method, each finding includes:

- severity: `critical`, `high`, `medium`, or `low`;
- exact location;
- violated contract;
- concrete failure mode;
- evidence or reproduction;
- smallest credible remedy.

A panel member assigned a different method follows that method's evidence and output shape; do not force every reviewer into this schema. Results auto-deliver and remain available at `agent://<id>`. The parent deduplicates and verifies findings, then categorizes each as `act`, `consider`, `noted`, or `dismissed`, with rationale. Reviewer consensus is not proof and does not authorize edits.

## Guardrails

- Read-only review does not mutate the artifact.
- No style finding without a repository rule or concrete maintenance cost.
- No severity without a plausible impact path.
- No raw concatenation of child reports.
- No “looks good” verdict when verification gaps remain unnamed.
- No merge, deploy, publish, or external message unless the user explicitly requested it.

## Output

1. Severity-ordered accepted findings.
2. Dismissed/disputed findings with rationale when a panel was used.
3. Spec coverage and scope drift.
4. Verification performed and gaps.
5. Residual risk.
6. Verdict: `blocked`, `changes requested`, `acceptable with risk`, or `verified`.
