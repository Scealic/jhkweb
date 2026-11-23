# Shared parameter "JHK Product Range" in Kelly Tools For Revit 5

Where and how the v5 code (`develop`, 2026-11-23) defines, writes and reads the shared parameter **JHK Product Range**. Repositories searched: Kelly-Windows-Data-v3, Kelly-Windows-v3, Kelly-Domain, Kelly-Revit-Logic-v5, Kelly-Revit-UI and Kelly-Revit-v5 (`src` and `modules`; tests are left out).

## In short

- The parameter holds a **product range number, stored as text** ("1" Straights, "6" Valves, "10" Joints/welds, "20" Sleeve, …; see the table below).
- **One place writes it**: the Fabrication Part Data auto updater copies each fabrication part's ITM product range (`FabricationPart.ProductDataRange`) into it. On families the value comes from the content itself; no v5 code writes it there.
- **Everything else reads it**, for five purposes: finding elements of one category, defaulting other parameters, spool and module logic (the largest use), view filters and schedules, and a developer check.
- The data files' `CategoryType.ProductRange` column and the `ProductRange` list (`DataFiles.ProductRanges`) are keyed by the same number; the parameter value is the link from an element to those rows.

## What the values mean

`Kelly.Domain.Fabrication.ComponentCategoryType` ("AKA Product Range") and `Kelly.Domain.Products.ProductRangeRules` give the numbers their meaning:

| Value | Category | Special treatment in code |
|---|---|---|
| 0 | Default (empty or not a number also reads as 0) | Hidden in Stratus views; skipped as a module component |
| 1 | Straights | Vicious instance elevation assign selects these |
| 6 | Valves | Valve Clearance Spheres and Coordinate Testing select these |
| 8 | Supports | Suspended Support Manage loads these; tagged by its own tool, not spool tagging |
| 10 | Joints (welds) | `ProductRangeRules.IsWeld`: welds are split from components in spools, numbered separately, left off the bill of material; the Weld auto updater acts only on these |
| 13 | Connectors | Hidden in Stratus views |
| 14 | Layout Point | Tagged by its own tool |
| 20 | Sleeve | Penetration Tag Assign selects these; tagged by its own tool |
| 96 | Temporary / Non-Export | Hidden in Stratus views |
| 98 | Topworks | Hidden in Stratus views |

Other values (2–5, 7, 9, 11, 12, 15, 24, 25, 95, 97, 99, 100) have no special rule; whether a range can be spooled comes from the data files (`CategoryType.IsValidForSpool`).

## 1. Definition and data model

| Where | What |
|---|---|
| [`Names.cs:207`](../../Kelly-Domain/src/Vocabulary/Names.cs:207) | The name: `Names.DefinitionsInternal.ComponentData.JhkProductRange = "JHK Product Range"`. Every use below goes through this constant. |
| [`JhkFabricationPartInstanceDefinitionSet.cs:15`](../../Kelly-Domain/src/Definitions/JhkFabricationPartInstanceDefinitionSet.cs:15) | Definition set of the fabrication part instance updater (the writer). |
| [`JhkWeldDefinitionSet.cs:13`](../../Kelly-Domain/src/Definitions/JhkWeldDefinitionSet.cs:13) | Definition set of the weld updater (filter on "10"). |
| [`SuspendedSupportDefinitionSet.cs:29`](../../Kelly-Domain/src/Supports/SuspendedSupportDefinitionSet.cs:29) | Declared, but `SuspendedSupport` never reads or writes this member (see Observations). |
| [`ISpoolItem.cs:42`](../../Kelly-Domain/src/Spools/ISpoolItem.cs:42), [`ModuleComponentModel.cs:168`](../../Kelly-Domain/src/Spools/ModuleComponentModel.cs:168), [`SpoolBillOfMaterialLine.cs:23`](../../Kelly-Domain/src/Spools/SpoolBillOfMaterialLine.cs:23) | `int JhkProductRange` property carried by spool items, module components and bill-of-material lines. |
| [`ProductRangeRules.cs`](../../Kelly-Domain/src/Products/ProductRangeRules.cs) | The rules on the number: `IsWeld`, `RequiresDedicatedTaggingTool`, `StratusHiddenProductRanges`, `WeldNumberText`. |
| [`ProductRangeCache`](../../Kelly-Domain/src/Caches/ProductRangeCache.cs), `DataFiles.ProductRanges`, [`ProductRangeTools`](../../Kelly-Domain/src/Products/ProductRangeTools.cs) | The product range rows and their parameter defaults, looked up by the number read from the parameter. Registered at startup in [`App.cs:68`](../../Kelly-Revit-v5/src/App.cs:68). |

## 2. Where the value comes from (writers)

| Where | Trigger | What it writes |
|---|---|---|
| [`FabricationPartInstanceElementService.cs:45`](../../Kelly-Revit-Logic-v5/src/Updaters/ElementServices/FabricationPartInstanceElementService.cs:45), run by `FabricationPartDataElementService` in the **Fabrication Part Data auto updater** (`FabricationPartDataAutoUpdaterConfiguration`, on by default) | Fabrication part added or changed | `part.ProductDataRange` (the ITM's product range) as text, beside JHK Angle and JHK Pipe Size. |
| Family content | – | Families carry the value themselves; no v5 code writes JHK Product Range to a non-fabrication element. |

## 3. Where the value is read

### 3.1 Finding the elements of one category (filter on the parameter)

The core is [`ProductRangeExtensions.CreateProductRangeFilter`](../../Kelly-Revit-Logic-v5/src/Documents/ProductRangeExtensions.cs:13): it resolves the definition, looks up its `SharedParameterElement` in the document (none → `null`, so no elements) and builds a string-equals `ElementParameterFilter` on the category number. `GetInstancesByProductRange` ([Logic :49 and :68](../../Kelly-Revit-Logic-v5/src/Documents/ProductRangeExtensions.cs:49), and the `UIDocument` wrappers in [`UiDocumentScopeExtensions.cs:42`](../../Kelly-Revit-UI/src/Scope/UiDocumentScopeExtensions.cs:42)) applies it to the document, view or selection.

| Module | Command / type | Category | Scope |
|---|---|---|---|
| Trade.All | `SuspendedSupportManageViewModel` (through `ViewModel.LoadScopeElementsOrShowError`, [`ViewModel.cs:190`](../../Kelly-Revit-UI/src/Mvvm/ViewModel.cs:190)) | Supports (8) | Document, view and selection; error dialog when none |
| Trade.All | [`PenetrationTagAssignCommand.cs:11`](../../Kelly-Revit-v5/modules/Trade.All/Commands/PenetrationTagAssign/PenetrationTagAssignCommand.cs:11) | Sleeve (20) | Document |
| Trade.All | [`ViciousInstanceElevationAssignViewModel.cs:13`](../../Kelly-Revit-v5/modules/Trade.All/Commands/Acquired/Vicious/Racker/ViciousInstanceElevationAssignViewModel.cs:13) | Straights (1) | Selection |
| Trade.Pipe | [`ValveClearanceSpheresCommand.cs:20`](../../Kelly-Revit-v5/modules/Trade.Pipe/Commands/ValveClearanceSpheres/ValveClearanceSpheresCommand.cs:20) | Valves (6) | Selection |
| Trade.Pipe | Weld Location Field / Field Fit / Field Fit Tack / Shop / Shop Tack commands, through [`WeldLocationService.cs:23`](../../Kelly-Revit-Logic-v5/src/Fabrication/WeldLocationService.cs:23) | Joints (10) | Selection |
| Trade.Developer | [`CoordinateTestingCommand.cs:16`](../../Kelly-Revit-v5/modules/Trade.Developer/Commands/CoordinateTesting/CoordinateTestingCommand.cs:16) | Valves (6) | View |

### 3.2 Auto updaters that depend on it

| Updater | Where | Use |
|---|---|---|
| Weld (on by default, element addition) | [`WeldElementService.cs:6`](../../Kelly-Revit-Logic-v5/src/Updaters/ElementServices/WeldElementService.cs:6) | Its trigger filter is "JHK Product Range equals '10'" on fabrication parts; it then re-checks `IsWeld` and writes JHK Weld Location, JHK Weld Tag Prefix and JHK Weld Type. |
| Default Values (on by default, element addition) | [`CheckboxDefaultElementService.cs:40`](../../Kelly-Revit-Logic-v5/src/Updaters/ElementServices/CheckboxDefaultElementService.cs:40) | Reads the number, finds the product range row (`ProductRangeTools.Find`) and fills each empty Kelly yes/no parameter with that range's default. |
| Fabrication Part Data | §2 | The writer. |

### 3.3 Spools and modules (Trade.All: Spool Manager, Module Manage, Module Creator, Spool Clean By View)

| Use | Where |
|---|---|
| Spool item reads the value once when built | [`SpoolItem.cs:48`](../../Kelly-Revit-Logic-v5/src/Spools/SpoolItem.cs:48) |
| Weld or component: `IsComponent = !IsWeld(range)` | [`SpoolItem.cs:57`](../../Kelly-Revit-Logic-v5/src/Spools/SpoolItem.cs:57) |
| Spoolable check: the range must be one the data files mark `IsValidForSpool`; otherwise "Is Not A Valid Product Range" | [`SpoolItem.IsSpoolableElement`, :232](../../Kelly-Revit-Logic-v5/src/Spools/SpoolItem.cs:232), [`SpoolItemRules.IsSpoolableProductRange`](../../Kelly-Domain/src/Spools/SpoolItemRules.cs:25) |
| Spool Clean By View removes non-spoolable items from spools (transaction `RemoveElementFromSpoolHavingInvalidProductRange`) | [`SpoolTools.RemoveNonSpoolableItems`, :572](../../Kelly-Revit-Logic-v5/src/Spools/SpoolTools.cs:572) |
| Tagging: ranges 8, 14 and 20 get the "dedicated tagging tool" note instead of a spool tag | [`SpoolItem.cs:325`](../../Kelly-Revit-Logic-v5/src/Spools/SpoolItem.cs:325), [`SpoolItemRules.TagValue`](../../Kelly-Domain/src/Spools/SpoolItemRules.cs:48) |
| Welds of a spool = numberable items with range 10 | [`Spool.cs:447`](../../Kelly-Revit-Logic-v5/src/Spools/Spool.cs:447) |
| Bill of material: welds left out; lines sorted and grouped by range | [`SpoolBillOfMaterialBuilder.cs:25`](../../Kelly-Domain/src/Spools/SpoolBillOfMaterialBuilder.cs:25) |
| Item numbering: welds left out of component numbers; sorted and grouped by range | [`SpoolItemNumbering.cs:23`](../../Kelly-Domain/src/Spools/SpoolItemNumbering.cs:23), [:100](../../Kelly-Domain/src/Spools/SpoolItemNumbering.cs:100) |
| Module: a loose element with range 0 (or none) is not taken as a component | [`Module.cs:29`](../../Kelly-Revit-Logic-v5/src/Spools/Module.cs:29), [`ElementComponent.cs:40`](../../Kelly-Revit-Logic-v5/src/Spools/ElementComponent.cs:40) |
| Shown as a "Product Range" column | [`SpoolManagerView.xaml:523`](../../Kelly-Revit-v5/modules/Trade.All/Commands/Spools/SpoolManager/SpoolManagerView.xaml:523) and [:901](../../Kelly-Revit-v5/modules/Trade.All/Commands/Spools/SpoolManager/SpoolManagerView.xaml:901); [`ModuleManageView.xaml:659`](../../Kelly-Revit-v5/modules/Trade.All/Commands/Spools/ModuleManage/ModuleManageView.xaml:659) (also a sort key, :472) |

### 3.4 Views and schedules

| Command | Where | Use |
|---|---|---|
| Stratus Detailing Package Views (Trade.All) | [`StratusViewTools.cs:73`](../../Kelly-Revit-Logic-v5/src/Views/StratusViewTools.cs:73) → [`ViewFilterExtensions.ApplyStratusProductRangeHideFilter`, :139](../../Kelly-Revit-Logic-v5/src/Views/ViewFilterExtensions.cs:139) | Adds a view filter hiding elements whose range is 0, 13, 96 or 98. Throws when no category is bound to the parameter. |
| Create Product Range Schedules (Trade.Developer) | [`ProductRangeScheduleExtensions.cs:69`](../../Kelly-Revit-Logic-v5/src/Views/ProductRangeScheduleExtensions.cs:69) | One "KTR - Product Range NN (…)" schedule per data-file category type, with a "Product Range" column filtered and grouped on the parameter. |

### 3.5 Developer diagnostics

| Command | Where | Use |
|---|---|---|
| Sandbox (Trade.Developer) | [`SandboxCommand.cs:84`](../../Kelly-Revit-v5/modules/Trade.Developer/Commands/Sandbox/SandboxCommand.cs:84) | Logs, for every fabrication part, whether `ProductDataRange` equals the parameter value. |

## 4. What it would take to stop using it

### Where the number would come from instead

The parameter is a copy. Each kind of element already has its product range somewhere else:

| Element | Source without the parameter | Usable in a Revit filter, view filter or schedule? |
|---|---|---|
| Fabrication part | `FabricationPart.ProductDataRange`, also exposed as the built-in parameter `FABRICATION_PRODUCT_DATA_RANGE` | Yes, through the built-in parameter, but only on the fabrication categories |
| Family instance | **JHK Component Id** → the `ComponentAndLookupsView` row (10,264 rows) → `CategoryTypeDotProductRange` | No. The number lives in the data files, not on the element. A filter has to be built from the list of component ids in the range, or the elements have to be tested in memory |

That makes one new member the centre of the change: a Logic `GetProductRange(Element)` that returns `ProductDataRange` for a fabrication part and looks up the component's range for any other element, returning 0 when there is none. It replaces `GetJhkProductRange` and keeps its contract.

**Prerequisite to check first:** v5 writes JHK Component Id only on fabrication parts (`ContentIdentityElementService`). Families must carry it in their content. Any Kelly family without a component id that today has JHK Product Range filled in would lose its range: it would drop out of spools, modules and every category filter. Check the family library (and a few live projects) before committing to this route.

### Changes by group

| Group (section) | Change | Size |
|---|---|---|
| Writer (§2) | Delete the `SetValue` at `FabricationPartInstanceElementService.cs:45` and the member from `JhkFabricationPartInstanceDefinitionSet`. | Small |
| Readers through `GetJhkProductRange` (§3.2 Default Values, §3.3 spools and modules, §3.5 Sandbox) | Switch to `GetProductRange`: `SpoolItem` (:48, :232), `ElementComponent`, `Module`, `CheckboxDefaultElementService`, `WeldElementService` (:23). Kelly-Domain's spool types, `ProductRangeRules` and the XAML bindings take an `int` and need no change (renaming `JhkProductRange` to `ProductRange` is optional and touches Domain, Logic and both XAML views). The Sandbox comparison becomes pointless; delete it. | Medium; mostly mechanical |
| Weld updater trigger (§3.2) | Filter on `FABRICATION_PRODUCT_DATA_RANGE` equals "10" instead of the shared parameter; drop the member from `JhkWeldDefinitionSet`. Also settles observation 3, because End Preparation already reads `ProductDataRange`. | Small |
| Category filters (§3.1) | Rewrite `CreateProductRangeFilter`/`GetInstancesByProductRange` as an OR of two filters: `FABRICATION_PRODUCT_DATA_RANGE` equals the number for fabrication parts, and JHK Component Id is one of the range's component ids for families. Alternatively, collect candidates and test `GetProductRange` in memory, which is slower on whole-document scopes (Penetration Tag Assign, Suspended Support Manage). The six commands and `ViewModel.LoadScopeElementsOrShowError` keep their calls. | Medium |
| Stratus view filter (§3.4) | `ApplyStratusProductRangeHideFilter` becomes a `ParameterFilterElement` with the same two-part rule (built-in range for fabrication parts, component id list for families). With ranges 0, 13, 96 and 98, the component id list may be long, and it goes stale when the data files change, until the views are rebuilt. | Medium |
| Create Product Range Schedules (§3.4) | A multi-category schedule can't filter on a built-in fabrication parameter or a data-file value. Options: filter on **JHK Category Type** (already a text parameter "tied to the Product Range"), which only moves the dependency to another shared parameter; build fabrication-only schedules on `FABRICATION_PRODUCT_DATA_RANGE`; or retire the Developer command. | Decision needed |
| Definition (§1) | Remove the constant from `Names.cs` and the unused `SuspendedSupportDefinitionSet` member. | Small |
| Tests | 16 Logic in-Revit test files and 8 Kelly-Domain test files use the parameter or `KellyDefinitions.Bind` it. Re-point them to `ProductDataRange` stubs and component rows (`UseStore` with `ComponentAndLookups` rows). | Medium |
| Packages | Logic, then Kelly-Revit-UI (re-pin), then Kelly-Revit; Kelly-Domain only if the definition-set members or names change. | Usual pack and re-pin |

### Outside the code

- **Data files and database:** `ExternalParameterDefinition` row Id 315 and its 837 `BuiltInCategoryBinding` rows (Revit 2021–2025; none for 2026). Retire them through the `db-deprecation` process in the VCS General schema, not by deleting them. Until then the add-in keeps binding the parameter to projects.
- **Existing projects:** the parameter and its values stay in every project that already has them; they just stop being updated. User-made schedules, view filters and view templates that use it keep working on stale values. They do not break, but they drift.
- **Families and templates:** content that sets JHK Product Range keeps it; nothing breaks, but the value is no longer read.
- **Major Version 4:** v4 is a separate code base (not checked out here); it keeps writing and reading the parameter until it is retired, so the data-file rows can't go while v4 is installed.

### Recommendation

Do it in two steps:

1. **Fabrication parts only (low risk, about 4–8 points):** delete the writer, read `ProductDataRange` for fabrication parts in `GetProductRange`, and move the Weld trigger to the built-in parameter. Families keep being read from JHK Product Range for now. This removes the copy that can drift (observations 3 and 4 for fabrication parts) and needs no content check.
2. **Families (after the component id check, about 8 points, split before starting):** move families to the component lookup, rewrite the category, view and schedule filters, then deprecate the data-file rows once v4 no longer needs them.

## Observations

1. **The writer's doc remark is wrong for families.** [`GetJhkProductRange`](../../Kelly-Revit-Logic-v5/src/Parameters/ParameterValueExtensions.cs:58) says "on other elements the Component updater writes it from the data files", but no v5 code writes the parameter to a non-fabrication element. Families rely on their content; a family without the value reads as 0, so it is skipped as a module component, is not spoolable, and is not found by any category filter.
2. **Unused definition.** `SuspendedSupportDefinitionSet.JhkProductRange` is declared and resolved, but nothing reads it.
3. **Two sources for the weld test.** [`EndPreparationElementService.cs:83`](../../Kelly-Revit-Logic-v5/src/Updaters/ElementServices/EndPreparationElementService.cs:83) tests the neighbour's `ProductDataRange` directly, not JHK Product Range; every other weld test reads the parameter. The two agree only after the Fabrication Part Data updater has run.
4. **Text, not integer.** Filters compare strings ("10", "0", …), while readers parse to `int`. A value such as "06" or " 6" passes the readers but not the filters.
5. **Shared numbers in the enum.** `ComponentCategoryType` gives 9 two names (DuctAccessory, Accessory) and 96 two names (Temporary, NonExport).
