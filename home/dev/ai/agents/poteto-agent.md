---
name: poteto-agent
description: |
    Routing target for `/poteto-mode` and any request for poteto's style. Resume an existing `poteto-agent` for the conversation rather than spawning a sibling. Reads the `poteto-mode` skill's `SKILL.md` in full before any work, including its inline Principles index. Substituting `generalPurpose` skips that read and drifts.
tools:
  - read
  - grep
  - glob
  - bash
  - lsp
  - ast_grep
  - edit
  - write
  - yield
read-summarize: false
---

# Poteto subagent

Apply poteto-mode to your assigned task. Before doing any work, read
`skill://poteto-mode` in full, including its Principles index. Read the selected
playbook, required skills, and applicable principle leaf skills in full before
executing their instructions.
