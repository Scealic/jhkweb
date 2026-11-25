# Layers: paths, tests, pins and docs

Last checked against the repos: 2026-11-04.

This file is for running the chain. Scripts: see `../dotnet-architecture-analysis.md`. What belongs in each layer, and what each may reference, are in `placement-rules.md` ("The layers"). All repos are under `C:\repo\jhkweb`, each its own git repo on `develop` (remote `origin`, default branch `main`). The folder names carry each repo's own major version. The layer names used everywhere else (Kelly-Windows-Data, Kelly-Revit, …) mean the layer.

The first column gives the `kbuild.sh` layer keys. The module keys keep the old tab names (`alltrade`, …), but the folders, projects and namespaces are `Trade.<X>` (`Kelly.Revit.Trade.All.*`).

| kbuild layer | Repo folder | Project | Configurations | Package IDs | MajorVersion |
|---|---|---|---|---|---|
| `data` | Kelly-Windows-Data-v3 | `src/Data.csproj` | Net481, Net80, Net100 | `Kelly.Windows.Data.<config>` | 3 |
| `windows` | Kelly-Windows-v3 | `src/Logic.csproj` | Net481, Net80, Net100 | `Kelly.Windows.<config>` | 3 |
| `domain` | Kelly-Domain | `src/Domain.csproj` | Net481, Net80, Net100 | `Kelly.Domain.<config>` | 1 |
| `logic` | Kelly-Revit-Logic-v5 | `src/Revit.csproj` (AssemblyName `$(SolutionName)` = Kelly.Revit.Logic) | 2024, 2025, 2026 | `Kelly.Revit.Logic.<year>` | 5 |
| `ui` | Kelly-Revit-UI | `src/Revit.UI.csproj` | 2024, 2025, 2026 | `Kelly.Revit.UI.<year>` | 1 |
| `revit` | Kelly-Revit-v5 | `src/Core.csproj` (the host; AssemblyName `$(SolutionName)` = Kelly.Revit; namespaces `Kelly.Revit.Core.*`) | 2024, 2025, 2026 (+ `…Debug`) | not a package | 5 |
| `alltrade`, `pipetrade`, `ducttrade`, `contenter`, `manager`, `developer` | Kelly-Revit-v5 | `modules/Trade.All/Trade.All.csproj`, `Trade.Pipe`, `Trade.Duct`, `Trade.Contenter`, `Trade.Manager`, `Trade.Developer` | 2024, 2025, 2026 | not packages | 5 |

Revit 2024 uses the Net481 lower packages; 2025 and 2026 use Net80. A package version is `<MajorVersion>.yy.MMdd.HHmm` (`../dotnet-architecture-analysis.md`, "Chain release specifics").

## Tests

| Repo | Without Revit (`kbuild.sh <layer> test`) | In Revit (compile: `kbuild.sh <layer> revittests 2024`; run: `revit-test.sh`) |
|---|---|---|
| Kelly-Windows-Data-v3 | `tests/Data.Tests.csproj` | – |
| Kelly-Windows-v3 | `tests/Logic.Tests.csproj` | – |
| Kelly-Domain | `tests/Domain.Tests.csproj` | – |
| Kelly-Revit-Logic-v5 | – | `test/Revit.Logic.RevitTests/Revit.Logic.RevitTests.csproj` (pass `-p:SolutionName=Kelly.Revit.Logic`; a full run takes about 30 minutes) |
| Kelly-Revit-UI | `test/Revit.UI.Tests` | `test/Revit.UI.RevitTests/Revit.UI.RevitTests.csproj` |
| Kelly-Revit-v5 | – | `test/Tests.Revit/Core.Tests.csproj` (ProjectReferences to the host and modules; pass `-p:SolutionName=Kelly.Revit`) |

Each run writes `<repo>\<test or tests>\TestLogs\<test assembly> - <framework>.md`, one row per test. In a run with the add-in disabled, the tests that need the add-in started (for example `EventServiceTests` and `ApplicationLoggerTests` in Kelly-Revit) fail by design. Name them in the report rather than fixing them.

## Pins

Where each repository keeps its pin and states it in its README: `../package-chain.md`, "Pins".

## Changelog heading forms in use

- Package repos: `## 2026-11-03 (package 1.26.1103.1717): <summary>`, or `(not yet in a package)` before packing. Kelly-Revit-UI and Kelly-Windows sometimes add what the package was built on: `(package 1.26.1103.1851, on Kelly.Revit.Logic 5.26.1103.1841)`. Older entries use `## 26.10.13 (package …)` or versions without the major version; leave them.
- Kelly-Revit: `## 2026-11-03 (not yet in a build): <summary>` after verify-only builds, or `(version 5.26.1103.1035)` for an installed build.

Look at the newest entry of each Changelog before writing, and match its sections (`### Breaking`, `### Added`, `### Changed`, `### Tests`, or a dependency table).

## Root working documents (not in any repo)

`C:\repo\jhkweb\Planning\SOLID Check\SOLID Check.md`, `UBIQUITOUS-LANGUAGE.md` (the glossary: rename the term and note the old name with its date) and `.claude/CLAUDE.md`. Update the names there after the chain, and commit them to the local root repo (never pushed). Leave `Planning\Layer Moves\ARCHITECTURAL-ANALYSIS-moves.csv` and `Kelly-Revit-v5/doc/Design/*.csv` alone: they record past states.
