# KTR5: projects to feature labels (plan, 2026-11-04)

Status: **draft for review. Nothing has been changed in Linear.**

## Goal

Every KTR5 issue can be tied to the feature (command, user control, cache, event handler or service) it concerns, and to more than one when it spans
several. Projects go back to what Linear means them for: bounded work that starts and ends.

## What KTR5 has now

- 151 projects (P-KTR5-2 to P-KTR5-171). 146 are one per feature, named `<Feature> (Command)`, `(User Control)`, `(Document Cache)`,
  `(Application Cache)`, `(Event Handler)` or `(Service)`; nearly all "In Progress" for good, with no dates, milestones or summary beyond "Role: …".
- "General" is a catch-all (release checklists, code-style items, shared parameters).
- About 600 issues in KTR5; about 110 are open. 70 open issues have no project, most of them about one or more named features
  (for example the 13 Layout Point Export fixes).
- An issue can be in one project only, so an issue spanning tools (KTR5-4698 touches four) cannot point at all of them.

## Label limits in Linear (and the check to run first)

- A label group holds **at most 250 labels**: 146 feature labels fit.
- Linear's labels page says **only one label per group** can be on an issue. The workspace's label API reports a group type (`singleSelect`), and
  initiative label groups can be switched to multi-select, so issue label groups may now allow it too. **Step 0 checks this** on one test
  issue before anything else.
  - **Multi-select works:** use a label group "5 - Feature" (this plan).
  - **Single-select only:** use ungrouped team labels prefixed `F: ` (`F: Spool Manager`). They sort together in the picker, and an issue can carry
    several. Everything else in this plan stays the same.

## Naming

- Label = project name without ` (Command)`; other kinds keep their suffix (`Scope (User Control)`, `Document Opened (Event Handler)`).
- `Valve Tag Assign (Idea) (Command)` → `Valve Tag Assign`; `Stratus Package Quality Check View Creator?` → `Stratus Package Quality Check View Creator`;
  `Auto Updater Configurations` → `Auto Updaters`; `Dockable Assigner System` → `Dockable Assigner`.
- No collisions with existing labels ("General" is the Role label; the General project gets no feature label).

## Projects

### Keep as projects (bounded new work still open), and give them their feature label too

| Project | Open issues |
|---|---|
| Spool Creator V2 (Command) | KTR5-3800, 3924, 3932, 3933, 3934, 3935 |
| Duct QA Length (Command) | KTR5-4119, 4125, 4126, 4127, 4128 |
| Duct QA Mirror (Command) | KTR5-4120, 4121, 4122, 4123, 4124 |
| Pipe Offset Create (Command) | KTR5-3827, 4719 |
| Dockable Assigner System | KTR5-4085 |
| Valve Tag Assign (Idea) (Command) | KTR5-3839 |
| Element Select By Context (Command) | KTR5-4009 |
| Stratus Detailing Package Views Create With User Interface (Command) | KTR5-4028 |
| Detailer View 3D Create (Command) | KTR5-4029 |
| Family Instance End Swap (Command) | KTR5-3829 |
| Auto Updater Configurations | KTR5-3142, 3810, 4077 |
| Project Session (Service) (the SQL deprecation; close it when done) | KTR5-4510, 4513, 4514, 4515 |

Suggested: drop the ` (Command)` suffix from the names of the kept projects and give each a target date. Optional, not part of this plan.

### Archive after relabelling (no label)

| Project | Why |
|---|---|
| General | Catch-all, not a feature. Its open issues get feature labels where one fits (table below), otherwise none. |
| Project Report SQL Export (Command) | Only a canceled issue; v5 no longer reaches SQL Server. |
| Global (Command) | No issues, and unclear what feature it is. **Question 1.** |

### Archive after relabelling (feature label created)

All the other 134 projects, among them: every Assigner command (System, Service, Line Number, Module Number, Spool Number, Detailing Package × Value
Set / Value Reset / Value Adopt / Tool Reset / Hide View Filter / Isolate View Filter / Auto Assign Switch), All Assigner Reset, the color view
filters, the Vicious tools, Spool Creator V1, Spool Manager, Spool Cleaner, Module Create, Module Manager, Suspended Support Manager, Layout Point
Export / Import / File Directory Open, Grid Layout Point Place / Update, the Trapeze tools, Manual Updater, Auto Updater State Report / Toggle,
the View Schedule exports, Definition Create / Update / Delete, the Document Caches and Application Caches, Scope and Element Select Zoom (User
Controls), Document Opened / Saved (Event Handlers), Progress Bar and Document Operation (Command Services), Application Service, Reload Data, Olet
Checker, Custom Data Property Update V1 / V2, Proposed Custom Data Values Report, and the Developer and Content tools.

## Issues

### Every issue in a feature project gets that feature's label

All of them, open and closed (about 430 issues), so filtering by a feature also shows its history. The project field of **open** issues in archived
projects is cleared; closed issues keep it. **Question 2.**

Extra labels on open project issues that cover more than their project:

| Issue | Project now | Labels |
|---|---|---|
| KTR5-4064 Assigners: refuse to turn on an auto-assigner while its value is the default | Detailing Package Assigner Auto Assign Switch | + System, Service, Line Number Assigner Auto Assign Switch |

### Open issues with no project, or in General, that get feature labels

| Issue | Title (short) | Feature labels |
|---|---|---|
| KTR5-4662 | Racker: will not open when a Straights item has no level | Vicious Straights Racker |
| KTR5-4631 | Racker: Bottom/Top align buttons overwrite the typed elevation | Vicious Straights Racker |
| KTR5-4661 | Racker: user cancel ends as Failed | Vicious Straights Racker |
| KTR5-4715 | Vicious Straights Racker: clean up the view model | Vicious Straights Racker |
| KTR5-4653 | Level Correct: element with no category throws | Vicious Instance Level Assign |
| KTR5-4654 | Level Correct: no model elements gives raw error | Vicious Instance Level Assign |
| KTR5-4718 | Vicious Instance Level Assign and Instance Disconnect: clean up | Vicious Instance Level Assign, Vicious Instance Disconnect |
| KTR5-4717 | Vicious Fabrication Hanger Place: clean up | Vicious Fabrication Hanger Instance Place |
| KTR5-4716 | Vicious Instance Rotate Move: clean up | Vicious Instance Rotate Move |
| KTR5-4713 | Vicious Point To Pipe: code-behind into the view model | Vicious File Based System Pipe Place |
| KTR5-4714 | Vicious Point To Pipe: break up the tools class | Vicious File Based System Pipe Place |
| KTR5-4644 | Point to Pipe: typed Point File path ignored | Vicious File Based System Pipe Place |
| KTR5-4645 | Point to Pipe: units boxes always start at Inches and Feet | Vicious File Based System Pipe Place |
| KTR5-4682 | Point to Pipe: use the PointToPipeUnits constants | Vicious File Based System Pipe Place |
| KTR5-4724 | Point to Pipe: call the Kelly.Domain PCF and settings rules | Vicious File Based System Pipe Place |
| KTR5-4720 | Point to Pipe and Rotate Move: call the Kelly.Windows helpers | Vicious File Based System Pipe Place, Vicious Instance Rotate Move |
| KTR5-4678 | Refactor and clean up the Vicious tools | the 7 Vicious labels |
| KTR5-4635, 4638, 4639, 4640, 4641, 4649, 4650, 4651, 4652 | Layout Point Export fixes | Layout Point Export |
| KTR5-4636, 4642 | Layout Point Import fixes | Layout Point Import |
| KTR5-4722 | Layout Point Export and Import: call the Kelly.Domain rules | Layout Point Export, Layout Point Import |
| KTR5-4721 | Layout Point Export, About and App: Kelly.Windows helpers | Layout Point Export, Application About |
| KTR5-4637, 4646, 4665 | Spool Manager fixes | Spool Manager |
| KTR5-4663, 4664 | Spool Creator fixes | Spool Creator V1 |
| KTR5-4723 | Spool Create and Module Creator: Kelly.Domain rules | Spool Creator V1, Module Create |
| KTR5-4656 | Module Creator: DEFAULT placeholder prefix | Module Create |
| KTR5-4657, 4658 | Module Manager fixes | Module Manager |
| KTR5-4624, 4647, 4648, 4666, 4667 | Suspended Support Manager | Suspended Support Manager |
| KTR5-4706 (General) | Per-element catch in the spool and support managers | Spool Manager, Suspended Support Manager |
| KTR5-4697 (General) | Fabrication Part Dimension Log and Suspended Support Manager: use the comparers | Fabrication Part Dimension Log, Suspended Support Manager |
| KTR5-4698 | OperationService.Run: Layout Point Export, Module Manage, Spool Create, Support Manager | Layout Point Export, Module Manager, Spool Creator V1, Suspended Support Manager |
| KTR5-4700 | OperationService.Run: decide Many Connect, Custom Data Updater V2, Layout Point CSV, Spool Create | Many Connect, Custom Data Property Update V2, Layout Point Import, Spool Creator V1 |
| KTR5-4725 | Weld Location Set, Hanger Place, Proposed Report: Domain rules | Weld Location Set, Vicious Fabrication Hanger Instance Place, Proposed Custom Data Values Report |
| KTR5-4643, 4659, 4660 | Olet Check fixes | Olet Checker |
| KTR5-4655 | Line Number Selector: Add Context Value check box label | Context Value Create |
| KTR5-4618 | Enable the ProjectInformationEditor for project shared parameters | Document Information Manager |
| KTR5-4625 | Scope control in every window that lacks it | Scope (User Control) |
| KTR5-4478 | KTR-3D view: do less on document open | Document Opened (Event Handler) |
| KTR5-4494 | IUpdaters: analyze what each updater needs | Auto Updaters |
| KTR5-4726 | Deprecate the Component and Product IUpdaters and Manual Updaters | Auto Updaters, Manual Updater |

### Open issues that need your call (Question 3)

| Issue | Title (short) | Suggestion |
|---|---|---|
| KTR5-4626 | Order the User Domain Report by EmployeeId | New label "User Domain Report" (no project exists) |
| KTR5-4668 | Windows Mockup: product-code list goes blank | New label "Window Mockup"? |
| KTR5-4496 | Family Version tool: fails on nested families | Family Revision Setter, or a new label? |
| KTR5-4256 | Content cleanup: remove unused JHK shared parameters from a project | Unused Shared Parameter Element Delete, or a new tool? |
| KTR5-4255 | Content cleanup: fabrication parts whose ITM is gone | New label (new tool)? |
| KTR5-4174 | Welds: write the joined parts' material type and wall thickness | Auto Updaters, or a new label? |
| KTR5-4704 (General) | Per-element catch in the Trade.All color filter assigners | All the color view filter labels, or none? |
| KTR5-3937 (General) | BIM Lite: still wanted? | New label "BIM Lite"? |

### Open issues that stay without a feature label (cross-cutting)

Function labels already place these: KTR5-4480, 4136, 4170, 4175, 2967, 3831, 4322, 4110, 2434, 4493, 4517 to 4521, 4707 (General); 4525, 4580, 4581,
4582, 4596, 4597, 4601, 4602, 4604, 4608, 4609, 4610, 4621, 4623, 4627, 4630, 4632, 4633, 4634, 4680, 4681, 4685, 4689, 4693, 4694, 4696, 4703, 4705,
4708 to 4712 (no project).

## Steps, after approval

0. Check multi-select: create the group "5 - Feature" with two labels, try both on one test issue, then remove the test labels. Choose the group or
   the `F: ` fallback.
1. Create the 146 feature labels (plus any new ones from Question 3).
2. Label every issue of each feature project (about 430 issues; batches per project).
3. Label the open issues in the tables above.
4. Clear the project of open issues in projects being archived.
5. Archive the 137 projects (134 feature, General, Project Report SQL Export, Global). Kept projects stay.
6. Update the `kelly-linear-projects` skill (and its line in `.claude/CLAUDE.md`): features are labels in "5 - Feature" and projects are bounded
   work only. Make `kelly-backlog-update` and the other `linear-issue-*` skills set a feature label when an issue names a tool.
7. Spot-check: filter KTR5 by three feature labels and compare with the old project counts.

## Option: sub-teams by trade module

The add-in is a host plus one DLL per ribbon tab (Trade.All, Trade.Pipe, Trade.Duct, Contenter, Manager, Developer), so KTR5 could get sub-teams
(KTR5-All, KTR5-Pipe, …), as KTR4 already has.

- **For:** each module gets its own backlog and board; each module's feature labels live in its own sub-team, so every picker is short (the parent
  team still sees them all, and sub-teams inherit the parent's labels); it matches the code and KTR4.
- **Against:** an issue belongs to one team only, so issues across modules (KTR5-4698, the OperationService and test items) and everything in the host,
  caches, services and controls stay in the parent team; Trade.All holds most of the features, so the split is lopsided; each sub-team adds
  workflow, cycle and estimate settings to keep in step, for one maintainer.
- **Cheaper alternative:** a single-select label group "5 - Module" (All, Pipe, Duct, Contenter, Manager, Developer, Host) gives the same filtering
  without moving issues.

Sub-teams do not replace feature labels: features stay labels either way. If sub-teams are chosen, step 1 creates each feature label in its
module's sub-team and the issues move to that sub-team first.

## Questions

1. **Global (Command)**: which feature is it, or should it go?
2. **Closed issues**: label them too (history by feature, about 320 extra updates), or open issues only?
3. **The eight issues above**: which labels?
4. **Modules**: sub-teams per trade module, a "5 - Module" label group, or neither?
5. **Other Kelly teams** (KTR4 and its sub-teams, KW*, KWD*, KD): do the same there after KTR5?
