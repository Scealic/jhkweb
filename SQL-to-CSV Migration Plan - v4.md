# SQL Server → CSV migration plan: Kelly Tools For Revit, Major Version 4

*Renamed 2026-10-22 from "SQL-to-JSON Migration Plan - Gen4.md" when the data files moved from JSON to CSV, and 2026-10-26 from "SQL-to-CSV Migration Plan - Gen4.md" when "Generation" became "Major Version". Rewritten 2026-10-22: the history of the abandoned designs (lazy loading, `DataDirectory.Get` repositories, the read-only project reconcile) is in the git history of the four repos and the PDF snapshot `SQL-to-JSON Migration Plan_2026.10.21.09.34.pdf`.*

**Goal:** Kelly Tools For Revit (KTR) makes no RDBMS calls. Every read comes from the CSV data files in `C:\Program Files\JH Kelly\Kelly Tools For Revit\Data`, named by `manifest.json` and written by Kelly-Revit-Data-Exporter. **Done for Major Version 4 on 2026-10-22.**

**Major Version 4 only.** The checked-out working trees:

| Repo | Branch | Package / build |
|---|---|---|
| Kelly-Windows-Data | `main-v2` | Kelly.Windows.Data 4.26.1022.1126 (head `f23181c`, pushed) |
| Kelly-Windows | `main-v2` | Kelly.Windows 4.26.1022.819 (pins Data 815) |
| Kelly-Revit-Logic | `main-v4` | Kelly.Revit.Logic 4.26.1022.905 (pins Data 815, Windows 819); head `8ac8de8`, pushed |
| Kelly-Revit | `main-v4` | pins Logic 905, Data 912 (1126 not needed: nothing it uses changed), Windows 819; head `d5535f4b`, pushed; installed 4.26.1022.1029 (2024), 4.26.1022.1119 (2025, 2026) |
| Kelly-Revit-Data-Exporter | `develop` | pins Kelly.Windows.Data.Net80 4.26.1022.1126 (head `8eddf83`, pushed) |

Packages are versioned `4.yy.MMdd.HHmm`: the major version leads the version, and the names are plain. Major Version 5 (`develop`, with Kelly-Domain and Kelly-Revit-UI) needs its own plan, not yet written. What carries over to it: the exporter, the CSV data files, `DataDirectory` and `CsvDataFormat` (to be brought across to v5's Kelly-Windows-Data), and decisions D1 and D2.

**Scope (decided 2026-10-21):** SQL Server leaves the **add-in** (Kelly-Revit-Logic and Kelly-Revit), not the shared libraries.
- Kelly-Windows-Data keeps `SqlServerService`, `BaseServerService`, `IDatabaseDataService`, Dapper, Microsoft.Data.SqlClient and its records, for other apps. It also keeps reading JSON.
- Kelly-Windows keeps `IModel` as it is.
- **All data access lives in Kelly.Windows.Data**, SQL and files alike. The Revit layers never open files or connections themselves.

## 1. How it works now

**Format: CSV, decided 2026-10-22.** JSON repeated every property name on every row: the same 23 files are 34 MB as CSV against 215 MB as JSON, and on .NET Framework 4.8.1 they load in 1.07 s against 2.09 s. Both exports of the real data read back with every row equal.
- **CSV rules** (`CsvDataFormat`, the one definition used by both sides): a header row of the record's properties; null as `\N`, so null and empty strings stay apart; dates as `yyyy-MM-dd HH:mm:ss.fff`; bools as `true`/`false`; doubles in round-trip form; a field quoted when it holds a comma, a quote, a CR or an LF, or starts or ends with white space.
- **Kelly-Revit-Data-Exporter** stays a standalone repo and application (decided 2026-10-22); its code isn't moved into Kelly-Revit or the libraries. It writes CSV by default (`--format csv`), and also JSON (`--format json`) or one SQLite database (`--format sqlite`), which KTR never reads. Without `--format`, a console run asks (`1) CSV`, `2) JSON`, `3) SQLite`; Enter takes CSV), and a run with redirected input exports CSV. Each export writes `manifest.json` with every file's row count, SHA-256 and `ExportedUtc`. A full export takes about 8 s.
- **Kelly.Windows.Data** has `CsvDataWriter`, `StrictCsvReader`, `DataDirectory.ReadAll<T>()` (through the manifest; `.csv` as CSV, `.json` as JSON), `DataDirectory.ComputeSha256` and `SqlMatch.Key`.

**Loading: everything at startup, decided 2026-10-21.** `App.LoadDataFiles()` is the one load path, for startup and "Reload Data".
- `DataStore.Load` reads `manifest.json` once. It refuses any entry that isn't `.csv`, and any file whose SHA-256 or row count isn't the manifest's, with the "Kelly Tools For Revit Data Error" dialog. Without `Data\`, startup fails.
- **No SQL Server, checked at build (2026-10-22):** Kelly-Revit and Kelly-Revit-Logic import BuildConfigs' `NoSqlServer.Build.targets`, which fails the build if either assembly references the SQL client, Dapper or Kelly.Windows.Data's SQL service types, holds a `USP_` string literal, or has a connection string in its config. The add-in still ships `Microsoft.Data.SqlClient.dll` and `Dapper.dll` because Kelly.Windows.Data depends on them; they are never loaded.
- All 23 files load behind a "Loading Data Files" progress bar (21 steps) into typed read-only lists and dictionary indexes: by Id, Guid, product code, and `SqlMatch.Key` for the SQL `=` lookups (case-insensitive, trailing spaces ignored). The `Find…` methods on `DataStore` hold those lookups. Nothing is read from disk afterwards.
- `App.LoadDataFiles` logs when, where and by whom the loaded data was exported. There is no warning when SQL Server has newer data than the export (decided 2026-10-22).
- **"Reload Data"** (General panel, third from the left) re-reads the files after a new export without restarting Revit. It keeps the current data if a file can't be read. An export older than the loaded one (by `ExportedUtc`) is loaded only if the user says yes; the default keeps the current data.

**Tested in Revit 2024 (2026-10-22):**
- Build 4.26.1022.836: Kelly's startup took at most about 4.5 s (5.3–5.5 s with JSON); a cloud project opened with all 24 updaters registered; "Reload Data" took 1.56 s.
- Build 4.26.1022.949: startup loaded all 23 files with SHA-256 and row counts checked; "Reload Data" declined an older export (15:37 UTC against the loaded 16:50 UTC), logged as "Data reload declined".
- Build 4.26.1022.1029 (Visual Studio's build, with Chris's dialog wording): tested by Chris.
- Build 4.26.1022.1029, journal 0571 (11:49–11:52): the Service and System assigners and the FabricationCustomData Updater V2 (twice) ran. V2 reported fabrication parts missing custom data points and 47 elements not updated, both conditions of those elements in the test project, not of the process. The only Kelly API notice was the known System.IO.Compression version message.
- No Kelly errors were logged in any of them.

**Deployment:** the InstallShield Express project `Kelly-Revit\.build\Kelly-Tools-For-Revit.ise` installs everything under `C:\Program Files\JH Kelly\Kelly Tools For Revit`, subfolders included. The next installer build takes whatever export is in that folder on the build machine, so run the exporter before building the installer. Builds before Kelly-Revit `97f523ae` opened `<name>.json` by name and would load stale JSON without an error, so every workstation needs the CSV build before or with the first CSV export.

## 2. What KTR called before the switch

Every call was a stored procedure run through Dapper in `Kelly.Windows.Data.Services.SqlServerService`; KTR had no inline SQL. The code named 34 procedures: 26 reads, 7 writes and 1 dead. Two databases on `lvsqlp03\misc`: **VCS** and **VCS Content**. None of these is called by the v4 add-in any more.

### Reads (26)

| Procedure | DB | Data file |
|---|---|---|
| `[dbo].[USP_ExternalParameterDefinition_SelectAll_v20240113]` | VCS | ExternalParameterDefinition |
| `[revit].[USP_GroupTypeId_SelectWhere_v20250110]` | VCS | GroupTypeId |
| `[dbo].[USP_BuiltInCategory_SelectWhereDefinitionIdAndRevitVersionEquals]` | VCS | BuiltInCategoryBinding |
| `[dbo].[USP_Table_ProductRange_ReadAll]` | VCS | ProductRange |
| `[dbo].[USP_Table_ProductRangeParameterDefaults_ReadWhereProductRangeIdEqualsId]` | VCS | ProductRangeParameterDefaults |
| `[dbo].[USP_ServiceData_SelectAll_v20241010]` | VCS | ServiceData |
| `[core].[USP_System_SelectAll_v20241010]` | VCS | System |
| `[core].[USP_System_SelectWhereIdEquals]` | VCS | System (by Id) |
| `[core].[USP_System_SelectWhereNameAndAbbreviationEquals]` | VCS | System (by Name + Abbreviation) |
| `[core].[USP_System_SelectWhereSignatureEquals]` | VCS | System (by `Name + " " + Abbreviation`) |
| `[dbo].[USP_Terminology_SelectAll]` | VCS | Terminology |
| `[core].[USP_ProjectToSystem_SelectWhereNumberAndConfigurationEquals]` | VCS | ProjectToSystem |
| `[dbo].[USP_EndPreparationsWelded_Select]` | VCS | EndPreparationsWelded |
| `[dbo].[USP_ConnectorPreparation_Select]` | VCS | ConnectorPreparations |
| `[dbo].[USP_Project_SelectWhereFilePathAndFileStoreEquals]` | VCS | Project |
| `[dbo].[USP_View_ComponentAndLookups_ReadAll]` | Content | ComponentAndLookupsView |
| `[dbo].[USP_Table_Product_ReadAll]` | Content | Product |
| `[dbo].[USP_Table_ConnectorGrouping_ReadWhereIdEqualsParameter]` | Content | ConnectorGrouping |
| `[dbo].[USP_ConnectorMapping_SelectWhereIdEqualsParameter_v20240716]` | Content | ConnectorMapping |
| `[dbo].[USP_SizeSymbol_SelectWhereTradeIdEqualsParameter_v20240716]` | Content | SizeSymbol |
| `USP_View_MaterialAndLookups_ReadWhereEquals` | Content | MaterialAndLookupsView |
| `USP_Table_Gauge_ReadWhereEquals` | Content | Gauge |
| `[fabrication].[USP_Configuration_SelectWhereGuidEquals]` | Content | Configuration |
| `[dbo].[USP_CustomDataUpdater_SelectAll_v20260811]` | Content | CustomDataUpdater |
| `[fabrication].[USP_ItemCustomDataPivotedOnComponentIdView_SelectAll_v20260112]` | Content | ItemCustomDataPivotedOnComponentId |
| `[dbo].[USP_CategoryType_SelectAll_v20250221]` | Content | CategoryType |

### Writes (7) and dead (1)

| Procedure | Table | Was called on |
|---|---|---|
| `[dbo].[USP_Table_ApplicationSession_CreateOne]` | dbo.ApplicationSession | Revit startup |
| `[dbo].[USP_Table_ApplicationSession_UpdateWhereIdEqualsParameter]` | dbo.ApplicationSession | Revit shutdown |
| `[dbo].[USP_ProjectSession_Insert]` | dbo.ProjectSession | DocumentOpened |
| `[dbo].[USP_ProjectSession_Update]` | dbo.ProjectSession | DocumentClosing |
| `[dbo].[USP_Table_ProjectMetricsLog_Insert]` | dbo.ProjectMetricsLog | DocumentClosing |
| `[dbo].[USP_Project_Insert_v20241205]` | dbo.Project | DocumentOpened reconcile, when no row existed |
| `[dbo].[USP_Project_UpdateWhereIdEquals]` | dbo.Project | DocumentOpened reconcile |
| `[Development].[USP_CodeTimer_Insert_v20241112]` | – | dead: Kelly-Windows `TimerService` is a `file class` |

## 3. Data files: 23, all produced by Kelly-Revit-Data-Exporter

Each file is a procedure's **result set**, not a raw table, so the record types map the same columns by name and the big joins stay in SQL at export time. Parameterized procedures are exported without their parameters, and the filter is an in-memory lookup. File names are the record type name without `Record`.

| # | File | DB | Export source | Lookup key in the add-in |
|---|---|---|---|---|
| 1 | ExternalParameterDefinition | VCS | its SelectAll procedure | name (OrdinalIgnoreCase) |
| 2 | GroupTypeId | VCS | `revit.GroupTypeId` | Id |
| 3 | BuiltInCategoryBinding | VCS | the procedure's join, plus `DefinitionId` and `RevitVersion` | (DefinitionId, RevitVersion) |
| 4 | ProductRange | VCS | its ReadAll procedure | – |
| 5 | ProductRangeParameterDefaults | VCS | `dbo.ProductRangeParameterDefaults` | ProductRangeId |
| 6 | ServiceData | VCS | its SelectAll procedure | – |
| 7 | System | VCS | its SelectAll procedure | Id; (Name, Abbreviation); `Name + " " + Abbreviation` |
| 8 | Terminology | VCS | its SelectAll procedure | – |
| 9 | ProjectToSystem | VCS | `core.ProjectToSystem` | (ProjectNumber, ConfigurationId) |
| 10 | EndPreparationsWelded | VCS | the procedure's join with its fixed `Weld`/`Location` filter, plus the linker `Id` (7 rows) | (WeldLocationInitialism, EndPreparationsHasFieldTrim) |
| 11 | ConnectorPreparations | VCS | the procedure's join, plus the connector `Id` | (GroupName, ConnectorName) |
| 12 | Project | VCS | `dbo.Project`, the procedure's 25 columns | Id (`ProjectsById`); nothing reads it yet |
| 13 | ComponentAndLookupsView | Content | its ReadAll procedure | Id |
| 14 | Product | Content | its ReadAll procedure | component Id; product code |
| 15 | ConnectorGrouping | Content | `dbo.ConnectorGrouping` | Id |
| 16 | ConnectorMapping | Content | `dbo.ConnectorMapping` | Id |
| 17 | SizeSymbol | Content | `dbo.SizeSymbol` | TradeId |
| 18 | Gauge | Content | `dbo.Gauge` | (MaterialTypeId, Thickness) |
| 19 | MaterialAndLookupsView | Content | the procedure's join | (Name, MaterialGroupDotName) |
| 20 | Configuration | Content | `Fabrication.Configuration` | Guid |
| 21 | CustomDataUpdater | Content | its SelectAll procedure | – |
| 22 | ItemCustomDataPivotedOnComponentId | Content | its SelectAll procedure | component Id |
| 23 | CategoryType | Content | `dbo.CategoryType`, not its procedure, which leaves out `IsValidForSpool` and `IsValidForStratus` | – |

Each export that replaces a procedure returns the procedure's columns; the only extras are `DefinitionId`, `RevitVersion` and the two `Id` columns.

**Base tables behind the files (63).** VCS (19): `dbo.ExternalParameterDefinitions`, `revit.GroupTypeId`, `dbo.BuiltInCategory`, `dbo.BuiltInCategoryMeta`, `dbo.LinkerExternalParameterDefinitionsToCategories`, `dbo.ProductRange`, `dbo.ProductRangeParameterDefaults`, `dbo.ServiceData`, `core.System`, `dbo.Terminology`, `core.ProjectToSystem`, `dbo.Linker_WeldLocationToEndPreparationWelded`, `dbo.EndPreparationsWelded`, `dbo.Connector`, `dbo.ConnectorDomains`, `dbo.ConnectorShapes`, `dbo.ConnectorPreparations`, `dbo.ConnectorGroups`, `dbo.Project`. VCS Content (44): the 29 component lookups behind `View_ComponentAndLookups`, 6 custom-data tables (`ComponentSupportType`, `SupportType`, `ComponentTag`, `TagPrefix`, `ComponentWeldType`, `WeldType`), and `dbo.Product`, `dbo.ConnectorGrouping`, `dbo.ConnectorMapping`, `dbo.SizeSymbol`, `dbo.Gauge`, `Fabrication.Material`, `Fabrication.MaterialGroup`, `Fabrication.Configuration`, `Fabrication.ItemCustomData`. `dbo.ApplicationSession`, `dbo.ProjectSession` and `dbo.ProjectMetricsLog` were written but never read, and need no export.

## 4. Decisions on the writes

`Program Files` can't be written by standard users, so nothing is written back.

**D1 Session and metrics logging (decided 2026-10-21, done).** All SQL reads and writes go.
- `ApplicationSession` stays as an in-memory object (user, workstation, Revit and KTR versions, start and stop times), with no persistence.
- ProjectSession and ProjectMetricsLog are gone. `DocumentSession` stays as the in-memory, per-document holder of `HangerPlaceSettings` (read by `ViciousFabricationHangerInstancePlaceCommand`), with a session-unique `Id`.

**D2 Project reconcile (decided 2026-10-21, done): there is no reconcile.** Project Information and its JHK shared parameters live in the document only, and the Project Information Editor changes them there. Opening a project reads nothing. `ProjectInformationWrapper` in Logic has only the document constructor. Nothing writes `dbo.Project`, so new projects are added on the server by another route. `Project.csv` is still exported and loaded.

## 5. Open items

**Work**
None. Revit 2025 and 2026 (build 4.26.1022.1119) aren't run yet; Chris expects them to work, as 2024 does with the same source.

**Stored procedures (2026-10-22).** `db-deprecation/40`–`44` mark 20 of the 34 with a `Deprecated` note "Deprecate/Delete 1/1/2027" (14 in VCS, 6 in VCS Content), with rollback and a read-only verify; run in SSMS, and verify shows all 20 marked. `db-object-usage-report.csv` lists them as `UNREFERENCED`, with the note in its new `Deprecated` column. The other 14 stay: Kelly-Revit-Data-Exporter calls 8, and Major Version 5 (`develop`) still named 6 until 2026-10-30, when it moved to the data files too (`SQL-to-CSV Migration Plan - v5.md`); they can be marked once every workstation runs a CSV build of either major version. SQL Agent jobs and execution history couldn't be checked (permissions denied). Older KTR installs still call them, so drop them only after every workstation runs the CSV build.

**Decisions**
1. SQL Server stays the master and the exporter is re-run (recommended), rather than the files becoming the master.
2. The refresh process: who runs the exporter, and when. The installer already ships `Data\`, so a new export reaches workstations with the next installer build.
3. `Project.csv` holds client names and addresses and is copied to every workstation. Confirm that is acceptable.
4. Columns without a source, listed per file in `manifest.json`; they have their default values, as they did with SQL. Fix each in the procedure or the record, or leave it:
   - Missing properties: `ComponentAndLookupsViewRecord.MaterialConfigurationId`, `CustomDataUpdaterRecord.CustomData108JhkGauge` and `.Id`. (`ProductRecord.Id` stays as it is, decided 2026-10-22.)
   - Columns no record maps: Terminology's `Context`, `CategoryB`, `FullName`, `InActive`, and ItemCustomData's `FilePath`.
5. Revit 2026 has no rows in `BuiltInCategoryMeta`, so shared parameters get no category bindings on 2026, with SQL as well as with CSV.
6. Write the Major Version 5 plan.

## 6. Findings worth keeping

1. **SQL matching rules differ from C#.** The SQL `=` comparisons are case-insensitive and ignore trailing spaces. `SqlMatch.Key` and `SqlMatch.StringEquals` in Kelly.Windows.Data do the same, and every in-memory lookup uses them.
2. **Two names the records never matched are renamed in the export:** `WeldLocationName` becomes `WeldLocationTerm`, and `FabricationPatternOptionTypeDotName` becomes `FabricationPatternOptionsTypeDotName`. Both properties were empty in the add-in with SQL, so this is a behaviour change, and a fix.
3. **The `CategoryType.json` installed before 2026-10-21 couldn't be read:** its flags were the strings `"0"` and `"1"`, so the add-in probably loaded no category types. The export writes real booleans.
4. **A field of a lone carriage return** (one `ProjectRecord.Address`) wasn't quoted by CsvHelper's own rule and read back as a line end. `CsvDataFormat` quotes any field with a CR or an LF, and the real-data comparison found no other difference.
5. **Product index:** 23% of components have no product, and a scan for one cost 2.3 ms over 171,540 rows on .NET Framework 4.8.1. The index by component Id and product code brought the Product updater from 14.9 s to 2.80 s in Revit 2024.
