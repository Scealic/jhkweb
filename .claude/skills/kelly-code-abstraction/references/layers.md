# Layers: paths, tests, pins and docs

All repos are under `C:\repo\jhkweb`, each its own git repo on `develop` (remote `origin`, default branch `main`). `kbuild.sh` layer names are in the first column.

| kbuild layer | Repo | Project | Configurations | Package IDs |
|---|---|---|---|---|
| `data` | Kelly-Windows-Data-v3 | `src/Data.csproj` | Net481, Net80, Net100 | `Kelly.Windows.Data.<config>` |
| `windows` | Kelly-Windows-v3 | `src/Logic.csproj` | Net481, Net80, Net100 | `Kelly.Windows.<config>` |
| `domain` | Kelly-Domain | `src/Domain.csproj` | Net481, Net80, Net100 | `Kelly.Domain.<config>` |
| `logic` | Kelly-Revit-Logic-v5 | `src/Revit.csproj` (AssemblyName `$(SolutionName)` = Kelly.Revit.Logic) | 2024, 2025, 2026 | `Kelly.Revit.Logic.<year>` |
| `ui` | Kelly-Revit-UI | `src/Revit.UI.csproj` | 2024, 2025, 2026 | `Kelly.Revit.UI.<year>` |
| `revit` | Kelly-Revit-v5 | `src/Revit.csproj` (the host; AssemblyName `$(SolutionName)` = Kelly.Revit) | 2024, 2025, 2026 (+ `…Debug`) | not a package |
| `alltrade`, `pipetrade`, `ducttrade`, `contenter`, `manager`, `developer` | Kelly-Revit-v5 | `modules/<Module>/<Module>.csproj` | 2024, 2025, 2026 | not packages |

Revit 2024 uses the Net481 lower packages; 2025 and 2026 use Net80.

## Tests

| Repo | Without Revit (`kbuild.sh <layer> test`) | In Revit (`kbuild.sh <layer> revittests 2024`, compile only) |
|---|---|---|
| Kelly-Windows-Data-v3 | `tests/Data.Tests.csproj` | – |
| Kelly-Windows-v3 | `tests/Logic.Tests.csproj` | – |
| Kelly-Domain | `tests/Domain.Tests.csproj` | – |
| Kelly-Revit-Logic-v5 | – | `test/Revit.Logic.RevitTests` |
| Kelly-Revit-UI | `test/Revit.UI.Tests` | `test/Revit.UI.RevitTests` |
| Kelly-Revit-v5 | – | `test/Tests.Revit` (ProjectReferences to the host and modules) |

Each run writes `<repo>\<test or tests>\TestLogs\<test assembly> - <framework>.md`, one row per test.

## Pins: where each repo keeps them

| Repo | Project files with Kelly pins | README pin statement |
|---|---|---|
| Kelly-Windows-Data-v3 | none | none |
| Kelly-Windows-v3 | `src/Logic.csproj` (Data) | dependency table rows `\| Net481 \| Kelly.Windows.Data.Net481 \| <v> \|` (and Net80, Net100) |
| Kelly-Domain | `src/Domain.csproj` (Data, Windows) | "pinned in `src/Domain.csproj` (currently `Kelly.Windows` `<v>` and `Kelly.Windows.Data` `<v>`)" |
| Kelly-Revit-Logic-v5 | `src/Revit.csproj` (Data, Windows, Domain) | "Package `<own v>` pins `Kelly.Windows.Data` `<v>`, `Kelly.Windows` `<v>` and `Kelly.Domain` `<v>`" |
| Kelly-Revit-UI | `src/Revit.UI.csproj` (Data, Windows, Domain, Logic) | dependency table rows `\| `Kelly.Domain` \| `<v>` \|` … `\| `Kelly.Revit.Logic` (`.2024`, `.2025`, `.2026`) \| `<v>` \|` |
| Kelly-Revit-v5 | `src/Revit.csproj` and all six `modules/*/*.csproj` (all five) | "They are currently pinned at `<data>`, `<windows>`,`\n` `<domain>`, `<logic>` and `<ui>`." |

`git ls-files '*.csproj'` lists a repo's project files; repin every one that has Kelly pins, including test projects (Kelly-Domain's `tests/Domain.Tests.csproj` has them). After repinning, `pins.sh show <csproj...>` should print one identical set per project.

## Changelog heading forms in use

- Kelly-Windows-Data, Kelly-Windows, Kelly-Revit-Logic: `## 2026-10-20 (package 26.10.20.832): <summary>`
- Kelly-Domain, Kelly-Revit-UI: the same form (older entries use `## 26.10.13 (package …)`; write new ones with the full date).
- Kelly-Revit: `## 2026-10-20 (not yet built): <summary>` after verify-only builds; `(version 26.10.15.1428)` for an installed build.

Look at the newest entry of each Changelog before writing, and match its sections (`### Breaking`, `### Added`, `### Changed`, `### Tests`, or a dependency table).

## Root working documents (not in any repo)

`C:\repo\jhkweb\SOLID Check.md`, `UBIQUITOUS-LANGUAGE.md` (the glossary: rename the term and note the old name with its date), `CLAUDE.md`. Update names there after the chain; leave `ARCHITECTURAL-ANALYSIS-moves.csv` and `Kelly-Revit-v5/doc/Design/*.csv`, which record past states.
