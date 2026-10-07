import test from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import {spawnSync} from 'node:child_process';
import {fileURLToPath} from 'node:url';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '../..');
test('evaluation pins the candidate, retains evidence, and propagates failures', () => {
  const temp = fs.mkdtempSync(path.join(os.tmpdir(), 'superpowers-eval-invocation-'));
  try {
    const bin = path.join(temp, 'bin'), candidate = path.join(temp, 'candidate with spaces');
    fs.mkdirSync(bin); fs.mkdirSync(candidate);
    for (const name of ['skills', 'hooks', '.claude-plugin']) fs.cpSync(path.join(root, name), path.join(candidate, name), {recursive: true});
    fs.writeFileSync(path.join(bin, 'claude'), '#!/bin/sh\nif [ "$1" = --version ]; then echo fake-cli; exit 0; fi\nprintf "%s\\n" "$@"\necho fake-diagnostic >&2\nexit "${FAKE_EXIT:-0}"\n', {mode: 0o755});
    fs.writeFileSync(path.join(bin, 'timeout'), '#!/bin/sh\nshift\nexec "$@"\n', {mode: 0o755});
    const env = {...process.env, PATH: `${bin}:${process.env.PATH}`, SUPERPOWERS_EVAL_PLUGIN_DIR: candidate, SUPERPOWERS_EVAL_RUN_DIR: path.join(temp, 'evidence'), SUPERPOWERS_RUN_MODEL_EVALS: '1'};
    const command = 'source "$1"; run_claude "literal prompt" 10 Read';
    const args = ['-c', command, 'evaluation-test', path.join(root, 'tests/claude-code/test-helpers.sh')];
    for (const code of [0, 7]) {
      const result = spawnSync('bash', args, {env: {...env, FAKE_EXIT: String(code)}, encoding: 'utf8'});
      assert.equal(result.status, code, result.stderr);
      const evidence = fs.readdirSync(env.SUPERPOWERS_EVAL_RUN_DIR).map(n => path.join(env.SUPERPOWERS_EVAL_RUN_DIR, n)).find(dir => fs.readFileSync(path.join(dir, 'exit-code.txt'), 'utf8').trim() === String(code));
      assert.ok(evidence);
      const argv = fs.readFileSync(path.join(evidence, 'transcript.jsonl'), 'utf8').trim().split('\n');
      assert.equal(argv[argv.indexOf('--plugin-dir') + 1], fs.realpathSync(candidate));
      assert.equal(argv[argv.indexOf('--permission-mode') + 1], 'dontAsk');
      assert.equal(argv.includes('--dangerously-skip-permissions'), false);
      assert.equal(fs.readFileSync(path.join(evidence, 'prompt.txt'), 'utf8'), 'literal prompt\n');
      assert.match(fs.readFileSync(path.join(evidence, 'stderr.txt'), 'utf8'), /fake-diagnostic/);
      const recorded = JSON.parse(fs.readFileSync(path.join(evidence, 'candidate.json'), 'utf8'));
      assert.equal(recorded.root, fs.realpathSync(candidate));
      assert.ok(recorded.files.some(f => f.path === 'skills/using-superpowers/SKILL.md' && /^[a-f0-9]{64}$/.test(f.sha256)));
    }
    const before = fs.readdirSync(env.SUPERPOWERS_EVAL_RUN_DIR);
    const rejected = spawnSync('bash', args, {env: {...env, SUPERPOWERS_RUN_MODEL_EVALS: ''}, encoding: 'utf8'});
    assert.equal(rejected.status, 2);
    assert.deepEqual(fs.readdirSync(env.SUPERPOWERS_EVAL_RUN_DIR), before);
  } finally {
    fs.rmSync(temp, {recursive: true, force: true});
  }
});

test('review scenario rejects CLI error results and unauthorized fixture changes', () => {
  const temp = fs.realpathSync(fs.mkdtempSync(path.join(os.tmpdir(), 'superpowers-outcome-check-')));
  try {
    const bin = path.join(temp, 'bin'); fs.mkdirSync(bin);
    fs.writeFileSync(path.join(bin, 'claude'), '#!/bin/sh\nif [ "$1" = --version ]; then echo fake-cli; exit 0; fi\nif [ "${FAKE_MUTATE:-}" = 1 ]; then printf broken > math.mjs; fi\nprintf "%s\\n" "$FAKE_RESULT"\n', {mode: 0o755});
    fs.writeFileSync(path.join(bin, 'timeout'), '#!/bin/sh\nshift\nexec "$@"\n', {mode: 0o755});
    for (const [name, event, mutate, expected] of [
      ['completed', {type: 'result', subtype: 'success', is_error: false}, '', 0],
      ['runtime-error', {type: 'result', subtype: 'error_during_execution', is_error: true}, '', 1],
      ['incomplete', {type: 'assistant', message: 'Starting now'}, '', 1],
      ['mutation', {type: 'result', subtype: 'success', is_error: false}, '1', 1],
    ]) {
      const evidence = path.join(temp, name);
      const result = spawnSync('bash', [path.join(root, 'tests/claude-code/test-workflow-outcomes.sh'), 'review-only'], {
        cwd: temp,
        encoding: 'utf8',
        env: {...process.env, PATH: `${bin}:${process.env.PATH}`, SUPERPOWERS_RUN_MODEL_EVALS: '1', SUPERPOWERS_EVAL_PLUGIN_DIR: path.relative(temp, root), SUPERPOWERS_EVAL_RUN_DIR: name, FAKE_RESULT: JSON.stringify(event), FAKE_MUTATE: mutate},
      });
      assert.equal(result.status === 0 ? 0 : 1, expected, result.stderr);
      assert.ok(fs.readdirSync(evidence).some(n => n.endsWith('.session.jsonl')));
    }
  } finally { fs.rmSync(temp, {recursive: true, force: true}); }
});
