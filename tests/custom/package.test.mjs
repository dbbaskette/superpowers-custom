import test from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import {fileURLToPath} from 'node:url';
import {execFileSync} from 'node:child_process';
import {build} from '../../scripts/build-local-plugin.mjs';

const source=path.resolve(path.dirname(fileURLToPath(import.meta.url)),'../..');
test('package contains all skill sources, assets and compatible hook output',()=>{
 const temp=fs.mkdtempSync(path.join(os.tmpdir(),'superpowers-package-'));
 try{
  const output=path.join(temp,'release');const result=build(source,output);
  const market=JSON.parse(fs.readFileSync(path.join(output,'.agents/plugins/marketplace.json'),'utf8'));
  assert.equal(market.name,'superpowers-custom');
  assert.equal(path.resolve(output,market.plugins[0].source.path),result.plugin);
  const names=fs.readdirSync(path.join(source,'skills')).filter(n=>fs.existsSync(path.join(source,'skills',n,'SKILL.md')));
  assert.equal(names.length,14);
  for(const n of names) assert.deepEqual(fs.readFileSync(path.join(source,'skills',n,'SKILL.md')),fs.readFileSync(path.join(result.plugin,'skills',n,'SKILL.md')));
  const manifest=JSON.parse(fs.readFileSync(path.join(result.plugin,'.codex-plugin/plugin.json'),'utf8'));
  assert.equal(manifest.name,'superpowers');assert.equal(manifest.version,result.version);
  assert.ok(fs.existsSync(path.resolve(result.plugin,manifest.interface.logo)));
  assert.equal(fs.existsSync(path.join(result.plugin,'AGENTS.md')),false);
  const env={...process.env,CLAUDE_PLUGIN_ROOT:result.plugin};delete env.CURSOR_PLUGIN_ROOT;delete env.COPILOT_CLI;
  const hook=JSON.parse(execFileSync('bash',[path.join(result.plugin,'hooks/session-start')],{env,encoding:'utf8'}));
  const bootstrap=fs.readFileSync(path.join(result.plugin,'skills/using-superpowers/SKILL.md'),'utf8').trim();
  assert.ok(hook.hookSpecificOutput.additionalContext.includes(bootstrap));
  assert.equal(hook.additional_context,undefined);
  assert.throws(()=>build(source,output),/already exists/);
 }finally{fs.rmSync(temp,{recursive:true,force:true});}
});
test('build rejects overwriting the source tree',()=>assert.throws(()=>build(source,source),/must not contain/));
test('symlinked package input is rejected before any output or external mutation',()=>{
 const temp=fs.mkdtempSync(path.join(os.tmpdir(),'superpowers-link-'));
 try {
  const fixture=path.join(temp,'source'), outside=path.join(temp,'outside'), output=path.join(temp,'out');
  fs.mkdirSync(fixture);fs.mkdirSync(outside);
  for(const name of ['skills','assets','hooks','.codex-plugin','LICENSE']) fs.cpSync(path.join(source,name),path.join(fixture,name),{recursive:true});
  fs.writeFileSync(path.join(outside,'marketplace.json'),'preserve me');
  fs.symlinkSync(outside,path.join(fixture,'.claude-plugin'),'dir');
  assert.throws(()=>build(fixture,output),/symlink/);
  assert.equal(fs.existsSync(output),false);
  assert.equal(fs.readFileSync(path.join(outside,'marketplace.json'),'utf8'),'preserve me');
 } finally {fs.rmSync(temp,{recursive:true,force:true});}
});
test('all entrypoints have matching short discoverable metadata',()=>{
 for(const name of fs.readdirSync(path.join(source,'skills'))){
  const file=path.join(source,'skills',name,'SKILL.md');if(!fs.existsSync(file))continue;
  const content=fs.readFileSync(file,'utf8');assert.ok(content.startsWith('---\nname: '+name+'\n'));
  const description=content.match(/^description: (.+)$/m);assert.ok(description,name);
  assert.ok(JSON.parse(description[1]).length<180,name);
 }
});

test('failed copy does not publish a partial release and can be retried',()=>{
 const temp=fs.mkdtempSync(path.join(os.tmpdir(),'superpowers-failure-'));
 const original=fs.cpSync;
 try {
  const output=path.join(temp,'release');
  fs.cpSync=()=>{throw new Error('simulated copy failure');};
  assert.throws(()=>build(source,output),/simulated copy failure/);
  assert.equal(fs.existsSync(output),false);
  assert.deepEqual(fs.readdirSync(temp),[]);
  fs.cpSync=original;
  assert.equal(build(source,output).marketplace,output);
 }finally{fs.cpSync=original;fs.rmSync(temp,{recursive:true,force:true});}
});
