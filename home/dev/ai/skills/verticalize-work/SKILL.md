---
name: verticalize-work
description: Split an agreed plan into implementation slices.
disable-model-invocation: true
---

# Verticalize Work

Turn intent into independently useful, agent-grabbable slices. **Default to chat. Offer local Markdown for durable coordination, and write it only when requested or clearly implied by authorized execution. Never create GitHub/Linear issues unless the user asks.**

## Choose the output surface

1. **Chat checklist** — small plan, immediate execution, no durable coordination needed.
2. **Local task pack** — recommended for multi-session work or delegated execution. Confirm file-write intent when the request is planning-only; otherwise keep the same contract in chat:

```text
.work/<effort>/
  index.md
  slices/
    01-<slice>.md
    02-<slice>.md
```

3. **External tracker** — only on explicit request. Preview the payload first, obtain create authority, then save local-slice ↔ external-id links in the index. Make retries idempotent; do not make the tracker the source of the plan.

For a local pack, start from [the index template](references/index-template.md) and [the slice template](references/slice-template.md). The parent/coordinator alone owns `index.md`; children may update only their assigned slice files. Never overwrite an existing slug implicitly: inspect it, confirm resumption when the outcome matches, or choose a new slug. Reconcile index status against actual artifacts and verification on resume. Automated index rewrites use a temporary file plus atomic replace.

## Workflow

1. **Define the outcome.** State the observable condition that makes the whole effort done, plus non-goals.
2. **Inspect reality.** Read relevant code, tests, docs, and prior decisions. Do not slice an imagined architecture.
3. **Find horizontal temptations.** Backend-only, frontend-only, schema-only, test-only, and cleanup-only tasks are warnings. Merge them when they do not deliver a verifiable capability alone.
4. **Create the tracer slice.** Choose the thinnest end-to-end behavior that crosses the real boundaries and produces feedback.
5. **Add depth slices.** Edge cases, migrations, integrations, permissions, resilience, polish, performance, and cleanup follow as independently valuable increments.
6. **Model dependencies.** Use the fewest real edges. Prefer parallel roots; do not serialize work merely because the list is written in order.
7. **Make each slice grabbable.** Include context pointers, acceptance criteria, proof command/surface, ownership boundaries, risks, and authority.
8. **Check slice fitness.** One child or session can complete it without hidden decisions or the full planning transcript.
9. **Choose a first wave.** Name the tracer slice and every independent root that is safe to start now.

## Special shapes

### Discovery

Discovery is a slice only when a decision blocks implementation. Its deliverable is evidence plus a decision or narrowed options—not “research done.” Convert the result into implementation slices afterward.

### Wide migration

Prefer:

1. **Expand** — add the new path and prove it alongside the old path.
2. **Migrate** — move independently verifiable caller groups in parallel where safe.
3. **Contract** — delete the old path, compatibility code, and residue after all callers move.

### Necessary horizontal work

Keep a horizontal slice only when it creates a standalone, reusable, verifiable capability that unblocks multiple vertical slices. Say why it earns independence.

## Slice contract

Every durable slice uses [the slice template](references/slice-template.md). At minimum:

```markdown
# S01 — <outcome-oriented title>

## Value
<What becomes observably possible or safer?>

## Scope
<Included behavior and ownership boundary>

## Acceptance criteria
- [ ] <observable result>

## Verification
<Exact command or real surface>

## Dependencies
<slice ids or none>
```

## Implementation

For planning-only requests, save the slices, report the ready frontier, and stop.

When the user authorizes implementation, execute ready slices through the matching pstack playbooks. Read `skill://pstack-omp` before delegating. Implementation may span multiple workers and sessions.

On resume, read the work index, active slices, and recorded evidence. Reconcile unfinished work before selecting the next ready slices; do not take over another active session's work.

- Schedule slices in dependency waves.
- One child owns one slice and its declared files/worktree.
- Parallel children may not share mutable files, branches, keys, or state.
- Put the slice-file path and original outcome in the child prompt; do not paste the entire planning conversation.
- Require an explicit parent reply with status, evidence, changed paths, blockers, and any artifact path. When a slice file exists, the child updates it **and** replies; artifact-only completion is a diagnosed fallback, not the normal signal.
- The coordinator verifies integration and the whole outcome; “all children replied” is not completion.
- If a slice reveals a hidden decision, mark it blocked and reshape locally. Do not create an issue as a reflex.

## Guardrails

- Do not create `setup`, `backend`, `frontend`, `tests`, and `cleanup` slices by layer unless each produces standalone value.
- Do not make every slice equal size; make each independently useful and context-bounded.
- Do not hide product or architecture decisions inside worker tasks.
- Do not manufacture dependencies to impose a preferred order.
- Do not publish to any tracker without explicit approval.
- Do not fan out implementation until file/state ownership is disjoint.
- Do not confuse a locally completed slice with integrated, verified delivery.

## Output

Return or write:

- `Outcome and non-goals`
- `Slice strategy`
- `Dependency map`
- `Ordered slice contracts`
- `First wave`
- `Integration verification`
- `Open decisions/blockers`
