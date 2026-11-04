# Layer moves - 2026-11-03 (round 1)

Round 1 of the abstractions found in the 2026-11-03 ViewModel review, implemented bottom-up through the v5 chain from the plan in `LAYER-MOVES-PLAN-2026-11-03.md` and the user's four decisions:
- all five moves;
- a Shop Tack Weld (STK) is Shop, which brought deferred move #6 into the round;
- fix the pinned bugs in this release;
- the host's root namespace becomes `Kelly.Revit.Core`.

Every move came from a design that an adversarial reviewer checked. Each work package was implemented test-first as one commit. Each repo's commits were then reviewed again and fixed until every configuration built and its tests passed, and the layer was packed. An audit then read the diffs against the run's starting commits.

Nothing was pushed, and the add-in was not installed.

## Result

| Repo | Run commits | Package | Tests (before → after) |
|---|---|---|---|
| Kelly-Windows-Data-v3 | none | unchanged, 3.26.1102.1424 | not run (no change) |
| Kelly-Windows-v3 | 4 (`9e94c7e` … `9e49e89`) | `3.26.1103.1535` | 562 → 608 in each of Net481, Net80, Net100; all pass |
| Kelly-Domain | 11 (`e578624` … `05dcfd0`) | `1.26.1103.1717` | 699 → 966 in each of Net481, Net80, Net100; all pass |
| Kelly-Revit-Logic-v5 | 5 (`3dc5c91` … `0b0469b`) | `5.26.1103.1841` | in Revit 2024: 935 → 947; full run 946 of 947 (the one failure, `LogDimensionValues`, is inconclusive without the add-in by design) |
| Kelly-Revit-UI | 3 (`c09c8ae` … `d8a0c1b`) | `1.26.1103.1851` (repin only) | 164 of 164 without Revit in 2024/2025/2026; 44 of 44 in Revit 2024 |
| Kelly-Revit-v5 | 8 (`d4084c71` … `a4b93e65`) | not a package; 21 configurations built (host and 6 modules × 2024/2025/2026), none installed | in Revit 2024: 105 → 132; 128 of 132 pass, and the 4 that fail need the add-in started (`ApplicationLoggerTests`, 3 `EventServiceTests`), as before |
| Kelly-Revit-v4 | 1 (`5cf6bdf`), backlog only | – | – |

- **Packages:** 14 planned, 14 done, 0 partial, 0 skipped.
- **Errors:** 0 in every configuration.
- **Pins** (one property per repo): Windows.Data `3.26.1102.1424` → Windows `3.26.1103.1535` → Domain `1.26.1103.1717` → Logic `5.26.1103.1841` → UI `1.26.1103.1851` → Kelly-Revit-v5. Restore resolves exactly these.
- **Rules** (`check-rules.pl`, before → after):
  - no Revit API in the Revit-free layers: 0 → 0;
  - no lower layer names a higher one: 0 → 0;
  - no protected files outside Kelly-Revit: 0 → 0 (7 allowed, the same 7);
  - namespace ≠ folder: **8 → 0** (the host namespace fix);
  - 133 commands and 42 view/view-model files are still in Kelly-Revit.
- **Git:** no Co-Authored-By lines, no other branches, nothing staged. The user's files are untouched: Kelly-Revit-v5 `AGENTS.md`, the untracked plan and diagram files in Kelly-Revit-v4 and -v5, and the jhkweb root's `Backlog - Quick.md`.

## What moved, by layer

### Into Kelly-Windows-v3

- **#5, the length-text parse.** Racker's private `TryParseDesiredElevation` became `ConstructionServices.TryParseDecimalFeet(this string, out double feet)`, verbatim. Its 22 in-Revit cases now run without Revit, plus 21 new ones. Racker calls it; a guard test checks the copy is gone.

### Into Kelly-Domain

- **#1, the module-number rules.** They moved from Module Creator to `Kelly.Domain.Spools.ModuleNumber`: `SequenceFormat` (`D3`), `Create`, `GetPrefixes`, `HasPrefix`, `HasModuleType` and `GetNextSequence`.
- **#2, the spool-name rules.** They moved from Spool Create to `SpoolNumber`: `TryComposeName`, `TrySplitName`, `HasLineNumber` and `HasCategory`. `GetNextSequence` shares the prefix helper.
- **#3, the Layout Point Export quality rule.** It is now `LayoutPointRecipe.IsInvalidForExport` and `LayoutPointExportQuality.TryGetWorstFlag<T>`.
- **#4, the Point To Pipe unit rules.** These moved from the view's code-behind: `PointToPipeUnits` (unit names, `FromUnitText`, the `To*UnitsText` and `Select*` rules) and `VtfrSettings.GetGlobalUnits`.
- **#6, the weld location rules.** `TerminologyTools.FindByTerm` and `WeldLocationTools.GetBillOfMaterialType` hold the one Shop/Field rule: an initialism starting with S is Shop.

### Kelly-Revit-Logic-v5

- `WeldLocationService` uses the Domain weld rules, with no behaviour change.
- `ProductRange10Joints01Weld.SetLocation` uses the same rule, so STK is now Shop (see below).

### Kelly-Revit-v5

- The five tools are repointed to the moved members, and their old copies are deleted:
  - Module Creator;
  - Spool Create;
  - Layout Point Export;
  - Point to Pipe;
  - Racker.
- The host's root namespace is `Kelly.Revit.Core`. That covered:
  - the `Core.csproj` `RootNamespace`;
  - both `Properties` designers, including the `ResourceManager` base name;
  - the `Settings` alias;
  - `App.config`, `Kelly.Revit.dll.config` and `Settings.settings`.
  
  The new `HostPropertiesTests` pins it.

## Fixed in this release (user decision: fix the pinned bugs)

| Fix | Commit | Visible in the add-in |
|---|---|---|
| Module Creator "Last Module" showed `AB-MOD-5` for `AB-MOD-005` | Domain `d867ee9` | Last Module is now padded, `AB-MOD-005` |
| "Spools with Line Number Found" counted `L10-…` for line `L1`; "Spools with Category Found" matched `-SPL-` anywhere | Domain `d6ba5b2` | Counts compare whole name parts |
| The "Invalid" layer marker was case-sensitive, so the upper-cased layer name never matched | Domain `d4d278f` | Export flags `INVALID` layers |
| Spool Manager wrote Field for a Shop Tack Weld (STK); the Weld Location buttons wrote Shop | Logic `f28bf5b` | STK is Shop everywhere |
| Spool Manager's Welds tab: every Update button showed "Error Reading Object" and wrote nothing | Kelly-Revit-v5 `d4084c71` | The buttons write the weld location |

## Not done

- **Partial or skipped:** none.
- **Dropped at the plan:**
  - Suspended Support Manager's JHK Long Description set: Kelly-Domain already has `ComponentDefinitionSet.JhkLongDescription`.
  - The export-dialog wording.
  - Racker's TaskDialog to `UserPrompt`, because it changes behaviour.
- **Deferred:** #7, the Point to Pipe settings file. It waits for the switch to a JSON settings file.
- **Later rounds, not yet designed:** 25 Logic candidates and 5 UI candidates.
- **Major Version 4:** v4 keeps its own copies. Its backlog now records:
  - the STK = Shop decision and the weld-button bug;
  - the always-Imperial units item (commit `5cf6bdf`).

## Behaviour you may notice

- The five fixes in the table above.
- **Any weld initialism starting with "S" is now Shop in Spool Manager.** The shipped `Terminology.csv` has only S and STK, so in practice only STK changes.
- **Spool Create counts:** a name that is only the line number, a name whose middle part is not a spool category (for example a module `B1-MOD-001`), and a name with an empty sequence no longer count.
- **Developers:** the host's namespace is `Kelly.Revit.Core` (`Kelly.Revit.Core.Properties.Resources` / `.Settings`). The settings section in `App.config` and `Kelly.Revit.dll.config` was renamed with it. All three settings are application-scoped and ship in that config file, so no user's saved settings are affected.
- **Developers:** `ConstructionServices.TryParseDecimalFeet`, `ModuleNumber.*`, `SpoolNumber.*`, `PointToPipeUnits`, `LayoutPointExportQuality`, `TerminologyTools` and `WeldLocationTools` are new public API in the packages.

## Bugs found and deliberately NOT fixed

Each one is pinned by a test as current behaviour and backlogged as an open item.

### Medium

- **Point to Pipe always starts in Inches and Feet, metric projects included.** Nothing assigns `VtfrSettings.VtfrUserSettings`, so the project-units fallback is never reached. Backlogged in v5 and v4.
- **Spool Create offers the SPA and SPT categories.** `SpoolNumber.TryParse` accepts only RCK, ESP and SPL, so those spools are left out of the spool-number lists. This needs a decision and a check in Revit.
- **`LayoutPointExportCandidate.QualityCheck` always returns `UnChecked`** (Logic `src/LayoutPoints/LayoutPointExportCandidate.cs:103`). The export's Danger and Caution counts never fire.

### Low

- **`SpoolNumber.GetNextSequence` still matches names on their start.** For line A, category SPL, it counts `A-SPL-B-SPA-005` and proposes 6.
- **A project with no modules offers the placeholder prefix DEFAULT** (DEFAULT-MOD-002). Sequences at `int.MaxValue` wrap to negative numbers.
- **`ConvertFractionToDecimalFeet` breaks its 0 default.** It throws on `1.2.3'` and on huge inch values, and returns 0 for text with no digit. `TryParseDecimalFeet` is lenient: `1'abc` is 1 foot, and `1,000` and `1e3` are 1000 feet.
- **`FindByTerm` searches every category.** `Shop` and `Field` alone find the BOM-type rows. Today's callers always pass full weld terms.

## Found on the way

- **The NU1202 restore failures were a stale assets file, not a race.** The cause of `NU1202 Microsoft.NETCore.Platforms 1.1.0 … net8.0-windows7.0` (2025/2026 test projects, also seen 2026-10-30) was `BuildConfigs\dotnet\TestLogger\obj\project.assets.json`, written while the NuGet cache had lost its `_._` files. NuGet kept those file lists through every restore, so any restore that restored the logger first failed. The file was moved aside (it is git-ignored build output), and the Kelly-Revit-v5 and -UI READMEs now give that cause and fix.
- **Garbled dashes in the backlogs.** My 2026-11-03 bug-backlog commits had written em dashes and ellipses double-encoded in the v4 and v5 `Quick-Backlog.md`. Repaired (`5cf6bdf`, `a4b93e65`).

## Things to check

- **In Revit:**
  - Spool Manager's weld Update buttons (an STK weld should get Shop);
  - Module Creator's Last Module;
  - Spool Create's two counts;
  - Layout Point Export on an `INVALID` layer.
  
  The tests cover the rules, but no one has clicked through the windows.
- **The root index `Backlog - Quick.md` has stale percentages.** It holds your uncommitted edits, so I left it alone. The new figures:
  - Windows-v3: 36% (4 of 11);
  - Domain: 52% (12 of 23);
  - Logic: 67% (14 of 21);
  - UI: 67% (6 of 9);
  - Revit-v5: 44% (50 of 113);
  - Revit-v4: 35% (23 of 65).

## Next

Push `develop` bottom-up: Kelly-Windows-v3, Kelly-Domain, Kelly-Revit-Logic-v5, Kelly-Revit-UI, Kelly-Revit-v5, then Kelly-Revit-v4 (backlog only).
