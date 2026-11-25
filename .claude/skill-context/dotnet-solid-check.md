# Context for the `dotnet-solid-check` skill: Kelly Tools For Revit repositories under `C:\repo\jhkweb`

Read by the skill before step 1.

## Document and scope

- The document is `C:\repo\jhkweb\Planning\SOLID Check\SOLID Check.md`. It rates six repositories (Kelly-Windows-Data, Kelly-Windows, Kelly-Domain, Kelly-Revit-Logic, Kelly-Revit-UI, Kelly-Revit; the v5 repositories `Kelly-Windows-Data-v3`, `Kelly-Windows-v3`, `Kelly-Domain`, `Kelly-Revit-Logic-v5`, `Kelly-Revit-UI`, `Kelly-Revit-v5`) on SRP, OCP, LSP, ISP and DIP, with a checklist of findings per repository, cross-repository patterns and "fixes with the best return".
- Each repository's README "SOLID principles" section (table Principle | Rating | Notes, dated by the review) is required by `BuildConfigs/SHARED-AGENTS.md`.
- Header line of the document holds the date of the last re-check.

## Measuring (step 2)

```bash
bash /c/repo/jhkweb/.claude/skill-context/dotnet-solid-check/measure.sh "2026-10-20 10:00"
```

`measure.sh` (in `.claude/skill-context/dotnet-solid-check/`) prints, read-only: each repository's commits and changed `src`/`modules` files since that time, uncommitted changes, the five largest source files per repository, per-repository counts (files with a static class, interfaces, files using `MessageBox`, `TaskDialog`, `UserPrompt`, `new SqlServerService`, `NotImplementedException` call sites), and the specific numbers the document cites (DocumentExtensions lines, `is Fabrication` checks, `Command.UiDocument` uses, and so on). Change the numbers it measures together with the document.

## Examples for step 3

- `TaskDialogSimple` and `HandleIt` look like direct dialogs but wrap `UserPrompt`, and `RevitUserPrompt` is the seam's own implementation, so none of them bypasses the prompt seam. A bypass is a direct `TaskDialog.Show`, `new TaskDialog(` or WPF `MessageBox.Show` (the script's `TaskDlg` and `MsgBox` columns count exactly those, code lines only).
- Earlier checks got counts wrong (22 vs 18 members, 11 vs 10 properties).
- Fixed items cite commit and package, for example "fixed 2026-10-20 (`d34921f`, package 26.10.20.941)", or "not yet pinned by Kelly-Revit-Logic and above".
- Counts that need new hits checked: `MessageBox` or `TaskDialog` in a layer that had none.

## Ratings (step 4)

One injected class does not lift a layer's DIP while its static registries and service locators remain.

## READMEs (step 6)

The tables follow `SOLID Check.md`; commit nothing, and tell the user which READMEs changed.
