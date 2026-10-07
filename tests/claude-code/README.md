# Workflow checks

The default runner performs local infrastructure checks without contacting a model:

```bash
bash tests/claude-code/run-skill-tests.sh
```

The full project suite uses `bash scripts/ci/tart-macos.sh`.

## Optional live scenarios

Only run when the model runtime and any associated usage are authorized:

```bash
SUPERPOWERS_RUN_MODEL_EVALS=1 bash tests/claude-code/run-skill-tests.sh --integration
```

The candidate defaults to this checkout. Set `SUPERPOWERS_EVAL_PLUGIN_DIR` to another
candidate root when comparing revisions. Each invocation passes `--plugin-dir` and records
the candidate's source hashes, runtime version, prompt, raw JSONL, stderr, and exit code
under `SUPERPOWERS_EVAL_RUN_DIR` (a retained temporary directory by default).
No model override is imposed. Inspect runtime initialization and loaded skill paths in
the transcript: user-installed customizations can still affect a CLI session.

The runner uses normal permission controls with an explicit tool allowlist, no external MCP
servers, and disposable fixtures. It does not create an OS sandbox; use an isolated runtime
when evaluating untrusted instructions. The fixture prompt limits side effects to its directory.

Scenarios cover a small documentation fix, an approved plan with failing tests, review-only
scope, and reporting existing verification evidence. Artifact assertions verify results and
input preservation. Read the transcripts to judge unnecessary approvals, repeated tests,
skill source selection, and the substance of review findings. A passing artifact check is
not a claim that every process decision was correct. Keep that qualitative judgment in the
release evidence.

The old SDD filenames remain compatibility wrappers. They no longer demand two ordered
review passes, a worktree, pasted task text, or per-task commits. The approved-plan scenario
runs without delegation and does not establish multi-agent execution reliability.

`test-worktree-native-preference.sh` and `test-worktree-path-policy.sh` are historical
upstream experiments, excluded from the maintained runner. Their wording checks and fixed
tool expectations are not release gates for this fork. Current worktree helper behavior is
covered by `test-sdd-workspace.sh`.
