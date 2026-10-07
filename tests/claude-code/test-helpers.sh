#!/usr/bin/env bash
# Helper functions for Claude Code skill tests

# Run Claude Code with a prompt and capture output
# Usage: run_claude "prompt text" [timeout_seconds] [allowed_tools]
run_claude() {
    local prompt="$1"
    local timeout="${2:-60}"
    local allowed_tools="${3:-}"
    if [ "${SUPERPOWERS_RUN_MODEL_EVALS:-}" != 1 ]; then
        echo "Live model evaluation is opt-in: set SUPERPOWERS_RUN_MODEL_EVALS=1 after authorizing runtime usage." >&2
        return 2
    fi
    local candidate
    candidate="${SUPERPOWERS_EVAL_PLUGIN_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd -P)}"
    candidate="$(cd "$candidate" && pwd -P)" || return 2
    [ -f "$candidate/.claude-plugin/plugin.json" ] || { echo "Invalid candidate plugin: $candidate" >&2; return 2; }
    local evidence_root="${SUPERPOWERS_EVAL_RUN_DIR:-${TMPDIR:-/tmp}}"
    mkdir -p "$evidence_root"
    local evidence_dir
    evidence_dir=$(mktemp -d "$evidence_root/superpowers-eval.XXXXXX")
    local output_file="$evidence_dir/transcript.jsonl"
    printf '%s\n' "$prompt" > "$evidence_dir/prompt.txt"
    node - "$candidate" > "$evidence_dir/candidate.json" <<'NODE' || return 2
const fs = require('node:fs'), path = require('node:path'), crypto = require('node:crypto');
const root = process.argv[2], files = [];
function walk(relative) {
  const absolute = path.join(root, relative), stat = fs.lstatSync(absolute);
  if (stat.isSymbolicLink()) throw new Error('Candidate symlinks need review: ' + relative);
  if (stat.isDirectory()) for (const name of fs.readdirSync(absolute).sort()) walk(path.join(relative, name));
  else files.push({path: relative, sha256: crypto.createHash('sha256').update(fs.readFileSync(absolute)).digest('hex')});
}
for (const relative of ['skills', 'hooks', '.claude-plugin/plugin.json']) walk(relative);
console.log(JSON.stringify({root, version: JSON.parse(fs.readFileSync(path.join(root, '.claude-plugin/plugin.json'))).version, files}, null, 2));
NODE
    claude --version > "$evidence_dir/runtime.txt" 2>&1 || return 2

    # Build command as an argv array so timeout wraps claude directly.
    local cmd=(claude -p "$prompt" --plugin-dir "$candidate" --add-dir "$candidate"
        --output-format stream-json --verbose --no-session-persistence
        --strict-mcp-config --mcp-config '{"mcpServers":{}}'
        --tools 'Read,Write,Edit,Bash,Skill' --permission-mode dontAsk)
    if [ -n "$allowed_tools" ]; then
        cmd+=(--allowed-tools="$allowed_tools")
    fi

    # Run Claude in headless mode with timeout
    echo "Candidate: $candidate; evidence: $evidence_dir" >&2
    if timeout "$timeout" "${cmd[@]}" > "$output_file" 2> "$evidence_dir/stderr.txt"; then
        cat "$output_file"
        printf '0\n' > "$evidence_dir/exit-code.txt"
        return 0
    else
        local exit_code=$?
        cat "$output_file" >&2
        cat "$evidence_dir/stderr.txt" >&2
        printf '%s\n' "$exit_code" > "$evidence_dir/exit-code.txt"
        return $exit_code
    fi
}

# Check if output contains a pattern
# Usage: assert_contains "output" "pattern" "test name"
# Matching is case-insensitive: patterns are prose keywords, and models
# freely capitalize skill terms ("Do Not Trust", "Spec Compliance").
assert_contains() {
    local output="$1"
    local pattern="$2"
    local test_name="${3:-test}"

    if echo "$output" | grep -qi "$pattern"; then
        echo "  [PASS] $test_name"
        return 0
    else
        echo "  [FAIL] $test_name"
        echo "  Expected to find: $pattern"
        echo "  In output:"
        echo "$output" | sed 's/^/    /'
        return 1
    fi
}

# Check if output does NOT contain a pattern
# Usage: assert_not_contains "output" "pattern" "test name"
assert_not_contains() {
    local output="$1"
    local pattern="$2"
    local test_name="${3:-test}"

    if echo "$output" | grep -qi "$pattern"; then
        echo "  [FAIL] $test_name"
        echo "  Did not expect to find: $pattern"
        echo "  In output:"
        echo "$output" | sed 's/^/    /'
        return 1
    else
        echo "  [PASS] $test_name"
        return 0
    fi
}

# Check if output matches a count
# Usage: assert_count "output" "pattern" expected_count "test name"
assert_count() {
    local output="$1"
    local pattern="$2"
    local expected="$3"
    local test_name="${4:-test}"

    local actual=$(echo "$output" | grep -ci "$pattern" || echo "0")

    if [ "$actual" -eq "$expected" ]; then
        echo "  [PASS] $test_name (found $actual instances)"
        return 0
    else
        echo "  [FAIL] $test_name"
        echo "  Expected $expected instances of: $pattern"
        echo "  Found $actual instances"
        echo "  In output:"
        echo "$output" | sed 's/^/    /'
        return 1
    fi
}

# Check if pattern A appears before pattern B
# Usage: assert_order "output" "pattern_a" "pattern_b" "test name"
assert_order() {
    local output="$1"
    local pattern_a="$2"
    local pattern_b="$3"
    local test_name="${4:-test}"

    # Get line numbers where patterns appear
    local line_a=$(echo "$output" | grep -ni "$pattern_a" | head -1 | cut -d: -f1)
    local line_b=$(echo "$output" | grep -ni "$pattern_b" | head -1 | cut -d: -f1)

    if [ -z "$line_a" ]; then
        echo "  [FAIL] $test_name: pattern A not found: $pattern_a"
        echo "  In output:"
        echo "$output" | sed 's/^/    /'
        return 1
    fi

    if [ -z "$line_b" ]; then
        echo "  [FAIL] $test_name: pattern B not found: $pattern_b"
        echo "  In output:"
        echo "$output" | sed 's/^/    /'
        return 1
    fi

    if [ "$line_a" -lt "$line_b" ]; then
        echo "  [PASS] $test_name (A at line $line_a, B at line $line_b)"
        return 0
    else
        echo "  [FAIL] $test_name"
        echo "  Expected '$pattern_a' before '$pattern_b'"
        echo "  But found A at line $line_a, B at line $line_b"
        return 1
    fi
}

# Create a temporary test project directory
# Usage: test_project=$(create_test_project)
create_test_project() {
    local test_dir=$(mktemp -d)
    echo "$test_dir"
}

# Cleanup test project
# Usage: cleanup_test_project "$test_dir"
cleanup_test_project() {
    local test_dir="$1"
    if [ -d "$test_dir" ]; then
        rm -rf "$test_dir"
    fi
}

# Create a simple plan file for testing
# Usage: create_test_plan "$project_dir" "$plan_name"
create_test_plan() {
    local project_dir="$1"
    local plan_name="${2:-test-plan}"
    local plan_file="$project_dir/docs/superpowers/plans/$plan_name.md"

    mkdir -p "$(dirname "$plan_file")"

    cat > "$plan_file" <<'EOF'
# Test Implementation Plan

## Task 1: Create Hello Function

Create a simple hello function that returns "Hello, World!".

**File:** `src/hello.js`

**Implementation:**
```javascript
export function hello() {
  return "Hello, World!";
}
```

**Tests:** Write a test that verifies the function returns the expected string.

**Verification:** `npm test`

## Task 2: Create Goodbye Function

Create a goodbye function that takes a name and returns a goodbye message.

**File:** `src/goodbye.js`

**Implementation:**
```javascript
export function goodbye(name) {
  return `Goodbye, ${name}!`;
}
```

**Tests:** Write tests for:
- Default name
- Custom name
- Edge cases (empty string, null)

**Verification:** `npm test`
EOF

    echo "$plan_file"
}

# Export functions for use in tests
export -f run_claude
export -f assert_contains
export -f assert_not_contains
export -f assert_count
export -f assert_order
export -f create_test_project
export -f cleanup_test_project
export -f create_test_plan
