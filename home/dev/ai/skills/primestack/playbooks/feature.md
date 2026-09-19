# Feature playbook

Use for new or changed user-visible behavior.

1. **Shape:** run [`shape-work`](skill://shape-work) if outcome, domain language, scope, or decisions are unclear. Freeze acceptance criteria and non-goals.
2. **Orient:** use [`context-map`](skill://context-map) to locate ownership, contracts, similar paths, and the real verification surface.
3. **Decide:** use [`prototype`](skill://prototype) for an empirical fork; use [`architect-work`](skill://architect-work) for a consequential module/type/interface shape. Do not prototype settled work.
4. **Slice:** for multi-step work, use [`verticalize-work`](skill://verticalize-work); default to a local task pack and choose the tracer slice/first dependency frontier.
5. **Build:** use [`tdd`](skill://tdd) at stable pre-agreed seams; otherwise run [`implement`](skill://implement) for bounded incremental edits, focused checks, integration, and real-surface proof. Delegate only disjoint slices and keep one owner per artifact.
6. **Integrate:** the root combines slices, resolves boundary mismatches, and exercises the end-to-end path.
7. **Review:** run [`contract-review`](skill://contract-review) against the frozen acceptance criteria, local standards, safety, blast radius, and proof.
8. **Verify:** exercise the real user surface and broader checks by risk. Report deviations and residual risk.

Stop and reshape if implementation reveals a hidden product decision or repeatedly fights the proposed design.
