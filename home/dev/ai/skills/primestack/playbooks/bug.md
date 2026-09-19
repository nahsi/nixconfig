# Bug and performance playbook

Use for regressions, flakes, incidents, wrong output, runtime failures, and measured slowness.

1. Freeze the exact symptom, environment, and nearest known-good behavior.
2. Run [`proof-repair`](skill://proof-repair): build and execute a red-capable proof loop before patching.
3. Minimize the reproduction and rank falsifiable hypotheses when the cause is not obvious.
4. Delegate read-only evidence searches only when sources are independent; do not fan out competing speculative fixes.
5. Establish the causal chain and correct fix boundary.
6. Preserve the bug at a valid seam with [`tdd`](skill://tdd) when a representative regression test is cheap.
7. Apply the smallest coherent fix; remove rejected probes and patch attempts.
8. Re-run the original proof, nearest broader checks, and the real surface.
9. Use [`contract-review`](skill://contract-review) for high-risk, cross-boundary, security/data/concurrency, or hard-to-reproduce repairs.

For performance, compare the same workload before/after and report absolute and relative results.
