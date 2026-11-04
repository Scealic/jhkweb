---
name: kelly-code-abstraction
description: Analyze every Kelly Tools For Revit repository under C:\repo\jhkweb for code that can be abstracted to a more appropriate architectural layer, usually a lower, more general one (Kelly-Revit modules → Kelly-Revit-UI or Kelly-Revit-Logic → Kelly-Domain → Kelly-Windows → Kelly-Windows-Data), but also code that sits too low or is duplicated across layers. Then, once the user confirms the plan, move it there bottom-up, building each layer's new NuGet package and repinning the layers above as it goes. The hard rules are that Kelly-Windows and Kelly-Windows-Data know nothing of the Revit API, and that the IExternalCommand, *View.xaml, *View.cs and *ViewModel.cs files stay in Kelly-Revit, though any code inside a view, view model or model that can and should live lower moves down. Use this skill whenever the user asks what code can be abstracted, where code could move to a more abstract or more appropriate layer, about "code abstraction across repositories", whether anything is in the wrong layer or repo, to push shared code down the layers, to find code duplicated across the layers, or to rerun the layer-moves analysis, even if they don't name a layer or a repo.
---

# Kelly code abstraction

This skill does the user's original request:

> Analyze all repositories to determine what code can be abstracted to a more appropriate architectural layer. If you build, a new nuget package is created so you can update dependencies as you [go]. Rules:
> - The Kelly-Windows repo should not know anything about the revit api.
> - The Kelly-Windows.data repo should not know anything about the revit api.
> - Leave all of the following types in the Kelly.Revit repo: IExternalCommands, \*View.xaml, \*View.cs, \*ViewModel.cs

On 2026-11-04 the user widened the last rule: "I just want to include or change the MVVM rules so it ok to abstract any code within a view, view mode or model that can/should be abstracted." The files and their classes stay in Kelly-Revit. Any code inside them that is not presentation moves to the lowest layer that fits, whatever its size (rule 6 and "Views, view models and models" in `references/placement-rules.md`).

Runs so far:
- **2026-10-12:** planned 173 moves and did 169 of them, with no behaviour changed and no rule broken.
- **2026-11-03, round 1:** 14 work packages from a view model review, through Kelly-Windows-v3, Kelly-Domain and Kelly-Revit-Logic-v5, all done and pushed on 2026-11-04 (`LAYER-MOVES-PLAN-2026-11-03.md`, `LAYER-MOVES-2026-11-03.md`).

This skill makes those runs repeatable on today's code: six layers, and Kelly-Revit as a host plus six modules.

**Last checked against the repos: 2026-11-04.** If a script, path or version format here no longer matches the repos, fix the skill first and update this date.

```
Kelly-Windows-Data → Kelly-Windows → Kelly-Domain → Kelly-Revit-Logic → Kelly-Revit-UI → Kelly-Revit (src/ host + modules/Trade.All, .Pipe, .Duct, .Contenter, .Manager, .Developer)
 data access         generic helpers   Kelly model     Revit DB only       ribbon/command/MVVM    the add-in: tools, commands, views
 ───────────── Revit-free ─────────────────────────    framework
```

"More appropriate" means **the lowest layer whose concern fits the code and whose references can satisfy it**. Read `references/placement-rules.md` before classifying anything; finders, reviewers and implementers all work from it. For a quick question about one file or folder ("where should `SpoolNameBuilder` live?"), apply those rules inline and answer. You don't need the workflows below.

## What's in the skill

| File | Use |
|---|---|
| `references/placement-rules.md` | The layers, the user's rules, the placement criteria, unsafe-move checklist, the move record, how to find, review and compile-probe moves, and the work package format. |
| `references/scopes.json` | The analysis scopes: one finder per scope, together covering every source file once. |
| `references/chain-release.md` | How moves are implemented and carried up the chain: per-layer steps, Kelly-Revit last, Changelog, commits, push, pitfalls. |
| `references/layers.md` | Per-repo projects, configurations, test projects, where each README states its pins, Changelog heading forms. |
| `references/report-template.md` | The plan document and the result report. |
| `scripts/check-rules.pl` | Read-only rule check: Revit API in the Revit-free layers, dependency direction, protected files outside Kelly-Revit, namespace ≠ folder. |
| `scripts/scope-coverage.pl` | Checks `scopes.json` covers every `.cs`/`.xaml` file exactly once, and counts each scope's files. |
| `scripts/layer-analysis.workflow.js` | Read-only analysis: find → adversarial review → compile probe. |
| `scripts/layer-moves.workflow.js` | Implementation, bottom-up: per layer, the stages in step 4 below, then an audit. |
| `scripts/kbuild.sh` | Build, test, compile the in-Revit tests of, or pack a layer. Kelly-Revit builds never install. |
| `scripts/pins.sh` | Show every repo's pin, or set one repo's `Kelly*Version` property. |
| `scripts/revit-test.sh` | Run an in-Revit test project in Revit 2024 against this source. It disables and restores the add-in manifests. |
| `scripts/insert-changelog.pl` | Insert a Changelog entry above the newest heading. |

The layer table, the user's rules and what belongs where live once, in `placement-rules.md`. Paths, pins and versions live in `layers.md`. Change them there, not here.

`S=/c/repo/jhkweb/.claude/skills/kelly-code-abstraction/scripts`. Use Git Bash, never PowerShell.

## Ground rules

These come from `BuildConfigs/SHARED-AGENTS.md`, the repos' `AGENTS.md` and corrections the user has made. Re-read those files at the start: the user edits them, and their current text wins over this list.

- **Nothing changes in the repos until the user confirms the plan.** The analysis is read-only. Probes build copies in the scratchpad.
- Work on `develop` only: no other branch, never push `main`, push only when asked. No `Co-Authored-By` or similar line in commits.
- Never stage, commit or revert the user's own uncommitted or staged files. Take a baseline at the start and compare against it before every commit.
- TDD: tests move or are written first. Every member needs a test. New or changed tests use the attribute form in `SHARED-AGENTS.md`, and never get a verification date.
- Preserve behaviour exactly. A bug found on the way is recorded, characterized by a test and reported, not fixed.
- Kelly-Revit builds must not install the add-in, so build through `kbuild.sh`.
- Every layer with an in-Revit test project compiles it. The implementation also runs it in Revit 2024, only through `revit-test.sh`: that script disables the add-in for the run and restores it afterwards. If Revit 2024 is open or no licence is available, compile only and report the tests as "compiled, not run". Never rename the manifests by hand.
- Keep each repo's `Quick-Backlog.md` current: add new items under "To Organize", and tick an item only with the commit as evidence.

## 0. Baseline

```bash
cd /c/repo/jhkweb
S=/c/repo/jhkweb/.claude/skills/kelly-code-abstraction/scripts
for r in Kelly-Windows-Data-v3 Kelly-Windows-v3 Kelly-Domain Kelly-Revit-Logic-v5 Kelly-Revit-UI Kelly-Revit-v5; do
  git -C $r fetch -q --prune origin
  echo "== $r: $(git -C $r branch --show-current) | $(git -C $r rev-parse --short HEAD) | $(git -C $r status -sb | head -1) | behind main $(git -C $r rev-list --count HEAD..origin/main) (non-merge $(git -C $r log --oneline --no-merges HEAD..origin/main | wc -l))"
  git -C $r status --short
done
perl $S/check-rules.pl
perl $S/scope-coverage.pl
bash $S/pins.sh show
```

The analysis needs only the layer repos. If the run touches Major Version 4 (for example a backlog item in Kelly-Revit-v4), add that repo to the loop.

- **Branch state.** If `develop` is behind `origin/main` only by merge commits, fast-forward it (`git -C <repo> merge --ff-only origin/main`). Anything else (real commits on `main`, a diverged branch): stop and tell the user.
- **The user's files.** Every file `git status` lists now is the user's.
- **Starting commits.** Record each repo's `HEAD` sha. The implementation workflow needs them as `args.base`, and the reviews and the audit diff against them.
- **Scopes.** If `scope-coverage.pl` reports uncovered files or missing paths, the tree has changed. Update `references/scopes.json`: add the new folder to the scope that fits, keep scopes to roughly 120 files or fewer, and give a new scope guidance like the others. Rerun until coverage is complete.
- **Builds.** Build every layer once to see the starting point:
  - `kbuild.sh <layer> verify` for data, windows, domain, logic and ui;
  - `kbuild.sh revit verify 2024` and one module.
  
  Errors that exist now are not the run's.
- **Pins.** Record the current pins (`pins.sh show`, one `Kelly*Version` per repo).
- **DECISIONS.md.** Write `<scratch>/packages/DECISIONS.md` with the baseline:
  - each repo's starting sha and `git status --short`;
  - the `check-rules.pl` output (a pre-existing hit, such as a namespace mismatch, goes in the plan as a move or a note);
  - the build results;
  - the pins.

## 1. Analyse (read-only)

Run the analysis workflow with the scopes as arguments:

```
Workflow({ scriptPath: "<S>/layer-analysis.workflow.js",
           args: { scratch: "<scratchpad, Git Bash form>", scopes: <the array in references/scopes.json> } })
```

- **Size.** It runs one finder per scope (17 today), reviewers in groups of 14 moves, and one compile probe per target layer: typically 40 to 50 agents. Say so in one line before you start it. `args.only: ["ui", "logic-a"]` limits it to some scopes, which is the right size when the user asks about one area.
- **Save the result.** Write the returned JSON to `<scratch>/analysis.json`.
- **`failedScopes`.** Rerun those scopes with `only`. Resuming with `resumeFromRunId` reuses everything else.
- **Check the result yourself before planning.** Open the source of every high-risk move, every upward move and a sample of the rest, and check them against `placement-rules.md`. Look at the probe's `failed`, `conflicts` and `sourceSideBreaks`: a file that failed to compile in its target is not a whole-file move. Downgrade it to a type or member extraction, or drop it.
- **Without the workflow.** The same method works with parallel `Agent` subagents: one per scope with the "Finding moves" instructions, then reviewers, then probes. Either way, finders never edit the repos.

## 2. Plan and confirm

Write `C:\repo\jhkweb\LAYER-MOVES-PLAN-<date>.md` from `references/report-template.md`:
- number the moves `#1` … `#N`, grouped by target layer bottom-up;
- list the rejected moves with reasons;
- record the rules baseline and the implementation order.

Then show the user the summary and the decisions only they can make. Use `AskUserQuestion` for the most important ones, up to four, each with a recommendation. They include:
- medium- and high-risk moves;
- upward moves;
- public API breaks;
- anything that changes a persisted type name;
- anything touching an approved exception.

**Stop here until the user confirms.** Their answers go into `DECISIONS.md`: what was dropped, what was deferred, and why.

## 3. Work packages

From the confirmed plan, write one `<scratch>/packages/P<n><letter>-<layer>-<topic>.md` per work package, following "Work packages and DECISIONS.md" in `placement-rules.md`:
- group moves by target layer, then by concern;
- about 25 moves at most per package, each package becoming one commit;
- each move carries its record, the review notes and the probe result;
- a package is a MOVE (behaviour kept exactly) or, only when the user decided it at the plan, a FIX (changes only the behaviour the spec names). Never mix the two in one package.

If you worked the moves out in more detail first (code designs, review corrections), save them as one file in the scratchpad, for example `<scratch>/design.json`. Name it in each spec, and pass it to the workflow as `args.design`.

The implementation steps run from the lowest layer that changes up through `revit`. Layers in between with no moves are repin-only steps (`packages: []`): they still get repinned, rebuilt, repacked and committed.

## 4. Implement, bottom-up

- **Large plans.** Run the implementation workflow:

  ```
  Workflow({ scriptPath: "<S>/layer-moves.workflow.js",
             args: { scratch: "<scratchpad, Git Bash form>",
                     date: "<yyyy-mm-dd, today>",
                     base: { "Kelly-Windows-v3": "<sha>", "Kelly-Domain": "<sha>", … },   // the starting commits from step 0, one per repo in steps
                     design: "<scratch>/design.json",                                    // optional
                     steps: [ { layer: "windows", packages: ["P2a-windows-text"] }, { layer: "domain", packages: [] }, …, { layer: "revit", packages: ["P6a-revit-…"] } ] } })
  ```

  `steps` must be consecutive layers, bottom-up, ending with `revit`. Per layer, the workflow runs:
  - one agent per work package: repin (first package only), tests first, the change, docs and backlog, **one commit**;
  - an adversarial review of the layer's commits since `base`;
  - fix until every configuration builds, the tests pass (in-Revit ones through `revit-test.sh`) and `check-rules.pl` shows nothing new, with up to three attempts;
  - pack, and the version docs (Changelog headings and README pin), which overlap with the next layer;
  - after the last layer, an audit.

  If it logs `STOPPING`, read that step's record, fix the cause inline, and resume with `resumeFromRunId` or finish the remaining layers by hand.
- **Small plans** (roughly 15 moves or fewer): follow `references/chain-release.md` yourself, one layer at a time.

Either way, Kelly-Revit comes last. It is where every blind consumer edit first compiles: all 21 configurations (host and six modules × 2024, 2025, 2026), plus the in-Revit test project.

## 5. Audit

Don't rely on the workflow's audit alone; check these yourself:
- `perl $S/check-rules.pl` shows no new hit compared with the baseline;
- each move's status (done, partial, skipped, missing), checked in the code;
- `git -C <repo> log --stat <base>..HEAD` per repo has only this run's files;
- the user's baseline files are still uncommitted and unchanged by you (`git diff` on them);
- `pins.sh show`: each repo pins the package this run packed for the layer below it;
- `ls /c/ProgramData/Autodesk/Revit/Addins/2024 | grep -i kelly`: the manifests are as they were at the start (an interrupted `revit-test.sh` run could leave one as `.addin.x`).

## 6. Report

Write `C:\repo\jhkweb\LAYER-MOVES-<date>.md` from `references/report-template.md`. It covers:
- the result table;
- what moved, by layer;
- what was not done;
- behaviour the user may notice;
- bugs found and deliberately not fixed;
- what to check.

Update the root working documents that name moved types (`UBIQUITOUS-LANGUAGE.md`, `SOLID Check.md`). Commit them, the plan and the report to the local root repo, with explicit paths. Never push the root repo.

Reply with:
- the result table;
- the counts (planned, done, partial, skipped);
- the rules result;
- what was compiled but not run;
- one concrete next step. Usually that is any in-Revit tests that were not run, then pushing `develop` bottom-up when the user says so.
