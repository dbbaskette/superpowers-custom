#!/usr/bin/env bash
set -euo pipefail
project_root="$(cd "$(dirname "$0")/../.." && pwd -P)"
exec env TART_NO_AUTO_PRUNE=1 bash /Users/dbbaskette/Projects/macos-test-suite/scripts/tart-test-vm.sh \
  --project "$project_root" --name superpowers-custom --guest scripts/ci/guest-test.sh \
  --base tanzu-brand-golden-gate-base --auto "$@"
