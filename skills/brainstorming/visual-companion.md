# Visual Companion Guide

Optional browser tool for visual brainstorming. Use when the user benefits from a mockup,
diagram, or comparison; ordinary requirements and tradeoffs can stay in chat. Existing user
authorization to use the companion is sufficient. Ask only for a missing material decision.

## Start and retain connection details

Resolve these scripts relative to this skill directory. Start with the project's root:

```bash
bash scripts/start-server.sh --project-dir /path/to/project --open
```

The response includes `url`, `screen_dir`, and `state_dir`. Preserve all three.
`--open` opens the browser when the first screen is written; share the complete URL as a
fallback. Its `?key=...` authenticates HTTP and WebSocket access. Never strip the key when
sharing the session URL. Subsequent requests use a cookie established by the first load.

The startup response is also in `state_dir/server-info`. With `--project-dir`, sessions live
under `.superpowers/brainstorm/` and mockups persist. Check that generated session data is
ignored by Git. Without a project directory, the session uses temporary storage.

The server must survive tool calls. Use the host's actual process-lifetime controls:

- Claude Code on Unix: the launcher normally backgrounds itself. On Windows it switches
  to foreground; use the Bash tool's background mechanism.
- Codex: the launcher detects `CODEX_CI` and selects foreground mode. Keep the returned
  execution session alive using the host's long-running command facility.
- Gemini and Copilot CLI: use `--foreground` with their background command mechanism.
- Other hosts: select foreground/background behavior based on the actual environment.

For a remote setup, choose a bind address and reachable URL host appropriate to the authorized
environment. `--host` controls binding and `--url-host` controls the printed hostname;
opening `0.0.0.0` exposes the listener beyond loopback. Preserve authentication.

## Show a screen

Check the session's state before publishing: `server-info` should exist and
`server-stopped` should not. If stopped, restart with the same `--project-dir` to reuse the
port and reconnect the existing tab. Default idle timeout is four hours, configurable with
`--idle-timeout-minutes`. If the state is stale or the URL fails, verify the actual process
or HTTP response before claiming the screen is available.

Write a fresh HTML file in `screen_dir` with the file-editing tool. The server serves the
newest file by modification time. Use semantic names and a new filename for each update,
such as `layout.html` and `layout-v2.html`; reusing names can confuse screen/event state.

Write an HTML fragment by default. The server adds its frame, styles, and interaction helper.
Full documents beginning with `<!DOCTYPE` or `<html` are served as complete pages with the
helper injected. Read [the markup catalog](visual-companion-markup.md) only when building
content that needs its classes or selection widgets. The underlying resources are
`scripts/frame-template.html` and `scripts/helper.js`.

## Feedback and continuation

Explain what the screen shows. Pause when a visual choice materially affects the design and
has not already been decided. Batch related choices where helpful. An informational screen,
an approved design, or an already-authorized implementation does not require another turn
or approval. Continue independent authorized work while a necessary answer is pending.

When the user responds, read `state_dir/events` if present and combine it with their message.
Events are JSON lines, for example:

```json
{"type":"click","choice":"a","text":"Option A - Simple Layout","timestamp":1706000101}
```

The event file clears when a new screen is pushed, so read needed feedback before replacing
the screen. Multiple clicks may represent exploration; use the user's explicit message to
resolve ambiguous selections. No events means there may have been no browser interaction.

For changed feedback, publish a new version. When leaving a resolved screen would confuse the
user, show a short waiting/status fragment. Avoid ceremonial waiting screens and repeated URL
messages when the existing tab and context suffice.

## Finish

```bash
bash scripts/stop-server.sh "$SESSION_DIR"
```

Stop only this task's session. Project-backed mockups persist for later reference; temporary
sessions are cleaned up by the stop script. Report retained artifacts when useful.
