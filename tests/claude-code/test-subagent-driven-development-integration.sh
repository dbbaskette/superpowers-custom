#!/usr/bin/env bash
# Compatibility entrypoint for the approved-plan outcome scenario.
# No fixed review order, commit count, tool name, or task-pasting policy is required.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
exec bash "$SCRIPT_DIR/test-workflow-outcomes.sh" approved-plan
