# Linear Estimates — 2026-11-04 (second run)

Second run of the day, after it turned out some teams had estimates turned off during the first run (`2026-11-04 Linear Estimates.md`). That run reported 236 estimates set and 0 refused, and Linear now shows an estimate on every open non-parent issue except KTR5-4726, created since. This run re-checks every open issue against the code and proposes only clear changes.

Scale: every team with issues uses the exponential scale (1, 2, 4, 8, 16), read from the estimates now set. KWD2, KWDC, KWDJ, KWDSS and KWDSL have no issues. The Hasa teams are estimated from the issue text only (no code here).

Parents keep what they have (never cleared): KTR5-3800 has 0 and KTR5-4604 has 2, though both have open sub-issues; Linear rolls the sub-issues up.

## Summary

| Team | Open | New | Changed | Unchanged | Skipped (parents) | Points proposed | Text only |
|---|---|---|---|---|---|---|---|
| KTR5 | 194 | 1 | 26 | 151 | 16 | 651 | 0 |
| KTRUI | 4 | 0 | 0 | 4 | 0 | 13 | 0 |
| KTRL5 | 30 | 0 | 0 | 26 | 4 | 84 | 0 |
| KTR4 | 50 | 0 | 3 | 45 | 2 | 123 | 0 |
| KTRL4 | 2 | 0 | 0 | 2 | 0 | 6 | 0 |
| KW3 | 10 | 0 | 0 | 9 | 1 | 27 | 0 |
| KW2 | 1 | 0 | 0 | 1 | 0 | 1 | 0 |
| KWD3 | 3 | 0 | 0 | 3 | 0 | 13 | 0 |
| KD | 21 | 0 | 0 | 21 | 0 | 44 | 0 |
| HASA | 24 | 0 | 3 | 16 | 5 | 100 | 24 |
| HASADB | 3 | 0 | 1 | 2 | 0 | 9 | 3 |
| HASAWB | 11 | 0 | 0 | 10 | 1 | 21 | 11 |
| HASAW | 7 | 0 | 0 | 7 | 0 | 17 | 7 |
| HASAO | 5 | 0 | 0 | 5 | 0 | 9 | 5 |
| HASAI | 5 | 0 | 0 | 5 | 0 | 10 | 5 |
| **Total** | **370** | **1** | **33** | **307** | **29** | **1128** | **55** |

**Applied 2026-11-04:** all 34 approved estimates set and confirmed in Linear (1 new, 33 changed; 0 refused). KTR5 27 (1 new, 26 changed), KTR4 3, Hasa teams 4 (HASA 3, HASADB 1). Five first responses (KTR5-3934, 3935, 4020, 4123, 4125) showed the old value; a resend read back the new one, and their updatedAt shows the first call had saved.

## Changes to existing estimates

These overwrite a value someone set; most were set by hand before the first run, which kept them.

| Key | Title | Current | Proposed | Confidence | Reason |
|---|---|---|---|---|---|
| [KTR5-3277](https://linear.app/jhkelly/issue/KTR5-3277) | Suspended Support Manager: Match column shows true when nothing matches | 1 | 2 | medium | reproduce, then fix the match logic with a test |
| [KTR5-3794](https://linear.app/jhkelly/issue/KTR5-3794) | Module Creator: optionally create the module's views, filters and sheet | 4 | 8 | medium | view, filter and sheet creation in Logic plus UI, across layers |
| [KTR5-3829](https://linear.app/jhkelly/issue/KTR5-3829) | Family Instance End Swap: swap connected family instances like fabrication parts | 4 | 8 | medium | new tool with connector geometry in Logic |
| [KTR5-3924](https://linear.app/jhkelly/issue/KTR5-3924) | Spool Creator: remember the selected Detailing Package between creations | 4 | 2 | medium | keep one combo value in one view model |
| [KTR5-3932](https://linear.app/jhkelly/issue/KTR5-3932) | Spool Creator V2: user interface | 8 | 4 | medium | only a push button and command, no window |
| [KTR5-3934](https://linear.app/jhkelly/issue/KTR5-3934) | Spool Creator V2: tests | 8 | 4 | medium | tests for one new command and its logic |
| [KTR5-3935](https://linear.app/jhkelly/issue/KTR5-3935) | Spool Creator V2: remaining work (docs, release notes, retire V1?) | 8 | 2 | medium | docs and one decision |
| [KTR5-4019](https://linear.app/jhkelly/issue/KTR5-4019) | Element Select Zoom: remove EventToCommandBehavior from Select In View and its views | 1 | 2 | medium | about 5 hosting views plus a repin of Kelly-Revit-UI |
| [KTR5-4020](https://linear.app/jhkelly/issue/KTR5-4020) | Element Select Zoom: remove EventToCommandBehavior from Zoom To Selection and its views | 1 | 2 | medium | about 5 hosting views plus a repin of Kelly-Revit-UI |
| [KTR5-4063](https://linear.app/jhkelly/issue/KTR5-4063) | Suspended Support Manager: filter the grid by Element Id | 1 | 2 | medium | pasting a list of Ids needs a custom filter |
| [KTR5-4122](https://linear.app/jhkelly/issue/KTR5-4122) | Duct QA Mirror: view | 8 | 4 | medium | one window, push button and contract tests |
| [KTR5-4123](https://linear.app/jhkelly/issue/KTR5-4123) | Duct QA Mirror: view model | 8 | 4 | medium | one view model on the shared Scope control |
| [KTR5-4124](https://linear.app/jhkelly/issue/KTR5-4124) | Duct QA Mirror: model(s) | 8 | 2 | medium | a few row types with tests |
| [KTR5-4125](https://linear.app/jhkelly/issue/KTR5-4125) | Duct QA Length: model(s) | 8 | 2 | medium | a few row types with tests |
| [KTR5-4126](https://linear.app/jhkelly/issue/KTR5-4126) | Duct QA Length: view model | 8 | 4 | medium | one view model on the shared Scope control |
| [KTR5-4127](https://linear.app/jhkelly/issue/KTR5-4127) | Duct QA Length: view | 8 | 4 | medium | one window, push button and contract tests |
| [KTR5-4136](https://linear.app/jhkelly/issue/KTR5-4136) | OperationService: email the logs to Chris Hildebran at every document close | 4 | 8 | medium | new mail service plus a hook on document close, likely across layers |
| [KTR5-4256](https://linear.app/jhkelly/issue/KTR5-4256) | Content cleanup: remove unused or deprecated JHK shared parameters from a project | 4 | 8 | medium | new tool with a usage scan and removal |
| [KTR5-4663](https://linear.app/jhkelly/issue/KTR5-4663) | Spool Creator: SPA and SPT categories do not parse as spool numbers | 4 | 8 | medium | SpoolNumber.TryParse is in Kelly-Domain: Domain pack and repin through Logic, UI and the add-in |
| [KTR5-4696](https://linear.app/jhkelly/issue/KTR5-4696) | OperationService.Run: assigner filter, Duct, Manager and Rotate Move commands | 2 | 4 | medium | 12 sites across 10+ command types, blocked until moved to Logic |
| [KTR5-4698](https://linear.app/jhkelly/issue/KTR5-4698) | OperationService.Run: Layout Point Export, Module Manage, Spool Create, Support Manager | 2 | 4 | medium | 8 sites in four large view models |
| [KTR5-4700](https://linear.app/jhkelly/issue/KTR5-4700) | OperationService.Run: decide Many Connect, Custom Data Updater V2, Layout Point CSV, Spool Create | 2 | 4 | medium | per-site decision and restructuring of partial commits in 4 types |
| [KTR5-4703](https://linear.app/jhkelly/issue/KTR5-4703) | Add-in host: tests for `Caches`, the 4 event handlers, `Resources`, `ApplicationSessionService` | 2 | 4 | medium | 7 types, in-Revit tests |
| [KTR5-4705](https://linear.app/jhkelly/issue/KTR5-4705) | Trade.All assigners: tests for the combo boxes, settings and event handlers | 4 | 8 | medium | 19 types in a 130-file folder, in-Revit tests with KellyDefinitions stubs |
| [KTR5-4707](https://linear.app/jhkelly/issue/KTR5-4707) | Per-element catch in the remaining module commands | 2 | 4 | medium | 5 commands in 3 modules |
| [KTR5-4708](https://linear.app/jhkelly/issue/KTR5-4708) | Trade.All view models: Spools, Supports, Layout Points, Module Creator | 4 | 8 | high | 8 view models, about 3,800 lines (SpoolManager 1069, SuspendedSupportManager 729) |
| [KTR4-50](https://linear.app/jhkelly/issue/KTR4-50) | Module Creator: Last Module shows AB-MOD-5 without padding | 4 | 2 | medium | D3 padding fix in settings/ModuleNumber, two small types |
| [KTR4-67](https://linear.app/jhkelly/issue/KTR4-67) | Assigner view-filter commands: share their common code | 2 | 4 | medium | base class extracted across seven command types |
| [KTR4-68](https://linear.app/jhkelly/issue/KTR4-68) | Vicious commands, Arranger, Spool Sheet Open: scope collector and refactor notes | 4 | 8 | medium | new shared scope collector plus refactor of six-plus commands is a sweep |
| [HASA-63](https://linear.app/jhkelly/issue/HASA-63) | Print any view | 4 | 8 | medium | print layouts on web plus native Print on Mac and iOS, several views |
| [HASA-76](https://linear.app/jhkelly/issue/HASA-76) | Copy tasks and paste them on another noun | 4 | 8 | medium | new feature across database and every app |
| [HASA-77](https://linear.app/jhkelly/issue/HASA-77) | Duplicate a noun with its components and tasks | 4 | 8 | medium | tree-copy database function plus command in every app |
| [HASADB-19](https://linear.app/jhkelly/issue/HASADB-19) | Idea: sign in with a 6-digit email code as well as the link | 2 | 4 | medium | email template plus code entry on web and SwiftUI apps |

## New estimates

| Key | Title | Proposed | Confidence | Reason |
|---|---|---|---|---|
| [KTR5-4726](https://linear.app/jhkelly/issue/KTR5-4726) | Deprecate the Component and Product IUpdaters and Manual Updaters | 4 | medium | add-in side: manual updater commands and buttons in Trade.All plus the auto-updater start, after the Logic side is repinned |

## KTR5

| Key | Title | Current | Proposed | Confidence | Reason |
|---|---|---|---|---|---|
| [KTR5-2434](https://linear.app/jhkelly/issue/KTR5-2434) | Shared parameters: deprecate the extraneous weld tag parameters | 4 | 4 | medium | code removal plus definitions plus a tie-in with the cleanup tool |
| [KTR5-2461](https://linear.app/jhkelly/issue/KTR5-2461) | Definitions: remove the "I" suffix from definition names in the data files and exporter | 8 | 8 | medium | spans data files, exporter and add-in lookups |
| [KTR5-2775](https://linear.app/jhkelly/issue/KTR5-2775) | Layout Point Import: check the point families when the window opens | 2 | 2 | high | one view model check plus a test (overlaps KTR5-4642) |
| [KTR5-2958](https://linear.app/jhkelly/issue/KTR5-2958) | Module Manager: work on sheet metal (duct) projects | 8 | 8 | medium | new duct categories through Logic and the grids |
| [KTR5-2967](https://linear.app/jhkelly/issue/KTR5-2967) | Validation: move tools that validate through IValueConverters to property validation | 8 | 8 | medium | sweep over several tools |
| [KTR5-3142](https://linear.app/jhkelly/issue/KTR5-3142) | Auto Updaters: they sometimes stop working during a session | 4 | 4 | low | cause unknown, needs in-Revit investigation |
| [KTR5-3144](https://linear.app/jhkelly/issue/KTR5-3144) | Spool Creator V1: nudge family instances so assembly creation doesn't fail |  | skip (parent) | high | has open sub-issues KTR5-4699 and 4701 |
| [KTR5-3277](https://linear.app/jhkelly/issue/KTR5-3277) | Suspended Support Manager: Match column shows true when nothing matches | 1 | 2 | medium | reproduce, then fix the match logic with a test |
| [KTR5-3278](https://linear.app/jhkelly/issue/KTR5-3278) | Suspended Support Manager: handle every fabrication support pattern | 8 | 8 | medium | every pattern of the configuration, in-Revit |
| [KTR5-3279](https://linear.app/jhkelly/issue/KTR5-3279) | Suspended Support Manager: row validation like the Module Manager's |  | skip (parent) | high | has open sub-issue KTR5-4702 |
| [KTR5-3280](https://linear.app/jhkelly/issue/KTR5-3280) | Suspended Support Manager: rebuild how rod geometry values are read and written | 8 | 8 | medium | rebuilds get/set paths in Logic and the manager |
| [KTR5-3281](https://linear.app/jhkelly/issue/KTR5-3281) | Suspended Support Manager: use the shared Scope control instead of its radio buttons | 2 | 2 | high | one view and its view model |
| [KTR5-3680](https://linear.app/jhkelly/issue/KTR5-3680) | Suspended Support Manager: trapeze too wide (needs investigation) | 2 | 2 | low | the problem is not recorded, reproduce first |
| [KTR5-3695](https://linear.app/jhkelly/issue/KTR5-3695) | Unused Shared Parameter Element Delete: tests for the tool and what it calls | 4 | 4 | high | in-Revit tests with KellyDefinitions |
| [KTR5-3703](https://linear.app/jhkelly/issue/KTR5-3703) | Manual Updater: disable Close until the update finishes | 4 | 4 | medium | DialogFooter in Kelly-Revit-UI has no disabled-Close support, small change across layers |
| [KTR5-3747](https://linear.app/jhkelly/issue/KTR5-3747) | Spool Manager: warn detailers when any grid has an error (red) row | 4 | 4 | medium | counts and navigation across several grids |
| [KTR5-3772](https://linear.app/jhkelly/issue/KTR5-3772) | View Schedule Excel export (single file): use Telerik's exporter instead of COM Excel | 4 | 4 | high | rewrite of one export path |
| [KTR5-3773](https://linear.app/jhkelly/issue/KTR5-3773) | View Schedule Excel export (multiple files): use Telerik's exporter instead of COM Excel | 4 | 4 | high | rewrite of one export path plus deleting ExcelInteropTools |
| [KTR5-3774](https://linear.app/jhkelly/issue/KTR5-3774) | View Schedule CSV export: use Telerik's exporter | 4 | 4 | medium | one command, output must match today's |
| [KTR5-3784](https://linear.app/jhkelly/issue/KTR5-3784) | Vicious Fabrication Hanger Place: keep the window open between placements | 4 | 4 | medium | modeless window needs an ExternalEvent |
| [KTR5-3785](https://linear.app/jhkelly/issue/KTR5-3785) | Vicious Fabrication Hanger Place: also place family-based hangers | 4 | 4 | low | open question on families |
| [KTR5-3786](https://linear.app/jhkelly/issue/KTR5-3786) | Vicious Instance Level Assign: list the elements whose level could not change | 4 | 4 | medium | failure capture plus a result list |
| [KTR5-3791](https://linear.app/jhkelly/issue/KTR5-3791) | Module Manager: change the Module Number without leaving the tool | 4 | 4 | high | in-place edit through all members, in-Revit |
| [KTR5-3792](https://linear.app/jhkelly/issue/KTR5-3792) | Module Manager: change the Module Group without leaving the tool | 4 | 4 | high | same pattern as KTR5-3791 |
| [KTR5-3793](https://linear.app/jhkelly/issue/KTR5-3793) | Module Creator: stay open to create module after module | 4 | 4 | medium | modeless conversion |
| [KTR5-3794](https://linear.app/jhkelly/issue/KTR5-3794) | Module Creator: optionally create the module's views, filters and sheet | 4 | 8 | medium | view, filter and sheet creation in Logic plus UI, across layers |
| [KTR5-3795](https://linear.app/jhkelly/issue/KTR5-3795) | Spool Manager: update the Line Number of every member of the selected spools | 4 | 4 | high | one action end to end |
| [KTR5-3796](https://linear.app/jhkelly/issue/KTR5-3796) | Spool Manager: update the Detailing Package of every member of the selected spools | 4 | 4 | high | one action end to end |
| [KTR5-3797](https://linear.app/jhkelly/issue/KTR5-3797) | Spool Manager: update the Spool Number (Assembly Name) of every member of the selected spools | 4 | 4 | high | one action end to end, renames the assembly too |
| [KTR5-3800](https://linear.app/jhkelly/issue/KTR5-3800) | Spool Creator V2: create spools from the assigner contexts, with no window | 0 | skip (parent) | high | has open sub-issues KTR5-3932 to 3935 |
| [KTR5-3808](https://linear.app/jhkelly/issue/KTR5-3808) | Layout Point Export: select and zoom to a row's element like the other tools | 4 | 4 | medium | shared control added to a large view model |
| [KTR5-3809](https://linear.app/jhkelly/issue/KTR5-3809) | Layout Point Export: show the point counts in the Scope options | 4 | 4 | medium | counts per scope that update with the selection |
| [KTR5-3810](https://linear.app/jhkelly/issue/KTR5-3810) | Auto Updaters: agree each updater's configuration with Jason and Adam | 4 | 4 | medium | meeting, sized by prep, kept |
| [KTR5-3811](https://linear.app/jhkelly/issue/KTR5-3811) | Manual Updater: agree each updater's configuration with Jason and Adam | 4 | 4 | medium | meeting, sized by prep, kept |
| [KTR5-3813](https://linear.app/jhkelly/issue/KTR5-3813) | Manual Updater: show a success/fail list after it runs | 4 | 4 | medium | result capture plus a list window |
| [KTR5-3827](https://linear.app/jhkelly/issue/KTR5-3827) | Pipe Offset Create: make lateral, vertical and rolling offsets in one step |  | skip (parent) | high | has open sub-issue KTR5-4719 |
| [KTR5-3829](https://linear.app/jhkelly/issue/KTR5-3829) | Family Instance End Swap: swap connected family instances like fabrication parts | 4 | 8 | medium | new tool with connector geometry in Logic |
| [KTR5-3831](https://linear.app/jhkelly/issue/KTR5-3831) | XAML: debounce EventToCommand calls | 8 | 8 | medium | shared behavior in a lower layer, repinned up |
| [KTR5-3833](https://linear.app/jhkelly/issue/KTR5-3833) | Scope control: filter the consuming grid instead of building an intermediate list | 8 | 8 | medium | shared control plus every view model that uses it |
| [KTR5-3839](https://linear.app/jhkelly/issue/KTR5-3839) | Valve Tag Assign: plan the new tool with Jason and Adam | 4 | 4 | medium | meeting plus writing the build issues, kept |
| [KTR5-3911](https://linear.app/jhkelly/issue/KTR5-3911) | Trapeze placement: extend the rods to the structure automatically | 4 | 4 | medium | reuses the existing extend logic in two tools |
| [KTR5-3924](https://linear.app/jhkelly/issue/KTR5-3924) | Spool Creator: remember the selected Detailing Package between creations | 4 | 2 | medium | keep one combo value in one view model |
| [KTR5-3932](https://linear.app/jhkelly/issue/KTR5-3932) | Spool Creator V2: user interface | 8 | 4 | medium | only a push button and command, no window |
| [KTR5-3933](https://linear.app/jhkelly/issue/KTR5-3933) | Spool Creator V2: logic | 8 | 8 | medium | Logic layer with in-Revit tests, packed and repinned |
| [KTR5-3934](https://linear.app/jhkelly/issue/KTR5-3934) | Spool Creator V2: tests | 8 | 4 | medium | tests for one new command and its logic |
| [KTR5-3935](https://linear.app/jhkelly/issue/KTR5-3935) | Spool Creator V2: remaining work (docs, release notes, retire V1?) | 8 | 2 | medium | docs and one decision |
| [KTR5-3936](https://linear.app/jhkelly/issue/KTR5-3936) | CSV writing: replace CsvHelper | 8 | 8 | high | CsvHelper used in 5 files across several repos |
| [KTR5-3937](https://linear.app/jhkelly/issue/KTR5-3937) | BIM Lite: ask Jason and Adam whether it is still wanted | 1 | 1 | high | one question |
| [KTR5-3938](https://linear.app/jhkelly/issue/KTR5-3938) | Assigners: Inherit All copies a picked element's contexts into the assigners | 4 | 4 | medium | new command across four assigners |
| [KTR5-4003](https://linear.app/jhkelly/issue/KTR5-4003) | System document cache: HashSet instead of List | 1 | 1 | high | same change already done for four caches |
| [KTR5-4004](https://linear.app/jhkelly/issue/KTR5-4004) | Service document cache: HashSet instead of List | 1 | 1 | high | same change already done for four caches |
| [KTR5-4009](https://linear.app/jhkelly/issue/KTR5-4009) | Select Elements By Context: select everything with the current System, Service, Line Number… | 4 | 4 | medium | one new command end to end |
| [KTR5-4015](https://linear.app/jhkelly/issue/KTR5-4015) | Module Manager: show or hide the Line Number column in every grid | 1 | 1 | medium | one check box like Show Signatures |
| [KTR5-4016](https://linear.app/jhkelly/issue/KTR5-4016) | Module Manager: show or hide the Detailing Package column in every grid | 1 | 1 | medium | one check box like Show Signatures |
| [KTR5-4017](https://linear.app/jhkelly/issue/KTR5-4017) | Element Select Zoom: Select In View check box raises Checked/Unchecked events | 1 | 1 | medium | one control in Kelly-Revit-UI |
| [KTR5-4018](https://linear.app/jhkelly/issue/KTR5-4018) | Element Select Zoom: Zoom To Selection check box raises Checked/Unchecked events | 1 | 1 | medium | one control in Kelly-Revit-UI |
| [KTR5-4019](https://linear.app/jhkelly/issue/KTR5-4019) | Element Select Zoom: remove EventToCommandBehavior from Select In View and its views | 1 | 2 | medium | about 5 hosting views plus a repin of Kelly-Revit-UI |
| [KTR5-4020](https://linear.app/jhkelly/issue/KTR5-4020) | Element Select Zoom: remove EventToCommandBehavior from Zoom To Selection and its views | 1 | 2 | medium | about 5 hosting views plus a repin of Kelly-Revit-UI |
| [KTR5-4024](https://linear.app/jhkelly/issue/KTR5-4024) | Assigners: one button resets every assigner | 4 | 4 | medium | new button reusing the per-assigner reset |
| [KTR5-4028](https://linear.app/jhkelly/issue/KTR5-4028) | Stratus Detailing Package 3D View: a dialog to choose base view, prefix and package | 8 | 8 | medium | new dialog tool |
| [KTR5-4029](https://linear.app/jhkelly/issue/KTR5-4029) | 3D Detailer Views: create a VDC 3D view per VDC package | 8 | 8 | medium | new tool with filters and colors |
| [KTR5-4040](https://linear.app/jhkelly/issue/KTR5-4040) | Arrange Instance Align Move: limit the categories it can move | 2 | 2 | high | a category guard plus a report |
| [KTR5-4042](https://linear.app/jhkelly/issue/KTR5-4042) | Vicious Straights Racker: one fabrication duct shape's size can't be read (reproduce first) | 1 | 1 | low | the shape is not known |
| [KTR5-4043](https://linear.app/jhkelly/issue/KTR5-4043) | Vicious Instance Rotate Move: window crops its controls | 1 | 1 | high | XAML sizing |
| [KTR5-4063](https://linear.app/jhkelly/issue/KTR5-4063) | Suspended Support Manager: filter the grid by Element Id | 1 | 2 | medium | pasting a list of Ids needs a custom filter |
| [KTR5-4064](https://linear.app/jhkelly/issue/KTR5-4064) | Assigners: refuse to turn on an auto-assigner while its value is the default | 2 | 2 | high | guard in the shared switch logic |
| [KTR5-4077](https://linear.app/jhkelly/issue/KTR5-4077) | Auto Updaters: review meetings on each updater and the services it calls | 1 | 1 | medium | meeting, kept |
| [KTR5-4085](https://linear.app/jhkelly/issue/KTR5-4085) | Assigners: dockable assigner panel | 2 | 2 | medium | AssignerDockablePanel already exists in Trade.All, mostly the open question is left |
| [KTR5-4110](https://linear.app/jhkelly/issue/KTR5-4110) | Kelly-Windows: remove the ObjectsComparer dependency (abandoned library) | 2 | 2 | high | one file (ComparerTools) uses it |
| [KTR5-4119](https://linear.app/jhkelly/issue/KTR5-4119) | Duct QA Length: suggest straight lengths that cut waste |  | skip (parent) | high | has open sub-issues KTR5-4125 to 4128 |
| [KTR5-4120](https://linear.app/jhkelly/issue/KTR5-4120) | Duct QA Mirror: find mirrored or handed fittings |  | skip (parent) | high | has open sub-issues KTR5-4121 to 4124 |
| [KTR5-4121](https://linear.app/jhkelly/issue/KTR5-4121) | Duct QA Mirror: port the Hill Group Visual Basic mirror check to C# | 8 | 8 | medium | port into Logic and Domain, across layers |
| [KTR5-4122](https://linear.app/jhkelly/issue/KTR5-4122) | Duct QA Mirror: view | 8 | 4 | medium | one window, push button and contract tests |
| [KTR5-4123](https://linear.app/jhkelly/issue/KTR5-4123) | Duct QA Mirror: view model | 8 | 4 | medium | one view model on the shared Scope control |
| [KTR5-4124](https://linear.app/jhkelly/issue/KTR5-4124) | Duct QA Mirror: model(s) | 8 | 2 | medium | a few row types with tests |
| [KTR5-4125](https://linear.app/jhkelly/issue/KTR5-4125) | Duct QA Length: model(s) | 8 | 2 | medium | a few row types with tests |
| [KTR5-4126](https://linear.app/jhkelly/issue/KTR5-4126) | Duct QA Length: view model | 8 | 4 | medium | one view model on the shared Scope control |
| [KTR5-4127](https://linear.app/jhkelly/issue/KTR5-4127) | Duct QA Length: view | 8 | 4 | medium | one window, push button and contract tests |
| [KTR5-4128](https://linear.app/jhkelly/issue/KTR5-4128) | Duct QA Length: port the Hill Group Visual Basic length logic to C# | 8 | 8 | medium | port into Logic and Domain, across layers |
| [KTR5-4136](https://linear.app/jhkelly/issue/KTR5-4136) | OperationService: email the logs to Chris Hildebran at every document close | 4 | 8 | medium | new mail service plus a hook on document close, likely across layers |
| [KTR5-4170](https://linear.app/jhkelly/issue/KTR5-4170) | Signatures: compare parts with an IEqualityComparer instead of the geometry signature string |  | skip (parent) | high | has open sub-issue KTR5-4697 |
| [KTR5-4174](https://linear.app/jhkelly/issue/KTR5-4174) | Welds: write the joined parts' material type and wall thickness to the weld | 4 | 4 | low | open questions on the target parameters |
| [KTR5-4175](https://linear.app/jhkelly/issue/KTR5-4175) | Code style: initialize collections where they are declared, not in constructors | 8 | 8 | high | sweep over every v5 repo |
| [KTR5-4177](https://linear.app/jhkelly/issue/KTR5-4177) | About window: status lists of services, data files, commands and updaters | 8 | 8 | medium | needs status exposed by the lower-layer services |
| [KTR5-4253](https://linear.app/jhkelly/issue/KTR5-4253) | Layout Point Import: list CSV rows missing layer or required data before importing | 4 | 4 | high | row validation plus a list window |
| [KTR5-4255](https://linear.app/jhkelly/issue/KTR5-4255) | Content cleanup: find fabrication parts whose ITM is gone from the fabrication database | 8 | 8 | medium | new tool |
| [KTR5-4256](https://linear.app/jhkelly/issue/KTR5-4256) | Content cleanup: remove unused or deprecated JHK shared parameters from a project | 4 | 8 | medium | new tool with a usage scan and removal |
| [KTR5-4322](https://linear.app/jhkelly/issue/KTR5-4322) | XAML views: one command per Click instead of several EventBindings | 8 | 8 | high | 10 XAML files use telerik:EventBinding |
| [KTR5-4448](https://linear.app/jhkelly/issue/KTR5-4448) | Vicious Straights Racker: inaccurate move aligning top of pipe to a trapeze bottom (reproduce first) | 2 | 2 | low | reproduce first |
| [KTR5-4478](https://linear.app/jhkelly/issue/KTR5-4478) | KTR-3D view: do less on document open | 2 | 2 | high | in Testing, one handler |
| [KTR5-4480](https://linear.app/jhkelly/issue/KTR5-4480) | OperationService: catch errors per element inside the change loops |  | skip (parent) | high | has open sub-issues KTR5-4704, 4706, 4707 |
| [KTR5-4493](https://linear.app/jhkelly/issue/KTR5-4493) | Claude Code: try Nice3point's revit-skills in the Kelly repositories | 2 | 2 | medium | evaluation only |
| [KTR5-4494](https://linear.app/jhkelly/issue/KTR5-4494) | IUpdaters: analyze what each updater needs (triggers, parameters, data) | 4 | 4 | medium | analysis across every updater |
| [KTR5-4496](https://linear.app/jhkelly/issue/KTR5-4496) | Family Version tool: fails when a nested family has the version shared parameters | 4 | 4 | medium | reproduce, then fix with an in-Revit test |
| [KTR5-4510](https://linear.app/jhkelly/issue/KTR5-4510) | VCS-Database-General-Schema: deprecate the ProjectSession table | 1 | 1 | high | rename plus a Changelog entry |
| [KTR5-4513](https://linear.app/jhkelly/issue/KTR5-4513) | VCS-Database-General-Schema: deprecate USP_ProjectSession_Insert | 1 | 1 | high | rename plus a Changelog entry |
| [KTR5-4514](https://linear.app/jhkelly/issue/KTR5-4514) | VCS-Database-General-Schema: deprecate USP_ProjectSession_Update | 1 | 1 | high | rename plus a Changelog entry |
| [KTR5-4515](https://linear.app/jhkelly/issue/KTR5-4515) | VCS-Database-General-Schema: deprecate the ProjectUpdatersLog table | 1 | 1 | high | table and view rename plus a Changelog entry |
| [KTR5-4517](https://linear.app/jhkelly/issue/KTR5-4517) | Delete - Dead Code From All Repositories |  | skip (parent) | high | has open sub-issues KTR5-4518 to 4521 |
| [KTR5-4518](https://linear.app/jhkelly/issue/KTR5-4518) | Delete - Dead Code From Kelly.Revit | 1 | 1 | low | no description, deleting dead code |
| [KTR5-4519](https://linear.app/jhkelly/issue/KTR5-4519) | Delete - Dead Code From Kelly.REvit.Logic | 1 | 1 | low | no description, a lower layer may need packing |
| [KTR5-4520](https://linear.app/jhkelly/issue/KTR5-4520) | Delete - Dead Code From Kelly.Windows | 1 | 1 | low | no description, a lower layer may need packing |
| [KTR5-4521](https://linear.app/jhkelly/issue/KTR5-4521) | Delete - Dead Code From Kelly.Windows.Data | 1 | 1 | low | no description, a lower layer may need packing |
| [KTR5-4525](https://linear.app/jhkelly/issue/KTR5-4525) | Element services: keep the updater element services out of command use | 8 | 8 | medium | 9 module files reference element services, plus a split in Logic |
| [KTR5-4581](https://linear.app/jhkelly/issue/KTR5-4581) | Tool to recover OperationService logs (.json, .jsonl) | 8 | 8 | low | new tool, title only |
| [KTR5-4582](https://linear.app/jhkelly/issue/KTR5-4582) | Refactor the application services if needed | 4 | 4 | low | scope undefined |
| [KTR5-4596](https://linear.app/jhkelly/issue/KTR5-4596) | Implement a hierarchical application and tool settings file |  | skip (parent) | high | has an open sub-issue |
| [KTR5-4597](https://linear.app/jhkelly/issue/KTR5-4597) | Is there any other file data I/O that Kelly.Windows.Data.* can handle? | 2 | 2 | low | analysis question |
| [KTR5-4601](https://linear.app/jhkelly/issue/KTR5-4601) | Configure the InstallShield project for different install types |  | skip (parent) | high | open sub-issues KTR5-4608/4609/4610 |
| [KTR5-4602](https://linear.app/jhkelly/issue/KTR5-4602) | Read and write the settings file with Kelly.Windows.Data.Json | 8 | 8 | medium | new format library wired through the layers up to the add-in |
| [KTR5-4604](https://linear.app/jhkelly/issue/KTR5-4604) | Mark the SQL procedures only v5 called (step 9 of the plan) | 2 | skip (parent) | high | open sub-issues KTR5-4510/4513/4514/4515 |
| [KTR5-4608](https://linear.app/jhkelly/issue/KTR5-4608) | Detailer | 2 | 2 | low | title only: one InstallShield install type |
| [KTR5-4609](https://linear.app/jhkelly/issue/KTR5-4609) | Manager | 2 | 2 | low | title only: one InstallShield install type |
| [KTR5-4610](https://linear.app/jhkelly/issue/KTR5-4610) | Contenter | 2 | 2 | low | title only: one InstallShield install type |
| [KTR5-4618](https://linear.app/jhkelly/issue/KTR5-4618) | Enable the ProjectInformationEditor for project shared parameters | 8 | 8 | medium | new tool in v5, not in the modules yet |
| [KTR5-4621](https://linear.app/jhkelly/issue/KTR5-4621) | Enable light and dark mode for the versions of Revit that have that feature |  | skip (parent) | high | open sub-issue KTR5-4623 |
| [KTR5-4623](https://linear.app/jhkelly/issue/KTR5-4623) | Light-mode and dark-mode icons (use the proper green color) | 8 | 8 | medium | sweep over every button icon in all modules |
| [KTR5-4624](https://linear.app/jhkelly/issue/KTR5-4624) | Suspended Support Manager: show vertical members in a separate grid below | 4 | 4 | medium | XAML plus view model rework in one tool |
| [KTR5-4625](https://linear.app/jhkelly/issue/KTR5-4625) | Implement the scope control in every window that doesn't have it yet | 8 | 8 | medium | sweep over many windows and view models |
| [KTR5-4626](https://linear.app/jhkelly/issue/KTR5-4626) | Order the User Domain Report (Developer tab) by EmployeeId | 4 | 4 | medium | small change in Kelly-Windows-v3 DomainGroupReport, needs a pack and repin |
| [KTR5-4627](https://linear.app/jhkelly/issue/KTR5-4627) | Use the other JH Kelly brand colors beside Kelly Green |  | skip (parent) | high | open sub-issues KTR5-4632/4633/4634 |
| [KTR5-4630](https://linear.app/jhkelly/issue/KTR5-4630) | Take all push button names from a names property | 8 | 8 | high | 50 literal push button texts across the modules |
| [KTR5-4631](https://linear.app/jhkelly/issue/KTR5-4631) | Racker: Bottom/Top align buttons overwrite the typed elevation in Manual mode | 1 | 1 | high | remove two XAML event bindings |
| [KTR5-4632](https://linear.app/jhkelly/issue/KTR5-4632) | Add the brand colors once as named colors, brushes and resources | 8 | 8 | high | Kelly-Windows-v3 Palettes plus a Kelly-Revit-UI dictionary, packed and repinned |
| [KTR5-4633](https://linear.app/jhkelly/issue/KTR5-4633) | Replace the off-palette colors in the views and panels | 2 | 2 | medium | 5 known color literals in a few views |
| [KTR5-4634](https://linear.app/jhkelly/issue/KTR5-4634) | Decide the status colors beside the brand palette | 4 | 4 | medium | a decision plus 5 color types in Kelly-Windows-v3 and Trade.Pipe |
| [KTR5-4635](https://linear.app/jhkelly/issue/KTR5-4635) | Layout Point Export: Data Filter drops hidden saved points on save | 2 | 2 | medium | one view model fix, needs a Revit check |
| [KTR5-4636](https://linear.app/jhkelly/issue/KTR5-4636) | Layout Point Import: Specify Level always fails with an unhandled error | 2 | 2 | high | binding fix in one view |
| [KTR5-4637](https://linear.app/jhkelly/issue/KTR5-4637) | Spool Manager: a failed edit commits partial changes and closes the tool | 4 | 4 | high | 11 operations to wrap in a 1069-line view model |
| [KTR5-4638](https://linear.app/jhkelly/issue/KTR5-4638) | Layout Point Export: cancelling the check or Save As still rewrites hosts | 4 | 4 | medium | reorders the export flow in one tool |
| [KTR5-4639](https://linear.app/jhkelly/issue/KTR5-4639) | Layout Point Export: Save with no valid point shows the exception prompt | 2 | 2 | high | one guard in one view model |
| [KTR5-4640](https://linear.app/jhkelly/issue/KTR5-4640) | Layout Point Export: Exported and Not Valid filters name missing members | 2 | 2 | high | member names and label count in one code-behind |
| [KTR5-4641](https://linear.app/jhkelly/issue/KTR5-4641) | Layout Point Export: tool will not open when the plan has no hangers | 2 | 2 | high | relax ValidateRequirements in one view model |
| [KTR5-4642](https://linear.app/jhkelly/issue/KTR5-4642) | Layout Point Import: missing point families throw a NullReferenceException | 2 | 2 | high | null checks in one view model |
| [KTR5-4643](https://linear.app/jhkelly/issue/KTR5-4643) | Olet Check: Re-Connect and Select act on the wrong project with two open | 4 | 4 | medium | document handling across view model, command and external event handlers |
| [KTR5-4644](https://linear.app/jhkelly/issue/KTR5-4644) | Point to Pipe: a typed or pasted Point File path is ignored | 2 | 2 | high | one code-behind fix |
| [KTR5-4645](https://linear.app/jhkelly/issue/KTR5-4645) | Point to Pipe: units boxes always start at Inches and Feet | 4 | 4 | medium | settings assignment plus project-units fallback in a messy tool |
| [KTR5-4646](https://linear.app/jhkelly/issue/KTR5-4646) | Spool Manager: will not open without a Spool title block type | 2 | 2 | high | one check and a disabled command |
| [KTR5-4647](https://linear.app/jhkelly/issue/KTR5-4647) | Suspended Support Manager: Override Size Set clears tags without a size | 2 | 2 | high | one method fix |
| [KTR5-4648](https://linear.app/jhkelly/issue/KTR5-4648) | Suspended Support Manager: Tagging Set tags un-hosted hangers when disallowed | 2 | 2 | high | one condition fix |
| [KTR5-4649](https://linear.app/jhkelly/issue/KTR5-4649) | Layout Point Export: save clears the Revit selection and empties the grid | 2 | 2 | medium | selection-sync fix in one view model |
| [KTR5-4650](https://linear.app/jhkelly/issue/KTR5-4650) | Layout Point Export: export window stays always on top | 1 | 1 | high | one line |
| [KTR5-4651](https://linear.app/jhkelly/issue/KTR5-4651) | Layout Point Export: quality dialog shows placeholder text | 2 | 2 | high | dialog content in one method |
| [KTR5-4652](https://linear.app/jhkelly/issue/KTR5-4652) | Layout Point Export: Danger and Caution quality counts never fire | 8 | 8 | medium | decision plus a Logic stub, packed and repinned |
| [KTR5-4653](https://linear.app/jhkelly/issue/KTR5-4653) | Level Correct: an element with no category throws NullReferenceException | 1 | 1 | high | one-line filter fix |
| [KTR5-4654](https://linear.app/jhkelly/issue/KTR5-4654) | Level Correct: no model elements gives a raw List must contain error | 2 | 2 | high | one guard and message in the same command |
| [KTR5-4655](https://linear.app/jhkelly/issue/KTR5-4655) | Line Number Selector: Add Context Value check box label is run together | 1 | 1 | high | label text in one view model |
| [KTR5-4656](https://linear.app/jhkelly/issue/KTR5-4656) | Module Creator: DEFAULT placeholder prefix shown in an empty project | 2 | 2 | high | filter in one view model |
| [KTR5-4657](https://linear.app/jhkelly/issue/KTR5-4657) | Module Manager: Item Numbers Update button stays disabled after BOM update | 2 | 2 | high | one view or view model fix |
| [KTR5-4658](https://linear.app/jhkelly/issue/KTR5-4658) | Module Manager: Components grid shows item numbers that were not saved | 2 | 2 | high | restore on failed commit in one view model |
| [KTR5-4659](https://linear.app/jhkelly/issue/KTR5-4659) | Olet Check: Select links keep stale enabled state after a reload | 1 | 1 | high | invalidate two commands |
| [KTR5-4660](https://linear.app/jhkelly/issue/KTR5-4660) | Olet Check: opening the dialog checks the olets twice | 1 | 1 | high | drop one call |
| [KTR5-4661](https://linear.app/jhkelly/issue/KTR5-4661) | Racker: user cancel ends the command as Failed instead of Cancelled | 4 | 4 | medium | same Result fix in several v5 commands |
| [KTR5-4662](https://linear.app/jhkelly/issue/KTR5-4662) | Racker: will not open when a Straights item has no level | 2 | 2 | high | null handling in one view model |
| [KTR5-4663](https://linear.app/jhkelly/issue/KTR5-4663) | Spool Creator: SPA and SPT categories do not parse as spool numbers | 4 | 8 | medium | SpoolNumber.TryParse is in Kelly-Domain: Domain pack and repin through Logic, UI and the add-in |
| [KTR5-4664](https://linear.app/jhkelly/issue/KTR5-4664) | Spool Creator: one Create is three Undo steps | 2 | 2 | high | transaction group in one view model |
| [KTR5-4665](https://linear.app/jhkelly/issue/KTR5-4665) | Spool Manager: grids keep new values after Revit rolls an edit back | 2 | 2 | high | IsCommitted check and reload |
| [KTR5-4666](https://linear.app/jhkelly/issue/KTR5-4666) | Suspended Support Manager: Set Extensions on unattached hangers extends no rod | 2 | 2 | high | skip and report in one method |
| [KTR5-4667](https://linear.app/jhkelly/issue/KTR5-4667) | Suspended Support Manager: field trim stored in inches, not feet | 1 | 1 | high | one variable |
| [KTR5-4668](https://linear.app/jhkelly/issue/KTR5-4668) | Windows Mockup: product-code list goes blank after a scope change | 1 | 1 | high | one collection fix |
| [KTR5-4678](https://linear.app/jhkelly/issue/KTR5-4678) | Refactor and clean up the Vicious tools |  | skip (parent) | high | open sub-issues KTR5-4713 to 4718 |
| [KTR5-4680](https://linear.app/jhkelly/issue/KTR5-4680) | Are there any TODO notes that can be handled? | 8 | 8 | medium | 54 todos in this repo, sweep |
| [KTR5-4681](https://linear.app/jhkelly/issue/KTR5-4681) | Deduplicate the SetActiveProjectLocation combo code in two ViewModels | 2 | 2 | high | extract one helper from two view models |
| [KTR5-4682](https://linear.app/jhkelly/issue/KTR5-4682) | Point to Pipe: use the PointToPipeUnits constants instead of unit literals | 1 | 1 | high | replace literals in two files |
| [KTR5-4685](https://linear.app/jhkelly/issue/KTR5-4685) | Rename debris and config drift | 2 | 2 | high | four small cleanups in src |
| [KTR5-4689](https://linear.app/jhkelly/issue/KTR5-4689) | Implement the Unit Test Implementation plan for Kelly Tools For Revit |  | skip (parent) | high | open sub-issues KTR5-4703/4705/4708-4712 and others |
| [KTR5-4693](https://linear.app/jhkelly/issue/KTR5-4693) | Final test: KTR needs to work without connecting to a JHK network (no VPN, etc.) | 4 | 4 | medium | manual end-to-end check off the network |
| [KTR5-4694](https://linear.app/jhkelly/issue/KTR5-4694) | Run the tooltip and icon commits inside Revit | 2 | 2 | medium | one in-Revit run plus a ribbon spot check, no code |
| [KTR5-4696](https://linear.app/jhkelly/issue/KTR5-4696) | OperationService.Run: assigner filter, Duct, Manager and Rotate Move commands | 2 | 4 | medium | 12 sites across 10+ command types, blocked until moved to Logic |
| [KTR5-4697](https://linear.app/jhkelly/issue/KTR5-4697) | Fabrication Part Dimension Log and Suspended Support Manager: use the comparers | 2 | 2 | medium | one command change and a filter check |
| [KTR5-4698](https://linear.app/jhkelly/issue/KTR5-4698) | OperationService.Run: Layout Point Export, Module Manage, Spool Create, Support Manager | 2 | 4 | medium | 8 sites in four large view models |
| [KTR5-4699](https://linear.app/jhkelly/issue/KTR5-4699) | Spool Creator V1: reproduce the assembly creation failure on family instances | 1 | 1 | medium | reproduce only, no code change |
| [KTR5-4700](https://linear.app/jhkelly/issue/KTR5-4700) | OperationService.Run: decide Many Connect, Custom Data Updater V2, Layout Point CSV, Spool Create | 2 | 4 | medium | per-site decision and restructuring of partial commits in 4 types |
| [KTR5-4701](https://linear.app/jhkelly/issue/KTR5-4701) | Spool Creator V1: repin and verify on the failing families | 1 | 1 | high | repin plus one check |
| [KTR5-4702](https://linear.app/jhkelly/issue/KTR5-4702) | Suspended Support Manager: mark rows with invalid properties | 2 | 2 | medium | XAML validation, marker and one filter |
| [KTR5-4703](https://linear.app/jhkelly/issue/KTR5-4703) | Add-in host: tests for `Caches`, the 4 event handlers, `Resources`, `ApplicationSessionService` | 2 | 4 | medium | 7 types, in-Revit tests |
| [KTR5-4704](https://linear.app/jhkelly/issue/KTR5-4704) | Per-element catch in the Trade.All color filter assigners | 2 | 2 | medium | 7 commands of one shape, after the Logic helper is repinned |
| [KTR5-4705](https://linear.app/jhkelly/issue/KTR5-4705) | Trade.All assigners: tests for the combo boxes, settings and event handlers | 4 | 8 | medium | 19 types in a 130-file folder, in-Revit tests with KellyDefinitions stubs |
| [KTR5-4706](https://linear.app/jhkelly/issue/KTR5-4706) | Per-element catch in the spool and support managers | 4 | 4 | high | 11 blocks in SpoolManager plus the support manager |
| [KTR5-4707](https://linear.app/jhkelly/issue/KTR5-4707) | Per-element catch in the remaining module commands | 2 | 4 | medium | 5 commands in 3 modules |
| [KTR5-4708](https://linear.app/jhkelly/issue/KTR5-4708) | Trade.All view models: Spools, Supports, Layout Points, Module Creator | 4 | 8 | high | 8 view models, about 3,800 lines (SpoolManager 1069, SuspendedSupportManager 729) |
| [KTR5-4709](https://linear.app/jhkelly/issue/KTR5-4709) | Trade.All other commands: Vicious, About, Arranger, Excel, updater helpers | 4 | 4 | medium | about 11 types, overlaps the Vicious cleanup |
| [KTR5-4710](https://linear.app/jhkelly/issue/KTR5-4710) | Trade.All ribbon items: tests for the 24 stacked buttons and enablers | 2 | 2 | medium | repetitive tests, only what runs without an active view |
| [KTR5-4711](https://linear.app/jhkelly/issue/KTR5-4711) | Contenter, Developer, Duct and Pipe modules: tests for the 15 untested types | 4 | 4 | medium | 15 types across 4 modules |
| [KTR5-4712](https://linear.app/jhkelly/issue/KTR5-4712) | Tests.Revit: the 4 tests that need the add-in started fail with it disabled | 1 | 1 | high | Assume.That in 4 tests |
| [KTR5-4713](https://linear.app/jhkelly/issue/KTR5-4713) | Vicious Point To Pipe: move the view's code-behind logic into the view model | 4 | 4 | high | 351-line code-behind to the view model with tests |
| [KTR5-4714](https://linear.app/jhkelly/issue/KTR5-4714) | Vicious Point To Pipe: break up `ViciousFileBasedSystemPipePlaceTools` | 4 | 4 | high | 525-line class split into several types with tests |
| [KTR5-4715](https://linear.app/jhkelly/issue/KTR5-4715) | Vicious Straights Racker: clean up `ViciousInstanceElevationAssignViewModel` | 4 | 4 | high | 346-line view model split with prompts and tests |
| [KTR5-4716](https://linear.app/jhkelly/issue/KTR5-4716) | Vicious Instance Rotate Move: clean up the command | 4 | 4 | high | 267-line stateful command refactor |
| [KTR5-4717](https://linear.app/jhkelly/issue/KTR5-4717) | Vicious Fabrication Hanger Place: clean up command and options window | 2 | 2 | medium | bare catch and 118-line code-behind to a view model |
| [KTR5-4718](https://linear.app/jhkelly/issue/KTR5-4718) | Vicious Instance Level Assign and Instance Disconnect: clean up | 2 | 2 | medium | two small tools aligned to MVVM and Run |
| [KTR5-4719](https://linear.app/jhkelly/issue/KTR5-4719) | Pipe Offset Create: command, window and push button in Trade.Pipe | 4 | 4 | medium | one tool end to end; the Logic offset creation is a sibling issue |
| [KTR5-4721](https://linear.app/jhkelly/issue/KTR5-4721) | Layout Point Export, About and App: call the Kelly.Windows helpers of moves #4, #15, #16 | 1 | 1 | high | three call replacements |
| [KTR5-4726](https://linear.app/jhkelly/issue/KTR5-4726) | Deprecate the Component and Product IUpdaters and Manual Updaters |  | 4 | medium | add-in side: manual updater commands and buttons in Trade.All plus the auto-updater start, after the Logic side is repinned |

## KTRUI

| Key | Title | Current | Proposed | Confidence | Reason |
|---|---|---|---|---|---|
| [KTRUI-1](https://linear.app/jhkelly/issue/KTRUI-1) | Review the Kelly-Revit-UI controls for improvements | 4 | 4 | low | open-ended review of ~5 XAML controls in src/Controls |
| [KTRUI-2](https://linear.app/jhkelly/issue/KTRUI-2) | Handle the open // todo notes in Kelly-Revit-UI | 4 | 4 | medium | single TODO is implementing ElementFilter in CommandBase, a base type every command uses |
| [KTRUI-3](https://linear.app/jhkelly/issue/KTRUI-3) | Every build warns CS0419 six times on the ArgumentNullException cref | 1 | 1 | high | cref fixes in six doc comments |
| [KTRUI-10](https://linear.app/jhkelly/issue/KTRUI-10) | Tests for the 16 untested Kelly-Revit-UI types | 4 | 4 | high | tests across several folders, contract tests only for UIDocument members |

## KTRL5

| Key | Title | Current | Proposed | Confidence | Reason |
|---|---|---|---|---|---|
| [KTRL5-1](https://linear.app/jhkelly/issue/KTRL5-1) | Remove this layer's copies of the code moved down on 2026-11-04 |  | skip (parent) | high | open sub-issue KTRL5-43 (plus KTRUI-11, KTR5-4580) |
| [KTRL5-2](https://linear.app/jhkelly/issue/KTRL5-2) | Move DataFileService to Kelly-Domain | 8 | 8 | high | breaking type move into a lower layer, needs injected Logic factory, pack and repin |
| [KTRL5-3](https://linear.app/jhkelly/issue/KTRL5-3) | Move the 66 remaining OperationService call sites to Run and Run<T> |  | skip (parent) | high | open sub-issues KTRL5-30/31/33/35 and KTR5 children |
| [KTRL5-4](https://linear.app/jhkelly/issue/KTRL5-4) | Deprecation plans for Kelly-Revit-Logic-v5 |  | skip (parent) | high | open sub-issue KTRL5-8 |
| [KTRL5-5](https://linear.app/jhkelly/issue/KTRL5-5) | Handle the open // todo notes in Kelly-Revit-Logic-v5 |  | skip (parent) | high | open sub-issues KTRL5-24..29 |
| [KTRL5-6](https://linear.app/jhkelly/issue/KTRL5-6) | PenetrationTagTools.CreateTag mixes invariant and current culture | 2 | 2 | medium | one method in one file; deferred (KTR US-only) |
| [KTRL5-7](https://linear.app/jhkelly/issue/KTRL5-7) | Test that SetWeldLocation leaves a matching JHK BOM Type alone | 4 | 4 | high | needs an in-Revit test and a seam to see the dropped ParameterResultType |
| [KTRL5-8](https://linear.app/jhkelly/issue/KTRL5-8) | Deprecate the Component and Product updaters | 8 | 8 | medium | removes updater configurations and element services, callers up to Kelly-Revit-v5 |
| [KTRL5-24](https://linear.app/jhkelly/issue/KTRL5-24) | Updater element services: resolve the 23 "Implement Data Point" notes | 4 | 4 | medium | 13 element services in one folder, in-Revit tests |
| [KTRL5-25](https://linear.app/jhkelly/issue/KTRL5-25) | Spool: write uniform line, spool, module number and group to the assembly | 2 | 2 | medium | one type, four values; in-Revit test may push it to 4 |
| [KTRL5-26](https://linear.app/jhkelly/issue/KTRL5-26) | Spools: type JhkTag as Tag, give IsSpoolAble a result, plan a LineNumber type | 4 | 4 | high | several types in Spools with callers and tests |
| [KTRL5-27](https://linear.app/jhkelly/issue/KTRL5-27) | SuspendedSupport: settle the 6 notes on its shape and property notifications | 2 | 2 | high | one class plus moving SetTag to its base |
| [KTRL5-28](https://linear.app/jhkelly/issue/KTRL5-28) | Service and System document caches: name and place them as data-store caches | 2 | 2 | medium | renames/moves of two caches and one function in one repo |
| [KTRL5-29](https://linear.app/jhkelly/issue/KTRL5-29) | Size data model, annotation arranger, layout point recipe: last 5 notes | 2 | 2 | medium | three small decisions in three files |
| [KTRL5-30](https://linear.app/jhkelly/issue/KTRL5-30) | OperationService.Run: Elements, Families, Projects, Mep and Updaters sites | 2 | 2 | medium | 9 mechanical site conversions with tests already patterned |
| [KTRL5-31](https://linear.app/jhkelly/issue/KTRL5-31) | OperationService.Run: Fabrication, Spools and Supports sites | 2 | 2 | medium | 7 mechanical site conversions |
| [KTRL5-32](https://linear.app/jhkelly/issue/KTRL5-32) | VerticalSupportMemberComparer | 2 | 2 | high | one new comparer type with its tests |
| [KTRL5-33](https://linear.app/jhkelly/issue/KTRL5-33) | OperationService.Run: Views, Layout Points and Arrangement sites | 2 | 2 | medium | 8 mechanical site conversions |
| [KTRL5-34](https://linear.app/jhkelly/issue/KTRL5-34) | SuspendedSupportComparer: use it in GetNextTag and the signature-tag match grouping | 4 | 4 | high | new comparer plus two call sites, depends on a Kelly-Domain overload |
| [KTRL5-35](https://linear.app/jhkelly/issue/KTRL5-35) | OperationService.Run: decide the 3 Logic sites that commit partial work | 2 | 2 | high | three sites, one restructure of ImportTx |
| [KTRL5-36](https://linear.app/jhkelly/issue/KTRL5-36) | FabricationPartGeometryComparer | 2 | 2 | high | one new comparer type with its tests |
| [KTRL5-37](https://linear.app/jhkelly/issue/KTRL5-37) | Spool: nudge family instances 1/32" before AssemblyInstance.Create | 2 | 2 | medium | small change in one method; in-Revit check |
| [KTRL5-38](https://linear.app/jhkelly/issue/KTRL5-38) | PhysicalElementEntity: report property errors through ModelBase | 4 | 4 | high | base class change affecting SuspendedSupport and its tests |
| [KTRL5-39](https://linear.app/jhkelly/issue/KTRL5-39) | SuspendedSupport and VerticalSupportMember: validation rules for the editable properties | 2 | 2 | high | attributes/rules on two types after KTRL5-38 |
| [KTRL5-40](https://linear.app/jhkelly/issue/KTRL5-40) | OperationService: per-element loop helper that logs and skips a failed element | 4 | 4 | high | new public helper on a core service with docs and in-Revit tests |
| [KTRL5-41](https://linear.app/jhkelly/issue/KTRL5-41) | Per-element catch in the Logic change loops: Elements, Fabrication, Spools, Supports, Updaters | 4 | 4 | high | about 12 sites across several folders |
| [KTRL5-42](https://linear.app/jhkelly/issue/KTRL5-42) | Per-element catch in the other Logic change loops: Views, Documents, Families, Layout Points, MEP, … | 4 | 4 | medium | remaining sites across several folders |
| [KTRL5-43](https://linear.app/jhkelly/issue/KTRL5-43) | CustomDataUpdateEvaluator: switch ResolveRecord to Domain TryResolveRecord (#57) | 2 | 2 | high | one type, null-case decision and test |
| [KTRL5-45](https://linear.app/jhkelly/issue/KTRL5-45) | Pipe offset: create the offset in an MEP pipe run | 4 | 4 | high | one tool's Logic end to end with in-Revit tests |
| [KTRL5-46](https://linear.app/jhkelly/issue/KTRL5-46) | Pipe offset: create the offset in a fabrication part run | 4 | 4 | medium | fabrication placement, tests need the Kelly test project |

## KTR4

| Key | Title | Current | Proposed | Confidence | Reason |
|---|---|---|---|---|---|
| [KTR4-2](https://linear.app/jhkelly/issue/KTR4-2) | Use the other JH Kelly brand colors beside Kelly Green |  | skip (parent) | high | parent of open KTR4-24/25/26 |
| [KTR4-3](https://linear.app/jhkelly/issue/KTR4-3) | Move the feet-and-inches check into Kelly-Windows-v2 ConstructionServices | 8 | 8 | high | Kelly-Windows-v2 pack and repin of Logic and add-in |
| [KTR4-18](https://linear.app/jhkelly/issue/KTR4-18) | Are there any TODO notes that can be handled? |  | skip (parent) | high | parent of open KTR4-66..73 and KTRL4-2 |
| [KTR4-24](https://linear.app/jhkelly/issue/KTR4-24) | Add the brand colors once as named colors and brushes | 8 | 8 | high | Kelly-Windows-v2 pack and repin plus add-in resource dictionary |
| [KTR4-25](https://linear.app/jhkelly/issue/KTR4-25) | Replace the off-palette colors in the views and converters | 8 | 8 | medium | views in add-in plus Kelly-Windows-v2 converters, across layers |
| [KTR4-26](https://linear.app/jhkelly/issue/KTR4-26) | Decide the status colors (success, warning, danger) | 4 | 4 | medium | decision plus three types in Kelly-Windows-v2, matched with v5 |
| [KTR4-27](https://linear.app/jhkelly/issue/KTR4-27) | Racker: Bottom/Top align buttons override typed elevation in Manual mode | 1 | 1 | high | remove two XAML event bindings |
| [KTR4-28](https://linear.app/jhkelly/issue/KTR4-28) | Module Manage: Item Numbers button stays disabled after BOM type set | 1 | 1 | high | one extra toggle call in code-behind |
| [KTR4-29](https://linear.app/jhkelly/issue/KTR4-29) | Layout Point Export: Data Filter drops hidden saved points on save | 2 | 2 | medium | change point source in one ViewModel, needs Revit check |
| [KTR4-30](https://linear.app/jhkelly/issue/KTR4-30) | Layout Point Import: Specify Level always fails | 1 | 1 | high | one binding fix in XAML |
| [KTR4-31](https://linear.app/jhkelly/issue/KTR4-31) | Spool Manager: partial changes committed when an edit throws | 4 | 4 | medium | wrap 11 operations with rollback and reporting in one ViewModel |
| [KTR4-32](https://linear.app/jhkelly/issue/KTR4-32) | Layout Point Export: Export saves hosts before quality check and dialog | 4 | 4 | medium | reorder save, check and dialog flow in a large ViewModel |
| [KTR4-33](https://linear.app/jhkelly/issue/KTR4-33) | Layout Point Export: save with no valid points shows exception prompt | 2 | 2 | high | guard reselect in one ViewModel |
| [KTR4-34](https://linear.app/jhkelly/issue/KTR4-34) | Layout Point Export: Exported and Not Valid filters cannot match | 2 | 2 | high | fix member names and count in code-behind |
| [KTR4-35](https://linear.app/jhkelly/issue/KTR4-35) | Layout Point Export: tool will not open without hangers or points | 2 | 2 | high | relax ValidateRequirements in one ViewModel |
| [KTR4-36](https://linear.app/jhkelly/issue/KTR4-36) | Layout Point Import: missing point families cause NullReferenceException | 2 | 2 | high | null-skip in family lookups in one ViewModel |
| [KTR4-37](https://linear.app/jhkelly/issue/KTR4-37) | Olet Check: Re-Connect and Select use the wrong project | 4 | 4 | medium | handler, command and dialog document lifetime across several types |
| [KTR4-38](https://linear.app/jhkelly/issue/KTR4-38) | Point to Pipe: typed or pasted Point File path is ignored | 2 | 2 | high | read picker path on OK in one view |
| [KTR4-39](https://linear.app/jhkelly/issue/KTR4-39) | Point to Pipe: units boxes always start at Inches and Feet | 2 | 2 | medium | initialize settings fallback in view/settings |
| [KTR4-40](https://linear.app/jhkelly/issue/KTR4-40) | Spool Manager: Welds tab Update buttons show Error Reading Object | 2 | 2 | medium | CommandParameter change plus STK shop rule follow-up |
| [KTR4-41](https://linear.app/jhkelly/issue/KTR4-41) | Spool Manager: will not open without a 'Spool - ' title block | 2 | 2 | high | drop check and disable one command in one ViewModel |
| [KTR4-42](https://linear.app/jhkelly/issue/KTR4-42) | Suspended Support Manager: Override Size Set skips family supports | 2 | 2 | high | restrict tag reset and size write in one ViewModel |
| [KTR4-43](https://linear.app/jhkelly/issue/KTR4-43) | Suspended Support Manager: Tagging Set tags un-hosted hangers | 1 | 1 | high | change one skip condition |
| [KTR4-44](https://linear.app/jhkelly/issue/KTR4-44) | Layout Point Export: save clears the Revit selection | 2 | 2 | medium | selection sync changes in one ViewModel |
| [KTR4-45](https://linear.app/jhkelly/issue/KTR4-45) | Layout Point Export: export window stays always on top | 1 | 1 | high | remove one Topmost assignment |
| [KTR4-46](https://linear.app/jhkelly/issue/KTR4-46) | Layout Point Export: quality dialog shows placeholder text | 1 | 1 | high | fill dialog text in one method |
| [KTR4-47](https://linear.app/jhkelly/issue/KTR4-47) | Level Correct: fails on a selection with a category-less element | 1 | 1 | high | null-conditional in one filter |
| [KTR4-48](https://linear.app/jhkelly/issue/KTR4-48) | Level Correct: empty model selection shows a raw Revit error | 1 | 1 | high | empty-selection message in one command |
| [KTR4-49](https://linear.app/jhkelly/issue/KTR4-49) | Line Number selector: Add Context Value check box label is wrong | 1 | 1 | high | label text change |
| [KTR4-50](https://linear.app/jhkelly/issue/KTR4-50) | Module Creator: Last Module shows AB-MOD-5 without padding | 4 | 2 | medium | D3 padding fix in settings/ModuleNumber, two small types |
| [KTR4-51](https://linear.app/jhkelly/issue/KTR4-51) | Module Creator: DEFAULT prefix offered in projects with no modules | 2 | 2 | high | filter placeholder in one ViewModel |
| [KTR4-52](https://linear.app/jhkelly/issue/KTR4-52) | Module Manager: grid shows unsaved item numbers as written | 2 | 2 | high | keep and restore old values in one ViewModel |
| [KTR4-53](https://linear.app/jhkelly/issue/KTR4-53) | Olet Check: Select links keep stale enabled state | 1 | 1 | high | invalidate two commands in one method |
| [KTR4-54](https://linear.app/jhkelly/issue/KTR4-54) | Olet Check: dialog collects olets twice on open | 1 | 1 | high | drop one call in constructor |
| [KTR4-55](https://linear.app/jhkelly/issue/KTR4-55) | Racker: cancel ends as Failed instead of Cancelled | 1 | 1 | high | one return value in one command |
| [KTR4-56](https://linear.app/jhkelly/issue/KTR4-56) | Racker: will not open on Straights items with no level | 2 | 2 | high | null guard and listing in one ViewModel |
| [KTR4-57](https://linear.app/jhkelly/issue/KTR4-57) | Spool Creator: line-number spool count matches name prefixes too loosely | 2 | 2 | high | tighten one count filter in one ViewModel |
| [KTR4-58](https://linear.app/jhkelly/issue/KTR4-58) | Spool Creator: one Create is three separate Undo steps | 2 | 2 | high | one transaction group in one ViewModel |
| [KTR4-59](https://linear.app/jhkelly/issue/KTR4-59) | Spool Manager: grids keep new values after a rolled-back edit | 2 | 2 | high | IsCommitted check and reload in one ViewModel |
| [KTR4-60](https://linear.app/jhkelly/issue/KTR4-60) | Suspended Support Manager: Set Extensions on unattached hangers does nothing | 2 | 2 | high | skip and report in one model type |
| [KTR4-61](https://linear.app/jhkelly/issue/KTR4-61) | Suspended Support Manager: field trim stored in inches, not feet | 1 | 1 | high | assign the feet variable, one line |
| [KTR4-62](https://linear.app/jhkelly/issue/KTR4-62) | Windows Mockup: product-code list blank after scope change | 1 | 1 | high | refill existing collection in one ViewModel |
| [KTR4-66](https://linear.app/jhkelly/issue/KTR4-66) | Assigner combo boxes: one base class for the six, ComboBoxExtensions as a helper | 4 | 4 | high | base class for six types plus helper |
| [KTR4-67](https://linear.app/jhkelly/issue/KTR4-67) | Assigner view-filter commands: share their common code | 2 | 4 | medium | base class extracted across seven command types |
| [KTR4-68](https://linear.app/jhkelly/issue/KTR4-68) | Vicious commands, Arranger, Spool Sheet Open: scope collector and refactor notes | 4 | 8 | medium | new shared scope collector plus refactor of six-plus commands is a sweep |
| [KTR4-69](https://linear.app/jhkelly/issue/KTR4-69) | Layout Point, Spool Manager, Support Manager, Weld Location, Duct and User Report notes | 4 | 4 | medium | 17 notes across seven tools |
| [KTR4-70](https://linear.app/jhkelly/issue/KTR4-70) | Updater element services: resolve the "Implement Data Point" notes, merge the Service pair | 4 | 4 | medium | 13 services plus a merge of two |
| [KTR4-71](https://linear.app/jhkelly/issue/KTR4-71) | Spool and support models: the 14 notes | 4 | 4 | medium | 14 notes across five model types |
| [KTR4-72](https://linear.app/jhkelly/issue/KTR4-72) | Caches, material tools, sessions, error model, size model: the 14 notes | 2 | 2 | medium | 14 small notes across several types; could be 4 |
| [KTR4-73](https://linear.app/jhkelly/issue/KTR4-73) | ElementExtensions: call the Logic copies and delete the add-in's four | 1 | 1 | medium | repoint callers in about 7 files and delete four members |

## KTRL4

| Key | Title | Current | Proposed | Confidence | Reason |
|---|---|---|---|---|---|
| [KTRL4-1](https://linear.app/jhkelly/issue/KTRL4-1) | Are there any TODO notes that can be handled? | 4 | 4 | medium | 11 notes in Kelly-Revit-Logic-v4, package needed |
| [KTRL4-2](https://linear.app/jhkelly/issue/KTRL4-2) | ElementExtensions: add GetLengthInFeet, GetNominalSize, GetWeight, ResetValuesTransaction | 2 | 2 | high | add four members to one type and pack |

## KW3

| Key | Title | Current | Proposed | Confidence | Reason |
|---|---|---|---|---|---|
| [KW3-1](https://linear.app/jhkelly/issue/KW3-1) | Repoint the layers above to the helpers moved down in round 2 (#2 to #18) |  | skip (parent) | high | parent of KTR5-4721 |
| [KW3-2](https://linear.app/jhkelly/issue/KW3-2) | SpreadsheetColumns.FirstLetterToNumber reads only the first letter | 2 | 2 | high | decision plus one-method change in SpreadsheetColumns and its pinned test |
| [KW3-4](https://linear.app/jhkelly/issue/KW3-4) | Improve the progress bar service (`ProgressReporter`, `Kelly.Windows.Wpf`) | 4 | 4 | low | title only; 5 types in one repo, used by 13 Logic files |
| [KW3-5](https://linear.app/jhkelly/issue/KW3-5) | ServiceProvider.GetService returns arbitrary instance on duplicate concrete types | 2 | 2 | high | one type (ServiceProvider) and its tests |
| [KW3-7](https://linear.app/jhkelly/issue/KW3-7) | Change Point3 to a struct | 8 | 8 | medium | Point3 used in 24 Kelly-Domain and 3 Logic-v5 files; pack and repin up the stack |
| [KW3-8](https://linear.app/jhkelly/issue/KW3-8) | Are there any TODO notes that can be handled? | 1 | 1 | high | one stale "move to Kelly.Windows" TODO in StringExtensions.cs |
| [KW3-10](https://linear.app/jhkelly/issue/KW3-10) | ConvertFractionToDecimalFeet should use the guarded parse of TryParseDecimalFeet | 2 | 2 | high | one method in ConstructionServices reusing an existing guarded parse, with tests |
| [KW3-11](https://linear.app/jhkelly/issue/KW3-11) | Decide whether TryParseDecimalFeet should stay lenient | 2 | 2 | medium | decision plus one method and its pinned test |
| [KW3-13](https://linear.app/jhkelly/issue/KW3-13) | Flake and brittleness risks in the test wave | 2 | 2 | high | two test fixtures to loosen |
| [KW3-15](https://linear.app/jhkelly/issue/KW3-15) | `ShellTools`, `ClipboardTools`, `UserPrincipalExtensions`: add seams and tests | 4 | 4 | high | three types each need a seam plus tests in one repo |

## KW2

| Key | Title | Current | Proposed | Confidence | Reason |
|---|---|---|---|---|---|
| [KW2-1](https://linear.app/jhkelly/issue/KW2-1) | Are there any TODO notes that can be handled? | 1 | 1 | high | two stale TODOs in one StringExtensions.cs |

## KWD3

| Key | Title | Current | Proposed | Confidence | Reason |
|---|---|---|---|---|---|
| [KWD3-2](https://linear.app/jhkelly/issue/KWD3-2) | Rename `JsonFileLoadException`, the declared failure for every format, CSV included | 8 | 8 | medium | referenced in KWD3, Json, Csv, Domain, Logic-v5 and UI; pack and repin each |
| [KWD3-7](https://linear.app/jhkelly/issue/KWD3-7) | Decide `ICache`'s fate (`src/Caching/ICache.cs`) | 4 | 4 | medium | used in Windows-v3, Domain and Logic-v5, so moving or deleting it crosses layers |
| [KWD3-10](https://linear.app/jhkelly/issue/KWD3-10) | Align the tests csproj configuration fallback with src | 1 | 1 | high | one property line in tests/Data.Tests.csproj |

## KD

| Key | Title | Current | Proposed | Confidence | Reason |
|---|---|---|---|---|---|
| [KD-1](https://linear.app/jhkelly/issue/KD-1) | Layout Point Export selection label miscounts and has a stray parenthesis | 1 | 1 | high | one method and its two pinned tests |
| [KD-2](https://linear.app/jhkelly/issue/KD-2) | Layout Point Export dialog shows placeholder footer and expanded text | 1 | 1 | high | two text constants and their pinned test |
| [KD-3](https://linear.app/jhkelly/issue/KD-3) | Layout point export and save length guards disagree | 2 | 2 | high | align two guard methods and their tests |
| [KD-4](https://linear.app/jhkelly/issue/KD-4) | Hanger placement repeat fallback differs from the settings default | 1 | 1 | high | one constant and its pinned test, after a decision |
| [KD-5](https://linear.app/jhkelly/issue/KD-5) | Do-not-number item number differs between the spool models | 2 | 2 | medium | decision, then one caller changed in the layers above |
| [KD-6](https://linear.app/jhkelly/issue/KD-6) | JHK parameter name prefix checks compare differently | 4 | 4 | medium | three Logic-v5 sites move to DefinitionNames.IsKellyName, with in-Revit tests |
| [KD-7](https://linear.app/jhkelly/issue/KD-7) | Two signature rules for services and systems | 2 | 2 | medium | decision plus SignatureTools/ColoredSignatureTools and their pinned tests |
| [KD-8](https://linear.app/jhkelly/issue/KD-8) | Point To Pipe settings reader stays open on an error | 2 | 2 | high | two fixes in one type with pinned tests |
| [KD-9](https://linear.app/jhkelly/issue/KD-9) | Proposed Custom Data report does not quote its values | 1 | 1 | high | one method and its pinned test |
| [KD-21](https://linear.app/jhkelly/issue/KD-21) | Layout point text is culture-sensitive and cannot round-trip | 2 | 2 | medium | invariant write and parse in two types; culture fixes deferred (US-only) |
| [KD-22](https://linear.app/jhkelly/issue/KD-22) | Legacy layout point names that are not IDs decode to Empty without a report | 4 | 4 | low | report or migration design not settled |
| [KD-23](https://linear.app/jhkelly/issue/KD-23) | default(LayoutPoint).IsValid throws NRE and LayoutPoint is mutable | 4 | 4 | medium | making the struct immutable reaches 5 Logic-v5 files |
| [KD-24](https://linear.app/jhkelly/issue/KD-24) | ModuleNumber.GetNextSequence proposes 0 for a too-large sequence | 1 | 1 | high | one method with a pinned test |
| [KD-25](https://linear.app/jhkelly/issue/KD-25) | ModuleNumber.GetNextSequence wraps to int.MinValue after int.MaxValue | 1 | 1 | high | one checked addition plus a pinned test |
| [KD-26](https://linear.app/jhkelly/issue/KD-26) | SpoolNumber.GetNextSequence wraps to int.MinValue after int.MaxValue | 1 | 1 | high | one checked addition plus pinned tests |
| [KD-27](https://linear.app/jhkelly/issue/KD-27) | SpoolNumber.GetNextSequence matches names on their start, not on split parts | 2 | 2 | high | one method reusing TrySplitName, with tests |
| [KD-30](https://linear.app/jhkelly/issue/KD-30) | Are there any TODO notes that can be handled? | 4 | 4 | medium | 11 TODOs, 9 of them BearerTypeTools sizes to check against real parts |
| [KD-33](https://linear.app/jhkelly/issue/KD-33) | Tests pin display-only enums and property counts | 2 | 2 | high | two test fixtures |
| [KD-35](https://linear.app/jhkelly/issue/KD-35) | LayoutPointIdTests verification dates use the wrong date format | 1 | 1 | high | text fix in one test file |
| [KD-37](https://linear.app/jhkelly/issue/KD-37) | `SupportTagNumbering.NextTag`: find identical supports with an `IEqualityComparer<T>` | 2 | 2 | high | one overload in one type with tests |
| [KD-38](https://linear.app/jhkelly/issue/KD-38) | Pipe offset geometry: points for lateral, vertical and rolling offsets | 4 | 4 | medium | new Revit-free calculation, several types and tests in one repo |

## HASA (text only)

| Key | Title | Current | Proposed | Confidence | Reason |
|---|---|---|---|---|---|
| [HASA-9](https://linear.app/jhkelly/issue/HASA-9) | Build native SwiftUI apps for Mac, iPhone and iPad |  | skip (parent) | high | parent with open sub-issues |
| [HASA-51](https://linear.app/jhkelly/issue/HASA-51) | Import nouns and components from a Markdown list | 4 | 4 | medium | parser plus import into tree, one feature |
| [HASA-52](https://linear.app/jhkelly/issue/HASA-52) | Export tasks to other task apps (Todoist, TickTick, …) | 8 | 8 | low | several export targets, open design; split if API sync |
| [HASA-53](https://linear.app/jhkelly/issue/HASA-53) | Task dependencies (waiting on / blocking) | 8 | 8 | medium | new relation in database plus behavior in all apps |
| [HASA-54](https://linear.app/jhkelly/issue/HASA-54) | Find and replace, in a selection or everywhere | 8 | 8 | medium | many fields, selection scope, all apps |
| [HASA-59](https://linear.app/jhkelly/issue/HASA-59) | Speed improvements (top priority) |  | skip (parent) | high | parent with open sub-issues |
| [HASA-62](https://linear.app/jhkelly/issue/HASA-62) | A parallel web app built with .NET Blazor |  | skip (parent) | high | parent with open sub-issues |
| [HASA-63](https://linear.app/jhkelly/issue/HASA-63) | Print any view | 4 | 8 | medium | print layouts on web plus native Print on Mac and iOS, several views |
| [HASA-64](https://linear.app/jhkelly/issue/HASA-64) | Settings panel, starting with locale | 8 | 8 | medium | new per-user settings table plus panel in every app |
| [HASA-65](https://linear.app/jhkelly/issue/HASA-65) | Fill in Made by and Model from a noun's name | 4 | 4 | low | parsing rules plus suggestion UI, design open |
| [HASA-67](https://linear.app/jhkelly/issue/HASA-67) | Proper app icons based on "has a" | 2 | 2 | medium | design plus asset sets per platform |
| [HASA-68](https://linear.app/jhkelly/issue/HASA-68) | Open a new noun right after creating it | 2 | 2 | medium | select and expand after add in each app |
| [HASA-69](https://linear.app/jhkelly/issue/HASA-69) | Add makers on the Makers page |  | skip (parent) | high | parent with open sub-issues |
| [HASA-70](https://linear.app/jhkelly/issue/HASA-70) | Benchmark each app | 4 | 4 | medium | shared web speed meter plus native timing |
| [HASA-71](https://linear.app/jhkelly/issue/HASA-71) | Other ways to view the data: mind map, area → noun → task, task → noun → area |  | skip (parent) | high | parent with open sub-issues |
| [HASA-72](https://linear.app/jhkelly/issue/HASA-72) | Kits: groups of nouns, such as a workstation | 8 | 8 | low | new data model and UI, design undecided |
| [HASA-74](https://linear.app/jhkelly/issue/HASA-74) | Group makers by first letter on the Makers page | 2 | 2 | medium | small grouping change per app |
| [HASA-76](https://linear.app/jhkelly/issue/HASA-76) | Copy tasks and paste them on another noun | 4 | 8 | medium | new feature across database and every app |
| [HASA-77](https://linear.app/jhkelly/issue/HASA-77) | Duplicate a noun with its components and tasks | 4 | 8 | medium | tree-copy database function plus command in every app |
| [HASA-78](https://linear.app/jhkelly/issue/HASA-78) | Keyboard shortcuts to add a noun, area or task | 2 | 2 | medium | small shortcut wiring per app |
| [HASA-79](https://linear.app/jhkelly/issue/HASA-79) | Tags, with a hierarchy | 8 | 8 | low | new hierarchical schema plus UI in all apps; may need 16 and a split |
| [HASA-82](https://linear.app/jhkelly/issue/HASA-82) | Sidebar: Makers and Archived at the bottom, above the account section | 2 | 2 | medium | move two sidebar items in each app |
| [HASA-83](https://linear.app/jhkelly/issue/HASA-83) | Export a noun as a formatted Markdown file | 4 | 4 | medium | one feature end to end, formatting nested data |
| [HASA-84](https://linear.app/jhkelly/issue/HASA-84) | Click an area's header to expand or collapse it | 2 | 2 | medium | small click-handler change per app |

## HASADB (text only)

| Key | Title | Current | Proposed | Confidence | Reason |
|---|---|---|---|---|---|
| [HASADB-15](https://linear.app/jhkelly/issue/HASADB-15) | Add the production web address to Supabase auth URLs | 1 | 1 | high | user settings step |
| [HASADB-16](https://linear.app/jhkelly/issue/HASADB-16) | Sign in with Apple | 4 | 4 | medium | Supabase provider, capability and buttons across apps |
| [HASADB-19](https://linear.app/jhkelly/issue/HASADB-19) | Idea: sign in with a 6-digit email code as well as the link | 2 | 4 | medium | email template plus code entry on web and SwiftUI apps |

## HASAWB (text only)

| Key | Title | Current | Proposed | Confidence | Reason |
|---|---|---|---|---|---|
| [HASAWB-14](https://linear.app/jhkelly/issue/HASAWB-14) | Host the Blazor app on everleap.com |  | skip (parent) | high | parent with open sub-issues |
| [HASAWB-15](https://linear.app/jhkelly/issue/HASAWB-15) | Compare Blazor and React: measure and write up | 4 | 4 | medium | measure both apps and write recommendation |
| [HASAWB-19](https://linear.app/jhkelly/issue/HASAWB-19) | Blazor: add makers on the Makers page | 1 | 1 | high | one box reusing MakerNamedAsync |
| [HASAWB-25](https://linear.app/jhkelly/issue/HASAWB-25) | User step: set up the Everleap site and enable WebSockets | 1 | 1 | high | user control-panel step |
| [HASAWB-26](https://linear.app/jhkelly/issue/HASAWB-26) | User step: upload blazor/publish to Everleap over FTP | 1 | 1 | high | user upload step |
| [HASAWB-27](https://linear.app/jhkelly/issue/HASAWB-27) | User step: add the Everleap address to Supabase Redirect URLs and test sign-in | 1 | 1 | high | user settings step |
| [HASAWB-32](https://linear.app/jhkelly/issue/HASAWB-32) | Speed (Blazor): start-up from the last loaded workspace | 1 | 1 | high | already built, only verification left |
| [HASAWB-33](https://linear.app/jhkelly/issue/HASAWB-33) | Blazor: outline view area → noun → task | 4 | 4 | medium | new page with multi-level expand/collapse |
| [HASAWB-34](https://linear.app/jhkelly/issue/HASAWB-34) | Blazor: task view grouped by noun and area | 2 | 2 | high | one read-only page reusing task row |
| [HASAWB-35](https://linear.app/jhkelly/issue/HASAWB-35) | Blazor: mind map view of areas, nouns and components | 4 | 4 | medium | new page plus JS interop or SVG diagram |
| [HASAWB-36](https://linear.app/jhkelly/issue/HASAWB-36) | Blazor parity check against the React app | 2 | 2 | medium | review screens and file gap issues, no code |

## HASAW (text only)

| Key | Title | Current | Proposed | Confidence | Reason |
|---|---|---|---|---|---|
| [HASAW-6](https://linear.app/jhkelly/issue/HASAW-6) | Touch support for moving nouns (iPad/iPhone web) | 4 | 4 | medium | add touch drag library or Move-to picker |
| [HASAW-21](https://linear.app/jhkelly/issue/HASAW-21) | Deploy the web app to a hosting service | 1 | 1 | high | connect repo and set env vars |
| [HASAW-22](https://linear.app/jhkelly/issue/HASAW-22) | Connect a custom domain to the hosted web app | 1 | 1 | high | DNS and auth URL settings |
| [HASAW-34](https://linear.app/jhkelly/issue/HASAW-34) | Web: add makers on the Makers page | 1 | 1 | high | one box reusing maker_named |
| [HASAW-43](https://linear.app/jhkelly/issue/HASAW-43) | Web: outline view area → noun → task | 4 | 4 | medium | new view and menu entry with expand/collapse |
| [HASAW-44](https://linear.app/jhkelly/issue/HASAW-44) | Web: task view grouped by noun and area | 2 | 2 | high | one read-only view reusing task row |
| [HASAW-45](https://linear.app/jhkelly/issue/HASAW-45) | Web: mind map view of areas, nouns and components | 4 | 4 | medium | new view plus a diagram library |

## HASAO (text only)

| Key | Title | Current | Proposed | Confidence | Reason |
|---|---|---|---|---|---|
| [HASAO-11](https://linear.app/jhkelly/issue/HASAO-11) | Native drag and drop to nest and reorder nouns | 4 | 4 | medium | one feature end to end in sidebar |
| [HASAO-17](https://linear.app/jhkelly/issue/HASAO-17) | Sign and notarize the Mac app; store sessions in Keychain | 2 | 2 | high | config change plus notarize/export |
| [HASAO-27](https://linear.app/jhkelly/issue/HASAO-27) | Bug: sign-in link errors aren't shown when Hasa opens from Safari | 1 | 1 | high | one small alert timing fix |
| [HASAO-36](https://linear.app/jhkelly/issue/HASAO-36) | Mac, iPhone & iPad: add makers on the Makers page | 1 | 1 | high | one field reusing maker_named |
| [HASAO-37](https://linear.app/jhkelly/issue/HASAO-37) | Bug: a component's right-click menu can change its area | 1 | 1 | high | hide one menu item for components |

## HASAI (text only)

| Key | Title | Current | Proposed | Confidence | Reason |
|---|---|---|---|---|---|
| [HASAI-4](https://linear.app/jhkelly/issue/HASAI-4) | Join the Apple Developer Program | 1 | 1 | high | user enrollment step |
| [HASAI-5](https://linear.app/jhkelly/issue/HASAI-5) | Install and test on a real iPhone | 2 | 2 | high | signing, install and manual checks |
| [HASAI-6](https://linear.app/jhkelly/issue/HASAI-6) | Publish a TestFlight build | 2 | 2 | high | App Store Connect record, icon, upload |
| [HASAI-11](https://linear.app/jhkelly/issue/HASAI-11) | Drag nouns to nest and reorder on iPhone and iPad | 4 | 4 | medium | touch drag design in shared SwiftUI using move_noun |
| [HASAI-13](https://linear.app/jhkelly/issue/HASAI-13) | Bug: Select mode shows selection circles on Today, Upcoming and Makers | 1 | 1 | high | one small fix in sidebar rows |

## Low confidence

- [KTR5-3142](https://linear.app/jhkelly/issue/KTR5-3142) Auto Updaters: they sometimes stop working during a session (4): cause unknown, needs in-Revit investigation
- [KTR5-3680](https://linear.app/jhkelly/issue/KTR5-3680) Suspended Support Manager: trapeze too wide (needs investigation) (2): the problem is not recorded, reproduce first
- [KTR5-3785](https://linear.app/jhkelly/issue/KTR5-3785) Vicious Fabrication Hanger Place: also place family-based hangers (4): open question on families
- [KTR5-4042](https://linear.app/jhkelly/issue/KTR5-4042) Vicious Straights Racker: one fabrication duct shape's size can't be read (reproduce first) (1): the shape is not known
- [KTR5-4174](https://linear.app/jhkelly/issue/KTR5-4174) Welds: write the joined parts' material type and wall thickness to the weld (4): open questions on the target parameters
- [KTR5-4448](https://linear.app/jhkelly/issue/KTR5-4448) Vicious Straights Racker: inaccurate move aligning top of pipe to a trapeze bottom (reproduce first) (2): reproduce first
- [KTR5-4518](https://linear.app/jhkelly/issue/KTR5-4518) Delete - Dead Code From Kelly.Revit (1): no description, deleting dead code
- [KTR5-4519](https://linear.app/jhkelly/issue/KTR5-4519) Delete - Dead Code From Kelly.REvit.Logic (1): no description, a lower layer may need packing
- [KTR5-4520](https://linear.app/jhkelly/issue/KTR5-4520) Delete - Dead Code From Kelly.Windows (1): no description, a lower layer may need packing
- [KTR5-4521](https://linear.app/jhkelly/issue/KTR5-4521) Delete - Dead Code From Kelly.Windows.Data (1): no description, a lower layer may need packing
- [KTR5-4581](https://linear.app/jhkelly/issue/KTR5-4581) Tool to recover OperationService logs (.json, .jsonl) (8): new tool, title only
- [KTR5-4582](https://linear.app/jhkelly/issue/KTR5-4582) Refactor the application services if needed (4): scope undefined
- [KTR5-4597](https://linear.app/jhkelly/issue/KTR5-4597) Is there any other file data I/O that Kelly.Windows.Data.* can handle? (2): analysis question
- [KTR5-4608](https://linear.app/jhkelly/issue/KTR5-4608) Detailer (2): title only: one InstallShield install type
- [KTR5-4609](https://linear.app/jhkelly/issue/KTR5-4609) Manager (2): title only: one InstallShield install type
- [KTR5-4610](https://linear.app/jhkelly/issue/KTR5-4610) Contenter (2): title only: one InstallShield install type
- [KTRUI-1](https://linear.app/jhkelly/issue/KTRUI-1) Review the Kelly-Revit-UI controls for improvements (4): open-ended review of ~5 XAML controls in src/Controls
- [KW3-4](https://linear.app/jhkelly/issue/KW3-4) Improve the progress bar service (`ProgressReporter`, `Kelly.Windows.Wpf`) (4): title only; 5 types in one repo, used by 13 Logic files
- [KD-22](https://linear.app/jhkelly/issue/KD-22) Legacy layout point names that are not IDs decode to Empty without a report (4): report or migration design not settled
- [HASA-52](https://linear.app/jhkelly/issue/HASA-52) Export tasks to other task apps (Todoist, TickTick, …) (8): several export targets, open design; split if API sync
- [HASA-65](https://linear.app/jhkelly/issue/HASA-65) Fill in Made by and Model from a noun's name (4): parsing rules plus suggestion UI, design open
- [HASA-72](https://linear.app/jhkelly/issue/HASA-72) Kits: groups of nouns, such as a workstation (8): new data model and UI, design undecided
- [HASA-79](https://linear.app/jhkelly/issue/HASA-79) Tags, with a hierarchy (8): new hierarchical schema plus UI in all apps; may need 16 and a split

## Proposed at 16 (split)

None.
