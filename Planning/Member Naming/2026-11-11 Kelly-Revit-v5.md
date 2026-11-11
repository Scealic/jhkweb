# Member Naming Check: Kelly-Revit-v5 (the add-in)

2026-11-11. Linear: KTR5-4798. Approach: [Member Naming Check](../Member%20Naming%20Check.md). Previous layer: [Kelly-Revit-UI](2026-11-11%20Kelly-Revit-UI.md).

**Read:** all 436 source files and 18 XAML files (about 16,400 lines of C#): the host in `src/` and the six modules. Every member was checked at every severity, private ones, view-model commands and XAML `x:Name`s included. Five Sonnet agents read about 3,300 lines each. They worked from one brief listing the rules from the layers below and the titles of the 175 open KTR5 issues, so they didn't report known problems again. I checked each suspected bug against the code. Reach is the number of files outside the command's own folder that use the name. "Bound" means a XAML file binds it by name, so a rename has to change the XAML too.

**Result:** about 75 misleading names, 60 vague names and 50 style notes. The host (`src/`) and the Updaters, BillOfMaterial and ribbon classes are named well. The weak names cluster in three places:

1. **View-model commands named for the button, not the work, and bound in XAML.**
   - `ModuleCreatorViewModel.CommandCreateModule` writes JHK Module Number to the selection; it creates no module.
   - `SpoolManagerViewModel.CommandUpdateWeldLocationTerm` only picks a value; nothing is written.
   - `CommandSetSelectedObjects` selects in Revit.
   - `CommandGetSpoolData` loads the grids.
   - `CommandTagSelectionButtonClick`, `CommandSetExtensionsButtonClick` and `CommandSetVerticalSupportSizeButtonClick` put UI event words in command names.
   - `CommandReadSpoolTypesWithPrefix` filters by line number.
   - `ModuleManageViewModel.CommandUpdateBillOfMaterialType` always sets Module.
   - `CommandGetPoints` reads a file and may close the window.
   - Every rename here changes the XAML too.
2. **XAML `x:Name`s copied from other tools.**
   - `CreateSpoolSheetComboBox` is a TextBox for the rod size.
   - `CreateAssemblyButton` adds a value or creates a spool.
   - `BackgroundListComboBox` is the level combo on import.
   - `AssemblyCreateWindow`, `AssemblyManagerWindow`, `PendentSupportTaggerWindow` and `LevelizerWindow` are old window names.
   - `TabItem`s are named `…TabControl`.
   - Typos: `SpoolWledsTabControl`, `AssignerContrextControl`, `PointToPipeeWindow`, `SignatureHaseColumn`.
3. **One feature, several words.**
   - Assigners use AutoSet, AutoAssign, AutoAssignSwitch and Toggle for one thing (the glossary says "Auto-Set toggle").
   - "Reset" means both "reset the combo box" and "clear the parameter".
   - "Spool Name" and "Spool Number" are used for one value.
   - Manage vs Manager, and Create vs Creator.
   - Select-in-view and zoom check box pairs are named two ways (this comes from Kelly-Revit-UI).

**Dialog titles and Undo texts with old tool names:**
- "UpdateElements Item Number Warning"
- "Export Valve Information Issue"
- "Set Field Trim End Test"
- "Confirm Delete All Filters From Project?", although the command deletes only unused filters
- "Set Detailing PackageCombo Box", missing a space

## Behaviour bugs found on the way (filed)

| Issue | Priority | Tool | Bug |
|---|---|---|---|
| **KTR5-4801** | High | Vicious Fabrication Hanger Place | The options window's result is ignored, so closing it without OK still places hangers with whatever settings it holds. |
| **KTR5-4799** | Medium | Duct Item Number Set | Picking a duct that isn't in the item number list ends the tool silently: `continue` leaves `ElementId` set, so the pick loop exits. |
| **KTR5-4800** | Medium | Unused Family Type Delete (Manager) | Also deletes unused shared parameter elements; the confirmation the user answers doesn't say so. |
| **KTR5-4802** | Low | Trapeze Extend split button | Built with the text "Spool" (copied from the spool split button). To confirm in Revit whether that text shows. |
| **KTR5-4803** | Low | Vicious Instance Rotate Move | The saved dialog position is ignored on a monitor left of or above the primary, so the dialog reopens centred. |

**Checked and not filed:**
- **Spool Manager** sets `SpoolItemTabControl.SelectedIndex = 4` after creating sheets. That tab control may have fewer tabs, but the view has more than one tab control, so this needs a look in Revit before filing. Noted in A2.
- **Spool Create** closes its window even when no spool was created (low confidence about the intent). Noted in A2.
- **Layout Point File Directory Open** has a dead "folder missing" branch, because the folder is always created first.
- **CollectorTesting** always returns Succeeded. It is a developer tool.
- **Already filed:** the Spool and Module Auto Set buttons that do nothing are KTR5-4780.

## Findings by area

Each list names the member, what it actually does where the name hides it, and the suggested name (→). The rename issues A1 to A5 carry the full tables with file and line.

### A1: Assigners, Updaters, Views, BillOfMaterial (Trade.All)
- **Misleading:**
  - `CommonComboBoxContextAdoptCommand.GetElement` shows a dialog unless exactly one element passes the filter.
  - `GetParameterValue` warns **and changes the Revit selection** when the value is empty.
  - `DeleteProjectFiltersNotification` asks for confirmation → `ConfirmDeleteProjectFilters`.
  - `ContextValueAddView.CreateAssemblyButton` is the "Add" button. Its click handler only closes the dialog.
  - `ContextValueAddViewModel.IsSelected` is "set as current in the combo box" → `IsSetAsCurrent` (bound).
  - `CommonAutoAssignerTools.ResetUpdater` disables the updater → `DisableUpdater`.
  - `PipeAndWeldFieldTrimLineColorViewFilterCommand` applies BOM-type filters, which matches KTRL5-145's `ApplyPipeAndWeldFieldTrimFiltersOperation`.
- **Vague:**
  - `ContextValueAddDialog.Run` returns `Result?`, where null means "added".
  - `AssignerViewFilterCommand.Operation` and `RuleType`.
  - `ServiceComboBoxEventHandler.OnCurrentChanged` also selects the matching system.
  - The dead `AssignerContext.CloseMenuItem_Click`.
- **Style:**
  - The AutoSet/AutoAssign/Toggle vocabulary.
  - Reset vs Clear vs Unassign.
  - Spool Name vs Number on the line-colour filter.
  - `IsConstructed` has a public setter.
  - XAML leftovers: `AssignerContrextControl`, `moduleCreator`, `ContextAdderWindow`.
  - Two prompt texts (above).

### A2: Spools and Supports (Trade.All)
- **Misleading:**
  - `SpoolSheetOpenCommand.TileSheets` asks a question → `AskToTileSheets`.
  - `SpoolManagerViewModel.UpdateWeldLocationTerm`, `SetSelectedObjects`, `GetSpoolData`, `SetSpoolName` and `JogSpoolGrid`.
  - `SuspendedSupportManagerViewModel.GetData` refreshes.
  - `SetTag`/`TagSelectionButtonClick` write the next tags.
  - `AttachVerticalSupportButtonOnClick` attaches **or extends**.
  - `ModuleManageViewModel.UpdateBillOfMaterialType` always sets Module.
  - `ModuleManageView.ToggleItemizeComponentsButton` toggles nothing.
  - `SpoolsTabControl_SelectionChanged` handles `ModuleItemTabControl`.
  - `ModuleCreatorViewModel.CommandCreateModule` writes the module number.
  - `CreateModuleNumber` also enables a button.
  - `SpoolCreateViewModel.CommandReadSpoolTypesWithPrefix` filters by line number.
  - `CreateSpoolName` also enables a button.
  - XAML: `CreateSpoolSheetComboBox`, `RdoSelectionScopeIsProject1/2`, `PrefixIsModuleNumberRadioButton`, and five `…TabControl` names on `TabItem`s.
- **Vague:**
  - `SpoolItemTagTextBoxValue`.
  - `RunManualUpdaters` also selects.
  - `UpdateTag`.
  - `DelegateCommandUpdateValues`.
  - `ModuleTypesWithPrefix` holds module numbers.
  - `CommandContentRenderedEvent`.
  - `VerticalSupportSize` vs "vertical member".
  - `SpoolCreateViewModel.Create`/`CreateSpool(obj)`, where `obj` is unused.
  - `ResetRadGridView`.
  - `SpoolCleanCommon.CleanByScope` also shows dialogs.
  - Old window and control names (Assembly…, Pendent…).
- **Style:**
  - `ShowTaggedNot` and `ShowTagSignatureMatchedNot`; `ShowAttachedOrExtendedNot` is dead.
  - Match / Mismatch / MatchedNot for one state.
  - `UpdateSpoolOnly` and `UpdateSpoolAndItems`; the second is never read.
  - `CreateButtonIsEnabled`.
  - `SettingFile` vs `SettingsFilePath`.
  - `TerminologyModels` holds spool categories.
  - `SpoolNameLast`.
  - The `Delegate…` prefix.
  - `AllowUnHostedHangers`.
  - XAML typos: `AllowUnHostedSCheckbox`, `FieldTrimTextBoxtackPanel`, `SignatureHaseColumn`, `AllAreAttachedOfExtendedColumn`, `SpoolWledsTabControl`.

### A3: Acquired (Vicious tools), schedule exports, About, Many Connect, Penetration Tag, Family Shared Parameter Report (Trade.All)
- **Misleading:**
  - `ViciousInstanceRotateMoveCommand.IsCancelled` is set by Close, while the rotations made are kept (KTR5-4803).
  - `RotateElements` also rotates the crop box.
  - `ViciousFileBasedSystemPipePlaceViewModel.LayoutPointFilePath` is the Point To Pipe file → `PointFilePath` (bound).
  - `ImportXls` reads XLS, XLSX and CSV.
  - `SetWorkPlaneAndPickObject` picks a point and rolls back.
  - `SelectMethod` is the placement method.
  - `ConvertExcelToDataTable` reads the first worksheet.
  - `ViciousInstanceElevationAssignViewModel.ElementsOfMultipleLevelsSelected` shows a warning.
  - `ApplicationAboutModel.UserAddinsAllLocation` → `AllUsersAddinsLocation`, and `AppVersionName`/`AppBuildVersion` are Revit's (both bound).
  - XAML: `SaveLineNumberCheckbox` is "Adjust For Insulation?"; `BackgroundListComboBox_SelectionChanged` handles the level combo.
- **Vague:**
  - `CommandProcessElements`/`ProcessElements` assign a level or an elevation (bound).
  - `Arranger.Elements(alignType)`.
  - `Location` and `RotationAngle` (degrees).
  - `ColX`/`ColY`/`ColZ`/`ColSize`.
  - `PointUnits`/`SizeUnits` are combo texts.
  - `OkButton_Click` also saves and copies settings.
  - `RadFilePathPicker_DialogOpening`.
  - Hanger options: `UpdateCheckbox`, `btnOK_Click` and the `TextBlock` x:Name.
  - `ManualValue` and `DesiredElevation` (feet).
  - The four `ExportSelectedSchedules` also open Explorer.
  - `ExportSchedule`'s 0-based index vs the 1-based `sheetIndex`.
  - The unused `ApplicationAboutModel.Name`.
- **Style:**
  - Properties named like their types (`ApplicationAboutModel`, `…Command`, `…Tools`, `HangerPlaceSettings`).
  - `_distinctElevation`.
  - XAML: `PointToPipeeWindow`, `CmbPipeType`, `FilePathFilePathPicker`, `LevelizerWindow`.
  - `workBook` vs `workbooks`.
  - `toleranceDeg`.
  - `FamilySharedParameterReportCommand` reports type-bound parameters only.

### A4: Layout points, the rest of Trade.All, the host
- **Misleading:**
  - `LayoutPointFromCommaSeparatedValueImportViewModel.CommandGetPoints`/`GetPoints` → `LoadPointCandidates` (bound).
  - The export view model's `SelectedObjectsExportQualityCheck` and `SelectedObjectsExportNotifyUser` ask the user.
  - `UpdateSelectionIssuesLabel` also enables buttons.
  - `SetRadGridViewToDefault` also resizes the window.
  - `Reset` and `Save` → `ResetHostElements` / `SaveToHostElements` (command handlers).
  - XAML: `BackgroundListComboBox` on import is the level combo.
  - `SiteComboBox` is a StackPanel.
  - `CheckedOutCheckbox` and the "Checked Out" column mean "owned by others"; the header text is shown to users.
  - `ShowIngredientsCheckbox` → recipe.
  - `ShowElementIdCheckbox` → parent element data.
- **Vague:**
  - `ComboBoxExtensions.GetSelected*` (6) vs `GetChosen*` (4), near-synonyms used in 17 assigner files.
  - The `ComboBoxExtensions` class holds no public extension.
  - `ScopeChange` and its unbound `CommandScopeChange`.
  - `SetScopes`.
  - The unbound `Statistics…` counts.
  - The never-assigned `DelegateCommandProgressBar`.
  - `LayoutPointNumbersLast`.
  - `GetWidth`.
  - `RadGridView1_RowLoaded`.
  - The empty `ImportViewModel.CreateObjects`.
  - The `EventService` handler properties are named like the Revit events.
- **Style:**
  - `CommandIdentifyDuplicatePoints` vs `MarkDuplicatesButton`/`MarkDuplicates`.
  - `SpecifyLevel`.
  - `AddUnSelectedSiblings`.
  - `ShowSavedCheckbox` vs `SavedCheckbox`.
  - `ViewPlansToExport` are background plans.
  - `App.GetAddinGuid` returns an `AddInId`.
  - `App.Caches` is an abstract class of statics.

### A5: Contenter, Developer, Duct, Manager, Pipe
- **Misleading:**
  - `DuctItemNumberSetCommand.UpdateItemNumber` asks Yes/No (KTR5-4799).
  - `DuctRunItemNumberSetCommand.HasRequirements` shows a dialog.
  - `ResetItemNumbers` also selects the run.
  - `DuctItemNumberResetCommand`: `Step00_GetElementIds` returns elements, `Step01_UpdateElementDataModels` is empty, and `Step02_ExecuteOperation` clears the numbers.
  - `ElementInstanceCoordinateReportCommand.CoordinateTesting` shows a report.
  - The six `CollectorTestingCommand.GetElements…` always return true.
  - `SandboxCommand.Get…Report` writes to the log.
  - `OletCheckViewModel.ShowDisconnected` selects (bound).
  - `SelectFieldTrimEndCommand` also writes Comments and places a marker. Its Undo text is "Set Field Trim End Test".
- **Vague:**
  - `NotifyDetailer`.
  - The two `RunCommand` bodies.
  - `CreateDomainGroupReport` also saves and opens.
  - `GetCategoryTypeRecords` throws when empty.
  - `CollectorTestingCommand.Selection`.
  - `OletGrid_SelectionChanged` handles `OletRadGridView`.
  - The Window Mockup `ViewGroupControl`.
- **Style:**
  - `…LabelBackgroundColor` returns a brush (bound).
  - `MisAligned*` (bound).
  - `OnComplete` is an Action.
  - `ZoomToElements` is a bool.
  - `ElementId`.
  - The unused `x:Name`s.
  - The unused `DefinitionSet` fields in three Duct commands.

## Linear issues (filed 2026-11-11)

A1 **KTR5-4804**, A2 **KTR5-4805**, A3 **KTR5-4806**, A4 **KTR5-4807**, A5 **KTR5-4808**. All in KTR5, Low, labelled Add-In Wide with each module touched, related to KTR5-4798. Each renames the members and updates the XAML bindings and `x:Name`s in the same change. It adds XML docs where they are missing, resets the `Author` stamp of the tests it touches, and builds every configuration. Button texts, tab names, dialog titles and Undo texts change only where listed as wrong (the old tool names and typos above).

| # | Scope | Notes | Estimate |
|---|---|---|---|
| A1 | Assigners, Updaters, Views, BillOfMaterial | Includes choosing one word for the Auto-Set toggle and one for Reset vs Clear (maintainer decides, then renames classes and ribbon names) | 2 |
| A2 | Spools and Supports view models, views and XAML | The most bound members; coordinate with the open Spool Manager, Module Manager and Suspended Support Manager issues; check the tab index after sheet creation | 4 |
| A3 | Vicious tools, schedule exports, About, Many Connect | Coordinate with the Vicious cleanup issues (KTR5-4678 and its children) | 2 |
| A4 | Layout Point Import/Export, the ribbon `ComboBoxExtensions`, host | Coordinate with the open Layout Point Export issues | 2 |
| A5 | Contenter, Developer, Duct, Manager, Pipe | Includes the dialog titles and Undo text with old tool names | 2 |

## The whole check

This was the last layer. Across the six v5 layers checked on 2026-11-11:

| Layer | Bugs filed | Rename issues |
|---|---|---|
| Kelly-Windows-Data-v3 | – | KWD3-14, KWD3-15 (+ KWD3-7, KWD3-13 commented) |
| Kelly-Windows-v3 | KW3-29 to KW3-31 | KW3-32 to KW3-37 |
| Kelly-Domain | KD-61, KD-62 | KD-63 to KD-68 |
| Kelly-Revit-Logic-v5 | KTRL5-133 to KTRL5-139 | KTRL5-140 to KTRL5-149 |
| Kelly-Revit-UI | KTRUI-30 to KTRUI-32 | KTRUI-33, KTRUI-34 |
| Kelly-Revit-v5 | KTR5-4799 to KTR5-4803 | KTR5-4804 to KTR5-4808 |

The renames go bottom-up: a lower layer's public renames reach the add-in only after that layer is packed and the layers above are repinned. Three decisions come first because they set names in many places:
- KTRL5-149, the transaction suffix rule.
- KD-68, the names written to data files and settings.
- The Auto-Set and Reset vocabulary (A1).
