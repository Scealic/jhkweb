# Linear Estimates — 2026-11-06 (proposal)

Open issues (triage, backlog, unstarted, started) of every team in the jhkelly workspace; no Hasa team exists today. Every team uses the exponential scale (1, 2, 4, 8, 16; KTR5 also has a 0). The four Kelly-Windows-Data format teams (KWDC, KWDJ, KWDSS, KWDSL) have no issues. Estimated by Sonnet subagents from the issue text and the code. Parents of open sub-issues get no estimate of their own; existing estimates (most set on 2026-11-04) were kept unless the evidence clearly pointed elsewhere. Nothing is applied yet.

## Summary

| Team | Open | New | Changed | Unchanged | Skipped (parents) | Points proposed | Text only |
|---|---|---|---|---|---|---|---|
| KWD3 | 3 | 0 | 2 | 1 | 0 | 19 | 0 |
| KW3 | 10 | 1 | 0 | 9 | 0 | 35 | 0 |
| KW2 | 1 | 0 | 0 | 1 | 0 | 1 | 0 |
| KD | 24 | 3 | 1 | 20 | 0 | 47 | 0 |
| KTRL5 | 49 | 19 | 0 | 25 | 5 | 138 | 0 |
| KTRUI | 4 | 0 | 1 | 3 | 0 | 10 | 0 |
| KTR5 | 201 | 8 | 2 | 177 | 14 | 670 | 0 |
| KTRL4 | 2 | 0 | 0 | 2 | 0 | 6 | 0 |
| KTR4 | 50 | 0 | 0 | 48 | 2 | 123 | 0 |
| **Total** | 344 | 31 | 6 | 286 | 21 | 1049 | 0 |

"Unchanged" includes two parents that keep the estimate someone set (KTR5-3800 at 0, KTR5-4604 at 2); clearing those needs your say-so.

## Changes to existing estimates

| Key | Title | Current | Proposed | Reason |
|---|---|---|---|---|
| [KWD3-2](https://linear.app/jhkelly/issue/KWD3-2) | Rename JsonFileLoadException, the declared failure for every format, C | 8 | 16 | rename JsonFileLoadException used in 32 files across layers; split |
| [KWD3-7](https://linear.app/jhkelly/issue/KWD3-7) | Decide ICache's fate (src/Caching/ICache.cs) | 4 | 2 | ICache has no users; delete or add tests in one repo |
| [KD-23](https://linear.app/jhkelly/issue/KD-23) | default(LayoutPoint).IsValid throws NRE and LayoutPoint is mutable | 4 | 2 | null Description guard in one type; struct immutability may widen it |
| [KTRUI-2](https://linear.app/jhkelly/issue/KTRUI-2) | Handle the open // todo notes in Kelly-Revit-UI | 4 | 1 | only one todo comment left in the repo |
| [KTR5-4626](https://linear.app/jhkelly/issue/KTR5-4626) | Order the User Domain Report (Developer tab) by EmployeeId | 4 | 8 | needs sort and EmployeeId read in Kelly-Windows-v3 repinned to add-in |
| [KTR5-4661](https://linear.app/jhkelly/issue/KTR5-4661) | Racker: user cancel ends the command as Failed instead of Cancelled | 4 | 2 | result code change in one command, though several exit paths |

## New estimates

| Key | Title | Proposed | Confidence | Reason |
|---|---|---|---|---|
| [KW3-1](https://linear.app/jhkelly/issue/KW3-1) | Repoint the layers above to the helpers moved down in round 2 (#2 to # | 8 | medium | repoint layers above to 14 moved helpers, packs and repins up to Kelly-Revit |
| [KD-45](https://linear.app/jhkelly/issue/KD-45) | ModuleComponentModel: integer Range on double columns lets 100.5 and 20 | 1 | high | change two Range attributes, tests already pin it |
| [KD-46](https://linear.app/jhkelly/issue/KD-46) | Support tags: pairing groups hashes case-sensitively, NextTag ignores c | 2 | medium | two small comparison fixes in one area plus tests |
| [KD-49](https://linear.app/jhkelly/issue/KD-49) | DuctDefinitionSet name is duct-specific but serves every fabrication p | 2 | medium | rename one type across Kelly-Domain; breaking for Trade.Duct callers |
| [KTRL5-61](https://linear.app/jhkelly/issue/KTRL5-61) | BOM type write: Spool Manager and Module Manager write different value | 4 | medium | decision plus merging two overloads, in-Revit tests |
| [KTRL5-62](https://linear.app/jhkelly/issue/KTRL5-62) | Duct item numbers: Reset and Run Item Number Set clear them differentl | 4 | medium | decide one clear and fix two tools with in-Revit tests |
| [KTRL5-63](https://linear.app/jhkelly/issue/KTRL5-63) | AutoUpdaterService: NullReferenceException for an updater that was nev | 2 | high | one type fix with tests |
| [KTRL5-64](https://linear.app/jhkelly/issue/KTRL5-64) | GetCropBoxRotationAxis: NullReferenceException when the crop box has n | 2 | high | one-method null fix with a test |
| [KTRL5-65](https://linear.app/jhkelly/issue/KTRL5-65) | IsModelInstance: NullReferenceException for an element with no owner v | 2 | high | one-method null fix with a test |
| [KTRL5-66](https://linear.app/jhkelly/issue/KTRL5-66) | OletTapTools and PointToPipeTargets: test the fabrication paths the sa | 4 | medium | in-Revit tests on the Kelly fabrication project |
| [KTRL5-67](https://linear.app/jhkelly/issue/KTRL5-67) | GetPlaneOfPlanarFace and TrySetPartCustomDataValue: test the untested | 4 | medium | in-Revit tests on the Kelly test model |
| [KTRL5-68](https://linear.app/jhkelly/issue/KTRL5-68) | GetLevelsActiveFirst and DeleteElementTransaction: test the paths a te | 4 | medium | in-Revit tests on the Kelly test model |
| [KTRL5-69](https://linear.app/jhkelly/issue/KTRL5-69) | TagDistributor and MoveAndConnectTx: test the paths a sample cannot re | 4 | medium | in-Revit tests needing a view-aware test project |
| [KTRL5-70](https://linear.app/jhkelly/issue/KTRL5-70) | Layer moves of packages P4a to P4l: run the in-Revit tests and the six | 4 | medium | in-Revit run across P4a-P4l plus fixed P4c tests |
| [KTRL5-71](https://linear.app/jhkelly/issue/KTRL5-71) | Views and vocabulary moves: run the 2026-11-04 tests of package P4l | 2 | low | in-Revit run of existing tests, fixes may follow |
| [KTRL5-72](https://linear.app/jhkelly/issue/KTRL5-72) | Spool and support moves: run the 2026-11-04 tests of package P4k | 2 | low | in-Revit run of existing tests, fixes may follow |
| [KTRL5-73](https://linear.app/jhkelly/issue/KTRL5-73) | Layout point and signature moves: run the 2026-11-04 tests of package P | 2 | low | in-Revit run of existing tests, fixes may follow |
| [KTRL5-74](https://linear.app/jhkelly/issue/KTRL5-74) | Common definitions moves: run the 2026-11-04 tests of package P4i | 2 | low | in-Revit run of existing tests, fixes may follow |
| [KTRL5-75](https://linear.app/jhkelly/issue/KTRL5-75) | Collections and files moves: run the 2026-11-04 tests of package P4h | 4 | medium | in-Revit run plus fabrication-path tests |
| [KTRL5-76](https://linear.app/jhkelly/issue/KTRL5-76) | Support and updater moves: run the 2026-11-04 tests and cover the untes | 4 | medium | in-Revit run plus new tests for hanger branches |
| [KTRL5-77](https://linear.app/jhkelly/issue/KTRL5-77) | Spool transactions: run the 2026-11-04 tests and cover the untested pa | 4 | medium | in-Revit run plus new tests for untested paths |
| [KTRL5-78](https://linear.app/jhkelly/issue/KTRL5-78) | SizeElementDataModel: oval dimensions were documented as rounded, neve | 1 | medium | decision on rounding, small or no code |
| [KTRL5-79](https://linear.app/jhkelly/issue/KTRL5-79) | Verify JHK Product Range and Long Description are populated in all ITMs | 1 | high | conversation with two people, no code |
| [KTR5-4728](https://linear.app/jhkelly/issue/KTR5-4728) | Collections, Files, Xlsx and more: switch Kelly-Revit to the 6 moved m | 2 | low | switch callers to 6 moved members and delete copies, guard tests |
| [KTR5-4740](https://linear.app/jhkelly/issue/KTR5-4740) | Commands, Grids: switch Kelly-Revit to the 21 moved members and delete | 4 | low | switch callers to 21 moved members across Commands/Grids |
| [KTR5-4743](https://linear.app/jhkelly/issue/KTR5-4743) | Missing shared parameters dialog says the list was copied to the clipb | 1 | high | text fix or one clipboard call in one handler |
| [KTR5-4744](https://linear.app/jhkelly/issue/KTR5-4744) | Assigner adopt commands report Failed after adding a new value | 2 | medium | one command result fix in one type with test |
| [KTR5-4745](https://linear.app/jhkelly/issue/KTR5-4745) | Module Manager: the Show In View checkbox does nothing | 2 | high | one ViewModel honoring an existing checkbox binding, with test |
| [KTR5-4747](https://linear.app/jhkelly/issue/KTR5-4747) | ExcelInteropTools: FormatWorksheet and ImportTabDelimitedText have no | 2 | medium | tests for two Excel helpers and one private method |
| [KTR5-4748](https://linear.app/jhkelly/issue/KTR5-4748) | Three commands never check their window is ready before showing it | 2 | medium | add ValidateRequirements to three commands with tests |
| [KTR5-4749](https://linear.app/jhkelly/issue/KTR5-4749) | Module Creator view model tests repeat the Kelly.Domain numbering rule | 1 | medium | delete duplicated tests already covered in Kelly.Domain |

## KWD3

| Key | Title | Current | Proposed | Confidence | Reason |
|---|---|---|---|---|---|
| [KWD3-2](https://linear.app/jhkelly/issue/KWD3-2) | Rename JsonFileLoadException, the declared failure for every format, C | 8 | 16 | medium | rename JsonFileLoadException used in 32 files across layers; split |
| [KWD3-7](https://linear.app/jhkelly/issue/KWD3-7) | Decide ICache's fate (src/Caching/ICache.cs) | 4 | 2 | medium | ICache has no users; delete or add tests in one repo |
| [KWD3-10](https://linear.app/jhkelly/issue/KWD3-10) | Align the tests csproj configuration fallback with src | 1 | 1 | high | align one csproj fallback |

## KW3

| Key | Title | Current | Proposed | Confidence | Reason |
|---|---|---|---|---|---|
| [KW3-1](https://linear.app/jhkelly/issue/KW3-1) | Repoint the layers above to the helpers moved down in round 2 (#2 to # | - | 8 | medium | repoint layers above to 14 moved helpers, packs and repins up to Kelly-Revit |
| [KW3-2](https://linear.app/jhkelly/issue/KW3-2) | SpreadsheetColumns.FirstLetterToNumber reads only the first letter | 2 | 2 | medium | fix one method plus pinned tests |
| [KW3-4](https://linear.app/jhkelly/issue/KW3-4) | Improve the progress bar service (ProgressReporter, Kelly.Windows.Wpf) | 4 | 4 | low | thin text, ProgressReporter improvement, may touch callers |
| [KW3-5](https://linear.app/jhkelly/issue/KW3-5) | ServiceProvider.GetService returns arbitrary instance on duplicate conc | 2 | 2 | high | unify or document one method in ServiceProvider |
| [KW3-7](https://linear.app/jhkelly/issue/KW3-7) | Change Point3 to a struct | 8 | 8 | medium | class to struct: Point3 used in 42 files across layers |
| [KW3-8](https://linear.app/jhkelly/issue/KW3-8) | Are there any TODO notes that can be handled? | 1 | 1 | low | keep: evidence not clear enough to change (subagent proposed 2, low confidence) |
| [KW3-10](https://linear.app/jhkelly/issue/KW3-10) | ConvertFractionToDecimalFeet should use the guarded parse of TryParseDe | 2 | 2 | high | use guarded parse in one method plus tests |
| [KW3-11](https://linear.app/jhkelly/issue/KW3-11) | Decide whether TryParseDecimalFeet should stay lenient | 2 | 2 | medium | decide leniency, tighten one parser plus tests |
| [KW3-13](https://linear.app/jhkelly/issue/KW3-13) | Flake and brittleness risks in the test wave | 2 | 2 | high | loosen two brittle tests |
| [KW3-15](https://linear.app/jhkelly/issue/KW3-15) | ShellTools, ClipboardTools, UserPrincipalExtensions: add seams an | 4 | 4 | medium | three seams plus tests for 3 types in one repo |

## KW2

| Key | Title | Current | Proposed | Confidence | Reason |
|---|---|---|---|---|---|
| [KW2-1](https://linear.app/jhkelly/issue/KW2-1) | Are there any TODO notes that can be handled? | 1 | 1 | medium | two todo comments in a small repo |

## KD

| Key | Title | Current | Proposed | Confidence | Reason |
|---|---|---|---|---|---|
| [KD-1](https://linear.app/jhkelly/issue/KD-1) | Layout Point Export selection label miscounts and has a stray parenthe | 1 | 1 | high | fix label text in one method, update pinned tests |
| [KD-2](https://linear.app/jhkelly/issue/KD-2) | Layout Point Export dialog shows placeholder footer and expanded text | 1 | 1 | high | replace two placeholder strings and update pinned test |
| [KD-3](https://linear.app/jhkelly/issue/KD-3) | Layout point export and save length guards disagree | 2 | 2 | medium | align two length guards in one type plus tests |
| [KD-4](https://linear.app/jhkelly/issue/KD-4) | Hanger placement repeat fallback differs from the settings default | 1 | 1 | high | pick one constant, update pinned test |
| [KD-5](https://linear.app/jhkelly/issue/KD-5) | Do-not-number item number differs between the spool models | 2 | 2 | medium | decide and unify item number format in one type |
| [KD-6](https://linear.app/jhkelly/issue/KD-6) | JHK parameter name prefix checks compare differently | 4 | 4 | medium | unify prefix checks across Domain and Logic callers |
| [KD-7](https://linear.app/jhkelly/issue/KD-7) | Two signature rules for services and systems | 2 | 2 | medium | decide and unify two signature helpers, one repo |
| [KD-8](https://linear.app/jhkelly/issue/KD-8) | Point To Pipe settings reader stays open on an error | 2 | 2 | high | close reader and null guard in one type |
| [KD-9](https://linear.app/jhkelly/issue/KD-9) | Proposed Custom Data report does not quote its values | 1 | 1 | high | quote values in one report builder, test pinned |
| [KD-21](https://linear.app/jhkelly/issue/KD-21) | Layout point text is culture-sensitive and cannot round-trip | 2 | 2 | medium | invariant culture in one type (KTR is US-only, deferred) |
| [KD-22](https://linear.app/jhkelly/issue/KD-22) | Legacy layout point names that are not IDs decode to Empty without a r | 4 | 4 | low | legacy decode migration or report, behaviour decision |
| [KD-23](https://linear.app/jhkelly/issue/KD-23) | default(LayoutPoint).IsValid throws NRE and LayoutPoint is mutable | 4 | 2 | medium | null Description guard in one type; struct immutability may widen it |
| [KD-24](https://linear.app/jhkelly/issue/KD-24) | ModuleNumber.GetNextSequence proposes 0 for a too-large sequence | 1 | 1 | high | one overflow guard in ModuleNumber with pinned test |
| [KD-25](https://linear.app/jhkelly/issue/KD-25) | ModuleNumber.GetNextSequence wraps to int.MinValue after int.MaxValue | 1 | 1 | high | checked addition in one method |
| [KD-26](https://linear.app/jhkelly/issue/KD-26) | SpoolNumber.GetNextSequence wraps to int.MinValue after int.MaxValue | 1 | 1 | high | checked addition in one method |
| [KD-27](https://linear.app/jhkelly/issue/KD-27) | SpoolNumber.GetNextSequence matches names on their start, not on split | 2 | 2 | high | filter via TrySplitName in one method plus tests |
| [KD-30](https://linear.app/jhkelly/issue/KD-30) | Are there any TODO notes that can be handled? | 4 | 4 | medium | sweep of 11 todo comments incl. unverifiable bearer sizes |
| [KD-33](https://linear.app/jhkelly/issue/KD-33) | Tests pin display-only enums and property counts | 2 | 2 | high | loosen two tests in one repo |
| [KD-35](https://linear.app/jhkelly/issue/KD-35) | LayoutPointIdTests verification dates use the wrong date format | 1 | 1 | high | text change of dates in one test file |
| [KD-37](https://linear.app/jhkelly/issue/KD-37) | SupportTagNumbering.NextTag: find identical supports with an IEqualityC | 2 | 2 | medium | add overload with comparer in one type |
| [KD-38](https://linear.app/jhkelly/issue/KD-38) | Pipe offset geometry: points for lateral, vertical and rolling offsets | 4 | 4 | medium | new Revit-free geometry type with tests |
| [KD-45](https://linear.app/jhkelly/issue/KD-45) | ModuleComponentModel: integer Range on double columns lets 100.5 and 20 | - | 1 | high | change two Range attributes, tests already pin it |
| [KD-46](https://linear.app/jhkelly/issue/KD-46) | Support tags: pairing groups hashes case-sensitively, NextTag ignores c | - | 2 | medium | two small comparison fixes in one area plus tests |
| [KD-49](https://linear.app/jhkelly/issue/KD-49) | DuctDefinitionSet name is duct-specific but serves every fabrication p | - | 2 | medium | rename one type across Kelly-Domain; breaking for Trade.Duct callers |

## KTRL5

| Key | Title | Current | Proposed | Confidence | Reason |
|---|---|---|---|---|---|
| [KTRL5-2](https://linear.app/jhkelly/issue/KTRL5-2) | Move DataFileService to Kelly-Domain | 8 | 8 | medium | type move across layers with injection |
| [KTRL5-3](https://linear.app/jhkelly/issue/KTRL5-3) | Move the 66 remaining OperationService call sites to Run and Run<T> | - | - | high | parent (sub-issues KTRL5-30, 31, 33, 35) |
| [KTRL5-4](https://linear.app/jhkelly/issue/KTRL5-4) | Deprecation plans for Kelly-Revit-Logic-v5 | - | - | high | parent (sub-issue KTRL5-8) |
| [KTRL5-5](https://linear.app/jhkelly/issue/KTRL5-5) | Handle the open // todo notes in Kelly-Revit-Logic-v5 | - | - | high | parent (sub-issues KTRL5-24 to KTRL5-29) |
| [KTRL5-6](https://linear.app/jhkelly/issue/KTRL5-6) | PenetrationTagTools.CreateTag mixes invariant and current culture | 2 | 2 | medium | culture fix in one method, deferred |
| [KTRL5-7](https://linear.app/jhkelly/issue/KTRL5-7) | Test that SetWeldLocation leaves a matching JHK BOM Type alone | 4 | 4 | medium | needs in-Revit test and a way to see ParameterResultType |
| [KTRL5-8](https://linear.app/jhkelly/issue/KTRL5-8) | Deprecate the Component and Product updaters | 8 | 8 | high | keep (overrides subagent's "parent"): its only sub-issue KTRL5-79 is a prerequisite check, the deprecation work itself is still this issue |
| [KTRL5-24](https://linear.app/jhkelly/issue/KTRL5-24) | Updater element services: resolve the 23 "Implement Data Point" notes | 4 | 4 | medium | 13 services with 23 notes |
| [KTRL5-25](https://linear.app/jhkelly/issue/KTRL5-25) | Spool: write uniform line, spool, module number and group to the assem | 2 | 2 | medium | one file, 4 notes |
| [KTRL5-26](https://linear.app/jhkelly/issue/KTRL5-26) | Spools: type JhkTag as Tag, give IsSpoolAble a result, plan a LineNumb | 4 | 4 | medium | three typing changes in spool models |
| [KTRL5-27](https://linear.app/jhkelly/issue/KTRL5-27) | SuspendedSupport: settle the 6 notes on its shape and property notific | 2 | 2 | medium | one type with 6 notes |
| [KTRL5-28](https://linear.app/jhkelly/issue/KTRL5-28) | Service and System document caches: name and place them as data-store | 2 | 2 | medium | rename/move of three types |
| [KTRL5-29](https://linear.app/jhkelly/issue/KTRL5-29) | Size data model, annotation arranger, layout point recipe: last 5 notes | 2 | 2 | medium | 5 todo notes in 3 types |
| [KTRL5-30](https://linear.app/jhkelly/issue/KTRL5-30) | OperationService.Run: Elements, Families, Projects, Mep and Updaters s | 2 | 2 | medium | 9 sites, mechanical |
| [KTRL5-31](https://linear.app/jhkelly/issue/KTRL5-31) | OperationService.Run: Fabrication, Spools and Supports sites | 2 | 2 | medium | 7 sites, mechanical |
| [KTRL5-32](https://linear.app/jhkelly/issue/KTRL5-32) | VerticalSupportMemberComparer | 2 | 2 | high | one new comparer |
| [KTRL5-33](https://linear.app/jhkelly/issue/KTRL5-33) | OperationService.Run: Views, Layout Points and Arrangement sites | 2 | 2 | medium | 8 sites, mechanical |
| [KTRL5-34](https://linear.app/jhkelly/issue/KTRL5-34) | SuspendedSupportComparer: use it in GetNextTag and the signature-tag m | 4 | 4 | medium | new comparer used in two places |
| [KTRL5-35](https://linear.app/jhkelly/issue/KTRL5-35) | OperationService.Run: decide the 3 Logic sites that commit partial wor | 2 | 2 | medium | 3 sites with decision |
| [KTRL5-36](https://linear.app/jhkelly/issue/KTRL5-36) | FabricationPartGeometryComparer | 2 | 2 | high | one new comparer |
| [KTRL5-37](https://linear.app/jhkelly/issue/KTRL5-37) | Spool: nudge family instances 1/32" before AssemblyInstance.Create | 2 | 2 | high | one method in Spool |
| [KTRL5-38](https://linear.app/jhkelly/issue/KTRL5-38) | PhysicalElementEntity: report property errors through ModelBase | 4 | 4 | medium | base class change with validation |
| [KTRL5-39](https://linear.app/jhkelly/issue/KTRL5-39) | SuspendedSupport and VerticalSupportMember: validation rules for the e | 2 | 2 | medium | attributes on two types |
| [KTRL5-40](https://linear.app/jhkelly/issue/KTRL5-40) | OperationService: per-element loop helper that logs and skips a failed | 4 | 4 | medium | new OperationService helper plus tests |
| [KTRL5-41](https://linear.app/jhkelly/issue/KTRL5-41) | Per-element catch in the Logic change loops: Elements, Fabrication, Sp | 4 | 4 | medium | about 12 sites with their Run moves |
| [KTRL5-42](https://linear.app/jhkelly/issue/KTRL5-42) | Per-element catch in the other Logic change loops: Views, Documents, F | 4 | 4 | low | remaining sites across many folders, may be larger |
| [KTRL5-45](https://linear.app/jhkelly/issue/KTRL5-45) | Pipe offset: create the offset in an MEP pipe run | 4 | 4 | medium | one tool in src/Mep with in-Revit test |
| [KTRL5-46](https://linear.app/jhkelly/issue/KTRL5-46) | Pipe offset: create the offset in a fabrication part run | 4 | 4 | low | fabrication offset needs Kelly test project, could be 8 |
| [KTRL5-47](https://linear.app/jhkelly/issue/KTRL5-47) | Arrangement, Common, Connectors: move 12 members into Kelly-Revit-Logi | - | - | low | parent of source-package sub-issues, in Testing |
| [KTRL5-52](https://linear.app/jhkelly/issue/KTRL5-52) | Supports, Updaters, ElementDataModels and more: move 22 members into K | - | - | low | parent of source-package sub-issues, in Testing |
| [KTRL5-61](https://linear.app/jhkelly/issue/KTRL5-61) | BOM type write: Spool Manager and Module Manager write different value | - | 4 | medium | decision plus merging two overloads, in-Revit tests |
| [KTRL5-62](https://linear.app/jhkelly/issue/KTRL5-62) | Duct item numbers: Reset and Run Item Number Set clear them differentl | - | 4 | medium | decide one clear and fix two tools with in-Revit tests |
| [KTRL5-63](https://linear.app/jhkelly/issue/KTRL5-63) | AutoUpdaterService: NullReferenceException for an updater that was nev | - | 2 | high | one type fix with tests |
| [KTRL5-64](https://linear.app/jhkelly/issue/KTRL5-64) | GetCropBoxRotationAxis: NullReferenceException when the crop box has n | - | 2 | high | one-method null fix with a test |
| [KTRL5-65](https://linear.app/jhkelly/issue/KTRL5-65) | IsModelInstance: NullReferenceException for an element with no owner v | - | 2 | high | one-method null fix with a test |
| [KTRL5-66](https://linear.app/jhkelly/issue/KTRL5-66) | OletTapTools and PointToPipeTargets: test the fabrication paths the sa | - | 4 | medium | in-Revit tests on the Kelly fabrication project |
| [KTRL5-67](https://linear.app/jhkelly/issue/KTRL5-67) | GetPlaneOfPlanarFace and TrySetPartCustomDataValue: test the untested | - | 4 | medium | in-Revit tests on the Kelly test model |
| [KTRL5-68](https://linear.app/jhkelly/issue/KTRL5-68) | GetLevelsActiveFirst and DeleteElementTransaction: test the paths a te | - | 4 | medium | in-Revit tests on the Kelly test model |
| [KTRL5-69](https://linear.app/jhkelly/issue/KTRL5-69) | TagDistributor and MoveAndConnectTx: test the paths a sample cannot re | - | 4 | medium | in-Revit tests needing a view-aware test project |
| [KTRL5-70](https://linear.app/jhkelly/issue/KTRL5-70) | Layer moves of packages P4a to P4l: run the in-Revit tests and the six | - | 4 | medium | in-Revit run across P4a-P4l plus fixed P4c tests |
| [KTRL5-71](https://linear.app/jhkelly/issue/KTRL5-71) | Views and vocabulary moves: run the 2026-11-04 tests of package P4l | - | 2 | low | in-Revit run of existing tests, fixes may follow |
| [KTRL5-72](https://linear.app/jhkelly/issue/KTRL5-72) | Spool and support moves: run the 2026-11-04 tests of package P4k | - | 2 | low | in-Revit run of existing tests, fixes may follow |
| [KTRL5-73](https://linear.app/jhkelly/issue/KTRL5-73) | Layout point and signature moves: run the 2026-11-04 tests of package P | - | 2 | low | in-Revit run of existing tests, fixes may follow |
| [KTRL5-74](https://linear.app/jhkelly/issue/KTRL5-74) | Common definitions moves: run the 2026-11-04 tests of package P4i | - | 2 | low | in-Revit run of existing tests, fixes may follow |
| [KTRL5-75](https://linear.app/jhkelly/issue/KTRL5-75) | Collections and files moves: run the 2026-11-04 tests of package P4h | - | 4 | medium | in-Revit run plus fabrication-path tests |
| [KTRL5-76](https://linear.app/jhkelly/issue/KTRL5-76) | Support and updater moves: run the 2026-11-04 tests and cover the untes | - | 4 | medium | in-Revit run plus new tests for hanger branches |
| [KTRL5-77](https://linear.app/jhkelly/issue/KTRL5-77) | Spool transactions: run the 2026-11-04 tests and cover the untested pa | - | 4 | medium | in-Revit run plus new tests for untested paths |
| [KTRL5-78](https://linear.app/jhkelly/issue/KTRL5-78) | SizeElementDataModel: oval dimensions were documented as rounded, neve | - | 1 | medium | decision on rounding, small or no code |
| [KTRL5-79](https://linear.app/jhkelly/issue/KTRL5-79) | Verify JHK Product Range and Long Description are populated in all ITMs | - | 1 | high | conversation with two people, no code |

## KTRUI

| Key | Title | Current | Proposed | Confidence | Reason |
|---|---|---|---|---|---|
| [KTRUI-1](https://linear.app/jhkelly/issue/KTRUI-1) | Review the Kelly-Revit-UI controls for improvements | 4 | 4 | low | open-ended review of the Controls folder, thin text |
| [KTRUI-2](https://linear.app/jhkelly/issue/KTRUI-2) | Handle the open // todo notes in Kelly-Revit-UI | 4 | 1 | medium | only one todo comment left in the repo |
| [KTRUI-3](https://linear.app/jhkelly/issue/KTRUI-3) | Every build warns CS0419 six times on the ArgumentNullException cref | 1 | 1 | high | fix six cref attributes (docs only) |
| [KTRUI-10](https://linear.app/jhkelly/issue/KTRUI-10) | Tests for the 16 untested Kelly-Revit-UI types | 4 | 4 | medium | tests for 16 types, UIDocument limits |

## KTR5

| Key | Title | Current | Proposed | Confidence | Reason |
|---|---|---|---|---|---|
| [KTR5-2434](https://linear.app/jhkelly/issue/KTR5-2434) | Shared parameters: deprecate the extraneous weld tag parameters | 4 | 4 | medium | deprecate four parameters across code and data files |
| [KTR5-2461](https://linear.app/jhkelly/issue/KTR5-2461) | Definitions: remove the "I" suffix from definition names in the data files | 8 | 8 | medium | rename across data files, exporter and readers in several repos |
| [KTR5-2775](https://linear.app/jhkelly/issue/KTR5-2775) | Layout Point Import: check the point families when the window opens | 2 | 2 | high | one pre-check in one view model |
| [KTR5-2958](https://linear.app/jhkelly/issue/KTR5-2958) | Module Manager: work on sheet metal (duct) projects | 8 | 8 | medium | duct support across Manager grids and logic |
| [KTR5-2967](https://linear.app/jhkelly/issue/KTR5-2967) | Validation: move tools that validate through IValueConverters to property | 8 | 8 | medium | several tools moved off converters |
| [KTR5-3142](https://linear.app/jhkelly/issue/KTR5-3142) | Auto Updaters: they sometimes stop working during a session | 4 | 4 | low | cause unknown, needs in-Revit investigation |
| [KTR5-3144](https://linear.app/jhkelly/issue/KTR5-3144) | Spool Creator V1: nudge family instances so assembly creation doesn't fail | - | - | high | parent (open sub-issues KTR5-4699, KTR5-4701); subagent proposed 2 |
| [KTR5-3277](https://linear.app/jhkelly/issue/KTR5-3277) | Suspended Support Manager: Match column shows true when nothing matches | 2 | 2 | medium | one property bug, repro needed |
| [KTR5-3278](https://linear.app/jhkelly/issue/KTR5-3278) | Suspended Support Manager: handle every fabrication support pattern | 8 | 8 | low | every support pattern, scope open |
| [KTR5-3279](https://linear.app/jhkelly/issue/KTR5-3279) | Suspended Support Manager: row validation like the Module Manager's | - | - | high | parent (open sub-issue KTR5-4702); subagent proposed 4 |
| [KTR5-3280](https://linear.app/jhkelly/issue/KTR5-3280) | Suspended Support Manager: rebuild how rod geometry values are read and wr | 8 | 8 | medium | rebuild rod get/set path in Logic and manager with tests |
| [KTR5-3281](https://linear.app/jhkelly/issue/KTR5-3281) | Suspended Support Manager: use the shared Scope control instead of its rad | 2 | 2 | high | swap radio buttons for the shared Scope control |
| [KTR5-3680](https://linear.app/jhkelly/issue/KTR5-3680) | Suspended Support Manager: trapeze too wide (needs investigation) | 2 | 2 | low | vague bug, investigation first |
| [KTR5-3695](https://linear.app/jhkelly/issue/KTR5-3695) | Unused Shared Parameter Element Delete: tests for the tool and what it cal | 4 | 4 | medium | in-Revit tests for a tool and its callees |
| [KTR5-3703](https://linear.app/jhkelly/issue/KTR5-3703) | Manual Updater: disable Close until the update finishes | 4 | 4 | low | shared footer control change plus Manual Updater |
| [KTR5-3747](https://linear.app/jhkelly/issue/KTR5-3747) | Spool Manager: warn detailers when any grid has an error (red) row | 4 | 4 | medium | error counts per grid and jump-to-row |
| [KTR5-3772](https://linear.app/jhkelly/issue/KTR5-3772) | View Schedule Excel export (single file): use Telerik's exporter instead o | 4 | 4 | medium | one export command replacing COM Excel |
| [KTR5-3773](https://linear.app/jhkelly/issue/KTR5-3773) | View Schedule Excel export (multiple files): use Telerik's exporter instead | 4 | 4 | medium | one export command replacing COM Excel |
| [KTR5-3774](https://linear.app/jhkelly/issue/KTR5-3774) | View Schedule CSV export: use Telerik's exporter | 4 | 4 | medium | one export command moved to Telerik |
| [KTR5-3784](https://linear.app/jhkelly/issue/KTR5-3784) | Vicious Fabrication Hanger Place: keep the window open between placements | 4 | 4 | medium | make window modeless with external event |
| [KTR5-3785](https://linear.app/jhkelly/issue/KTR5-3785) | Vicious Fabrication Hanger Place: also place family-based hangers | 4 | 4 | medium | second placement path for family hangers in one tool |
| [KTR5-3786](https://linear.app/jhkelly/issue/KTR5-3786) | Vicious Instance Level Assign: list the elements whose level could not cha | 4 | 4 | medium | collect and report unchanged levels, in-Revit test |
| [KTR5-3791](https://linear.app/jhkelly/issue/KTR5-3791) | Module Manager: change the Module Number without leaving the tool | 4 | 4 | medium | one editable column with write-back and tests |
| [KTR5-3792](https://linear.app/jhkelly/issue/KTR5-3792) | Module Manager: change the Module Group without leaving the tool | 4 | 4 | medium | one editable column with write-back and tests |
| [KTR5-3793](https://linear.app/jhkelly/issue/KTR5-3793) | Module Creator: stay open to create module after module | 4 | 4 | medium | make window modeless with external event |
| [KTR5-3794](https://linear.app/jhkelly/issue/KTR5-3794) | Module Creator: optionally create the module's views, filters and sheet | 8 | 8 | medium | view, filter and sheet creation across Logic and tool |
| [KTR5-3795](https://linear.app/jhkelly/issue/KTR5-3795) | Spool Manager: update the Line Number of every member of the selected spo | 4 | 4 | medium | one write-through action in Spool Manager with tests |
| [KTR5-3796](https://linear.app/jhkelly/issue/KTR5-3796) | Spool Manager: update the Detailing Package of every member of the selecte | 4 | 4 | medium | one write-through action in Spool Manager with tests |
| [KTR5-3797](https://linear.app/jhkelly/issue/KTR5-3797) | Spool Manager: update the Spool Number (Assembly Name) of every member of | 4 | 4 | medium | assembly rename plus members, in-Revit test |
| [KTR5-3800](https://linear.app/jhkelly/issue/KTR5-3800) | Spool Creator V2: create spools from the assigner contexts, with no window | 0 | 0 | high | parent; keeps its 0 (clearing it needs your say-so) |
| [KTR5-3808](https://linear.app/jhkelly/issue/KTR5-3808) | Layout Point Export: select and zoom to a row's element like the other too | 4 | 4 | medium | add Select/Zoom control to a grid, view model and tests |
| [KTR5-3809](https://linear.app/jhkelly/issue/KTR5-3809) | Layout Point Export: show the point counts in the Scope options | 4 | 4 | medium | scope counts in the shared control for one tool |
| [KTR5-3810](https://linear.app/jhkelly/issue/KTR5-3810) | Auto Updaters: agree each updater's configuration with Jason and Adam | 4 | 4 | low | meeting plus written config decisions |
| [KTR5-3811](https://linear.app/jhkelly/issue/KTR5-3811) | Manual Updater: agree each updater's configuration with Jason and Adam | 4 | 4 | low | meeting plus written config decisions |
| [KTR5-3813](https://linear.app/jhkelly/issue/KTR5-3813) | Manual Updater: show a success/fail list after it runs | 4 | 4 | medium | result list window for one command |
| [KTR5-3827](https://linear.app/jhkelly/issue/KTR5-3827) | Pipe Offset Create: make lateral, vertical and rolling offsets in one step | - | - | high | parent (open sub-issues KTR5-4719, KD-38); subagent proposed 8 |
| [KTR5-3829](https://linear.app/jhkelly/issue/KTR5-3829) | Family Instance End Swap: swap connected family instances like fabricatio | 8 | 8 | medium | new tool with Revit connector logic, in-Revit tests |
| [KTR5-3831](https://linear.app/jhkelly/issue/KTR5-3831) | XAML: debounce EventToCommand calls | 8 | 8 | low | debounce across shared behavior and many views |
| [KTR5-3833](https://linear.app/jhkelly/issue/KTR5-3833) | Scope control: filter the consuming grid instead of building an intermedia | 8 | 8 | medium | shared Scope control change touching every consuming view model |
| [KTR5-3839](https://linear.app/jhkelly/issue/KTR5-3839) | Valve Tag Assign: plan the new tool with Jason and Adam | 4 | 4 | low | planning meeting then build issues; thin text |
| [KTR5-3911](https://linear.app/jhkelly/issue/KTR5-3911) | Trapeze placement: extend the rods to the structure automatically | 4 | 4 | medium | one tool end to end, reuses rod extend logic |
| [KTR5-3924](https://linear.app/jhkelly/issue/KTR5-3924) | Spool Creator: remember the selected Detailing Package between creations | 2 | 2 | high | remember one combo box value in one view model |
| [KTR5-3932](https://linear.app/jhkelly/issue/KTR5-3932) | Spool Creator V2: user interface | 4 | 4 | medium | user interface for one tool |
| [KTR5-3933](https://linear.app/jhkelly/issue/KTR5-3933) | Spool Creator V2: logic | 8 | 8 | medium | spool creation logic, Revit transactions and tests |
| [KTR5-3934](https://linear.app/jhkelly/issue/KTR5-3934) | Spool Creator V2: tests | 4 | 4 | medium | tests for several types, in-Revit |
| [KTR5-3935](https://linear.app/jhkelly/issue/KTR5-3935) | Spool Creator V2: remaining work (docs, release notes, retire V1?) | 2 | 2 | medium | docs and release notes, retire V1 decision |
| [KTR5-3936](https://linear.app/jhkelly/issue/KTR5-3936) | CSV writing: replace CsvHelper | 8 | 8 | medium | replace CsvHelper in v5, writer plus all call sites |
| [KTR5-3937](https://linear.app/jhkelly/issue/KTR5-3937) | BIM Lite: ask Jason and Adam whether it is still wanted | 1 | 1 | high | ask a question, no code |
| [KTR5-3938](https://linear.app/jhkelly/issue/KTR5-3938) | Assigners: Inherit All copies a picked element's contexts into the assigne | 4 | 4 | medium | one new command reading a picked element's contexts |
| [KTR5-4003](https://linear.app/jhkelly/issue/KTR5-4003) | System document cache: HashSet instead of List | 1 | 1 | high | List to HashSet in one cache |
| [KTR5-4004](https://linear.app/jhkelly/issue/KTR5-4004) | Service document cache: HashSet instead of List | 1 | 1 | high | List to HashSet in one cache |
| [KTR5-4009](https://linear.app/jhkelly/issue/KTR5-4009) | Select Elements By Context: select everything with the current System, Ser | 4 | 4 | medium | one new command over the context lookup |
| [KTR5-4015](https://linear.app/jhkelly/issue/KTR5-4015) | Module Manager: show or hide the Line Number column in every grid | 1 | 1 | high | one check box toggling a column |
| [KTR5-4016](https://linear.app/jhkelly/issue/KTR5-4016) | Module Manager: show or hide the Detailing Package column in every grid | 1 | 1 | high | one check box toggling a column |
| [KTR5-4017](https://linear.app/jhkelly/issue/KTR5-4017) | Element Select Zoom: Select In View check box raises Checked/Unchecked eve | 1 | 1 | high | routed events on one user control |
| [KTR5-4018](https://linear.app/jhkelly/issue/KTR5-4018) | Element Select Zoom: Zoom To Selection check box raises Checked/Unchecked | 1 | 1 | high | routed events on one user control |
| [KTR5-4019](https://linear.app/jhkelly/issue/KTR5-4019) | Element Select Zoom: remove EventToCommandBehavior from Select In View and | 2 | 2 | high | remove behavior in one control and its views |
| [KTR5-4020](https://linear.app/jhkelly/issue/KTR5-4020) | Element Select Zoom: remove EventToCommandBehavior from Zoom To Selection | 2 | 2 | high | remove behavior in one control and its views |
| [KTR5-4024](https://linear.app/jhkelly/issue/KTR5-4024) | Assigners: one button resets every assigner | 4 | 4 | medium | one command resetting four assigners and switches |
| [KTR5-4028](https://linear.app/jhkelly/issue/KTR5-4028) | Stratus Detailing Package 3D View: a dialog to choose base view, prefix an | 8 | 8 | low | new dialog and view model on top of existing tool |
| [KTR5-4029](https://linear.app/jhkelly/issue/KTR5-4029) | 3D Detailer Views: create a VDC 3D view per VDC package | 8 | 8 | medium | new tool creating views per VDC package with filters |
| [KTR5-4040](https://linear.app/jhkelly/issue/KTR5-4040) | Arrange Instance Align Move: limit the categories it can move | 2 | 2 | high | category guard in two commands |
| [KTR5-4042](https://linear.app/jhkelly/issue/KTR5-4042) | Vicious Straights Racker: one fabrication duct shape's size can't be read | 1 | 1 | low | repro first, one shape size read |
| [KTR5-4043](https://linear.app/jhkelly/issue/KTR5-4043) | Vicious Instance Rotate Move: window crops its controls | 1 | 1 | high | window sizing fix |
| [KTR5-4063](https://linear.app/jhkelly/issue/KTR5-4063) | Suspended Support Manager: filter the grid by Element Id | 2 | 2 | high | one grid filter in one view model |
| [KTR5-4064](https://linear.app/jhkelly/issue/KTR5-4064) | Assigners: refuse to turn on an auto-assigner while its value is the defau | 2 | 2 | high | one switch/command guard in one type |
| [KTR5-4077](https://linear.app/jhkelly/issue/KTR5-4077) | Auto Updaters: review meetings on each updater and the services it calls | 1 | 1 | medium | series of meetings, no code |
| [KTR5-4085](https://linear.app/jhkelly/issue/KTR5-4085) | Assigners: dockable assigner panel | 2 | 2 | low | dockable pane for the assigners, UI only |
| [KTR5-4110](https://linear.app/jhkelly/issue/KTR5-4110) | Kelly-Windows: remove the ObjectsComparer dependency (abandoned library) | 2 | 2 | high | replace one small helper type and package |
| [KTR5-4119](https://linear.app/jhkelly/issue/KTR5-4119) | Duct QA Length: suggest straight lengths that cut waste | - | - | high | parent |
| [KTR5-4120](https://linear.app/jhkelly/issue/KTR5-4120) | Duct QA Mirror: find mirrored or handed fittings | - | - | high | parent |
| [KTR5-4121](https://linear.app/jhkelly/issue/KTR5-4121) | Duct QA Mirror: port the Hill Group Visual Basic mirror check to C# | 8 | 8 | medium | port VB logic to Logic and Domain with tests |
| [KTR5-4122](https://linear.app/jhkelly/issue/KTR5-4122) | Duct QA Mirror: view | 4 | 4 | medium | one window with Scope control and grid |
| [KTR5-4123](https://linear.app/jhkelly/issue/KTR5-4123) | Duct QA Mirror: view model | 4 | 4 | medium | view model running the check |
| [KTR5-4124](https://linear.app/jhkelly/issue/KTR5-4124) | Duct QA Mirror: model(s) | 2 | 2 | medium | model row types |
| [KTR5-4125](https://linear.app/jhkelly/issue/KTR5-4125) | Duct QA Length: model(s) | 2 | 2 | medium | model row types |
| [KTR5-4126](https://linear.app/jhkelly/issue/KTR5-4126) | Duct QA Length: view model | 4 | 4 | medium | view model running the check |
| [KTR5-4127](https://linear.app/jhkelly/issue/KTR5-4127) | Duct QA Length: view | 4 | 4 | medium | one window with Scope control and grid |
| [KTR5-4128](https://linear.app/jhkelly/issue/KTR5-4128) | Duct QA Length: port the Hill Group Visual Basic length logic to C# | 8 | 8 | medium | port VB logic to Logic and Domain with tests per rule |
| [KTR5-4136](https://linear.app/jhkelly/issue/KTR5-4136) | OperationService: email the logs to Chris Hildebran at every document | 8 | 8 | medium | new email service hooked to document close |
| [KTR5-4170](https://linear.app/jhkelly/issue/KTR5-4170) | Signatures: compare parts with an IEqualityComparer instead of the geomet | - | - | high | parent (open sub-issues KTR5-4697, KD-37); subagent proposed 8 |
| [KTR5-4174](https://linear.app/jhkelly/issue/KTR5-4174) | Welds: write the joined parts' material type and wall thickness to the | 4 | 4 | medium | one updater writing two weld values with tests |
| [KTR5-4175](https://linear.app/jhkelly/issue/KTR5-4175) | Code style: initialize collections where they are declared, not in con | 8 | 8 | medium | style sweep over many files in all v5 repos, no behavior change |
| [KTR5-4177](https://linear.app/jhkelly/issue/KTR5-4177) | About window: status lists of services, data files, commands and updat | 8 | 8 | medium | new status lists across services, data files, commands, updaters |
| [KTR5-4253](https://linear.app/jhkelly/issue/KTR5-4253) | Layout Point Import: list CSV rows missing layer or required data before i | 4 | 4 | medium | CSV row check and list in one tool |
| [KTR5-4255](https://linear.app/jhkelly/issue/KTR5-4255) | Content cleanup: find fabrication parts whose ITM is gone from the fab | 8 | 8 | medium | new report tool querying the fabrication database, grid and tests |
| [KTR5-4256](https://linear.app/jhkelly/issue/KTR5-4256) | Content cleanup: remove unused or deprecated JHK shared parameters fro | 8 | 8 | medium | new cleanup tool with UI, logging, transaction, tests |
| [KTR5-4322](https://linear.app/jhkelly/issue/KTR5-4322) | XAML views: one command per Click instead of several EventBindings | 8 | 8 | medium | sweep over all XAML views replacing stacked EventBindings |
| [KTR5-4448](https://linear.app/jhkelly/issue/KTR5-4448) | Vicious Straights Racker: inaccurate move aligning top of pipe to a tr | 2 | 2 | low | reproduce first; likely one elevation calc fix in Racker |
| [KTR5-4478](https://linear.app/jhkelly/issue/KTR5-4478) | KTR-3D view: do less on document open | 2 | 2 | medium | one event handler change plus on-demand reset; in Testing |
| [KTR5-4480](https://linear.app/jhkelly/issue/KTR5-4480) | OperationService: catch errors per element inside the change loops | - | - | high | parent |
| [KTR5-4493](https://linear.app/jhkelly/issue/KTR5-4493) | Claude Code: try Nice3point's revit-skills in the Kelly repositories | 2 | 2 | medium | evaluate external skills, docs-only |
| [KTR5-4494](https://linear.app/jhkelly/issue/KTR5-4494) | IUpdaters: analyze what each updater needs (triggers, parameters, data | 4 | 4 | medium | read-only inventory of all IUpdaters across code |
| [KTR5-4496](https://linear.app/jhkelly/issue/KTR5-4496) | Family Version tool: fails when a nested family has the version shared | 4 | 4 | medium | one tool, nested-family bind logic plus tests |
| [KTR5-4510](https://linear.app/jhkelly/issue/KTR5-4510) | VCS-Database-General-Schema: deprecate the ProjectSession table | 1 | 1 | high | mark one table deprecated plus changelog |
| [KTR5-4513](https://linear.app/jhkelly/issue/KTR5-4513) | VCS-Database-General-Schema: deprecate USP_ProjectSession_Insert | 1 | 1 | high | mark one procedure deprecated plus changelog |
| [KTR5-4514](https://linear.app/jhkelly/issue/KTR5-4514) | VCS-Database-General-Schema: deprecate USP_ProjectSession_Update | 1 | 1 | high | mark one procedure deprecated plus changelog |
| [KTR5-4515](https://linear.app/jhkelly/issue/KTR5-4515) | VCS-Database-General-Schema: deprecate the ProjectUpdatersLog table | 1 | 1 | high | mark one schema object deprecated plus changelog |
| [KTR5-4517](https://linear.app/jhkelly/issue/KTR5-4517) | Delete - Dead Code From All Repositories | - | - | high | parent |
| [KTR5-4518](https://linear.app/jhkelly/issue/KTR5-4518) | Delete - Dead Code From Kelly.Revit | 1 | 1 | low | delete dead code in one layer, description empty |
| [KTR5-4519](https://linear.app/jhkelly/issue/KTR5-4519) | Delete - Dead Code From Kelly.REvit.Logic | 1 | 1 | low | delete dead code in one layer, description empty |
| [KTR5-4520](https://linear.app/jhkelly/issue/KTR5-4520) | Delete - Dead Code From Kelly.Windows | 1 | 1 | low | delete dead code in one layer, description empty |
| [KTR5-4521](https://linear.app/jhkelly/issue/KTR5-4521) | Delete - Dead Code From Kelly.Windows.Data | 1 | 1 | low | delete dead code in one layer, description empty |
| [KTR5-4525](https://linear.app/jhkelly/issue/KTR5-4525) | Element services: keep the updater element services out of command use | 8 | 8 | medium | split updater element services from command use across layers |
| [KTR5-4581](https://linear.app/jhkelly/issue/KTR5-4581) | Tool to recover OperationService logs (.json, .jsonl) | 8 | 8 | low | new recovery tool, thin text |
| [KTR5-4582](https://linear.app/jhkelly/issue/KTR5-4582) | Refactor the application services if needed | 4 | 4 | low | vague refactor, thin text |
| [KTR5-4596](https://linear.app/jhkelly/issue/KTR5-4596) | Implement a hierarchical application and tool settings file | - | - | high | parent |
| [KTR5-4597](https://linear.app/jhkelly/issue/KTR5-4597) | Is there any other file data I/O that Kelly.Windows.Data.* can handle? | 2 | 2 | low | investigation of other file I/O, thin text |
| [KTR5-4601](https://linear.app/jhkelly/issue/KTR5-4601) | Configure the InstallShield project for different install types | - | - | high | parent |
| [KTR5-4602](https://linear.app/jhkelly/issue/KTR5-4602) | Read and write the settings file with Kelly.Windows.Data.Json | 8 | 8 | medium | Json library wired to settings file across layers |
| [KTR5-4604](https://linear.app/jhkelly/issue/KTR5-4604) | Mark the SQL procedures only v5 called (step 9 of the plan) | 2 | 2 | high | parent of open sub-issues 4510, 4513-4515; keeps its 2 (clearing needs your say-so) |
| [KTR5-4608](https://linear.app/jhkelly/issue/KTR5-4608) | Detailer | 2 | 2 | low | installer config, title only |
| [KTR5-4609](https://linear.app/jhkelly/issue/KTR5-4609) | Manager | 2 | 2 | low | installer config, title only |
| [KTR5-4610](https://linear.app/jhkelly/issue/KTR5-4610) | Contenter | 2 | 2 | low | installer config, title only |
| [KTR5-4618](https://linear.app/jhkelly/issue/KTR5-4618) | Enable the ProjectInformationEditor for project shared parameters | 8 | 8 | medium | re-enable an editor module with data binding and tests |
| [KTR5-4621](https://linear.app/jhkelly/issue/KTR5-4621) | Enable light and dark mode for the versions of Revit that have that fe | - | - | high | parent |
| [KTR5-4623](https://linear.app/jhkelly/issue/KTR5-4623) | Light-mode and dark-mode icons (use the proper green color) | 8 | 8 | medium | new light/dark icon sets for every ribbon button |
| [KTR5-4624](https://linear.app/jhkelly/issue/KTR5-4624) | Suspended Support Manager: show vertical members in a separate grid be | 4 | 4 | medium | new grid in view and ViewModel for one tool |
| [KTR5-4625](https://linear.app/jhkelly/issue/KTR5-4625) | Implement the scope control in every window that doesn't have it yet | 8 | 8 | medium | scope control added to every window lacking it |
| [KTR5-4626](https://linear.app/jhkelly/issue/KTR5-4626) | Order the User Domain Report (Developer tab) by EmployeeId | 4 | 8 | low | needs sort and EmployeeId read in Kelly-Windows-v3 repinned to add-in |
| [KTR5-4627](https://linear.app/jhkelly/issue/KTR5-4627) | Use the other JH Kelly brand colors beside Kelly Green | - | - | high | parent |
| [KTR5-4630](https://linear.app/jhkelly/issue/KTR5-4630) | Take all push button names from a names property | 8 | 8 | medium | sweep of 50 push buttons to property names |
| [KTR5-4631](https://linear.app/jhkelly/issue/KTR5-4631) | Racker: Bottom/Top align buttons overwrite the typed elevation in Manu | 1 | 1 | high | stop passing list in Manual mode, one XAML/ViewModel spot |
| [KTR5-4632](https://linear.app/jhkelly/issue/KTR5-4632) | Add the brand colors once as named colors, brushes and resources | 8 | 8 | medium | new palette in Windows-v3 and resources in Revit-UI, repinned |
| [KTR5-4633](https://linear.app/jhkelly/issue/KTR5-4633) | Replace the off-palette colors in the views and panels | 2 | 2 | medium | replace four colors in views |
| [KTR5-4634](https://linear.app/jhkelly/issue/KTR5-4634) | Decide the status colors beside the brand palette | 4 | 4 | medium | decision plus several color types in Windows-v3 |
| [KTR5-4635](https://linear.app/jhkelly/issue/KTR5-4635) | Layout Point Export: Data Filter drops hidden saved points on save | 2 | 2 | medium | save from full point set not filtered, one ViewModel |
| [KTR5-4636](https://linear.app/jhkelly/issue/KTR5-4636) | Layout Point Import: Specify Level always fails with an unhandled erro | 2 | 2 | high | binding type fix in one ViewModel/view |
| [KTR5-4637](https://linear.app/jhkelly/issue/KTR5-4637) | Spool Manager: a failed edit commits partial changes and closes the to | 4 | 4 | medium | partial-commit handling across several Spool Manager edits |
| [KTR5-4638](https://linear.app/jhkelly/issue/KTR5-4638) | Layout Point Export: cancelling the check or Save As still rewrites ho | 4 | 4 | medium | reorder save/check/Save As flow and cancel handling |
| [KTR5-4639](https://linear.app/jhkelly/issue/KTR5-4639) | Layout Point Export: Save with no valid point shows the exception prom | 2 | 2 | high | one ViewModel message path with test |
| [KTR5-4640](https://linear.app/jhkelly/issue/KTR5-4640) | Layout Point Export: Exported and Not Valid filters name missing membe | 2 | 2 | high | fix filter member names in one ViewModel plus count label |
| [KTR5-4641](https://linear.app/jhkelly/issue/KTR5-4641) | Layout Point Export: tool will not open when the plan has no hangers | 2 | 2 | medium | one ViewModel open-path guard with test |
| [KTR5-4642](https://linear.app/jhkelly/issue/KTR5-4642) | Layout Point Import: missing point families throw a NullReferenceExcep | 2 | 2 | high | null guard in one ViewModel with test |
| [KTR5-4643](https://linear.app/jhkelly/issue/KTR5-4643) | Olet Check: Re-Connect and Select act on the wrong project with two op | 4 | 4 | medium | document-scope handling across dialog actions, in-Revit test |
| [KTR5-4644](https://linear.app/jhkelly/issue/KTR5-4644) | Point to Pipe: a typed or pasted Point File path is ignored | 2 | 2 | high | read typed path in one view code-behind |
| [KTR5-4645](https://linear.app/jhkelly/issue/KTR5-4645) | Point to Pipe: units boxes always start at Inches and Feet | 4 | 4 | medium | settings assignment plus metric defaults across view and settings |
| [KTR5-4646](https://linear.app/jhkelly/issue/KTR5-4646) | Spool Manager: will not open without a Spool title block type | 2 | 2 | high | defer title block lookup in one ViewModel |
| [KTR5-4647](https://linear.app/jhkelly/issue/KTR5-4647) | Suspended Support Manager: Override Size Set clears tags without a siz | 2 | 2 | high | one ViewModel bug with test |
| [KTR5-4648](https://linear.app/jhkelly/issue/KTR5-4648) | Suspended Support Manager: Tagging Set tags un-hosted hangers when dis | 2 | 2 | high | skip condition fix in one ViewModel with test |
| [KTR5-4649](https://linear.app/jhkelly/issue/KTR5-4649) | Layout Point Export: save clears the Revit selection and empties the g | 2 | 2 | medium | preserve selection around save in one ViewModel |
| [KTR5-4650](https://linear.app/jhkelly/issue/KTR5-4650) | Layout Point Export: export window stays always on top | 1 | 1 | high | reset Topmost flag in one place |
| [KTR5-4651](https://linear.app/jhkelly/issue/KTR5-4651) | Layout Point Export: quality dialog shows placeholder text | 2 | 2 | high | replace placeholder strings in one ViewModel |
| [KTR5-4652](https://linear.app/jhkelly/issue/KTR5-4652) | Layout Point Export: Danger and Caution quality counts never fire | 8 | 8 | medium | implement quality check in Logic then repin up to add-in |
| [KTR5-4653](https://linear.app/jhkelly/issue/KTR5-4653) | Level Correct: an element with no category throws NullReferenceExcepti | 1 | 1 | high | null guard on category in one command |
| [KTR5-4654](https://linear.app/jhkelly/issue/KTR5-4654) | Level Correct: no model elements gives a raw List must contain error | 2 | 2 | high | selection check and message in one command |
| [KTR5-4655](https://linear.app/jhkelly/issue/KTR5-4655) | Line Number Selector: Add Context Value check box label is run togethe | 1 | 1 | high | label text and width fix |
| [KTR5-4656](https://linear.app/jhkelly/issue/KTR5-4656) | Module Creator: DEFAULT placeholder prefix shown in an empty project | 2 | 2 | high | one ViewModel bug with test |
| [KTR5-4657](https://linear.app/jhkelly/issue/KTR5-4657) | Module Manager: Item Numbers Update button stays disabled after BOM up | 2 | 2 | high | one view/ViewModel bug with test |
| [KTR5-4658](https://linear.app/jhkelly/issue/KTR5-4658) | Module Manager: Components grid shows item numbers that were not saved | 2 | 2 | high | one ViewModel bug with test |
| [KTR5-4659](https://linear.app/jhkelly/issue/KTR5-4659) | Olet Check: Select links keep stale enabled state after a reload | 1 | 1 | high | raise CanExecute after reload in one ViewModel |
| [KTR5-4660](https://linear.app/jhkelly/issue/KTR5-4660) | Olet Check: opening the dialog checks the olets twice | 1 | 1 | high | remove duplicate reload in constructor |
| [KTR5-4661](https://linear.app/jhkelly/issue/KTR5-4661) | Racker: user cancel ends the command as Failed instead of Cancelled | 4 | 2 | low | result code change in one command, though several exit paths |
| [KTR5-4662](https://linear.app/jhkelly/issue/KTR5-4662) | Racker: will not open when a Straights item has no level | 2 | 2 | high | null level guard in one ViewModel |
| [KTR5-4663](https://linear.app/jhkelly/issue/KTR5-4663) | Spool Creator: SPA and SPT categories do not parse as spool numbers | 8 | 8 | medium | SpoolNumber parse change in lower layer repinned up to add-in |
| [KTR5-4664](https://linear.app/jhkelly/issue/KTR5-4664) | Spool Creator: one Create is three Undo steps | 2 | 2 | high | wrap steps in one transaction group in one ViewModel |
| [KTR5-4665](https://linear.app/jhkelly/issue/KTR5-4665) | Spool Manager: grids keep new values after Revit rolls an edit back | 2 | 2 | medium | refresh grids after rollback in one ViewModel |
| [KTR5-4666](https://linear.app/jhkelly/issue/KTR5-4666) | Suspended Support Manager: Set Extensions on unattached hangers extend | 2 | 2 | medium | one type, extend rod logic plus message and test |
| [KTR5-4667](https://linear.app/jhkelly/issue/KTR5-4667) | Suspended Support Manager: field trim stored in inches, not feet | 1 | 1 | high | unit conversion fix in one place |
| [KTR5-4668](https://linear.app/jhkelly/issue/KTR5-4668) | Windows Mockup: product-code list goes blank after a scope change | 1 | 1 | high | raise change notification or replace collection in one ViewModel |
| [KTR5-4678](https://linear.app/jhkelly/issue/KTR5-4678) | Refactor and clean up the Vicious tools | - | - | high | parent |
| [KTR5-4680](https://linear.app/jhkelly/issue/KTR5-4680) | Are there any TODO notes that can be handled? | 8 | 8 | medium | 54 todos in the repo, a sweep over many files |
| [KTR5-4681](https://linear.app/jhkelly/issue/KTR5-4681) | Deduplicate the SetActiveProjectLocation combo code in two ViewModels | 2 | 2 | high | extract shared combo code from two ViewModels |
| [KTR5-4682](https://linear.app/jhkelly/issue/KTR5-4682) | Point to Pipe: use the PointToPipeUnits constants instead of unit lite | 1 | 1 | high | replace literals with existing constants |
| [KTR5-4685](https://linear.app/jhkelly/issue/KTR5-4685) | Rename debris and config drift | 2 | 2 | medium | config value alignment and stale file cleanup |
| [KTR5-4689](https://linear.app/jhkelly/issue/KTR5-4689) | Implement the Unit Test Implementation plan for Kelly Tools For Revit | - | - | high | parent |
| [KTR5-4693](https://linear.app/jhkelly/issue/KTR5-4693) | Final test: KTR needs to work without connecting to a JHK network (no | 4 | 4 | low | offline end-to-end check, may expose several faults |
| [KTR5-4694](https://linear.app/jhkelly/issue/KTR5-4694) | Run the tooltip and icon commits inside Revit | 2 | 2 | medium | one in-Revit test run plus ribbon spot-check |
| [KTR5-4696](https://linear.app/jhkelly/issue/KTR5-4696) | OperationService.Run: assigner filter, Duct, Manager and Rotate Move c | 4 | 4 | low | 12 Start/Stop sites in commands moved to Run, maybe larger |
| [KTR5-4697](https://linear.app/jhkelly/issue/KTR5-4697) | Fabrication Part Dimension Log and Suspended Support Manager: use the | 2 | 2 | medium | swap grouping to comparer in two tools plus check |
| [KTR5-4698](https://linear.app/jhkelly/issue/KTR5-4698) | OperationService.Run: Layout Point Export, Module Manage, Spool Create | 4 | 4 | medium | 8 Start/Stop sites in view models moved to Run |
| [KTR5-4699](https://linear.app/jhkelly/issue/KTR5-4699) | Spool Creator V1: reproduce the assembly creation failure on family in | 1 | 1 | low | keep: evidence not clear enough to change (subagent proposed 2, low confidence) |
| [KTR5-4700](https://linear.app/jhkelly/issue/KTR5-4700) | OperationService.Run: decide Many Connect, Custom Data Updater V2, Lay | 4 | 4 | medium | four sites needing per-site decision and restructure |
| [KTR5-4701](https://linear.app/jhkelly/issue/KTR5-4701) | Spool Creator V1: repin and verify on the failing families | 1 | 1 | medium | repin and verify one case |
| [KTR5-4702](https://linear.app/jhkelly/issue/KTR5-4702) | Suspended Support Manager: mark rows with invalid properties | 2 | 2 | medium | enable validation, row marker and filter in one grid |
| [KTR5-4703](https://linear.app/jhkelly/issue/KTR5-4703) | Add-in host: tests for Caches, the 4 event handlers, Resources, A | 4 | 4 | medium | tests for host types in one repo |
| [KTR5-4704](https://linear.app/jhkelly/issue/KTR5-4704) | Per-element catch in the Trade.All color filter assigners | 2 | 2 | medium | same helper applied to 7 similar commands |
| [KTR5-4705](https://linear.app/jhkelly/issue/KTR5-4705) | Trade.All assigners: tests for the combo boxes, settings and event han | 8 | 8 | medium | 19 untested types with many members, in-Revit |
| [KTR5-4706](https://linear.app/jhkelly/issue/KTR5-4706) | Per-element catch in the spool and support managers | 4 | 4 | medium | helper applied across spool and support managers (11 blocks) |
| [KTR5-4707](https://linear.app/jhkelly/issue/KTR5-4707) | Per-element catch in the remaining module commands | 4 | 4 | medium | helper applied across several module commands |
| [KTR5-4708](https://linear.app/jhkelly/issue/KTR5-4708) | Trade.All view models: Spools, Supports, Layout Points, Module Creator | 8 | 8 | medium | tests for five large view models, some needing Revit |
| [KTR5-4709](https://linear.app/jhkelly/issue/KTR5-4709) | Trade.All other commands: Vicious, About, Arranger, Excel, updater hel | 4 | 4 | medium | tests for several command types in one module |
| [KTR5-4710](https://linear.app/jhkelly/issue/KTR5-4710) | Trade.All ribbon items: tests for the 24 stacked buttons and enablers | 2 | 2 | medium | tests for ribbon items and enablers, mostly simple |
| [KTR5-4711](https://linear.app/jhkelly/issue/KTR5-4711) | Contenter, Developer, Duct and Pipe modules: tests for the 15 untested | 4 | 4 | medium | tests for 15 types across four modules |
| [KTR5-4712](https://linear.app/jhkelly/issue/KTR5-4712) | Tests.Revit: the 4 tests that need the add-in started fail with it dis | 1 | 1 | high | add Assume.That inconclusive guards to four tests |
| [KTR5-4713](https://linear.app/jhkelly/issue/KTR5-4713) | Vicious Point To Pipe: move the view's code-behind logic into the view | 4 | 4 | medium | move 351 lines of code-behind into ViewModel with tests |
| [KTR5-4714](https://linear.app/jhkelly/issue/KTR5-4714) | Vicious Point To Pipe: break up ViciousFileBasedSystemPipePlaceTools | 4 | 4 | medium | split a 525-line class and route through Run |
| [KTR5-4715](https://linear.app/jhkelly/issue/KTR5-4715) | Vicious Straights Racker: clean up ViciousInstanceElevationAssignView | 4 | 4 | medium | separate logic from prompts in a 346-line ViewModel with tests |
| [KTR5-4716](https://linear.app/jhkelly/issue/KTR5-4716) | Vicious Instance Rotate Move: clean up the command | 4 | 4 | medium | extract state and rotate logic from a 267-line command |
| [KTR5-4717](https://linear.app/jhkelly/issue/KTR5-4717) | Vicious Fabrication Hanger Place: clean up command and options window | 2 | 2 | medium | remove bare catch and move 118 lines to a ViewModel |
| [KTR5-4718](https://linear.app/jhkelly/issue/KTR5-4718) | Vicious Instance Level Assign and Instance Disconnect: clean up | 2 | 2 | medium | two small tools aligned to MVVM and Run |
| [KTR5-4719](https://linear.app/jhkelly/issue/KTR5-4719) | Pipe Offset Create: command, window and push button in Trade.Pipe | 4 | 4 | medium | new command, window and push button in one module |
| [KTR5-4726](https://linear.app/jhkelly/issue/KTR5-4726) | Deprecate the Component and Product IUpdaters and Manual Updaters | 4 | 4 | medium | add-in side now only docs and the Logic repin; could be 2 |
| [KTR5-4728](https://linear.app/jhkelly/issue/KTR5-4728) | Collections, Files, Xlsx and more: switch Kelly-Revit to the 6 moved m | - | 2 | low | switch callers to 6 moved members and delete copies, guard tests |
| [KTR5-4740](https://linear.app/jhkelly/issue/KTR5-4740) | Commands, Grids: switch Kelly-Revit to the 21 moved members and delete | - | 4 | low | switch callers to 21 moved members across Commands/Grids |
| [KTR5-4743](https://linear.app/jhkelly/issue/KTR5-4743) | Missing shared parameters dialog says the list was copied to the clipb | - | 1 | high | text fix or one clipboard call in one handler |
| [KTR5-4744](https://linear.app/jhkelly/issue/KTR5-4744) | Assigner adopt commands report Failed after adding a new value | - | 2 | medium | one command result fix in one type with test |
| [KTR5-4745](https://linear.app/jhkelly/issue/KTR5-4745) | Module Manager: the Show In View checkbox does nothing | - | 2 | high | one ViewModel honoring an existing checkbox binding, with test |
| [KTR5-4747](https://linear.app/jhkelly/issue/KTR5-4747) | ExcelInteropTools: FormatWorksheet and ImportTabDelimitedText have no | - | 2 | medium | tests for two Excel helpers and one private method |
| [KTR5-4748](https://linear.app/jhkelly/issue/KTR5-4748) | Three commands never check their window is ready before showing it | - | 2 | medium | add ValidateRequirements to three commands with tests |
| [KTR5-4749](https://linear.app/jhkelly/issue/KTR5-4749) | Module Creator view model tests repeat the Kelly.Domain numbering rule | - | 1 | medium | delete duplicated tests already covered in Kelly.Domain |

## KTRL4

| Key | Title | Current | Proposed | Confidence | Reason |
|---|---|---|---|---|---|
| [KTRL4-1](https://linear.app/jhkelly/issue/KTRL4-1) | Are there any TODO notes that can be handled? | 4 | 4 | low | keep: 11 todo notes, but no sub-issues; sized as one standalone |
| [KTRL4-2](https://linear.app/jhkelly/issue/KTRL4-2) | ElementExtensions: add GetLengthInFeet, GetNominalSize, GetWeight, Reset | 2 | 2 | high | keep: four small extension methods plus pack |

## KTR4

| Key | Title | Current | Proposed | Confidence | Reason |
|---|---|---|---|---|---|
| [KTR4-2](https://linear.app/jhkelly/issue/KTR4-2) | Use the other JH Kelly brand colors beside Kelly Green | - | - | high | parent |
| [KTR4-3](https://linear.app/jhkelly/issue/KTR4-3) | Move the feet-and-inches check into Kelly-Windows-v2 ConstructionServic | 8 | 8 | medium | keep: new Windows-v2 member packed and repinned through Logic-v4 and add-in |
| [KTR4-18](https://linear.app/jhkelly/issue/KTR4-18) | Are there any TODO notes that can be handled? | - | - | high | parent |
| [KTR4-24](https://linear.app/jhkelly/issue/KTR4-24) | Add the brand colors once as named colors and brushes | 8 | 8 | medium | keep: new color set in Kelly-Windows-v2 packed and repinned, plus resource dictionary |
| [KTR4-25](https://linear.app/jhkelly/issue/KTR4-25) | Replace the off-palette colors in the views and converters | 8 | 8 | medium | keep: sweep over views and converters across two repos |
| [KTR4-26](https://linear.app/jhkelly/issue/KTR4-26) | Decide the status colors (success, warning, danger) | 4 | 4 | low | keep: color decision plus applying to three classes |
| [KTR4-27](https://linear.app/jhkelly/issue/KTR4-27) | Racker: Bottom/Top align buttons override typed elevation in Manual mod | 1 | 1 | high | keep: remove two bindings |
| [KTR4-28](https://linear.app/jhkelly/issue/KTR4-28) | Module Manage: Item Numbers button stays disabled after BOM type set | 1 | 1 | high | keep: raise PropertyChanged |
| [KTR4-29](https://linear.app/jhkelly/issue/KTR4-29) | Layout Point Export: Data Filter drops hidden saved points on save | 2 | 2 | medium | keep: take points from candidates |
| [KTR4-30](https://linear.app/jhkelly/issue/KTR4-30) | Layout Point Import: Specify Level always fails | 1 | 1 | high | keep: fix binding path |
| [KTR4-31](https://linear.app/jhkelly/issue/KTR4-31) | Spool Manager: partial changes committed when an edit throws | 4 | 4 | medium | keep: rollback wrapper around 11 operations |
| [KTR4-32](https://linear.app/jhkelly/issue/KTR4-32) | Layout Point Export: Export saves hosts before quality check and dialog | 4 | 4 | medium | keep: reorder export flow across view and ViewModel |
| [KTR4-33](https://linear.app/jhkelly/issue/KTR4-33) | Layout Point Export: save with no valid points shows exception prompt | 2 | 2 | high | keep: one ViewModel |
| [KTR4-34](https://linear.app/jhkelly/issue/KTR4-34) | Layout Point Export: Exported and Not Valid filters cannot match | 2 | 2 | high | keep: fix filter member names and label |
| [KTR4-35](https://linear.app/jhkelly/issue/KTR4-35) | Layout Point Export: tool will not open without hangers or points | 2 | 2 | high | keep: relax validation in one ViewModel |
| [KTR4-36](https://linear.app/jhkelly/issue/KTR4-36) | Layout Point Import: missing point families cause NullReferenceExceptio | 2 | 2 | high | keep: null checks in one type |
| [KTR4-37](https://linear.app/jhkelly/issue/KTR4-37) | Olet Check: Re-Connect and Select use the wrong project | 4 | 4 | medium | keep: handler, command and ViewModel per-project |
| [KTR4-38](https://linear.app/jhkelly/issue/KTR4-38) | Point to Pipe: typed or pasted Point File path is ignored | 2 | 2 | high | keep: view code-behind fix |
| [KTR4-39](https://linear.app/jhkelly/issue/KTR4-39) | Point to Pipe: units boxes always start at Inches and Feet | 2 | 2 | medium | keep: settings init in one tool |
| [KTR4-40](https://linear.app/jhkelly/issue/KTR4-40) | Spool Manager: Welds tab Update buttons show Error Reading Object | 2 | 2 | high | keep: pass CommandParameter in one ViewModel |
| [KTR4-41](https://linear.app/jhkelly/issue/KTR4-41) | Spool Manager: will not open without a 'Spool - ' title block | 2 | 2 | high | keep: one ViewModel plus UI disable |
| [KTR4-42](https://linear.app/jhkelly/issue/KTR4-42) | Suspended Support Manager: Override Size Set skips family supports | 2 | 2 | high | keep: one ViewModel method |
| [KTR4-43](https://linear.app/jhkelly/issue/KTR4-43) | Suspended Support Manager: Tagging Set tags un-hosted hangers | 1 | 1 | high | keep: one condition |
| [KTR4-44](https://linear.app/jhkelly/issue/KTR4-44) | Layout Point Export: save clears the Revit selection | 2 | 2 | high | keep: selection sync in one ViewModel |
| [KTR4-45](https://linear.app/jhkelly/issue/KTR4-45) | Layout Point Export: export window stays always on top | 1 | 1 | high | keep: remove Topmost |
| [KTR4-46](https://linear.app/jhkelly/issue/KTR4-46) | Layout Point Export: quality dialog shows placeholder text | 1 | 1 | high | keep: dialog text |
| [KTR4-47](https://linear.app/jhkelly/issue/KTR4-47) | Level Correct: fails on a selection with a category-less element | 1 | 1 | high | keep: one filter expression |
| [KTR4-48](https://linear.app/jhkelly/issue/KTR4-48) | Level Correct: empty model selection shows a raw Revit error | 1 | 1 | high | keep: one filter message |
| [KTR4-49](https://linear.app/jhkelly/issue/KTR4-49) | Line Number selector: Add Context Value check box label is wrong | 1 | 1 | high | keep: label text |
| [KTR4-50](https://linear.app/jhkelly/issue/KTR4-50) | Module Creator: Last Module shows AB-MOD-5 without padding | 2 | 2 | high | keep: one-type padding fix |
| [KTR4-51](https://linear.app/jhkelly/issue/KTR4-51) | Module Creator: DEFAULT prefix offered in projects with no modules | 2 | 2 | high | keep: one ViewModel filter |
| [KTR4-52](https://linear.app/jhkelly/issue/KTR4-52) | Module Manager: grid shows unsaved item numbers as written | 2 | 2 | high | keep: one ViewModel restore logic |
| [KTR4-53](https://linear.app/jhkelly/issue/KTR4-53) | Olet Check: Select links keep stale enabled state | 1 | 1 | high | keep: invalidate two commands |
| [KTR4-54](https://linear.app/jhkelly/issue/KTR4-54) | Olet Check: dialog collects olets twice on open | 1 | 1 | high | keep: drop one call |
| [KTR4-55](https://linear.app/jhkelly/issue/KTR4-55) | Racker: cancel ends as Failed instead of Cancelled | 1 | 1 | high | keep: return Cancelled |
| [KTR4-56](https://linear.app/jhkelly/issue/KTR4-56) | Racker: will not open on Straights items with no level | 2 | 2 | high | keep: null handling in one ViewModel |
| [KTR4-57](https://linear.app/jhkelly/issue/KTR4-57) | Spool Creator: line-number spool count matches name prefixes too loosel | 2 | 2 | high | keep: tighten one count |
| [KTR4-58](https://linear.app/jhkelly/issue/KTR4-58) | Spool Creator: one Create is three separate Undo steps | 2 | 2 | high | keep: one ViewModel transaction group |
| [KTR4-59](https://linear.app/jhkelly/issue/KTR4-59) | Spool Manager: grids keep new values after a rolled-back edit | 2 | 2 | high | keep: one ViewModel fix |
| [KTR4-60](https://linear.app/jhkelly/issue/KTR4-60) | Suspended Support Manager: Set Extensions on unattached hangers does no | 2 | 2 | high | keep: skip and report in one type |
| [KTR4-61](https://linear.app/jhkelly/issue/KTR4-61) | Suspended Support Manager: field trim stored in inches, not feet | 1 | 1 | high | keep: one unit assignment |
| [KTR4-62](https://linear.app/jhkelly/issue/KTR4-62) | Windows Mockup: product-code list blank after scope change | 1 | 1 | high | keep: refill one collection |
| [KTR4-66](https://linear.app/jhkelly/issue/KTR4-66) | Assigner combo boxes: one base class for the six, ComboBoxExtensions as | 4 | 4 | medium | keep: one base class for six combo boxes |
| [KTR4-67](https://linear.app/jhkelly/issue/KTR4-67) | Assigner view-filter commands: share their common code | 4 | 4 | medium | keep: shared base for seven view-filter commands, several types |
| [KTR4-68](https://linear.app/jhkelly/issue/KTR4-68) | Vicious commands, Arranger, Spool Sheet Open: scope collector and refac | 8 | 8 | medium | keep: shared scope collector refactor across 6 Vicious commands |
| [KTR4-69](https://linear.app/jhkelly/issue/KTR4-69) | Spool and support models: the 14 notes | 4 | 4 | medium | keep: 14 notes in spool and support models |
| [KTR4-70](https://linear.app/jhkelly/issue/KTR4-70) | Layout Point, Spool Manager, Support Manager, Weld Location, Duct and U | 4 | 4 | medium | keep: 17 notes across several commands |
| [KTR4-71](https://linear.app/jhkelly/issue/KTR4-71) | Updater element services: resolve the "Implement Data Point" notes, mer | 4 | 4 | medium | keep: 25 notes across 13 services plus merge |
| [KTR4-72](https://linear.app/jhkelly/issue/KTR4-72) | Caches, material tools, sessions, error model, size model: the 14 notes | 2 | 2 | medium | keep: 14 small notes across caches and models |
| [KTR4-73](https://linear.app/jhkelly/issue/KTR4-73) | ElementExtensions: call the Logic copies and delete the add-in's four | 1 | 1 | high | keep: repoint four callers and delete members |

## Low confidence

- [KW3-4](https://linear.app/jhkelly/issue/KW3-4) (4): thin text, ProgressReporter improvement, may touch callers
- [KW3-8](https://linear.app/jhkelly/issue/KW3-8) (1): keep: evidence not clear enough to change (subagent proposed 2, low confidence)
- [KD-22](https://linear.app/jhkelly/issue/KD-22) (4): legacy decode migration or report, behaviour decision
- [KTRL5-42](https://linear.app/jhkelly/issue/KTRL5-42) (4): remaining sites across many folders, may be larger
- [KTRL5-46](https://linear.app/jhkelly/issue/KTRL5-46) (4): fabrication offset needs Kelly test project, could be 8
- [KTRL5-71](https://linear.app/jhkelly/issue/KTRL5-71) (2): in-Revit run of existing tests, fixes may follow
- [KTRL5-72](https://linear.app/jhkelly/issue/KTRL5-72) (2): in-Revit run of existing tests, fixes may follow
- [KTRL5-73](https://linear.app/jhkelly/issue/KTRL5-73) (2): in-Revit run of existing tests, fixes may follow
- [KTRL5-74](https://linear.app/jhkelly/issue/KTRL5-74) (2): in-Revit run of existing tests, fixes may follow
- [KTRUI-1](https://linear.app/jhkelly/issue/KTRUI-1) (4): open-ended review of the Controls folder, thin text
- [KTR5-3142](https://linear.app/jhkelly/issue/KTR5-3142) (4): cause unknown, needs in-Revit investigation
- [KTR5-3278](https://linear.app/jhkelly/issue/KTR5-3278) (8): every support pattern, scope open
- [KTR5-3680](https://linear.app/jhkelly/issue/KTR5-3680) (2): vague bug, investigation first
- [KTR5-3703](https://linear.app/jhkelly/issue/KTR5-3703) (4): shared footer control change plus Manual Updater
- [KTR5-3810](https://linear.app/jhkelly/issue/KTR5-3810) (4): meeting plus written config decisions
- [KTR5-3811](https://linear.app/jhkelly/issue/KTR5-3811) (4): meeting plus written config decisions
- [KTR5-3831](https://linear.app/jhkelly/issue/KTR5-3831) (8): debounce across shared behavior and many views
- [KTR5-3839](https://linear.app/jhkelly/issue/KTR5-3839) (4): planning meeting then build issues; thin text
- [KTR5-4028](https://linear.app/jhkelly/issue/KTR5-4028) (8): new dialog and view model on top of existing tool
- [KTR5-4042](https://linear.app/jhkelly/issue/KTR5-4042) (1): repro first, one shape size read
- [KTR5-4085](https://linear.app/jhkelly/issue/KTR5-4085) (2): dockable pane for the assigners, UI only
- [KTR5-4448](https://linear.app/jhkelly/issue/KTR5-4448) (2): reproduce first; likely one elevation calc fix in Racker
- [KTR5-4518](https://linear.app/jhkelly/issue/KTR5-4518) (1): delete dead code in one layer, description empty
- [KTR5-4519](https://linear.app/jhkelly/issue/KTR5-4519) (1): delete dead code in one layer, description empty
- [KTR5-4520](https://linear.app/jhkelly/issue/KTR5-4520) (1): delete dead code in one layer, description empty
- [KTR5-4521](https://linear.app/jhkelly/issue/KTR5-4521) (1): delete dead code in one layer, description empty
- [KTR5-4581](https://linear.app/jhkelly/issue/KTR5-4581) (8): new recovery tool, thin text
- [KTR5-4582](https://linear.app/jhkelly/issue/KTR5-4582) (4): vague refactor, thin text
- [KTR5-4597](https://linear.app/jhkelly/issue/KTR5-4597) (2): investigation of other file I/O, thin text
- [KTR5-4608](https://linear.app/jhkelly/issue/KTR5-4608) (2): installer config, title only
- [KTR5-4609](https://linear.app/jhkelly/issue/KTR5-4609) (2): installer config, title only
- [KTR5-4610](https://linear.app/jhkelly/issue/KTR5-4610) (2): installer config, title only
- [KTR5-4626](https://linear.app/jhkelly/issue/KTR5-4626) (8): needs sort and EmployeeId read in Kelly-Windows-v3 repinned to add-in
- [KTR5-4661](https://linear.app/jhkelly/issue/KTR5-4661) (2): result code change in one command, though several exit paths
- [KTR5-4693](https://linear.app/jhkelly/issue/KTR5-4693) (4): offline end-to-end check, may expose several faults
- [KTR5-4696](https://linear.app/jhkelly/issue/KTR5-4696) (4): 12 Start/Stop sites in commands moved to Run, maybe larger
- [KTR5-4699](https://linear.app/jhkelly/issue/KTR5-4699) (1): keep: evidence not clear enough to change (subagent proposed 2, low confidence)
- [KTR5-4728](https://linear.app/jhkelly/issue/KTR5-4728) (2): switch callers to 6 moved members and delete copies, guard tests
- [KTR5-4740](https://linear.app/jhkelly/issue/KTR5-4740) (4): switch callers to 21 moved members across Commands/Grids
- [KTRL4-1](https://linear.app/jhkelly/issue/KTRL4-1) (4): keep: 11 todo notes, but no sub-issues; sized as one standalone
- [KTR4-26](https://linear.app/jhkelly/issue/KTR4-26) (4): keep: color decision plus applying to three classes

## Proposed at 16 (should be split)

- [KWD3-2](https://linear.app/jhkelly/issue/KWD3-2): rename JsonFileLoadException used in 32 files across layers; split

## Corrections made to the subagents' proposals

- KTRL5-8 keeps 8: its only sub-issue, KTRL5-79, is a prerequisite check, and the deprecation work itself is still on KTRL5-8 (the subagent proposed clearing it as a parent).
- KTR5-3144, KTR5-3279, KTR5-3827 and KTR5-4170 have open sub-issues, so they get no estimate (the subagent proposed 2, 4, 8 and 8).
- KTR5-3800 (0) and KTR5-4604 (2) are parents that already have an estimate; they keep it unless you ask to clear it.
- KW3-8 and KTR5-4699 keep 1: the subagents proposed 2 with low confidence, not clear enough to overwrite a set value.
