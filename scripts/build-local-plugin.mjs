import fs from 'node:fs';
import path from 'node:path';
import crypto from 'node:crypto';
import {fileURLToPath} from 'node:url';

// Build only a generated marketplace tree; never mutate installed plugin caches.
export function build(source, destination) {
  source = path.resolve(source);
  destination = path.resolve(destination);
  if (destination === source || source.startsWith(destination + path.sep))
    throw new Error('Output must not contain the source checkout');

  if (fs.existsSync(destination)) throw new Error('Output already exists; choose a new release directory');
  const manifest = JSON.parse(fs.readFileSync(path.join(source, '.codex-plugin/plugin.json'), 'utf8'));
  if (manifest.name !== 'superpowers' || !/^\d+\.\d+\.\d+-custom\.\d+(?:\+codex\.[A-Za-z0-9.-]+)?$/.test(manifest.version))
    throw new Error('Expected a custom prerelease manifest');
  const includes = ['skills', 'assets', 'hooks', '.codex-plugin', '.claude-plugin', 'LICENSE'];
  function rejectLinks(file) {
    const stat = fs.lstatSync(file);
    if (stat.isSymbolicLink()) throw new Error('Package symlink requires explicit review: '+file);
    if (stat.isDirectory()) for (const name of fs.readdirSync(file)) rejectLinks(path.join(file,name));
  }
  for (const name of includes) rejectLinks(path.join(source,name));
  fs.mkdirSync(path.dirname(destination), {recursive:true});
  const staging=fs.mkdtempSync(path.join(path.dirname(destination),'.superpowers-build-'));
  const plugin=path.join(staging,'plugins','superpowers');
  try {
  fs.mkdirSync(plugin, {recursive:true});
  for (const name of includes) {
    const input = path.join(source,name);
    fs.cpSync(input,path.join(plugin,name),{recursive:true,dereference:false});
  }
  // Keep marketplace catalogs outside the plugin itself.
  fs.rmSync(path.join(plugin,'.claude-plugin/marketplace.json'),{force:true});
  const marketplace = {name:'superpowers-custom',interface:{displayName:'Superpowers Custom'},plugins:[{
    name:'superpowers',source:{source:'local',path:'./plugins/superpowers'},
    policy:{installation:'AVAILABLE',authentication:'ON_INSTALL'},category:'Developer Tools'
  }]};
  fs.mkdirSync(path.join(staging,'.agents/plugins'),{recursive:true});
  fs.writeFileSync(path.join(staging,'.agents/plugins/marketplace.json'),JSON.stringify(marketplace,null,2)+'\n');
  const entries=[];
  function walk(dir){for(const name of fs.readdirSync(dir).sort()){
    const file=path.join(dir,name), stat=fs.lstatSync(file);
    if(stat.isSymbolicLink()) throw new Error('Package symlink requires explicit review: '+file);
    if(stat.isDirectory()) walk(file);
    else entries.push({path:path.relative(plugin,file),sha256:crypto.createHash('sha256').update(fs.readFileSync(file)).digest('hex')});
  }}
  walk(plugin);
  fs.writeFileSync(path.join(staging,'package-evidence.json'),JSON.stringify({version:manifest.version,files:entries},null,2)+'\n');
  if(fs.existsSync(destination)) throw new Error('Output already exists; choose a new release directory');
  fs.renameSync(staging,destination);
  return {marketplace:destination,plugin:path.join(destination,'plugins','superpowers'),version:manifest.version,files:entries.length};
  } catch(error) {
    fs.rmSync(staging,{recursive:true,force:true});
    throw error;
  }
}

if (process.argv[1] && path.resolve(process.argv[1]) === fileURLToPath(import.meta.url)) {
  const source=path.resolve(path.dirname(fileURLToPath(import.meta.url)),'..');
  const version=JSON.parse(fs.readFileSync(path.join(source,'.codex-plugin/plugin.json'),'utf8')).version;
  const destination=process.argv[2] || path.join(source,'dist',version);
  console.log(JSON.stringify(build(source,destination),null,2));
}
