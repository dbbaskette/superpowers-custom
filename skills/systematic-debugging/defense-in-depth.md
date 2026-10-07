# Validation at meaningful boundaries

Use this reference when multiple callers or trust boundaries can independently introduce
invalid data. Trace the supported failure first; choose validation points from actual bypass
paths rather than adding the same check to every internal function.

- Validate external input at the boundary that owns its contract.
- Guard dangerous side effects when another caller can bypass earlier validation.
- Preserve an invariant inside a module when its entry contract does not already establish it.
- Add focused diagnostics only when they help distinguish unresolved causes; redact secrets.

For an empty working-directory bug, rejecting an empty value at the public entrypoint may
be sufficient. A separately callable Git operation may also need a guard. Explain what each
additional check catches and test those distinct paths. Passing tests support those cases;
they do not prove that a bug is impossible.

## Filesystem containment example

For an existing directory, resolve symbolic links and compare path components. A string
prefix treats sibling paths such as `/tmp-other` as descendants of `/tmp`.

```javascript
import { realpathSync } from 'node:fs';
import { isAbsolute, relative, sep } from 'node:path';

function isStrictDescendant(root, directory) {
  const delta = relative(realpathSync(root), realpathSync(directory));
  return delta !== '' && delta !== '..' &&
    !delta.startsWith('..' + sep) && !isAbsolute(delta);
}
```

This rejects the root itself and symlinks leading outside it. It requires existing paths and
is an illustrative preflight, not protection against concurrent filesystem replacement.
Use a disposable workspace for tests of Git side effects. Strong adversarial filesystem
boundaries need an operation-level design appropriate to the platform.

Verify that valid inputs still work and the supported invalid/bypass cases are rejected.
Prefer one clear owner for each invariant; add layers only for distinct failure modes.
