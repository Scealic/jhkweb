# Package chain: jhkweb values

The project values for `~/.claude/skills/_shared/package-chain.md`, the one pack-and-repin procedure the skills follow. The rules themselves are in `BuildConfigs/SHARED-AGENTS.md` and the jhkweb `CLAUDE.md`.

## Layers and configurations

- Order, lowest first: Kelly-Windows-Data-v3 → Kelly-Windows-v3 → Kelly-Domain → Kelly-Revit-Logic-v5 → Kelly-Revit-UI → Kelly-Revit-v5 (the application; no package).
- Configurations: `-c Net481|Net80|Net100` for Kelly-Windows-Data, Kelly-Windows, Kelly-Domain and the format libraries; `-c 2024|2025|2026` for the Revit layers. Always pass `-p:GeneratePackageOnBuild=false` except when packing.
- Tests before a pack: the three lower layers and the format libraries run their tests in all three configurations (`dotnet test <tests csproj> -c <configuration> -p:GeneratePackageOnBuild=false`). Revit layers: build the in-Revit tests only (the lead runs them); Kelly-Revit-UI also runs `test/Revit.UI.Tests` for 2024.
- Packages outside the chain that are repinned and packed in the same pass: the format libraries (Kelly-Windows-Data-Csv, -Json, -Sqlite, -SqlServer) and Kelly-Revit-Data-Exporter.

## Scripts

`P=C:/repo/jhkweb/.claude/skill-context/scripts` (Git Bash):

| Script | Use |
|---|---|
| `bash $P/kbuild.sh <layer> verify\|test\|revittests\|pack [configurations]` | Build without a package, run the non-Revit tests, compile the in-Revit test project, or pack every configuration with one version. Layers: data, windows, domain, logic, ui, revit, alltrade, pipetrade, ducttrade, contenter, manager, developer. Kelly-Revit builds never install (`NoInstall.targets`). Prints `errors=N` per configuration and `PACKED <layer> <version>`. |
| `bash $P/pins.sh show [repository...]`, `pins.sh set <repository> <version>` | Print every repository's `Kelly*Version` pin (default: the six v5 repositories), or set one (`pins.sh set Kelly-Revit-UI 5.26.1104.930`). |
| `bash $P/revit-test.sh <test csproj> <filter\|-> <log> [msbuild arguments]` | Run an in-Revit test project in Revit 2024 against this source. It renames the active `Kelly Tools For Revit*.addin` manifests to `.addin.x` for the run and restores them, even when the run fails. Never rename the manifests by hand. |

## Pins

Each repo pins only the layer directly below it, with one property in its `Directory.Packages.props`. Its project files name the packages without a version. `pins.sh show` prints every repo's pin, and `pins.sh set <repo> <version>` changes it.

| Repo | Pin property (`Directory.Packages.props`) | README pin statement |
|---|---|---|
| Kelly-Windows-Data-v3 | none | none |
| Kelly-Windows-v3 | `KellyWindowsDataVersion` | Dependencies: "`Kelly.Windows.Data` NuGet package … versioned once in `Directory.Packages.props` … at `<v>`" |
| Kelly-Domain | `KellyWindowsVersion` | Dependencies: "`Kelly.Windows` NuGet package … at `<v>`" |
| Kelly-Revit-Logic-v5 | `KellyDomainVersion` | Dependencies: "`Kelly.Domain` (suffix …), versioned once in `Directory.Packages.props` … at `<v>`" |
| Kelly-Revit-UI | `KellyRevitLogicVersion` | dependency table row `` \| `Kelly.Revit.Logic` (`.2024`, `.2025`, `.2026`) \| `<v>` \| `` and the test-results table |
| Kelly-Revit-v5 | `KellyRevitUIVersion` (the host and all six modules share it) | the "Status" line ("They are on Kelly.Revit.UI `<v>`") and "Kelly layer package" under Dependencies, which also lists the versions underneath |

Kelly-Revit-v5 also pins `Kelly.Windows.Data.Csv` (the CSV reader) by a literal version, outside the chain.

Grep each README for the old version string before you change it. The wording drifts, but the version number is always there.

## Versions and Changelog headings

- `BuildConfigs/dotnet/.props/Version.Build.props` sets `<MajorVersion>.yy.MMdd.HHmm`, each number without leading zeros. MajorVersion: Kelly-Windows-Data-v3 and Kelly-Windows-v3 3; Kelly-Domain and Kelly-Revit-UI 1; Kelly-Revit-Logic-v5 and Kelly-Revit-v5 5. Kelly-Domain built on 2026-11-03 at 17:17 is `1.26.1103.1717`.
- Packing by hand: one version for all configurations, `-p:VersionCalculated=<v> -p:FileVersionCalculated=<v>`. Packages go to `C:\Repo\NugetPackages`.
- Headings: package repositories `## 2026-11-03 (not yet in a package): <summary>`, then `(package 1.26.1103.1717)`; Kelly-Revit `(not yet in a build)`, or `(version 5.26.1103.1035)` for an installed build.

## The application: Kelly-Revit-v5

- Repin with `pins.sh set Kelly-Revit-v5 <ui version>`; the host and all six modules share that one property. The host also pins the CSV reader, `Kelly.Windows.Data.Csv`, by a literal version outside the chain: if Kelly-Windows-Data was repacked, check restore shows no `NU1605`/`NU1608` warning for it.
- Build all 21 configurations: `for l in revit alltrade pipetrade ducttrade contenter manager developer; do bash $P/kbuild.sh $l verify; done`, then `kbuild.sh revit revittests 2024`, which checks every module's commands, availability classes and push buttons.
- Confirm restore used the new versions: `find src/obj modules/*/obj -maxdepth 2 -name project.assets.json | xargs grep -ohE '"Kelly\.[A-Za-z.]+\.(Net481|2024)/[0-9.]+"' | sort | uniq -c`.
- Builds must not install the add-in: build through `kbuild.sh`, and install only when the user asks.

## Push

Merge order: Data, Windows, Domain, Logic, UI, Kelly-Revit. Branch `develop`. Push only when the user asks (`git-push-developbranch`).

## Traps

- `kbuild.sh pack` refuses a version it already used for that layer this minute (exit code 3), and a same-minute build fails with `KTR0003`: wait for the minute (memory `jhkweb-stale-package-pins.md`).
- Kelly-Revit-Logic-v5, Kelly-Revit-v5 and Kelly-Windows-Data name their assembly `$(SolutionName)`: built alone without `-p:SolutionName=<solution name>` the assembly is `Revit.dll`. The scripts pass it; building the `.slnx` is simplest.
- Mass `CS0234` = a pin names a version not in `C:\Repo\NugetPackages`. "doesn't support net8.0"/`NU1202` = a stale `obj/project.assets.json`: delete that `obj` folder and restore again.
- If restore returns 401 from the Telerik feed, pass `"-p:RestoreSources=https://api.nuget.org/v3/index.json;C:\repo\NugetPackages;<local Telerik folder>"`.
- In a run with the add-in disabled, tests that need it started (for example `EventServiceTests` and `ApplicationLoggerTests`) fail by design: name them in the report rather than fixing them.
- A Revit cleanup can shorten `catch (Autodesk.Revit.Exceptions.OperationCanceledException)` to `catch (OperationCanceledException)`: keep the full name in files you move.
- Issues closed by a pack: move each round's In Review issues to Done with a comment naming the package, after checking they are in the team's current cycle (`LINEAR.md`, Cycles).
