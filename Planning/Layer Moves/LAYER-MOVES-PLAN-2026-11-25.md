# Layer moves plan - 2026-11-25

The `dotnet-architecture-analysis` run of 2026-11-25 read the six Major Version 5 layer repositories, 1,250 source files in 16 scopes plus a duplication scope across all of them. 17 finders proposed moves, adversarial reviewers tried to refute each one, and the whole-file moves were compiled in scratch copies of their target layers (39 agents in all, read-only). Nothing in the repositories has changed yet.

## Summary

| | Count |
|---|---|
| Files read | 1,250 of 1,250 in scope (every file in one scope; the duplication scope reads across all) |
| Moves proposed | 161 |
| Rejected by review | 104 |
| Accepted (as proposed / modified) | 57 (40 / 17) |
| Whole-file moves that compiled in the probe | 12 of 12 probed (2 more go into Kelly-Revit and are not probed; #15 is a rewording in place) |
| Type and member extractions (not probed) | 44 |

Most of the accepted moves are small extractions: Revit-free arithmetic, rules and text left in Kelly-Revit-Logic or in the add-in's tools, and copies of a lower layer's helper. The largest group is nine WPF MVVM types that still sit in Kelly-Windows (seven value converters, `WindowBehaviors`, `EnumComboBoxItem`, plus `TrueToErrorBrushConverter`): the MVVM rule puts them with the Kelly-Revit code, so they move **up**, into Kelly-Revit-UI (shared through `ValueConverters.xaml` or used by four modules) or into the one Kelly-Revit tool that uses them.

## Decisions needed

1. **Upward MVVM moves (#48 to #54, #56, #57)**: nine public types leave Kelly-Windows (a breaking change in its Changelog), seven go into Kelly-Revit-UI and two into the Trade.All module. Every user was checked by grep: only Kelly-Revit-UI's `ValueConverters.xaml`, 18 Kelly-Revit XAML windows (`WindowBehaviors.KeepCentered`), `LayoutPointCsvImportView` and `SpoolManagerViewModel`. A Kelly-Domain test (`SimpleModelTests.EnumComboBoxItem_ComputesReadableName`) also uses `EnumComboBoxItem`; it moves with the type. `MatchColors` (Kelly-Windows Palettes) is left with no user outside tests; it stays and goes to the next dead-code round. **Recommended: do them.**
2. **`DataFileService` (#20) from Kelly-Revit-Logic to Kelly-Domain**: its constructor gains the Revit year and a definition validator, which `App.cs` passes in place of the `#if REVIT20xx` switch and `GetGroupTypeId`; its exception text names "Revit startup", which Kelly-Domain may not say, so the message would change. Medium risk, public API break. **Recommended: defer** (filed as a Backlog issue).
3. **Three small behaviour changes**: #11 (a Number view filter value with a non-breaking space around it would parse instead of failing, by using `InvariantNumberText.TryParseNumber`), #42 (`GetValueWithSingleQuotes` on an element gains the parameter overload's `HasValue` check), and #15 (Kelly-Windows' `ImageTools` warning says "Failed to decode ribbon icon", naming the add-in's ribbon in a Revit-free layer; reword it to "Failed to decode embedded image"). **Recommended: allow all three, as FIX packages.** Without it, #11 and #42 are dropped and #15 still gets reworded (a log line only).
4. **Confirm the plan.** Confirming also creates the Linear project `Layer Moves 2026-11-25` with 17 package issues: KW3 5, KD 4, KTRL5 4, KTRUI 2, KTR5 2 (plus one Backlog issue in KD for #20 if deferred).

Also from the review, noted and not changed: `VerticalSupportSize.TryReadInches` (#5) reads a plain number with `CultureInfo.CurrentCulture` (US-only add-in: not a fix); `SuspendedSupport`'s flat strap case reads a dimension named `TBD` (#31, looks unfinished); `TagLeader.UpdateLeaderPosition` (#9) gives NaN when the leader is horizontal or vertical (0/0). Each is kept exactly and characterized by a test.

## Decisions (answered 2026-11-25)

1. Upward MVVM moves: **do them.**
2. `DataFileService` (#20): **deferred**, filed as a Backlog issue in KD.
3. #11, #42 and #15: **allowed as FIX packages.** A fix never shares a package with a move, so #11 and #42 got their own packages (P3d, P3e).
4. **Plan confirmed**, with the Linear project and 18 package issues.

The Kelly-Revit repin breaks the 18 XAML windows and the two Trade.All users of the MVVM types at once, so those switches moved into Kelly-Revit's first package (P5a); the Assigner pane work is P5b.

## Work packages and implementation order

Bottom-up; Kelly-Windows-Data does not change. Each package is one commit; the first package of each layer absorbs the repin.

| Step | Package | Moves | Kind |
|---|---|---|---|
| Kelly-Windows | P1a-windows-floating-window-fit | #1, #2, #3: the Assigner pane's WPF and Win32 window-fit helper, renamed neutrally (`FloatingWindowFit`, `WindowBounds`), native calls beside `Kelly.Windows.Wpf.Native.NativeMethods` | MOVE |
| | P1b-windows-geometry | #8, #9, #10: elevation offset by alignment reference, tag leader elbow, tag position column | MOVE |
| | P1c-windows-text-files-measurements | #4, #5, #6, #7, #12, #13: order by saved keys, read inches, `StepTimingLog`, dimension value strings, read rows and delete, rows to `DataTable` | MOVE |
| | P1d-windows-image-tools-wording | #15 | FIX |
| | P1e-windows-remove-mvvm-types | source half of #48 to #54, #56, #57 (and `EnumExtensions.CreateComboBoxItems`) | MOVE (source) |
| Kelly-Domain | P2a-domain-switch | repin; `SimpleModelTests` drops the `EnumComboBoxItem` case; #5 source half; #19 `SizeSymbolPosition` to `Kelly.Domain.Products` | MOVE |
| | P2b-domain-fabrication-supports | #17, #18, #23, #24, #31, #32 | MOVE |
| | P2c-domain-layout-points-identifiers | #16, #22, #26, #27, #28 | MOVE |
| | P2d-domain-parameters-spools-views | #21, #25, #29, #30 | MOVE |
| Kelly-Revit-Logic | P3a-logic-source-switch | repin; source halves of #5 to #10, #12, #13, #19, #21 to #32; #14 | MOVE |
| | P3b-logic-shared-members | targets of #33 to #40, #45 | MOVE |
| | P3c-logic-deduplication | #41, #43, #44 | MOVE |
| | P3d-logic-view-filter-number-parse | #11 | FIX |
| | P3e-logic-single-quotes-has-value | #42 | FIX |
| Kelly-Revit-UI | P4a-ui-converters-and-behaviors | repin; targets of #48 to #54; #45 source half | MOVE |
| | P4b-ui-ribbon-and-checkbox-helpers | targets of #46, #47 | MOVE |
| Kelly-Revit | P5a-revit-source-switch | repin; targets of #56, #57; the 18 XAML windows repointed (#54); source halves of #17, #18, #39, #40, #47 | MOVE |
| | P5b-revit-assigner-pane | source halves of #1 to #4, #16, #33 to #38, #46; #55 | MOVE |

In-Revit tests: Kelly-Revit-Logic, Kelly-Revit-UI and Kelly-Revit each compile their in-Revit test project; the run executes them in Revit 2024 through `revit-test.sh` if Revit 2024 is closed and a licence is available, otherwise they are reported as compiled, not run.

## Kept on purpose

- `alltrade-acquired` and `domain-a` proposed nothing: the Arrange and Vicious tools already call Kelly-Revit-Logic for their database work, and Kelly-Domain's first half holds only Kelly concepts.
- `App.Caches` (eight `GetCache<T>` accessors) repeats one pattern but depends on the host's `ServiceProvider`, so it stays in the host.
- The Assigner pane's own colour brushes stay in the Trade.All module (#55 only removes the copies); Kelly-Revit-UI gets no new dictionary for one module.

## Rules baseline

`check-rules.pl` before any change: 0 Revit API uses in the Revit-free layers, 0 lower layers naming a higher one, 0 protected files outside Kelly-Revit beyond the 9 approved framework files, 0 namespace and folder mismatches; 126 `IExternalCommand` classes and 48 view or view model files in Kelly-Revit. Every layer built with 0 errors (Kelly-Revit in 2024).

## Moves by target layer

### Into Kelly-Windows

| # | From (repository:path) | Symbol | Granularity | To (folder) | Why | Risk | Probe | Package |
|---|---|---|---|---|---|---|---|---|
| 1 | Kelly-Revit:`modules/Trade.All/DockablePanes/Assigner/AssignerPaneFit.cs` | `AssignerPaneFit` | file | `src/Wpf` | Pure WPF and Win32 (FrameworkElement.Measure, PresentationSource, HwndSource, user32 calls): measures a panel's content and resizes the owning floating window. It has no Revit API reference and no Kelly meaning; the … | medium | compiled | P1a |
| 2 | Kelly-Revit:`modules/Trade.All/DockablePanes/Assigner/AssignerPaneNativeMethods.cs` | `AssignerPaneNativeMethods` | file | `src/Wpf/Native` | user32 P/Invoke declarations (GetAncestor, GetWindow, GetWindowRect, SetWindowPos) used only by the fit helper; Kelly-Windows already owns Wpf/Native/NativeMethods.cs, so the calls belong beside it. A separate file … | low | compiled | P1a |
| 3 | Kelly-Revit:`modules/Trade.All/DockablePanes/Assigner/AssignerPaneWindowBounds.cs` | `AssignerPaneWindowBounds` | file | `src/Wpf/Native` | A sequential-layout struct that mirrors Win32 RECT; no dependency at all. It is a P/Invoke interop struct, not a bound model. | low | compiled | P1a |
| 4 | Kelly-Revit:`modules/Trade.All/DockablePanes/Assigner/AssignerPaneViewModel.cs` | `AssignerPaneViewModel.ApplyOrder` | member | `src/Collections` | The ordering rule inside ApplyOrder is a pure sort of items by a saved key list: items whose key is saved come first in saved order, unsaved ones keep their current order after them, comparing keys ignoring case; … | low | not probed (extraction) | P1c |
| 5 | Kelly-Domain:`src/Supports/VerticalSupportSize.cs` | `VerticalSupportSize.TryReadInches` | member | `src/Measurements` | Generic length text reader with no Kelly meaning: a plain number or fraction is inches, otherwise it appends a double-quote and reads feet-inch text through FeetInchTools.TryParseDecimalFeet, then rejects NaN, infinity … | low | not probed (extraction) | P1c |
| 6 | Kelly-Revit-Logic:`src/Common/StepTimingLog.cs` | `StepTimingLog` | type | `src/Logging` | A stopwatch that records named steps and renders one line (Mark, ToLine) is generic and Revit-free. Only Write() depends on DevelopmentLog, whose path (C:\Projects\Revit\Application) encodes the add-in and must stay in … | low | not probed (extraction) | P1c |
| 7 | Kelly-Revit-Logic:`src/Connectors/ConnectorWrapper.cs` | `ConnectorWrapper.SetDimensionValueString` | member | `src/Measurements` | The method touches only the Dimensions list of DimensionModel (a Kelly-Windows type): it sets each ValueString from ValueFeet with ConvertDecimalFeetToFractionalFormat(RoundAmount.OneSixteenth, … | low | not probed (extraction) | P1c |
| 8 | Kelly-Revit-Logic:`src/Fabrication/FabricationPartExtensions.cs` | `FabricationPartExtensions.SetElevationByAlignmentReference` | member | `src/Geometry` | The arithmetic that turns a desired elevation into the stored offset is Revit-free: Top = desired - half height - insulation, Middle = desired, Bottom = desired + half height + insulation. The same rule is written … | low | not probed (extraction) | P1b |
| 9 | Kelly-Revit-Logic:`src/Arrangement/TagLeader.cs` | `TagLeader.UpdateLeaderPosition` | member | `src/Geometry` | The elbow offset is pure planar math on the leader end and tag centre: ab = end - centre, sign of ab.X*ab.Y, delta X = ab.X - ab.Y * tan(sign * pi / 4), elbow = centre + delta. Kelly-Windows Geometry already holds the … | low | not probed (extraction) | P1b |
| 10 | Kelly-Revit-Logic:`src/Arrangement/TagDistributor.cs` | `TagDistributor.CreateTagPositionPoints` | member | `src/Geometry` | Computing the column of candidate tag positions is Revit-free arithmetic: step = tallest tag * 1.2, count = round(height / step), then 2 * count positions at multiples of the step from the crop box bottom, at the left … | low | not probed (extraction) | P1b |
| 11 | Kelly-Revit-Logic:`src/Views/ViewFilterVisibility.cs` | `ViewFilterVisibility.CreateFilterRule` | member | `src/Text` | double.TryParse(FilterValue, NumberStyles.Float, InvariantCulture) re-implements InvariantNumberText.TryParseNumber, which Logic already uses in ParameterTextExtensions.WriteText. The only difference is an empty or … | low | not probed (extraction) | P3d |
| 12 | Kelly-Revit-Logic:`src/Views/ScheduleExportService.cs` | `ScheduleExportService.ExportToRows` | member | `src/Files` | After the Revit export, "read the delimited text file into rows, then delete the temporary file in a finally block" is file work with no Revit type; DelimitedTextTools already reads rows. | low | not probed (extraction) | P1c |
| 13 | Kelly-Revit-Logic:`src/Mep/PointToPipeReader.cs` | `PointToPipeReader.ReadCsvTable` | member | `src/Files` | Building a DataTable from rows of fields (columns = longest row, one DataRow per record) is generic and Revit-free. The CsvTable.ReadFields call (file read) stays in Logic and its rows are passed in, so Windows takes no … | low | not probed (extraction) | P1c |
| 14 | Kelly-Revit-Logic:`src/Parameters/ParameterValueExtensions.cs` | `ParameterValueExtensions.GetThicknessInInches` | member | `src/Measurements` | `GetThicknessInFeet() * 12` re-implements DoubleExtensions.FeetToInches (Windows keeps the inches-per-foot constant). Duplicate of an existing lower-layer helper; no new Windows member needed. | low | not probed (extraction) | P3a |
| 15 | Kelly-Windows:`src/Wpf/ImageTools.cs` | `ImageTools` | file | `src/Wpf` | Rule 1: the Revit-free layer encodes ribbon behaviour in its warning text ('Failed to decode ribbon icon'). The only consumer is RibbonExtensions in Kelly-Revit-UI (item.Image = ImageTools.LoadEmbeddedImage(...16.png)). … | low | compiled | P1d |

### Into Kelly-Domain

| # | From (repository:path) | Symbol | Granularity | To (folder) | Why | Risk | Probe | Package |
|---|---|---|---|---|---|---|---|---|
| 16 | Kelly-Revit:`modules/Trade.All/DockablePanes/Assigner/AssignerContexts.cs` | `AssignerContexts.DetailingPackage and AssignerContexts.LineNumber: new value rule text …` | member | `src/Identifiers` | The strings 'Use at least 4 characters, starting and ending with a letter or digit' (Detailing Package) and 'Use at least 4 letters, digits, '.' or '-', starting and ending with a letter or digit, with no two marks … | low | not probed (extraction) | P2c |
| 17 | Kelly-Revit:`modules/Trade.Contenter/Commands/FabricationPartProductCodeCheckReport/FabricationPartProductCodeCheckReportCommand.cs` | `FabricationPartProductCodeCheckReportCommand.WriteReport (summary text assembly)` | member | `src/Fabrication` | WriteReport builds the two-sentence summary ('N of the M Fabrication Parts ... failed the Product Code and Component Id check', blank line, scenario summary) with a StringBuilder. It is pure text from findings and a … | low | not probed (extraction) | P2b |
| 18 | Kelly-Revit:`modules/Trade.Contenter/Commands/FabricationCustomDataUpdaterV2/FabricationCustomDataUpdaterCommandV2.cs` | `FabricationCustomDataUpdaterCommandV2.ExecuteUpdate (custom data point presence rule)` | member | `src/Fabrication` | customDataPointStatuses.All(status => status.Item1) is the rule 'every required custom data point exists on the part'. The statuses come from Revit (GetCustomDataPointStatuses) but the rule and the status text … | low | not probed (extraction) | P2b |
| 19 | Kelly-Domain:`src/Views/SizeSymbolPosition.cs` | `SizeSymbolPosition` | file | `src/Products` | Misfiled inside Domain. The enum describes where a size symbol sits in a connector size string (separator, unit, diameter, rectangular, oval suffix). It is the Position of Products/SizeSymbol and is used by … | low | compiled | P2a |
| 20 | Kelly-Revit-Logic:`src/Caches/DataFileService.cs` | `DataFileService` | type | `src/Caches` | The service only loads a DataStore and builds the Domain caches (ComponentCache, ExternalParameterDefinitionCache, ProductCache, ProductRangeCache, ServiceCache, SystemCache, TerminologyCache, all already in … | medium | not probed (extraction) | deferred |
| 21 | Kelly-Revit-Logic:`src/Documents/DocumentExtensionsJhk.cs` | `DocumentExtensions.GetMissingSharedParameterNames` | member | `src/Parameters` | The first half of the method is a Kelly rule over ExternalParameterDefinition (Domain): ignore deprecated definitions and those with no bound categories, then order by SortOrderPrimary and SortOrderSecondary. It needs … | low | not probed (extraction) | P2d |
| 22 | Kelly-Revit-Logic:`src/Caches/NumberedDocumentCache.cs` | `NumberedDocumentCache<T>.GetData` | member | `src/Identifiers` | After the elements are read, the rest of GetData is Revit-free: parse each text with TryParse, keep distinct values, add the parsed default when none were found, and order by the sort key. It sits beside the Domain … | low | not probed (extraction) | P2c |
| 23 | Kelly-Revit-Logic:`src/Fabrication/FabricationDatabaseTools.cs` | `FabricationDatabaseTools.PlaceRepeatedHangers` | member | `src/Supports` | The distance stepping inside the do-while (first step is the near-end interval when the straight length equals the residual, later steps are the repeat interval, each reducing the residual) is Revit-free arithmetic that … | low | not probed (extraction) | P2b |
| 24 | Kelly-Revit-Logic:`src/Fabrication/StraightLengthPart.cs` | `StraightLengthPart.GetEndConnectorNames` | member | `src/Fabrication` | Choosing which two end connectors to name is a Kelly rule over their fabrication indexes: the lowest index below 4 (4 when none), then that index and the next one. It needs only integers. The connector reads and … | low | not probed (extraction) | P2b |
| 25 | Kelly-Revit-Logic:`src/Views/ViewFilterSets.cs` | `ViewFilterSets.ApplyBillOfMaterialTypeFieldFilter` | member | `src/Views` | The filter names "BOM Equals Field", "BOM Equals Module" and "Field Trim Is Greater Than Zero" are naming constants sitting inline in Logic while ViewFilterNames already holds the other filter names. | low | not probed (extraction) | P2d |
| 26 | Kelly-Revit-Logic:`src/LayoutPoints/LayoutPointTools.cs` | `LayoutPointTools.UpdateSavedCoordinatesCore` | member | `src/LayoutPoints` | Inside the loop, matching saved layout points by id against live coordinates, replacing coordinates and counting the changes is pure LayoutPoint (Domain struct) logic. Only reading the saved points from the element and … | low | not probed (extraction) | P2c |
| 27 | Kelly-Revit-Logic:`src/LayoutPoints/LayoutPointTools.cs` | `LayoutPointTools.WriteCsv` | member | `src/LayoutPoints` | The row projection new object[]{Id.Value, X, Y, Z, Description, Layer} pairs with LayoutPointCsvFormat.ColumnNames (already Domain) and must keep their order; both halves of the file format belong together. The file … | low | not probed (extraction) | P2c |
| 28 | Kelly-Revit-Logic:`src/LayoutPoints/LayoutPointTools.cs` | `LayoutPointTools.SummarizeImportFailures` | member | `src/LayoutPoints` | Counting rows by failure class (invalid id, duplicate, no family) and listing the non-id names is pure logic; the result type LayoutPointImportFailureSummary is already Domain. The Logic overload only projects each … | low | not probed (extraction) | P2c |
| 29 | Kelly-Revit-Logic:`src/Spools/ModuleItemizeRules.cs` | `ModuleItemizeRules.CanItemizeComponents` | member | `src/Spools` | The overload CanItemizeComponents(int selectedCount, bool anySelectedHasErrors) is a Revit-free Kelly business rule (some selected, none with errors); only the overload over Module needs the Logic type. The file's whole … | low | not probed (extraction) | P2d |
| 30 | Kelly-Revit-Logic:`src/Spools/SpoolItem.cs` | `SpoolItem.IsSpoolableElement` | member | `src/Spools` | The report text and rule composition (invalid product range, null category, not a spoolable category, not a parent category; Element Id header inserted when not spoolable) are Revit-free once the facts are passed as … | low | not probed (extraction) | P2d |
| 31 | Kelly-Revit-Logic:`src/Supports/SuspendedSupport.cs` | `SuspendedSupport.SetRodLengthForZStrapHanger` | member | `src/Supports` | Rod length by bearer type: Length A / Length B by rod index, Rod Length, and the Z strap sum Top Length + Supported Depth + Bottom Extension + Strut Extension. BearerTypeTools.GetBearerSize in Domain already takes a … | low | not probed (extraction) | P2b |
| 32 | Kelly-Revit-Logic:`src/Updaters/CustomDataUpdateEvaluator.cs` | `CustomDataUpdateEvaluator.LoadPartOrReportError` | member | `src/Operations` | Three checks in LoadPartOrReportError use only Domain types and produce Kelly error text: the ComponentId mismatch between the shared parameter and custom data 105, the component lookup in componentsById with the Null … | low | not probed (extraction) | P2b |

### Into Kelly-Revit-Logic

| # | From (repository:path) | Symbol | Granularity | To (folder) | Why | Risk | Probe | Package |
|---|---|---|---|---|---|---|---|---|
| 33 | Kelly-Revit:`modules/Trade.All/Commands/Assigners/AssignerViewFilterCommand.cs` | `AssignerViewFilterCommand.Execute` | member | `src/Views` | Execute builds a ViewFilterVisibility and sets its five properties (FilterDomain, FilterValue, Action, FilterRuleType from FilterRuleTypeOf(Action)) before ApplyOrCreateViewFilter. The same construct-and-fill sequence … | low | not probed (extraction) | P3b |
| 34 | Kelly-Revit:`modules/Trade.All/DockablePanes/Assigner/AssignerRequestHandler.cs` | `AssignerRequestHandler.ApplyViewFilter` | member | `src/Views` | The tail of ApplyViewFilter (new ViewFilterVisibility with the definition name, then FilterDomain, FilterValue, Action and the rule from FilterOf, then ApplyOrCreateViewFilter) is a second copy of … | low | not probed (extraction) | P3b |
| 35 | Kelly-Revit:`modules/Trade.All/Commands/Assigners/SpoolNumberContext/ValueAssign/SpoolNumberAssignerValueSetCommand.cs` | `SpoolNumberAssignerValueSetCommand.Execute` | member | `src/Spools` | Execute reads the selection's spoolable elements (GetSpoolableElements(Selection, true, false)), stops when there are none, and calls Document.AddElementsToSpool. The same three steps are in AssignerContexts.AddToSpool … | low | not probed (extraction) | P3b |
| 36 | Kelly-Revit:`modules/Trade.All/Commands/Assigners/SpoolNumberContext/ValueClear/SpoolNumberAssignerValueClearCommand.cs` | `SpoolNumberAssignerValueClearCommand.Execute` | member | `src/Spools` | Mirror of the Value Set command: spoolable selection, empty check, Document.RemoveElementsFromSpool. Same copy exists in AssignerContexts.RemoveFromSpool. One Logic member (TryRemoveSelectionFromSpool) owns it. | low | not probed (extraction) | P3b |
| 37 | Kelly-Revit:`modules/Trade.All/DockablePanes/Assigner/AssignerContexts.cs` | `AssignerContexts.AddToSpool` | member | `src/Spools` | Private copy of the Spool Number Value Set command's selection flow (GetSpoolableElements, empty check, AddElementsToSpool), differing only in the messages. Replace with a call to the shared Logic member; the say … | low | not probed (extraction) | P3b |
| 38 | Kelly-Revit:`modules/Trade.All/DockablePanes/Assigner/AssignerContexts.cs` | `AssignerContexts.RemoveFromSpool` | member | `src/Spools` | Private copy of the Spool Number Value Clear command's flow (selection, empty check, RemoveElementsFromSpool); only the HasContent check and the messages are pane-specific and stay. | low | not probed (extraction) | P3b |
| 39 | Kelly-Revit:`modules/Trade.All/Commands/Layout/LayoutPointImport/LayoutPointCsvImportViewModel.cs` | `LayoutPointCsvImportViewModel.SetPointType` | member | `src/LayoutPoints` | The loop inside SetPointType is not presentation: it maps the clicked button text to a layout point family name (Domain LayoutPointFamilies.TryGetFamilyName), looks up the FamilySymbol … | low | not probed (extraction) | P3b |
| 40 | Kelly-Revit:`modules/Trade.All/Commands/DataReload/AllDataReloadCommand.cs` | `AllDataReloadCommand.Execute` | member | `src/Caches` | The expression DataFileLoader.Load(dataFileService, KellyDirectories.GetOrCreateApplicationDataDirectory().FullName) is written twice (App.OnStartup and this command). Both DataFileLoader (src/Caches) and … | low | not probed (extraction) | P3b |
| 41 | Kelly-Revit-Logic:`src/Connectors/ConnectorTools.cs` | `ConnectorTools.GetConnectors(Element, ConnectorType)` | member | `src/Elements` | Re-implements ElementExtensions.GetConnectors(this Element) (Category null check, GetConnectorSetIterator null check, iterator.GetConnectors()) and then filters by ConnectorType. It can be Validate, then … | low | not probed (extraction) | P3c |
| 42 | Kelly-Revit-Logic:`src/Elements/ElementDataExtensions.cs` | `ElementDataExtensions.GetValueWithSingleQuotes(Element, BuiltInParameter, string)` | member | `src/Parameters` | Re-implements ParameterExtensions.GetValueWithSingleQuotes(Parameter, string): read AsString, return default when it has no content, otherwise DoubleQuoteToTwoSingleQuotes. The element overload can read the parameter … | low | not probed (extraction) | P3e |
| 43 | Kelly-Revit-Logic:`src/Parameters/BuiltInParameterExtensions.cs` | `BuiltInParameterExtensions.CreateFilterRule` | member | `src/Parameters` | The text-rule switch (EndsWith, Contains, Equals, NotEquals to ParameterFilterRuleFactory.Create*Rule, default null) is repeated line for line in SharedParameterElementExtensions.CreateFilterRule(SharedParameterElement, … | low | not probed (extraction) | P3c |
| 44 | Kelly-Revit-Logic:`src/Updaters/Configurations/Auto/DetailingPhaseAutoUpdaterConfiguration.cs` | `DetailingPhaseAutoUpdaterConfiguration.DetailingPhaseAutoUpdaterConfiguration` | member | `src/Updaters/Configurations` | ChangeType.ConcatenateChangeTypes(Element.GetChangeTypeElementAddition(), Element.GetChangeTypeAny()) is repeated verbatim in four configurations (DetailingPhase, EndPreparation, FabricationPartData, LayoutDiscipline); … | low | not probed (extraction) | P3c |
| 45 | Kelly-Revit-UI:`src/Mvvm/ViewModel.cs` | `ViewModel.ElementsInDocument/ElementsInSelection/ElementsInView (element id set building)` | member | `src/Elements` | The three private setters each build a HashSet<ElementId> from the element list with new HashSet<ElementId>(value.Select(e => e.Id)). Collecting the ids of elements is Revit database work with no UI dependency and is … | low | not probed (extraction) | P3b |

### Into Kelly-Revit-UI

| # | From (repository:path) | Symbol | Granularity | To (folder) | Why | Risk | Probe | Package |
|---|---|---|---|---|---|---|---|---|
| 46 | Kelly-Revit:`modules/Trade.All/Commands/Assigners/CommonAutoAssignerTools.cs` | `CommonAutoAssignerTools.ResetIcon` | member | `src/Ribbon` | The same three-step ribbon operation, RibbonTabName.Tools.FindItemOrContainerByName(name, uiApplication) then SetPowerIcons(bool), is written in two places in this scope (CommonAutoAssignerTools.ResetIcon with false, … | low | not probed (extraction) | P4b |
| 47 | Kelly-Revit:`modules/Trade.All/Commands/Layout/LayoutPointExport/LayoutPointCsvExportView.xaml.cs` | `LayoutPointCsvExportView.CheckAllNoneCheckbox_CheckedChanged / ResetColumnsButton_Click / …` | member | `src/Controls` | The same loop, group box.ChildrenOfType<CheckBox>() then checkbox.IsChecked = value, is written five times in this view (CheckAllNoneCheckbox_CheckedChanged, ResetColumnsButton_Click, ResetFiltersButton_Click, plus the … | low | not probed (extraction) | P4b |
| 48 | Kelly-Windows:`src/Common/NonEmptyTextToCautionBrushConverter.cs` | `NonEmptyTextToCautionBrushConverter` | file | `src/Converters` (upward) | A WPF value converter is an MVVM type (rule 2: converters belong with the Kelly-Revit code, never in a lower layer). It is used only by Kelly-Revit-UI's ValueConverters.xaml (key FlagExists); nothing in Windows or below … | medium | compiled | P4a |
| 49 | Kelly-Windows:`src/Common/PositiveNumberToYConverter.cs` | `PositiveNumberToYConverter` | file | `src/Converters` (upward) | WPF value converter (MVVM type, rule 2), used only by Kelly-Revit-UI's ValueConverters.xaml (key PositiveNumberToYes); nothing at or below Windows uses it. | medium | compiled | P4a |
| 50 | Kelly-Windows:`src/Palettes/MatchResultColorConverter.cs` | `MatchResultColorConverter` | file | `src/Converters` (upward) | WPF value converter (MVVM type, rule 2), used only by Kelly-Revit-UI's ValueConverters.xaml (key NameQualityCellColor; also used in Kelly-Revit-v5 SpoolManagerView and ModuleManageView through that key). It reads … | medium | compiled | P4a |
| 51 | Kelly-Windows:`src/Measurements/ToFeetInchAndFractionConverter.cs` | `ToFeetInchAndFractionConverter` | file | `src/Converters` (upward) | WPF value converter (MVVM type, rule 2), marked [Obsolete], used only by Kelly-Revit-UI's ValueConverters.xaml (key ToFeetInchAndFraction). It calls the public FeetInchTools extension that stays in Windows. If the key … | medium | compiled | P4a |
| 52 | Kelly-Windows:`src/Measurements/ToInchAndFractionConverter.cs` | `ToInchAndFractionConverter` | file | `src/Converters` (upward) | WPF value converter (MVVM type, rule 2), marked [Obsolete], used only by Kelly-Revit-UI's ValueConverters.xaml (key ToInchAndFraction). | medium | compiled | P4a |
| 53 | Kelly-Windows:`src/Measurements/ToPoundFormatConverter.cs` | `ToPoundFormatConverter` | file | `src/Converters` (upward) | WPF value converter (MVVM type, rule 2), used only by Kelly-Revit-UI's ValueConverters.xaml (key ToPoundFormat; Kelly-Revit-v5 SpoolManagerView uses the key). Its formatting call RoundToDecimalPlaces is public in … | medium | compiled | P4a |
| 54 | Kelly-Windows:`src/Wpf/WindowBehaviors.cs` | `WindowBehaviors` | file | `src/Behaviors` (upward) | An attached behaviour is an MVVM type (rule 2: behaviours stay with the Kelly-Revit code). Its only consumers are 18 Kelly-Revit XAML windows in four modules (attached property KeepCentered), so it is shared across … | medium | compiled | P4a |

### Into Kelly-Revit

| # | From (repository:path) | Symbol | Granularity | To (folder) | Why | Risk | Probe | Package |
|---|---|---|---|---|---|---|---|---|
| 55 | Kelly-Revit:`modules/Trade.All/DockablePanes/Assigner/AssignerPaneIcons.xaml` | `AssignerPaneIcons.xaml, AssignerPaneStyles.xaml and AssignerBPanel.xaml brush colours …` | member | `modules/Trade.All/DockablePanes/Assigner` | Colour tables repeated in XAML: #016043 (accent) in AssignerPaneIcons and AssignerBPanel, #DC3545 (destructive red) in AssignerPaneIcons, AssignerPaneStyles (twice) and AssignerBPanel, #2F2F2F (ink) in … | low | not probed (extraction) | P5b |
| 56 | Kelly-Windows:`src/Palettes/TrueToErrorBrushConverter.cs` | `TrueToErrorBrushConverter` | file | `modules/Trade.All/Commands/Layout/LayoutPointImport` (upward) | WPF value converter (MVVM type, rule 2: converters stay in Kelly-Revit). Its only non-test user is LayoutPointCsvImportView.xaml.cs (Converter = new TrueToErrorBrushConverter()), so it is specific to one tool. Nothing … | low | not probed | P5a |
| 57 | Kelly-Windows:`src/Wpf/EnumComboBoxItem.cs` | `EnumComboBoxItem<TEnum>` | type | `modules/Trade.All/Commands/Spools/SpoolManager` (upward) | A combo-box item the view model binds to (a bound model, MVVM type, rule 2). Its only non-test user is SpoolManagerViewModel (the BillOfMaterialTypes list, built by EnumExtensions.CreateComboBoxItems). Nothing else in … | medium | not probed (extraction) | P5a |

## Counts by target

| Target | From | Moves |
|---|---|---|
| Kelly-Windows | Kelly-Windows | 1 |
| Kelly-Windows | Kelly-Domain | 1 |
| Kelly-Windows | Kelly-Revit-Logic | 9 |
| Kelly-Windows | Kelly-Revit | 4 |
| Kelly-Domain | Kelly-Domain | 1 |
| Kelly-Domain | Kelly-Revit-Logic | 13 |
| Kelly-Domain | Kelly-Revit | 3 |
| Kelly-Revit-Logic | Kelly-Revit-Logic | 4 |
| Kelly-Revit-Logic | Kelly-Revit-UI | 1 |
| Kelly-Revit-Logic | Kelly-Revit | 8 |
| Kelly-Revit-UI | Kelly-Windows | 7 |
| Kelly-Revit-UI | Kelly-Revit | 2 |
| Kelly-Revit | Kelly-Windows | 2 |
| Kelly-Revit | Kelly-Revit | 1 |

| Target | low | medium | high |
|---|---|---|---|
| Kelly-Windows | 14 | 1 | 0 |
| Kelly-Domain | 16 | 1 | 0 |
| Kelly-Revit-Logic | 13 | 0 | 0 |
| Kelly-Revit-UI | 2 | 7 | 0 |
| Kelly-Revit | 2 | 1 | 0 |

## Rejected (and why)


**alltrade-assigners-a** (3)

- `modules/Trade.All/Commands/Assigners/AssignerAutoAssignToggleCommand.cs#AssignerAutoAssignToggleCommand<TConfi …` → Kelly-Revit-Logic: ShouldTurnOn(owner, isEnabled) => owner is not null // !isEnabled only works out the ribbon toggle button's next state: it inverts the button's on or off state, and that state is read from who owns the selection plus the updater …
- `modules/Trade.All/Commands/Assigners/AssignerAutoAssignToggleCommand.cs#AssignerAutoAssignToggleCommand<TConfi …` → Kelly-Revit-Logic: RefusalMessage returns the text of the command's own user prompt ('Choose a ... in the ribbon before turning its auto-assign on...'). The text is about the ribbon UI and is shown through UserPrompt.Show by the same Execute. …
- `modules/Trade.All/Commands/Assigners/AssignerSelectorResetCommand.cs#AssignerSelectorResetCommand.Execute …` → Kelly-Revit-Logic: The 'OwnerOf(Selection) is null ? disable : leave' choice decides which reset steps this ribbon command runs (KTR5-4826), and it has one caller. Moving it onto AutoUpdaterService would give a generic updater-control service …

**alltrade-assigners-b** (6)

- `modules/Trade.All/Commands/Assigners/ServiceContext/ComboBox/ServiceComboBoxEventHandler.cs#ServiceComboBoxEve …` → Kelly-Revit-UI: Not a view, view model or model, so rule 6's 'whatever its size' does not apply. The case-insensitive item match is used only by this one tool's handler (placement table: one-tool RevitAPIUI code stays in its module). The claimed …
- `modules/Trade.All/DockablePanes/Assigner/AssignerAddedContextUpdater.cs#AssignerAddedContextUpdater` → Kelly-Revit-Logic: Its own remarks record a maintainer decision of 2026-11-17 that this updater 'lives with the pane, since it only serves the pane's added rows'; overriding that needs the user, not a review. It also carries the pane's identity …
- `modules/Trade.All/DockablePanes/DockablePaneToggler.cs#DockablePaneToggler` → Kelly-Revit-UI: Only one caller in all six repositories (AssignerBDockablePaneToggleCommand); pane A does not use it and no other module has a dockable pane. The placement table sends RevitAPIUI code to Kelly-Revit-UI only when it is framework …
- `modules/Trade.All/DockablePanes/DockablePaneFirstShow.cs#DockablePaneFirstShow` → Kelly-Revit-UI: Same as DockablePaneToggler: one registration site (AssignerBDockablePane.Register), no second pane in any module, and the docs are pane-B and maintainer-request specific. One-tool RevitAPIUI code stays in its module until a …
- `modules/Trade.All/DockablePanes/Assigner/AssignerRequestDispatcher.cs#AssignerRequestDispatcher.Post(Action<UI …` → Kelly-Revit-UI: The two queues do not share their semantics: DocumentRequestQueue owns its ExternalEvent (created in the constructor), is disposable, snapshots and clears the whole queue before running, and drops everything with a prompt when …
- `modules/Trade.All/DockablePanes/Assigner/AssignerContexts.cs#AssignerContexts.SpoolNumber and …` → Kelly-Domain: The rule texts 'Use [line number]-[category]-[sequence above 0]' and 'Use [prefix]-MOD-[sequence above 0]' appear only in the Assigner pane's hints and its tests. They are user-facing wording for one tool (presentation), not a …

**alltrade-ribbon** (6)

- `modules/Trade.All/RibbonItems/PushButtons/ExternalCommandAvailability/IsElementSelectableViewCommandEnabler.cs …` → Kelly-Revit-UI: Churn, not a gain. The shared part across the four leaves (three in Trade.All, IsTaggableViewCommandEnabler in Trade.Duct) is only the expression 'uiDocument.Document.ActiveView'; the null-document handling is already in …
- `modules/Trade.All/RibbonItems/PushButtons/ExternalCommandAvailability/IsLayoutPointViewCommandEnabler.cs#IsLay …` → Kelly-Revit-UI: Depends on the rejected ActiveViewCommandAvailability base. The body is 'uiDocument.Document.ActiveView.IsLayoutPointView()'. The rule already lives in Kelly-Revit-Logic ViewExtensions, and the leaf would still need its own …
- `modules/Trade.All/RibbonItems/PushButtons/ExternalCommandAvailability/IsViewFilterEligibleCommandEnabler.cs#Is …` → Kelly-Revit-UI: Depends on the rejected ActiveViewCommandAvailability base. The body is one line, 'uiDocument.Document.ActiveView.IsViewFilterEligible()', and the rule is already in Kelly-Revit-Logic ViewExtensions. The number of buttons that …
- `modules/Trade.All/RibbonItems/PushButtons/ExternalCommandAvailability/IsSingleElementSelectedCommandEnabler.cs …` → Kelly-Revit-UI: There is no duplication: the only 'GetElementIds().Count == 1' availability check in all modules is this one. The only other single-selection test, in ViciousInstanceRotateMoveCommand, is command logic, not availability. The …
- `modules/Trade.All/RibbonItems/PushButtons/ExternalCommandAvailability/NeverAvailableCommandEnabler.cs#NeverAva …` → Kelly-Revit-UI: There is a single copy: no other module (Pipe, Duct, Contenter, Manager, Developer) declares a fixed-false availability class. The body is 'return false', and under rule 4 the sealed leaf must stay in Trade.All anyway, so the …
- `modules/Trade.All/RibbonItems/RibbonComboBoxSelections.cs#RibbonComboBoxSelections.GetComboBoxCurrent` → Kelly-Revit-UI: A private one-line wrapper, 'settings.GetComboBox()?.Current', called only by the six GetCurrentItemTextOf* methods in the same file. No other module or file reads a combo box's Current through IRibbonComboBoxSettings: …

**alltrade-tools-a** (1)

- `modules/Trade.All/Commands/Layout/LayoutPointExport/LayoutPointCsvExportView.xaml.cs#LayoutPointCsvExportView. …` → Kelly-Revit-UI: Refuted as presentation that only one tool uses: SumColumnGroupWidth sums Telerik RadGridView column ActualWidth solely to grow or shrink the window when a column group is shown or hidden (window sizing, UI state). Grep of …

**alltrade-tools-b** (3)

- `modules/Trade.All/Commands/Updaters/UpdaterAuto/StateReport/AutoUpdaterStateReportCommand.cs#AutoUpdaterStateR …` → Kelly-Revit-Logic: The command has a single caller of the three Write*UpdaterReport members (grep of all six repositories finds no other sequence), so there is no duplication to remove. The three report writers already live in Kelly-Revit-Logic …
- `modules/Trade.All/Commands/Supports/SuspendedSupportManage/SuspendedSupportManageView.xaml.cs#SuspendedSupport …` → Kelly-Domain: The handler builds Telerik grid filter conditions on the displayed SignatureStatus text from check box states; which display values a 'Show Not Signature Match' check box selects is the meaning of that filter control, not a …
- `modules/Trade.All/Commands/Spools/SpoolCreate/SpoolCreateViewModel.cs#SpoolCreateViewModel.SuggestNextSpoolSeq …` → Kelly-Domain: The spool numbering rules are already in Kelly-Domain: SpoolNumber.GetNextSequence finds the next free sequence and SpoolNumber.FormatSequence formats it, and SpoolNumber's XML docs already say callers format the result with …

**contenter-manager-developer** (6)

- `modules/Trade.Contenter/Commands/FabricationPartProductCodeCheckReport/FabricationPartProductCodeCheckReportCo …` → Kelly-Revit-Logic: The per-part check is already in Logic (ProductCodeChecks.CreateResult). What is left is orchestration: a progress window wrapped around each item (ItemBegin/ItemEnd/Finish), plus a one-comparison filter on a Kelly-Domain result …
- `modules/Trade.Contenter/Commands/FabricationCustomDataUpdaterV2/FabricationCustomDataUpdaterCommandV2.cs#Fabri …` → Kelly-Revit-Logic: CustomDataUpdateEvaluator is designed and documented as the per-part steps, with the command in charge of confirmation, the operation and reporting. The two loops are that orchestration. The write loop is woven into the …
- `modules/Trade.Developer/Commands/PlaceFieldTrimEndMarker/FieldTrimEndMarkCommand.cs#FieldTrimEndMarkCommand.Ex …` → Kelly-Revit-Logic: Each transaction wraps a single call that already lives in Logic (PlaceFieldTrimEndMarker, DeleteMarkers). FieldTrimMarkerTools is designed to run inside the caller's transaction. The place transaction sits inside the pick loop, …
- `modules/Trade.Developer/Commands/ProductRangeSchedules/ProductRangeSchedulesCommand.cs#ProductRangeSchedulesCo …` → Kelly-Revit-Logic: The existing Logic overload CreateOrRebuildProductRangeSchedules(Document, IEnumerable<CategoryTypeRecord>) takes its records explicitly, which is the testable seam. A Document-only overload that reads the DataFiles.Store static …
- `modules/Trade.Developer/Commands/BuiltInParameterGroupIdsCopy/BuiltInParameterGroupIdsCopyCommand.cs#BuiltInPa …` → Kelly-Revit-Logic: A four-line loop in a Developer diagnostic formats Autodesk's ParameterUtils.GetAllBuiltInGroups() for the clipboard. Nothing else in the six repositories calls GetAllBuiltInGroups, so the member would have no reuse. The proposal …
- `modules/Trade.Contenter/Commands/FabricationPartVariousReport/FabricationHangerDetailLogCommand.cs#Fabrication …` → Kelly-Revit-Logic: The claimed duplication does not hold. FabricationDuctworkCollector uses GetElementsByScopeAndFilter with ElementFilterTools.Instances and includeAssemblyMembers true. The command goes through the Kelly-Revit-UI …

**cross-repo-duplication** (24)

- `modules/Trade.All/Commands/Layout/LayoutPointExport/LayoutPointCsvExportViewModel.cs#LayoutPointCsvExportViewM …` → Kelly-Revit-UI: Read both copies (export line 370, import line 316): the body is the ICommand handler casting its parameter to RadComboBox, reading SelectedValue and calling Document.SetActiveProjectLocation, which already lives once in …
- `modules/Trade.All/Commands/Layout/LayoutPointImport/LayoutPointCsvImportViewModel.cs#LayoutPointCsvImportViewM …` → Kelly-Revit-UI: This is the same presentation handler as the export copy (cast the command parameter, forward to the existing Logic DocumentExtensions.SetActiveProjectLocation). Its prerequisite move is rejected, and there is no non-presentation …
- `modules/Trade.All/Commands/ScheduleExport/ViewScheduleExportToXlsxFile/ViewScheduleToXlsxFileExportCommand.cs# …` → Kelly-Revit-Logic: The 'preamble' is five calls to members that are already shared: GetOrCreateSchedulesDirectory, GetOrCreateTemporaryDirectory, ScheduleExportService.GetSelectedSchedulesOrPrompt, a Count check and …
- `modules/Trade.All/Commands/ScheduleExport/ViewScheduleExportToXlsxFiles/ViewScheduleToXlsxFilesExportCommand.c …` → Kelly-Revit-Logic: Same as the single-workbook command: the shared lines are already calls to the single implementations in ScheduleExportService and KellyDirectories. The prerequisite PrepareExport member is rejected as churn.
- `src/Views/ScheduleExportService.cs#ScheduleExportService.ExportToXlsxFiles / ExportToXlsxWorkbook` → Kelly-Revit-Logic: Both methods already call the shared members (GetSelectedSchedulesOrPrompt, CreateTabDelimitedOptions, the directory extensions), and their order differs: ExportToXlsxWorkbook takes the time stamp first, ExportToXlsxFiles takes …
- `modules/Trade.All/Commands/ManyConnect/ManyConnectCommand.cs#ManyConnectCommand.ConfirmConnectorAngle` → Kelly-Windows: Each site fills a PromptRequest object initializer (Kelly-Windows), and that initializer already is the single abstraction. The sites differ in title, AllowCancellation, AutoPrefixTitle, DefaultButton, Icon, MainContent or …
- `modules/Trade.All/Commands/Spools/SpoolSheetOpen/SpoolSheetOpenCommand.cs#SpoolSheetOpenCommand.ShowTileViewsP …` → Kelly-Windows: This is a per-site PromptRequest initializer with its own wording and Information icon. It is not duplicated logic, and the proposed AskYesNo helper only re-encodes the PromptRequest properties as parameters (see the ManyConnect …
- `modules/Trade.All/Commands/Views/Filters/All/DeleteUnusedInProject/AllUnusedInProjectDeleteViewFilterCommand.c …` → Kelly-Windows: Same reason as the other prompt sites: the initializer is the shared abstraction, and the helper would add a wide public member to Kelly-Windows, with a pack and repin of four layers, for no reduction in logic.
- `modules/Trade.Duct/Commands/DuctItemNumberSet/DuctItemNumberSetCommand.cs#DuctItemNumberSetCommand.AskReplaceI …` → Kelly-Windows: This PromptRequest initializer is specific to the site (its own title and content). The AskYesNo helper is churn (see the ManyConnect record).
- `modules/Trade.Developer/Commands/PlaceFieldTrimEndMarker/FieldTrimEndMarkCommand.cs#FieldTrimEndMarkCommand.As …` → Kelly-Windows: This site uses AutoPrefixTitle false and the Information icon: yet another property mix. The helper would only mirror PromptRequest's properties as parameters. It is churn.
- `modules/Trade.Developer/Commands/PlaceFieldTrimEndMarker/FieldTrimEndMarkCommand.cs#FieldTrimEndMarkCommand.As …` → Kelly-Windows: This site uses default Yes, AllowCancellation false, AutoPrefixTitle false and FooterText. Covering it would need a footer and a default-button parameter, which shows that the helper is just PromptRequest under another name. It …
- `modules/Trade.Contenter/Commands/FabricationCustomDataUpdaterV2/FabricationCustomDataUpdaterCommandV2.cs#Fabri …` → Kelly-Windows: UserPrompt.AskYesNo does not exist in Kelly-Windows (src/Prompts has UserPrompt, PromptRequest, PromptButtons, PromptIcon only). PromptRequest with an object initializer already is the shared, UI-agnostic abstraction; the three …
- `modules/Trade.All/Commands/Acquired/Vicious/Racker/ViciousInstanceElevationAssignViewModel.cs#ViciousInstanceE …` → Kelly-Windows: Showing a message through UserPrompt is presentation orchestration that stays in the view model (placement rules, 'Code that stays'). The method is already a thin call to UserPrompt.Show with a PromptRequest; the proposed …
- `src/Caches/DataFileLoader.cs#DataFileLoader.ConfirmOlderData` → Kelly-Windows: Same as the other two prompt records: no AskYesNo helper exists, PromptRequest already is the shared abstraction, and this site sets a different set of properties (no icon, no cancellation). The proposal itself says to leave it …
- `src/Spools/SpoolTools.cs#SpoolTools (9 manual Start/IsStarted/Commit sites: CreateSpool, …` → Kelly-Revit-Logic: Not a layer move: the code stays in Kelly-Revit-Logic and nothing goes to src/Operations; it is the already-parked OperationService.Run migration, tracked on its own. It also does not preserve behaviour: Run returns false and …
- `src/LayoutPoints/LayoutPointTools.cs#LayoutPointTools (6 manual Start/Commit sites: …` → Kelly-Revit-Logic: Same-layer refactor that is part of the parked OperationService.Run migration, not a layer move; depends on the rejected SpoolTools record. Converting changes the result when a commit is rolled back by failure processing (Run …
- `src/Views/ViewExtensions.cs#ViewExtensions (4 manual sites: SetUpFieldAndModuleReview, ExportToDwg, …` → Kelly-Revit-Logic: Same-layer refactor from the parked OperationService.Run migration, not a layer move. SetUpFieldAndModuleReview commits with notes and the file mixes OperationService with raw Transaction Start/Commit pairs; Run changes the …
- `src/Spools/ItemNumberTools.cs#ItemNumberTools (3 manual sites: ClearItemNumbers, SetSequentialItemNumbers, …` → Kelly-Revit-Logic: Same-layer refactor from the parked OperationService.Run migration, not a layer move. SetSequentialItemNumbers manages its own progress window and an inner raw Transaction; RunWithProgress would change window title, exception …
- `src/Views/ColorFilterRuleViewFilterTools.cs#ColorFilterRuleViewFilterTools (CreateAndApplyLineFilters, …` → Kelly-Revit-Logic: Same-layer refactor belonging to the parked OperationService.Run migration, not a layer move; depends on the rejected SpoolTools record and changes the result on a failure-processing rollback (Run checks IsCommitted).
- `src/Fabrication/WeldLocationService.cs#WeldLocationService (RefreshEndPreparation, SetWeldLocationByTerm)` → Kelly-Revit-Logic: Same-layer refactor from the parked OperationService.Run migration, not a layer move; the code does not leave Kelly-Revit-Logic or go to src/Operations. Behaviour changes on a failure-processing rollback and on exceptions; leave …
- `src/Arrangement/AnnotationArranger.cs#AnnotationArranger (Arrange, StripLeadersAndWrapElements)` → Kelly-Revit-Logic: Not a layer move. Arrange nests OperationService inside a raw TransactionGroup that it rolls back on failure (lines 46 and 76), which Run cannot express without restructuring; converting risks changing the group rollback order. …
- `src/Supports/TrapezeVerticalMemberTools.cs#TrapezeVerticalMemberTools (ResetExtendAndClearTags, …` → Kelly-Revit-Logic: Does not match RunWithProgress: the documented behaviour calls RollBack when the group did not start (throwing InvalidOperationException), runs Commit after the progress window and inner transactions are disposed, and leaves …
- `modules/Trade.All/Commands/Acquired/Vicious/Rotate/ViciousInstanceRotateMoveCommand.cs#ViciousInstanceRotateMo …` → Kelly-Revit-Logic: No code moves to Kelly-Revit-Logic; it is a call-site refactor. RotateViewport returns Result.Cancelled from inside the started operation (lines 147 and 156) and uses GetTransaction mid-work, and RotateSelected sets a failures …
- `modules/Trade.Contenter/Commands/FabricationCustomDataUpdaterV2/FabricationCustomDataUpdaterCommandV2.cs#Fabri …` → Kelly-Revit-Logic: One record standing for sixteen files across two repositories is not a verifiable move, and none of it changes layer. The command site opens its own ProgressReporter with its own title and step texts and shows a second 'Operation …

**domain-b** (5)

- `src/Supports/IFractionDecimalSet.cs#IFractionDecimalSet` → Kelly-Revit: Moving up undoes a rule-6 placement. ObservableCollection<T> is System.Collections.ObjectModel (BCL), not WPF, and InchLength lives in Kelly-Windows, so Domain satisfies every dependency. The interface and its three sets hold JH …
- `src/Supports/AnchorFractionDecimalSet.cs#AnchorFractionDecimalSet` → Kelly-Revit: The list of anchor lengths offered (0 to 9 inches) is a Kelly business choice with no Revit or WPF dependency: ObservableCollection is BCL and InchLength is in Kelly-Windows. Domain is the lowest layer that fits. The move would …
- `src/Supports/FieldTrimFractionDecimalSet.cs#FieldTrimFractionDecimalSet` → Kelly-Revit: The standard field trim choices are Kelly business data, not presentation, and every dependency is satisfied in Domain. Rule 6 keeps such data out of the view model, so moving it back up is churn. Rejected along with …
- `src/Supports/VerticalSupportSizeSet.cs#VerticalSupportSizeSet` → Kelly-Revit: The rod (vertical member) sizes offered, 1/16 to 2 inches, are Kelly support data that sit next to VerticalSupportSize and VerticalSupportTypeTools in Kelly.Domain.Supports. Nothing in it needs a higher layer. Rejected along with …
- `src/Spools/SpoolValueSummary.cs#SpoolValueSummary.SingleValueOrMultiple` → Kelly-Windows: The result carries Kelly meaning: the 'Multiple' label (Miscellaneous.Multiple) feeds the spool quality check. The generic part is only Distinct, OrderBy and a three-way switch. Moving it to Kelly-Windows means a new label …

**logic-a** (4)

- `src/Caches/DataFileLoader.cs#DataFileLoader` → Kelly-Domain: This is the add-in's startup and Reload Data orchestration, not a Kelly business model. It shows UserPrompt dialogs whose titles are built from AddInNames.ApplicationTitle, and nothing in Kelly-Domain src calls UserPrompt or …
- `src/Documents/DocumentExtensions.cs#DocumentExtensions.IsEditableProject(Document, out string)` → Kelly-Domain: The 'rule' is Revit document semantics: IsFamilyDocument, IsReadOnly, IsReadOnlyFile and IsDetached are Revit Document properties. The report strings it would carry ('Is Family Document', 'Is Detached', 'Is Read Only File') …
- `src/Elements/ElementInstanceModel.cs#ElementInstanceModel` → Kelly-Revit: ElementInstanceModel is Revit database work. GetElevations switches on FabricationPart, CableTray, Conduit, Duct, Pipe and FamilyInstance and reads BuiltInParameter values, and the type also reads Category and GetElementType. …
- `src/Elements/ElementInstanceModelTools.cs#ElementInstanceModelTools` → Kelly-Revit: Its only prerequisite, the ElementInstanceModel move, is rejected. On its own merits, this type was deliberately moved down from the Racker view model on 2026-11-04 (move #122, P6h, guarded by LowerLayerRulesTests 130 and 131), …

**logic-b** (23)

- `src/Operations/OperationServiceLogRecord.cs#OperationServiceLogRecord` → Kelly-Domain: Reverses a deliberate decision: the record was moved UP out of Kelly.Domain.Operations on 2026-11-04 (move #156, Kelly-Domain Changelog: 'it moves up to Kelly-Revit-Logic-v5, its only user'; the file's own remarks say so). Its …
- `src/Supports/SupportKindTiming.cs#SupportKindTiming` → Kelly-Domain: A diagnostics counter for one window's open-timing log (KTR5-4863, added days ago), used only by SupportBuildTiming in Logic and indirectly by one view model. It is instrumentation, not part of the Kelly business model that …
- `src/Supports/SupportBuildTiming.cs#SupportBuildTiming.Record` → Kelly-Domain: Splitting a cohesive, freshly added diagnostics type across two packages (Record/Summary with private state to Domain, static TimeRaycasts into a new Logic type) adds a new type, a Breaking change and view model churn …
- `src/Mep/OletTapConnectorStatus.cs#OletTapConnectorStatus` → Kelly-Domain: Reverses a deliberate earlier move: the Kelly-Revit-Logic Changelog records OletTapConnectorStatus 'Moved up from Kelly.Domain' (Kelly.Domain.Connectors -> Kelly.Revit.Logic.Mep). It describes the state of a Revit fabrication …
- `src/Mep/OletTapTools.cs#OletTapTools.CountByStatus` → Kelly-Domain: Depends on the rejected OletTapConnectorStatus move. On its own it is a three-bucket count over an enum projected from Olet; extracting a Domain overload plus a forwarding Logic overload adds surface for no real gain (the only …
- `src/Mep/OletTapTools.cs#OletTapTools.ConnectToPipes` → Kelly-Windows: A single inline comparison (Math.Round(d1 + d2, 6) != Math.Round(pLen, 6)) inside Revit transaction code, with no second copy anywhere in the six repositories (grep found only OletTapTools.cs:88). The code is not in a view or …
- `src/Views/VisibilityAction.cs#VisibilityAction` → Kelly-Domain: Reverses a deliberate decision: as OperationType it was moved up from Kelly.Domain.Operations to Kelly.Revit.Logic.Views (Logic Changelog line 2483 and table at 2722; Domain Changelog: 'OperationType stays in Logic' when …
- `src/Views/ViewFilterVisibility.cs#ViewFilterVisibility.FilterRuleTypeOf` → Kelly-Domain: Depends on the rejected VisibilityAction move. The mapping (Hide -> Equals, Isolate -> NotEquals) encodes how a Revit view filter with visibility off implements hide and isolate (SetFilterVisibility(false)), i.e. Revit behaviour, …
- `src/Views/ViewFilterVisibility.cs#ViewFilterVisibility.ApplyViewFilter` → Kelly-Domain: An earlier move (Domain Changelog for ViewFilterNames #87, and ViewFilterNames' own remarks) decided explicitly that 'the "Select" placeholder checks stay in Logic'. The check is a combo-box UI convention (placeholder text of a …
- `src/Views/ProductRangeScheduleExtensions.cs#ProductRangeScheduleExtensions.CreateOrRebuildProductRangeSchedule …` → Kelly-Domain: The view name hard-codes the application prefix "KTR - Product Range ...". The jhkweb rules forbid naming the application (Kelly Tools For Revit / KTR) in the lower layers; Kelly-Domain today contains no "KTR" string. Its …
- `src/Views/AddInViewExtensions.cs#AddInViewExtensions.AddInViewNamePrefix` → Kelly-Domain: The constants are "KTR" and "KTR - 3D": moving them to Kelly-Domain would name the application in a lower layer, which the jhkweb rules forbid (only the Kelly-Revit* repositories may name it). Their consumers …
- `src/Views/ScheduleExportService.cs#ScheduleExportService.ExportToCsvFiles` → Kelly-Domain: The '<' check encodes Revit behaviour (Revit names its revision and internal schedules in angle brackets; the method's own docs say so), not a Kelly naming rule. Only Revit-coupled code uses it, so it does not belong in Domain. …
- `src/LayoutPoints/LayoutPointRecipeIngredients.cs#LayoutPointRecipeIngredients.GetDescription2` → Kelly-Domain: These are three single-use fallback literals in three private methods. The rationale also reaches GetDescription1 and GetLayer, which the symbol does not name. Each text is bound to a Revit read: the RBS_CALCULATED_SIZE …
- `src/Mep/PointToPipeReader.cs#PointToPipeReader.ReadPcf` → Kelly-Domain: The core of the method is the UnitUtils conversion, which Domain must not call. Replacing it with hand-written constants risks floating-point differences, so behaviour may not stay exactly the same, and the proposal itself needs …
- `src/Mep/PointToPipeReader.cs#PointToPipeReader.ReadTable` → Kelly-Domain: The data is a CSV or worksheet table, not a PCF, so Domain/Pcf is the wrong concern; generic cell parsing would belong in Windows if anywhere. The behaviour is subtle: one try covers all three coordinates plus UnitUtils, so any …
- `src/Mep/ValveData.cs#ValveData.ClearanceSphereDiameter` → Kelly-Domain: The rule is a single-use '+ .25' inside a constructor where everything else is Revit (bounding box, shared coordinates, worksets). The three default texts are single-use GetValue fallbacks. A new Domain type for one addition and …
- `src/Mep/ValveClearanceSphereTools.cs#ValveClearanceSphereTools.FamilyName` → Kelly-Domain: Only Logic's Revit family lookup (GetClearanceSphereSymbol) and its test use the constant. No Revit-free code uses it, unlike LayoutPointFamilies.FamilyName, which Domain rules use. The add-in names the family as literals in its …
- `src/Spools/SpoolItem.cs#SpoolItem..ctor` → Kelly-Domain: The inline Enum.TryParse with a fallback to None is used once, and the same pattern appears untouched across Domain (SizeSymbol, ConnectorGrouping). A new Domain tools type for one generic line is churn. Possible bug to note, not …
- `src/Spools/Spool.cs#Spool.CreateAndPlaceScheduleViews` → Kelly-Domain: The proposed enum names Revit schedule kinds (an AssemblyViewUtils part list against a single-category OST_FabricationPipework schedule), so it would put Revit behaviour into Revit-free Domain. The if/else chain is private and …
- `src/Spools/Spool.cs#Spool.RecomputeDerivedState` → Kelly-Domain: What would move is two Sum+Math.Round one-liners and `!IsSpoolable // !IsTopLevelCategory`. The rounding (0 and 2 decimals) only shapes bound display properties of the Spool model (WeightPounds, LengthFeet, also summed by …
- `src/Supports/TrapezeVerticalMemberTools.cs#TrapezeVerticalMemberTools.VerticalMemberParameterPrefix` → Kelly-Domain: The 'BS' prefix is already one private constant used by both callers, so nothing is duplicated. It is used only to build names for trapeze.LookupParameter in Revit-coupled code. The proposed 'length rule' cannot be lifted out …
- `src/Supports/HangerPlacementService.cs#HangerPlacementService.FindSelectedButton` → Kelly-Windows: The BCL already provides 'item at position or default': Enumerable.ElementAtOrDefault. It is O(1) on IList<T>, including ObservableCollection<T>, returns default for negative and out-of-range indices, and exists on net481 and …
- `src/Parameters/ParameterBindingReportExtensions.cs#ParameterBindingReportExtensions.ExportKellyBindingsMarkdow …` → Kelly-Domain: The verdict switch matches Revit API class names as string literals ('InstanceBinding', 'TypeBinding', from binding.GetType().Name). Moving it to Kelly-Domain would encode Revit behaviour in a layer that must stay Revit-free, …

**logic-updaters** (4)

- `src/Updaters/ElementDataModels/MaterialElementDataModel.cs#MaterialElementDataModel.ReadValues` → Kelly-Domain: The Kelly rules in ReadValues have already moved to Domain: UsesComponentLookup (move #18), MaterialIngredients FromComponent/FromLookup/Empty (#28), DataFiles.FindComponent (#32), AddInConfiguration.IsAlternateLookupTrigger …
- `src/Updaters/UpdaterFailureLog.cs#UpdaterFailureLog.FormatMessage` → Kelly-Windows: FormatMessage has a single caller (UpdaterFailureLog.Write), and the proposal itself rates the gain small with low confidence. Its line carries the literal ' - Element Id <id>', which is a Revit concept. Moving that literal into …
- `src/Updaters/ElementServices/SuspendedSupportElementService.cs#SuspendedSupportElementService.WriteValues` → Kelly-Domain: The proposal itself calls the gain marginal: two subtractions and a sentinel comparison, folded into a loop full of Revit reads (GetRodInfo, GetRodEndPosition, GetLevelAssigned, DistanceToStructureAbove). It depends on an …
- `src/Updaters/ElementDataModels/SizeElementDataModel.cs#SizeElementDataModel.ReadRoundSize` → Kelly-Domain: This is a redesign of the model's private state (sixteen properties into a table), not a misplaced rule. The switch only assigns values to slots and holds no Kelly business rule beyond the ConnectorName key. The shape is …

**pipe-duct-trade** (7)

- `modules/Trade.Duct/RibbonItems/PushButtons/ExternalCommandAvailability/IsTaggableViewCommandEnabler.cs#IsTagga …` → Kelly-Revit-UI: Third proposal of the same base; rejected on 2026-11-06 and again on 2026-11-23 (Planning/Layer Moves plans). I read all four leaves. The only repeated code is the property read uiDocument.Document.ActiveView. Each leaf already …
- `modules/Trade.Duct/Commands/DuctLengthCheck/DuctLengthCheckViewModel.cs#DuctLengthCheckViewModel.FormatIssuesL …` → Kelly-Domain: FormatIssuesLabel returns the text of one window's Issues label ($"Failed: {n}, Warnings: {m}"). Only DuctLengthCheckViewModel.IssuesLabelContent uses it, and no other view model or layer repeats that text (grep). Display text …
- `modules/Trade.Duct/Commands/DuctLengthCheck/DuctLengthCheckViewModel.cs#DuctLengthCheckViewModel.FilterRows` → Kelly-Domain: FilterRows decides which rows the grid shows from the groups whose checkbox is ticked (StraightLengthGroupSummary.IsIncluded). That is visibility UI state, and the placement rules keep UI state in the view model. The proposed …
- `modules/Trade.Duct/Commands/DuctLengthCheck/StraightLengthGroupSummary.cs#StraightLengthGroupSummary.SummaryTe …` → Kelly-Domain: SummaryText is the display text of a summary model bound to one tool's group list (DuctLengthCheckWindow.xaml line 67, Text="{Binding SummaryText}"). The placement rules keep display text in a row or item model that exists only …
- `modules/Trade.Duct/Commands/DuctRunItemNumberSet/DuctRunItemNumberSetCommand.cs#DuctRunItemNumberSetCommand.Ha …` → Kelly-Revit-Logic: The non-presentation rule, which parts are missing a line number, already lives in Kelly-Revit-Logic as ParameterValueQueries.GetPartIdsMissingLineNumber, and the command calls it. What is left is the body of one TaskDialog: a …
- `modules/Trade.Duct/Commands/DuctItemNumberSet/DuctItemNumberSetCommand.cs#DuctItemNumberSetCommand.Execute …` → Kelly-Revit-Logic: Already rejected on 2026-11-23 in this same scope. Nothing has changed: the code is identical. The lookup is a one-line FirstOrDefault over the command's own list, used once, and grep finds no second copy in any module. Adding …
- `modules/Trade.Duct/Commands/DuctItemNumberSet/DuctItemNumberSetCommand.cs#DuctItemNumberSetCommand.ShouldRepla …` → Kelly-Windows: Already rejected on 2026-11-23 in this same scope, and nothing has changed. ShouldReplace is the single equality 'answer == PromptResult.Yes'. The other sites listed compare in different shapes (response?.Result == …

**revit-host** (3)

- `src/EventHandlers/MissingSharedParametersDialog.cs#MissingSharedParametersDialog.MainContent` → Kelly-Domain: MainContent is the text of a TaskDialog that only the host shows. That makes it presentation text, not a Kelly business rule. The placement rules keep the orchestration and its messages with the presentation. The text also states …
- `src/App.cs#App.CreateAddInId` → Kelly-Revit-Logic: The Guid pattern 321044f7-b0b3-4b1c-af18-e71a1925<year> is the add-in's own identity. It must match the <AddInId> in the host's manifests (Kelly-Revit-v5/src/AddinManifests/<year>/Kelly Tools For Revit 5.addin, plus the copies …
- `src/Services/ApplicationSessionService.cs#ApplicationSessionService.OnApplicationInitialized` → Kelly-Revit-Logic: The method is about 8 lines and only copies Application properties into the Kelly.Windows ApplicationSession constructor. The host service is the only consumer, and nothing else in any layer builds an ApplicationSession from a …

**ui** (7)

- `src/Ribbon/RibbonModuleLoader.cs#RibbonModuleLoader.GetModuleTypes` → Kelly-Windows: Not a real gain. The claimed duplication is false: Kelly.Windows.Reflection.AssemblyExtensions.GetConcreteTypesAssignableTo<T> has different semantics (GetTypes, includes non-public and non-class types, no constructor or generic …
- `src/Mvvm/ViewModel.cs#ViewModel.SyncGridSelectionToRevit (host element id projection)` → Kelly-Revit-Logic: The DRY claim does not hold. Grep of Kelly-Revit-Logic-v5/src finds no Select(e => e.HostElement.Id) projection. LayoutPointTools and SuspendedSupportIndex use HostElement.Id in GroupBy, Equals and dictionary keys, which a …
- `src/Ribbon/ProjectRibbonComboBox.cs#ProjectRibbonComboBox` → Kelly-Revit: Kelly-Revit-UI is a valid layer for it. The placement table puts ribbon types that are reusable framework shared by tools in Kelly-Revit-UI, and six assigner tools share this base. The 'one-module' rule the proposal invokes is …
- `src/Ribbon/RibbonComboBoxEvents.cs#RibbonComboBoxEvents` → Kelly-Revit: It depends on the rejected ProjectRibbonComboBox move. On its own it is a shared ribbon event handler used by six assigner tools, which is framework shared by tools and belongs in Kelly-Revit-UI. It was consolidated there on …
- `src/Ribbon/RibbonExtensions.cs#RibbonExtensions.AddStackedComboBoxes` → Kelly-Revit: Its prerequisite, the ProjectRibbonComboBox move, is rejected. AddStackedComboBoxes takes ProjectRibbonComboBox and must stay with it in Kelly-Revit-UI. It is a ribbon helper shared by two stacked-button tools, so it is valid …
- `src/Commands/CommandRunner.cs#CommandRunner` → Kelly-Revit: The proposal's target folder is wrong: CommandRunner is used by two separate Trade.All tools, Arranger and ArrangeDistributeTagsAroundCommand, not one, and placing it in Commands/Acquired/Arrange would put it inside one tool's …
- `src/Selection/SelectionPickTools.cs#SelectionPickTools` → Kelly-Revit: SelectionPickTools holds generic RevitAPIUI Selection helpers (TryPickObject and TryPickPoint, which handle Esc) used by two different tools, Disconnect and Point To Pipe. By the placement table that is reusable framework shared …

**windows-and-data** (2)

- `src/Text/IdentifierTools.cs#IdentifierTools` → Kelly-Domain: JoinPartsUpperCase is a generic text helper (trim parts, join with a delimiter, upper-case invariant); the code carries no Kelly meaning, and its own docs say only 'Builds identifiers from parts'. Kelly-Windows is the lowest …
- `src/Text/RegexMatchTools.cs#RegexMatchTools.SizeSeparatedByAnX` → Kelly-Domain: The pattern ^(.+)\s+x\s+(.+)$ is generic parsing ('a x b') with no Kelly meaning. The rules put parsing of plain text in Kelly-Windows. A single Domain caller does not make it a Kelly business rule, and the move would split …

## Scopes

| Scope | Files read | Proposed |
|---|---|---|
| revit-host | 8 | 3 |
| alltrade-acquired | 51 | 0 |
| alltrade-assigners-a | 72 | 4 |
| alltrade-assigners-b | 106 | 17 |
| alltrade-tools-a | 70 | 3 |
| alltrade-tools-b | 60 | 4 |
| alltrade-ribbon | 44 | 6 |
| pipe-duct-trade | 45 | 7 |
| contenter-manager-developer | 72 | 8 |
| ui | 68 | 8 |
| logic-updaters | 68 | 8 |
| logic-a | 109 | 14 |
| logic-b | 85 | 34 |
| domain-a | 118 | 0 |
| domain-b | 144 | 7 |
| windows-and-data | 132 | 12 |
| cross-repo-duplication | 1250 | 28 |
