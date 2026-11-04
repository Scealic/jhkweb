# Linear Issue Splits 2026-11-04

Proposed by the `linear-issue-split-review` skill for the 15 open issues estimated at 16 points on 2026-11-04 (`Linear Estimates/2026-11-04 Linear Estimates.md`). Nothing changes in Linear until approved. The Hasa issues were split from their text only (no code here).

## Summary

| Team | Reviewed | Fine | Split | Unclear | New issues proposed | Existing issues as pieces |
|---|---|---|---|---|---|---|
| KW3 | 1 | 0 | 1 | 0 | 2 | 0 |
| KTRL5 | 3 | 0 | 3 | 0 | 16 | 0 |
| KTR5 | 8 | 0 | 7 | 1 | 36 | 0 |
| KTR4 | 1 | 0 | 1 | 0 | 9 | 0 |
| HASA | 2 | 0 | 2 | 0 | 7 | 2 |
| **Total** | 15 | 0 | 14 | 1 | 70 | 2 |

## [KW3-1](https://linear.app/jhkelly/issue/KW3-1) Repoint the layers above to the helpers moved down in round 2 (#2 to #18) (16)

- **Signals:** Split: crosses layers (nothing left in Kelly-Windows-v3: the work is in Kelly-Domain, Kelly-Revit-Logic-v5 and Kelly-Revit-v5); the Domain deletions are done (2a23679: `ObjectReference`, `DimensionType`, `FractionalLength`; #14 `VicMaterial` done) and the Logic side is done (e8dfef7: #2, #5, #6, #7, #9, #17, #18, Logic `AddInServices` deleted)
- **Shape:** mixed
- **Original keeps:** parent only ("Repoint the layers above to the helpers moved down in round 2 (#2 to #18)")

| # | Team | Title | Est. | Type | Relation | Goal | Where |
|---|---|---|---|---|---|---|---|
| 1 | KTR5 | Point to Pipe and Rotate Move: call the Kelly.Windows helpers of moves #3, #10, #11 | 2 | Change | sub-issue | replace the column-letter arithmetic with `SpreadsheetColumns`, and `ConvertToRadians` and the three hand-built `NumberFormatInfo` with `AngleExtensions` (`AngleFormat`); Kelly.Windows 3.26.1104.851 already reaches the add-in through the current UI pin | `modules/Trade.All/Commands/Acquired/Vicious/PointToPipe/ViciousFileBasedSystemPipePlaceView.xaml.cs:167-170`, `.../Rotate/ViciousInstanceRotateMoveCommand.cs:99,122`, `.../Rotate/ViciousInstanceRotateMoveView.xaml.cs:37,72` |
| 2 | KTR5 | Layout Point Export, About and App: call the Kelly.Windows helpers of moves #4, #15, #16 | 1 | Change | sub-issue | `Process.Start("explorer.exe", ...)` to `ShellTools.OpenInExplorer`, `App.LoadTelerikAssembliesBesideAddIn` to `References.LoadAssembliesInDirectory`, `ApplicationAboutViewModel.GetAddInAssembly` to `AssemblyExtensions.FindLoaded` | `modules/Trade.All/Commands/Layout/LayoutPointExport/LayoutPointToCommaSeparatedValueFileExportViewModel.cs:273`, `src/App.cs:202`, `modules/Trade.All/Commands/About/ApplicationAboutViewModel.cs:51` |

- **Existing:** KTR5-4580 (drops the `AddInServices` aliases of #9 in the host and Trade.All once Logic is repacked) - link as related (it is a sub-issue of KTRL5-1); KTRL5-1 (holds the Logic pack and UI repin that KTR5-4580 waits for) - link as related

## [KTRL5-5](https://linear.app/jhkelly/issue/KTRL5-5) Handle the open // todo notes in Kelly-Revit-Logic-v5 (16)

- **Signals:** Split: estimate 16; vague goal over a large area (45 `// todo` notes in 8 folders, not 54: the P6a/P6b commits of 2026-11-04 removed 9); several independent deliverables
- **Shape:** mixed
- **Original keeps:** parent only (title "Handle the open // todo notes in Kelly-Revit-Logic-v5"; description count updated to 45)

| # | Team | Title | Est. | Type | Relation | Goal | Where |
|---|---|---|---|---|---|---|---|
| 1 | KTRL5 | Updater element services: resolve the 23 "Implement Data Point" notes | 4 | Change | sub-issue | 13 element services still build `PlaceholderElementDataModel` and say "Implement Data Point In This Service": give each its data model or drop the notes, per the user's decision | `src/Updaters/ElementServices/*UpdaterElementService.cs` (CheckboxDefault, ContentIdentity, DetailingPackage, DetailingPhase, EndPreparation, FabricationPartInstances, FieldTrimDefault, LineNumber, ServiceOfFabricationPart, Service, SuspendedSupport, System, Weld) |
| 2 | KTRL5 | Spool: write uniform line, spool, module number and group to the assembly | 2 | Add | sub-issue | when every element of a spool has the same JhkLineNumber / JhkSpoolNumber / JhkModuleNumber / JhkModuleGroup, set it on the assembly, else leave it blank (4 notes) | `src/Spools/Spool.cs:93-96` |
| 3 | KTRL5 | Spools: type JhkTag as Tag, give IsSpoolAble a result, plan a LineNumber type | 4 | Change | sub-issue | the 3 typing notes of the spool models: `SpoolItem.JhkTag` string to `Kelly.Domain` `Tag`, `SpoolItem.IsSpoolAble` bool+StringBuilder to a TryParse/result, `ItemNumber.LineNumber` string to a LineNumber type (HVAC and piping schemas differ) | `src/Spools/SpoolItem.cs:175,221`, `src/Spools/ItemNumber.cs:25` |
| 4 | KTRL5 | SuspendedSupport: settle the 6 notes on its shape and property notifications | 2 | Change | sub-issue | make the class abstract or sealed as intended, remove the 4 `OnPropertyChanged(nameof(Signature))` calls if `SignatureHash` already raises it (test it), move `SetTag` to `PhysicalElementEntity` | `src/Supports/SuspendedSupport.cs:6,167,194,213,233,320` |
| 5 | KTRL5 | Service and System document caches: name and place them as data-store caches | 2 | Change | sub-issue | the 3 notes say `ServiceDocumentCache` is a fabrication-table cache, `SystemDocumentCache` a data-store cache and `FillFromServices` a data-store function, not parameter/document caches: rename or move them (see KTRL5-2 for the related `DataFileService` move) | `src/Caches/ServiceDocumentCache.cs:3`, `src/Caches/SystemDocumentCache.cs:4,66` |
| 6 | KTRL5 | Size data model, annotation arranger, layout point recipe: last 5 notes | 2 | Change | sub-issue | decide whether `SizeElementDataModel.Initialize` reports missing connector models / symbols / connectors (through `UserPrompt` or the operation log) or drop the 3 notes; use a scope collector in `AnnotationArranger` (line 249); clean up `LayoutPointRecipeIngredients` (line 161) | `src/Updaters/ElementDataModels/SizeElementDataModel.cs:95,108,121`, `src/Arrangement/AnnotationArranger.cs:249`, `src/LayoutPoints/LayoutPointRecipeIngredients.cs:161` |

- **Existing:** KTR5-4136 (OperationService: email the logs at every document close) covers the note at `src/Operations/OperationService.cs:433` - link as related; KTR5-4680 (v5-wide TODO item, counts this repo's notes) - link as related

## [KTRL5-3](https://linear.app/jhkelly/issue/KTRL5-3) Move the OperationService call sites to Run and Run<T> (16)

- **Signals:** Split: estimate 16; a sweep over many sites (66 sites still on Start/Stop, not 80: the 80 `new OperationService(` include the 15 already converted to Run); crosses repositories (30 sites in Kelly-Revit-Logic-v5, 36 in the Kelly-Revit-v5 modules)
- **Shape:** sub-issues
- **Original keeps:** parent only, retitled "Move the 66 remaining OperationService call sites to Run and Run<T>"; the category D sites (AnnotationArranger.Arrange, TrapezeVerticalMemberTools x2, ViciousInstanceRotateMoveCommand.RotateViewport) stay on the old pattern as `OperationService Run Migration.md` says

| # | Team | Title | Est. | Type | Relation | Goal | Where |
|---|---|---|---|---|---|---|---|
| 1 | KTRL5 | OperationService.Run: Elements, Families, Projects, Mep and Updaters sites | 2 | Change | sub-issue | move the 9 straight (category A) sites to Run/Run<T>, wrapping Run in a try/catch that reports where the catch swallows today | `GroupTools`, `PenetrationTagTools.ApplyTags`, `WorksetExtensions.SetVisibilityWithOperation`, `FamilySymbolExtensions.NewFamilyInstances2`, `ProjectInformationWrapper.Set`, `ValveClearanceSphereTools`, `ElementServiceExtensions.ProcessElementsTransaction`, `ModuleNumberElementService`, `ManualUpdaterRunner` |
| 2 | KTRL5 | OperationService.Run: Fabrication, Spools and Supports sites | 2 | Change | sub-issue | move the 7 category A sites to Run/Run<T> | `BillOfMaterialTypeAssigner.UpdateElements`, `WeldLocationService.SetEndPreparation` / `SetWeldLocation`, `ItemNumberTools`, `SpoolTools` (remove invalid product range; `ChangeSpoolItemsTransaction`), `HangerPlacementService` |
| 3 | KTRL5 | OperationService.Run: Views, Layout Points and Arrangement sites | 2 | Change | sub-issue | move the 8 category A sites to Run/Run<T> | `StratusViewTools`, `ViewExtensions` (shop filters, DWG Export, remove filters, `SetViewTemplateOperation`), `VisibilityCommon.ApplyOrCreateViewFilterTransaction`, `LayoutPointTools` (update, line ~404), `AnnotationArranger.PrepareAnnotationElements` |
| 4 | KTRL5 | OperationService.Run: decide the 3 Logic sites that commit partial work | 2 | Change | sub-issue | per site, keep the partial commit (stay on Start/Stop, note why) or roll back through Run; restructure the RollBack-plus-return in `ImportTx` first | `DocumentSchemaExtensions` (delete schemas, B), `ScheduleExportService` (B), `LayoutPointTools.ImportTx` (C) |
| 5 | KTR5 | OperationService.Run: assigner filter, Duct, Manager and Rotate Move commands | 2 | Change | sub-issue | move the 12 category A command sites to Run/Run<T> (uses the Run already in the pinned Logic package) | 8 `*ViewFilterCommand.Execute` under `modules/Trade.All/Commands/Assigners`, `DuctItemNumberResetCommand`, `DuctItemNumberSetCommand.Transaction`, `ElementDeleteCommand`, `ViciousInstanceRotateMoveCommand.RotateSelected` |
| 6 | KTR5 | OperationService.Run: Layout Point Export, Module Manage, Spool Create, Support Manager | 2 | Change | sub-issue | move the 8 category A view-model sites to Run/Run<T>; rebind only on Run's true | `LayoutPointToCommaSeparatedValueFileExportViewModel` (Reset, Save, UpdateCoordinates), `ModuleManageViewModel` (x2), `SpoolCreateViewModel` (UpdateSpoolData, UpdateSpoolName), `SuspendedSupportManagerViewModel.RunSelectionOperation` |
| 7 | KTR5 | OperationService.Run: decide Many Connect, Custom Data Updater V2, Layout Point CSV, Spool Create | 2 | Change | sub-issue | the 4 module sites that commit partial work (B) or have code after Stop (C): decide or restructure, then move to Run | `ManyConnectCommand.Transaction` (B), `FabricationCustomDataUpdaterCommandV2.Execute` (B, per-part SubTransaction), `LayoutPointToCommaSeparatedValueFileExportViewModel` export (C), `SpoolCreateViewModel.CreateSpool` (C) |

- **Existing:** KTR5-4637 (Spool Manager: a failed edit commits partial changes; its fix is the 11 try/finally sites of `SpoolManagerViewModel` moved to Run) - make it a sub-issue instead of a new piece; KTR5-4480 (OperationService: catch errors per element inside the change loops) - link as related

## [KTRL5-1](https://linear.app/jhkelly/issue/KTRL5-1) Remove this layer's copies of the code moved down on 2026-11-04 (16)

- **Signals:** Split: crosses layers (Logic pack, Kelly-Revit-UI repin, Kelly-Revit-v5 edits); estimate 16 is stale: the Logic source side is done in 9042387 (P6a) and e8dfef7 (P6b), 1026 of 1027 in Revit 2024, not yet packed
- **Shape:** sub-issues
- **Original keeps:** parent only ("Remove this layer's copies of the code moved down on 2026-11-04"); tick in Quick-Backlog with 9042387 and e8dfef7 when the pieces are done

| # | Team | Title | Est. | Type | Relation | Goal | Where |
|---|---|---|---|---|---|---|---|
| 1 | KTRL5 | CustomDataUpdateEvaluator: switch ResolveRecord to Domain TryResolveRecord (#57) | 2 | Change | sub-issue | the one move P6b skipped: `EvaluatePart`'s private `ResolveRecord` reports "Missing {identity} Error" where `Kelly.Domain` `TryResolveRecord` throws for a null dictionary; agree the null case, test it, call the Domain copy (Quick-Backlog line 11, no Linear key yet) | `src/Updaters/CustomDataUpdateEvaluator.cs` |
| 2 | KTRL5 | Pack `Kelly.Revit.Logic` with the round 2a source-side deletions (P6a, P6b) | 1 | Change | sub-issue, blocks 3 | build 2024/2025/2026 packages, date the Changelog headings, finish the uncommitted `Architecture/SourceFiles` test refactor in the working tree first | `Changelog.md`, `README.md`, `test/Revit.Logic.RevitTests/Architecture/*` |
| 3 | KTRUI | Repin `Kelly.Revit.Logic` to the package without the moved copies | 1 | Change | sub-issue, blocks KTR5-4580 | set `KellyRevitLogicVersion` (now 5.26.1104.1040) to the new package and pack UI; needs piece 2 packed; UI names none of the deleted members | `Kelly-Revit-UI/Directory.Packages.props` |

- **Existing:** KTR5-4580 (Drop the full names left by the round 2a repin once Logic deletes its copies: the `AddInServices` global aliases in `src/GlobalUsings.cs` and `Trade.All/GlobalUsings.cs`, and `LayoutPointFromCommaSeparatedValueImportViewModel.cs:220`, which names the deleted `Kelly.Revit.Logic.LayoutPoints.LayoutPointCsvFormat` and will not compile after the repin) - make it a sub-issue, blocked by piece 3

## [KTR5-4689](https://linear.app/jhkelly/issue/KTR5-4689) Implement the Unit Test Implementation plan for Kelly Tools For Revit (16)

- **Signals:** Split: estimate 16; crosses repositories (Kelly-Windows-v3, Kelly-Revit-UI, Kelly-Revit-v5); several independent deliverables (the plan's open gap lists)
- **Shape:** sub-issues
- **Original keeps:** parent only ("Implement the Unit Test Implementation plan for Kelly Tools For Revit"; Kelly-Windows-v3 13 of 16, Kelly-Domain 76 of 76 and Kelly-Revit-Logic-v5 127 of 127 are done per the plan and commit 21b00ad of the root repo; human verification of `Author` dates is a person's job and not a piece)

| # | Team | Title | Est. | Type | Relation | Goal | Where |
|---|---|---|---|---|---|---|---|
| 1 | KW3 | `ShellTools`, `ClipboardTools`, `UserPrincipalExtensions`: add seams and tests | 4 | Add | sub-issue | Test the last 3 untested Kelly-Windows-v3 types: a process-starter seam for `ShellTools.OpenInExplorer`, a clipboard seam for `ClipboardTools` (incl. `SetText(List<string>)` empty/null behaviour), a `DirectoryEntry` seam for `UserPrincipalExtensions.GetManager`/`GetTitle` | `Kelly-Windows-v3/src/Files/ShellTools.cs`, `src/Wpf/ClipboardTools.cs`, `src/Workstation/UserPrincipalExtensions.cs`; `tests/Logic.Tests.csproj`, all three configurations |
| 2 | KTRUI | Tests for the 16 untested Kelly-Revit-UI types | 4 | Add | sub-issue | Cover Commands (`CommandResultExtensions`, `IExternalCommandBase`, `IExternalCommandMvvm`), Mvvm (`IView`, `IViewModel`, `ViewModel`), Ribbon interfaces and `RibbonSplitButton`, `UiDocumentScopeExtensions`, `ConnectorPickTools`, `SelectionExtensions`; members that need a `UIDocument` get argument/contract tests only | `Kelly-Revit-UI/src/{Commands,Mvvm,Ribbon,Scope,Selection}`; `test/Revit.UI.Tests`, `test/Revit.UI.RevitTests` |
| 3 | KTR5 | Add-in host: tests for `Caches`, the 4 event handlers, `Resources`, `ApplicationSessionService` | 2 | Add | sub-issue | Test the untested host types of `src/` | `Kelly-Revit-v5/src/App/Caches.cs`, `src/EventHandlers/Document{Changed,Opened}EventHandler`, `View{Activated,Activating}EventHandler`, `src/Services/ApplicationSessionService.cs`; `test/Tests.Revit` |
| 4 | KTR5 | Trade.All assigners: tests for the combo boxes, settings and event handlers | 4 | Add | sub-issue | The 19 assigner types: `Assigner*ComboBox`, `Assigner*ComboBoxSettings`, `AssignerComboBoxPopulator`, `*ComboBoxEventHandler`, `CommonAutoAssignerTools` | `Kelly-Revit-v5/modules/Trade.All/Commands/Assigners`; needs `KellyDefinitions` stubs (add-in disabled) |
| 5 | KTR5 | Trade.All view models: Spools, Supports, Layout Points, Module Creator | 4 | Add | sub-issue | `SpoolCreateViewModel`, `SpoolManagerViewModel`, `SpoolCleanCommon`, `ModuleCreatorViewModel`, `SuspendedSupportManagerViewModel`, `LayoutPointFromCommaSeparatedValueImportViewModel`, `LayoutPointToCommaSeparatedValueFileExportViewModel`, `ContextValueAddViewModel` | `Kelly-Revit-v5/modules/Trade.All/Commands/{Spools,Supports,Layout,Assigners/ContextValueAdder}` |
| 6 | KTR5 | Trade.All other commands: Vicious, About, Arranger, Excel, updater helpers | 4 | Add | sub-issue | `Vicious*` (5 types), `ApplicationAboutModel`/`ViewModel`, `Arranger`, `ExcelInteropTools`, `AutoUpdaterPowerIcon`, `ManualUpdaterExtensions` | `Kelly-Revit-v5/modules/Trade.All/Commands/{Acquired/Vicious,...}`; overlaps KTR5-4678 (Vicious cleanup): do the Vicious tests there if that lands first |
| 7 | KTR5 | Trade.All ribbon items: tests for the 24 stacked buttons and enablers | 2 | Add | sub-issue | `*StackedButtons` (17) and the availability classes (`IsSelectionMade`, `IsTrapezeSelectedCommandEnabler`, …) beyond what `AddInContractTests` checks | `Kelly-Revit-v5/modules/Trade.All/RibbonItems` |
| 8 | KTR5 | Contenter, Developer, Duct and Pipe modules: tests for the 15 untested types | 4 | Add | sub-issue | `FabricationCustomDataUpdaterCommandV1/V2` and push buttons, `DocumentHasFabricationParts`, `IsDocumentOfTypeFamily`, Developer `Settings`, `WindowMockupViewModel`, `IsDuctItemNumberAbleViewCommandEnabler`, `ConnectOletsExternalEventHandler`, `OletCheckViewModel`, `OletCheckWindow`, `SelectionExternalEventHandler`, `WeldLocationPurpose1/2StackedButtons` | `Kelly-Revit-v5/modules/Trade.{Contenter,Developer,Duct,Pipe}` |
| 9 | KTR5 | Tests.Revit: the 4 tests that need the add-in started fail with it disabled | 1 | Fix | sub-issue | `ApplicationLoggerTests.LogWarning_WithTheAddInStarted…` and 3 `EventServiceTests` assert a started add-in, so they fail in every run with the manifest disabled; make them inconclusive or move them to a separately run fixture | `Kelly-Revit-v5/test/Tests.Revit` (plan "Known failures") |

- **Existing:** -

## [KTR5-4678](https://linear.app/jhkelly/issue/KTR5-4678) Refactor and clean up the Vicious tools (16)

- **Signals:** Split: several tools (6 Vicious commands); vague goal over a large area ("clean up"); estimate 16
- **Shape:** sub-issues
- **Original keeps:** parent only ("Refactor and clean up the Vicious tools"; 2,333 lines in `Kelly-Revit-v5/modules/Trade.All/Commands/Acquired/Vicious`)

| # | Team | Title | Est. | Type | Relation | Goal | Where |
|---|---|---|---|---|---|---|---|
| 1 | KTR5 | Vicious Point To Pipe: move the view's code-behind logic into the view model | 4 | Change | sub-issue | `ViciousFileBasedSystemPipePlaceView.xaml.cs` (351 lines) reads/saves settings, converts units and lists pipe types in the code-behind; move that to `ViciousFileBasedSystemPipePlaceViewModel` with tests | `Acquired/Vicious/PointToPipe/ViciousFileBasedSystemPipePlaceView.xaml.cs`, `…ViewModel.cs`; settings types in `Kelly-Domain/src/Pcf` |
| 2 | KTR5 | Vicious Point To Pipe: break up `ViciousFileBasedSystemPipePlaceTools` | 4 | Change | sub-issue | Split the 525-line tools class by responsibility (file reading, point conversion, pipe creation) and route the pipe creation through `OperationService` | `Acquired/Vicious/PointToPipe/ViciousFileBasedSystemPipePlaceTools.cs` |
| 3 | KTR5 | Vicious Straights Racker: clean up `ViciousInstanceElevationAssignViewModel` | 4 | Change | sub-issue | 346-line view model with prompts (`TaskDialog`) and element moves inline; separate the elevation logic from the prompts, test it | `Acquired/Vicious/Racker/ViciousInstanceElevationAssignViewModel.cs` |
| 4 | KTR5 | Vicious Instance Rotate Move: clean up the command | 4 | Change | sub-issue | 267-line command holding state, two raw `GetTransaction()` uses and a bare `catch`; move the rotate/viewport logic out of the command, use `OperationService.Run` | `Acquired/Vicious/Rotate/ViciousInstanceRotateMoveCommand.cs`, `ViciousInstanceRotateMoveView.xaml.cs` |
| 5 | KTR5 | Vicious Fabrication Hanger Place: clean up command and options window | 2 | Change | sub-issue | Bare `catch` in the command; options window code-behind (118 lines) to a view model; logic already in Logic `HangerPlacementService` | `Acquired/Vicious/HangerPlace/*`; `Kelly-Revit-Logic-v5/src/Supports/HangerPlacementService.cs` |
| 6 | KTR5 | Vicious Instance Level Assign and Instance Disconnect: clean up | 2 | Change | sub-issue | Two small tools (95-line view model, 68-line command); align with the MVVM pattern of the others and test | `Acquired/Vicious/Level/*`, `Acquired/Vicious/Disconnect/*` |

- **Existing:** KTR5-3786, KTR5-4043, KTR5-4042, KTR5-4448, KTR5-3784, KTR5-3785 (feature/fix issues on the same tools: related, not pieces); KD-4, KD-8 (Vicious settings in Kelly-Domain, related)

## [KTR5-3827](https://linear.app/jhkelly/issue/KTR5-3827) Tool to create an offset in a pipe run (16)

- **Signals:** Split: crosses layers (Kelly-Domain geometry, Kelly-Revit-Logic-v5 creation, Kelly-Revit-v5 command); several deliverables (lateral, vertical, rolling; MEP pipe and possibly fabrication); estimate 16
- **Shape:** sub-issues
- **Original keeps:** parent only ("Pipe Offset Create: make lateral, vertical and rolling offsets in one step"); no offset code exists in any layer today

| # | Team | Title | Est. | Type | Relation | Goal | Where |
|---|---|---|---|---|---|---|---|
| 1 | KD | Pipe offset geometry: points for lateral, vertical and rolling offsets | 4 | Add | sub-issue, blocks 2 and 3 | Revit-free calculation of the offset path (start, fitting points, end) from a run direction, offset distances and fitting angle, with tests in all three configurations | `Kelly-Domain/src` (new folder, e.g. `Piping`), using Kelly-Windows `Point3` |
| 2 | KTRL5 | Pipe offset: create the offset in an MEP pipe run | 4 | Add | sub-issue, blocks 4 | Split the picked pipe, create the segments and elbows (`Pipe.Create`, `NewElbowFitting`) from piece 1's points inside one `OperationService.Run`; needs the Kelly-Domain package packed and repinned | `Kelly-Revit-Logic-v5/src/Mep` |
| 3 | KTRL5 | Pipe offset: create the offset in a fabrication part run | 4 | Add | sub-issue, blocks 4 | Same for fabrication pipework (fabrication straights and elbows from the part's service); test on the Kelly test project | `Kelly-Revit-Logic-v5/src/Fabrication` |
| 4 | KTR5 | Pipe Offset Create: command, window and push button in Trade.Pipe | 4 | Add | sub-issue | Pick the pipe and point, choose lateral/vertical/rolling and distances, call piece 2/3; needs the Logic package packed and repinned | `Kelly-Revit-v5/modules/Trade.Pipe/Commands/PipeOffsetCreate` (new), ribbon item |

- **Existing:** -

## [KTR5-4170](https://linear.app/jhkelly/issue/KTR5-4170) Implement IEqualityComparer<object>() in place of "Signature" (16)

- **Signals:** Split: crosses layers (Kelly-Domain `SupportTagNumbering`, Kelly-Revit-Logic-v5 support and part types, Kelly-Revit-v5 tools); several types (one comparer each); estimate 16
- **Shape:** sub-issues
- **Original keeps:** parent only ("Signatures: compare parts with an IEqualityComparer instead of the geometry signature string"). Note from the code: `GeometrySignatureExtensions.GetGeometrySignature` is used only by Contenter's Fabrication Part Dimension Log; the Suspended Support Manager's Match column uses `SuspendedSupport.SignatureHash` (SHA-256 of `Signature`, which joins each `VerticalSupportMember.Signature`), also written to JHK Tag Signature and compared with the stored value in `SignatureStatus`

| # | Team | Title | Est. | Type | Relation | Goal | Where |
|---|---|---|---|---|---|---|---|
| 1 | KD | `SupportTagNumbering.NextTag`: find identical supports with an `IEqualityComparer<T>` | 2 | Change | sub-issue, blocks 3 | Overload (or replace) the `hashOf` string parameter with a comparer, tests in all three configurations | `Kelly-Domain/src/Supports/SupportTagNumbering.cs` |
| 2 | KTRL5 | `VerticalSupportMemberComparer` | 2 | Add | sub-issue, blocks 3 | Compares the 7 properties `Signature` joins (size, lengths, elevations, offsets); also avoids the `NullReferenceException` `Signature` throws while `Size` is unset | `Kelly-Revit-Logic-v5/src/Supports/VerticalSupportMember.cs` (new `Signatures/VerticalSupportMemberComparer.cs`) |
| 3 | KTRL5 | `SuspendedSupportComparer`: use it in `GetNextTag` and the signature-tag match grouping | 4 | Change | sub-issue, blocks 5 | Compares tag prefix, long description, bearer type and size, host size and the members (piece 2); `GetNextTag` and `SetSignatureTagPairMatch`'s `GroupBy(SignatureHash)` use it; same results as before, tested on the Kelly test project; needs the Kelly-Domain package packed and repinned | `Kelly-Revit-Logic-v5/src/Supports/SuspendedSupport.cs` |
| 4 | KTRL5 | `FabricationPartGeometryComparer` | 2 | Add | sub-issue, blocks 5 | Compares long description, size and dimension values as `GetGeometrySignature` does, without the culture-dependent string | `Kelly-Revit-Logic-v5/src/Signatures/GeometrySignatureExtensions.cs` |
| 5 | KTR5 | Fabrication Part Dimension Log and Suspended Support Manager: use the comparers | 2 | Change | sub-issue | Group the logged parts with piece 4's comparer; check the manager's Matched/Not Matched filters give the same rows; needs the Logic package packed and repinned | `Kelly-Revit-v5/modules/Trade.Contenter/Commands/PartDimensionExport/FabricationPartDimensionLogCommand.cs`, `modules/Trade.All/Commands/Supports/SuspendedSupportManage` |

- **Existing:** KTR5-3277 (Suspended Support Manager: Match column shows true when nothing matches; related, touches the same grouping); KD-7 (service/system signatures; out of scope, related)

## [KTR5-3144](https://linear.app/jhkelly/issue/KTR5-3144) Assembly Creator: nudge family instances so assembly creation does not fail (16)

- **Signals:** Split: crosses layers (the assembly is created in Kelly-Revit-Logic-v5 `Spool` constructor, the tool in Kelly-Revit-v5); estimate 16 mostly uncertainty (the description's "next step" is to reproduce)
- **Shape:** sub-issues
- **Original keeps:** parent only ("Spool Creator V1: nudge family instances so assembly creation doesn't fail"). A 2025-03-06 comment says a 1/32" geometry change was enough for Revit to treat the new assembly as unique; no nudge code exists today

| # | Team | Title | Est. | Type | Relation | Goal | Where |
|---|---|---|---|---|---|---|---|
| 1 | KTR5 | Spool Creator V1: reproduce the assembly creation failure on family instances | 1 | Fix | sub-issue, blocks 2 | Find which families fail and the Revit error (`AssemblyInstance.Create` returns null / duplicate assembly), on the Kelly test project; compare with KTR5-4512 (Done, single-element assemblies Revit thinks are duplicates) | `Kelly-Revit-v5/modules/Trade.All/Commands/Spools/SpoolCreate/SpoolCreateViewModel.cs` (`new Spool(...)`) |
| 2 | KTRL5 | `Spool`: nudge family instances 1/32" before `AssemblyInstance.Create` | 2 | Change | sub-issue, blocks 3 | Move each family instance by a negligible vector (and back, if the user wants geometry unchanged) in the same transaction before creating the assembly; test on the Kelly test project | `Kelly-Revit-Logic-v5/src/Spools/Spool.cs` (constructor `Spool(List<Element>, Document)`) |
| 3 | KTR5 | Spool Creator V1: repin and verify on the failing families | 1 | Change | sub-issue | Needs the Logic package packed and repinned; check piece 1's case now creates the assembly | `Kelly-Revit-v5` `Directory.Packages.props`, Spool Creator |

- **Existing:** KTR5-4512 (Done; check whether it already fixed this before piece 2)

## [KTR5-3279](https://linear.app/jhkelly/issue/KTR5-3279) Suspended Support Manager: better property validation (16)

- **Signals:** Split: crosses layers (Kelly-Revit-Logic-v5 `SuspendedSupport` model, Kelly-Revit-v5 grid); estimate 16
- **Shape:** sub-issues
- **Original keeps:** parent only ("Suspended Support Manager: row validation like the Module Manager's"). From the code: the Module Manager's system is Kelly-Windows `Persistence/ModelBase` (`INotifyDataErrorInfo` + DataAnnotations, `Validate(propertyName, value)`), used by `Spool`, `SpoolItem`, `ElementComponent`; `SuspendedSupport` derives from `PhysicalElementEntity` (its only subclass), already carries `[Bool]` and `[TagSignatureNotMisMatch]` attributes, but nothing evaluates them; the manager's XAML has no `ValidatesOnDataErrors`

| # | Team | Title | Est. | Type | Relation | Goal | Where |
|---|---|---|---|---|---|---|---|
| 1 | KTRL5 | `PhysicalElementEntity`: report property errors through `ModelBase` | 4 | Change | sub-issue, blocks 3 | Derive `PhysicalElementEntity` from Kelly-Windows `ModelBase` (or implement `INotifyDataErrorInfo` the same way) so `SuspendedSupport` validates on set; tests | `Kelly-Revit-Logic-v5/src/Entities/PhysicalElementEntity.cs`, `src/Supports/SuspendedSupport.cs` |
| 2 | KTRL5 | `SuspendedSupport` and `VerticalSupportMember`: validation rules for the editable properties | 2 | Add | sub-issue, blocks 3 | Attributes (or rules) for the properties the user names, evaluated by piece 1; tests per rule | `Kelly-Revit-Logic-v5/src/Supports/SuspendedSupport.cs`, `VerticalSupportMember.cs` |
| 3 | KTR5 | Suspended Support Manager: mark rows with invalid properties | 2 | Add | sub-issue | `ValidatesOnDataErrors` on the columns, a row marker and filter like Module Manager's "Has Invalid Spool Items"; needs the Logic package packed and repinned | `Kelly-Revit-v5/modules/Trade.All/Commands/Supports/SuspendedSupportManage/SuspendedSupportManageView.xaml`, `SuspendedSupportManagerViewModel.cs` |

- **Existing:** KTR5-2967 (validation for all tools; related, already linked)

## [KTR5-4480](https://linear.app/jhkelly/issue/KTR5-4480) Operation/Project Bar implementations (per-element catch) (16)

- **Signals:** Split: sweep over many sites (80 `new OperationService(` sites: 44 in Kelly-Revit-Logic-v5/src, 36 in Kelly-Revit-v5/modules); crosses layers; estimate 16
- **Shape:** sub-issues
- **Original keeps:** parent only ("OperationService: catch errors per element inside the change loops"). `ElementChangeError` already exists in Logic (`src/Elements/ElementChangeError.cs`) and Contenter `FabricationCustomDataUpdaterCommandV2` already follows the pattern; KTRL5-3 migrates the same 80 sites to `Run`, which rolls back on a throw

| # | Team | Title | Est. | Type | Relation | Goal | Where |
|---|---|---|---|---|---|---|---|
| 1 | KTRL5 | `OperationService`: per-element loop helper that logs and skips a failed element | 4 | Add | sub-issue, blocks 2–6 | One helper (e.g. `ForEachElement(items, idOf, work, progress)`) that catches per element, records an `ElementChangeError`, calls `LoopSkipped`/`Increment`, and returns the errors; tests | `Kelly-Revit-Logic-v5/src/Operations/OperationService.cs`, `src/Elements/ElementChangeError.cs` |
| 2 | KTRL5 | Per-element catch in the Logic change loops: Elements, Fabrication, Spools, Supports, Updaters | 4 | Change | sub-issue | Apply piece 1 in the loops of those folders (about 12 sites) | `Kelly-Revit-Logic-v5/src/{Elements,Fabrication,Spools,Supports,Updaters}` |
| 3 | KTRL5 | Per-element catch in the other Logic change loops: Views, Documents, Families, Layout Points, MEP, … | 4 | Change | sub-issue | The remaining Logic sites with an element loop | `Kelly-Revit-Logic-v5/src/{Views,Documents,Families,LayoutPoints,Mep,Projects,Connectors,Arrangement}` |
| 4 | KTR5 | Per-element catch in the Trade.All color filter assigners | 2 | Change | sub-issue | The 7 `LineColorFilterAssign`/`FillColorFilterAssign` commands share one shape; needs the Logic package packed and repinned | `Kelly-Revit-v5/modules/Trade.All/Commands/Assigners/*Context/*ColorFilterAssign` |
| 5 | KTR5 | Per-element catch in the spool and support managers | 4 | Change | sub-issue | `SpoolManagerViewModel` (11 try/finally-Stop blocks), `SpoolCreateViewModel`, `ModuleManageViewModel`, `SuspendedSupportManagerViewModel` | `Kelly-Revit-v5/modules/Trade.All/Commands/{Spools,Supports}` |
| 6 | KTR5 | Per-element catch in the remaining module commands | 2 | Change | sub-issue | Many Connect, Layout Point Export, Vicious Rotate, Duct Item Number Set/Reset, Manager Delete By Id | `Kelly-Revit-v5/modules/Trade.All/Commands/{ManyConnect,Layout/LayoutPointExport,Acquired/Vicious/Rotate}`, `Trade.Duct/Commands/DuctItemNumber{Set,Reset}`, `Trade.Manager/Commands/DeleteById` |

- **Existing:** KTRL5-3 (Move the 80 OperationService call sites to Run; same sites, related: do each site's per-element catch and its `Run` move together); KTR5-4637 (Spool Manager: a failed edit commits partial changes; related to piece 5); KTR5-4136, KTR5-4581 (already related)

## [KTR4-18](https://linear.app/jhkelly/issue/KTR4-18) Are there any TODO notes that can be handled? (16)

- **Signals:** Split: estimate 16; vague goal over a large area (122 `// todo` notes in about 60 files); several independent deliverables
- **Shape:** sub-issues
- **Original keeps:** parent only ("Are there any TODO notes that can be handled?"); no tests in the v4 Revit repos, so each piece is checked by build and in Revit

| # | Team | Title | Est. | Type | Relation | Goal | Where |
|---|---|---|---|---|---|---|---|
| 1 | KTR4 | Assigner combo boxes: one base class for the six, ComboBoxExtensions as a helper | 4 | Change | sub-issue | the 18 "Refactor into base class" notes (3 in each assigner combo box) and the 6 "Not actually an extension method" notes | `src/Documents/Commands/MultiTrade/Assigners/*Context/ComboBox/Assigner*ComboBox.cs`, `src/Application/RibbonItems/ComboBoxExtensions.cs` |
| 2 | KTR4 | Assigner view-filter commands: share their common code | 2 | Change | sub-issue | the 7 "Find common code among all ViewFilterApplyBy commands" notes | `src/Documents/Commands/MultiTrade/Assigners/*Context/*ColorFilterAssign/*ViewFilterCommand.cs` |
| 3 | KTR4 | Vicious commands, Arranger, Spool Sheet Open: scope collector and refactor notes | 4 | Change | sub-issue | 15 notes: "Implement Scope Collector Class" (Arranger x2, Disconnect, Level Assign, Rotate Move, Spool Sheet Open), "All Vicious commands should be refactored" (6 commands), Point to Pipe's catch use (x2) and its JSON settings file | `src/Documents/Commands/Acquired/**`, `src/Documents/Commands/MultiTrade/SpoolSheetOpen/SpoolSheetOpenCommand.cs` |
| 4 | KTR4 | Layout Point, Spool Manager, Support Manager, Weld Location, Duct and User Report notes | 4 | Change | sub-issue | 17 command notes: Layout Point Export (3) and Import (4, button-content checks, view knows the document), Spool Manager (2), Suspended Support Manager duplicate of the rod-extend Execute (1), a proper availability class for the 5 Weld Location Set commands, Duct Item Number Set to OperationService (1), User Report generalisation (1) | `src/Documents/Commands/MultiTrade/LayoutPoint*`, `.../SpoolManager/SpoolManagerViewModel.cs`, `.../SuspendedSupportManage/SuspendedSupportManagerViewModel.cs`, `src/Documents/Commands/Piping/WeldLocationAssign/*`, `src/Documents/Commands/Duct/DuctItemNumberSet`, `src/Documents/Commands/Developer/UserReport` |
| 5 | KTR4 | Updater element services: resolve the "Implement Data Point" notes, merge the Service pair | 4 | Change | sub-issue | 25 "Implement Data Point In This Service" notes in 13 services and the 2 notes to combine `ServiceUpdaterElementService` with `ServiceOfFabricationPartElementService`; same decision as the v5 piece of KTRL5-5 | `src/Documents/Services/ElementServices/**` |
| 6 | KTR4 | Spool and support models: the 14 notes | 4 | Change | sub-issue | `SuspendedSupport` (6: abstract/sealed, 4 redundant `OnPropertyChanged`, `SetTag`), `Spool` (4: uniform values to the assembly), `SpoolItem` (2: `JhkTag` as `Tag`, `IsSpoolAble` result), `ItemNumber` (LineNumber type), `LayoutPointRecipe` (1) | `src/Common/Modelle/Supports/SuspendedSupport.cs`, `src/Common/Modelle/Spool.cs`, `SpoolItem.cs`, `ItemNumber.cs`, `LayoutPointRecipe.cs` |
| 7 | KTR4 | Caches, material tools, sessions, error model, size model: the 14 notes | 2 | Change | sub-issue | `SystemDocumentCache` (3, incl. "include Discipline to get the right record?") and `ServiceDocumentCache` (1), `MaterialTools` duplicate Create (2), `ErrorModel` (2), `ApplicationSession`/`DocumentSession` to a JSON file (2), `SizeElementDataModel` notify (3), `ManualUpdaterConfiguration` dispose (1) | `src/Documents/Caches/*`, `src/Common/Werkzeuge/MaterialTools.cs`, `src/Common/Modelle/**`, `src/Common/Basisklassen/ManualUpdaterConfiguration.cs` |
| 8 | KTRL4 | ElementExtensions: add GetLengthInFeet, GetNominalSize, GetWeight, ResetValuesTransaction | 2 | Change | sub-issue, blocks 9 | the 4 "Migrate to Kelly.Revit.Logic.ElementExtensions" notes: none of the four exists in Kelly-Revit-Logic-v4 yet; add them there and pack | `Kelly-Revit-Logic-v4/src` ElementExtensions; source `Kelly-Revit-v4/src/Common/Extensions/ElementExtensions.cs:11,44,97,127` |
| 9 | KTR4 | ElementExtensions: call the Logic copies and delete the add-in's four | 1 | Change | sub-issue | after the Kelly-Revit-Logic-v4 package with piece 8 is packed and repinned, repoint the callers and delete the local members | `src/Common/Extensions/ElementExtensions.cs` |

- **Existing:** - (v4 counterparts: KTRL5-5 pieces 1, 2, 3, 4, 5 and 6 cover the same notes in v5 - link each v4 piece as related to its v5 piece)

## [HASA-71](https://linear.app/jhkelly/issue/HASA-71) Other ways to view the data: mind map, area â noun â task, task â noun â area (16)

- **Signals:** Split (text only): several independent deliverables (three views in one title), estimate at the top of the scale (16), several platforms (Web, Blazor, Mac, iOS)
- **Shape:** sub-issues
- **Original keeps:** parent only (title and goal unchanged; estimate removed, rolled up from the sub-issues). Mac (HASAO) and iOS (HASAI) pieces are added when scheduled, as the issue says.

| # | Team | Title | Est. | Type | Relation | Goal | Where |
|---|---|---|---|---|---|---|---|
| 1 | HASAW | Web: outline view area → noun → task | 4 | Frontend | sub-issue of HASA-71 | A read-only outline from each area down through its nouns (and components) to their tasks, expand and collapse per level | React web app: new view and its sidebar or menu entry, reading the loaded workspace (areas, nouns, tasks) |
| 2 | HASAW | Web: task view grouped by noun and area | 2 | Frontend | sub-issue of HASA-71 | A task list where each task shows (or is grouped under) its noun and area; starts from tasks, the reverse of piece 1 | React web app: new view beside Today/Upcoming, reusing the existing task row |
| 3 | HASAW | Web: mind map view of areas, nouns and components | 4 | Frontend | sub-issue of HASA-71 | A read-only branching diagram of areas → nouns → components; pick and add a diagram or graph library; pan and zoom | React web app: new view and the library dependency |
| 4 | HASAWB | Blazor: outline view area → noun → task | 4 | Frontend | sub-issue of HASA-71 | Same as piece 1 in the Blazor Server app (parity rule of HASA-62) | `blazor/`: new page, data from load_workspace |
| 5 | HASAWB | Blazor: task view grouped by noun and area | 2 | Frontend | sub-issue of HASA-71 | Same as piece 2 in the Blazor app | `blazor/`: new page reusing the task row component |
| 6 | HASAWB | Blazor: mind map view of areas, nouns and components | 4 | Frontend | sub-issue of HASA-71 | Same as piece 3 in the Blazor app (a JS diagram library through interop, or SVG rendered in C#) | `blazor/`: new page |

- **Existing:** HASA-63 (Print any view; already related, stays related, covers printing the mind map). No existing issue covers any view.

## [HASA-62](https://linear.app/jhkelly/issue/HASA-62) A parallel web app built with .NET Blazor (16)

- **Signals:** Split (text only): estimate at the top of the scale (16), several deliverables (project setup, sign-in, every screen, hosting, comparison), mostly already split into HASAWB-1 to HASAWB-15 but only as related issues or none
- **Shape:** sub-issues (link existing; one new piece)
- **Original keeps:** parent only (title and goal unchanged; estimate removed). Its open work is hosting (HASAWB-14), the comparison (HASAWB-15) and closing parity gaps; the "every new feature also gets a HASAWB issue" rule stays a process rule, done per feature under that feature's own Hasa parent (as HASAWB-19 under HASA-69), not here.

| # | Team | Title | Est. | Type | Relation | Goal | Where |
|---|---|---|---|---|---|---|---|
| 1 | HASAWB | Blazor parity check against the React app | 2 | Product | sub-issue of HASA-62 | Go through the React app's screens and features, list what the Blazor app lacks, and file one HASAWB issue (under its Hasa feature parent) for each gap; HASA-62 is done when this list is empty and HASAWB-14 and HASAWB-15 are done | Both web apps; the HASAW and HASAWB issue lists |
| 2 | HASAWB-14 | Host the Blazor app on everleap.com | (existing, In Progress, own sub-issues HASAWB-23 to HASAWB-27) | Dev Environment | make sub-issue of HASA-62 | - |  |
| 3 | HASAWB-15 | Compare Blazor and React: measure and write up | (existing, 4, In Progress) | Product | make sub-issue of HASA-62 (now only related) | - |  |

- **Existing:** HASAWB-14 and HASAWB-15 (open, make sub-issues). Done and covering pieces of the original: HASAWB-1 (now related), HASAWB-2 to HASAWB-13 (no link to HASA-62), HASAWB-22. Open Blazor feature pieces already under other Hasa parents and left there: HASAWB-19 (HASA-69), HASAWB-32 (HASA-59).

## Unclear (run `linear-issue-info-review` first)

| Key | Title | Why |
|---|---|---|
| [KTR5-4679](https://linear.app/jhkelly/issue/KTR5-4679) | Run the IA Prompt architectural analysis and cleanup | the issue is only a pointer to `C:\repo\jhkweb\IA Prompt - Architectural Analysis and Cleanup.md`, which is not in `C:\repo\jhkweb` (rechecked 2026-11-04 by this review too: no `IA Prompt*` file at the root); without it there is no scope to split. Related work already exists: `kelly-layer-moves`, `kelly-solid-check`, KTR5-4584 (Done), KTRL5-1, KTRL5-3 |

## Open questions

- KW3-1: The other 27 Kelly-Revit-sourced moves of round 2a (#19 to #31 `ValidateRequirements` in 13 views, and the Domain moves #37, #42 to #45, #56, #59 to #61, #73 to #76, #80) have no Linear issue: file them as standalone KTR5 issues now?
- KTRL5-5: What should "Implement Data Point In This Service" mean for the 13 updater element services: give each a real element data model, or delete the notes?
- KTRL5-3: Should the module pieces (5 to 7) run before round 2b moves their transactions into Kelly-Revit-Logic (e.g. move #97 ManyConnectCommand.Transaction), or wait and convert them there?
- KTR5-4689: KTR5-4689 (Unit Test Implementation plan): for the 4 Tests.Revit tests that need the add-in started, should they become inconclusive (`Assume.That`) when the add-in has not started (drafted), or move to a fixture run separately with the add-in loaded?
- KTR5-4679: KTR5-4679 (IA Prompt architectural analysis): where is the "IA Prompt - Architectural Analysis and Cleanup" file, or is this covered by the layer-moves and SOLID-check skills and can be Canceled?
- KTR5-4678: KTR5-4678 (Vicious tools cleanup): should the same cleanup be done in v4 (`Kelly-Revit-v4/src/Documents/Commands/Acquired/Vicious`, the same 6 tools) as a standalone KTR4 issue related to this one (drafted: no, v5 only), and is "clean" the MVVM + `OperationService.Run` pattern of the Module Manager (drafted: yes)?
- KTR5-3827: KTR5-3827 (Pipe Offset Create): fabrication parts, MEP pipes, or both (drafted: both, so pieces 2 and 3; drop one if not), and is the fitting angle fixed at 45° or chosen by the user?
- KTR5-4170: KTR5-4170 (Signatures to IEqualityComparer): the support's `SignatureHash` is also stored in JHK Tag Signature and compared with the live one (`SignatureStatus`), which a comparer cannot replace; keep the hash for the stored signature and its status and use comparers only for in-memory matching (drafted), or replace the stored signature too?
- KTR5-3144: KTR5-3144 (Spool Creator V1 nudge): should the nudge stay (the instances end 1/32" off, which made the assembly unique per the 2025-03-06 comment) or be moved back after the assembly is created (drafted: stay, since moving back restores the duplicate geometry)?
- KTR5-3279: KTR5-3279 (Suspended Support Manager validation): which properties should fail validation and on what rule (drafted: the existing two, "vertical member sizes not set" and "tag signature mismatch", plus any the user names)?
- KTR5-4480: KTR5-4480 (OperationService per-element catch): when some elements fail, commit the elements that succeeded and report the failed ones (drafted, as `FabricationCustomDataUpdaterCommandV2` does), or roll the whole operation back as `Run` does?
- KTR4-18: Should the v4 notes be handled in v4 at all, or only those with a v5 counterpart, done in both at once?
- HASA-71: Are the three views read-only for now (as drafted), or should editing in them be a further piece? Do they include completed tasks? Should the Mac and iOS pieces be created now instead of when scheduled?
- HASA-62: Should the Done HASAWB-1 to HASAWB-13 (and HASAWB-22) also become sub-issues of HASA-62 for the record, or stay as they are? Is HASA-62 done when parity and hosting are reached (as drafted), or does it stay open while both web apps exist?

## Answers (2026-11-04)

The user's answers to the open questions; every question not listed here takes the drafted reading.

- KTR5-4679: Cancel it (covered by the layer-moves and SOLID-check skills).
- KTR5-3827: both MEP pipes and fabrication parts; the user picks the fitting angle.
- KTR4-18: all 9 v4 pieces, each related to its v5 counterpart in KTRL5-5.
- KW3-1: file the 27 other Kelly-Revit-sourced round 2a moves as standalone KTR5 issues related to KW3-1, grouped by seam.
- KTR5-4480: commit the elements that succeeded and report the failed ones.
- KTRL5-3: the KTR5 module pieces wait for round 2b (blocked-by note), so each site is converted once in Logic.
- KTR5-4170: keep the stored `SignatureHash` and its status; comparers only for in-memory matching.
- KTR5-4678: v5 only.
