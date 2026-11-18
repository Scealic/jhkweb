# jhkweb root

## Layout

`C:\repo\jhkweb` holds sibling repositories, each with its own git, `develop` and `main`; run git per repository with `git -C <repository>`. The root is also its own git repository (branch `main`, remote `origin` = `github.com/Scealic/jhkweb`, pushed only when the maintainer asks) that tracks only the working documents at this level (architecture notes, plans, `UBIQUITOUS-LANGUAGE.md`, `*.mmd` diagrams, `Monthly Reports`, `db-deprecation`, `.claude`, the root `Directory.Build*.targets`). Its `.gitignore` lists every sibling repository folder: add a new repository's folder there when one is cloned here. A plain `git` command run at the root acts on this outer repository, not on any sibling.

Repository and folder names carry the repository's own major version. Kelly Tools For Revit (KTR) v5 is built from `Kelly-Windows-Data-v3`, `Kelly-Windows-v3`, `Kelly-Domain`, `Kelly-Revit-Logic-v5`, `Kelly-Revit-UI` and `Kelly-Revit-v5`; v4 from `Kelly-Windows-Data-v2`, `Kelly-Windows-v2`, `Kelly-Revit-Logic-v4` and `Kelly-Revit-v4`. Each is its own GitHub repository, worked on `develop`. The layer names in these instructions (Kelly-Revit, Kelly-Windows, …) mean the layer, in whichever of its repositories. The old `main-v2`/`main-v4` branches of the v5 repositories are a read-only archive. When a develop→main pull request deletes the remote `develop`, the next push recreates it; set the local branch to track `origin/develop` again.

The layers (the stack and pinning are in `SHARED-AGENTS.md`, below):

- **Kelly-Windows-Data / Kelly-Windows / Kelly-Domain**: Revit-free code (data access, WPF/Windows helpers, domain types such as `DefinitionRegistry`, `ScopeType`).
- **Kelly-Revit-Logic**: Revit API logic (documents, views, elements, MEP, spools, updaters, purges, `OperationService` transactions).
- **Kelly-Revit-UI**: shared ribbon, command and MVVM framework, selection filters, availability base classes.
- **Kelly-Revit**: the add-in. `src/` is a host (`App.cs` startup, `EventService`, `RibbonService`); every ribbon tab is a module DLL under `modules/` (AllTrade, PipeTrade, DuctTrade, Contenter, Manager, Developer).
- **BuildConfigs**: shared MSBuild property files, imported by absolute path (`C:\Repo\jhkweb\BuildConfigs\dotnet\.props\*.props`) in v5, and in v4 through `$(KellyBuildConfigs)`, which each v4 repository's `Directory.Build.props` points at the BuildConfigs beside it. v4 projects share `Revit.Build.props` (Revit layers; Revit API from the `Nice3point.Revit.Api` packages, so no Revit install is needed to build) and `Framework.Build.props` (Windows layers), and keep package versions in each repository's `Directory.Packages.props` (central package management).
- **VCS-Database-General-Schema / VCS-Database-Content-Schema**: SQL Server schema projects (branches `develop` and `production`) for the databases Kelly-Revit-Data-Exporter exports to the CSV data files. Neither major version of the add-in reaches SQL Server; both read the data files in `C:\Program Files\JH Kelly\Kelly Tools For Revit\Data`.

## Claude Code configuration

Each repository has a checked-in `.claude/settings.json` (allows `dotnet build`/`test`/`restore`/`list`, read-only git commands and `tasklist`; denies new branches and pushes to `main`), and a git-ignored `.claude/settings.local.json` for personal entries. A change to these permissions goes into all 18 copies. Claude may install a v5 build when asked. Commands and `launch.json` that span repositories stay in this root `.claude`. Skills that span repositories live in the user's personal skills folder, `C:\Users\childebran\.claude\skills`; put a skill in a repository's `.claude/skills` only when it concerns that repository alone.

At the end of the day, or whenever it is missing, refresh `Kelly Tools For Revit V5 -Systems.md` with the `kelly-systems-document` skill.

## Backlog

Each repository's backlog is its Linear team in the workspace "Virtual Construction" (`https://linear.app/jhkelly-ktr`); its `AGENTS.md` names the team. The rules shared by every team are in `BuildConfigs/LINEAR.md` (imported through `SHARED-AGENTS.md`, and by the two VCS schema repositories, which use KWDSS); BuildConfigs keeps no backlog. The KTR team rules are here, because only the root and the `Kelly-Revit*` repositories may name the application:

@LINEAR-KTR.md

## Agent rules

The rules shared by the Kelly .NET repositories (the v5 and v4 layer repositories, the format libraries and Kelly-Revit-Data-Exporter), including the stack, building and in-Revit testing, live once in `BuildConfigs/SHARED-AGENTS.md`:

@../BuildConfigs/SHARED-AGENTS.md

Each of those repositories' `AGENTS.md` adds only that repository's rules and pitfalls (the v4 Revit repositories override TDD: they have no tests), and its `CLAUDE.md` imports both (`@../BuildConfigs/SHARED-AGENTS.md`, `@AGENTS.md`). BuildConfigs and the two VCS schema repositories have their own standalone `AGENTS.md`, imported by a `CLAUDE.md` of `@AGENTS.md`. Change a shared rule in `SHARED-AGENTS.md`, not in each repository.

## Building

Beyond the shared rules:

- Kelly-Revit also has `2024Debug`-style configurations.
- `Kelly-Revit-Logic` and `Kelly-Revit` name their assembly `$(SolutionName)`. Building a project file outside its solution needs `-p:SolutionName=Kelly.Revit.Logic` (or `Kelly.Revit`); otherwise the assembly is built as `Revit.dll`, which fails to load inside Revit (`BadImageFormatException`). Kelly-Revit-UI defaults it.
- Package file names drop the leading zero of the minutes (`0932` → `.932`). To give every project of one release the same version, pass `-p:VersionCalculated=<v> -p:FileVersionCalculated=<v>`.
- **Building Kelly-Revit installs the add-in** (Program Files and the ProgramData `.addin` manifest) for that Revit year. To build or test without replacing the installed add-in, add `"-p:CustomAfterMicrosoftCommonTargets=C:\repo\jhkweb\Kelly-Revit-v5\test\Tests.Revit\NoInstall.targets"`.
- Each major version installs to `C:\Program Files\JH Kelly\Kelly Tools For Revit\V<n>\<year>` and `C:\ProgramData\Autodesk\Revit\Addins\<year>\Kelly Tools For Revit <n>.addin` (BuildConfigs' `AddinInstall.Build.targets`). Only one version can load in a Revit year, so an install renames the other versions' manifests (and an unversioned `Kelly Tools For Revit.addin`) to `.addin.x`: the version installed last is active.
- The root `Directory.Build.targets` (not in any repository) stops builds in `Kelly-Revit-v5` from installing and warns `KTR0004` instead. Pass `-p:InstallAddin=true` to install a v5 build on purpose. `Kelly-Revit-v4` builds install.

```bash
dotnet build Kelly-Domain/Kelly.Domain.slnx -c Net80 -p:GeneratePackageOnBuild=false
dotnet build Kelly-Revit-Logic-v5/Kelly.Revit.Logic.slnx -c 2026 -p:GeneratePackageOnBuild=false
```

## Testing

Beyond the shared rules. Two kinds of NUnit tests:

| Repository | Without Revit | Inside Revit |
|---|---|---|
| Kelly-Windows-Data | `tests/Data.Tests.csproj` | – |
| Kelly-Windows | `tests/Logic.Tests.csproj` | – |
| Kelly-Domain | `tests/Domain.Tests.csproj` | – |
| Kelly-Revit-Logic | – (every Logic test runs inside Revit) | `test/Revit.Logic.RevitTests` |
| Kelly-Revit-UI | `test/Revit.UI.Tests` | `test/Revit.UI.RevitTests` |
| Kelly-Revit | – | `test/Tests.Revit` |

```bash
dotnet test Kelly-Revit-Logic-v5/test/Revit.Logic.RevitTests/Revit.Logic.RevitTests.csproj -c 2024 -p:SolutionName=Kelly.Revit.Logic -p:GeneratePackageOnBuild=false --filter "FullyQualifiedName~PurgeTests"
dotnet test Kelly-Revit-UI/test/Revit.UI.RevitTests/Revit.UI.RevitTests.csproj -c 2024 -p:GeneratePackageOnBuild=false
```

- The "without Revit" project (UI) cannot call the Revit API at run time (RevitAPI.dll is not copied); it covers pure logic, names and argument checks.
- The `*.RevitTests` projects use **ricaun.RevitTest.TestAdapter**: `dotnet test` starts the Revit version of the configuration, runs the tests on Revit's thread and closes Revit (`-p:RevitTestKeepOpen=true` keeps it open). A full Logic run takes about 30 minutes, so the Logic project sets `NUnit.Timeout` (assembly metadata, in minutes) to 45.
- The Markdown test log is written by a VSTest logger, `BuildConfigs/dotnet/TestLogger`, imported through `BuildConfigs/dotnet/.props/Test.Build.props`; under ricaun the tests can't log themselves. Logger errors go to `%LOCALAPPDATA%\Kelly Unit Test Logs\errors.txt`.
- Fixtures derive from `Abstractions/RevitApiTest` (injected `Application`/`UIApplication`; `OpenIsolatedCopy`, `OpenSharedCopy`, `CreateIsolatedProject`), `RevitFamilySampleTest` or `RevitModelSampleTest` (samples in `C:\Program Files\Autodesk\Revit <year>\Samples`; the model sample is Snowdon Towers HVAC).
- Code that prompts goes through `Kelly.Windows.Prompts.UserPrompt`, which throws when nothing is registered; tests register a recording `IUserPrompt`. `OperationService` logs to `C:\Projects\Revit\<document title>`; tests remove that folder with `Abstractions/ProjectFolders.Delete`.
- The Logic `Abstractions/RevitApiTest` handles Revit's failure messages for every transaction of a fixture (warnings deleted, errors resolved with their default resolution, all recorded in `RevitFailures`), so no failure dialog stops an unattended run. Move ducts or pipes only after disconnecting them: moving a joined one raises an error whose default resolution deletes it.
- **Kelly shared parameters and data without the data files:** Logic's `Abstractions/KellyDefinitions` registers a `DefinitionRegistry` resolver that answers every Kelly definition name with a stub (name, and a GUID derived from the name, stable across tests because the definition sets are cached for the Revit session). `Bind` creates those shared parameters in a test document with a data type each (TEXT, INTEGER, NUMBER, LENGTH, MASS, YESNO, MATERIAL), `Definition` makes a deprecated or category-bound stub, `UseDataFiles` registers a `DataFiles` list and `UseStore` a `DataStore` built from in-memory rows (`DataStoreRecords`). `Spools/SpoolTests` and `Updaters/ElementServiceTests` show the use. Needs the Kelly add-in disabled, which registers the real resolver.
- The Kelly element readers check a parameter's storage type, so bind each stub with the data type the add-in uses (for example JHK Total Weight as MASS).
- The Revit samples have no fabrication configuration, no Kelly families and no Kelly parameters; tests that need them (fabrication parts, Kelly supports, real project data) cannot run on the samples. A document opened by a test has no active view and no `UIDocument`, so availability classes, `CommandBase`, the `UIDocument` scope helpers and `TagDistributor` are not testable this way.

## Runtime architecture worth knowing

- `Kelly-Revit-v5/src/App.cs` `OnStartup` registers the process-wide seams the lower layers depend on before anything else runs: `UserPrompt.Register`, `DefinitionRegistry.Register` (shared parameter definitions, from the data files), `DataFiles.Register` and `DataFiles.RegisterStore` (Kelly.Domain: the lists and the `DataStore`), `AddInServices.Register`. It then loads the CSV data files through Kelly.Revit.Logic's `DataFileLoader` (a problem shows the "Kelly Tools For Revit Data Error" dialog and fails startup, as v4 does), starts every `IApplicationService` in `StartOrder` through `Kelly.Windows.Hosting.ServiceProvider.AddServices` (`DataFileService` 0, `AutoUpdaterService` 2, …, `EventService` 5) and fails startup if any does not start. Reload Data (Trade.All, Updater panel) reloads through the same loader.
- `EventService` subscribes the Revit application and user interface events. The document handlers live in Kelly-Revit (`src/EventHandlers`) and Kelly-Revit-Logic (`Documents/*EventHandler`); a handler left `null` makes Revit throw at subscription.
- Code that needs Kelly shared parameters or the data files (updaters, Kelly parameter helpers, the assigner combo boxes) works in a Kelly project with the add-in started, or in tests through `KellyDefinitions` (above); the Revit samples have none of these parameters.
- Ribbon modules are discovered by `RibbonService`; `test/Tests.Revit/AddIn/AddInContractTests` checks every module's commands, availability classes and push buttons (transaction attribute, constructors, icons embedded as `<ImageName>16.png`/`32.png`).
