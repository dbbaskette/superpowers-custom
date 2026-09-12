---
name: requesting-code-review
description: "Obtain a scoped independent code review when requested or justified before integrating substantial changes."
---

# Request code review

Provide the reviewer with the requirements, exact base/head (or working-tree diff), changed
files, and test evidence. Use an independent permitted invocation when it adds confidence;
do not require a second full review of every small fix or create duplicate review seats.
Use code-reviewer.md as a concise brief template, not a fixed ritual.

Review should evaluate acceptance criteria, correctness, security, regressions, and meaningful
coverage. Give enough surrounding context to verify real findings. Do not preselect the verdict
or suppress relevant defects. Reviewers stay read-only and report uncertainty honestly.

Assign one owner to final test execution. Reviewers inspect existing evidence and request or
run focused safe checks for concrete doubts, not a duplicate full suite. Respect the configured
model and host support; do not invent aliases or force a model upgrade without authority.

During authorized implementation, fix verified material findings and review the affected change.
For review-only requests, report findings without changing code. Do not blindly accept findings
or silently waive real blockers. Review authorization alone does not authorize posting a
GitHub review, approving, merging, or implementing unrelated suggestions.
