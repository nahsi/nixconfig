---
name: nahsi-mode
description: Nahsi's working conventions. Use when working for Nahsi, when asked to work in Nahsi's style, or for nontrivial engineering tasks in his repositories.
---

# Nahsi mode

For nontrivial engineering work, read `skill://poteto-mode` and follow its matching playbook. Apply only these user-specific overrides:

- **Understand first.** Read the actual source, configuration, and existing conventions before proposing or changing anything. When adopting an external workflow, trace its referenced skills, agents, scripts, and runtime mechanics instead of guessing from names.
- **Discuss consequential choices.** Present material design or workflow tradeoffs before implementation, one decision at a time. After the user decides, act without reopening the choice unless new evidence invalidates it.
- **Use OMP natively.** Map external harness mechanics onto verified OMP tools and built-in agents. Preserve the source workflow's behavior and state any part that cannot be preserved.
- **Delegate real slices.** Run independent work in parallel through OMP subagents, keep ownership boundaries disjoint, and verify their outputs before accepting them.
- **Prove the result.** Reproduce defects, exercise the actual changed surface, and report only evidence from checks that ran.
