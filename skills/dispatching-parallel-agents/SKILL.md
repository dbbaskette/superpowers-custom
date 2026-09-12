---
name: dispatching-parallel-agents
description: "Coordinate permitted parallel work across independent tasks with nonoverlapping ownership."
---

# Parallel work

Delegate only when the user/host permits it and multiple bounded tasks can progress
independently. Related failures may share a cause; investigate that before splitting them.
Do not parallelize writes to shared files, Git state, fixtures, or deployments without isolation.

Give each worker a clear outcome, permitted files/actions, relevant raw context, dependencies,
and reporting expectations. Preserve the configured model unless a supported override is
requested. Avoid passing the whole conversation when a focused brief suffices.

The coordinator owns integration and final verification. Workers run their focused checks;
do not give each worker and reviewer the same full-suite assignment. Prevent duplicate
delegation by making ownership explicit. Keep working locally while useful work remains;
otherwise use bounded event-driven waits that meet the host's communication requirements.

Inspect returned changes for conflicts and acceptance gaps, then verify the integrated result.
Honor dependencies before starting consumers. Delegation does not grant workers additional
publication, credential, paid-service, or destructive-action authority.
