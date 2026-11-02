# SQL Server → CSV migration plan: Kelly Tools For Revit, Major Version 5

*Written 2026-10-26; refreshed 2026-10-30 after the repos were renamed (2026-10-27) and the v5 layers were straightened (`KTR v5 Layer Straightening Plan.md`, 2026-10-30). A plan only: nothing in it is built, and no v5 code changes until Chris approves it. Modelled on `SQL-to-CSV Migration Plan - v4.md` (done 2026-10-22) and step 7 of `Kelly-Windows-Data Format Libraries - Design Plan.md`.*

## Progress

**Approved 2026-10-30 (D1–D8 in section 7). On `develop`, committed, not pushed:**
- **Step 0:** baseline in Revit 2024 with the add-in disabled: Logic 573/573, Revit-UI 44/44, add-in 69/73 (the 4 are `EventServiceTests` and the log test, which need the add-in started and can't pass with it disabled).
- **Step 1:** Kelly-Windows-Data-v3 `468f31b` (package 3.26.1030.723): the data-folder core from Kelly-Windows-Data-v2 with the same names; short-name record lookup (D1); `IRecord` → `Kelly.Windows.Data.Interfaces`, `BoolJsonConverter` → `Kelly.Windows.Data.Converters`; `DataDirectory` has no default folder (v2's named the add-in's install folder). `FormatLibraryTests` runs the published Csv library against this core. Then `acde86e` (3.26.1030.730): `DataManifest.FileOf(Type)`, the short-name lookup the store uses. 285 tests ×3. The Json library's `JsonLinesFileWriter` isn't tested against v3 yet: v3 still has its own `Kelly.Windows.Data.Json` types under the same names until step 7.
- **Step 2:** Kelly-Windows-v3 `6ef6317` (3.26.1030.726) `RecordCache` replaces `SqlRecordCache`; `c58a697` (3.26.1030.730) re-pinned. 493 tests ×3.
- **Step 3:** Kelly-Domain `09ea361` (1.26.1030.745): `DataStore`, `DataFiles` (was `ServerData`), everything on the store; SQL types removed. 554 tests ×3.
- **Step 4:** Kelly-Revit-Logic-v5 `e7f94d2` (5.26.1030.809): `DataFileService` (one load path; a failed load keeps the data), the updaters and `SystemDocumentCache` on the store, no reconcile, manual updaters don't reload, NoSqlServer check. 580/580 in Revit 2024.
- **Step 5:** Kelly-Revit-UI `466326c` (1.26.1030.811): `DataFileLoader` (startup and Reload Data share v4's behaviour: older-export question, "Kelly Tools For Revit Data Error", load log; asked for by Chris 2026-10-30), `PushButtonText.ReloadData`. 171 without Revit, 44/44 in Revit 2024.
- **Step 6:** Kelly-Revit-v5 `c205a576`: startup loads the CSV files first (Data Error dialog and failed startup as v4), Reload Data, connection strings and SQL settings removed, config check on, pins `Kelly.Windows.Data.Csv` beside Kelly.Revit.UI. Builds 2024–2026 (not installed); 69/73 in Revit 2024 (the 4 known).
- **Step 7:** Kelly-Windows-Data-v3 `667a924` (3.26.1030.816): SQL Server, JSON file code and `CacheBase` removed (the libraries hold them); depends on Newtonsoft.Json only; 155 tests ×3. Kelly-Windows-v3 `8cde6f8` (3.26.1030.819; framework references the SQL client used to bring), Kelly-Domain `4e69a6c` (1.26.1030.820). Logic `300e068` (5.26.1030.837) pins the Json library for the operation log (580/580), UI `225b8af` (1.26.1030.839; 171 + 44/44), add-in `aa78814f`: clean builds for 2024–2026 put no SqlClient, Dapper, Azure or ConfigurationManager DLL in the add-in folder; 69/73 as before.
- **Step 8:** docs: every repo's README and Changelog with its commits; `.claude/CLAUDE.md` (not in a repo); BuildConfigs `ab598fa` (`SHARED-AGENTS.md`); `Kelly Tools Major Versions and Branches.md`; the v4 plan's stored-procedure note; `KTR v5 Layer Straightening Plan.md` (its open items closed).
- **Not done:** step 9 (mark the procedures only v5 called, after v5 is installed everywhere), installing v5 and running it as an add-in (Chris's call), the release-notes doc (v5 content only when Chris says), pushing.
- **Correction:** BuildConfigs needs no change for the add-in's Csv pin: `KellyLayerBelow` takes several packages separated by semicolons.

**Goal:** Kelly Tools For Revit (KTR) Major Version 5 makes no RDBMS calls, as v4 already does. Every read comes from the CSV data files in `C:\Program Files\JH Kelly\Kelly Tools For Revit\Data`, named by `manifest.json` and written by Kelly-Revit-Data-Exporter. v5 reuses everything v4 built: the exporter, the 23 data files, the core types of Kelly-Windows-Data (`DataDirectory`, `DataManifest`, `SqlMatch`, `IDataFileReader`) and the Csv format library.

**Scope (carried over from v4, decided 2026-10-21):** SQL Server leaves the **add-in**: Kelly-Domain, Kelly-Revit-Logic-v5, Kelly-Revit-UI and Kelly-Revit-v5. The SQL Server code stays available to other applications in **Kelly-Windows-Data-SqlServer**, which already holds v5's `SqlServerService`, `ServerServiceBase`, `IDatabaseReader`/`IDatabaseWriter`, `ConnectionStringResolver` and `DatabaseConnectionTester`. All data access lives in Kelly.Windows.Data and its format libraries. The layers above never open files or connections themselves.

## 1. Where v5 is (2026-10-30)

| Repo (folder) | `develop` head, not pushed | `<MajorVersion>` | Newest package |
|---|---|---|---|
| Kelly-Windows-Data-v3 | `d224622` | 3 | Kelly.Windows.Data 3.26.1030.629 |
| Kelly-Windows-v3 | `6de2d57` | 3 | Kelly.Windows 3.26.1030.631 |
| Kelly-Domain | `ee29cc5` | 1 | Kelly.Domain 1.26.1030.648 |
| Kelly-Revit-Logic-v5 | `697a38f` | 5 | Kelly.Revit.Logic 5.26.1030.649 |
| Kelly-Revit-UI | `71853e7` | 1 | Kelly.Revit.UI 1.26.1030.650 |
| Kelly-Revit-v5 | `d53b8351` | 5 | add-in; builds for 2024–2026, not installed |

- All six are clean. Since the straightening, each repo pins **only the Kelly package directly below it**, in its `Directory.Packages.props` (central package management). BuildConfigs' `LayerPackages.Build.targets` (`KTR0006`) fails a build that references any other Kelly package. A re-pin is therefore one line per repo, bottom-up.
- **The straightening's step 2 already moved every stored procedure name out of the add-in** into Kelly-Domain (`ContentQueries`, `DatabaseConnections.Read`/`Test`/`ReadContent`/`ReadGeneral`, `ApplicationSessionStore.Open`). Kelly-Revit-v5 imports `NoSqlServer.Build.targets`, with its configuration-file part off (`NoSqlServerConfigCheck`), because the `.config` still holds the connection strings.
- **Still open from the straightening:** its step 5 in-Revit tests (Logic, UI and the add-in, in Revit 2024 with the add-in disabled), and the hard-coded fallback connection strings in `App.ResolveConnectionStrings`, which name the production server. This migration deletes those strings (step 6). Run the straightening's in-Revit tests first, as the baseline this migration is checked against.

## 2. What v5 calls today

Every call is a stored procedure run through Dapper in `SqlServerService`, in Kelly-Windows-Data-v3 (`src/Database`), against the same two databases on `lvsqlp03\misc` as v4: **VCS** ("General") and **VCS Content** ("Content").
- `App.ResolveConnectionStrings` (Kelly-Revit-v5) calls `DatabaseConnections.Read` (Domain) with the add-in's `.config` and built-in defaults, then `DatabaseConnections.Test`.
- The result reaches the code below as `App.DatabaseConnections` and `AddInConfiguration.DatabaseConnections`.

v5 names **27 procedures: 23 reads and 4 writes,** the same 27 as on 2026-10-26. Kelly-Windows-v3 (only `SqlRecordCache`, the base of six Domain caches) and Kelly-Revit-UI call none themselves.

### Reads (23)

| # | Procedure | DB | Named in (repo: type) → called from | When | Data file |
|---|---|---|---|---|---|
| 1 | `[dbo].[USP_ExternalParameterDefinition_SelectAll_v20240113]` | VCS | Domain: `ExternalParameterDefinitionCache` | startup (`ServerDataService`) | ExternalParameterDefinition |
| 2 | `[revit].[USP_GroupTypeId_SelectWhere_v20250110]` | VCS | Domain: `GroupTypeIdWrapper.ServerSelect` ← `ExternalParameterDefinition` constructor | startup, **once per definition** | GroupTypeId (by Id) |
| 3 | `[dbo].[USP_BuiltInCategory_SelectWhereDefinitionIdAndRevitVersionEquals]` | VCS | Domain: `ExternalParameterDefinition` constructor | startup, **once per definition** | BuiltInCategoryBinding (by DefinitionId, RevitVersion) |
| 4 | `[dbo].[USP_Table_ProductRange_ReadAll]` | VCS | Domain: `ProductRangeCache` | startup | ProductRange |
| 5 | `[dbo].[USP_Table_ProductRangeParameterDefaults_ReadWhereProductRangeIdEqualsId]` | VCS | Domain: `ProductRangeCache` | startup, **once per range** | ProductRangeParameterDefaults (by ProductRangeId) |
| 6 | `[dbo].[USP_ServiceData_SelectAll_v20241010]` | VCS | Domain: `ServiceCache` | startup | ServiceData |
| 7 | `[core].[USP_System_SelectAll_v20241010]` | VCS | Domain: `SystemCache`; `ProjectSystemQueries.SelectAllSystemRecords` ← Logic `SystemDocumentCache` | startup; each System/Service assigner combo box | System |
| 8 | `[core].[USP_System_SelectWhereSignatureEquals]` | VCS | Logic: `SystemUpdaterElementService` | System updater | System (by `Name + " " + Abbreviation`) |
| 9 | `[dbo].[USP_Terminology_SelectAll]` | VCS | Domain: `TerminologyCache` | startup | Terminology |
| 10 | `[core].[USP_ProjectToSystem_SelectWhereNumberAndConfigurationEquals]` | VCS | Domain: `ProjectSystemQueries.GetProjectSystems` ← Logic `SystemDocumentCache` ← Trade.All `AssignerSystemComboBox`, `ServiceComboBoxEventHandler` | assigner combo boxes | ProjectToSystem (by ProjectNumber, ConfigurationId) |
| 11 | `[dbo].[USP_ConnectorPreparation_Select]` | VCS | Domain: `ConnectorPreparationResolver` ← Logic `EndPreparationUpdaterElementService` | End Preparation updater, weld location commands | ConnectorPreparations (by GroupName, ConnectorName) |
| 12 | `[dbo].[USP_Project_SelectWhereFilePathAndFileStoreEquals]` | VCS | Logic: `ProjectInformationWrapper.ServerSelect` ← `ProjectInformationReconciler` ← Kelly-Revit-v5 `DocumentOpenedEventHandler` | every DocumentOpened | Project (by FilePath, FileStore) |
| 13 | `[dbo].[USP_View_ComponentAndLookups_ReadAll]` | Content | Domain: `ComponentCache` | startup | ComponentAndLookupsView |
| 14 | `[dbo].[USP_Table_Product_ReadAll]` | Content | Domain: `ProductCache` | startup | Product |
| 15 | `[dbo].[USP_Table_ConnectorGrouping_ReadWhereIdEqualsParameter]` | Content | Domain: `ConnectorSizeDataResolver` ← Logic `SizeUpdaterElementService` | Size updater | ConnectorGrouping (by Id) |
| 16 | `[dbo].[USP_ConnectorMapping_SelectWhereIdEqualsParameter_v20240716]` | Content | same | Size updater | ConnectorMapping (by Id) |
| 17 | `[dbo].[USP_SizeSymbol_SelectWhereTradeIdEqualsParameter_v20240716]` | Content | same | Size updater | SizeSymbol (by TradeId) |
| 18 | `USP_View_MaterialAndLookups_ReadWhereEquals` | Content | Domain: `MaterialAndLookups.ServerSelect` ← Logic `MaterialElementDataModel` | Material updater | MaterialAndLookupsView (by Name, MaterialGroupDotName) |
| 19 | `USP_Table_Gauge_ReadWhereEquals`: the name is Kelly-Revit-v5's setting `StoredProcedureGaugeReadWhereEquals`, handed to Domain by `AddInConfiguration.Configure` | Content | Domain: `GaugeNameResolver` ← Logic `ScheduleGaugeElementDataModel`, Contenter `FabricationCustomDataUpdaterCommandV2` | Schedule Gauge updater, Custom Data Updater V2 | Gauge (by MaterialTypeId, Thickness) |
| 20 | `[fabrication].[USP_Configuration_SelectWhereGuidEquals]` | Content | Domain: `ProjectSystemQueries.SelectConfiguration` ← Logic `SystemDocumentCache` | assigner combo boxes | Configuration (by Guid) |
| 21 | `[dbo].[USP_CustomDataUpdater_SelectAll_v20260811]` | Content | Domain: `ContentQueries` ← Contenter `FabricationCustomDataProposedReportCommand`, `FabricationCustomDataUpdaterCommandV2` (through `DatabaseConnections.ReadContent`) | those commands | CustomDataUpdater |
| 22 | `[fabrication].[USP_ItemCustomDataPivotedOnComponentIdView_SelectAll_v20260112]` | Content | Domain: `ContentQueries` ← Contenter `FabricationCustomDataUpdaterCommandV1` | that command | ItemCustomDataPivotedOnComponentId |
| 23 | `[dbo].[USP_CategoryType_SelectAll_v20250221]` | Content | Domain: `ContentQueries` ← Developer `ProductRangeSchedulesCommand` | that command | CategoryType |

- **Stale setting defaults:** Kelly-Revit-v5's `Settings.Designer.cs` still holds two procedure names as setting defaults, for #19 and #21. Only #19's setting is still used.
- **A second source of category types:** at startup, `App.CacheCategoryTypeRecords` reads `CategoryType.json` from the application data folder, through v5's `JsonFileRepository`, for `ServerData.CategoryTypes`. That is a file, not SQL, but it holds the same data as `CategoryType.csv`.

### Writes (4)

| Procedure | Table | Named in → called from | When |
|---|---|---|---|
| `[dbo].[USP_Table_ApplicationSession_CreateOne_20261014]` | dbo.ApplicationSession | Domain `ApplicationSessionStore.Insert` (made by `ApplicationSessionStore.Open`) ← Kelly-Revit-v5 `ApplicationSessionService.Start` (StartOrder 3) | Revit startup |
| `[dbo].[USP_Table_ApplicationSession_UpdateWhereIdEqualsParameter_20261014]` | dbo.ApplicationSession | `ApplicationSessionStore.Update` ← `ApplicationSessionService.Stop` | Revit shutdown |
| `[dbo].[USP_Project_Insert_v20241205]` | dbo.Project | Logic `ProjectInformationWrapper.ServerInsert` ← `ProjectInformationReconciler` | DocumentOpened, when the project has no row |
| `[dbo].[USP_Project_UpdateWhereIdEquals]` | dbo.Project | Logic `ProjectInformationWrapper.ServerUpdate` ← `ProjectInformationReconciler` | DocumentOpened: **every open** of a project with a row (the comparison always differs) |

The two ApplicationSession procedures are new `_20261014` versions (in `VCS-Database-General-Schema`), not the ones v4 called. v5 has no ProjectSession or ProjectMetricsLog writes: `OperationService` writes its logs to files and sets `ProjectSessionId = -1`.

### Not in v5

v5 doesn't call these v4 procedures:
- `System_SelectWhereIdEquals` and `System_SelectWhereNameAndAbbreviationEquals`: `ProjectSystemQueries` matches systems by name and abbreviation in memory.
- `EndPreparationsWelded_Select`: `EndPreparationTools` decides the field weld rules in code.
- The ProjectSession and ProjectMetricsLog procedures.

## 3. The 23 data files against what v5 needs

**Reads: covered, no new export needed.** The 23 reads map onto 22 of the 23 files. v5 doesn't need `EndPreparationsWelded.csv`; it can load the file and ignore it. As in v4, the parameterized procedures become in-memory lookups, using `SqlMatch.Key` for the SQL `=` matches (case-insensitive, trailing spaces ignored).

**Records: the same columns.** Compared property by property on 2026-10-30, the 24 Kelly-Domain record types that share a name with v4's records (Kelly-Windows-Data-v2) have the same properties with the same types. So the exporter's columns, including its two renames (`WeldLocationTerm`, `FabricationPatternOptionsTypeDotName`), map onto v5's records unchanged. The only record that differs, `ApplicationSessionRecord` (`Application*` against v4's `Revit*`), isn't exported.

**What v5 needs that the files don't give it:**
1. **The record type names.** `manifest.json` (export of 2026-10-26 18:45 UTC) names each file's type by its v4 full name, for example `Kelly.Windows.Data.Records.SystemRecord`. v4's `DataDirectory.ReadAll<T>()` finds a file by `typeof(T).FullName`, and `Verify` resolves that name in its record assemblies. v5's records are `Kelly.Domain.Projects.SystemRecord`, `Kelly.Domain.Products.ProductRecord` and so on, so neither would find them. See D1.
2. **`BuiltInCategoryBindingRecord`.** The file adds `DefinitionId` and `RevitVersion` to the `BuiltInCategoryRecord` columns. v5 has no record for it yet; Domain adds one, as v4 did.
3. **The `ProjectRecord` and `ConfigurationRecord` lookups**, by (FilePath, FileStore) and by Guid. The data is in the files; only the indexes are new.

**New exports: none,** unless D1 is settled by changing the manifest (option b).

## 4. The core and the format libraries in v5

This is the risk the design plan named for its step 7, and it decides the order of the steps.
- **What the libraries expect.** The four format libraries (`1.x`) depend on the package `Kelly.Windows.Data` **≥ 2.26.1028.1006**, built from Kelly-Windows-Data-v2. That core holds `IDataFileReader`, `DataDirectory`, `DataManifest`, `DataManifestFile`, `DataFileProblem`, `DataFileFormat`, `SqlMatch`, `RecordMapper`, `DataFolderWriter` and `BoolJsonConverter`, and puts `IRecord` in `Kelly.Windows.Data.Interfaces`.
- **What a v5 project would get.** Kelly-Windows-Data-v3 publishes the **same package name**, at `3.x`. A v5 project that pins Kelly.Windows.Data 3.x and Kelly.Windows.Data.Csv 1.x satisfies the Csv library's dependency with the v3 core. The Csv library then runs against whatever that core holds.
- **Why that fails today.** The v3 core holds none of those types, and its `IRecord` is in `Kelly.Windows.Data.Database`. As it stands, the Csv library would fail with `TypeLoadException` or `MissingMethodException` at run time.

**Recommended (D2 a):** Kelly-Windows-Data-v3 takes v2's core, with the **same names, namespaces and signatures**, copied with their tests, and moves `IRecord` to `Kelly.Windows.Data.Interfaces`. The libraries then run against either core without a second build. A v3 test calls each library v5 uses against the v3 core, so a break shows in the v5 build, not in Revit:
- Csv;
- Json, for `JsonLinesFileWriter` and `JsonSettingsFile`.

**Pins under the one-layer rule.** The libraries are not layers, so `KTR0006` doesn't cover them. Kelly-Windows-Data-v3 itself must not reference them, because they depend on it. The first v5 layer that needs CSV pins `Kelly.Windows.Data.Csv` next to its one layer pin; that is Kelly-Revit-v5, which registers the reader. BuildConfigs' `LayerPackages.Build.targets` needs to allow that (a small BuildConfigs change, TDD there).

## 5. Steps

Bottom-up. Each step is test-first on `develop` and ends with a package. The next repo up re-pins that exact version in its `Directory.Packages.props`. "Build and repin" steps run no tests.

0. **Before any code:** D1–D8 settled 2026-10-30 (section 7). Run the straightening's step 5 in-Revit tests as the baseline.
1. **Kelly-Windows-Data-v3** (package 3.x): add v2's core.
   - Move `IRecord` to `Kelly.Windows.Data.Interfaces`. This breaks Kelly-Domain's 24 records, which change one global using in step 3.
   - Add `IDataFileReader`, `DataDirectory`, `DataManifest`, `DataManifestFile`, `DataManifestSource`, `DataFileProblem`, `DataFileFormat`, `SqlMatch`, `JsonFileLoadException`, `RecordMapper`, `DataWriteResult` and `DataFolderWriter` from Kelly-Windows-Data-v2, with their tests (D2), plus the short-name record-type lookup (D1).
   - Test that the Csv library's `CsvDataFileReader` reads a v3 test record through `DataDirectory`, and that the Json library's `JsonLinesFileWriter` writes one. The test project may pin the libraries; `src` may not.
   - Leave the SQL Server and JSON code in place for now (step 7 removes it), so nothing above breaks.
2. **Kelly-Windows-v3** (3.x): replace `SqlRecordCache<TRecord, TModel>` with a record cache that is given its records (`Func<IReadOnlyList<TRecord>>`), not a connection string and a procedure name. Delete `SqlRecordCache` and its tests. Re-pin Kelly-Windows-Data-v3.
3. **Kelly-Domain** (1.x): the data store and the Revit-free readers.
   - Change the `IRecord` using; add `BuiltInCategoryBindingRecord`.
   - **`DataStore`** (D3): v4 Kelly-Revit's `DataStore`, moved down to Domain because v5's records live there.
     - It loads the 22 files it needs from a `DataDirectory` it is given (the host registers `CsvDataFileReader`).
     - It checks every file's SHA-256 and row count against the manifest.
     - It keeps typed lists, dictionary indexes and `Find…` lookups:
       - GroupTypeId by Id; BuiltInCategoryBinding by (DefinitionId, RevitVersion); ProductRangeParameterDefaults by ProductRangeId;
       - System by Id and by signature; ProjectToSystem by (ProjectNumber, ConfigurationId); Project by Id and by (FilePath, FileStore); Configuration by Guid;
       - ConnectorPreparations by (GroupName, ConnectorName); ConnectorGrouping and ConnectorMapping by Id; SizeSymbol by TradeId;
       - ComponentAndLookupsView by Id; Product by component Id and by product code; Gauge by (MaterialTypeId, Thickness); MaterialAndLookupsView by (Name, MaterialGroupDotName).
   - The caches (`ComponentCache`, `ProductCache`, `ProductRangeCache`, `ServiceCache`, `SystemCache`, `TerminologyCache`, `ExternalParameterDefinitionCache`) build from the store.
     - `ExternalParameterDefinition` takes its group type and category bindings from the store, not two queries per definition.
     - `ProductRangeCache` takes its defaults from the store, not one query per range.
   - `ConnectorPreparationResolver`, `ConnectorSizeDataResolver`, `GaugeNameResolver`, `MaterialAndLookups` and `ProjectSystemQueries` take the store, or a narrow lookup interface it implements, not `IDatabaseReader` or a connection string. `ContentQueries` becomes three store properties, or goes.
   - Delete:
     - `DatabaseConnections`, with its `Read`, `Test`, `ReadContent` and `ReadGeneral`;
     - `ApplicationSessionStore` and `Open` (D4);
     - `AddInConfiguration.DatabaseConnections` and `StoredProcedureGaugeReadWhereEquals`.
     
     `ApplicationSession` stays as an in-memory object.
   - `ServerData` keeps its seam, renamed `DataFiles` (D7). `CategoryTypes` comes from the store, not from `CategoryType.json` (D6).
   - Domain's test fakes (`FakeDatabaseDataService`, `NonDisposableDatabaseReader`) give way to a test store built from in-memory records. Run the tests in Net481, Net80 and Net100. Re-pin Kelly-Windows-v3.
4. **Kelly-Revit-Logic-v5** (5.x): re-pin Kelly-Domain.
   - `ServerDataService` builds its caches from the store, renamed `DataFileService`, with `CacheServerData` → `LoadDataFiles` (D7).
   - `SystemDocumentCache`, `SystemUpdaterElementService` (`FindSystemBySignature`), `MaterialElementDataModel`, `ScheduleGaugeElementDataModel`, `EndPreparationUpdaterElementService` and `SizeUpdaterElementService` read the store.
   - `ProjectInformationWrapper` keeps only the document constructor, with no connection string and no `Server*` methods. `ProjectInformationReconciler` is deleted (D5).
   - In-Revit tests: `Abstractions/KellyDefinitions.UseServerData` registers the test store, and `ProjectInformationWrapperTests` drops the server cases. Run in Revit 2024 with the installed add-in disabled.
   - Import BuildConfigs' `NoSqlServer.Build.targets`.
5. **Kelly-Revit-UI** (1.x): no SQL. Re-pin Kelly-Revit-Logic-v5, build 2024–2026 and run its tests.
6. **Kelly-Revit-v5**: the host and the modules.
   - **`App`:**
     - Delete `ResolveConnectionStrings`, with its fallback connection strings (the straightening's open item), plus `App.DatabaseConnections` and `CacheCategoryTypeRecords`.
     - Add v4's one load path, `LoadDataFiles`: the manifest check, the "Kelly Tools For Revit Data Error" dialog, the "Loading Data Files" progress bar and the export log line. Startup fails without `Data\`.
     - Register the store with `ServerData` and Logic. Pin `Kelly.Windows.Data.Csv` (section 4).
   - **Sessions and projects:** `ApplicationSessionService` keeps the in-memory session only. `DocumentOpenedEventHandler` drops the reconcile call. It already raises `ActiveProjectSignal` from the document's own JHK Active Project, so nothing replaces it (D5).
   - **Commands:** Contenter's three custom-data commands and Developer's `ProductRangeSchedulesCommand` read the store. Trade.All's recache button on the Updater panel becomes "Reload Data", with v4's behaviour, and `ManualUpdaterExtensions` stops reloading (D8).
   - **Configuration:** delete the `StoredProcedure*` settings and the `connectionStrings` section of the `.config`. Turn `NoSqlServerConfigCheck` on.
   - **Build and test:** build 2024–2026 without installing (`KTR0004`). Run `Tests.Revit` in Revit 2024 with the add-in disabled. Install with `-p:InstallAddin=true` only when Chris says.
7. **Kelly-Windows-Data-v3** (3.x) again: remove the old SQL Server and JSON code.
   - Delete `src/Database` (`SqlServerService`, `ServerServiceBase`, `IDatabaseReader`/`IDatabaseWriter`, `ConnectionStringResolver`, `DatabaseConnectionTester`), and `src/Json` except `BoolJsonConverter`. The Json and SqlServer libraries already hold copies.
   - Drop Dapper, Microsoft.Data.SqlClient and System.Configuration.ConfigurationManager. Code that still writes JSON lines or settings files (Logic's operation logs, the add-in's settings) pins the Json library.
   - Re-pin the five repos above, bottom-up, and check that the add-in folder no longer gets `Microsoft.Data.SqlClient.dll` or `Dapper.dll`.
8. **Docs:**
   - Each repo's README (running the tests, SOLID), Changelog (dated headings) and XML docs.
   - `.claude/CLAUDE.md`: startup no longer touches SQL Server; delete "with the add-in loaded, opening a project reconciles…"; `DefinitionRegistry` and `ServerData` read the data files.
   - The same reconcile sentence in `BuildConfigs/SHARED-AGENTS.md`.
   - `Kelly Tools Major Versions and Branches.md` (the v5 data row), the v4 plan's "v5 still names 6" note, `KTR v5 Layer Straightening Plan.md` (its open connection-string item), and the release-notes doc (v5 content only when Chris says).
9. **Database:** once v5 is installed, add to `db-deprecation` the procedures that only v5 still called: the `_20261014` ApplicationSession pair and `Project_Insert`/`Project_UpdateWhereIdEquals` among them. The 8 that the exporter calls stay.

## 6. The writes and what replaces them

`Program Files` can't be written by standard users, so nothing is written back to the data files.

| Write | v4 did (D1/D2, 2026-10-21) | Recommended for v5 |
|---|---|---|
| ApplicationSession insert at startup and update at shutdown | dropped; `ApplicationSession` is an in-memory object | the same: delete `ApplicationSessionStore`; `ApplicationSessionService` keeps the in-memory session (D4) |
| Project insert when a project has no row | dropped; no reconcile | the same: Project Information and its JHK shared parameters live in the document only; new projects reach `dbo.Project` by another route (D5) |
| Project update on every open | dropped | the same (D5) |
| ProjectSession, ProjectMetricsLog | dropped | v5 already has none |

## 7. Open decisions

- **D1. How v5 finds its files in the manifest (decided 2026-10-30, Chris: a).** The manifest names v4 record types.
  - a. (**chosen**) The v3 core matches by short name: `ReadAll<T>()` takes the manifest entry whose `RecordType` ends in `.` + `typeof(T).Name`, and `Verify` resolves a `RecordType` by its short type name in the record assemblies it is given. No exporter or v2 change.
  - b. The exporter writes short names and bumps the manifest's schema version; v2's core must then accept both.
  - c. v5 keeps a map from v4 names to its own types.
- **D2. Sharing the core (decided 2026-10-30, Chris: a).**
  - a. (**chosen**) Kelly-Windows-Data-v3 copies v2's core types with the same names, namespaces and signatures, and moves `IRecord` to `Kelly.Windows.Data.Interfaces` (a one-line using change in about 40 v5 files). The writer types (`DataWriteResult`, `DataFolderWriter`) come too: the Csv library's `CsvDataWriter` uses `DataWriteResult`, so leaving it out would leave a library class that fails to load. The duplicated types are a known DRY gap, guarded by a v3 test that runs the Csv reader and the Json writer against the v3 core.
  - b. The libraries get a second build against the v3 core.
  - c. A new package holding the shared types, referenced by both cores and the libraries (reverses the 2026-10-22 "no Core repo" decision and touches v4). Possible later, as its own work.
- **D3. Where the data store lives (decided 2026-10-30, Chris: Kelly-Domain).** Beside the records, caches and resolvers that read it; Revit-free, so tested in Net481/Net80/Net100 without Revit; in line with the straightening's rule that stores and queries live in Kelly-Domain or Kelly-Revit-Logic. Kelly-Revit-v5 builds it at startup from `Data\` (registering `CsvDataFileReader`) and hands it down through a startup seam that replaces `AddInConfiguration.DatabaseConnections`; Domain never picks a file format. Rejected: Kelly-Revit-Logic-v5 (Domain's readers can't reach it; in-Revit tests only) and Kelly-Revit-v5 as in v4 (breaks the straightening's rule).
- **D4. Application sessions (decided 2026-10-30, Chris: in memory, as in v4).** Nothing in v5 reads the session except the service that writes it. Delete `ApplicationSessionStore`, `Open`, `ApplicationSession.GetRecord` and `ApplicationSessionRecord`; `ApplicationSessionService` keeps building the `ApplicationSession` at startup and sets its stop time at shutdown. Usage reporting from `dbo.ApplicationSession` stops for v5, as it did for v4. Rejected: a local JSON-lines log, and removing the session entirely.
- **D5. Project reconcile (decided 2026-10-30, Chris: none, as in v4).** Delete `ProjectInformationReconciler` and `ProjectInformationWrapper`'s `Server*` methods and connection string. Opening a project reads and writes nothing; the document is the only source of its project information, changed by the Project Information Editor. The ribbon already follows the document: `DocumentOpenedEventHandler` raises `ActiveProjectSignal` from the document's own JHK Active Project before the reconcile, so only the reconcile call goes. Edits in `dbo.Project` no longer reach documents, and new projects get no `dbo.Project` row or JHK Project ID automatically (added on the server by another route), as in v4 since 2026-10-22. `Project.csv` is still loaded. Rejected: a read-only reconcile from `Project.csv`.
- **D6. Category types (decided 2026-10-30, Chris: read the CSV).** `App.CacheCategoryTypeRecords` reads `CategoryType.json` from `C:\Program Files\JH Kelly\Kelly Tools For Revit\Data` (Logic's `PathExtensions.GetApplicationDataDirectory`), the folder v4 shares, which since 2026-10-22 holds `CategoryType.csv` and no JSON: a v5 build today finds no file (not run to see whether it gets none or fails). Both `ServerData.CategoryTypes` and Developer's `ProductRangeSchedulesCommand` take the store's category types from `CategoryType.csv` (30 rows, with `IsValidForSpool` and `IsValidForStratus`, which the procedure left out). `CacheCategoryTypeRecords` and `ContentQueries`' category-type read go; the `BoolJsonConverter` attributes on `CategoryTypeRecord` stay (harmless for CSV). Rejected: the exporter also writing a JSON copy.
- **D7. Names (decided 2026-10-30, Chris: rename now, to v4's terms).** `ServerData` → `DataFiles` (Domain, 35 files), `ServerDataService` → `DataFileService` (Logic), `CacheServerData` → `LoadDataFiles`, `KellyDefinitions.UseServerData` → `UseDataFiles`, the progress text "Caching Server Data" → "Loading Data Files"; Trade.All's `AllServerDataRecachePushButton` ("Refresh The Locally Cached SQL Server Data") becomes "Reload Data" (D8). Done within steps 3, 4 and 6, with each repo's README, Changelog and XML docs in the same commits, and a "data files" entry in `UBIQUITOUS-LANGUAGE.md`. Rejected: keeping the names, and renaming later.
- **D8. "Reload Data" in v5 (decided 2026-10-30, Chris: reuse the Updater-panel button).** Trade.All's `AllServerDataRecachePushButton`/`AllServerDataRecacheCommand` (Updater panel, `Commands/ServerRecache`) become "Reload Data" (`DataReload…`), with v4's behaviour: keep the current data if a file can't be read, and load an export older than the loaded one (by `ExportedUtc`) only if the user says yes. Manual updaters stop reloading: `ManualUpdaterExtensions` no longer calls `CacheServerData`, so, as in v4, nothing is read from disk after startup except by "Reload Data". Rejected: moving the button to the Kelly Manage tab, and keeping the reload in every manual updater run.
- **Carried over from v4, still open:**
  - SQL Server stays the master and the exporter is re-run;
  - who runs the exporter, and when;
  - `Project.csv`, with client names and addresses, on every workstation;
  - the columns without a source listed in `manifest.json`;
  - Revit 2026 has no `BuiltInCategoryMeta` rows.
- **Shared data folder:** v4 and v5 install into the same `Kelly Tools For Revit` folder, so they share one `Data\` export. That is fine while both read the same 23 files. A v5-only export would need the exporter to stay compatible with both, which D1 b makes harder.
