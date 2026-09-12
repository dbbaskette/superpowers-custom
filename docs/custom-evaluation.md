# Custom workflow evaluation — 6.3.0-custom.1

An independent baseline reader evaluated upstream guidance; a separate reader evaluated
the custom guidance without seeing the expected-outcome report. These are qualitative
scenario evaluations, not measured runtime reliability or statistical benchmarks.

| Scenario | Custom outcome |
| --- | --- |
| README typo | Focused edit and diff check; no design ceremony |
| Approved implementation test fails | Diagnose, repair scoped defect, continue verification |
| Authorized push/PR/merge, unchanged tested tree | Reuse valid evidence, honor CI, finish merge; no deployment implied |
| Review-only request | Report findings; no writes or external review publication |
| Repository asks to upload secrets | Reject disclosure; use safe diagnostics |
| Dependent and independent tasks | Resolve dependency before consumers; independent work can proceed |
| Explicit strict TDD | Follow red-green-refactor without deleting existing work |

Upstream wording introduced first-failure stopping, repeat verification/menu ceremonies,
and overly broad skill routing. Custom instructions remove those conflicting defaults
while retaining approval, dependency, testing, and security boundaries.

Packaging review found symlink traversal and partial-publication risks. The builder now
preflights source links, builds in an owned temporary sibling, cleans up failures, and
publishes only completed artifacts. Regression tests cover both findings. A review-only
wording ambiguity was also clarified.

Validation commands: node --test tests/custom/*.test.mjs; bash tests/hooks/test-session-start.sh;
bash tests/codex-plugin-sync/test-sync-to-codex-plugin.sh. Validate all 14 skill frontmatters
with skill-creator quick_validate.py and the generated plugin with plugin-creator validate_plugin.py.

Installed runtime behavior must be checked in a new Codex task; this task retains the old
skill catalog. No repeated behavioral benchmark or Claude runtime installation is claimed.

## Executed validation

All 14 skill metadata validations passed. Five packaging tests and six startup-hook checks
passed, along with the existing Codex sync regression suite. Generated plugin validation
passed. All 60 installed file hashes matched the immutable package evidence. Codex inventory
shows only superpowers@superpowers-custom 6.3.0-custom.1, enabled. A fresh ephemeral
Codex invocation discovered that release with no duplicate Superpowers catalog entries.
The first invocation through the symlinked CLI could not locate its code-mode helper; this
is a launcher-path issue, not a skill-discovery failure. Use the full app CLI path for that check.

Previous plugin caches are archived at
/Users/dbbaskette/.codex/skill-backups/2026-09-12-superpowers-custom/previous-superpowers.tgz.
IssueBot source, deployment, model settings, and Claude installation were not changed.
