# Linear Estimates, 2026-11-09

Scope: every **open** issue with **no estimate** in the Kelly teams of "Kelly Tools For Revit" (`jhkelly-ktr`), per the new `LINEAR.md` rule (every issue carries an estimate). Existing estimates are left alone. Closed issues are not backfilled (user decision 2026-11-09). Parents with open sub-issues are skipped: Linear rolls their sub-issues up. Scale: Exponential (0, 1, 2, 4, 8, 16) in every team. Hasa teams are not in the workspace listing.

Proposals by three read-only Sonnet subagents that read each issue and the code it names.

## Summary

| Team | Open, unestimated | Proposed | Skipped | Points proposed |
|---|---|---|---|---|
| KTR5 | 27 | 27 | 0 | 100 |
| KTRL5 | 13 | 12 | 1 | 75 |
| KTRUI | 2 | 2 | 0 | 12 |
| KD | 7 | 7 | 0 | 29 |
| KW3 | 7 | 7 | 0 | 19 |
| KWD3 | 1 | 1 | 0 | 4 |
| KWDC | 1 | 1 | 0 | 1 |
| KWDJ | 3 | 3 | 0 | 7 |
| KWDSS | 3 | 3 | 0 | 9 |
| KTR4, KTRL4, KW2, KWD2, KRDE, KWDSL | 0 | – | – | – |
| **Total** | **64** | **63** | **1** | **256** |

Parents skipped because they have open sub-issues: KTR5-3144, -3279, -3827, -4119, -4120, -4170, -4480, -4517, -4596, -4601, -4621, -4627, -4678, -4689; KTRL5-3, KTRL5-5; KTR4-2, KTR4-18.

No changes to existing estimates.

## KTR5

| Key | Title | Proposed | Confidence | Reason |
|---|---|---|---|---|
| [KTR5-4780](https://linear.app/jhkelly-ktr/issue/KTR5-4780) | Spool Auto Set button does nothing | 4 | medium | new auto-set toggle modelled on its neighbours, one tool end to end |
| [KTR5-4771](https://linear.app/jhkelly-ktr/issue/KTR5-4771) | Vicious Rotate/Point To Pipe: culture, dead counters, dead checks | 2 | medium | several small fixes in one module's Vicious files |
| [KTR5-4777](https://linear.app/jhkelly-ktr/issue/KTR5-4777) | Developer tools: Coordinate/Collector Testing, Field Trim End | 4 | medium | four commands in Trade.Developer, one needs a decision |
| [KTR5-4775](https://linear.app/jhkelly-ktr/issue/KTR5-4775) | Many Connect, Stratus Views, spool tools: dead defaults, repeated text | 4 | medium | five small fixes in several tools |
| [KTR5-4766](https://linear.app/jhkelly-ktr/issue/KTR5-4766) | Vicious Rotate: empty angle text throws | 2 | high | three handlers in one view to TryParseAngle, plus a test |
| [KTR5-4767](https://linear.app/jhkelly-ktr/issue/KTR5-4767) | Duct Item Number Set: Esc on replace still renumbers | 1 | high | one condition in one command plus its test |
| [KTR5-4754](https://linear.app/jhkelly-ktr/issue/KTR5-4754) | Module Manager: block Update Item Numbers on component errors | 4 | medium | view model and view rules plus a sort-schema check |
| [KTR5-4753](https://linear.app/jhkelly-ktr/issue/KTR5-4753) | Module Manager: manual update of members button | 4 | low | new button and command, unconfirmed idea |
| [KTR5-4752](https://linear.app/jhkelly-ktr/issue/KTR5-4752) | Module Manager: Rename Module button | 4 | low | new button and operation over all members; may overlap KTR5-3791 |
| [KTR5-4755](https://linear.app/jhkelly-ktr/issue/KTR5-4755) | Layout Point Export: internal or shared coordinates | 4 | medium | new option through view, view model and DWG export |
| [KTR5-4756](https://linear.app/jhkelly-ktr/issue/KTR5-4756) | Layout Point Export: select sibling points | 4 | low | new selection behaviour, "sibling" undefined |
| [KTR5-4757](https://linear.app/jhkelly-ktr/issue/KTR5-4757) | Stratus Detailing Package Views: add missing filters | 2 | medium | one change in one tool's reuse path plus a test |
| [KTR5-4768](https://linear.app/jhkelly-ktr/issue/KTR5-4768) | Value Set: Line Number does not dispose its view model | 1 | high | one argument in one command, one test updated |
| [KTR5-4770](https://linear.app/jhkelly-ktr/issue/KTR5-4770) | Host event handlers: dead IsSameDocument, empty DocumentChanged | 2 | medium | three handlers, mostly dead code removed |
| [KTR5-4778](https://linear.app/jhkelly-ktr/issue/KTR5-4778) | Driving force: spec-driven development, integration testing | 0 | low | planning note, no code |
| [KTR5-4779](https://linear.app/jhkelly-ktr/issue/KTR5-4779) | Claude prompt that recreates an IExternalCommand | 2 | low | experiment, no repo change |
| [KTR5-4758](https://linear.app/jhkelly-ktr/issue/KTR5-4758) | Category sets from the definition | 16 | medium | sweep over many static sets, likely lower layers too; split |
| [KTR5-4751](https://linear.app/jhkelly-ktr/issue/KTR5-4751) | Prompts: 36 files TaskDialog, 3 MessageBox | 16 | high | migration over dozens of sites; split by module |
| [KTR5-4750](https://linear.app/jhkelly-ktr/issue/KTR5-4750) | Contenter: FabricationCustomDataUpdater V1/V2 duplicate | 4 | medium | remove one updater with its button, tests and docs |
| [KTR5-4773](https://linear.app/jhkelly-ktr/issue/KTR5-4773) | Assigners: reset results, case, placeholder, panel | 4 | medium | four findings in Trade.All; part moved to KTR5-4780 |
| [KTR5-4776](https://linear.app/jhkelly-ktr/issue/KTR5-4776) | Contenter: V1 workshared message, Various Report cast | 2 | medium | two small fixes in two types |
| [KTR5-4772](https://linear.app/jhkelly-ktr/issue/KTR5-4772) | Service/System line color filters: no progress, empty list throws | 2 | medium | fix in the Logic filter path; 4 if Logic is repinned |
| [KTR5-4769](https://linear.app/jhkelly-ktr/issue/KTR5-4769) | Missing Shared Parameters dialog: nothing copied | 1 | high | one dialog: clipboard call or text change |
| [KTR5-4774](https://linear.app/jhkelly-ktr/issue/KTR5-4774) | Layout Point Export: leading space in " IsExported" | 1 | high | one string constant plus a test |
| [KTR5-4761](https://linear.app/jhkelly-ktr/issue/KTR5-4761) | Commands and Rotate view to Windows helpers and UserPrompt | 8 | medium | about 8 TaskDialogs plus angle parse and report writer |
| [KTR5-2808](https://linear.app/jhkelly-ktr/issue/KTR5-2808) | BOM Type Module Setter | 1 | low | push button already exists; likely done, check and close |
| [KTR5-2806](https://linear.app/jhkelly-ktr/issue/KTR5-2806) | BOM Type Shop Setter | 1 | low | push button already exists; likely done, check and close |

## KTRL5

| Key | Title | Proposed | Confidence | Reason |
|---|---|---|---|---|
| [KTRL5-98](https://linear.app/jhkelly-ktr/issue/KTRL5-98) | StratusViewTools no-packages prompt unreachable | 2 | medium | one guard fix; in-Revit test exists |
| [KTRL5-101](https://linear.app/jhkelly-ktr/issue/KTRL5-101) | SpoolItem.IsSpoolAble: Insulation passes | 2 | high | one fix in one type with its test |
| [KTRL5-102](https://linear.app/jhkelly-ktr/issue/KTRL5-102) | SuspendedSupport extension units, defaults, layout point cancel | 4 | medium | three fixes across Supports and LayoutPoints, in-Revit tests |
| [KTRL5-93](https://linear.app/jhkelly-ktr/issue/KTRL5-93) | Fabrication/geometry/MEP command logic into Logic | 8 | low | about 8 command moves; source-switch child done |
| [KTRL5-97](https://linear.app/jhkelly-ktr/issue/KTRL5-97) | PathExtensions data path from AddInNames | 1 | high | one string composition |
| [KTRL5-99](https://linear.app/jhkelly-ktr/issue/KTRL5-99) | GeometrySignatureGroupingTests null-arg Serilog clash | 2 | medium | test guard plus an argument check in one type |
| [KTRL5-100](https://linear.app/jhkelly-ktr/issue/KTRL5-100) | Shared ViewFamilyType test helper | 4 | high | new helper, 8 fixtures repointed, in-Revit run |
| [KTRL5-103](https://linear.app/jhkelly-ktr/issue/KTRL5-103) | Remaining ScopeType Enum.IsDefined guards | 4 | medium | 7 sites in 4 files |
| [KTRL5-90](https://linear.app/jhkelly-ktr/issue/KTRL5-90) | FabricationPartExtensions: 46 type checks | 8 | medium | 31 checks in one large file, redesign, in-Revit tests |
| [KTRL5-89](https://linear.app/jhkelly-ktr/issue/KTRL5-89) | Split DocumentExtensions (1,940 lines) and Spool (1,059) | 16 | high | about 50 methods plus callers; split |
| [KTRL5-52](https://linear.app/jhkelly-ktr/issue/KTRL5-52) | Move 22 members into Logic (Supports, Updaters) | 16 | low | 22 members; mostly done, in Testing |
| [KTRL5-47](https://linear.app/jhkelly-ktr/issue/KTRL5-47) | Move 12 members into Logic (Arrangement, Common, Connectors) | 8 | low | 12 members; mostly done, in Testing |
| [KTRL5-4](https://linear.app/jhkelly-ktr/issue/KTRL5-4) | Deprecation plans for Kelly-Revit-Logic-v5 | skip | high | container; both sub-issues are Done (KTRL5-8 holds 8 points), so its own estimate would count the work twice; check whether to close it |

## KTRUI

| Key | Title | Proposed | Confidence | Reason |
|---|---|---|---|---|
| [KTRUI-26](https://linear.app/jhkelly-ktr/issue/KTRUI-26) | RibbonHost static locator, RibbonExtensions TaskDialog bypass | 4 | medium | two TaskDialogs to UserPrompt, plus about 126 RibbonHost uses if the locator goes |
| [KTRUI-25](https://linear.app/jhkelly-ktr/issue/KTRUI-25) | ViewModel does too much, no IViewModel | 8 | medium | 352-line base split, touches every derived view model |

## KD

| Key | Title | Proposed | Confidence | Reason |
|---|---|---|---|---|
| [KD-57](https://linear.app/jhkelly-ktr/issue/KD-57) | SupportSignature double text differs .NET 4.8/8 | 4 | medium | one type plus a format decision; 8 if stored signatures migrate |
| [KD-58](https://linear.app/jhkelly-ktr/issue/KD-58) | ProductCodeCheckReport.BuildSummaryText | 2 | high | one new member with tests and docs |
| [KD-59](https://linear.app/jhkelly-ktr/issue/KD-59) | Domain docs name higher layers | 2 | high | docs only: 8 remarks, one Description, placeholder texts |
| [KD-53](https://linear.app/jhkelly-ktr/issue/KD-53) | IColorPalette numbered Color00..09 | 4 | medium | interface, one type, 3 test files; public change |
| [KD-52](https://linear.app/jhkelly-ktr/issue/KD-52) | Infrastructure in domain (USP_, SqlServerService) | 8 | medium | 4+ files moved or behind seams, repinned up the stack |
| [KD-51](https://linear.app/jhkelly-ktr/issue/KD-51) | DefinitionRegistry/ServerData global service locators | 8 | medium | 28 Domain files; public surface change for the layers above |
| [KD-50](https://linear.app/jhkelly-ktr/issue/KD-50) | LayeringTests fails under coverlet | 1 | high | skip Coverlet namespaces in one test |

## KW3

| Key | Title | Proposed | Confidence | Reason |
|---|---|---|---|---|
| [KW3-27](https://linear.app/jhkelly-ktr/issue/KW3-27) | ObjectPropertyLogger.IsList misses IList&lt;T&gt; | 2 | high | one private method, tests updated |
| [KW3-19](https://linear.app/jhkelly-ktr/issue/KW3-19) | ProgressBarService.Dispose warning on short run | 2 | high | one type, one log call with test |
| [KW3-20](https://linear.app/jhkelly-ktr/issue/KW3-20) | Rename LoopBegin/LoopEnd/LoopSkipped, callers to Track | 8 | high | about 27 files across layers, repinned |
| [KW3-23](https://linear.app/jhkelly-ktr/issue/KW3-23) | UserPrincipalExtensions AD seam | 2 | medium | one type, seam and tests |
| [KW3-22](https://linear.app/jhkelly-ktr/issue/KW3-22) | ClipboardTools clipboard seam | 2 | high | one type: seam, SetText fix, null check |
| [KW3-21](https://linear.app/jhkelly-ktr/issue/KW3-21) | ShellTools.OpenInExplorer process-starter seam | 1 | high | one small method, seam and test |
| [KW3-24](https://linear.app/jhkelly-ktr/issue/KW3-24) | SqlRecordCache: drop SqlServerService constructor | 2 | medium | one constructor; layers above may call it |

## KWD3, KWDC, KWDJ, KWDSS

| Key | Title | Proposed | Confidence | Reason |
|---|---|---|---|---|
| [KWD3-12](https://linear.app/jhkelly-ktr/issue/KWD3-12) | CacheBase creates SqlServerService | 4 | low | constructor injection plus callers; overlaps KWD3-7 |
| [KWDC-1](https://linear.app/jhkelly-ktr/issue/KWDC-1) | Add coverlet.collector to Csv tests | 1 | high | one package reference |
| [KWDJ-1](https://linear.app/jhkelly-ktr/issue/KWDJ-1) | JsonDataWriter property order by DataFileFormat.Columns | 2 | high | one type, test first; mirrors the Csv fix |
| [KWDJ-2](https://linear.app/jhkelly-ktr/issue/KWDJ-2) | 50 tests without Author/Description | 4 | high | 51 tests, each needs a real Description |
| [KWDJ-3](https://linear.app/jhkelly-ktr/issue/KWDJ-3) | Add coverlet.collector to Json tests | 1 | high | one package reference |
| [KWDSS-1](https://linear.app/jhkelly-ktr/issue/KWDSS-1) | Delete 20 deprecated stored procedures | 4 | medium | 20 files across two schema repos; blocked until 2027-01-01 |
| [KWDSS-3](https://linear.app/jhkelly-ktr/issue/KWDSS-3) | Delete dbo.Project.IsActive column | 1 | medium | one column; blocked until after 2027-01-01 |
| [KWDSS-6](https://linear.app/jhkelly-ktr/issue/KWDSS-6) | General-Schema build fails, 37 SQL71501 errors | 4 | medium | three views to fix or delete, per-view decisions |

## Low confidence

KTR5-4753, -4752, -4756, -4778, -4779, -2808, -2806; KTRL5-93, -52, -47; KWD3-12.

KTR5-2808 and KTR5-2806 look already done (their push buttons exist); `linear-issue-check-isdone` can confirm and close them.

## Proposed at 16 (should be split)

KTR5-4758, KTR5-4751, KTRL5-89, KTRL5-52.
