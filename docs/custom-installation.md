# Maintained Superpowers fork

Source: https://github.com/dbbaskette/superpowers-custom
Upstream: https://github.com/obra/superpowers
Baseline: b36e0829c6d0140e93cfef2ca599b1b07d4a7797 (6.3.0).
The plugin identity remains superpowers; the marketplace identity is superpowers-custom.

## Build and install

From this checkout, run the validation commands in custom-evaluation.md, then:

```sh
node scripts/build-local-plugin.mjs
codex plugin marketplace add /Users/dbbaskette/Projects/superpowers-custom/dist/6.3.0-custom.1
codex plugin add superpowers@superpowers-custom
codex plugin list --json
```

Back up existing installed Superpowers cache directories outside skill discovery before
removing duplicate installations. Remove only exact installed Superpowers identifiers,
not their whole marketplace. Start a new Codex task after changing installed skills.
The source checkout is not the installable marketplace: use the generated release tree.
Do not edit plugin caches directly. package-evidence.json records hashes of packaged files.

## Updates

Fetch upstream and inspect changes on a branch. Port useful changes deliberately; do not
automatically overwrite custom workflow policy. Review all affected skill entrypoints and
run relevant packaging, hook, metadata and behavioral checks. Keep upstream attribution.
Commit source changes and keep each published artifact immutable. For routine local
reinstallation use plugin-creator's update_plugin_cachebuster.py on the source manifest,
then build a new artifact directory. Read the generated marketplace name using its
read_marketplace_name.py helper, register that release root with the marketplace CLI,
and reinstall from the confirmed local marketplace. Never hand-edit installed config.
For a meaningful release increment the custom prerelease number and record its changes.

## Rollback

Retain the previous generated release directory. Register that directory as the local
marketplace again and reinstall superpowers@superpowers-custom, then start a new task.
To return to upstream, remove the custom plugin and reinstall the exact previously
recorded upstream identifier (for example superpowers@superpowers-dev). Review cache
backups for local modifications before restoring; do not overwrite unrelated settings.

Codex is the installation target. Claude metadata and shared startup hooks remain
compatible and tested, but no Claude installation is changed by this procedure.
