export const meta = {
  name: 'kelly-layer-moves',
  description: 'Implement confirmed Kelly layer moves bottom-up: per layer repin, tests first, move, adversarial review, fix, pack, docs and commit; then a completeness and rules audit',
  whenToUse: 'Phase 5 of the kelly-code-abstraction skill, after the user confirmed the plan. args: { scratch, steps: [{ layer: "data"|"windows"|"domain"|"logic"|"ui"|"revit", packages: ["P1a-data-caching", ...] }, ...] } bottom-up, from the lowest layer that changes through "revit"; a layer with no moves gets packages: [] (repin only)',
  phases: [
    { title: 'Data', detail: 'Kelly-Windows-Data' },
    { title: 'Windows', detail: 'Kelly-Windows' },
    { title: 'Domain', detail: 'Kelly-Domain' },
    { title: 'Logic', detail: 'Kelly-Revit-Logic' },
    { title: 'UI', detail: 'Kelly-Revit-UI' },
    { title: 'Revit', detail: 'Kelly-Revit host and modules: integrate every blind edit, 21 builds' },
    { title: 'Audit', detail: 'completeness critic over every move, rule checks, final builds, repo state' },
  ],
}

const R = '/c/repo/jhkweb'
const SKILL = R + '/.claude/skills/kelly-code-abstraction'
const S = SKILL + '/scripts'
const SP = (args && args.scratch) || ''
if (!SP) throw new Error('pass args.scratch')
const PK = SP + '/packages'
const LAYER = {
  data: { repo: 'Kelly-Windows-Data', family: 'Kelly.Windows.Data', phase: 'Data', quick: 'Net80', tests: true, revitTests: false },
  windows: { repo: 'Kelly-Windows', family: 'Kelly.Windows', phase: 'Windows', quick: 'Net80', tests: true, revitTests: false },
  domain: { repo: 'Kelly-Domain', family: 'Kelly.Domain', phase: 'Domain', quick: 'Net80', tests: true, revitTests: false },
  logic: { repo: 'Kelly-Revit-Logic', family: 'Kelly.Revit.Logic', phase: 'Logic', quick: '2024', tests: false, revitTests: true },
  ui: { repo: 'Kelly-Revit-UI', family: 'Kelly.Revit.UI', phase: 'UI', quick: '2024', tests: true, revitTests: true },
  revit: { repo: 'Kelly-Revit', family: null, phase: 'Revit', quick: '2024', tests: false, revitTests: true },
}
const ORDER = ['data', 'windows', 'domain', 'logic', 'ui', 'revit']
const STEPS = (args.steps || []).filter(s => LAYER[s.layer])
if (!STEPS.length) throw new Error('pass args.steps')
for (let i = 1; i < STEPS.length; i++) if (ORDER.indexOf(STEPS[i].layer) !== ORDER.indexOf(STEPS[i - 1].layer) + 1) throw new Error('args.steps must be consecutive layers, bottom-up')
if (STEPS[STEPS.length - 1].layer !== 'revit') throw new Error('args.steps must end with "revit": every layer above a change is repinned')
const MODULES = ['revit', 'alltrade', 'pipetrade', 'ducttrade', 'contenter', 'manager', 'developer']

const IMPL = {
  type: 'object',
  properties: {
    package: { type: 'string' },
    implemented: { type: 'array', items: { type: 'number' } },
    skipped: { type: 'array', items: { type: 'object', properties: { move: { type: 'number' }, reason: { type: 'string' } }, required: ['move', 'reason'] } },
    partial: { type: 'array', items: { type: 'object', properties: { move: { type: 'number' }, what: { type: 'string' } }, required: ['move', 'what'] } },
    testsMovedOrAdded: { type: 'array', items: { type: 'string' } },
    filesTouched: { type: 'array', items: { type: 'string' } },
    bugsNoted: { type: 'array', items: { type: 'string' } },
    followUps: { type: 'array', items: { type: 'string' } },
    verify: { type: 'string' },
  },
  required: ['package', 'implemented', 'skipped', 'partial', 'testsMovedOrAdded', 'filesTouched', 'bugsNoted', 'followUps', 'verify'],
}
const REVIEW = {
  type: 'object',
  properties: {
    package: { type: 'string' },
    findings: { type: 'array', items: { type: 'object', properties: { move: { type: 'number' }, verdict: { type: 'string', enum: ['ok', 'defect', 'not-done'] }, file: { type: 'string' }, detail: { type: 'string' }, fix: { type: 'string' } }, required: ['move', 'verdict', 'file', 'detail', 'fix'] } },
  },
  required: ['package', 'findings'],
}
const FIX = {
  type: 'object',
  properties: {
    layer: { type: 'string' },
    verifyClean: { type: 'boolean' },
    verify: { type: 'string' },
    tests: { type: 'string' },
    rules: { type: 'string' },
    fixed: { type: 'array', items: { type: 'string' } },
    rejectedFindings: { type: 'array', items: { type: 'string' } },
    bugsNoted: { type: 'array', items: { type: 'string' } },
    followUps: { type: 'array', items: { type: 'string' } },
  },
  required: ['layer', 'verifyClean', 'verify', 'tests', 'rules', 'fixed', 'rejectedFindings', 'bugsNoted', 'followUps'],
}
const PACK = {
  type: 'object',
  properties: { layer: { type: 'string' }, version: { type: 'string' }, packages: { type: 'array', items: { type: 'string' } }, notes: { type: 'string' } },
  required: ['layer', 'version', 'packages', 'notes'],
}
const FINISH = {
  type: 'object',
  properties: {
    repo: { type: 'string' },
    commit: { type: 'string' },
    commitSubject: { type: 'string' },
    docsUpdated: { type: 'array', items: { type: 'string' } },
    leftUncommitted: { type: 'array', items: { type: 'string' } },
    gaps: { type: 'array', items: { type: 'string' } },
    followUps: { type: 'array', items: { type: 'string' } },
  },
  required: ['repo', 'commit', 'commitSubject', 'docsUpdated', 'leftUncommitted', 'gaps', 'followUps'],
}
const AUDIT = {
  type: 'object',
  properties: {
    moves: { type: 'array', items: { type: 'object', properties: { move: { type: 'number' }, status: { type: 'string', enum: ['done', 'partial', 'skipped', 'missing'] }, note: { type: 'string' } }, required: ['move', 'status', 'note'] } },
    ruleViolations: { type: 'array', items: { type: 'string' } },
    builds: { type: 'array', items: { type: 'string' } },
    repoState: { type: 'array', items: { type: 'string' } },
    summary: { type: 'string' },
  },
  required: ['moves', 'ruleViolations', 'builds', 'repoState', 'summary'],
}

function common(packed) {
  return `
## Run context
Repos under ${R}, each its own git repo on develop. READ FIRST: ${PK}/DECISIONS.md (the user's decisions, dropped and deferred moves,
the behaviour rule, probe findings, and each repo's baseline "git status --short": those files are the USER'S and must stay out of
every commit), ${SKILL}/references/chain-release.md (the per-layer procedure, docs, Changelog form, commit rules, pitfalls) and
${SKILL}/references/placement-rules.md (the layer rules). Also the AGENTS.md of each repo you touch and ${R}/BuildConfigs/SHARED-AGENTS.md.
Tools: Bash (Git Bash) only, never PowerShell. Build only through ${S}/kbuild.sh; never run dotnet build on Kelly-Revit yourself
(its normal build installs the add-in). Never write NuGet packages unless your stage says pack.
Git: stay on develop. No branches, worktrees, stash, reset, checkout/restore of files, or push. Only a stage that says commit commits.
Earlier stages left uncommitted edits in several repos on purpose (blind consumer edits in higher repos): keep and build on them.
Layers already packed in this run (do NOT edit their src/ or tests): ${packed.length ? packed.join(', ') : 'none yet'}.
`
}

function pinText(versions) {
  const v = Object.entries(versions)
  if (!v.length) return ''
  return `Repin first: in every csproj of the repo with Kelly pins (git ls-files '*.csproj'; then ${S}/pins.sh show), set ${v.map(([l, ver]) => `${LAYER[l].family} ${ver}`).join(', ')}
with bash ${S}/pins.sh set <csproj> <family> <version>, and confirm one identical pin set per project.`
}

function implPrompt(step, L, pkg, pins, packed) {
  return `${common(packed)}
## Your stage: implement work package ${pkg} (${L.repo})
Spec: ${PK}/${pkg}.md: every move with its record, required changes, consumers, review notes and probe result.
${pins}
Follow "Per layer" steps 2-4 in chain-release.md:
1. Tests first: move the tests that cover the moving code into ${L.repo}'s test project and write the missing ones (every member, the
   attribute form in SHARED-AGENTS.md, characterizing current behaviour). ${L.tests ? `bash ${S}/kbuild.sh ${step.layer} test ${L.quick} should fail to compile now.` : `${L.repo}'s tests run only inside Revit: write them in the in-Revit project and compile with bash ${S}/kbuild.sh ${step.layer} revittests 2024.`}
2. Implement every move as specified, in every repo it touches: target folder with namespace == folder, remove from the source,
   repoint every consumer in all six repos (src, modules, tests; .cs and .xaml), GlobalUsings.cs, accessibility, XML docs.
   Overlapping records for one symbol are implemented once. Preserve behaviour exactly; protected files keep their class.
3. bash ${S}/kbuild.sh ${step.layer} verify ${L.quick} until 0 errors${L.tests ? `, then bash ${S}/kbuild.sh ${step.layer} test ${L.quick} until green` : ''}.
   Edits in higher repos cannot compile yet; write them carefully from the code.
4. A move that cannot be done as specified: do the closest safe version or skip it, and say why. Never edit a packed layer; record the need in followUps.
Return the structured result; implemented/skipped/partial use the move numbers from the spec.`
}

function reviewPrompt(L, pkg, packed) {
  return `${common(packed)}
## Your stage: adversarial review of work package ${pkg} as just implemented. READ-ONLY: edit nothing, build nothing.
Spec: ${PK}/${pkg}.md. See what changed with git -C ${R}/<repo> status and diff (include untracked files) in every repo it touches.
Apply "Per layer" step 5 of chain-release.md to each move: try hard to find a defect, comparing old (git show HEAD:<path>) and new code
line by line. Also check: tests moved or written for every moved member, no edit to a file the baseline in DECISIONS.md lists as the user's.
Report concrete defects only (file:line, what is wrong, the exact fix). Give every move of the package a verdict: ok | defect | not-done.`
}

function fixPrompt(step, L, payload, packed, attempt) {
  const builds = step.layer === 'revit'
    ? MODULES.map(m => `bash ${S}/kbuild.sh ${m} verify`).join('; ') + `; bash ${S}/kbuild.sh revit revittests 2024`
    : `bash ${S}/kbuild.sh ${step.layer} verify` + (L.tests ? `; bash ${S}/kbuild.sh ${step.layer} test` : '') + (L.revitTests ? `; bash ${S}/kbuild.sh ${step.layer} revittests 2024` : '')
  return `${common(packed)}
## Your stage: integrate and fix ${L.repo}${attempt > 1 ? ` (attempt ${attempt})` : ''}
Work packages of this step: ${step.packages.length ? step.packages.join(', ') : 'none (repin only)'} (specs in ${PK}/).
${step.packages.length ? '' : pinText(payload.versions) + '\n'}Reports and review findings so far (JSON):
${JSON.stringify(payload.reports, null, 1)}
Do:
1. Re-check every review finding against the code; fix the real ones (behaviour-preserving) and list the ones you reject, with the reason.
2. Make every one of these pass, for ALL configurations: ${builds}
${step.layer === 'revit' ? '   This is the first build of Kelly-Revit against the new packages: every earlier step edited it blind, so fix every error the run caused.\n' : ''}3. perl ${S}/check-rules.pl: no new hit compared with the baseline in DECISIONS.md. Also XML docs on new public members and no leftover copies.
4. Do not edit packed layers. Do not fix bugs by changing behaviour; list them in bugsNoted.
verifyClean = true only if the last full run of every command in step 2 reported 0 errors and no failed test.`
}

function packPrompt(step, L, packed) {
  return `${common(packed)}
## Your stage: pack ${L.repo}
Run bash ${S}/kbuild.sh ${step.layer} pack. It builds every configuration with one version and prints "PACKED ${step.layer} <version>".
On compile errors, fix them inside ${L.repo} only (behaviour-preserving) and pack again. Exit code 3 means that version was used this
minute: run bash ${S}/kbuild.sh ${step.layer} verify ${L.quick} once to let the minute pass, then pack again.
Return the version from the PACKED line and the package file names.`
}

function finishPrompt(step, L, version, versions, packed) {
  return `${common(packed)}
## Your stage: docs and commit for ${L.repo}
${version ? `Its package is built as ${version}; do NOT change anything under src/ or the tests (report a defect in followUps instead).` : 'Kelly-Revit now builds against the new packages; it is not a package.'}
1. Docs, per "Per layer" step 6 and "Changelog entries" in chain-release.md: README (moved types with old -> new namespace, the pin
   statement per references/layers.md, Running the tests, SOLID if a rating moves) and one dated Changelog entry
   (${version ? `"(package ${version})"` : '"(not yet built)"'}) inserted with perl ${S}/insert-changelog.pl. Pins this run: ${JSON.stringify(versions)}.
2. Commit per "Commits" in chain-release.md: one commit on develop with explicit paths, only files this run changed (compare git status
   with the baseline in DECISIONS.md), no Co-Authored-By or similar line, no push. Then git show --stat HEAD.
Return the sha and subject; list in leftUncommitted every modified file you left out and why, and in gaps every new or moved member without a test.`
}

const versions = {}
const packed = []
const record = { steps: [] }
const tails = []

for (const step of STEPS) {
  const L = LAYER[step.layer]
  phase(L.phase)
  const impls = []
  for (let i = 0; i < step.packages.length; i++) {
    const pkg = step.packages[i]
    const r = await agent(implPrompt(step, L, pkg, i === 0 ? pinText(versions) : '', packed.slice()), { label: `impl:${pkg}`, phase: L.phase, schema: IMPL })
    if (!r) log(`WARNING: implementer for ${pkg} returned nothing`)
    else log(`${pkg}: ${r.implemented.length} implemented, ${r.skipped.length} skipped, ${r.partial.length} partial; ${r.verify.slice(0, 100)}`)
    impls.push(r || { package: pkg, failed: true })
  }
  const reviews = await parallel(step.packages.map(pkg => () =>
    agent(reviewPrompt(L, pkg, packed.slice()), { label: `review:${pkg}`, phase: L.phase, schema: REVIEW })))
  const findings = reviews.filter(Boolean).flatMap(r => r.findings.filter(f => f.verdict !== 'ok').map(f => ({ package: r.package, ...f })))
  if (step.packages.length) log(`${L.repo}: ${findings.length} review findings to integrate`)

  let fix = null
  for (let attempt = 1; attempt <= 3; attempt++) {
    const reports = attempt === 1 ? { implementers: impls, reviewFindings: findings } : { previousFix: fix }
    fix = await agent(fixPrompt(step, L, { reports, versions: { ...versions } }, packed.slice(), attempt), { label: `fix:${step.layer}#${attempt}`, phase: L.phase, schema: FIX })
    if (fix && fix.verifyClean) break
    log(`${L.repo}: fix attempt ${attempt} not clean: ${fix ? fix.verify.slice(0, 160) : 'no result'}`)
  }
  const stepRecord = { repo: L.repo, impls, findings, fix }
  record.steps.push(stepRecord)
  if (!fix || !fix.verifyClean) {
    log(`STOPPING: ${L.repo} does not build and test cleanly after 3 attempts`)
    record.stoppedAt = L.repo
    break
  }

  if (step.layer !== 'revit') {
    const p = await agent(packPrompt(step, L, packed.slice()), { label: `pack:${step.layer}`, phase: L.phase, schema: PACK })
    if (!p || !p.version) {
      log(`STOPPING: pack failed for ${L.repo}`)
      record.stoppedAt = L.repo
      break
    }
    versions[step.layer] = p.version
    stepRecord.pack = p
    packed.push(L.repo)
    log(`${L.repo} packed as ${p.version}`)
    // Docs and the commit for this layer run while the next layer is implemented; they touch only this repo.
    const snapshot = { ...versions }
    tails.push(agent(finishPrompt(step, L, p.version, snapshot, packed.slice()), { label: `finish:${step.layer}`, phase: L.phase, schema: FINISH })
      .then(f => { stepRecord.finish = f; return f }))
  } else {
    stepRecord.finish = await agent(finishPrompt(step, L, null, { ...versions }, packed.slice()), { label: 'finish:revit', phase: L.phase, schema: FINISH })
  }
}

await Promise.all(tails)

phase('Audit')
const audit = await agent(`${common(['all layers (read-only audit)'])}
## Your stage: completeness audit. READ-ONLY except for running verify builds.
Work packages: ${PK}/P*.md (minus the moves DECISIONS.md drops or defers).
Stage reports (JSON): ${JSON.stringify(record.steps.map(s => ({ repo: s.repo, impls: s.impls, fix: s.fix, pack: s.pack, finish: s.finish })), null, 1)}
1. For EVERY move number in the packages, check the code in the repos (not the reports): done | partial | skipped | missing, with a one-line note.
2. perl ${S}/check-rules.pl, compared with the baseline in DECISIONS.md; report every new hit.
3. Builds: bash ${S}/kbuild.sh <layer> verify for data, windows, domain, logic, ui and ${MODULES.join(', ')} (all configurations); report each result line.
4. Repo state: for each of the six repos, git status --short and git log --oneline -2. Only the baseline's files (the user's) may remain uncommitted.`, { label: 'audit', phase: 'Audit', schema: AUDIT })

return { versions, stoppedAt: record.stoppedAt || null, steps: record.steps, audit }
