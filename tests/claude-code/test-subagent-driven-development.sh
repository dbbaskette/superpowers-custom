#!/usr/bin/env bash
# Compatibility entrypoint: retired recall assertions are replaced by outcome scenarios.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
exec bash "$SCRIPT_DIR/test-workflow-outcomes.sh" all
