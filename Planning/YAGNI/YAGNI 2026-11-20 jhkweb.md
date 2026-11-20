# YAGNI 2026-11-20 jhkweb: code used only by tests

This report covers members that tests use and that no production code in any repository uses. Members used nowhere, not even by tests (94 in this scan), are left out.

## Scope

- **Target:** every repository under `C:\repo\jhkweb`, each reported as its own unit: BuildConfigs, Component-Data-Editor, Fabrication-Kitchen-Sink, Fabrication-Tools, Kelly-Domain, Kelly-Revit-Data-Exporter, Kelly-Revit-Logic-v5, Kelly-Revit-UI, Kelly-Revit-v5, Kelly-Windows-Data-Csv, -Excel, -Json, -Sqlite, -SqlServer, Kelly-Windows-Data-v3, Kelly-Windows-v3 and the two VCS schema repositories.
- **Also searched:** Commands, Notes-JHKelly, Remove-Empty-Directories, RevitExtensions, Access-Front-Ends and Hill-Revit-Combined-Addins. None of them depends on these repositories. A grep of the user profile, `C:\repo\chrishildebran` and `C:\repo\jhkweb - non KTR` found no other code that uses the Kelly namespaces.
- **Configuration read:** the skill's default entry points and `C:\repo\jhkweb\.yagni`.
- **Not visible:** the Major Version 4 packages `Kelly.Revit.Logic.2024/2025/2026` 4.x depend on `Kelly.Windows.Data.Json.Net481` 1.x, and their source is not on this machine. Public Json members are therefore marked **Keep**.
- **Limit:** members are matched by name, so a dead member that shares a name with a live one (`Name`, `Id`, `Value`) is not flagged. This list shows what is dead, not everything that is dead.
- **Checks:** each candidate was searched as a whole word across every repository, in code and non-code files. Each was also checked for reflection, CSV or JSON mapping, XAML binding, interface or override reach, test seams, members waiting to be repointed, and `#if` branches. The compiled-reference check (skill step 5) has not been run yet; it runs before any deletion.

## Totals

| Repository | Used only by tests | Dead | Decide | Keep | Used |
|---|---|---|---|---|---|
| Kelly-Domain | 69 | 14 | 55 | 0 | 0 |
| Kelly-Windows-v3 | 43 | 41 | 0 | 2 | 0 |
| Kelly-Revit-Logic-v5 | 33 | 33 | 0 | 0 | 0 |
| Kelly-Revit-UI | 9 | 9 | 0 | 0 | 0 |
| Kelly-Windows-Data-v3 | 4 | 4 | 0 | 0 | 0 |
| Kelly-Windows-Data-Json | 4 | 0 | 0 | 4 | 0 |
| Kelly-Revit-v5 | 3 | 3 | 0 | 0 | 0 |
| Kelly-Windows-Data-SqlServer | 3 | 3 | 0 | 0 | 0 |
| Kelly-Windows-Data-Excel | 2 | 2 | 0 | 0 | 0 |
| Kelly-Windows-Data-Sqlite | 1 | 1 | 0 | 0 | 0 |
| Fabrication-Tools | 1 | 1 | 0 | 0 | 0 |
| Component-Data-Editor | 1 | 0 | 0 | 0 | 1 |
| **Total** | **173** | **111** | **55** | **6** | **1** |

## Dead (used only by tests)

### Kelly-Windows-Data-v3

| Member | Tests that go with it |
|---|---|
| `DataDirectory.Readers` (`src/Services/DataDirectory.cs:69`) | `tests/Services/DataDirectoryTests.cs` |
| `DataDirectory.CheckPresence` (`:78`) | `DataDirectoryTests.cs` |
| `DataDirectory.VerifyFiles` (`:211`) | `DataDirectoryTests.cs`, `FormatLibraryTests.cs` |
| `SqlMatch.EqualsAsSql` (`src/Services/SqlMatch.cs:17`) | `tests/Services/SqlMatchTests.cs` |

### Kelly-Windows-Data-SqlServer, -Sqlite, -Excel

| Member | Tests that go with it |
|---|---|
| `DatabaseConnectionTester` (whole class, with `ReportConnectionStates`) | `SqlServer.Tests/DatabaseConnectionTesterTests.cs`; the name check in Kelly-Windows-Data-v3 `tests/CoreBoundaryTests.cs` |
| `ConnectionStringResolver` (whole class) | `SqlServer.Tests/ConnectionStringResolverTests.cs`; `CoreBoundaryTests.cs` |
| `SqliteRecordReader` (whole class) | `Sqlite.Tests/SqliteRecordReaderTests.cs` |
| `ExcelWorkbookReader.ReadSheetNames` (`src/ExcelWorkbookReader.cs:60`) | `Excel.Tests/ExcelWorkbookReaderTests.cs`, `ExcelWorkbookWriterTests.cs`; Fabrication-Tools tests |
| `SpreadsheetXml.ContentTypesNamespace` (`src/SpreadsheetXml.cs:121`) | `Excel.Tests/SpreadsheetXmlTests.cs` |

### Kelly-Windows-v3

| Member | Tests that go with it |
|---|---|
| `MonitorAreas` (whole class, with `MonitorInfo` and `NativeRect`: `GetPrimaryMonitorFullArea`, `GetPrimaryMonitorWorkingArea`, `GetWorkingAreaForWindow`, `WriteAllMonitorsToConsole`) | `tests/Tools/MonitorAreasTests.cs` |
| `ObjectDumper` (whole class, `Print` and `Dump`) | `tests/Reflection/ObjectDumperTests.cs` |
| `FractionalLength` (struct) | `tests/Measurements/FractionalLengthTests.cs` |
| `ValidValueColors` (class) | `tests/Sets/ColorSetTests.cs`, `AssemblyExtensionsTests.cs` |
| `HashExtensions.ComputeMd5Hex` | `tests/Extensions/HashExtensionsTests.cs` |
| `RegexMatchTools.IsValidEmailAddress` | `tests/Text/RegexMatchToolsTests.cs` |
| `StringBuilderExtensions.AppendCsvRow` | `tests/Extensions/StringBuilderExtensionsTests.cs` |
| `StringExtensions.DigitsOnly`, `ReplaceUnsafeCharactersWithSpace`, `StripAllButAlphaNumericUnderscorePeriod`, `StripAllButAlphaNumericSpaces`, `StripAllButWordDotAtHyphen`, `ToInitials` | `tests/Text/StringExtensionsTests.cs` |
| `AssemblyExtensions.GetFileVersion`, `GetTypesAssignableTo`, `GetTypesWithAttribute` | `tests/Extensions/AssemblyExtensionsTests.cs`, fixture `ScanObsolete.cs` |
| `AngleExtensions.ParseAngle` (production uses `TryParseAngle`; drop its crefs to `ParseAngle`) | `tests/Measurements/AngleExtensionsTests.cs` |
| `DimensionModel.ValueInches` | `tests/Measurements/DimensionModelTests.cs` |
| `DoubleExtensions.DecimalFeetToFeetInchFraction`, `InchesToFeet`, `IsOutOfRange` | `tests/Measurements/DoubleExtensionsTests.cs` |
| `IntegerExtensions.FlipBit`, `ToBool` | `tests/Extensions/IntegerExtensionsTests.cs` |
| `RoundAmount`: `OneEighthDecimalPlaces`, `OneFourthDecimalPlaces`, `OneHalfDecimalPlaces`, `OneHalfInchInFeet`, `OneSixteenthDecimalPlaces`, `OneSixtyFourthDecimalPlaces`, `OneThirtySecondDecimalPlaces`, `OneTwoHundredFiftySixthDecimalPlaces` | `tests/Tools/RoundAmountTests.cs` |
| `FileLoggerFactory.OpenLogFile` | `tests/Files/ShellToolsTests.cs` |
| `ApplicationSession.TimeElapsedMinutes` | `tests/Hosting/ApplicationSessionTests.cs` |
| `EnumExtensions.CreateValueCollection` | `tests/Extensions/EnumExtensionsTests.cs` |
| `ObjectExtensions.IsNull` | `tests/Extensions/ObjectExtensionsTests.cs` |
| `ListTools.DrainToList` | `tests/Tools/AbstractedToolsTests.cs` |

### Kelly-Domain

| Member | Tests that go with it |
|---|---|
| `Names.DefinitionsInternal.ComponentData.JhkFinish` | Kelly-Revit-Logic-v5 `Updaters/ElementDataModelsTests.cs`; Kelly-Domain `NamesTests.cs` (reflection) |
| `Names.DefinitionsInternal.Deprecated`: `JhkCahf`, `JhkCipe`, `JhkClassDescription`, `JhkManufacturer`, `JhkShortDescription`, `JhkTradeName` (all `[Obsolete]`) | `ElementDataModelsTests.cs` |
| `Nouns.RoleSuperintendent` | `tests/Vocabulary/NounsTests.cs` |
| `ColoredSignatureLookup.FindBySignatureExact` (production uses `FindBySignaturesIgnoreCase`) | `tests/Signatures/ColoredSignatureLookupTests.cs` |
| `ServiceSignatureTools.FindServiceExact` | `tests/Signatures/ServiceSignatureToolsFindTests.cs` |
| `LayoutPointExportNotice.CanProceed` (callers read `Severity`) | `tests/LayoutPoints/LayoutPointExportNoticeTests.cs` |
| `DataFiles.IsStoreRegistered` | `tests/Caches/DataFilesStoreTests.cs` |
| `FilePath` (whole class: `LocalPath`, `ServerPath`) | `tests/Models/SimpleModelTests.cs` |
| `BuiltInCategoryModel.IsBound` (not used by tests either) | none |

### Kelly-Revit-Logic-v5 (tests under `test/Revit.Logic.RevitTests`)

| Member | Tests that go with it |
|---|---|
| `ParameterFilterElementExtensions.ApplyToView` | `Views/ParameterFilterElementExtensionsTests.cs` |
| `ViewExtensions.SetLinkVisibilityType`, `ShowAllRevitLinks` | `Views/ViewExtensionsTests.cs` |
| `ViewFilterSets.ApplyBillOfMaterialTypeFieldAndFieldTrimFilter`, `ApplyBillOfMaterialTypeShopFilter` | `Views/ViewFilterTests.cs` |
| `AutoUpdaterManager.UpdaterStates` (`IsSuspended` reads the private field) | `Updaters/AutoUpdaterTests.cs` |
| `ProjectInformationWrapper.GetRecord` | `Projects/ProjectInformationWrapperTests.cs` |
| `ExternalParameterDefinitionExtensions.GetRecord` | `Parameters/CategoryAndParameterHelperTests.cs` |
| `ParameterExtensions.GetValueAsStringWithSingleQuotes` | `Parameters/ParameterExtensionsTests.cs` |
| `CoordinateExtensions.TryParseXyz` | `Geometry/CoordinateTests.cs` |
| `FamilySymbolExtensions.HasInstances` | `Families/FamilyHelpersTests.cs` |
| `BuiltInCategoryElementEntity` (whole class) | `Entities/BuiltInCategoryElementEntityTests.cs` |
| `ElementDataExtensions.GetSharedParameter` | `Parameters/ParameterExtensionsTests.cs` |
| `ElementIdExtensions.ParseElementIds` | `Elements/ElementHelpersTests.cs` |
| `GroupTools` (whole class, `UngroupGroups`) | `Elements/ElementHelpersTests.cs` |
| `RevitLinkInstanceExtensions.IsEffectivelyLoaded` | `Elements/ElementHelpersTests.cs` |
| `ParameterBindingRecord` (whole class) | `Elements/ParameterBindingRecordTests.cs` |
| `DocumentExtensions.DeleteAllOfType`, `GetBoundInternalDefinition`, `GetFirstViewOrPrompt` | `Documents/DocumentQueryTests.cs` |
| `DocumentExtensions.SetProjectRecordId` (`DocumentExtensionsJhk.cs`) | `Documents/KellyDocumentTests.cs` |
| `VictaulicConnectorTools.GetAllConnectionInfos` (already `[Obsolete]`) | `Connectors/ConnectorToolsTests.cs` |
| `ConnectorWithOwner` (whole class) | `Connectors/ConnectorModelsTests.cs` |
| `TaskDialogSimple.ShowEntitiesNotFound`, `ShowFamilySymbolMissing` | `Common/TaskDialogSimpleTests.cs` |
| `BuiltInCategoryExtensions.GetCategoryIds` (the `InternalDefinitionExtensions` overload of the same name stays) | `CategoryAndParameterHelperTests.cs`, `InsulationCategoriesTests.cs` |
| `BuiltInCategoryRow` (whole class) | `CategoryAndParameterHelperTests.cs` |
| `BuiltInCategoryWrapperExtensions.GetRecord` | `CategoryAndParameterHelperTests.cs` |
| `CategoryExtensions.ParseBuiltInCategory`, `IsFabricationOrFamilyPart_Victaulic` | `CategoryAndParameterHelperTests.cs` |

### Kelly-Revit-UI

| Member | Tests that go with it |
|---|---|
| `PushButtonText`: `AlignPipeBottoms`, `BuiltInParameterLists`, `ManagerLocationPoints`, `ServiceColors`, `SpoolIfcStrutInView`, `UpdateCustomData` | `test/Revit.UI.Tests/Ribbon/PushButtonTextTests.cs` (it pins the field count, 63: lower it) |
| `RotateAxisIsMepFittingSelectionFilter` (class) | `Revit.UI.RevitTests/Selection/SelectionFilterTests.cs`, `Revit.UI.Tests/Architecture/DocumentsAndElementsMovesTests.cs` |
| `RotateAxisIsMepStraightSelectionFilter` (class) | same, plus Kelly-Revit-v5 `Commands/LowerLayerRulesTests.cs` |
| `SelectionExternalEventHandler` (class) | `Revit.UI.RevitTests/Selection/SelectionExternalEventHandlerTests.cs`, Kelly-Revit-v5 `LowerLayerRulesTests.cs` |

### Kelly-Revit-v5

| Member | Tests that go with it |
|---|---|
| `AssignerKindExtensions.ToLabel`, `ToFormatHint`, `ToExampleValue` (`modules/Trade.All/DockablePanes/Assigner`; only crefs in `AssignerRowViewModel.cs`) | `test/Tests.Revit/Assigners/AssignerKindExtensionsTests.cs`, `AssignerRowViewModelTests.cs` |

### Fabrication-Tools

| Member | Tests that go with it |
|---|---|
| `SizeUpdateFilterQuality.IsBadData` (`SPECIFICATION.md` says `GroupOf` replaced it) | `tests/FabricationTools.Tests/ViewModels/SizeUpdateFilterQualityTests.cs` |

## Decide: Victaulic settings in Kelly-Domain (55 members)

`Kelly-Domain/src/Pcf/VtfrSettings.cs`: all 43 properties of `VtfrSettingsRow`, the 9 properties of `FtpTemplate`, and `VtfrSettings.RevisionNumber`, `RodSizeConversionValues` and `UnitConversionValues`. Only `VtfrSettingsTests.cs` uses them.

They look dead because nothing assigns `VtfrUserSettings`. `VtfrSettingsTests.cs` already describes this as a bug: Point To Pipe always starts in Imperial, even in metric projects. Production reads only `GetGlobalUnits` (that is, `Units`). Either:

- **Delete:** keep `Units` and `GetGlobalUnits`, and file the units bug alone; or
- **Keep:** wire up a settings loader, which makes these members live.

## Keep

| Member | Reason |
|---|---|
| `ProgressReporter.UseFactory` (Kelly-Windows-v3) | Test seam by design; its XML docs say tests replace the window with it. |
| `ProgressWindowReporter.Displayed` (Kelly-Windows-v3) | Internal test seam, read through `InternalsVisibleTo`. |
| `JsonFileRepository.DeleteWhere`, `GetById`, `Upsert`, and `JsonDataDirectory` (Kelly-Windows-Data-Json) | Public, and may be used by Major Version 4 `Kelly.Revit.Logic` 4.x, whose source is not on this machine. |

## Used (the scan missed it)

- `Product.productIndex` (Component-Data-Editor): an `[ObservableProperty]` field whose generated `ProductIndex` property is used by `ComponentEditorViewModel.cs`. The scan skips generated code. Proposed `.yagni` rule: `used: Component-Data-Editor|Product|productIndex`.

## Deleted 2026-11-20

The maintainer asked: "File "Used Only By Test" and "Dead" Linear issues and then delete them", then "rescan and delete the second round". The Decide group (the Victaulic settings) was deleted under KD-85, as that issue's Goal said. The 94 members nothing used at all were checked too: 51 were dead and deleted; 40 in Component-Data-Editor and Fabrication-Tools are CommunityToolkit generator entry points, and 3 are Developer sandbox helpers (both now in `.yagni`).

| Repository | Commits | Issues |
|---|---|---|
| Kelly-Windows-Data-v3 | `3b1194f`, `5d39609` | KWD3-22, KWDSS-13 |
| Kelly-Windows-Data-SqlServer | `6b4a11f`, `8caace5` | KWDSS-13 |
| Kelly-Windows-Data-Sqlite | `e1df385`, `0c21d0d` | KWDSL-2 |
| Kelly-Windows-Data-Excel | `94dbe7d` | KWDE-4 |
| Kelly-Windows-v3 | `4936db8`, `ec0a221` | KW3-51, KW3-52, KW3-53 |
| Kelly-Domain | `27d218b`, `0e48105` | KD-85, KD-86, KD-87, KD-88, KTRL5-175 |
| Kelly-Revit-Logic-v5 | `0c25759`, `c6df7a1`, `b5b3853` | KTRL5-175 to KTRL5-178, KD-86 |
| Kelly-Revit-UI | `f5e5ee0`, `39801ab` | KTRUI-45 |
| Kelly-Revit-v5 | `58847774` | KTR5-4907, KTRUI-45, KTRL5-178 |
| Fabrication-Tools | `6bbe93c` | FKS-52 |

Second round (left dead by the first): Kelly-Domain `ToRecord` on nine types, `BuiltInCategoryMetaRecord`, `Nouns.Pipe`; Kelly-Windows-v3 `ColorNameTools` and five `RoundAmount` increments; Kelly-Windows-Data-v3 `DataFileProblem` and two test types; Kelly-Revit-Logic-v5 `ShowWorksharingInfo`, `ParseElementId`, both `GetAssemblyInstances`, `TransactionName.UnGroupGroups` and `UpdateProjectInformationId`; Kelly-Revit-UI `GetSelectedAssemblyInstances`, `GetAssemblyTypes`; leftover test helpers and the SqlServer `System.Configuration` references.

Kept although an issue named them: `DefinitionRegistry.IsRegistered` (the assigner pane uses it), `FabricationConnectorTools` (`StraightLengthPart`), `ParameterFilterElementExtensions.ExportNamesToCsv` (Filters To CSV), `VtfrSettings.Year` (the Victaulic tools folder), `StringExtensions.ThrowIfNullOrWhiteSpace`. Kept on purpose in the second round: `SizeUpdateActionOutcome.IsBadData` (new work under FKS-58), `DataDirectory.RecordAssemblies` (the add-in passes the constructor parameter).

### Left

- Pack each changed package and repin the layers above; none is packed yet. When Fabrication-Tools is repinned to the new Excel package, three of its tests that call `ReadSheetNames` must change.
- Kelly-Revit-v5 `docs/Specification.md` R16 and Duct Length Check R7 require `SelectionExternalEventHandler`, which nothing ever used and which is now deleted.
- Third round, not deleted: the private Kelly-Domain properties only `ToRecord` read, and `Product.RecordId`.
