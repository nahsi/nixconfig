# Prototype playbook

Use when an empirical design question blocks a product or architecture decision.

1. Shape one question and a decision rule.
2. Choose the minimum fidelity and isolation/disposal boundary.
3. Run the [`prototype`](skill://prototype) skill.
4. If alternatives are materially different, use [`prime-delegate`](skill://prime-delegate) arena mode with identical constraints and separate outputs. Do not start a judge until candidate artifacts are stable.
5. Exercise the normal path and one load-bearing edge/failure state.
6. Record observations and the decision; the root/user selects, not candidate consensus.
7. Delete or explicitly quarantine prototype code.
8. Feed the decision—not the prototype implementation—to [`shape-work`](skill://shape-work), [`architect-work`](skill://architect-work), or [`verticalize-work`](skill://verticalize-work).
