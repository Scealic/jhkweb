# Stored procedure review: VCS and VCS Content

2026-11-24. A read-only review of all 41 stored procedures in `VCS-Database-General-Schema` (27) and `VCS-Database-Content-Schema` (14), on `develop`. It reads the procedure files against the tables, indexes and callers in the checkout. Nothing was edited, published or run against a database. It does not cover execution plans, row counts, permissions, SQL Agent jobs, or code in the v4 repositories, which are not checked out.

## Summary

- **The Content database has the only real performance problem.** The `Component` trigger runs three procedures (`VCS_Update_Component_Set*`), and each one rewrites every row of `dbo.Component` on every save. That costs about 3 × N row writes per saved row. Every rewrite also fires `Tr_Component_UpdatedBy`, which stamps every row's `UpdatedBy` and `UpdatedUtc` with the current editor. Your commit 90783c9 (2026-11-13) made the recalculation table-wide on purpose and reversed e3ab418 (KWDSS-10, saved rows only). The options are under "Decisions" below.
- **The other procedures still in use are full reads of small reference tables** called by `Kelly-Revit-Data-Exporter` (`src/Catalog/ExportCatalog.cs`). Indexes hardly matter there. The one worthwhile change is the non-persisted `FORMAT` column `Product.FabricationIdCalc`, plus a scan in the `ItemCustomData` pivot.
- **About two thirds of the procedures have no caller in the checkout.** Twenty of them already carry the `Deprecated` property, due for removal on 2027-01-01. Dropping the dead ones does more than tuning them.
- **There are several correctness bugs** in General procedures that are no longer called. See "Bugs".

## Content database (`VCS-Database-Content-Schema/Project`)

### High

| Procedure | Problem | Change |
|---|---|---|
| `dbo.VCS_Update_Component_SetFilePathAndName`, `…SetLongDescription`, `…SetShortDescription` (trigger `Trig_Component_SetDerivedFieldsOnInsertAndUpdate`, `dbo/Tables/Component.sql`) | The `UPDATE dbo.Component` has no `WHERE`, so every save recalculates and rewrites all rows. Three passes run with 5 to 27 joins each. Each pass fires `Tr_Component_UpdatedBy` for every row, which wipes the audit columns. A string too long for `FilePath`/`FileName` (`NVARCHAR(200)`), `LongDescription` (255) or `ShortDescription` (100) on any row rolls back the user's save. | See "Decisions". The cheapest fix that keeps the table-wide behaviour is to add `WHERE` *new value* `<>` *current value* to each `UPDATE`, so unchanged rows are not written and `Tr_Component_UpdatedBy` does not fire for them. Next, merge the three procedures into one pass over `Component` and its lookups. |
| `Fabrication.USP_ItemCustomDataPivotedOnComponentIdView_SelectAll_v20260112` (exporter) | The only index, `Idx_FilePathAndIndex`, leads with `ItemPath`. `[Index] = 105` and `[Index] >= 100` scan the table twice and then sort. | Index `Fabrication.ItemCustomData ([Index]) INCLUDE (ItemPath, Value)`. |

### Medium

- **`dbo.Product.FabricationIdCalc`** is computed with `FORMAT(…,'D3')` and is not persisted. `USP_Table_Product_ReadAll` and `USP_CustomDataUpdater_SelectAll_v20260811` (both used by the exporter) evaluate it per row, and the second also sorts on it. Rewrite it with `RIGHT('000' + CONVERT(varchar(4), ProductIndex), 3)`, using a `CASE` for values above 999, and make it `PERSISTED`.
- **`USP_CustomDataUpdater_SelectAll_v20260811`:** `CONVERT(varchar(max), …)` on `NVARCHAR` columns inside three `STRING_AGG` blocks forces large-object handling and drops characters outside the server code page. Aggregate the `NVARCHAR` columns as they are. Also delete the commented-out column list in lines 18-61.
- **`VCS_Update_Component_SetLongDescription`:** its two `CASE` branches are identical apart from the Alpha and Bravo modifiers, and six of its joins are never used. Merge the branches and remove those joins.
- **`ItemCustomData` pivot:** four leading-wildcard `NOT LIKE '%…%'` predicates with an explicit `COLLATE`. `MAX(…)` silently collapses duplicate index-105 rows for a path.
- **`USP_View_MaterialAndLookups_ReadWhereEquals`** (deprecated): its `LEFT JOIN` acts as an inner join, and with no configuration parameter it can return several rows.
- **`USP_Table_Gauge_ReadWhereEquals`:** no index matches its `WHERE`. No caller; deprecate it rather than index it.

### Low

- 13 of 14 procedures lack `SET NOCOUNT ON`.
- Redundant `CAST(… AS INT)` on `INT` columns, and `IsProjectSpecific = '1'` compares a `BIT` column to a string.
- `\\vcdetailing\…` UNC paths are hard-coded in `SetFilePathAndName`.
- The `TRY/CATCH` in `USP_View_ComponentAndLookups_ReadAll` only rethrows.

### No caller in the checkout

Deprecated (drop on 2027-01-01): `USP_View_ComponentAndLookups_ReadAll`, `USP_View_MaterialAndLookups_ReadWhereEquals`, `USP_SizeSymbol_SelectWhereTradeIdEqualsParameter_v20240716`, `USP_ConnectorMapping_SelectWhereIdEqualsParameter_v20240716`, `USP_Table_ConnectorGrouping_ReadWhereIdEqualsParameter`, `Fabrication.USP_Configuration_SelectWhereGuidEquals`.

Not marked deprecated yet: `USP_Table_Gauge_ReadWhereEquals`, `USP_CategoryType_SelectAll_v20250221`.

## General database (`VCS-Database-General-Schema/project`)

The exporter uses five procedures: `USP_ExternalParameterDefinition_SelectAll_v20261117`, `USP_Table_ProductRange_ReadAll`, `USP_ServiceData_SelectAll_v20241010`, `core.USP_System_SelectAll_v20241010` and `USP_Terminology_SelectAll`. All five are full reads of small tables and need only `SET NOCOUNT ON`. In `USP_Terminology_SelectAll`, also replace `SELECT *` with the column list that `TerminologyRecord` expects, so a new column cannot change the export's shape.

### Medium

- **`core.USP_System_SelectWhereSignatureEquals`:** `@Signature = CONCAT(Name, ' ', Abbreviation)` cannot use an index, so every call scans. The match is also ambiguous: `"A B" + "C"` and `"A" + "B C"` give the same signature. It is not deprecated, and the usage report lists v4 `Kelly-Revit` as a caller. Seek on `Name` and `Abbreviation` separately.
- **`USP_ConnectorPreparation_Select`:** its `LEFT JOIN`s act as inner joins. No index serves `(GroupId, Name)` on `dbo.Connector`.
- **`USP_EndPreparationsWelded_Select`:** `Terminology` and `Linker_WeldLocationToEndPreparationWelded` have no index for its joins and filters.
- **`USP_Table_ProductRangeParameterDefaults_ReadWhereProductRangeIdEqualsId`:** the table is a heap with no index on `ProductRangeId`.
- **`USP_ExternalParameterDefinition_SelectAll_v20240113`** duplicates `_v20261117` without `IsAssignerContext` and is not marked deprecated.
- **`usp_ExportTablesToJson`:** with `@TableList = NULL` it exports every user table, `User` and session tables included, into one string. Its dynamic SQL is safe (`QUOTENAME`, `sp_executesql`). Consider an allow-list.

### Redundant indexes (write cost only)

- `LinkerExternalParameterDefinitionsToCategories.IX_Link_SPId` duplicates `UK_Linker`.
- `Project.Idx_Project_FileStoreAndFilePath` duplicates `UC_Projects_FileStoreAndFilePath`.
- `ProjectSession.IX_ProjectSession_ApplicationSessionId` is covered by a `_dta_index_` index.
- `ApplicationSession._dta_index_…K1_2` repeats the clustered key.

### Low

- Only `usp_ExportTablesToJson` sets `SET NOCOUNT ON`.
- Six insert procedures carry an unused `@Id` parameter.
- Several procedures use unqualified table names.
- A stray Copilot URL follows `END` in `USP_ProjectToSystem_SelectWhereNumberAndConfigurationEquals`.

## Bugs found along the way

1. `USP_Project_UpdateWhereIdEquals.sql:24-26` defaults the three rules-of-credit values to 31/41/31 (sum 103), while `USP_Project_Insert_v20241205.sql:23-25` uses 30/40/30.
2. Both `USP_Table_ApplicationSession_UpdateWhereIdEqualsParameter` versions take 18 parameters but write only `TimeStop` and `TimeElapsedMinutes`.
3. Parameters are wider than their columns. `USP_Table_ProjectMetricsLog_Insert` has `@Name` 255 → 100, `@Unit` 255 → 20 and `@Value DECIMAL(15,10)` → `(13,5)`. The `ApplicationSession_CreateOne` procedures have `@Name` 255 → 100.
4. `Development.USP_CodeTimer_Insert_v20241112` defaults `@UserName` to `NULL` but writes it into a `NOT NULL` column, so the column default `'-'` is never used.
5. `USP_BuiltInCategory_SelectWhereDefinitionIdAndRevitVersionEquals` takes `@RevitVersion NVARCHAR(100)` for an `INT` column.
6. `USP_Table_ApplicationSession_CreateOne_20261014` writes `ApplicationVersion*` parameters into `RevitVersion*` columns. The names disagree.
7. Defaults written as `"-"` in double quotes (the `Project` and `ApplicationSession` procedures) deploy because T-SQL accepts a bare word as a parameter default. Write them as `'-'`.
8. Content `VCS_Update_Component_SetFilePathAndName`: the trade `CASE` covers only trades 2 and 4 and has no `ELSE`, so any other trade sets `FilePath` to `NULL`.
9. Content `Changelog.md` still describes `ComponentIdList` and `@ComponentIds` as "Not yet published", but 90783c9 removed both.

## Decisions for the maintainer

1. **Component derived fields.** Choose one:
   - (a) Keep table-wide recalculation, but write only changed rows. This needs the least change and keeps the audit columns meaningful.
   - (b) Go back to recalculating only the saved rows (e3ab418). This is the cheapest at run time, but it gives up whatever 90783c9 was meant to fix (stale derived values after a lookup table changes).
   - (c) Option (b), plus a separate recalculation run when the lookup tables change.

   The Fabrication-Tools tests (`RealTriggerSaveTests`) install these procedures and the trigger, so any change must keep them passing.
2. **Drop the deprecated procedures early.** Twenty already carry the 2027-01-01 date. Drop sooner, or wait for that date?
3. **Rules-of-credit defaults.** Should `USP_Project_UpdateWhereIdEquals` use 30/40/30?

## Suggested order

1. Content: the changed-rows filter on the three `VCS_Update_Component_Set*` procedures (decision 1).
2. Content: the `ItemCustomData ([Index])` index and the persisted `FabricationIdCalc`.
3. Both: `SET NOCOUNT ON` on every procedure that stays, and an explicit column list in `USP_Terminology_SelectAll`.
4. General: drop the redundant indexes; fix the `USP_System_SelectWhereSignatureEquals` seek if v4 still calls it.
5. Both: drop the deprecated procedures and fix or drop the bugged ones.
