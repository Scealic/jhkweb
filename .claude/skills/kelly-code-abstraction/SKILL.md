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

The first run (2026-10-12) planned 173 moves and did 169 of them. It changed no behaviour and broke none of the rules. This skill makes that run repeatable on today's code: six layers (Kelly-Revit-UI has been added since), and Kelly-Revit as a host plus six modules.

```
Kelly-Windows-Data → Kelly-Windows → Kelly-Domain → Kelly-Revit-Logic → Kelly-Revit-UI → Kelly-Revit (src/ host + modules/AllTrade, PipeTrade, DuctTrade, Contenter, Manager, Developer)
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
| `scripts/layer-moves.workflow.js` | Implementation, bottom-up: per layer, the stages in step 5 below, then an audit. |
| `scripts/kbuild.sh`, `pins.sh`, `insert-changelog.pl` | Build, test or pack a layer (Kelly-Revit never installs); set or show pins; insert a Changelog entry. |

`S=/c/repo/jhkweb/.claude/skills/kelly-code-abstraction/scripts`. Use Git Bash, never PowerShell.

## Ground rules

These come from `BuildConfigs/SHARED-AGENTS.md`, the repos' `AGENTS.md` and corrections the user has made. Re-read those files at the start: the user edits them, and their current text wins over this list.

- **Nothing changes in the repos until the user confirms the plan.** The analysis is read-only. Probes build copies in the scratchpad.
- Work on `develop` only: no other branch, never push `main`, push only when asked. No `Co-Authored-By` or similar line in commits.
- Never stage, commit or revert the user's own uncommitted or staged files. Take a baseline at the start and compare against it before every commit.
- TDD: tests move or are written first. Every member needs a test. New or changed tests use the attribute form in `SHARED-AGENTS.md`, and never get a verification date.
- Preserve behaviour exactly. A bug found on the way is recorded, characterized by a test and reported, not fixed.
- Kelly-Revit builds must not install the add-in, so build through `kbuild.sh`. In-Revit test projects are compiled, not run, unless the user asks (a run needs Revit closed and the add-in disabled; see `C:\repo\jhkweb\.claude\CLAUDE.md`).

## 0. Baseline

```bash
cd /c/repo/jhkweb
for r in Kelly-Windows-Data Kelly-Windows Kelly-Domain Kelly-Revit-Logic Kelly-Revit-UI Kelly-Revit; do
  git -C $r fetch -q --prune origin
  echo "== $r: $(git -C $r branch --show-current) | $(git -C $r status -sb | head -1) | behind main $(git -C $r rev-list --count HEAD..origin/main) (non-merge $(git -C $r log --oneline --no-merges HEAD..origin/main | wc -l))"
  git -C $r status --short
done
perl $S/check-rules.pl
perl $S/scope-coverage.pl
```

- **Branch state.** If `develop` is behind `origin/main` only by merge commits, fast-forward it (`git -C <repo> merge --ff-only origin/main`). Anything else (real commits on `main`, a diverged branch): stop and tell the user.
- **The user's files.** Every file `git status` lists now is the user's.
- **Scopes.** If `scope-coverage.pl` reports uncovered files or missing paths, the tree has changed. Update `references/scopes.json`: add the new folder to the scope that fits, keep scopes to roughly 120 files or fewer, and give a new scope guidance like the others. Rerun until coverage is complete.
- **Builds.** Build every layer once to see the starting point:
  - `kbuild.sh <layer> verify` for data, windows, domain, logic and ui;
  - `kbuild.sh revit verify 2024` and one module.
  
  Errors that exist now are not the run's.
- **Pins.** Record the current pins with `pins.sh show` on each repo's project files.
- **DECISIONS.md.** Write `<scratch>/packages/DECISIONS.md` with the baseline: each repo's `git status --short`, the `check-rules.pl` output (pre-existing hits, such as a namespace mismatch, go in the plan as moves or notes), the build results and the pins.

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
- about 25 moves at most per package;
- each move carries its record, the review notes and the probe result.

The implementation steps run from the lowest layer that changes up through `revit`. Layers in between with no moves are repin-only steps (`packages: []`): they still get repinned, rebuilt, repacked and committed.

## 4. Implement, bottom-up

- **Large plans.** Run the implementation workflow:

  ```
  Workflow({ scriptPath: "<S>/layer-moves.workflow.js",
             args: { scratch: "<scratchpad>", steps: [ { layer: "windows", packages: ["P2a-windows-text"] }, { layer: "domain", packages: [] }, …, { layer: "revit", packages: ["P6a-revit-…"] } ] } })
  ```

  Per layer, it runs:
  - implement (repin, tests first, move, repoint consumers);
  - an adversarial review of the diff;
  - fix until every configuration builds and tests green and `check-rules.pl` shows nothing new;
  - pack;
  - docs and commit, which overlap with the next layer;
  - after the last layer, an audit.

  If it logs `STOPPING`, read that step's record, fix the cause inline, and resume with `resumeFromRunId` or finish the remaining layers by hand.
- **Small plans** (roughly 15 moves or fewer): follow `references/chain-release.md` yourself, one layer at a time.

Either way, Kelly-Revit comes last. It is where every blind consumer edit first compiles: all 21 configurations, plus the in-Revit test project compiled.

## 5. Audit

Don't rely on the workflow's audit alone; check these yourself:
- `perl $S/check-rules.pl` shows no new hit compared with the baseline;
- each move's status (done, partial, skipped, missing), checked in the code;
- `git -C <repo> show --stat HEAD` per repo has only this run's files;
- the user's baseline files are still uncommitted and unchanged by you (`git diff` on them);
- `pins.sh show` gives one consistent set across Kelly-Revit's seven projects.

## 6. Report

Write `C:\repo\jhkweb\LAYER-MOVES-<date>.md` from `references/report-template.md`. It covers:
- the result table;
- what moved, by layer;
- what was not done;
- behaviour the user may notice;
- bugs found and deliberately not fixed;
- what to check.

Update the root working documents that name moved types (`UBIQUITOUS-LANGUAGE.md`, `SOLID Check.md`).

Reply with:
- the result table;
- the counts (planned, done, partial, skipped);
- the rules result;
- what was compiled but not run;
- one concrete next step, usually running the in-Revit tests for Logic and Kelly-Revit in Revit 2024, then pushing `develop` bottom-up when the user says so.
