# Context for the `dotnet-test-coverage-check` skill: Kelly Tools For Revit v5 under `C:\repo\jhkweb`

Read by the skill before step 1. Scripts, the checked-covered list and the issue rules for this project are in `.claude/skill-context/dotnet-test-coverage-check/`:

| File | Use |
|---|---|
| `coverage.sh`, `coverage.runsettings` | Section 2: the tests that run without Revit, with coverlet |
| `scan.sh` | Section 3: runs the generic `scan.cs` over the eight repositories, writes `gaps.csv` and the diff |
| `known-covered.txt` | Checked false positives: `Repo|Type|Member or *|reason (checked <date>)` |
| `linear-issues.md` | Section 5: rules the Linear subagent follows (teams, label "Test Coverage", title, estimate) |

`scan.sh` sets the contract-type options of `scan.cs` (`SCAN_CONTRACT_REPOSITORY`, `SCAN_CONTRACT_BASES`, `SCAN_CONTRACT_NAME_PATTERN`, `SCAN_CONTRACT_ENABLER_NAMES`).

## Scope and rules

- The shared rule is in `C:\repo\jhkweb\BuildConfigs\SHARED-AGENTS.md` (Tests): every type member has an NUnit test, `Author = "Verified By Human On:"`, a `Description`.
- Scope: Major Version 5 only (decided 2026-11-05): Kelly-Revit-v5 and every Kelly package below it; no v4 repositories, no format library v5 doesn't pin. Confirm it from each repository's `Directory.Packages.props` (`Kelly.`). When a repository appears or goes, update `PROJECTS` in `coverage.sh` (and its assembly in `coverage.runsettings`' `Include`) and `SPECS` in `scan.sh`, and commit that to the skills repository (`C:\Users\childebran\.claude`).
- Words: Major Version 5 or v5, never "Gen5" or "Generation"; "Senior Software Developer" where the user is named.
- Outputs: the report `C:\repo\jhkweb\Planning\Unit Test Coverage\Unit Test Implementation - Kelly Tools For Revit.md` (a "How to backfill a type" method, the 2026-11-02 baseline and per-repository backfill lists, one "Coverage re-examined (date)" section per review); the gap list `C:\repo\jhkweb\Planning\Unit Test Coverage\<yyyy-mm-dd> Coverage Gaps.csv`; the proposal `<yyyy-mm-dd> Linear Proposal.md` and `<yyyy-mm-dd> Linear Issues.csv` (`Team,Key,Repo,Type,Action,Estimate`) in the same folder.
- The headline measure is members named in a test (decided 2026-11-05).

## In-Revit suites (section 1 and 4)

`Kelly-Revit-Logic-v5/test/Revit.Logic.RevitTests` (about 30 minutes), `Kelly-Revit-UI/test/Revit.UI.RevitTests`, `Kelly-Revit-v5/test/Tests.Revit`; latest log `<repository>\test\TestLogs\*.md`. Follow the README "Running the tests" steps: check `tasklist` for that year's Revit and `ricaun`, rename the active `Kelly Tools For Revit <n>.addin` in `C:\ProgramData\Autodesk\Revit\Addins\2024` to `.addin.x` (it may be v4's), run in Revit 2024, rename it back afterwards, also when the run fails. A Revit of another year can stay open (`tasklist //v //fo list //fi "imagename eq Revit.exe"`). The build scripts are named in `.claude/skill-context/scripts/`.

## Section 2: what `coverage.sh` runs

Kelly-Windows-Data-v3, Kelly-Windows-v3, Kelly-Domain, Csv and Json (Net80), and Kelly-Revit-UI's `Revit.UI.Tests` (2025 measured; 2024 and 2025 run). Other configurations (Net481, Net100) only when a Net80 result looks wrong or the user asks.

## Section 3: false positives and contract types

- Covered without being named: records checked by reflection over every `IRecord` (`RecordTests`), enums checked by `EnumMembersTests`, an abstract base run through its subclasses (`NumberedDocumentCache`).
- Named without being tested: Kelly-Revit-v5's source-text rule tests (`SOURCE_RULE_TESTS` in `scan.sh`: `Commands/LowerLayerRulesTests.cs`, `Ribbon/RibbonMovesTests.cs`); the scan runs the add-in again without them ("by behaviour").
- Contract types: Kelly-Revit-v5's commands, push buttons, availability classes, panels and windows are checked by `AddInContractTests` for attributes, constructors and icons only; count them apart.
- Checked-covered lines go in `known-covered.txt`; commit it to the skills repository.

## Section 5: Linear

Issues per type, label "Test Coverage" (created as a workspace label the first time), teams from `.claude/skill-context/linear-teams.md` (KWD3, KW3, KD, KTRL5, KTRUI, KTR5, KWDC, KWDJ; Kelly-Revit-Logic is KTRL5). The rules are in `linear-issues.md` here. Estimate scale: exponential (checked 2026-11-05). About 526 types on the first run.

## Section 7: finish

Commit only this review's files to the jhkweb root repository (local, `main`, no remote): the report, `Coverage Gaps.csv`, `Linear Proposal.md` and `Linear Issues.csv` (those that exist), no `Co-Authored-By` line, never push.

## Traps met before

- `DebugType=None` in `Output.Build.props`: coverlet reports 0 of 0 lines without `-p:DebugType=portable`.
- Coverlet gives up when it can't instrument the locked `Kelly.Markdown.TestLogger.dll`: keep the runsettings' `Include` list.
- Under coverlet, Kelly-Domain's `LayeringTests.Domain_namespaces_are_not_named_after_Revit_layers` fails on coverlet's injected `Coverlet.Core.Instrumentation.Tracker.*` type; the rerun without coverage passes.
- Kelly-Revit-UI's line coverage (29.6% on 2026-11-05) counts only `Revit.UI.Tests`, which can't call the Revit API: the classes that need it show 0% there. Report the figure with that note.
- Kelly-Revit-Logic-v5 has no tests outside Revit, so it isn't in `coverage.sh`; the scan, the in-Revit question and Linear (KTRL5) cover it.
- Csv and Json had no `coverlet.collector` on 2026-11-05.
- 2026-11-05: three Csv tests and two Sqlite tests failed because an IDE member sort had reordered a test record (commit `2fae2fa`).
- No `claude`, `node` or `python` on this machine: the scripts are Bash and .NET 10 file-based C# apps (`dotnet run file.cs`). Use Bash and the file tools only.
- `wmic` is not available on this machine.
