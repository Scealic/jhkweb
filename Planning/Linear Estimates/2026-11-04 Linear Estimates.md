# Linear Estimates 2026-11-04

Proposed by the `linear-issue-estimate-update` skill for every open issue (backlog, todo, in progress, triage) of every team in the "jhkelly" workspace. Nothing is set in Linear until approved.

Scale: KTR5 uses the exponential scale (1, 2, 4, 8, 16). No other team has any estimate set yet, so their scale is unknown; every proposal uses the exponential scale. Linear refuses a value a team's settings don't allow (or estimates turned off): those are reported, not retried.

## Summary

| Team | Open | New | Changed | Unchanged | Skipped (parents) | Points proposed | Text only |
|---|---|---|---|---|---|---|---|
| KTR5 | 175 | 95 | 10 | 62 | 8 | 737 | 0 |
| KTRUI | 3 | 3 | 0 | 0 | 0 | 9 | 0 |
| KTRL5 | 8 | 7 | 0 | 0 | 1 | 70 | 0 |
| KTR4 | 42 | 41 | 0 | 0 | 1 | 110 | 0 |
| KTRL4 | 1 | 1 | 0 | 0 | 0 | 4 | 0 |
| KW3 | 10 | 10 | 0 | 0 | 0 | 47 | 0 |
| KW2 | 1 | 1 | 0 | 0 | 0 | 1 | 0 |
| KWD3 | 4 | 4 | 0 | 0 | 0 | 21 | 0 |
| KD | 20 | 20 | 0 | 0 | 0 | 39 | 0 |
| HASA | 24 | 21 | 0 | 0 | 3 | 120 | 21 |
| HASADB | 3 | 3 | 0 | 0 | 0 | 7 | 3 |
| HASAW | 4 | 4 | 0 | 0 | 0 | 7 | 4 |
| HASAO | 5 | 5 | 0 | 0 | 0 | 9 | 5 |
| HASAI | 5 | 5 | 0 | 0 | 0 | 10 | 5 |
| HASAWB | 7 | 6 | 0 | 0 | 1 | 9 | 6 |
| **Total** | 312 | 226 | 10 | 62 | 14 | 1200 | 44 |

**Applied 2026-11-04:** all 236 approved estimates set and confirmed in Linear (226 new, 10 changed; 62 unchanged and 14 parents needed no call; 0 refused). KTR5 105, KTRUI 3, KTRL5 7, KTR4 41, KTRL4 1, KW3 10, KW2 1, KWD3 4, KD 20, Hasa teams 44.

KWD2, KWDC, KWDJ, KWDSS and KWDSL have no issues.

## Changes to existing estimates

| Key | Title | Current | Proposed | Reason |
|---|---|---|---|---|
| [KTR5-3911](https://linear.app/jhkelly/issue/KTR5-3911) | Trapeze placement: extend the rods to the structure automatically | 2 | 4 | shared extend logic called from Hanger tool and Suspended Support Manager, in-Revit test |
| [KTR5-4040](https://linear.app/jhkelly/issue/KTR5-4040) | Arrange Instance Align Move: limit the categories it can move | 1 | 2 | selection filter plus command check plus skip report, open question on categories |
| [KTR5-4024](https://linear.app/jhkelly/issue/KTR5-4024) | Assigners: one button resets every assigner | 16 | 4 | one push button reusing the per-assigner reset logic |
| [KTR5-4064](https://linear.app/jhkelly/issue/KTR5-4064) | Assigners: refuse to turn on an auto-assigner while its value is the default | 1 | 2 | one shared check across four assigners with message and tests |
| [KTR5-3831](https://linear.app/jhkelly/issue/KTR5-3831) | Debounce XAML EventToCommand calls | 16 | 8 | one shared debounce behavior in Kelly-Revit-UI applied over about 10 views |
| [KTR5-3142](https://linear.app/jhkelly/issue/KTR5-3142) | Fix - Sometimes the Auto Updaters stop working during the course of working on a project. | 2 | 4 | intermittent updater failure needs investigation in Revit |
| [KTR5-4110](https://linear.app/jhkelly/issue/KTR5-4110) | Delete - Objects Comparer Dependency Throughout Solution | 4 | 2 | only Kelly-Windows-v3 ComparerTools and one test use it |
| [KTR5-4496](https://linear.app/jhkelly/issue/KTR5-4496) | Change - Family Version Tool is failing when a family has a nested .rfa with Version SP's | 2 | 4 | nested family handling needs in-Revit family test |
| [KTR5-4493](https://linear.app/jhkelly/issue/KTR5-4493) | Add - Implement Nice3point revit-skills | 8 | 2 | adopt agent skills into .claude, no product code |
| [KTR5-4322](https://linear.app/jhkelly/issue/KTR5-4322) | Fix - Combine ALL Identical Event Bindings In Event To Command Blocks in ALL XAML Views | 16 | 8 | about 96 EventBindings in 10 XAML views, one sweep |

## KTR5

| Key | Title | Current | Proposed | Confidence | Reason |
|---|---|---|---|---|---|
| [KTR5-4694](https://linear.app/jhkelly/issue/KTR5-4694) | Run the tooltip and icon commits inside Revit |  | 2 | medium | run Tests.Revit and spot-check ribbon, no code expected |
| [KTR5-4693](https://linear.app/jhkelly/issue/KTR5-4693) | Final test: KTR needs to work without connecting to a JHK network (no VPN, etc.) |  | 4 | low | end-to-end offline check of every startup path and tool, title-only |
| [KTR5-4689](https://linear.app/jhkelly/issue/KTR5-4689) | Implement the Unit Test Implementation plan for Kelly Tools For Revit |  | 16 | medium | remaining backfill: 16 UI types, 85 Kelly-Revit types, 8 fabrication Logic types; split |
| [KTR5-4685](https://linear.app/jhkelly/issue/KTR5-4685) | Rename debris and config drift |  | 2 | high | several small cleanups in config, manifest folder and App.cs |
| [KTR5-4682](https://linear.app/jhkelly/issue/KTR5-4682) | Point to Pipe: use the PointToPipeUnits constants instead of unit literals |  | 1 | high | swap literals for existing PointToPipeUnits constants at three sites |
| [KTR5-4681](https://linear.app/jhkelly/issue/KTR5-4681) | Deduplicate the SetActiveProjectLocation combo code in two ViewModels |  | 2 | high | extract duplicated combo code shared by two ViewModels |
| [KTR5-4680](https://linear.app/jhkelly/issue/KTR5-4680) | Are there any TODO notes that can be handled? |  | 8 | medium | sweep over 54 TODOs in this repo (113 in v5) |
| [KTR5-4679](https://linear.app/jhkelly/issue/KTR5-4679) | Run the IA Prompt architectural analysis and cleanup |  | 16 | low | architectural analysis and cleanup; prompt file missing, scope unknown; split |
| [KTR5-4678](https://linear.app/jhkelly/issue/KTR5-4678) | Refactor and clean up the Vicious tools |  | 16 | medium | 56 Vicious files, about 11.5k lines to refactor; split |
| [KTR5-4668](https://linear.app/jhkelly/issue/KTR5-4668) | Windows Mockup: product-code list goes blank after a scope change |  | 1 | high | refill existing collection instead of reassigning, one ViewModel |
| [KTR5-4667](https://linear.app/jhkelly/issue/KTR5-4667) | Suspended Support Manager: field trim stored in inches, not feet |  | 1 | high | assign the feet value, one line in SuspendedSupport |
| [KTR5-4666](https://linear.app/jhkelly/issue/KTR5-4666) | Suspended Support Manager: Set Extensions on unattached hangers extends no rod |  | 2 | high | skip unattached hangers and report count, one type |
| [KTR5-4665](https://linear.app/jhkelly/issue/KTR5-4665) | Spool Manager: grids keep new values after Revit rolls an edit back |  | 2 | high | check IsCommitted and reload spools, one ViewModel |
| [KTR5-4664](https://linear.app/jhkelly/issue/KTR5-4664) | Spool Creator: one Create is three Undo steps |  | 2 | medium | wrap three steps in one transaction group, one ViewModel |
| [KTR5-4663](https://linear.app/jhkelly/issue/KTR5-4663) | Spool Creator: SPA and SPT categories do not parse as spool numbers |  | 4 | medium | decide SPA/SPT rule; Kelly-Domain SpoolNumber change plus repin if accepted |
| [KTR5-4662](https://linear.app/jhkelly/issue/KTR5-4662) | Racker: will not open when a Straights item has no level |  | 2 | high | skip null level or elevations, one ViewModel |
| [KTR5-4661](https://linear.app/jhkelly/issue/KTR5-4661) | Racker: user cancel ends the command as Failed instead of Cancelled |  | 4 | medium | return Cancelled here and in other v5 commands with the same check (sweep) |
| [KTR5-4660](https://linear.app/jhkelly/issue/KTR5-4660) | Olet Check: opening the dialog checks the olets twice |  | 1 | high | drop the extra LoadElements call |
| [KTR5-4659](https://linear.app/jhkelly/issue/KTR5-4659) | Olet Check: Select links keep stale enabled state after a reload |  | 1 | high | invalidate two commands in RecalculateOletCounts |
| [KTR5-4658](https://linear.app/jhkelly/issue/KTR5-4658) | Module Manager: Components grid shows item numbers that were not saved |  | 2 | high | keep old numbers and restore unless commit succeeded |
| [KTR5-4657](https://linear.app/jhkelly/issue/KTR5-4657) | Module Manager: Item Numbers Update button stays disabled after BOM update |  | 2 | high | re-evaluate button after BOM update or notifying property |
| [KTR5-4656](https://linear.app/jhkelly/issue/KTR5-4656) | Module Creator: DEFAULT placeholder prefix shown in an empty project |  | 2 | high | exclude DEFAULT placeholder from Module Creator prefixes |
| [KTR5-4655](https://linear.app/jhkelly/issue/KTR5-4655) | Line Number Selector: Add Context Value check box label is run together |  | 1 | high | label text fix and width in one dialog |
| [KTR5-4654](https://linear.app/jhkelly/issue/KTR5-4654) | Level Correct: no model elements gives a raw List must contain error |  | 2 | high | show message when no model elements remain, one command |
| [KTR5-4653](https://linear.app/jhkelly/issue/KTR5-4653) | Level Correct: an element with no category throws NullReferenceException |  | 1 | high | null-safe category filter, one line, pairs with 4654 |
| [KTR5-4652](https://linear.app/jhkelly/issue/KTR5-4652) | Layout Point Export: Danger and Caution quality counts never fire |  | 8 | medium | decide Danger/Caution meaning; Logic stub and Domain test change, pack and repin |
| [KTR5-4651](https://linear.app/jhkelly/issue/KTR5-4651) | Layout Point Export: quality dialog shows placeholder text |  | 2 | high | list flagged IDs and remove placeholder footer, one ViewModel |
| [KTR5-4650](https://linear.app/jhkelly/issue/KTR5-4650) | Layout Point Export: export window stays always on top |  | 1 | high | remove Topmost assignment |
| [KTR5-4649](https://linear.app/jhkelly/issue/KTR5-4649) | Layout Point Export: save clears the Revit selection and empties the grid |  | 2 | medium | selection sync handling in one ViewModel, two sites |
| [KTR5-4648](https://linear.app/jhkelly/issue/KTR5-4648) | Suspended Support Manager: Tagging Set tags un-hosted hangers when disallowed |  | 2 | high | change the skip condition to host id, one ViewModel |
| [KTR5-4647](https://linear.app/jhkelly/issue/KTR5-4647) | Suspended Support Manager: Override Size Set clears tags without a size |  | 2 | high | limit reset to fabrication hangers, one ViewModel |
| [KTR5-4646](https://linear.app/jhkelly/issue/KTR5-4646) | Spool Manager: will not open without a Spool title block type |  | 2 | high | drop minimum check and disable Create Spool Sheets with note |
| [KTR5-4645](https://linear.app/jhkelly/issue/KTR5-4645) | Point to Pipe: units boxes always start at Inches and Feet |  | 4 | medium | default UnitsId in Kelly-Domain VtfrSettings plus repin, or load user settings |
| [KTR5-4644](https://linear.app/jhkelly/issue/KTR5-4644) | Point to Pipe: a typed or pasted Point File path is ignored |  | 2 | high | read picker FilePath on OK, one view |
| [KTR5-4643](https://linear.app/jhkelly/issue/KTR5-4643) | Olet Check: Re-Connect and Select act on the wrong project with two open |  | 4 | medium | bind dialog to its own document across handler, command and reopen per project |
| [KTR5-4642](https://linear.app/jhkelly/issue/KTR5-4642) | Layout Point Import: missing point families throw a NullReferenceException |  | 2 | high | skip null symbols in family lookups, one ViewModel |
| [KTR5-4641](https://linear.app/jhkelly/issue/KTR5-4641) | Layout Point Export: tool will not open when the plan has no hangers |  | 2 | high | relax ValidateRequirements minimums, one ViewModel |
| [KTR5-4640](https://linear.app/jhkelly/issue/KTR5-4640) | Layout Point Export: Exported and Not Valid filters name missing members |  | 2 | high | correct two filter member names and the count label |
| [KTR5-4639](https://linear.app/jhkelly/issue/KTR5-4639) | Layout Point Export: Save with no valid point shows the exception prompt |  | 2 | high | skip reselect when nothing saved, one ViewModel |
| [KTR5-4638](https://linear.app/jhkelly/issue/KTR5-4638) | Layout Point Export: cancelling the check or Save As still rewrites hosts |  | 4 | medium | reorder export flow: check and Save As before saving hosts; confirm in Revit |
| [KTR5-4637](https://linear.app/jhkelly/issue/KTR5-4637) | Spool Manager: a failed edit commits partial changes and closes the tool |  | 4 | medium | wrap 11 operations with rollback (OperationService.Run), test in Revit |
| [KTR5-4636](https://linear.app/jhkelly/issue/KTR5-4636) | Layout Point Import: Specify Level always fails with an unhandled error |  | 2 | high | fix SelectedValuePath binding and null guard |
| [KTR5-4635](https://linear.app/jhkelly/issue/KTR5-4635) | Layout Point Export: Data Filter drops hidden saved points on save |  | 2 | medium | take host points from candidates not filtered grid; confirm in Revit |
| [KTR5-4634](https://linear.app/jhkelly/issue/KTR5-4634) | Decide the status colors beside the brand palette |  | 4 | medium | decide status colors and apply across four Kelly-Windows types and OletCheck |
| [KTR5-4633](https://linear.app/jhkelly/issue/KTR5-4633) | Replace the off-palette colors in the views and panels |  | 2 | high | replace five off-palette colors once named resources exist |
| [KTR5-4632](https://linear.app/jhkelly/issue/KTR5-4632) | Add the brand colors once as named colors, brushes and resources |  | 8 | high | new palette in Kelly-Windows-v3 and resource dictionary in Kelly-Revit-UI, pack and repin |
| [KTR5-4631](https://linear.app/jhkelly/issue/KTR5-4631) | Racker: Bottom/Top align buttons overwrite the typed elevation in Manual mode |  | 1 | high | remove two event bindings in one view |
| [KTR5-4630](https://linear.app/jhkelly/issue/KTR5-4630) | Take all push button names from a names property |  | 8 | medium | 50 push buttons still use literals plus matching transaction names (sweep) |
| [KTR5-4627](https://linear.app/jhkelly/issue/KTR5-4627) | Use the other JH Kelly brand colors beside Kelly Green |  | skip (parent) | high | parent with open sub-issues 4632 to 4634 |
| [KTR5-4626](https://linear.app/jhkelly/issue/KTR5-4626) | Order the User Domain Report (Developer tab) by EmployeeId |  | 4 | medium | sort plus EmployeeId read in Kelly-Windows-v3 DomainGroupReport, pack and repin |
| [KTR5-4625](https://linear.app/jhkelly/issue/KTR5-4625) | Implement the scope control in every window that doesn't have it yet |  | 8 | medium | scope control in every remaining window via PropertyChanged (sweep) |
| [KTR5-4624](https://linear.app/jhkelly/issue/KTR5-4624) | Suspended Support Manager: show vertical members in a separate grid below |  | 4 | medium | split rod grid into a second grid with selection binding, one tool |
| [KTR5-4623](https://linear.app/jhkelly/issue/KTR5-4623) | Light-mode and dark-mode icons (use the proper green color) |  | 8 | medium | light and dark variants of every ribbon icon |
| [KTR5-4621](https://linear.app/jhkelly/issue/KTR5-4621) | Enable light and dark mode for the versions of Revit that have that feature |  | skip (parent) | high | parent with open sub-issue 4623 |
| [KTR5-4618](https://linear.app/jhkelly/issue/KTR5-4618) | Enable the ProjectInformationEditor for project shared parameters |  | 8 | medium | port the v4 ProjectInformationEditor as a new v5 tool |
| [KTR5-4610](https://linear.app/jhkelly/issue/KTR5-4610) | Contenter |  | 2 | low | title-only: one InstallShield install type |
| [KTR5-4609](https://linear.app/jhkelly/issue/KTR5-4609) | Manager |  | 2 | low | title-only: one InstallShield install type |
| [KTR5-4608](https://linear.app/jhkelly/issue/KTR5-4608) | Detailer |  | 2 | low | title-only: one InstallShield install type |
| [KTR5-4604](https://linear.app/jhkelly/issue/KTR5-4604) | Mark the SQL procedures only v5 called (step 9 of the plan) |  | 2 | medium | mark procedures in the VCS schema repo, docs-like change |
| [KTR5-4602](https://linear.app/jhkelly/issue/KTR5-4602) | Read and write the settings file with Kelly.Windows.Data.Json |  | 8 | medium | settings read/write through Kelly.Windows.Data.Json across layers |
| [KTR5-4601](https://linear.app/jhkelly/issue/KTR5-4601) | Configure the InstallShield project for different install types |  | skip (parent) | high | parent with open sub-issues 4608 to 4610 |
| [KTR5-4597](https://linear.app/jhkelly/issue/KTR5-4597) | Is there any other file data I/O that Kelly.Windows.Data.* can handle? |  | 2 | low | analysis of remaining file I/O, title-only |
| [KTR5-4596](https://linear.app/jhkelly/issue/KTR5-4596) | Implement a hierarchical application and tool settings file |  | skip (parent) | high | parent with open sub-issue 4602 |
| [KTR5-4582](https://linear.app/jhkelly/issue/KTR5-4582) | Refactor the application services if needed |  | 4 | low | title-only, conditional refactor of application services |
| [KTR5-4581](https://linear.app/jhkelly/issue/KTR5-4581) | Tool to recover OperationService logs (.json, .jsonl) |  | 8 | low | new tool to recover OperationService logs, title-only |
| [KTR5-4580](https://linear.app/jhkelly/issue/KTR5-4580) | Drop the full names left by the round 2a repin once Logic deletes its copies |  | 2 | medium | drop alias and full names in a few files after Logic repin |
| [KTR5-4253](https://linear.app/jhkelly/issue/KTR5-4253) | Change - Missing Information Notification For the Layout Point Importer | 4 | 4 | medium | validation and message in Layout Point Import, in-Revit check |
| [KTR5-2775](https://linear.app/jhkelly/issue/KTR5-2775) | Best to check for the presence of required layout point families prior to the window opening so that we can eliminate false starts. |  | 2 | medium | move the family check into the Layout Point Import command before the view opens |
| [KTR5-3808](https://linear.app/jhkelly/issue/KTR5-3808) | Ability to Select/Zoom element in view like we have in other tools [Layout Point Export Tool] | 4 | 4 | medium | reuse existing Select/Zoom controls in one tool |
| [KTR5-3809](https://linear.app/jhkelly/issue/KTR5-3809) | Show the layout point count in Scope Controls Selection/View/Project options [Layout Point Export Tools] | 4 | 4 | medium | scope count per option in one tool |
| [KTR5-3911](https://linear.app/jhkelly/issue/KTR5-3911) | Trapeze placement: extend the rods to the structure automatically | 2 | 4 | medium | shared extend logic called from Hanger tool and Suspended Support Manager, in-Revit test |
| [KTR5-4040](https://linear.app/jhkelly/issue/KTR5-4040) | Arrange Instance Align Move: limit the categories it can move | 1 | 2 | medium | selection filter plus command check plus skip report, open question on categories |
| [KTR5-3938](https://linear.app/jhkelly/issue/KTR5-3938) | Assigners: Inherit All copies a picked element's contexts into the assigners |  | 4 | medium | new pick command setting four assigner combos with reporting |
| [KTR5-4024](https://linear.app/jhkelly/issue/KTR5-4024) | Assigners: one button resets every assigner | 16 | 4 | medium | one push button reusing the per-assigner reset logic |
| [KTR5-4064](https://linear.app/jhkelly/issue/KTR5-4064) | Assigners: refuse to turn on an auto-assigner while its value is the default | 1 | 2 | medium | one shared check across four assigners with message and tests |
| [KTR5-3833](https://linear.app/jhkelly/issue/KTR5-3833) | Change the way the Scope Control works or the way View Models use it so a filter i created on the GridView or other consuming control |  | 8 | low | Kelly-Revit-UI scope control redesign affecting every consuming view model |
| [KTR5-3281](https://linear.app/jhkelly/issue/KTR5-3281) | Selection Radio Button |  | 2 | low | title only, likely one control change |
| [KTR5-3831](https://linear.app/jhkelly/issue/KTR5-3831) | Debounce XAML EventToCommand calls | 16 | 8 | medium | one shared debounce behavior in Kelly-Revit-UI applied over about 10 views |
| [KTR5-3935](https://linear.app/jhkelly/issue/KTR5-3935) | Other | 8 | 8 | low | sub-issue of new Spool Creator, no description |
| [KTR5-3934](https://linear.app/jhkelly/issue/KTR5-3934) | Testing | 8 | 8 | low | sub-issue of new Spool Creator, no description |
| [KTR5-3933](https://linear.app/jhkelly/issue/KTR5-3933) | Logic | 8 | 8 | low | sub-issue of new Spool Creator, no description |
| [KTR5-3932](https://linear.app/jhkelly/issue/KTR5-3932) | User Interface | 8 | 8 | low | sub-issue of new Spool Creator, no description |
| [KTR5-4128](https://linear.app/jhkelly/issue/KTR5-4128) | Try To Convert Hill Group VB.net to C#.net | 8 | 8 | low | no Hill Group code in the repos yet, size unknown |
| [KTR5-4127](https://linear.app/jhkelly/issue/KTR5-4127) | Create - Duct Quality Check View | 8 | 8 | low | new view for a new tool |
| [KTR5-4126](https://linear.app/jhkelly/issue/KTR5-4126) | Create - Duct Quality Check View Model | 8 | 8 | low | new view model for a new tool |
| [KTR5-4125](https://linear.app/jhkelly/issue/KTR5-4125) | Create - Duct Quality Check Model(s) | 8 | 8 | low | new models for a new tool |
| [KTR5-4124](https://linear.app/jhkelly/issue/KTR5-4124) | Create - Duct Quality Check Model(s) | 8 | 8 | low | new models for a new tool |
| [KTR5-4123](https://linear.app/jhkelly/issue/KTR5-4123) | Create - Duct Quality Check View Model | 8 | 8 | low | new view model for a new tool |
| [KTR5-4122](https://linear.app/jhkelly/issue/KTR5-4122) | Create - Duct Quality Check View | 8 | 8 | low | new view for a new tool |
| [KTR5-4121](https://linear.app/jhkelly/issue/KTR5-4121) | Try To Convert Hill Group VB.net to C#.net | 8 | 8 | low | no Hill Group code in the repos yet, size unknown |
| [KTR5-3794](https://linear.app/jhkelly/issue/KTR5-3794) | Ability to create View/Filters/Sheets when i create a Module | 4 | 4 | low | scope still under discussion |
| [KTR5-4020](https://linear.app/jhkelly/issue/KTR5-4020) | Zoom To Selection Check Box - Remove telerik:EventToCommandBehavior and refactor Views Using this control | 1 | 1 | medium | one control plus its consuming views |
| [KTR5-4019](https://linear.app/jhkelly/issue/KTR5-4019) | Select In View Check Box - Remove telerik:EventToCommandBehavior and refactor Views Using this control | 1 | 1 | medium | one control plus its consuming views |
| [KTR5-4018](https://linear.app/jhkelly/issue/KTR5-4018) | Zoom To Selection Check Box - Add Event Routing For Checked and Unchecked So Binding Can Occur Externally | 1 | 1 | medium | routed events on one control |
| [KTR5-4017](https://linear.app/jhkelly/issue/KTR5-4017) | Select In View Check Box - Add Event Routing For Checked and Unchecked So Binding Can Occur Externally | 1 | 1 | medium | routed events on one control |
| [KTR5-3680](https://linear.app/jhkelly/issue/KTR5-3680) | Trapeze Is Too Wide |  | 2 | low | title only, likely a width calculation fix in one type |
| [KTR5-3785](https://linear.app/jhkelly/issue/KTR5-3785) | Ability to place Family Instances as well as Fabrication Part Instances [Hanger Tool] | 4 | 4 | low | second placement mode in the Vicious hanger tool |
| [KTR5-3695](https://linear.app/jhkelly/issue/KTR5-3695) | Implement Unit Testing on this Tool and its dependencies |  | 4 | low | tool not named, in-Revit tests |
| [KTR5-4016](https://linear.app/jhkelly/issue/KTR5-4016) | Ability to show/hide the Detailing Package Column in all grids [Module Manager] | 1 | 1 | high | column visibility toggle in one view |
| [KTR5-4015](https://linear.app/jhkelly/issue/KTR5-4015) | Ability to show/hide the Line Number Column in all grids [Module Manager] | 1 | 1 | high | column visibility toggle in one view |
| [KTR5-4028](https://linear.app/jhkelly/issue/KTR5-4028) | Create a tool to create Detailing Package 3D View For Stratus Using A UI To enter specific data |  | 8 | medium | new tool with dialog, view creation and isolation filters |
| [KTR5-4026](https://linear.app/jhkelly/issue/KTR5-4026) | Create a tool to delete all family instances in a document (Developer Only) |  | 2 | medium | small developer command with one transaction |
| [KTR5-4085](https://linear.app/jhkelly/issue/KTR5-4085) | Develop Dockable Assigner System |  | 2 | low | AssignerDockablePanel already exists in Trade.All, verify what remains |
| [KTR5-3827](https://linear.app/jhkelly/issue/KTR5-3827) | Tool to create an offset in a pipe run so that the complex multistep manual work is eliminated |  | 16 | low | new geometry tool with three offset kinds, split |
| [KTR5-4012](https://linear.app/jhkelly/issue/KTR5-4012) | Ability To Cancel the Progress Bar Service and Underlining Process |  | 8 | medium | cancellation through the progress service and its callers across layers |
| [KTR5-4009](https://linear.app/jhkelly/issue/KTR5-4009) | Tool Idea - "Select Elements By Context" |  | 4 | medium | one command selecting by context parameter |
| [KTR5-3936](https://linear.app/jhkelly/issue/KTR5-3936) | Refactor Tools that use CSV Helper to use another export means. |  | 8 | medium | CsvHelper used in Kelly-Windows-v3, Kelly-Domain and Logic, pack and repin |
| [KTR5-4029](https://linear.app/jhkelly/issue/KTR5-4029) | Create A Tool To Create 3D Detailer Views | 8 | 8 | medium | new tool creating views with filters per package |
| [KTR5-3937](https://linear.app/jhkelly/issue/KTR5-3937) | Ask Jason/Adam if "BIM Lite" is still something we want to use |  | 1 | medium | a question for a meeting |
| [KTR5-4170](https://linear.app/jhkelly/issue/KTR5-4170) | Change - Implement IEqualityComparer<object>() Interface in place of "Signature" | 16 | 16 | medium | Signature used in over 100 files across layers |
| [KTR5-3829](https://linear.app/jhkelly/issue/KTR5-3829) | Ability to end swap connected family instances like we can with Fabrication Parts so less manual and potentially destructive work is eliminated | 4 | 4 | low | new connector logic for family instances |
| [KTR5-3142](https://linear.app/jhkelly/issue/KTR5-3142) | Fix - Sometimes the Auto Updaters stop working during the course of working on a project. | 2 | 4 | medium | intermittent updater failure needs investigation in Revit |
| [KTR5-2461](https://linear.app/jhkelly/issue/KTR5-2461) | Remove the "I" suffix from any Definition Name in our ExternalParameterDefinitions Table and Classes now that the old "Type" records have been deleted |  | 8 | low | data files, exporter and definition names across layers |
| [KTR5-4084](https://linear.app/jhkelly/issue/KTR5-4084) | Add - UI Elements to Display Remaining Time |  | 4 | medium | progress UI in Kelly-Windows, pack and repin |
| [KTR5-4083](https://linear.app/jhkelly/issue/KTR5-4083) | Add - UI Elements to Display Item Count of Total Items To |  | 4 | medium | progress UI in Kelly-Windows, pack and repin |
| [KTR5-2434](https://linear.app/jhkelly/issue/KTR5-2434) | Delete the use of extraneous Shared Parameters. |  | 4 | low | four weld parameters to remove from code and data |
| [KTR5-4110](https://linear.app/jhkelly/issue/KTR5-4110) | Delete - Objects Comparer Dependency Throughout Solution | 4 | 2 | medium | only Kelly-Windows-v3 ComparerTools and one test use it |
| [KTR5-3747](https://linear.app/jhkelly/issue/KTR5-3747) | Provide a notification to detailers if a row in any of the Spool Manager's grids are red (have an error) | 4 | 4 | medium | error summary in one tool |
| [KTR5-4004](https://linear.app/jhkelly/issue/KTR5-4004) | Refactor Local and Type "List" objects to "HashSet" objects In Service Document Cache | 1 | 1 | high | one List in ServiceDocumentCache |
| [KTR5-4003](https://linear.app/jhkelly/issue/KTR5-4003) | Refactor Local and Type "List" objects to "HashSet" objects In System Document Cache | 1 | 1 | high | few Lists in SystemDocumentCache |
| [KTR5-3704](https://linear.app/jhkelly/issue/KTR5-3704) | Convert The Telerik License to an Environment Variable From Class | 4 | 4 | medium | license load in App.cs plus build and install setup |
| [KTR5-3772](https://linear.app/jhkelly/issue/KTR5-3772) | Refactor The Export To Single XLSX Command TO Use Telerik's Exporter |  | 4 | medium | one export command rewritten with Telerik export |
| [KTR5-2967](https://linear.app/jhkelly/issue/KTR5-2967) | Global - Validation - Upgrade To Property Validation for All Tools Using IConverters |  | 8 | low | sweep over the views using IValueConverters |
| [KTR5-3793](https://linear.app/jhkelly/issue/KTR5-3793) | Refactor the Module Creator tool to remain open so i can continue to select and create modules so my workflow is uninterrupted [Module Creator] | 4 | 4 | medium | modeless window with external events in one tool |
| [KTR5-3791](https://linear.app/jhkelly/issue/KTR5-3791) | Add - Ability to change the Module Number in the tool so i don't have to exit, change and reopen the tool. [Module Manager] | 4 | 4 | medium | edit and write back in one tool |
| [KTR5-3792](https://linear.app/jhkelly/issue/KTR5-3792) | Add - Ability to change the Module Group in the tool so i don't have to exit, change and reopen the tool. [Module Manager] | 4 | 4 | medium | edit and write back in one tool |
| [KTR5-3795](https://linear.app/jhkelly/issue/KTR5-3795) | Add - Ability to update Line Number of Spool Members in a selection of spools [Spool Manager] | 4 | 4 | medium | one new edit operation in Spool Manager |
| [KTR5-3796](https://linear.app/jhkelly/issue/KTR5-3796) | Add - Ability to update Detailing Package of Spool Members in a selection of spools [Spool Manager] | 4 | 4 | medium | one new edit operation in Spool Manager |
| [KTR5-3797](https://linear.app/jhkelly/issue/KTR5-3797) | Add - Ability to update Assembly Name/Spool Number of Spool Members in a selection of spools [Spool Manager] | 4 | 4 | medium | one new edit operation in Spool Manager |
| [KTR5-3774](https://linear.app/jhkelly/issue/KTR5-3774) | Refactor The Export To Single CSV's Command TO Use Telerik's Exporter |  | 4 | medium | one export command rewritten with Telerik export |
| [KTR5-3773](https://linear.app/jhkelly/issue/KTR5-3773) | Refactor The Export To Multiple XLSX Command TO Use Telerik's Exporter |  | 4 | medium | one export command rewritten with Telerik export |
| [KTR5-4043](https://linear.app/jhkelly/issue/KTR5-4043) | Fix - Window crops some UI Elements | 1 | 1 | low | layout fix in one view, view not named |
| [KTR5-3924](https://linear.app/jhkelly/issue/KTR5-3924) | Persist the selected Detailing Package in the Combo Box so the flow isn't interrupted on subsequent creations | 4 | 4 | low | selection persistence in one tool |
| [KTR5-4042](https://linear.app/jhkelly/issue/KTR5-4042) | Fix - reading the size from Fabrication Duct - One shape of duct fails | 1 | 1 | low | one shape case in the size reader |
| [KTR5-3786](https://linear.app/jhkelly/issue/KTR5-3786) | Be notified if an elements level won't be changed so it doesn't cause problems later | 4 | 4 | medium | report unchanged elements in Level Correct |
| [KTR5-3703](https://linear.app/jhkelly/issue/KTR5-3703) | Disable the Close button until the updating is complete | 4 | 4 | medium | footer control refactor |
| [KTR5-3813](https://linear.app/jhkelly/issue/KTR5-3813) | Ability to see a success/fail list when the manual updater runs so that i can know if anything failed to update | 4 | 4 | medium | result list for the manual updater |
| [KTR5-3784](https://linear.app/jhkelly/issue/KTR5-3784) | Ability to have the window stay open so to minimize the interruption of flow state [Hanger Tool] | 4 | 4 | medium | modeless window in one tool |
| [KTR5-2958](https://linear.app/jhkelly/issue/KTR5-2958) | Module Manager to work on Sheet Metal Projects |  | 8 | low | duct and sheet metal support through Module Manager and its Logic |
| [KTR5-3144](https://linear.app/jhkelly/issue/KTR5-3144) | Assembly Creator to geometrically alter all "Family Instances" a miniscule amount so it doesn't fail the Assembly creation process. | 16 | 16 | low | Revit API workaround with uncertain approach |
| [KTR5-3278](https://linear.app/jhkelly/issue/KTR5-3278) | Must be able to process all Fabrication Support Patterns |  | 8 | low | every support pattern needs handling and fabrication content to test |
| [KTR5-3277](https://linear.app/jhkelly/issue/KTR5-3277) | Must not show true in match column if there is not match! | 1 | 1 | medium | one match flag fix |
| [KTR5-3280](https://linear.app/jhkelly/issue/KTR5-3280) | Rebuild the get/set system of rod geometry value. | 8 | 8 | medium | rod geometry access rewrite in Logic and the support tools |
| [KTR5-4063](https://linear.app/jhkelly/issue/KTR5-4063) | Add - Ability to filter by element Id Column | 1 | 1 | medium | grid column filter in one view |
| [KTR5-3279](https://linear.app/jhkelly/issue/KTR5-3279) | Needs better property validation system such as the Fluent system i implemented in the Module Manager Tool |  | 16 | low | new validation across all models, split |
| [KTR5-3800](https://linear.app/jhkelly/issue/KTR5-3800) | Create - New version of the Spool Creator that leverages the contexts in the assigner panel. | 0 | skip (parent) | high | parent of KTR5-3932 to 3935 |
| [KTR5-4119](https://linear.app/jhkelly/issue/KTR5-4119) | Add - Duct Length Optimization |  | skip (parent) | high | parent with open sub-issues |
| [KTR5-4120](https://linear.app/jhkelly/issue/KTR5-4120) | Add - Duct Quality Check Mirror |  | skip (parent) | high | parent with open sub-issues |
| [KTR5-4136](https://linear.app/jhkelly/issue/KTR5-4136) | Reinstate Operation Logging | 4 | 4 | medium | OperationService log files sent by email at document close |
| [KTR5-4177](https://linear.app/jhkelly/issue/KTR5-4177) | Add - Status Lists To Bottom Of Window (Services, DB Connections, Commands, IUPdaters, etc.) | 8 | 8 | medium | new status UI reading several services |
| [KTR5-4494](https://linear.app/jhkelly/issue/KTR5-4494) | Analysis - IUpdater Needs |  | 4 | low | analysis of about 26 updater types |
| [KTR5-4525](https://linear.app/jhkelly/issue/KTR5-4525) | Change !!! Refactor Element Service types to only be used by IUpdaters. Segregate them from IExternal Command Usage so the updaters are NEVER inadvertantly changed. !!! | 8 | 8 | medium | ElementService used in about 96 files, Logic and commands |
| [KTR5-4518](https://linear.app/jhkelly/issue/KTR5-4518) | Delete - Dead Code From Kelly.Revit | 1 | 1 | medium | dead-code deletion in one repo |
| [KTR5-4519](https://linear.app/jhkelly/issue/KTR5-4519) | Delete - Dead Code From Kelly.REvit.Logic | 1 | 1 | medium | dead-code deletion in one repo |
| [KTR5-4520](https://linear.app/jhkelly/issue/KTR5-4520) | Delete - Dead Code From Kelly.Windows | 1 | 1 | medium | dead-code deletion in one repo |
| [KTR5-4521](https://linear.app/jhkelly/issue/KTR5-4521) | Delete - Dead Code From Kelly.Windows.Data | 1 | 1 | medium | dead-code deletion in one repo |
| [KTR5-4515](https://linear.app/jhkelly/issue/KTR5-4515) | Deprecated - SQL Table "ProjectUpdatersLog" |  | 1 | medium | add to the db-deprecation scripts |
| [KTR5-4514](https://linear.app/jhkelly/issue/KTR5-4514) | Deprecated - SQL Store Procedure "USP_ProjectSession_Update" |  | 1 | high | already listed in db-deprecation 40-mark-deprecated-2027-VCS.sql |
| [KTR5-4513](https://linear.app/jhkelly/issue/KTR5-4513) | Deprecated - SQL Store Procedure "USP_ProjectSession_Insert" |  | 1 | high | already listed in db-deprecation 40-mark-deprecated-2027-VCS.sql |
| [KTR5-4510](https://linear.app/jhkelly/issue/KTR5-4510) | Deprecate - SQL Table "ProjectSession" |  | 1 | medium | add to the db-deprecation scripts |
| [KTR5-4496](https://linear.app/jhkelly/issue/KTR5-4496) | Change - Family Version Tool is failing when a family has a nested .rfa with Version SP's | 2 | 4 | medium | nested family handling needs in-Revit family test |
| [KTR5-4493](https://linear.app/jhkelly/issue/KTR5-4493) | Add - Implement Nice3point revit-skills | 8 | 2 | medium | adopt agent skills into .claude, no product code |
| [KTR5-4480](https://linear.app/jhkelly/issue/KTR5-4480) | Change - Operation/Project Bar Implenations | 16 | 16 | high | migration over about 48 OperationService sites |
| [KTR5-4448](https://linear.app/jhkelly/issue/KTR5-4448) | Fix - Didn't move accurately work when aligning the top of pipe with the bottom of a trapeze (11' 10 3/8") | 2 | 2 | low | alignment calculation fix |
| [KTR5-4322](https://linear.app/jhkelly/issue/KTR5-4322) | Fix - Combine ALL Identical Event Bindings In Event To Command Blocks in ALL XAML Views | 16 | 8 | medium | about 96 EventBindings in 10 XAML views, one sweep |
| [KTR5-4255](https://linear.app/jhkelly/issue/KTR5-4255) | Add - New Tool To Find deprecated fab parts (ITMs) that no longer match a fab part |  | 8 | low | new tool needing fabrication configuration |
| [KTR5-4256](https://linear.app/jhkelly/issue/KTR5-4256) | Add - New Tool to delete shared parameters from projects |  | 4 | low | one tool with selection list and delete |
| [KTR5-4174](https://linear.app/jhkelly/issue/KTR5-4174) | Add - Write material type and wall thickness data from connected parts to weld objects | 4 | 4 | medium | connector walk and parameter write for welds |
| [KTR5-4175](https://linear.app/jhkelly/issue/KTR5-4175) | Change - Initialize Collections at the property/Field Rather than in a constructor | 8 | 8 | medium | style sweep across many files and repos |
| [KTR5-3810](https://linear.app/jhkelly/issue/KTR5-3810) | Discuss Individual Auto Updater Configurations with Jason/Adam | 4 | 4 | medium | meeting series |
| [KTR5-3811](https://linear.app/jhkelly/issue/KTR5-3811) | Discuss Individual Manual Updater Configurations with Jason/Adam | 4 | 4 | medium | meeting series |
| [KTR5-4077](https://linear.app/jhkelly/issue/KTR5-4077) | Plan - Need a whole series of meetings To Review Auto Updaters and The service's they call | 1 | 1 | medium | planning item |
| [KTR5-3839](https://linear.app/jhkelly/issue/KTR5-3839) | Plan - With Jason and Adam About New [Valve Tag Assign Tool] | 4 | 4 | medium | planning meeting |
| [KTR5-4478](https://linear.app/jhkelly/issue/KTR5-4478) | Change - KTR-3D Visibility Graphics (Ease Up On Loading...) |  | 2 | low | title only, view template or filter change |
| [KTR5-4517](https://linear.app/jhkelly/issue/KTR5-4517) | Delete - Dead Code From All Repositories |  | skip (parent) | high | parent of KTR5-4518 to 4521 |

## KTRUI

| Key | Title | Current | Proposed | Confidence | Reason |
|---|---|---|---|---|---|
| [KTRUI-3](https://linear.app/jhkelly/issue/KTRUI-3) | Every build warns CS0419 six times on the ArgumentNullException cref |  | 1 | high | six doc-only cref fixes in six files, build three years |
| [KTRUI-2](https://linear.app/jhkelly/issue/KTRUI-2) | Handle the open // todo notes in Kelly-Revit-UI |  | 4 | medium | the one todo is implementing an ElementFilter in CommandBase, a design change in a type not testable in Revit |
| [KTRUI-1](https://linear.app/jhkelly/issue/KTRUI-1) | Review the Kelly-Revit-UI controls for improvements |  | 4 | low | open-ended review of six XAML controls in src/Controls plus follow-up fixes |

## KTRL5

| Key | Title | Current | Proposed | Confidence | Reason |
|---|---|---|---|---|---|
| [KTRL5-7](https://linear.app/jhkelly/issue/KTRL5-7) | Test that SetWeldLocation leaves a matching JHK BOM Type alone |  | 4 | high | in-Revit test plus exposing the ParameterResultType from SetWeldLocation and ProductRange10Joints01Weld.SetLocation |
| [KTRL5-6](https://linear.app/jhkelly/issue/KTRL5-6) | PenetrationTagTools.CreateTag mixes invariant and current culture |  | 2 | medium | one method with its test; deferred as KTR is US-only |
| [KTRL5-5](https://linear.app/jhkelly/issue/KTRL5-5) | Handle the open // todo notes in Kelly-Revit-Logic-v5 |  | 16 | low | 45 todo comments in 23 src files; split per area |
| [KTRL5-4](https://linear.app/jhkelly/issue/KTRL5-4) | Deprecation plans for Kelly-Revit-Logic-v5 |  | skip (parent) | high | parent with open sub-issue KTRL5-8 |
| [KTRL5-8](https://linear.app/jhkelly/issue/KTRL5-8) | Deprecate the Component and Product updaters |  | 8 | medium | plan steps 3-4 span Logic and Kelly-Revit-v5 with in-Revit verify; 16 if parameters and SQL are retired too |
| [KTRL5-3](https://linear.app/jhkelly/issue/KTRL5-3) | Move the 80 OperationService call sites to Run and Run<T> |  | 16 | high | migration of 80 sites across Logic and the Kelly-Revit-v5 modules; split |
| [KTRL5-1](https://linear.app/jhkelly/issue/KTRL5-1) | Remove this layer's copies of the code moved down on 2026-11-04 |  | 16 | medium | about 51 Logic-sourced moves to delete or forward, callers repointed in Logic, UI and Kelly-Revit-v5; split |
| [KTRL5-2](https://linear.app/jhkelly/issue/KTRL5-2) | Move DataFileService to Kelly-Domain |  | 8 | medium | breaking type move to Kelly-Domain with injected Revit version and validator factory, packed and repinned up |

## KTR4

| Key | Title | Current | Proposed | Confidence | Reason |
|---|---|---|---|---|---|
| [KTR4-30](https://linear.app/jhkelly/issue/KTR4-30) | Layout Point Import: Specify Level always fails |  | 1 | high | one XAML binding fix (SelectedValuePath) in the import view |
| [KTR4-62](https://linear.app/jhkelly/issue/KTR4-62) | Windows Mockup: product-code list blank after scope change |  | 1 | high | refill the existing collection in a 73-line ViewModel |
| [KTR4-61](https://linear.app/jhkelly/issue/KTR4-61) | Suspended Support Manager: field trim stored in inches, not feet |  | 1 | high | assign the feet value on one line of SuspendedSupport.cs |
| [KTR4-60](https://linear.app/jhkelly/issue/KTR4-60) | Suspended Support Manager: Set Extensions on unattached hangers does nothing |  | 2 | medium | skip unattached hangers and report the count in SuspendedSupport; check in Revit |
| [KTR4-59](https://linear.app/jhkelly/issue/KTR4-59) | Spool Manager: grids keep new values after a rolled-back edit |  | 2 | medium | check IsCommitted after Stop and reload spools in one ViewModel |
| [KTR4-58](https://linear.app/jhkelly/issue/KTR4-58) | Spool Creator: one Create is three separate Undo steps |  | 2 | medium | wrap create, data and name in one transaction group in SpoolCreateViewModel |
| [KTR4-57](https://linear.app/jhkelly/issue/KTR4-57) | Spool Creator: line-number spool count matches name prefixes too loosely |  | 2 | medium | tighten the prefix match to line-initialism pattern in one ViewModel |
| [KTR4-56](https://linear.app/jhkelly/issue/KTR4-56) | Racker: will not open on Straights items with no level |  | 2 | medium | skip or list null-level elements in the Racker ViewModel |
| [KTR4-55](https://linear.app/jhkelly/issue/KTR4-55) | Racker: cancel ends as Failed instead of Cancelled |  | 1 | high | return Result.Cancelled in one command |
| [KTR4-54](https://linear.app/jhkelly/issue/KTR4-54) | Olet Check: dialog collects olets twice on open |  | 1 | high | drop one LoadElements call in the constructor |
| [KTR4-53](https://linear.app/jhkelly/issue/KTR4-53) | Olet Check: Select links keep stale enabled state |  | 1 | high | invalidate two commands in RecalculateOletCounts |
| [KTR4-52](https://linear.app/jhkelly/issue/KTR4-52) | Module Manager: grid shows unsaved item numbers as written |  | 2 | medium | keep old numbers and restore unless commit succeeded in one ViewModel |
| [KTR4-51](https://linear.app/jhkelly/issue/KTR4-51) | Module Creator: DEFAULT prefix offered in projects with no modules |  | 2 | medium | filter the DEFAULT placeholder out of the existing prefixes in one ViewModel |
| [KTR4-50](https://linear.app/jhkelly/issue/KTR4-50) | Module Creator: Last Module shows AB-MOD-5 without padding |  | 4 | medium | ModuleCreatorSettings is in Kelly-Revit-Logic-v4 and ModuleNumber in Kelly-Windows-v2, so a pack and repin unless fixed in the add-in display |
| [KTR4-49](https://linear.app/jhkelly/issue/KTR4-49) | Line Number selector: Add Context Value check box label is wrong |  | 1 | high | label text and width in a 48-line ViewModel and its view |
| [KTR4-48](https://linear.app/jhkelly/issue/KTR4-48) | Level Correct: empty model selection shows a raw Revit error |  | 1 | high | add an empty-selection message in a 43-line command |
| [KTR4-47](https://linear.app/jhkelly/issue/KTR4-47) | Level Correct: fails on a selection with a category-less element |  | 1 | high | null-safe category filter in the same command; pairs with KTR4-48 |
| [KTR4-46](https://linear.app/jhkelly/issue/KTR4-46) | Layout Point Export: quality dialog shows placeholder text |  | 1 | high | fill ExpandedContent and drop the footer in one prompt call |
| [KTR4-45](https://linear.app/jhkelly/issue/KTR4-45) | Layout Point Export: export window stays always on top |  | 1 | high | remove one Topmost assignment (line 792) |
| [KTR4-44](https://linear.app/jhkelly/issue/KTR4-44) | Layout Point Export: save clears the Revit selection |  | 2 | medium | switch to RebindAndSelectWithoutSync and suspend sync in the 1041-line ViewModel |
| [KTR4-43](https://linear.app/jhkelly/issue/KTR4-43) | Suspended Support Manager: Tagging Set tags un-hosted hangers |  | 1 | high | change the skip test to the host id in one method |
| [KTR4-42](https://linear.app/jhkelly/issue/KTR4-42) | Suspended Support Manager: Override Size Set skips family supports |  | 2 | medium | limit tag reset and size write to fabrication hangers in one ViewModel |
| [KTR4-41](https://linear.app/jhkelly/issue/KTR4-41) | Spool Manager: will not open without a 'Spool - ' title block |  | 2 | medium | drop the minimum check and disable Create Spool Sheets with a note |
| [KTR4-40](https://linear.app/jhkelly/issue/KTR4-40) | Spool Manager: Welds tab Update buttons show Error Reading Object |  | 2 | medium | CommandParameter fix in the view plus STK to Shop in ProductRange10Joints01Weld, both in the add-in |
| [KTR4-39](https://linear.app/jhkelly/issue/KTR4-39) | Point to Pipe: units boxes always start at Inches and Feet |  | 2 | medium | load user settings or default UnitsId 0 in VtfrSettings and the view; metric check in Revit |
| [KTR4-38](https://linear.app/jhkelly/issue/KTR4-38) | Point to Pipe: typed or pasted Point File path is ignored |  | 2 | medium | read the picker path on OK and guard the null in the tools class |
| [KTR4-37](https://linear.app/jhkelly/issue/KTR4-37) | Olet Check: Re-Connect and Select use the wrong project |  | 4 | medium | carry the dialog's document through the external event handler and reopen per project; two-project check in Revit |
| [KTR4-36](https://linear.app/jhkelly/issue/KTR4-36) | Layout Point Import: missing point families cause NullReferenceException |  | 2 | medium | null-safe family lookups in one ViewModel |
| [KTR4-35](https://linear.app/jhkelly/issue/KTR4-35) | Layout Point Export: tool will not open without hangers or points |  | 2 | medium | relax ValidateRequirements minimums and warn instead |
| [KTR4-34](https://linear.app/jhkelly/issue/KTR4-34) | Layout Point Export: Exported and Not Valid filters cannot match |  | 2 | medium | fix two filter member names, the count and a stray paren in the code-behind |
| [KTR4-33](https://linear.app/jhkelly/issue/KTR4-33) | Layout Point Export: save with no valid points shows exception prompt |  | 2 | medium | skip reselect when nothing saved and show a quality message |
| [KTR4-32](https://linear.app/jhkelly/issue/KTR4-32) | Layout Point Export: Export saves hosts before quality check and dialog |  | 4 | medium | reorder the export flow (check, dialog, then save) across view and 1041-line ViewModel; check in Revit |
| [KTR4-31](https://linear.app/jhkelly/issue/KTR4-31) | Spool Manager: partial changes committed when an edit throws |  | 4 | medium | add rollback and report around 11 operations in SpoolManagerViewModel (no OperationService.Run in v4) |
| [KTR4-29](https://linear.app/jhkelly/issue/KTR4-29) | Layout Point Export: Data Filter drops hidden saved points on save |  | 2 | medium | take host points from LayoutPointCandidates; confirm in Revit first |
| [KTR4-28](https://linear.app/jhkelly/issue/KTR4-28) | Module Manage: Item Numbers button stays disabled after BOM type set |  | 1 | high | call the toggle or raise PropertyChanged after the BOM type is set |
| [KTR4-27](https://linear.app/jhkelly/issue/KTR4-27) | Racker: Bottom/Top align buttons override typed elevation in Manual mode |  | 1 | high | remove two event bindings in one XAML view |
| [KTR4-26](https://linear.app/jhkelly/issue/KTR4-26) | Decide the status colors (success, warning, danger) |  | 4 | low | decision plus changes to Kelly-Windows-v2 QualityCheckColors and MatchColors and OletCheckViewModel; lower-layer pack likely shared with KTR4-24 |
| [KTR4-25](https://linear.app/jhkelly/issue/KTR4-25) | Replace the off-palette colors in the views and converters |  | 8 | medium | sweep over several views plus Kelly-Windows-v2 IValueConverter classes, needs pack and repin |
| [KTR4-24](https://linear.app/jhkelly/issue/KTR4-24) | Add the brand colors once as named colors and brushes |  | 8 | medium | new colors and brushes in Kelly-Windows-v2 with tests, pack, repin, and a resource dictionary in Kelly-Revit-v4 |
| [KTR4-2](https://linear.app/jhkelly/issue/KTR4-2) | Use the other JH Kelly brand colors beside Kelly Green |  | skip (parent) | high | open sub-issues KTR4-24, KTR4-25, KTR4-26 |
| [KTR4-18](https://linear.app/jhkelly/issue/KTR4-18) | Are there any TODO notes that can be handled? |  | 16 | low | 122 todo comments in the add-in (135 across v4); split into themed issues |
| [KTR4-3](https://linear.app/jhkelly/issue/KTR4-3) | Move the feet-and-inches check into Kelly-Windows-v2 ConstructionServices |  | 8 | high | new tested Kelly-Windows-v2 member, pack, repin Kelly-Revit-Logic-v4 and the add-in, replace the Racker copy |

## KTRL4

| Key | Title | Current | Proposed | Confidence | Reason |
|---|---|---|---|---|---|
| [KTRL4-1](https://linear.app/jhkelly/issue/KTRL4-1) | Are there any TODO notes that can be handled? |  | 4 | low | 11 todo comments in Kelly-Revit-Logic-v4, then a pack and repin if code changes |

## KW3

| Key | Title | Current | Proposed | Confidence | Reason |
|---|---|---|---|---|---|
| [KW3-13](https://linear.app/jhkelly/issue/KW3-13) | Flake and brittleness risks in the test wave |  | 2 | high | two test fixtures (WorkstationModelTests, FileTypeTests) to loosen |
| [KW3-11](https://linear.app/jhkelly/issue/KW3-11) | Decide whether TryParseDecimalFeet should stay lenient |  | 2 | medium | decision plus a change to one method in ConstructionServices and its pinning tests |
| [KW3-10](https://linear.app/jhkelly/issue/KW3-10) | ConvertFractionToDecimalFeet should use the guarded parse of TryParseDecimalFeet |  | 2 | medium | one type (ConstructionServices), shared private helper, four pinning tests change |
| [KW3-8](https://linear.app/jhkelly/issue/KW3-8) | Are there any TODO notes that can be handled? |  | 1 | high | one TODO left (StringExtensions.Write 'move to Kelly.Windows', already there) |
| [KW3-7](https://linear.app/jhkelly/issue/KW3-7) | Change Point3 to a struct |  | 8 | medium | class-to-struct semantics change; Point3 used in 34 files across layers, needs pack and repin |
| [KW3-5](https://linear.app/jhkelly/issue/KW3-5) | ServiceProvider.GetService returns arbitrary instance on duplicate concrete types |  | 2 | high | one method in ServiceProvider plus tests and XML docs |
| [KW3-4](https://linear.app/jhkelly/issue/KW3-4) | Improve the progress bar service (ProgressReporter, Kelly.Windows.Wpf) |  | 4 | low | title-only; ProgressReporter and its extensions are two types |
| [KW3-3](https://linear.app/jhkelly/issue/KW3-3) | Repoint 13 view code-behinds to FrameworkElementExtensions.ThrowIfNotReady |  | 8 | medium | needs Kelly-Windows pack and repin through Domain, Logic, UI to Kelly-Revit-v5, then 13 mechanical edits |
| [KW3-2](https://linear.app/jhkelly/issue/KW3-2) | SpreadsheetColumns.FirstLetterToNumber reads only the first letter |  | 2 | medium | one type and its tests; behaviour decision for the point-to-pipe window |
| [KW3-1](https://linear.app/jhkelly/issue/KW3-1) | Repoint the layers above to the helpers moved down in round 2 (#2 to #18) |  | 16 | medium | 14 helpers repointed and duplicates deleted in Domain, Logic, UI and v5, each layer packed and repinned; split per layer |

## KW2

| Key | Title | Current | Proposed | Confidence | Reason |
|---|---|---|---|---|---|
| [KW2-1](https://linear.app/jhkelly/issue/KW2-1) | Are there any TODO notes that can be handled? |  | 1 | high | two 'move to Kelly.Windows' TODOs in StringExtensions already in Kelly.Windows: remove the comments |

## KWD3

| Key | Title | Current | Proposed | Confidence | Reason |
|---|---|---|---|---|---|
| [KWD3-10](https://linear.app/jhkelly/issue/KWD3-10) | Align the tests csproj configuration fallback with src |  | 1 | high | one-line csproj fallback change in tests/Data.Tests.csproj |
| [KWD3-7](https://linear.app/jhkelly/issue/KWD3-7) | Decide ICache's fate (src/Caching/ICache.cs) |  | 4 | medium | decision; still referenced by Kelly-Windows-v3 RecordCache and Domain caches, so delete or redesign reaches the layers above |
| [KWD3-2](https://linear.app/jhkelly/issue/KWD3-2) | Rename JsonFileLoadException, the declared failure for every format, CSV included |  | 8 | medium | public rename used in 32 files across 8 repos, pack and repin; blocked until v2 compatibility lifts |
| [KWD3-1](https://linear.app/jhkelly/issue/KWD3-1) | Pack DataDirectory.ReadAllVerified and repin the layers above |  | 8 | high | pack and repin Kelly-Windows and Kelly-Domain, then switch DataStore.Load and delete ReadChecked |

## KD

| Key | Title | Current | Proposed | Confidence | Reason |
|---|---|---|---|---|---|
| [KD-35](https://linear.app/jhkelly/issue/KD-35) | LayoutPointIdTests verification dates use the wrong date format |  | 1 | high | text fix in one test file (the dates themselves are the human's to set) |
| [KD-33](https://linear.app/jhkelly/issue/KD-33) | Tests pin display-only enums and property counts |  | 2 | high | loosen pins in EnumMembersTests and VtfrSettingsTests |
| [KD-30](https://linear.app/jhkelly/issue/KD-30) | Are there any TODO notes that can be handled? |  | 4 | medium | 11 TODOs: 9 bearer sizes to verify against real parts, ApplicationSession JSON persistence, a ProjectSystemQueries query |
| [KD-27](https://linear.app/jhkelly/issue/KD-27) | SpoolNumber.GetNextSequence matches names on their start, not on split parts |  | 2 | high | one method in SpoolNumber reuses TrySplitName, plus tests |
| [KD-26](https://linear.app/jhkelly/issue/KD-26) | SpoolNumber.GetNextSequence wraps to int.MinValue after int.MaxValue |  | 1 | high | checked addition or guard in one method, pinning test exists |
| [KD-25](https://linear.app/jhkelly/issue/KD-25) | ModuleNumber.GetNextSequence wraps to int.MinValue after int.MaxValue |  | 1 | high | checked addition or guard in one method, pinning test exists |
| [KD-24](https://linear.app/jhkelly/issue/KD-24) | ModuleNumber.GetNextSequence proposes 0 for a too-large sequence |  | 1 | high | small fix in GetSegmentSequence handling, pinning test exists |
| [KD-23](https://linear.app/jhkelly/issue/KD-23) | default(LayoutPoint).IsValid throws NRE and LayoutPoint is mutable |  | 4 | medium | null guard is small but making the struct immutable and fixing Signature touches its callers |
| [KD-22](https://linear.app/jhkelly/issue/KD-22) | Legacy layout point names that are not IDs decode to Empty without a report |  | 4 | medium | needs a report or migration path for legacy names across LayoutPoint and its storage |
| [KD-21](https://linear.app/jhkelly/issue/KD-21) | Layout point text is culture-sensitive and cannot round-trip |  | 2 | medium | invariant write and parse in LayoutPoint and LayoutPointStorage; deferred, KTR is US-only |
| [KD-10](https://linear.app/jhkelly/issue/KD-10) | Implement the FractionalLength struct for fractional feet and inches |  | 1 | low | struct already implemented and moved to Kelly-Windows-v3; close or move the item |
| [KD-9](https://linear.app/jhkelly/issue/KD-9) | Proposed Custom Data report does not quote its values |  | 1 | high | quote values in one method, pinning test exists |
| [KD-8](https://linear.app/jhkelly/issue/KD-8) | Point To Pipe settings reader stays open on an error |  | 2 | high | using-block in Read and null guard in Write of one type, two pinning tests change |
| [KD-7](https://linear.app/jhkelly/issue/KD-7) | Two signature rules for services and systems |  | 2 | medium | decision, then align SignatureTools and ColoredSignatureTools with their tests |
| [KD-6](https://linear.app/jhkelly/issue/KD-6) | JHK parameter name prefix checks compare differently |  | 4 | medium | decision; unify IsKellyName with three Kelly-Revit-Logic-v5 types, which needs the Domain pin |
| [KD-5](https://linear.app/jhkelly/issue/KD-5) | Do-not-number item number differs between the spool models |  | 2 | medium | decision, then one of the two callers changes with its test |
| [KD-4](https://linear.app/jhkelly/issue/KD-4) | Hanger placement repeat fallback differs from the settings default |  | 1 | high | decision then a constant change, pinning test exists |
| [KD-3](https://linear.app/jhkelly/issue/KD-3) | Layout point export and save length guards disagree |  | 2 | high | align two guard methods in two types plus tests |
| [KD-2](https://linear.app/jhkelly/issue/KD-2) | Layout Point Export dialog shows placeholder footer and expanded text |  | 1 | high | text change in LayoutPointExportNotice, pinning test exists |
| [KD-1](https://linear.app/jhkelly/issue/KD-1) | Layout Point Export selection label miscounts and has a stray parenthesis |  | 1 | high | count and text fix in Summarize, pinning tests exist |

## HASA

| Key | Title | Current | Proposed | Confidence | Reason |
|---|---|---|---|---|---|
| [HASA-51](https://linear.app/jhkelly/issue/HASA-51) | Import nouns and components from a Markdown list |  | 4 | medium | text only: parser plus nested insert, area picker and duplicate handling across apps |
| [HASA-83](https://linear.app/jhkelly/issue/HASA-83) | Export a noun as a formatted Markdown file |  | 4 | medium | text only: tree-to-Markdown export of details, components and tasks on several apps |
| [HASA-79](https://linear.app/jhkelly/issue/HASA-79) | Tags, with a hierarchy |  | 8 | medium | text only: new hierarchical tag table, RPCs and tag UI/filter on every app |
| [HASA-53](https://linear.app/jhkelly/issue/HASA-53) | Task dependencies (waiting on / blocking) |  | 8 | medium | text only: dependency table, date rules and blocked-task display across apps |
| [HASA-64](https://linear.app/jhkelly/issue/HASA-64) | Settings panel, starting with locale |  | 8 | medium | text only: per-user settings storage plus settings UI and locale formatting on every app |
| [HASA-63](https://linear.app/jhkelly/issue/HASA-63) | Print any view |  | 4 | medium | text only: print stylesheets on web and Print command in native apps |
| [HASA-71](https://linear.app/jhkelly/issue/HASA-71) | Other ways to view the data: mind map, area → noun → task, task → noun → area |  | 16 | low | text only: three new views incl. mind map on several platforms; split |
| [HASA-72](https://linear.app/jhkelly/issue/HASA-72) | Kits: groups of nouns, such as a workstation |  | 8 | low | text only: new kit entity with membership table, RPCs and UI; design still open |
| [HASA-78](https://linear.app/jhkelly/issue/HASA-78) | Keyboard shortcuts to add a noun, area or task |  | 2 | medium | text only: shortcut bindings focusing existing add fields per app |
| [HASA-54](https://linear.app/jhkelly/issue/HASA-54) | Find and replace, in a selection or everywhere |  | 8 | low | text only: replace RPC over several fields plus selection-aware UI on every app |
| [HASA-65](https://linear.app/jhkelly/issue/HASA-65) | Fill in Made by and Model from a noun's name |  | 4 | low | text only: name parsing against makers plus suggestion UI; rules vs AI undecided |
| [HASA-52](https://linear.app/jhkelly/issue/HASA-52) | Export tasks to other task apps (Todoist, TickTick, …) |  | 8 | low | text only: mapping and export/sync to several third-party apps; scope undecided |
| [HASA-77](https://linear.app/jhkelly/issue/HASA-77) | Duplicate a noun with its components and tasks |  | 4 | medium | text only: one recursive copy DB function plus a Duplicate command per app |
| [HASA-76](https://linear.app/jhkelly/issue/HASA-76) | Copy tasks and paste them on another noun |  | 4 | medium | text only: copy/paste of tasks with multi-select across several apps |
| [HASA-62](https://linear.app/jhkelly/issue/HASA-62) | A parallel web app built with .NET Blazor |  | 16 | medium | text only: whole second web app on the same backend; already under way in HASAWB |
| [HASA-67](https://linear.app/jhkelly/issue/HASA-67) | Proper app icons based on "has a" |  | 2 | medium | text only: icon design and asset sets for Mac, iOS and web favicons |
| [HASA-69](https://linear.app/jhkelly/issue/HASA-69) | Add makers on the Makers page |  | skip (parent) | high | text only: has open platform sub-issues HASAW-34, HASAO-36, HASAWB-19 |
| [HASA-59](https://linear.app/jhkelly/issue/HASA-59) | Speed improvements (top priority) |  | skip (parent) | high | text only: has open sub-issue HASAWB-32 |
| [HASA-70](https://linear.app/jhkelly/issue/HASA-70) | Benchmark each app |  | 4 | medium | text only: shared timing script for both web apps plus native measurement |
| [HASA-68](https://linear.app/jhkelly/issue/HASA-68) | Open a new noun right after creating it |  | 2 | medium | text only: select and reveal new noun in each app; sub-issues already closed |
| [HASA-74](https://linear.app/jhkelly/issue/HASA-74) | Group makers by first letter on the Makers page |  | 2 | high | text only: letter-heading grouping, small change on each platform |
| [HASA-82](https://linear.app/jhkelly/issue/HASA-82) | Sidebar: Makers and Archived at the bottom, above the account section |  | 2 | high | text only: move two sidebar items in each app's layout |
| [HASA-84](https://linear.app/jhkelly/issue/HASA-84) | Click an area's header to expand or collapse it |  | 2 | high | text only: header click toggles area in each app, rename moves to menu |
| [HASA-9](https://linear.app/jhkelly/issue/HASA-9) | Build native SwiftUI apps for Mac, iPhone and iPad |  | skip (parent) | high | text only: has open sub-issue HASAO-11 |

## HASADB

| Key | Title | Current | Proposed | Confidence | Reason |
|---|---|---|---|---|---|
| [HASADB-16](https://linear.app/jhkelly/issue/HASADB-16) | Sign in with Apple |  | 4 | medium | text only: Supabase provider config plus Apple capability and button on native and web |
| [HASADB-19](https://linear.app/jhkelly/issue/HASADB-19) | Idea: sign in with a 6-digit email code as well as the link |  | 2 | medium | text only: email template token plus verifyOTP code field on web, Mac and iOS |
| [HASADB-15](https://linear.app/jhkelly/issue/HASADB-15) | Add the production web address to Supabase auth URLs |  | 1 | high | text only: user step setting Site and Redirect URLs, then check sign-in |

## HASAW

| Key | Title | Current | Proposed | Confidence | Reason |
|---|---|---|---|---|---|
| [HASAW-6](https://linear.app/jhkelly/issue/HASAW-6) | Touch support for moving nouns (iPad/iPhone web) |  | 4 | medium | text only: touch drag library or Move-to picker in the React sidebar |
| [HASAW-22](https://linear.app/jhkelly/issue/HASAW-22) | Connect a custom domain to the hosted web app |  | 1 | high | text only: DNS, HTTPS and Supabase URL update; configuration only |
| [HASAW-21](https://linear.app/jhkelly/issue/HASAW-21) | Deploy the web app to a hosting service |  | 1 | high | text only: connect repo to a static host and set two env variables |
| [HASAW-34](https://linear.app/jhkelly/issue/HASAW-34) | Web: add makers on the Makers page |  | 1 | high | text only: one add box on the React Makers page reusing maker_named |

## HASAO

| Key | Title | Current | Proposed | Confidence | Reason |
|---|---|---|---|---|---|
| [HASAO-17](https://linear.app/jhkelly/issue/HASAO-17) | Sign and notarize the Mac app; store sessions in Keychain |  | 2 | medium | text only: set team, switch session storage to Keychain, archive and notarize |
| [HASAO-27](https://linear.app/jhkelly/issue/HASAO-27) | Bug: sign-in link errors aren't shown when Hasa opens from Safari |  | 1 | medium | text only: show existing error alert when app is brought forward by the link |
| [HASAO-36](https://linear.app/jhkelly/issue/HASAO-36) | Mac, iPhone & iPad: add makers on the Makers page |  | 1 | high | text only: one add field in shared SwiftUI MakersView reusing maker_named |
| [HASAO-37](https://linear.app/jhkelly/issue/HASAO-37) | Bug: a component's right-click menu can change its area |  | 1 | high | text only: hide Move to Area menu on components in the shared sidebar |
| [HASAO-11](https://linear.app/jhkelly/issue/HASAO-11) | Native drag and drop to nest and reorder nouns |  | 4 | medium | text only: drag and drop in the native sidebar using the existing move_noun RPC |

## HASAI

| Key | Title | Current | Proposed | Confidence | Reason |
|---|---|---|---|---|---|
| [HASAI-13](https://linear.app/jhkelly/issue/HASAI-13) | Bug: Select mode shows selection circles on Today, Upcoming and Makers |  | 1 | high | text only: limit selection circles to noun rows in one sidebar view |
| [HASAI-6](https://linear.app/jhkelly/issue/HASAI-6) | Publish a TestFlight build |  | 2 | medium | text only: App Store Connect record, icon, privacy details, archive and upload |
| [HASAI-5](https://linear.app/jhkelly/issue/HASAI-5) | Install and test on a real iPhone |  | 2 | medium | text only: sign and install, then manual check of sign-in, sync and touch |
| [HASAI-4](https://linear.app/jhkelly/issue/HASAI-4) | Join the Apple Developer Program |  | 1 | high | text only: user enrollment step, no code |
| [HASAI-11](https://linear.app/jhkelly/issue/HASAI-11) | Drag nouns to nest and reorder on iPhone and iPad |  | 4 | medium | text only: touch-specific drag design in shared SwiftUI using move_noun |

## HASAWB

| Key | Title | Current | Proposed | Confidence | Reason |
|---|---|---|---|---|---|
| [HASAWB-32](https://linear.app/jhkelly/issue/HASAWB-32) | Speed (Blazor): start-up from the last loaded workspace |  | 1 | medium | text only: already done in 0e1899c; only the signed-in check remains |
| [HASAWB-25](https://linear.app/jhkelly/issue/HASAWB-25) | User step: set up the Everleap site and enable WebSockets |  | 1 | high | text only: user step in the hosting control panel |
| [HASAWB-27](https://linear.app/jhkelly/issue/HASAWB-27) | User step: add the Everleap address to Supabase Redirect URLs and test sign-in |  | 1 | high | text only: user step adding one redirect URL and testing sign-in |
| [HASAWB-26](https://linear.app/jhkelly/issue/HASAWB-26) | User step: upload blazor/publish to Everleap over FTP |  | 1 | high | text only: user step running publish script and FTP upload |
| [HASAWB-19](https://linear.app/jhkelly/issue/HASAWB-19) | Blazor: add makers on the Makers page |  | 1 | high | text only: one add box on the Blazor Makers page via MakerNamedAsync |
| [HASAWB-14](https://linear.app/jhkelly/issue/HASAWB-14) | Host the Blazor app on everleap.com |  | skip (parent) | high | text only: has open sub-issues HASAWB-25, HASAWB-26, HASAWB-27 |
| [HASAWB-15](https://linear.app/jhkelly/issue/HASAWB-15) | Compare Blazor and React: measure and write up |  | 4 | medium | text only: measure both apps the same way and write a comparison with recommendation |

## Low confidence

- [KTR5-4693](https://linear.app/jhkelly/issue/KTR5-4693) Final test: KTR needs to work without connecting to a JHK network (no VPN, etc.) (4): end-to-end offline check of every startup path and tool, title-only
- [KTR5-4679](https://linear.app/jhkelly/issue/KTR5-4679) Run the IA Prompt architectural analysis and cleanup (16): architectural analysis and cleanup; prompt file missing, scope unknown; split
- [KTR5-4610](https://linear.app/jhkelly/issue/KTR5-4610) Contenter (2): title-only: one InstallShield install type
- [KTR5-4609](https://linear.app/jhkelly/issue/KTR5-4609) Manager (2): title-only: one InstallShield install type
- [KTR5-4608](https://linear.app/jhkelly/issue/KTR5-4608) Detailer (2): title-only: one InstallShield install type
- [KTR5-4597](https://linear.app/jhkelly/issue/KTR5-4597) Is there any other file data I/O that Kelly.Windows.Data.* can handle? (2): analysis of remaining file I/O, title-only
- [KTR5-4582](https://linear.app/jhkelly/issue/KTR5-4582) Refactor the application services if needed (4): title-only, conditional refactor of application services
- [KTR5-4581](https://linear.app/jhkelly/issue/KTR5-4581) Tool to recover OperationService logs (.json, .jsonl) (8): new tool to recover OperationService logs, title-only
- [KTR5-3833](https://linear.app/jhkelly/issue/KTR5-3833) Change the way the Scope Control works or the way View Models use it so a filter i created on the GridView or other consuming control (8): Kelly-Revit-UI scope control redesign affecting every consuming view model
- [KTR5-3281](https://linear.app/jhkelly/issue/KTR5-3281) Selection Radio Button (2): title only, likely one control change
- [KTR5-3935](https://linear.app/jhkelly/issue/KTR5-3935) Other (8): sub-issue of new Spool Creator, no description
- [KTR5-3934](https://linear.app/jhkelly/issue/KTR5-3934) Testing (8): sub-issue of new Spool Creator, no description
- [KTR5-3933](https://linear.app/jhkelly/issue/KTR5-3933) Logic (8): sub-issue of new Spool Creator, no description
- [KTR5-3932](https://linear.app/jhkelly/issue/KTR5-3932) User Interface (8): sub-issue of new Spool Creator, no description
- [KTR5-4128](https://linear.app/jhkelly/issue/KTR5-4128) Try To Convert Hill Group VB.net to C#.net (8): no Hill Group code in the repos yet, size unknown
- [KTR5-4127](https://linear.app/jhkelly/issue/KTR5-4127) Create - Duct Quality Check View (8): new view for a new tool
- [KTR5-4126](https://linear.app/jhkelly/issue/KTR5-4126) Create - Duct Quality Check View Model (8): new view model for a new tool
- [KTR5-4125](https://linear.app/jhkelly/issue/KTR5-4125) Create - Duct Quality Check Model(s) (8): new models for a new tool
- [KTR5-4124](https://linear.app/jhkelly/issue/KTR5-4124) Create - Duct Quality Check Model(s) (8): new models for a new tool
- [KTR5-4123](https://linear.app/jhkelly/issue/KTR5-4123) Create - Duct Quality Check View Model (8): new view model for a new tool
- [KTR5-4122](https://linear.app/jhkelly/issue/KTR5-4122) Create - Duct Quality Check View (8): new view for a new tool
- [KTR5-4121](https://linear.app/jhkelly/issue/KTR5-4121) Try To Convert Hill Group VB.net to C#.net (8): no Hill Group code in the repos yet, size unknown
- [KTR5-3794](https://linear.app/jhkelly/issue/KTR5-3794) Ability to create View/Filters/Sheets when i create a Module (4): scope still under discussion
- [KTR5-3680](https://linear.app/jhkelly/issue/KTR5-3680) Trapeze Is Too Wide (2): title only, likely a width calculation fix in one type
- [KTR5-3785](https://linear.app/jhkelly/issue/KTR5-3785) Ability to place Family Instances as well as Fabrication Part Instances [Hanger Tool] (4): second placement mode in the Vicious hanger tool
- [KTR5-3695](https://linear.app/jhkelly/issue/KTR5-3695) Implement Unit Testing on this Tool and its dependencies (4): tool not named, in-Revit tests
- [KTR5-4085](https://linear.app/jhkelly/issue/KTR5-4085) Develop Dockable Assigner System (2): AssignerDockablePanel already exists in Trade.All, verify what remains
- [KTR5-3827](https://linear.app/jhkelly/issue/KTR5-3827) Tool to create an offset in a pipe run so that the complex multistep manual work is eliminated (16): new geometry tool with three offset kinds, split
- [KTR5-3829](https://linear.app/jhkelly/issue/KTR5-3829) Ability to end swap connected family instances like we can with Fabrication Parts so less manual and potentially destructive work is eliminated (4): new connector logic for family instances
- [KTR5-2461](https://linear.app/jhkelly/issue/KTR5-2461) Remove the "I" suffix from any Definition Name in our ExternalParameterDefinitions Table and Classes now that the old "Type" records have been deleted (8): data files, exporter and definition names across layers
- [KTR5-2434](https://linear.app/jhkelly/issue/KTR5-2434) Delete the use of extraneous Shared Parameters. (4): four weld parameters to remove from code and data
- [KTR5-2967](https://linear.app/jhkelly/issue/KTR5-2967) Global - Validation - Upgrade To Property Validation for All Tools Using IConverters (8): sweep over the views using IValueConverters
- [KTR5-4043](https://linear.app/jhkelly/issue/KTR5-4043) Fix - Window crops some UI Elements (1): layout fix in one view, view not named
- [KTR5-3924](https://linear.app/jhkelly/issue/KTR5-3924) Persist the selected Detailing Package in the Combo Box so the flow isn't interrupted on subsequent creations (4): selection persistence in one tool
- [KTR5-4042](https://linear.app/jhkelly/issue/KTR5-4042) Fix - reading the size from Fabrication Duct - One shape of duct fails (1): one shape case in the size reader
- [KTR5-2958](https://linear.app/jhkelly/issue/KTR5-2958) Module Manager to work on Sheet Metal Projects (8): duct and sheet metal support through Module Manager and its Logic
- [KTR5-3144](https://linear.app/jhkelly/issue/KTR5-3144) Assembly Creator to geometrically alter all "Family Instances" a miniscule amount so it doesn't fail the Assembly creation process. (16): Revit API workaround with uncertain approach
- [KTR5-3278](https://linear.app/jhkelly/issue/KTR5-3278) Must be able to process all Fabrication Support Patterns (8): every support pattern needs handling and fabrication content to test
- [KTR5-3279](https://linear.app/jhkelly/issue/KTR5-3279) Needs better property validation system such as the Fluent system i implemented in the Module Manager Tool (16): new validation across all models, split
- [KTR5-4494](https://linear.app/jhkelly/issue/KTR5-4494) Analysis - IUpdater Needs (4): analysis of about 26 updater types
- [KTR5-4448](https://linear.app/jhkelly/issue/KTR5-4448) Fix - Didn't move accurately work when aligning the top of pipe with the bottom of a trapeze (11' 10 3/8") (2): alignment calculation fix
- [KTR5-4255](https://linear.app/jhkelly/issue/KTR5-4255) Add - New Tool To Find deprecated fab parts (ITMs) that no longer match a fab part (8): new tool needing fabrication configuration
- [KTR5-4256](https://linear.app/jhkelly/issue/KTR5-4256) Add - New Tool to delete shared parameters from projects (4): one tool with selection list and delete
- [KTR5-4478](https://linear.app/jhkelly/issue/KTR5-4478) Change - KTR-3D Visibility Graphics (Ease Up On Loading...) (2): title only, view template or filter change
- [KTRUI-1](https://linear.app/jhkelly/issue/KTRUI-1) Review the Kelly-Revit-UI controls for improvements (4): open-ended review of six XAML controls in src/Controls plus follow-up fixes
- [KTRL5-5](https://linear.app/jhkelly/issue/KTRL5-5) Handle the open // todo notes in Kelly-Revit-Logic-v5 (16): 45 todo comments in 23 src files; split per area
- [KTR4-26](https://linear.app/jhkelly/issue/KTR4-26) Decide the status colors (success, warning, danger) (4): decision plus changes to Kelly-Windows-v2 QualityCheckColors and MatchColors and OletCheckViewModel; lower-layer pack likely shared with KTR4-24
- [KTR4-18](https://linear.app/jhkelly/issue/KTR4-18) Are there any TODO notes that can be handled? (16): 122 todo comments in the add-in (135 across v4); split into themed issues
- [KTRL4-1](https://linear.app/jhkelly/issue/KTRL4-1) Are there any TODO notes that can be handled? (4): 11 todo comments in Kelly-Revit-Logic-v4, then a pack and repin if code changes
- [KW3-4](https://linear.app/jhkelly/issue/KW3-4) Improve the progress bar service (ProgressReporter, Kelly.Windows.Wpf) (4): title-only; ProgressReporter and its extensions are two types
- [KD-10](https://linear.app/jhkelly/issue/KD-10) Implement the FractionalLength struct for fractional feet and inches (1): struct already implemented and moved to Kelly-Windows-v3; close or move the item
- [HASA-71](https://linear.app/jhkelly/issue/HASA-71) Other ways to view the data: mind map, area → noun → task, task → noun → area (16): text only: three new views incl. mind map on several platforms; split
- [HASA-72](https://linear.app/jhkelly/issue/HASA-72) Kits: groups of nouns, such as a workstation (8): text only: new kit entity with membership table, RPCs and UI; design still open
- [HASA-54](https://linear.app/jhkelly/issue/HASA-54) Find and replace, in a selection or everywhere (8): text only: replace RPC over several fields plus selection-aware UI on every app
- [HASA-65](https://linear.app/jhkelly/issue/HASA-65) Fill in Made by and Model from a noun's name (4): text only: name parsing against makers plus suggestion UI; rules vs AI undecided
- [HASA-52](https://linear.app/jhkelly/issue/HASA-52) Export tasks to other task apps (Todoist, TickTick, …) (8): text only: mapping and export/sync to several third-party apps; scope undecided

## Proposed at 16: split into sub-issues

- [KTR5-4689](https://linear.app/jhkelly/issue/KTR5-4689) Implement the Unit Test Implementation plan for Kelly Tools For Revit
- [KTR5-4679](https://linear.app/jhkelly/issue/KTR5-4679) Run the IA Prompt architectural analysis and cleanup
- [KTR5-4678](https://linear.app/jhkelly/issue/KTR5-4678) Refactor and clean up the Vicious tools
- [KTR5-3827](https://linear.app/jhkelly/issue/KTR5-3827) Tool to create an offset in a pipe run so that the complex multistep manual work is eliminated
- [KTR5-4170](https://linear.app/jhkelly/issue/KTR5-4170) Change - Implement IEqualityComparer<object>() Interface in place of "Signature"
- [KTR5-3144](https://linear.app/jhkelly/issue/KTR5-3144) Assembly Creator to geometrically alter all "Family Instances" a miniscule amount so it doesn't fail the Assembly creation process.
- [KTR5-3279](https://linear.app/jhkelly/issue/KTR5-3279) Needs better property validation system such as the Fluent system i implemented in the Module Manager Tool
- [KTR5-4480](https://linear.app/jhkelly/issue/KTR5-4480) Change - Operation/Project Bar Implenations
- [KTRL5-5](https://linear.app/jhkelly/issue/KTRL5-5) Handle the open // todo notes in Kelly-Revit-Logic-v5
- [KTRL5-3](https://linear.app/jhkelly/issue/KTRL5-3) Move the 80 OperationService call sites to Run and Run<T>
- [KTRL5-1](https://linear.app/jhkelly/issue/KTRL5-1) Remove this layer's copies of the code moved down on 2026-11-04
- [KTR4-18](https://linear.app/jhkelly/issue/KTR4-18) Are there any TODO notes that can be handled?
- [KW3-1](https://linear.app/jhkelly/issue/KW3-1) Repoint the layers above to the helpers moved down in round 2 (#2 to #18)
- [HASA-71](https://linear.app/jhkelly/issue/HASA-71) Other ways to view the data: mind map, area → noun → task, task → noun → area
- [HASA-62](https://linear.app/jhkelly/issue/HASA-62) A parallel web app built with .NET Blazor
