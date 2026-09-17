---
name: test-driven-development
description: "Apply red-green-refactor when the user or repository explicitly requests test-driven development."
---

# Explicit test-driven development

When TDD is requested, first write a focused test of the desired observable behavior and
confirm it fails for the intended missing behavior, not an environment or syntax error.
Implement the smallest sufficient change, confirm the test passes, then refactor while
preserving behavior. Expand to relevant integration checks at coherent boundaries.

Keep valid existing work. Do not delete an implementation merely because it was written
before a test. Add a regression test and use an isolated comparison or controlled mutation
when needed to prove that it detects the defect; preserve user changes throughout.

Tests should distinguish correct and incorrect behavior, not mirror implementation wording
or merely assert mock calls. Read writing-good-tests.md when choosing test seams or diagnosing
unhelpful tests; it is not a required reread before each assertion. Classify warnings and
failures honestly rather than requiring all tools to produce no diagnostic output.

Outside an explicit TDD workflow, use appropriate regression coverage and milestone checks;
test-first ordering is not a prerequisite for every feature, fix, or documentation edit.
