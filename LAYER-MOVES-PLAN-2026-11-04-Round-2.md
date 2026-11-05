# Layer moves plan - 2026-11-04 Round 2

The second layer-moves run of 2026-11-04, on `develop` after round 1 (`LAYER-MOVES-PLAN-2026-11-04.md`) was pushed. The analysis read 1129 files in 17 scopes with 54 agents: 329 moves proposed, 302 kept by the adversarial review (56 of them with changes), 27 rejected. Nothing has changed in the repos yet.

## Summary

| Target layer | Moves | Packages | Low / medium risk |
|---|---|---|---|
| Kelly-Windows-Data | 2 | 1 | 2 / 0 |
| Kelly-Windows | 23 | 1 | 18 / 5 |
| Kelly-Domain | 69 | 4 | 67 / 2 |
| Kelly-Revit-Logic | 134 | 7 | 118 / 16 |
| Kelly-Revit-UI | 68 | 3 | 50 / 18 |
| Kelly-Revit | 6 | 1 | 4 / 2 |

- No high-risk move, no upward move, no public type renamed in a persisted form found by the review. 300 of the 302 are type or member extractions (code edits, so not compile-probed); the two whole-file moves compiled in their target (`ApplicationSession` into Kelly-Windows `Hosting`, the `NumberableSpoolItemBuiltInCategorySet` file rename in Kelly-Revit-Logic).
- Every move whose source is above its target gets a source package in the source layer: 25 in all.
- Linear: one project, **Layer Moves 2026-11-04 Round 2**, with 42 issues: KWD3 1, KW3 1, KD 6, KTRL5 12, KTRUI 6, KTR5 16 (one per package, one sub-issue per source package).

## Moves by target layer

### Kelly-Windows-Data (work package P1a-data-services, Linear team KWD3)

Source packages: Kelly-Domain (KD).

| # | Source | Symbol | Into | Kind | Risk | Review |
|---|---|---|---|---|---|---|
| #1 | Kelly-Domain `src/Data/DataStore.cs` | `DataStore.FirstByKey` | `src/Services` | member | low | accept |
| #2 | Kelly-Domain `src/Data/DataStore.cs` | `DataStore.BySqlKeys` | `src/Services` | member | low | accept |

### Kelly-Windows (work package P2a-windows-collections-files, Linear team KW3)

Source packages: Kelly-Domain (KD), Kelly-Revit-Logic (KTRL5), Kelly-Revit (KTR5).

| # | Source | Symbol | Into | Kind | Risk | Review |
|---|---|---|---|---|---|---|
| #3 | Kelly-Revit-Logic `src/Connectors/ConnectorTools.cs` | `ConnectorTools.GetConnectedRun (breadth-first shortest path and path reconstruction)` | `src/Collections` | member | medium | accept |
| #4 | Kelly-Revit-Logic `src/Common/PathExtensions.cs` | `PathExtensions.GetDirectoryInfo and PathExtensions.DeleteIfEmpty (private)` | `src/Files` | member | low | accept |
| #5 | Kelly-Revit-Logic `src/Documents/DocumentExtensions.cs` | `DocumentExtensions.GetFileStore (local and network drive classification)` | `src/Files` | member | low | modify |
| #6 | Kelly-Windows `src/Files/FileServices.cs` | `FileServices.OpenFile` | `src/Files` | member | low | accept |
| #7 | Kelly-Windows `src/Logging/LoggerServices.cs` | `LoggerServices.OpenFile` | `src/Files` | member | low | accept |
| #8 | Kelly-Windows `src/Text/StringBuilderExtensions.cs` | `StringBuilderExtensions.Write (open file branch)` | `src/Files` | member | low | accept |
| #9 | Kelly-Windows `src/Text/StringExtensions.cs` | `StringExtensions.FileName` | `src/Files` | member | low | accept |
| #10 | Kelly-Revit `modules/Trade.All/Commands/ScheduleExport/ViewScheduleExportToXlsxFile/ViewScheduleToExcelFileExportCommand.cs` | `ViewScheduleToExcelFileExportCommand.ExportSchedule (indexed worksheet name)` | `src/Files/Xlsx` | member | low | modify |
| #11 | Kelly-Domain `src/LayoutPoints/LayoutPointStorage.cs` | `LayoutPointStorage.TryParseCoordinate` | `src/Geometry` | member | low | accept |
| #12 | Kelly-Revit-Logic `src/Geometry/CoordinateExtensions.cs` | `CoordinateExtensions.TryParse(string, out XYZ)` | `src/Geometry` | member | low | accept |
| #13 | Kelly-Revit-Logic `src/Geometry/CoordinateExtensions.cs` | `CoordinateExtensions.TryParse` | `src/Geometry` | member | low | modify |
| #14 | Kelly-Domain `src/Projects/ApplicationSession.cs` | `ApplicationSession` | `src/Hosting` | file | medium | accept |
| #15 | Kelly-Revit-Logic `src/Connectors/ConnectorTools.cs` | `ConnectorTools.GetAngleBetweenDegrees (clamp, Acos, radians to degrees)` | `src/Measurements` | member | low | accept |
| #16 | Kelly-Revit-Logic `src/Elements/ElementExtensionsJhk.cs` | `ElementExtensions.GetWeight (kilograms to pounds, factor 2.2046226218)` | `src/Measurements` | member | low | accept |
| #17 | Kelly-Domain `src/Pcf/VicMaterial.cs` | `VicMaterial.ColorName` | `src/Palettes` | member | low | accept |
| #18 | Kelly-Domain `src/Pcf/VicMaterial.cs` | `VicMaterial.ColorName / VicMaterial.GetColorName` | `src/Palettes` | member | low | accept |
| #19 | Kelly-Domain `src/Caches/ExternalParameterDefinitionCache.cs` | `ExternalParameterDefinitionCache.GetData / FillCache / ClearCache` | `src/Persistence` | member | medium | modify |
| #20 | Kelly-Revit `modules/Trade.All/Commands/Acquired/Vicious/HangerPlace/ViciousFabricationHangerInstancePlaceCommand.cs` | `ViciousFabricationHangerInstancePlaceCommand.Execute (TaskDialog.Show calls)` | `src/Prompts` | member | low | accept |
| #21 | Kelly-Revit `modules/Trade.All/Commands/Acquired/Vicious/PointToPipe/ViciousFileBasedSystemPipePlaceTools.cs` | `ViciousFileBasedSystemPipePlaceTools.ShowMessage` | `src/Prompts` | member | low | modify |
| #22 | Kelly-Revit `modules/Trade.All/Commands/Acquired/Vicious/Racker/ViciousInstanceElevationAssignViewModel.cs` | `ViciousInstanceElevationAssignViewModel.ElementsOfMultipleLevelsSelected` | `src/Prompts` | member | low | modify |
| #23 | Kelly-Revit `modules/Trade.All/Commands/Acquired/Vicious/Rotate/ViciousInstanceRotateMoveCommand.cs` | `ViciousInstanceRotateMoveCommand.Execute (TaskDialog.Show calls)` | `src/Prompts` | member | low | accept |
| #24 | Kelly-Revit-Logic `src/Common/TaskDialogSimple.cs` | `TaskDialogSimple.TaskDialogError, TaskDialogInformation, TaskDialogWarning` | `src/Prompts` | member | medium | modify |
| #25 | Kelly-Revit `modules/Trade.All/Commands/Layout/LayoutPointExport/LayoutPointToCommaSeparatedValueFileExportView.xaml.cs` | `LayoutPointToCommaSeparatedValueFileExportView.CenterOnCurrentMonitor` | `src/Wpf` | member | medium | modify |

### Kelly-Domain (work package P3a-domain-common-definitions, Linear team KD)

Source packages: Kelly-Revit-Logic (KTRL5), Kelly-Revit (KTR5).

| # | Source | Symbol | Into | Kind | Risk | Review |
|---|---|---|---|---|---|---|
| #26 | Kelly-Revit `modules/Trade.All/Commands/Acquired/Vicious/Racker/ViciousInstanceElevationAssignViewModel.cs` | `ViciousInstanceElevationAssignViewModel.SetDesiredElevation (rounding rule)` | `src/Common` | member | low | accept |
| #27 | Kelly-Revit-Logic `src/Elements/PenetrationTagTools.cs` | `PenetrationTagTools.NestedDefinitionSet` | `src/Definitions` | type | low | accept |
| #28 | Kelly-Revit-Logic `src/Entities/PhysicalElementEntity.cs` | `PhysicalElementEntity.NestedDefinitionSet` | `src/Definitions` | type | low | accept |
| #29 | Kelly-Revit-Logic `src/Fabrication/ProductRange10Joints01Weld.cs` | `ProductRange10Joints01Weld.NestedDefinitionSet` | `src/Definitions` | type | low | accept |
| #30 | Kelly-Revit-Logic `src/Fabrication/WeldLocationService.cs` | `WeldLocationService.NestedDefinitionSet` | `src/Definitions` | type | low | accept |
| #31 | Kelly-Revit-Logic `src/LayoutPoints/LayoutPointRecipeIngredients.cs` | `LayoutPointRecipeIngredients.NestedDefinitionSet` | `src/Definitions` | type | low | accept |
| #32 | Kelly-Revit-Logic `src/Mep/ValveData.cs` | `ValveData.NestedDefinitionSet` | `src/Definitions` | type | low | accept |
| #33 | Kelly-Revit-Logic `src/Spools/ElementComponent.cs` | `ElementComponent.NestedDefinitionSet` | `src/Definitions` | type | low | modify |
| #34 | Kelly-Revit-Logic `src/Spools/ItemNumber.cs` | `ItemNumber.NestedDefinitionSet` | `src/Definitions` | type | low | accept |
| #35 | Kelly-Revit-Logic `src/Spools/Module.cs` | `Module.NestedDefinitionSet` | `src/Definitions` | type | medium | modify |
| #36 | Kelly-Revit-Logic `src/Spools/Spool.cs` | `Spool.NestedDefinitionSet` | `src/Definitions` | type | low | accept |
| #37 | Kelly-Revit-Logic `src/Spools/SpoolItem.cs` | `SpoolItem.NestedDefinitionSet` | `src/Definitions` | type | low | accept |
| #38 | Kelly-Revit-Logic `src/Updaters/ElementDataModels/LayoutDisciplineElementDataModel.cs` | `LayoutDisciplineElementDataModel.NestedDefinitionSet` | `src/Definitions` | type | low | accept |
| #39 | Kelly-Revit-Logic `src/Updaters/ElementServices/DetailingPhaseUpdaterElementService.cs` | `DetailingPhaseUpdaterElementService.NestedDefinitionSet` | `src/Definitions` | type | low | accept |
| #40 | Kelly-Revit-Logic `src/Updaters/ElementServices/EndPreparationUpdaterElementService.cs` | `EndPreparationUpdaterElementService.NestedDefinitionSet` | `src/Definitions` | type | low | accept |
| #41 | Kelly-Revit-Logic `src/Updaters/ElementServices/FabricationPartInstancesUpdaterElementService.cs` | `FabricationPartInstancesUpdaterElementService.NestedDefinitionSet` | `src/Definitions` | type | low | accept |
| #42 | Kelly-Revit-Logic `src/Updaters/ElementServices/LayoutDisciplineUpdaterElementService.cs` | `LayoutDisciplineUpdaterElementService.NestedDefinitionSet` | `src/Definitions` | type | low | accept |
| #43 | Kelly-Revit-Logic `src/Updaters/ElementServices/WeldUpdaterElementService.cs` | `WeldUpdaterElementService.NestedDefinitionSet` | `src/Definitions` | type | low | accept |
| #44 | Kelly-Revit-Logic `src/Fabrication/FabricationDatabaseTools.cs` | `FabricationDatabaseTools.GetNextStraight (fitting alias rule "Bend", "Elbow", "Tee")` | `src/Fabrication` | member | low | accept |
| #45 | Kelly-Revit-Logic `src/Views/ViewFilterSets.cs` | `ViewFilterSets.BomTypeEqualsField, BomTypeEqualsFieldAndFieldTrimIsGreaterThanZero, BomTypeEqualsModule, BomTypeEqualsShop (BOM type literals)` | `src/Fabrication` | member | low | accept |
| #46 | Kelly-Revit-Logic `src/Caches/DetailingPackageDocumentCache.cs` | `DetailingPackageDocumentCache..ctor (default "DEFAULT-DP-001")` | `src/Identifiers` | member | low | accept |
| #47 | Kelly-Revit-Logic `src/Caches/LineNumberDocumentCache.cs` | `LineNumberDocumentCache..ctor (default "DEFAULT-LN-001")` | `src/Identifiers` | member | low | accept |
| #48 | Kelly-Revit-Logic `src/Updaters/ElementDataModel.cs` | `ElementDataModel..ctor (ProductCode parse-or-new)` | `src/Identifiers` | member | low | accept |

### Kelly-Domain (work package P3b-domain-layoutpoints-pcf, Linear team KD)

Source packages: Kelly-Revit-Logic (KTRL5), Kelly-Revit (KTR5).

| # | Source | Symbol | Into | Kind | Risk | Review |
|---|---|---|---|---|---|---|
| #49 | Kelly-Revit `modules/Trade.All/Commands/Layout/LayoutPointExport/LayoutPointToCommaSeparatedValueFileExportView.xaml.cs` | `LayoutPointToCommaSeparatedValueFileExportView.LayoutPointGridViewSelectionChanged` | `src/LayoutPoints` | member | low | modify |
| #50 | Kelly-Revit `modules/Trade.All/Commands/Layout/LayoutPointExport/LayoutPointToCommaSeparatedValueFileExportView.xaml.cs` | `LayoutPointToCommaSeparatedValueFileExportView.IsolateDuplicatesRadGridViewButton_Click` | `src/LayoutPoints` | member | low | accept |
| #51 | Kelly-Revit `modules/Trade.All/Commands/Layout/LayoutPointImport/LayoutPointFromCommaSeparatedValueImportViewModel.cs` | `LayoutPointFromCommaSeparatedValueImportViewModel.ImportPoints (warning text)` | `src/LayoutPoints` | member | low | accept |
| #52 | Kelly-Revit-Logic `src/LayoutPoints/LayoutPointExportCandidate.cs` | `LayoutPointExportCandidate.GetSignatureStatus` | `src/LayoutPoints` | member | low | accept |
| #53 | Kelly-Revit `modules/Trade.All/Commands/Acquired/Vicious/PointToPipe/ViciousFileBasedSystemPipePlaceTools.cs` | `ViciousFileBasedSystemPipePlaceTools.LoadDataTable (file-kind rule)` | `src/Pcf` | member | low | accept |
| #54 | Kelly-Revit `modules/Trade.All/Commands/Acquired/Vicious/PointToPipe/ViciousFileBasedSystemPipePlaceView.xaml.cs` | `ViciousFileBasedSystemPipePlaceView.OkButton_Click (placement method names)` | `src/Pcf` | member | low | accept |
| #55 | Kelly-Revit `modules/Trade.Contenter/Commands/FabricationCustomDataUpdaterV1/FabricationCustomDataUpdaterCommandV1.cs` | `FabricationCustomDataUpdaterCommandV1.Execute (record selection: ComponentId match, InternalIndex != 105)` | `src/Products` | member | low | accept |
| #56 | Kelly-Revit-Logic `src/Caches/SystemDocumentCache.cs` | `SystemDocumentCache.GetData (default system "Generic System" "SYS")` | `src/Projects` | member | low | accept |
| #57 | Kelly-Revit-Logic `src/Caches/SystemDocumentCache.cs` | `SystemDocumentCache.GetData (default system)` | `src/Projects` | member | low | accept |
| #58 | Kelly-Revit-Logic `src/Updaters/ElementDataModels/MaterialElementDataModel.cs` | `MaterialElementDataModel.Initialize (alternate lookup trigger check)` | `src/Projects` | member | low | accept |
| #59 | Kelly-Revit `modules/Trade.All/Commands/Assigners/ServiceContext/ComboBox/ServiceComboBoxEventHandler.cs` | `ServiceComboBoxEventHandler.OnCurrentChanged` | `src/Signatures` | member | low | modify |
| #60 | Kelly-Revit-Logic `src/Caches/ServiceDocumentCache.cs` | `ServiceDocumentCache.GetData (default, distinct and sort tail)` | `src/Signatures` | member | low | modify |
| #61 | Kelly-Revit-Logic `src/Caches/SystemDocumentCache.cs` | `SystemDocumentCache.GetData (default, distinct and sort tail)` | `src/Signatures` | member | low | modify |
| #62 | Kelly-Revit-Logic `src/Signatures/GeometrySignatureExtensions.cs` | `GeometrySignatureExtensions.GetGeometrySignature (composition rule) and GetSignaturePrefix` | `src/Signatures` | member | low | accept |
| #63 | Kelly-Revit-Logic `src/Updaters/ElementDataModels/LayoutDisciplineElementDataModel.cs` | `LayoutDisciplineElementDataModel.UpdateElement (service lookup by signature)` | `src/Signatures` | member | low | accept |
| #64 | Kelly-Revit-Logic `src/Updaters/ElementServices/ServiceElementWriter.cs` | `ServiceElementWriter.UpdateElements (service lookup by signature)` | `src/Signatures` | member | low | accept |

### Kelly-Domain (work package P3c-domain-spools-supports, Linear team KD)

Source packages: Kelly-Revit-Logic (KTRL5), Kelly-Revit (KTR5).

| # | Source | Symbol | Into | Kind | Risk | Review |
|---|---|---|---|---|---|---|
| #65 | Kelly-Revit `modules/Trade.All/Commands/Spools/SpoolManager/SpoolManagerViewModel.cs` | `SpoolManagerViewModel..ctor (spool sheet title block prefix "Spool - ")` | `src/Spools` | member | low | accept |
| #66 | Kelly-Revit `modules/Trade.Duct/Commands/DuctItemNumberSet/DuctItemNumberSetCommand.cs` | `DuctItemNumberSetCommand.Execute (next sequence and item number value)` | `src/Spools` | member | low | accept |
| #67 | Kelly-Revit `modules/Trade.Duct/Commands/DuctItemNumberSet/DuctItemNumberSetCommand.cs` | `DuctItemNumberSetCommand.Execute (next sequence and item number text)` | `src/Spools` | member | low | accept |
| #68 | Kelly-Revit-Logic `src/Caches/ModuleNumberDocumentCache.cs` | `ModuleNumberDocumentCache..ctor (default "DEFAULT-MOD-001")` | `src/Spools` | member | low | accept |
| #69 | Kelly-Revit-Logic `src/Caches/SpoolNumberDocumentCache.cs` | `SpoolNumberDocumentCache..ctor (default "DEFAULT-SPL-001")` | `src/Spools` | member | low | accept |
| #70 | Kelly-Revit-Logic `src/Spools/ElementComponent.cs` | `ElementComponent (validated column properties and ItemNumber display)` | `src/Spools` | member | medium | modify |
| #71 | Kelly-Revit-Logic `src/Spools/Spool.cs` | `Spool(List<Element>, Document) detailing package summary` | `src/Spools` | member | low | accept |
| #72 | Kelly-Revit-Logic `src/Spools/SpoolItem.cs` | `SpoolItem.IsSpoolAble (spoolable product range query)` | `src/Spools` | member | low | accept |
| #73 | Kelly-Revit-Logic `src/Spools/SpoolItem.cs` | `SpoolItem.SetTag (tag text and note rule)` | `src/Spools` | member | low | accept |
| #74 | Kelly-Revit-Logic `src/Spools/SpoolItem.cs` | `SpoolItem.IsNumberable and SpoolItem.ShopCutLength` | `src/Spools` | member | low | accept |
| #75 | Kelly-Revit `modules/Trade.All/RibbonItems/PushButtons/ExternalCommandAvailability/IsTrapezeSelectedCommandEnabler.cs` | `IsTrapezeSelectedCommandEnabler.IsCommandAvailable (family-name rule)` | `src/Supports` | member | low | accept |
| #76 | Kelly-Revit-Logic `src/Families/FamilyInstanceExtensions.cs` | `FamilyInstanceExtensions.IsValidSuspendedSupportTrapeze (family name Contains "Trapeze")` | `src/Supports` | member | low | accept |
| #77 | Kelly-Revit-Logic `src/Families/FamilyInstanceExtensions.cs` | `FamilyInstanceExtensions.IsValidSuspendedSupportPipeHanger (family name Contains "Pipe Hanger")` | `src/Supports` | member | low | accept |
| #78 | Kelly-Revit-Logic `src/Supports/SuspendedSupport.cs` | `SuspendedSupport.NestedDefinitionSet` | `src/Supports` | type | low | accept |
| #79 | Kelly-Revit-Logic `src/Supports/SuspendedSupport.cs` | `SuspendedSupport.MarkSignatureTagPairMatches (grouping rule)` | `src/Supports` | member | low | accept |
| #80 | Kelly-Revit-Logic `src/Supports/SuspendedSupport.cs` | `SuspendedSupport.GetVerticalMemberData(FabricationPart) BearerType-to-rod-length rule` | `src/Supports` | member | low | accept |
| #81 | Kelly-Revit-Logic `src/Supports/VerticalSupportMember.cs` | `VerticalSupportMember.NestedDefinitionSet` | `src/Supports` | type | low | accept |
| #82 | Kelly-Revit-Logic `src/Updaters/ElementServices/SuspendedSupportElementService.cs` | `SuspendedSupportElementService.NestedDefinitionSet` | `src/Supports` | type | low | accept |

### Kelly-Domain (work package P3d-domain-views-vocabulary, Linear team KD)

Source packages: Kelly-Revit-Logic (KTRL5), Kelly-Revit (KTR5).

| # | Source | Symbol | Into | Kind | Risk | Review |
|---|---|---|---|---|---|---|
| #83 | Kelly-Revit `modules/Trade.All/Commands/ScheduleExport/ViewScheduleExportToXlsxFile/ViewScheduleToExcelFileExportCommand.cs` | `ViewScheduleToExcelFileExportCommand.ExportSelectedSchedules (workbook file name base)` | `src/Views` | member | low | accept |
| #84 | Kelly-Revit `modules/Trade.All/Commands/ScheduleExport/ViewScheduleExportToXlsxFile/ViewScheduleToExcelFileExportCommand.cs` | `ViewScheduleToExcelFileExportCommand.ExportSelectedSchedules (workbook file name)` | `src/Views` | member | low | accept |
| #85 | Kelly-Revit `modules/Trade.All/Commands/ScheduleExport/ViewScheduleExportToXlsxFileNoExcel/ViewScheduleToXlsxFileNoExcelExportCommand.cs` | `ViewScheduleToXlsxFileNoExcelExportCommand.ExportSelectedSchedules (workbook file name base)` | `src/Views` | member | low | accept |
| #86 | Kelly-Revit `modules/Trade.All/Commands/ScheduleExport/ViewScheduleExportToXlsxFileNoExcel/ViewScheduleToXlsxFileNoExcelExportCommand.cs` | `ViewScheduleToXlsxFileNoExcelExportCommand.ExportSelectedSchedules (workbook file name)` | `src/Views` | member | low | accept |
| #87 | Kelly-Revit `modules/Trade.All/Commands/ScheduleExport/ViewScheduleExportToXlsxFiles/ViewScheduleToExcelFilesExportCommand.cs` | `ViewScheduleToExcelFilesExportCommand.ExportSchedule (file name base)` | `src/Views` | member | low | modify |
| #88 | Kelly-Revit `modules/Trade.All/Commands/ScheduleExport/ViewScheduleExportToXlsxFiles/ViewScheduleToExcelFilesExportCommand.cs` | `ViewScheduleToExcelFilesExportCommand.ExportSchedule (schedule file name)` | `src/Views` | member | low | accept |
| #89 | Kelly-Revit `modules/Trade.All/Commands/ScheduleExport/ViewScheduleExportToXlsxFilesNoExcel/ViewScheduleToXlsxFilesNoExcelExportCommand.cs` | `ViewScheduleToXlsxFilesNoExcelExportCommand.ExportSchedule (file name base)` | `src/Views` | member | low | accept |
| #90 | Kelly-Revit `modules/Trade.All/Commands/ScheduleExport/ViewScheduleExportToXlsxFilesNoExcel/ViewScheduleToXlsxFilesNoExcelExportCommand.cs` | `ViewScheduleToXlsxFilesNoExcelExportCommand.ExportSchedule (schedule file name)` | `src/Views` | member | low | accept |
| #91 | Kelly-Revit-Logic `src/Views/ScheduleExportService.cs` | `ScheduleExportService.ExportToCsvFiles (schedule file name)` | `src/Views` | member | low | accept |
| #92 | Kelly-Revit-Logic `src/Documents/DocumentExtensionsJhk.cs` | `DocumentExtensions.GetViewPlansOfJhkViewType ("JHK View Type" literal)` | `src/Vocabulary` | member | low | accept |
| #93 | Kelly-Revit-Logic `src/LayoutPoints/LayoutPointRecipeIngredients.cs` | `LayoutPointRecipeIngredients.GetIdNumber ("Control Point" literal)` | `src/Vocabulary` | member | low | accept |
| #94 | Kelly-Revit-Logic `src/Views/ProductRangeScheduleExtensions.cs` | `ProductRangeScheduleExtensions.CreateProductRangeSchedules ("JHK Product Range" literal)` | `src/Vocabulary` | member | low | accept |

### Kelly-Revit-Logic (work package P4a-logic-arrangement-common, Linear team KTRL5)

Source packages: Kelly-Revit-UI (KTRUI), Kelly-Revit (KTR5).

| # | Source | Symbol | Into | Kind | Risk | Review |
|---|---|---|---|---|---|---|
| #95 | Kelly-Revit `modules/Trade.All/Commands/Acquired/Arrange/DistributeAround/ArrangeDistributeTagsAroundCommand.cs` | `ArrangeDistributeTagsAroundCommand.Execute` | `src/Arrangement` | member | low | accept |
| #96 | Kelly-Revit `modules/Trade.All/Commands/Acquired/Arrange/DistributeAround/ArrangeDistributeTagsAroundCommand.cs` | `ArrangeDistributeTagsAroundCommand.Execute (transaction group and exception mapping)` | `src/Arrangement` | member | medium | modify |
| #97 | Kelly-Revit `modules/Trade.All/Commands/Acquired/Vicious/PointToPipe/ViciousFileBasedSystemPipePlaceView.xaml.cs` | `ViciousFileBasedSystemPipePlaceView..ctor (settings file path)` | `src/Common` | member | low | accept |
| #98 | Kelly-Revit `modules/Trade.All/Commands/Spools/ModuleCreator/ModuleCreatorViewModel.cs` | `ModuleCreatorViewModel..ctor (SettingsFilePath = Path.Combine(GetSettingsDirectory, ModuleCreatorSettings.json))` | `src/Common` | member | low | accept |
| #99 | Kelly-Revit `modules/Trade.All/Commands/Spools/ModuleCreator/ModuleCreatorViewModel.cs` | `ModuleCreatorViewModel..ctor (settings file path)` | `src/Common` | member | low | accept |
| #100 | Kelly-Revit `modules/Trade.All/Commands/Spools/SpoolCreate/SpoolCreateViewModel.cs` | `SpoolCreateViewModel..ctor (SettingFile = <Settings folder>\SpoolCreatorSettings.json)` | `src/Common` | member | low | accept |
| #101 | Kelly-Revit `modules/Trade.All/Commands/Spools/SpoolCreate/SpoolCreateViewModel.cs` | `SpoolCreateViewModel..ctor (settings file path)` | `src/Common` | member | low | accept |
| #102 | Kelly-Revit `modules/Trade.Developer/WindowMockup/WindowMockupViewModel.cs` | `WindowMockupViewModel.CreateObjects (distinct JHK Product Codes in a scope)` | `src/Common` | member | low | modify |
| #103 | Kelly-Revit `modules/Trade.Pipe/Commands/OletChecker/OletCheckViewModel.cs` | `OletCheckViewModel.GetInitialScope` | `src/Common` | member | low | accept |
| #104 | Kelly-Revit `modules/Trade.All/Commands/ManyConnect/ManyConnectCommand.cs` | `ManyConnectCommand.Transaction` | `src/Connectors` | member | medium | accept |
| #105 | Kelly-Revit `modules/Trade.Developer/Commands/SelectFieldTrimEnd/SelectFieldTrimEndCommand.cs` | `SelectFieldTrimEndCommand.Execute (end connector filter)` | `src/Connectors` | member | low | accept |
| #106 | Kelly-Revit-UI `src/Selection/FamilyInstanceHavingConnectorsSelectionFilter.cs` | `FamilyInstanceHavingConnectorsSelectionFilter.AllowElement` | `src/Connectors` | member | low | accept |

### Kelly-Revit-Logic (work package P4b-logic-documents-elements, Linear team KTRL5)

Source packages: Kelly-Revit-UI (KTRUI), Kelly-Revit (KTR5).

| # | Source | Symbol | Into | Kind | Risk | Review |
|---|---|---|---|---|---|---|
| #107 | Kelly-Revit `modules/Trade.All/Commands/Acquired/Vicious/PointToPipe/ViciousFileBasedSystemPipePlaceTools.cs` | `ViciousFileBasedSystemPipePlaceTools.Execute (level at or below picked point)` | `src/Documents` | member | low | accept |
| #108 | Kelly-Revit `modules/Trade.All/Commands/Acquired/Vicious/PointToPipe/ViciousFileBasedSystemPipePlaceTools.cs` | `ViciousFileBasedSystemPipePlaceTools (PipeType, PipingSystemType and Level collectors)` | `src/Documents` | member | low | accept |
| #109 | Kelly-Revit `modules/Trade.All/Commands/Acquired/Vicious/PointToPipe/ViciousFileBasedSystemPipePlaceView.xaml.cs` | `ViciousFileBasedSystemPipePlaceView.GetPipeTypes (collector)` | `src/Documents` | member | low | accept |
| #110 | Kelly-Revit `modules/Trade.All/Commands/Assigners/DetailingPackageContext/ValueUnassign/DetailingPackageAssignerValueResetCommand.cs` | `DetailingPackageAssignerValueResetCommand.Execute` | `src/Documents` | member | low | modify |
| #111 | Kelly-Revit `modules/Trade.All/Commands/Assigners/LineNumberContext/ValueUnassign/LineNumberAssignerValueResetCommand.cs` | `LineNumberAssignerValueResetCommand.Execute` | `src/Documents` | member | low | modify |
| #112 | Kelly-Revit `modules/Trade.All/Commands/Assigners/ModuleNumberContext/ValueUnassign/ModuleNumberAssignerValueResetCommand.cs` | `ModuleNumberAssignerValueResetCommand.Execute` | `src/Documents` | member | low | modify |
| #113 | Kelly-Revit `modules/Trade.All/Commands/Spools/SpoolCreate/SpoolCreateViewModel.cs` | `SpoolCreateViewModel..ctor (AssemblyTypesInProject collector)` | `src/Documents` | member | low | accept |
| #114 | Kelly-Revit `modules/Trade.All/Commands/Spools/SpoolCreate/SpoolCreateViewModel.cs` | `SpoolCreateViewModel..ctor (AssemblyType collector)` | `src/Documents` | member | low | accept |
| #115 | Kelly-Revit `modules/Trade.Developer/Commands/PurgeFamilyInstances/AllFamilyInstanceDeleteCommand.cs` | `AllFamilyInstanceDeleteCommand.Execute (count of instances with a family)` | `src/Documents` | member | low | accept |
| #116 | Kelly-Revit `modules/Trade.Manager/Commands/DeleteById/ElementDeleteCommand.cs` | `ElementDeleteCommand.Execute (delete by id inside OperationService)` | `src/Documents` | member | medium | accept |
| #117 | Kelly-Revit `src/App.cs` | `App.LogEventHandlerArgumentName` | `src/Documents` | member | low | accept |
| #118 | Kelly-Revit `src/EventHandlers/DocumentOpenedEventHandler.cs` | `DocumentOpenedEventHandler.Execute` | `src/Documents` | member | medium | modify |
| #119 | Kelly-Revit-UI `src/Scope/ScopeSourceExtensions.cs` | `ScopeSourceExtensions.GetLevelComboBoxItems` | `src/Documents` | member | low | accept |
| #120 | Kelly-Revit-UI `src/Scope/ScopeSourceExtensions.cs` | `ScopeSourceExtensions.GetProjectLocationComboBoxItems` | `src/Documents` | member | low | accept |
| #121 | Kelly-Revit `modules/Trade.All/Commands/Acquired/Vicious/Level/ViciousInstanceLevelAssignCommand.cs` | `ViciousInstanceLevelAssignCommand.Execute (model-element filter)` | `src/Elements` | member | low | accept |
| #122 | Kelly-Revit `modules/Trade.All/Commands/Acquired/Vicious/Racker/ViciousInstanceElevationAssignViewModel.cs` | `ViciousInstanceElevationAssignViewModel..ctor (element models, distinct elevations, distinct level names)` | `src/Elements` | member | low | accept |
| #123 | Kelly-Revit `modules/Trade.All/Commands/Acquired/Vicious/Rotate/ViciousInstanceRotateMoveCommand.cs` | `ViciousInstanceRotateMoveCommand.Execute (assembly membership check)` | `src/Elements` | member | low | accept |
| #124 | Kelly-Revit-UI `src/Selection/RotateAxisIsMepFittingSelectionFilter.cs` | `RotateAxisIsMepFittingSelectionFilter.AllowElement` | `src/Elements` | member | low | accept |
| #125 | Kelly-Revit-UI `src/Selection/RotateAxisIsMepStraightSelectionFilter.cs` | `RotateAxisIsMepStraightSelectionFilter.AllowElement` | `src/Elements` | member | low | accept |
| #126 | Kelly-Revit `modules/Trade.All/Commands/Layout/LayoutPointExport/LayoutPointToCommaSeparatedValueFileExportView.xaml.cs` | `LayoutPointToCommaSeparatedValueFileExportView.AddUnSelectedSiblings` | `src/Entities` | member | low | modify |
| #127 | Kelly-Revit-Logic `src/Entities/PhysicalElementEntity.cs` | `PhysicalElementEntity.SetField` | `src/Entities` | member | low | modify |
| #128 | Kelly-Revit-UI `src/Mvvm/ViewModel.cs` | `ViewModel.AddScope` | `src/Entities` | member | low | modify |
| #129 | Kelly-Revit-UI `src/Mvvm/ViewModel.cs` | `ViewModel.AddScopes` | `src/Entities` | member | low | modify |

### Kelly-Revit-Logic (work package P4c-logic-fabrication-families, Linear team KTRL5)

Source packages: Kelly-Revit-UI (KTRUI), Kelly-Revit (KTR5).

| # | Source | Symbol | Into | Kind | Risk | Review |
|---|---|---|---|---|---|---|
| #130 | Kelly-Revit `modules/Trade.All/Commands/Spools/SpoolManager/SpoolManagerViewModel.cs` | `SpoolManagerViewModel.UpdateWeldLocation (weld location transaction)` | `src/Fabrication` | member | low | accept |
| #131 | Kelly-Revit `modules/Trade.Contenter/Commands/FabricationCustomDataReport/FabricationCustomDataReportCommand.cs` | `FabricationCustomDataReportCommand.CustomDataPointValuesToCsv` | `src/Fabrication` | member | low | accept |
| #132 | Kelly-Revit `modules/Trade.Contenter/Commands/FabricationCustomDataUpdaterV1/FabricationCustomDataUpdaterCommandV1.cs` | `FabricationCustomDataUpdaterCommandV1.Execute (per-record custom data write switch)` | `src/Fabrication` | member | low | accept |
| #133 | Kelly-Revit `modules/Trade.Contenter/Commands/FabricationPartProductCodeCheckReport/FabricationPartProductCodeCheckReportCommand.cs` | `FabricationPartProductCodeCheckReportCommand.WriteReport (CSV text) and GetScenarioSummary` | `src/Fabrication` | member | low | accept |
| #134 | Kelly-Revit `modules/Trade.Contenter/Commands/FabricationPartVariousReport/FabricationPartVariousReportCommand.cs` | `FabricationPartVariousReportCommand.LogPropertyValues and the per-part logging loop` | `src/Fabrication` | member | low | accept |
| #135 | Kelly-Revit `modules/Trade.Pipe/Commands/WeldLocationAssign/Field/WeldLocationFieldSetCommand.cs` | `WeldLocationFieldSetCommand.Execute (empty check, SetWeldLocation(term), SetEndPreparation)` | `src/Fabrication` | member | low | accept |
| #136 | Kelly-Revit `modules/Trade.Pipe/Commands/WeldLocationAssign/FieldFit/WeldLocationFieldFitSetCommand.cs` | `WeldLocationFieldFitSetCommand.Execute (empty check, SetWeldLocation(term), SetEndPreparation)` | `src/Fabrication` | member | low | accept |
| #137 | Kelly-Revit `modules/Trade.Pipe/Commands/WeldLocationAssign/FieldFitTack/WeldLocationFieldFitTackSetCommand.cs` | `WeldLocationFieldFitTackSetCommand.Execute (empty check, SetWeldLocation(term), SetEndPreparation)` | `src/Fabrication` | member | low | accept |
| #138 | Kelly-Revit `modules/Trade.Pipe/Commands/WeldLocationAssign/Shop/WeldLocationShopSetCommand.cs` | `WeldLocationShopSetCommand.Execute (empty check, SetWeldLocation(term), SetEndPreparation)` | `src/Fabrication` | member | low | accept |
| #139 | Kelly-Revit `modules/Trade.Pipe/Commands/WeldLocationAssign/ShopTack/WeldLocationShopTackSetCommand.cs` | `WeldLocationShopTackSetCommand.Execute (empty check, SetWeldLocation(term), SetEndPreparation)` | `src/Fabrication` | member | low | accept |
| #140 | Kelly-Revit `modules/Trade.All/Commands/FamilySharedParameterReport/FamilySharedParameterReportCommand.cs` | `FamilySharedParameterReportCommand.Execute (CSV file write and family count)` | `src/Families` | member | low | modify |
| #141 | Kelly-Revit `modules/Trade.All/RibbonItems/PushButtons/ExternalCommandAvailability/IsTrapezeSelectedCommandEnabler.cs` | `IsTrapezeSelectedCommandEnabler.IsCommandAvailable` | `src/Families` | member | low | accept |
| #142 | Kelly-Revit `modules/Trade.All/RibbonItems/PushButtons/ExternalCommandAvailability/IsTrapezeSelectedCommandEnabler.cs` | `IsTrapezeSelectedCommandEnabler.IsCommandAvailable (top-level trapeze rule)` | `src/Families` | member | medium | modify |
| #143 | Kelly-Revit-UI `src/Families/TitleBlockExtensions.cs` | `TitleBlockExtensions.GetTitleBlocks` | `src/Families` | member | low | accept |
| #144 | Kelly-Revit `modules/Trade.All/Commands/Acquired/Vicious/PointToPipe/ViciousFileBasedSystemPipePlaceTools.cs` | `ViciousFileBasedSystemPipePlaceTools.SetWorkPlaneAndPickObject (plane from face, temporary work plane)` | `src/Geometry` | member | medium | accept |
| #145 | Kelly-Revit `modules/Trade.All/Commands/Acquired/Vicious/Rotate/ViciousInstanceRotateMoveCommand.cs` | `ViciousInstanceRotateMoveCommand.SelectRotationAxis (axis from element)` | `src/Geometry` | member | medium | accept |
| #146 | Kelly-Revit `modules/Trade.All/Commands/Layout/LayoutPointExport/LayoutPointToCommaSeparatedValueFileExportViewModel.cs` | `LayoutPointToCommaSeparatedValueFileExportViewModel.Export` | `src/LayoutPoints` | member | medium | accept |
| #147 | Kelly-Revit `modules/Trade.All/Commands/Layout/LayoutPointExport/LayoutPointToCommaSeparatedValueFileExportViewModel.cs` | `LayoutPointToCommaSeparatedValueFileExportViewModel.Reset` | `src/LayoutPoints` | member | low | accept |
| #148 | Kelly-Revit `modules/Trade.All/Commands/Layout/LayoutPointExport/LayoutPointToCommaSeparatedValueFileExportViewModel.cs` | `LayoutPointToCommaSeparatedValueFileExportViewModel.Save` | `src/LayoutPoints` | member | medium | accept |
| #149 | Kelly-Revit `modules/Trade.All/Commands/Layout/LayoutPointExport/LayoutPointToCommaSeparatedValueFileExportViewModel.cs` | `LayoutPointToCommaSeparatedValueFileExportViewModel.UpdateCoordinates` | `src/LayoutPoints` | member | low | accept |
| #150 | Kelly-Revit `modules/Trade.All/Commands/Layout/LayoutPointImport/LayoutPointFromCommaSeparatedValueImportViewModel.cs` | `LayoutPointFromCommaSeparatedValueImportViewModel.GetFamilySymbols` | `src/LayoutPoints` | member | low | accept |
| #151 | Kelly-Revit `modules/Trade.All/Commands/Layout/LayoutPointImport/LayoutPointFromCommaSeparatedValueImportViewModel.cs` | `LayoutPointFromCommaSeparatedValueImportViewModel.SetPointType` | `src/LayoutPoints` | member | low | accept |
| #152 | Kelly-Revit `modules/Trade.All/Commands/Layout/LayoutPointImport/LayoutPointFromCommaSeparatedValueImportViewModel.cs` | `LayoutPointFromCommaSeparatedValueImportViewModel.ImportPoints (failure classification)` | `src/LayoutPoints` | member | low | accept |

### Kelly-Revit-Logic (work package P4d-logic-mep-operations, Linear team KTRL5)

Source packages: Kelly-Revit (KTR5).

| # | Source | Symbol | Into | Kind | Risk | Review |
|---|---|---|---|---|---|---|
| #153 | Kelly-Revit `modules/Trade.All/Commands/Acquired/Vicious/PointToPipe/ViciousFileBasedSystemPipePlaceTools.cs` | `ViciousFileBasedSystemPipePlaceTools.Execute (pipe type, piping system type and fabrication service lookup)` | `src/Mep` | member | medium | accept |
| #154 | Kelly-Revit `modules/Trade.All/Commands/Acquired/Vicious/PointToPipe/ViciousFileBasedSystemPipePlaceTools.cs` | `ViciousFileBasedSystemPipePlaceTools.Execute (usable points and centroid)` | `src/Mep` | member | low | accept |
| #155 | Kelly-Revit `modules/Trade.All/Commands/Acquired/Vicious/PointToPipe/ViciousFileBasedSystemPipePlaceTools.cs` | `ViciousFileBasedSystemPipePlaceTools.ToPointUnitTypeId, ViciousFileBasedSystemPipePlaceTools.ToSizeUnitTypeId` | `src/Mep` | member | low | accept |
| #156 | Kelly-Revit `modules/Trade.All/Commands/Acquired/Vicious/PointToPipe/ViciousFileBasedSystemPipePlaceTools.cs` | `ViciousFileBasedSystemPipePlaceTools.ToPointUnitTypeId / ToSizeUnitTypeId` | `src/Mep` | member | low | modify |
| #157 | Kelly-Revit `modules/Trade.All/Commands/Acquired/Vicious/PointToPipe/ViciousFileBasedSystemPipePlaceView.xaml.cs` | `ViciousFileBasedSystemPipePlaceView.GetPipeTypes` | `src/Mep` | member | low | accept |
| #158 | Kelly-Revit `modules/Trade.All/Commands/Acquired/Vicious/PointToPipe/ViciousFileBasedSystemPipePlaceView.xaml.cs` | `ViciousFileBasedSystemPipePlaceView.GetProjectLengthUnitsText, ViciousFileBasedSystemPipePlaceView.GetProjectVicUnits` | `src/Mep` | member | low | accept |
| #159 | Kelly-Revit `modules/Trade.All/Commands/Acquired/Vicious/PointToPipe/ViciousFileBasedSystemPipePlaceView.xaml.cs` | `ViciousFileBasedSystemPipePlaceView.GetProjectLengthUnitsText` | `src/Mep` | member | low | modify |
| #160 | Kelly-Revit `modules/Trade.Pipe/Commands/OletChecker/OletCheckViewModel.cs` | `OletCheckViewModel.LoadElements` | `src/Mep` | member | low | accept |
| #161 | Kelly-Revit `modules/Trade.Pipe/Commands/OletChecker/OletCheckViewModel.cs` | `OletCheckViewModel.RecalculateOletCounts` | `src/Mep` | member | low | accept |
| #162 | Kelly-Revit `modules/Trade.Pipe/Commands/OletChecker/OletCheckViewModel.cs` | `OletCheckViewModel.ConnectDisconnected (disconnected olets and size-matched pipes)` | `src/Mep` | member | low | accept |
| #163 | Kelly-Revit `modules/Trade.Pipe/Commands/OletChecker/OletCheckViewModel.cs` | `OletCheckViewModel.SelectAll/SelectMisAligned/ShowDisconnected/ShowSelected (olets of a status to element ids)` | `src/Mep` | member | low | accept |
| #164 | Kelly-Revit-Logic `src/Mep/CableTrayExtensions.cs` | `CableTrayExtensions.SetOffset` | `src/Mep` | member | low | accept |
| #165 | Kelly-Revit-Logic `src/Mep/CableTrayExtensions.cs` | `CableTrayExtensions.SetLevelOfNativeCableTray` | `src/Mep` | member | low | accept |
| #166 | Kelly-Revit-Logic `src/Mep/CableTrayExtensions.cs` | `CableTrayExtensions.SetOffset / SetLevelOfNativeCableTray` | `src/Mep` | member | low | modify |
| #167 | Kelly-Revit-Logic `src/Mep/ConduitExtensions.cs` | `ConduitExtensions.SetOffset` | `src/Mep` | member | low | modify |
| #168 | Kelly-Revit-Logic `src/Mep/ConduitExtensions.cs` | `ConduitExtensions.SetLevelOfNativeConduit` | `src/Mep` | member | low | accept |
| #169 | Kelly-Revit-Logic `src/Mep/DuctExtensions.cs` | `DuctExtensions.SetLevelOfNativeDuct` | `src/Mep` | member | low | modify |
| #170 | Kelly-Revit-Logic `src/Mep/PipeExtensions.cs` | `PipeExtensions.SetLevelOfNativePipe` | `src/Mep` | member | low | modify |
| #171 | Kelly-Revit `modules/Trade.All/Commands/Supports/SuspendedSupportManage/SuspendedSupportManagerViewModel.cs` | `SuspendedSupportManagerViewModel.RunSelectionOperation (operation + progress + rollback wrapper)` | `src/Operations` | member | medium | modify |
| #172 | Kelly-Revit-Logic `src/Operations/OperationService.cs` | `OperationService.StopWatchState` | `src/Operations` | type | low | accept |
| #173 | Kelly-Revit-Logic `src/Parameters/InternalDefinitionExtensions.cs` | `InternalDefinitionExtensions.GetCategoryIds` | `src/Parameters` | member | low | accept |
| #174 | Kelly-Revit-Logic `src/Views/DataContextViewFilterTools.cs` | `DataContextViewFilterTools.CreateAndApplyFillAndLine (shared parameter element lookup)` | `src/Parameters` | member | low | accept |

### Kelly-Revit-Logic (work package P4e-logic-signatures-spools, Linear team KTRL5)

Source packages: Kelly-Revit (KTR5).

| # | Source | Symbol | Into | Kind | Risk | Review |
|---|---|---|---|---|---|---|
| #175 | Kelly-Revit `modules/Trade.All/Commands/Assigners/ServiceContext/FillColorFilterAssign/ServiceFillColorViewFilterCommand.cs` | `ServiceFillColorViewFilterCommand.Execute (elements.Select(e => e.CreateServiceSignature()).Distinct().OrderBy(s => s))` | `src/Signatures` | member | low | accept |
| #176 | Kelly-Revit `modules/Trade.All/Commands/Assigners/ServiceContext/LineColorFilterAssign/ServiceLineColorViewFilterCommand.cs` | `ServiceLineColorViewFilterCommand.Execute (elements.Select(e => e.CreateServiceSignature()).Distinct().OrderBy(s => s))` | `src/Signatures` | member | low | accept |
| #177 | Kelly-Revit `modules/Trade.All/Commands/Assigners/SystemContext/FillColorFilterAssign/SystemFillColorViewFilterCommand.cs` | `SystemFillColorViewFilterCommand.Execute (elements.Select(e => e.GetSystemSignature()).Distinct().OrderBy(s => s))` | `src/Signatures` | member | low | accept |
| #178 | Kelly-Revit `modules/Trade.All/Commands/Assigners/SystemContext/LineColorFilterAssign/SystemLineColorViewFilterCommand.cs` | `SystemLineColorViewFilterCommand.Execute (elements.Select(e => e.GetSystemSignature()).Distinct().OrderBy(s => s))` | `src/Signatures` | member | low | accept |
| #179 | Kelly-Revit `modules/Trade.Contenter/Commands/PartDimensionExport/FabricationPartDimensionLogCommand.cs` | `FabricationPartDimensionLogCommand.Execute (dimension logging and geometry signature grouping loop)` | `src/Signatures` | member | low | accept |
| #180 | Kelly-Revit `modules/Trade.All/Commands/Spools/ModuleManage/ModuleManageViewModel.cs` | `ModuleManageViewModel.CreateObjects (module collection)` | `src/Spools` | member | low | accept |
| #181 | Kelly-Revit `modules/Trade.All/Commands/Spools/ModuleManage/ModuleManageViewModel.cs` | `ModuleManageViewModel.UpdateBillOfMaterialType (write JHK BOM Type = Module to components, mirror on commit)` | `src/Spools` | member | medium | accept |
| #182 | Kelly-Revit `modules/Trade.All/Commands/Spools/ModuleManage/ModuleManageViewModel.cs` | `ModuleManageViewModel.UpdateComponentItemNumbers (itemize and write item numbers)` | `src/Spools` | member | low | accept |
| #183 | Kelly-Revit `modules/Trade.All/Commands/Spools/SpoolCreate/SpoolCreateViewModel.cs` | `SpoolCreateViewModel.CreateSpoolName (compose the name, then the 'no AssemblyType has that name' check)` | `src/Spools` | member | low | modify |
| #184 | Kelly-Revit `modules/Trade.All/Commands/Spools/SpoolCreate/SpoolCreateViewModel.cs` | `SpoolCreateViewModel.Create / CreateSpool / UpdateSpoolData / UpdateSpoolName (spool creation transactions)` | `src/Spools` | member | medium | accept |
| #185 | Kelly-Revit `modules/Trade.All/Commands/Spools/SpoolManager/SpoolManagerViewModel.cs` | `SpoolManagerViewModel.CreateSpoolSheetAndViews (spool sheet transaction)` | `src/Spools` | member | low | accept |
| #186 | Kelly-Revit `modules/Trade.All/Commands/Spools/SpoolManager/SpoolManagerViewModel.cs` | `SpoolManagerViewModel.PopulateNumberableSpoolItems / PopulateSpoolBillOfMaterials / PopulateSpoolWelds (aggregation over spools)` | `src/Spools` | member | low | accept |
| #187 | Kelly-Revit `modules/Trade.All/Commands/Spools/SpoolManager/SpoolManagerViewModel.cs` | `SpoolManagerViewModel.SetDetailingPackage / SetDetailingPackageFromSpoolItem (detailing package transaction)` | `src/Spools` | member | low | accept |
| #188 | Kelly-Revit `modules/Trade.All/Commands/Spools/SpoolManager/SpoolManagerViewModel.cs` | `SpoolManagerViewModel.SetLineNumber / SetLineNumberFromSpoolItem (line number transaction)` | `src/Spools` | member | low | accept |
| #189 | Kelly-Revit `modules/Trade.All/Commands/Spools/SpoolManager/SpoolManagerViewModel.cs` | `SpoolManagerViewModel.SetSpoolName / SetSpoolNameUsingSpoolItem (spool name transactions and the adopt-assembly-name rule)` | `src/Spools` | member | low | accept |
| #190 | Kelly-Revit `modules/Trade.All/Commands/Spools/SpoolManager/SpoolManagerViewModel.cs` | `SpoolManagerViewModel.UpdateBillOfMaterialType (spool item BOM type transaction)` | `src/Spools` | member | low | accept |
| #191 | Kelly-Revit `modules/Trade.All/Commands/Spools/SpoolManager/SpoolManagerViewModel.cs` | `SpoolManagerViewModel.UpdateItemNumbers (itemize components and welds, write item numbers)` | `src/Spools` | member | low | accept |
| #192 | Kelly-Revit `modules/Trade.All/Commands/Spools/SpoolManager/SpoolManagerViewModel.cs` | `SpoolManagerViewModel.UpdateTag (spool item tag transaction)` | `src/Spools` | member | low | accept |
| #193 | Kelly-Revit `modules/Trade.All/Commands/Spools/SpoolManager/SpoolManagerViewModel.cs` | `SpoolManagerViewModel spool-of-spool-item lookup (SetDetailingPackageFromSpoolItem, SetLineNumberFromSpoolItem, SetSpoolNameUsingSpoolItem)` | `src/Spools` | member | low | accept |
| #194 | Kelly-Revit `modules/Trade.Duct/Commands/DuctItemNumberReset/DuctItemNumberResetCommand.cs` | `DuctItemNumberResetCommand.Step02_ExecuteOperation` | `src/Spools` | member | low | accept |
| #195 | Kelly-Revit `modules/Trade.Duct/Commands/DuctItemNumberSet/DuctItemNumberSetCommand.cs` | `DuctItemNumberSetCommand.Transaction` | `src/Spools` | member | low | modify |
| #196 | Kelly-Revit-Logic `src/Spools/Spool.cs` | `Spool.RecomputeSuspension` | `src/Spools` | type | low | accept |
| #197 | Kelly-Revit-Logic `src/Spools/SpoolItemBuiltInCategorySet.cs` | `NumberableSpoolItemBuiltInCategorySet` | `src/Spools` | file | low | accept |

### Kelly-Revit-Logic (work package P4f-logic-supports-updaters, Linear team KTRL5)

Source packages: Kelly-Revit (KTR5).

| # | Source | Symbol | Into | Kind | Risk | Review |
|---|---|---|---|---|---|---|
| #198 | Kelly-Revit `modules/Trade.All/Commands/Supports/SuspendedSupportManage/SuspendedSupportManagerViewModel.cs` | `SuspendedSupportManagerViewModel.BuildSuspendedSupports (support model build) and nested NestedDefinitionSet` | `src/Supports` | member | medium | modify |
| #199 | Kelly-Revit `modules/Trade.All/Commands/Supports/SuspendedSupportManage/SuspendedSupportManagerViewModel.cs` | `SuspendedSupportManagerViewModel.AttachOrExtendToStructure (inner AttachOrExtend host switch) / ExtendToStructure(FabricationPart, Transaction)` | `src/Supports` | member | medium | accept |
| #200 | Kelly-Revit `modules/Trade.All/Commands/Supports/SuspendedSupportManage/SuspendedSupportManagerViewModel.cs` | `SuspendedSupportManagerViewModel.SetVerticalMemberSize (model write plus fabrication custom data 111)` | `src/Supports` | member | low | accept |
| #201 | Kelly-Revit `modules/Trade.All/Commands/Supports/SuspendedSupportManage/SuspendedSupportManagerViewModel.cs` | `SuspendedSupportManagerViewModel.SetTag (un-hosted skip rule, next tag, model and element write)` | `src/Supports` | member | low | modify |
| #202 | Kelly-Revit-Logic `src/Supports/VerticalSupportMember.cs` | `VerticalSupportMember.SetField` | `src/Supports` | member | low | modify |
| #203 | Kelly-Revit `modules/Trade.All/Commands/Assigners/CommonAutoAssignerTools.cs` | `CommonAutoAssignerTools.ResetUpdater` | `src/Updaters` | member | low | modify |
| #204 | Kelly-Revit `modules/Trade.All/Commands/Assigners/DetailingPackageContext/AutoAssignSwitch/DetailingPackageAssignerAutoSetToggleCommand.cs` | `DetailingPackageAssignerAutoSetToggleCommand.Execute` | `src/Updaters` | member | low | accept |
| #205 | Kelly-Revit `modules/Trade.All/Commands/Assigners/LineNumberContext/AutoAssignSwitch/LineNumberAssignerAutoSetToggleCommand.cs` | `LineNumberAssignerAutoSetToggleCommand.Execute` | `src/Updaters` | member | low | accept |
| #206 | Kelly-Revit `modules/Trade.All/Commands/Assigners/ServiceContext/AutoAssignSwitch/ServiceAssignerAutoSetToggleCommand.cs` | `ServiceAssignerAutoSetToggleCommand.Execute` | `src/Updaters` | member | low | accept |
| #207 | Kelly-Revit `modules/Trade.All/Commands/Assigners/SystemContext/AutoAssignSwitch/SystemAssignerAutoSetToggleCommand.cs` | `SystemAssignerAutoSetToggleCommand.Execute` | `src/Updaters` | member | low | accept |
| #208 | Kelly-Revit `modules/Trade.All/Commands/Updaters/UpdaterAuto/StateToggleChange/AutoUpdaterStateToggleCommand.cs` | `AutoUpdaterStateToggleCommand.Execute (suspended test UpdaterStates.Count > 0)` | `src/Updaters` | member | low | modify |
| #209 | Kelly-Revit `modules/Trade.Contenter/Commands/FabricationCustomDataUpdaterV2/FabricationCustomDataUpdaterCommandV2.cs` | `FabricationCustomDataUpdaterCommandV2.RunCommand (pass 2 per-part write: ownership re-check, SubTransaction write, ElementChangeError)` | `src/Updaters` | member | medium | accept |
| #210 | Kelly-Revit-Logic `src/Updaters/ElementServices/BillOfMaterialDefaultUpdaterElementService.cs` | `BillOfMaterialDefaultUpdaterElementService.UpdateElements(List<BillOfMaterialTypeDefaultElementDataModel>)` | `src/Updaters` | member | low | accept |
| #211 | Kelly-Revit-Logic `src/Updaters/ElementServices/ComponentUpdaterElementService.cs` | `ComponentUpdaterElementService.UpdateElements(List<ComponentElementDataModel>)` | `src/Updaters` | member | low | accept |
| #212 | Kelly-Revit-Logic `src/Updaters/ElementServices/LayoutDisciplineUpdaterElementService.cs` | `LayoutDisciplineUpdaterElementService.UpdateElements(List<LayoutDisciplineElementDataModel>)` | `src/Updaters` | member | low | accept |
| #213 | Kelly-Revit-Logic `src/Updaters/ElementServices/MaterialUpdaterElementService.cs` | `MaterialUpdaterElementService.UpdateElements(List<MaterialElementDataModel>)` | `src/Updaters` | member | low | accept |
| #214 | Kelly-Revit-Logic `src/Updaters/ElementServices/ProductUpdaterElementService.cs` | `ProductUpdaterElementService.UpdateElements(List<ProductElementDataModel>)` | `src/Updaters` | member | low | accept |
| #215 | Kelly-Revit-Logic `src/Updaters/ElementServices/ScheduleGaugeUpdaterElementService.cs` | `ScheduleGaugeUpdaterElementService.UpdateElements(List<ScheduleGaugeElementDataModel>)` | `src/Updaters` | member | low | accept |
| #216 | Kelly-Revit-Logic `src/Updaters/ElementServices/SizeUpdaterElementService.cs` | `SizeUpdaterElementService.CreateSizeDataModels and UpdateElements` | `src/Updaters` | member | low | accept |
| #217 | Kelly-Revit-Logic `src/Updaters/ManualUpdaterRunner.cs` | `ManualUpdaterRunner.Run (per-configuration operation)` | `src/Updaters` | member | low | accept |
| #218 | Kelly-Revit-Logic `src/Updaters/ElementDataModels/SizeElementDataModel.cs` | `SizeElementDataModel.UpdateOvalIngredients` | `src/Updaters/ElementDataModels` | member | low | accept |
| #219 | Kelly-Revit-Logic `src/Updaters/ElementServices/SuspendedSupportElementService.cs` | `SuspendedSupportElementService.UpdateElements (trapeze and pipe hanger branches)` | `src/Updaters/ElementServices` | member | low | accept |

### Kelly-Revit-Logic (work package P4g-logic-views, Linear team KTRL5)

Source packages: Kelly-Revit (KTR5).

| # | Source | Symbol | Into | Kind | Risk | Review |
|---|---|---|---|---|---|---|
| #220 | Kelly-Revit `modules/Trade.All/Commands/Acquired/Vicious/Rotate/ViciousInstanceRotateMoveCommand.cs` | `ViciousInstanceRotateMoveCommand.RotateViewport (crop box rotation axis)` | `src/Views` | member | low | accept |
| #221 | Kelly-Revit `modules/Trade.All/Commands/Assigners/DetailingPackageContext/LineColorFilterAssign/DetailingPackageLineColorViewFilterCommand.cs` | `DetailingPackageLineColorViewFilterCommand.Execute` | `src/Views` | member | low | modify |
| #222 | Kelly-Revit `modules/Trade.All/Commands/Assigners/LineNumberContext/LineColorFilterAssign/LineNumberLineColorViewFilterCommand.cs` | `LineNumberLineColorViewFilterCommand.Execute` | `src/Views` | member | low | accept |
| #223 | Kelly-Revit `modules/Trade.All/Commands/Assigners/ModuleNumberContext/LineColorFilterAssign/ModuleNumberLineColorViewFilterCommand.cs` | `ModuleNumberLineColorViewFilterCommand.Execute` | `src/Views` | member | low | accept |
| #224 | Kelly-Revit `modules/Trade.All/RibbonItems/PushButtons/ExternalCommandAvailability/IsElementSelectableViewCommandEnabler.cs` | `IsElementSelectableViewCommandEnabler.IsElementSelectableView` | `src/Views` | member | low | accept |
| #225 | Kelly-Revit `modules/Trade.All/RibbonItems/PushButtons/ExternalCommandAvailability/IsLayoutViewTypeCommandEnabler.cs` | `IsLayoutViewTypeCommandEnabler.IsAvailable` | `src/Views` | member | low | accept |
| #226 | Kelly-Revit `modules/Trade.Developer/Commands/ViewBrowserParameterUpdate/UpdateKellyToolsViewParametersCommand.cs` | `UpdateKellyToolsViewParametersCommand.Execute (views named 'KTR*' ordered by name)` | `src/Views` | member | low | accept |
| #227 | Kelly-Revit-Logic `src/Views/FilterExtensions.cs` | `FilterExtensions.CreateLineAndFillOverrides (both overloads) and CreateLineOverrides (both overloads)` | `src/Views` | member | low | accept |
| #228 | Kelly-Revit-Logic `src/Views/ViewFilterSets.cs` | `ViewFilterSets.BomTypeEqualsField, BomTypeEqualsModule, BomTypeEqualsShop, FieldTrimIsGreaterThanZero (shared skeleton)` | `src/Views` | member | low | accept |

### Kelly-Revit-UI (work package P5a-ui-commands-grids, Linear team KTRUI)

Source packages: Kelly-Revit (KTR5).

| # | Source | Symbol | Into | Kind | Risk | Review |
|---|---|---|---|---|---|---|
| #229 | Kelly-Revit `modules/Trade.All/Commands/About/ApplicationAboutCommand.cs` | `ApplicationAboutCommand.Execute (view model and view show sequence)` | `src/Commands` | member | low | accept |
| #230 | Kelly-Revit `modules/Trade.All/Commands/Acquired/Arrange/Arranger.cs` | `Arranger.Elements` | `src/Commands` | member | medium | modify |
| #231 | Kelly-Revit `modules/Trade.All/Commands/Acquired/Vicious/Racker/ViciousInstanceElevationAssignCommand.cs` | `ViciousInstanceElevationAssignCommand.Execute (view model and view show sequence)` | `src/Commands` | member | low | accept |
| #232 | Kelly-Revit `modules/Trade.All/Commands/Layout/LayoutPointImport/LayoutPointFromCommaSeparatedValueImportCommand.cs` | `LayoutPointFromCommaSeparatedValueImportCommand.Execute (view model and view show sequence)` | `src/Commands` | member | low | accept |
| #233 | Kelly-Revit `modules/Trade.All/Commands/Spools/ModuleCreator/ModuleCreatorCommand.cs` | `ModuleCreatorCommand.Execute (view model and view show sequence)` | `src/Commands` | member | low | accept |
| #234 | Kelly-Revit `modules/Trade.All/Commands/Spools/ModuleManage/ModuleManageCommand.cs` | `ModuleManageCommand.Execute (view model and view show sequence)` | `src/Commands` | member | low | accept |
| #235 | Kelly-Revit `modules/Trade.All/Commands/Spools/SpoolCreate/SpoolCreateCommand.cs` | `SpoolCreateCommand.Execute (view model and view show sequence)` | `src/Commands` | member | low | modify |
| #236 | Kelly-Revit `modules/Trade.All/Commands/Spools/SpoolManager/SpoolManagerCommand.cs` | `SpoolManagerCommand.Execute (view model and view show sequence)` | `src/Commands` | member | low | accept |
| #237 | Kelly-Revit `modules/Trade.All/Commands/Supports/SuspendedSupportManage/SuspendedSupportManageCommand.cs` | `SuspendedSupportManageCommand.Execute (view model and view show sequence)` | `src/Commands` | member | low | accept |
| #238 | Kelly-Revit `modules/Trade.All/RibbonItems/PushButtons/ExternalCommandAvailability/DocumentHasAssemblyInstances.cs` | `DocumentHasAssemblyInstances` | `src/Commands` | type | low | accept |
| #239 | Kelly-Revit `modules/Trade.All/RibbonItems/PushButtons/ExternalCommandAvailability/DocumentHasAssemblyInstances.cs` | `DocumentHasAssemblyInstances.IsCommandAvailable` | `src/Commands` | member | low | accept |
| #240 | Kelly-Revit `modules/Trade.All/RibbonItems/PushButtons/ExternalCommandAvailability/IsTrapezeSelectedCommandEnabler.cs` | `IsTrapezeSelectedCommandEnabler (null-document guard)` | `src/Commands` | type | low | accept |
| #241 | Kelly-Revit `modules/Trade.All/RibbonItems/PushButtons/ExternalCommandAvailability/IsViewFilterEligibleCommandEnabler.cs` | `IsViewFilterEligibleCommandEnabler (null-document guard)` | `src/Commands` | type | low | accept |
| #242 | Kelly-Revit `modules/Trade.All/RibbonItems/PushButtons/ExternalCommandAvailability/IsViewFilterEligibleCommandEnabler.cs` | `IsViewFilterEligibleCommandEnabler.IsCommandAvailable (null guard)` | `src/Commands` | member | low | accept |
| #243 | Kelly-Revit `modules/Trade.Contenter/RibbonItems/PushButtons/ExternalCommandAvailability/DocumentHasFabricationParts.cs` | `DocumentHasFabricationParts.IsCommandAvailable` | `src/Commands` | member | low | accept |
| #244 | Kelly-Revit `modules/Trade.Contenter/RibbonItems/PushButtons/ExternalCommandAvailability/IsDocumentOfTypeFamily.cs` | `IsDocumentOfTypeFamily.IsCommandAvailable (null guard)` | `src/Commands` | member | low | modify |
| #245 | Kelly-Revit `modules/Trade.Developer/WindowMockup/WindowMockupCommand.cs` | `WindowMockupCommand.Execute (view model and view show sequence)` | `src/Commands` | member | low | accept |
| #246 | Kelly-Revit `modules/Trade.All/Commands/Spools/ModuleManage/ModuleManageView.xaml.cs` | `ModuleManageView.ResetComponentGridButton_Click / ResetModuleGridButton_Click / ResetSpoolGridButton_Click (grid descriptor reset)` | `src/Grids` | member | low | modify |
| #247 | Kelly-Revit `modules/Trade.All/Commands/Spools/SpoolManager/SpoolManagerView.xaml.cs` | `SpoolManagerView.ResetSpoolBillOfMaterialsGridButton_Click / ResetSpoolGridButton_Click / ResetSpoolItemGridButton_Click / ResetSpoolWeldGridButton_Click (grid descriptor reset)` | `src/Grids` | member | low | modify |
| #248 | Kelly-Revit `modules/Trade.All/Commands/Spools/SpoolManager/SpoolManagerView.xaml.cs` | `SpoolManagerView.RebindGridAll` | `src/Grids` | member | low | accept |
| #249 | Kelly-Revit `modules/Trade.All/Commands/Supports/SuspendedSupportManage/SuspendedSupportManageView.xaml.cs` | `SuspendedSupportManageView.ResetRadGridView (grid descriptor reset)` | `src/Grids` | member | low | accept |

### Kelly-Revit-UI (work package P5b-ui-ribbon, Linear team KTRUI)

Source packages: Kelly-Revit (KTR5).

| # | Source | Symbol | Into | Kind | Risk | Review |
|---|---|---|---|---|---|---|
| #250 | Kelly-Revit `modules/Trade.All/AllTradeRibbonModule.cs` | `AllTradeRibbonModule.CreateTabAndPanels` | `src/Ribbon` | member | low | accept |
| #251 | Kelly-Revit `modules/Trade.All/Commands/Assigners/CommonComboBoxContextAdoptCommand.cs` | `CommonComboBoxContextAdoptCommand.SetComboBoxItem` | `src/Ribbon` | member | low | modify |
| #252 | Kelly-Revit `modules/Trade.All/Commands/Assigners/DetailingPackageContext/ComboBox/AssignerDetailingPackageComboBox.cs` | `AssignerDetailingPackageComboBox.CreateProjectComboBoxMembers` | `src/Ribbon` | member | medium | accept |
| #253 | Kelly-Revit `modules/Trade.All/Commands/Assigners/DetailingPackageContext/ComboBox/AssignerDetailingPackageComboBox.cs` | `AssignerDetailingPackageComboBox.CreateBasicComboBoxMembers` | `src/Ribbon` | member | medium | modify |
| #254 | Kelly-Revit `modules/Trade.All/Commands/Assigners/DetailingPackageContext/ComboBox/AssignerDetailingPackageComboBox.cs` | `AssignerDetailingPackageComboBox.CreateBasicComboBoxMembers / CreateProjectComboBoxMembers (3 overloads)` | `src/Ribbon` | member | medium | accept |
| #255 | Kelly-Revit `modules/Trade.All/Commands/Assigners/DetailingPackageContext/ComboBox/AssignerDetailingPackageComboBoxSettings.cs` | `AssignerDetailingPackageComboBoxSettings.Name` | `src/Ribbon` | member | low | accept |
| #256 | Kelly-Revit `modules/Trade.All/Commands/Assigners/DetailingPackageContext/ComboBox/DetailingPackageComboBoxEventHandler.cs` | `DetailingPackageComboBoxEventHandler.OnDropDownClosed` | `src/Ribbon` | member | low | accept |
| #257 | Kelly-Revit `modules/Trade.All/Commands/Assigners/DetailingPackageContext/ValueAssign/DetailingPackageAssignerValueSetCommand.cs` | `DetailingPackageAssignerValueSetCommand.Execute` | `src/Ribbon` | member | low | accept |
| #258 | Kelly-Revit `modules/Trade.All/Commands/Assigners/LineNumberContext/ComboBox/AssignerLineNumberComboBox.cs` | `AssignerLineNumberComboBox.CreateProjectComboBoxMembers` | `src/Ribbon` | member | medium | accept |
| #259 | Kelly-Revit `modules/Trade.All/Commands/Assigners/LineNumberContext/ComboBox/AssignerLineNumberComboBox.cs` | `AssignerLineNumberComboBox.CreateBasicComboBoxMembers` | `src/Ribbon` | member | medium | accept |
| #260 | Kelly-Revit `modules/Trade.All/Commands/Assigners/LineNumberContext/ComboBox/AssignerLineNumberComboBox.cs` | `AssignerLineNumberComboBox.CreateBasicComboBoxMembers / CreateProjectComboBoxMembers (3 overloads)` | `src/Ribbon` | member | medium | modify |
| #261 | Kelly-Revit `modules/Trade.All/Commands/Assigners/LineNumberContext/ComboBox/AssignerLineNumberComboBoxSettings.cs` | `AssignerLineNumberComboBoxSettings.Name` | `src/Ribbon` | member | low | accept |
| #262 | Kelly-Revit `modules/Trade.All/Commands/Assigners/LineNumberContext/ComboBox/LineNumberComboBoxEventHandler.cs` | `LineNumberComboBoxEventHandler.OnDropDownClosed` | `src/Ribbon` | member | low | accept |
| #263 | Kelly-Revit `modules/Trade.All/Commands/Assigners/LineNumberContext/ValueAssign/LineNumberAssignerValueSetCommand.cs` | `LineNumberAssignerValueSetCommand.Execute` | `src/Ribbon` | member | low | accept |
| #264 | Kelly-Revit `modules/Trade.All/Commands/Assigners/ModuleNumberContext/ComboBox/AssignerModuleNumberComboBox.cs` | `AssignerModuleNumberComboBox.CreateProjectComboBoxMembers` | `src/Ribbon` | member | medium | accept |
| #265 | Kelly-Revit `modules/Trade.All/Commands/Assigners/ModuleNumberContext/ComboBox/AssignerModuleNumberComboBox.cs` | `AssignerModuleNumberComboBox.CreateBasicComboBoxMembers` | `src/Ribbon` | member | medium | accept |
| #266 | Kelly-Revit `modules/Trade.All/Commands/Assigners/ModuleNumberContext/ComboBox/AssignerModuleNumberComboBox.cs` | `AssignerModuleNumberComboBox.CreateBasicComboBoxMembers / CreateProjectComboBoxMembers (3 overloads)` | `src/Ribbon` | member | medium | accept |
| #267 | Kelly-Revit `modules/Trade.All/Commands/Assigners/ModuleNumberContext/ComboBox/AssignerModuleNumberComboBoxSettings.cs` | `AssignerModuleNumberComboBoxSettings.Name` | `src/Ribbon` | member | low | accept |
| #268 | Kelly-Revit `modules/Trade.All/Commands/Assigners/ModuleNumberContext/ComboBox/ModuleNumberComboBoxEventHandler.cs` | `ModuleNumberComboBoxEventHandler.OnDropDownClosed` | `src/Ribbon` | member | low | accept |
| #269 | Kelly-Revit `modules/Trade.All/Commands/Assigners/ServiceContext/ComboBox/AssignerFabricationServiceComboBox.cs` | `AssignerFabricationServiceComboBox.CreateProjectComboBoxMembers` | `src/Ribbon` | member | medium | accept |
| #270 | Kelly-Revit `modules/Trade.All/Commands/Assigners/ServiceContext/ComboBox/AssignerFabricationServiceComboBox.cs` | `AssignerFabricationServiceComboBox.CreateBasicComboBoxMembers / CreateProjectComboBoxMembers (3 overloads)` | `src/Ribbon` | member | medium | accept |
| #271 | Kelly-Revit `modules/Trade.All/Commands/Assigners/ServiceContext/ComboBox/AssignerServiceComboBoxSettings.cs` | `AssignerServiceComboBoxSettings.Name` | `src/Ribbon` | member | low | accept |
| #272 | Kelly-Revit `modules/Trade.All/Commands/Assigners/ServiceContext/ComboBox/ServiceComboBoxEventHandler.cs` | `ServiceComboBoxEventHandler.OnDropDownClosed` | `src/Ribbon` | member | low | accept |
| #273 | Kelly-Revit `modules/Trade.All/Commands/Assigners/SpoolNumberContext/ComboBox/AssignerSpoolNumberComboBox.cs` | `AssignerSpoolNumberComboBox.CreateProjectComboBoxMembers` | `src/Ribbon` | member | medium | accept |
| #274 | Kelly-Revit `modules/Trade.All/Commands/Assigners/SpoolNumberContext/ComboBox/AssignerSpoolNumberComboBox.cs` | `AssignerSpoolNumberComboBox.CreateBasicComboBoxMembers / CreateProjectComboBoxMembers (3 overloads)` | `src/Ribbon` | member | medium | accept |

### Kelly-Revit-UI (work package P5c-ui-ribbon-scope, Linear team KTRUI)

Source packages: Kelly-Revit (KTR5).

| # | Source | Symbol | Into | Kind | Risk | Review |
|---|---|---|---|---|---|---|
| #275 | Kelly-Revit `modules/Trade.All/Commands/Assigners/SpoolNumberContext/ComboBox/AssignerSpoolNumberComboBoxSettings.cs` | `AssignerSpoolNumberComboBoxSettings.Name` | `src/Ribbon` | member | low | accept |
| #276 | Kelly-Revit `modules/Trade.All/Commands/Assigners/SpoolNumberContext/ComboBox/SpoolNumberComboBoxEventHandler.cs` | `SpoolNumberComboBoxEventHandler.OnDropDownClosed` | `src/Ribbon` | member | low | accept |
| #277 | Kelly-Revit `modules/Trade.All/Commands/Assigners/SystemContext/ComboBox/AssignerSystemComboBox.cs` | `AssignerSystemComboBox.CreateProjectComboBoxMembers` | `src/Ribbon` | member | medium | accept |
| #278 | Kelly-Revit `modules/Trade.All/Commands/Assigners/SystemContext/ComboBox/AssignerSystemComboBox.cs` | `AssignerSystemComboBox.CreateBasicComboBoxMembers / CreateProjectComboBoxMembers (3 overloads)` | `src/Ribbon` | member | medium | accept |
| #279 | Kelly-Revit `modules/Trade.All/Commands/Assigners/SystemContext/ComboBox/AssignerSystemComboBoxSettings.cs` | `AssignerSystemComboBoxSettings.Name` | `src/Ribbon` | member | low | accept |
| #280 | Kelly-Revit `modules/Trade.All/Commands/Assigners/SystemContext/ComboBox/SystemComboBoxEventHandler.cs` | `SystemComboBoxEventHandler.OnDropDownClosed` | `src/Ribbon` | member | low | accept |
| #281 | Kelly-Revit `modules/Trade.All/RibbonItems/ComboBoxExtensions.cs` | `ComboBoxExtensions.GetComboBox` | `src/Ribbon` | member | low | accept |
| #282 | Kelly-Revit `modules/Trade.All/RibbonItems/ComboBoxExtensions.cs` | `ComboBoxExtensions.WithoutPlaceholder` | `src/Ribbon` | member | low | accept |
| #283 | Kelly-Revit `modules/Trade.All/RibbonItems/Panels/GeneralRibbonPanelConfiguration.cs` | `GeneralRibbonPanelConfiguration.CreateItems (panel null guard and Name setup)` | `src/Ribbon` | member | low | modify |
| #284 | Kelly-Revit `modules/Trade.All/RibbonItems/StackedButtons/LineNumberModuleAssemblyStackedButtons/LineNumberModuleSpoolComboBoxStackedButtons.cs` | `LineNumberModuleSpoolComboBoxStackedButtons.Create` | `src/Ribbon` | member | medium | accept |
| #285 | Kelly-Revit `modules/Trade.All/RibbonItems/StackedButtons/ServiceSystemPackageStackedButtons/ServiceSystemPackageComboBoxStackedButtons.cs` | `ServiceSystemPackageComboBoxStackedButtons.Create` | `src/Ribbon` | member | medium | modify |
| #286 | Kelly-Revit `modules/Trade.Contenter/ContenterRibbonModule.cs` | `ContenterRibbonModule.CreateTabAndPanels` | `src/Ribbon` | member | low | accept |
| #287 | Kelly-Revit `modules/Trade.Developer/DeveloperRibbonModule.cs` | `DeveloperRibbonModule.CreateTabAndPanels` | `src/Ribbon` | member | low | accept |
| #288 | Kelly-Revit `modules/Trade.Duct/DuctTradeRibbonModule.cs` | `DuctTradeRibbonModule.CreateTabAndPanels` | `src/Ribbon` | member | low | accept |
| #289 | Kelly-Revit `modules/Trade.Manager/ManagerRibbonModule.cs` | `ManagerRibbonModule.CreateTabAndPanels` | `src/Ribbon` | member | low | accept |
| #290 | Kelly-Revit `modules/Trade.Pipe/PipeTradeRibbonModule.cs` | `PipeTradeRibbonModule.CreateTabAndPanels` | `src/Ribbon` | member | low | accept |
| #291 | Kelly-Revit `modules/Trade.All/Commands/Spools/ModuleManage/ModuleManageViewModel.cs` | `ModuleManageViewModel.SelectElementsInView (set selection, then ShowElements when zooming)` | `src/Scope` | member | low | modify |
| #292 | Kelly-Revit `modules/Trade.All/Commands/Spools/SpoolManager/SpoolManagerViewModel.cs` | `SpoolManagerViewModel.SetSelectedObjects (element ids of SpoolItem/Spool rows, then select and optionally zoom)` | `src/Scope` | member | low | accept |
| #293 | Kelly-Revit `modules/Trade.All/Commands/Acquired/Vicious/Disconnect/ViciousInstanceDisconnectCommand.cs` | `ViciousInstanceDisconnectCommand.TryPick` | `src/Selection` | member | low | accept |
| #294 | Kelly-Revit `modules/Trade.All/Commands/Spools/ModuleManage/ModuleManageViewModel.cs` | `ModuleManageViewModel.SelectElementsInView (select and zoom)` | `src/Selection` | member | low | modify |
| #295 | Kelly-Revit `modules/Trade.All/Commands/Spools/SpoolManager/SpoolManagerViewModel.cs` | `SpoolManagerViewModel.SetSelectedObjects (select and zoom)` | `src/Selection` | member | low | modify |
| #296 | Kelly-Revit `modules/Trade.Pipe/Commands/OletChecker/Support/SelectionExternalEventHandler.cs` | `SelectionExternalEventHandler.Execute (set selection, then ShowElements when zooming)` | `src/Selection` | member | low | accept |

### Kelly-Revit (work package P6a-revit-assigners-scheduleexport, Linear team KTR5)

Source packages: none (same layer).

| # | Source | Symbol | Into | Kind | Risk | Review |
|---|---|---|---|---|---|---|
| #297 | Kelly-Revit `modules/Trade.All/Commands/Assigners/ServiceContext/ComboBoxReset/ServiceAssignerToolResetCommand.cs` | `ServiceAssignerToolResetCommand.Execute` | `modules/Trade.All/Commands/Assigners` | member | low | accept |
| #298 | Kelly-Revit `modules/Trade.All/Commands/Assigners/SystemContext/ComboBoxReset/SystemAssignerToolResetCommand.cs` | `SystemAssignerToolResetCommand.Execute` | `modules/Trade.All/Commands/Assigners` | member | low | accept |
| #299 | Kelly-Revit `modules/Trade.All/Commands/ScheduleExport/ViewScheduleExportToXlsxFile/ViewScheduleToExcelFileExportCommand.cs` | `ViewScheduleToExcelFileExportCommand.ExportSelectedSchedules (Excel application and workbook lifecycle)` | `modules/Trade.All/Commands/ScheduleExport` | member | medium | accept |
| #300 | Kelly-Revit `modules/Trade.All/Commands/ScheduleExport/ViewScheduleExportToXlsxFile/ViewScheduleToExcelFileExportCommand.cs` | `ViewScheduleToExcelFileExportCommand.ExportSelectedSchedules (Excel application start and quit)` | `modules/Trade.All/Commands/ScheduleExport` | member | low | accept |
| #301 | Kelly-Revit `modules/Trade.All/Commands/ScheduleExport/ViewScheduleExportToXlsxFiles/ViewScheduleToExcelFilesExportCommand.cs` | `ViewScheduleToExcelFilesExportCommand.ExportSelectedSchedules/ExportSchedule (Excel application and workbook lifecycle)` | `modules/Trade.All/Commands/ScheduleExport` | member | medium | accept |
| #302 | Kelly-Revit `modules/Trade.All/Commands/ScheduleExport/ViewScheduleExportToXlsxFiles/ViewScheduleToExcelFilesExportCommand.cs` | `ViewScheduleToExcelFilesExportCommand.ExportSelectedSchedules (Excel application start and quit)` | `modules/Trade.All/Commands/ScheduleExport` | member | low | accept |

## Decisions needed

43 medium-risk moves (all others are low risk). Overlapping records for the same members (the assigner combo boxes #252 to #278, the two stacked-button builders #284 and #285) are merged into one change per member when the packages are written:

- #3 ConnectorTools.GetConnectedRun (breadth-first shortest path and path reconstruction) `src/Connectors/ConnectorTools.cs` -> Kelly-Windows: Read lines 221-293: the BFS core (visited HashSet, cameFrom Dictionary, Queue, break on first hit of endId, rebuild from endId via cameFrom and Reverse) uses no Revit type beyond ElementId as the node type; Revit is only in the neighbour function (document.Get
- #14 ApplicationSession `src/Projects/ApplicationSession.cs` -> Kelly-Windows: ApplicationSession depends only on BCL (Assembly, DateTime) and Kelly.Windows.Workstation.WorkstationModel; it has no Kelly business meaning, so the lowest fitting layer is Kelly-Windows (Hosting/workstation concern listed for layer 2). It currently breaks rul
- #19 ExternalParameterDefinitionCache.GetData / FillCache / ClearCache `src/Caches/ExternalParameterDefinitionCache.cs` -> Kelly-Windows: Confirmed: ExternalParameterDefinitionCache re-implements RecordCache's lifecycle (Objects, FillCache copying the List, ClearCache, GetData returning early on no records and leaving Objects untouched). The six other Domain caches already derive from RecordCach
- #24 TaskDialogSimple.TaskDialogError, TaskDialogInformation, TaskDialogWarning `src/Common/TaskDialogSimple.cs` -> Kelly-Windows: Confirmed: the three members only build a PromptRequest (title, PromptButtons.Ok, an Error/Information/Warning icon, MainContent, MainInstruction = title) and call UserPrompt.Show; every type is in Kelly.Windows.Prompts, so Kelly-Windows (beside UserPrompt.Con
- #25 LayoutPointToCommaSeparatedValueFileExportView.CenterOnCurrentMonitor `modules/Trade.All/Commands/Layout/LayoutPointExport/LayoutPointToCommaSeparatedValueFileExportView.xaml.cs` -> Kelly-Windows: This copy duplicates Kelly-Windows WindowExtensions.Move(ScreenPosition.MiddleCenter), so the dedup target is right and needs no new code in Kelly-Windows. Replacing it changes behaviour, and the rules say behaviour is preserved and bugs are recorded, not fixe
- #35 Module.NestedDefinitionSet `src/Spools/Module.cs` -> Kelly-Domain: Refuted as proposed. Module.cs line 10 passes the WHOLE set to ElementFilterTools.InstanceHavingParameterOfTypeStringValue(document, IDefinitionSet, ...), which adds AndListOfSharedParameters(definitionSet), meaning the element must carry every definition in t
- #70 ElementComponent (validated column properties and ItemNumber display) `src/Spools/ElementComponent.cs` -> Kelly-Domain: Read ElementComponent and ModelBase. The validation attributes and ItemNumber are Revit-free Kelly rules, and their dependencies resolve in Domain or below: ModelBase and BoolAttribute in Kelly.Windows, ModuleNumber and SpoolItemNumberFormat in Kelly-Domain. T
- #96 ArrangeDistributeTagsAroundCommand.Execute (transaction group and exception mapping) `modules/Trade.All/Commands/Acquired/Arrange/DistributeAround/ArrangeDistributeTagsAroundCommand.cs` -> Kelly-Revit-Logic: Confirmed: the command owns the "Arrange Tags" TransactionGroup, the Transaction and the rollback around TagDistributor.DistributeAroundCropBox, which is Revit database work. The sibling AnnotationArranger.Arrange in Logic already owns its own group and rollba
- #104 ManyConnectCommand.Transaction `modules/Trade.All/Commands/ManyConnect/ManyConnectCommand.cs` -> Kelly-Revit-Logic: OperationService (AnyConnect), ElementTransformUtils.MoveElement, Connector.ConnectTo/IsConnectedTo, TaskDialogSimple.TaskDialogWarning (Logic Common), exception.HandleIt (Kelly-Windows ExceptionExtensions) and FailToStartNotification are all RevitAPI, Logic o
- #116 ElementDeleteCommand.Execute (delete by id inside OperationService) `modules/Trade.Manager/Commands/DeleteById/ElementDeleteCommand.cs` -> Kelly-Revit-Logic: The OperationService start, Document.Delete, the contains check, Increment, Stop and FailToStartNotification are all RevitAPI and Logic transaction code, matching the other Delete*Transaction extensions in Logic DocumentExtensions. TaskDialogSimple is in Kelly
- #118 DocumentOpenedEventHandler.Execute `src/EventHandlers/DocumentOpenedEventHandler.cs` -> Kelly-Revit-Logic: Confirmed: apart from App.ServiceProvider, App.Caches and the TaskDialog, the handler uses only RevitAPI.dll and Logic members (DocumentExtensionsJhk.GetMissingSharedParameterNames returns HashSet<string>, IsKellyProject, AutoUpdaterService.Build(Document) in 
- #142 IsTrapezeSelectedCommandEnabler.IsCommandAvailable (top-level trapeze rule) `modules/Trade.All/RibbonItems/PushButtons/ExternalCommandAvailability/IsTrapezeSelectedCommandEnabler.cs` -> Kelly-Revit-Logic: Confirmed: the enabler's predicate (SuperComponent == null and family name contains "Trapeze") is conditions 1 and 3 of Logic's FamilyInstanceExtensions.IsValidSuspendedSupportTrapeze, RevitAPI only, so it belongs in Logic src/Families; the enabler also re-wri
- #144 ViciousFileBasedSystemPipePlaceTools.SetWorkPlaneAndPickObject (plane from face, temporary work plane) `modules/Trade.All/Commands/Acquired/Vicious/PointToPipe/ViciousFileBasedSystemPipePlaceTools.cs` -> Kelly-Revit-Logic: Read lines 392-458: after the PickObject, the code (GetGeometryObjectFromReference as PlanarFace, the last-GeometryInstance transform, Plane.CreateByNormalAndOrigin, SketchPlane.Create, View.SketchPlane, ShowActiveWorkPlane) uses RevitAPI.dll only. Logic has n
- #145 ViciousInstanceRotateMoveCommand.SelectRotationAxis (axis from element) `modules/Trade.All/Commands/Acquired/Vicious/Rotate/ViciousInstanceRotateMoveCommand.cs` -> Kelly-Revit-Logic: After the pick, the axis is geometry: LocationCurve end points for a straight, or the connector points from Logic's VictaulicConnectorTools for a fitting. Only the category rules tie it to Kelly-Revit-UI, through the ISelectionFilter classes. Those rules are a
- #146 LayoutPointToCommaSeparatedValueFileExportViewModel.Export `modules/Trade.All/Commands/Layout/LayoutPointExport/LayoutPointToCommaSeparatedValueFileExportViewModel.cs` -> Kelly-Revit-Logic: Lines 237-279 are an OperationService transaction: WriteCsv, SetValue of JHK Layout Point Exported with Increment per candidate, Stop, then ViewPlan.Export. Everything it calls is in Logic: OperationService, LayoutPointTools.WriteCsv, DefinitionSetCache/JhkLay
- #148 LayoutPointToCommaSeparatedValueFileExportViewModel.Save `modules/Trade.All/Commands/Layout/LayoutPointExport/LayoutPointToCommaSeparatedValueFileExportViewModel.cs` -> Kelly-Revit-Logic: It groups the candidates by HostElement.Id, calls SaveToHostElement per host inside an OperationService (LayoutPointSaveToElement) and counts with Increment only the saved hosts. That is Revit database work, and its dependencies are in Logic. Only the grid rea
- #153 ViciousFileBasedSystemPipePlaceTools.Execute (pipe type, piping system type and fabrication service lookup) `modules/Trade.All/Commands/Acquired/Vicious/PointToPipe/ViciousFileBasedSystemPipePlaceTools.cs` -> Kelly-Revit-Logic: Confirmed. Execute builds its own PipeType and PipingSystemType collectors, the same work as Logic's DocumentExtensions.GetElementsByType<T>(). It then resolves the pipe type by name, with the last match winning and a case-sensitive ==, and when no pipe type m
- #171 SuspendedSupportManagerViewModel.RunSelectionOperation (operation + progress + rollback wrapper) `modules/Trade.All/Commands/Supports/SuspendedSupportManage/SuspendedSupportManagerViewModel.cs` -> Kelly-Revit-Logic: Confirmed (VM lines 476-512): Start, FailToStartNotification on no start, ObjectCountSelected after Start, ProgressReporter.Start(title, operationService.Name, count) (Kelly.Windows, already used throughout Logic, e.g. GroupTools, BillOfMaterialTypeAssigner), 
- #181 ModuleManageViewModel.UpdateBillOfMaterialType (write JHK BOM Type = Module to components, mirror on commit) `modules/Trade.All/Commands/Spools/ModuleManage/ModuleManageViewModel.cs` -> Kelly-Revit-Logic: The transaction part runs a BillOfMaterialTypeUpdate OperationService over ElementComponent.Element.SetValue(DefinitionSet.JhkBomType, nameof(BillOfMaterialType.Module), CancelValue.String), with rollback on exception and a read of IsCommitted. It is Revit dat
- #184 SpoolCreateViewModel.Create / CreateSpool / UpdateSpoolData / UpdateSpoolName (spool creation transactions) `modules/Trade.All/Commands/Spools/SpoolCreate/SpoolCreateViewModel.cs` -> Kelly-Revit-Logic: CreateSpool, UpdateSpoolData and UpdateSpoolName are three OperationService transactions over Logic types only: Spool(List<Element>, Document), Spool.WriteIdentificationParameters and AssemblyInstance.AssemblyTypeName. They need no RevitAPIUI, and Command.UiDo
- #198 SuspendedSupportManagerViewModel.BuildSuspendedSupports (support model build) and nested NestedDefinitionSet `modules/Trade.All/Commands/Supports/SuspendedSupportManage/SuspendedSupportManagerViewModel.cs` -> Kelly-Revit-Logic: Lines 357-377: TryParse, GetData and the long-description progress label are Logic work on a Logic model, and IProgressReporter is in Kelly-Windows, so Logic can take it. The nested NestedDefinitionSet is read only for that label (JhkSupportElevation is never 
- #199 SuspendedSupportManagerViewModel.AttachOrExtendToStructure (inner AttachOrExtend host switch) / ExtendToStructure(FabricationPart, Transaction) `modules/Trade.All/Commands/Supports/SuspendedSupportManage/SuspendedSupportManagerViewModel.cs` -> Kelly-Revit-Logic: Lines 311-325 and 380-387: a switch on HostElement that runs FabricationPart.GetRodInfo().AttachToStructure() in the given Transaction (Start/Commit) or TrapezeVerticalMemberTools.ResetAndExtendToStructure (Logic). It is RevitAPI-only behaviour of SuspendedSup
- #209 FabricationCustomDataUpdaterCommandV2.RunCommand (pass 2 per-part write: ownership re-check, SubTransaction write, ElementChangeError) `modules/Trade.Contenter/Commands/FabricationCustomDataUpdaterV2/FabricationCustomDataUpdaterCommandV2.cs` -> Kelly-Revit-Logic: The per-part write uses only RevitAPI (SubTransaction, WorksharingUtils) and Logic types: CustomDataUpdater (src/Updaters), ElementChangeError (src/Elements) and OperationService. CustomDataUpdateEvaluator.EvaluatePart already holds the read-pass twin of the o
- #230 Arranger.Elements `modules/Trade.All/Commands/Acquired/Arrange/Arranger.cs` -> Kelly-Revit-UI: The duplication is confirmed. Arranger.Elements and ArrangeDistributeTagsAroundCommand.Execute are the only two places with the same three catches (Revit OperationCanceledException gives Cancelled, ErrorMessageException gives Failed, Exception gives Failed, ea
- #252 AssignerDetailingPackageComboBox.CreateProjectComboBoxMembers `modules/Trade.All/Commands/Assigners/DetailingPackageContext/ComboBox/AssignerDetailingPackageComboBox.cs` -> Kelly-Revit-UI: Read all six combo boxes: the two event-args overloads and the Document loop (CreateComboBoxMemberData(document, text), AddItem, Current = GetItems()[0]) are identical; only the item source differs (DetailingPackage/LineNumber/ModuleNumber/SpoolNumber caches' 
- #253 AssignerDetailingPackageComboBox.CreateBasicComboBoxMembers `modules/Trade.All/Commands/Assigners/DetailingPackageContext/ComboBox/AssignerDetailingPackageComboBox.cs` -> Kelly-Revit-UI: Right idea: the header + Refresh List builder is identical across the six boxes and uses only UI-owned members (StandardItemsContextSelector, CreateComboBoxMemberData(string), AddItem), so it belongs in Kelly-Revit-UI RibbonComboBox; IRibbonComboBox already de
- #254 AssignerDetailingPackageComboBox.CreateBasicComboBoxMembers / CreateProjectComboBoxMembers (3 overloads) `modules/Trade.All/Commands/Assigners/DetailingPackageContext/ComboBox/AssignerDetailingPackageComboBox.cs` -> Kelly-Revit-UI: Read: identical to the LineNumber copy except header DetailingPackage and DetailingPackageDocumentCache(document).Cache Value. Leaf keeps its constructors and settings.
- #258 AssignerLineNumberComboBox.CreateProjectComboBoxMembers `modules/Trade.All/Commands/Assigners/LineNumberContext/ComboBox/AssignerLineNumberComboBox.cs` -> Kelly-Revit-UI: Verified verbatim copy; only LineNumberDocumentCache differs. Same reasoning as the DetailingPackage combo box move.
- #259 AssignerLineNumberComboBox.CreateBasicComboBoxMembers `modules/Trade.All/Commands/Assigners/LineNumberContext/ComboBox/AssignerLineNumberComboBox.cs` -> Kelly-Revit-UI: Verified copy (Headers.LineNumber, Refresh List, no extras). Same reasoning as the DetailingPackage basic-members move.
- #260 AssignerLineNumberComboBox.CreateBasicComboBoxMembers / CreateProjectComboBoxMembers (3 overloads) `modules/Trade.All/Commands/Assigners/LineNumberContext/ComboBox/AssignerLineNumberComboBox.cs` -> Kelly-Revit-UI: Confirmed by reading all six leaves: CreateBasicComboBoxMembers (header list + add loop), the two event-args overloads and the per-document loop are identical except the headers and the item-text source; each carries 'TODO: Refactor into base class'. RibbonCom
- #264 AssignerModuleNumberComboBox.CreateProjectComboBoxMembers `modules/Trade.All/Commands/Assigners/ModuleNumberContext/ComboBox/AssignerModuleNumberComboBox.cs` -> Kelly-Revit-UI: Verified verbatim copy; only ModuleNumberDocumentCache differs. Same reasoning as the DetailingPackage combo box move.
- #265 AssignerModuleNumberComboBox.CreateBasicComboBoxMembers `modules/Trade.All/Commands/Assigners/ModuleNumberContext/ComboBox/AssignerModuleNumberComboBox.cs` -> Kelly-Revit-UI: Verified copy (Headers.Module, Refresh List, no extras). Same reasoning as the DetailingPackage basic-members move.
- #266 AssignerModuleNumberComboBox.CreateBasicComboBoxMembers / CreateProjectComboBoxMembers (3 overloads) `modules/Trade.All/Commands/Assigners/ModuleNumberContext/ComboBox/AssignerModuleNumberComboBox.cs` -> Kelly-Revit-UI: Read: identical except header Module and ModuleNumberDocumentCache(document).Cache Value.
- #269 AssignerFabricationServiceComboBox.CreateProjectComboBoxMembers `modules/Trade.All/Commands/Assigners/ServiceContext/ComboBox/AssignerFabricationServiceComboBox.cs` -> Kelly-Revit-UI: Read all six assigner combo boxes in v5: CreateBasicComboBoxMembers (list of CreateComboBoxMemberData(text) then AddItem each), the two event overloads (ActiveUIDocument.Document / args.Document) and the Document loop (AddItem(CreateComboBoxMemberData(document
- #270 AssignerFabricationServiceComboBox.CreateBasicComboBoxMembers / CreateProjectComboBoxMembers (3 overloads) `modules/Trade.All/Commands/Assigners/ServiceContext/ComboBox/AssignerFabricationServiceComboBox.cs` -> Kelly-Revit-UI: Read: identical except three basic items (Headers.Service, RefreshList, ServiceMultiple) and items ServiceDocumentCache(document).Cache GetSignature(). AddBasicMembers(params string[]) covers the third header in the same order.
- #273 AssignerSpoolNumberComboBox.CreateProjectComboBoxMembers `modules/Trade.All/Commands/Assigners/SpoolNumberContext/ComboBox/AssignerSpoolNumberComboBox.cs` -> Kelly-Revit-UI: Verified copy of the fill template (headers Spool, RefreshList; SpoolNumberDocumentCache(document).Cache.Select(s => s.Value)). Grep across all repos shows no caller of the public Document overload outside the class; every external call passes event args. Maki
- #274 AssignerSpoolNumberComboBox.CreateBasicComboBoxMembers / CreateProjectComboBoxMembers (3 overloads) `modules/Trade.All/Commands/Assigners/SpoolNumberContext/ComboBox/AssignerSpoolNumberComboBox.cs` -> Kelly-Revit-UI: Read: identical except header Spool and SpoolNumberDocumentCache; its CreateProjectComboBoxMembers(Document) is public but grep finds no caller outside the class (CommonComboBoxContextAdoptCommand and AssignerComboBoxPopulator use only the interface members), 
- #277 AssignerSystemComboBox.CreateProjectComboBoxMembers `modules/Trade.All/Commands/Assigners/SystemContext/ComboBox/AssignerSystemComboBox.cs` -> Kelly-Revit-UI: Verified line-for-line copy of the fill template; subclass keeps new SystemDocumentCache(document, DataFiles.Store).Cache.Select(s => s.GetSignature()) and the headers System, RefreshList, SystemMultiple. DataFiles.Store stays in the module subclass, so the UI
- #278 AssignerSystemComboBox.CreateBasicComboBoxMembers / CreateProjectComboBoxMembers (3 overloads) `modules/Trade.All/Commands/Assigners/SystemContext/ComboBox/AssignerSystemComboBox.cs` -> Kelly-Revit-UI: Read: identical except headers System/RefreshList/SystemMultiple and SystemDocumentCache(document, DataFiles.Store) GetSignature(); DataFiles.Store stays in the leaf's GetProjectItemTexts, so the base needs no data seam.
- #284 LineNumberModuleSpoolComboBoxStackedButtons.Create `modules/Trade.All/RibbonItems/StackedButtons/LineNumberModuleAssemblyStackedButtons/LineNumberModuleSpoolComboBoxStackedButtons.cs` -> Kelly-Revit-UI: Read it: this is the second copy of the same shell (same count check and message, same assign, wire, then CreateBasicComboBoxMembers order). Repointing it to the single Kelly-Revit-UI helper removes the duplication. It depends on the modified service/system/pa
- #285 ServiceSystemPackageComboBoxStackedButtons.Create `modules/Trade.All/RibbonItems/StackedButtons/ServiceSystemPackageStackedButtons/ServiceSystemPackageComboBoxStackedButtons.cs` -> Kelly-Revit-UI: The two combo-box stacking classes repeat the same multi-step shell: AddStackedItems of the ComboBoxData, the count check with the same message, a silent skip on a non-ComboBox item, assigning ComboBox, wiring events, then CreateBasicComboBoxMembers. It uses o
- #299 ViewScheduleToExcelFileExportCommand.ExportSelectedSchedules (Excel application and workbook lifecycle) `modules/Trade.All/Commands/ScheduleExport/ViewScheduleExportToXlsxFile/ViewScheduleToExcelFileExportCommand.cs` -> Kelly-Revit: Confirmed line by line: the hidden Application initializer (Visible/DisplayAlerts/ScreenUpdating false), the 12-argument SaveAs with xlWorkbookDefault, the null-checked Close(false)+Release and the null-checked Quit+Release+GC.Collect+WaitForPendingFinalizers 
- #301 ViewScheduleToExcelFilesExportCommand.ExportSelectedSchedules/ExportSchedule (Excel application and workbook lifecycle) `modules/Trade.All/Commands/ScheduleExport/ViewScheduleExportToXlsxFiles/ViewScheduleToExcelFilesExportCommand.cs` -> Kelly-Revit: Confirmed second copy of the same start/SaveAs/Close/Quit code; one copy in ExcelInteropTools, same assembly and namespace, no runtime identity risk.

## Rejected (and why)

- `Kelly-Revit:src/EventHandlers/DocumentOpenedEventHandler.cs#DocumentOpenedEventHandler.VerifySharedParameters`: VerifySharedParameters calls Document.GetMissingSharedParameterNames (Revit) and App.Caches, so as a member it cannot go to Kelly-Domain. The proposal only extracts its message text, and that text is the content of one host TaskDialog, which is presentation. It also encodes Revit behaviour in a stri
- `Kelly-Revit:src/App.cs#App.GetDefinition`: There is little to gain and a full stack repin to pay. The null check already duplicates DefinitionRegistry.Resolve, which returns null for a null name before it calls the resolver. What is left is a single TryGetValue on the public, OrdinalIgnoreCase CacheByDefinitionName dictionary that the Domain
- `Kelly-Revit:src/EventHandlers/ViewActivatedEventHandler.cs#ViewActivatedEventHandler.IsSameDocument`: The duplication is real (I read both), but both copies are dead in practice: their only caller does nothing with the result ('if (IsSameDocument(args)) { // Could still be useful }'). Lifting dead code into a new public Kelly-Revit-Logic API means adding XML docs, a Changelog entry, an in-Revit test
- `Kelly-Revit:src/EventHandlers/ViewActivatingEventHandler.cs#ViewActivatingEventHandler.IsSameDocument`: This is the second copy of the same dead comparison. Its result only feeds an empty 'Could still be useful' branch, and Execute has already returned when either view is null, so the null checks inside it are redundant too. It also depends on the ViewActivated move, which is rejected. A public Logic 
- `Kelly-Revit:src/Services/ApplicationSessionService.cs#ApplicationSessionService.OnApplicationInitialized`: OnApplicationInitialized is the host service's event handler. It casts the sender, which is the host's subscription contract, uses Assembly.GetExecutingAssembly(), which is assembly identity and must stay in Kelly-Revit, and assigns the service's own state. What would move is one object initializer 
- `Kelly-Revit:modules/Trade.All/Commands/Acquired/Vicious/HangerPlace/ViciousFabricationHangerInstancePlaceCommand.cs#ViciousFabricationHangerInstancePlaceCommand.Execute`: This is churn, not a real gain. The code is one RevitAPI call chain, FabricationConfiguration.GetFabricationConfiguration(doc).GetService(part.ServiceId), plus two calls that are already Logic members (GetHangerButtons, GetOrderedButtonDatas). No other site in any layer repeats the service lookup. T
- `Kelly-Revit:modules/Trade.All/Commands/Acquired/Vicious/PointToPipe/ViciousFileBasedSystemPipePlaceTools.cs#ViciousFileBasedSystemPipePlaceTools.Execute (placement origins and transform)`: Rejected because it is unclear the move is safe and an improvement. The Revit parts are single API calls: BasePoint.GetProjectBasePoint(document).Position and ActiveProjectLocation.GetTotalTransform(). These calls are interleaved with four user messages whose order must be kept (pipe types, family d
- `Kelly-Revit:modules/Trade.All/Commands/Acquired/Vicious/PointToPipe/ViciousFileBasedSystemPipePlaceTools.cs#ViciousFileBasedSystemPipePlaceTools.Execute (input completeness check)`: The check on line 44 is not a Point To Pipe business rule. It is the tool's way of telling that the dialog was closed without OK: every field still has its default (string.Empty or 0), because OkButton_Click never ran. That is UI orchestration state. A seven-parameter PointToPipeInputs.AreComplete i
- `Kelly-Revit:modules/Trade.All/Commands/Acquired/Vicious/Rotate/ViciousInstanceRotateMoveCommand.cs#ViciousInstanceRotateMoveCommand.RotateElements`: RotateElements is two direct one-line ElementTransformUtils calls with AngleExtensions.DegreesToRadians, which already lives in Kelly-Windows. It holds no rule, calculation or duplication, and no other caller in any repo rotates elements. Wrapping it in a Logic ElementRotation type is churn: a comma
- `Kelly-Revit:modules/Trade.All/Commands/Acquired/Vicious/Rotate/ViciousInstanceRotateMoveView.xaml.cs#ViciousInstanceRotateMoveView.CloseButton_Click, RotateLeftButton_Click, RotateRightButton_Click, AngleTextBox_KeyDown (angle text parsing)`: Each handler already makes one BCL parse call with the shared Kelly.Windows AngleExtensions.AngleFormat or the invariant culture. There is no hand-written parsing logic to take out. AngleExtensions records the earlier decision that 'each caller keeps its own parse or format call', and only the user 
- `Kelly-Revit:modules/Trade.All/Commands/Assigners/ServiceContext/FillColorFilterAssign/ServiceFillColorViewFilterCommand.cs#ServiceFillColorViewFilterCommand.Execute`: Not behaviour-preserving as proposed, and churn if made so. Kelly-Revit-Logic ExternalParameterDefinitionExtensions.GetBoundCategoryIds throws InvalidOperationException when the signature parameter is not in the document. Today it runs before the OperationService is created, and before DataFiles.Get
- `Kelly-Revit:modules/Trade.All/Commands/Assigners/SystemContext/FillColorFilterAssign/SystemFillColorViewFilterCommand.cs#SystemFillColorViewFilterCommand.Execute`: Depends on the rejected CreateAndApplySignatureFill move and has the same problem. Today GetBoundCategoryIds (it throws InvalidOperationException when the parameter is missing) and SharedParameterElement.Lookup run before the operation and before DataFiles.GetSystems. Moving them inside the transact
- `Kelly-Revit:modules/Trade.All/Commands/ManyConnect/ManyConnectCommand.cs#ManyConnectCommand.ConfirmConnectionIfNotPerfect (alignment rule)`: The angle calculation already moved to ConnectorTools.GetAngleBetweenDegrees. What is left is one comparison (angle > 180 - tolerance) against a tolerance the caller passes in. ConnectorTools already has AreFacingEachOther(a, b, dot tolerance), a facing predicate whose tolerance means something else
- `Kelly-Revit:modules/Trade.All/Commands/About/ApplicationAboutModel.cs#ApplicationAboutModel`: Every property is a one-line forward for display: Revit Application properties, the Logic DocumentExtensions GetPath/GetTitle (already in Logic) and the host Assembly. There is no rule, calculation or Kelly concept to move, nothing else uses it, and it exists only to bind one window. That is present
- `Kelly-Revit:modules/Trade.All/RibbonItems/ComboBoxExtensions.cs#ComboBoxExtensions`: Not a layer move: the type stays in the same assembly and layer (Trade.All), and its namespace already matches its folder (rule 5 holds). Relocating it from RibbonItems to Commands/Assigners and renaming it is a same-module cleanup that breaks the string-named type lookup in RibbonSelectionTests and
- `Kelly-Revit:modules/Trade.All/RibbonItems/StackedButtons/BillOfMaterialsSetterStackedButtons.cs#BillOfMaterialsSetterStackedButtons.Create`: The shared 'shell' is one call, panel.AddStackedItems(a, b, c). Unlike RibbonSplitButton, there is no type check or extra steps to factor out. A list-driven base replaces the compile-time 2- or 3-item overloads with a runtime count check (weaker), needs multi-group support for the Filters classes, a
- `Kelly-Revit:modules/Trade.Contenter/Commands/FabricationCustomDataUpdaterV2/FabricationCustomDataUpdaterCommandV2.cs#FabricationCustomDataUpdaterCommandV2.RunCommand (custom data point status list text)`: This is the MainContent text of the command's own 'Missing Custom Data Point(s) Error' TaskDialog: a dialog message built from a tuple that Logic's HasAllCustomDataPoints returns. That makes it presentation: the command's own message, used only here, with no business rule or reusable conversion. Mov
- `Kelly-Revit-Logic:src/Updaters/ElementServices/SuspendedSupportElementService.cs#SuspendedSupportElementService.UpdateElements (support dimension calculations)`: This is not a model or view model, so rule 6's 'whatever its size' does not apply, and the gain has to be real. It is not. RoundDimension would only wrap ConstructionServices.RoundInchesOfDecimalFeet(x, OneSixTeenth, Down), which already lives in Kelly-Windows and is already testable. The double.Max
- `Kelly-Revit-Logic:src/Updaters/CustomDataUpdateEvaluator.cs#CustomDataUpdateEvaluator.EvaluatePart (Revit-free checks)`: The three pieces are trivial and are not in a model or view model. One is an int != int with a message, one is a single Dictionary.TryGetValue with a message, and one is only an error string. Moving them would split EvaluatePart's sequence across two layers, with the Revit ownership check (Workshari
- `Kelly-Revit-Logic:src/Updaters/ElementService.cs#ElementService.UpdateElements (remembered prompt answer)`: The remembered-answer logic is generic, but it has exactly one user: ElementService.UpdateElements. GroupTools.cs:95 reads VerificationChecked differently, as a one-off confirm. The modules' TaskDialogs all set VerificationText = null, so no other 'apply to the remaining' prompt exists to share it. 
- `Kelly-Revit-Logic:src/Geometry/CoordinateExtensions.cs#CoordinateExtensions.IsEqualTo(XYZ, XYZ, double)`: Three lines of per-axis comparison with one production caller (CoordinateTestingCommand) and no Point3 caller anywhere. Both options the proposal offers fail the rules: forwarding through ToPoint3 changes the exception for a null argument (NullReferenceException becomes ArgumentNullException) and al
- `Kelly-Revit-Logic:src/Views/VisibilityCommon.cs#VisibilityCommon.ApplyOrCreateViewFilterTransaction and ApplyViewFilter ("Select" placeholder check)`: The "Select" prefix is the placeholder text of the ribbon combo boxes, which Kelly-Revit-UI's StandardItemsContextSelector defines: a UI convention, not a Kelly business rule or a view filter name. ViewFilterNames holds persisted filter names, and its own remarks record that round 2a deliberately le
- `Kelly-Revit-Logic:src/Views/ViewExtensions.cs#ViewExtensions.IsTagAbleView`: The two switches do accept the same five view types today, but they are two separate rules: whether a view can be tagged (used by IsDuctItemNumberAbleViewCommandEnabler) and whether Revit allows view filters on it (used by IsViewFilterEligibleCommandEnabler and ViewExtensions.GetFilters). The propos
- `Kelly-Domain:src/Categories/BuiltInCategoryMetaRecord.cs#BuiltInCategoryMetaRecord`: Not a clear improvement. The record is a Revit-free IRecord DTO for the dbo.BuiltInCategoryMeta table: primitive properties and BoolJsonConverter attributes, the same shape and folder as its siblings in Kelly-Domain src/Categories (BuiltInCategoryBindingRecord, BuiltInCategoryRecord and CategoryType
- `Kelly-Windows:src/Common/QualityCheck.cs#QualityCheck`: QualityCheck is a generic check-outcome enum (Caution, Checked, Danger, Fail, Good, Indeterminate, Invalid, Pass, Proceed, UnChecked) with no Kelly or layout-point meaning in its members or XML docs, so its concern fits Kelly-Windows (generic, reusable), the lowest valid layer; it is not a Kelly-spe
- `Kelly-Windows:src/Persistence/RecordCache.cs#RecordCache`: RecordCache depends on Kelly.Windows.Collections.ArgumentExtensions.Validate<T>(List<T>, int, bool) twice, and Kelly-Windows-Data cannot reference Kelly-Windows and has no equivalent helper (grep finds the 'List must contain at least {n} items.' check only in Kelly-Windows ArgumentExtensions). The m
- `Kelly-Revit-Logic:src/Documents/DocumentExtensions.cs#DocumentExtensions.SetRevisionInformation ("JHK Revision Date" literal)`: "JHK Revision Date" here is one of three family QC parameters (with "JHK Revision By" and "JHK Revision Time") that SetRevisionInformation resolves from its own generated shared parameter file. The same method area writes that file with hard-coded GUIDs (be314ae9-...) under the group "Family QC Data

## Kept on purpose

The finders' keep lists and notes are in the analysis (`analysis.json` in the run's scratchpad); the main ones: the host's `App.cs` start-up, `GetAddinGuid` (tied to the .addin manifests), the Arrange commands' selection handling, availability classes and push buttons beside their commands, Office interop and ExcelDataReader in Kelly-Revit.

## Rules baseline

`check-rules.pl` on 2026-11-04: 0 hits in rules 1, 2, 3 (not allowed) and 4; 7 allowed protected files; 133 commands and 42 view or view-model files in Kelly-Revit. Every layer built with 0 errors in every configuration (Kelly-Revit host and Trade.All for 2024).

## Implementation order

Bottom-up, one commit per package, then the source packages in their source layers, then pack and repin:

1. **Kelly-Windows-Data** (`Kelly-Windows-Data-v3`): P1a-data-services
2. **Kelly-Windows** (`Kelly-Windows-v3`): P2a-windows-collections-files
3. **Kelly-Domain** (`Kelly-Domain`): P3a-domain-common-definitions, P3b-domain-layoutpoints-pcf, P3c-domain-spools-supports, P3d-domain-views-vocabulary; source side of P1a-data-services, P2a-windows-collections-files
4. **Kelly-Revit-Logic** (`Kelly-Revit-Logic-v5`): P4a-logic-arrangement-common, P4b-logic-documents-elements, P4c-logic-fabrication-families, P4d-logic-mep-operations, P4e-logic-signatures-spools, P4f-logic-supports-updaters, P4g-logic-views; source side of P2a-windows-collections-files, P3a-domain-common-definitions, P3b-domain-layoutpoints-pcf, P3c-domain-spools-supports, P3d-domain-views-vocabulary
5. **Kelly-Revit-UI** (`Kelly-Revit-UI`): P5a-ui-commands-grids, P5b-ui-ribbon, P5c-ui-ribbon-scope; source side of P4a-logic-arrangement-common, P4b-logic-documents-elements, P4c-logic-fabrication-families
6. **Kelly-Revit** (`Kelly-Revit-v5`): P6a-revit-assigners-scheduleexport; source side of P2a-windows-collections-files, P3a-domain-common-definitions, P3b-domain-layoutpoints-pcf, P3c-domain-spools-supports, P3d-domain-views-vocabulary, P4a-logic-arrangement-common, P4b-logic-documents-elements, P4c-logic-fabrication-families, P4d-logic-mep-operations, P4e-logic-signatures-spools, P4f-logic-supports-updaters, P4g-logic-views, P5a-ui-commands-grids, P5b-ui-ribbon, P5c-ui-ribbon-scope

In-Revit tests (Logic, UI, Kelly-Revit) are compiled at every step and run in Revit 2024 through `revit-test.sh` when Revit 2024 is closed and a licence is available; otherwise they are reported "compiled, not run".
