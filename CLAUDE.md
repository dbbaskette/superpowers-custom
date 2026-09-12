# Superpowers Custom contributor agreements

This is dbbaskette's maintained fork, not upstream. See docs/customization-policy.md for the
intentional policy differences and docs/upstream-contributing.md only when preparing an
explicitly requested upstream contribution. Never send fork customizations upstream.

Follow the approved task scope. Plan substantial new work and accept one combined spec/plan
approval; execute clear small changes directly. Use coherent test milestones and reuse valid
evidence for an unchanged tree/environment. Safe local fixture tests need no per-test approval.
Do not use paid model APIs for validation without authorization. Report behavioral evaluation
limits honestly. Preserve user changes, licenses, and platform-specific invariants.

Before installation, run node --test tests/custom/*.test.mjs and the relevant existing hook
tests. Build the install artifact with node scripts/build-local-plugin.mjs. Never hand-edit
installed caches. Publish/deploy only when authorized; no upstream PR is implied by fork work.
