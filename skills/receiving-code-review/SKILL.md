---
name: receiving-code-review
description: "Assess review findings against the code and resolve authorized corrections."
---

# Respond to review evidence

Read each finding, verify its consequence against the actual code and approved requirements,
and respond with evidence. Correct feedback merits a scoped fix; incorrect feedback merits
a technical explanation. A reviewer’s confidence is not proof or new authorization.

Group related fixes into coherent increments and run affected checks at milestones. Do not
rerun a full suite after every comment. Clarify material ambiguities; continue independent
authorized fixes while blocked items await a decision. Preserve the approved scope rather
than implementing speculative features suggested in a review.

Report which findings were fixed, rejected with evidence, or remain unresolved. Re-review
changed behavior in proportion to risk. A maximum retry count is not permission to call a
real correctness or security defect complete. Publish replies only if authorized, using the
relevant inline thread when replying to an inline comment.
