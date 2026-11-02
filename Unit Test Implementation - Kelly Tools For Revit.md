# Unit Test Implementation - Kelly Tools For Revit v5

Restarted 2026-11-02. The goal is the shared rule in `BuildConfigs/SHARED-AGENTS.md`: **every type member has an NUnit test**, and every change starts with a failing test (TDD). This plan covers the six Major Version 5 repos; the v4 Revit repos override TDD and are out of scope, and the format libraries (Kelly-Windows-Data-Csv, -Json, -SqlServer, -Sqlite) keep their own suites.

## Baseline (2026-11-02)

Every suite run in full: the lower layers in all three configurations, the Revit layers in Revit 2024 with `Kelly Tools For Revit 5.addin` renamed to `.addin.x` for the run.

| Repo | Test project | Net481 | Net80 | Net100 |
|---|---|---|---|---|
| Kelly-Windows-Data-v3 | `tests/Data.Tests.csproj` | 155 passed | 155 passed | 155 passed |
| Kelly-Windows-v3 | `tests/Logic.Tests.csproj` | 486 passed | 486 passed | 486 passed |
| Kelly-Domain | `tests/Domain.Tests.csproj` | 556 passed | 556 passed | 556 passed |

| Repo | Test project | Revit 2024 |
|---|---|---|
| Kelly-Revit-Logic-v5 | `test/Revit.Logic.RevitTests` | 608 passed (17 min 51 s; all 608 reached the log) |
| Kelly-Revit-UI | `test/Revit.UI.Tests` (without Revit) | 167 passed |
| Kelly-Revit-UI | `test/Revit.UI.RevitTests` | 44 passed |
| Kelly-Revit-v5 | `test/Tests.Revit` | 75 passed, **4 failed** (see below) |

Also on 2026-11-02: Kelly-Windows-Data-Csv's three column-order tests failed because a member sort had put the test record's properties in alphabetical order; fixed in Csv commit `12bbce2` (46 passed in all three configurations).

### Known failures

- [ ] **Kelly-Revit-v5, 4 tests that need the add-in started**: `ApplicationLoggerTests.LogWarning_WithTheAddInStarted_IsWrittenToTheApplicationLog`, `EventServiceTests.Start_SubscribesEveryHandlerWithoutThrowing_AndReportsStarted`, `EventServiceTests.StartOrder_IsAfterTheAutoUpdater`, `EventServiceTests.Stop_AfterStart_UnsubscribesEveryHandlerWithoutThrowing_AndReturnsTrue`. They assert that the add-in has started, so they fail whenever the suite runs with the manifest disabled, which the shared rules require for testing new source. Decide: make them `Assert.Ignore` (or `Assume.That`) when the add-in has not started, or move them to a fixture that is run separately with the add-in loaded.

## How to backfill a type

One type per commit, bottom layer first, so a lower package is never waiting on a test above it.

1. Read the type and list its members, whatever their access modifier.
2. Write the fixture `<Type>Tests` in the test folder matching the type's `src` folder, with the namespace matching the folder. Call public members directly, internal ones where `InternalsVisibleTo` allows, the rest through reflection (`BindingFlags.NonPublic`).
3. Every `[Test]` and `[TestCase]` gets `Author = "Verified By Human On:"` (a person adds the date after checking) and a `Description` that says what is verified.
4. A test that fails against the current code has found a bug: stop, report it, and fix it test-first in its own commit.
5. Run the fixture (`--filter "FullyQualifiedName~<Type>Tests"`), then the whole suite in every configuration, and check the `TestLogs` row count.
6. If the type is hard to test (static Windows state, WPF windows, shell or clipboard calls, Revit UI), note why under its line here instead of forcing a brittle test; it may point to a seam worth adding.
7. Update the repo's README "Running the tests" section when the way to run changes, and its SOLID table if a seam moves a rating. Test-only commits need no Changelog entry and no package.

Lower-layer suites run in seconds; in-Revit fixtures need Revit 2024 closed and the v5 manifest disabled for the run (renamed back afterwards, also when a run fails).

## Gaps: types with no test

Found 2026-11-02 by listing every `public`/`internal` type in each repo's source and keeping the ones whose name, or a `<Type>Tests` fixture, appears nowhere in the tests. That is type level only: a type that is tested can still have untested members, so step 1 above also applies to each tested type before the repo is called done. Interfaces and enums often need only a small test (values, or a contract checked through an implementation).

| Repo | Types with no test |
|---|---|
| Kelly-Windows-v3 | 16 |
| Kelly-Domain | 76 |
| Kelly-Revit-Logic-v5 | 127 |
| Kelly-Revit-UI | 16 |
| Kelly-Revit-v5 | 85 (not counting commands, push buttons, availability classes and views, which `AddInContractTests` checks for every module) |
| **Total** | **320** |

Kelly-Windows-Data-v3 has a test naming every type.

Order: Kelly-Windows-v3 → Kelly-Domain → Kelly-Revit-Logic-v5 → Kelly-Revit-UI → Kelly-Revit-v5. Within a repo, pure logic first (text, files, measurements, definitions), then types that need Windows or Revit state.

### Kelly-Windows-v3

13 of 16 done 2026-11-02 (suite 486 → 559, all passing in Net481, Net80 and Net100; one commit per type, `6af08ab`..`5f500de`):

- [x] **Commands**: `CommandType`
- [x] **Files**: `DelimitedTextTools`, `FileType`, `PathTools`
- [x] **Files/Xlsx**: `MinimalXlsxWriter` (including the private `ColumnLetter`, `XmlEscape`, `EscapeFooter`), `WorksheetNameTools`, `XlsxSheet`
- [x] **Geometry**: `Point3Extensions`
- [x] **Measurements**: `LengthUnits`
- [x] **Workstation**: `WorkstationModel` (reads the real machine through WMI)
- [x] **Wpf**: `ComboBoxItemData`, `ProgressDisplay`
- [x] **Wpf/Native**: `Monitorinfo` (its Win32 layout, in `ScreenInfoTests`)

Need a seam before they can be tested without side effects on the desktop or the network:

- [ ] **Files**: `ShellTools.OpenInExplorer` starts `explorer.exe`. A process-starter seam would let a test check the quoted argument.
- [ ] **Wpf**: `ClipboardTools` reads and writes the real clipboard (the user's, during a run). A clipboard seam would make it testable. Also: `SetText(List<string>)` adds "No Value was Provided" to the caller's list when it is empty, and throws on a null list.
- [ ] **Workstation**: `UserPrincipalExtensions.GetManager`/`GetTitle` need Active Directory, so they fail off the JHK network. They could take the `DirectoryEntry` properties through a seam.

Found while testing (behavior pinned by the tests as it is; not changed):

- `WorksheetNameTools.BuildUnique`: the `"Sheet" + n` fallback for an empty name can never run, because the index prefix (`"n-"`) always survives cleaning.
- `WorksheetNameTools.BuildUnique` is only case-insensitive if the caller's `usedNames` set is (`StringComparer.OrdinalIgnoreCase`); its summary says it is.
- `CommandType` is used nowhere in the v5 repos.
- `WorkstationModel`'s WMI fallback text has no space: `"ManufacturerNot Found"`.

### Kelly-Domain

All 76 done 2026-11-02 (suite 556 → 699, all passing in Net481, Net80 and Net100; Kelly-Domain `88e5091`..`67817bf`, one commit per fixture):

- [x] **Definitions, Spools, Supports**: the 16 definition sets that only resolve names (`ComponentDefinitionSet` … `TrapezeVerticalMemberDefinitionSet`, `SpoolDefinitionSet`) in one fixture, `DefinitionSetsTests`, with a case per set, so the same three checks are not copied 16 times. `IDefinitionSet` is checked through them.
- [x] **Enums**: the 20 enums with no behavior, names and values pinned in `EnumMembersTests` (one case per enum; `FabricationCustomData`'s ids 1 and 100–117 included).
- [x] **Vocabulary**: `Deprecated` (31 names, all `[Obsolete]`, none also live) and `Worksets`, in `NamesTests`.
- [x] **Models and settings**: `ConnectorMapping`, `DataFileHeaderSchemaSets`, `LayoutPointCandidate`, `ModuleCreatorSettings`, `SpoolBillOfMaterial`, `SpoolCreatorSettings`, `ProductRange`, `SizeSymbol`, `Terminology`, `SupportMember`, `IIdentifier`, `IsExternalInit`; `ViewOrthographicConfiguration`, `ViewScheduleConfiguration`, the spool sheet settings and the three settings interfaces in `ViewConfigurationTests`.
- [x] **Records**: `BuiltInCategoryMetaRecord` and `OperationServiceLogRecord` were already covered by `RecordTests`, which checks every `IRecord` type by reflection (the type-level scan missed them because they are not named).
- [x] **Pcf**: `PcfReader` (`Part`, `Pipe`, `Weld`, `Point3d`), `PcfReaderController` (`PcfData`, `Reader`), `KeyboardShortcut`, `VtfrSettings` (`FtpTemplate`, `UnitConversionValue`, `VtfrSettingsRow`), `VicMaterial`, `StandardUnits`, `Databases`.

Not run: `StandardUnits.Read` and `Write` use the fixed file `Public Documents\Victaulic Tools\24\StandardUnits.vic`, which a real Victaulic install also uses. Its format is tested through the private `ToStorableString`; a file-path seam would let `Read`/`Write` be tested.

Found while testing (behavior pinned by the tests as it is; not changed):

- `PcfReaderController.Reader.ReadFile` throws `NullReferenceException` for a file with no `UNITS-BORE` or `UNITS-CO-ORDS` line.
- `ReadFile` throws `ArgumentOutOfRangeException` for an `END-POINT` line with X Y Z but no bore: `GetPoint` checks for more than 3 words but reads the fifth.
- `ReadFile` parses numbers in the current culture: on a de-DE machine `1000.5` reads as `10005`.
- `PcfData.Pipes`/`Welds` pick parts by `Name`, so a plain `Part` named `PIPE` shows up as a null entry.
- `SizeSymbol` accepts a numeric `Position` that is no member (`"99"` stays `(SizeSymbolPosition)99`, not `Invalid`).
- `ConnectorMapping` (and the other record-copying constructors) throw `NullReferenceException` on a null record.
- `VicMaterial.ColorText` names a color by the first `KnownColor` with the same RGB, which includes Windows system colors, so names for some colors (white, greys) depend on the Windows theme.
- The definition sets still resolve 24 names that `Names` marks `[Obsolete]` (e.g. `SizeDefinitionSet`'s shape and size names, `ProductDefinitionSet`'s CAHF, CIPE and Product Id).

### Kelly-Revit-Logic-v5

- [ ] **Arrangement**: `AnnotationElement`, `CommitPreprocessor`, `CustomLeader`, `ViewSides`
- [ ] **Caches**: `IDocumentCache`, `NumberedDocumentCache`, `SystemDocumentCache`
- [ ] **Common**: `AddInServices`, `AssemblyTypeExtensions`, `AssemblyWarningSwallower`, `ButtonDataWrapper`, `ContextLists`, `ObjectExtensions`, `RevitCancelValue`, `SuppressDuplicateInstancesWarning`, `TaskDialogSimple`
- [ ] **Connectors**: `ConnectorExtensions`, `ConnectorInfo`, `ConnectorInfoVictaulic`, `ConnectorTypeEnd`, `DimensionModel`, `EndPositions`, `FabricationConnectorTools`, `TapWrapper`
- [ ] **Documents**: `DocumentSavedEventHandler`, `DocumentSchemaExtensions`, `EventHandlerTools`, `UiDocumentExtensions`
- [ ] **Elements**: `ElementFilterExtensions`, `ElementInstanceModel`, `ReInsertModel`
- [ ] **Entities**: `BuiltInCategoryElementEntity`
- [ ] **Fabrication**: `BillOfMaterialTypeAssigner`, `FabricationPartExtensions`, `FabricationPartWrapper`, `ProductCodeCheckResult`, `ProductRange10Joints01Weld`
- [ ] **Families**: `FamilyExtensions`, `TypeBoundSharedParameter`, `TypeBoundSharedParameterScanner`
- [ ] **IsExternalInit**: `IsExternalInit`
- [ ] **Materials**: `MaterialExtensions`
- [ ] **Mep**: `CableTrayExtensions`, `ConduitExtensions`, `DuctExtensions`, `OletTapConnectorStatus`, `PipeExtensions`, `ValveClearanceSphereTools`, `ValveData`
- [ ] **Projects**: `ProjectLocationExtensions`
- [ ] **Properties**: `Resources`
- [ ] **Signatures**: `GeometrySignatureExtensions`, `ServiceSignatureExtensions`, `SystemSignatureExtensions`
- [ ] **Spools**: `NumberableSpoolItemBuiltInCategorySet`
- [ ] **Supports**: `HangerLocation`, `HangerPlaceSettings`, `HangerPlacementService`, `HangeredStraightModel`, `TrapezeVerticalMemberTools`, `VerticalSupportMember`
- [ ] **Updaters**: `CustomDataUpdateEvaluator`, `CustomDataUpdater`, `ElementDataModel`
- [ ] **Updaters/Configurations**: `AutoUpdaterConfiguration`, `ManualUpdaterConfiguration`, `UpdaterDuty`, `UpdaterState`
- [ ] **Updaters/Configurations/Auto**: `ComponentAutoUpdaterConfiguration`, `ContentIdentityAutoUpdaterConfiguration`, `DetailingPackageUpdaterAutoAdditionConfiguration`, `DetailingPhaseAutoUpdaterConfiguration`, `EndPreparationAutoUpdaterConfiguration`, `FabricationPartInstancesAutoUpdaterConfiguration`, `FieldTrimDefaultAutoUpdaterConfiguration`, `LayoutDisciplineUpdaterAutoAdditionConfiguration`, `LineNumberUpdaterAutoAdditionConfiguration`, `MaterialAutoUpdaterConfiguration`, `ProductAutoUpdaterConfiguration`, `ScheduleGaugeAutoUpdaterConfiguration`, `ServiceAutoUpdaterConfiguration`, `ServiceOfFabricationPartAutoUpdaterConfiguration`, `ServiceOfNonFabricationPartUpdaterAutoAdditionConfiguration`, `SizeAutoUpdaterConfiguration`, `SuspendedSupportAutoUpdaterConfiguration`, `SystemUpdaterAutoAdditionConfiguration`, `WeldAutoUpdaterConfiguration`
- [ ] **Updaters/Configurations/Manual**: `BillOfMaterialTypeDefaultManualUpdaterConfiguration`, `CheckboxDefaultManualUpdaterConfiguration`, `ComponentManualUpdaterConfiguration`, `ContentIdentityManualUpdaterConfiguration`, `DetailingPhaseManualUpdaterConfiguration`, `EndPreparationManualUpdaterConfiguration`, `FabricationPartInstancesManualUpdaterConfiguration`, `FieldTrimDefaultManualUpdaterConfiguration`, `LayoutDisciplineManualUpdaterConfiguration`, `MaterialManualUpdaterConfiguration`, `ProductManualUpdaterConfiguration`, `ScheduleGaugeManualUpdaterConfiguration`, `ServiceOfFabricationPartManualUpdaterConfiguration`, `SizeManualUpdaterConfiguration`, `SuspendedSupportManualUpdaterConfiguration`, `WeldManualUpdaterConfiguration`
- [ ] **Updaters/ElementDataModels**: `BillOfMaterialTypeDefaultElementDataModel`, `ComponentElementDataModel`, `LayoutDisciplineElementDataModel`, `MaterialElementDataModel`, `PlaceholderElementDataModel`, `ProductElementDataModel`, `ScheduleGaugeElementDataModel`
- [ ] **Updaters/ElementServices**: `ComponentUpdaterElementService`, `ContentIdentityUpdaterElementService`, `EndPreparationUpdaterElementService`, `FabricationPartInstancesUpdaterElementService`, `MaterialUpdaterElementService`, `ProductUpdaterElementService`, `ScheduleGaugeUpdaterElementService`, `ServiceElementWriter`, `ServiceOfFabricationPartElementService`, `ServiceOfNonFabricationPartElementService`, `SizeUpdaterElementService`, `SuspendedSupportElementService`, `SystemUpdaterElementService`, `WeldUpdaterElementService`
- [ ] **Views**: `ParameterFilterElementExtensions`, `StratusViewTools`, `ViewPortExtensions`

### Kelly-Revit-UI

- [ ] **Commands**: `CommandResultExtensions`, `IExternalCommandBase`, `IExternalCommandMvvm`
- [ ] **Mvvm**: `IView`, `IViewModel`, `ViewModel`
- [ ] **Ribbon**: `IRibbonComboBox`, `IRibbonPanelConfiguration`, `IRibbonPullDownButton`, `IRibbonPushButton`, `IRibbonSplitButton`, `IRibbonStackedButton`, `RibbonSplitButton`
- [ ] **Scope**: `UiDocumentScopeExtensions`
- [ ] **Selection**: `ConnectorPickTools`, `SelectionExtensions`

### Kelly-Revit-v5

- [ ] **App**: `Caches`
- [ ] **EventHandlers**: `DocumentChangedEventHandler`, `DocumentOpenedEventHandler`, `ViewActivatedEventHandler`, `ViewActivatingEventHandler`
- [ ] **Properties**: `Resources`
- [ ] **Services**: `ApplicationSessionService`
- [ ] **Trade.All/Commands**: `ApplicationAboutModel`, `ApplicationAboutViewModel`, `Arranger`, `AssignerComboBoxPopulator`, `AssignerDetailingPackageComboBox`, `AssignerDetailingPackageComboBoxSettings`, `AssignerFabricationServiceComboBox`, `AssignerLineNumberComboBox`, `AssignerLineNumberComboBoxSettings`, `AssignerModuleNumberComboBox`, `AssignerModuleNumberComboBoxSettings`, `AssignerServiceComboBoxSettings`, `AssignerSpoolNumberComboBox`, `AssignerSpoolNumberComboBoxSettings`, `AssignerSystemComboBox`, `AssignerSystemComboBoxSettings`, `AutoUpdaterPowerIcon`, `CommonAutoAssignerTools`, `ContextValueAddViewModel`, `DetailingPackageComboBoxEventHandler`, `ExcelInteropTools`, `LayoutPointFromCommaSeparatedValueImportViewModel`, `LayoutPointToCommaSeparatedValueFileExportViewModel`, `LineNumberComboBoxEventHandler`, `ManualUpdaterExtensions`, `ModuleCreatorViewModel`, `ModuleNumberComboBoxEventHandler`, `ServiceComboBoxEventHandler`, `SpoolCleanCommon`, `SpoolCreateViewModel`, `SpoolManagerViewModel`, `SpoolNumberComboBoxEventHandler`, `SuspendedSupportManagerViewModel`, `SystemComboBoxEventHandler`, `ViciousFabricationHangerInstancePlaceOptions`, `ViciousFileBasedSystemPipePlaceTools`, `ViciousFileBasedSystemPipePlaceViewModel`, `ViciousInstanceElevationAssignViewModel`, `ViciousInstanceLevelAssignViewModel`
- [ ] **Trade.All/RibbonItems**: `BillOfMaterialsSetterStackedButtons`, `DocumentHasAssemblyInstances`, `IsDisabledCommandEnabler`, `IsElementSelectableViewCommandEnabler`, `IsLayoutViewTypeCommandEnabler`, `IsSelectionMade`, `IsSingleElementSelectedCommandEnabler`, `IsTrapezeSelectedCommandEnabler`, `IsViewFilterEligibleCommandEnabler`, `LineNumberModuleSpoolAddToSelectedStackedButtons`, `LineNumberModuleSpoolAdoptStackedButtons`, `LineNumberModuleSpoolAutoAssignStackedButtons`, `LineNumberModuleSpoolComboBoxStackedButtons`, `LineNumberModuleSpoolFilterStackedButtons`, `LineNumberModuleSpoolRemoveFromSelectedStackedButtons`, `LineNumberModuleSpoolResetStackedButtons`, `ManualUpdaterStackedButtons`, `ServiceSystemPackageAddToSelectedStackedButtons`, `ServiceSystemPackageAdoptStackedButtons`, `ServiceSystemPackageAutoAssignStackedButtons`, `ServiceSystemPackageComboBoxStackedButtons`, `ServiceSystemPackageFiltersStackedButtons`, `ServiceSystemPackageRemoveFromSelectedStackedButtons`, `ServiceSystemPackageResetStackedButtons`
- [ ] **Trade.Contenter/Commands**: `FabricationCustomDataUpdaterCommandV1`, `FabricationCustomDataUpdaterCommandV2`, `FabricationCustomDataUpdaterPushButtonV1`, `FabricationCustomDataUpdaterPushButtonV2`
- [ ] **Trade.Contenter/RibbonItems**: `DocumentHasFabricationParts`, `IsDocumentOfTypeFamily`
- [ ] **Trade.Developer/Properties**: `Settings`
- [ ] **Trade.Developer/WindowMockup**: `WindowMockupViewModel`
- [ ] **Trade.Duct/RibbonItems**: `IsDuctItemNumberAbleViewCommandEnabler`
- [ ] **Trade.Pipe/Commands**: `ConnectOletsExternalEventHandler`, `OletCheckViewModel`, `OletCheckWindow`, `SelectionExternalEventHandler`
- [ ] **Trade.Pipe/RibbonItems**: `WeldLocationPurpose1StackedButtons`, `WeldLocationPurpose2StackedButtons`

## Human verification

About 10 of roughly 1,870 tests carry a date in `Author` (`Verified By Human On:yyyy.mm.dd`). Only a person adds that date, after checking the test does what its `Description` says. Changing a test removes it again.
