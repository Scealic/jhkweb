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

No calls were refused. KTR5-4596 and KTR5-4602 also got the "Settings" feature label, and KTR5-4602 left KTR5-4596 as its parent.
