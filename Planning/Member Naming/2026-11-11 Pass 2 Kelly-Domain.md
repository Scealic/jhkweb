# Member naming check, pass 2: Kelly-Domain (2026-11-11)

Second pass after the first-pass renames landed. Sources: groups G04, G05, G06, plus the `ConnectorOnePerimeter` finding of G11 (a Domain member, owned here). Readers: Sonnet; checked by: Opus.

Callers are files outside Kelly-Domain that use the name (Logic is Kelly-Revit-Logic-v5, the add-in is Kelly-Revit-v5). Every suggested name below was grepped across the v5 repos and clashes with nothing.

## Summary

- Confirmed: **6 Misleading**, **49 Vague**, **46 Style**.
- Possible bugs: **2 confirmed**, **11 dropped** (documented, already filed, or no live caller).
- Downgraded: 2 Misleading to Vague or Style. Dropped: 8 findings (below).
- Two renames made today are still wrong: `SignatureState.NoSignatures` (the value means "not saved", and a live signature always exists when it is returned) and `ConnectorOnePerimeter` (the largest perimeter of all connectors, not connector one's).

## Confirmed bugs

| Member | File:line | What is wrong | Evidence | Steps to show it | Priority |
|---|---|---|---|---|---|
| `ConnectorSizeFormatter.FormatGroupedSize` | `Connectors/ConnectorSizeFormatter.cs:86` (`BuildRunText` returns null at :211) | When the Run connector has an empty size string, `BuildRunText` returns null and `runString.Length` throws `NullReferenceException`. The JHK Size updater (`SizeElementDataModel.SetSizes`, Logic `Updaters/ElementDataModels/SizeElementDataModel.cs:150`) calls it whenever the connectors do not share one size string. | The method's own XML docs and the test `FormatGroupedSize_EmptyRunSizeString_ThrowsNullReferenceException` say "reported as a bug", but no KD issue for it is in the known list or the Planning reports. | Call `FormatGroupedSize([(Run, ""), (Branch, "4")], "x", grouping)`: it throws. In Revit: a fitting whose Run connector gives no size string while another connector has one (not reproduced in Revit). | High |
| `ColoredSignatureLists.DistinctSortedOrDefault`, `ServiceData` / `SystemData` (no value equality) | `Signatures/ColoredSignatureLists.cs:35`; callers Logic `Caches/SystemDocumentCache.cs:27-29`, `Caches/ServiceDocumentCache.cs:33` | `ServiceData` and `SystemData` override no `Equals`, so `Distinct()` and every `Contains` check compare by reference and never remove anything. `SystemDocumentCache.GetData` adds the project's systems and then the service-matched systems, so a system that is both assigned to the project and matched by a loaded service is listed twice in the system lists. | `DistinctSortedOrDefault`'s returns doc admits "by reference"; `MatchServicesToSystems` docs admit its own repeat (first pass: documented, not filed). The repeat across the two lists is new evidence. Related: KTR5-4003, KTR5-4004 (HashSet refactors of the two caches). | Open a Kelly project with system X assigned to the project and a fabrication service named like X loaded; open a System combo box (Auto-Set panel): X appears twice. | Medium |

## Proposed rename issues

### R1: Spool items and spool rules: `ConnectorOnePerimeter`, `ModuleNumber.Create`, spool names

| Severity | Member | File:line | What it does | Suggested | Callers | Serialized/Shown |
|---|---|---|---|---|---|---|
| Misleading | `ISpoolItem.ConnectorOnePerimeter`, `ModuleComponentModel.ConnectorOnePerimeter` (and Logic `SpoolItem`, `ElementComponent`) | `Spools/ISpoolItem.cs:8`, `Spools/ModuleComponentModel.cs:15` | The largest perimeter over all connectors (Logic `GetMaxPerimeterOfConnectors`), 0 when none. Renamed today from `ConnectorOneDiameter`; "One" is still wrong. The validation message, class remarks and grid header still say "Connector One Diameter". | `MaxConnectorPerimeter`; fix the `[Range]` message, the remarks and the header | Domain `SpoolItemNumbering` (4), Logic 2, add-in XAML 1 | **Shown**: `ModuleManageView.xaml:680` binds it by name; header "Conn. One Dia." and tooltip are wrong text |
| Vague | `ModuleNumber.Create` | `Spools/ModuleNumber.cs:67` | Never throws: returns `new ModuleNumber()` (not valid) when the parts make no number; pads the sequence ("007") | `ComposeOrInvalid` (the layer's `ParseOrInvalid` pattern) | Domain 1, add-in 1 | no |
| Vague | `SpoolBillOfMaterial` (type) | `Spools/SpoolBillOfMaterial.cs:3` | One grouped line of a bill; `Build` returns a list of them | `SpoolBillOfMaterialLine` | about 10 | no |
| Vague | `SpoolSummary` / `Summarize` | `Spools/SpoolSummary.cs:4,12` | Empty, the one distinct value, or "Multiple" | `SpoolValueSummary.SingleValueOrMultiple` | about 10 | "Multiple" shown |
| Vague | `SpoolSheet` (type) | `Spools/SpoolSheet.cs:4` | Holds only `TitleBlockNamePrefix` | `SpoolSheetNames` | 2 | prefix "Spool - " is a Revit name: keep |
| Vague | `SpoolViewNameType` | `Spools/SpoolViewNameType.cs:3` | Its member names are the sheet and view names (`nameof`), and `Sheet` is no view | `SpoolViewName` | 2 | **Serialized**: member names are Revit view names |
| Vague | `ModuleCreatorSettings.From`, `ResolvePrefixOptionExisting` | `Spools/ModuleCreatorSettings.cs:20,37` | Builds from a `ModuleNumber`; returns whether "Existing" wins | `FromModuleNumber`, `IsExistingPrefixOptionSelected` | 2 | methods, not JSON keys |
| Vague | `SupportSignature.CompareStoredToLiveHash` | `Supports/SupportSignature.cs:103` | Returns text "", "Match" or "Mismatch"; throws when the live hash is empty | `GetSignatureStateText` | 2 | result text stored/shown |
| Vague | `VerticalSupportTypeTools.FormatSupportSizeText(value111)` | `Supports/VerticalSupportTypeTools.cs:12` | Parameter is the custom data 111 text | parameter `supportSizeText` | 3 | no |

### R2: Service and system signatures: one name per matching and composing rule

| Severity | Member | File:line | What it does | Suggested | Callers | Serialized/Shown |
|---|---|---|---|---|---|---|
| Misleading | `ColoredSignatureLists.DistinctSortedOrDefault` | `Signatures/ColoredSignatureLists.cs:16` | `Distinct` removes nothing (reference equality, see bug B2) | `SortedOrDefault`, or keep the name once B2 gives the types value equality | Logic 2 | no |
| Vague (was Misleading) | `ColoredSignatureTools.Compose` vs `SignatureTools.Compose` (internal) | `Signatures/ColoredSignatureTools.cs:10`, `Signatures/SignatureTools.cs:12` | Same name, different rule: raw `name + " " + abbreviation` vs content check and white-space collapse. Both docs state the difference, so the names are true but hide it | `ComposeRaw` / `ComposeNormalized` | Domain 4 | no |
| Vague | `ServiceSignatureTools.CreateServiceSignature`, `SystemSignatureTools.GetSystemSignature` | `Signatures/ServiceSignatureTools.cs:11`, `Signatures/SystemSignatureTools.cs:34` | Two verbs for the same pure composition | `ComposeServiceSignature` / `ComposeSystemSignature` | about 20 | no |
| Vague | `ColoredSignatureLookup.FindBySignature`, `ServiceSignatureTools.FindService` / `FindServiceExact`, `SystemSignatureTools.FindSystem` | `Signatures/ColoredSignatureLookup.cs:20`, `ServiceSignatureTools.cs:27,51`, `SystemSignatureTools.cs:15` | Four match rules (ordinal, ignore case, normalized) under overlapping names. `FindSystem` to `FindSystemExact` is first pass, not applied (waits on KD-7) | `FindBySignatureExact`, `FindServiceIgnoreCase`; settle with KD-7 | about 13 | no |
| Vague | `DataFiles.GetServices(signatures)`, `GetSystems(signatures)` | `Caches/DataFiles.cs:75,85` | Case-insensitive filter by signature | `FindServicesBySignatures`, `FindSystemsBySignatures` | 4 / 4 | no |
| Vague | `ServiceData` / `SystemData` over `ServiceDataRecord` / `SystemRecord`; `DataStore.ServiceRecords` / `SystemRecords` | `Projects/ServiceData.cs:3`, `Projects/ServiceDataRecord.cs:3`, `Data/DataStore.cs:41,42` | Record type names disagree; the `…Records` lists (renamed today) differ from siblings `Products`, `Projects` | type `ServiceDataRecord` to `ServiceRecord`; decide one list pattern | about 30 | data-file name stays |

### R3: Layout point signature state and export names

| Severity | Member | File:line | What it does | Suggested | Callers | Serialized/Shown |
|---|---|---|---|---|---|---|
| Misleading | `SignatureState.NoSignatures` | `Operations/SignatureState.cs:13` | Returned by `LayoutPointSignature.Status` only when the live signature exists and the point is not saved. Its own doc ("neither a live nor a stored signature") is wrong; `Status`'s doc is right | `NotSaved`, and fix the enum doc | Domain 1, Logic 1 (via `SignatureStatus`) | **Shown**: the Layout Point To CSV Export grid shows the enum text (`…ExportView.xaml:425`) |
| Vague | `DataFileHeaderSchemaSets` | `LayoutPoints/DataFileHeaderSchemaSets.cs:3` | Only the accepted Layout Point CSV headers | `LayoutPointCsvHeaders` | 4 | no |
| Vague | `LayoutPointExportQuality.Describe` | `LayoutPoints/LayoutPointExportQuality.cs:22` | Builds the dialog notice for a flag and its count | `CreateNotice` | 4 | no |
| Vague | `LayoutPointLayer.FamilyName` | `LayoutPoints/LayoutPointLayer.cs:19` | The family name constant on the layer class | move to `LayoutPointFamilies` | 6 | "Layout Point" family name: keep |
| Vague | `LayoutPointRecipe.Ingredient01IdPrefix` … `Ingredient10DisciplineName` | `LayoutPoints/LayoutPointRecipe.cs:40-67` | Numbered names; `Ingredient03IdIndex` vs `IndexLetter` | drop the numbers (`IdPrefix`, `IdNumber`, `IdIndexLetter`, …) | Logic 1, add-in XAML 9 | **Shown**: bound by name in `LayoutPointToCommaSeparatedValueFileExportView.xaml` |
| Vague | `LayoutPointExportSelection.SelectDuplicatesToResolve` | `LayoutPoints/LayoutPointExportSelection.cs:62` | Points that are duplicates and moved after save; resolves nothing | `FindMovedDuplicates` | 2 | no |

### R4: Point To Pipe and PCF types: `Databases`, `PcfReader`, Victaulic prefixes

| Severity | Member | File:line | What it does | Suggested | Callers | Serialized/Shown |
|---|---|---|---|---|---|---|
| Misleading | `Databases` (type), `VtfrDocumentsFolder` | `Pcf/Databases.cs:3,7` | One folder path, no database; hard-codes "24" while `VtfrSettings.Year` is "24" | `VictaulicToolsFolders` (or fold into `StandardUnits`, its only caller) | Domain 1 | folder path: keep |
| Misleading | `PcfReader` (type), `PcfReaderController`, `PcfReaderController.Reader` | `Pcf/PcfReader.cs:3`, `Pcf/PcfReaderController.cs:3,42` | `PcfReader` holds only part models; the reading is in `Reader.ReadFile`; the "controller" only nests `PcfData` and `Reader`. Nested types also break one type per file | `PcfModel` (or top-level `PcfPart`, `PcfPipe`, `PcfWeld`), `PcfFileReader.ReadFile`, top-level `PcfData` | Logic 1 | no |
| Vague | `Reader.ReadFile` locals `flag1..3`, `str1`, `text1..3` | `Pcf/PcfReaderController.cs:54-209` | Parser state | `isInPipe`, `isInWeld`, `isInOtherComponent`, `previousLine` | private | no |
| Vague | `PcfReader.Point3d` | `Pcf/PcfReader.cs:57` | A second point type beside `Point3` | reuse `Point3`, or `PcfPoint` | 2 | no |
| Vague | `StandardUnits` (type) | `Pcf/StandardUnits.cs:3` | Flags of which tools' unit choices changed; holds no units | `ToolUnitChangeFlags` | 4 | file "StandardUnits.vic": keep |
| Vague | `PointToPipeSettings.WriteCore` | `Pcf/PointToPipeSettings.cs:89` | "Core" breaks the house meaning (caller's transaction) | `WriteToFile` | private | no |
| Vague | `VicUnits`, `VicMaterial`, `VtfrSettings`, `VtfrSettingsRow` | `Pcf/*` | Three prefixes for one tool set | `Vtfr…` for settings, `VictaulicMaterial`, `UnitSystem` | 2 to 4 | settings keys: check |
| Vague | `PointToPipeUnits.FromUnitText` | `Pcf/PointToPipeUnits.cs:18` | Unit text to `VicUnits` | `ToVicUnits` | 2 | no |

### R5: Products, parameters and custom data records

| Severity | Member | File:line | What it does | Suggested | Callers | Serialized/Shown |
|---|---|---|---|---|---|---|
| Misleading | locals `isSpecificationNameSet`, `isGradeNameSet` | `Products/MaterialDescriptionTools.cs:24,28` | True when the part is left out ("-" or the lookup trigger) | `isSpecificationNameLeftOut`, `isGradeNameLeftOut` | private | no |
| Vague | `Manufacturer` (type) | `Products/Manufacturer.cs:3` | Unused anywhere (0 callers) | delete | 0 | no |
| Vague | `ProductRangeParameterDefaults`, `…Record` | `Products/ProductRangeParameterDefaults.cs:3` | One row | `ProductRangeParameterDefault` | 5 | file name stays |
| Vague | `ProductRangeRules.IsWeld(int productRange)`, `RequiresDedicatedTaggingTool` | `Products/ProductRangeRules.cs:10,19` | Parameter is a range number | parameter `productRangeNumber` | 6 / 2 | no |
| Vague | `Product.Id` vs `ProductDotId` | `Products/Product.cs:27,36` | Record id vs product id | `RecordId` for `Id` | many | `ProductDotId` column: keep |
| Vague | `FabricationIdCalc` / `ProductDotProductCode` | `Operations/CustomDataUpdaterRecord.cs:40`, `Products/Product.cs:42` | Three names for the product code | C# `ProductCode`, columns by attribute | 5 | **Serialized** columns |
| Vague | `CustomDataUpdaterRecordIndex` | `Operations/CustomDataUpdaterRecordIndex.cs:5` | Matches a part to a record | `CustomDataUpdaterRecordMatcher` | 3 | no |
| Vague | `ExternalParameterDefinition` ctor arg `groupTypeId`, `GroupTypeTableId` | `Parameters/ExternalParameterDefinition.cs:12,47` | The arg is a row, not an id | `groupTypeRecord` | 3 | columns: keep |
| Vague | `GroupTypeIdWrapper` | `Parameters/GroupTypeIdWrapper.cs:4` | Wraps a group-type row | `ParameterGroupType` | 2 | no |
| Vague | `GaugeNameResolver.Resolve` | `Products/GaugeNameResolver.cs:21` | Schedule abbreviation or gauge name | `ResolveGaugeName` | 1 | no |
| Vague | `Component.BusinessDotName` | `Products/Component.cs:59` | Written to JHK Manufacturer | `ManufacturerName` | 4 | column: keep |

### R6: Connectors, data files, fabrication and identifiers

| Severity | Member | File:line | What it does | Suggested | Callers | Serialized/Shown |
|---|---|---|---|---|---|---|
| Vague | `ConnectorSizeDataResolver.ReadConnectorGrouping`, `ReadConnectorMapping`, `ReadSizeSymbols` | `Connectors/ConnectorSizeDataResolver.cs:18,36,54` | Finds a store row, memoized; reads no file | `GetConnectorGrouping`, `GetConnectorMapping`, `GetSizeSymbols` | 2 / 2 / 3 | no |
| Vague | `ConnectorPreparationResolver.Resolve` | `Connectors/ConnectorPreparationResolver.cs:19` | Forwards to `DataStore.FindConnectorPreparation` | `FindPreparation` | about 6 | no |
| Vague | `ConnectorPreparationsRecord` | `Connectors/ConnectorPreparationsRecord.cs:5` | One row | `ConnectorPreparationRecord` | 5 | columns kept |
| Vague | `ConnectorSizeFormatter.FormatConnectorSize` | `Connectors/ConnectorSizeFormatter.cs:13` | One connector's size | `FormatSingleConnectorSize` | 2 | no |
| Vague | `RegexTools.ParseItemNumber` | `Common/RegexTools.cs:20` | Never fails: "-" and -1 when no match | `ParseItemNumberOrInvalid` | Logic 1 | no |
| Vague | `DataFiles.Get<T>()` | `Caches/DataFiles.cs:63` | The list registered for T | `GetRegisteredList<T>` | internal mostly | no |
| Vague | `ProductCodeCheckReport.GetReportName`, `FabricationCustomDataNames.GetReportName` | `Fabrication/ProductCodeCheckReport.cs:62`, `FabricationCustomDataNames.cs:17` | File name without extension | `GetReportFileName` | 4 | text unchanged |
| Vague | `BuiltInCategoryWrapper` | `Categories/BuiltInCategoryWrapper.cs:3` | Model with `IsBound` | `BuiltInCategoryModel` | 8 | no |
| Vague | `ContentTools` | `Common/ContentTools.cs:3` | Product code scenario rules | `ProductCodeScenarioTools` | 8 | no |
| Vague | `CategoryTypeRecord.ProductRange` | `Categories/CategoryTypeRecord.cs:24` | A range number | `ProductRangeNumber` with the column kept | few | **Serialized** |
| Vague | `FittingAliasTools.Prefixes` | `Fabrication/FittingAliasTools.cs:8` | Prefixes that end a hanger run walk | `HangerRunEndAliasPrefixes` | 6 | no |
| Vague | `PenetrationTag` (static class) | `Identifiers/PenetrationTag.cs:3` | Composer, reads as a value type | `PenetrationTagTools` | 3 | no |
| Vague | `IIdentifier.ValueAsHash` | `Identifiers/IIdentifier.cs:11` | SHA-256 hex of `Value`, computed in every constructor of seven identifier types, and read nowhere in the v5 repos | delete it, or `ValueSha256Hex` if kept | 0 readers | no |

### R7: Spool sheet view settings: one word for the 3D view

| Severity | Member | File:line | What it does | Suggested | Callers | Serialized/Shown |
|---|---|---|---|---|---|---|
| Vague | "Orthographic" (`ISheetOrthographicViewSettings`, `ViewOrthographicConfiguration`, …), "3d" (`SpoolSheet3dViewPortSettings`), `ThreeD` | `Views/*`, `Views/Spools/*` | Three words for the one 3D view | `ThreeD…` throughout | 3 to 7 each | `ViewName` "3D" is a Revit name |
| Vague | `PlanSpool11X17SheetDetailViewSettings` | `Views/Spools/PlanSpool11X17SheetDetailViewSettings.cs:3` | Orientation `ElevationTop`, view "TOP" | `TopSpool11X17SheetDetailViewSettings` | 1 | **Shown**: template "Spool 11x17 - Plan" kept |
| Style | `IViewPortSettings` and implementers | `Views/IViewPortSettings.cs:3` | Revit says `Viewport` | `IViewportSettings` | 3 | no |
| Style | `ISheetDetailViewSettings.ViewOrientation` vs `ViewDetailConfiguration.Orientation` | `Views/ISheetDetailViewSettings.cs:12` | Same property, two names | `Orientation` | 7 | no |
| Style | `Spool11X17…` types | `Views/Spools/*` | Template text is "11x17" | `Spool11x17…` | 1 each | no |

### R8: Style batch (Kelly-Domain)

| Severity | Member | File:line | Note | Suggested | Serialized/Shown |
|---|---|---|---|---|---|
| Style | `SignatureState.SchemaIssue` | `Operations/SignatureState.cs:17` | Never produced anywhere | delete | enum text |
| Style | `ModuleNumber.TryCompose` | `Spools/ModuleNumber.cs:223` | No callers in src; differs from `Create` (no padding) | delete | no |
| Style | `LayoutPointRecipe.Ingredient01IdPrefix` `[Range]` | `LayoutPoints/LayoutPointRecipe.cs:38` | `Range` on a string, with a number message; the recipe is never validated | remove the attribute | no |
| Style | `MaterialAndLookups.MaterialTypeDotDescription` doc (was Misleading) | `Products/MaterialAndLookups.cs:19` | Doc says `MaterialType.Name`, column is `Description` | fix the doc | column |
| Style | `ExternalParameterDefinition.ToRecord` doc | `Parameters/ExternalParameterDefinition.cs:108` | Says "SQL Operations" | fix the doc | no |
| Style | `CustomDataUpdaterRecord.CustomData108JhkGauge` doc "Maps To TBD"; `MaterialTypeDotId` doc | `Operations/CustomDataUpdaterRecord.cs` | Stale docs | fix the docs | columns |
| Style | `ExternalParameterDefinitionCache.CacheByDefinitionName` | `Caches/ExternalParameterDefinitionCache.cs:14` | Type name repeated | `ByDefinitionName` | no |
| Style | `ComponentCategoryType.PlaceHolder`; double names for 9 and 96 | `Fabrication/ComponentCategoryType.cs` | Casing; two names per value | `Placeholder`; one name per value | enum text |
| Style | `Trade.AllTrades` | `Fabrication/Trade.cs` | Type name repeated | `All` | stored number |
| Style | `weldLocationInitialism` vs `weldLocation` | `Fabrication/WeldLocationTools.cs:9`, `Connectors/EndPreparationTools.cs` | Same codes, two words | `weldLocationCode` | no |
| Style | `WeldLocationTools.ToTerm` | `Fabrication/WeldLocationTools.cs:41` | | `ToTerminologyTerm` | no |
| Style | `FabricationCustomData.TagNumberPrefix` | `Fabrication/FabricationCustomData.cs` | Weld and penetration tag prefix | `TagPrefix` | report text |
| Style | `GetCustomDataName(int index)` | `Fabrication/FabricationCustomDataNames.cs:6` | A custom data number | `customDataPoint` | no |
| Style | `BuildCsv(findings)`, `BuildScenarioSummary(findings)` | `Fabrication/ProductCodeCheckReport.cs:9,40` | Items are results | `results` | no |
| Style | `BuildRunText`, `BuildBranchText` | `Connectors/ConnectorSizeFormatter.cs` | Return `StringBuilder`; fix with bug B1 | `BuildRun`, `BuildBranch` returning string | no |
| Style | Definition-set names (`Jhk` prefix, overlapping sets) | `Definitions/*.cs` | | one prefix rule | no |
| Style | `ConnectorName.RunTwo` vs definitions `…Run2…` | `Connectors/ConnectorName.cs` | "Two" vs "2" | C# keeps "Two" | definition names |
| Style | `DataFiles` in `Kelly.Domain.Caches` | `Caches/DataFiles.cs:3` | A registry, not a cache | namespace `Kelly.Domain.Data` | no |
| Style | `CacheRows.Of` | `Caches/CacheRows.cs:9` | | `ReadListFrom` | no |
| Style | private `Name` in `DetailingPackage`, `LineNumber` | `Identifiers/*.cs` | Matched text | `MatchedText` | no |
| Style | `DataStore.FindGroupType` | `Data/DataStore.cs:56` | List is `GroupTypeIds` | `FindGroupTypeId` | no |
| Style | `ExternalParameterDefinition.DocumentBindings`, `ElementBindings` | `Parameters/ExternalParameterDefinition.cs:63,92` | One value each | singular on the class | columns |
| Style | `FilterRuleType.Greater`, `Less`, … | `Parameters/FilterRuleType.cs:15-23` | | `GreaterThan`, `LessThan`, … | check if stored |
| Style | `Color00..Color09` | `Parameters/FilterRules/*.cs` | Numbered | `ColorForDigit(int)` | no |
| Style | `FilterRuleModel`; "colour"/"color" in docs | `Parameters/FilterRules/*` | | `ColorFilterRule`; "color" | no |
| Style | `KeyboardShortcut.Shortcut` | `Pcf/KeyboardShortcut.cs:5` | Empty outer class | top-level `Shortcut` | no |
| Style | `VtfrSettings` public static mutable fields | `Pcf/VtfrSettings.cs:37-41` | | properties or `static readonly` | no |
| Style | `LayoutPointImportFailureSummary.NotIdCount` | `LayoutPoints/LayoutPointImportFailureSummary.cs:36` | | `InvalidIdCount` | no |
| Style | `LayoutPointIngredientRules` verbs | `LayoutPoints/LayoutPointIngredientRules.cs:14,23,38` | Three verb styles | `ToIdPrefix`, `ToIdIndex`, `ToRodLayerName` | no |
| Style | `LayoutPointFileNames.DefaultExport` | `LayoutPoints/LayoutPointFileNames.cs:12` | | `DefaultExportName` | no |
| Style | `IsTooLongToExport` / `IsTooLongToSave` | `LayoutPoints/LayoutPointStorage.cs:93`, `LayoutPointStorageTexts.cs:31` | Two rules for one 255 limit | one term after KD-3 | no |
| Style | `TypeBoundSharedParameter.IsReporting` | `Parameters/TypeBoundSharedParameter.cs:18` | | `IsReportingParameter` | no |
| Style | `TagSignatureNotMismatch` | `Signatures/TagSignatureNotMismatch.cs:3` | Double negative; rejects "MisMatch" | `RejectsMismatch…` | no |
| Style | `ViewFilterNames.IsNavisworksViewType` | `Views/ViewFilterNames.cs:20` | Tests for "Navis" | `IsNavisViewType` | **Serialized** "Navis" |
| Style | key `JhkLongDescriptionNEW` | `Spools/SpoolBillOfMaterialBuilder.cs:34` | Leftover "NEW" | `JhkLongDescription` | no |
| Style | `IsTaggable(.., allowUnHosted)` | `Supports/SupportTagNumbering.cs:12` | Casing | `allowUnhosted` | no |
| Style | `AnchorFractionDecimalSets` | `Supports/AnchorFractionDecimalSets.cs:3` | One set | `AnchorFractionDecimalSet` | no |
| Style | `Nouns` not `static`; `RoleSuperintendent` value "Superintendant" | `Vocabulary/Nouns.cs:3,110` | Typo in shown text | `static class`; "Superintendent" | **Shown** |
| Style | `Nouns.MethodParameter`, `LayoutControlPoint` values | `Vocabulary/Nouns.cs:60,36` | Name and value disagree | review | **Shown** |
| Style | `Names.DefinitionsInternal`, `ComponentData`, `JhkDetailingPkg`, `JhkSizeDia` | `Vocabulary/Names.cs` | Vague and abbreviated member names (263 callers for the class) | rename members only | **Serialized** values |
| Style | `Names.BoundToFamily` `A1..Se3`, same fields in `SuspendedSupportDefinitionSet` | `Vocabulary/Names.cs:71`, `Supports/SuspendedSupportDefinitionSet.cs:50` | Cryptic field names | name after meaning | **Serialized** values |
| Style | `ISpoolItem.JhkTotalLength`, `ShopCutLength` | `Spools/ISpoolItem.cs:47`, `Spools/SpoolItemRules.cs:36` | Feet in docs only | `…Feet` on C#-only names | `JhkTotalLength` is a parameter name |
| Style | signature vs hash wording | `Supports/SupportSignature.cs`, `SupportTagNumbering.cs` | Four words for the hash | "signature hash" | no |

## Dropped or downgraded

| Finding | Group | Why |
|---|---|---|
| Bug: `EndPreparationTools.GetFieldFitPreparation` returns "error" | G04 | Documented; the only caller (`EndPreparationTools` itself) checks `IsFieldFitWeldLocation` first; no outside callers |
| Bug: `RegexTools.ParseItemNumber` throws for null | G04 | Its one caller (Logic `SpoolItem.cs:44`) passes `ValueIfNull.String`, never null |
| Bug: `LayoutPointExportSelection.Summarize` count and ")" | G05 | Already filed as KD-1; the unmatched ")" is new detail for KD-1 |
| Bug: `SignatureState.NoSignatures` doc | G05 | Code is right, the enum doc is wrong: moved into the R3 rename |
| Bug: `[Range]` on `Ingredient01IdPrefix` | G05 | The recipe is never validated, so no effect: Style in R8 |
| Bug: `SignatureState.SchemaIssue` never produced | G05 | Dead value, not a bug: Style in R8 |
| Bug: `ModuleNumber.Create` vs `TryCompose` padding | G06 | Documented on both; `TryCompose` has no callers: Style (delete) in R8 |
| Bug: `ColoredSignatureTools.Compose` vs `SignatureTools.Compose` | G06 | Documented "recorded, not fixed"; matching is KD-7 |
| Bug: `MatchServicesToSystems` dead `Contains` | G06 | First pass checked it (documented); its new evidence is folded into bug B2 |
| Bug: `SuspendedSupportFamilyNames` `Contains` vs `BearerTypeTools` `StartsWith` | G06 | Documented as kept, not unified |
| Bug: `SpoolItemRules.TagValue` writes "Invalid Tag '…'" | G06 | Documented return, deliberate visible marker |
| `ColoredSignatureTools.Compose` vs `SignatureTools.Compose` Misleading | G06 | Downgraded to Vague: both names are true, the difference is documented |
| `MaterialTypeDotDescription` Misleading | G05 | Downgraded to Style: the name is right, only the doc is wrong |
| `ItemNumberFormat.ComposeOrClear` | G06 | Renamed today from `Format` in the first pass: restates that decision |
| `SupportTagNumbering.ResolveTag` | G06 | Renamed today from `NextTag`: restates that decision |
| `BearerType.Unknown` / "Default" / "None" | G06 | First-pass rename; the texts are kept for stored hashes (documented) |
| `ScopeType` in `Operations` namespace | G05 | No change proposed by the reader |
| `ProjectRecord.IsActive` / `IsBimLite` | G06 | Data columns, reader says keep |
| `Verbs`, `Adjectives`, `Adverbs` plural | G06 | Deliberate word lists, reader says keep |
| `IIdentifier.ValueAsHash` "20 callers" | G04 | Kept, but the 20 hits are declarations and assignments only: nothing reads it |
| `ModuleNumber.Create` "returns Empty" | G06 | Corrected: it returns `new ModuleNumber()`, not `Empty` |
