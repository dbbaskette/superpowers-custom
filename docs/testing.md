# Testing the maintained fork

## Local release suite

Read the project's local CI instructions, inspect
`bash scripts/ci/tart-macos.sh --dry-run`, then run `bash scripts/ci/tart-macos.sh`.
The disposable macOS VM runs custom package and evaluation-harness checks, startup hooks,
SDD workspace helpers, Codex sync, OpenCode bootstrap checks, and the complete brainstorm
server suite, then builds the install artifact. Logs identify source state and environment.
Native Windows checks skip on macOS; no Windows runtime pass is implied.

For focused checks, use:

```bash
node --test tests/custom/*.test.mjs
bash tests/hooks/test-session-start.sh
bash tests/opencode/test-bootstrap-caching.sh
```

The custom harness test uses a fake CLI to check candidate selection, evidence retention,
failure propagation, and opt-in behavior. It does not contact a model.

## Behavioral evaluation

See [the scenario runner](../tests/claude-code/README.md) and
[skill evaluation guidance](../skills/writing-skills/testing-skills-with-subagents.md).
Live evaluation is opt-in and requires authorization for the actual runtime/usage.
Keep prompts and raw transcripts; report candidate hashes, outcomes, and limits. Independent
host-agent scenarios may also provide qualitative evidence when permitted.

Evaluate task outcomes and authority boundaries rather than fixed review counts, wording,
or particular tool names. Include counterexamples where a material choice needs user input.
Reuse evidence for unchanged behavior and rerun affected scenarios after meaningful fixes.

The original custom release's [evaluation record](custom-evaluation.md) is historical evidence.
It is not a benchmark for subsequent changes. Record new results with their release.

## Historical upstream tests

The optional upstream Drill harness is a separate repository, not included in this checkout
or local package. Older documents referring to `evals/README.md` describe an upstream setup.
Legacy recall/worktree experiments remain for history, outside this fork's default runner.
Do not reintroduce their retired process expectations to make them pass.
