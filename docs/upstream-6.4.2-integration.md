# Superpowers Custom 6.4.2-custom.1

Reviewed upstream release: v6.4.2 (8ca22dba). This update selectively backports
post-release development fixes as requested; it does not merge upstream ancestry.

## Sources

- 19e54c0 / 2b7893a: preserve an existing workspace .gitignore and normalize the root
  physically for Windows plan markers; regression suite through c88ba76.
- ddd35ab: insert visual companion content literally, with its regression test.
- bccb109 / a0415da: test teardown and non-login shell fixes for reliable server tests.
- 0a8cefe: startup hook resolution with empty PATH, retaining the Windows output workaround.
- 35ce949: Windows Bash discovery, current-directory exclusion, and exit-code propagation;
  includes Windows-only regression tests and documentation.

Our concise planning skill already follows the main v6.4.2 planning principle. All custom
workflow entrypoints remain unchanged. Keep CLAUDE.md because our AGENTS.md links to it.
No upstream brainstorming rewrite, new execution helpers, or harness expansion is adopted.

## Verification

Use bash scripts/ci/tart-macos.sh --dry-run, then bash scripts/ci/tart-macos.sh.
The shared runner clones the stopped base, runs the guest checks, retains logs and removes
its VM. The guest records environment and source state, copies source into disposable
storage, runs custom packaging, hooks, SDD workspace, Codex sync, and the complete
brainstorm-server suite, then builds the package. Native Windows checks skip on macOS;
their inclusion is not a claim of Windows runtime verification. No model evaluation is claimed.

On 2026-10-06, the complete guest suite passed on macOS 27.0 (26A428), Node 22.23.2,
npm 10.9.8, Git 2.54.0 and Bash 3.2.57. The tested tree was fork main ae60235 plus
this integration's source changes; only this verification note was added afterward.
Windows-only checks skipped as expected. The shared runner stopped and deleted its clone.
Host logs are in ~/Library/Logs/MacOS Test Suite/superpowers-custom/
superpowers-custom-test-20261007013145-18106-93c529ba/ (directory timestamp is UTC).
All 60 files in the locally built release match the source and package hashes.
