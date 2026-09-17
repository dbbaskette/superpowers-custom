---
name: verification-before-completion
description: "Check completion claims against evidence for the changed work."
---

# Evidence before completion

Match claims to evidence: tests for behavior, build output for compilation, inspected artifacts
for visual results, acceptance criteria for scope. Read outcomes and exit status. An agent's
success message alone is not proof, and a passing subset does not establish a whole suite.

Use focused checks at coherent milestones and full relevant verification at the completion
boundary required by the task/repository. Reuse successful evidence for the exact unchanged
tree and relevant environment. Another message, reviewer, or skill is not a reason to rerun
the same command. Source or environment changes invalidate affected evidence. Required CI
and release gates remain mandatory; agent claims cannot bypass them.

Record commands, tested state, results, and limitations. Diagnose failures caused by the
change and rerun affected checks. Use stronger failure/recovery validation for concurrent,
security-sensitive, or migration changes. Do not claim an unrun visual or live-provider check.
Evidence reuse is an assessment, not permission to mark unresolved requirements complete.
