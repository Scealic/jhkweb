# YAGNI 2026-11-12: Kelly-Revit-Logic-v5

Code in Kelly-Revit-Logic-v5 that nothing in production uses, found with the `yagni` skill and checked by grep. Nothing has been deleted.

## 1. Scope

- **Target:** `Kelly-Revit-Logic-v5` (`develop`, as checked out on 2026-11-12).
- **Dependents searched for uses:** Kelly-Revit-UI (pins Logic) and Kelly-Revit-v5 (through UI): `src`, `modules`, XAML. Their tests count only as "tests only".
- **Dependencies read for interfaces and base types only:** Kelly-Domain, Kelly-Windows-v3, Kelly-Windows-Data-v3, -Csv, -Json.
- **Configuration:** the skill's `default-entry-points.txt` and the jhkweb root `.yagni`.
- **Not visible:** nothing outside these repos uses the Logic package (Major Version 4 has its own Logic repo).
- **Checking:** each name grepped as a whole word across the production code of the three repos (XML docs left out). Every hit was the member's own declaration or constructor, or, for `GetRecord`, one of the five same-named declarations.

## 2. Totals

| Unit | Types | Members | Candidates | Dead (unused) | Dead (tests only) | Used | Entry point | Keep |
|---|---|---|---|---|---|---|---|---|
| Kelly-Revit-Logic-v5 | 255 | 1566 | 41 | 4 | 37 | 0 | 0 | 0 |

The tests that go with them are in `test/Revit.Logic.RevitTests` (in-Revit) unless named otherwise.

## 3. Dead, by group

### Record conversions left from the SQL export (`GetRecord`)

Nothing calls any `GetRecord`. They turned rows into `IRecord`s for the SQL Server export, which v5 no longer has (since 2026-10-30).

| Member | File | Tests |
|---|---|---|
| `BuiltInCategoryRow` (type) and `GetRecord` | `src/Categories/BuiltInCategoryRow.cs` | `CategoryAndParameterHelperTests` |
| `BuiltInCategoryElementEntity` (type) and `GetRecord` | `src/Entities/BuiltInCategoryElementEntity.cs` | `BuiltInCategoryElementEntityTests` |
| `BuiltInCategoryWrapperExtensions.GetRecord` | `src/Categories/BuiltInCategoryWrapperExtensions.cs` | `CategoryAndParameterHelperTests` |
| `ExternalParameterDefinitionExtensions.GetRecord` | `src/Parameters/ExternalParameterDefinitionExtensions.cs` | `CategoryAndParameterHelperTests` |
| `ProjectInformationWrapper.GetRecord` | `src/Projects/ProjectInformationWrapper.cs` | `BuiltInCategoryElementEntityTests` |

### Documents and views

| Member | File | Tests |
|---|---|---|
| `DocumentExtensions.DeleteAllOfType` | `src/Documents/DocumentExtensions.cs:560` | `DocumentQueryTests` |
| `DocumentExtensions.GetBoundInternalDefinition` | `src/Documents/DocumentExtensions.cs:814` | `DocumentQueryTests` |
| `DocumentExtensions.GetFirstViewOrPrompt` | `src/Documents/DocumentExtensions.cs:1099` | `DocumentQueryTests` |
| `DocumentExtensions.SetProjectRecordId` | `src/Documents/DocumentExtensionsJhk.cs:143` | `KellyDocumentTests` |
| `ParameterFilterElementExtensions.ApplyToView` (the whole class's only member) | `src/Views/ParameterFilterElementExtensions.cs` | `ParameterFilterElementExtensionsTests` |
| `ViewExtensions.SetLinkVisibilityType`, `ShowAllRevitLinks` | `src/Views/ViewExtensions.cs:650, 727` | `ViewExtensionsTests` |
| `ViewFilterBuilder.OverrideSurfaceForeground` | `src/Views/ViewFilterBuilder.cs:136` | `ViewFilterTests` |
| `ViewFilterSets.ApplyBillOfMaterialTypeFieldAndFieldTrimFilter`, `ApplyBillOfMaterialTypeShopFilter` | `src/Views/ViewFilterSets.cs:7, 46` | `ViewFilterTests` |

### Elements, connectors, categories and the rest

| Member | File | Tests |
|---|---|---|
| `ElementDataExtensions.GetSharedParameter` | `src/Elements/ElementDataExtensions.cs:37` | `ParameterExtensionsTests` |
| `ElementExtensions.GetIds` | `src/Elements/ElementExtensions.cs:249` | none |
| `ElementIdExtensions.ParseElementIds` | `src/Elements/ElementIdExtensions.cs:101` | `ElementHelpersTests` |
| `ElementInstanceModel.TypeName` | `src/Elements/ElementInstanceModel.cs:33` | `ElementInstanceModelTests` |
| `GroupTools` (type, `UngroupGroups`) | `src/Elements/GroupTools.cs` | `ElementHelpersTests` |
| `ParameterBindingRecord` (type) | `src/Elements/ParameterBindingRecord.cs` | `ParameterBindingRecordTests` |
| `RevitLinkInstanceExtensions.IsEffectivelyLoaded` | `src/Elements/RevitLinkInstanceExtensions.cs:20` | `ElementHelpersTests` |
| `ConnectorWithOwner` (type) | `src/Connectors/ConnectorWithOwner.cs` | `ConnectorModelsTests` |
| `FabricationConnectorTools` (type, `GetFabricationName`) | `src/Connectors/FabricationConnectorTools.cs` | `FabricationOnlyTypesTests` |
| `VictaulicConnectorTools.GetAllConnectionInfos` | `src/Connectors/VictaulicConnectorTools.cs:10` | `ConnectorToolsTests` |
| `BuiltInCategoryExtensions.GetCategoryIds` | `src/Categories/BuiltInCategoryExtensions.cs:11` | `CategoryAndParameterHelperTests`, `InsulationCategoriesTests` |
| `CategoryExtensions.ParseBuiltInCategory`, `IsFabricationOrFamilyPart_Victaulic` | `src/Categories/CategoryExtensions.cs:48, 103` | `CategoryAndParameterHelperTests` |
| `ParameterExtensions.GetValueAsStringWithSingleQuotes` | `src/Parameters/ParameterExtensions.cs:82` | `ParameterExtensionsTests` |
| `CoordinateExtensions.TryParseXyz` | `src/Geometry/CoordinateExtensions.cs:193` | `CoordinateTests` |
| `FamilySymbolExtensions.HasInstances` | `src/Families/FamilySymbolExtensions.cs:129` | `FamilyHelpersTests` |

### Common and updaters

| Member | File | Tests |
|---|---|---|
| `KellyDirectories.GetOrCreateApplicationReportsDirectory`, `GetOrCreateProjectExportDirectory`, `GetOrCreateProjectsRootDirectory` | `src/Common/KellyDirectories.cs:51, 86, 106` | none |
| `TaskDialogSimple.ShowEntitiesNotFound`, `ShowFamilySymbolMissing` | `src/Common/TaskDialogSimple.cs:11, 25` | `TaskDialogSimpleTests` |
| `AutoUpdaterManager.UpdaterStates` | `src/Updaters/AutoUpdaterManager.cs:30` | `AutoUpdaterTests`; Kelly-Revit-v5 `test/Tests.Revit/Commands/LowerLayerRulesTests.cs` names it in a source-text rule (check that rule before deleting) |

## 4. Knock-on

Deleting the `GetRecord` group may leave Kelly-Domain and Kelly-Windows-Data types with no user (`BuiltInCategoryRecord`, `BuiltInCategoryMetaRecord` and the like). Run the scan on Kelly-Domain again after it lands.

## 5. `.yagni` changes

None needed: no entry points or false positives found.

## Filed 2026-11-12 (KTRL5, Backlog, Low, Delete)

- KTRL5-175: the `GetRecord` conversions (2 points).
- KTRL5-176: document and view helpers, before the `DocumentExtensions` split (related KTRL5-89, -108, -110, -111; 2 points).
- KTRL5-177: element, connector, category and geometry helpers (related KTRL5-135; 2 points).
- KTRL5-178: `KellyDirectories`, `TaskDialogSimple`, `UpdaterStates` (related KTRL5-139; 1 point).

## How to delete, when approved

Delete with the tests named, build `-c 2024`, `2025` and `2026` (`-p:SolutionName=Kelly.Revit.Logic`), run the affected in-Revit fixtures in Revit 2024 with the add-in disabled (README "Running the tests"), update the Changelog (public surface) and README, pack, repin Kelly-Revit-UI and rebuild the layers above.
