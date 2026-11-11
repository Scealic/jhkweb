# Member naming check, pass 2: Kelly-Revit-Logic-v5 (part 2) (2026-11-11)
Second pass after the first-pass renames landed. Sources: groups G10 (Mep, Operations, Parameters, Projects, Properties, Signatures), G11 (Spools, Supports), G12 (Updaters, Views). Readers: Sonnet; checked by: Opus.

Part 1 (G07–G09) is a separate report. `PathExtensions` and `ArrangerOrientation` belong to part 1. All paths below are under `Kelly-Revit-Logic-v5/src`. Callers are rough counts across the v5 repos (src and modules, not tests).

## Summary
- Misleading: 10 confirmed out of 20 reported. 8 were downgraded, 1 belongs to Domain, and 1 was merged into a bug.
- Vague: 53. That is 45 as reported, plus 7 downgraded from Misleading and 1 moved from Possible bugs.
- Style: 42. That is 42 reported, less 1 dropped, plus 1 downgraded from Misleading.
- Possible bugs: 18 reported, 7 confirmed, 11 dropped (documented behaviour, already checked in the first pass, or no failing case).
- Every Misleading and every bug was checked against the code. About one in four Vague and Style items was spot-checked; all of those held.

## Confirmed bugs
| Member | File:line | What is wrong | Evidence | Steps to show it | Priority |
|---|---|---|---|---|---|
| `SuspendedSupport.SetRodLengthForFlatStrapHanger` | `Supports/SuspendedSupport.cs:843` | Reads the fabrication dimension named `"TBD"`, a placeholder. `GetDimensionValue` returns -1 when no dimension has that name, so every flat strap hanger gets `LengthOverall` = -1. | Literal `"TBD"`. `FabricationPartExtensions.GetDimensionValue` returns -1 when nothing matches. In the code since the folder move (`b7c156f`). | Open Suspended Support Manage on a model with a flat strap fabrication hanger (`RodLengthSource.FlatStrap`). The vertical member length shows -1. | Medium (find the real dimension name; raise to High if the value is written back) |
| `Spool.PlaceScheduleViews` | `Spools/Spool.cs:899-929` | When the project has no schedule template with the configured name, `viewScheduleTemplate` is null and `viewScheduleTemplate.Id` throws `NullReferenceException`. The "Could not find a View Template" prompt only appears for an unknown schedule kind. Its title is `"GetManagerName"`, a leftover method name. | `FirstOrDefault(...)`, then `.Id` in every branch. Literal on line 929. | Spool Manager, Spool Sheet Create, in a project without one of the BOM/MTR/Length/Weight/Weld schedule templates. | Medium |
| `Olet.TryParse` | `Mep/Olet.cs:82` | A `Try` method that throws. An olet part (ItemCustomId 2875) with 0 or more than 2 connectors makes the private constructor throw `InvalidOperationException`, so one bad part stops `OletTapTools.SortOletsAndPipes` for the whole selection. | The constructor throws when `connectorSetSize is 0 or > 2`. `TryParse` does not catch it. | Connect Olets on a selection that holds a damaged olet with no connectors. | Low. Add to **KTRL5-138** (same guard) as new evidence, not as a new issue. |
| `TrapezeVerticalMemberTools.ResetExtendAndClearTags`, `ResetVerticalMembersAndTags` | `Supports/TrapezeVerticalMemberTools.cs:77-82, 206-213` | When the transaction group does not start, they roll back and return `CommandResult.Succeeded` without `ShowFailToStartNotification`. Every other operation in the folder shows that notification. The second method also calls `Commit()` after `RollBack()`. | The `else { operationService.RollBack(); }` branches, then `return CommandResult.Succeeded`. | Run Extend Trapeze Rods, or Suspended Support Manage reset, on a document where the group cannot start (for example, read-only). The command reports success with no message. | Low |
| `VisibilityCommon.ApplyOrCreateViewFilter` (obsolete) | `Views/VisibilityCommon.cs:48-110` | Catches any exception, shows it, then returns `CommandResult.Succeeded`. Its only caller, `AssignerViewFilterCommand`, therefore reports success after a failure. | `catch (Exception exception) { exception.ReportToUser(); }`, then falls through to `return CommandResult.Succeeded`. | Assigner view filter in a project where the shared parameter is not bound. You get the error dialog, but the command returns Succeeded. | Low |
| `ProjectLocationExtensions.GetSiteLocationReport` | `Projects/ProjectLocationExtensions.cs:36, 47, 52` | Prints the project position `Angle` raw, in radians with no unit, while latitude and longitude are converted to degrees. "Name" and "Place Name" both print `siteLocation.PlaceName`. | The report lines named. | Run the Project Coordinate Report on a rotated project. The angle reads, for example, 0.5236 rather than 30°. | Low |
| `CustomDataUpdateEvaluator.EvaluatePart` gauge error text | `Updaters/CustomDataUpdateEvaluator.cs:56` | The message says "No Gauge record was found in SQL Server". v5 reads only the CSV data files (since 2026-10-30), so the message sends the user to the wrong place. | The literal. It is the only `SQL Server` text left in Logic `src`. | Fabrication part whose gauge is missing from the data files. | Low |

## Proposed rename issues

### R1: Mep point-to-pipe and olet member names
| Severity | Member | File:line | What it does | Suggested | Callers | Serialized/Shown |
|---|---|---|---|---|---|---|
| Misleading | `Olet.TryParse` | `Mep/Olet.cs:82` | Builds an `Olet` from a part; parses nothing. Fix the throw first (KTRL5-138). | `TryCreate` (as `SuspendedSupport.TryCreate`) | 1 | no |
| Vague | `PointToPipeTargets.ResolvePipeType(…, out service)` | `Mep/PointToPipeTargets.cs:56` | Finds the pipe type by name. If none matches, it returns the first pipe type and also looks up a fabrication service of that name. Documented, but the name hides both. (Downgraded.) | `FindPipeTypeOrFabricationService` | 2 | no |
| Vague | `MepCurve` `SetOffset` (Pipe, Duct, CableTray, Conduit) | `Mep/PipeExtensions.cs:21`, `DuctExtensions.cs:21`, `CableTrayExtensions.cs:28`, `ConduitExtensions.cs:28` | Sets the top, middle or bottom elevation (parameter `desiredElevation`). The wrapper is `SetBottomOrTopElevation`. The Pipe, CableTray and Conduit versions keep a dead `insulationThickness = 0.0`. (Moved here from Possible bugs.) | `SetElevation` (no clash); drop the dead local | 4 + wrapper | no |
| Vague | `PointToPipePlacement.Resolve` | `Mep/PointToPipePlacement.cs:18` | Maps a placement-method text to an origin, a file point and a transform | `ResolvePlacementPoints` | 1 | no |
| Vague | `OletTapTools.SortOletsAndPipes` | `Mep/OletTapTools.cs:227` | Partitions the parts; it does not sort them | `SplitOletsAndPipes` | 2 | no |
| Vague | `PointToPipeBuilder.CheckDocumentAndData` | `Mep/PointToPipeBuilder.cs:42` | Only throws on bad arguments | `ValidateDocumentAndData` | 2 | no |
| Vague | `PointToPipeUnitTypes`, `GetProjectLengthUnitsText`, `ToUnitsText` | `Mep/PointToPipeUnitTypes.cs:11` | Mixes unit text and `UnitTypeId` | `PointToPipeUnitConversion`, `GetProjectLengthUnitText`, `ToUnitText` | 3 | no |
| Vague | `PointToPipeReport.Created` | `Mep/PointToPipeReport.cs:14` | Count of pipes created | `CreatedPipeCount` | 4 | no |
| Vague | `PointToPipePlacementResult.Origin`, `FilePoint` | `Mep/PointToPipePlacementResult.cs:15` | Target point, and the data's own reference point | `TargetOrigin`, `SourceOrigin` | 4 | no |
| Vague | locals `unitTypeId1/2` (`ReadPcf`), `xyz6` (`CreatePipesCore`), `num` (`ReadTable`) | `Mep/PointToPipeReader.cs`, `PointToPipeBuilder.cs` | Numbered or vague locals | `diameterUnitTypeId`, `coordinateUnitTypeId`, `dataPoint`, `size` | private | no |

### R2: Parameters, Operations and Signatures member names
| Severity | Member | File:line | What it does | Suggested | Callers | Serialized/Shown |
|---|---|---|---|---|---|---|
| Misleading | `ParameterExtensions.GetValue(this Parameter, string)`, `GetValueAsString` | `Parameters/ParameterExtensions.cs:16, 57` | Read, and silently turn `"` into `'` (`DoubleToSingleQuotes`). No XML docs. The Element overload names this transform (`GetValueWithSingleQuotes`, kept on purpose). | Document it now. Rename the string overload to `GetValueWithSingleQuotes(this Parameter, string)` (no clash: the existing one extends `Element`), and `GetValueAsString` to `GetValueAsStringWithSingleQuotes`. | ~156 `GetValue` calls (all overloads); 3 | value shown |
| Vague | `BuiltInParameterExtensions` (type) | `Parameters/BuiltInParameterExtensions.cs:3` | Two of its three members extend `BuiltInCategory`, and `GetCategoryIds` has no callers. (Downgraded: placement, not a wrong claim.) | Move `GetFamilySymbols` to a new `Categories/BuiltInCategoryExtensions.cs`; delete or move `GetCategoryIds` | few | no |
| Vague | `ParameterResultType.ValueParity`, `DontOverWriteValue` | `Parameters/ParameterResultType.cs:17, 29` | Value unchanged; not overwritten because the parameter had content | `ValueUnchanged`, `ValueNotOverwritten` | 2 | Generated from dbo.Terminology; keep the integer values |
| Vague | `OperationService.AddToModifiedCount(object obj)` | `Operations/OperationService.cs:156` | Adds an int, or a collection's count | parameter `countOrItems` | ~60 | no |
| Vague | `OperationServiceLogRecord.Duration` | `Operations/OperationServiceLogRecord.cs:12` | Seconds | `DurationSeconds` with `[JsonProperty("Duration")]` | 1 | Serialized (`OperationServiceLog.jsonl` key) |

### R3: Spool and SpoolTools member names
| Severity | Member | File:line | What it does | Suggested | Callers | Serialized/Shown |
|---|---|---|---|---|---|---|
| Misleading | `SpoolTools.GetElementIds(IEnumerable<Spool>)` / `(IEnumerable<Module>)` (first pass, not applied: only the single-spool overload was renamed) | `Spools/SpoolTools.cs:316, 333` | Spools give member ids only; modules give assembly ids plus component ids | `GetMemberElementIds`, `GetAssemblyAndComponentIds` (match the single-item names; no clash) | 1 and 1-2 | no |
| Misleading | `Spool.TryParse(spoolNumber, document, out spool)` | `Spools/Spool.cs:657` | Finds the assembly instance by name and builds a spool from it | `TryFind` | 1 | no |
| Misleading | `SpoolTools.CreateInvalidSpoolItemReport(List<Spool>, Document)` | `Spools/SpoolTools.cs:124` | Writes the non-spoolable report to a log file and returns nothing | `WriteNonSpoolableItemsReport`. Rename `WriteInvalidSpoolItemReport` (`StringBuilder`, :963) to the same name. Keep `Spool.HasInvalidSpoolItems`: it also counts items that are not top-level categories. | 2 and 4 | File title "Invalid Spool Items Report - date" shown; keep or change on purpose |
| Vague | `SpoolTools.TryComposeAvailableSpoolName` | `Spools/SpoolTools.cs:797` | False has two causes; the caller reads `isComposed`. Documented. (Downgraded. The out `spoolNumber` vs "name" is pending: Spool Name vs Spool Number.) | `TryComposeSpoolName` plus `IsSpoolNameAvailable` | 2 | no |
| Vague | `Spool.ItemizeComponents`, `ItemizeWelds`, `SpoolTools.ItemizeAndWriteItemNumbers` | `Spools/Spool.cs:459, 464`; `SpoolTools.cs:838` | Assign item numbers in memory (and then write them) | `AssignComponentItemNumbers`, `AssignWeldItemNumbers`, `AssignAndWriteComponentItemNumbers` (Domain uses `AssignItemNumbers`) | 6 | no |
| Vague | `SpoolItem.SetItemNumberAndSuffix` | `Spools/SpoolItem.cs:319` | In memory only; every other `SetX` writes | `AssignItemNumberAndSuffix` | 5 | no |
| Vague | `Spool.AddSpoolItems`/`RemoveSpoolItems`, Document extensions of the same name | `Spools/Spool.cs:340, 529`; `SpoolTools.cs:16, 572` | Take elements. The Document version finds the spool and opens a transaction. | `Spool.AddElements`/`RemoveElements`; `Document.AddElementsToSpool`/`RemoveElementsFromSpool` | 5 and 5 | Undo texts kept |
| Vague | `SpoolTools.FindSpoolableElementsWithReport` | `Spools/SpoolTools.cs:447` | Also writes the report file and shows a dialog | `GetSpoolableElements` with the side effects in XML docs | 2 | dialog title shown |
| Vague | `NumberableSpoolItemBuiltInCategorySet`, `IsSpoolable(Category)`, `Set()` | `Spools/NumberableSpoolItemBuiltInCategorySet.cs:3` | "Numberable" vs "Spoolable"; `Set()` builds a new set on every call | `SpoolableBuiltInCategories`; static readonly `SpoolableCategories` | 1 | no |
| Vague | `GetBillOfMaterials` (Spool, SpoolTools) | `Spools/SpoolTools.cs:274`; `Spool.cs:421` | Returns the lines of one bill | `GetBillOfMaterialLines` | few | no |
| Vague | `Spool.Weight`, `Length`, `Module.Weight`, `SpoolItem.Weight`, `ShopCutLength` | `Spools/*.cs` | Pounds and feet; `ElementComponent` already says `WeightPounds` | `WeightPounds`, `LengthFeet`, `ShopCutLengthFeet` | ~15 | XAML bindings in the add-in |
| Vague | `Spool.IsDetailed` (and `ElementComponent`) | `Spools/Spool.cs:24` | True when a sheet named like the assembly exists | `HasSpoolSheet` (leave `Module.IsDetailed` for the pending decision) | ~6 | XAML bindings |

### R4: Suspended support and hanger member names
| Severity | Member | File:line | What it does | Suggested | Callers | Serialized/Shown |
|---|---|---|---|---|---|---|
| Misleading | `SuspendedSupport.SetVerticalMemberSupportSize` / `SetVerticalMemberSizeOnModel` | `Supports/SuspendedSupport.cs:462, 448` | The first sets sizes in memory only. The second also writes custom data 111 to a fabrication hanger host. "Model" means the in-memory object in one doc and the Revit model in the other. | `SetVerticalMemberSizeInMemory`, `SetVerticalMemberSizeOnHost` (matches `WriteTagToHost`/`LoadFromHost`) | 4 and 3 | no |
| Vague | `SuspendedSupport.BuildAll` | `Supports/SuspendedSupport.cs:264` | `TryCreate` plus load for each element | `CreateFromElements` | 2 | no |
| Vague | `HangeredStraightModel` and its `LengthStraight*` members | `Supports/HangeredStraightModel.cs:6` | "Hangered" is not a word; feet | `StraightHangerSpacing`; `StraightLengthFeet`, `ResidualLengthFeet`, `ResidualLengthFromPreviousFeet` | 9 | no |
| Vague | `HangerButtonLookupResult.NoButtonDatas`, local `buttonDatas` | `Supports/HangerButtonLookupResult.cs:18` | Empty ordered button list | `NoOrderedButtons`, `buttons` | 5 | no |
| Vague | `HangerPlaceSettings` | `Supports/` | "Place" vs "Placement" | `HangerPlacementSettings` (check that no settings file name uses the type name) | few | check |
| Vague | `TrapezeVerticalMemberTools` length parameters | `Supports/TrapezeVerticalMemberTools.cs:95-289` | Feet | `lengthFeet`, `baselineLengthFeet`, `noStructureLengthFeet` | 10 | no |
| Vague | `VerticalSupportMember.LengthOverall`; docs of `ExtensionLengthForFieldTrim` ("In Inches") and `Signature` (old names) | `Supports/VerticalSupportMember.cs:96, 162` | Feet; the docs are stale after KTRL5-142 | `LengthOverallFeet`; fix the two docs | 13 | Do not change how `Signature` is composed |
| Vague | locals in `LoadVerticalMembers` and the `DefinitionSet` `…EndElevation…`/`EndSupportOffset…` members | `Supports/SuspendedSupport.cs:575-605` | Leftovers from the KTRL5-142 renames | `rodLengthAbove…`, `rodLengthBelow…`, `strutExtensionPastRod` | 1 file | Revit parameter names stay |

### R5: View filter tools member names
| Severity | Member | File:line | What it does | Suggested | Callers | Serialized/Shown |
|---|---|---|---|---|---|---|
| Misleading | `DataContextViewFilterTools.CreateAndApplyFillAndLineCore` (3 public overloads), `CreateAndApplyFillAndLine`, `CreateAndApplyFillAndLineToActiveView` | `Views/DataContextViewFilterTools.cs:50-141` | Line overrides only, except on Export views (line and fill, " (Export)" suffix). All callers are LineColor commands. | `CreateAndApplyLineFiltersCore`, `CreateAndApplyLineFilters`, `CreateAndApplyLineFiltersToActiveView` (no clash) | 4 + 5 add-in commands | Undo text kept |
| Misleading | `ViewFilterExtensions.DetailingPackageIsolateFilter`, `ProductRangeHideFilter` | `Views/ViewFilterExtensions.cs:94, 108` | Noun names on methods that create or reset a filter and apply it. The second is hard-wired to "P-Stratus View". | `ApplyDetailingPackageIsolateFilter`, `ApplyStratusProductRangeHideFilter` | 1 each | filter names shown |
| Misleading | `VisibilityCommon.ApplyOrCreateViewFilter` `[Obsolete]` text | `Views/VisibilityCommon.cs:47` | Points to `CreateAndApplyViewFilter`, which does not exist; the replacement is `ApplyViewFilter` | Fix the message | 1 | Obsolete text |
| Misleading | `AddInViewExtensions.EnsureAddInViews` | `Views/AddInViewExtensions.cs:77` | Also sets the developer parameters and **synchronizes with central and relinquishes** (on document open) | `EnsureAddInViewsAndSyncWithCentral`, or move the sync to the caller (`DocumentOpenedEventHandler`) | 1 | sync comment shown |
| Vague | `DataContextViewFilterTools.CreateAndApplyFill` | `Views/DataContextViewFilterTools.cs:21` | Needs the caller's transaction but has no `Core`. (Downgraded.) | `CreateAndApplyFillFiltersCore` | 2 | no |
| Vague | `ViewExtensions.RemoveAllFilters` / `RemoveFilters` | `Views/ViewExtensions.cs:378, 393` | Same job. The first needs the caller's transaction; the second opens its own. (Downgraded.) | `RemoveAllFiltersCore`, then `RemoveFilters` → `RemoveAllFilters` | 1 and 2 | no |
| Vague | `ViewFilterFactory` (type) | `Views/ViewFilterFactory.cs:5` | A disposable builder that applies rules and overrides. (Downgraded: it does create the filter.) | `ViewFilterBuilder` | 2 | no |
| Vague | `ViewExtensions.ApplyFieldAndModuleFilters` | `Views/ViewExtensions.cs:14` | Also sets wireframe and hides insulation; applies three filters. Documented. (Downgraded.) | `SetUpFieldAndModuleReview` | 1 | Undo text kept |
| Vague | `ProductRangeScheduleExtensions.CreateProductRangeSchedules` | `Views/ProductRangeScheduleExtensions.cs:19` | Creates or rebuilds | `CreateOrRebuildProductRangeSchedules` | 2 | schedule name shown |
| Vague | `StratusViewTools.GetOrPrepareStratusSourceView` | `Views/StratusViewTools.cs:121` | Prompts and assigns the template in a transaction | `PrepareStratusSourceView` | 6 | prompt text |
| Vague | `ViewExtensions.SetCropRegionVisibleAndRestart` | `Views/ViewExtensions.cs:71` | "CropRegion" vs "CropBox" | `SetCropBoxVisibleAndRestart` | 4 | no |
| Vague | `DataContextViewFilterTools` (type), `VisibilityCommon` (type), `OperationType`/`Operation` | `Views/` | Vague names; "Operation" clashes with `OperationService` | `FilterRuleModelViewFilterTools`, `ViewFilterVisibility`, `VisibilityAction`/`Action` | 8, 3, 6 | `Hide`/`Isolate` in saved filter names: keep the values |

### R6: Updater member names
| Severity | Member | File:line | What it does | Suggested | Callers | Serialized/Shown |
|---|---|---|---|---|---|---|
| Vague | `AutoUpdaterManager.Build` / `IAutoUpdaterControl.Build` / `AutoUpdaterService.Build` | `Updaters/AutoUpdaterManager.cs:50` | Creates, registers, triggers and orders the updaters for a document | `RegisterForDocument` | 1 + 2 implementations | no |
| Vague | `ManualUpdaterRunner.Run` | `Updaters/ManualUpdaterRunner.cs:20` | Suspends the auto-updaters, runs the services over a scope, resumes | `UpdateScopeElements` | 1 | no |
| Vague | `ManualUpdaterConfigurationSet.Build` vs `AutoUpdaterConfigurationSet.Create` | `Updaters/Configurations/Manual/ManualUpdaterConfigurationSet.cs:13` | Two verbs for one job | `Create` | 1 | no |
| Vague | `AutoUpdaterManager.WriteUpdaterReport` | `Updaters/AutoUpdaterManager.cs:110` | Kelly updaters only | `WriteKellyUpdaterReport` | 5 | CSV header shown (stray space in `Priority, IsEnabled`) |
| Vague | `IElementDataModel.Initialize` / `UpdateElement` | `Updaters/IElementDataModel.cs:9` | Read the values, then write them | `ReadValues` / `WriteValues` | 6 implementations, 1 caller | no |
| Vague | private `WriteValues` (12 services), `SizeElementDataModel.Update…Ingredients` | `Updaters/ElementServices/*.cs` | Hide what they write | Name the parameter written; `ReadRoundSize`, `ReadWidthHeightSize` | private | no |
| Vague | `ElementServiceExtensions.AssignSelected<T>` | `Updaters/ElementServiceExtensions.cs:15` | Runs the service over the selection in a transaction | `ProcessSelectedElements<T>` (`BillOfMaterialTypeAssigner.AssignSelected` is part 1) | 10 | no |
| Vague | `IElementService.ProcessElements` vs the extension `ProcessElements(…, transactionName)` | `Updaters/ElementServiceExtensions.cs:45` | One name for "in the caller's transaction" and "opens its own" | interface member → `ProcessElementsCore` | many | no |
| Vague | `CustomDataUpdater` (type), `CustomDataUpdateEvaluator.EvaluatePart` | `Updaters/CustomDataUpdater.cs:3`, `CustomDataUpdateEvaluator.cs:16` | A writer of custom data; validates and returns a loaded writer or null | `FabricationPartCustomDataWriter`; `LoadPartOrReportError` | 11, 5 | no |
| Vague | `ServiceElementWriter.WriteServices` | `Updaters/ElementServices/ServiceElementWriter.cs:18` | Also finds or creates the service material | `WriteServiceValuesAndMaterial` | 2 | no |

### R7: Style batch (Logic part 2)
| Member | File | Suggested |
|---|---|---|
| `CreateServiceSignature` vs `GetSystemSignature` (downgraded from Misleading: both only compose text) | `Signatures/` | `GetServiceSignature` |
| private `GetFamilySymbols`, `IsUsedByProject` | `Parameters/SharedParameterElementExtensions.cs` | `GetFamilySymbolsWithParameter`, `IsBoundInProject` |
| `GetRequiredSharedParameterElement` vs `GetBoundCategoryIdsOrThrow` | `Parameters/` | `GetSharedParameterElementOrThrow` |
| private `SetValue(Parameter, object)` | `Parameters/ParameterExtensions.cs:176` | `WriteByStorageType` |
| `StopWatchState`, `SetStopwatchState` | `Operations/StopWatchState.cs` | `StopwatchState` |
| `TransactionName.CreatedWorkset`, `Executing`, `ElementNukeByElementId`, `TagSignatureConverter`, `SleeveTag`, `WorksetDefaultVisibility` | `Operations/TransactionName.cs` | verb phrases. **Shown**: Undo text comes from the member name, so keep the texts. |
| locals `disconnected`, `misAligned` | `Mep/OletTapTools.cs` | `failed`, `misaligned` |
| `valveDatas`, `CreateValveDataList` | `Mep/ValveClearanceSphereTools.cs` | `valves`, `ReadValveData` |
| private `LogDimensionsAndSignatureGroupingsCore` (no transaction) | `Signatures/GeometrySignatureExtensions.cs` | `…NoInlining` or inline |
| `GetJhkServiceAbbreviation`/`GetJhkServiceName` identical switch branches | `Parameters/ParameterValueExtensions.cs` | merge the branches |
| `SpoolItem.SetTag(tagAsString)`, `IsSpoolableElement(out report)` | `Spools/SpoolItem.cs` | `tag`, `nonSpoolableReport` |
| `Spool.SetSpoolNumber` side effects; duplicate `SetLineNumber` bodies | `Spools/Spool.cs:635` | document; merge the overloads |
| loop variable `element` (a `SpoolItem`); `UpdateQualityCheckColumns` vs `Qa…` | `Spools/Spool.cs:718, 1027` | `spoolItem`; `UpdateQaColumns` (XAML) |
| private `PlaceDetailViews`/`PlaceOrthoViews`/`PlaceScheduleViews`, `…ViewModels` locals | `Spools/Spool.cs` | `CreateAndPlace…`; `…Configurations` |
| private `RunOverSpools`, `RunOverItems`, `ChangeSpoolItems`; `getType`, `spoolItemModel` locals | `Spools/SpoolTools.cs` | `InOperationForEach…`; `itemType`, `spoolItem` |
| `JhkItemNumber` (int) vs `ItemNumber.Value`; Set/Assign/Itemize | `Spools/` | `ItemNumberSequence`; one verb `Assign` (JHK parameter name stays) |
| `HangerLocation` private members with no reader | `Supports/HangerLocation.cs` | expose or remove |
| `…UpdaterAutoAdditionConfiguration` vs `…AutoUpdaterConfiguration` | `Updaters/Configurations/Auto/` | one pattern. **Shown**: `UpdaterName`/`DisplayName` derive from the type name. |
| `…UpdaterElementService` vs `…ElementService`; `FabricationPartInstancesUpdaterElementService` | `Updaters/ElementServices/` | `<Name>ElementService`, singular |
| file `AutoUpdaterConfigurationOfService.cs` holds `AutoUpdaterConfiguration<TElementService>` | `Updaters/Configurations/` | `AutoUpdaterConfiguration{T}.cs` |
| `AutoUpdaterService.Disable(Guid)`, parameter `desiredState` | `Updaters/` | `SetEnabled(Guid, bool)`, `enabled` |
| locals `filteredElementIds` (elements), `filterOneParameters`, `productCodeParam`, `serviceSignatureStored`, `rod1PoaElevationAbsolute`, `belowStructureDim`, `toStructureAbove` | `Updaters/` | `elements`, `emptyYesNoParameters`, `productCode`, `lookupSignature`, spelled out (`JhkBelowStructureDim` parameter name stays) |
| `RibbonSelections.NotRegistered`, `UpdaterFailureLog.Message`, `GetDocumentTrade(config)` | `Updaters/` | `CreateNotRegisteredException`, `FormatMessage`, `GetTradeOfConfiguration` |
| `EnsureAddInThreeDeeView`, `ThreeDeeViewName` | `Views/AddInViewExtensions.cs` | `EnsureAddIn3DView`, `AddIn3DViewName` ("KTR - 3D" shown, keep) |
| typo `jhkFiledTrimDefinition`; `ApplyBomType*` | `Views/ViewFilterSets.cs:18` | `jhkFieldTrimDefinition`; `ApplyBillOfMaterialType…` (filter names shown) |
| `ViewPortExtensions` | `Views/ViewPortExtensions.cs` | `ViewportExtensions` |
| private `AddToViewAndSetVisibility`; `SignatureViewFilterTools.Document(…)`; parameter `toolName` | `Views/` | `SetVisibilityAddingToView`, `DocumentOf`, `promptTitle` |
| two private `GetSolidPatternFill` | `Views/ViewFilterFactory.cs:181`, `FilterExtensions.cs:109` | one shared `GetSolidFillPattern` |
| private `ExportSchedule`; locals `subCategories`, `rvtLinksCat`, `…FieldId` | `Views/` | `ExportScheduleToXlsx`, `insulationSubcategory`, `…SchedulableField` |

## Dropped or downgraded
| Finding | Group | Why |
|---|---|---|
| `SpoolItem`/`ElementComponent.ConnectorOnePerimeter` | G11 | Owned by Kelly-Domain (`ISpoolItem`, `ModuleComponentModel`); the Domain reviewer reports it. |
| `ResolvePipeType` Misleading | G10 | Downgraded to Vague: XML docs state the fallback and the service lookup, and the out parameter shows it. |
| `BuiltInParameterExtensions` Misleading | G10 | Downgraded to Vague: misplaced members, not a false claim. |
| `CreateServiceSignature` vs `GetSystemSignature` Misleading | G10 | Downgraded to Style: one term per concept. |
| `TryComposeAvailableSpoolName` Misleading | G11 | Downgraded to Vague: the name and docs match the body. The out-name part is the pending Spool Name vs Spool Number decision. |
| `HasInvalidSpoolItems` → `HasNonSpoolableItems` | G11 | Dropped: it also flags items that are not top-level categories, so "Invalid" is wider than non-spoolable. |
| `CreateAndApplyFill`, `RemoveAllFilters`/`RemoveFilters`, `ViewFilterFactory`, `ApplyFieldAndModuleFilters` Misleading | G12 | Downgraded to Vague: names are true. The Core-rule gap, two names for one job and documented extras are Vague. |
| `CustomDataUpdateEvaluator` shown text (Misleading) | G12 | Merged into the confirmed bug (stale text, not a member name). |
| `GetJhkTagPrefix` vs `GetCustomData100TagNumberPrefix` | G10 | The other name lives in `Fabrication/` (part 1); left to that report. |
| Bug: `ExportKellyBindingsMarkdownReport` "Cancelled" line never saved | G10 | Documented: returns false and writes no file when there are no bindings. Dead append only. |
| Bug: `SetOffset` sets an elevation | G10 | Naming, not behaviour: moved to R1 (Vague). |
| Bug: `OletTapTools.TryConnect` leaves the branch disconnected on failure | G10 | Documented in its remarks ("there is no reconnect on failure"). |
| Bug: `PointToPipeReader.ReadTable` bad rows become run breaks | G10 | Documented on purpose (header and blank rows end a run; fix of 2026-10-13). |
| Bug: `SuspendedSupportSelectionService.AttachOrExtendToStructure` ignores the origin | G11 | Checked in the first pass: documented on purpose. |
| Bug: `HangerPlacementService.PlaceAlongStraights` has no document guard | G11 | The `OperationService` constructor throws the documented `ArgumentNullException(document)`. |
| Bug: `SpoolItem.GetHashCode` condition order | G11 | `Element` is guarded non-null in the constructor and get-only, so there is no failing case. |
| Bug: `SetBillOfMaterialType` uses `ToString` vs `ToReadableName` | G11 | Same text for every current member; no effect today. |
| Bug: `ApplyFieldAndModuleFilters` `GetFilters().Clear()` clears a copy | G12 | Documented; checked in the first pass. |
| Bug: `ViewFilterFactory.AddFilterRule` exception types | G12 | A choice of exception type, not a naming or behaviour bug. |
| Bug: `MaterialElementDataModel.Initialize` bare `NullReferenceException` | G12 | Kept on purpose (see `AddInConfiguration.IsAlternateLookupTrigger` remarks: the model "keeps that with its own null check"); the order is harmless because the trigger check is null-safe. |
