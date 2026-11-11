# Member naming check, pass 2: Kelly-Revit-UI and add-in host (2026-11-11)
Second pass after the first-pass renames landed. Sources: group G13. Readers: Sonnet; checked by: Sonnet (code opened for every Misleading finding and every possible bug).
Teams: UI findings go to KTRUI (`Kelly-Revit-UI/src`); host findings go to KTR5 (`Kelly-Revit-v5/src`).

## Summary
- Confirmed: Misleading 7 (UI 5, host 2), Vague 17, Style 15.
- Bugs: 1 confirmed (Low), 3 dropped.
- Downgraded Misleading to Vague: `RibbonComboBoxEvents.RefillOnRefreshList` (its XML docs state that the view is refreshed whatever the item).
- Dropped: `PushButtonText.Delimiter*`, `RadGridViewExtensions.RebindAll`, the root `x:Name` Style row, and the known items (see the last table).

## Confirmed bugs
| Member | File:line | What is wrong | Evidence | Steps to show it | Priority |
|---|---|---|---|---|---|
| `RibbonExtensions.ResolveRibbonPanel` | `Kelly-Revit-UI/src/Ribbon/RibbonExtensions.cs:237` | Finds the panel with `UiControlledApplication.GetRibbonPanels()`, which has no tab argument and so lists only the Add-Ins tab. A panel of the same name there (another add-in with a "General" or "Manage" panel; `RibbonPanelName.General` exists) is returned instead of creating the Kelly panel on `ribbonTab`, so the Kelly buttons land on the wrong tab. A panel already on the Kelly tab is never looked up (not needed today: `CreatePanels` runs once per tab at startup). | Code read; the signature `(this RibbonTab ribbonTab, ...)` implies a lookup on that tab; only caller is `CreatePanels` (line 86); unchanged since the first commit `a407355`. Not run in Revit. | Install another add-in that puts a panel named like a Kelly panel on the Add-Ins tab, start Revit, look for the Kelly buttons on that panel. | Low |

## Proposed rename issues

### R1 (KTRUI): Ribbon helpers: names that hide what they do
| Severity | Member | File:line | What it does | Suggested | Callers | Serialized/Shown |
|---|---|---|---|---|---|---|
| Misleading | `RibbonExtensions.ResolveRibbonPanel` | `src/Ribbon/RibbonExtensions.cs:237` | Finds the panel by name or creates it on the tab; sibling is `GetOrCreateRibbonTab` | `GetOrCreateRibbonPanel` (no clash) | 1 | no |
| Vague | `RibbonComboBoxEvents.RefillOnRefreshList` | `src/Ribbon/RibbonComboBoxEvents.cs:20` | Adds the project items when "Refresh List" is chosen, then always refreshes the active view (stated in the docs) | `AddProjectItemsOnRefreshList` | 7 | no |
| Vague | `RibbonExtensions.SetPowerIcon<T>` / `SetPowerIcons(this RibbonItem)` | `src/Ribbon/RibbonExtensions.cs:~165/~190` | One finds the button by generated id (dialog on failure), the other takes the item | `SetPowerIconsOfButton<T>` / keep `SetPowerIcons` | 3 / 2 | image names `PowerOn16.png` etc. stay |
| Vague | `RibbonComboBox.CreateComboBoxMemberData` and static `CreateProjectMemberData` | `src/Ribbon/RibbonComboBox.cs:~44/~75` | The first calls the second | `CreateProjectComboBoxMemberData` for both | 4 / 4 | SHA-256 name stored by Revit: keep the algorithm |
| Vague | `StandardItemsContextSelector` (type) | `src/Ribbon/StandardItemsContextSelector.cs:5` | Holds combo box item texts; nothing selects | `ComboBoxItemTexts` | 8 | texts shown |
| Vague | `PushButtonText.FiltersApply{Fill,Line}ColorBy{Service,System}Name` | `src/Ribbon/PushButtonText.cs:~51-60` | Member says Name, shown text says "Service Signature" / "System Signature" | `...ByServiceSignature`, `...BySystemSignature` | 1 each | shown text kept |
| Vague | `PushButtonText.ServiceColorGrid`, `ResetAllAssigners`, `ManagerNukeElementById` | `src/Ribbon/PushButtonText.cs:~86-92` | Member and shown text differ | `ServiceColors`, `ResetAssignerTools`, `NukeElement` | 1 each | shown text kept |
| Style | `RibbonExtensions.FindItemOrContainerByName` vs private `FindItemById` | `src/Ribbon/RibbonExtensions.cs:137` | Both return item or container | `FindItemOrContainerById` (do after KTRUI-30) | 2 | no |
| Style | `PushButtonText.ExportToASingleXlsxFile`; `SleeveTagger` out of order | `src/Ribbon/PushButtonText.cs` | "ToASingle" | `ExportToSingleXlsxFile`; alphabetize | 1 each | shown text |

### R2 (KTRUI): Selection, scope and title block extensions
| Severity | Member | File:line | What it does | Suggested | Callers | Serialized/Shown |
|---|---|---|---|---|---|---|
| Misleading | `TitleBlockExtensions.GetTitleBlocks(Document, string, bool)` | `src/Families/TitleBlockExtensions.cs:17` | Returns `FamilySymbolWrapper`s of title block TYPES; Logic's `ViewExtensions.GetTitleBlocks(this ViewSheet)` (`ViewExtensions.cs:262`) returns INSTANCES on a sheet | `GetTitleBlockSymbolWrappers` (no clash on `Document`) | 1 (`SpoolManagerViewModel:20`); named in `Kelly-Domain/src/Spools/SpoolSheet.cs:9` docs | no |
| Misleading | `UiDocumentScopeExtensions.GetSpoolEligibleElements` | `src/Scope/UiDocumentScopeExtensions.cs:57` | Calls `FindSpoolableElementsWithReport`, which also writes the invalid-spool-item report (documented, so not a bug) | `FindSpoolableElementsWithReport` | 3 (`SpoolCreateViewModel`, two spool number assigner commands) | no |
| Misleading | `UiDocumentScopeExtensions.GetTrapezeFromSelection` | `src/Scope/UiDocumentScopeExtensions.cs:67` | Returns a list; callee is `GetValidTrapezesFromSelection` | `GetTrapezesFromSelection` | 2 | no |
| Misleading | `SelectionExtensions.SelectAndShow(uiDocument, ids, zoom)` | `src/Selection/SelectionExtensions.cs:~85` | Always selects; shows only when `zoom` is true and the list is not empty. Docs say so | keep the name, rename parameter `zoom` to `showInView` | 4 | no |
| Vague | `SelectionExtensions.GetAssemblyInstances(this Selection, Document)` vs `GetAssemblyInstancesFromSelection` | `src/Selection/SelectionExtensions.cs:13,~48` | First: instances of the selected assembly TYPES plus the selected instances; second: selected instances only | `GetAssemblyInstancesOfSelection` / `GetSelectedAssemblyInstances` | 3 / 2 | no |
| Vague | `ConnectorPickTools.PickElement(filter, uiDocument)` | `src/Selection/ConnectorPickTools.cs:12` | Any filter, but a fixed prompt "Pick an element having an open connector"; swallows every exception | `PickElementHavingOpenConnector` or a prompt parameter | 2 | prompt shown |
| Style | `GetElementInstancesByCategoryAndScope` / `GetInstancesByProductRange` | `src/Scope/UiDocumentScopeExtensions.cs:~12,~32` | "ElementInstances" vs "Instances" | `GetInstancesByCategoryAndScope` | 5 / 4 | no |
| Style | `SelectElements(this List<Spool>, UIDocument)` | `src/Scope/UiDocumentScopeExtensions.cs:~77` | Selects the spools' elements | `SelectSpoolElements` | 2 | no |
| Style | `TitleBlockExtensions.GetTitleBlocks` parameter `removeStartsWith` | `src/Families/TitleBlockExtensions.cs:17` | Strips the prefix from the shown name | `stripPrefixFromShownName` | 1 | no |

### R3 (KTRUI): View model and command runner names
| Severity | Member | File:line | What it does | Suggested | Callers | Serialized/Shown |
|---|---|---|---|---|---|---|
| Vague | `ViewModel.LoadScopeElements` (two overloads) | `src/Mvvm/ViewModel.cs:~170/~187` | Loads the lists and shows the "candidate elements" error when none are found | `LoadScopeElementsOrShowError` | 5 | no |
| Vague | `IViewModel.InitializeFirst` / `InitializeLast` | `src/Mvvm/IViewModel.cs:22,25` | First creates commands and filters; Last (base) sets the initial scope | `InitializeMembers` / `ApplyInitialScope` (public interface; lowest priority) | 25 / 15 | no |
| Vague | `ViewModel.SyncGridSelectionToRevit(object obj)` | `src/Mvvm/ViewModel.cs:~215` | `obj` is a `RadGridView` or `ElementControl` | parameter `sender` | 6 | no |
| Vague | `CommandRunner.Run(Action, ref string)` | `src/Commands/CommandRunner.cs:19` | Runs and catches cancel, error message and any exception | `RunAndCatch` | 2 | no |
| Style | `ViewModel.SelectInView`, `ZoomInView` | `src/Mvvm/ViewModel.cs:55` | Bool properties; shown text "Zoom To Selected" | `ShouldSelectInView`, `ShouldZoomInView` (many XAML bindings in the add-in: rename with them) | many | shown text |
| Style | `SelectionMadeCommandAvailability.IsCommandAvailable` parameters | `src/Commands/SelectionMadeCommandAvailability.cs:~12` | Siblings use `uiApp`, `catSet` | `uiApp`, `catSet` | 3 | no |

### R4 (KTR5): Host `App` and services (`Kelly-Revit-v5/src`)
| Severity | Member | File:line | What it does | Suggested | Callers | Serialized/Shown |
|---|---|---|---|---|---|---|
| Misleading | `App.Caches.GetComponentCache`, `GetProductCache`, `GetProductRangeCache`, `GetServiceDataCache`, `GetSystemDataCache`, `GetTerminologyCache`, `GetExternalParameterDefinitionCache` | `src/App.cs:~190-250` (confirmed: each returns `.Models`) | Returns the cache's model list, not the cache (`GetCache<T>()` is the cache) | `GetComponents`, `GetProducts`, `GetProductRanges`, `GetServices`, `GetSystems`, `GetTerminologies`, `GetExternalParameterDefinitions` (`GetExternalParameterDefinitionsByName` stays; no clash) | 1 each (`App.cs:63`, `EventService`) | no |
| Misleading | `App.GetDefinition(string)` (private) | `src/App.cs:~140` | Looks up a definition by name; on any exception shows an error dialog and returns null | `FindExternalParameterDefinitionOrReport` | 1 | no |
| Vague | `App.OpenDataDirectory` (private) | `src/App.cs:~170` | Builds a new `DataDirectory`; opens nothing | `CreateDataDirectory` | 1 | no |
| Vague | `RibbonService.CreateTabs` (private) | `src/Services/RibbonService.cs:34` | Loads the six module DLLs and has each build its ribbon | `LoadModulesAndCreateRibbons` | 1 | no |
| Style | `App.CreateAddInId(uiContApp)`, `loadTelerikReferences` | `src/App.cs:~125,~80` | Abbreviation; a bool not read as a question | `uiControlledApplication`, `areTelerikReferencesLoaded` | 1 | no |
| Style | `DocumentChangedEventHandler`, `ViewActivatedEventHandler`, `ViewActivatingEventHandler` `Execute` | `src/EventHandlers/*.cs` | Same behaviour as `EventService.LogOnly` | remove and use `LogOnly` (DRY) | 1 each | no |

### R5 (KTRUI): Batched Style
| Severity | Member | File:line | What it does | Suggested | Callers | Serialized/Shown |
|---|---|---|---|---|---|---|
| Style | `DialogMenu.CloseMenuItem_Click`; summary "Interaction logic for Menu.xaml" | `src/Controls/DialogMenu.xaml.cs:9,15` | `DialogMenu.xaml` has no Close item (grep confirmed), so the handler is dead and the summary names the wrong file | delete handler; summary "Interaction logic for DialogMenu.xaml" | 0 | no |
| Style | `ScopeControl.RadioButton_Click`; `ScopeIs*RadioButton` x:Names | `src/Controls/ScopeControl.xaml` | One handler for three buttons | `ScopeRadioButton_Click`; `SelectionRadioButton` etc. | 0 | no |
| Style | `ElementHavingConnectionSelectionFilter` vs `...HavingUnusedConnector...` | `src/Selection/ElementHavingConnectionSelectionFilter.cs:4` | "Connection" vs "Connector" | pick one word | 3 | no |
| Style | `RadGridViewExtensions.GetItems<T>` local `selectedItems` | `src/Grids/RadGridViewExtensions.cs:19` | Holds all items | `items` | local | no |
| Style | `RibbonPushButton.ImageName` setter | `src/Ribbon/RibbonPushButton.cs:26` | Assigns `_imageName` twice (`... : _imageName = "Scrum"`); the "Scrum" fallback is the intended placeholder | drop the inner assignment | 1 | "Scrum" icon key |
| Style | Resource keys `HintLabel`, `SidebarGroupBoxHeaderLabel` (prefix `Label` elsewhere), `TextBlockBlue` (colour, not role), `ToPounds` vs type `ToPoundFormatConverter` | `src/Resources/Labels.xaml:88,105`; `Controls.xaml:156`; `ValueConverters.xaml:11` | Key naming | `LabelHint`, `LabelSidebarGroupBoxHeader`, `ToPoundFormat`; check every `StaticResource` user in `Kelly-Revit-v5` | XAML | style keys |

## Dropped or downgraded
| Finding | Group | Why |
|---|---|---|
| Possible bug: `GetSpoolEligibleElements` writes a report | G13 | Intended: the callee is `...WithReport` and its docs say so. Only the wrapper name is vague (kept in R2) |
| Possible bug: `RefillOnRefreshList` refreshes after every close, no null check on `Current` | G13 | Documented ("whatever the item"); `Current` is set after a drop-down close. Downgraded to Vague |
| Possible bug: `RibbonPushButton.ImageName` | G13 | Double assignment is harmless; the "Scrum" placeholder is intended. Style only |
| `PushButtonText.Delimiter*` four constants | G13 | Same value, used as a family; noise only |
| `RadGridViewExtensions.RebindAll(this Window)` | G13 | Agrees with receiver and type |
| Control root `x:Name` suffixes | G13 | Pure taste, no outside users |
