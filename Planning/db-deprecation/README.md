# Deprecation marking — 55 unreferenced stored procedures

Generated 2026-10-02 against `lvsqlp03\misc`.

These scripts attach an extended property named `Deprecated` to 55 stored
procedures. They do **not** rename, alter, or drop anything — runtime
behaviour is unchanged, and every change is reversible.

## Run order

| # | Script | Database | Targets |
|---|--------|----------|---------|
| 1 | `01-mark-deprecated-VCS.sql` | `VCS` | 48 |
| 2 | `02-mark-deprecated-VCS-Content.sql` | `VCS Content` | 7 |
| — | `05-verify.sql` | both | lists what is marked |
| — | `03-rollback-VCS.sql` | `VCS` | 48 |
| — | `04-rollback-VCS-Content.sql` | `VCS Content` | 7 |

All scripts are safe to re-run. Marking updates an existing property rather
than duplicating it; rollback skips procedures that are not marked.

```bash
sqlcmd -S 'lvsqlp03\misc' -E -I -i 01-mark-deprecated-VCS.sql
```

## How the list was derived

A procedure is on this list only if **both** are true:

- no reference to its name anywhere in Kelly-Revit, Kelly-Revit-Logic,
  Kelly-Windows or Kelly-Windows-Data (all file types, not just `.cs`);
- no referencing object in `sys.sql_expression_dependencies`.

## What this list does NOT prove

These procedures are **not** confirmed dead. Three blind spots remain:

- **SQL Agent jobs were never checked** — no `SELECT` on `msdb.dbo.sysjobsteps`.
  21 of the 54 are cleanup/update procedures, exactly the kind a scheduled job
  would call. This is the most important gap to close.
- **Query Store is OFF** on both databases, so no execution history exists.
- **External consumers** (SSIS, Power BI, Excel, linked servers, ad-hoc queries)
  are invisible to both checks above.

Treat the marked set as a review queue, not a drop list.

## Suggested next steps

1. Have someone with msdb rights run:
   `SELECT j.name, s.step_name, s.database_name, s.command FROM msdb.dbo.sysjobsteps s JOIN msdb.dbo.sysjobs j ON j.job_id = s.job_id WHERE s.database_name IN ('VCS','VCS Content')`
2. Enable Query Store on both databases and let a full business cycle elapse
   (a quarter, to catch monthly and quarterly jobs).
3. Re-check the marked set against real execution data before dropping anything.

If you do eventually rename rather than drop, match the convention already in
use in this schema — a dated suffix such as `_Deprecated2025.07.30` — rather
than a prefix, which scatters procedures away from their functional neighbours
in Object Explorer.

---

# Outright rename to `DEPREC_` prefix

Chosen over extended-property marking on 2026-10-02. Scripts `10`–`20` below
supersede `01`–`05` for this purpose; the extended-property scripts are kept
in case the non-breaking option is wanted later.

## Order of operations

1. **Repo first** — `20-rename-repo-files.ps1` (run with `-WhatIf` first) — 54 procedures.
   Requires a clean working tree. Build the `.sqlproj` before committing.
2. **Server** — `10-rename-VCS.sql`, then `11-rename-VCS-Content.sql`.
3. **Verify** — `14-verify-rename.sql` against each database.
   Expect 47 in `VCS`, 7 in `VCS Content`.

Doing the repo first means that if anything goes wrong on the server, the
deployable source and the server can be reconciled by a normal SSDT deploy
rather than by hand.

## Rollback

- Server: `12-rollback-rename-VCS.sql`, `13-rollback-rename-VCS-Content.sql`
- Repo: `git revert` the rename commit

## Implementation notes

- `sp_rename` is called through `QUOTENAME`, because **two** of the 54 names
  contain dots and would otherwise be mis-parsed as multi-part names:
  `USP_OperationLog_Insert_v20240905_Deprecated2025.07.30`,
  `USP_Project_InsertNew_Deprecated2025.07.30`.
- No `DEPREC_`-prefixed name collides with an existing object.
- `sp_rename` preserves permissions, extended properties and `object_id`, but
  does **not** rewrite the module definition. Until the repo change is
  deployed, `OBJECT_DEFINITION()` still reports the old name. `14-verify-rename.sql`
  lists every procedure in that state.
- `sp_rename` emits a "Caution: Changing any part of an object name..."
  message per procedure. That is informational, not an error.

## Risk accepted

These procedures were never observed at runtime. SQL Agent could not be read
(`msdb` denied), Query Store is off, and `dm_db_index_usage_stats` is also
permission-denied. 21 of the 54 are cleanup/update procedures of the kind a
scheduled job would call. Any hidden caller will fail at its next invocation,
which for a monthly or quarterly job may be weeks away. Keep the rollback
scripts available for at least one full business cycle.


## The duplicate procedure — dropped, not renamed

`[dbo].[dbo.usp_ExportTablesToJson]` was removed from the rename set
(55 → 54) and is handled by `30-drop-duplicate-proc-VCS.sql` instead.
Renaming it would only have preserved the stray dot from the original
quoting mistake as `DEPREC_dbo.usp_ExportTablesToJson`.

The real `[dbo].[usp_ExportTablesToJson]`, which Kelly-Windows calls, is
untouched and is **not** in any deprecation list.

That drop is destructive. After it is confirmed good, remove the repo
definition too, or the next SSDT deploy will recreate it:

```
git -C VCS-Database-General-Schema rm "project/dbo/Stored Procedures/dbo.usp_ExportTablesToJson.sql"
```
then delete the matching `<Build Include="dbo\Stored Procedures\dbo.usp_ExportTablesToJson.sql" />`
line from `project/project.sqlproj` and rebuild.

---

# Deprecate/Delete 1/1/2027 — 20 procedures Kelly Tools For Revit no longer calls

Generated 2026-10-22 against `lvsqlp03\misc`. Kelly Tools For Revit Major Version 4
stopped calling SQL Server on 2026-10-22: it now reads CSV data files exported by
Kelly-Revit-Data-Exporter. These scripts mark the 20 procedures it used to call that
nothing else in our code calls, with a `Deprecated` extended property whose note
starts "Deprecate/Delete 1/1/2027". Like the 2026-10-02 set, they do **not**
rename, alter or drop anything, and every change is reversible.

## Run order

| # | Script | Database | Targets |
|---|--------|----------|---------|
| 1 | `40-mark-deprecated-2027-VCS.sql` | `VCS` | 14 |
| 2 | `41-mark-deprecated-2027-VCS-Content.sql` | `VCS Content` | 6 |
| — | `44-verify-deprecated-2027.sql` | both (read only) | lists what is marked, and any target that isn't |
| — | `42-rollback-deprecated-2027-VCS.sql` | `VCS` | 14 |
| — | `43-rollback-deprecated-2027-VCS-Content.sql` | `VCS Content` | 6 |

```bash
sqlcmd -S 'lvsqlp03\misc' -E -I -i 40-mark-deprecated-2027-VCS.sql
sqlcmd -S 'lvsqlp03\misc' -E -I -i 41-mark-deprecated-2027-VCS-Content.sql
sqlcmd -S 'lvsqlp03\misc' -E -I -i 44-verify-deprecated-2027.sql
```

- **Safe to re-run.** The marking scripts stop without changes if a target is
  missing, or already carries a *different* `Deprecated` note (such as the
  2026-10-02 one); they never overwrite it. Their own note is updated, not
  duplicated.
- **Rollback removes only this note** (one starting "Deprecate/Delete 1/1/2027"),
  never a different `Deprecated` note or `MS_Description`.
- Checked 2026-10-22 before hand-over: all four scripts parse on the server
  (`SET PARSEONLY ON`), and the verify script lists all 20 as not yet marked.
- **Run 2026-10-22 (in SSMS, by Chris):** `40` and `41`. `44` then showed all
  20 marked and none missing. They are the only `Deprecated` properties on the
  server (14 in VCS, 6 in VCS Content): the 2026-10-02 set above has not been run.

## The 20 targets

| Database | Procedure |
|---|---|
| VCS | `revit.USP_GroupTypeId_SelectWhere_v20250110` |
| VCS | `dbo.USP_BuiltInCategory_SelectWhereDefinitionIdAndRevitVersionEquals` |
| VCS | `dbo.USP_Table_ProductRangeParameterDefaults_ReadWhereProductRangeIdEqualsId` |
| VCS | `core.USP_System_SelectWhereIdEquals` |
| VCS | `core.USP_System_SelectWhereNameAndAbbreviationEquals` |
| VCS | `core.USP_ProjectToSystem_SelectWhereNumberAndConfigurationEquals` |
| VCS | `dbo.USP_EndPreparationsWelded_Select` |
| VCS | `dbo.USP_ConnectorPreparation_Select` |
| VCS | `dbo.USP_Table_ApplicationSession_CreateOne` |
| VCS | `dbo.USP_Table_ApplicationSession_UpdateWhereIdEqualsParameter` |
| VCS | `dbo.USP_ProjectSession_Insert` |
| VCS | `dbo.USP_ProjectSession_Update` |
| VCS | `dbo.USP_Table_ProjectMetricsLog_Insert` |
| VCS | `Development.USP_CodeTimer_Insert_v20241112` |
| VCS Content | `dbo.USP_View_ComponentAndLookups_ReadAll` |
| VCS Content | `dbo.USP_Table_ConnectorGrouping_ReadWhereIdEqualsParameter` |
| VCS Content | `dbo.USP_ConnectorMapping_SelectWhereIdEqualsParameter_v20240716` |
| VCS Content | `dbo.USP_SizeSymbol_SelectWhereTradeIdEqualsParameter_v20240716` |
| VCS Content | `dbo.USP_View_MaterialAndLookups_ReadWhereEquals` |
| VCS Content | `Fabrication.USP_Configuration_SelectWhereGuidEquals` |

## How the list was derived (2026-10-22)

- They are the 34 procedures Major Version 4 KTR called (section 1 of
  `..\SQL-to-CSV Migration Plan - v4.md`), minus the ones still called:
  - **by Kelly-Revit-Data-Exporter (8, kept):** `USP_ExternalParameterDefinition_SelectAll_v20240113`,
    `USP_Table_ProductRange_ReadAll`, `USP_ServiceData_SelectAll_v20241010`,
    `USP_System_SelectAll_v20241010`, `USP_Terminology_SelectAll`, `USP_Table_Product_ReadAll`,
    `USP_CustomDataUpdater_SelectAll_v20260811`, `USP_ItemCustomDataPivotedOnComponentIdView_SelectAll_v20260112`;
  - **by Major Version 5 (`develop` of the four layer repos; 6 more, kept):** `USP_System_SelectWhereSignatureEquals`,
    `USP_Project_SelectWhereFilePathAndFileStoreEquals`, `USP_Project_Insert_v20241205`,
    `USP_Project_UpdateWhereIdEquals`, `USP_Table_Gauge_ReadWhereEquals`, `USP_CategoryType_SelectAll_v20250221`.
- On the live server, all 20 exist, none is referenced in
  `sys.sql_expression_dependencies`, and none carried a `Deprecated` property.

## What this list does NOT prove

- **SQL Agent jobs** (`msdb` SELECT denied) and **execution history**
  (`VIEW SERVER STATE` denied; Query Store is OFF) could not be checked.
- **Older KTR installs still call them:** Major Version 3, and Major Version 4 builds
  before the CSV switch, call the session writes at every startup and project
  open/close, and the lookups in the updaters. Delete only after every
  workstation runs the CSV build.
- **External consumers** (SSIS, Power BI, Excel, linked servers, ad-hoc use)
  are invisible to these checks.
