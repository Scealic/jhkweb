# Linear Issue Splits, 2026-11-09

Scope: the four issues estimated at 16 points (the top of the Exponential scale) on 2026-11-09: KTR5-4758, KTR5-4751, KTRL5-89, KTRL5-52. `LINEAR.md` now says an issue at 16 points is split before work starts. Proposals by two read-only Sonnet subagents from the issues, their comments and the code on `develop`.

## Summary

| Team | Reviewed | Fine | Split | Unclear | New issues | Existing to link |
|---|---|---|---|---|---|---|
| KTR5 | 2 | 0 | 2 | 0 | 6 KTR5 + 4 KTRL5 | KTR5-4761, KTRUI-26, KTR5-4040 |
| KTRL5 | 2 | 1 | 1 | 0 | 7 KTRL5 | KTRL5-103, KTRL5-68, KD-6 |
| **Total** | **4** | **1** | **3** | **0** | **17** | **6** |

## [KTR5-4758](https://linear.app/jhkelly-ktr/issue/KTR5-4758) Category sets: replace the static sets with categories from the definition (16)

Signals: the work is in another layer (the static sets are in Kelly-Revit-Logic-v5; Kelly-Revit-v5 has none), several separate rules, top of the scale. Shape: sub-issues in KTRL5. The original keeps its goal as parent only, loses its estimate, and gets a note that the code lives in Logic. The method it asks for already exists: `InternalDefinitionExtensions.GetCategories` / `GetCategoryIds`.

| # | Team | Title | Est. | Relation | Goal |
|---|---|---|---|---|---|
| 1 | KTRL5 | Spool categories: take the spoolable set from the definition's binding | 4 | sub-issue; blocks 2, 3 | Replace the 54-entry `NumberableSpoolItemBuiltInCategorySet` (used by `SpoolItem.IsSpoolAble`) with the spool definition's bound categories |
| 2 | KTRL5 | Suspended support updater: categories from the definition, or keep the trigger filter | 2 | sub-issue | Decide whether `SupportCategories` (3) in `SuspendedSupportElementService` can follow the definition without waking the updater for the whole model; do it or document why not |
| 3 | KTRL5 | Category rules: keep, move or derive the other static sets | 2 | sub-issue | Review `InsulationCategories`, `ConnectorTools` (8), `CategoryExtensions` (4), `CoordinateExtensions.StructureCategories` (4), `RotateAxisTools`; derive or record in XML docs why they stay geometry rules |

Existing: KTR5-4040 (limit the categories Arrange Instance Align Move can move) is separate; relate it.

## [KTR5-4751](https://linear.app/jhkelly-ktr/issue/KTR5-4751) Prompts: 36 files show a TaskDialog directly, 3 a MessageBox (16)

Signals: a migration over many sites (today 25 files, about 55 sites, in 6 modules plus the host; the description's counts are stale: 2 `MessageBox` left), top of the scale. Shape: sub-issues per module. The original keeps its goal as parent only and loses its estimate; its two side notes (`Command.UiDocument` 49 uses, 9 `AutoUpdaterService` lookups) are not prompts (see Questions).

| # | Team | Title | Est. | Relation | Goal |
|---|---|---|---|---|---|
| 1 | KTR5 | Trade.All spool commands: TaskDialogs to UserPrompt | 4 | sub-issue | 14 sites in `SpoolManagerViewModel`, `SpoolCleanCommon`, `SpoolCreateViewModel`, `SpoolSheetOpenCommand`, `ModuleCreatorViewModel` |
| 2 | KTR5 | Trade.All other commands: TaskDialogs and MessageBox to UserPrompt | 2 | sub-issue | Assigner value commands, `FamilySharedParameterReportCommand`, Layout Point export, `ManyConnectCommand`, `SuspendedSupportManagerViewModel` `MessageBox` |
| 3 | KTR5 | Contenter commands: TaskDialogs to UserPrompt | 2 | sub-issue | `FabricationCustomDataUpdaterCommandV2` (6), Product Code Check report (2), Custom Data report (1); V1 after KTR5-4776 |
| 4 | KTR5 | Pipe and Duct commands: TaskDialogs to UserPrompt | 2 | sub-issue | Valve Clearance Spheres (3), Olet Check, Connect Olets, Duct Run Item Number Set (2), Duct Item Number Set (after KTR5-4767) |
| 5 | KTR5 | Developer and Manager commands: TaskDialogs and MessageBox to UserPrompt | 1 | sub-issue | 4 TaskDialog sites and the `UserReportCommand` `MessageBox` |
| 6 | KTR5 | Host: startup and Missing Shared Parameters dialogs to UserPrompt | 2 | sub-issue | `App.cs` startup errors (3, after `UserPrompt.Register`), `MissingSharedParametersDialog` (touches KTR5-4769) |
| 7 | KTRL5 | Layout point tools: TaskDialog to UserPrompt | 1 | sub-issue | The one direct dialog in `LayoutPoints/LayoutPointTools.cs` |

Existing: KTRUI-26 (RibbonExtensions TaskDialogs) becomes a sub-issue too. KTR5-4761 (In Progress) moves hand-built TaskDialogs from the KW3-25 plan but names no files: its sites are taken out of pieces 1 to 5 before they are created.

## [KTRL5-89](https://linear.app/jhkelly-ktr/issue/KTRL5-89) Split DocumentExtensions and Spool (16)

Signals: two large files with unrelated responsibilities (`DocumentExtensions.cs` 1,940 lines, `Spool.cs` 1,059), top of the scale. Shape: sub-issues. The new extension classes stay in `Kelly.Revit.Logic.Documents` (`src/Documents`), so callers need no change and no upper-layer piece is needed. Pieces total 22 points.

| # | Team | Title | Est. | Relation | Goal |
|---|---|---|---|---|---|
| 1 | KTRL5 | Documents: move element and collector queries to DocumentQueryExtensions | 4 | sub-issue; related KTRL5-103, KTRL5-68 | About 17 query methods (`GetElementsByType` used in 32 files); do with or after KTRL5-103 |
| 2 | KTRL5 | Documents: move delete and purge operations to DocumentPurgeExtensions | 2 | sub-issue; related KTRL5-68 | Delete/purge transactions and their prompt, unchanged |
| 3 | KTRL5 | Documents: move view, filter and template lookups to DocumentViewExtensions | 2 | sub-issue | `GetView`, `GetViewTemplate`, `Create3DViewTransaction`, filter lookups, unchanged |
| 4 | KTRL5 | Documents: move shared-parameter code to DocumentParameterExtensions | 4 | sub-issue; related KD-6 | `GetDefinition` (11 files), shared-parameter elements and binding code, unchanged |
| 5 | KTRL5 | Documents: move info, path, workset and location helpers to DocumentInfoExtensions | 2 | sub-issue | The rest of the class (document info, paths, worksets, locations, levels) |
| 6 | KTRL5 | Spool: move sheet, view and schedule creation to SpoolSheetBuilder | 4 | sub-issue; blocks 7 | `CreateSpoolSheetAndViews` and its private helpers (about 230 lines), prompts kept; check `LowerLayerRulesTests` |
| 7 | KTRL5 | Spool: replace the model's UserPrompt calls with results | 4 | sub-issue | Spool returns results and the caller shows the same text (see Questions) |

## [KTRL5-52](https://linear.app/jhkelly-ktr/issue/KTRL5-52) Move 22 members into Logic: Fine, mostly done

Its only sub-issue (KTR5-4738) is Done, the moved members exist in Logic (Component and Product updaters were deleted under KTRL5-8), and the comments record the 2026-11-05 Revit 2024 run. What's left is the full in-Revit Logic run that hangs, already covered by KTRL5-70 and KTRL5-76. Proposal: no split; re-estimate 16 → 2, status unchanged (Testing). Not checked: whether `CommonAutoAssignerTools.ResetUpdater` in Kelly-Revit-v5 delegates to Logic's `AutoUpdaterService.ResetUpdater`.

## Decisions (maintainer, 2026-11-09)

1. KTR5-4758: the spool and support sets come from the open document's binding (`InternalDefinitionExtensions.GetCategories`), not from Domain's records.
2. KTR5-4751: the two side notes become their own KTR5 issues, related to KTR5-4751: "Commands: reduce the 49 `Command.UiDocument` uses" and "Services: replace the 9 `AddInServices.GetService<AutoUpdaterService>()` lookups by concrete class" (estimates to be set when filed); the notes leave its description.
3. KTRL5-89: piece 7 stays (Spool without `UserPrompt`, test-first).

KTRL5-52: no split; its estimate goes from 16 to 2.
