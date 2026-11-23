# Linear Issue Splits, 2026-11-23

Split review of every open issue in the Kelly teams of "Virtual Construction". Read-only proposal: nothing in Linear has changed. Each team was reviewed from its code by a Sonnet reviewer, and the results were checked here.

Not reviewed: KTR4 and KTRL4 (rule: no Major Version 4 Kelly Tools For Revit work), KRDE and CDEB (no open issues), Hasa (no such team). KWD2 and KW2 were judged from the text only (their repositories are not checked out). Parents that still have open sub-issues were skipped, and their sub-issues reviewed instead.

## Summary

| Team | Open reviewed | Fine | Split | Unclear | New issues proposed | Existing to link |
|---|---|---|---|---|---|---|
| KTR5 | 258 | 242 | 11 | 5 | 41 | 5 |
| KTRL5 | 82 | 77 | 5 | 0 | 15 | 2 |
| KTRUI | 12 | 10 | 1 | 1 | 3 | 0 |
| KD | 42 | 39 | 1 | 2 | 3 | 0 |
| KW3 | 25 | 21 | 3 | 1 | 9 | 1 |
| KWD3, KWDC, KWDJ, KWDSS, KWDSL, KWDE, KWD2, KW2 | 20 | 20 | 0 | 0 | 0 | 0 |
| FKS | 26 | 24 | 1 | 1 | 4 | 1 |
| CDED, CDEC | 13 | 13 | 0 | 0 | 0 | 0 |
| **Total** | **478** | **446** | **22** | **10** | **75** | **9** |

"New issues proposed" counts the pieces under the team of the issue being split. Some pieces go to a lower-layer team, as the tables show.

Kept whole although a reviewer offered a split: [KWDC-5](https://linear.app/jhkelly-ktr/issue/KWDC-5) (2 points), [KWDSS-6](https://linear.app/jhkelly-ktr/issue/KWDSS-6) (4 points, one project), [KTRUI-10](https://linear.app/jhkelly-ktr/issue/KTRUI-10) (4 points, one test project), [KW3-50](https://linear.app/jhkelly-ktr/issue/KW3-50) (a rename with its callers).

## KTR5

### [KTR5-3936](https://linear.app/jhkelly-ktr/issue/KTR5-3936) CSV writing: replace CsvHelper (8)

Signals: crosses three repositories. Shape: sub-issues. Keep: parent only.

| # | Team | Title | Est. | Relation | Goal |
|---|---|---|---|---|---|
| 1 | KD | `LayoutPointCsvFormat`: read and write CSV without CsvHelper | 2 | sub-issue, blocks 2 | use `Kelly.Windows.Data.Csv` in `src/LayoutPoints/LayoutPointCsvFormat.cs` |
| 2 | KTRL5 | Layout point and Point To Pipe readers: drop CsvHelper | 2 | sub-issue, blocks 3 | `LayoutPointTools`, `PointToPipeReader`; after the Kelly-Domain repin |
| 3 | KTR5 | Add-in: remove the CsvHelper package reference | 1 | sub-issue | `Directory.Packages.props`, `src/Core.csproj`, `AddInContractTests`; after the Logic repin |

### [KTR5-4322](https://linear.app/jhkelly-ktr/issue/KTR5-4322) XAML views: one command per Click instead of several EventBindings (8)

Signals: sweep over 9 views. Shape: sub-issues. Keep: parent only.

| # | Team | Title | Est. | Relation | Goal |
|---|---|---|---|---|---|
| 1 | KTR5 | Spool and module views: one Click command instead of stacked EventBindings | 4 | sub-issue | Spool Create, Spool Manager, Module Creator, Module Manage |
| 2 | KTR5 | Layout point and support views: one Click command instead of stacked EventBindings | 2 | sub-issue | Layout Point Export and Import, Suspended Support Manage |
| 3 | KTR5 | Vicious views: one Click command instead of stacked EventBindings | 2 | sub-issue | Instance Level Assign, Straights Racker |

### [KTR5-4175](https://linear.app/jhkelly-ktr/issue/KTR5-4175) Code style: initialize collections where they are declared (8)

Signals: sweep over about 60 sites in 6 repositories. Shape: sub-issues, one per repository (no order between them). Keep: parent only.

| # | Team | Title | Est. | Relation | Goal |
|---|---|---|---|---|---|
| 1 | KTR5 | Add-in: initialize collections at their declaration | 4 | sub-issue | about 34 sites in `modules/` and `src/` |
| 2 | KTRL5 | Kelly-Revit-Logic: initialize collections at their declaration | 2 | sub-issue | about 12 sites |
| 3 | KTRUI | Kelly-Revit-UI: initialize collections at their declaration | 1 | sub-issue | about 7 sites |
| 4 | KD | Kelly-Domain: initialize collections at their declaration | 1 | sub-issue | about 3 sites |
| 5 | KW3 | Kelly-Windows: initialize collections at their declaration | 1 | sub-issue | about 2 sites |
| 6 | KWD3 | Kelly-Windows-Data: initialize collections at their declaration | 1 | sub-issue | about 3 sites |

### [KTR5-2461](https://linear.app/jhkelly-ktr/issue/KTR5-2461) Definitions: remove the "I" suffix from definition names (8)

Signals: crosses the exporter, Kelly-Domain and the add-in; old projects are their own deliverable. Shape: mixed. Keep: parent only.

| # | Team | Title | Est. | Relation | Goal |
|---|---|---|---|---|---|
| 1 | KRDE | Exporter: write definition names without the "I" suffix | 2 | sub-issue, blocks 2 | exported definitions data has no names ending in "I" |
| 2 | KD | Definition name constants and caches: drop the "I" suffix | 2 | sub-issue | `Names`, `ExternalParameterDefinitionCache` |
| 3 | KTR5 | Projects with parameters under the old "I" names still resolve | 4 | related | migration or fallback (see question) |

### [KTR5-3833](https://linear.app/jhkelly-ktr/issue/KTR5-3833) Scope control: filter the consuming grid instead of building a list (8)

Signals: crosses Kelly-Revit-UI and the add-in; 8 windows. Shape: sub-issues. Keep: parent only.

| # | Team | Title | Est. | Relation | Goal |
|---|---|---|---|---|---|
| 1 | KTRUI | `ScopeControl`: expose the in-scope test so a grid can filter on it | 2 | sub-issue, blocks 2 and 3 | predicate and change event instead of a copied list |
| 2 | KTR5 | Spool, module, support and layout point windows: grids filter by scope | 4 | sub-issue | after the Kelly-Revit-UI repin |
| 3 | KTR5 | Duct, Pipe and Developer windows: grids filter by scope | 2 | sub-issue | Duct Length Check, Duct Mirror Check, Olet Check, Window Mockup |

### [KTR5-4630](https://linear.app/jhkelly-ktr/issue/KTR5-4630) Take all push button names from a names property (8)

Signals: sweep over about 59 literals in 5 modules, plus a second deliverable. Shape: sub-issues. Keep: parent only.

| # | Team | Title | Est. | Relation | Goal |
|---|---|---|---|---|---|
| 1 | KTR5 | Trade.All push buttons: take `Text` from `PushButtonText` | 4 | sub-issue | 22 literals |
| 2 | KTR5 | Trade.Developer push buttons: take `Text` from `PushButtonText` | 2 | sub-issue | 16 literals |
| 3 | KTR5 | Contenter, Pipe, Manager and Duct push buttons: take `Text` from `PushButtonText` | 2 | sub-issue | about 21 literals |
| 4 | KTR5 | Transaction names: use the push button's `PushButtonText` name | 4 | sub-issue, blocked by 1 to 3 | Undo and log names match the button; contract test |

### [KTR5-4625](https://linear.app/jhkelly-ktr/issue/KTR5-4625) Implement the scope control in every window that doesn't have it (8)

Signals: sweep over 14 windows in several modules. Shape: sub-issues. Keep: parent only. Only windows that list elements get the control.

| # | Team | Title | Est. | Relation | Goal |
|---|---|---|---|---|---|
| 1 | KTR5 | Trade.All windows with an element list: add the scope control | 4 | sub-issue | view models react to `Scope` |
| 2 | KTR5 | Duct, Pipe, Contenter and Developer windows with an element list: add the scope control | 2 | sub-issue | same pattern |

Existing: [KTR5-3833](https://linear.app/jhkelly-ktr/issue/KTR5-3833), [KTR5-3281](https://linear.app/jhkelly-ktr/issue/KTR5-3281) as Related.

### [KTR5-4626](https://linear.app/jhkelly-ktr/issue/KTR5-4626) Order the User Domain Report by EmployeeId (8)

Signals: crosses layers. Shape: sub-issues. Keep: parent only. (Small once split: 3 points in all.)

| # | Team | Title | Est. | Relation | Goal |
|---|---|---|---|---|---|
| 1 | KW3 | `DomainGroupReport.BuildMemberReport`: read EmployeeId and order by it | 2 | sub-issue, blocks 2 | `src/Workstation/DomainGroupReport.cs` with tests |
| 2 | KTR5 | User Report: show members ordered by EmployeeId | 1 | sub-issue | after the Kelly-Windows repin |

### [KTR5-4883](https://linear.app/jhkelly-ktr/issue/KTR5-4883) Hands-on check of every tool closed on 2026-11-17 (8)

Signals: several deliverables (a checklist of about 40 lines). Shape: sub-issues. Keep: parent only. The "Outside Revit" lines ([KWDSS-10](https://linear.app/jhkelly-ktr/issue/KWDSS-10), [CDED-1](https://linear.app/jhkelly-ktr/issue/CDED-1), [CDEC-7](https://linear.app/jhkelly-ktr/issue/CDEC-7)) move to comments on those issues.

| # | Team | Title | Est. | Relation | Goal |
|---|---|---|---|---|---|
| 1 | KTR5 | Hands-on check: Assigners pane fixes of 2026-11-17 | 2 | sub-issue | 10 lines |
| 2 | KTR5 | Hands-on check: Support Manager, Spool, Layout Point and Racker fixes | 2 | sub-issue | 7 lines |
| 3 | KTR5 | Hands-on check: renamed tools open with correct bindings and texts | 2 | sub-issue | 10 lines |
| 4 | KTR5 | Hands-on check: Duct QA Length and Duct QA Mirror on a Developer install | 1 | sub-issue | 2 lines |
| 5 | KTR5 | In-Revit runs: complete Kelly-Revit suite and full Logic suite | 2 | sub-issue | no hand check |

### [KTR5-4896](https://linear.app/jhkelly-ktr/issue/KTR5-4896) View models take Telerik grids and controls as command parameters (8)

Signals: several tools (7 view models); the issue itself says split per tool. Shape: sub-issues. Keep: parent only.

| # | Team | Title | Est. | Relation | Goal |
|---|---|---|---|---|---|
| 1 | KTR5 | View models: `SelectedItems` behaviour and `RequestClose` event | 2 | sub-issue, blocks 2 to 6 | the pattern the others use |
| 2 | KTR5 | Spool Manager: view model without Telerik grid command parameters | 4 | sub-issue | about 15 handlers, 31 parameters |
| 3 | KTR5 | Module Manager and Spool Creator: view models without Telerik controls | 2 | sub-issue | 4 handlers |
| 4 | KTR5 | Layout Point Import and Export: view models without `FindName` and window calls | 4 | sub-issue | 46 parameters |
| 5 | KTR5 | Suspended Support Manager: view model without Telerik control parameters | 2 | sub-issue | 14 parameters |
| 6 | KTR5 | Vicious Straights Racker: `SetDesiredElevation` takes a typed value | 1 | sub-issue | 4 parameters |

Existing: [KTR5-4897](https://linear.app/jhkelly-ktr/issue/KTR5-4897) Related to piece 5; [KTRUI-25](https://linear.app/jhkelly-ktr/issue/KTRUI-25) and [KTR5-4787](https://linear.app/jhkelly-ktr/issue/KTR5-4787) Related to the parent.

### [KTR5-4787](https://linear.app/jhkelly-ktr/issue/KTR5-4787) Commands: reduce the 49 uses of the concrete Command.UiDocument (8)

Signals: sweep over 14 files. Shape: sub-issues. Keep: parent only.

| # | Team | Title | Est. | Relation | Goal |
|---|---|---|---|---|---|
| 1 | KTR5 | Spool Manager: replace the 16 `Command.UiDocument` uses | 4 | sub-issue | injected document or scope |
| 2 | KTR5 | Spool Creator, Module Creator and Module Manager: replace `Command.UiDocument` | 2 | sub-issue | 13 uses |
| 3 | KTR5 | Layout Point Import and Export: replace `Command.UiDocument` | 2 | sub-issue | 9 uses |
| 4 | KTR5 | Support Manager, Vicious tools, About and Window Mockup: replace `Command.UiDocument` | 2 | sub-issue | 11 uses |

## KTRL5

### [KTRL5-93](https://linear.app/jhkelly-ktr/issue/KTRL5-93) Fabrication, geometry and MEP: move command database logic into Logic (8)

Signals: 8 commands. Shape: sub-issues. Keep: parent only. In Progress since 2026-11-07: check the commits for bullets that have already landed before creating pieces.

| # | Team | Title | Est. | Relation | Goal |
|---|---|---|---|---|---|
| 1 | KTRL5 | Vicious Rotate: move selection check, rotation and failure set-up into Logic | 4 | sub-issue | bullets #50, #55, #59 |
| 2 | KTRL5 | Fabrication Custom Data Updater V1 and V2: move write loop and messages into Logic | 2 | sub-issue | #51, #52 |
| 3 | KTRL5 | Product Code Check, Bill Of Material Shop Set, Coordinate Testing: move report text into Logic | 2 | sub-issue | #53, #54, #56 |
| 4 | KTRL5 | Vicious Point To Pipe and Valve Clearance Spheres: move placement and family lookup into Logic | 4 | sub-issue | #57, #58 |

### [KTRL5-2](https://linear.app/jhkelly-ktr/issue/KTRL5-2) Move DataFileService to Kelly-Domain (8)

Signals: crosses layers; 28 referencing files. Shape: sub-issues. Keep: parent only.

| # | Team | Title | Est. | Relation | Goal |
|---|---|---|---|---|---|
| 1 | KD | `DataFileService`: Domain type with the Revit version and validator injected | 4 | sub-issue, blocks 2 | new Revit-free type |
| 2 | KTRL5 | `DataFileService`: repoint users to the Domain type and delete the Logic copy | 4 | sub-issue, blocks 3 | after the Kelly-Domain repin |
| 3 | KTR5 | `App.cs`: repoint start-up wiring to the Domain `DataFileService` | 1 | sub-issue | after the Logic repin |

### [KTRL5-90](https://linear.app/jhkelly-ktr/issue/KTRL5-90) FabricationPartExtensions: 46 type checks (8)

Signals: sweep over 9 files. Shape: sub-issues. Keep: parent only.

| # | Team | Title | Est. | Relation | Goal |
|---|---|---|---|---|---|
| 1 | KTRL5 | `FabricationPartExtensions`: replace the type checks with a part kind lookup | 4 | sub-issue, blocks 2 and 3 | 29 checks in the type itself |
| 2 | KTRL5 | Fabrication part kind: convert the callers in Connectors, Elements and Signatures | 4 | sub-issue | 3 files |
| 3 | KTRL5 | Fabrication part kind: convert the callers in Spools, Updaters and Fabrication | 4 | sub-issue | 5 files |

### [KTRL5-42](https://linear.app/jhkelly-ktr/issue/KTRL5-42) Per-element catch in the other Logic change loops (4)

Signals: open-ended sweep. Shape: standalone. Keep: narrowed to "Per-element catch: Views and Layout Points change loops" (with [KTRL5-33](https://linear.app/jhkelly-ktr/issue/KTRL5-33)).

| # | Team | Title | Est. | Relation | Goal |
|---|---|---|---|---|---|
| 1 | KTRL5 | Per-element catch: Documents, Families and Projects change loops | 2 | related | with each site's `Run` move |
| 2 | KTRL5 | Per-element catch: MEP and Connectors change loops | 2 | related | same |

Existing: [KTRL5-40](https://linear.app/jhkelly-ktr/issue/KTRL5-40) (the helper) blocks both.

### [KTRL5-26](https://linear.app/jhkelly-ktr/issue/KTRL5-26) Spools: type JhkTag as Tag, give IsSpoolAble a result, plan a LineNumber type (4)

Signals: three deliverables. Shape: sub-issues. Keep: parent only.

| # | Team | Title | Est. | Relation | Goal |
|---|---|---|---|---|---|
| 1 | KTRL5 | `SpoolItem.JhkTag`: type it as the Kelly-Domain `Tag` | 2 | sub-issue | `src/Spools/SpoolItem.cs` |
| 2 | KTRL5 | `SpoolItem.IsSpoolAble`: return a result instead of filling a `StringBuilder` | 2 | sub-issue | same file |
| 3 | KTRL5 | `ItemNumber.LineNumber`: plan a line number type for HVAC and piping | 1 | sub-issue | decision; team per question |

## KTRUI

### [KTRUI-25](https://linear.app/jhkelly-ktr/issue/KTRUI-25) ViewModel does too much and doesn't implement IViewModel (8)

Signals: two deliverables; vague over a 366-line `src/Mvvm/ViewModel.cs`. Shape: sub-issues. Keep: parent only.

| # | Team | Title | Est. | Relation | Goal |
|---|---|---|---|---|---|
| 1 | KTRUI | `ViewModel`: implement the `IViewModel` lifecycle | 2 | sub-issue | lifecycle order enforced |
| 2 | KTRUI | `ViewModel`: move element queries and error display into injected services | 4 | sub-issue | |
| 3 | KTRUI | `ViewModel`: drop the `Command.UiDocument` dependency and the WPF tree walk | 2 | sub-issue | |

## KD

### [KD-51](https://linear.app/jhkelly-ktr/issue/KD-51) DefinitionRegistry and ServerData are global service locators (8)

Signals: crosses layers; vague over about 22 definition sets. `ServerData` no longer exists in any repository (checked 2026-11-23); the pieces cover `DefinitionRegistry` only. Shape: sub-issues. Keep: parent only.

| # | Team | Title | Est. | Relation | Goal |
|---|---|---|---|---|---|
| 1 | KD | `DefinitionSetCache<T>`: let the cached instance be reset | 2 | sub-issue | tests and data reload rebuild a set |
| 2 | KD | `DefinitionSetBase`: take the definition resolver as a constructor argument | 4 | sub-issue, blocks 3 | `DefinitionRegistry` stays the default |
| 3 | KTRL5 | Definition sets: pass the injected definition resolver | 2 | sub-issue | after the Kelly-Domain repin |

## KW3

### [KW3-1](https://linear.app/jhkelly-ktr/issue/KW3-1) Repoint the layers above to the helpers moved down in round 2 (8)

Signals: crosses four layers. Shape: sub-issues. Keep: parent only. Each piece first checks which of the 14 helpers still have copies in its layer.

| # | Team | Title | Est. | Relation | Goal |
|---|---|---|---|---|---|
| 1 | KD | Kelly-Domain: repoint to the `Kelly.Windows` round 2 helpers | 2 | sub-issue, blocks 2 | delete the copies, repin |
| 2 | KTRL5 | Kelly-Revit-Logic: repoint to the `Kelly.Windows` round 2 helpers | 4 | sub-issue, blocks 3 | after the Kelly-Domain repin |
| 3 | KTRUI | Kelly-Revit-UI: repoint to the `Kelly.Windows` round 2 helpers | 2 | sub-issue, blocks 4 | after the Logic repin |
| 4 | KTR5 | Add-in: repoint to the `Kelly.Windows` round 2 helpers | 4 | sub-issue | after the Kelly-Revit-UI repin |

### [KW3-7](https://linear.app/jhkelly-ktr/issue/KW3-7) Change Point3 to a struct (8)

Signals: crosses layers (files using `Point3`: Kelly-Windows 4, Kelly-Domain 25, Logic 4, none above). Shape: sub-issues. Keep: parent only.

| # | Team | Title | Est. | Relation | Goal |
|---|---|---|---|---|---|
| 1 | KW3 | `Point3`: change to a struct and fix its tests | 2 | sub-issue, blocks 2 | `src/Geometry/Point3.cs` |
| 2 | KD | Kelly-Domain: adapt to the `Point3` struct | 2 | sub-issue, blocks 3 | null checks and reference comparisons |
| 3 | KTRL5 | Kelly-Revit-Logic: adapt to the `Point3` struct | 2 | sub-issue | same |

### [KW3-54](https://linear.app/jhkelly-ktr/issue/KW3-54) Move the shared WPF style dictionaries to `Kelly.Windows` (4)

Signals: crosses layers. Shape: sub-issues. Keep: parent only.

| # | Team | Title | Est. | Relation | Goal |
|---|---|---|---|---|---|
| 1 | KW3 | `Kelly.Windows`: add the brand style dictionaries from Kelly-Revit-UI | 2 | sub-issue, blocks 2 | seven `.xaml` files |
| 2 | KTRUI | Views: merge the `Kelly.Windows` style dictionaries and delete the copies | 2 | sub-issue | after the Kelly-Windows repin |

Existing: [KTRUI-43](https://linear.app/jhkelly-ktr/issue/KTRUI-43) (same files) as Related.

## FKS

### [FKS-7](https://linear.app/jhkelly-ktr/issue/FKS-7) Brand styles, Windows High Contrast and text size (4)

Signals: several deliverables. Shape: sub-issues. Keep: parent only.

| # | Team | Title | Est. | Relation | Goal |
|---|---|---|---|---|---|
| 1 | FKS | Fabrication Tools: brand palette and shared styles in the shell and three views | 2 | sub-issue, blocks 2 to 4 | Related to [KW3-54](https://linear.app/jhkelly-ktr/issue/KW3-54) |
| 2 | FKS | Fabrication Tools: switch to Windows High Contrast colours while running | 2 | sub-issue | from Component-Data-Editor `AppTheme` |
| 3 | FKS | Fabrication Tools: follow the Windows text size setting | 2 | sub-issue | from Component-Data-Editor `TextScale` |
| 4 | FKS | Fabrication Tools: visible keyboard focus, label targets and access keys | 2 | sub-issue | three views |

## Unclear: run through `linear-issue-info-review` or `linear-issue-check-isdone` first

| Key | Title | Why |
|---|---|---|
| [KTR5-4796](https://linear.app/jhkelly-ktr/issue/KTR5-4796) | Ability To Rename A Spool (And Its members) | empty description, estimate 16, no labels |
| [KTR5-4845](https://linear.app/jhkelly-ktr/issue/KTR5-4845) | Duct QA Length: suggest straight lengths that cut waste | design still open; likely seams: Domain rules, Logic, Trade.Duct grid ([KTR5-4128](https://linear.app/jhkelly-ktr/issue/KTR5-4128)) |
| [KTR5-2958](https://linear.app/jhkelly-ktr/issue/KTR5-2958) | Module Manager: work on sheet metal (duct) projects | thin; unknown whether Logic changes too |
| [KTR5-4581](https://linear.app/jhkelly-ktr/issue/KTR5-4581) | Tool to recover OperationService logs | one-line description, estimate 8 |
| [KTR5-4680](https://linear.app/jhkelly-ktr/issue/KTR5-4680) | Are there any TODO notes that can be handled? | no `// todo` left in any v5 repository: probably done |
| [KTRUI-1](https://linear.app/jhkelly-ktr/issue/KTRUI-1) | Review the Kelly-Revit-UI controls for improvements | review with no findings yet; file findings as issues |
| [KD-52](https://linear.app/jhkelly-ktr/issue/KD-52) | Infrastructure in the domain | stale: `SqlServerService` gone, `USP_` only in XML docs; narrow to the four file readers |
| [KD-30](https://linear.app/jhkelly-ktr/issue/KD-30) | Are there any TODO notes that can be handled? | one note left (`BearerTypeTools.cs:58`): re-estimate 1 or close |
| [KW3-20](https://linear.app/jhkelly-ktr/issue/KW3-20) | Progress reporting: rename LoopBegin/LoopEnd/LoopSkipped | no v5 layer uses those names any more: probably done |
| [FKS-24](https://linear.app/jhkelly-ktr/issue/FKS-24) | Find the product sizes that need correcting, beyond syntax | correction rules with Vladimir not agreed yet |

## Decisions (2026-11-23)

1. [KTR5-4883](https://linear.app/jhkelly-ktr/issue/KTR5-4883): split by section into the five sub-issues.
2. [KTR5-2461](https://linear.app/jhkelly-ktr/issue/KTR5-2461): piece 3 resolves both names for a while; no project is rewritten.
3. [FKS-7](https://linear.app/jhkelly-ktr/issue/FKS-7): piece 1 copies the Component-Data-Editor styles now, with a note on [KW3-54](https://linear.app/jhkelly-ktr/issue/KW3-54).
4. [KTRL5-26](https://linear.app/jhkelly-ktr/issue/KTRL5-26): piece 3 (the `LineNumber` plan) goes to the KD team, as a sub-issue in Kelly-Domain.

## Open questions

5. [KTRL5-2](https://linear.app/jhkelly-ktr/issue/KTRL5-2): what the "populated during Revit startup" message becomes (left open in piece 1).
6. [KTR5-4787](https://linear.app/jhkelly-ktr/issue/KTR5-4787) and [KTR5-4896](https://linear.app/jhkelly-ktr/issue/KTR5-4896): the pieces of one tool touch the same files; they are proposed as separate issues, linked Related, to do together.
