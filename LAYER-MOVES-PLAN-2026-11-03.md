# Layer moves plan - 2026-11-03

Round 1 moves the Revit-free logic out of five Kelly-Revit-v5 tools into Kelly-Domain and Kelly-Windows-v3, where it can be tested without Revit. Each move was designed against the code by one agent and attacked by an independent reviewer; every reviewer accepted the move with corrections, which this plan adopts. Nothing has changed in the repos yet.

The candidates come from the 2026-11-03 ViewModel review (40 extractions; the judges agreed the ViewModels themselves stay in their modules). This round covers the 8 that target Kelly-Domain and Kelly-Windows-v3. The 30 that target Kelly-Revit-Logic-v5 and Kelly-Revit-UI are later rounds, not yet designed.

## Summary

| | Count |
|---|---|
| Round 1 candidates designed and reviewed | 8 |
| To do (#1 to #5) | 5 |
| Deferred (#6, #7) | 2 |
| Dropped | 1, plus 2 the judges dropped earlier |
| Later rounds (Logic 25, UI 5) | 30, not yet designed |

## Round 1 moves

Every move preserves behaviour exactly. The tool's ViewModel (or View) stays in its module and calls the new member. Tests are written first, in the target layer, and characterize current behaviour, bugs included.

| # | From | What moves | To | Tests (written first) | Risk |
|---|---|---|---|---|---|
| 1 | Module Creator view model | Module-number rules: `Create` (sequence padded to 3 digits), `GetPrefixes`, `HasPrefix`, `HasModuleType`, `GetNextSequence` | Kelly-Domain `Spools/ModuleNumber` (extends the existing struct) | `tests/Identifiers/ModuleNumberTests.cs` | low |
| 2 | Spool Create view model | Spool-name rules: `TryComposeName`, `HasCategorySegment`, `StartsWithLineNumber`, and a private prefix helper that `GetNextSequence` shares | Kelly-Domain `Spools/SpoolNumber` | `tests/Spools/SpoolNumberTests.cs` | low |
| 3 | Layout Point Export view model | Export quality rule: `LayoutPointRecipe.IsInvalidForExport` and `LayoutPointExportQuality.TryGetWorstFlag` | Kelly-Domain `LayoutPoints` | `LayoutPointRecipeTests`, new `LayoutPointExportQualityTests` | low |
| 4 | Point to Pipe view (code-behind) | Unit-name and unit-selection rules: `PointToPipeUnits`, `VtfrSettings.GetGlobalUnits` | Kelly-Domain `Pcf` | new `PointToPipeUnitsTests`, `VtfrSettingsTests` | low |
| 5 | Racker view model | Length-text parse: today's `TryParseDesiredElevation` moves verbatim as `TryParseDecimalFeet`; its 22 in-Revit test cases move with it and run without Revit | Kelly-Windows-v3 `Measurements/ConstructionServices` | `tests/Measurements/ConstructionServicesTests.cs` | low |

Reviewer corrections adopted:

- **#1**: name the pinned bugs by their text, not backlog line numbers; add the empty-number cases for `HasModuleType`; no application name in Kelly-Domain docs or tests.
- **#2**: `StartsWithLineNumber` returns false for a null name instead of throwing; `GetNextSequence` and `TryComposeName` share one prefix helper (DRY); the member is documented as the rule before the "L1 counts L10" fix, which will replace it; the test signatures are corrected.
- **#3**: the "both Invalid and Danger" test is renamed for what it can observe; no `[TestCaseSource]`, so every case carries its Author.
- **#4**: the delegate call order is asserted with a shared log; whitespace saved-text cases are added; the `VtfrSettingsTests` fixture becomes `[NonParallelizable]`.
- **#5**: the out parameter keeps the name `feet` (the draft's rename did not compile); the "throws" pins are split into separate cases; the README test count comes from the test log, not arithmetic; the XML docs carry no Revit or tool wording.

Move #4 comes from a `*View.xaml.cs`. The View stays where it is; only its Revit-free rules move, which placement rule 2 allows.

## Deferred

| # | Candidate | Why | Unblocked by |
|---|---|---|---|
| 6 | Weld Shop/Field rule (Spool Manager, the Weld Location assigner) | Two rules disagree only for Shop Tack Weld (STK). Moving either one now would make it the canonical rule before that is decided. Spool Manager's weld Update buttons also write nothing today (backlogged). | Your decision on STK |
| 7 | Point to Pipe settings file (`PointToPipe.txt`) | The code's TODO and the v5 backlog ask for a JSON settings file, as Module Creator and Spool Create use. A Domain reader for the 7-line text format would be added only to be removed. | A decision to switch it to JSON (its own change) |

## Dropped

| Candidate | Why |
|---|---|
| Suspended Support Manager's own definition set for JHK Long Description | Not an abstraction: Kelly-Domain already has it (`ComponentDefinitionSet.JhkLongDescription`). What is left is a one-line edit inside the view model with one caller and no test value. Backlog it as a clean-up instead. |
| Layout Point Export quality-dialog wording to Kelly-Domain | Dropped by the judges: one tool's dialog wording stays with the caller. |
| Racker's TaskDialog to `UserPrompt.Confirm` | Dropped by the judges: changes behaviour. |

## Bugs pinned as current behaviour

The tests pin these as they are. Each gets a backlog item if it does not have one, and is fixed later in its own test-first commit (or in this release, if you choose that below).

| Move | Bug | Backlog |
|---|---|---|
| #1 | "Last Module" shows AB-MOD-5 for AB-MOD-005: `ModuleCreatorSettings.GetModuleNumber` composes without padding | v5 and v4, found 2026-11-03 |
| #1 | A project with no modules offers the placeholder prefix DEFAULT and proposes DEFAULT-MOD-002 | v5 and v4, found 2026-11-03 |
| #1 | The next sequence after AB-MOD-2147483647 wraps to a negative number; an overflowing sequence reads as -1 | new, very low |
| #2 | "Spools with Line Number Found": L1 also counts L10-... spools | v5 and v4, found 2026-11-03 |
| #2 | The category count matches "-SPL-" anywhere in the name | new, low |
| #2 | Spool Create offers the SPA and SPT categories, but `SpoolNumber.TryParse` accepts only RCK, ESP and SPL, so those spools are left out of the spool-number lists | new, not checked in Revit |
| #3 | The "Invalid" layer marker is compared case-sensitively, so it never matches an upper-cased layer name | new, low |
| #4 | Point to Pipe always starts in Inches and Feet: nothing loads the user's global units, so they stay Imperial | new, medium |
| #5 | `ConvertFractionToDecimalFeet` throws on `1.2.3'` and on more inches than a whole number holds, and returns 0 for text with no digit | the existing "move the check into Kelly-Windows" item |

## Release order

One bottom-up chain, every repo on develop, nothing pushed until you say:

1. **Kelly-Windows-v3**: #5, tests first; tests in Net481, Net80 and Net100; pack.
2. **Kelly-Domain**: repin to that Kelly.Windows; #1 to #4, tests first; tests in Net481, Net80 and Net100; pack.
3. **Kelly-Revit-Logic-v5**: repin to that Kelly.Domain (no code change); build 2024, 2025 and 2026; compile its in-Revit tests; pack.
4. **Kelly-Revit-UI**: repin to that Logic (no code change); build; run its non-Revit tests; pack.
5. **Kelly-Revit-v5**: repin to that UI. Repoint the four view models and the Point to Pipe view. In `Tests.Revit`, the 22 parse cases leave (they now run in Kelly-Windows-v3) and the 4 Cancel cases stay. Build 21 configurations without installing; run `Tests.Revit` in Revit 2024 with the add-in disabled.

Each repo gets its README (layout row, test count), its Changelog entry and its Quick-Backlog items in the same commit.

## Rules baseline

`check-rules.pl` before any change: no Revit API in the Revit-free layers, no dependency running upward, no protected file outside Kelly-Revit. 133 commands and 42 view and view-model files are in Kelly-Revit-v5. One pre-existing finding: the 8 host files in `Kelly-Revit-v5/src` declare `Kelly.Revit.Core.*`, while `Core.csproj` sets `RootNamespace` to `$(SolutionName)`, which is `Kelly.Revit`.

## Decisions needed

1. Round 1 scope: all five moves?
2. Shop Tack Weld (STK): BOM type Shop or Field? This unblocks #6 and the fix for Spool Manager's weld buttons.
3. Bugs pinned by round 1: fix them in this same release, each in its own test-first commit after its move, or leave them for later?
4. The host namespace: make `RootNamespace` match the code (`Kelly.Revit.Core`), or rename the code to `Kelly.Revit`?
