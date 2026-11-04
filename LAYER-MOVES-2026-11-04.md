# Layer moves - 2026-11-04 (round 2a)

Round 2a of [LAYER-MOVES-PLAN-2026-11-04.md](LAYER-MOVES-PLAN-2026-11-04.md). It was planned as moves #1 to #90 (without #34, deferred) plus the rule-1 fixes #94, #95, #96 and #156: 93 moves. It ran bottom-up, test-first, one commit per work package. Each layer went through an adversarial review and fixes, was built in every configuration, packed, and repinned in the layer above. The first run stopped when the session ended, partway through Logic. A second run finished Logic, Kelly-Revit-UI and Kelly-Revit. Nothing was pushed, and the add-in was not installed.

**Main finding: the source side of 82 moves was never done.** For each of them the code was added to its new lower layer and tested there, but the original still runs in Kelly-Revit-Logic or Kelly-Revit, and nothing calls the new copy. Behaviour is unchanged, but the code now exists twice. See "What was not done".

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
| Done | 11 | #8, #12, #13, #14, #58, #71, #72 and the rule-1 fixes #94, #95, #96, #156 |
| Partial | 82 | listed under "What was not done" |
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

## What was not done

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

None. All the code that runs is the code that ran before: the moved copies are not called yet, except #94 to #96, #156, #8, #12, #13 and #14, which are character-for-character moves.

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

## What to check

1. **Finish the source side of the 82 partial moves:**
   - a Domain package for #1;
   - a Logic package that deletes or forwards its copies, adds `LayoutPointTools.HasAcceptedHeader` and drops the Logic `AddInServices`;
   - repin Kelly-Revit-UI;
   - a Kelly-Revit package that points the views, view models and commands at the new members and drops the aliases.

   Then repack Logic and UI, rebuild all 21 configurations and rerun the in-Revit tests.
2. **Decide on the "Moved from … Kelly-Revit-Logic-v5, which keeps …" remarks** in Kelly-Domain (34). The history is already in the Changelogs, so dropping the remarks would keep the higher layers' names out of Domain.
3. **Fix the skill** so a move's source-side edits are their own package in the source layer, and the audit checks that each move's source no longer has the code.
4. **Push `develop`** bottom-up only when the user says so.
