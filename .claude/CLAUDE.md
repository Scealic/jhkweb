# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Layout

`C:\repo\jhkweb` holds sibling repos (each with its own git, `develop` and `main`); run git per repo with `git -C <repo>`. Since 2026-11-02 the root is also
its own local git repo (branch `main`, no remote) that tracks only the working documents at this level (architecture notes, plans, `UBIQUITOUS-LANGUAGE.md`,
`*.mmd` diagrams, `Monthly Reports`, `db-deprecation`, `.claude`, the root `Directory.Build*.targets`). Its `.gitignore` lists every sibling repo folder: add a
new repo's folder there when one is cloned here. A plain `git` command run at the root acts on this outer repo, not on any sibling.

Each repo keeps its own backlog in `Quick-Backlog.md` at its root (since 2026-11-02; its `AGENTS.md` points to it, `BuildConfigs/SHARED-AGENTS.md` has the rule). Items that cover a whole major version live in Kelly-Revit-v4 or Kelly-Revit-v5. `Backlog - Quick.md` at the root is the index of them, plus the items that belong to no repo. The `kelly-backlog-update` skill maintains them.

Claude Code configuration lives at two levels (since 2026-11-03). Each repo has a checked-in `.claude/settings.json` (allows `dotnet build`/`test`/`restore`/`list`, read-only git commands and `tasklist`; denies new branches and pushes to `main`; Kelly-Revit-v5 also denies `InstallAddin=true`), and its `.claude/settings.local.json` is git-ignored for personal entries. A change to these permissions goes into all 18 copies. Skills, commands and `launch.json` that span repos stay in this root `.claude` (`kelly-backlog-update`, `kelly-layer-moves`, `kelly-solid-check`, `kelly-ribbon-buttons` (it covers both Kelly-Revit-v4 and v5), `kelly-repo-activity`, `kelly-linear-projects` (suggests Linear projects from the backlogs, creates them after approval and files the issues in them), `linear-issue-estimate-update` (proposes a point estimate for every open issue of every Linear team in a dated report under `Linear Estimates`, sets them after approval), `linear-issue-info-review` (checks every open Kelly-team Linear issue for a problem or goal, where in the code, and repro steps for fixes; drafts the gaps from the code, interviews the user, rewrites the descriptions and closes stale issues after approval; skips Hasa), `linear-issue-split-review` (finds open Kelly-team Linear issues too big for one change, proposes sub-issues or related standalone issues per layer in a dated report under `Linear Splits`, creates and links them after approval; skips Hasa), `kelly-work-log` (the daily work log, work summary and savings report in Notes-JHKelly; the "Work Log For Today" scheduled task only calls it)). Put a skill in a repo's `.claude/skills` only when it concerns that repo alone.

Kelly Tools For Revit (KTR) is a layered .NET stack. Each layer is published as NuGet packages and **pinned by exact version** in the layer above it:

```
Kelly-Windows-Data → Kelly-Windows → Kelly-Domain → Kelly-Revit-Logic → Kelly-Revit-UI → Kelly-Revit (the add-in)
   (Net481/Net80/Net100 configurations)              (Revit 2024/2025/2026 configurations)
```

- **Kelly-Windows-Data / Kelly-Windows / Kelly-Domain**: Revit-free code (data access, WPF/Windows helpers, domain types such as `DefinitionRegistry`, `ScopeType`).
- **Kelly-Revit-Logic**: Revit API logic (documents, views, elements, MEP, spools, updaters, purges, `OperationService` transactions).
- **Kelly-Revit-UI**: shared ribbon/command/MVVM framework, selection filters, availability base classes.
- **Kelly-Revit**: the add-in. `src/` is a host (`App.cs` startup, `EventService`, `RibbonService`); every ribbon tab is a module DLL under `modules/` (AllTrade, PipeTrade, DuctTrade, Contenter, Manager, Developer).
- **BuildConfigs**: shared MSBuild props, imported by absolute path (`C:\Repo\jhkweb\BuildConfigs\dotnet\.props\*.props`) in v5, and in v4 through `$(KellyBuildConfigs)`, which each v4 repo's `Directory.Build.props` points at the BuildConfigs beside it. v4 projects share `Revit.Build.props` (Revit layers; Revit API from the `Nice3point.Revit.Api` packages, so no Revit install is needed to build) and `Framework.Build.props` (Windows layers), and keep package versions in each repo's `Directory.Packages.props` (central package management).
- **VCS-Database-General-Schema / VCS-Database-Content-Schema**: SQL Server schema projects (branches `develop` and `production`) for the databases Kelly-Revit-Data-Exporter exports to the CSV data files. Neither major version of the add-in reaches SQL Server (v4 since 2026-10-22, v5 since 2026-10-30); both read the data files in `C:\Program Files\JH Kelly\Kelly Tools For Revit\Data`.

A change in a lower layer reaches the add-in only after that layer is packed, the layers above are re-pinned to the new version, and Kelly-Revit is rebuilt.

## Agent rules

The rules shared by the Kelly .NET repos (the v5 and v4 layer repos, the format libraries and Kelly-Revit-Data-Exporter) live once in `BuildConfigs/SHARED-AGENTS.md`, imported here:

@../BuildConfigs/SHARED-AGENTS.md

Each of those repos' `AGENTS.md` adds only that repo's rules and pitfalls (the v4 Revit repos override TDD: they have no tests) and points to the shared file. Its `CLAUDE.md` imports both (`@../BuildConfigs/SHARED-AGENTS.md`, `@AGENTS.md`). BuildConfigs and the two VCS schema repos have their own standalone `AGENTS.md`, imported by a `CLAUDE.md` of `@AGENTS.md`. Change a shared rule in `SHARED-AGENTS.md`, not in each repo.

When a develop→main pull request deletes the remote `develop`, the next push recreates it; set the local branch to track `origin/develop` again.

## Building

- Always pass a configuration: `-c Net481|Net80|Net100` for the three lower layers, `-c 2024|2025|2026` for the Revit layers (Kelly-Revit also has `2024Debug` etc.). Without one, a v4 project stops with `KTR0005`, which lists its configurations; a v5 project's restore fails on old target frameworks.
- `Kelly-Revit-Logic` and `Kelly-Revit` name their assembly `$(SolutionName)`. Building a project file outside its solution needs `-p:SolutionName=Kelly.Revit.Logic` (or `Kelly.Revit`); otherwise the assembly is built as `Revit.dll`, which fails to load inside Revit (`BadImageFormatException`). Kelly-Revit-UI defaults it.
- Builds **generate NuGet packages** into `C:\Repo\NugetPackages` (`Package.Build.props`). Pass `-p:GeneratePackageOnBuild=false` when you are not producing a release package.
- Package version is the build time, `yy.M.d.HHmm` (`Version.Build.props`); the leading zero of the minutes is dropped in file names (`0932` → `.932`). To give every project of one release the same version pass `-p:VersionCalculated=<v> -p:FileVersionCalculated=<v>`.
- Mass `CS0234`/missing-namespace errors usually mean a pin points at a package version that does not exist in `C:\Repo\NugetPackages`, not broken source.
- **Building Kelly-Revit installs the add-in** (Program Files and the ProgramData `.addin` manifest) for that Revit year. To build or test without replacing the installed add-in, add `"-p:CustomAfterMicrosoftCommonTargets=C:\repo\jhkweb\Kelly-Revit-v5\test\Tests.Revit\NoInstall.targets"`.
- **Repo and folder names carry the repo's own `<MajorVersion>`** (since 2026-10-27). KTR v5 is built from `Kelly-Windows-Data-v3`, `Kelly-Windows-v3`, `Kelly-Domain`, `Kelly-Revit-Logic-v5`, `Kelly-Revit-UI` and `Kelly-Revit-v5`; KTR v4 from `Kelly-Windows-Data-v2`, `Kelly-Windows-v2`, `Kelly-Revit-Logic-v4` and `Kelly-Revit-v4`. Each is its own GitHub repo, worked on `develop`. The layer names in this file (Kelly-Revit, Kelly-Windows, …) mean the layer, in whichever of its repos. The old `main-v2`/`main-v4` branches of the v5 repos are a read-only archive. Each major version installs to its own folder and manifest (since 2026-11-02, BuildConfigs' `AddinInstall.Build.targets`): `C:\Program Files\JH Kelly\Kelly Tools For Revit\V<n>\<year>` (`Kelly Tools For Revit <n>\<year>` until the afternoon of 2026-11-02) and `C:\ProgramData\Autodesk\Revit\Addins\<year>\Kelly Tools For Revit <n>.addin`. Both versions read the data files from the shared `C:\Program Files\JH Kelly\Kelly Tools For Revit\Data`. Only one version can load in a Revit year, so an install renames the other versions' manifests (and the unversioned `Kelly Tools For Revit.addin` of older builds) to `.addin.x`: the version installed last is active. The jhkweb root `Directory.Build.targets` (not in any repo) stops builds in `Kelly-Revit-v5` from installing, so they don't switch Revit to v5: they warn `KTR0004` instead. Pass `-p:InstallAddin=true` to install a v5 build on purpose. `Kelly-Revit-v4` builds install as before.
- If restore fails with 401 from the Telerik feed, pass sources explicitly: `"-p:RestoreSources=https://api.nuget.org/v3/index.json;C:\repo\NugetPackages;<local Telerik package folder>"`.

```bash
dotnet build Kelly-Domain/Kelly.Domain.slnx -c Net80 -p:GeneratePackageOnBuild=false
dotnet build Kelly-Revit-Logic-v5/Kelly.Revit.Logic.slnx -c 2026 -p:GeneratePackageOnBuild=false
```

## Testing

Two kinds of NUnit tests:

| Repo | Without Revit | Inside Revit |
|---|---|---|
| Kelly-Windows-Data | `tests/Data.Tests.csproj` | – |
| Kelly-Windows | `tests/Logic.Tests.csproj` | – |
| Kelly-Domain | `tests/Domain.Tests.csproj` | – |
| Kelly-Revit-Logic | – (removed; every Logic test runs inside Revit) | `test/Revit.Logic.RevitTests` |
| Kelly-Revit-UI | `test/Revit.UI.Tests` | `test/Revit.UI.RevitTests` |
| Kelly-Revit | – | `test/Tests.Revit` |

In-Revit tests run in **Revit 2024** (`-c 2024`, .NET Framework 4.8.1) unless told otherwise; Revit 2026 is missing template paths that show a dialog at startup.

```bash
dotnet test Kelly-Revit-Logic-v5/test/Revit.Logic.RevitTests/Revit.Logic.RevitTests.csproj -c 2024 -p:SolutionName=Kelly.Revit.Logic -p:GeneratePackageOnBuild=false --filter "FullyQualifiedName~PurgeTests"
dotnet test Kelly-Revit-UI/test/Revit.UI.RevitTests/Revit.UI.RevitTests.csproj -c 2024 -p:GeneratePackageOnBuild=false
```

- The "without Revit" project (UI) cannot call the Revit API at run time (RevitAPI.dll is not copied); it covers pure logic, names and argument checks.
- The `*.RevitTests` projects use **ricaun.RevitTest.TestAdapter**: `dotnet test` starts the Revit version of the configuration, runs the tests on Revit's thread and closes Revit (`-p:RevitTestKeepOpen=true` keeps it open). The adapter runs **NUnit 3.13.3** (the other test projects use NUnit 4), so use `Assert.That` constraints only. Revit for that year must be closed before a run, and a licence is needed. A full Logic run takes about 30 minutes. The adapter stops a run after its `NUnit.Timeout` (assembly metadata, in minutes; default 10) and drops the tests not yet run without reporting them, so the Logic project sets it to 45. If a run reports fewer tests than discovery finds, raise it.
- Before a run, check no Revit or `ricaun.RevitTest.Console` is already running for that year; a run started while one is running fails or waits. A run that is killed (a session restart, a stopped task) leaves the `.addin.x` rename below in place, so check the manifest afterwards.
- Fixtures derive from `Abstractions/RevitApiTest` (injected `Application`/`UIApplication`; `OpenIsolatedCopy`, `OpenSharedCopy`, `CreateIsolatedProject`), `RevitFamilySampleTest` or `RevitModelSampleTest` (samples in `C:\Program Files\Autodesk\Revit <year>\Samples`; the model sample is Snowdon Towers HVAC).
- **In-Revit tests bind to the Kelly DLLs the installed add-in already loaded**, not the copies beside the test assembly. A Logic or UI change is therefore tested against the installed version (new members fail with `MissingMethodException`). To test new source, rename the active `C:\ProgramData\Autodesk\Revit\Addins\<year>\Kelly Tools For Revit <n>.addin` (the one not already `.addin.x`) to `.addin.x` for the run so Revit starts without the add-in, and rename it back afterwards.
- With the add-in loaded, its own resolver and data are registered over the test stubs (`KellyDefinitions`, below), and the active add-in may be the other major version. Tests that open documents should run with the add-in disabled as above. (Builds before 2026-10-22 for v4 and 2026-10-30 for v5 also reconciled project information against the production SQL Server on every open.)
- **Every `dotnet test` run writes a Markdown log**: `<repo>\<test or tests>\TestLogs\<test assembly> - <framework>.md` (git-ignored), one file per test assembly and target framework, replaced on every run: one row per test (fixture, test, parameters, result, time, message) and the totals. It is a VSTest logger, `BuildConfigs/dotnet/TestLogger`, that each test project imports through `BuildConfigs/dotnet/.props/Test.Build.props`. It has to be a VSTest logger because under ricaun the tests can't log themselves: ricaun runs them with its own runner (`ricaun.NUnit`), so NUnit's `TestContext` is empty and `ITestAction` never fires. Logger errors go to `%LOCALAPPDATA%\Kelly Unit Test Logs\errors.txt`. Compare a log's rows with the number of tests discovered to find tests that never ran.
- Code that prompts goes through `Kelly.Windows.Prompts.UserPrompt`, which throws when nothing is registered; tests register a recording `IUserPrompt`. `OperationService` logs to `C:\Projects\Revit\<document title>`; tests remove that folder with `Abstractions/ProjectFolders.Delete`.
- The Logic `Abstractions/RevitApiTest` handles Revit's failure messages for every transaction of a fixture (warnings deleted, errors resolved with their default resolution, all recorded in `RevitFailures`), so no failure dialog stops an unattended run. Move ducts or pipes only after disconnecting them: moving a joined one raises an error whose default resolution deletes it.
- **Kelly shared parameters and data without the data files:** Logic's `Abstractions/KellyDefinitions` registers a `DefinitionRegistry` resolver that answers every Kelly definition name with a stub (name, and a GUID derived from the name, stable across tests because the definition sets are cached for the Revit session). `Bind` creates those shared parameters in a test document with a data type each (TEXT, INTEGER, NUMBER, LENGTH, MASS, YESNO, MATERIAL), `Definition` makes a deprecated or category-bound stub, `UseDataFiles` registers a `DataFiles` list and `UseStore` a `DataStore` built from in-memory rows (`DataStoreRecords`). `Spools/SpoolTests` and `Updaters/ElementServiceTests` show the use. Needs the Kelly add-in disabled, which registers the real resolver.
- The Revit samples have no fabrication configuration, no Kelly families and no Kelly parameters; tests that need them (fabrication parts, Kelly supports, real project data) cannot run on the samples. A document opened by a test has no active view and no `UIDocument`, so availability classes, `CommandBase`, the `UIDocument` scope helpers and `TagDistributor` are not testable this way.
- The Kelly element readers check a parameter's storage type, so bind each stub with the data type the add-in uses (for example JHK Total Weight as MASS).

## Runtime architecture worth knowing

- `Kelly-Revit-v5/src/App.cs` `OnStartup` registers the process-wide seams the lower layers depend on before anything else runs: `UserPrompt.Register`, `DefinitionRegistry.Register` (shared parameter definitions, from the data files), `DataFiles.Register` and `DataFiles.RegisterStore` (Kelly.Domain: the lists and the `DataStore`), `AddInServices.Register`. It then loads the CSV data files through Kelly.Revit.UI's `DataFileLoader` (a problem shows the "Kelly Tools For Revit Data Error" dialog and fails startup, as v4 does), starts every `IApplicationService` in `StartOrder` through `Kelly.Windows.Hosting.ServiceProvider.AddServices` (`DataFileService` 0, `AutoUpdaterService` 2, …, `EventService` 5) and fails startup if any does not start. Reload Data (Trade.All, Updater panel) reloads through the same loader.
- `EventService` subscribes the Revit application/UI events. The document handlers live in Kelly-Revit (`src/EventHandlers`) and Kelly-Revit-Logic (`Documents/*EventHandler`); a handler left `null` makes Revit throw at subscription.
- Code that needs Kelly shared parameters or the data files (updaters, Kelly parameter helpers, the assigner combo boxes) works in a Kelly project with the add-in started, or in tests through `KellyDefinitions` (above); the Revit samples have none of these parameters.
- Ribbon modules are discovered by `RibbonService`; `test/Tests.Revit/AddIn/AddInContractTests` checks every module's commands, availability classes and push buttons (transaction attribute, constructors, icons embedded as `<ImageName>16.png`/`32.png`).
