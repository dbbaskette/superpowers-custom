---
name: finishing-a-development-branch
description: "Integrate completed, verified work according to the user’s publication instructions."
---

# Finish the branch

Check the actual repository, branch, base, diff, and verification evidence. Reuse valid checks
for the unchanged tree/environment; test affected integration changes when the base has moved.
Resolve material correctness findings before merge. Do not waive blockers to satisfy a deadline.

If the user already requested push, PR, or merge, perform those authorized actions without
another options menu. If publication intent or target is ambiguous, ask only for that missing
decision. Local completion does not itself authorize publishing, deployment, or restart.

Use the repository's required release metadata, PR checks, and approved merge method. Check
for an existing PR before creating one. On uncertain writes, inspect remote state before
retrying. Verify the remote merged commit and source tree before claiming success. Do not
force-push or bypass protections without explicit authority.

Preserve unrelated changes, externally managed worktrees, and unique artifacts. Remove an
owned worktree only when its work is integrated and cleanup is safe; never force-delete dirty
work. Keep rollback and deployment decisions separate. Report PR/commit, verification, and
whether the running service changed.
