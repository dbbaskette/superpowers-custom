# Fix review brief

Provide the original findings, requirements, fix-base/head, diff, and updated evidence.
Review read-only whether each defect is addressed and whether the fix introduces regressions.
Inspect surrounding context where required; do not repeat the whole original review by default.
Report unrelated discoveries separately, but do not automatically downgrade a real security or
correctness blocker because it is outside the fix diff. The coordinator triages it before merge.
Reuse applicable evidence; request focused verification for concrete gaps. Do not mutate,
publish, approve, merge, or delegate a duplicate review.

Return ADDRESSED or NOT ADDRESSED per finding, new defects, and unresolved evidence gaps.
