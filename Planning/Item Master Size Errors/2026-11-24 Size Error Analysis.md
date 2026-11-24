# Item Master size errors: analysis of `ALL_VL_Cod_Source_From_ITM_Cleaned.csv`

Date: 2026-11-24. Source: `Item Masters\_Support\FAB Stuff\ALL_VL_Cod_Source_From_ITM_Cleaned.csv` (148,754 rows, 6,790 ITM files, all under `jhk master database 2025 (wip)/items/Piping`).

Every flagged row is in `2026-11-24 Size Errors - Rows.csv` (severity, issue, detail, a suggested product name where one can be derived, and the original columns). `2026-11-24 Size Errors - Items.csv` counts the issues per ITM file, worst first.

## How the columns were read

| Column | Meaning used |
|---|---|
| `SQLProductName` | Size from the SQL database |
| `ITMProductName` | Size from the ITM file (empty on 5,945 rows; then SQL is the source) |
| `ProductName` | The cleaned size, the column being checked |
| `ProductOrder` | Vendor order text; when it ends in ` - <size>` that size is used as a third opinion |

The check compares the inch values (`1-1/4''`, `1 1/4''`, `1.25''` all read as 1.25) of `ProductName` with the source (ITM, else SQL), in order or reordered (`3/4''on1/2''` and `1/2''on3/4''` count as the same; the cleaned olet names consistently put the branch first, which is correct).

## Summary

| Severity | Issue | Rows | ITM files |
|---|---|---:|---:|
| Error | Cleaned size does not match source | 2,430 | 154 |
| Error | Duplicate cleaned size within item, source sizes differ (size lost) | 1,732 | 68 |
| Error | Duplicate marker `(2)` left in the size | 28 | 6 |
| Error | Bolt diameter `0''` | 21 | 1 |
| Review | Duplicate cleaned size within item, source differs only by model or part number | 1,264 | 127 |
| Review | Cleaned size differs from a source name that is itself duplicated | 448 | 13 |
| Review | Source disagrees, but product order agrees with the cleaned size | 97 | 25 |
| Review | Odd values (`3/5''`, `3/20''`, `11/4''`, `100'`) | 7 | 7 |
| Format | Mixed fraction with a space (`1 1/4''` for `1-1/4''`) | 947 | 370 |
| Format | Decimal where the source has a fraction (`0.5''` for `1/2''`) | 33 | 8 |
| Format | `x''` separator, `2 -1/2''`, uppercase `X` | 6 | 3 |

5,509 rows flagged in all; 2,747 rows in 168 ITM files have at least one Error.

## Errors

### 1. Rows mismatched: the cleaned size belongs to another row

The cleaned list is in a different order from the item's rows, so each row carries another row's size.

- `Generic/Fittings Carbon Steel/Nipple PE CS ASTM A106 GR B SMLS SCH 80.itm`: 209 rows. Index 160 is `1/8''xClose` in ITM, SQL and product order, but its cleaned size is `2-1/2''x11'' LNG`; index 51 `1-1/4''xClose` became `1/2''xCL`.
- All 12 `Generic/Bolts CS/* Class E*.itm` files (31 to 35 rows each): the SQL names restart at `4''` from index 10 while the ITM and product order go on to `20'' - (20) 1-1/8'' Dia`; the cleaned size followed SQL, so `4''` to `18''` appear twice and `20''` and up are missing.
- `Projects/Eagle/Carbon (BW)/Olet BW FS ASTM A105 STD WT TRANS-O-CON.itm` (12 rows).

Fix: take the size from the ITM name of the same index (the suggested column does this).

### 2. A size dropped from a two-size name

The cleaner kept only the last size, so reducers and tees lost their run size and many rows of an item collapse to one size.

- Nibco ACR copper, Sweat and Braze: Tee Reducing 9611 (180 rows each), Reducer 9600 (46), Reducer FTGxC 9600-2 (41), Adapter Female 9603 (32), Adapter Male 9604 (31), Bushing Flush 9618 (13), Elbow 90 9607 and 9607-LT (9). `1/4''ODx3/8''OD` became `3/8''`.
- Mueller Return Bend WE 512, Sweat and Braze (27 each): `3/8''OD x 1-1/2''` became `1-1/2''`.
- Georg Fischer Nipple 861 (68): `1/2''-2''` became `2''`; Expansion Joints 836 (9 each, six files): `1/2''-12''` became `12''`.
- HIS Nipple Half KF (38): `1-1/2''-1/2''` became `1/2''`.
- Relief valves (Kunkle 910 and 913, Apollo 500): `1/2''(MPT)x3/4''(FPT)` became `3/4''`.
- Georg Fischer Diaphragm Valve Type-519 (14), FNW bolt sets NBSS (14 each, the bolt count and diameter dropped), Ford meter coupling (22, the `2'' Long` dropped).
- Place holders: Zone Square to Round (256 of 288 rows: `6'' x (1'')` became `1''`) and Zone Tee Rect (35).
- Josam Push-Fit pipe (48): the length (`- 0.8ft`) dropped, so eight rows per size share one name.

### 3. A size misread from a broken source

- Georg Fischer CPVC Tee Reducing 9801 (24) and its bushings 9838 (9): source `1 .25  x1/2''` became `25''x1/2''`; `1''x 3?4` became `1''x3''` (should be `1-1/4''x1/2''` and `1''x3/4''`). The source names need fixing too.
- Asahi HP-PVC flanges (11 to 12 rows per file): `13mm (3/8'')` became `75mm`, `16mm (1/2'')` became `200mm`: the metric sizes are shifted rows.
- Asahi: the inch sizes are also dropped (`200mm (8'')` rows keep `8''`, the rest keep only millimetres).

### 4. Other errors

- `Generic/Bolts SS A320/Bolt Set STD SS ASTM A320 B8 Class 2 CL600.itm`: all 21 rows have `(4) 0'' Dia`, in SQL, ITM and the cleaned size.
- `(2)` and `(2) (2)` duplicate markers left in the cleaned size: Charlotte Bend Sixteenth PN_324 (8), Swagelok Flange Adapter FLxCMP, FLxSPG and FLxBW (6 each), Parker Nipple TBE, Nibco 604.

## For review

- **Stanchion caps** (`Cap BW CS ASTM A234 WPB ... for Stanchion.itm`, four files, 426 rows): the ITM name is `1''x1/2''` on every row of a size, while the cleaned names step through `1''x1/2''`, `1''x3/4''`, `1''x1''`. The cleaned names look right and the ITM names wrong, but confirm the second size is the hole size.
- **Same size, different model** (1,264 rows): AP Tech regulators, Blue-White and Hedland flow meters, Tescom valves, Swagelok check valves keep only the pipe size, so 4 to 48 rows of one item share a name. Fine if the name is only a size; a problem if it must be unique within the item.
- **Source wrong, cleaned size right** (97 rows): gaskets Blue-Gard 300 (SQL `5''`, `24''`, `44''` for `1/2''`, `3/4''`, `1''`), Union Orifice SP-83, pup pipes (cast iron, PVC, DWV copper), bronze check valves 507 and 1509. The cleaned size agrees with the product order; fix the ITM or SQL name.
- Odd values: `2-3/5''` (Elbow 90 LR 10GA), `2-1/2''x3/20''` (four reducers), `1-1/2''x11/4''` (Adapter Trap 903-7, likely `1-1/4''`), `8''x100'` (Mason V-Loop).

## Format only

Write mixed fractions with a hyphen (`1-1/4''`, 947 rows in 370 files, mostly Forged Stainless tees and Georg Fischer metric items), fractions rather than decimals where the source has a fraction (Swagelok VCR glands, Union SP-83), lowercase `x`, and no `x''` (Merit NL106 tees).
