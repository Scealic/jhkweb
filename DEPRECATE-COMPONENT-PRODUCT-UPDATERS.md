# Deprecating the Component / Product element updaters

Based on a read of the code only. Nothing was built or run, and the Revit-side shared parameter files were not inspected.

## What "the process" is

Two pairs of auto and manual updaters write Component and Product data onto Revit element instances. Each updater is a configuration class, an element service and a data model:

| | Component | Product |
|---|---|---|
| Auto config | `ComponentAutoUpdaterConfiguration` | `ProductAutoUpdaterConfiguration` |
| Manual config | `ComponentManualUpdaterConfiguration` | `ProductManualUpdaterConfiguration` |
| Element service | `ComponentUpdaterElementService` (order 002) | `ProductUpdaterElementService` (order 019) |
| Data model | `ComponentElementDataModel` | `ProductElementDataModel` |
| Parameter set | `ComponentDefinitionSet` | `ProductDefinitionSet` |
| Writes | JhkCategoryType, JhkClassDescription, JhkFinish, JhkLongDescription, JhkManufacturer, JhkPartCategory, JhkProductRange, JhkShortDescription, JhkTradeName | JhkCahf, JhkCipe, JhkProductId, JhkTotalWeight |

The configs and services are under `Kelly-Revit-Logic/src/Configurations/Updater/{Component,Product}` and `Services/ElementServices`. The data models are under `Models/ElementDataModels`, and the parameter sets are in `Sets/`.

## Component.cs and Product.cs cannot be deleted yet

`Component.cs` and `Product.cs` are the cache DTOs, and they are used by more than these updaters. The caches and DTOs stay for now.

| Remaining consumer | What it uses |
|---|---|
| `MaterialElementDataModel` | `ServerData.Components` |
| `ScheduleGaugeElementDataModel` | `ServerData.Components` |
| `SizeElementDataModel` | `ServerData.Components` and `ServerData.Products` |
| `FabricationCustomDataUpdaterCommandV2` | `ServerData.Components` |
| `CustomDataUpdateEvaluator` | `Component` |

`ComponentCache` and `ProductCache` are also registered in `App.cs` and `ServerDataService`.

## Steps

**1. Decide the scope first.** Decide one of two things:
- Stop writing the parameters only (steps 2 to 4).
- Also retire the parameters and the SQL (steps 5 to 7).

**2. Check what reads the output parameters.** Do this before removing anything. Elements already in models keep their last-written values, but new elements stop getting them.
- **JhkProductRange:** `SpoolManagerViewModel`, `ModuleManageViewModel` and the spool models filter and sort on it, and `ProductRange` schedules and `CheckboxDefaultUpdater` appear to depend on it too.
- **JhkLongDescription:** `FabricationCustomDataReport`, `PartDimensionExport`, `PenetrationTagAssign`, `SuspendedSupportManager` and the trapeze commands read it.
- **JhkProductId:** `ElementDataModel.cs:19` reads it for every data model.
- **JhkTotalWeight:** readers not yet traced.
- **Replacement:** `FabricationCustomDataUpdaterV2` may already cover part of this, but that is unconfirmed for non-fabrication families.

**3. Unregister the updaters.** This stops the process.
- In `AutoUpdaterService.cs` (`BuildStepAlphaCreate`), remove `ComponentAutoUpdaterConfiguration` and `ProductAutoUpdaterConfiguration`.
- In `ManualUpdaterExtensions.cs` (`BuildConfigurations`), remove `ComponentManualUpdaterConfiguration` and `ProductManualUpdaterConfiguration`.
- The explicit lists mean this is a visible change rather than a type scan. `ARCHITECTURAL-ANALYSIS.md` counts 21 auto and 16 manual configurations, so update those numbers to 19 and 14.
- Any Revit document that has these updaters registered will drop them on next load. The GUIDs are `143dd38c-…` for Component and `79022c0b-…` for Product.

**4. Delete the dead code.**
- Delete the four configuration classes, the two element services and the two data models.
- Delete `ComponentDefinitionSet` and `ProductDefinitionSet`, but only after confirming no other class uses them. `ElementDataModel` has its own nested definition set that includes `JhkProductId`.
- Check `ExecutionOrder` 002 and 019 for any other updater that relied on running after these two.
- Check `Revit.csproj` for explicit includes.
- Check `ProductCodeScenario` and `Names.DefinitionsInternal.Deprecated.*`. Several of these parameters are already marked "Deprecated" (JhkClassDescription, JhkManufacturer, JhkShortDescription, JhkTradeName, JhkCahf, JhkCipe, JhkProductId).

**5. Trim the caches, if nothing else needs them.**
- After step 4, `ProductCache` is only used by `SizeElementDataModel`.
- If that use goes, remove `ProductCache`, `Product`, `ProductRecord`, `GetProductCache` and the `ServerData.Register` call at `App.cs:96`.
- `ComponentCache` stays unless Material, ScheduleGauge, Size and V2 all stop using it.

**6. Retire the shared parameters.** Remove the deprecated ones from the shared parameter file and from `Names.cs`. Do this only after step 2 confirms nothing reads them, and ideally after a release cycle.

**7. Retire the SQL.** This is only possible once the caches are gone.
- Stored procedures: `USP_Table_Product_ReadAll` and `USP_View_ComponentAndLookups_ReadAll`.
- Use the existing `db-deprecation/` scripts (mark deprecated, then rename, then drop) rather than dropping directly.
- `db-object-usage-report.csv` shows both procedures still referenced by `Kelly-Revit`.
- Both procedures are in `VCS-Database-Content-Schema/Project/Project.sqlproj`.

**8. Verify.**
- Build with `dotnet build -c 2026`.
- Start Revit and confirm the startup cache count and updater count match the new numbers.
- Place an element and confirm no errors.
- Run `Kelly-Revit-Logic/test`.
- Run the manual updater command and check that the Component and Product entries are gone.
- Update the docs that mention these types, such as `ARCHITECTURAL-ANALYSIS.md` and the `.ai/` reports in `Kelly-Revit`.

The repos are not under one git root, so commit each repo separately. Changes in steps 3 to 5 touch both `Kelly-Revit` and `Kelly-Revit-Logic`. The SQL changes in steps 6 and 7 are in `VCS-Database-Content-Schema`.
