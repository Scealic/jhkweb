# Layer moves - 2026-11-04 (round 2a)

Round 2a of [LAYER-MOVES-PLAN-2026-11-04.md](LAYER-MOVES-PLAN-2026-11-04.md). It was planned as moves #1 to #90 (without #34, deferred) plus the rule-1 fixes #94, #95, #96 and #156: 93 moves. It ran bottom-up, test-first, one commit per work package. Each layer went through an adversarial review and fixes, was built in every configuration, packed, and repinned in the layer above. The first run stopped when the session ended, partway through Logic. A second run finished Logic, Kelly-Revit-UI and Kelly-Revit. Nothing was pushed, and the add-in was not installed.

**Main finding: the source side of 82 moves was missed at first, and has since been done.** A follow-up pass the same day (see "Source-side pass") moved 80 of the 82 callers to the lower copies and deleted the originals. It skipped #4 and #57 on purpose, because their originals behave differently from the lower copies. Both wait for the user's decision.

## Result

| Repo | Run commits | Package | Tests |
|---|---|---|---|
| Kelly-Windows-Data-v3 | 6c663cc, 677c353, 01b4e10 | 3.26.1104.824 | 166 of 166 in Net481, Net80 and Net100 |
| Kelly-Windows-v3 | fa8f8f4, baa9e73, fd7000a, fad51f9 | 3.26.1104.851 | 735 of 735 in each configuration |
| Kelly-Domain | 9fd96ca, c070084, 80d19c3, 2a23679, fced06c | 1.26.1104.956 | 1529 of 1529 in each configuration (was 1559: the 36 rows of the types moved to Windows went, 6 guard tests came) |
| Kelly-Revit-Logic-v5 | 29db3a4, 3ad2972, d7aa571, bc6ccc5 | 5.26.1104.1040 | In Revit 2024: 961 of 962. `LogDimensionValues_WritesTheDimensionsToALog` needs the add-in started. |
| Kelly-Revit-UI | dec689b, 033177e | 1.26.1104.1046 | 164 of 164 without Revit; 44 of 44 in Revit 2024 |
| Kelly-Revit-v5 | 0fcd56e8 | not a package. All 21 configurations built with 0 errors; none installed. | In Revit 2024: 128 of 132. The 4 failures need the add-in started: three `EventServiceTests` and `ApplicationLoggerTests.LogWarning_WithTheAddInStarted…`. |

Every in-Revit run went through `revit-test.sh`, with the add-in disabled. The manifests are as they were at the start: `Kelly Tools For Revit 5.addin` is active and `Kelly Tools For Revit.addin.x` is disabled. Each test log has one row per test that discovery found.

Moves:

| Status | Count | Moves |
|---|---|---|
| Done | 91 | all but #4 and #57 (11 in round 2a, 80 in the source-side pass) |
| Partial | 2 | #4 and #57: the lower copy exists, but the original stays because its behaviour differs |
| Skipped | 0 | |
| Deferred by the user | 1 | #34 |

Rules (`check-rules.pl`, before and after): rules 1 to 4 are unchanged.
- 0 Revit API in the Revit-free layers.
- 0 lower layers naming a higher one in code.
- 0 protected files outside Kelly-Revit (the same 7 approved exceptions).
- 0 namespace/folder mismatches.
- Kelly-Revit still has 133 IExternalCommand classes and 42 view and view-model files.

The word "Revit" in the Revit-free layers went from 31 to 65. All 34 new hits are XML doc remarks in Kelly-Domain such as "Moved on 2026-11-04 from `X` in Kelly-Revit-Logic-v5, which keeps …". They are not Revit API. But they name the higher layers. Worse, they say the Logic copy keeps only the element reads, which is not yet true.

## What moved, by layer

### Into Kelly-Windows-Data
- #1 `DataDirectory.ReadAllVerified<T>(manifest)`: the verified read (manifest entry, SHA-256, row count, the three messages word for word). **Partial**: Kelly-Domain's `DataStore` still calls its own private `ReadChecked`.

### Into Kelly-Windows
- #19 to #31 `FrameworkElementExtensions.ThrowIfNotReady`, the `ValidateRequirements` check copied into 13 views. **Partial**: the views were not repointed.
- #2 to #18 the helpers: chop, explorer launch, geometry, radians, the column letter, fraction and stake-out text, the colour name, Telerik assembly loading, the add-in assembly, pounds, the unique view name.
  - #8 `ObjectReference`, #12 `FractionalLength` and #13 `DimensionType` came down from Kelly-Domain and are deleted there. **Done.**
  - #14 `VicMaterial.GetColorName` came down from Kelly-Domain. **Done.**
  - #9 `AddInServices` is in `Kelly.Windows.Hosting`, and the host and Trade.All alias it there. **Partial**: Kelly-Revit-Logic still has its own `Kelly.Revit.Logic.Common.AddInServices`.
  - The other Logic- and Revit-sourced helpers: **partial.**
- #94, #95 and #96 `WriteToLog` and both `ToLogDevelopment` overloads are deleted from Kelly-Windows (### Breaking). **Done.**

### Into Kelly-Domain
- #42 to #55 and #88 to #90: the layout point rules and texts (`LayoutPointCsvFormat.IsAcceptedHeader`, prefixes, ids, the save-length rule, "Layout Point" and "Control Point").
- #61 to #66 and #73 to #86: the spool, module, item number, support, bearer and product rules.
- #32, #33, #35 to #41, #56, #57, #59, #60, #67 to #70 and #87: the data model lookups, weld defaults, report text, PCF settings and units, service signature, and the view filter names. #58 `IColorPalette` moved within Domain to `Parameters/FilterRules`. **Done.** #71 and #72, both inside Domain: **done.**
- #156 `OperationServiceLogRecord` is deleted from Kelly-Domain (### Breaking). **Done.**
- Everything here whose source is in Kelly-Revit-Logic or Kelly-Revit: **partial.**

### Into Kelly-Revit-Logic
- #94 `ObjectLogExtensions.WriteToLog`, #95 and #96 `DevelopmentLog.ToLogDevelopment`, and #156 `OperationServiceLogRecord`. Each is the same code, character for character, with 15 new in-Revit tests that pass. The path comes from the string constant `PathExtensions.ApplicationLogsPath`; nothing creates the folder or prompts. **Done.**

### Kelly-Revit-UI and Kelly-Revit
Repinned only. These are the consumer edits that made them compile:
- `ObjectReference` now comes from `Kelly.Windows.Geometry`.
- `AddInServices` is aliased to `Kelly.Windows.Hosting`.
- Three view filter commands call Domain's `ColoredSignatureFilterRules.ToFilterRuleModels`.
- The layout point import names Logic's `LayoutPointCsvFormat.HasAcceptedHeader` in full.

## What was not done (round 2a; since finished, see "Source-side pass")

**82 moves are partial**:
- #1, whose source is Kelly-Domain;
- 46 moves from Kelly-Revit-Logic;
- 33 moves from Kelly-Revit (31 untouched, and 2 touched only to fix a compile error);
- 2 Logic moves whose files were touched only to fix compile errors.

In each, the new member exists, is tested and has shipped in its package, but the source still has its own copy, and its callers still use that copy. That includes:
- Logic's `AddInServices`;
- Logic's `LayoutPointCsvFormat`; the planned split into `LayoutPointTools.HasAcceptedHeader` was not done;
- Logic's `ColoredSignatureExtensions.ToFilterRuleModels`;
- the 13 views' `ValidateRequirements`;
- the layout point, spool, support and product rules in Logic and the modules.

The cause is in the work packages. They were grouped by target layer and listed the source-side edits only as `requiredChanges`. The package agents wrote the new member and left those edits for "the step of the layer above", and no later package did them.

Kelly-Revit-Logic-v5 and Kelly-Revit-v5 each have a Quick-Backlog item for it under "To Organize". The skill needs a fix too: every move whose source is above its target gets a source-side package in the source layer's step (see "What to check").

## Behaviour the user may notice

None intended. After the source-side pass the callers run the lower copies, each checked line by line against its original. The one known difference is #60: when the unit selection throws after the read, the `StreamReader` is now already closed. #4 and #57 were left alone because switching them would change behaviour.

## Bugs found and not fixed

- `DocumentOpenedEventHandler` shows `TaskDialog` directly, and says "(List set to clipboard...)", but nothing sets the clipboard.
- The `IsSameDocument` results in both `View*EventHandler` go into empty `if` bodies.
- `App.OnStartup` shows `TaskDialog` directly after `UserPrompt` is registered.
- `DocumentChangedEventHandler` has two unused `*_Sandbox` methods.
- `Kelly-Windows-v3` `tests/Hosting/ServiceProviderTests.cs` names `IAutoUpdaterControl in Kelly-Revit-Logic` in a comment. It predates the run.
- Three test files this run changed still hold nested helper types from earlier commits:
  - `Kelly-Windows-Data-v3` `DataDirectoryTests` (`FakeReader`, `TestJsonReader`);
  - `Kelly-Windows-v3` `ObjectExtensionsTests` (`Person`);
  - `Kelly-Domain` `LayoutPointExportQualityTests` (`TestPoint`, `CountingSequence<T>`).

  Every type the run added has its own file.
- `percent.sh` rewrote index rows in the root `Backlog - Quick.md`, which already had the user's uncommitted changes. It is left uncommitted for the user.

## Source-side pass (2026-11-04, afternoon)

The user approved finishing the 82 partial moves ("Yes, finish them"). The pass ran a source package in each source layer, then an adversarial review, fixes, builds in every configuration, a pack and the version docs. An audit checked the code, not the reports. Its base commits:

| Repo | Base commit |
|---|---|
| Kelly-Domain | fced06c |
| Kelly-Revit-Logic-v5 | bc6ccc5 |
| Kelly-Revit-UI | 033177e |
| Kelly-Revit-v5 | 0fcd56e8 |

| Repo | Pass commits | Package | Tests |
|---|---|---|---|
| Kelly-Domain | dd30f82 (P5a, #1), b98c3fc, c005dcf | 1.26.1104.1118 | 1530 of 1530 in Net481, Net80 and Net100 |
| Kelly-Revit-Logic-v5 | 9042387 (P6a, 23 moves), e8dfef7 (P6b, 27 of 28 moves), bb57143, 4a90609, 78f5d98 (backlog tick KTRL5-1) | 5.26.1104.1301 | In Revit 2024: 1026 of 1027 on e8dfef7 (`LogDimensionValues` needs the add-in started); after the review fixes, the 96 Architecture guards pass |
| Kelly-Revit-UI | abf6b45 (repin only), 5e4d0b3 | 1.26.1104.1305 | 164 of 164 without Revit in 2024, 2025 and 2026; 44 of 44 in Revit 2024 |
| Kelly-Revit-v5 | 241a0e79 (P8a, #19 to #31), de28a2e2 (P8b, 19 of 20 moves), 09961350, bb256105 (backlog tick KTR5-4580) | not a package. All 21 configurations build with 0 errors; none installed | In Revit 2024: 206 of 210. The same 4 tests need the add-in started. |

What is now true in the code:
- Logic's `Common/AddInServices.cs` and `LayoutPoints/LayoutPointCsvFormat.cs` are deleted. `ColoredSignatureExtensions` no longer has `ToFilterRuleModels`. The CSV header check is `LayoutPointTools.HasAcceptedHeader`, which calls Domain's `IsAcceptedHeader`.
- The host and Trade.All no longer alias `AddInServices`. The three color filter commands call Domain's `ToFilterRuleModels` as an extension. No full `Kelly.Revit.Logic.LayoutPoints.LayoutPointCsvFormat` name is left.
- The 13 views call Kelly.Windows' `ThrowIfNotReady`. No hand-built `NullReferenceException("DataContext")` or `TypeInitializationException` is left.
- Kelly-Domain's `DataStore.Load` reads through `DataDirectory.ReadAllVerified`, and its private `ReadChecked` is gone.
- The Logic and Kelly-Revit layout point, spool, module, support, weld, product and helper callers call the lower copies. Guard tests (`MovedToKellyDomainTests`, `MovedToKellyWindowsTests`, `LowerLayerRulesTests`, `ViewReadinessTests`) fail if an original comes back.
- `check-rules.pl` is unchanged from the baseline for rules 1 to 4. Every type the pass added has its own file, and no new test `Author` has a date.
- The manifests are as at the start: `Kelly Tools For Revit 5.addin` is active and `Kelly Tools For Revit.addin.x` is disabled. No Revit, ricaun or testhost process was left running.

Skipped on purpose, each a To Organize backlog item that waits for the user's decision:
- **#4 Layout Point To CSV Export** still calls `Process.Start("explorer.exe", directoryPost)`. `ShellTools.OpenInExplorer` quotes the path, so a folder with spaces would then open correctly. That is a behaviour change.
- **#57 `CustomDataUpdateEvaluator.ResolveRecord`** stays. Domain's `TryResolveRecord` throws `ArgumentNullException` for a null dictionary up front, while the original reports "Missing {identity} Error" for a part with no identity. No caller passes null.

Also noted:
- Kelly-Revit-v5 `Quick-Backlog.md` has three other new items:
  - three commands never call `ValidateRequirements`;
  - the Module Creator view model tests repeat Domain's numbering rule;
  - the #60 entry, where the `StreamReader` now closes before the unit selection.
- `LayoutPointRecipeIngredients.GetIdNumber` still has a "Control Point" literal (no move covers it).
- The optional #33 `Product.UsesProductRates` predicate was not added.

**Push state** (found by the audit, not done by this run): Kelly-Domain up to adbf979, Kelly-Revit-Logic-v5 up to 4a90609 and Kelly-Revit-UI up to 5e4d0b3 are already on `origin/develop`. They were pushed between 12:06 and 13:09, from outside the run. Still unpushed:
- Kelly-Domain 173696b (the other session's KD-10 tick);
- Logic 78f5d98;
- Kelly-Revit-v5 241a0e79, de28a2e2, 09961350 and bb256105.

## What to check

1. **Decide #4 and #57** (backlog items in Kelly-Revit-v5 and Kelly-Revit-Logic-v5).
2. **Decide on the "Moved from … Kelly-Revit-Logic-v5, which keeps …" remarks** in Kelly-Domain (34). They name the higher layers in Domain. They are now true apart from #57, but the history is already in the Changelogs.
3. **Confirm the pushes made at 12:06 to 13:09 were intended**, and push the rest of `develop` bottom-up when ready.
4. **Not covered:** in-Revit tests in Revit 2025 and 2026, and an install of the v5 add-in to try the tools by hand.
5. **Round 2b** (#91 to #254) is still to plan and run.
