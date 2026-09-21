# Selective integration of upstream v6.4.1

Source: obra/superpowers v6.4.1, commit 5bf4e78. Fork release: 6.4.1-custom.1.
The user approved integrating the recommended fixes while preserving the fork's workflow.

## Adopted

- Unmodified upstream SDD helpers: workspace ownership markers distinguish plans sharing a
  basename; review packages reject empty or non-descendant commit ranges; helper calls use
  Bash when package extraction has stripped executable bits.
- The upstream SDD workspace regression suite, including collisions, legacy workspace
  adoption, path normalization, invalid review ranges, and stripped executable permissions.
- Interpreter invocation corrections in the visual companion and root-cause tracing references.
- Adapted guidance: review a branch from its target merge base; plan checks for foreseeable
  edge cases; report meaningful unassessed behavior without inventing new feature requirements.
- Apply interpreter invocation guidance to future skill scripts.

## Preserved and deferred

All 14 skill identities, one combined substantial-work approval, explicit-only strict TDD,
optional permitted delegation, configured model choice, evidence reuse, and publication
boundaries remain. Custom contributor instructions, local packaging, licensing and attribution
remain in place.

Do not import the full Native execution rewrite or its task-start/task-done helpers:
our execution guidance already supports continuing through the plan. Defer the diagnostic
skill until its mandatory seven-analyst workflow and prohibition on proposing fixes are adapted.
OpenCode, Muse, and Qwen support remain outside this Codex-focused update.

This is a selective backport, not a merge of upstream ancestry. Future comparisons should
use the original v6.3.0 baseline and this adoption record to avoid losing deferred changes.
The version follows the reviewed upstream release, with a custom suffix identifying our fork.
It does not imply that every upstream feature was adopted.

## Verification

Run the SDD workspace suite, all custom packaging tests, startup hook tests, and Codex sync
regressions. Build with scripts/build-local-plugin.mjs and check the packaged file hashes.
Inspect instruction diffs for preservation of custom policy. Automated script tests do not
establish model behavior; no new independent model evaluation is claimed for this update.

Executed on 2026-09-21: all 24 SDD workspace assertions, all five custom packaging tests,
all six startup-hook checks, and the Codex sync regression suite passed. The six directly
backported files match v6.4.1 exactly. Custom workflow changes are additive guidance only;
the remaining entrypoints and contributor instructions match the fork's main branch.

Installed locally on 2026-09-21 through the Codex CLI as superpowers@superpowers-custom
6.4.1-custom.1, enabled. All 60 installed files match package hashes and source. Plugin
schema validation passed. The prior 6.3.0-custom.1 release directory remains available
for rollback. New Codex tasks pick up the updated skills; no fresh-session behavioral
evaluation is claimed here.
