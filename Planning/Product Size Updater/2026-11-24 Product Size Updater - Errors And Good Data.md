# Product Size Updater: errors and good data

2026-11-24. Taken from the code in `Fabrication-Tools/src/FabricationTools.Core/ProductSizeUpdater` (`ProductSizeUpdaterPlanner`, `ProductSizeUpdaterAction`, `SizeCheck`). The tool reads a product size CSV file and matches each row with the database's products: the row's `ProductCode` is `dbo.Product.FabricationIdCalc`, and its `ProductName`, trimmed, is the size for `dbo.Product.Size`.

## Good data

A row is good when all of these hold:

- **The row can be read:** it has an ITM file path, and its Index and Quantity are whole numbers.
- **Product Code** is filled in and shaped `<ComponentId>-<ProductIndex>`.
- **Each Product Code appears once per ITM file.**
- **The database has the product:** a `dbo.Product` row with that Product Code.
- **ProductName (the size) is filled in.**
- **The size is at most 40 characters**, the width of `dbo.Product.Size` (NVARCHAR(40)).
- **Inches are written as two single quotes (`''`)**, never `"`, `“`, `”` or `″`.
- **Fractions use a slash and a power-of-two denominator:** `1-1/2''`, `3/4''`, `1/16''`. Not `1-12`, `1?2` or `1/3`.
- **The size is not an Excel date:** not a five-digit whole number.
- **Each Product Code of a component has its own size.** A size can repeat only when the component is sized by something else, such as a length or a pressure class. The check treats a component as sized by something else when more than 10% of its products repeat a size.
- **Copied ITM files agree with the original:** when the same Product Code appears in several ITM files with different sizes, the component's own ITM file must hold exactly one of them, and that one is used.

The size may have text after it, such as a supplier part number after the last inch marks (`2''x1-1/2'' SD0215`) or text in brackets (`1/2'' (15mm)`). The size checks ignore that text.

Good rows get one of these results:

| Action | Meaning |
|---|---|
| SQL Size Differs | The CSV size differs from the database's; Update In SQL writes it. The Difference column says why (Inch marks, Spaces, Letter case, Missing inch marks, Olet syntax, Dimension order, Text removed, Dimensions added, Dimensions removed, Size changed, Database blank). |
| SQL Size Matches | The database already has this size; nothing is written. |
| Copied ITM File | A copied ITM file has another size; the size from the component's own ITM file is used. |

## Errors

### Rows it blocks

Nothing is written, and the grid draws these rows in red.

- **Duplicate CSV Product Code:** an earlier row of the same ITM file already used this Product Code. Every row of the repeated code is marked.
- **Conflicting Copied ITM Sizes:** the code's rows give different sizes, and none of them comes from the component's own ITM file.
- **Bad CSV Index or Quantity:** Index or Quantity isn't a whole number, usually because the columns shifted.
- **Bad CSV Product Code:** the Product Code is blank or not shaped `<ComponentId>-<ProductIndex>`.
- **CSV Size Too Long:** the size is longer than 40 characters.
- **Double Quote in CSV Size:** inches are written with `"`, `“`, `”` or `″` instead of `''`.
- **Unreadable CSV Row:** the row can't be read for another reason, such as a blank ITM file path.

### Rows with nothing to write

The row is read, but there is nothing to update.

- **No SQL Record:** the database has no product with this Product Code.
- **No CSV Size:** the ProductName is blank.

### Sizes that need correcting

These show in the Needs correcting column. The tool only flags them; Update All In SQL and Update Selection In SQL never write a flagged size.

- **Excel date in CSV size:** the size is a five-digit whole number, so Excel has turned it into a date.
- **Bad fraction in CSV size:** a denominator that isn't a power of two, a whole number and digits with no slash (`1-12`), or a question mark in place of the slash (`1?2`).
- **Repeated CSV size:** two Product Codes of the same component have the same size, while repeats are at most 10% of the component's products. Rows whose sizes already match the database are checked too, so every row of a repeated size shows.

The size rules are provisional. They come from the content team's workbook reviewed on 2026-11-19 and are waiting for Vladimir to confirm them.
