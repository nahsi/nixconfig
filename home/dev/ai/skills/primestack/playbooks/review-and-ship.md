# Review and ship playbook

Use for an existing change that needs adversarial judgment and release readiness.

1. Freeze the diff/artifact fixed point and originating intent.
2. Run the closest native checks and exercise the real surface before asking reviewers to judge claims.
3. Run [`contract-review`](skill://contract-review). For consequential work, use a read-only [`prime-delegate`](skill://prime-delegate) panel with spec, standards, safety, and proof lenses.
4. The root validates, deduplicates, accepts/dismisses, and fixes approved findings; never auto-apply reviewer prose.
5. Re-run affected checks after fixes and inspect blast radius beyond the diff.
6. Confirm authority before commit, push, merge, deploy, publish, customer messaging, or destructive cleanup.
7. Report verdict, evidence, gaps, and residual risk.

“Green CI” is not release proof when the real user surface or migration path remains untested.
