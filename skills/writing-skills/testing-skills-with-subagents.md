# Behavioral evaluation of skills

Use when changed instructions could materially alter decisions. The parent writing-skills
entrypoint defines the workflow; this reference supplies scenario design, not an additional
approval or mandatory TDD stage.

## Design a useful scenario

Choose realistic inputs that expose the changed decision: a small fix, an approved plan with
a failing local test, a review-only request, an already-tested tree, a material scope change,
or a dependency that blocks only part of the work. Include a counterexample where extra
planning, review, or user input is actually needed.

Give an independent permitted evaluator the user request, candidate skill paths, and minimum
raw artifacts. Do not include the expected answer or prior review findings. Use disposable
fixtures and state the permitted side effects. Respect host delegation and provider limits;
do not start paid model calls or use new credentials merely because an evaluation is useful.

A baseline comparison can reveal whether the change helps; it is optional when the previous
failure is already demonstrated. Preserve existing implementation. There is no required
number of model runs or requirement to manufacture a failing baseline before editing prose.

## Observe outcomes

Prefer actions and artifacts over a description of the skill. Record:

- Candidate commit/tree and actual skill source loaded.
- Runtime/model when available, prompt, raw transcript, outputs, and exit status.
- Whether the task's acceptance criteria and authority boundaries were respected.
- Unnecessary approvals, repeated reads/tests, abandoned work, or missed verification.

Judge against the user's task, allowing valid alternative workflows. Do not fail a scenario
because it uses one combined review, an appropriate existing checkout, a task brief file, or
a different permitted tool. A response repeating the intended policy is weak evidence.

## Interpret and iterate

Fix a demonstrated decision problem with a scoped instruction change. Rerun the affected
scenario; reuse unrelated evidence. Treat small scenario samples as qualitative evidence,
not proof of reliability or token savings. Token comparisons need matched tasks and models,
and must count worker activity as well as the coordinator.

Keep raw evidence outside production artifacts, with a concise result record in the repository.
If no independent runtime was exercised, say so. Packaging, metadata, and script tests remain
useful but measure different outcomes.

Historical examples in `examples/CLAUDE_MD_TESTING.md` and `persuasion-principles.md`
illustrate earlier experiments; their universal process or pressure language is not this
fork's operating policy. Consult them only when studying that history.
