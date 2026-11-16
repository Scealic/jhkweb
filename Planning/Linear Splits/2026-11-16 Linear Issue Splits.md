# 2026-11-16 Linear Issue Splits

Scope: [KTR5-4869](https://linear.app/jhkelly-ktr/issue/KTR5-4869) only, asked for by the maintainer on 2026-11-16. Design settled the same day: the user picks a parameter, added contexts are saved per project, and they show in both panes just above the All row.

| Team | Open issues reviewed | Fine | Split | Unclear | New issues proposed | Existing issues to link |
|---|---|---|---|---|---|---|
| KTR5 | 1 | 0 | 1 | 0 | 5 (4 KTR5, 1 KTRL5) | 0 |

## [KTR5-4869](https://linear.app/jhkelly-ktr/issue/KTR5-4869): Assigners panes: Add Context button for a user-picked parameter, saved per project (8)

- **Signals:**
  - **Crosses layers.** The per-project storage belongs in Kelly.Revit.Logic, which has no code for saving data in a project file yet. `DocumentSchemaExtensions` only finds and erases schemas. That storage must be packed and repinned before the add-in can save added contexts.
  - **Several independent deliverables:**
    - a context definition built from any parameter;
    - rows that can be added and removed at run time (today `AssignerPaneViewModel.Rows` is fixed in the constructor);
    - the picker and button in both panels;
    - saving the added contexts with the project.
- **Shape:** sub-issues.
- **The original keeps:** parent only. Its title and goal stay, and it loses its estimate.

| # | Team | Title | Est. | Relation | Goal |
|---|---|---|---|---|---|
| 1 | KTRL5 | Project-level storage: read and write a list of strings saved in the project file | 2 | sub-issue; blocks 5 | A small extensible-storage helper: one `DataStorage` element per schema GUID, holding a list of strings, written in one transaction. The add-in saves its added contexts there. |
| 2 | KTR5 | Assigners panes: a context definition for any user-picked parameter | 2 | sub-issue | `AssignerContexts.ForParameter`: an `AssignerContextDefinition` built from a project or shared text parameter. Its value list comes from the project's values, it takes any non-empty typed value, and Adopt, Add To, Remove From, Hide and Isolate work on that parameter. No Auto-Assign. |
| 3 | KTR5 | Assigners panes: add and remove context rows at run time | 4 | sub-issue | `AssignerPaneViewModel.Rows` becomes observable. `AddContext` inserts a row just above All and `RemoveContext` takes out a user-added row (built-in rows can't be removed). Choices, value lists and the All commands follow. Pane B's wrapped rows follow too. |
| 4 | KTR5 | Assigners panes: Add Context button and parameter picker in both panes | 2 | sub-issue | An Add Context button on Option A's All row and in Option B's action area opens a picker of the project's text parameters bound to model categories. Each user-added row gets a way to remove it. |
| 5 | KTR5 | Assigners panes: save the added contexts with the project and restore them | 2 | sub-issue; blocked by 1 | On Add or Remove Context, write the parameter names to the project through the new storage. When a project becomes active, rebuild its added rows, and skip a parameter the project no longer has. Needs the Kelly.Revit.Logic package with piece 1 packed and repinned. |

Order: 1 first, because it needs a pack and repin. Pieces 2, 3 and 4 don't wait on it, so they can go ahead at the same time. 5 comes last.

All pieces: type Add, function "Tools, ribbon and UI" (KTR5) or the matching KTRL5 function label, priority Medium, project "Dockable Assigner System" where the team is in it, assignee the maintainer. The KTR5 pieces get the "Dockable Assigner" feature label and the "Trade.All" module label.

## Unclear

None.

## Open questions

- **Removing a user-added row:** a remove (×) button on the row, or a right-click menu on its label?
- **Where the added contexts are saved:** a hidden extensible-storage entity in the project (recommended: it needs no new shared parameter and isn't shown to users), or a text parameter on Project Information?
