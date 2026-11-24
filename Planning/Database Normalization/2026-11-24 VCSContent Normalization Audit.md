# VCSContent normalization audit (2026-11-24)

Read-only audit of the VCSContent database against the `database-normalize` skill: first, second and third normal form, natural keys and column types. **Nothing was changed.** The audit ran on the development copy `VCS Content Dev` on `(localdb)\MSSQLLocalDB`, which is refreshed from production, over the schemas `dbo`, `Estimating`, `Fabrication` and `Material`.

The audit script gave 217 candidates (42 list values, 5 second normal form, 41 third normal form within a table, 96 third normal form through a foreign key, 33 natural key, 0 type). Each one was then checked against the data. Most of them are coincidences, explained under "Dismissed". The findings below are what remains, together with gaps found by hand in the three tables too large for the pairwise checks (`Product`, `Estimating.Data`, `Fabrication.ItemCustomData`).

The plan that carries these findings out is [2026-11-24 VCSContent Normalization Plan.md](2026-11-24%20VCSContent%20Normalization%20Plan.md).

"Schema review" means `VCS-Database-Content-Schema/Code Review/SQL Server 2019 Schema Review_2026.05.08.md`, which already records some of these from the schema alone. This audit adds the row counts.

## 1. Facts stored twice

| # | Table | Columns | Rows affected | Proposed fix | Schema review |
|---|---|---|---|---|---|
| 1.1 | `dbo.HarrisonCodes` | `HarrisonPublishingHouseCode`, keyed by the product code text | 34,427 rows: 27,310 agree with `Product.HPHCode`, **2,505 conflict**, 3,072 exist only here, 86 name no product | Keep the code on `Product.HPHCode` (the row it describes). Settle the 2,505 conflicts, copy the 3,072 missing codes across, archive the table and retire it. No procedure, view or application code reads it. | Orphan table, no foreign key |
| 1.2 | `Estimating.ProductCodeLinkToData` | `[Product Code]` → `[Source]`, `[Source ID]` | 78,698 rows: 75,975 agree with `Product.EstimatingDataId`, **2,673 disagree**, 50 name no product, one product code on 9 rows | `Product.EstimatingDataId` (which has a foreign key) is the one link. Settle the 2,673, point the view `Estimating.[Labor Product List]` at `Product`, archive and retire the table. | S-04: no key, no constraints |
| 1.3 | `dbo.ProductIdMcaaId` | `McaaId`, keyed by the product code text | 34,426 rows, 32,382 of them `0` (meaning "none"), 709 real values, 14 product codes repeated | A nullable `McaaId` on `Product` (`0` becomes `NULL`), or retire the table if the MCAA id is no longer wanted. Nothing reads it. | Orphan table |
| 1.4 | `dbo.Component` | `CategoryId` vs `SubCategory.CategoryId` | 60 rows disagree (out of 4,272 with a real subcategory) | Correct the 60 rows, then a composite foreign key (`CategoryId`, `SubCategoryId`) → `SubCategory` (`CategoryId`, `Id`) so the two can't disagree again. The "-" placeholder rows (see 3.2) stop this working until each category has its own "-" row or the column takes `NULL`. | – |
| 1.5 | `dbo.Component` | `MaterialCodeId` vs `MaterialSpecification.MaterialCodeId` | 61 of 6,064 disagree | As 1.4: correct the rows, then a composite foreign key. | – |
| 1.6 | `dbo.Component` | `BusinessId` vs `BusinessModel.BusinessId` | 68 of 4,970 disagree | As 1.4. | – |
| 1.7 | `dbo.Component` | `TradeId` vs `MainSchedule.TradeId` | 325, all on the `[AlternateLookup]` schedule, which belongs to an `[AlternateLookup]` trade, used by sheet metal components | Decide whether `[AlternateLookup]` is a real schedule; if it is a marker, treat it like "-" (see 3.2). `MainClass` and `ConnectionType` agree with `TradeId` on every row. | – |
| 1.8 | `dbo.Component` | `FilePath`, `FileName`, `ShortDescription`, `LongDescription` | all 10,262 rows | These are built from the code columns by `VCS_Update_Component_SetFilePathAndName`, `…SetShortDescription` and `…SetLongDescription`, so they are derived values stored. Either compute them in a view, or keep them as a deliberate copy (the exporter reads them) with a `vQual_` view that lists the rows where the stored value differs from a fresh build. Explains all 10 `FileName`/`LongDescription` "decides" hits. | – |
| 1.9 | `dbo.LinkerCategoryTypeAndCategory` | `Name_Redundant` = `Category.Name` | 34 of 473 already differ (for example "Connecotr") | Drop it; a view joins `Category.Name`. | Name_Redundant |
| 1.10 | `dbo.BusinessModel` | `ManufacturerNameRedundant` = `Business.Name` | 31 of 3,794 differ | Drop it; a view joins `Business.Name`. | – |
| 1.11 | `dbo.Product` | `InstallationUnitRate`, `FabricationUnitRate` | `0` on all 178,921 rows; the rates live in `Estimating.Data` through `EstimatingDataId` | Drop both after checking `USP_Table_Product_ReadAll` and its callers. | – |

## 2. Missing natural keys

### Ready for a unique constraint (no duplicates in the data)

| Table | Natural key |
|---|---|
| `dbo.BusinessType` | `Name` |
| `dbo.FabricationPattern` | `Pattern` (its extended property calls it "the Primary Key - Driven By Autodesk"; schema review agrees) |
| `dbo.FabricationPatternOptionType` | `FabricationPatternId`, `Index` |
| `dbo.FileType` | `Name` |
| `dbo.LinkerBusinessAndBusinessType` | `BusinessId`, `BusinessTypeId` (schema review) |
| `dbo.MaterialGroup` | `Name` |
| `dbo.ReducingClass`, `dbo.ReducingSchedule` | `TradeId`, `Name` |
| `dbo.ReducingClassModifier` | `ReducingClassId`, `Name` |
| `dbo.TagPrefix`, `dbo.Trade`, `dbo.UnitOfMeasure`, `dbo.WeldType`, `Material.ShopGroup` | `Name` |
| `Fabrication.Specification` | `SpecificationGroupId`, `Name` |
| `Fabrication.SpecificationGroup` | `ConfigurationId`, `Name` |
| `Fabrication.ItemCustomData` | `ItemPath`, `Index`: the existing unique index also holds `Value`, which lets one item and index hold two values. No such pairs today, so `Value` can leave the key (schema review). |

### Duplicates to settle first

| Table | Natural key | Duplicate groups | Notes |
|---|---|---|---|
| `dbo.Component` | the item file (`FilePath`, `FileName`) | 51 groups, 1,770 rows | 1,566 rows are `Ancillaries.itm` (only one has a product); 80 are `.-` with no path; 50 groups are identical in every column. Decide what identifies a component before choosing the key: placeholder rows probably go to an archive. |
| `dbo.SubCategory` | `CategoryId`, `Name` | 5 | Both rows of a pair are in use (for example "90" under one category: 389 and 74 components). Merge by repointing `Component.SubCategoryId`. |
| `dbo.SubCategoryModifierAlpha` | `Name` (its `ForeignKeyId` is `NULL` on 549 of 550 rows) | 17 | Usually one row of a pair is unused (for example "ACR": 59 and 0 components). Depends on what `ForeignKeyId` should be (schema review). |
| `dbo.SubCategoryModifierBravo` | `ForeignKeyId`, `Name` | 4 | As above. |
| `dbo.BusinessModel` | `BusinessId`, `Name` | 22 | Most differ only by spaces: 20 names have leading or trailing spaces. Trim, then merge. |
| `dbo.MaterialSpecification` | `MaterialCodeId`, `Name` | 4 (7 by `Name` alone) | Read each pair, for example "A48" twice under the same code. |
| `dbo.MaterialType` | `Name` | 3 | |
| `dbo.LinkerCategoryTypeAndCategory` | `TradeId`, `CategoryTypeId`, `CategoryId` | 2 | The key needs `TradeId`: without it there are 21 groups, which are the same pair for piping and sheet metal. |
| `dbo.LinkerMainClassAndMainClassModifier`, `dbo.LinkerMaterialSpecificationAndMaterialGrade`, `dbo.LinkerMaterialSpecificationAndMaterialType` | the two foreign keys | 1 each | Exact duplicate rows: delete one. |
| `dbo.MaterialCode`, `dbo.Finish` | `Name` | 1 each | |
| `dbo.HarrisonCodes`, `dbo.ProductIdMcaaId`, `Estimating.ProductCodeLinkToData` | product code | 14, 14, 1 | Settled by retiring them (1.1 to 1.3). |
| `dbo.ComponentExternal` | – | 201 identical groups | Not worth keying: see 4.1. |

## 3. Placeholder values and unused columns

| # | What | Where | Proposed fix |
|---|---|---|---|
| 3.1 | Text columns that are "-" or empty on every row | `NameAbbreviation` on `CatalogGroup`, `FileNameModifier`, `MainClass`, `ReducingClass`, `ReducingClassModifier`, `SubCategory`, `SubCategoryModifierAlpha`, `SubCategoryModifierBravo`, `SupportType`; `Notes` on `ComponentSupportType`, `ComponentWeldType`, `SizeSymbol`, `Estimating.Data`, `Fabrication.Configuration`, `Fabrication.Material`, `Fabrication.MaterialGroup`, `Fabrication.SpecificationGroup`, `Material.ShopGroup`; `Description` on `ComponentTag`, `SizeSymbol`; `CatalogGroup.PDFURL`; `MaterialType.CommonName`; `Product.PartCode`; `Material.Configuration.Name` | Drop the ones nothing reads; make the rest nullable with `NULL` for "none". These columns account for about 20 of the "repeats through a foreign key" hits ("-" equals "-"). |
| 3.2 | "-" placeholder rows standing for "none" | Every lookup that `Component` points to (Id 1 in most); the "-" rows hang under the "-" parent, so they belong to no real category, business or code | **Decision for you:** keep the placeholder rows (they exist because the `Component` foreign key columns are `NOT NULL`) or make those columns nullable. While the placeholders stay, natural keys need one "-" per parent or must leave "-" out (a filtered unique index), and the composite foreign keys in 1.4 to 1.6 can't be added. |
| 3.3 | Foreign key columns with one value | `Component.MaterialGroupId` and `Component.MaterialConfigurationId` are 1 on every row; `Category.CategoryTypeId` is 1 on 436 of 440 (the real link is `LinkerCategoryTypeAndCategory`); `SubCategoryModifierAlpha.ForeignKeyId` is `NULL` on 549 of 550 | Drop, or fill if they are meant to be used. `Material.Configuration` holds the code, grade, specification and type combinations that `Component` also stores one by one; if `MaterialConfigurationId` is meant to replace those four columns, that is a larger design change. |

## 4. Other

| # | Table | Finding | Proposed fix |
|---|---|---|---|
| 4.1 | `dbo.ComponentExternal` | 71,124 rows, 64,472 of them "No Category Found"; no foreign keys; nothing in the schema project, the exporter, Fabrication Tools or the v5 add-in reads it. A flat import of Revit model elements. | Archive and retire rather than normalize. |
| 4.2 | `dbo.Product` | `ManufacturerCode` contains the size: 54,353 end with " - " followed by `Size` | Allowed: it is the product name as written in the product list. A `vQual_` view could list the rows where the name and `Size` disagree. |
| 4.3 | `dbo.Product` | `Size` packs two sizes ("4''x1-1/2''") | Leave it whole. It is the trade notation and the Fabrication Tools size work writes it as written. |
| 4.4 | `Estimating.Data` | `SourcePath` packs attributes ("fittings\|CS\|BW\|XXH") | Allowed: source text from MCAA as written. Parse it into columns only if a query needs them. |
| 4.5 | `Fabrication.Material` | `Name` decides `MaterialGradeId` within the key (`Name`, `MaterialGroupId`): 18 names | Possible second normal form issue, low priority: the table mirrors the Fabrication configuration, where each material group lists its materials. Leave unless the grade should be set once per material name. |

## Dismissed (coincidence or allowed)

- **96 "through a foreign key" hits:** about 70 compare `Component` Id columns that are 1 on (almost) every row with unrelated Id columns that are also mostly 1. About 20 are "-" placeholder text. 14 are `UpdatedBy`, which holds the same person because one person loaded both tables. What remains is 1.5, 1.10 and the `Fabrication.Material` text columns, which are all "-".
- **41 "decides within a table" hits:** 10 explained by 1.8; 15 inside `ComponentExternal` (4.1); `UpdatedUtc` → `UpdatedBy` and `Name` → `UpdatedBy` (one load, one person); `Gauge`, `MaterialType` and `SubCategoryModifierBravo` hits on tables of under 300 rows; `[Source ID]` → `Source` (the two sources' ids don't overlap); `JhkProductCode` → `McaaId` (covered by 1.3).
- **5 second normal form hits:** `ComponentSupportType` `UpdatedUtc` and `MainSchedule` `UpdatedBy` (one load); `MainSchedule` `Name` → `NameAbbreviation` (the same schedule has the same abbreviation in both trades; allowed per-trade lists); `Gauge` `Notes` (small table, mostly empty). `Fabrication.Material` is 4.5.
- **42 list hits:** fractions and paths with "/" (`Product.Size`, `ManufacturerCode`, `Estimating.Data.Size`, `ItemCustomData.ItemPath`, `Component.FullPathDeprecated`), "n/a" (`ComponentExternal`), and descriptions or notes written as prose. None is a list of separate facts.
- **Type:** no text column holds only dates or only numbers.

## Suggested order

1. Retire the three tables that duplicate `Product` (1.1 to 1.3) and `ComponentExternal` (4.1), after settling the conflicts: the largest gain, and nothing reads them except one view.
2. Add the unique constraints that need no clean-up (section 2, first table).
3. Decide 3.2 (placeholder rows or nullable foreign keys); it decides how 1.4 to 1.7 and the remaining natural keys are done.
4. Merge the duplicate lookup rows and drop the redundant and unused columns (1.9 to 1.11, 3.1, 3.3).
5. Decide 1.8: compute the `Component` file names and descriptions, or keep them with a check.

Each change goes through the schema project (`develop`, build, Schema Compare, publish to the development database), with an archive of removed rows and a before-and-after fingerprint of every view, as the skill sets out.
