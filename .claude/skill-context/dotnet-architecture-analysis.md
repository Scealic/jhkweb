# Context for the dotnet-architecture-analysis skill

The project's layers, repositories, paths, rules and history. Files beside this one, in `dotnet-architecture-analysis/`:

| File | Use |
|---|---|
| `project.json` | The constants the scripts and workflows read: root, layers (name, folder, build key, role, root namespace, forbidden namespaces, build project and configurations, test projects), add-in modules, command interfaces, Revit patterns, known exceptions, scan roots. Pass it as `args.project` to both workflows. `check-rules.pl` and `scope-coverage.pl` find it from the working folder upward. |
| `scopes.json` | The analysis scopes: one finder per scope, together covering every source file once. Pass the array as `args.scopes`. |
| `placement-rules.md` | The project part of the placement rules: the six layers, the user's hard rules, the placement table, views and models, the unsafe-move list. |
| `layers.md` | Per-repository projects, configurations, test projects, pins and where each README states them, Changelog heading forms, root working documents. |

Scripts (Git Bash), in `C:\repo\jhkweb\.claude\skill-context\scripts\` (`P=/c/repo/jhkweb/.claude/skill-context/scripts`); other skills use them too:

| Script | Use |
|---|---|
| `bash $P/kbuild.sh <layer> verify\|test\|revittests\|pack [configurations]` | Build without a package, run the non-Revit tests, compile the in-Revit test project, or pack every configuration with one version. Layers: data, windows, domain, logic, ui, revit, alltrade, pipetrade, ducttrade, contenter, manager, developer. Kelly-Revit builds never install (`NoInstall.targets`). Prints `errors=N` per configuration and `PACKED <layer> <version>`. |
| `bash $P/pins.sh show [repository...]`, `pins.sh set <repository> <version>` | Print every repository's `Kelly*Version` pin (default: the six v5 repositories), or set one (`pins.sh set Kelly-Revit-UI 5.26.1104.930`). |
| `bash $P/revit-test.sh <test csproj> <filter\|-> <log> [msbuild arguments]` | Run an in-Revit test project in Revit 2024 against this source. It renames the active `Kelly Tools For Revit*.addin` manifests to `.addin.x` for the run and restores them, even when the run fails. Never rename the manifests by hand. |

The skill's own `insert-changelog.pl`, `check-rules.pl` and `scope-coverage.pl` stay in the skill (`$HOME/.claude/skills/dotnet-architecture-analysis/scripts`).

## The user's request and decisions

The skill does the user's original request:

> Analyze all repositories to determine what code can be abstracted to a more appropriate architectural layer. If you build, a new nuget package is created so you can update dependencies as you [go]. Rules:
> - The Kelly-Windows repo should not know anything about the revit api.
> - The Kelly-Windows.data repo should not know anything about the revit api.
> - Leave all of the following types in the Kelly.Revit repo: IExternalCommands, \*View.xaml, \*View.cs, \*ViewModel.cs

On 2026-11-06 the user set the limit, emphatically: "NO TYPES THAT ARE PART OF WPF MVVM SHALL MOVE OUT OF Kelly.Revit." Views, controls, view models, bound models, `ICommand` implementations, converters and behaviours stay in Kelly-Revit as types; only code inside them may leave, as members of non-MVVM types (rule 2). On models the user added: "maybe someday we can move the models of a MVVM set but lets just keep them together for now". Don't propose model moves until they reopen it.

On 2026-11-04 the user widened the last rule: "I just want to include or change the MVVM rules so it ok to abstract any code within a view, view mode or model that can/should be abstracted." The files and their classes stay in Kelly-Revit. Any code inside them that is not presentation moves to the lowest layer that fits, whatever its size (rule 6 and "Views, view models and models" in `placement-rules.md`).

## Layers

```
Kelly-Windows-Data → Kelly-Windows → Kelly-Domain → Kelly-Revit-Logic → Kelly-Revit-UI → Kelly-Revit (src/ host + modules/Trade.All, .Pipe, .Duct, .Contenter, .Manager, .Developer)
 data access         generic helpers   Kelly model     Revit DB only       ribbon/command/MVVM    the add-in: tools, commands, views
 ───────────── Revit-free ─────────────────────────    framework
```

Repositories under `C:\repo\jhkweb` (Major Version 5): Kelly-Windows-Data-v3, Kelly-Windows-v3, Kelly-Domain, Kelly-Revit-Logic-v5, Kelly-Revit-UI, Kelly-Revit-v5; each on `develop`, remote `origin`, default branch `main`. If a run touches Major Version 4 (an issue in Kelly-Revit-v4, for example), add that repository to the baseline loop. The ground rules come from `BuildConfigs/SHARED-AGENTS.md`, each repository's `AGENTS.md` and the user's corrections; re-read them at the start, their current text wins.

**Last checked against the repositories: 2026-11-06.** If a script, path or version format here no longer matches the repositories, fix this context first and update the date.

## Runs so far

Plans and reports in `C:\repo\jhkweb\Planning\Layer Moves`:
- **2026-10-12:** planned 173 moves and did 169 of them, with no behaviour changed and no rule broken.
- **2026-11-03, round 1:** 14 work packages from a view model review, through Kelly-Windows-v3, Kelly-Domain and Kelly-Revit-Logic-v5, all done and pushed on 2026-11-04 (`LAYER-MOVES-PLAN-2026-11-03.md`, `LAYER-MOVES-2026-11-03.md`).
- **2026-11-04, round 2:** 302 moves in 42 packages through all six layers, filed in Linear (project "Layer Moves 2026-11-04 Round 2"); 38 done, 4 partial (`LAYER-MOVES-PLAN-2026-11-04-Round-2.md`, `LAYER-MOVES-2026-11-04-Round-2.md`).
- **2026-11-06:** 79 moves in 18 packages (Windows through Kelly-Revit), filed in Linear (project "Layer Moves 2026-11-06"); 16 packages done, 2 partial; pushed at the user's request (`LAYER-MOVES-PLAN-2026-11-06.md`, `LAYER-MOVES-2026-11-06.md`).

## Paths

- Plans folder: `C:\repo\jhkweb\Planning\Layer Moves` (the local root repository). Plan `LAYER-MOVES-PLAN-<date>.md`, report `LAYER-MOVES-<date>.md`.
- Root working documents that name moved types: `UBIQUITOUS-LANGUAGE.md` (rename the term and note the old name with its date), `Planning\SOLID Check\SOLID Check.md`, `.claude/CLAUDE.md`. Commit them, the plan and the report to the local root repository with explicit paths; never push it. Leave `Planning\Layer Moves\ARCHITECTURAL-ANALYSIS-moves.csv` and `Kelly-Revit-v5/doc/Design/*.csv` alone: they record past states.
- Local package folder: `C:\repo\NugetPackages`. Build logs and the record of packed versions: `$KELLY_BUILD_LOGS` (default `$TEMP/kelly-build`).
- Add-in manifests (step 6 audit): `ls /c/ProgramData/Autodesk/Revit/Addins/2024 | grep -i kelly` must show them as they were at the start (an interrupted `revit-test.sh` run can leave one as `.addin.x`).

## Baseline loop (step 0)

```bash
cd /c/repo/jhkweb
S=$HOME/.claude/skills/dotnet-architecture-analysis/scripts; P=/c/repo/jhkweb/.claude/skill-context/scripts
for r in Kelly-Windows-Data-v3 Kelly-Windows-v3 Kelly-Domain Kelly-Revit-Logic-v5 Kelly-Revit-UI Kelly-Revit-v5; do
  git -C $r fetch -q --prune origin
  echo "== $r: $(git -C $r branch --show-current) | $(git -C $r rev-parse --short HEAD) | $(git -C $r status -sb | head -1) | behind main $(git -C $r rev-list --count HEAD..origin/main) (non-merge $(git -C $r log --oneline --no-merges HEAD..origin/main | wc -l))"
  git -C $r status --short
done
perl $S/check-rules.pl
perl $S/scope-coverage.pl
bash $P/pins.sh show
```

Baseline builds: `kbuild.sh <layer> verify` for data, windows, domain, logic and ui; `kbuild.sh revit verify 2024` and one module.

## Workflows

- The analysis runs one finder per scope (17 today), reviewers in groups of 14 moves, and one compile probe per target layer: typically 40 to 50 agents. `args.only: ["ui", "logic-a"]` limits it to some scopes.
- The Workflow tool refused a `scriptPath` in the skills folder (2026-11-06): read the whole `.workflow.js` file and pass it through `script` with the same `args`.
- Implementation `args.steps` layers: `data`, `windows`, `domain`, `logic`, `ui`, `revit`; `args.base` keys are the repository folders (`"Kelly-Windows-v3": "<sha>"`, …). The Kelly-Revit step builds all 21 configurations (host and six modules × 2024, 2025, 2026) plus `test/Tests.Revit/Core.Tests.csproj`.
- Before step 5, `tasklist | grep -i -E "Revit.exe|ricaun"`: if Revit 2024 is open, ask the user to close it (round 2 of 2026-11-04 only compiled about 2,100 in-Revit tests because it was open). In-Revit runs use Revit 2024; the Logic suite takes about 30 minutes.

## Work package lessons

- "Moved from …" provenance goes in the Changelog entry, not in XML docs of the Revit-free layers (it names the higher layers there). Say so in every Revit-free target spec: on 2026-11-06 agents still added eight such `<remarks>` to Kelly-Domain (KD-59).
- A move's `requiredChanges` that touch a lower layer (a constant in Kelly-Domain, a mapping in Kelly-Revit-UI's prompt) become a target package in that lower layer's step, or the move waits. Round 2 of 2026-11-04 left four packages partial this way.
- Source packages: without one the original stays and keeps running, which happened to 82 moves in round 2a.
- Check the lower layer covers every option a source half needs: on 2026-11-06, three TaskDialogs could not switch to `UserPrompt` because `PromptRequest` has no `FooterText` (KTR5-4765), and one summary text had nowhere to go once its type had moved to an already-packed layer (KD-58).

## Linear

- Workspace "Virtual Construction" (`jhkelly-ktr`); team table in `linear-teams.md` beside this file: Kelly-Windows-Data-v3 → KWD3, Kelly-Windows-v3 → KW3, Kelly-Domain → KD, Kelly-Revit-Logic-v5 → KTRL5, Kelly-Revit-UI → KTRUI, Kelly-Revit-v5 → KTR5; the v4 repositories to their own teams. BuildConfigs has no team.
- In KTR5, add the "5 - Feature" and "5 - Module" labels of the tool a package touches (rules in `C:\repo\jhkweb\.claude\LINEAR-KTR.md`).
- Example issue keys in reports look like `KW3-12`.

## Chain release specifics

- Kelly-Revit goes last: it is where the Kelly-Revit source packages run and where every consumer edit first compiles.
- Repin it with `pins.sh set Kelly-Revit-v5 <ui version>`; the host and all six modules share that one property. The host also pins the CSV reader, `Kelly.Windows.Data.Csv`, by a literal version outside the chain: if Kelly-Windows-Data was repacked, check restore shows no `NU1605`/`NU1608` warning for it.
- Build all 21 configurations: `for l in revit alltrade pipetrade ducttrade contenter manager developer; do bash $P/kbuild.sh $l verify; done`, then `kbuild.sh revit revittests 2024`, which checks every module's commands, availability classes and push buttons.
- Confirm restore used the new versions: `find src/obj modules/*/obj -maxdepth 2 -name project.assets.json | xargs grep -ohE '"Kelly\.[A-Za-z.]+\.(Net481|2024)/[0-9.]+"' | sort | uniq -c`.
- Versions: `BuildConfigs/dotnet/.props/Version.Build.props` sets `<MajorVersion>.yy.MMdd.HHmm`, each number without leading zeros. MajorVersion: Kelly-Windows-Data-v3 and Kelly-Windows-v3 3; Kelly-Domain and Kelly-Revit-UI 1; Kelly-Revit-Logic-v5 and Kelly-Revit-v5 5. Kelly-Domain built on 2026-11-03 at 17:17 is `1.26.1103.1717`.
- Changelog headings: package repositories `## 2026-11-03 (not yet in a package): <summary>`, then `(package 1.26.1103.1717)`; Kelly-Revit `(not yet in a build)`, or `(version 5.26.1103.1035)` for an installed build.
- Test attribute form: `Author = "Verified By Human On:"` and a `Description` of what is verified, never a date (`SHARED-AGENTS.md`).
- Push merge order: Data, Windows, Domain, Logic, UI, Kelly-Revit.
- Pitfalls: `kbuild.sh pack` refuses a version it already used for that layer this minute (exit code 3), because the NuGet cache would serve the old package: wait for the minute. Logic and Kelly-Revit name their assembly `$(SolutionName)`; built alone without `-p:SolutionName=...` the assembly is `Revit.dll` (the scripts pass it). Kelly-Revit builds must not install the add-in, so build through `kbuild.sh`. In a run with the add-in disabled, tests that need the add-in started (for example `EventServiceTests` and `ApplicationLoggerTests`) fail by design: name them in the report rather than fixing them.
