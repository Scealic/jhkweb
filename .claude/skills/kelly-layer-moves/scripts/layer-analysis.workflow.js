export const meta = {
  name: 'kelly-layer-analysis',
  description: 'Read-only: find Kelly code that belongs in a more abstract (or otherwise more appropriate) layer, refute each proposed move, and compile-probe whole-file moves in scratch copies',
  whenToUse: 'Phase 1 of the kelly-layer-moves skill. args: { scratch: "<scratchpad path, Git Bash form>", scopes: <the array in references/scopes.json>, only?: ["scope key", ...] }',
  phases: [
    { title: 'Map', detail: 'one finder per scope classifies every file and proposes moves' },
    { title: 'Review', detail: 'adversarial reviewers try to refute each proposed move' },
    { title: 'Probe', detail: 'accepted whole-file moves are compiled inside a scratch copy of each target layer' },
  ],
}

const R = '/c/repo/jhkweb'
const SKILL = R + '/.claude/skills/kelly-layer-moves'
const SP = (args && args.scratch) || ''
if (!SP) throw new Error('pass args.scratch (the session scratchpad, Git Bash form)')
const ALL_SCOPES = (args && args.scopes) || []
if (!ALL_SCOPES.length) throw new Error('pass args.scopes (the array in references/scopes.json)')
const SCOPES = args.only && args.only.length ? ALL_SCOPES.filter(s => args.only.includes(s.key)) : ALL_SCOPES

const LAYERS = ['Kelly-Windows-Data', 'Kelly-Windows', 'Kelly-Domain', 'Kelly-Revit-Logic', 'Kelly-Revit-UI', 'Kelly-Revit']
const layerOf = r => LAYERS.indexOf(r)
// Each layer name is a layer; its folder carries the repo's own major version (since 2026-10-27).
const DIR = { 'Kelly-Windows-Data': 'Kelly-Windows-Data-v3', 'Kelly-Windows': 'Kelly-Windows-v3', 'Kelly-Domain': 'Kelly-Domain', 'Kelly-Revit-Logic': 'Kelly-Revit-Logic-v5', 'Kelly-Revit-UI': 'Kelly-Revit-UI', 'Kelly-Revit': 'Kelly-Revit-v5' }

const CONTEXT = `
## Workspace
Root ${R}: six sibling git repos, each on branch develop. Layer names below map to these folders (Major Version 5): ${LAYERS.map(l => l + " = " + DIR[l]).join(", ")}. sourceRepo and targetRepo use the layer name; paths are relative to the folder. This task is READ-ONLY for the repos: do not edit, create or delete
anything under ${R}, and run no git command that changes state. Use Bash (Git Bash), never PowerShell. Scratch space: ${SP}
(make your own subfolder). Skip bin/, obj/, TestLogs/ and .vs/ everywhere.

## Rules
READ FIRST: ${SKILL}/references/placement-rules.md. It defines the six layers and what belongs in each, the user's hard rules
(Kelly-Windows and Kelly-Windows-Data know nothing of the Revit API; the IExternalCommand, *View.xaml(.cs), *View.cs and
*ViewModel.cs FILES stay in Kelly-Revit, but any code inside a view, view model or model that is not presentation moves to the
lowest layer that fits, whatever its size (rule 6); availability classes stay with their commands), what "a more appropriate layer" means
(the LOWEST layer whose concern fits and whose references satisfy the code; code can also sit too low), what makes a move unsafe,
and the move record. Follow it exactly.
`

const MOVE = {
  type: 'object',
  properties: {
    sourceRepo: { type: 'string', enum: LAYERS },
    sourcePath: { type: 'string' },
    granularity: { type: 'string', enum: ['file', 'type', 'member'] },
    symbol: { type: 'string' },
    targetRepo: { type: 'string', enum: LAYERS },
    targetFolder: { type: 'string' },
    targetNamespace: { type: 'string' },
    revitApi: { type: 'string', enum: ['none', 'db', 'ui'] },
    rationale: { type: 'string' },
    prerequisites: { type: 'array', items: { type: 'string' } },
    requiredChanges: { type: 'array', items: { type: 'string' } },
    consumers: { type: 'array', items: { type: 'string' } },
    risk: { type: 'string', enum: ['low', 'medium', 'high'] },
    confidence: { type: 'string', enum: ['high', 'medium', 'low'] },
  },
  required: ['sourceRepo', 'sourcePath', 'granularity', 'symbol', 'targetRepo', 'targetFolder', 'targetNamespace', 'revitApi', 'rationale', 'prerequisites', 'requiredChanges', 'consumers', 'risk', 'confidence'],
}

const FINDER_SCHEMA = {
  type: 'object',
  properties: {
    scope: { type: 'string' },
    filesReviewed: { type: 'number' },
    moves: { type: 'array', items: MOVE },
    keep: { type: 'array', items: { type: 'object', properties: { path: { type: 'string' }, reason: { type: 'string' } }, required: ['path', 'reason'] } },
    notes: { type: 'array', items: { type: 'string' } },
  },
  required: ['scope', 'filesReviewed', 'moves', 'keep', 'notes'],
}

const VERDICT_SCHEMA = {
  type: 'object',
  properties: {
    verdicts: {
      type: 'array',
      items: {
        type: 'object',
        properties: {
          key: { type: 'string' },
          verdict: { type: 'string', enum: ['accept', 'reject', 'modify'] },
          reason: { type: 'string' },
          targetRepo: { type: 'string', enum: LAYERS },
          targetFolder: { type: 'string' },
          targetNamespace: { type: 'string' },
          extraRequiredChanges: { type: 'array', items: { type: 'string' } },
        },
        required: ['key', 'verdict', 'reason', 'targetRepo', 'targetFolder', 'targetNamespace', 'extraRequiredChanges'],
      },
    },
  },
  required: ['verdicts'],
}

const PROBE_SCHEMA = {
  type: 'object',
  properties: {
    targetRepo: { type: 'string' },
    configurationsBuilt: { type: 'array', items: { type: 'string' } },
    compiled: { type: 'array', items: { type: 'string' } },
    failed: { type: 'array', items: { type: 'object', properties: { key: { type: 'string' }, cause: { type: 'string' }, errors: { type: 'array', items: { type: 'string' } } }, required: ['key', 'cause', 'errors'] } },
    conflicts: { type: 'array', items: { type: 'string' } },
    sourceSideBreaks: { type: 'array', items: { type: 'object', properties: { key: { type: 'string' }, consumer: { type: 'string' }, error: { type: 'string' } }, required: ['key', 'consumer', 'error'] } },
    notes: { type: 'array', items: { type: 'string' } },
  },
  required: ['targetRepo', 'configurationsBuilt', 'compiled', 'failed', 'conflicts', 'sourceSideBreaks', 'notes'],
}

const keyOf = m => `${m.sourceRepo}:${m.sourcePath}#${m.symbol || ''}`

function scopeText(s) {
  const ex = s.exclude && s.exclude.length ? `\nExcept: ${s.exclude.join(', ')}` : ''
  return `Paths (repo-root relative; "folder/*" means only the files directly in that folder): ${s.paths.join(', ')}${ex}`
}

function finderPrompt(s) {
  return `${CONTEXT}
## Your scope: ${s.key} (${s.repo})
${scopeText(s)}

${s.guidance}

Follow "Finding moves" in placement-rules.md. List every .cs and .xaml file in scope with find, read each one, and
classify it (and any type, member or piece of code inside it that should move) as KEEP or MOVE from its real dependencies.
Read every view, view model and model line by line ("Views, view models and models" in placement-rules.md): every rule,
check, conversion, calculation, query or file access in them that is not presentation is a move, however short. For each move
grep all six repos (src, modules and test folders) for consumers and prerequisites. Every kept file gets a short reason in keep.
Be precise, and do not miss anything in your scope.`
}

function reviewPrompt(moves, scopeKey) {
  return `${CONTEXT}
## Your job: adversarial review of the moves proposed in scope "${scopeKey}"
Follow "Reviewing moves" in placement-rules.md: try to REFUTE each move. Read the source yourself and grep consumers and dependencies.
Default to reject when it is unclear the move is safe and an improvement. Always fill targetRepo/targetFolder/targetNamespace with
the final values (copy the proposal's for accept and reject). Echo each move's "key" exactly.

Moves (JSON):
${JSON.stringify(moves.map(m => ({ key: keyOf(m), ...m })), null, 1)}`
}

function chunk(arr, n) {
  const out = []
  for (let i = 0; i < arr.length; i += n) out.push(arr.slice(i, i + n))
  return out
}

phase('Map')
log(`${SCOPES.length} scopes: ${SCOPES.map(s => s.key).join(', ')}`)
const reviewed = await pipeline(
  SCOPES,
  s => agent(finderPrompt(s), { label: `find:${s.key}`, phase: 'Map', schema: FINDER_SCHEMA }),
  async (found, s) => {
    if (!found) return { scope: s.key, found: null, verdicts: [] }
    const seen = new Set()
    const moves = found.moves.filter(m => { const k = keyOf(m); if (seen.has(k)) return false; seen.add(k); return true })
    log(`${s.key}: ${found.filesReviewed} files read, ${moves.length} moves proposed`)
    if (!moves.length) return { scope: s.key, found, verdicts: [] }
    const vs = await parallel(chunk(moves, 14).map((g, i) => () =>
      agent(reviewPrompt(g, s.key), { label: `review:${s.key}#${i + 1}`, phase: 'Review', schema: VERDICT_SCHEMA })))
    return { scope: s.key, found, verdicts: vs.filter(Boolean).flatMap(v => v.verdicts) }
  },
)

// Barrier: a compile probe for a target layer must see every accepted move into that layer and below.
const all = reviewed.filter(Boolean)
const failedScopes = all.filter(r => !r.found).map(r => r.scope)
if (failedScopes.length) log(`WARNING: finders returned nothing for ${failedScopes.join(', ')}; rerun them with args.only`)
const moveByKey = new Map()
for (const r of all) for (const m of (r.found ? r.found.moves : [])) if (!moveByKey.has(keyOf(m))) moveByKey.set(keyOf(m), { ...m, scope: r.scope })
const accepted = []
for (const r of all) for (const v of r.verdicts) {
  const m = moveByKey.get(v.key)
  if (!m || v.verdict === 'reject' || accepted.some(a => a.key === v.key)) continue
  accepted.push({ ...m, key: v.key, verdict: v.verdict, reviewReason: v.reason, targetRepo: v.targetRepo, targetFolder: v.targetFolder, targetNamespace: v.targetNamespace, requiredChanges: [...m.requiredChanges, ...v.extraRequiredChanges] })
}
const unreviewed = [...moveByKey.keys()].filter(k => !all.some(r => r.verdicts.some(v => v.key === k)))
if (unreviewed.length) log(`WARNING: ${unreviewed.length} proposed moves got no verdict and are not probed: ${unreviewed.slice(0, 10).join(', ')}`)
log(`${moveByKey.size} moves proposed, ${accepted.length} survived review`)

phase('Probe')
const fileMoves = accepted.filter(m => m.granularity === 'file')
const extractions = accepted.filter(m => m.granularity !== 'file')
if (extractions.length) log(`${extractions.length} type/member extractions are not compile-probed (they need code edits first)`)
const intoAddIn = fileMoves.filter(m => m.targetRepo === 'Kelly-Revit')
if (intoAddIn.length) log(`${intoAddIn.length} whole-file moves into Kelly-Revit are not probed (its builds install the add-in); check them by hand`)

const BUILD = {
  'Kelly-Windows-Data': { proj: 'Data.csproj', cfgs: ['Net80', 'Net481'], sol: 'Kelly.Windows.Data' },
  'Kelly-Windows': { proj: 'Logic.csproj', cfgs: ['Net80', 'Net481'], sol: 'Kelly.Windows' },
  'Kelly-Domain': { proj: 'Domain.csproj', cfgs: ['Net80', 'Net481'], sol: 'Kelly.Domain' },
  'Kelly-Revit-Logic': { proj: 'Revit.csproj', cfgs: ['2026', '2024'], sol: 'Kelly.Revit.Logic' },
  'Kelly-Revit-UI': { proj: 'Revit.UI.csproj', cfgs: ['2026', '2024'], sol: 'Kelly.Revit.UI' },
}

function probePrompt(target, cands, alsoInclude, upward) {
  const b = BUILD[target]
  const dir = `${SP}/probes/${target}`
  return `${CONTEXT}
## Your job: compile probe for target layer ${target}
Decide which candidate files really compile inside ${target} with only ${target}'s references: evidence from the compiler, not reading.
Follow "Compile probe" in placement-rules.md. Work ONLY inside ${dir}/ (and ${dir}-source-<repo>/ for step 5); never touch ${R}.
1. rm -rf ${dir}; mkdir -p ${dir}; cp -r ${R}/${DIR[target]}/src ${dir}/src; cp ${R}/${DIR[target]}/Directory.Packages.props ${R}/${DIR[target]}/NuGet.Config ${dir}/ (central package management: the project files name packages without a version); delete the copied bin/ and obj/.
2. Copy each candidate and alsoInclude file unchanged into ${dir}/src/__probe__/<sourceRepo>/<sourcePath>.
3. Write ${dir}/src/__probe__/ProbeUsings.cs with the global usings the probe files need (from the source projects' GlobalUsings.cs),
   keeping only namespaces and aliases that exist in ${target} or below or are declared by probe files.${layerOf(target) <= 2 ? ' Never add a Revit namespace.' : ''}
4. cd ${dir}/src && dotnet build ${b.proj} -c ${b.cfgs[0]} -nologo -v:minimal -p:GeneratePackageOnBuild=false -p:SolutionName=${b.sol} 2>&1 | grep -E " error | warning CS|->" | sort -u
   -p:GeneratePackageOnBuild=false is mandatory: never write packages.
5. Attribute each error to a probe file. Remove a file that needs something ${target} cannot have (a higher layer's types, RevitAPIUI,
   Telerik, host statics, Settings/Resources${layerOf(target) <= 2 ? ', ANY Autodesk type' : ''}) and record the cause in failed (a cascade when it only
   needed another removed file). Rebuild until 0 errors (at most 12 rounds). An error in an ORIGINAL target file caused by a probe file
   (an ambiguous name, for example) goes in conflicts, naming both files.
6. With the final set, build ${b.cfgs.slice(1).join(', ')} as well and record any extra failures (net481, C# 12, #if REVIT20xx).
7. ${upward.length ? `Upward moves (their source is below ${target}): for each source repo, copy its folder's src (the folder is in Workspace) with its Directory.Packages.props and NuGet.Config to ${dir}-source-<repo>/, delete the moving
   files there, build its project the same way, and record each break in sourceSideBreaks.` : 'No upward moves for this target; leave sourceSideBreaks empty.'}
Report files by their key exactly. compiled = keys of candidates (not alsoInclude) that survived every configuration.

Candidates (destined for ${target}):
${JSON.stringify(cands.map(m => ({ key: m.key, sourceRepo: m.sourceRepo, sourcePath: m.sourcePath, targetFolder: m.targetFolder })), null, 1)}

alsoInclude (moving from above ${target} to ${target} or a layer below it; include them so candidates that need them compile; do not report them):
${JSON.stringify(alsoInclude.map(m => ({ key: m.key, sourceRepo: m.sourceRepo, sourcePath: m.sourcePath })), null, 1)}

Upward moves into ${target}: ${JSON.stringify(upward.map(m => m.key))}`
}

const targets = LAYERS.filter(t => BUILD[t] && fileMoves.some(m => m.targetRepo === t))
const probes = await parallel(targets.map(t => () => {
  const cands = fileMoves.filter(m => m.targetRepo === t)
  const alsoInclude = fileMoves.filter(m => layerOf(m.targetRepo) < layerOf(t) && layerOf(m.sourceRepo) > layerOf(t))
  const upward = cands.filter(m => layerOf(m.sourceRepo) < layerOf(t))
  return agent(probePrompt(t, cands, alsoInclude, upward), { label: `probe:${t}`, phase: 'Probe', schema: PROBE_SCHEMA })
}))

return {
  scopes: all.map(r => ({ scope: r.scope, filesReviewed: r.found ? r.found.filesReviewed : null, proposed: r.found ? r.found.moves.length : 0, keep: r.found ? r.found.keep : [], notes: r.found ? r.found.notes : ['FINDER FAILED'] })),
  failedScopes,
  proposed: [...moveByKey.values()],
  verdicts: all.flatMap(r => r.verdicts),
  accepted,
  unreviewed,
  probes: probes.filter(Boolean),
}
