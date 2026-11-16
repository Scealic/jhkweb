# Linear Issue Splits, 2026-11-16 (KTR5-4869)

| Team | Reviewed | Fine | Split | Unclear | New issues | Existing to link |
|---|---|---|---|---|---|---|
| KTR5 | 1 | 0 | 1 | 0 | 4 (3 KTR5, 1 KTRL5) | 0 |

## [KTR5-4869](https://linear.app/jhkelly-ktr/issue/KTR5-4869) Assigners panes: Add Context button for a user-picked parameter, saved per project (8)

Signals: crosses layers (per-project storage in Kelly.Revit.Logic, then pack and repin); several deliverables (storage, generic definition, run-time rows, picker and button). Shape: sub-issues. Keep: parent only.

| # | Team | Title | Est. | Relation | Goal |
|---|---|---|---|---|---|
| 1 | KTRL5 | Project storage for a list of named parameters (extensible storage) | 2 | sub-issue; blocks 4 | Read and write a per-project list of parameter names in the project file, one operation, with tests |
| 2 | KTR5 | Assigners: context definition built from a picked text parameter | 4 | sub-issue; blocks 4 | `AssignerContextDefinition` factory: values from the project, any non-empty typed text, Adopt, Add To, Remove From, Hide and Isolate filters, no Auto-Assign |
| 3 | KTR5 | Assigners: add and remove context rows at run time, above All | 2 | sub-issue; blocks 4 | `AssignerPaneViewModel` rows change at run time; both panes show the change; B's row selection survives |
| 4 | KTR5 | Assigners: Add Context button, parameter picker and row removal | 4 | sub-issue | Button in both panels, picker of the project's text parameters bound to model categories, remove button on added rows, saved through 1 and reloaded on project open; checked in Revit 2024 |

Open question: removing an added row — a remove button on the row (drafted) or a context menu.
