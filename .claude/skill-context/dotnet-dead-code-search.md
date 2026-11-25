# Context for the `dotnet-dead-code-search` skill: Kelly repositories under `C:\repo\jhkweb`

Read by the skill before step 1. Learned over four rounds from 2026-11-20 to 2026-11-25; the report is `C:\repo\jhkweb\Planning\YAGNI\YAGNI 2026-11-20 jhkweb.md`. The Linear teams are in `.claude/skill-context/linear-teams.md`.

## Scan (step 1)

```bash
bash ~/.claude/skills/yagni/scripts/yagni.sh /c/repo/jhkweb "<scratchpad>/yagni"
```

Entry points are in `C:\repo\jhkweb\.yagni` (Revit interfaces, `IRecord` properties, CommunityToolkit `[RelayCommand]`/`[ObservableProperty]`/`On*Changed`, `used:` rules). Commit `.yagni` to the root repository.

## Name check (step 2)

```bash
CHECK_NAMES_ROOT=/c/repo/jhkweb \
CHECK_NAMES_EXCLUDE_DIRS="Planning RevitTestModels" \
CHECK_NAMES_RULES_REGEX='/Architecture/|RulesTests\.cs|MovesTests\.cs' \
bash ~/.claude/skills/dotnet-dead-code-search/check-names.sh <name>...
```

The source-text tests (RULES) are `Architecture/*MovesTests` and `LowerLayerRulesTests`.

## Compiled references (step 2)

Run `yagni/scripts/refs.cs` over the installed add-in (`C:\Program Files\JH Kelly\Kelly Tools For Revit\V5\<year>`), fresh builds of Fabrication-Tools and the exporter (Kelly-Revit-Data-Exporter), and the newest Kelly packages in `C:\Repo\NugetPackages`.

## Keep (step 2)

Test seams by design (`ProgressReporter.UseFactory`, `ProgressWindowReporter.Displayed`); public members of packages the Major Version 4 code may use (its source isn't on this machine: check `ls` first); members an open Linear issue still names; sandbox helpers.

## File, then delete (step 3)

- Issue per repository, in that repository's team (`.claude/skill-context/linear-teams.md`): title `Delete <members>`; estimate 1 or 2; priority Low; labels "Delete" and "Code quality and cleanup"; assignee "me"; state In Progress; Related to the issue whose deletion made it dead.
- Delete bottom-up: Kelly-Windows-Data-v3, Kelly-Windows-v3, Kelly-Domain, Kelly-Revit-Logic-v5, Kelly-Revit-UI, Kelly-Revit-v5, then Fabrication-Tools and the exporter.
- In-Revit tests (main session only): SHARED-AGENTS "in-Revit tests", Revit 2024, `--filter` of about 30 tests, rename the active `.addin` to `.addin.x` with a trap that restores it, and include every source-text fixture (`Architecture/*MovesTests`, `LowerLayerRulesTests`) that names a deleted member. A run that selects hundreds of tests times out without running any. The build scripts are named in `.claude/skill-context/scripts/`.
- Issue comment: commit, configurations built, test totals; In Review ("not yet in a package"), or Done for Fabrication-Tools (no package; push its `develop`). When marked Done, check the issue is in its team's current cycle and add it if not (`LINEAR.md`, Cycles).
- Packing and repinning, when asked: Packing, repinning, versions, Changelog headings, the application last, push order and traps: `package-chain.md` beside this file (procedure: `~/.claude/skills/_shared/package-chain.md`). Install only when asked.

## Record (step 4)

Add a "<n> round (<date>)" section to the report above, then commit just that file to the root repository.

## Deletion subagent rules (from `delete-brief.md`)

- Never use the Windows shell other than Git Bash. Branch `develop` only; no `Co-Authored-By` or other trailer.
- Test stamp: `Author` goes back to exactly `"Verified By Human On:"` for a test that changes.
- `Changelog.md`: a new entry at the top, `## <today> (not yet in a package): ...` (Kelly-Revit-v5: `(not yet in a build)`; Fabrication-Tools: its own style), with Removed and Tests sections. Never "Unreleased".
- Build every configuration with `-p:GeneratePackageOnBuild=false`:
  - Kelly-Windows-Data-*, Kelly-Windows-v3, Kelly-Domain: `-c Net481`, `-c Net80`, `-c Net100`; run their tests in all three.
  - Kelly-Revit-Logic-v5: `-c 2024/2025/2026` with `-p:SolutionName=Kelly.Revit.Logic`; build the solution so the in-Revit tests compile, but do NOT run them.
  - Kelly-Revit-UI: `-c 2024/2025/2026`; run `test/Revit.UI.Tests`; build but don't run `test/Revit.UI.RevitTests`.
  - Kelly-Revit-v5: `-c 2024/2025/2026` with `-p:SolutionName=Kelly.Revit` and `"-p:CustomAfterMicrosoftCommonTargets=C:\repo\jhkweb\Kelly-Revit-v5\test\Tests.Revit\NoInstall.targets"`; never install; build `test/Tests.Revit` but don't run it.
  - Fabrication-Tools: build and test with a scratch `--artifacts-path` if the running app locks its output.
- Source-text tests to search: `Architecture/*MovesTests`, `LowerLayerRulesTests`.
- Mass CS0234 errors mean a pin points to a version missing from `C:\Repo\NugetPackages`.
