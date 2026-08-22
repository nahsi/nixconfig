### Opening a PR

Invoked at the end of every other playbook.

**Worktree.** Work from a git worktree off main. Non-isolated OMP task agents share the parent's cwd; they do not receive private worktrees automatically. Give concurrent writers disjoint files or explicit isolated worktrees. Dirty branch with unrelated work: preserve it, create a fresh worktree, and apply only the task's changes. Snarled worktree: reset only the isolated task worktree from main, then redo minimally.

**Commits.** Commit liberally; rebase into small, ordered commits before opening PRs. Each commit is a future PR: landable, ordered to tell the story. Amend when the fix belongs in a just-made commit; new commit when separable.

**PRs.** Apply `skill://deslop` to the diff before commit, `skill://no-comments` before review, and **unslop** to the PR description and commit bodies. Small PRs, 5 narrow over 1 fat; stack follow-ups, branch off main only for genuinely independent work. For stacked PRs, use whatever stacking tool the team already uses. Read PR status through `pr://<number>`. Open the PR through OMP's `github` tool when available. If no write-capable PR tool is installed, push the branch, return the exact compare URL, and state that PR creation remains open. Rebase on `main` before substantial stack work. No `## Summary` / `## Test plan` boilerplate on small PRs; commit bodies don't restate the subject.

A subagent that opens a PR runs `skill://interrogate`, `skill://deslop`, and `skill://no-comments`, then returns the URL. It does not monitor the PR. Return to the parent.
