export const meta = {
  name: 'kelly-layer-moves',
  description: 'Implement confirmed Kelly layer moves bottom-up (v5 repos): per layer, one test-first commit per work package, an adversarial review, fixes, full builds and tests, pack, and the version docs; then an audit',
  whenToUse: 'Step 4 of the kelly-code-abstraction skill, after the user confirmed the plan. args: { scratch, date: "yyyy-mm-dd", base: { "<repo folder>": "<sha at start>" } (every repo in steps), design?: "<path of the design file the specs name>", steps: [{ layer: "data"|"windows"|"domain"|"logic"|"ui"|"revit", packages: ["P2a-windows-parse", ...] }, ...] } bottom-up and consecutive, from the lowest layer that changes through "revit"; a layer with no moves gets packages: [] (repin only)',
  phases: [
    { title: 'Data', detail: 'Kelly-Windows-Data-v3' },
    { title: 'Windows', detail: 'Kelly-Windows-v3' },
    { title: 'Domain', detail: 'Kelly-Domain' },
    { title: 'Logic', detail: 'Kelly-Revit-Logic-v5' },
    { title: 'UI', detail: 'Kelly-Revit-UI' },
    { title: 'Revit', detail: 'Kelly-Revit-v5 host and modules: 21 builds, Tests.Revit in Revit 2024' },
    { title: 'Audit', detail: 'every package checked in the code, rules, pins, repo state' },
  ],
}

const R = '/c/repo/jhkweb'
const SKILL = R + '/.claude/skills/kelly-code-abstraction'
const S = SKILL + '/scripts'
const SP = (args && args.scratch) || ''
if (!SP) throw new Error('pass args.scratch')
const PK = SP + '/packages'
const BASE = args.base || {}
const DATE = args.date || ''
if (!/^\d{4}-\d{2}-\d{2}$/.test(DATE)) throw new Error('pass args.date (today, yyyy-mm-dd): it dates the Changelog headings')
const DESIGN = args.design ? ` Designs and their review corrections: ${args.design}.` : ''
const LAYER = {
  data: { repo: 'Kelly-Windows-Data-v3', phase: 'Data', quick: 'Net80', tests: true, revit: null },
  windows: { repo: 'Kelly-Windows-v3', phase: 'Windows', quick: 'Net80', tests: true, revit: null },
  domain: { repo: 'Kelly-Domain', phase: 'Domain', quick: 'Net80', tests: true, revit: null },
  logic: { repo: 'Kelly-Revit-Logic-v5', phase: 'Logic', quick: '2024', tests: false, revit: { proj: R + '/Kelly-Revit-Logic-v5/test/Revit.Logic.RevitTests/Revit.Logic.RevitTests.csproj', extra: '-p:SolutionName=Kelly.Revit.Logic', full: 'about 30 minutes' } },
  ui: { repo: 'Kelly-Revit-UI', phase: 'UI', quick: '2024', tests: true, revit: { proj: R + '/Kelly-Revit-UI/test/Revit.UI.RevitTests/Revit.UI.RevitTests.csproj', extra: '', full: 'a few minutes' } },
  revit: { repo: 'Kelly-Revit-v5', phase: 'Revit', quick: '2024', tests: false, revit: { proj: R + '/Kelly-Revit-v5/test/Tests.Revit/Core.Tests.csproj', extra: '-p:SolutionName=Kelly.Revit', full: 'a few minutes' } },
}
const ORDER = ['data', 'windows', 'domain', 'logic', 'ui', 'revit']
const MODULES = ['revit', 'alltrade', 'pipetrade', 'ducttrade', 'contenter', 'manager', 'developer']
const STEPS = (args.steps || []).filter(s => LAYER[s.layer])
if (!STEPS.length) throw new Error('pass args.steps')
for (let i = 1; i < STEPS.length; i++) if (ORDER.indexOf(STEPS[i].layer) !== ORDER.indexOf(STEPS[i - 1].layer) + 1) throw new Error('args.steps must be consecutive layers, bottom-up')
if (STEPS[STEPS.length - 1].layer !== 'revit') throw new Error('args.steps must end with "revit": every layer above a change is repinned')
const noBase = STEPS.map(s => LAYER[s.layer].repo).filter(r => !BASE[r])
if (noBase.length) throw new Error(`pass args.base with the starting sha of every repo in steps; missing: ${noBase.join(', ')}`)

const COMMIT = { type: 'object', properties: { package: { type: 'string' }, commit: { type: 'string' }, done: { type: 'array', items: { type: 'string' } }, skipped: { type: 'array', items: { type: 'string' } }, red: { type: 'string' }, green: { type: 'string' }, filesCommitted: { type: 'array', items: { type: 'string' } }, bugsNoted: { type: 'array', items: { type: 'string' } }, followUps: { type: 'array', items: { type: 'string' } } }, required: ['package', 'commit', 'done', 'skipped', 'red', 'green', 'filesCommitted', 'bugsNoted', 'followUps'] }
const REVIEW = { type: 'object', properties: { findings: { type: 'array', items: { type: 'object', properties: { package: { type: 'string' }, severity: { type: 'string', enum: ['high', 'medium', 'low'] }, file: { type: 'string' }, problem: { type: 'string' }, fix: { type: 'string' } }, required: ['package', 'severity', 'file', 'problem', 'fix'] } }, checkedAndFine: { type: 'array', items: { type: 'string' } } }, required: ['findings', 'checkedAndFine'] }
const FIX = { type: 'object', properties: { verifyClean: { type: 'boolean' }, commits: { type: 'array', items: { type: 'string' } }, builds: { type: 'string' }, tests: { type: 'string' }, revitTests: { type: 'string' }, rules: { type: 'string' }, fixed: { type: 'array', items: { type: 'string' } }, rejectedFindings: { type: 'array', items: { type: 'string' } }, bugsNoted: { type: 'array', items: { type: 'string' } } }, required: ['verifyClean', 'commits', 'builds', 'tests', 'revitTests', 'rules', 'fixed', 'rejectedFindings', 'bugsNoted'] }
const PACK = { type: 'object', properties: { version: { type: 'string' }, packages: { type: 'array', items: { type: 'string' } }, notes: { type: 'string' } }, required: ['version', 'packages', 'notes'] }
const FINISH = { type: 'object', properties: { commit: { type: 'string' }, docsUpdated: { type: 'array', items: { type: 'string' } }, leftUncommitted: { type: 'array', items: { type: 'string' } } }, required: ['commit', 'docsUpdated', 'leftUncommitted'] }
const AUDIT = { type: 'object', properties: { packages: { type: 'array', items: { type: 'object', properties: { package: { type: 'string' }, status: { type: 'string', enum: ['done', 'partial', 'missing'] }, note: { type: 'string' } }, required: ['package', 'status', 'note'] } }, rules: { type: 'string' }, pins: { type: 'string' }, repoState: { type: 'array', items: { type: 'string' } }, summary: { type: 'string' } }, required: ['packages', 'rules', 'pins', 'repoState', 'summary'] }

function common(packed) {
  return `
## Run context
Repos under ${R}, each on develop; this run started at ${JSON.stringify(BASE)} (repo -> sha). READ FIRST: ${PK}/DECISIONS.md (baseline, the user's
decisions, the behaviour rule, the hard rules, and the user's own files that must stay out of every commit) and ${SKILL}/references/chain-release.md
(per-layer procedure, docs, Changelog form, commits, pitfalls). The repo's AGENTS.md and ${R}/BuildConfigs/SHARED-AGENTS.md apply (TDD; every member has
a test; [Test]/[TestCase] Author exactly "Verified By Human On:" and a Description of what is verified; namespace == folder; README, Changelog and XML docs
in the same commit as a public change; keep Quick-Backlog.md current, new items under To Organize, tick only with commit evidence).
Tools: Bash (Git Bash) only. Build with ${S}/kbuild.sh (<layer> verify|test|revittests|pack [configs]); pins with ${S}/pins.sh (show; set <repo> <version>:
each v5 repo pins only the layer directly below it, one property in Directory.Packages.props). In-Revit tests ONLY through ${S}/revit-test.sh (it disables and
restores the Revit 2024 add-in manifests; never rename manifests yourself). Never write packages unless your stage says pack. Never install the add-in.
Git: stay on develop; no branches, stash, reset, rebase, amend, checkout/restore of files, or push. Stage and commit with explicit paths only. No
Co-Authored-By or similar line. Re-check git status and git diff just before each commit (the user's IDE can rewrite files).
Layers already packed in this run (do NOT edit their src or tests): ${packed.length ? packed.join(', ') : 'none yet'}.
`
}

function packagePrompt(step, L, pkg, packed, versions) {
  const below = ORDER[ORDER.indexOf(step.layer) - 1]
  const repin = below && versions[below] ? `If this is the first package of ${L.repo} in this run, repin first: bash ${S}/pins.sh set ${L.repo} ${versions[below]}.` : ''
  return `${common(packed)}
## Your stage: work package ${pkg} in ${L.repo}, ONE commit
Spec: ${PK}/${pkg}.md.${DESIGN} ${repin}
1. Tests first: write or change the tests the spec names and show they fail (${L.tests ? `bash ${S}/kbuild.sh ${step.layer} test ${L.quick}` : `compile with bash ${S}/kbuild.sh ${step.layer} revittests 2024; in-Revit tests run later`}). Record the red result.
2. Change the code: a MOVE keeps behaviour exactly; a FIX changes only the behaviour the spec names. Repoint every caller in this repo.
3. Green: bash ${S}/kbuild.sh ${step.layer} verify ${L.quick}${L.tests ? ` and bash ${S}/kbuild.sh ${step.layer} test ${L.quick}` : ''} until 0 errors and no failing test.
4. Docs in the same commit: README (layout row, members, test count from the TestLogs), Changelog entry headed "## ${DATE} (not yet in a package): ..."
   (Kelly-Revit-v5: "(not yet in a build)"), XML docs, Quick-Backlog (the spec says which items to add or tick).
5. Commit with explicit paths; message: one subject line under 72 characters, then bullets. Return the sha, what was done or skipped, the red and green results.
If something in the spec cannot be done as written, do the closest safe version or skip it and say why; never edit a packed layer.`
}

function reviewPrompt(step, L, packed) {
  return `${common(packed)}
## Your stage: adversarial review of this run's commits in ${L.repo}. READ-ONLY: edit nothing, build nothing.
See them with git -C ${R}/${L.repo} log --stat ${BASE[L.repo]}..HEAD and git show per commit. Specs: ${PK}/P*.md for this layer.${DESIGN}
For each commit try hard to find a defect: a MOVE that changed behaviour (compare old and new code line by line: conditions, ordering, case and culture
comparisons, null handling, exceptions, messages, return values); a FIX that changed more than it should or lacks its test; tests that do not pin what they
claim or whose expected values are wrong; missing tests for a new member; namespace != folder; Revit wording in a Revit-free layer; a public change without
README/Changelog/XML docs; a backlog tick without evidence; a file of the user's committed; a move and a fix mixed in one commit.
Report concrete defects only (file:line, the problem, the exact fix).`
}

function fixPrompt(step, L, payload, packed, attempt) {
  const isRevit = step.layer === 'revit'
  const builds = isRevit ? MODULES.map(m => `bash ${S}/kbuild.sh ${m} verify`).join('; ') : `bash ${S}/kbuild.sh ${step.layer} verify`
  const below = ORDER[ORDER.indexOf(step.layer) - 1]
  const repin = !step.packages.length && below && payload.versions[below] ? `This layer has no work package: repin it (bash ${S}/pins.sh set ${L.repo} ${payload.versions[below]}), add a Changelog entry for the repin, and commit that.\n` : ''
  return `${common(packed)}
## Your stage: integrate, fix and verify ${L.repo}${attempt > 1 ? ` (attempt ${attempt})` : ''}
${repin}Reports so far (JSON):
${JSON.stringify(payload.reports, null, 1)}
Do:
1. Re-check each review finding against the code; fix the real ones (behaviour-preserving for moves) in a commit "Review fixes: ..." (explicit paths); list the rejected ones with the reason.
2. All of these must pass: ${builds}${L.tests ? `; bash ${S}/kbuild.sh ${step.layer} test (all configurations; check each TestLogs file has a row per test)` : ''}${L.revit ? `; bash ${S}/kbuild.sh ${step.layer} revittests` : ''}.
${L.revit ? `3. Run the in-Revit tests against this source: bash ${S}/revit-test.sh ${L.revit.proj} ${isRevit ? '-' : '<filter for the fixtures this run touched, or - for all>'} ${SP}/revit-${step.layer}.log ${L.revit.extra} (${L.revit.full}${isRevit ? '; run them all' : '; run all if the run changed shared code'}). A test that needs the add-in started fails in such a run by design; name those. Compare the log's rows with the tests discovered. Exit code 3 means Revit or ricaun is already running: never close it; record revitTests as "compiled, not run (Revit open)", which does not block verifyClean.\n` : ''}4. perl ${S}/check-rules.pl: no new hit compared with the baseline in DECISIONS.md.
verifyClean = true only if every build is 0 errors, every test run passed (apart from named add-in-started tests) and the rules show nothing new.`
}

function packPrompt(step, L, packed) {
  return `${common(packed)}
## Your stage: pack ${L.repo}
Run bash ${S}/kbuild.sh ${step.layer} pack. It builds every configuration with one version and prints "PACKED ${step.layer} <version>". On compile errors fix them in
${L.repo} only and pack again. Exit code 3 means that version was used this minute: run bash ${S}/kbuild.sh ${step.layer} verify ${L.quick} once, then pack again.
Return the version and the package file names.`
}

function finishPrompt(step, L, version, versions, packed) {
  return `${common(packed)}
## Your stage: version docs for ${L.repo}
${version ? `Its package is built as ${version}. Do NOT change src or tests.` : 'Kelly-Revit-v5 is not a package.'}
Update this run's Changelog headings ${version ? `from "(not yet in a package)" to "(package ${version})"` : 'to say "(not yet in a build)" (built, not installed)'}, the README's pin or version
statements (pins this run: ${JSON.stringify(versions)}), and nothing else. Commit with explicit paths (no push). Return the sha and what you left uncommitted (the user's files).`
}

const versions = {}
const packed = []
const record = { steps: [] }
const tails = []

for (const step of STEPS) {
  const L = LAYER[step.layer]
  phase(L.phase)
  const commits = []
  for (const pkg of step.packages) {
    const c = await agent(packagePrompt(step, L, pkg, packed.slice(), { ...versions }), { label: `pkg:${pkg}`, phase: L.phase, schema: COMMIT })
    if (!c) log(`WARNING: ${pkg} returned nothing`)
    else log(`${pkg}: ${c.commit || 'no commit'}; red: ${c.red.slice(0, 60)}; green: ${c.green.slice(0, 60)}`)
    commits.push(c || { package: pkg, failed: true })
  }
  const review = step.packages.length ? await agent(reviewPrompt(step, L, packed.slice()), { label: `review:${step.layer}`, phase: L.phase, schema: REVIEW }) : null
  if (review) log(`${L.repo}: ${review.findings.length} review findings`)

  let fix = null
  for (let attempt = 1; attempt <= 3; attempt++) {
    const reports = attempt === 1 ? { commits, review } : { previousFix: fix }
    fix = await agent(fixPrompt(step, L, { reports, versions: { ...versions } }, packed.slice(), attempt), { label: `fix:${step.layer}#${attempt}`, phase: L.phase, schema: FIX })
    if (fix && fix.verifyClean) break
    log(`${L.repo}: attempt ${attempt} not clean: ${fix ? fix.builds.slice(0, 100) + ' | ' + fix.tests.slice(0, 100) : 'no result'}`)
  }
  const stepRecord = { repo: L.repo, commits, review, fix }
  record.steps.push(stepRecord)
  if (!fix || !fix.verifyClean) { log(`STOPPING: ${L.repo} is not clean after 3 attempts`); record.stoppedAt = L.repo; break }

  if (step.layer !== 'revit') {
    const p = await agent(packPrompt(step, L, packed.slice()), { label: `pack:${step.layer}`, phase: L.phase, schema: PACK })
    if (!p || !p.version) { log(`STOPPING: pack failed for ${L.repo}`); record.stoppedAt = L.repo; break }
    versions[step.layer] = p.version
    stepRecord.pack = p
    packed.push(L.repo)
    log(`${L.repo} packed as ${p.version}`)
    const snapshot = { ...versions }
    tails.push(agent(finishPrompt(step, L, p.version, snapshot, packed.slice()), { label: `docs:${step.layer}`, phase: L.phase, schema: FINISH }).then(f => { stepRecord.finish = f; return f }))
  } else {
    stepRecord.finish = await agent(finishPrompt(step, L, null, { ...versions }, packed.slice()), { label: 'docs:revit', phase: L.phase, schema: FINISH })
  }
}

await Promise.all(tails)

phase('Audit')
const audit = await agent(`${common(['all layers (read-only audit)'])}
## Your stage: audit. READ-ONLY except running verify builds and read-only scripts.
Packages: ${STEPS.map(s => s.packages).flat().join(', ')} (specs ${PK}/). Stage reports (JSON): ${JSON.stringify(record.steps.map(s => ({ repo: s.repo, commits: s.commits, fix: s.fix, pack: s.pack, finish: s.finish })), null, 1)}
1. For EVERY package check the code (not the reports): done | partial | missing, one-line note.
2. perl ${S}/check-rules.pl compared with the baseline in DECISIONS.md.
3. bash ${S}/pins.sh show: each repo pins this run's package of the layer below (${JSON.stringify(versions)}).
4. For each repo: git log --oneline ${JSON.stringify(BASE)}..HEAD and git status --short; only the user's baseline files may be uncommitted; nothing pushed.`, { label: 'audit', phase: 'Audit', schema: AUDIT })

return { versions, stoppedAt: record.stoppedAt || null, steps: record.steps, audit }
