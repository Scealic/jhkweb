# Access modifiers that can be narrowed, 2026-11-23

Types and members of the six Major Version 5 layers (`src` and `modules`, not the tests) whose access modifier is wider than their uses need.

## How it was found

A Roslyn scan (syntax only, name-based) of every C# and XAML file under `C:\repo\jhkweb`, all repositories, so the format libraries, Kelly-Revit-Data-Exporter and Fabrication-Tools count as users too. For each public, internal or protected type or member it records where the name is used:

- only inside its own type: it can be **private**;
- only inside its own project (assembly): it can be **internal**;
- a public settable property written only inside its own type: the setter can be **private set**.

Left out, because something reaches them without the name: overrides, virtual, abstract and `new` members; members with attributes; implicit interface implementations; Revit entry points and other reflection-created types (`IExternalCommand`, `IExternalApplication`, `IUpdater`, `IRibbonModule`, which `RibbonModuleLoader` finds through `GetExportedTypes`, `IApplicationService`); `IRecord` properties (filled by name from the CSV files); positional record properties; names in XAML; names that also appear in `#if` code not compiled by default. Also removed by hand after checking: `DataManifest.SchemaVersion` (Newtonsoft fills it) and the `App.Caches` getters (`AppStartupTests` checks they are public and static).

Name matching is conservative: a member sharing its name with another member elsewhere (`Name`, `Id`) counts that one's uses too, so it is never wrongly narrowed, but some candidates are missed. Not compiled: build each layer after narrowing (a public member whose signature uses a type made internal fails with CS0050/CS0051).

## Summary

| Repository | private | internal | private set | Public only because tests call it |
|---|---|---|---|---|
| Kelly-Windows-Data-v3 | 0 | 0 | 0 | 5 |
| Kelly-Windows-v3 | 2 | 0 | 0 | 70 |
| Kelly-Domain | 3 | 4 | 3 | 169 |
| Kelly-Revit-Logic-v5 | 30 | 32 | 2 | 455 |
| Kelly-Revit-UI | 5 | 5 | 0 | 7 |
| Kelly-Revit-v5 | 15 | 15 | 0 | 2 |
| **Total** | **55** | **56** | **5** | **708** |

## Public only because tests call it

708 public types and members are used by nothing but their own layer and its test projects. They could be internal if the layer granted its test projects `InternalsVisibleTo`, which only Kelly-Windows-v3, Kelly-Revit-UI and Trade.All do today. Most are in Kelly-Revit-Logic-v5 (`DocumentExtensions` 28, `FabricationPartExtensions` 27, `ElementExtensions` 23, `ViewExtensions` 14) and Kelly-Domain (`DataStore` 14, `DataStoreRecords` 11). These are package APIs that no layer above uses yet; narrowing them is a design choice (what each package offers the layers above), not a clean-up. The list is in `2026-11-23 Public Only For Tests.psv` beside this report.

## Can be narrowed now

### Kelly-Domain

| File | Line | Type | Member | Kind | Now | Can be |
|---|---|---|---|---|---|---|
| `src/Data/DataFiles.cs` | 60 | `DataFiles` | `GetRegisteredList` | Method | public | private |
| `src/Parameters/FilterRules/ColorFilterRule.cs` | 32 | `ColorFilterRule` | `RuleText` | Property | public | private set |
| `src/Parameters/FilterRules/ColorFilterRule.cs` | 35 | `ColorFilterRule` | `RuleType` | Property | public | private set |
| `src/Pcf/PcfData.cs` | 14 | `PcfData` | `Parts` | Property | public | private set |
| `src/Projects/ServiceData.cs` | 31 | `ServiceData` | `ColorAutoCad` | Property | public | internal |
| `src/Projects/SystemData.cs` | 32 | `SystemData` | `ColorAutoCad` | Property | public | internal |
| `src/Signatures/GeometrySignatureTools.cs` | 39 | `GeometrySignatureTools` | `LongDescriptionNotFound` | Field | public | private |
| `src/Supports/SupportSignature.cs` | 150 | `SupportSignature` | `UnknownBearerTypeText` | Field | public | private |
| `src/Vocabulary/Nouns.cs` | 31 | `Nouns` | `LayoutControlPointShort` | Property | public | internal |
| `src/Vocabulary/Nouns.cs` | 39 | `Nouns` | `LayoutManualPointShort` | Property | public | internal |

### Kelly-Revit-Logic-v5

| File | Line | Type | Member | Kind | Now | Can be |
|---|---|---|---|---|---|---|
| `src/Arrangement/TagLeader.cs` | 23 | `TagLeader` | `BaseLine` | Property | public | internal |
| `src/Arrangement/TagLeader.cs` | 25 | `TagLeader` | `EndLine` | Property | public | internal |
| `src/Arrangement/TagLeader.cs` | 27 | `TagLeader` | `LeaderEnd` | Property | public | internal |
| `src/Arrangement/TagLeader.cs` | 29 | `TagLeader` | `Side` | Property | public | internal |
| `src/Arrangement/TagLeader.cs` | 31 | `TagLeader` | `TagCenter` | Property | public | internal |
| `src/Arrangement/TagLeader.cs` | 42 | `TagLeader` | `TagHeight` | Property | public | internal |
| `src/Arrangement/TagLeader.cs` | 44 | `TagLeader` | `TagWidth` | Property | public | private |
| `src/Arrangement/TagLeader.cs` | 73 | `TagLeader` | `GetTaggedElement` | Method | public | internal |
| `src/Arrangement/TagLeader.cs` | 97 | `TagLeader` | `UpdateTagPosition` | Method | public | internal |
| `src/Common/FabricationServiceButtonItem.cs` | 29 | `FabricationServiceButtonItem` | `ButtonIndex` | Property | public | private set |
| `src/Common/KellyDirectories.cs` | 61 | `KellyDirectories` | `GetOrCreateProjectDataDirectory` | Method | public | internal |
| `src/Common/ScopeSource.cs` | 28 | `ScopeSource` | `GetSelectedElementIds` | Property | public | internal |
| `src/Connectors/ConnectorExtensions.cs` | 106 | `ConnectorExtensions` | `IsOnConnectedPipeCenterline` | Method | public | internal |
| `src/Connectors/ConnectorWrapper.cs` | 18 | `ConnectorWrapper` | `ConnectorId` | Property | public | internal |
| `src/Connectors/ConnectorWrapper.cs` | 33 | `ConnectorWrapper` | `SizeString` | Property | public | private set |
| `src/Connectors/ConnectorWrapper.cs` | 110 | `ConnectorWrapper` | `SetDimensionValueString` | Method | public | internal |
| `src/Documents/DocumentExtensions.cs` | 1265 | `DocumentExtensions` | `GetSharedParameterElement` | Method | public | internal |
| `src/Elements/ElementExtensions.cs` | 483 | `ElementExtensions` | `IncludeOrExcludeNestedFamilyInstances` | Method | public | internal |
| `src/Elements/ElementExtensions.cs` | 597 | `ElementExtensions` | `IsValidFabricationPartHanger` | Method | public | internal |
| `src/Elements/ElementExtensions.cs` | 602 | `ElementExtensions` | `ResetValue` | Method | public | internal |
| `src/Elements/PenetrationTagTools.cs` | 97 | `PenetrationTagTools` | `BuildTagText` | Method | public | private |
| `src/Entities/PhysicalElementEntity.cs` | 142 | `PhysicalElementEntity` | `ResetTag` | Method | public | internal |
| `src/Fabrication/FabricationDatabaseTools.cs` | 54 | `FabricationDatabaseTools` | `GetNextStraight` | Method | public | internal |
| `src/Fabrication/FabricationDatabaseTools.cs` | 86 | `FabricationDatabaseTools` | `PlaceRepeatedHangers` | Method | public | internal |
| `src/Fabrication/FabricationDatabaseTools.cs` | 122 | `FabricationDatabaseTools` | `PlaceMidLengthHanger` | Method | public | internal |
| `src/Mep/Olet.cs` | 56 | `Olet` | `BranchConnector` | Property | public | internal |
| `src/Mep/Olet.cs` | 71 | `Olet` | `PipeConnector` | Property | public | internal |
| `src/Mep/Olet.cs` | 74 | `Olet` | `PipeDiameterFeet` | Property | public | private |
| `src/Mep/OletTapTools.cs` | 264 | `OletTapTools` | `TryConnect` | Method | public | private |
| `src/Mep/PointToPipeReport.cs` | 30 | `PointToPipeReport` | `FailedPointCount` | Property | public | private |
| `src/Mep/PointToPipeReport.cs` | 36 | `PointToPipeReport` | `IsRolledBack` | Property | public | private |
| `src/Mep/PointToPipeReport.cs` | 40 | `PointToPipeReport` | `NotConvertedCount` | Property | public | private |
| `src/Mep/PointToPipeReport.cs` | 44 | `PointToPipeReport` | `RefusedServiceName` | Property | public | private |
| `src/Mep/PointToPipeReport.cs` | 54 | `PointToPipeReport` | `AddPartialConversion` | Method | public | internal |
| `src/Mep/PointToPipeReport.cs` | 85 | `PointToPipeReport` | `AddPointFailure` | Method | public | internal |
| `src/Mep/PointToPipeReport.cs` | 112 | `PointToPipeReport` | `MarkConversionRefused` | Method | public | internal |
| `src/Mep/PointToPipeReport.cs` | 119 | `PointToPipeReport` | `MarkRolledBack` | Method | public | internal |
| `src/Projects/ProjectInformationWrapper.cs` | 51 | `ProjectInformationWrapper` | `Address` | Property | public | private (set in the constructor, read nowhere: better deleted) |
| `src/Projects/ProjectInformationWrapper.cs` | 53 | `ProjectInformationWrapper` | `Architect` | Property | public | private (set in the constructor, read nowhere: better deleted) |
| `src/Projects/ProjectInformationWrapper.cs` | 55 | `ProjectInformationWrapper` | `BuildingName` | Property | public | private (set in the constructor, read nowhere: better deleted) |
| `src/Projects/ProjectInformationWrapper.cs` | 57 | `ProjectInformationWrapper` | `ClientName` | Property | public | private (set in the constructor, read nowhere: better deleted) |
| `src/Projects/ProjectInformationWrapper.cs` | 61 | `ProjectInformationWrapper` | `FabricationConfigurationId` | Property | public | private (set in the constructor, read nowhere: better deleted) |
| `src/Projects/ProjectInformationWrapper.cs` | 65 | `ProjectInformationWrapper` | `FileStore` | Property | public | private (set in the constructor, read nowhere: better deleted) |
| `src/Projects/ProjectInformationWrapper.cs` | 67 | `ProjectInformationWrapper` | `GeneralContractor` | Property | public | private (set in the constructor, read nowhere: better deleted) |
| `src/Projects/ProjectInformationWrapper.cs` | 71 | `ProjectInformationWrapper` | `IsBimLite` | Property | public | private (set in the constructor, read nowhere: better deleted) |
| `src/Projects/ProjectInformationWrapper.cs` | 73 | `ProjectInformationWrapper` | `IssueDate` | Property | public | private (set in the constructor, read nowhere: better deleted) |
| `src/Projects/ProjectInformationWrapper.cs` | 75 | `ProjectInformationWrapper` | `MarketSector` | Property | public | private (set in the constructor, read nowhere: better deleted) |
| `src/Projects/ProjectInformationWrapper.cs` | 81 | `ProjectInformationWrapper` | `NameInternal` | Property | public | private (set in the constructor, read nowhere: better deleted) |
| `src/Projects/ProjectInformationWrapper.cs` | 85 | `ProjectInformationWrapper` | `NumberInternal` | Property | public | private (set in the constructor, read nowhere: better deleted) |
| `src/Projects/ProjectInformationWrapper.cs` | 87 | `ProjectInformationWrapper` | `OrganizationDescription` | Property | public | private (set in the constructor, read nowhere: better deleted) |
| `src/Projects/ProjectInformationWrapper.cs` | 89 | `ProjectInformationWrapper` | `OrganizationName` | Property | public | private (set in the constructor, read nowhere: better deleted) |
| `src/Projects/ProjectInformationWrapper.cs` | 91 | `ProjectInformationWrapper` | `RulesOfCreditConstructionSignOff` | Property | public | private (set in the constructor, read nowhere: better deleted) |
| `src/Projects/ProjectInformationWrapper.cs` | 93 | `ProjectInformationWrapper` | `RulesOfCreditIssuedForConstruction` | Property | public | private (set in the constructor, read nowhere: better deleted) |
| `src/Projects/ProjectInformationWrapper.cs` | 95 | `ProjectInformationWrapper` | `RulesOfCreditModel` | Property | public | private (set in the constructor, read nowhere: better deleted) |
| `src/Spools/ItemNumber.cs` | 29 | `ItemNumber` | `StartsWithLineNumber` | Property | public | private |
| `src/Spools/SpoolItem.cs` | 174 | `SpoolItem` | `NonSpoolableReport` | Property | public | internal |
| `src/Spools/SpoolTools.cs` | 396 | `SpoolTools` | `GetSpoolableSubComponents` | Method | public | internal |
| `src/Supports/StraightHangerSpacing.cs` | 38 | `StraightHangerSpacing` | `ConnectorEndFar` | Property | public | internal |
| `src/Supports/StraightHangerSpacing.cs` | 40 | `StraightHangerSpacing` | `ConnectorEndNear` | Property | public | internal |
| `src/Supports/SuspendedSupport.cs` | 38 | `SuspendedSupport` | `IsSignatureTagPairMatched` | Property | public | private |
| `src/Supports/SuspendedSupport.cs` | 314 | `SuspendedSupport` | `GetNextTag` | Method | public | private |
| `src/Supports/SuspendedSupport.cs` | 455 | `SuspendedSupport` | `SetVerticalMemberSizeInMemory` | Method | public | private |
| `src/Supports/SuspendedSupport.cs` | 538 | `SuspendedSupport` | `WriteTagToHost` | Method | public | private |
| `src/Views/AddInViewExtensions.cs` | 77 | `AddInViewExtensions` | `EnsureAddInViewsAndSyncWithCentral` | Method | public | internal |

### Kelly-Revit-UI

| File | Line | Type | Member | Kind | Now | Can be |
|---|---|---|---|---|---|---|
| `src/Commands/SelectionMadeCommandAvailability.cs` | 28 | `SelectionMadeCommandAvailability` | `HasSelection` | Method | protected | private |
| `src/Mvvm/CheckWindowViewModel.cs` | 193 | `CheckWindowViewModel` | `CloseIfClosing` | Method | internal | private |
| `src/Ribbon/IRibbonSplitButton.cs` | 3 | `IRibbonSplitButton` | `IRibbonSplitButton` | type | public | internal |
| `src/Ribbon/RibbonComboBox.cs` | 15 | `RibbonComboBox` | `ComboBoxData` | Property | public | internal |
| `src/Ribbon/RibbonComboBox.cs` | 97 | `RibbonComboBox` | `CreateComboBoxMemberData` | Method | public | internal |
| `src/Ribbon/RibbonComboBox.cs` | 118 | `RibbonComboBox` | `CreateProjectComboBoxMemberData` | Method | public | internal |
| `src/Ribbon/RibbonExtensions.cs` | 178 | `RibbonExtensions` | `GetOrCreateRibbonTab` | Method | public | private |
| `src/Ribbon/RibbonExtensions.cs` | 193 | `RibbonExtensions` | `GetToolsTabComboBoxes` | Method | public | private |
| `src/Ribbon/RibbonExtensions.cs` | 217 | `RibbonExtensions` | `GetOrCreateRibbonPanel` | Method | public | private |
| `src/Ribbon/RibbonPushButton.cs` | 27 | `RibbonPushButton` | `ContextualHelp` | Property | public | internal |

### Kelly-Revit-v5

| File | Line | Type | Member | Kind | Now | Can be |
|---|---|---|---|---|---|---|
| `modules/Trade.All/Commands/About/ApplicationAboutModel.cs` | 3 | `ApplicationAboutModel` | `ApplicationAboutModel` | type | public | internal |
| `modules/Trade.All/Commands/Acquired/Arrange/Arranger.cs` | 3 | `Arranger` | `Arranger` | type | public | internal |
| `modules/Trade.All/Commands/Acquired/Arrange/Arranger.cs` | 8 | `Arranger` | `ArrangeSelection` | Method | public | internal |
| `modules/Trade.All/Commands/Acquired/Vicious/PointToPipe/ViciousFileBasedSystemPipePlaceTools.cs` | 40 | `ViciousFileBasedSystemPipePlaceTools` | `ImportAndPlacePipes` | Method | public | internal |
| `modules/Trade.All/Commands/Acquired/Vicious/PointToPipe/ViciousFileBasedSystemPipePlaceTools.cs` | 346 | `ViciousFileBasedSystemPipePlaceTools` | `SizeColumnNumber` | Field | public | internal |
| `modules/Trade.All/Commands/Acquired/Vicious/PointToPipe/ViciousFileBasedSystemPipePlaceTools.cs` | 349 | `ViciousFileBasedSystemPipePlaceTools` | `XColumnNumber` | Field | public | internal |
| `modules/Trade.All/Commands/Acquired/Vicious/PointToPipe/ViciousFileBasedSystemPipePlaceTools.cs` | 352 | `ViciousFileBasedSystemPipePlaceTools` | `YColumnNumber` | Field | public | internal |
| `modules/Trade.All/Commands/Acquired/Vicious/PointToPipe/ViciousFileBasedSystemPipePlaceTools.cs` | 355 | `ViciousFileBasedSystemPipePlaceTools` | `ZColumnNumber` | Field | public | internal |
| `modules/Trade.All/Commands/Acquired/Vicious/PointToPipe/ViciousFileBasedSystemPipePlaceTools.cs` | 360 | `ViciousFileBasedSystemPipePlaceTools` | `PointUnitsText` | Field | public | internal |
| `modules/Trade.All/Commands/Acquired/Vicious/PointToPipe/ViciousFileBasedSystemPipePlaceTools.cs` | 363 | `ViciousFileBasedSystemPipePlaceTools` | `PlacementMethod` | Field | public | internal |
| `modules/Trade.All/Commands/Acquired/Vicious/PointToPipe/ViciousFileBasedSystemPipePlaceTools.cs` | 366 | `ViciousFileBasedSystemPipePlaceTools` | `PipeTypeChoiceName` | Field | public | internal |
| `modules/Trade.All/Commands/Acquired/Vicious/PointToPipe/ViciousFileBasedSystemPipePlaceTools.cs` | 369 | `ViciousFileBasedSystemPipePlaceTools` | `SizeUnitsText` | Field | public | internal |
| `modules/Trade.All/Commands/Assigners/ContextValueAdder/ContextValueAddViewModel.cs` | 44 | `ContextValueAddViewModel` | `SuperClassName` | Property | public | private |
| `modules/Trade.All/Commands/Layout/LayoutPointExport/LayoutPointCsvExportView.xaml.cs` | 28 | `LayoutPointCsvExportView` | `SelectSiblingsOfSelection` | Method | public | private |
| `modules/Trade.All/Commands/Layout/LayoutPointImport/LayoutPointCsvImportViewModel.cs` | 40 | `LayoutPointCsvImportViewModel` | `FamilySymbols` | Property | public | private |
| `modules/Trade.All/Commands/Spools/ModuleCreator/ModuleCreatorViewModel.cs` | 80 | `ModuleCreatorViewModel` | `ExistingModuleNumbers` | Property | public | private |
| `modules/Trade.All/Commands/Spools/ModuleCreator/ModuleCreatorViewModel.cs` | 139 | `ModuleCreatorViewModel` | `ModuleNumbersWithModuleType` | Property | public | private |
| `modules/Trade.All/Commands/Spools/ModuleCreator/ModuleCreatorViewModel.cs` | 185 | `ModuleCreatorViewModel` | `ThisModuleNumberType` | Property | public | private |
| `modules/Trade.All/Commands/Supports/SuspendedSupportManage/SuspendedSupportManageViewModel.cs` | 151 | `SuspendedSupportManageViewModel` | `SuspendedSupports` | Property | public | private |
| `modules/Trade.All/Commands/Supports/SuspendedSupportManage/SuspendedSupportManageViewModel.cs` | 188 | `SuspendedSupportManageViewModel` | `VerticalMemberSizeOptions` | Property | public | private |
| `modules/Trade.All/DockablePanes/Assigner/AssignerContextDefinition.cs` | 92 | `AssignerContextDefinition` | `NewValues` | Property | public | private |
| `modules/Trade.All/DockablePanes/Assigner/AssignerPaneViewModel.cs` | 445 | `AssignerPaneViewModel` | `ResetAll` | Method | public | private |
| `modules/Trade.All/DockablePanes/AssignerB/AssignerBPaneViewModel.cs` | 66 | `AssignerBPaneViewModel` | `IdleHint` | Field | public | private |
| `modules/Trade.Duct/Commands/DuctLengthCheck/DuctLengthCheckViewModel.cs` | 51 | `DuctLengthCheckViewModel` | `FilterRows` | Method | internal | private |
| `modules/Trade.Duct/Commands/DuctLengthCheck/DuctLengthCheckViewModel.cs` | 62 | `DuctLengthCheckViewModel` | `FormatIssuesLabel` | Method | internal | private |
| `modules/Trade.Duct/Commands/DuctLengthCheck/StraightLengthGroupSummary.cs` | 4 | `StraightLengthGroupSummary` | `StraightLengthGroupSummary` | type | public | internal |
| `modules/Trade.Duct/Commands/DuctLengthCheck/StraightLengthRow.cs` | 6 | `StraightLengthRow` | `StraightLengthRow` | type | public | internal |
| `modules/Trade.Duct/Commands/DuctLengthCheck/StraightLengthRow.cs` | 77 | `StraightLengthRow` | `FromPart` | Method | public | internal (a test calls `GetMethod("FromPart")` with no flags: give it `BindingFlags.NonPublic`) |
| `modules/Trade.Duct/Commands/DuctMirrorCheck/DuctMirrorCheckViewModel.cs` | 46 | `DuctMirrorCheckViewModel` | `FormatMirroredLabel` | Method | internal | private |
| `src/Services/RibbonService.cs` | 61 | `RibbonService` | `DeveloperModuleFileName` | Field | internal | private |

### Kelly-Windows-v3

| File | Line | Type | Member | Kind | Now | Can be |
|---|---|---|---|---|---|---|
| `src/Files/TextFileWriter.cs` | 46 | `TextFileWriter` | `VettedDirectoryInfo` | Property | public | private |
| `src/Logging/FileLoggerFactory.cs` | 23 | `FileLoggerFactory` | `IncludeTimestamp` | Property | public | private |
