### Authoring or modifying a skill

**You own the skill's voice.** Agent-facing prose has a higher bar than human prose; unhelpful sentences become instructions.

1. Read and apply `skill://create-skill`. It owns drafting, validation, behavioral test cases, and the subjective-output branch.
2. Confirm frontmatter, referenced assets, and every `skill://` pointer through Create-skill's validator.
3. Complete its evaluation loop when behavior is structural; use its user vibe-check when output is subjective.
4. Run **Opening a PR**.

When in doubt, delete; prose earns its keep by changing a decision. Tell it to do the thing and skip the reason. Explain only when the rule is confusing without one. Match tone to scope. Point at structural sources (types, READMEs, config); hardcoded details go stale (the **encode-lessons-in-structure** principle skill). Delegate to other skills by path; don't restate. A workflow you keep hitting but isn't captured → propose a new skill.

**Reply:** summary of the skill, key design decisions, validation notes.
