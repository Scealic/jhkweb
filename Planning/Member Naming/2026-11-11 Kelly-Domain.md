# Member Naming Check: Kelly-Domain

2026-11-11. Linear: KTR5-4798. Approach: [Member Naming Check](../Member%20Naming%20Check.md). Previous layer: [Kelly-Windows-v3](2026-11-11%20Kelly-Windows-v3.md).

**Read:** all 256 source files in `src` (about 13,300 lines), every member at every severity, private ones included. Five Sonnet agents each read about 2,600 lines in full, with the domain glossary (`UBIQUITOUS-LANGUAGE.md`) and the 31 open KD issues, so they didn't report those again. I checked every Misleading finding and every suspected bug against the code. Reach is the number of files outside Kelly-Domain that use the name. Logic is Kelly-Revit-Logic-v5, UI is Kelly-Revit-UI, and the add-in is Kelly-Revit-v5. A short or common name gives a noisy count.

**Result:** the names here are better than in Kelly-Windows-v3 and worse than in Kelly-Windows-Data-v3. There are about 35 misleading names, 45 vague names and 40 style notes. This layer's own trouble spots:

1. **SQL leftovers.** Names from before 2026-10-30 still say "database" or "select" for data now read from the CSV files: `IsDatabaseLookupWeldLocation`, `SelectConfiguration`, `MaterialAndLookups.Select`, and `GetRecord` "for SQL operations".
2. **Numbered or abbreviated enum and field names that only the docs explain.** `ProductCodeScenario.One` to `Four` and `Invalid`, `SpoolBillOfMaterial.Sort01` to `Sort11`, `Terminology.CategoryA`, and the support definition fields `Bl`, `Rd`, `Se1`.
3. **Serialized names.** Many weak names are data-file columns (`FabricationIdCalc`, `CustomData101ProductDotHphCode`, `CategoryA`, `IsAllowVaryBetweenGroupInstance`, `DocumentBindings`), settings keys (`SpoolCreatorSettings.*Value`) or Revit parameter names (`Names.*`, the `PenetrationTag` abbreviations). Renaming one changes the exporter (Kelly-Revit-Data-Exporter), the CSV columns and the add-in's data files together. So these are listed apart (D6) and not mixed into the code-only renames.
4. **Copies.** The `*DefinitionSet` classes repeat the same fields in eight or more sets, and the field names are inconsistent across them: `JhkTag` and `JhkTagDefinition`, `JhkSize1Definition` and `JhkSizeDefinition`. Each fix has to be made in every copy.

`Names.cs` is clean: every constant's name matches its value.

## Behaviour bugs found on the way (filed)

| Issue | Member | Bug |
|---|---|---|
| **KD-61** (Medium) | `Empty` of `LineNumber`, `DetailingPackage`, `ProductCode`, `Tag`, `ModuleNumber`, `SpoolNumber` | `Empty = default` leaves `Value` null, so `GetHashCode()` throws `ArgumentNullException`, `ToString()` is null, and `Empty != new X()`. The same holds for every failed `TryParse` out value. |
| **KD-62** | `ExternalParameterDefinition` | `GroupInProperties` is on the record only, so a record that passes through the domain type comes back without it. |

Checked and not filed:
- `BearerTypeTools` has no case for `DoubleProfileBearer2`, and tests pin that.
- `MatchServicesToSystems` returns the same system twice, and its docs describe this.
- `FormatGroupedSize` drops the branch size when there is no run. This is documented.
- `PointToPipeUnits.FromUnitText` reads "Meter" as Imperial. This is documented.
- The layout point selection summary miscount and the export length guard off-by-one are already filed as KD-1 and KD-3.
- `Component` has stray `] ` in three `[Column]` attributes and `???` on `Id`. Nothing reads `ColumnAttribute`, so this is cosmetic, and it is listed under D3.
- `VtfrSettings.FtpPassword` is a plain-text settings property. The source holds no value (it defaults to empty), so no secret is committed. Whatever a user saves is stored in plain text, though. It is noted here, not filed.

## Misleading

### Spools and Supports

| Member | What it does | Suggested | Reach |
|---|---|---|---|
| `SpoolNumber.HasLineNumber` / `HasCategory` (static, on a name string) | Also requires the category part to be one of the spool categories | `IsNameOfLineNumber` / `IsNameOfCategory` | Logic 2, add-in 1 |
| `SupportTagNumbering.NextTag` | Returns the **existing** tag of an identical support; only otherwise makes prefix-(max+1) | `ResolveTag` | Logic 2 (KD-37 and KD-46 touch it too) |
| `ISpoolItem.SetItemNumber` (+ `ModuleComponentModel`) | Sets the item number **and** its suffix | `SetItemNumberAndSuffix` | Logic 4 |
| `ISpoolItem.ConnectorOneDiameter` | The docs say the largest connector **perimeter** | `ConnectorOnePerimeter`, or fix the doc | Logic 2, add-in 1; may be grid-bound |
| `ItemNumberFormat.Format` | Like `Compose`, but returns "" (clears) when the sequence is ≤ 0 | `ComposeOrClear` | noisy |
| `BearerType.None` | Shown as "Default", and returned for unknown names | `Unknown` | stored by Description text |
| `BearerTypeTools.FromFamilyName` | "Trapeze…" families map to `Strut`, although `BearerType.Trapeze` exists | document, or return `Trapeze` | Logic 2 |
| `AnchorType.ConcreteInsert` | The XML doc says "Wood Deck, Sheet Metal Deck" | fix the name or the doc | enum |

### LayoutPoints and Pcf

| Member | What it does | Suggested | Reach |
|---|---|---|---|
| `PointToPipeSettings.Write` | Writes the settings file, **then** sets the `StandardUnits` changed flags and writes that file too | `WriteAndRecordUnitChanges`, or split it | add-in 1 |
| `PointToPipeSettings.CoordinateX/Y/Z` | Hold the **name of the column** holding each coordinate; the sibling is `PipeSizeColumn` | `XColumn` / `YColumn` / `ZColumn` | add-in 1 (file is line-ordered, safe) |
| `StandardUnits.PointToPointPipeSizeUnitsChanged` / `…PointUnitsChanged` | Flags for the **Point To Pipe** tool | `PointToPipe…` | add-in 1 each (stored by position, safe) |
| `LayoutPointExportQuality.TryGetWorstFlag` | Never reports failure through the bool (throws instead); false only means "no flags" | `GetWorstFlag` returning a tuple | add-in 2 |
| `PcfReader.Part.StartNominalDiamter` / `EndNominalDiamter` | Typo: should be "Diameter" | `…Diameter` | Logic 1 each |
| `PcfReader.Part.Name` / `Weight` | The PCF component keyword (PIPE, WELD…); the raw WEIGHT text | `ComponentType` / `WeightText` | noisy |
| `VtfrSettingsRow.DecRound` | A fraction to round to (1/16), not decimal rounding | `RoundingFraction` | none |

### Products, Definitions, Categories

| Member | What it does | Suggested | Reach |
|---|---|---|---|
| `MaterialAndLookups.Select(store, name, group)` | Finds the material and **copies its fields into this instance** | `TryLoadFrom` | Logic 1 |
| `SpoolItemDefinitionSet.JhkSize1Definition` | The JHK Size definition; "1" is a leftover (`ValveDefinitionSet` has `JhkSizeDefinition`) | `JhkSizeDefinition` | Logic 1 |
| `TerminologyTools.GetSpoolCategories` / `SpoolCategoryName` | Filters terminology rows whose `CategoryA` is "Assembly"; the glossary has Assembly as a module grouping | confirm the term with the maintainer | add-in 2; Logic 1 |

### Identifiers, Connectors, Parameters, Vocabulary

| Member | What it does | Suggested | Reach |
|---|---|---|---|
| `EndPreparationTools.IsDatabaseLookupWeldLocation` | True for S/STK/FW; the lookup goes to the CSV `DataStore`, not a database | `IsDataStoreLookupWeldLocation` | Logic 1 |
| `ConnectorSizeFormatter.GetRunString` / `GetBranchString` (private) | Return a `StringBuilder`, or null | `BuildRunText` / `BuildBranchText` | private |
| `Nouns.Prefix` | Returns "Name" | fix the value, or rename | none |
| `Verbs.Exported` | A past participle in an enum of verbs | move to `Adjectives` | Logic 5, add-in 1 |

### Projects, Data, Signatures, Operations, Views, Common, Fabrication

| Member | What it does | Suggested | Reach |
|---|---|---|---|
| `ProductCodeScenario.One` / `Two` / `Three` / `Four` / `Invalid` | Missing Product Code / OK / missing both / Component Id mismatch / missing Component Id; `IsValid => Scenario == Two` is unreadable | `MissingProductCode`, `Valid`, `MissingBoth`, `ComponentIdMismatch`, `MissingComponentId` | Logic 6 |
| `ProjectSystemQueries.SelectConfiguration` | Finds by GUID in the store; a missing record throws **`ArgumentNullException("configuration")`** | `GetConfiguration`, and throw `InvalidOperationException` | Logic 1 |
| `ServiceData.GetServiceName` | Parses "Group:Name" and **shows a prompt** when there is more than one ':' | `ParseServiceName`, prompt moved out | Logic 2 |
| `DataStore.ServiceData`, `Systems` vs `DataFiles.Services`, `Systems` | The same names return records in one type and domain objects in the other | `ServiceRecords`, `SystemRecords` on the store | noisy |
| `DataStore.FindGroupTypeId` | Returns the `GroupTypeIdRecord`, not an id | `FindGroupType` | none |
| `SystemSignatureTools.FindSystem` vs `FindService` / `FindServiceExact` | The unsuffixed names mean opposite things (exact vs ignore case) | `FindSystemExact`; one rule (KD-7) | Logic 2, add-in 3 |
| `ColoredSignatureLookup.MatchSignatures` vs `FindBySignature` | Ignores case where its sibling does not; drops unmatched items | `FindBySignaturesIgnoreCase` | Logic 1, add-in 2 |
| `ViewFilterNames.IsNavisViewType` | Predicate in a "names" type; "Navis" vs `KellyViewType.Navisworks` | `IsNavisworksViewType` | Logic 2 |

## Vague (highlights)

- **Spools and Supports:**
  - `IFractionDecimalSet.GetSet`: builds a new collection, and its values are inches.
  - `ModuleComponentModel.Length` and `Weight`: no unit in the name; `Length` is feet.
  - `SpoolItemNumbering.ItemizeComponents` and `ItemizeNonWelds`: they assign item numbers.
  - `HangerSpacing.ParseRepeatFeet` and `ParseStartFeet`: they fall back to 8 and 2.
  - `SupportSignature.Status` and `Issue`.
  - `ModuleNumber.TryParse(prefix, type, seq)`: it composes the number.
  - `Placeholder`: it is text.
  - `SuspendedSupportDefinitionSet.RodTopEnds` and `RodBottomEnds`: they are definitions.
- **LayoutPoints and Pcf:** `DataFileHeaderSchemaSets.LayoutPointSchema`, `NormalizePrefix` (it returns the sentinel "Invalid"), `LayoutPointStorage.MaximumLength`, `Databases.VtfrDocuments` (a folder), and the private `GetPoint` and `ToFeet`.
- **Products:** `ProductRangeTools.GetCheckboxDefault` (a Yes/No default), `GetDefaultParameterValue` (its `nullValue` is a fallback), and `BuiltInCategoryWrapper.BuiltInCategoryValue` (an element id).
- **Identifiers and Parameters:**
  - `LayoutPointId.Index`: a letter.
  - The `GetSegment*` methods of `Tag` and `ProductCode`.
  - `ExternalParameterDefinition.GetRecord` and `GroupTypeIdWrapper.GetRecord`: both build a record (`ToRecord`).
  - `IColorPalette.GetAll`: it creates filter rules.
  - `FilterRuleModel.Value`.
  - `HostSize`: an unused enum.
- **Common and Operations:**
  - `RegexTools.SheetMetalSizeSchema`: returns a `Match`.
  - `RegexTools.SplitItemNumber`: it parses.
  - `SignatureState.None`: means "neither signature".
  - `Miscellaneous`.
  - `FilePath`: clashes with `ProjectRecord.FilePath`.
  - `FabricationCustomData.JhkJlsw` and `JhkJmvc`.

## Style (highlights)

- **Typos:**
  - `WelLocation` enum (Logic 2, add-in 6).
  - `Sort04LOngDescription`.
  - `TagSignatureNotMisMatch`.
  - `Nouns.RoleSuperintendant`: the value too.
  - `Verbs.UnTangle`.
  - `FilterRuleType.BeginWith` and `NotBeginWith`, against `EndsWith`.
  - `CustomData101ProductDotHphCode` against `HpnCode`: one of them is a typo, and the first is a data-file column.
- **Definition-set suffixes:** `JhkTag` and `JhkTagDefinition`, `JhkFieldTrim` and `JhkFieldTrimDefinition`, `JhkLongDescriptionDefinition` (only in `TrapezeVerticalMemberDefinitionSet`), and `JhkLayoutPointIdIndex` against the parameter `JhkLayoutPointIndex`. Pick one form. Dropping "Definition" fits, since the type already says it.
- **Bools without Is/Should, or `Is…` on non-bools:**
  - `ModuleComponentModel.InLinkedDocument`.
  - `SpoolCreatorSettings.SaveLineNumberToComponents`.
  - `IColorPalette.ColorIsEmpty`: a colour.
  - `ProjectRecord.IsActive` and `IsBimLite`: ints, and CSV columns.
  - `ExternalParameterDefinition.IsAllowVaryBetweenGroupInstance` and its siblings: columns.
- **Counts named as collections:** `LayoutPointImportFailureSummary.NotIds`, `Duplicates`, `NoFamily`. Also `HasAny` (better `HasFailures`).
- **One term, several meanings:**
  - "item number" means three things.
  - `JhkBomType` is a string in one type and an enum in another.
  - `BearerType.SupportMember` shares its name with the empty class `SupportMember`.
  - `ModuleNumber.Empty` and `new ModuleNumber()` differ (KD-61).
- **Abbreviations:** `PcfData.IsCoOrdsUnitsMm`, `SpoolMtrSheet…`, `DecRound`, and `ThreeDee`.
- **BearerType numbering:** its docs say "explicit and append-only", but only `None = -1` is explicit. Inserting a member would renumber the stored values.

## Proposed Linear issues (not yet filed)

All in KD, related to KTR5-4798. Each renames the members, adds XML docs where they are missing, resets the `Author` stamp of the tests it touches, and is followed by repin issues in the Revit logic layer and the add-in where the reach is not "none". **D1 to D5 rename only code.** D6 holds the names that are written to files, settings or models.

| # | Scope | Highest reach | Estimate |
|---|---|---|---|
| D1 | **Spools and Supports**: `SpoolNumber.Has*`, `NextTag`, `SetItemNumber`, `ConnectorOneDiameter`, `ItemNumberFormat.Format`, `BearerType.None` / Trapeze mapping, `AnchorType` doc, `ItemizeComponents`, `HangerSpacing.Parse*`, `SupportSignature`, `ModuleNumber.TryParse`/`Placeholder`, `RodTopEnds`, the bool and typo notes | `Placeholder` Logic 8 | 2 |
| D2 | **LayoutPoints and Pcf**: `PointToPipeSettings.Write`/`Coordinate*`, `StandardUnits.PointToPoint*`, `TryGetWorstFlag`, `Diamter` typos, `Part.Name`/`Weight`, `DecRound`, failure counts, `LayoutPointSchema`, `NormalizePrefix` | `TryGetWorstFlag` add-in 2 | 2 |
| D3 | **Products, Definitions, Categories**: `MaterialAndLookups.Select`, one suffix rule for every `*DefinitionSet` field (`JhkSize1Definition` …), `GetCheckboxDefault`, `GetDefaultParameterValue`, `BuiltInCategoryValue`, the `Component` `[Column]` strays, the Assembly/spool-category term (after the maintainer decides) | DefinitionSet fields, many | 2 |
| D4 | **Identifiers, Connectors, Parameters, Vocabulary**: `IsDatabaseLookupWeldLocation`, `GetRunString`/`GetBranchString`, `Nouns.Prefix`, `Verbs.Exported`/`UnTangle`, `LayoutPointId.Index`, `GetSegment*`, `GetRecord` → `ToRecord` (with KD-62), `IColorPalette.GetAll`/`ColorIsEmpty`, `FilterRuleType.BeginWith`, `HostSize` | `Verbs.Exported` Logic 5 | 2 |
| D5 | **Projects, Data, Signatures, Operations, Views, Common, Fabrication**: `ProductCodeScenario` members, `SelectConfiguration` (+ its exception), `GetServiceName`, `DataStore`/`DataFiles` record vs domain names, `FindGroupTypeId`, `FindSystem`/`MatchSignatures` (with KD-7), `ViewFilterNames`, `WelLocation`, `TagSignatureNotMisMatch`, `SignatureState.None`, `RegexTools` | `WelLocation` 8, `ProductCodeScenario` 6 | 2 |
| D6 | **Serialized names** (decide per item, with the exporter): data-file columns `FabricationIdCalc`, `CustomData101ProductDotHphCode`, `Terminology.CategoryA`/`EnumCalc`, `InternalIndex`, `CategoryTypeRecord.ProductRange`, `IsAllowVaryBetweenGroupInstance` and siblings, `DocumentBindings`/`ElementBindings`, `ProjectRecord.IsActive`/`IsBimLite`; settings keys `SpoolCreatorSettings.*Value`/`SpoolName`; `SpoolBillOfMaterial.Sort*`; `Nouns.RoleSuperintendant` value | exporter, CSV files, add-in data | 4 |

D6 changes Kelly-Revit-Data-Exporter, the CSV schema and the shipped data files together, so it needs the maintainer's call on each name. Some, like `IsActive` as an int, may not be worth a format change.
