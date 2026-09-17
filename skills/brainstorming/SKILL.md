---
name: brainstorming
description: "Resolve design choices and define a spec for a substantial new feature or architectural change."
---

# Design before substantial implementation

Read the relevant code and clarify only decisions that materially affect the result. For a
substantial feature, define the outcome, acceptance criteria, constraints, interfaces, risks,
and meaningful alternatives. Use the simplest sufficient design, not a fixed number of options.

Prepare the spec and implementation plan together. Default locations are
docs/superpowers/specs/ and docs/superpowers/plans/; honor project preferences. Present both
for one approval before implementing substantial unapproved work. Do not demand section-by-section
approvals or another approval when the same scope is already accepted. Use writing-plans
for task dependencies and verification ownership, not for a mandatory second gate.

A clear small fix or an explicitly authorized investigation needs proportionate explanation,
not a design ceremony. A spike answers a question; retaining a new feature from it needs scope
authorization. If new information materially changes approved scope, explain and seek a decision.

For visual decisions, use an available visualization only when it helps. The optional
visual-companion.md describes the bundled browser tool; read it only if choosing that tool.
Text remains sufficient for nonvisual questions. Do not require a browser session for every UI task.
