---
name: using-git-worktrees
description: "Create or verify Git worktree isolation when requested or needed to protect concurrent work."
---

# Worktree isolation

Inspect git status, branch, repository root, git directory, common directory, and
--show-superproject-working-tree before creating anything. Different git/common directories
can mean a linked worktree; do not mistake a submodule for one. Reuse suitable isolation.

Honor the user's directory and checkout choice. A fresh dedicated clone need not gain another
worktree simply because a plan exists. When creating isolation, prefer available host-native
support; otherwise use git worktree add with a named feature branch. Check a project-local
worktree directory is ignored before creating it. Never stage unrelated changes to make room.

Install dependencies only if needed using the project's lockfile/tooling; package.json is
not itself a command to run npm install. Use existing baseline evidence when applicable or
run relevant diagnostics to distinguish pre-existing failures. Do not automatically stop all
work because an unrelated baseline failure exists; report it and avoid hiding it.

On a permission failure, use the host approval mechanism or report the blocker. Do not silently
switch to a shared checkout when isolation was required. Do not assume detached HEAD forbids
all Git actions; consult actual host capabilities. Cleanup only owned, safely integrated
worktrees without unique/uncommitted work, and never force removal of user artifacts.
