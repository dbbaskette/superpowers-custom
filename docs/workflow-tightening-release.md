# Superpowers Custom 6.4.2-custom.2

This release implements the two workflow reviews under the user's authorization to plan,
implement, publish a fork PR, merge, and install locally. See the
[implementation plan](superpowers/plans/2026-10-06-workflow-tightening.md).

## Changes

- Startup context uses the host's available loader and identifies the router as already loaded.
- OpenCode deduplicates its actual bootstrap rather than a generic phrase in user text.
- Debugging references focus on independently necessary boundaries and correct filesystem
  containment; the root-cause guide no longer prescribes unconditional extra validation.
- The visual operating guide pauses for material unresolved decisions. Its markup catalog
  is separately loaded when needed; authentication and server lifecycle guidance remain.
- Test-writing guidance permits contractual interaction assertions and small valid fixtures.
- Skill evaluation guidance uses proportional outcome scenarios. Earlier pressure-testing
  materials are labeled historical. Antigravity bookkeeping is milestone-based.
- All 14 skill identities and independent worker briefs remain. Execution/delegation
  descriptions clarify their distinct triggers; no mandatory shared-policy read is added.
- The README and fork PR template describe the maintained workflow. Upstream README content
  is preserved separately for attribution and history.
- Optional CLI scenarios load an explicit candidate and retain source hashes and transcripts.
  Retired SDD recall tests are compatibility wrappers; fixed review order, task-pasting,
  per-task commits, and worktree expectations are no longer their verdict criteria.
- All nine declared version manifests are aligned to 6.4.2-custom.2.

## Verification

On 2026-10-06, the complete relevant suite passed in the existing disposable Tart runner.
Environment: macOS 27.0 (26A428), Node 22.23.2, npm 10.9.8, Git 2.54.0, Bash 3.2.57.
The source was base 9d719f28d6b949bebc745142fb4b1fef79275c0f plus this branch's changes.

Coverage: seven custom package/harness tests, startup hooks, SDD workspace helpers, Codex
sync, OpenCode loading/caching/deduplication, and the complete brainstorm-server suite.
The generated plugin contained 61 files. Windows-only checks skipped on macOS. The runner
stopped and deleted its owned VM successfully.

Logs: ~/Library/Logs/MacOS Test Suite/superpowers-custom/
superpowers-custom-test-20261007015540-39649-f5f139d3/.

Independent release review found an evaluation-runner path issue. It was corrected after
the VM snapshot: create the configured output root and canonicalize candidate/output paths
before changing directory. Both affected fake-CLI tests passed again on host Node 25.9.0,
including nonexistent relative output paths. Independent focused re-review confirmed the fix.
Other verified runtime code did not change; release records were added afterward.

All 14 skills passed skill-creator metadata validation using cached PyYAML. All nine version
declarations match. The documentation's executable path example passed child, root,
sibling-prefix, and symlink-escape checks. Changed maintained Markdown links and diff
whitespace were checked.

## Behavioral evidence and limits

Two independent host agents received only candidate paths, raw fixture files, and user tasks:

- Approved implementation: implemented blank-name rejection, kept the public return structure,
  added relevant whitespace cases, and completed four passing tests without another approval.
- Review-only: identified the percentage-discount defect using six focused cases (three
  expected failures established the defect), reported it, and left fixture source unchanged.

Action journals are in [implementation](evaluations/6.4.2-custom.2-implementation.md) and
[review](evaluations/6.4.2-custom.2-review.md); detailed calls remain in the evaluation chats.
These are qualitative regression exercises, not a reliability or token-saving benchmark.
The agents did not exercise every changed reference or the visual browser interaction loop.

The optional live Claude harness was checked with fake executables and local CLI help;
no live Claude model/API evaluation or permission-enforcement test is claimed. Scenario
artifact checks require a successful completed result, reject review mutations, and preserve
failure evidence. Transcript review is still needed to judge review substance, redundant
work, and user-installed configuration effects. No new paid model service was used.

## Local release and rollback

Build the immutable marketplace at dist/6.4.2-custom.2 with the repository builder and use
the Codex plugin CLI as described in [installation](custom-installation.md). Confirm the
enabled version and compare all installed files with package-evidence.json. Keep
dist/6.4.2-custom.1 for rollback. A new Codex task picks up the updated skill catalog;
existing conversations can retain their earlier loaded instructions.
