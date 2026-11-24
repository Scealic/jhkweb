# Item Master size errors: analysis of `ALL_VL_Cod_Source_From_ITM_Cleaned.csv`

Date: 2026-11-24. Source: `Item Masters\_Support\FAB Stuff\ALL_VL_Cod_Source_From_ITM_Cleaned.csv` (148,754 rows, 6,790 ITM files, all under `jhk master database 2025 (wip)/items/Piping`).

Every flagged row is in `2026-11-24 Size Errors - Rows.csv` (severity, issue, detail, a suggested product name where one can be derived, and the original columns). `2026-11-24 Size Errors - Items.csv` counts the issues per ITM file, worst first.

## How the columns were read

| Column | Meaning used |
|---|---|
| `SQLProductName` | Ignored |
| `ITMProductName` | Size from the ITM file, the source the cleaned size is checked against |
| `ProductName` | The cleaned size, the column being checked |
| `ProductOrder` | Vendor order text; when it ends in ` - <size>` that size is used as a second opinion |

The check compares the inch values (`1-1/4''`, `1 1/4''`, `1.25''` all read as 1.25) of `ProductName` with `ITMProductName`, in order or reordered (`1''x1/2''` and `1/2''on1''` count as the same; the cleaned olet names consistently put the branch first, which is correct).

5,945 rows have no `ITMProductName`. They get only the format and duplicate checks, not the source check.

## Summary

| Severity | Issue | Rows | ITM files |
|---|---|---:|---:|
| Error | Cleaned size does not match the ITM name | 2,423 | 150 |
| Error | Duplicate cleaned size within item, ITM sizes differ (size lost) | 1,736 | 69 |
| Error | Duplicate marker `(2)` left in the size | 28 | 6 |
| Error | Bolt diameter `0''` | 21 | 1 |
| Review | Duplicate cleaned size within item, ITM names differ only by model or part number | 1,260 | 126 |
| Review | Cleaned size differs from an ITM name that is itself duplicated | 448 | 13 |
| Review | ITM name disagrees, but product order agrees with the cleaned size | 39 | 13 |
| Review | Odd values (`3/5''`, `3/20''`, `11/4''`, `100'`) | 7 | 7 |
| Format | Mixed fraction with a space (`1 1/4''` for `1-1/4''`) | 947 | 370 |
| Format | Decimal where the ITM name has a fraction (`0.5''` for `1/2''`) | 25 | 6 |
| Format | `x''` separator, `2 -1/2''`, uppercase `X` | 6 | 3 |

5,444 rows flagged in all; 2,744 rows in 165 ITM files have at least one Error.

## Errors

### 1. Rows mismatched: the cleaned size belongs to another row

The cleaned list is in a different order from the item's rows, so each row carries another row's size.

- `Generic/Fittings Carbon Steel/Nipple PE CS ASTM A106 GR B SMLS SCH 80.itm`: 209 rows. Index 160 is `1/8''xClose` in the ITM name and product order, but its cleaned size is `2-1/2''x11'' LNG`; index 51 `1-1/4''xClose` became `1/2''xCL`.
- All 12 `Generic/Bolts CS/* Class E*.itm` files (31 to 35 rows each): from index 10 the cleaned sizes start over at `4'' - (8) 5/8'' Dia`, while the ITM name and product order go on to `20'' - (20) 1-1/8'' Dia`. So `4''` to `18''` appear twice and `20''` and up are missing.
- Asahi HP-PVC flanges (`Flange SxFL ... CL150 FF`, `Flange Blind ... CL150 FF` and `JIS10K FF`, 11 to 12 rows each): `13mm (3/8'')` became `75mm`, `16mm (1/2'')` became `100mm`; the millimetre sizes are two rows off and the inch sizes dropped.
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

### 3. A size misread from a broken ITM name

- Georg Fischer CPVC Tee Reducing 9801 (24) and Bushing 9838 (9): the ITM name `1 .25  x1/2''` became `25''x1/2''`; `1''x 3?4` became `1''x3''` (should be `1-1/4''x1/2''` and `1''x3/4''`). The ITM names need fixing too.

### 4. Other errors

- `Generic/Bolts SS A320/Bolt Set STD SS ASTM A320 B8 Class 2 CL600.itm`: all 21 rows have `(4) 0'' Dia`, in the ITM name and the cleaned size.
- `(2)` and `(2) (2)` duplicate markers left in the cleaned size: Charlotte Bend Sixteenth PN_324 (8), Swagelok Flange Adapter FLxCMP, FLxSPG and FLxBW (6 each), Parker Nipple TBE, Nibco 604.

## For review

- **Stanchion caps** (`Cap BW CS ASTM A234 WPB ... for Stanchion.itm`, four files, 426 rows): the ITM name is `1''x1/2''` on every row of a size, while the cleaned names step through `1''x1/2''`, `1''x3/4''`, `1''x1''`. The cleaned names look right and the ITM names wrong, but confirm the second size is the hole size.
- **Ashcroft and Eagle brass thermowells** (26 rows each): the ITM name is a part number (`75-W-0162-2-x-R-...`) with no size, so the cleaned `3/4''x1/2''` cannot be checked; they are counted under Error 1 but may be right.
- **Same size, different model** (1,260 rows): AP Tech regulators, Blue-White and Hedland flow meters, Tescom valves, Swagelok check valves keep only the pipe size, so 4 to 48 rows of one item share a name. Fine if the name is only a size; a problem if it must be unique within the item.
- **ITM name wrong, cleaned size right** (39 rows): stainless tube bends 15 to 90 (ITM `5/8''`, cleaned and product order `3/4''`), pup pipes (PVC, CPVC, copper), Union Orifice SP-83. Fix the ITM name.
- Odd values: `2-3/5''` (Elbow 90 LR 10GA), `2-1/2''x3/20''` (four reducers), `1-1/2''x11/4''` (Adapter Trap 903-7, likely `1-1/4''`), `8''x100'` (Mason V-Loop).

## Corrected copy

`ALL_VL_Cod_Source_From_ITM_Cleaned - Corrected.csv` (same rows, same order; only `ProductName` changed, on 2,261 rows). Each change is in `2026-11-24 Size Corrections - Changes.csv` with the rule used; the Error rows left alone, and why, are in `2026-11-24 Size Corrections - Not Corrected.csv`.

Rules:

- **Size from the ITM name** (1,752 rows): `ProductName` set to the ITM name of the same row, tidied (`x` without spaces, `Long` → ` LNG`, `Close` → `CL`, `1 1/4''` → `1-1/4''`, `1/2''-2''` → `1/2''x2''`, `(6'') x (6'')` → `6''x6''`); olets keep the `<branch>on<run>` form.
- **Size from a repaired ITM name** (481 rows): obvious typos fixed first: `2''-1/2x2''` → `2-1/2''x2''`, `1 .25` → `1-1/4''`, `3?4` → `3/4''`, `1-1//4''` → `1-1/4''`, `6-58''` → `6-5/8''`, `11-/2''` → `1-1/2''`, `x''` → `x`, `'''` → `''`. Fix these ITM names in the ITM files too.
- **`(n)` marker removed** (28 rows).

Not corrected (482 Error rows):

| Reason | Rows |
|---|---:|
| Duplicate size, but the ITM names have the same sizes (the name was already right, the duplicate came from another row now fixed) | 251 |
| ITM name has no usable size (stock codes such as `37257`, part numbers such as the brass thermowells, `AG-4`, `Z1700-100`) | 143 |
| Cleaned name adds detail the ITM name lacks (cap screw sets: `3/4''` → `3/4'' - (4) 0.625'' Dia`) | 39 |
| Bolt diameter `0''` (A320 B8 Class 2 CL600), true diameter unknown | 21 |
| ITM name repeated on several rows of the item (TRANS-O-CON olets) | 12 |
| Product order agrees with the cleaned name, not the ITM name (tube bends 5/8 to 7/8, Swagelok 767LM) | 10 |
| ITM name has an unusual fraction (`2-3/5''`; the cleaned `2-3/8''` looks right) | 3 |
| No ITM name, or ITM name may have lost a whole number (Nibco 604 `1/4'' x 1/2''`) | 3 |

Re-running the checks on the corrected copy leaves 302 Error rows: the 252 not corrected on purpose that still show (the 251 duplicates no longer do), and 50 rows corrected from a repaired ITM name, which still differ from that unrepaired ITM name. No new errors. Removing the `(n)` markers and filling the Zone place holders adds 59 rows to the "same size, different model" duplicates for review, because those ITM names are themselves duplicated. The 947 format-only rows are not changed.

## Format only

Write mixed fractions with a hyphen (`1-1/4''`, 947 rows in 370 files, mostly Forged Stainless tees and Georg Fischer metric items), fractions rather than decimals where the ITM name has a fraction (Swagelok VCR glands, Union SP-83), lowercase `x`, and no `x''` (Merit NL106 tees).
