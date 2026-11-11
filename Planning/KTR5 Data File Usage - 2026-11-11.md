# KTR5 data file usage (2026-11-11)

Question: which of the CSV data files that Kelly-Revit-Data-Exporter writes does Kelly Tools For Revit 5 really use?

Method: from Kelly-Domain's `DataStore` (the one place v5 reads the files), every accessor was traced through the Kelly-Domain caches and resolvers and the `DataFiles` registry to the code that calls it in Kelly-Revit-Logic-v5, Kelly-Revit-UI and Kelly-Revit-v5 (`src` and `modules`, tests left out). This was done by text search on `develop` as of today, not by running the add-in. Sizes are the installed files in `C:\Program Files\JH Kelly\Kelly Tools For Revit\Data`.

## Summary

- **v5 loads 22 of the 23 files at startup** (`DataStore.Load`, `DataStore.RecordTypes`), all of them every time, for every user.
- **Unused in v5: 2 files.**
  - `EndPreparationsWelded.csv` (1 KB) is not loaded at all. `DataStore`'s own docs say nothing in v5 uses it.
  - `Project.csv` (446 KB) is loaded into `DataStore.Projects`, and nothing reads it.
- **Used by the Contenter tab's Fabrication Custom Data commands only: 2 files,** about 11 MB of the 38 MB.
  - `CustomDataUpdater.csv` (10.8 MB) is used only by Proposed Report and Updater V2.
  - `ItemCustomDataPivotedOnComponentId.csv` (169 KB) is used only by Updater V1.
- The other 18 are used by updaters, caches or services that run in every project.
- **v4 was not checked.** The v4 repos are not cloned here, so these results say nothing about which files Major Version 4 needs. The exporter serves both versions, so a file is only safe to drop from the export once v4 has been checked too.

Correction made the same day: a first draft listed `ComponentAndLookupsView.csv` as used by one tool only. It missed `DataFiles.FindComponent`, which the updaters call.

## Per file

| File | Size | v5 reader (Domain → add-in) | Used by | Verdict |
|---|---:|---|---|---|
| Product.csv | 15.4 MB | `Products` → `ProductCache` → `DataFiles.Products` | Size updater (`SizeElementDataModel`, `ProductTools.GetSizeByProductCode`) | Used |
| CustomDataUpdater.csv | 10.8 MB | `CustomDataUpdaters` | Trade.Contenter: Fabrication Custom Data Proposed Report, Fabrication Custom Data Updater V2 | Contenter only (KD-83) |
| ComponentAndLookupsView.csv | 3.7 MB | `ComponentAndLookups` → `ComponentCache` → `DataFiles.Components`, `DataFiles.FindComponent` | Material, Schedule Gauge and Size updaters (`FindComponent`); Trade.Contenter: Fabrication Custom Data Updater V2 | Used |
| BuiltInCategoryBinding.csv | 3.6 MB | `FindBuiltInCategoryBindings` → `ExternalParameterDefinitionCache` | Shared parameter definitions (`DefinitionRegistry`, every Kelly parameter) | Used |
| Project.csv | 446 KB | `Projects`: no reader | none | **Unused in v5** |
| ItemCustomDataPivotedOnComponentId.csv | 169 KB | `ItemCustomDataPivotedOnComponentId` | Trade.Contenter: Fabrication Custom Data Updater V1 | Contenter only (KD-83) |
| ConnectorPreparations.csv | 145 KB | `FindConnectorPreparation` → `ConnectorPreparationResolver` | End Preparation updater (`EndPreparationUpdaterElementService`) | Used |
| ExternalParameterDefinition.csv | 74 KB | `ExternalParameterDefinitions` → `ExternalParameterDefinitionCache` | Shared parameter definitions (`App.GetDefinition`) | Used |
| ServiceData.csv | 68 KB | `ServiceRecords` → `ServiceCache` → `DataFiles.Services` | Layout discipline, service writer, signature view filters | Used |
| System.csv | 63 KB | `SystemRecords`, `FindSystemBySignature` → `SystemCache`, `ProjectSystemQueries` | System updater, Detailing Phase updater, system combo boxes (`SystemDocumentCache`) | Used |
| Terminology.csv | 29 KB | `Terminologies` → `TerminologyCache` → `DataFiles.Terminologies` | Weld Location service, Spool Create and Spool Manager | Used |
| Gauge.csv | 13 KB | `FindGauge` → `GaugeNameResolver` | Schedule gauge data, custom data updater, Fabrication Custom Data V2 | Used |
| MaterialAndLookupsView.csv | 7 KB | `FindMaterial` → `MaterialAndLookups` | Material updater (`MaterialElementDataModel`) | Used |
| GroupTypeId.csv | 5 KB | `FindGroupType` → `ExternalParameterDefinitionCache` | Shared parameter definitions | Used |
| ProjectToSystem.csv | 4 KB | `FindProjectToSystems` → `ProjectSystemQueries` | System combo boxes (`SystemDocumentCache`) | Used |
| ProductRangeParameterDefaults.csv | 3 KB | `FindProductRangeParameterDefaults` → `ProductRangeCache` | Checkbox Default updater | Used |
| SizeSymbol.csv | 2 KB | `FindSizeSymbols` → `ConnectorSizeDataResolver` | Size updater | Used |
| CategoryType.csv | 2 KB | `CategoryTypes` → `DataFiles.CategoryTypes` | Spool item rules (`SpoolItemRules`), Trade.Developer Product Range Schedules | Used |
| ProductRange.csv | 1 KB | `ProductRanges` → `ProductRangeCache` → `DataFiles.ProductRanges` | Checkbox Default updater | Used |
| ConnectorMapping.csv | 1 KB | `FindConnectorMapping` → `ConnectorSizeDataResolver` | Size updater | Used |
| ConnectorGrouping.csv | 1 KB | `FindConnectorGrouping` → `ConnectorSizeDataResolver` | Size updater | Used |
| Configuration.csv | 1 KB | `FindConfiguration` → `ProjectSystemQueries` | System combo boxes (`SystemDocumentCache`) | Used |
| EndPreparationsWelded.csv | 1 KB | not loaded | none | **Unused in v5** |

## What follows

1. **Project.csv** ([KD-82](https://linear.app/jhkelly-ktr/issue/KD-82)): stop loading it in v5. Remove `DataStore.Projects`, `DataStoreRecords.Projects` and `ProjectRecord` from `RecordTypes` in Kelly-Domain, then repin. Drop it from the export only if v4 doesn't read it either.
2. **EndPreparationsWelded.csv:** it is already being removed from the exporter's catalog; those changes are uncommitted in Kelly-Revit-Data-Exporter. v4 was not checked, so confirm v4 doesn't read it before that change ships.
3. **The two Fabrication Custom Data files (about 11 MB)** ([KD-83](https://linear.app/jhkelly-ktr/issue/KD-83)): every user loads them at startup for three Contenter commands. Reading them the first time one of those commands runs would shorten startup and save memory for everyone else. `ComponentAndLookupsView.csv` must stay loaded at startup: the Material, Schedule Gauge and Size updaters use it through `DataFiles.FindComponent`.
4. **The V1 command:** if Fabrication Custom Data Updater V1 has been replaced by V2, retiring V1 would also retire `ItemCustomDataPivotedOnComponentId.csv`.
