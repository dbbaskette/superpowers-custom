#!/usr/bin/env bash
set -euo pipefail
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
source_dir="/Volumes/My Shared Files/source"
results_dir="/Volumes/My Shared Files/results"
exec > "$results_dir/suite.log" 2>&1
trap 'rc=$?; printf "%s\n" "$rc" > "$results_dir/suite-exit-code.txt"' EXIT
sw_vers
node --version
npm --version
git --version
bash --version
git -C "$source_dir" rev-parse HEAD
git -C "$source_dir" status --short
scratch="$(mktemp -d)"
# The shared runner destroys this disposable VM and its scratch files after the run.
mkdir "$scratch/project"
rsync -a --exclude=.git --exclude=dist --exclude=node_modules "$source_dir/" "$scratch/project/"
cd "$scratch/project"
git init -q -b main
git add -A
git -c user.name=CI -c user.email=ci@example.invalid -c commit.gpgsign=false commit -qm "CI source snapshot"
node --test tests/custom/*.test.mjs
bash tests/hooks/test-session-start.sh
bash tests/hooks/test-run-hook-cmd-windows.sh
bash tests/claude-code/test-sdd-workspace.sh
bash tests/codex-plugin-sync/test-sync-to-codex-plugin.sh
bash tests/opencode/test-plugin-loading.sh
bash tests/opencode/test-bootstrap-caching.sh
npm ci --prefix tests/brainstorm-server --ignore-scripts --no-audit --no-fund
npm test --prefix tests/brainstorm-server
node scripts/build-local-plugin.mjs
printf 'PASS\n' > "$results_dir/result.txt"
