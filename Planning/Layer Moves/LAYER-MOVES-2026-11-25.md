# Layer moves 2026-11-25: after-action report

The plan is in `LAYER-MOVES-PLAN-2026-11-25.md`: 57 moves in 18 work packages, through Kelly-Windows, Kelly-Domain, Kelly-Revit-Logic, Kelly-Revit-UI and Kelly-Revit, plus one deferred move (#20, [KD-121](https://linear.app/jhkelly-ktr/issue/KD-121)). The implementation workflow ran for 4 hours 45 minutes (40 agents, none failed). The Linear project is [Layer Moves 2026-11-25](https://linear.app/jhkelly-ktr/project/layer-moves-2026-11-25-141eb9fb756c).

## Result

| | |
|---|---|
| Packages done | 17 of 18 |
| Packages partial | 1: P5b, [KTR5-4950](https://linear.app/jhkelly-ktr/issue/KTR5-4950) (#35 and #36 deferred to [KTR5-4968](https://linear.app/jhkelly-ktr/issue/KTR5-4968); panes not yet checked by eye) |
| Moves done | 55 of 57 (#20 was deferred at the plan) |
| Rules check | Same as the baseline: rules 1 to 4 have 0 hits; the same 9 allowed protected files; 126 command classes, 48 view or view model files |
| Builds | 0 errors: Kelly-Windows and Kelly-Domain (Net481, Net80, Net100); Logic and UI (2024, 2025, 2026); Kelly-Revit host and six modules (2024, 2025, 2026, all 21) |
| Behaviour changes | Only the three FIX packages decided at the plan: #11 ([KTRL5-214](https://linear.app/jhkelly-ktr/issue/KTRL5-214)), #42 ([KTRL5-215](https://linear.app/jhkelly-ktr/issue/KTRL5-215)), #15 ([KW3-72](https://linear.app/jhkelly-ktr/issue/KW3-72)) |

## Per layer

| Layer | Packages | Commits | Package | Tests |
|---|---|---|---|---|
| Kelly-Windows | [KW3-69](https://linear.app/jhkelly-ktr/issue/KW3-69) to [KW3-73](https://linear.app/jhkelly-ktr/issue/KW3-73) | 2f3c597, 232a4a0, e8785d7, e3dfa78, 5c20df0; review fixes 26c1bc7; stamp ceff394 | 3.26.1125.1025 | 990 passed in each of Net481, Net80, Net100 |
| Kelly-Domain | [KD-117](https://linear.app/jhkelly-ktr/issue/KD-117) to [KD-120](https://linear.app/jhkelly-ktr/issue/KD-120) | d1dc00a, 8f713dd, 4af7668, 30b146c; review fixes 2b37567; stamp 0a52727 | 1.26.1125.1050 | 2174 passed in each configuration |
| Kelly-Revit-Logic | [KTRL5-211](https://linear.app/jhkelly-ktr/issue/KTRL5-211) to [KTRL5-215](https://linear.app/jhkelly-ktr/issue/KTRL5-215) | b7a1c99, 79f1652, a472025, 6b89e99, 0ae0757; review fixes a09063d, ec8138f, b3a0f83, 104c376; stamp b7dcdb3 | 5.26.1125.1311 | In Revit 2025: every fixture this run touched passed, some in filtered runs ([KTRL5-228](https://linear.app/jhkelly-ktr/issue/KTRL5-228)); the fixtures that open the Kelly test model passed in Revit 2024 in another session's run |
| Kelly-Revit-UI | [KTRUI-55](https://linear.app/jhkelly-ktr/issue/KTRUI-55), [KTRUI-56](https://linear.app/jhkelly-ktr/issue/KTRUI-56) | 9e633da, 4e2a01f; review fixes ba21287; stamp 05d13a7 | 1.26.1125.1326 | 301 passed outside Revit (2024, 2025, 2026); in-Revit tests compiled, **not run** (another session's test console was running) |
| Kelly-Revit | [KTR5-4949](https://linear.app/jhkelly-ktr/issue/KTR5-4949), [KTR5-4950](https://linear.app/jhkelly-ktr/issue/KTR5-4950) | 5d6aa43a, 80cce39e; review fixes d11bff46 | not a package | In Revit 2025, unfiltered: 1740 of 1756 passed; the 16 failures all existed before this run (4 need the add-in started; 11 Excel interop and 1 `System.Management` under .NET 8) |

## What the reviews caught

Each layer had an adversarial review; every finding was fixed in its own commit.

- **Kelly-Windows:** `OrderBySavedKeys` placed equal unsaved items differently from the original; now ranked by `IndexOf` as before. One test computed its expected values with the code under test.
- **Kelly-Domain:** `TryResolveComponentAndGauge` gained argument guards the original did not have; removed, so the original null behaviour holds. A provenance remark left in XML docs, and tests that changed process-wide configuration without restoring it.
- **Kelly-Revit-Logic:** a connector test compared objects from two reads; the spool selection scope; stale in-Revit tests ([KTRL5-227](https://linear.app/jhkelly-ktr/issue/KTRL5-227)).
- **Kelly-Revit-UI:** undocumented exception and unpinned cases of `SetPowerIconsOfItem`.
- **Kelly-Revit:** the Assigner view filter command read the combo box value before the view filter constructor ran; it reads it afterwards again, with a test. README test counts off by one.

## Kept on purpose (characterized by tests, not fixed)

- `TryReadInches` reads a plain number with the current culture (#5; the add-in is US-only).
- The flat strap rod length reads a dimension named `TBD` (#31).
- The leader elbow offset is NaN for a horizontal or vertical leader (#9).
- The Gauge Lookup Error text still names SQL Server (#32).
- Small, recorded order and exception-type differences: #30 reads the category before the product range; #9 and #39 throw `ArgumentNullException` where the old code threw `NullReferenceException` for inputs no caller passes.

## Issues filed during the run

- [KD-122](https://linear.app/jhkelly-ktr/issue/KD-122): `default(DetailingPackage)` has a null value, so its hash code throws.
- [KTRL5-227](https://linear.app/jhkelly-ktr/issue/KTRL5-227): stale in-Revit tests (fixed in this run).
- [KTRL5-228](https://linear.app/jhkelly-ktr/issue/KTRL5-228): an unfiltered in-Revit run silently left out 17 fixtures.
- [KTR5-4968](https://linear.app/jhkelly-ktr/issue/KTR5-4968): Spool Number Set and Clear commands, #35 and #36, for the maintainer to decide.

## Still to do

- [KTR5-4950](https://linear.app/jhkelly-ktr/issue/KTR5-4950) (In Review): check both Assigner panes' colours and layout by eye in Revit; decide [KTR5-4968](https://linear.app/jhkelly-ktr/issue/KTR5-4968).
- [KTRUI-56](https://linear.app/jhkelly-ktr/issue/KTRUI-56) (In Review): run the Kelly-Revit-UI in-Revit tests (`SetPowerIconsOfItemTests`, and the rest since `ViewModel` changed).
- [KD-121](https://linear.app/jhkelly-ktr/issue/KD-121) (Backlog): the deferred `DataFileService` move.
- `revit-test.sh` defaults to Revit 2025 for this run; set it back to 2024 once the maintainer is done in 2024.

## What happened around the run

- **Revit 2025 template dialog:** every Revit 2025 start showed "The path specified for default family templates is empty or invalid" until someone clicked OK, which stalled unattended test runs. The company `Revit.ini` points at `C:\Projects\Revit\Library`, which did not exist; the folder was created at 14:23 and later starts showed no dialog.
- **Other sessions worked in the same repositories during the run:** [KW3-77](https://linear.app/jhkelly-ktr/issue/KW3-77), [KD-124](https://linear.app/jhkelly-ktr/issue/KD-124) to [KD-130](https://linear.app/jhkelly-ktr/issue/KD-130), [KTR5-4644](https://linear.app/jhkelly-ktr/issue/KTR5-4644), [KTR5-4966](https://linear.app/jhkelly-ktr/issue/KTR5-4966) and [KTR5-4967](https://linear.app/jhkelly-ktr/issue/KTR5-4967). KTR5-4967 repinned Logic, UI and Kelly-Revit onto 1.26.1125.1427 / 5.26.1125.1427, built on top of this run's commits, and installed 5.26.1125.1430 for Revit 2024, so the installed 2024 add-in already holds this run's moves. The pins are therefore newer than this run's packages, and consistent.
- **Pushed:** every repository's `develop` was pushed at 14:21, 14:29 and 14:39, not by this run.
- **Your files:** Kelly-Revit-v5 `.gitignore` and `installer/test/Run-InstallTest.cmd` are still uncommitted and untouched.
- **Workflow stop:** the workflow reported Kelly-Revit "not clean after 3 attempts" only because the third attempt reported before its builds finished; its build log shows 0 errors in every configuration, and attempt 2 had passed every build and the in-Revit run on the same commit.
