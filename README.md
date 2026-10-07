# Superpowers Custom

Maintained fork of [obra/superpowers](https://github.com/obra/superpowers).
Plugin identity: `superpowers`. Marketplace: `superpowers-custom`.

## Workflow

Use the process the task needs:

- Clear small fixes proceed directly, with appropriate regression checks.
- Substantial unapproved features get a spec and implementation plan with one combined approval.
- Approved work continues through implementation, diagnosis, verification, and any requested publication.
- Strict TDD applies when the user or repository requests it.
- Delegation requires permission and a useful division of work. Reviews cover coherent milestones;
  one owner runs final integrated checks and reuses valid evidence.
- Review and diagnosis requests stay within their requested scope.

The 14 skills remain independently usable. Start with `executing-plans` for an approved plan;
use `subagent-driven-development` when assigning implementation to permitted workers, and
`dispatching-parallel-agents` for coordination across independent workstreams. These are choices
for the current task, not a sequence of required skill loads.

## Install and update

Follow [custom installation](docs/custom-installation.md). Build a versioned local marketplace
with `node scripts/build-local-plugin.mjs`; install that artifact through the Codex plugin CLI.
Do not edit installed caches. Keep the previous artifact for rollback and start a new task
to use the updated skill catalog.

Codex is our local installation target. The repository retains other platform adapters;
their presence does not establish live verification on those platforms.

## Maintain and verify

- [Customization policy](docs/customization-policy.md)
- [Testing and evaluation](docs/testing.md)
- [Original custom evaluation](docs/custom-evaluation.md)
- [Current workflow release](docs/workflow-tightening-release.md)

Run the project's full local suite with `bash scripts/ci/tart-macos.sh` after inspecting
`--dry-run`. It uses a disposable VM and retains logs. Live model scenarios are separate:
record the candidate revision, raw transcripts, observed outcomes, and evaluation limits.
Script and packaging tests do not prove model behavior or efficiency gains.

Fork PRs target this repository's `main`. User authorization determines publication;
never submit fork policy to upstream as an implied part of this workflow.

## Upstream and license

Superpowers was created by Jesse Vincent and contributors. This fork preserves the
[MIT license](LICENSE) and upstream attribution. [Historical upstream documentation](UPSTREAM-README.md)
describes upstream workflows and installation, not the maintained fork's defaults.
Read [upstream contribution guidance](docs/upstream-contributing.md) only for an explicitly
requested upstream contribution.
