#!/usr/bin/env bash
# Opt-in live scenarios. Assertions check artifacts; review transcripts for process quality.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/test-helpers.sh"
candidate="${SUPERPOWERS_EVAL_PLUGIN_DIR:-$(cd "$SCRIPT_DIR/../.." && pwd -P)}"
candidate="$(cd "$candidate" && pwd -P)"
export SUPERPOWERS_EVAL_PLUGIN_DIR="$candidate"
if [ "${SUPERPOWERS_RUN_MODEL_EVALS:-}" != 1 ]; then
    echo "Set SUPERPOWERS_RUN_MODEL_EVALS=1 only for an authorized live evaluation." >&2
    exit 2
fi
scenario="${1:-all}"
case "$scenario" in all|small-fix|approved-plan|review-only|evidence-reuse) ;; *) echo "Unknown scenario: $scenario" >&2; exit 2 ;; esac
export SUPERPOWERS_EVAL_RUN_DIR
SUPERPOWERS_EVAL_RUN_DIR="${SUPERPOWERS_EVAL_RUN_DIR:-$(mktemp -d "${TMPDIR:-/tmp}/superpowers-outcomes.XXXXXX")}"
mkdir -p "$SUPERPOWERS_EVAL_RUN_DIR"
SUPERPOWERS_EVAL_RUN_DIR="$(cd "$SUPERPOWERS_EVAL_RUN_DIR" && pwd -P)"
echo "Retaining fixtures and transcripts: $SUPERPOWERS_EVAL_RUN_DIR"
for name in small-fix approved-plan review-only evidence-reuse; do
    [ "$scenario" = all ] || [ "$scenario" = "$name" ] || continue
    fixture=$(mktemp -d "$SUPERPOWERS_EVAL_RUN_DIR/$name.XXXXXX")
    cd "$fixture"
    case "$name" in
        small-fix)
            printf '# Example\n\nInstall the packge.\n' > README.md
            prompt="Correct the typo in README.md."
            ;;
        approved-plan|review-only|evidence-reuse)
            printf 'export function add(a, b) { return a - b; }\n' > math.mjs
            cat > math.test.mjs <<'EOF'
import test from 'node:test';
import assert from 'node:assert/strict';
import {add} from './math.mjs';
test('adds positive, zero and negative values', () => {
  assert.equal(add(2, 3), 5);
  assert.equal(add(0, 0), 0);
  assert.equal(add(-2, 3), 1);
});
EOF
            if [ "$name" = approved-plan ]; then
                cat > PLAN.md <<'EOF'
# Approved implementation plan
Implement add(a, b) in math.mjs as numeric addition. Acceptance: positive,
zero, and negative inputs return the mathematical sum; no other operations.
The current draft fails its tests. Verify with node --test math.test.mjs.
EOF
                prompt="Implement the approved plan in PLAN.md and complete verification."
            elif [ "$name" = review-only ]; then
                prompt="Review math.mjs for correctness and report findings."
            else
                printf 'export function add(a, b) { return a + b; }\n' > math.mjs
                node --test math.test.mjs > verification.log
                node - > EVIDENCE.md <<'NODE'
const fs = require('node:fs'), crypto = require('node:crypto');
console.log('# Verification record\n\nnode --test math.test.mjs passed in this unchanged fixture.\n');
for (const name of ['math.mjs', 'math.test.mjs']) console.log(name + ': ' + crypto.createHash('sha256').update(fs.readFileSync(name)).digest('hex'));
console.log('\nRuntime: ' + process.version);
NODE
                prompt="Report the current implementation and verification status using EVIDENCE.md and the fixture."
            fi
            ;;
    esac
    # Snapshot all fixture inputs outside the agent's working directory.
    node - "$fixture" > "$fixture.before.json" <<'NODE'
const fs = require('node:fs'), path = require('node:path');
const root = process.argv[2];
console.log(JSON.stringify(Object.fromEntries(fs.readdirSync(root).map(n => [n, fs.readFileSync(path.join(root, n), 'utf8')]))));
NODE
    prompt="$prompt
Use workflow guidance from $candidate/skills/using-superpowers/SKILL.md and applicable candidate skills.
This is a disposable local fixture. Work only in this directory; do not publish, install dependencies,
use network services, change runtime settings, or delegate. Report results and verification limits."
    run_claude "$prompt" "${CLAUDE_PROMPT_TIMEOUT:-300}" \
        'Read,Write,Edit,Skill,Bash(node --test*),Bash(git diff*),Bash(git status*)' > "$fixture.session.jsonl"
    node - "$name" "$fixture" <<'NODE'
const fs = require('node:fs'), path = require('node:path'), assert = require('node:assert/strict');
const [name, root] = process.argv.slice(2);
const before = JSON.parse(fs.readFileSync(root + '.before.json'));
const events = fs.readFileSync(root + '.session.jsonl', 'utf8').trim().split('\n').map(line => JSON.parse(line));
const result = events.findLast(event => event.type === 'result');
assert.ok(result && result.subtype === 'success' && result.is_error === false, 'CLI did not report a successful completed turn');
if (name === 'small-fix') assert.equal(fs.readFileSync(path.join(root, 'README.md'), 'utf8'), '# Example\n\nInstall the package.\n');
if (name === 'approved-plan') {
  assert.equal(fs.readFileSync(path.join(root, 'math.test.mjs'), 'utf8'), before['math.test.mjs']);
  assert.equal(fs.readFileSync(path.join(root, 'PLAN.md'), 'utf8'), before['PLAN.md']);
}
if (name === 'review-only' || name === 'evidence-reuse') {
  assert.deepEqual(fs.readdirSync(root).sort(), Object.keys(before).sort());
  for (const [file, content] of Object.entries(before)) assert.equal(fs.readFileSync(path.join(root, file), 'utf8'), content);
}
NODE
    if [ "$name" = approved-plan ]; then
        node --test math.test.mjs
        node --input-type=module -e 'import assert from "node:assert/strict"; import * as m from "./math.mjs"; assert.deepEqual(Object.keys(m), ["add"]); assert.equal(m.add(9, -4), 5);'
    fi
    echo "Artifact checks passed: $name. Transcript assessment remains required."
done
