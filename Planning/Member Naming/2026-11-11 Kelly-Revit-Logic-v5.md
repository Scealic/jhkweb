# Member Naming Check: Kelly-Revit-Logic-v5

2026-11-11. Linear: KTR5-4798. Approach: [Member Naming Check](../Member%20Naming%20Check.md). Previous layer: [Kelly-Domain](2026-11-11%20Kelly-Domain.md).

**Read:** all 253 source files in `src` (about 30,000 lines), every member at every severity, private ones included. Nine Sonnet agents each read about 3,300 lines in full. They worked from one brief listing the rules from the layers below, the domain glossary, and the 67 open KTRL5 issues, so they didn't report those again. I checked every suspected bug against the code. Reach is the number of files in Kelly-Revit-UI ("UI") and Kelly-Revit-v5 ("add-in") that use the name. A short or common name gives a noisy count.

**Result:** about 90 misleading names, 90 vague names and 70 style notes. This is the weakest layer so far for names that hide side effects. Four patterns account for most of them:

1. **"Get" and "Is" that change the model or show a dialog.**
   - These change the model: `SuspendedSupport.GetData`, `GetBearerData` and `GetVerticalMemberData` load fields. `ViewExtensions.GetCropBoxElement` reveals the crop box and restarts the transaction.
   - These show a dialog: `GetElementChangeErrorReport`, `GetSpoolEligibleElements` (which also writes a report file), `GetView<T>`, `GetFamilySymbol`, `IsOwnedByOtherUser(notifyUser)` and `GetParameterFilterElements`.
   - `PathExtensions.Get*Directory` (13 methods) creates folders on disk.
2. **Names that describe only part of the work, or the opposite.**
   - `AutoUpdaterManager.StateToggle` sets a state rather than toggling it.
   - `SetVisibilityByCategoryType(…, hidden)`: `false` shows the categories, and the Undo text says "Show" even when hiding.
   - `CategoryExtensions.IsParent` is true for a top-level category, and `SpoolItem` names its result `HasParentCategory`.
   - `PurgeAllOfTypeFromProject` deletes every element, used or not.
   - `DocumentExtensions.IsModifiable` means something different from Revit's own `Document.IsModifiable`.
3. **Same name, two meanings.**
   - `SpoolItem.SetItemNumber(int, int)` stores in memory, while `SetItemNumber()` writes to the model.
   - `SuspendedSupport.SetTag()` writes the host, while `SetTag(Tag)` sets the model only.
   - The private `ApplyToView` only sets visibility, while the public `ApplyToView` adds the filter (KTRL5-134).
   - `GetConnectedPart` has two overloads with different results.
   - `IsDuplicate` follows a different rule on import and on export candidates.
   - `GetElementIds` means category ids in one type, member ids in another, and a string parser in a third.
4. **No single rule for methods that open their own transaction.** The suffixes `…Transaction`, `…Tx`, `…WithOperation` and `…Operation` are all in use, some of those methods have no suffix at all (`DeleteUnusedSharedParameterElements`), and some methods with a suffix run inside the caller's transaction. One rule, decided once (L10), fixes many names at once.

Units: Revit lengths are decimal feet, but several names and formatters assume inches. That mix-up produced the worst bug found (KTRL5-133). `BearerSizeAsFractionalFeetAndInches` returns inches, `ExtensionTotal` is feet while its doc says inches, and `GetElevation` and `GetWeight` have no unit in the name.

## Behaviour bugs found on the way (filed)

| Issue | Priority | Member | Bug |
|---|---|---|---|
| **KTRL5-133** | High | `SuspendedSupport.SupportElevationStoredAsString` | Formats a feet value with an inches formatter: 10 ft shows as 0'-10" in the Suspended Support Manage grid. |
| **KTRL5-134** | High | `ViewExtensions.ResolveParameterFilterElement` | Sets the visibility of a filter it never adds to the view; Revit throws for a filter not in the view (to confirm in Revit). |
| **KTRL5-135** | Medium | `VictaulicConnectorTools.GetConnectors_Victaulic` | Casts a sprinkler (`FamilyInstance`) to `MEPCurve`, which throws `InvalidCastException`. |
| **KTRL5-136** | Medium | `TagLeader.UpdateLeaderPosition` | 0/0 = NaN elbow when a tag lines up with its target on X or Y. |
| **KTRL5-137** | Medium | `ElementExtensions.IsPipe` | True for any fabrication straight, duct and containment included. |
| **KTRL5-138** | Low | `AlignsWithPipeCenterline`, `Olet`, `ValveData` | True when no straight is found; a one-connector olet passes the guard; a valve hidden in the active view throws. |
| **KTRL5-139** | Low | `AssemblyWarningSwallower`, `GetApplicationReportsDirectory` | Calls `DeleteWarning` on errors too; the reports folder is the logs folder. |

**Checked and not filed:**
- **Documented on purpose:**
  - `GetFilters().Clear()` clears a copy.
  - `AttachOrExtendToStructure` resolves the origin and doesn't use it.
  - `SaveToHostElementsTx` returns candidates "written or not".
  - `AssignSelectedTransaction` returns true when the operation can't start.
  - `CategoryExtensions.Export`'s header has no matching column.
- **Already filed:** `IDocumentCache.GetData` follows KWD3-7.
- **Smaller ones, carried in the rename issues below:**
  - `Module.IsDetailed` is true for a module with no spools.
  - A spool sheet is created as "Sheet" but renamed to "SHEET".
  - `HangerPlacementService` messages contain "StartTransaction End Distance" and "somehow has is connected".
  - `ParameterExtensions.SetValue` never returns `ValueTooLong`.
  - The `ScopeType` guards throw the wrong exception type.
- **Uncertain:**
  - `PurgeAllOfTypeFromProject` may throw on cascaded deletes.
  - `SetLevelOfFamilyInstance` rewrites the offset when the level change was refused.
  - `UpdateGridPointDataTx` changes the model on a cancelled run.
  - These are noted in L4, L5 and L8 for checking when those issues are picked up.

## Findings by area

Each list names the member, what it actually does where the name hides it, and the suggested name (→). The rename issues L1–L10 carry the complete tables with file and line.

### Updaters (L1)
- **Misleading:**
  - `StateToggle` sets a state → `SetUpdaterEnabled`.
  - `ModuleNumberElementService.SetValue` and `SetValueTransaction` write to every element.
  - `ElementService.SetElements(filteredElementIds)` takes elements, not ids.
  - `SizeElementDataModel.SetGrouping` returns a string → `FormatGroupedSize`.
  - `AutoUpdater.FilterElements` expands nested and assembly members rather than filtering.
  - The `ServiceOfFabricationPart…InitializeElementService` override also sets the change type.
- **Vague:**
  - `ReportOf…` writes a CSV and opens it.
  - `Remove(Document)` releases document state.
  - `BuildStepAlphaCreate` to `DeltaAbleByDefault`.
  - `LogicalAndFilter` → `TriggerFilter`.
  - `SuperClassName` → `UpdaterName`, together with KW3-35. It is the updater name shown in UpdaterRegistry.
  - `CustomDataUpdater.SetValues` → `LoadFromRecord`.
  - Eight private `UpdateElements()` methods hide the public one.
- **Style:**
  - `DefaultState` → `IsEnabledByDefault`. Its value is shown in Revit as "Default State: True".
  - `RibbonSelections.System` clashes with the `System` namespace.
  - Typo: `…HphCode`.

### Spools, Signatures, Projects (L2)
- **Misleading:**
  - The two `SetItemNumber` overloads (one stores in memory, one writes to the model).
  - `Spool.SetItemNumbers` → `WriteItemNumbers`.
  - `ItemNumber.Update` → `WriteSequence`.
  - `ElementComponent.UpdateElement`.
  - `GetSpoolEligibleElements` also writes a report and shows a prompt.
  - `CleanSpoolsTx` → `RemoveNonSpoolableItemsTransaction`.
  - `UpdateItemNumbersTransaction` returns a list even after a rollback.
  - `GetElementIds`: Module returns assembly plus component ids, Spool returns member ids.
- **Vague:**
  - `Process…` sheet and view builders → `GetOrCreate…` / `Place…`.
  - `SpoolItem.Report` → `NonSpoolableReport`.
  - `ItemNumberTools` Clear vs Reset.
  - `ProjectInformationWrapper.Set` and `Name`/`NameInternal` (the class is `[Obsolete]`).
- **Style:**
  - Four spellings of one idea: `IsSpoolAble`, `Spoolable`, `SpoolEligible` and `Numberable…`.
  - `SetSpoolName` sets the spool number.
  - `Module.IsValidModule`.

### Supports, Arrangement (L3)
- **Misleading:**
  - `GetData`, `GetBearerData` and `GetVerticalMemberData` load from the host → `Load…`.
  - `TagLeader.GetTagDimension` → `MeasureTag`.
  - `BearerSizeAsFractionalFeetAndInches` returns inches. It is bound in XAML, so check the binding before renaming.
  - `SetTag()` writes to the host → `WriteTagToHost`.
  - `SuspendedSupport.TryParse` builds from an element → `TryCreate`. Used in 5 add-in files.
  - `TrapezeVerticalMemberTools.ExtendToStructure` and `Reset` also clear the tags.
  - `VerticalSupportMember.EndSupportOffset` → `StrutExtensionPastRod`.
  - `AnnotationElement.Parent`.
- **Vague:**
  - `PrepareAnnotationElements` commits a transaction.
  - `ExtensionTotal…` is feet.
  - `Bottom/TopEndToSupportElevation`.
  - `HangerPlaceSettings.ButtonDatas` and `Service`.
  - The `observedClassName` parameters are progress titles.
- **Style:**
  - `SignatureTagPairMatch`.
  - `SetVerticalMemberSize` vs `SetVerticalMemberSupportSize`.
  - `TryGetHangerButtonDatas` returns an enum.
  - `ArrangerToolkit.RevitReferencesToElementIds(document, …)` never uses `document`.
- **Text fixes:** the hanger placement messages.

### Documents, Families (L4)
- **Misleading:**
  - `IsModifiable`, which clashes with Revit's own `Document.IsModifiable` → `IsEditableProject`.
  - `PurgeAllOfTypeFromProject` deletes used elements too → `DeleteAllOfType`.
  - `GetDocumentInformation` appends to a builder.
  - `GetDocumentType`'s `extension` out parameter.
  - `DeleteUnusedSharedParameterElements` opens its own transaction.
  - `GetView<T>(…, isTemplate)` shows a prompt.
  - `GetFamilySymbol` shows a dialog.
  - `ResolveSharedParameter` → `EnsureFamilyParameter`.
  - `SetRevisionInformation` also adds parameters → `StampFamilyRevision`.
- **Vague:**
  - `GetPath`.
  - `GetDefinition` → `GetBoundInternalDefinition`.
  - `SynQuishOnDemand`.
  - `SetIdTransaction` (an SQL-era term).
  - `DeleteKellySharedParameterElementsTransaction`.
  - `EraseSchemas` returns a log.
  - `DeletePlacedFamiliesTransaction` and `GetPlacedFamilyIds`.
  - `HasInstancesFast`.
  - `EventHandlerTools.LogEventHandlerArgumentName` and `Run`.
- **Style:**
  - `WorkSet` vs `Workset`.
  - `GetOrCreateParameterElementFilter`.
  - `Jhk` vs `Kelly` prefixes.
  - `SetLevelOfFamilyInstance`.
  - `CreateAtCoordinates(…, document)`.

### Elements (L5)
- **Misleading:**
  - `GetElementChangeErrorReport` shows a dialog and writes a file → `Show…`.
  - `GetWorkSharingInfo`.
  - `IsOwnedByOtherUser(notifyUser)`.
  - `GroupTools.ProjectContainsGroups` asks for confirmation → `ConfirmUngroup`.
  - `UnGroupGroups` (Undo text).
  - `WorksetExtensions.SetVisibilityWithOperation` sets the default visibility.
  - `ResetValuesTransaction` runs one transaction per definition.
  - `GetParameter(Element, string)` returns shared parameters only, and null for duplicates.
  - `GetValue(…, BuiltInParameter, string)` also rewrites quotes.
  - `ElementInstanceModel.TypeName` (`[Obsolete]`).
- **Vague:**
  - `ProcessAssemblies` and `ProcessFamilyInstances`.
  - `SetCorrectLevel…`.
  - `SetOffsetBase`.
  - `GetElementLocation`.
  - `GetRelativeCoordinate` → `GetTransformOrigin`.
  - `GetElevation` and `GetWeight` (units).
  - `MepConnections`.
  - `AssemblyInstanceExtensions.GetView`.
  - `ElementFilterTools.InstanceHavingParameterOfTypeStringValue`.
- **Style:**
  - `nullValue` → `defaultValue` (9 overloads).
  - `overWrite…`.
  - `sharedParameterName` parameters hold definitions.
  - `ElementIdExtensions.GetElementIds(arrayOfElementIds)` parses a string.
  - `Validate(…, Document)` never uses the document.
  - "Sheet"/"SHEET".

### Views, Materials, Entities (L6)
- **Misleading:**
  - `ViewFilterFactory.CreateFilterRule` adds to a list.
  - `GetFilter` creates and resets.
  - `VisibilityCommon.AddRuleToFilter` replaces the filter.
  - `MaterialTools.Read` and `Create` (find-or-create, with a dialog).
  - `SetVisibilityByCategoryType(hidden)` has an inverted bool, and its Undo text says "Show".
  - `CropRegionVisibleToggle` doesn't toggle.
  - `GetCropBoxElement` changes the view.
  - `ResetFilterOverridesInViewWithTransaction(removeFilters)` can remove the filters.
  - `ViewFilterSets.BomTypeEquals…` look like predicates but apply filters.
  - `ServiceSignatureLineColorFilters` also applies fill.
  - `ApplyPipeAndWeldFieldTrimFiltersOperation` has nothing to do with pipe or weld.
  - `GetSelectedSchedules` shows a prompt.
  - `PhysicalElementEntity.SetTag` stores in memory only.
  - A leftover `[Column("dbo.Component.Id")]` attribute.
- **Vague:**
  - `RemoveFiltersBasic`.
  - `Export` (DWG, CSV).
  - `CreateDetailingPackageViews` also updates existing views.
  - `GetOrPrepareStratusTemplateView`.
  - The `ExportToXlsx…` return values.
  - `DataContextViewFilterTools.CreateAndApplyFillAndLineTransaction` uses the active view.
  - `SetWorksetVisibility` sets every user workset.
  - `OperationType` has 15 unused members. Only Hide and Isolate are used, and they appear in saved filter names.
- **Style:**
  - `IsTagAbleView`.
  - `FilterRuleTypes` holds one value.
  - Bool parameters without Is/Should.

### Mep, Connectors (L7)
- **Misleading:**
  - `IsStraightOrFamilyInstanceHavingUnusedConnector` → `HasUnusedConnector`.
  - `FindClosestFacingConnectors` covers unconnected connectors only.
  - `ConnectorWrapper.SetDimensionGrouping` and `SetDimensionValue` (which duplicates on a second call).
  - The two `GetConnectedPart` overloads.
  - `PointToPipeReport.RefuseConversion` → `MarkConversionRefused`.
  - `GetConnectors_Victaulic` (KTRL5-135).
  - `GetConnectedRun` is a shortest path.
  - `AlignsWithPipeCenterline` (KTRL5-138).
- **Vague:**
  - `Olet.PipeSize` and `PointToPipeData.Sizes` (feet).
  - The `tolerance` parameters, which are a dot product in one place and degrees in another.
  - `GetClosestTo` vs `GetConnectorClosestToCoordinate`.
  - `MoveAndConnectTx`.
- **Style:**
  - `TapOwner` is a list.
  - `MisAligned`.
  - `GetProjectVicUnits`.
  - `CreateValveDatas`.
  - `FabricationConnectorTools.GetName` returns "Error".
  - The obsolete `VictaulicConnectorTools.DisconnectAll` should be deleted.

### LayoutPoints, Fabrication, Geometry (L8)
- **Misleading:**
  - `HasAllCustomDataPoints` returns a list.
  - `WeldLocationService.SetEndPreparation` refreshes rather than sets.
  - `SetWeldLocation(weldName)` and `ProductRange10Joints01Weld.SetLocation` also write the BOM type.
  - `SetLocationTransaction`.
  - `BillOfMaterialTypeAssigner.GetSelectedElements` refills a field.
  - `GetLastLayoutPointIds` and `CheckLengthOfDataToSave` write state.
  - `ExportToCsvTx` also writes the Exported flag and a DWG.
  - `GetOrderedLayoutPoints` returns instances.
  - `OnQualityCheck` is constant.
- **Vague:**
  - `FabricationCustomDataLegacyWriter.Write`.
  - `SetLayoutPoint` → `BuildLayoutPoint`.
  - `Get01IdPrefix` to `Get10…` are numbered, and their words differ from the recipe's.
  - `CheckCustomData`, a duplicate of `HasCustomData`.
  - `SetTemporaryWorkPlane` creates a plane.
  - `CoordinateConversionExtensions.ToRevit`.
- **Style:**
  - `GetOrderedButtonDatas`.
  - The `Tx` suffix (L10).
  - `TryParse` on string → `TryParseXyz`.
  - `IsEqualTo`.
  - "relative" vs "internal" coordinate.
  - The `SetCustomData…` setters drop "Jhk".
  - The `WelLocation` type is in KD-67.

### Parameters, Operations, Common, Categories, Caches (L9)
- **Misleading:**
  - `CategoryExtensions.IsParent` is inverted, and so is its `HasParentCategory` consumer.
  - `BuiltInParameterExtensions.GetElementIds` returns category ids.
  - `PathExtensions.GetProjectDirectory()` returns the root of all projects.
  - The `Get*Directory` methods create folders.
  - `TaskDialogSimple.TaskDialog*` show a `UserPrompt` (the type name contradicts its own docs too).
  - `ErrorNotSureWhyThisDialogAppears`.
  - `SharedParameterElementExtensions.Delete` docs.
  - `GetBoundCategoryIds` throws.
  - `SystemDocumentCache.Fill…` (KTRL5-28).
  - `ContextLists.GetLineNumberSets`.
- **Vague:**
  - `GetForgeTypeId` and `GetForgeTypeIdByName` → `GetGroupTypeId…`.
  - `GetCategories` → `GetBoundCategories`.
  - `CategoryExtensions.Export` and `Validate`.
  - `InsulationCategories.ExclusionFilter`.
  - `OperationService.Increment` and `Stop` → `Commit`. `Stop` is used in 30 Logic files.
  - `ParameterExtensions.GetValue(…, object)` returns a string.
  - `TransactionName.Executing`, `Batch` and `ExampleOperation`.
  - `IsFabricationOrFamilyPart_Victaulic`.
- **Style:**
  - The `TaskDialogSimple.Info*` names.
  - `GetLogsDirectory` and `GetProjectLogsDirectory` are the same folder.
  - `TransactionName.CreatedWorkset`, `UnGroupGroups` and `…RadGrid…` (Undo text).
  - `OperationService.ObjectModifiedCount` vs `ObjectCountSelected`.
  - `RevitVersion` holds a year.
  - `ParameterResultType` has members that are never used.

**Names written somewhere, so renaming them changes something users or files see:**
- `TransactionName` values are Undo texts and log names.
- `SuperClassName` is the updater name shown in UpdaterRegistry.
- `OperationService`'s `Duration` key is in `OperationServiceLog.jsonl`.
- `OperationType.Hide`/`Isolate` appear in saved filter names.
- `BuiltInCategoryMeta` columns.
- Revit shared parameter names.

Each issue below marks these, so a rename keeps the stored text.

## Proposed Linear issues (not yet filed)

All in KTRL5, related to KTR5-4798. Each renames the members, adds XML docs where they are missing, resets the `Author` stamp of the tests it touches, and is followed by repin issues in Kelly-Revit-UI and the add-in where the reach is not none. Stored texts (Undo names, the updater name, log keys, saved filter names) are kept unless the maintainer decides otherwise.

| # | Scope | Highest reach | Estimate |
|---|---|---|---|
| L1 | Updaters | `SuperClassName` (with KW3-35), `ReportOf…` add-in 1 each | 2 |
| L2 | Spools, Signatures, Projects | `GetElementIds` noisy, `GetSpoolEligibleElements` UI 1 / add-in 3 | 2 |
| L3 | Supports, Arrangement (+ hanger message text) | `SuspendedSupport.TryParse` add-in 5 | 2 |
| L4 | Documents, Families | `DeleteUnusedSharedParameterElements` add-in 2 | 2 |
| L5 | Elements (+ Sheet/SHEET) | `GetElementIds` UI 6 / add-in 11 (shared with L2 and L9) | 2 |
| L6 | Views, Materials, Entities (+ unused `OperationType` members) | `DataContextViewFilterTools` add-in 5 | 2 |
| L7 | Mep, Connectors | `FabricationConnectorTools.GetName` add-in 6 | 2 |
| L8 | LayoutPoints, Fabrication, Geometry | `CoordinateExtensions` add-in 10+ | 2 |
| L9 | Parameters, Operations, Common, Categories, Caches | `OperationService.Stop` 30 Logic files; `TaskDialogSimple` add-in 7 | 4 |
| L10 | **Decide one suffix** for methods that open their own transaction or operation (`…Transaction`, `…Tx`, `…WithOperation`, `…Operation`), then apply it across Logic; ties in with the `OperationService.Run` migration (KTRL5-3) | every folder | 2 |
