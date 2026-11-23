# Kelly.Windows.Data format libraries: design plan

*Written 2026-10-22; revised the same day: the core stays in Kelly-Windows-Data, under its current name. Nothing is built yet.*

**Goal:** take the format-specific code (CSV, JSON, SQL Server, SQLite) out of Kelly-Windows-Data into four small libraries, **one repo each**, that Kelly Tools For Revit **Major Version 4 and Major Version 5** both use. Each consumer then references only the formats it needs, so the Revit add-in no longer ships the SQL Server client.

**Decided (2026-10-22, Chris):**
- **Kelly-Windows-Data stays the core, under its current name.** No `Kelly-Windows-Data-Core` repo or package.
- Four new repos, one per library: Kelly-Windows-Data-Csv, -Json, -SqlServer, -Sqlite. The libraries are versioned on their own, not by KTR major version.
- v4 adopts them first. v5 adopts them later: **no v5 repo or branch changes until Chris says so.** v5 code may be read and copied into the new libraries; its own repos stay as they are.
- Nothing deferred: Sqlite is split now, and v5's JSON and SQL Server helpers are copied into the libraries now.
- v4 `IModel` drops `IDatabaseDataService`.
- `Net481`, `Net80` and `Net100` only; no `net46`.
- Kelly-Revit-Data-Exporter stays a standalone application. Its generic SQLite table writer moves into the Sqlite library; its catalog, command line and export orchestration stay.

## 1. Where the code is today

| | v4 Kelly-Windows-Data (`main-v2`, 4.26.1022.1126) | v5 Kelly-Windows-Data (`develop`) |
|---|---|---|
| Records | 48 in `Records/`; 12 use `[JsonConverter(typeof(BoolJsonConverter))]` | none (Kelly-Domain holds v5's domain types) |
| `IRecord` | `Kelly.Windows.Data.Interfaces` | `Kelly.Windows.Data.Database` |
| Data folder | `DataDirectory`, `DataManifest`, `DataFileProblem`, `SqlMatch` | none |
| CSV | `CsvDataFormat`, `CsvDataWriter`, `StrictCsvReader` (CsvHelper 33.0.1) | none |
| JSON | `JsonFileRepository<T>`, `JsonFileLoadMode`, `JsonFileLoadException`, `JsonFileSettings`, `StrictJsonReader`, `BoolJsonConverter` | `JsonFileRepository<T>`, `JsonLinesFileWriter<T>`, `JsonSettingsFile`, `BoolJsonConverter` |
| SQL Server | `SqlServerService`, `BaseServerService`, `IDatabaseDataService` (full CRUD, sync and async) | `SqlServerService`, `ServerServiceBase`, `IDatabaseReader`, `IDatabaseWriter`, `ConnectionStringResolver`, `DatabaseConnectionTester` |
| Other | `ICache`, `SuperfluousAttribute` | `CacheBase`, `ICache` |
| Packages | CsvHelper, Dapper, Microsoft.Data.SqlClient, Newtonsoft.Json | Dapper, Microsoft.Data.SqlClient, Newtonsoft.Json, System.Configuration.ConfigurationManager |

**Who uses what (2026-10-22):**
- v4 Kelly-Revit: `DataDirectory` (`ReadAll`, manifest, SHA-256), `DataManifest(File)`, `CsvDataFormat`, `JsonFileLoadException`, `SqlMatch`, the records.
- v4 Kelly-Revit-Logic: `JsonFileRepository`, the records.
- v4 Kelly-Windows: `IDatabaseDataService` (in `IModel`), `SqlServerService`, `JsonFileRepository`.
- Kelly-Revit-Data-Exporter: `DataDirectory.ComputeSha256`, `DataManifest(File)`, `CsvDataFormat`, `CsvDataWriter`, `JsonFileSettings`, `BoolJsonConverter`, the records. It references SqlClient and Microsoft.Data.Sqlite itself.
- v5 Kelly-Windows: `IDatabaseReader`, `IDatabaseWriter`, `SqlServerService`.
- v5 Kelly-Revit-Logic: `SqlServerService` (17 uses), `JsonLinesFileWriter`, `JsonFileRepository`.
- v5 Kelly-Revit: `SqlServerService`, `ConnectionStringResolver`, `DatabaseConnectionTester`, `JsonSettingsFile`, `JsonFileRepository`.

## 2. The core and the four libraries

Every repo follows the shared layer rules: `develop` only, TDD with NUnit 4, the `Author`/`Description` attributes, README, Changelog and SOLID sections, and the `Net481` / `Net80` / `Net100` configurations. Each has one solution, so `Package.Build.props` names its packages `<SolutionName>.<Configuration>`.

| Repo | Package (`.Net481/.Net80/.Net100`) | Namespace | Holds | Depends on |
|---|---|---|---|---|
| **Kelly-Windows-Data** (existing; the core) | `Kelly.Windows.Data` | unchanged (`Kelly.Windows.Data.Services`, `.Interfaces`, `.Records`, `.Converters`) | the records; `IRecord`; `DataDirectory` (folder, manifest, SHA-256, `ReadAll`, `Verify`, `CheckPresence`); `DataManifest`, `DataManifestFile`, `DataFileProblem`; `JsonFileLoadException`; `SqlMatch`; `IDataFileReader` (the seam below); `BoolJsonConverter`; `ICache`, `SuperfluousAttribute` | Newtonsoft.Json only (see 2.2) |
| Kelly-Windows-Data-Csv | `Kelly.Windows.Data.Csv` | `Kelly.Windows.Data.Csv` | `CsvDataFormat`, `CsvDataWriter`, `CsvDataFileReader` (today's `StrictCsvReader`) | Kelly.Windows.Data, CsvHelper 33.0.1 |
| Kelly-Windows-Data-Json | `Kelly.Windows.Data.Json` | `Kelly.Windows.Data.Json` | `JsonFileRepository<T>`, `JsonFileLoadMode`, `JsonFileSettings`, `JsonDataFileReader`, the shared repositories `DataDirectory.Get<T>`/`Reload` hand out today, `JsonLinesFileWriter<T>`, `JsonSettingsFile` | Kelly.Windows.Data, Newtonsoft.Json |
| Kelly-Windows-Data-SqlServer | `Kelly.Windows.Data.SqlServer` | `Kelly.Windows.Data.SqlServer` | `SqlServerService`, `ServerServiceBase`, `IDatabaseReader`, `IDatabaseWriter`, `ConnectionStringResolver`, `DatabaseConnectionTester` | Kelly.Windows.Data, Dapper, Microsoft.Data.SqlClient, System.Configuration.ConfigurationManager |
| Kelly-Windows-Data-Sqlite | `Kelly.Windows.Data.Sqlite` | `Kelly.Windows.Data.Sqlite` | `SqliteRecordWriter` (today's exporter `SqliteExportWriter`: a record type's table, column types and values) and `SqliteRecordReader` (a table back into records) | Kelly.Windows.Data (for `DataFileFormat`), Microsoft.Data.Sqlite |

### 2.1 Versioning

- **Kelly-Windows-Data** keeps its major-version-led versions: `4.yy.MMdd.HHmm` on v4's `main-v2`.
- **The four libraries** set `<MajorVersion>1</MajorVersion>` in every project file (decided 2026-10-22 as `<Generation>`, renamed 2026-10-26), so `Version.Build.props` gives `1.yy.MMdd.HHmm`, for example `1.26.1022.1300`. That is their own major version, independent of KTR's. The first packages, built before this, were `26.10.22.x`, which NuGet sorts above 1.x, so consumers pin exact versions.
- Each consumer pins an exact version, as today. A library change reaches a major version only when that major version re-pins.

### 2.2 What the core keeps, and why

- **No circular reference.** The libraries reference Kelly.Windows.Data, so Kelly.Windows.Data can't reference them. Two things therefore stay in the core:
  - `BoolJsonConverter`, because 12 records carry `[JsonConverter(typeof(BoolJsonConverter))]`;
  - a JSON read of `manifest.json` (`ReadManifest`).
  The core keeps Newtonsoft.Json for these, and drops CsvHelper, Dapper and Microsoft.Data.SqlClient.
- **`JsonFileLoadException` keeps its name and namespace.** Kelly-Revit catches it, and keeping it unchanged means no churn. It already covers CSV too.
- **`DataDirectory.Get<T>` and `Reload` move out.** They hand out `JsonFileRepository<T>`, which moves to the Json library, so they go with it, for example as `JsonDataDirectory`. v4 Kelly-Revit doesn't use them; nothing in v4 Logic or Kelly-Windows does either.

### 2.3 The two seams in the core

1. **Readers are plugged in.** `DataDirectory` takes a set of `IDataFileReader`s (`string Extension`, `IReadOnlyList<T> Read<T>(string path)`), and the format packages provide them, for example `new DataDirectory(folder, CsvDataFileReader.Instance)`. `ReadAll` picks the reader by extension and throws `NotSupportedException` for an extension nobody registered. Kelly-Revit registers CSV only, which also enforces "KTR reads CSV only" in one place.
   - **Transition:** while CSV and JSON still live in Kelly-Windows-Data, the existing constructors register both, so nothing changes for today's callers. They lose the built-in readers in step 5.
2. **Record types are resolved by the caller.** `Verify` and `CheckPresence` turn the manifest's `RecordType` name into a type. Today that means "an `IRecord` in this assembly". `DataDirectory` instead takes the assemblies to search. It defaults to its own, where v4's records are, so this changes nothing in v4.

### 2.4 SQL Server API

The two major versions' APIs differ. The library takes v5's (`IDatabaseReader`/`IDatabaseWriter`, `ServerServiceBase`) and adds the members v4 uses that v5 lacks: the async methods and `Delete`. v4 Kelly-Windows drops `IDatabaseDataService` from `IModel` (decided), so nothing in v4 needs the old interface.

## 3. What each consumer references afterwards

| Consumer | Kelly.Windows.Data | Csv | Json | SqlServer | Sqlite |
|---|---|---|---|---|---|
| v4 Kelly-Windows | ✔ | | ✔ | | |
| v4 Kelly-Revit-Logic | ✔ | | ✔ | | |
| v4 Kelly-Revit | ✔ | ✔ | | | |
| Kelly-Revit-Data-Exporter | ✔ | ✔ | ✔ | (keeps its own SqlClient) | ✔ |
| v5, later | ✔ | | ✔ | ✔ | |

**The SQL client leaves the v4 add-in** once Kelly-Windows-Data no longer carries the SQL Server code (step 5) and v4 Kelly-Windows drops `IDatabaseDataService` from `IModel` (step 6). The no-SQL build check keeps passing throughout.

## 4. Steps

Bottom-up; each step ends with a package, and the next step pins it.

1. **The four new repos** (done 2026-10-22): scaffolded under `C:\repo\jhkweb` (solution, library and test projects), made git repos by Chris, each with `develop` holding the scaffold. Chris adds the GitHub remotes; Claude never creates remote repos.
2. **Seams in Kelly-Windows-Data** *Done 2026-10-22: `IDataFileReader`, `DataDirectory(directoryInfo, readers, recordAssemblies)` with `Readers`/`RecordAssemblies`, built-in CSV and JSON readers by default, and `DataFileFormat` (`DateFormat`, `Columns`); 297 tests, package 4.26.1022.1239, `8f9d9e7` (not pushed). Pinned 2026-10-22: all four libraries pin 1239 (packages 26.10.22.1247; Csv 0852833, Json 73452f2, SqlServer 73004dc, Sqlite c24788b), Csv's and Json's readers implement `IDataFileReader`, and Csv, Json and Sqlite use `DataFileFormat` instead of their own copies. Sqlite references Kelly.Windows.Data again for it.* (v4 `main-v2`, test first): `IDataFileReader` and reader registration, with CSV and JSON registered by default for now; record-type assemblies, defaulting to its own. Also one `DateFormat` constant in the core for every format: today Csv's `CsvDataFormat.DateFormat` and Json's `JsonFileSettings.DateFormat` each hold `yyyy-MM-dd HH:mm:ss.fff` (a DRY gap left by the move), and Sqlite's `SqliteRecordWriter.DateFormat` too. Likewise one column rule (public settable properties in declaration order): Csv's `CsvDataFormat.Columns` and Sqlite's internal `RecordColumns.Of`. All of them then point at the core. No caller changes. Package `4.yy…`.
3. **Csv and Json:** *Csv done 2026-10-22: `CsvDataFormat`, `CsvDataWriter` and `CsvDataFileReader` (public; `Instance`, `Extension`, `Read<T>(path)`) with 30 tests, package 26.10.22.1220, `develop` 74d941d; it implements `IDataFileReader` once step 2 adds it. Json done 2026-10-22: `JsonFileRepository<T>`, `JsonFileLoadMode`, `JsonFileSettings`, `JsonDataDirectory` (the `Get`/`Reload` repositories), `JsonDataFileReader`, and v5's `JsonLinesFileWriter`/`JsonSettingsFile`, with 116 tests, package 26.10.22.1226, `develop` f5d7609.* move the code and tests in; `CsvDataFileReader` and `JsonDataFileReader` implement `IDataFileReader`; the Json library takes `Get<T>`/`Reload`. Copy in v5's `JsonLinesFileWriter` and `JsonSettingsFile` with their tests. Package both.
4. **SqlServer:** *Done 2026-10-22: v5's `ServerServiceBase`, `IDatabaseReader`/`IDatabaseWriter`, `ConnectionStringResolver`, `DatabaseConnectionTester`, and v4's `SqlServerService` (async members included) on them; 86 tests incl. LocalDB integration, package 26.10.22.1230, `develop` 4fc0f1e.* v5's service and interfaces, plus v4's extra members, with both major versions' tests (unit and LocalDB integration). Package.
   **Sqlite:** *Done 2026-10-22: `SqliteRecordWriter` (takes records; the exporter keeps its row mapping and gap report) and a strict `SqliteRecordReader`, 34 tests, package 26.10.22.1234, `develop` 11d3566; no Kelly.Windows.Data reference.* move the exporter's `SqliteExportWriter` and its tests in as `SqliteRecordWriter`, and add `SqliteRecordReader` test first. Package.
5. **Kelly-Windows-Data:** *Done 2026-10-22 (`2b50d1e`, package 4.26.1022.1253, not pushed): CSV, JSON and SQL Server code and tests removed, `Get`/`Reload` removed, no built-in readers (the reader-less constructors read none), CsvHelper, Dapper and SqlClient dropped; 135 tests incl. `CoreBoundaryTests`. Re-pinned 2026-10-22: all four libraries pin 1253 (packages 26.10.22.1256; Csv df67410, Json 642ee2c, SqlServer 2aa660b, Sqlite ca5c562); only SqlServer depends on the SQL client now.* delete the moved code and the default reader registration; drop CsvHelper, Dapper and SqlClient. Package `4.yy…`.
6. **v4 consumers**, re-pinned bottom-up: *Done 2026-10-22, none pushed: Kelly-Windows `318d9fd` (4.26.1022.1309; `IModel` and the dead `TimerService` deleted, explicit Net481 references), Kelly-Revit-Logic `3a2bcf9` (4.26.1022.1311; uses Json's `JsonLinesFileWriter`, its own copy deleted), Kelly-Revit `333c88ca`/`dc7115ed` (`DataDirectory` gets only `CsvDataFileReader`; builds 2024–2026, not installed, not yet run in Revit), exporter `a0af223` (Csv, Json, Sqlite; 175 tests; real CSV and SQLite exports checked).*
   - Kelly-Windows: drop `IDatabaseDataService` from `IModel`.
   - Logic: switch to the Json library's namespace.
   - Kelly-Revit: register `CsvDataFileReader` in `App.LoadDataFiles`; build 2024–2026 without installing; then a Revit 2024 run before any install.
   - Exporter: pin Csv, Json and Sqlite, and drop its own SQLite writer.

   6a. **The exporter's generic code moves into the libraries** (asked 2026-10-22): *Done 2026-10-22, none pushed.* The exporter keeps its catalog, options, format prompt and command line (769 source lines, from about 1,160); the rest is now:
   - **Core** (`79e349d`, package 4.26.1022.1330, 161 tests): `RecordMapper` (was internal in the exporter; `MapAll`, `Result` added), `DataWriteResult` (was `ExportWriteResult`), `DataFolderWriter` (the atomic `.tmp` write, hash and manifest-last commit, from `DataExporter`), `DataManifest.Create`, `CurrentSchemaVersion`, `DataManifestFile.Create` and `DataManifestSource` (were `ExportManifest` and `ExportSourceInfo`). `manifest.json` is written and read with one set of settings.
   - **Csv** `fcc6d32` (`CsvDataWriter.WriteRows`, 36 tests), **Json** `f0bc69e` (`JsonDataWriter`, 129), **Sqlite** `5ecaf94` (`SqliteRecordWriter.WriteRows`, 38), **SqlServer** `3423e9d` (`SqlServerReader.ConnectionString` and `Open`, 92 with LocalDB): packages 1.26.1022.1335, pinning the core 1330.
   - **Exporter** `b536d50`: pins core 1330 and the four libraries 1335 (SqlServer replaces its direct SqlClient reference); its copies and their tests deleted; `FormatLibrariesTests` fails if one comes back; 143 tests. A real CSV export was byte-identical, file for file, to the installed data; a real SQLite export completed.
   - Kelly-Windows, Kelly-Revit-Logic and Kelly-Revit stay on core 1253 and Csv/Json 1300: they only read, and nothing they use changed.
7. **v5 (later, only when Chris says so):** v5's Kelly-Windows-Data takes the same seams, and its consumers pin the libraries.
8. **Docs:** each repo's README and Changelog. The shared rule "all data access lives in Kelly.Windows.Data" becomes "in Kelly.Windows.Data and its format libraries". `CLAUDE.md`'s layer diagram shows the four libraries beside Kelly-Windows-Data.

## 5. Risks

- **v5 and the core.** The libraries build against v4's `Kelly.Windows.Data` 4.x. v5 publishes the same package name with its own versions and a different `IRecord` namespace (`Kelly.Windows.Data.Database`). Before v5 can use the libraries, its Kelly-Windows-Data needs the same core types under the same names, or the libraries need a v5 build. Settle this at step 7.
- **Namespace churn**, smaller than before: only the moved types change namespace (`Kelly.Windows.Data.Services` → `.Csv` / `.Json` / `.SqlServer`).
- **Declaration-order tests:** code cleanup that sorts members breaks the CSV and SQLite column tests (it happened twice on 2026-10-22). The moved test records keep their "keep this order" comments.
- **Two consumers of each library:** a change one major version needs must not break the other. Pins keep each safe until it re-pins.
- **Test files must not import `Kelly.Windows.Data.Services`.** A `using` after a file-scoped namespace beats the library's own namespace, so a test would silently bind to Kelly-Windows-Data's same-named copy (found 2026-10-22 in Csv and Json; fixed with single-type aliases). This stops mattering once step 5 deletes the copies.
