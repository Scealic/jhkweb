# Member Naming Check: Kelly-Revit-UI

2026-11-11. Linear: KTR5-4798. Approach: [Member Naming Check](../Member%20Naming%20Check.md). Previous layer: [Kelly-Revit-Logic-v5](2026-11-11%20Kelly-Revit-Logic-v5.md).

**Read:** all 66 source files and the XAML in `src` (about 4,400 lines with XAML), every member at every severity, private ones and XAML `x:Name` values included. One Sonnet agent read the whole repository, with the rules from the layers below and the 7 open KTRUI issues. I checked each suspected bug against the code. Reach is the number of files in Kelly-Revit-v5 (the add-in) that use the name.

**Result:** about 25 misleading names, 5 vague names and 10 style notes, most of them in the ribbon code. The MVVM interfaces (`IViewModel.CreateObjects`, `InitializeFirst`, `InitializeLast`, `IExternalCommandMvvm.InitializeCommand`), `CommandRunner.Run`, `MvvmDialog.Show`, `SelectionPickTools.TryPick*` and the scope extensions are named well.

Two layer-specific points:

- **`PushButtonText` constant names have drifted from their button text.** `SpoolIfcAssemblyInView` reads "Spool IFC Strut In View". `CreatePenetrationTags` reads "Sleeve Tagger". `ManagerGetDocumentLocations` reads "Location Points". `ExportToSingleCsvFile` reads "Export To .csv File(s)". `ExportToAMultipleXlsxFile` has a typo. The button text is also the icon key (`<ImageName>16.png`), so renaming a constant is free, but changing its text means renaming the icon files too.
- **Names Revit stores:**
  - Tab and panel titles come from `RibbonTabName` and `RibbonPanelName` via `ToReadableName()`. `Develop` and `Developer` name one concept, while `Manage` names two different things.
  - The push button `SuperClassName` is the ribbon item name.
  - These stay as they are unless the maintainer decides otherwise.

## Behaviour bugs found on the way (filed)

| Issue | Priority | Member | Bug |
|---|---|---|---|
| **KTRUI-30** | Medium | `RibbonExtensions.GetItemFromRibbonRowPanel` (private) | Returns the first row panel it meets, holding the item or not, and returns the row panel instead of the matching child, so `SetPowerIcon<T>` can set the icon on the wrong item. |
| **KTRUI-31** | Medium | `RadGridViewExtensions.RebindAndSelect` | Throws for an empty list; the layout point export passes an empty list when its save operation can't start. |
| **KTRUI-32** | Low | `RibbonExtensions.ResolveRibbonPanel` | Looks up panels on the Add-Ins tab only, then creates on the Kelly tab, so a second call for the same panel throws. |

Not filed: `ToggleAutoAssignIcons` throws `ArgumentNullException` for an item that isn't a push button, which is the wrong exception type. That fix belongs with the rename in U1.

## Misleading

### Ribbon (U1)

| Member | What it does | Suggested | Reach |
|---|---|---|---|
| `RibbonComboBox.GetComboBox` (+ `IRibbonComboBox`) | Finds the combo box on the ribbon and **assigns** the property; throws if missing | `FindAndAssignComboBox` | 6 |
| `RibbonComboBox.ResetComboBox(resetValue)` | Makes the **first** item current; succeeds only if its text equals `resetValue` | `ResetToFirstItem(expectedFirstItemText)` | 3 |
| `ProjectRibbonComboBox.CreateBasicComboBoxMembers` / `CreateProjectComboBoxMembers`, `RibbonComboBox.CreateProjectComboBoxMember` | **Add** items to the live combo box and set the current one (`CreateComboBoxMemberData` is the real "create"); the interface doc says "detailing package" only | `AddBasicItems` / `AddProjectItems` / `AddProjectItem` | 1–3 |
| `RibbonExtensions.GetRibbonCombos` | Can **create** the Kelly Tools tab; lists that tab only | `GetToolsTabComboBoxes` | 0 |
| `RibbonExtensions.GetItemByName` | Returns the **container** when the name matches a child of a split button, combo box, pull-down or radio group | `FindItemOrContainerByName` | 3 |
| `RibbonExtensions.ToggleAutoAssignIcons(item, isEnabled)` | Doesn't toggle or enable anything: sets the PowerOn/PowerOff images | `SetPowerIcons(item, isOn)` | 3 |
| `RibbonExtensions.GetItemFromRibbonRowPanel` (private) | Searches every tab and panel (see KTRUI-30) | `FindItemById` | private |
| `RibbonExtensions.GenerateItemId<T>(tabName)` (private) | The parameter is a `RibbonTab` | `ribbonTab` | private |
| `RibbonPushButton.SetContextualHelp(webAddress)` | Silently ignores any address not starting with `https://coda.io` | `SetCodaContextualHelp`, or throw | 0 |
| `RibbonModuleLoader.LoadModules` | Loads the assemblies, creates the modules **and their ribbons**; returns the names of modules whose ribbon was created | `LoadModulesAndCreateRibbons` | 1 |
| `PushButtonText.SpoolIfcAssemblyInView` / `ExportToSingleCsvFile` / `ExportToAMultipleXlsxFile` / `CreatePenetrationTags` / `ManagerGetDocumentLocations` / `FiltersApplyNonBillOfMaterialShop` | Constants whose names no longer match their text ("Spool IFC Strut In View", "Export To .csv File(s)", typo, "Sleeve Tagger", "Location Points", "Assign Non Shop BOM View Filters") | `SpoolIfcStrutInView`, `ExportToCsvFiles`, `ExportToMultipleXlsxFiles`, `SleeveTagger`, `ManagerLocationPoints`, `FiltersAssignNonShopBomViews` (texts unchanged) | 0–1 each |

### MVVM, selection, families, controls (U2)

| Member | What it does | Suggested | Reach |
|---|---|---|---|
| `ViewModel.GetElements` (2 overloads, protected) | Void; loads the document, view and selection elements, and **shows an error dialog** when empty | `LoadScopeElements` | 3 |
| `ViewModel.AddScope(elementIds)` | Takes elements | `elements` | 1 |
| `ViewModel.SelectElements(object)` (protected; bound as `CommandSelectElements`) | Syncs the grid selection to Revit: sets the select/zoom flags and clears Revit's selection when nothing is selected | `SyncGridSelectionToRevit` (the command binding keeps working if the property name stays) | 3 |
| `ConnectorPickTools.PickElementWithUnusedConnector` | Prompts with the caller's filter and a fixed text; checks no connector itself; swallows every exception | `PickElement(filter, uiDocument)` | 1 |
| `FamilySymbolWrapper.Name` / `SymbolName` | The family name / the type name shown | `FamilyName` / `ShownTypeName` | 1 |
| `FamilyInstanceHavingConnectorsSelectionFilter`, `StraightOrFamilyInstanceHavingConnectorsSelectionFilter` (types) | Test for an **unused** connector | `…HavingUnusedConnector…` (types, out of scope; noted) | — |
| XAML resource key `HasFieldTrim` (`Resources/ValueConverters.xaml:7`) | Maps to `PositiveNumberToYesConverter` | `PositiveNumberToYes` (add-in XAML uses the key) | 1 |
| `ScopeControl.SetRadioButton` (private) | Sets all three radio buttons | `CheckRadioButtonFor` | private |
| `DialogFooter.Button_Click` | Closes the parent window | `CloseWindowButton_Click` | XAML |

## Vague

- `DialogFooter.Test`: a public string set to "Test" and never used. Delete it.
- `SelectionMadeCommandAvailability.IsAvailable`: true when at least one element is selected, under the same name as the abstract hook. Suggested `HasSelection` (noisy).
- `RibbonPushButton.Type` and `IRibbonPushButton.Type`: the command class the button runs. Suggested `CommandType`.
- `ProjectRibbonComboBox.Header`: the "Select …" placeholder text. Suggested `HeaderItemText`.
- `RibbonComboBoxSettings.ItemText`: the combo box title. Elsewhere `itemText` means an item's text. Suggested `Title` (noisy).

## Style

- `LevelComboBoxItem(isCurrent)` sets `IsActiveLevel`. Suggested `isActiveLevel`.
- `RibbonSplitButton.AddItems(sb)`: suggested `splitButton`.
- `SetPowerIcon(…, desiredState)` and `isEnabled` in its sibling. Suggested `isOn`.
- `ElementControl.SelectInViewDependencyProperty` and `ZoomInViewDependencyProperty` break the WPF convention. Suggested `…Property`.
- `ElementControl.SelectInViewCheckbox_Checked` is an empty handler wired in XAML. Remove it.
- XAML `x:Name` leftovers:
  - `ZoomToSelectionCheckbox` is bound to `ZoomInView`.
  - The root names `ViewGroupControl`, `StatusBarControl` and `ProjectScopeControl` are left over.
  - All of these are used inside their own file only.
- `RibbonTabName.Develop` vs `RibbonPanelName.Developer`, and `Manage` in both enums: these become the titles Revit stores, so decide before renaming.
- `PushButtonText.ArrangeTagsAround` uses the verb "Distribute".
- `RibbonPushButton.BaseClassName` is private, set, and never read. Remove it.
- `CommandBase`, `RibbonComboBox` and `RibbonPushButton.SuperClassName` follow KW3-35 and KTRL5-140. The push button's value is the ribbon item name Revit stores (add-in 14).
- `SelectionExtensions.GetAssemblyInstances` returns the instances of selected assembly types plus the selected instances. Its summary says only "Smells a bit".

## Linear issues (filed 2026-11-11)

U1 **KTRUI-33**, U2 **KTRUI-34**. Both in KTRUI, Low, related to KTR5-4798. Each renames the members, adds XML docs where they are missing, resets the `Author` stamp of the tests it touches, and is followed by a repin issue in the add-in. Tab, panel and ribbon item names, and button texts and icon keys, stay unless the maintainer decides otherwise.

| # | Scope | Highest reach | Estimate |
|---|---|---|---|
| U1 | **Ribbon**: combo box members, `GetRibbonCombos`, `GetItemByName`, `ToggleAutoAssignIcons` (+ exception type), `SetContextualHelp`, `LoadModules`, the drifted `PushButtonText` constant names, the vague and style ribbon notes | `GetComboBox` 6 | 2 |
| U2 | **MVVM, selection, families, controls**: `ViewModel.GetElements` / `SelectElements` / `AddScope`, `PickElementWithUnusedConnector`, `FamilySymbolWrapper`, `HasFieldTrim` key, control handlers and `x:Name`s, `DialogFooter.Test`, `SelectionMadeCommandAvailability.IsAvailable` | `GetElements`, `SelectElements` 3 | 2 |
