# VCSContent normalization plan (2026-11-24)

The plan that carries out [2026-11-24 VCSContent Normalization Audit.md](2026-11-24%20VCSContent%20Normalization%20Audit.md) (the report). Finding numbers (1.1, 3.2, …) are the report's. **Nothing here has been done:** every schema or data change waits for the maintainer's go-ahead, phase by phase.

## Ground rules

- **Development copy only.** Every change is made in `VCS-Database-Content-Schema` on `develop`, built, compared with Schema Compare and published to `VCS Content Dev` on `(localdb)\MSSQLLocalDB`. The maintainer publishes to production through the develop→production pull request. No script runs against production from an agent.
- **No stored procedure is dropped** (KWDSS-1 on hold, decided 2026-11-24). A procedure whose output changes gets a new dated version (`_vYYYYMMDD`) beside the old one, as KWDSS-10 did, and its callers are pointed at the new one.
- **Copy before changing.** A new schema `Archive` holds every removed row and every replaced value (`Archive.<Table>_<yyyyMMdd>`, the original columns plus `ArchivedUtc` and `Reason`). A table that is retired is first copied there whole.
- **Prove nothing else changed.** Before each phase, fingerprint every view and every procedure the exporter calls (SHA-256 per row into a `#temp` table, as `sql-server.md` in the skill describes), and run Kelly-Revit-Data-Exporter against the development copy. After the phase, the fingerprints must match and the exported data files must be byte-identical, except where the phase changes them on purpose (then the plan names the columns that change).
- **Fabrication Tools writes `dbo.Product.Size` on production.** Changes to `dbo.Product` go to production only when the maintainer has backed it up (`Fabrication-Tools/scripts/backup-production-tables.sh`) and paused Product Size Updater.

## Who reads what

Searched in every repository under `C:\repo\jhkweb` (2026-11-24). Callers outside the checkout (the Major Version 4 add-in, Access front ends, `stratusapi`) can't be searched, so a retired table is watched before it is dropped (Phase 3).

| Object | Read by | Effect on the plan |
|---|---|---|
| `dbo.HarrisonCodes`, `dbo.ProductIdMcaaId` | nothing | Retire after the watch period. |
| `Estimating.ProductCodeLinkToData` | the view `Estimating.[Labor Product List]` only; nothing reads the view | Repoint the view at `Product.EstimatingDataId`, then retire. |
| `dbo.ComponentExternal` | nothing | Retire after the watch period. |
| `Product.InstallationUnitRate`, `FabricationUnitRate`, `PartCode` | `USP_Table_Product_ReadAll` → exporter `ProductRecord` → the Product data file → Kelly-Domain `Product` (`InstallationUnitRate` is mapped to the shared parameter "JHK CIPE"); also `vQual_Product_MissingEstimatingDataId` | **Data file contract.** Not a plain drop: see decision D3. |
| `Component.MaterialConfigurationId` | `vComponentAndLookups` → exporter and Kelly-Domain `ComponentAndLookupsViewRecord` | Data file contract: dropping it removes a column from the data file. |
| `Component.MaterialGroupId` | five views and `USP_View_MaterialAndLookups_ReadWhereEquals` | Keep until those are rewritten. |
| `Component.FilePath`, `FileName`, `ShortDescription`, `LongDescription` | written by the three `VCS_Update_Component_Set*` procedures from the `Component` trigger; read by the exporter | Decision D2; tied to KWDSS-10 and KWDSS-14. |
| `Category.CategoryTypeId` | `VCS_Update_Component_SetFilePathAndName`, `…SetLongDescription`, `USP_CustomDataUpdater_SelectAll_v20260811`, `vCategoryTypeLinkedToCategory` | Those procedures use it, so it is not unused (3.3): check what they expect before dropping. |
| `NameAbbreviation` columns | the same procedures, `USP_View_ComponentAndLookups_ReadAll`, `USP_View_MaterialAndLookups_ReadWhereEquals`, `USP_CategoryType_SelectAll_v20250221` | All "-", but read: make them nullable rather than drop, or drop with new dated procedure versions. |
| `LinkerCategoryTypeAndCategory.Name_Redundant`, `BusinessModel.ManufacturerNameRedundant` | nothing but their tables | Drop (Phase 4). |

## Decisions for the maintainer

| # | Question | Options | Blocks |
|---|---|---|---|
| D1 | "-" placeholder rows (3.2) | **a)** keep them and add one "-" row per parent, or a filtered unique index that leaves "-" out; **b)** make the `Component` foreign key columns nullable and move "-" to `NULL`, which changes every view and the exporter's records (`int` → `int?`) | Phases 5 and 7 |
| D2 | Derived `Component` fields (1.8) | **a)** compute them in a view and stop storing them, which also removes the trigger's three-times-every-row rewrite (KWDSS-10, KWDSS-14); **b)** keep them stored, with a `vQual_Component_StaleDerivedFields` view listing rows whose stored value differs from a fresh build | Phase 6 |
| D3 | `Product` rate columns, all 0 (1.11) | **a)** drop them and the data file columns ("JHK CIPE" stays empty, as it is today); **b)** a new `USP_Table_Product_ReadAll_v<date>` that reads the rates from `Estimating.Data` through `EstimatingDataId` (`WorkActivityMethodUnitRate`, `ComponentMethodUnitRate`), then drop the columns. Option b fills "JHK CIPE" in every model, which is a behaviour change for users | Phase 4 |
| D4 | MCAA id (1.3) | keep it as a nullable `Product.McaaId`, or let it go with the table | Phase 3 |
| D5 | Conflicting values (1.1: 2,505 HPH codes; 1.2: 2,673 estimating links) | which side is right: `Product` (likely, it is the maintained table), the old table, or row by row from a review sheet | Phase 3 |
| D6 | What identifies a component (2, `Component`) | the item file (`FilePath`, `FileName`), after the 1,566 `Ancillaries.itm` and 80 `.-` rows are archived, or another key | Phase 7 |
| D7 | `[AlternateLookup]` schedule (1.7) | a real schedule, or a marker treated like "-" | Phase 5 |

## Phases

Each phase is one Linear issue in KWDSS (estimate in points), built and checked on the development copy, then left for the maintainer's production publish. A phase that changes a data file also needs Kelly-Revit-Data-Exporter (KRDE) and Kelly-Domain (KD) issues, a package and repin, and a v5 rebuild.

### Phase 0: safety net (2 points)

1. Add the schema `Archive` to the project.
2. Add `Planning/Database Normalization/Scripts/Fingerprint views.sql` (read-only): one SHA-256 per row for every view and for the result of every procedure the exporter calls, saved into `#temp` tables, and a compare step.
3. Export the data files from the development copy into a dated folder as the baseline.

Done when the fingerprint script and the baseline export run clean on the unchanged development copy.

### Phase 1: unique constraints that need no clean-up (2 points)

The first table of the report's section 2: `BusinessType`, `FabricationPattern`, `FabricationPatternOptionType`, `FileType`, `LinkerBusinessAndBusinessType`, `MaterialGroup`, `ReducingClass`, `ReducingSchedule`, `ReducingClassModifier`, `TagPrefix`, `Trade`, `UnitOfMeasure`, `WeldType`, `Material.ShopGroup`, `Fabrication.Specification`, `Fabrication.SpecificationGroup`, and `Fabrication.ItemCustomData` (`ItemPath`, `Index`, replacing the index that also holds `Value`).

- Before each constraint: re-run the duplicate count on the development copy (the data moves daily).
- Check: publish succeeds; fingerprints unchanged; an insert of a duplicate fails.

### Phase 2: exact duplicates and trims (2 points)

- Delete one row of each exact duplicate in `LinkerMainClassAndMainClassModifier`, `LinkerMaterialSpecificationAndMaterialGrade`, `LinkerMaterialSpecificationAndMaterialType`, into `Archive` first; then their unique constraints.
- Trim the 20 `BusinessModel` names with leading or trailing spaces (compare with `DATALENGTH`), archive the old values.
- Check: fingerprints change only where a view shows the trimmed names; the diff lists exactly those rows.

### Phase 3: retire the tables that duplicate `Product` (4 points, after D4 and D5)

1. Write a review sheet (`.csv` in this folder) for the 2,505 HPH code conflicts and the 2,673 estimating link conflicts, both values side by side, for D5.
2. Apply D5 to `Product` (old values to `Archive`), copy the 3,072 HPH codes that exist only in `HarrisonCodes`, and add `Product.McaaId` if D4 keeps it (`0` → `NULL`).
3. Repoint `Estimating.[Labor Product List]` at `Product` (`Product.FabricationIdCalc` and `Product.EstimatingDataId`), keeping the view's name and columns; fingerprint it before and after (its row count changes by the 50 orphan and 9 repeated rows: list them).
4. Copy `HarrisonCodes`, `ProductIdMcaaId`, `ProductCodeLinkToData` and `ComponentExternal` whole into `Archive`, mark each `Deprecated` with an extended property, and start an Extended Events session that records any read of them (like the KWDSS-10 call logging scripts).
5. After a watch period the maintainer sets (four weeks suggested) with no reads, drop the four tables in the schema project.

### Phase 4: redundant and unused columns (4 points, after D3; data file part needs KRDE and KD issues)

- Drop `LinkerCategoryTypeAndCategory.Name_Redundant` and `BusinessModel.ManufacturerNameRedundant` (1.9, 1.10); nothing reads them.
- Merge the duplicate lookup rows of section 2 (`SubCategory` 5, `SubCategoryModifierAlpha` 17, `SubCategoryModifierBravo` 4, `BusinessModel` 22 after the trim, `MaterialSpecification` 4, `MaterialType` 3, `MaterialCode` 1, `Finish` 1, `LinkerCategoryTypeAndCategory` 2): repoint `Component` to the kept row, archive the other, add the unique constraint. One review sheet first, since some pairs may be distinct facts that need one more key column.
- D3: the `Product` rate columns and `PartCode`. This is a data file contract change: a new dated `USP_Table_Product_ReadAll` version, the exporter catalog pointed at it, `ProductRecord` changed in the exporter and Kelly-Domain, Kelly-Domain packed and repinned up to Kelly-Revit-v5.
- 3.1 placeholder text columns: make nullable with `NULL` for "none" where a procedure reads them; drop those nothing reads. 3.3: `Component.MaterialGroupId` and `MaterialConfigurationId` stay until the views (and, for `MaterialConfigurationId`, the data file) no longer use them; `Category.CategoryTypeId` stays (the procedures use it).

### Phase 5: composite foreign keys (2 points, after D1 and D7)

1. Correct the 60 `CategoryId`, 61 `MaterialCodeId` and 68 `BusinessId` rows on `Component` (review sheet first; old values to `Archive`), and the 325 `[AlternateLookup]` rows per D7.
2. Unique indexes on `SubCategory (Id, CategoryId)`, `MaterialSpecification (Id, MaterialCodeId)`, `BusinessModel (Id, BusinessId)`, `MainSchedule (Id, TradeId)`.
3. Composite foreign keys from `Component` to each.
- Check: inserting a disagreeing pair fails; fingerprints change only on the corrected rows.

### Phase 6: derived `Component` fields (4 points, after D2; with KWDSS-10 and KWDSS-14)

- D2 a: a view that builds `FilePath`, `FileName`, `ShortDescription` and `LongDescription` from the code columns; prove on every row that it gives the stored value (binary comparison) and list the rows it doesn't (they are the stale ones, including KWDSS-18's `NULL` paths); point the exporter's view at it; stop the trigger calling the three procedures (they stay, marked deprecated); drop the stored columns last.
- D2 b: add `vQual_Component_StaleDerivedFields` and keep the procedures, with KWDSS-10's changed-rows filter.

### Phase 7: `Component` natural key (4 points, after D1 and D6)

Archive the placeholder and identical rows (1,566 `Ancillaries.itm`, 80 `.-`, the 50 identical groups) after checking that no `Product`, `ComponentSupportType`, `ComponentTag` or `ComponentWeldType` row points at them, then add the unique constraint D6 chooses.

## Order and dependencies

```
Phase 0 ─┬─ Phase 1
         ├─ Phase 2 ── Phase 4 (lookup merges)
         ├─ Phase 3 (D4, D5, watch period)
         ├─ Phase 4 (D3, data file change: KRDE, KD, repin)
         ├─ Phase 5 (D1, D7) ── Phase 7 (D6)
         └─ Phase 6 (D2, with KWDSS-10, KWDSS-14)
```

Phases 1, 2 and 3 need no design decision beyond D4 and D5 and give most of the gain. Phases 5 to 7 wait on D1, the one decision that shapes the rest.

## Linear issues

Filed 2026-11-24 under the parent KWDSS-29 (Backlog, Low, assigned to the maintainer). Phase 0 waits on KWDSS-28 (the Content project's build errors); every other phase waits on Phase 0.

| Phase | Issue | Points | Waits on |
|---|---|---|---|
| 0 Safety net | KWDSS-30 | 2 | KWDSS-28 |
| 1 Unique constraints | KWDSS-31 | 2 | KWDSS-30 |
| 2 Exact duplicates and trims | KWDSS-32 | 2 | KWDSS-30 |
| 3 Retire the duplicate tables | KWDSS-33 | 4 | KWDSS-30, D4, D5 |
| 4a Redundant columns, lookup merges | KWDSS-34 | 4 | KWDSS-30, KWDSS-32 |
| 4b `Product` rate columns | KWDSS-35 | 2 | KWDSS-30, D3 |
| 4b exporter `ProductRecord` | KRDE-15 | 1 | KWDSS-35 |
| 4b Kelly-Domain `ProductRecord`, `Product` | KD-114 | 1 | KWDSS-35 |
| 5 Composite foreign keys | KWDSS-36 | 2 | KWDSS-30, D1, D7 |
| 6 Derived `Component` fields | KWDSS-37 | 4 | KWDSS-30, D2 (related to KWDSS-10, KWDSS-14, KWDSS-18) |
| 7 `Component` natural key | KWDSS-38 | 4 | KWDSS-30, KWDSS-36, D1, D6 |

## Next steps

1. The maintainer answers D1 to D7 (or the ones for the first phases), recorded on the phase issues.
2. Fix KWDSS-28, then start with Phase 0 (KWDSS-30).
