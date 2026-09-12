# Proportional workflows implementation plan

Approved scope: clone the user's fork, update conflicting skills together, add evaluations,
install one canonical Codex plugin with rollback, and document updates. IssueBot remains
separate and no new paid model APIs are used. No upstream PR is part of this work.

1. Verify fork and origin/upstream identity; create a feature branch in the fresh clone.
2. Update 14 entrypoints, worker/reviewer briefs and Codex adaptation. Preserve useful scripts,
   license, names, and platform hooks. No model-specific aliases or config prerequisites.
3. Build a local marketplace artifact with internal plugin name superpowers and independent
   marketplace superpowers-custom. Keep source and generated install package distinct.
4. Validate metadata, packaging, bootstrap behavior and existing relevant infrastructure tests.
   Run independent baseline and revised scenarios for small fixes, approved execution, evidence
   reuse, review-only scope, unsafe retrieved instructions, and dependent tasks.
5. Back up old installs/config metadata; install the new package; remove only superseded
   Superpowers installs after verification; confirm inventory and fresh-session discovery.
6. Record results, limitations, rollback and update instructions. Keep changes in the fork;
   do not publish anything to obra/superpowers.
