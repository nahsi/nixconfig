# Investigation playbook

Use for read-only local “how,” “why,” ownership, history, and impact questions, or external research into unfamiliar topics, alternatives, practitioner experience, and conflicting evidence.

1. State the goal, constraints, and which decision the investigation should enable.
2. Choose the evidence method:
   - Local code, behavior, or history: run [`context-map`](skill://context-map) in `how`, `why`, or `change impact` mode.
   - Exploratory external research: run [`in-depth-research`](skill://in-depth-research). Let discoveries revise terminology, subquestions, and the domain map while keeping the user's goal fixed.
   - A precise external fact: consult its authoritative source directly. A bounded evidence audit follows its assigned audit method rather than restarting exploration.
3. Work inline when bounded. For independent or context-heavy branches, use [`prime-delegate`](skill://prime-delegate), passing the chosen method explicitly. Use scout profiles for local evidence and researcher profiles for external evidence. Children remain read-only, return source-backed findings and promising leads, and do not spawn. The coordinator owns cross-branch synthesis and any further research round.
4. Distinguish observed evidence, inference, and unknowns.
5. Verify disputed/load-bearing claims directly in the root.
6. Synthesize the smallest useful map; do not dump all explored files or child prose.
7. Do not edit code unless the user separately asks for implementation.

If the investigation exposes a decision, transition to [`shape-work`](skill://shape-work). If the investigation exposes executable work, transition to [`verticalize-work`](skill://verticalize-work) only when execution planning is requested.
