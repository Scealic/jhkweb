# Member naming check, pass 2: Kelly-Revit-Logic-v5 (part 1) (2026-11-11)
Second pass after the first-pass renames landed. Sources: groups G07, G08, G09 (plus the two Logic findings G16 reported from the add-in side: `PathExtensions.Get*Directory`, `ArrangerOrientation`). Readers: Sonnet; checked by: Opus.

Folders: `Arrangement`, `Caches`, `Categories`, `Common`, `Connectors` (G07); `Documents`, `Elements` (G08); `Entities`, `Fabrication`, `Families`, `Geometry`, `LayoutPoints`, `Materials` (G09). Paths below are relative to `Kelly-Revit-Logic-v5/src`. Callers = files in Logic, Kelly-Revit-UI and the add-in (src and modules, no tests) unless a count of call sites is given.

## Summary
- **Confirmed:** 11 Misleading (10 findings; `GetSettingsFilePath` has its own row), 50 Vague, 37 Style (in 19 rows).
- **Misleading not kept:** 9 of the 19 reported. 5 went to Vague, 2 to Style, and 2 were dropped (`GetData`: KWD3-7; `GetApplicationReportsDirectory`: KTRL5-139).
- **Possible bugs:** 17 reported, 2 confirmed, 15 dropped (documented "kept as moved", already filed, not a bug, or a docs fix carried in a rename issue).
- **Rule note.** The readers' brief says building blocks that need the caller's transaction end in `Core`. `AGENTS.md` (KTRL5-149) asks for `Core` only to tell a self-transacting method from its caller-transaction twin, and lets parameters do that too; the code has 4 `…Core` names. So I suggest `Core` only for twins. For the other caller-transaction methods I suggest an XML docs line instead. If the maintainer wants `Core` on every such building block, it is a rule change for all of Logic (KTRL5-149), not this pass.
- **`PathExtensions.Get*Directory`.** KTRL5-148 took the "document it" option: a type-level remark says every `Get…Directory` creates the folder. The 13 methods still have no XML docs of their own, and G16 shows the effect at a caller: both Excel schedule exports create the Schedules and Temporary folders before they check the selection, so a cancelled run leaves them behind. R1 asks the maintainer to choose between renaming and keeping the names.

## Confirmed bugs
| Member | File:line | What is wrong | Evidence | Steps to show it | Priority |
|---|---|---|---|---|---|
| `WeldLocationService.RefreshEndPreparation` | `Fabrication/WeldLocationService.cs:65` | `connectedStraights` is created once, before the per-weld loop, and never cleared. Each weld runs the end preparation updater again over the straights of every weld before it. That is quadratic work, the updater runs more than once per straight, and a weld with no straight of its own still re-processes the earlier ones. | Line 77 `var connectedStraights = new List<Element>();` sits outside `foreach (var weld …)`. Inside the loop, `SetElements(connectedStraights)` and `ProcessElements` are called per weld. The XML docs say "Kept as moved", so this is a known defect left in place, and no issue was ever filed (searched `Planning`). | Select 3 fabrication welds on one pipe run and run any Weld Location Set command (for example Field). With a breakpoint or log in `EndPreparationUpdaterElementService.ProcessElements`, the straights of weld 1 are processed 3 times, weld 2's twice and weld 3's once. | Low |
| `ForgeTools.GetGroupTypeIdByName`, `FabricationConnectorTools.GetFabricationConfiguration` (private), `WeldLocationService.SetWeldLocationByTerm` | `Common/ForgeTools.cs:9`, `Connectors/FabricationConnectorTools.cs:18`, `Fabrication/WeldLocationService.cs:134` | A failed lookup (a group name that is not a `GroupTypeId`, a document with no fabrication configuration, a weld term with no terminology row) throws `ArgumentNullException`. The parameter name it reports is a local (`propertyInfo`, `weldLocation`) or a code string, not an argument. A caller that catches lookup failures, or a person reading the log, is misled. | `throw new ArgumentNullException(nameof(propertyInfo))`; `throw new ArgumentNullException("FabricationConfiguration.GetFabricationConfiguration(connector.Owner.Document)")`. `Assign`'s docs repeat "parameter name weldLocation". `ExternalParameterDefinitionExtensions.cs:31` passes a data-file group name to `GetGroupTypeIdByName`, so a bad data row ends in this exception. | Call `ForgeTools.GetGroupTypeIdByName("NotAGroup")`: it throws `ArgumentNullException` "propertyInfo". `InvalidOperationException` (or `KeyNotFoundException`) naming the missing value is expected. | Low |

## Proposed rename issues

### R1: PathExtensions: Get*Directory creates folders; rename or keep (decide)
| Severity | Member | File:line | What it does | Suggested | Callers | Serialized/Shown |
|---|---|---|---|---|---|---|
| Misleading | `PathExtensions.GetApplicationDataDirectory`, `GetApplicationLogsDirectory`, `GetLayoutDirectory`, `GetProjectDataDirectory`, `GetProjectDirectory`, `GetProjectsRootDirectory`, `GetProjectExportDirectory`, `GetProjectLogsDirectory`, `GetReportsDirectory`, `GetSchedulesDirectory`, `GetSettingsDirectory`, `GetTemporaryDirectory` (`GetApplicationReportsDirectory` is KTRL5-139) | `Common/PathExtensions.cs:40-167` | Each goes through `DirectoryTools.GetOrCreate`, so reading the path creates the folder. Only the type remarks say so (KTRL5-148). The Excel schedule exports create Schedules and Temporary even when the user selected nothing (`ViewScheduleToExcelFileExportCommand.cs:57-58`, same in the Files variant). | `GetOrCreate<X>Directory` (the private `GetOrCreateApplicationDirectory` / `GetOrCreateProjectSubDirectory` already use the term; no clash). Or keep the names and add a docs line to each member. Either way, the two Excel commands should read the folders after the selection check (add-in). | about 55 call sites (9 `GetProjectLogsDirectory`, 8 `GetReportsDirectory`, 7 `GetSchedulesDirectory`, 6 `GetApplicationLogsDirectory`) | no |
| Misleading | `PathExtensions.GetSettingsFilePath` | `Common/PathExtensions.cs:149` | Returns a file path and creates the Settings folder (documented in its remarks) | keep; follows the R1 decision | 3 | no |
| Vague | `PathExtensions` (type) | `Common/PathExtensions.cs:5` | Not path extensions: it is the Kelly folder layout under `C:\Projects\Revit` | `KellyDirectories` (no clash) | 8 | no |

### R2: Arrangement: ArrangerOrientation is an action; tag distributor names
| Severity | Member | File:line | What it does | Suggested | Callers | Serialized/Shown |
|---|---|---|---|---|---|---|
| Misleading | `ArrangerOrientation` (enum) and its `orientation` parameters; members `AlignUp`, `AlignDown` | `Arrangement/ArrangerOrientation.cs:4` | The values are arrange actions (align, distribute, untangle); its own summary says "the arrange operation". The top/bottom aligns are `AlignUp`/`AlignDown`, while the commands, buttons and tooltips say Top/Bottom (`ArrangeAlignTopCommand` passes `AlignUp`). Also reported by G16. | `ArrangeAction`, members `AlignTop`, `AlignBottom`, parameters `action`. `AlignTop`/`AlignBottom` are also namespace segments in the add-in; qualified use still compiles. | 14 files (11 add-in); `AlignUp` 5, `AlignDown` 5 refs | **Shown:** `ToReadableName()` makes the Undo group text "Arrange - Align Up". The rename changes it to "Align Top", which matches the button. Decide whether to accept that. |
| Misleading | `TagDistributor.PlaceAndSort` (private) | `Arrangement/TagDistributor.cs:201` | Gives each tag the nearest free position, swaps crossing tags twice (`UnCross`) and moves the tags; sorts nothing | `AssignPositionsAndUncross` | private | no |
| Vague | `ArrangerToolkit` (type) | `Arrangement/ArrangerToolkit.cs:3` | Sealed class whose only member is static `ElementIdsOf(references)` | static `ReferenceExtensions`, or fold into the add-in's Arranger | 2 | no |
| Vague | `CustomLeader` | `Arrangement/CustomLeader.cs:3` | The end and elbow points copied from a Revit `Leader` | `LeaderPoints` (no clash) | 2 | no |
| Vague | `ViewSides` (enum) | `Arrangement/ViewSides.cs:4` | One side (Left, Right); the property is `Side` | `ViewSide` | 3 | no |

### R3: Common: dialog names and failure preprocessor names
| Severity | Member | File:line | What it does | Suggested | Callers | Serialized/Shown |
|---|---|---|---|---|---|---|
| Misleading | `TaskDialogSimple.ShowSleeveTagger` | `Common/TaskDialogSimple.cs:54` | Information dialog "There were no JHK penetrations found in this project"; shows no tagger | `ShowNoPenetrationsFound` | 1 (add-in `PenetrationTagAssignCommand`) | **Shown:** title "Sleeve Tagger": keep |
| Vague | `TaskDialogSimple.ShowViewScheduleError` | `Common/TaskDialogSimple.cs:14` | Error dialog titled "Error" whose text is only the schedule name; shown when a schedule export throws | `ShowScheduleExportError` (no clash) | 1 (`ScheduleExportService`, 3 sites) | **Shown:** title "Error" (vague text too) |
| Vague | `CommitPreprocessor` | `Arrangement/CommitPreprocessor.cs:3` | Deletes the four "room tag not in room" warnings | `RoomTagNotInRoomWarningSwallower` | 2 | no |
| Vague | `SuppressDuplicateInstancesWarning` | `Common/SuppressDuplicateInstancesWarning.cs:3` | Deletes the Duplicate Instances warning; a third naming pattern for failure preprocessors | `DuplicateInstancesWarningSwallower` | 2 | no |
| Vague | `AssemblyWarningSwallower` | `Common/AssemblyWarningSwallower.cs:3` | Deletes every warning of the transaction, not only assembly ones. The behaviour is filed as KTRL5-139, so rename with that fix. | `AllWarningsSwallower`, or keep if KTRL5-139 narrows it to assembly warnings | 3 | no |

### R4: Common, Categories, Connectors: vague type names
| Severity | Member | File:line | What it does | Suggested | Callers | Serialized/Shown |
|---|---|---|---|---|---|---|
| Misleading | `ButtonDataWrapper` | `Common/ButtonDataWrapper.cs:5` | Not Revit's ribbon `ButtonData`: it is a list item for a fabrication service button (index, name, image, enabled). The first pass renamed `ButtonDatas` to `HangerButtons` and left the type. | `FabricationServiceButtonItem` (no clash); follow on: `ToOrderedButtonDataWrappers`, `HangerButtonLookupResult.NoButtonDatas`, `buttonDatas` out parameters (Supports, part 2) | 6 (1 add-in) | no |
| Vague | `ContextLists` (type) | `Common/ContextLists.cs:5` | Static queries for item numbers, line numbers, product codes and service signatures in a scope or view | `ParameterValueQueries` (no clash) | 5 | no |
| Vague | `ContextLists.GetPartsMissingLineNumber` | `Common/ContextLists.cs:68` | Returns `ElementId`s, not parts | `GetPartIdsMissingLineNumber` | 2 | no |
| Vague | `ForgeTools` (type) | `Common/ForgeTools.cs:3` | One method: a parameter group name to its `GroupTypeId` | `GroupTypeIdTools` (do it with bug 2) | 2 | no |
| Vague | `BuiltInCategoryMeta`; private `VersionNumber` | `Categories/BuiltInCategoryMeta.cs:5, 76` | One category row. `VersionNumber` only copies into `RevitVersion` | `BuiltInCategoryRow`; drop `VersionNumber` | 1 | **Serialized:** `RevitVersion` is a record column (pending decision): keep |
| Vague | `ConnectorTypeEnd` | `Connectors/ConnectorTypeEnd.cs:3` | An End connector with its Near/Far position from the source connector | `PositionedEndConnector` | 4 | no |
| Vague | `EndPositions` (enum) | `Connectors/EndPositions.cs:4` | One position, Near or Far; the property is `EndPosition` | `EndPosition` (type and property may share the name) | 4 | no |
| Vague | `ConnectionInfo`, `ConnectorInfo` and `ConnectorInfo.ConnectorXyz` | `Connectors/ConnectionInfo.cs:5`, `ConnectorInfo.cs:5, 19` | "Info" says nothing; `Xyz` names the type, the value is the connector origin | `ConnectedConnectorPair`, `ConnectorWithOwner`, `ConnectorOrigin`. `ConnectorInfoVictaulic` waits for the Victaulic cleanup (KTR5-4678). | 7 / 2 | no |

### R5: Documents: lookups named like Revit's, and caller-transaction docs
| Severity | Member | File:line | What it does | Suggested | Callers | Serialized/Shown |
|---|---|---|---|---|---|---|
| Misleading | `UiDocumentExtensions` (type and file) | `Documents/UiDocumentExtensions.cs:4` | Product-range filter and queries on `Document` and `ScopeSource`; nothing about `UIDocument` | `ProductRangeExtensions` (no clash) | 1 | no |
| Vague (was Misleading) | `DocumentExtensions.GetOrCreateParameterFilterElement` | `Documents/DocumentExtensions.cs:1028` | Calls `ParameterFilterElement.Create` in the caller's transaction; the docs don't say so | keep the name (no self-transacting twin); add "needs the caller's open transaction" | 3 | no |
| Vague (was Misleading) | `DocumentExtensions.DeleteAllOfType<T>` | `Documents/DocumentExtensions.cs:1461` | Deletes every T in the caller's transaction; no docs, no null check; returns the ids it was asked to delete. Only the tests call it. | keep; add docs (transaction, cascade risk noted under KTRL5-143) | 0 (tests only) | no |
| Vague | `DocumentExtensions.GetElement<T>(Document, string)` | `Documents/DocumentExtensions.cs:916` | First T whose `Name` matches exactly; looks like Revit's `GetElement(ElementId)` | `GetElementByName<T>` | 21 hits for the three lookups together | no |
| Vague | `DocumentExtensions.GetDocumentType(this string, out string)` | `Documents/DocumentExtensions.cs:835` | Classifies a file path by its extension | `GetDocumentTypeFromPath` | 2 | `extensionLabel` values (`<rvt>`) are shown |
| Vague | `DocumentExtensions.GetWorkset(Document, string)` | `Documents/DocumentExtensions.cs:1376` | User worksets only, exact case-sensitive name | `GetUserWorksetByName` | 1 | no |
| Vague | `GetElementsByFilter(this List<ElementId>, …)` XML docs | `Documents/DocumentExtensions.cs:143` | Summary copied from the View overload ("from a provided View") | fix the summary (docs only) | n/a | no |

### R6: ElementFilterTools and ElementId lookups
| Severity | Member | File:line | What it does | Suggested | Callers | Serialized/Shown |
|---|---|---|---|---|---|---|
| Misleading | `ElementFilterTools.AndListOfSharedParameters(Document, List<ExternalParameterDefinition> definitionNames)` (private) | `Elements/ElementFilterTools.cs:341` | Requires each parameter to have content (string greater than empty). The `IDefinitionSet` and `List<string>` overloads only require it to be applicable. The parameter holds definitions, not names. | `AndListOfSharedParametersWithContent(document, definitions)`; the other two `AndListOfSharedParametersApplicable` | private (2 sites) | no |
| Misleading | `ElementFilterTools.BaseList` and the summary above `GetInternalDefinition` | `Elements/ElementFilterTools.cs:392, 407` | `BaseList(isInstanceFilter)` is the not-a-type filter plus the insulation exclusion. Its summary ("for either Element Types Or Instances", `isInstanceFilter`) sits on `GetInternalDefinition`, which has no such parameter. | `InstanceFilterBase`; move the docs | private (14 sites) | no |
| Vague | `ElementFilterTools.InstanceHavingParameterContent` (3 overloads) | `Elements/ElementFilterTools.cs:7, 39, 65` | Singular, while every sibling is `Instances…` | `InstancesHavingParameterContent` | 3 | no |
| Vague | `ElementFilterTools.ParameterOfTypeStringEquals` (private) | `Elements/ElementFilterTools.cs:449` | String-equals rule filter on one parameter; "OfType" reads as element type | `StringParameterEqualsFilter` | private | no |
| Vague | `ElementIdExtensions.GetElements<T>(IEnumerable<ElementId>, Document)` | `Elements/ElementIdExtensions.cs:87` | Keeps only the elements of type T and throws for an id with no element; T is unconstrained | `GetElementsOfType<T>` with `where T : Element` | 9 | no |
| Vague | `ElementIdExtensions.GetElementIdValue` vs `ElementExtensions.GetIdValue` | `Elements/ElementIdExtensions.cs:60`, `ElementExtensions.cs:186` | Both return the id's `long`; KTRL5-144 renamed only the `Element` one | `GetIdValue` on both | 3 / 0 | no |

### R7: Elements: assemblies, tags, values and categories
| Severity | Member | File:line | What it does | Suggested | Callers | Serialized/Shown |
|---|---|---|---|---|---|---|
| Vague (was Misleading) | `AssemblyInstanceExtensions.Rename` | `Elements/AssemblyInstanceExtensions.cs:76` | Renames the assembly type and its schedules and sheets, returns `(bool, string)`, in the caller's transaction (only `Spool.cs:637`) | `RenameWithViews`; docs line for the transaction | 1 | no |
| Vague (was Misleading) | `AssemblyInstanceExtensions.CreateSpoolSheet` | `Elements/AssemblyInstanceExtensions.cs:6` | Creates the sheet in the caller's transaction; returns null when assembly views are not allowed; no docs | keep the name (spool/assembly term pending); add docs | 1 | **Shown:** sheet name "Sheet" here, "SHEET" in `Rename` (first pass, not applied: make them one text) |
| Vague | `AssemblyInstanceExtensions.GetViewByNameOrSheetNumber` parameter `viewName` | `Elements/AssemblyInstanceExtensions.cs:32` | Compared with a sheet's `SheetNumber` too | `nameOrSheetNumber` | n/a | no |
| Vague | `PenetrationTagTools.CreateTag` | `Elements/PenetrationTagTools.cs:97` | Builds the tag text "{prefix}-{size}-{length}"; creates no Revit tag | `BuildTagText` | 1 (in type) | the tag format is shown |
| Vague | `ElementExtensions.GetElevationInFeet` | `Elements/ElementExtensions.cs:230` | Only mechanical equipment, pipe accessories and fabrication hangers, pipework and ductwork; 0 for the rest; null category throws | document the categories, or `GetHostOffsetInFeet` | 3 | no |
| Vague | `ElementDataExtensions.GetValueAsString` | `Elements/ElementDataExtensions.cs:242` | Docs say a null is returned. The code throws for a null default, returns `defaultValue.ToString()` when the value is missing, and otherwise the display text with quotes swapped | fix the docs; `GetDisplayText` | 3 | no |
| Vague | `RevitLinkInstanceExtensions.GetStatus` | `Elements/RevitLinkInstanceExtensions.cs:7` | `LinkedFileStatus` of the link's type, `Invalid` with no type | `GetLinkedFileStatus` (no clash on `RevitLinkInstance`) | 5 | no |
| Vague | `RotateAxisTools.IsMepFittingAxis` | `Elements/RotateAxisTools.cs:12` | True for fittings and accessories | `IsMepFittingOrAccessoryAxis` | 3 | no |
| Vague | `ReInsertModel` | `Elements/ReInsertModel.cs:3` | A definition, its binding and group, kept to re-insert a binding | `ParameterBindingRecord` | 1 | no |

### R8: Families and Materials: hidden dialogs and overwrites
| Severity | Member | File:line | What it does | Suggested | Callers | Serialized/Shown |
|---|---|---|---|---|---|---|
| Misleading | `FamilySymbolExtensions.FindFirstSymbolOfFamily` | `Families/FamilySymbolExtensions.cs:108` | Shows a "Family Error" prompt when no symbol is found. This is the first-pass rename of `GetFamilySymbol`, which was flagged for the dialog; the new name still hides it. | `FindFirstSymbolOfFamilyOrPrompt` (as `GetFirstViewOrPrompt<T>`, `GetSelectedSchedulesOrPrompt`) | 7 | **Shown:** "Family Error" |
| Vague | `FamilySymbolExtensions.FamilyMissingMessage` (private) | `Families/FamilySymbolExtensions.cs:140` | Shows the prompt | `ShowFamilyMissingMessage` | private | no |
| Misleading | `MaterialTools.GetOrCreateMaterial` | `Materials/MaterialTools.cs:14` | Also overwrites `Color` and `UseRenderAppearanceForShading` on an existing material; caller's transaction | `GetOrCreateMaterialWithColor`; docs line | 2 | no |
| Vague | `MaterialTools.RemoveMaterialsFromFamily` | `Materials/MaterialTools.cs:71` | Clears the material assignment of every category except the family's own; removes no material | `ResetMaterialAssignmentsInFamily` (matches `TransactionName.ResetMaterialAssignments`) | 2 | Undo text kept |
| Vague | `MaterialExtensions.Export` | `Materials/MaterialExtensions.cs:10` | Writes a Name/RGB/Transparency CSV to the reports folder and may open it | `ExportToCsv` | 1 | CSV header and file name "Materials" |
| Vague | `TypeBoundSharedParameterScanner.Scan` | `Families/TypeBoundSharedParameterScanner.cs:16` | Opens every editable family to list type-bound "JHK" shared parameters | `ScanFamiliesForTypeBoundJhkParameters` | 2 | no |

### R9: LayoutPoints: duplicate flag, candidate builders and saved data
| Severity | Member | File:line | What it does | Suggested | Callers | Serialized/Shown |
|---|---|---|---|---|---|---|
| Vague (was Misleading) | `LayoutPointImportCandidate.IsDuplicateName` | `LayoutPoints/LayoutPointImportCandidate.cs:10` | The CSV "Name" is the layout point Id (`new LayoutPoint(Name, …)`). The flag is Domain's `LayoutPoint.IsDuplicate` ("same Id"), and the export side is `IsDuplicateId`. The first pass kept "Name" on purpose, so the name is accurate for the CSV column but not for the domain term. | `IsDuplicateId` | 4 files | **XAML binding** `LayoutPointFromCommaSeparatedValueImportView.xaml:237` |
| Vague | `LayoutPointExportCandidateFactory.Create` | `LayoutPoints/LayoutPointExportCandidateFactory.cs:54` | Builds every export candidate, flags too-long and duplicate ids, reloads the last numbers per prefix | `CreateCandidates` | 1 | no |
| Vague | `LayoutPointTools.Import` | `LayoutPoints/LayoutPointTools.cs:151` | Places a family instance per candidate in its own operation | `PlaceImportCandidates` | 1 | no |
| Vague | `LayoutPointTools.ExportCandidates` | `LayoutPoints/LayoutPointTools.cs:22` | Writes the CSV, stamps "exported" on each host and exports the DWG view | `ExportCandidatesAndMarkExported` | 1 | no |
| Vague | `LayoutPointTools.ResetHostElement` / `ResetHostElements` | `LayoutPoints/LayoutPointTools.cs:397, 414` | Clears the five saved layout point parameters of a host | `ResetSavedLayoutPoints` / `ResetSavedLayoutPointsOfHosts` | 2 | Undo text kept |
| Vague | `LayoutPointOrdering.GetSavedOrderedById(Element)` | `LayoutPoints/LayoutPointOrdering.cs:37` | Reads the points saved on one element, in stored order; only the list overload orders by id | `ReadSavedLayoutPoints(Element)` | 3 | no |
| Vague | `LayoutPointExportCandidate.Index` | `LayoutPoints/LayoutPointExportCandidate.cs:17` | Index of the point within its host | `IndexInHost` (check grid bindings) | several | possibly bound in the export grid |

### R10: Fabrication: weld rows, weld location and hanger placement names
| Severity | Member | File:line | What it does | Suggested | Callers | Serialized/Shown |
|---|---|---|---|---|---|---|
| Vague | `ProductRange10Joints01Weld` (type) | `Fabrication/ProductRange10Joints01Weld.cs` | A weld row of the Spool Manager grid; the code already says `SpoolWelds`, `GetWelds` | `SpoolWeld` (no clash) | 4 | type used in add-in `SpoolManagerViewModel` |
| Vague | `WeldLocationService.Assign` | `Fabrication/WeldLocationService.cs:43` | Sets the weld location and BOM type, then refreshes end preparation | `AssignWeldLocation` | 5 (one per weld command) | no |
| Vague | `WeldLocationService.SetWeldLocationByTerm(string weldName)` | `Fabrication/WeldLocationService.cs:134` | `weldName` is a terminology term; local `weldLocation` is a terminology row | parameter `weldTerm`, local `terminology` (with bug 2) | 2 | no |
| Vague | `BillOfMaterialTypeAssigner.UpdateElements` | `Fabrication/BillOfMaterialTypeAssigner.cs:70` | Writes JHK BOM Type on the filtered elements in an operation | `AssignBillOfMaterialType` | 0 outside class | no |
| Vague | `FabricationDatabaseTools.PlaceHangerMultiple` / `PlaceHangerSingle` | `Fabrication/FabricationDatabaseTools.cs:121, 157` | Hangers at the near-end then repeat interval / one hanger at mid-length | `PlaceRepeatedHangers` / `PlaceMidLengthHanger` | 2 | no |

### R11: Logic part 1: batched style names and docs
| Severity | Member | File:line | What it does | Suggested | Callers | Serialized/Shown |
|---|---|---|---|---|---|---|
| Style | `CategoryExtensions.GetBuiltInCategory(this string)` | `Categories/CategoryExtensions.cs:48` | Throws on an unknown name; the wrapper overload returns `INVALID` | `ParseBuiltInCategory` | many | no |
| Style | `ConnectorTools.GetClosestConnectorTo` vs `GetConnectorClosestToCoordinate` / `GetConnectorFarthestFromCoordinate` | `Connectors/ConnectorTools.cs:177, 259, 295` | Two word orders; `xyz` vs `coordinate` | `GetClosestConnectorTo(…, ConnectorType)`, `GetFarthestConnectorFrom` | 2 each | no |
| Style | `HasUnusedConnector`, `FamilyInstanceHasUnusedConnector` vs `FindClosestFacingUnconnectedConnectors` | `Connectors/ConnectorTools.cs:385, 392, 85` | Both first-pass names; "Unused" and "Unconnected" mean the same | `HasUnconnectedConnector`, `FamilyInstanceHasUnconnectedConnector` | 3 / 2 | no |
| Style | `DevelopmentLog.ToLogDevelopment` (2 overloads) | `Common/DevelopmentLog.cs:13, 24` | Appends to the daily development log | `AppendToDevelopmentLog` | 4 | no |
| Style | `ConnectorWrapper.SetDimensionValueString` docs | `Connectors/ConnectorWrapper.cs:162` | Docs say value plus unit suffix; code formats feet as inch-and-fraction to 1/16 | fix the docs | n/a | `ValueString` shown |
| Style | `TagDistributor.UnCross`; `AnnotationArranger` local `transGroupName`; `AnnotationElement.GetMax/GetMin` | `Arrangement/TagDistributor.cs:240`, `AnnotationArranger.cs:39`, `AnnotationElement.cs:48` | Casing; abbreviation; re-implement `Math.Max/Min` | `Uncross`; `transactionGroupName`; `Math.Max/Min` | private | no |
| Style | `CategoryExtensions.AddLine`, local `commandName`; `ConnectorExtensions` local `isSourceConnectorAnEnd` | `Categories/CategoryExtensions.cs:192, 183`; `Connectors/ConnectorExtensions.cs:76` | Appends category rows recursively; holds `nameof(category)`; tests the connected connector's type | `AppendCategoryRows`; `parameterName`; `isOfRequestedType` | private | no |
| Style | `ElementExtensions.SetBottomOrTopElevation(Element, …)` vs the `List<Element>` overload (was Misleading) | `Elements/ElementExtensions.cs:762, 793` | Same name: caller's transaction vs own operation. `AGENTS.md` allows telling twins apart by parameters, but this pair is easy to mix up. | `SetBottomOrTopElevationCore` for the element one, or a docs line | 6 | no |
| Style | `LayoutPointTools.UpdateSavedCoordinates(candidates)` vs `(document, candidates)` | `LayoutPoints/LayoutPointTools.cs:654, 714` | Same twin pattern (int in caller's transaction / bool with own operation) | `UpdateSavedCoordinatesCore` for the first, or docs | 2 | no |
| Style | `DocumentExtensions.IsEditableProject` texts; `AppendDocumentInformation` heading | `Documents/DocumentExtensions.cs:1406-1442, 779` | "not in a modifiable state" (Revit's `IsModifiable` means a transaction is open); heading "Project Information" for any document | "is not editable"; "Document Information" | 5 / 1 | **Shown** texts |
| Style | `ShowWorkSharingInfo`, `syncIfNewWorkSet`; `GetUniqueViewName` not an extension | `Elements/ElementExtensions.cs:833`; `Documents/DocumentExtensions.cs:1073, 1277` | Revit spells `Worksharing`/`Workset` | `ShowWorksharingInfo`, `syncIfNewWorkset` | 2 / private | no |
| Style | `GridTools.GetNearestIntersection`, `GetIntersectionCoordinates` | `Elements/GridTools.cs:83, 11` | Return a key ("A/1" or "??") / points keyed by name. `GetNearestIntersection` also computes a location and two curve end points it never uses (dead code). | `GetNearestIntersectionName`, `GetIntersectionPointsByName`; remove the dead lines | 2 / 2 | key text shown |
| Style | locals and parameters: `GroupTools` `taskDialog`, `OrListOfCategories` `builtInCategory`, `definitionsSet`, `GetConnectedElements` `elementIds`, `GetValue(… BuiltInParameter parameter …)`, `ResetValues` `filteredElements`, `scopedFilePath` | `Elements/GroupTools.cs:23`, `ElementFilterTools.cs:366, 441`, `ElementExtensions.cs:536`, `ElementDataExtensions.cs:74-117`, `ElementExtensionsJhk.cs:158`, `Documents/DocumentExtensions.cs:1629` | Names that don't match what they hold | `confirmed`, `category`, `definitionSet`, `connectedElements`, `builtInParameter`, `elements`, `temporaryFile` | private / public parameters | no |
| Style | `LayoutPointExportCandidate.SignatureStatus` of type `SignatureState` | `LayoutPoints/LayoutPointExportCandidate.cs:54` | Status vs State (same on `SuspendedSupport`, part 2) | `SignatureState` | 4 | **XAML bindings** in the Layout Point Export and Suspended Support Manage grids |
| Style | `MarkDuplicates` / `SetIsDuplicateId` / `FlagTooLongCandidates`; `LayoutPointRecipeIngredients.LayoutDefinitions` | `LayoutPoints/LayoutPointTools.cs:284`, `LayoutPointExportCandidateFactory.cs`, `LayoutPointRecipeIngredients.cs:7` | Three verbs for one action; every other class says `DefinitionSet` | `FlagDuplicateIds` on both sides; `DefinitionSet` | 2 / private | no |
| Style | `CoordinateExtensions.GetNormal` (private); `DistanceToStructureAbove`, `GridPointTolerance` | `Geometry/CoordinateExtensions.cs:46, 16` | Face normal from a reference; unit-less doubles in feet | `GetFaceNormal`; `…Feet` suffix or docs | private / 1 | no |
| Style | `CoordinateExtensions.Rounded(XYZ, int)` | `Geometry/CoordinateExtensions.cs:154` | Unused outside its tests; null gives the origin (documented) | delete | 0 | no |
| Style | `FabricationPartExtensions.LogVariousPropertyValues`, `SetElevationFromReference`; `ProductCodeChecks.Create`; `TypeBoundSharedParameterScanner.TryGetGroupLabel` | `Fabrication/FabricationPartExtensions.cs:211, 326`, `ProductCodeChecks.cs:13`, `Families/TypeBoundSharedParameterScanner.cs:69` | "Various"; "Reference" means an `ObjectReference`; builds a result, checks nothing; "Try" that returns a string | `LogPartPropertyValues`, `SetElevationByObjectReference`, `CreateResult`, `GetGroupLabelOrEmpty` | 2 / 2 / 1 / private | log file names shown |
| Style | `GetCustomData100…`/`105…` getters; G09 locals (`filenamePost`, `directoryPost`, `get01IdPrefix`, `listOfDeleted`, `layoutPointElements`, `mgr`, `fp`) | `Fabrication/FabricationPartExtensions.cs`, `LayoutPoints/*` | Slot numbers match the data (keep), but two "missing" sentinels (`"<no data stored>"`, `-1`) are undocumented; locals don't say what they hold | document the sentinels; `exportFileName`, `exportDirectory`, `idPrefixText`, `deletedIds`, `candidates`, `manager`, `parameter` | many / private | sentinel texts shown |

## Dropped or downgraded
| Finding | Group | Why |
|---|---|---|
| `IDocumentCache.GetData` (Misleading) and the caches' `Cache` property (Vague) | G07 | Both covered by the open KWD3-7 (`ICache`) restructure; first pass said the same. |
| `GetApplicationReportsDirectory` (Misleading and bug) | G07 | Filed as KTRL5-139. |
| `CategoryExtensions.ExportToCsvReport` header (bug) | G07 | Documented "Known issue, kept as moved" in its XML docs; first pass listed it as documented on purpose. |
| `TagDistributor` `OrderBy(X)` then `OrderBy(Y)` (bug) | G07 | Not a bug: LINQ `OrderBy` is stable, so the second sort keeps the X order for equal Y. It works as `OrderBy(Y).ThenBy(X)`. A `ThenBy` would be clearer, but nothing is lost. |
| `ConnectorWrapper.LoadDimensionsFrom` (Vague) | G07 | Keeping the connector it loads from is part of loading; the first pass already reworked this method. |
| `VictaulicConnectorTools.GetAllConnectionInfos`, `tapOwner`, `ConnectorInfoVictaulic` | G07 | Obsolete Victaulic code; leave to KTR5-4678 (Vicious cleanup). |
| `GetElementsByScopeAndFilter` / `GetElementsByTypeAndScope<T>` exception type (bug) | G08 | Filed: KTRL5-103 (remaining `ScopeType` guards). |
| `GridTools.GetNearestIntersection` (bug) | G08 | Dead code only (moved to R11). The Z claim is wrong: every intersection shares the grids' Z, so a constant Z offset does not change which one is nearest. The only caller passes point-located layout points. |
| `GetElementsByFilter(List<ElementId>)` docs (bug) | G08 | A docs copy error, not behaviour; in R5. |
| `DeleteAllOfType<T>` cascade (bug) | G08 | No caller outside tests; the first pass already noted the cascade risk as uncertain under KTRL5-143. Docs in R5. |
| `GetValueAsString` docs (bug) | G08 | Docs mismatch, not wrong behaviour; in R7. |
| Sheet / SHEET (bug) | G08 | First-pass item carried in KTRL5-144 and not applied; in R7 as "first pass, not applied". |
| `DocumentExtensions.GetOrCreateParameterFilterElement`, `DeleteAllOfType`, `AssemblyInstanceExtensions.Rename`, `CreateSpoolSheet` (Misleading → Vague) | G08 | `AGENTS.md` asks for `Core` only for twins; with no twin, a docs line is the fix. `Rename` does rename the assembly, so it is vague, not wrong. |
| `SetBottomOrTopElevation` (Misleading → Style) | G08 | The twins differ by parameters, which `AGENTS.md` allows. |
| `ElementFilterExtensions/ElementIdExtensions/ElementExtensions.Validate` → `ThrowIfInvalid` | G08 | House style used across every layer; the first pass already reworked `Validate`. |
| Event handler `Execute` methods | G08 | The reader suggests leaving them; the type name carries the meaning. |
| `IsDuplicateName` (Misleading → Vague) | G09 | The CSV Name column is the layout point Id, and the first pass kept "Name" on purpose (`LayoutPointExportCandidate` remarks). Only the term differs. |
| `CoordinateExtensions.Rounded` (Misleading → Style) | G09 | Null giving the origin is documented; the method is unused, so it moves to R11 as a delete. |
| `UpdateSavedCoordinates` pair (Vague → Style) | G09 | Twins told apart by parameters, which `AGENTS.md` allows. |
| `FabricationDatabaseTools.PlaceHangerSingle` order 1 vs 0 (bug) | G09 | `HangerLocation.PlacementIndex` is private and never read, so the value has no effect. |
| `LayoutPointTools.GetLayoutPointFamilySymbols` nulls (bug) | G09 | Documented ("kept so the caller can count them"; `FindFamilySymbol` documents the NRE). |
| `LayoutPointRecipeIngredients.GetLayer` "No support-rod usage found" (bug) | G09 | A visible sentinel, like the `QualityCheck.Invalid` texts beside it; `QualityCheck` is a pending decision. |
| `LayoutPointTools.Import` null element and workset cancel value (bug) | G09 | The null element case is documented (added to `failed` since 2026-10-15). A `String` cancel value against an int never matches, so the workset is always written, which is the intent. |
| `FabricationCustomDataPointReport.BuildPointStatusText` tab (bug) | G09 | Documented "Kept as moved: the extra tab before 'Missing'"; cosmetic. |
| `FabricationCustomDataLegacyWriter.WriteAndGetOwnedByOtherUser` commit in `finally` (bug) | G09 | Documented in its remarks as the intended behaviour. |
