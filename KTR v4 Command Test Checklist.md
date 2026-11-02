# KTR v4 Command Test Checklist

Manual check of every ribbon command in Kelly Tools For Revit, Major Version 4 (`Kelly-Revit-v4`, `develop`), grouped by ribbon tab and panel in the order they appear on the ribbon.

Generated 2026-10-27 from the ribbon code (`src/Application/Services/RibbonService.cs` and the panel, split, stacked and pull-down button classes). Descriptions are the buttons' own tooltips; "Enabled" is the button's availability class. **186 items** to check: 7 checks when you open a project, 153 ribbon items and 26 auto-updater checks (IUpdater configurations in `src/Documents/Configurations/Updater`).

## Test run

| | |
|---|---|
| Tester | |
| Date | |
| Revit year | ☐ 2024 ☐ 2025 ☐ 2026 |
| Add-in version (from **About**) | |
| Model used | |

## For every item, check

1. **Enabled state**: the button is greyed out when its "Enabled" condition is not met and lights up when it is.
2. **Tooltip**: hovering shows the tooltip and the icon is not the placeholder.
3. **Runs**: clicking it gives no error dialog or crash, and any window opens laid out correctly.
4. **Does what it says**: the result matches the description.
5. **Undo**: one Ctrl+Z reverses a change it made to the model.
6. **Cancel**: pressing Esc at a pick prompt, or Cancel/close in its window, leaves the model unchanged.

Tick the box when all six pass; write anything that fails in **Issues found** at the end.

## Test models

- A project with **fabrication parts** (pipe and duct), **assemblies/spools**, **trapeze supports** and **Kelly shared parameters**: most Tools, Pipe and Duct tab items need these. The Revit sample models have none of them.
- A **family document** for *Set Revision Date* (Kelly Content tab).
- A floor plan, a ceiling plan, a 3D view, a section and a schedule, to check the view-based "Enabled" conditions.

## Contents

- [When you open a project](#when-you-open-a-project) (6): Startup and open
- [Kelly Tools tab](#kelly-tools-tab) (107): General, Container, Tag And Number, Layout, Updater, Bill Of Material, Assigner And Visibility
- [Kelly Pipe tab](#kelly-pipe-tab) (7): Pipe General, Weld
- [Kelly Duct tab](#kelly-duct-tab) (5): Quality Check, Annotation
- [Kelly Content tab](#kelly-content-tab) (8): Content Family, Content Fabrication Parts
- [Kelly Manage tab](#kelly-manage-tab) (8): Manage, Parameter
- [Kelly Develop tab](#kelly-develop-tab) (18): Developer
- [Auto Updaters (IUpdater)](#auto-updaters-iupdater) (26): Always on, Auto Assign, The whole set

---

## When you open a project

Seven things you see in the first minutes of every run, before you test any tool. Only the first needs setting up (disconnect from the JHKelly network); for the rest, start Revit, open a Kelly project, look.


### Startup and open

- [ ] **Runs off the JHKelly network**: Disconnect the VPN and any other connection to JHKelly (office network, Wi-Fi), then start Revit and open a Kelly project. Kelly Tools must start and work with no network error dialog and no long hang; the tabs, drop-downs and tools behave as they do on the network. Note anything that fails, waits or asks for a server. Expected: Kelly Develop › User Report fails offline (it needs the JHKELLY domain). Reconnect afterwards.
  - Check: Before Revit starts · `App.OnStartup`
- [ ] **Clean start**: Revit starts with no Kelly error dialog (no "Application Service Start Error", "Telerik Reference Loading Error", "Telerik License Error" or "Kelly Tools For Revit Data Error"), and the Kelly Tools, Pipe, Duct, Content and Manage tabs are there. Kelly Develop appears only in developer mode.
  - Check: When Revit starts · `App.OnStartup`
- [ ] **About shows the installed version**: Kelly Tools › General › About shows the add-in version you installed. Type it into the run's "Add-in version" field above.
  - Check: After startup · `ApplicationAboutCommand`
- [ ] **Missing shared parameters**: A project missing Kelly shared parameters shows "Shared Parameter Information Missing" once, listing them; a complete Kelly project shows nothing. In builds made after 2026-10-27 the dialog no longer says the list is on the clipboard (it never was), and the clipboard is left alone.
  - Check: Opening a project · `DocumentOpenedEventHandler`
- [ ] **Active Project gates Kelly Tools**: The Active Project icon on Kelly Manage matches JHK Active Project in Project Information. With it off, the Kelly Tools items are greyed out; turn it on and they are available.
  - Check: Opening a project · `DocumentOpenedEventHandler`
- [ ] **Drop-downs per project**: The Service, System, Detailing Package, Line Number, Spool Number and Module Number drop-downs list this project's values. Open a second project: it lists its own.
  - Check: Opening a project · `DocumentOpenedEventHandler`
- [ ] **KTR - 3D view**: The project has a 3D view named "KTR - 3D" after opening. Close and reopen it: still one, no duplicate. A family document gets none of this.
  - Check: Opening a project · `DocumentOpenedEventHandler`

---

## Kelly Tools tab


### General panel

- [ ] **About**: Opens a window showing the Revit version and build, the add-in version and install folder, your Autodesk user name, the active document's title and path, and the add-in manifest folders.
  - Enabled: Always · `ApplicationAboutCommand`
- [ ] **Project Directory**: Opens the project's working folder (C:\Projects\Revit\&lt;project title>), which holds its reports, schedules, layout files and logs, in File Explorer. Creates the folder if it is missing.
  - Enabled: Always · `ProjectDirectoryOpenCommand`
- [ ] **Reload Data**: Reloads the Kelly data files from the add-in's Data folder after a new export, without restarting Revit. Asks first if the files are older than the data already loaded; on a problem it keeps the current data.
  - Enabled: Always · `DataReloadCommand`
- **Arrange** (split button / drop-down: test every item in it)
  - [ ] **Align Left**: Moves the selected tags and text notes so their left edges line up with the leftmost one. Select at least two first, or pick them when prompted; pinned elements stay put.
    - Enabled: Always · `ArrangeAlignLeftCommand`
  - [ ] **Align Center**: Moves the selected tags and text notes sideways so their centers sit on one vertical line, halfway between the leftmost and rightmost. Select at least two first, or pick them when prompted.
    - Enabled: Always · `ArrangeAlignCenterCommand`
  - [ ] **Align Right**: Moves the selected tags and text notes so their right edges line up with the rightmost one. Select at least two first, or pick them when prompted; pinned elements stay put.
    - Enabled: Always · `ArrangeAlignRightCommand`
  - [ ] **Align Top**: Moves the selected tags and text notes so their top edges line up with the highest one. Select at least two first, or pick them when prompted; pinned elements stay put.
    - Enabled: Always · `ArrangeAlignTopCommand`
  - [ ] **Align Middle**: Moves the selected tags and text notes up or down so their centers sit on one horizontal line, halfway between the highest and lowest. Select at least two first, or pick them when prompted.
    - Enabled: Always · `ArrangeAlignMiddleCommand`
  - [ ] **Align Bottom**: Moves the selected tags and text notes so their bottom edges line up with the lowest one. Select at least two first, or pick them when prompted; pinned elements stay put.
    - Enabled: Always · `ArrangeAlignBottomCommand`
  - [ ] **Distribute Tags Around**: Moves every tag with a leader in the active view to the left or right edge of the crop region, whichever side its leader points to, ordered so leaders do not cross. Ignores the selection; the view must be cropped.
    - Enabled: Always · `ArrangeDistributeTagsAroundCommand`
  - [ ] **Distribute Horizontally**: Spaces the selected tags and text notes evenly from left to right between the two outermost ones, keeping their heights. Select at least three first, or pick them when prompted.
    - Enabled: Always · `ArrangeDistributeHorizontallyCommand`
  - [ ] **Distribute Vertically**: Spaces the selected tags and text notes evenly from bottom to top between the two outermost ones, keeping their sideways positions. Select at least three first, or pick them when prompted.
    - Enabled: Always · `ArrangeDistributeVerticallyCommand`
  - [ ] **UnTangle Horizontally**: Lines the selected tags up side by side, edge to edge, in the left-to-right order of their leader ends so the leaders stop crossing; each tag keeps its height. Select at least two first, or pick them when prompted.
    - Enabled: Always · `ArrangeUntangleHorizontallyCommand`
  - [ ] **UnTangle Vertically**: Stacks the selected tags edge to edge, in the bottom-to-top order of their leader ends so the leaders stop crossing; each tag keeps its sideways position. Select at least two first, or pick them when prompted.
    - Enabled: Always · `ArrangeUntangleVerticallyCommand`
- **Basic Tools** (split button / drop-down: test every item in it)
  - [ ] **Hanger Place**: Places fabrication hangers on a picked fabrication straight, starting from the end nearest your pick. Choose a hanger from its service, a start distance and repeat spacing in feet, and optionally continue onto connected straights.
    - Enabled: Always · `ViciousFabricationHangerInstancePlaceCommand`
  - [ ] **Level Correct**: Moves the selected model elements (family instances, pipes, ducts, conduit, cable tray, fabrication parts) to a level you choose, keeping their elevation. Hosted families and fabrication hangers are skipped. Select elements first.
    - Enabled: Something is selected · `ViciousInstanceLevelAssignCommand`
  - [ ] **Racker**: Sets the top or bottom elevation of the selected pipes, ducts, conduit, cable tray and fabrication straights to one value, typed in or taken from the selection, optionally allowing for insulation. Select them first.
    - Enabled: Always · `ViciousInstanceElevationAssignCommand`
  - [ ] **ManyConnect**: Pick a pipe, duct, conduit, tray or fitting with an open connector, then a fitting or other family instance: moves the second onto the first's nearest facing open connector and connects them. Repeats until you press Esc.
    - Enabled: Always · `ManyConnectCommand`
  - [ ] **Disconnect**: Disconnects the selected elements from everything joined at their connectors, leaving them in place. With nothing selected, pick elements one at a time and press Esc to finish.
    - Enabled: Always · `ViciousInstanceDisconnectCommand`
  - [ ] **Rotate**: Rotates the selected elements about a picked straight or fitting by an angle you enter, left or right, until you close the dialog. Select first; assembly members are refused. A single selected viewport rotates its view's crop region instead.
    - Enabled: Always · `ViciousInstanceRotateMoveCommand`
  - [ ] **Point To Pipe**: Creates pipes between consecutive points read from an Excel, CSV or PCF file, sized from the file and placed from the project base point, survey point or a picked point, as a chosen pipe type or fabrication service.
    - Enabled: Always · `ViciousFileBasedSystemPipePlaceCommand`
- [ ] **Open Assembly Sheets**: Opens the assembly sheets of the spools selected under Assemblies in the Project Browser, then offers to tile them. Spools selected in the model are not picked up.
  - Enabled: Always · `SpoolSheetOpenCommand`
- **Export** (split button / drop-down: test every item in it)
  - [ ] **Export To An .xlsx File**: Exports the schedules selected in the Project Browser to one Excel workbook, one worksheet each, in the project's Schedules folder, then opens the folder. Needs Microsoft Excel installed.
    - Enabled: Always · `ViewScheduleToExcelFileExportCommand`
  - [ ] **Export To .xlsx File(s)**: Exports each schedule selected in the Project Browser to its own Excel file in the project's Schedules folder, then opens the folder. Needs Microsoft Excel installed.
    - Enabled: Always · `ViewScheduleToExcelFilesExportCommand`
  - [ ] **Export To An .xlsx (No Excel)**: Exports the schedules selected in the Project Browser to one Excel workbook, one worksheet each, in the project's Schedules folder, then opens the folder. Does not need Excel installed.
    - Enabled: Always · `ViewScheduleToXlsxFileNoExcelExportCommand`
  - [ ] **Export To .xlsx (No Excel)**: Exports each schedule selected in the Project Browser to its own Excel file in the project's Schedules folder, then opens the folder. Does not need Excel installed.
    - Enabled: Always · `ViewScheduleToXlsxFilesNoExcelExportCommand`
  - [ ] **Export To .csv File(s)**: Exports each schedule selected in the Project Browser to its own CSV file, named after the schedule with a time stamp, in the project's Schedules folder, then opens the folder.
    - Enabled: Always · `ViewScheduleToCommaSeparatedValueFilesExportCommand`
- [ ] **Stratus Detailing Package Views**: For each detailing package in the project, creates or updates a 3D view named &lt;package>-Stratus, copied from 0-Stratus, that isolates that package and colors it by service. Needs the 0-Stratus view and the S-3D-ALL-STRATUS-Export view template.
  - Enabled: Always · `StratusDetailingPackageViewsCommand`

### Container panel

- [ ] **Module Manager**: Opens the Module Manager for the modules in the selection or active view: review their spools and components, select them in the model, set JHK BOM Type to Module and update item numbers on chosen components.
  - Enabled: Active view lets you select model elements · `ModuleManageCommand`
- [ ] **Module Creator**: Opens the Module Creator to build a module number (prefix-type-sequence, with the next free sequence suggested) and write it to JHK Module Number on the selected elements, including members of selected spools.
  - Enabled: Something is selected · `ModuleCreatorCommand`
- [ ] **Spool Manager**: Opens the Spool Manager for the spools in the selection or active view: review items, bill of materials, welds and quality checks; set detailing package, line number, spool name, BOM type, item numbers and tags; create spool sheets.
  - Enabled: Active view lets you select model elements · `SpoolManagerCommand`
- [ ] **Spool Creator**: Opens the Spool Creator to make a spool (assembly) from the eligible selected elements, named line number-category-sequence, and write JHK Spool Number, JHK Line Number and optionally JHK Detailing Pkg to it and its items.
  - Enabled: Something is selected · `SpoolCreateCommand`
- [ ] **Spool Clean By View**: Removes elements that can't belong to a spool (by product range or category) from the spools in the active view, clears their JHK Spool Number and reports how many were removed. Available when the project has spools.
  - Enabled: Project has assemblies · `SpoolCleanByViewCommand`

### Tag And Number panel

- [ ] **Suspended Support Manager**: Opens the Suspended Support Manager for the supports in the selection, active view or project: attach or extend rods to structure, set anchor and field trim extensions and rod size, and write their tags.
  - Enabled: Active view lets you select model elements · `SuspendedSupportManageCommand`
- [ ] **Extend Trapeze Rods**: Extends each rod (BS1, BS2 and so on) of the selected trapeze supports up to the structure above; a rod with nothing above is set to 6 in. Clears JHK Tag, Tag Signature, Field Trim and Anchor Length. Needs a trapeze selected.
  - Enabled: A trapeze support is selected · `TrapezeVerticalMemberExtendCommand`
- [ ] **Reset Trapeze Rods**: Resets each rod (BS1, BS2 and so on) of the selected trapeze supports to 12 in and clears JHK Tag, Tag Signature, Field Trim and Anchor Length, which no longer apply. Needs a trapeze selected.
  - Enabled: A trapeze support is selected · `TrapezeVerticalMemberResetCommand`
- [ ] **Sleeve Tagger**: Writes JHK Tag on every sleeve in the project as prefix-size-length, built from its JHK Tag Prefix, its diameter or width x height, and its length, in inches.
  - Enabled: Always · `PenetrationTagAssignCommand`

### Layout panel

- [ ] **Create Grid**: Places a Grid Point at every grid intersection in the project and writes the intersection name (for example A/1) to JHK Layout Point Description 2. Needs the Grid Point family loaded.
  - Enabled: Always · `GridLayoutPointPlaceCommand`
- [ ] **Update Grid**: Rewrites JHK Layout Point Description 2 on every Grid Point in the project with the name of its nearest grid intersection (for example A/1). In a workshared project also moves the points to the x_Layout Reference workset.
  - Enabled: Always · `GridLayoutPointUpdateCommand`
- [ ] **Import**: Opens the Layout Point Importer to read points (name, X, Y, Z in feet, description, layer) from a CSV file, mark duplicates, and place them as Grid, Control or Manual Points relative to site or a chosen level.
  - Enabled: Active view lets you select model elements · `LayoutPointFromCommaSeparatedValueImportCommand`
- [ ] **Export**: Opens the Layout Point Exporter to check layout points, save their data to the elements and export them to a CSV file for a total station. Needs a floor or ceiling plan active and a plan view with JHK View Type set to Layout.
  - Enabled: Active view is a floor or ceiling plan · `LayoutPointToCommaSeparatedValueFileExportCommand`
- [ ] **Layout Directory**: Opens the project's Layout folder (C:\Projects\Revit\&lt;project title>\Layout), where layout point CSV files are kept, in File Explorer.
  - Enabled: Always · `LayoutPointFileDirectoryOpenCommand`

### Updater panel

- [ ] **Auto Update State**: Turns this project's automatic updaters off, or back on when they are off. Turning them off also resets the assigner drop-downs. The button icon shows whether they are on.
  - Enabled: Always · `AutoUpdaterStateToggleCommand`
- [ ] **Update Selection**: Runs every Kelly parameter updater (size, material, product, welds, field trim, BOM type and others) on the selected elements, with automatic updaters paused during the run. Needs a selection.
  - Enabled: At least one element is selected · `ManualUpdaterOnSelectionCommand`
- [ ] **Update Active View**: Runs every Kelly parameter updater (size, material, product, welds, field trim, BOM type and others) on the elements in the active view, with automatic updaters paused during the run.
  - Enabled: Always · `ManualUpdaterOnViewCommand`
- [ ] **Update Project**: Runs every Kelly parameter updater (size, material, product, welds, field trim, BOM type and others) on all elements in the project, with automatic updaters paused during the run. Can take a while on large projects.
  - Enabled: Always · `ManualUpdaterOnDocumentCommand`
- [ ] **Auto Updater Report**: Writes three CSV reports on automatic updaters (this project's Kelly updaters, and all updaters registered with Revit and with this document) to the project's Reports folder, then opens the folder.
  - Enabled: Always · `AutoUpdaterStateReportCommand`
- [ ] **Family SP Binding Report**: Opens each editable family in the project and lists its JHK shared parameters that are type parameters rather than instance parameters. Writes the list to a CSV file on your desktop.
  - Enabled: Always · `FamilySharedParameterReportCommand`

### Bill Of Material panel

- [ ] **Field**: Sets JHK BOM Type to Field on every selected element that has that parameter (the Shop and Module buttons set the other values). Needs a selection.
  - Enabled: At least one element is selected · `BillOfMaterialFieldSetCommand`
- [ ] **Shop**: Sets JHK BOM Type to Shop on every selected element that has that parameter (the Field and Module buttons set the other values). Needs a selection.
  - Enabled: At least one element is selected · `BillOfMaterialShopSetCommand`
- [ ] **Module**: Sets JHK BOM Type to Module on every selected element that has that parameter (the Shop and Field buttons set the other values). Needs a selection.
  - Enabled: At least one element is selected · `BillOfMaterialModuleSetCommand`

### Assigner And Visibility panel

- **Adopt value from selected element** (small stacked buttons)
  - [ ] **Service**: Sets the Service Selector to the JHK Service Signature of the one selected element, adding it to the list if missing. Needs exactly one selected element that has a service.
    - Enabled: Exactly one element is selected · `ServiceAssignerValueAdoptCommand`
  - [ ] **System**: Sets the System Selector to the JHK System Signature of the one selected element, adding it to the list if missing. Needs exactly one selected element that has a system.
    - Enabled: Exactly one element is selected · `SystemAssignerValueAdoptCommand`
  - [ ] **Detailing Package**: Sets the Detailing Package Selector to the JHK Detailing Pkg of the one selected element, adding it to the list if missing. Needs exactly one selected element that has a detailing package.
    - Enabled: Exactly one element is selected · `DetailingPackageAssignerValueAdoptCommand`
- **Reset the drop-down** (small stacked buttons)
  - [ ] **Service**: Sets the Service Selector back to "Select Service" and turns off service auto-assign for this project. Elements already assigned are not changed.
    - Enabled: Always · `ServiceAssignerToolResetCommand`
  - [ ] **System**: Sets the System Selector back to "Select System" and turns off system auto-assign for this project. Elements already assigned are not changed.
    - Enabled: Always · `SystemAssignerToolResetCommand`
  - [ ] **Detailing Package**: Sets the Detailing Package Selector back to "Select Detailing Package" and turns off detailing package auto-assign for this project. Elements already assigned are not changed.
    - Enabled: Always · `DetailingPackageAssignerToolResetCommand`
- [ ] **Drop-downs: Service / System / Detailing Package**: each lists its values for this project, picking a value sticks, and typing a new value is accepted.
  - Enabled: Always
- **Auto Assign on/off** (small stacked buttons)
  - [ ] **Service**: Turns service auto-assign on or off for this project: while on, newly placed non-fabrication elements get the service chosen in the Service Selector (JHK Service fields). Plan, elevation, section and 3D views only.
    - Enabled: Active view accepts view filters · `ServiceAssignerAutoSetToggleCommand`
  - [ ] **System**: Turns system auto-assign on or off for this project: while on, newly placed elements get the system chosen in the System Selector (JHK System Name, Abbreviation, Signature). Plan, elevation, section and 3D views only.
    - Enabled: Active view accepts view filters · `SystemAssignerAutoSetToggleCommand`
  - [ ] **Detailing Package**: Turns detailing package auto-assign on or off for this project: while on, newly placed elements get the package chosen in the Detailing Package Selector in JHK Detailing Pkg. Plan, elevation, section and 3D views only.
    - Enabled: Active view accepts view filters · `DetailingPackageAssignerAutoSetToggleCommand`
- **Add value to selected** (small stacked buttons)
  - [ ] **Service**: Rewrites JHK Service Name, Abbreviation, Signature and JHK Navis System on the selected fabrication parts from each part's own fabrication service. The Service Selector is not used; other elements are skipped.
    - Enabled: Something is selected · `ServiceAssignerValueSetCommand`
  - [ ] **System**: Writes the system chosen in the System Selector to JHK System Name, Abbreviation and Signature on the selected elements. Does nothing if no system is chosen or it is not in the system list.
    - Enabled: Something is selected · `SystemAssignerValueSetCommand`
  - [ ] **Detailing Package**: Writes the package chosen in the Detailing Package Selector to JHK Detailing Pkg on the selected elements, asking before overwriting a different value. If none is chosen, it first asks you to type a new one.
    - Enabled: Something is selected · `DetailingPackageAssignerValueSetCommand`
- **Remove value from selected** (small stacked buttons)
  - [ ] **Service**: Clears JHK Service Name, JHK Service Abbreviation, JHK Service Signature and JHK Navis System on the selected elements, including members of selected assemblies.
    - Enabled: Something is selected · `ServiceAssignerValueResetCommand`
  - [ ] **System**: Clears JHK System Name, JHK System Abbreviation and JHK System Signature on the selected elements, including members of selected assemblies.
    - Enabled: Something is selected · `SystemAssignerValueResetCommand`
  - [ ] **Detailing Package**: Clears JHK Detailing Pkg on the selected elements, including members of selected assemblies. Other assigner parameters are not changed.
    - Enabled: Something is selected · `DetailingPackageAssignerValueResetCommand`
- **Isolate value in view** (small stacked buttons)
  - [ ] **Service**: Hides elements in the active view whose JHK Service Signature differs from the service chosen in the Service Selector, using an "Isolate By Service &lt;name>" view filter. Plan, elevation, section and 3D views only.
    - Enabled: Active view accepts view filters · `ServiceAssignerIsolateViewFilterCommand`
  - [ ] **System**: Hides elements in the active view whose JHK System Signature differs from the system chosen in the System Selector, using an "Isolate By System &lt;name>" view filter. Plan, elevation, section and 3D views only.
    - Enabled: Active view accepts view filters · `SystemAssignerIsolateViewFilterCommand`
  - [ ] **Detailing Package**: Hides elements in the active view whose JHK Detailing Pkg differs from the package chosen in the Detailing Package Selector, using an "Isolate By Detailing Package &lt;value>" view filter. Plan, elevation, section and 3D views only.
    - Enabled: Active view accepts view filters · `DetailingPackageAssignerIsolateViewFilterCommand`
- **Hide value in view** (small stacked buttons)
  - [ ] **Service**: Hides elements in the active view whose JHK Service Signature equals the service chosen in the Service Selector, using a "Hide By Service &lt;name>" view filter. Plan, elevation, section and 3D views only.
    - Enabled: Active view accepts view filters · `ServiceAssignerHideViewFilterCommand`
  - [ ] **System**: Hides elements in the active view whose JHK System Signature equals the system chosen in the System Selector, using a "Hide By System &lt;name>" view filter. Plan, elevation, section and 3D views only.
    - Enabled: Active view accepts view filters · `SystemAssignerHideViewFilterCommand`
  - [ ] **Detailing Package**: Hides elements in the active view whose JHK Detailing Pkg equals the package chosen in the Detailing Package Selector, using a "Hide By Detailing Package &lt;value>" view filter. Plan, elevation, section and 3D views only.
    - Enabled: Active view accepts view filters · `DetailingPackageAssignerHideViewFilterCommand`
- **Adopt value from selected element** (small stacked buttons)
  - [ ] **Line Number**: Sets the Line Number Selector to the JHK Line Number of the one selected element, adding it to the list if missing. Needs exactly one selected element that has a line number.
    - Enabled: Exactly one element is selected · `LineNumberAssignerValueAdoptCommand`
  - [ ] **Module Number**: Sets the Module Number Selector to the JHK Module Number of the one selected element, adding it to the list if missing. Needs exactly one selected element that has a module number.
    - Enabled: Exactly one element is selected · `ModuleNumberAssignerValueAdoptCommand`
  - [ ] **Spool Number**: Sets the Spool Number Selector to the JHK Spool Number of the one selected element, adding it to the list if missing. Needs exactly one selected element that has a spool number.
    - Enabled: Exactly one element is selected · `SpoolNumberAssignerValueAdoptCommand`
- **Reset the drop-down** (small stacked buttons)
  - [ ] **Line Number**: Sets the Line Number Selector back to "Select Line Number" and turns off line number auto-assign for this project. Elements already assigned are not changed.
    - Enabled: Always · `LineNumberAssignerToolResetCommand`
  - [ ] **Module Number**: Sets the Module Number Selector back to "Select Module". Module numbers already assigned to elements are not changed.
    - Enabled: Always · `ModuleNumberAssignerToolResetCommand`
  - [ ] **Spool Number**: Sets the Spool Number Selector back to "Select Spool". Spool numbers already assigned to elements are not changed.
    - Enabled: Always · `SpoolNumberAssignerToolResetCommand`
- [ ] **Drop-downs: Line Number / Module Number / Spool Number**: each lists its values for this project, picking a value sticks, and typing a new value is accepted.
  - Enabled: Always
- **Auto Assign on/off** (small stacked buttons)
  - [ ] **Line Number**: Turns line number auto-assign on or off for this project: while on, newly placed elements get the line number chosen in the Line Number Selector in JHK Line Number. Plan, elevation, section and 3D views only.
    - Enabled: Active view accepts view filters · `LineNumberAssignerAutoSetToggleCommand`
  - [ ] **Spool Number**: Spool number auto-assign is not supported, so this button is always unavailable. Use the add button with the Spool Number Selector to add elements to a spool.
    - Enabled: Never: disabled on purpose, check it stays greyed out · `SpoolValueAutoSetCommand`
  - [ ] **Module Number**: Module number auto-assign is not supported, so this button is always unavailable. Use the add button with the Module Number Selector to assign module numbers.
    - Enabled: Never: disabled on purpose, check it stays greyed out · `ModuleValueAutoSetCommand`
- **Add value to selected** (small stacked buttons)
  - [ ] **Line Number**: Writes the line number chosen in the Line Number Selector to JHK Line Number on the selected elements, asking before overwriting a different value. If none is chosen, it first asks you to type a new one.
    - Enabled: Something is selected · `LineNumberAssignerValueSetCommand`
  - [ ] **Module Number**: Writes the module chosen in the Module Number Selector to JHK Module Number on the selected elements and on members of selected assemblies. If none is chosen, it opens Module Creator instead.
    - Enabled: Something is selected · `ModuleNumberAssignerValueSetCommand`
  - [ ] **Spool Number**: Adds the selected spool-eligible elements to the spool assembly chosen in the Spool Number Selector and writes its number to their JHK Spool Number. Ineligible elements are skipped and listed in an Invalid Spool Items report.
    - Enabled: Always · `SpoolNumberAssignerValueSetCommand`
- **Remove value from selected** (small stacked buttons)
  - [ ] **Line Number**: Clears JHK Line Number on the selected elements, including members of selected assemblies. Other assigner parameters are not changed.
    - Enabled: Something is selected · `LineNumberAssignerValueResetCommand`
  - [ ] **Module Number**: Clears JHK Module Number and JHK Module Group on the selected elements, including members of selected assemblies.
    - Enabled: Something is selected · `ModuleNumberAssignerValueResetCommand`
  - [ ] **Spool Number**: Removes the selected elements from the spool assembly chosen in the Spool Number Selector and clears their JHK Spool Number. Needs a selection and a spool chosen in the selector.
    - Enabled: Always · `SpoolNumberAssignerValueResetCommand`
- **Isolate value in view** (small stacked buttons)
  - [ ] **Line Number**: Hides elements in the active view whose JHK Line Number differs from the line number chosen in the Line Number Selector, using an "Isolate By Line Number &lt;value>" view filter. Plan, elevation, section and 3D views only.
    - Enabled: Active view accepts view filters · `LineNumberAssignerIsolateViewFilterCommand`
  - [ ] **Module Number**: Hides elements in the active view whose JHK Module Number differs from the module chosen in the Module Number Selector, using an "Isolate By Module &lt;value>" view filter. Plan, elevation, section and 3D views only.
    - Enabled: Active view accepts view filters · `ModuleNumberAssignerIsolateViewFilterCommand`
  - [ ] **Spool Number**: Hides elements in the active view whose JHK Spool Number differs from the spool chosen in the Spool Number Selector, using an "Isolate By Assembly &lt;number>" view filter. Plan, elevation, section and 3D views only.
    - Enabled: Active view accepts view filters · `SpoolNumberAssignerIsolateViewFilterCommand`
- **Hide value in view** (small stacked buttons)
  - [ ] **Line Number**: Hides elements in the active view whose JHK Line Number equals the line number chosen in the Line Number Selector, using a "Hide By Line Number &lt;value>" view filter. Plan, elevation, section and 3D views only.
    - Enabled: Active view accepts view filters · `LineNumberAssignerHideViewFilterCommand`
  - [ ] **Module Number**: Hides elements in the active view whose JHK Module Number equals the module chosen in the Module Number Selector, using a "Hide By Module &lt;value>" view filter. Plan, elevation, section and 3D views only.
    - Enabled: Active view accepts view filters · `ModuleNumberAssignerHideViewFilterCommand`
  - [ ] **Spool Number**: Hides elements in the active view whose JHK Spool Number equals the spool chosen in the Spool Number Selector, using a "Hide By Spool &lt;number>" view filter. Plan, elevation, section and 3D views only.
    - Enabled: Active view accepts view filters · `SpoolNumberAssignerHideViewFilterCommand`
- [ ] **Reset Assigner Tools**: Sets every assigner selector (System, Service, Line Number, Detailing Package, Module Number, Spool Number) back to its "Select" entry and turns off all assigner auto-assign for this project.
  - Enabled: Active view accepts view filters · `AllAssignerResetCommand`
- [ ] **Line Color For Service Signature**: Adds a "Service - &lt;name>" view filter to the active view for each service on elements in the view, drawing lines in that service's color (and fill in Navis export views). Plan, elevation, section and 3D views only.
  - Enabled: Active view accepts view filters · `ServiceLineColorViewFilterCommand`
- [ ] **Line Color For System Signature**: Adds a "System - &lt;name>" view filter to the active view for each system on elements in the view, drawing lines in that system's color (and fill in Export views). Plan, elevation, section and 3D views only.
  - Enabled: Active view accepts view filters · `SystemLineColorViewFilterCommand`
- [ ] **Line Color For Detailing Package**: Adds view filters to the active view that color lines by the last digit (0-9) of JHK Detailing Pkg, gray when empty (and fill in Export views). Plan, elevation, section and 3D views only.
  - Enabled: Active view accepts view filters · `DetailingPackageLineColorViewFilterCommand`
- [ ] **Line Color For Line Number**: Adds view filters to the active view that color lines by the last digit (0-9) of JHK Line Number, gray when empty (and fill in Export views). Plan, elevation, section and 3D views only.
  - Enabled: Active view accepts view filters · `LineNumberLineColorViewFilterCommand`
- [ ] **Line Color For Spool Name**: Adds view filters to the active view that color assemblies' lines by the last digit (0-9) of the assembly name, gray when empty (and fill in Export views). Plan, elevation, section and 3D views only.
  - Enabled: Active view accepts view filters · `SpoolNumberLineColorViewFilterCommand`
- [ ] **Line Color For Module Number**: Adds view filters to the active view that color lines by the last digit (0-9) of JHK Module Number, gray when empty (and fill in Export views). Plan, elevation, section and 3D views only.
  - Enabled: Active view accepts view filters · `ModuleNumberLineColorViewFilterCommand`
- [ ] **Fill Color For Service Signature**: Adds a "Service - &lt;name>" view filter to the active view for each service on elements in the view, filled with that service's color and outlined in dark gray. Plan, elevation, section and 3D views only.
  - Enabled: Active view accepts view filters · `ServiceFillColorViewFilterCommand`
- [ ] **Fill Color For System Signature**: Adds a "System - &lt;name>" view filter to the active view for each system on elements in the view, filled with that system's color and outlined in dark gray. Plan, elevation, section and 3D views only.
  - Enabled: Active view accepts view filters · `SystemFillColorViewFilterCommand`
- [ ] **Assign Non Shop BOM View Filters**: Sets the active view to wireframe, hides fabrication pipe insulation and adds line-color filters: JHK Field Trim above zero in blue, JHK BOM Type Field in red and JHK BOM Type Module in green.
  - Enabled: Always · `PipeAndWeldFieldTrimLineColorViewFilterCommand`
- [ ] **Remove All From View**: Removes every filter from the active view's Visibility/Graphics filter list. Only available in views that support filters.
  - Enabled: Active view accepts view filters · `AllInViewRemoveViewFilterCommand`
- [ ] **Remove Unused From Project**: After confirmation, deletes every filter in the project that is not applied to any view, including saved selection sets. Filters applied to any view are kept.
  - Enabled: Always · `AllUnusedInProjectDeleteViewFilterCommand`

---

## Kelly Pipe tab


### Pipe General panel

- [ ] **Valve Clearance Spheres**: Places a Clearance Code Sphere at the center of each selected valve, sized to the valve's extents plus 3 inches. The Clearance Code Sphere family must be loaded; other selected elements are ignored.
  - Enabled: Something is selected · `ValveClearanceSpheresCommand`
- [ ] **Olet Check**: Opens the Olet Checker, which sorts the olets in the selection or active view into connected, disconnected and mis-aligned, selects and zooms to them, and can re-connect disconnected olets to the pipe they sit on.
  - Enabled: Always · `OletCheckCommand`

### Weld panel

- [ ] **Shop**: Sets JHK Weld Location of the selected welds to the Shop Weld code and JHK BOM Type to Shop, then updates end preparation on the connected pipe straights. Other selected elements are ignored.
  - Enabled: At least one element is selected · `WeldLocationShopSetCommand`
- [ ] **Field**: Sets JHK Weld Location of the selected welds to the Field Weld code and JHK BOM Type to Field, then updates end preparation on the connected pipe straights. Other selected elements are ignored.
  - Enabled: At least one element is selected · `WeldLocationFieldSetCommand`
- [ ] **Shop Tack**: Sets JHK Weld Location of the selected welds to the Shop Tack Weld code and JHK BOM Type to Shop, then updates end preparation on the connected pipe straights. Other selected elements are ignored.
  - Enabled: At least one element is selected · `WeldLocationShopTackSetCommand`
- [ ] **Field Fit**: Sets JHK Weld Location of the selected welds to the Field Fit Weld code and JHK BOM Type to Field, then updates end preparation on the connected pipe straights. Other selected elements are ignored.
  - Enabled: At least one element is selected · `WeldLocationFieldFitSetCommand`
- [ ] **Field Fit Tack**: Sets JHK Weld Location of the selected welds to the Field Fit Tack code and JHK BOM Type to Field, then updates end preparation on the connected pipe straights. Other selected elements are ignored.
  - Enabled: At least one element is selected · `WeldLocationFieldFitTackSetCommand`

---

## Kelly Duct tab


### Quality Check panel

- [ ] **Duct Length Check**: Not finished yet: collects the fabrication ductwork in the document but does not check or report lengths, and changes nothing.
  - Enabled: Active view can be tagged · `DuctLengthCheckCommand`
- [ ] **Duct Mirror Check**: Not finished yet: collects the fabrication ductwork in the document but does not check or report mirrored parts, and changes nothing.
  - Enabled: Active view can be tagged · `DuctMirrorCheckCommand`

### Annotation panel

- [ ] **Set Run Item Number**: Pick the first and last fabrication duct parts of a connected run to renumber it in order, continuing from the highest JHK Item Number on its JHK Line Number (also sets Item Number). Every part needs a line number. Esc to finish.
  - Enabled: Active view can be tagged · `DuctRunItemNumberSetCommand`
- [ ] **Set Part Item Number**: Pick fabrication duct parts one at a time; each gets the next JHK Item Number for its JHK Line Number (for example LINE-004), also written to Item Number. Asks before overwriting; Esc to finish. Plan, section, elevation or 3D views.
  - Enabled: Active view can be tagged · `DuctItemNumberSetCommand`
- [ ] **Reset Item Number**: Clears JHK Item Number and the Revit Item Number on the selected fabrication ductwork. Other selected elements are ignored.
  - Enabled: Something is selected · `DuctItemNumberResetCommand`

---

## Kelly Content tab


### Content Family panel

- [ ] **Set Revision Date**: Family documents only: sets JHK Revision Date, JHK Revision Time and JHK Revision By (your Revit user name) on every family type, adding them as type parameters if missing. Does nothing if the family has no JHK parameters.
  - Enabled: A family document is active · `RevisionSetterCommand`

### Content Fabrication Parts panel

- [ ] **Update Custom Data (V1)**: Older version: writes custom data from the Item Custom Data file to every fabrication part in the document, matched on its Component Id (custom data 105), without asking first. Skips parts owned by others and logs to the project Logs folder.
  - Enabled: Project has fabrication parts · `FabricationCustomDataUpdaterCommandV1`
- [ ] **Custom Data Report (Proposed)**: Writes every row of the Custom Data Updater data file (the custom data values the V2 updater writes, by Product Code) to a CSV in the project Logs folder and opens it. Reads no model elements.
  - Enabled: Always · `FabricationCustomDataProposedReportCommand`
- [ ] **Update Custom Data (V2)**: Overwrites custom data 100-117 (not Component Id) on every fabrication part in the document from the Custom Data Updater file, matched by Product Code in pipe models or Component Id in duct models. Asks first and reports skipped parts.
  - Enabled: Project has fabrication parts · `FabricationCustomDataUpdaterCommandV2`
- [ ] **Custom Data Report**: Writes every custom data value of every fabrication part in the document (element id, index, name, value, long description) to a CSV in the project Logs folder and opens it.
  - Enabled: Always · `FabricationCustomDataReportCommand`
- [ ] **Product Code Check**: Checks every fabrication part in the document for a missing Component Id (custom data 105), a missing or malformed Product Code, or the two disagreeing. Writes failing parts to a CSV in the project Logs folder and opens it.
  - Enabled: Project has fabrication parts · `FabricationPartProductCodeCheckReportCommand`
- [ ] **Various Data Report**: Writes the property values, ancillary usage, rod info, dimensions and version history of every fabrication hanger in the document to log files in the project Logs folder, then opens that folder.
  - Enabled: Always · `FabricationPartVariousReportCommand`
- [ ] **Dimension Data Report**: Logs the dimension values of the selected fabrication parts and groups parts with the same long description, size and dimensions, writing both to the project Logs folder and opening it. Needs a selection.
  - Enabled: Always · `FabricationPartDimensionLogCommand`

---

## Kelly Manage tab


### Manage panel

- [ ] **Active Project**: Turns JHK Active Project in Project Information on or off and enables or disables the Tools, Pipe and Duct ribbon tabs to match. In a workshared model, other users must sync and reopen to see the change.
  - Enabled: Always · `ActiveProjectCommand`
- [ ] **Project Info. Editor**: Opens the Project Information Editor to edit the project name, number, client, building, address, status, issue date, organization and JHK project values and save them to Project Information. Read-only if another user owns it.
  - Enabled: Always · `DocumentInformationManageCommand`
- [ ] **Project Location Report**: Shows the active project position (angle, east/west and north/south offsets, elevation) and site location (latitude, longitude, time zone, coordinate system) in a dialog and copies it to the clipboard.
  - Enabled: Always · `ProjectCoordinateReportCommand`
- [ ] **Element Location Report**: Pick an element to show its location in internal and shared coordinates (decimal and fractional feet) in a dialog. The report is also copied to the clipboard.
  - Enabled: Always · `ElementInstanceCoordinateReportCommand`
- [ ] **Purge Unused Families**: After you confirm, deletes every loadable family that has no placed instances in the project, then also deletes unused shared parameter elements.
  - Enabled: Always · `UnusedFamilyTypeDeleteCommand`
- [ ] **Nuke Element**: Deletes the element whose Element Id is on the clipboard, along with anything Revit deletes with it, and reports whether it worked. Copy the Element Id first.
  - Enabled: Always · `ElementDeleteCommand`

### Parameter panel

- [ ] **Purge Unused SPE's**: Deletes shared parameter elements that are neither bound to the project nor used by any loaded family type, removing leftover shared parameter definitions without asking first.
  - Enabled: Always · `UnusedSharedParameterElementDeleteCommand`
- [ ] **Bindings Report**: Lists every JHK shared parameter bound to the project and flags any bound by type instead of instance, appending the result to Shared Parameter Bindings Report.md in the project Reports folder. Does not open it.
  - Enabled: Always · `SharedParameterBindingsReportToMarkdownExportCommand`

---

## Kelly Develop tab

_Shown only when the add-in runs in developer mode (`App.IsDeveloperExecuting`)._


### Developer panel

- [ ] **Windows Mockup**: Developer demo of the standard dialog layout: opens a template window listing the JHK product codes found in the scope you pick. Changes nothing in the model.
  - Enabled: Always · `WindowMockupCommand`
- [ ] **Sandbox**: Developer sandbox for trying code; it currently lists the document's loaded fabrication services and item files in the daily development log in C:\Projects\Revit\Application. Changes nothing in the model.
  - Enabled: Always · `SandboxCommand`
- [ ] **Collector Testing**: Developer test harness that runs the element collector helpers against the whole document, the current selection and the active view. It changes nothing, writes no report and always ends as failed.
  - Enabled: Always · `CollectorTestingCommand`
- [ ] **Coordinate Testing**: Developer test that converts the location of the first valve in the active view to shared coordinates and back, and writes the results to the daily development log in C:\Projects\Revit\Application. Changes nothing in the model.
  - Enabled: Always · `CoordinateTestingCommand`
- [ ] **UserDomain Report**: Developer tool that looks up the members of the detailing group in the JHKELLY domain, writes their account details to a Markdown file in C:\Projects\Revit\Application and opens it. Needs a domain connection.
  - Enabled: Always · `UserReportCommand`
- [ ] **Create Product Range Schedules**: Creates or rebuilds one schedule per product range, filtered on JHK Product Range and listing count, family and type, and tags them as developer views. Needs the JHK Product Range parameter in the project.
  - Enabled: Always · `ProductRangeSchedulesCommand`
- [ ] **KTR View Parameters**: Sets the view purpose, discipline, detailer and type parameters of every view whose name starts with "KTR" to Admin, All, Developer and Kelly Tools Development, grouping them as developer views in the project browser.
  - Enabled: Always · `UpdateKellyToolsViewParametersCommand`
- [ ] **Delete By VendorId**: After confirmation, erases every extensible storage schema whose vendor id matches the text on the clipboard, with all data stored under it. The data cannot be recovered; use with one project open and no links.
  - Enabled: Always · `ExtensibleStorageDeleteByVendorIdCommand`
- [ ] **Purge JHK Parameters**: After confirmation, deletes every shared parameter whose name starts with "JHK " from the whole document, with all their values. Families that use them must be reloaded afterwards.
  - Enabled: Always · `PurgeKellySharedParameterElementsCommand`
- [ ] **Purge Families**: After confirmation, deletes the family type of every placed family instance in the whole document, removing those instances and types from the entire model. It cannot be limited to a view or selection.
  - Enabled: Always · `AllFamilyInstanceDeleteCommand`
- [ ] **Select Field Trim End**: Developer test: pick the field-trim end of fabrication straights in turn; each one gets the nearest end connector id in its Comments and a marker at the picked point. Press Esc to stop, then choose whether to delete the markers.
  - Enabled: Always · `SelectFieldTrimEndCommand`
- [ ] **Purge Family Materials**: In an open family document, clears the material assigned to every category and subcategory other than the family's own category. Works in family documents only.
  - Enabled: Always · `PurgeFamilyMaterialsCommand`
- [ ] **Align Conduit Bottom**: Developer tool that copies the identifiers of all built-in parameter groups to the clipboard, one per line, and shows how many were copied. Changes nothing in the model.
  - Enabled: Always · `GetForgeTypeIdsCommand`
- **Element List** (split button / drop-down: test every item in it)
  - [ ] **BuiltInParameter Lists**: Unfinished developer tool meant to export the list of built-in parameters to a CSV report. It currently does nothing and writes no file.
    - Enabled: Always · `BuiltInParametersToTextCommand`
  - [ ] **Category Lists**: Writes every category and subcategory of the document, with its type, built-in category and subcategory count, to a CSV in C:\Projects\Revit\&lt;project>\Reports and opens it.
    - Enabled: Always · `CategoriesToTextCommand`
  - [ ] **Filter List**: Writes the names of all view filters in the document, sorted, to a CSV in C:\Projects\Revit\&lt;project>\Reports and opens it.
    - Enabled: Always · `FiltersToCsvCommand`
  - [ ] **Material List**: Writes every material in the document with its red, green and blue color values and transparency to a CSV in C:\Projects\Revit\&lt;project>\Reports and opens it.
    - Enabled: Always · `MaterialsToTextCommand`
- **Other Lists** (split button / drop-down: test every item in it)
  - [ ] **Category Bindings**: Writes every project and shared parameter binding of the document, one row per bound category with binding type, parameter group and data type, to a CSV in C:\Projects\Revit\&lt;project>\Reports and opens it.
    - Enabled: Always · `CategoryBindingsReportCommand`

---

## Auto Updaters (IUpdater)

- Built per project when it opens (AutoUpdaterService) and listed here in the order they run. Each one has an `*AutoUpdaterConfiguration` in `Documents/Configurations/Updater`.
- **Fires:** with _Auto Update State_ on, place a new matching element (or change one, where it says so): the listed parameters are filled in.
- **Off means off:** with _Auto Update State_ off, the same placement leaves them empty. _Update Selection_ then fills them in, so that is how to catch up.
- **Undo:** one Ctrl+Z removes the element and the values together.
- **No dialogs:** a failure never shows a message box; it is written to the `AutoUpdater` log in the add-in's Logs folder. Check that log after each run.
- Most values come from the Kelly data files, so use a Kelly project with the add-in started; the Revit samples have no Kelly parameters.


### Always on

- [ ] **Content Identity**: Fabrication parts: writes JHK Component Id and JHK Product Code from the part's fabrication content.
  - Fires on: Element added · `ContentIdentityAutoUpdaterConfiguration`
- [ ] **Component**: Elements with the component parameters: writes JHK Category Type, Class Description, Short and Long Description, Finish, Manufacturer, Part Category, Trade Name and Product Range from the component data.
  - Fires on: Element added · `ComponentAutoUpdaterConfiguration`
- [ ] **BOM Type Default**: Sets JHK BOM Type to Shop. An element that already has a BOM Type keeps it.
  - Fires on: Element added · `BillOfMaterialTypeDefaultAutoUpdaterConfiguration`
- [ ] **Fabrication Part Instances**: Fabrication parts: writes JHK Total Length (centerline length), JHK Angle and the deprecated JHK Pipe Size. Stretch a straight or change a fitting's angle and the values follow.
  - Fires on: Element added or changed · `FabricationPartInstancesAutoUpdaterConfiguration`
- [ ] **Field Trim Default**: Sets JHK Field Trim to 0. An element that already has a field trim keeps it.
  - Fires on: Element added · `FieldTrimDefaultAutoUpdaterConfiguration`
- [ ] **Schedule Or Gauge**: Fabrication parts: writes JHK Schedule Or Gauge (pipe schedule or duct gauge).
  - Fires on: Element added · `ScheduleGaugeAutoUpdaterConfiguration`
- [ ] **Material**: Fabrication parts: writes JHK Material Type and JHK Material Description (type, code, specification and grade).
  - Fires on: Element added · `MaterialAutoUpdaterConfiguration`
- [ ] **Service (fabrication parts)**: Fabrication parts: writes JHK Service Name, Service Abbreviation, Service Signature and JHK Navis System from the part's fabrication service.
  - Fires on: Element added · `ServiceOfFabricationPartAutoUpdaterConfiguration`
- [ ] **Service Signature change**: Any element with the service parameters: when JHK Service Signature is edited, rewrites JHK Service Name, Service Abbreviation and JHK Navis System to match it.
  - Fires on: JHK Service Signature changed · `ServiceAutoUpdaterConfiguration`
- [ ] **Size**: Writes JHK Size and the run, run 2, branch and branch 2 diameter, width, height and shape parameters.
  - Fires on: Element added · `SizeAutoUpdaterConfiguration`
- [ ] **Suspended Support**: Fabrication hangers, mechanical equipment and pipe accessories with the support parameters: writes JHK Support Elevation and JHK Below Structure Dim. Move a support up or down and the values follow.
  - Fires on: Element added or geometry changed · `SuspendedSupportAutoUpdaterConfiguration`
- [ ] **Weld**: Fabrication parts with JHK Product Range 10 (welds): writes JHK Weld Location, JHK Weld Type and the deprecated JHK Weld Tag Prefix. Other parts are left alone.
  - Fires on: Element added · `WeldAutoUpdaterConfiguration`
- [ ] **End Preparation**: Fabrication parts: writes JHK End 1 Preparation and JHK End 2 Preparation from the connected welds and field trim. Change a weld to Field and the straight's end preparation follows.
  - Fires on: Element added or changed · `EndPreparationAutoUpdaterConfiguration`
- [ ] **Detailing Phase**: Elements other than sheets with JHK Detailing Phase: writes the activity code of the element's system (matched on JHK System Signature).
  - Fires on: Element added or changed · `DetailingPhaseAutoUpdaterConfiguration`
- [ ] **Layout Discipline**: Layout points: writes JHK Layout Point Discipline Name and Discipline Color from the service on JHK Service Signature.
  - Fires on: Element added or changed · `LayoutDisciplineUpdaterAutoAdditionConfiguration`
- [ ] **Checkbox Default**: Every element: each JHK Yes/No parameter that has never been set gets its default for the element's product range, or No when the range has none.
  - Fires on: Element added · `CheckboxDefaultAutoUpdaterConfiguration`
- [ ] **Product**: Writes JHK Product Id, JHK CAHF and JHK CIPE (fabrication and installation unit rates) and JHK Total Weight.
  - Fires on: Element added · `ProductAutoUpdaterConfiguration`

### Auto Assign (off by default)

- [ ] **System**: Turned on by the System Auto Assign button (Kelly Tools › Assigner And Visibility). New elements get JHK System Name, System Abbreviation and System Signature from the System drop-down. Off again: new elements stay empty.
  - Fires on: Element added, while Auto Assign is on · `SystemUpdaterAutoAdditionConfiguration`
- [ ] **Service (non-fabrication)**: Turned on by the Service Auto Assign button. New elements that are not fabrication parts get JHK Service Name, Abbreviation, Signature and Navis System from the Service drop-down.
  - Fires on: Element added, while Auto Assign is on · `ServiceOfNonFabricationPartUpdaterAutoAdditionConfiguration`
- [ ] **Detailing Package**: Turned on by the Detailing Package Auto Assign button. New elements get JHK Detailing Pkg from the Detailing Package drop-down; with nothing picked it should not fail.
  - Fires on: Element added, while Auto Assign is on · `DetailingPackageUpdaterAutoAdditionConfiguration`
- [ ] **Line Number**: Turned on by the Line Number Auto Assign button. New elements get JHK Line Number from the Line Number drop-down; with nothing picked it should not fail.
  - Fires on: Element added, while Auto Assign is on · `LineNumberUpdaterAutoAdditionConfiguration`

### The whole set

- [ ] **Per-project on/off**: Open two projects. Turn Auto Update State off in one: the other keeps firing. Switch between them: the power icon and the four Auto Assign icons follow the active project.
  - Fires on: Two projects open · `AutoUpdaterService`
- [ ] **All 21 registered**: Auto Updater Report lists 21 Kelly updaters for the project: the 17 always-on ones enabled, the 4 Auto Assign ones disabled until their buttons are pressed.
  - Fires on: Project open · `AutoUpdaterService`
- [ ] **Paused during a manual run**: Update Project runs without the auto updaters firing on its own changes, and afterwards each updater is back in the state it had (Auto Assign ones included).
  - Fires on: Project open · `AutoUpdaterService`
- [ ] **Paused during Synchronize**: In a workshared project, Synchronize with Central finishes without updater errors, and the updaters are on again afterwards (place an element to check).
  - Fires on: Workshared project · `AutoUpdaterService`
- [ ] **Close and reopen**: Close a project and open it again in the same session: its updaters fire again, with no duplicate-registration error.
  - Fires on: Project open · `AutoUpdaterService`

---

## Not on the ribbon

No panel puts these commands on the ribbon, so they cannot be run from it. The first two have a push button class that is never added; `ExtensibleStorageInsertCommand` has no push button at all. Nothing to check unless they should be on the ribbon:

- `ComponentDataRepairCommand` ([Documents/Commands/MultiTrade/ComponentDataRepair/ComponentDataRepairCommand.cs](Kelly-Revit-v4/src/Documents/Commands/MultiTrade/ComponentDataRepair/ComponentDataRepairCommand.cs))
- `ContextValueAddCommand` ([Documents/Commands/MultiTrade/Assigners/ContextValueAdder/ContextValueAddCommand.cs](Kelly-Revit-v4/src/Documents/Commands/MultiTrade/Assigners/ContextValueAdder/ContextValueAddCommand.cs))
- `ExtensibleStorageInsertCommand` ([Documents/Commands/Developer/Extensible/ExtensibleStorageInsertCommand.cs](Kelly-Revit-v4/src/Documents/Commands/Developer/Extensible/ExtensibleStorageInsertCommand.cs))

## Things noticed while building this list

- **Kelly Develop › Developer › Align Conduit Bottom** runs `GetForgeTypeIdsCommand`, so the label does not match the command.
- **Kelly Develop › Developer › Report** pull-down is created empty.
- **Kelly Tools › Assigner And Visibility**: *Spool Number* "Add value to selected" and "Remove value from selected" are always enabled, while the Line Number and Module Number ones need a selection.
- **Kelly Tools › Assigner And Visibility**: the *Spool Number* and *Module Number* Auto Assign buttons are placeholders, disabled on purpose (`IsDisabledCommandEnabler`) to keep the row lined up; an auto assign isn't wanted for them. Only Line Number has a working Auto Assign in that row.
- **Kelly Duct › Quality Check**: *Duct Length Check* and *Duct Mirror Check* are not in production yet; mark them N/A.
- **Kelly Tools › Bill Of Material**: *Field*, *Shop* and *Module* set on an assembly also set every member of the assembly. The tooltips don't say so.
- **Kelly Tools › General › Basic Tools** split button's internal name is `BasicToolsSplitButton`; the ribbon shows the last-used item, so check the label looks right after first start.

## Issues found

| Tab › Panel › Tool | Revit year | What happened | Steps to reproduce |
|---|---|---|---|
| | | | |
