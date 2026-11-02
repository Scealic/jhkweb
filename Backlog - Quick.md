# Backlog - Quick (Move to Linear...)

Within each section: open items first, then done items. Every version section starts with a "To Organize" heading for new items that still need a category. The percentage under each version counts every checkbox in it, sub-items included; superseded items count as closed.

## Kelly Tools For Revit v4

**Complete: 35% (20 of 57)**

### To Organize

### Architecture

- [ ] (High, review 2026-11-02) Key document sessions by `Document`, not the deprecated JHK Project ID: nothing assigns that ID any more, so projects without one share one session and closing one deletes the other's; new and non-Kelly documents get none, and Hanger Place dereferences it without a null check (Kelly-Revit-v4 `DocumentSessionService.cs:62`; commits 1fd8e20, 0594dca)
- [ ] (Review 2026-11-02) `App` is a static service locator: 29 files reach `App.Data`/`App.Lookups` directly, and `App.GetDefinition` pops a MessageBox from a catch-all
- [ ] (Review 2026-11-02) Move Kelly Tools For Revit knowledge out of Kelly-Windows-Data-v2: `DataDirectory.DefaultPath` (`DataDirectory.cs:235`), the Revit records `BuiltInCategoryBinding`/`RibbonPanel`/`RibbonTab`, and the VCS database names in `DataManifestSource`
- [ ] (Review 2026-11-02) Kelly-Revit-Logic-v4 pins `Kelly.Windows.Data.Json` only for the operation log; put it behind an `IOperationLog`
- [ ] (Review 2026-11-02, pre-existing) Move `TaskDialogSimple`/`TaskDialogsCommon` (user-facing dialogs) out of Kelly-Revit-Logic-v4
- [x] "Straighten" the architectural layer connections that make up Kelly Tools For Revit v4

### Data

- [ ] (High, review 2026-11-02) Gauge lookup needs an exact `double` match: the old `USP_Table_Gauge_ReadWhereEquals` rounded to `DECIMAL(10,4)`, the new key is the raw `feet * 12`, so floating-point noise misses and the gauge custom data is not written; round to 4 places on both sides (Kelly-Revit-v4 `GaugeNameResolver.cs:41`, `DataStore.cs:145`)
- [ ] (Review 2026-11-02) Replace `JsonFileLoadException` with a `DataFileLoadException`: CSV, manifest and hashing errors all throw the JSON one
- [ ] (Review 2026-11-02) Rename `SqlMatch`/`BySqlKeys`; `TrimEnd()` also strips tab, CR, LF and NBSP, which SQL's `=` does not
- [ ] (Review 2026-11-02) A missing CSV/SQLite column is silently zero-filled (only an extra column fails); JSON ignores unknown properties, so "strict" differs per format
- [ ] (Review 2026-11-02) One value converter for all formats: `RecordMapper`, `SqliteRecordReader` and CsvHelper convert differently; `StrictJsonReader` is duplicated in Kelly-Windows-Data-v2 and -Json
- [ ] (Review 2026-11-02) `DataFolderWriter.Commit` moves files one by one: a failure partway leaves new files beside the old manifest, and the add-in then refuses to start
- [ ] (Review 2026-11-02) Catch IO errors in the data load (`App.cs:223` catches only `JsonFileLoadException`/`InvalidOperationException`; a file locked by the exporter escapes the data-error dialog) and per file in `DataDirectory.Verify`/`CheckPresence`
- [ ] (Review 2026-11-02) Reload Data swaps `App.Data` only; combo boxes and element services built from the old data stay until the project is reopened, and the user is not told
- [ ] (Review 2026-11-02) Make the shared data rows `init`-only so one missed `with { }` copy can't corrupt the session's data
- [ ] (Review 2026-11-02) `DatabaseConnectionTester` (Kelly-Windows-Data-SqlServer) logs the connection string with its password (a test enshrines it) and only `e.StackTrace`, not the message
- [ ] (Review 2026-11-02) Column order rests on `MetadataToken`, so an IDE member sort changes the exported layout and hashes (already reverted twice: d890444, a0252c6); add a column-order attribute or layout test
- [x] Find any loose JSON read/write code that can be refactored to use the Kelly.Windows.Data.Json library — done 2026-11-02 (Kelly-Revit-v4 commit 1c9c4e8, pushed): Kelly-Revit-v4's `ModuleCreatorViewModel` and `SpoolCreateViewModel` read and write their settings through `JsonSettingsFile.TryRead`/`TryWrite`, as v5 does; no other v4 add-in or Logic code calls Newtonsoft directly. Builds for 2024, 2025 and 2026 (no install); not tested in Revit. Left as is: Kelly-Windows-Data-v2 keeps its own copy of `StrictJsonReader` and writes `data-manifest` with `JsonConvert` (`DataFolderWriter`); it sits below the Json library, so it cannot call it
- [x] Fully refactor to use CSV data files instead of SQL Server data — done 2026-10-22: KTR reads only the CSV files and ships no SQL client (build 4.26.1022.1411)
  - [x] Build a standalone SQL-to-CSV export tool to regularly export the required data from SQL Server. Migrate it into the KTR Manager tool in the future.
  - [x] Implement the [SQL-to-CSV Migration Plan - v4.md](SQL-to-CSV Migration Plan - v4.md) — no work items left; its section 5 lists decisions still open

### Versioning, build and install

- [ ] (High, review 2026-11-02) The package feed sorts backwards: `Kelly.Windows.Data.Net481` is at 2.x (v4), 3.x (v5) and 13 stale 4.26 builds under one ID (likewise `Kelly.Windows.*`, and the format libraries' 26.10.22 builds above 1.26); only exact pins keep the right one. Purge the stale 4.26 and 26.x packages; consider separate v4/v5 package IDs
- [ ] (Review 2026-11-02) `Revit.Build.props:26` demotes MSB3277, CS0612 and CS0618 to messages for every Revit project, hiding obsolete warnings (e.g. `ProjectInformationWrapper`'s "This Smells A Bit")
- [ ] (Review 2026-11-02) `AssemblyVersion` changes every minute from local time (not reproducible; DST can reverse it); fix it at `Major.0.0.0` and keep the time in file and package versions
- [ ] (Review 2026-11-02) Kelly-Windows-v2's `NuGet.Config` relies on machine-level feeds, unlike the other repos
- [ ] (Review 2026-11-02) Process: one Changelog entry per release instead of an "installed as build" commit per install (nine on 2026-10-22), and pin bumps in their own commits
- [x] Refactor the installation directory to be "C:\Program Files\JH Kelly\Kelly Tools For Revit 4". The add-in manifest files will need to be built and named as such. — done 2026-11-02 (Kelly-Revit-v4 commit d87120c, BuildConfigs `AddinInstall.Build.targets`): installs to `Kelly Tools For Revit 4\<year>` with `Kelly Tools For Revit 4.addin`, and renames the other versions' manifests to `.addin.x`. No v4 build installed since: Revit 2024–2026 have only the v5 manifest
- [x] Update my .sln solution files to the .slnx format — checked 2026-10-30: all four v4 repos have only a `.slnx`
- [x] Add a `<Generation>4</Generation>` property to the .csproj that indicates the application major version (1 to 5)
- [x] Include `<Generation>` in the NuGet package build
- [x] Implement `<MajorVersion>` at the .csproj level — done 2026-10-26: every v4 project sets it (2 for Kelly-Windows-Data and Kelly-Windows, 4 for Kelly-Revit-Logic and Kelly-Revit)
- [x] Add a document explaining the Kelly Tools major versions and which git branch each should be developed on — [Kelly Tools Major Versions and Branches.md](Kelly Tools Major Versions and Branches.md)

### Updaters and project information

- [ ] (Review 2026-11-02) Updaters and the session are removed in `DocumentClosing`, which can be cancelled, leaving an open project without them; unregister in `DocumentClosed`, each step in its own try
- [ ] (Review 2026-11-02) New projects get no auto updaters: `DocumentCreatedEventHandler` is still empty
- [ ] (Review 2026-11-02) If `Suspend` throws in `SetPowerIcon`, callers see "not suspended" and never resume, so the updaters stay off (`AutoUpdaterService.cs:253`)
- [ ] (Review 2026-11-02) `ProjectInformationWrapper`: Architect, GeneralContractor, MarketSector and NameAbbreviation hard-coded "TBD"; MarketSector is editable in the Project Information Editor but never saved; `GetFabricationConfiguration` not null-checked; `IsKellyProject` finds JHK Project Number by name, not GUID
- [ ] (Review 2026-11-02) The null check and toggle body are copied into four `*AssignerAutoSetToggleCommand`s; move them into `CommonAutoAssignerTools`
- [x] Delete any and all Active Project functionality: whatever is reading/writing the shared parameter "JHK Active Project" — done 2026-10-30 in v4 and v5: no Active Project button, the trade tabs are always enabled, and opening a project builds the updaters and views only in a Kelly project (`IsKellyProject`: JHK Project Number). The parameter stays in the data files and existing projects. Built, not installed
- [x] Enable the ProjectInformationEditor, but only have it edit the project shared parameters
- [x] Each document should have its own set of IUpdaters

### Tools, ribbon and UI

- [ ] (Review 2026-11-02) Fix the bugs the user guides documented as behaviour: Rules Of Credit shows "5,000.00 %"; Purge Unused Families deletes tag families with placed tags; Set Revision Date drops the leading zero ("09:30:15" → "93015"); a debug button borrows the "Align Conduit Bottom" label
- [ ] (Review 2026-11-02) Check the user guides in Revit: 224 "TODO: confirm" markers, none verified
- [x] Allow descriptions longer than 50 characters in the Layout Point Exporter — done 2026-10-21 (Kelly-Revit-v4 commit 9af4bbf): `LayoutPoint.Description` allows 4 to 65 characters (`StringLength(65)` and `IsValid`); the exporter still flags a host whose joined descriptions reach 255 characters
- [x] Update the tooltip of every IExternalCommand by gleaning what each tool does from the code behind the command — done 2026-10-26: all 153 push buttons (commit 6601016e, build 4.26.1026.1106)
- [x] Create icons for ribbon buttons that have the value "Scrum" for the `ImageName` property — done 2026-11-02 in source (Kelly-Revit-v4 commits 0f59534 and 8abfe9d): the 20 Scrum buttons and the six whose image never existed (among them `ContextValueAddPushButton` and `LayoutPointFileDirectoryOpenPushButton`) have their own icons; the Scrum images are removed. Not checked in Revit

### Code quality and cleanup

- [ ] Are there any TODO notes that can be handled? — 2026-10-30: 135 `// todo` comments (Kelly-Revit-v4 122, Kelly-Revit-Logic-v4 11, Kelly-Windows-v2 2, Kelly-Windows-Data-v2 0); unchanged 2026-11-02 (rechecked after the icon commits)
- [ ] (Review 2026-11-02) Hard-coded people: `App.cs:102` detects the developer by username `"ChrisHildebranAtWork"`; `App.cs:145` has the misspelled `CHILDEBRAN@JHELLY.COM`; the missing-parameters dialog and the Stratus command name Adam Fuller. Use one support-contact constant
- [ ] (Review 2026-11-02) The Telerik licence key is committed (`src/teleriklicense.cs`, installer `.ise`) and `App.cs:142` shows it in an error dialog; the `.ise` also holds a name and phone number
- [ ] (Review 2026-11-02) Remove dead SQL-era code: `SetIdTransaction`, the `GetRecord()` stubs (15 DTOs, and `ExternalParameterDefinition`/`BuiltInCategoryWrapper` in Logic), the `REVIT2027` branch, stale "SQL Server" comments
- [ ] (Review 2026-11-02) Kelly-Revit-Logic-v4 README: pin and path sections contradict the code; "SOLID principles" section missing
- [ ] (Review 2026-11-02) Ten owner-less "TODO: Verify" items left by removing names (Logic `FabricationPartExtensions.cs`); `GetBearerSizeOfProfiledBearer` still returns `-1.0`
- [x] Ensure every type lives in its own file: only one type per file unless nested — done 2026-11-02 (ReSharper, all v4 solutions): a scan of every `.cs` file in the four v4 repos finds no file with two top-level types. `DocumentExtensions.cs` (Kelly-Revit-Logic-v4) holds three `partial` blocks of one class and `FileDialogTools.cs` (Kelly-Revit-v4) one class per `#if` branch, both one type. Kelly-Windows-Data-v2’s split (`DataManifestFile.cs`, `CsvSampleRecord.cs`, `CsvDecimalSampleRecord.cs`, `TestRecords.cs` deleted) is not committed yet
- [x] Remove references to "Casey Puyleart" and "Jason Sherwood" — done 2026-07-07 (commit 01124c1 "Update contacts"); checked 2026-10-28: no match left in Kelly-Windows-Data-v2, Kelly-Windows-v2, Kelly-Revit-Logic-v4 or Kelly-Revit-v4

### Testing

- [ ] (Review 2026-11-02) Kelly-Revit-v4 and Kelly-Revit-Logic-v4 have no tests although the data layer, updater lifecycle and sessions were replaced; both High bugs are test-catchable. `DataStore.Load` could be tested outside Revit
- [ ] (Review 2026-11-02) Add `Author`/`Description` to `[Test]`/`[TestCase]`: missing on Kelly-Windows-v2 463 of 468, Kelly-Windows-Data-v2 50 of 161, -Json 50 of 129, -SqlServer 25 of 60
- [ ] (Review 2026-11-02) Weak tests: `CoreBoundaryTests` checks only type names; the SqlServer integration tests skip themselves with no server, so they likely never run
- [x] Final test: KTR needs to work without connecting to a JHK network (no VPN, etc.)



## Kelly Tools For Revit v5

**Complete: 56% (38 of 68)**

### To Organize

### Architecture and services

- [ ] Refactor the application services if needed
- [ ] Refactor OperationService (`Run` and `Run<T>`) — call sites sorted in [OperationService Run Migration.md](OperationService Run Migration.md); 2026-11-02: 80 `new OperationService(` sites are still on the old pattern
- [ ] Tool to recover OperationService logs (.json, .jsonl)
- [ ] Improve the progress bar service
- [ ] Plans to deprecate the following
   - [ ] [DEPRECATE-COMPONENT-PRODUCT-UPDATERS.md](DEPRECATE-COMPONENT-PRODUCT-UPDATERS.md) — 2026-10-30: the Component and Product updater configurations (Auto and Manual) and element services are still in Kelly-Revit-Logic-v5
   - [x] Deprecate Project Session — only `ProjectSessionId = -1` remains in the operation log record
- [x] "Straighten" the architectural layer connections that make up Kelly Tools For Revit v5 — done 2026-10-30: [KTR v5 Layer Straightening Plan.md](KTR v5 Layer Straightening Plan.md) has nothing left
- [x] Split the tabs into separate libraries
- [x] Rename the Kelly.Revit.* projects to...
  - [x] Kelly.Revit.Trade.All
  - [x] Kelly.Revit.Trade.Duct
  - [x] Kelly.Revit.Trade.Pipe
  - [x] Kelly.Revit.Trade.Developer
  - [x] Kelly.Revit.Trade.Contenter
  - [x] Kelly.Revit.Trade.Manager
- [x] Move every PushButton type next to its associated IExternalCommand

### Data and file I/O

- [ ] Implement an application/tool settings file. Hierarchical: the application settings at the top level and each tool's settings below them (if applicable)
   - [ ] Have the new Kelly.Windows.Data.Json library read/write the application and tool settings file
- [ ] Is there any other file data I/O that Kelly.Windows.Data.* can handle?
   - [ ] Find any loose JSON read/write code that can be refactored to use the Kelly.Windows.Data.Json library — 2026-11-02: none in Kelly-Revit-v5, Kelly-Revit-UI or Kelly-Revit-Logic-v5 (the Module Creator and Spool Create settings already use `JsonSettingsFile`; Kelly-Domain only carries `[JsonProperty]` attributes on records). Kelly-Windows-Data-v3 keeps its own copy of `StrictJsonReader` (same code as the Json library's, other namespace), used by `DataDirectory` for the data manifest, and writes the manifest with `JsonConvert` (`DataFolderWriter`); it sits below the Json library, so it cannot call it
- [x] Fully refactor to use CSV data files instead of SQL Server data — done 2026-10-30: no `Microsoft.Data.SqlClient` left in any v5 layer, and clean 2024–2026 builds put no SqlClient, Dapper or Azure DLL in the add-in folder (plan step 7)
   - [ ] Step 9 of the plan: mark the SQL procedures only v5 called, once v5 is installed everywhere
   - [x] Implement the [SQL-to-CSV Migration Plan - v5.md](SQL-to-CSV Migration Plan - v5.md) — steps 1–8 done 2026-10-30
   - [x] Build a standalone SQL-to-CSV export tool to regularly export the required data from SQL Server. Migrate it into the KTR Manager tool in the future — Kelly-Revit-Data-Exporter serves every major version (CSV, JSON or SQLite)
- [x] Have the new Kelly.Windows.Data.Csv library read/write the layout point .csv files — done 2026-10-30: `LayoutPointCsvFormat` in Kelly-Revit-Logic-v5 reads and writes through Kelly.Windows.Data.Csv's `CsvTable` (replaced the CsvHelper class map)
   - [x] Refactor the Layout Point Importer to use the Kelly-Windows-Data-Csv library — through `LayoutPointTools.ReadImportCandidates`
   - [x] Refactor the Layout Point Exporter to use the Kelly-Windows-Data-Csv library — through `LayoutPointTools.WriteCsv`
- [x] ~~Refactor all SQL operations to JSON operations~~ — superseded: KTR reads CSV only
   - [x] ~~Export all required tables to JSON files~~ — superseded
- [x] ~~Migrate SQL table data to JSON data files~~ — superseded: KTR reads CSV only
- [x] Plan splitting the SQL Server code out of Kelly.Windows.Data into its own package, "Kelly.Windows.Data.SqlServer" — planned and built 2026-10-22 ([design plan](Kelly-Windows-Data Format Libraries - Design Plan.md)); v5 adopted it in step 7 (2026-10-30)

### Versioning, build and install

- [ ] Configure the InstallShield project for different install types
   - [ ] Detailer
   - [ ] Manager
   - [ ] Contenter
- [x] Refactor the installation directory to be "C:\Program Files\JH Kelly\Kelly Tools For Revit 5". The add-in manifest files will need to be built and named as such. — done 2026-11-02 (Kelly-Revit-v5 commit 9a8a048d, BuildConfigs `AddinInstall.Build.targets`): installs to `Kelly Tools For Revit 5\<year>` with `Kelly Tools For Revit 5.addin`; installed for Revit 2024–2026 (the old `Kelly Tools For Revit.addin` is now `.addin.x`)
- [x] Update my .sln solution files to the .slnx format — done 2026-10-30: all six v5 repos have only a `.slnx` (Kelly-Revit-v5 commit bbbeb914)
- [x] Add a `<MajorVersion>5</MajorVersion>` property to the .csproj / implement `<MajorVersion>` at the .csproj level — done 2026-10-30: every v5 project sets it (Tests.Revit in commit 41ed1df5), and `RequireMajorVersion` defaults to true in BuildConfigs `Version.Build.props`
- [x] Include `<MajorVersion>` in the NuGet package build — `Version.Build.props` versions packages `MajorVersion.yy.MMdd.HHmm`
- [x] Add a document explaining the Kelly Tools major versions and which git branch each should be developed on — [Kelly Tools Major Versions and Branches.md](Kelly Tools Major Versions and Branches.md)

### Updaters and project information

- [ ] Enable the ProjectInformationEditor (like KTR v4), but only have it edit the project shared parameters — 2026-10-30: no ProjectInformationEditor in the v5 modules
- [x] Delete any and all Active Project functionality: whatever is reading/writing the shared parameter "JHK Active Project" — done 2026-10-30 in v4 and v5: no Active Project button, the trade tabs are always enabled, and opening a project builds the updaters and views only in a Kelly project (`IsKellyProject`: JHK Project Number). The parameter stays in the data files and existing projects. Built, not installed
- [x] Refactor the IUpdater service to create IUpdaters for each project document that is opened and destroy them for each project document that is closed, like KTR v4 (each document should have its own set of IUpdaters) — done in source (commit 4da0adb5, 2026-10-21): `AutoUpdaterService.Build` runs on open, and EventService subscribes `DocumentClosingEventHandler`, which calls `Remove`; the `AutoUpdaterService` XML remark now describes the closing handler. Not yet tested in Revit.

### Domain types

- [ ] Change Point3 to a struct — still a `sealed class` in `Kelly-Windows-v3/src/Geometry/Point3.cs`
- [ ] Implement the new "FractionalLength" struct to convert decimal feet and inches to fractional feet and inches — 2026-10-30: the struct and its tests are in Kelly-Domain; nothing in the Revit layers uses it yet
- [x] Create and implement a "LayoutPointId" struct

### Tools, ribbon and UI

- [ ] Enable light and dark mode for the versions of Revit that have that feature — 2026-11-02: no v5 code handles Revit's theme (`ThemeChanged` is only subscribed with a null handler in v4's EventService)
   - [ ] Light-mode and dark-mode icons (use the proper green color)
- [ ] Suspended Support Manager: split the rod grid view into a separate grid below the main grid view, showing the vertical support members of the selected suspended supports
- [ ] Implement the scope control in every window that doesn't have it yet
- [ ] Is there anything to improve in my controls? `C:\repo\jhkweb\Kelly-Revit-UI\src\Controls\`
- [x] Allow descriptions longer than 50 characters in the Layout Point Exporter — done 2026-10-14 (Kelly-Domain commit 6343bcb): `Kelly.Domain` `LayoutPoint.Description` allows 4 to 65 characters (`StringLength(65)` and `IsValid`); `LayoutPointExportCandidateFactory` still flags a host whose joined descriptions reach 255 characters
- [x] Update the tooltip of every IExternalCommand by gleaning what each tool does from the code behind the command — done 2026-11-02 in source (Kelly-Revit-v5 commits 978ffda5 and 831461d8): all 149 push buttons have a tooltip rewritten from the command's code (median 206 characters; v4 223). Not checked in Revit
- [x] Create icons for ribbon buttons that have the value "Scrum" for the `ImageName` property — done 2026-11-02 in source (Kelly-Revit-v5 commits 41bb6ad5 and 5032838c): all 20 Scrum buttons have their own icons; `Scrum16.png`/`Scrum32.png` are removed and no push button names "Scrum". Built, not installed; not checked in Revit
- [x] Move the "Extend and Reset Trapeze Rods" tools to another panel; the one they're on is for annotations — done 2026-10-30: a new Supports panel (Kelly-Revit-v5 commit 129c360f)

### Code quality and cleanup

- [ ] [IA Prompt - Architectural Analysis and Cleanup.md](IA Prompt - Architectural Analysis and Cleanup.md) — 2026-11-02: the linked file is still not in `C:\repo\jhkweb`
- [ ] Have Claude refactor the Vicious tools
- [ ] Are there any TODO notes that can be handled? — 2026-10-30: 114 `// todo` comments (Kelly-Revit-v5 55, Kelly-Revit-Logic-v5 54, Kelly-Windows-v3 2, Kelly-Domain 2, Kelly-Revit-UI 1, Kelly-Windows-Data-v3 0); unchanged 2026-11-02
- [x] Ensure every type lives in its own file: only one type per file unless nested — done 2026-11-02 (Kelly-Revit-UI commit 6b35c1d, Kelly-Revit-Logic-v5 commit 652d330): after the ReSharper pass, Claude split the two test files left, `TestRibbonModules.cs` (Kelly-Revit-UI, into seven files) and `RecordingProgress.cs` (Kelly-Revit-Logic-v5, into `RecordingProgress.cs` and `RecordedProgress.cs`); a scan of every `.cs` file in the six v5 repos finds no file with two top-level types (`DocumentExtensions.cs` in Kelly-Revit-Logic-v5 is three `partial` blocks of one class). `Revit.UI.Tests` passes (167 of 167, 2024); `Revit.Logic.RevitTests` builds, not run in Revit
- [x] Remove references to "Casey Puyleart" and "Jason Sherwood" — done 2026-07-07 (commit 01124c17); checked 2026-10-28: no match left in any v5 repo

### Testing and documentation

- [ ] Final test: KTR needs to work without connecting to a JHK network (no VPN, etc.)
- [ ] [Unit Test Implementation - Kelly Tools For Revit.md](Unit Test Implementation - Kelly Tools For Revit.md) — 2026-11-02: written (baseline run of every v5 suite, backfill method, 320 types with no test); backfill under way
- [x] Implement unit testing in every repository used by Kelly Tools For Revit v5 — checked 2026-10-30: all six v5 repos have a test project (Kelly-Revit-UI has two: with and without Revit)
- [x] Add a requirement somewhere for a unit-test coverage section in each repo
- [x] Use Claude Documents to create a Kelly Tools document: what it is, and a description of each IExternalCommand

### Process

- [ ] Linear backlog cleanup
- [ ] **Learn how to use Linear issues to prompt Claude!!**



## VCS-Database-General-Schema

**Complete: 0% (0 of 1)**

### To Organize

### Schema changes

- [ ] Delete the "dbo.Project.IsActive" column. Don't do this until after 2027-01-01.



## Other

**Complete: 0% (0 of 2)**

### To Organize

### Subscriptions

- [ ] Cancel GitKraken AI; I just need the basics.
- [ ] Cancel Figma for now.
