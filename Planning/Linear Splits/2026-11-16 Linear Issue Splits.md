# Linear Issue Splits – 2026-11-16

Scope: one issue, [KTR5-4864](https://linear.app/jhkelly-ktr/issue/KTR5-4864), at the maintainer's request. The review was done in the main session, with no subagents.

| Team | Open issues reviewed | Fine | Split | Unclear | New issues proposed | Existing issues to link |
|---|---|---|---|---|---|---|
| KTR5 | 1 | 0 | 1 | 0 | 5 (4 KTR5, 1 KTRL5) | 2 ([KTR5-4596](https://linear.app/jhkelly-ktr/issue/KTR5-4596), [KTR5-4602](https://linear.app/jhkelly-ktr/issue/KTR5-4602)) |

## [KTR5-4864](https://linear.app/jhkelly-ktr/issue/KTR5-4864) – Settings system: application and tool settings for v5 (16 points)

- **Signals:** estimate at the top of the scale; crosses layers (a generic store in Kelly-Revit-Logic, host wiring and tools in Kelly-Revit); several independent deliverables (model, storage, service, tool migration, settings window).
- **Shape:** sub-issues. Together they deliver the goal.
- **Original keeps:** parent only. Its title and goal stay, and its estimate is removed (Linear rolls up the sub-issues).
- **What the code shows:**
  - `Kelly.Windows.Data.Json.JsonSettingsFile` (`TryRead`/`TryWrite`) already reads and writes one settings object as JSON, and Kelly-Revit-Logic already pins `Kelly.Windows.Data.Json`.
  - `KellyDirectories.GetOrCreateSettingsFilePath(Document, string)` (Logic, `Common/KellyDirectories.cs`) gives a per-project settings path.
  - Spool Creator (`SpoolCreateViewModel`) and Module Creator (`ModuleCreatorViewModel`) each call `JsonSettingsFile` themselves.
  - The host's `Properties/Settings.settings` holds three read-only values.
  - `IApplicationService` and `ServiceProvider` are in `Kelly.Windows.Hosting`.
  - Because `JsonSettingsFile` already exists, [KTR5-4602](https://linear.app/jhkelly-ktr/issue/KTR5-4602) is smaller than its 8 points.

| # | Team | Title | Est. | Relation | Goal |
|---|---|---|---|---|---|
| 1 | KTR5 | [KTR5-4596](https://linear.app/jhkelly-ktr/issue/KTR5-4596) (existing), narrowed: Settings: decide the hierarchical model, scope and file location | 2 | sub-issue | Define the application → tool hierarchy, user-level versus project-level scope, file name and location; write it down in the README. |
| 2 | KTRL5 | `SettingsStore`: hierarchical application and tool settings in one JSON file | 4 | sub-issue; blocks #3 | A generic store in Kelly-Revit-Logic: get and set a tool's section by key, load and save with `JsonSettingsFile`, user and project paths (`KellyDirectories`). Includes its tests. |
| 3 | KTR5 | [KTR5-4602](https://linear.app/jhkelly-ktr/issue/KTR5-4602) (existing), narrowed: Settings service: start it with the application services | 2 (was 8) | sub-issue; blocked by #2 | An `IApplicationService` in the host that loads the store at startup (`App.cs`, `StartOrder`) and saves it on change; read and write go through `JsonSettingsFile` via the store. Needs the Logic package with #2 packed and repinned. |
| 4 | KTR5 | Spool Creator and Module Creator: keep their settings in the settings service | 2 | sub-issue; blocked by #3 | `SpoolCreateViewModel` and `ModuleCreatorViewModel` read and write their sections through the service; existing project JSON files are still read once (migration). |
| 5 | KTR5 | Host `Properties.Settings`: move its three values onto the settings service | 1 | sub-issue; blocked by #3 | `AlternateLookupTrigger`, `RibbonIcons`, `WindowIcons` come from the service; delete `Settings.settings` and the `App.config` section. |
| 6 | KTR5 | Settings window: a ribbon command to view and change the settings | 4 | sub-issue; blocked by #3 | Host ribbon button that opens a window listing application settings and each tool's section, with save and reset to defaults. |

Total: 15 points across 6 pieces.

## Unclear

None.

## Open questions

- Where does the generic store (#2) live: in Kelly-Revit-Logic (KTRL5), next to `KellyDirectories` and the JSON pin, or in the host only? **Decided 2026-11-16: Kelly-Revit-Logic.**

## Applied 2026-11-16

[KTR5-4864](https://linear.app/jhkelly-ktr/issue/KTR5-4864) is now a parent with no estimate. Its sub-issues:

| # | Key | Title | Est. | Order |
|---|---|---|---|---|
| 1 | [KTR5-4596](https://linear.app/jhkelly-ktr/issue/KTR5-4596) | Settings: decide the hierarchical model, scope and file location | 2 | blocks KTRL5-186 |
| 2 | [KTRL5-186](https://linear.app/jhkelly-ktr/issue/KTRL5-186) | `SettingsStore`: hierarchical application and tool settings in one JSON file | 4 | blocks KTR5-4602 |
| 3 | [KTR5-4602](https://linear.app/jhkelly-ktr/issue/KTR5-4602) | Settings service: start it with the application services | 2 (was 8) | blocks KTR5-4865, -4866, -4867 |
| 4 | [KTR5-4865](https://linear.app/jhkelly-ktr/issue/KTR5-4865) | Spool Creator and Module Creator: keep their settings in the settings service | 2 | — |
| 5 | [KTR5-4866](https://linear.app/jhkelly-ktr/issue/KTR5-4866) | Host `Properties.Settings`: move its three values onto the settings service | 1 | — |
| 6 | [KTR5-4867](https://linear.app/jhkelly-ktr/issue/KTR5-4867) | Settings window: a ribbon command to view and change the settings | 4 | — |

Later on 2026-11-16 the maintainer asked for a WPF/MVVM user interface for some settings. KTR5-4867 was retitled "Settings window: WPF/MVVM window to view and change the user-editable settings", and KTR5-4596 now also marks each setting as user-editable.

No calls were refused. KTR5-4596 and KTR5-4602 also got the "Settings" feature label, and KTR5-4602 left KTR5-4596 as its parent.

---

# Second review: KTR5-4869

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

### Unclear

None.

### Open questions

- **Removing a user-added row:** a remove (×) button on the row, or a right-click menu on its label? **Decided 2026-11-16: a × button on the row.**
- **Where the added contexts are saved:** a hidden extensible-storage entity in the project (recommended: it needs no new shared parameter and isn't shown to users), or a text parameter on Project Information? Not the project-level JSON file of the settings store (KTRL5-186, KTR5-4864): it sits outside the `.rvt`, so other people opening the project would not see the rows. **Decided 2026-11-16: extensible storage.**

### Applied 2026-11-16

[KTR5-4869](https://linear.app/jhkelly-ktr/issue/KTR5-4869) is now a parent with no estimate. It stays in Todo. Its sub-issues, all in Backlog:

| # | Key | Title | Est. | Order |
|---|---|---|---|---|
| 1 | [KTRL5-187](https://linear.app/jhkelly-ktr/issue/KTRL5-187) | Project-level storage: read and write a list of strings saved in the project file | 2 | blocks KTR5-4873 |
| 2 | [KTR5-4870](https://linear.app/jhkelly-ktr/issue/KTR5-4870) | Assigners panes: a context definition for any user-picked parameter | 2 | blocks KTR5-4872 |
| 3 | [KTR5-4871](https://linear.app/jhkelly-ktr/issue/KTR5-4871) | Assigners panes: add and remove context rows at run time | 4 | blocks KTR5-4872, KTR5-4873 |
| 4 | [KTR5-4872](https://linear.app/jhkelly-ktr/issue/KTR5-4872) | Assigners panes: Add Context button, parameter picker and a × on added rows | 2 | — |
| 5 | [KTR5-4873](https://linear.app/jhkelly-ktr/issue/KTR5-4873) | Assigners panes: save the added contexts with the project and restore them | 2 | — |

The picker piece (4) also waits on pieces 2 and 3, and saving (5) also waits on 3. Those two relations were added beyond the proposal's order. No calls were refused.
