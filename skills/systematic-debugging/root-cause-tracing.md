# Root cause tracing

Use when the error appears far from the invalid input or state transition.

1. Capture the actual error and the operation that emitted it.
2. Trace its inputs and callers backward, comparing a working path.
3. Form a falsifiable hypothesis about where valid state becomes invalid.
4. Run the smallest safe diagnostic that distinguishes that cause from alternatives.
5. When authorized to fix, correct the responsible contract and add regression coverage.

For example, `git init` running in the source directory may be caused by an empty `cwd`.
Trace that value back through workspace creation to test setup. If setup exposes an empty
directory before initialization, correcting that lifecycle is more useful than hiding the
Git error. Validate additional boundaries only where an independent caller can bypass the fix;
see [boundary validation](defense-in-depth.md) when that risk exists.

## Instrumentation

Add temporary stack traces or structured diagnostics at the uncertain boundary. Record only
the necessary non-secret values, such as a redacted path or state transition; do not dump
environment variables, tokens, or complete request objects. Use a logger visible in the test
environment and remove temporary noisy instrumentation after diagnosis.

Capture the command's exit status as well as the relevant output. A filtered log alone does
not establish that a test passed.

## Test pollution

When an artifact appears during tests and its source is unknown, inspect
`find-polluter.sh` before choosing it. It runs tests one by one and stops at the first test
that creates the named artifact:

```bash
bash ./find-polluter.sh '.git' 'src/**/*.test.ts'
```

Run it in disposable test storage. An order-dependent failure may require preserving the
triggering sequence; individual runs do not rule out interactions.

## Stopping condition

Verify the original symptom and relevant surrounding behavior. If the upstream cause is
outside the available scope, document the evidence and distinguish a justified containment
fix from a root-cause repair. Do not keep tracing indefinitely or rewrite architecture simply
because several hypotheses failed.
