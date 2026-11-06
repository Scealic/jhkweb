# Deprecate the Component and Product updaters (v5) — Plan

2026-11-06. Replaces `DEPRECATE-COMPONENT-PRODUCT-UPDATERS.md` (2026-10-30), which was written before the repo split and the move to CSV data files: its paths, its `ServerData` caches and its SQL steps no longer apply.

- Linear: KTRL5-8 (Logic side), KTR5-4726 (add-in side). Requested by Adam Fuller on 2026-11-03.
- Scope: Kelly Tools For Revit Major Version 5 only. Repos touched: Kelly-Domain and Kelly-Revit-Logic-v5; Kelly-Revit-v5 for docs and the repin only.
- Based on a read of the code on `develop`; nothing built or run yet.

## What the two updaters are

| | Component | Product |
|---|---|---|
| Auto configuration | `ComponentAutoUpdaterConfiguration` (GUID `143dd38c-…`) | `ProductAutoUpdaterConfiguration` (GUID `79022c0b-…`) |
| Manual configuration | `ComponentManualUpdaterConfiguration` | `ProductManualUpdaterConfiguration` |
| Element service | `ComponentUpdaterElementService`, ExecutionOrder 002 | `ProductUpdaterElementService`, ExecutionOrder 019 |
| Data model | `ComponentElementDataModel` | `ProductElementDataModel` |
| Definition set (Kelly-Domain) | `ComponentDefinitionSet` | `ProductDefinitionSet` |
| Data read | `DataFiles.FindComponent` | `DataFiles.FindProductByComponentId` |
| Parameters written | JHK Category Type, Class Description*, Finish, Long Description, Manufacturer*, Part Category, **Product Range**, Short Description*, Trade Name* | JHK CAHF*, CIPE*, Product Id*, Total Weight |

\* already under `Names.DefinitionsInternal.Deprecated`.

Logic files: `Kelly-Revit-Logic-v5/src/Updaters/Configurations/{Auto,Manual}`, `Updaters/ElementServices`, `Updaters/ElementDataModels`. Registration: `Updaters/AutoUpdaterManager.cs` (the explicit list in the build step) and `Updaters/Configurations/Manual/ManualUpdaterConfigurationSet.cs`. The add-in (`Trade.All` manual updater commands, `SpoolManagerViewModel`) only runs those lists and names neither updater.

Both are registered with `isOptional: true` (`AutoUpdaterManager.cs`, `RegisterUpdater(updater, document, true)`), so documents edited with them open without a missing-updater warning once they are gone. Elements already in models keep their last-written values; only new and changed elements stop getting them.

## Ramifications

### Component updater: blocked

In v5 it is the **only writer** of JHK Product Range, and of JHK Long Description on fabrication parts. Fabrication custom data (`FabricationCustomData`, written by the Update Custom Data command) has Category Type (112) and Part Category (117) but no Product Range or Long Description, so nothing replaces them today.

| Reader of what it writes | Uses | Effect on new elements without it |
|---|---|---|
| `WeldUpdaterElementService` (014, same pass) | filter: fabrication parts whose Product Range is `"10"` | welds not found; weld location, type and tag prefix stay empty |
| `CheckboxDefaultUpdaterElementService` (018, same pass) | Product Range → `ProductRangeTools.GetCheckboxDefault` | checkbox defaults not applied |
| `Spool`, `SpoolItem`, `SpoolTools`, `ElementComponent`; Spool Manager and Module Manage views | Product Range (weld vs component, item numbering, sort); Long Description (sort, grid columns) | welds counted as components; numbering and order change |
| `ProductRangeScheduleExtensions`, `ViewFilterExtensions`, `UiDocumentExtensions` | Product Range | product range schedules, filters and selection miss new elements |
| `ValveData`, `WeldLocationService`, `TrapezeVerticalMemberTools`, `SuspendedSupport`, `PhysicalElementEntity` | Long Description | blank or "undetermined" labels |

Category Type, Finish and Part Category have no Revit-parameter readers in v5; the deprecated four have none.

### Product updater: safe to remove

- CAHF, CIPE: no readers.
- Product Id: read only by `PhysicalElementEntity` (display) and by `ElementDataModel`'s constructor into `ProductId`, which only `ProductElementDataModel` uses.
- Total Weight: `ElementExtensionsJhk.GetWeight` reads it only for non-fabrication, non-assembly elements (fabrication parts use `part.Weight`). Non-fabrication families keep whatever the family or the user puts there; the updater only copied `GetWeight()` back onto itself.
- `DataFiles.FindProductByComponentId` has no other caller. `ProductCache` / `DataFiles.Products` stay: `SizeElementDataModel` uses them.

## Decision needed before Phase B

Who writes JHK Product Range (and Long Description on fabrication parts) after the Component updater is gone? Options:

1. A slim updater that writes only Product Range and Long Description (keeps ExecutionOrder before 014).
2. Fold those two into an existing early service such as `ContentIdentityUpdaterElementService` (001).
3. Add them to fabrication custom data and read them from there (changes the ITM configuration; Adam's call).
4. Accept the loss (not recommended: breaks welds, checkbox defaults and spool numbering).

Ask Adam Fuller which, and whether Category Type, Finish and Part Category on Revit elements are still wanted.

## Phase A: remove the Product updater

TDD: change the tests first, see them fail to compile or fail, then change `src`. Reset `Author` to `"Verified By Human On:"` on every test that changes.

**Kelly-Domain**
1. Delete `Definitions/ProductDefinitionSet.cs` and `DataFiles.FindProductByComponentId`, with their cases in `tests/Definitions/DefinitionSetsTests.cs` and `tests/Caches/DataFilesLookupTests.cs`.
   - Hold this until Logic no longer uses them (step 3), or mark both `[Obsolete]` in this package and delete in the next, so the repin does not break the Logic build.
2. Run the tests in Net481, Net80 and Net100; README, Changelog, XML docs in the same commit; pack.

**Kelly-Revit-Logic-v5**
3. Remove `ProductId` and `ProductSet` from `Updaters/ElementDataModel.cs`.
4. Remove `new ProductAutoUpdaterConfiguration()` from `AutoUpdaterManager.cs` and `new ProductManualUpdaterConfiguration()` from `ManualUpdaterConfigurationSet.cs`.
5. Delete `ProductAutoUpdaterConfiguration`, `ProductManualUpdaterConfiguration`, `ProductUpdaterElementService`, `ProductElementDataModel`.
6. Tests: drop the Product cases in `Updaters/Configurations/AutoUpdaterConfigurationsTests.cs`, `ManualUpdaterConfigurationsTests.cs`, `Updaters/ElementServicesTests.cs`, `Updaters/ElementDataModelsTests.cs`, and the `ProductElementDataModel.cs` case in `Architecture/MovedToKellyDomainTests.cs`; update any count of configurations.
7. Repin Kelly-Domain; build `-c 2024`, `2025`, `2026` with `-p:SolutionName=Kelly.Revit.Logic -p:GeneratePackageOnBuild=false`; run the changed fixtures in Revit 2024 with the add-in manifest renamed to `.addin.x` (rename back afterwards).
8. README (updater counts, SOLID only if a rating moves), Changelog, XML docs; pack.

**Kelly-Revit-v5**
9. Repin Logic; build (no install, `KTR0004` expected); update `.ai/Report Of Types … External Parameter Definitions.md`, Changelog.

## Phase B: remove the Component updater (after the decision)

1. Put the replacement writer of Product Range / Long Description in place first, with tests, at an ExecutionOrder before 014.
2. Remove `ComponentAutoUpdaterConfiguration` and `ComponentManualUpdaterConfiguration` from the two lists; delete them, `ComponentUpdaterElementService` and `ComponentElementDataModel`.
3. Kelly-Domain: delete `ComponentDefinitionSet` if nothing uses it; check `ComponentValueTools` and `ContentTools.GetScenarioThree*` (used only by `ComponentElementDataModel`) and whether `Component.GetClassDescription` / `GetLongDescription` / `GetShortDescription` still have callers. `DataFiles.FindComponent` stays (Material, ScheduleGauge, Size).
4. Tests as in Phase A (Component cases in the same five fixtures, plus `CommonDefinitionsMovesTests` if it names the set).
5. Pack, repin, rebuild as in Phase A.

## Later, optional

- Retire the deprecated shared parameters (Class Description, Manufacturer, Short Description, Trade Name, CAHF, CIPE, Product Id) from `Names.cs` and the shared parameter file, after a release cycle. `PhysicalElementDefinitionSet` still reads Product Id; drop that first.
- Exporter / CSV: `Product` rows are still needed for Size; no data file change.

## Verify

- Revit 2024, with a Kelly test model (`RevitTestModels\2024`): place a fabrication pipe with a weld and a valve family. Phase A: no errors, CAHF/CIPE/Product Id no longer written. Phase B: Product Range and Long Description still filled by the replacement; weld and checkbox defaults still applied; Spool Manager numbering unchanged.
- Manual updater (document, view, selection) runs without the removed entries.
- Test logs have a row for every expected test.

## Bookkeeping

- Commit each repo on `develop`, no push. Tick the backlog items with commit evidence in a follow-up commit (`kelly-backlog-update`).
- Update KTRL5-8 and KTR5-4726 to point to this file; KTR5-4726 reduces to docs and the repin, since the add-in names neither updater.
