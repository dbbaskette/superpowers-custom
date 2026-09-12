---
name: subagent-driven-development
description: "Execute an approved plan with permitted subagents and explicit integration ownership."
---

# Subagent-driven implementation

Use this workflow when delegation is permitted and useful, not merely because tools exist.
Read the approved spec/plan and progress record. Define task dependencies and nonoverlapping
ownership; batch small related edits. The coordinator owns integration, final tests, and
publication decisions. Independent workers may run concurrently only with safe isolation.

Give workers the relevant task, interfaces, scope, workspace, and evidence/report requirements.
The templates implementer-prompt.md and task-reviewer-prompt.md are optional brief starters.
Workers do not spawn duplicate reviewers. Keep configured models unless a supported change
is authorized; availability and uncertainty do not require automatic model escalation.

Track completed tasks, tested state, findings, and decisions in a durable task-scoped record
for long work. Existing scripts/sdd-workspace, scripts/task-brief, and scripts/review-package
can prepare artifacts when their plan format fits. Do not recreate finished work after
compaction or delete the only record of unresolved decisions.

Review coherent milestones for both spec and quality. Reuse supplied evidence when valid;
run focused checks for concrete doubts. Fix actual defects and use re-review-prompt.md for
the affected diff. Resolve incorrect findings with evidence immediately, not after mandatory
failed rounds. If repeated attempts make no progress, change the approach or request needed
context. Do not waive real material defects at a retry cap or call them complete.

Continue approved work without repeated approval pauses. Mechanical decisions can adapt
within scope; new product choices or authority boundaries need the user. Complete independent
tasks while a dependency is blocked, but do not implement dependent work on an unresolved
contract. A final integrated review/check should fill coverage gaps, not duplicate every task
review. Execute already-authorized publication via finishing-a-development-branch.
