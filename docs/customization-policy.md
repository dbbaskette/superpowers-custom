# Maintained customization policy

This fork belongs to dbbaskette and deliberately differs from upstream process policy.
Upstream source: obra/superpowers, baseline b36e0829c6d0140e93cfef2ca599b1b07d4a7797 (6.3.0).
Retain upstream license and attribution. Internal skill namespace remains superpowers.

Default: spec plus implementation plan for substantial work, one combined approval, then
execution through verification. Clear small fixes and already-approved plans do not require
another ceremony. Skills are model-neutral and honor host tool/authority boundaries.
Verification has one owner per outcome; changed code invalidates affected evidence, not all
evidence. Required CI remains. No approval bypass, silent scope change, secret disclosure,
paid-provider substitution, force-push, or unsafe worktree cleanup is implied.

The owner approved this customization in the IssueBot conversation after observing repeated
approvals and redundant verification. This is not an upstream contribution. Do not submit
fork policy upstream or imply endorsement by upstream maintainers.

Update process: fetch upstream; inspect changes on a maintenance branch; merge or cherry-pick
selectively; validate packaging and behavioral scenarios; review the diff; release a new
custom prerelease version and reinstall from a reproducible local build. Never edit an installed
cache as the source of truth. Preserve progress and back up installations before replacement.
