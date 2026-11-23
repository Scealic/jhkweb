# Unit Test Implementation - Kelly Tools For Revit v5

Restarted 2026-11-02. The goal is the shared rule in `BuildConfigs/SHARED-AGENTS.md`: **every type member has an NUnit test**, and every change starts with a failing test (TDD). This plan covers the six Major Version 5 repos; the v4 Revit repos override TDD and are out of scope, and the format libraries (Kelly-Windows-Data-Csv, -Json, -SqlServer, -Sqlite) keep their own suites. Since 2026-11-05 the coverage check also covers Kelly-Windows-Data-Csv and -Json, which Kelly-Revit-Logic-v5 and Kelly-Revit-v5 pin (Csv 1.26.1030.933, Json 1.26.1028.1008); -SqlServer and -Sqlite are not in v5's dependencies.

## Coverage re-examined (2026-11-05)

Re-run with the `tdd-coverage-check` skill (`C:\Users\childebran\.claude\skills\tdd-coverage-check`): it runs the measures below, compares them with the latest section here, and adds a new dated section above it.

Eight repos: the six v5 layers and the two format libraries v5 pins. Two measures:

- **Line and branch coverage** (coverlet, Net80) where it can be measured: the three lower layers. Csv and Json have no `coverlet.collector` reference, and the Revit layers run inside Revit under ricaun, where coverlet does not reach. Two things are needed for a run: `-p:DebugType=portable` (the shared `Output.Build.props` sets `DebugType` to `None`, so coverlet finds no PDB and reports 0 lines), and a runsettings `Include` of the Kelly assemblies only (otherwise coverlet tries to instrument `Kelly.Markdown.TestLogger.dll`, which VSTest has locked, and gives up).
- **Members named in a test**, for every repo: a Roslyn scan (`scan.cs`, now in the `tdd-coverage-check` skill: `C:\Users\childebran\.claude\skills\tdd-coverage-check\scripts`) lists each public or internal type and its methods, properties, events, constructors, indexers and operators (any access modifier), and counts a member as covered when its name appears in a test file that also names the type (or calls it, for extension methods). That is the shared rule's measure ("every type member has an NUnit test"), but approximate: a member reached only through another member, or by reflection over all members (`RecordTests`, `EnumMembersTests`), counts as not named; a common name (`Name`, `Id`) can count as named when it is not tested. The full list is in `Planning/Unit Test Coverage/2026-11-05 Coverage Gaps.csv`.

| Repo | Tests run on 2026-11-05 | Types with a test | Members named in a test | Lines / branches covered |
|---|---|---|---|---|
| Kelly-Windows-Data-v3 | 179 passed (Net80) | 17 of 17 | 74 of 87 (85%) | **99.6% / 97.8%** |
| Kelly-Windows-Data-Csv | 43 passed, **3 failed** (Net80) | 4 of 4 | 13 of 19 (68%) | not measured |
| Kelly-Windows-Data-Json | 129 passed (Net80) | 9 of 9 | 40 of 46 (87%) | not measured |
| Kelly-Windows-v3 | 835 passed (Net80) | 112 of 114 | 413 of 506 (82%) | **95.1% / 92.0%** |
| Kelly-Domain | 1,804 passed (Net80) | 262 of 263 | 964 of 1,306 (74%) | **92.2% / 90.9%** |
| Kelly-Revit-Logic-v5 | not run (last full run 2026-11-02: 842) | 262 of 264 | 1,243 of 1,663 (75%) | in Revit: not measured |
| Kelly-Revit-UI | 230 passed without Revit (Net481 and Net80), 91 in Revit 2024 (both logs of 2026-11-05) | 55 of 63 | 145 of 237 (61%) | not measured |
| Kelly-Revit-v5 | not run | 69 of 85; **27 of 85 by behavior** | 235 of 541 (43%); **88 (16%) by behavior** | in Revit: not measured |

Kelly-Revit-v5 also has 356 commands, push buttons, availability classes, panels and windows, which `AddInContractTests` checks for its contract (attribute, constructors, icons) but not for what they do. 528 of its 661 `[Test]`/`[TestCase]` attributes are source-text rules (`Commands/LowerLayerRulesTests` 469, `Ribbon/RibbonMovesTests` 59): they read a `.cs` file and check a call is there, so they name a type without running it. "By behavior" is the scan run without those two files.

### Since 2026-11-02

Types with no test: **320 → 29**.

| Repo | 2026-11-02 | 2026-11-05 | Still without a test |
|---|---|---|---|
| Kelly-Windows-v3 | 16 | 2 | `ClipboardTools`, `UserPrincipalExtensions` (both need a seam, above) |
| Kelly-Domain | 76 | 1 | `BuiltInCategoryMetaRecord`: run by `RecordTests` through reflection, so in effect 0 |
| Kelly-Revit-Logic-v5 | 127 | 2 | `DocumentClosingEventHandler`; `NumberedDocumentCache` is run through its four subclasses, so in effect 1 |
| Kelly-Revit-UI | 16 | 8 | `IExternalCommandBase`, `IExternalCommandMvvm`, `IRibbonPullDownButton`, `IRibbonPushButton`, `IRibbonSplitButton`, `IRibbonStackedButton`, `RibbonSplitButton`, `ConnectorPickTools` |
| Kelly-Revit-v5 | 85 | 16 | `DocumentChangedEventHandler`, `ViewActivatedEventHandler`, `ViewActivatingEventHandler`, `RibbonService`, `ApplicationAboutModel`, `AssignerComboBoxPopulator`, `ContextValueAddViewModel`, `SpoolCleanCommon`, `ManualUpdaterExtensions`, `IsSelectionMade` (three copies: Trade.All, Trade.Duct, Trade.Pipe), `ConnectOletsExternalEventHandler`, `ViciousInstanceLevelAssignViewModel`, `ViciousFileBasedSystemPipePlaceViewModel`, `AutoUpdaterPowerIcon` |

### Where the member gaps are

Types with the most public or internal members named in no test:

- **Kelly-Windows-v3** (lines not covered): `UserPrincipalExtensions` and `ClipboardTools` 0%, `DomainGroupReport` 38%, `ShellTools` 50%, `FileInfoExtensions` 56%, `FileDialogTools` 67%; members: `RoundAmount` 7, `ValidValueColors` 6.
- **Kelly-Domain** (lines not covered): `DefinitionSetCache<T>` 0%, the three `*Spool11X17SheetDetailViewSettings` 20%, `StandardUnits` 39% (no file-path seam, above), `ProductRangeParameterDefaults` 47%, `Product` 47%, `ExternalParameterDefinition` 53%, `Component` 57% (0% of branches), `DetailingPackage` and `LineNumber` 58%. Members: `Vocabulary/Nouns` 76 and the records (`ComponentAndLookupsViewRecord` 37, `ProjectRecord` 23, `ExternalParameterDefinitionRecord` 15) are mostly reached through reflection, not by name.
- **Kelly-Revit-Logic-v5**: `ProjectInformationWrapper` 26, `PhysicalElementEntity` 18, `SuspendedSupport` 12, `PathExtensions` 11, `Olet` 10, `TagLeader` 10, `SpoolItem` 9, `PointToPipeReport` 9, `ConnectorWrapper` 7.
- **Kelly-Revit-UI**: `UiDocumentScopeExtensions` 11 (needs a `UIDocument`, which a test document has not), `IRibbonPushButton` 10, `ViewModel` 9, `RibbonExtensions` 7, `RibbonComboBox` 7.
- **Kelly-Revit-v5**: the view models: `SpoolManagerViewModel` 31, `LayoutPointToCommaSeparatedValueFileExportViewModel` 23, `SuspendedSupportManagerViewModel` 20, `SpoolCreateViewModel` 18, `LayoutPointFromCommaSeparatedValueImportViewModel` 17, `ViciousInstanceElevationAssignViewModel` 14, `OletCheckViewModel` 13, `ModuleManageViewModel` and `ModuleCreatorViewModel` 12.
- **Format libraries**: only private helpers are unnamed (reached through the public members), plus `ICache`'s five members in Kelly-Windows-Data-v3 and `CsvDataWriter.Dispose`, `DataFolderWriter.Folder`/`Dispose`.

### Found on 2026-11-05

- [x] — done 2026-11-05 (Kelly-Windows-Data-v2 4cde171, -v3 0cc82b1, Csv 407b510, Sqlite 973956d, exporter ab7194f): the column order no longer depends on the declaration order at all: `DataFileFormat.Columns` sorts by name (ordinal), the tests expect name order, and Csv and Sqlite each have a test with a record declared out of order that fails on the old core. Csv 47 and Sqlite 39 tests pass in Net481, Net80 and Net100 (Sqlite had 2 failures of the same cause); the exporter (145 tests) pins Csv and Sqlite 1.26.1105.1154. The data files are not re-exported yet. **Kelly-Windows-Data-Csv, 3 tests fail again**: `CsvDataFormatTests.Columns_AreTheSettablePropertiesInDeclarationOrder`, `CsvDataWriterTests.Constructor_WritesTheHeaderEvenWithNoRecords`, `CsvDataWriterTests.WriteRecord_WritesTheHeaderAndOneLinePerRecord`. Commit `2fae2fa` ("Reorganize CSV tests and sample records") put `CsvSampleRecord`'s properties in alphabetical order again (header `Changed,Day,Id,...` instead of `Id,Name,Weight,...`), the same break `12bbce2` fixed on 2026-11-02. Put the record back in declaration order and stop the IDE's member sort from reaching it (a file-level ReSharper/Rider suppression, or a comment that says why the order matters).
- [ ] **Kelly-Windows-Data-Json, 50 tests without `Author` or `Description`**: 47 bare `[Test]` attributes in `JsonFileRepositoryTests`, 3 more elsewhere in the suite. The shared rule needs both on every `[Test]` and `[TestCase]`. — Linear: KWDJ-2 (2026-11-06)
- [ ] **Kelly-Domain `LayeringTests.Domain_namespaces_are_not_named_after_Revit_layers` fails under coverlet**: it lists coverlet's injected `Coverlet.Core.Instrumentation.Tracker.Kelly.Domain_<guid>` type as an offender. Skip namespaces that start with `Coverlet.` so a coverage run passes. — Linear: KD-50 (2026-11-06)
- [ ] **Csv and Json have no `coverlet.collector`**, and `DebugType=None` stops coverage everywhere: add the collector to both, and put the runsettings above in BuildConfigs so a coverage run is one command. — Linear: KWDC-1, KWDJ-3 (2026-11-06)
- [ ] **The four Kelly-Revit-v5 tests that need the add-in started** (Known failures, above) are unchanged.
- [ ] **No test carries a human verification date**: every `Author` in the eight repos is `"Verified By Human On:"` with no date (about 10 had one on 2026-11-02; changed tests lose it).

### Next, in order

1. Fix the Csv sample record (it is a failing test now).
2. The Json `Author`/`Description` attributes, and the coverlet guard in `LayeringTests`.
3. Kelly-Revit-UI's 8 types (the interfaces through an implementation, `RibbonSplitButton` in Revit).
4. Kelly-Revit-v5's view models, behavior first: the scan counts 58 of 85 v5 types that no behavioral test runs.
5. The member gaps of Logic's wrappers (`ProjectInformationWrapper`, `PhysicalElementEntity`, `SuspendedSupport`) and Domain's lowest-covered models (`Component`, `Product`, `DefinitionSetCache<T>`).
6. A full in-Revit run of Logic, UI and Kelly-Revit-v5 with the add-in disabled: today's logs are filtered runs (Logic 23 tests, Kelly-Revit-v5 2).

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

- [ ] **Files**: `ShellTools.OpenInExplorer` starts `explorer.exe`. A process-starter seam would let a test check the quoted argument. — Linear: KW3-21 (2026-11-06)
- [ ] **Wpf**: `ClipboardTools` reads and writes the real clipboard (the user's, during a run). A clipboard seam would make it testable. Also: `SetText(List<string>)` adds "No Value was Provided" to the caller's list when it is empty, and throws on a null list. — Linear: KW3-22 (2026-11-06)
- [ ] **Workstation**: `UserPrincipalExtensions.GetManager`/`GetTitle` need Active Directory, so they fail off the JHK network. They could take the `DirectoryEntry` properties through a seam. — Linear: KW3-23 (2026-11-06)

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

119 of 127 done 2026-11-02 (229 new tests, each fixture passing in its own Revit 2024 run with the add-in disabled; full run 2026-11-02 with all 229: ricaun ran 842 tests in 19 min, all 734 results that reached the log passed, the adapter lost 108 results (KTR0001) and the Revit journal records no failed or skipped test; Kelly-Revit-Logic-v5 `cbfca8e`..`d044641`, one commit per fixture):

- [x] **Updaters/Configurations** (39): every auto and manual configuration in two fixtures, `AutoUpdaterConfigurationsTests` and `ManualUpdaterConfigurationsTests`, one case per configuration (duty, default state, GUID, element service) and a coverage check that fails when a new configuration has no case; the bases `AutoUpdaterConfiguration`/`ManualUpdaterConfiguration`, `UpdaterDuty`, `UpdaterState`.
- [x] **Common**: `AddInServices`, `AssemblyTypeExtensions`, `AssemblyWarningSwallower` and `SuppressDuplicateInstancesWarning` (a duct terminal copied onto itself raises the duplicate-instances warning), `ObjectExtensions` (internal, by reflection), `RevitCancelValue`.
- [x] **Connectors**: `ConnectorTypeEnd`, `EndPositions`, `DimensionModel`, `ConnectorInfo`, `ConnectorInfoVictaulic`, `TapWrapper` in `ConnectorModelsTests`.
- [x] **IsExternalInit**, **Spools**: `NumberableSpoolItemBuiltInCategorySet` (54 categories), **Supports**: `HangerLocation`, `HangerPlaceSettings`.
- [x] **Updaters/ElementServices** (14): `ElementServicesTests` pins every remaining service's execution order and trigger filter (one case each: no duct passes before its parameters are bound; after, a duct passes only when the service is not limited to fabrication parts or supports), and runs content identity, service of (non-)fabrication part, `ServiceElementWriter` (internal, by reflection), system and product on ducts.
- [x] **Updaters/ElementDataModels** (8): `ElementDataModel` and the seven models in `ElementDataModelsTests`, on ducts and duct terminals with in-memory components, products and services.
- [x] **Signatures**: `GeometrySignatureExtensions` (argument check only: no fabrication parts), `ServiceSignatureExtensions`, `SystemSignatureExtensions`. **Mep**: `DuctExtensions` (on a disconnected duct), `PipeExtensions`, `ConduitExtensions`, `CableTrayExtensions` (argument checks), `OletTapConnectorStatus`. **Projects**: `ProjectLocationExtensions`. **Elements**: `ElementFilterExtensions`, `ReInsertModel`. **Entities**: `BuiltInCategoryElementEntity`.
- [x] **Families**: `FamilyExtensions`, `TypeBoundSharedParameter`, `TypeBoundSharedParameterScanner` (a family sample given three shared parameters and loaded into an empty project). **Views**: `ParameterFilterElementExtensions` (`ApplyToView`; `Export` argument checks only). **Arrangement**: `ViewSides`, `CustomLeader`, `CommitPreprocessor`. **Caches**: `IDocumentCache`, `SystemDocumentCache` (no fabrication configuration); `NumberedDocumentCache` was already run through its four subclasses in `DocumentCacheTests`.
- [x] **Common**: `TaskDialogSimple` (every message, through a recording prompt), `ContextLists`, `ButtonDataWrapper` (argument check only). **Properties**: `Resources`. **Mep**: `ValveData`, `ValveClearanceSphereTools` (on duct terminals; no clearance sphere family, so no sphere is placed). **Views**: `StratusViewTools` (the template view checks; the package views need the Kelly filters), `ViewPortExtensions`. **Elements**: `ElementInstanceModel`. **Arrangement**: `AnnotationElement` (text notes). **Documents**: `UiDocumentExtensions`, `DocumentSchemaExtensions`, `DocumentSavedEventHandler`, `EventHandlerTools`. **Fabrication**: `BillOfMaterialTypeAssigner`; `FabricationPartWrapper`, `FabricationConnectorTools`, `ProductCodeCheckResult` (argument check only). **Connectors**: `ConnectorExtensions` (`GetConnectors`; the rest was already run in `ConnectorToolsTests`). **Supports**: `VerticalSupportMember` (made from its type).

A test folder named `Common` made `using Common;` in 11 existing fixtures resolve to the test namespace; they now say `using Logic.Common;` (`e0f78b9`).

Found while testing (behavior pinned by the tests as it is; not changed):

- `ProductElementDataModel`: when the component has no product in the data, `Initialize` returns early but `UpdateElement` still writes its defaults, so CAHF, CIPE and JHK Total Weight are overwritten with 0 (the product id read from the element is written back).
- `ElementService.ExecutionOrder`: three services share 11 (service, service of fabrication part, service of non-fabrication part) and two share 100 (detailing package, line number), so execution order alone does not decide which of them runs first.
- Kelly's string `GetValue` turns a double quote into two single quotes, so a type named `4" DIA` is written to JHK Long Description as `4'' DIA`.
- `TypeBoundSharedParameterScanner.Scan` closes the document `EditFamily` returns, so a family document the caller already had open is closed by the scan.
- `SystemDocumentCache` throws `ArgumentNullException` from its constructor in a project with no fabrication configuration instead of listing the generic system, as `ServiceDocumentCache` does.
- `MaterialExtensions.Export` and `ParameterFilterElementExtensions.Export` write a CSV report and open it on the desktop (`ToCsv(..., openFile: true)`), so a test would start a program; they need an "open file" seam, like `ShellTools`.
- `UiDocumentExtensions.CreateProductRangeFilter` also passes a duct's "Center line" element, which reports the duct's parameters, so `GetInstancesByProductRange` returns the center line with the duct.
- `ContextLists.GetItemNumbers` lists only elements that have both a line number and an item number (the parameter filter ANDs them).
- `VerticalSupportMember.Signature` throws `NullReferenceException` while `Size` is unset, instead of returning "Signature Issue".
- `TypeBoundSharedParameterScanner`, `SystemDocumentCache`: see above. `ComponentCategoryType` has a member 99 (`PlaceHolder`), so 99 is no "invalid value" for it.

These needed fabrication parts, a fabrication configuration or Kelly support families, which the Revit samples do not have, so they are tested on the Kelly test project.

Kelly test projects (user decision 2026-11-03): kept in `C:\repo\jhkweb\RevitTestModels\` (the jhkweb root repo, outside every sibling repository), one per Revit version, `<year> KTR Test Project - Piping And Families.rvt`; Chris builds them. 2024 is there (137 MB, workshared): 269 fabrication parts (pipework, clevis hangers on support rods), 5 spool assemblies, weld families, 4 trapezes (T1, T4, T5) with 2–3 layout points and no structure above them, 139 materials, and the project's own JHK shared parameters (real GUIDs, so the tests bind `KellyDefinitions` stubs beside them). Fabrication configuration: "JHK Master Database 2025", the piping database (GUID `69a21195-f633-4908-531d-aecccdd482b1`). 2025 and 2026 to follow. `Abstractions/RevitKellyModelTest` opens a shared or isolated copy and picks the content (`ClevisHanger`, `Straight`, `Trapeze`, `FabricationAssembly`); a test is inconclusive when its year's project or content is missing.

- [x] **Fabrication**: `FabricationPartExtensions`, `ProductRange10Joints01Weld` — done 2026-11-03: 43 tests (every public member; the private bearer-size readers through `GetBearerSize` per bearer type) and 5 tests; all pass in Revit 2024 (`LogDimensionValues` only with the add-in loaded, below)
- [x] **Materials**: `MaterialExtensions` — done 2026-11-03: `Export` takes an optional `openFile` (default true); 2 tests on a new project, pass in Revit 2024
- [x] **Supports**: `HangerPlacementService`, `HangeredStraightModel`, `TrapezeVerticalMemberTools` — done 2026-11-03: 5, 8 and 8 tests, all pass in Revit 2024
- [x] **Updaters**: `CustomDataUpdateEvaluator`, `CustomDataUpdater` — done 2026-11-03: 9 and 5 tests, all pass in Revit 2024

Findings from the Kelly test project:

- `FabricationPartExtensions.LogDimensionValues` throws `MissingMethodException` (`LoggerServices.GetFileLogger(string, RollingInterval)`) in a test run with the Kelly add-in disabled: Revit 2024's P&ID Modeler add-in ships `AddInsPnIDModelerSerilog.Sinks.File.dll`, older than `RollingInterval`, with the same assembly version (2.0.0.0) as Kelly's 7.0.0, and the first one loaded wins. With the add-in loaded it passes (checked 2026-11-03); with it disabled the test is inconclusive and names the copy Revit resolved.
- `GetHostSize` and `GetVerticalSupportSize` write the inch mark as two single quotes (`2''`) and as `"` (`3/8"`) respectively.

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

On 2026-11-05 none of the tests in the eight repos carries a date (on 2026-11-02 about 10 of roughly 1,870 did) in `Author` (`Verified By Human On:yyyy.mm.dd`). Only a person adds that date, after checking the test does what its `Description` says. Changing a test removes it again.
