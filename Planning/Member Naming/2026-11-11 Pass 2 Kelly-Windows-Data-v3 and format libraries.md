# Member naming check, pass 2: Kelly-Windows-Data-v3 and format libraries (2026-11-11)
Second pass after the first-pass renames landed. Sources: group G01 (Kelly-Windows-Data-v3, -Csv, -Json, -Sqlite, -SqlServer). Readers: Sonnet; checked by: Sonnet (code opened for every Misleading and bug item; about one in four Vague and Style items spot-checked).

## Summary
- Confirmed: 0 Misleading, 9 Vague, 4 Style (batched).
- Bugs: 0 confirmed, 3 dropped.
- This layer is clean. The slice has no wrong names; the findings are vague words and two uses of one word for different things.
- No suggested name clashes with an existing member (grep of the five repos, src and tests).

## Confirmed bugs
None.

## Proposed rename issues

### R1: Data manifest: separate the export origin from a file's source query
Two things share the word "source": where the whole export came from, and the query behind one file.

| Severity | Member | File:line | What it does | Suggested | Callers | Serialized/Shown |
|---|---|---|---|---|---|---|
| Vague | `DataManifestSource` (type) | `Kelly-Windows-Data-v3/src/Services/DataManifestSource.cs:4` | Server, two databases, who and machine of one export | `DataExportOrigin` | `DataFolderWriter`, `DataManifest`, Exporter `DataExporter`, `SqliteDataExporter`, `Program` (6 files) | Stored in `manifest.json`; keep the JSON key names |
| Vague | `DataFolderWriter.Write(..., string source, ...)` and `DataManifestFile.Create(..., string source, ...)` parameter | `DataFolderWriter.cs:75`, `DataManifestFile.cs:44` | The stored procedure or SELECT that produced one file | parameter `query` | 2 files | no |
| Vague | `DataManifestFile.Source` (property) | `DataManifestFile.cs:65` | Same query text | `SourceQuery` with `[JsonProperty("Source")]` | 2 files | Serialized: `manifest.json` key `Source` stays |

### R2: Data folder writing: say that `DataFolderWriter.Write` only stages a file
| Severity | Member | File:line | What it does | Suggested | Callers | Serialized/Shown |
|---|---|---|---|---|---|---|
| Vague | `DataFolderWriter.Write` | `Services/DataFolderWriter.cs:75` | Writes `<name>.tmp` and adds the manifest entry; nothing is in place until `Commit` | `StageFile` | 2 files, 4 lines (Exporter) | no |
| Vague | `DataDirectory.VerifyRowCounts` | `Services/DataDirectory.cs:211` | Also reports unusable record types, missing or unreadable files and unregistered extensions | `VerifyFiles` | 2 files, 5 lines | no |

Do R1 and R2 together: both touch the Exporter's calls to `DataFolderWriter`. Fix the `DataFileProblem` summary (names only `VerifyRowCounts`) in the same change.

### R3: `CsvTable`: one meaning for "record" and "row"
| Severity | Member | File:line | What it does | Suggested | Callers | Serialized/Shown |
|---|---|---|---|---|---|---|
| Vague | `CsvTable.ReadRecords` | `Kelly-Windows-Data-Csv/src/CsvTable.cs:23` | Returns raw `string[]` fields per line; "record" elsewhere means a typed `IRecord` | `ReadFields` | 4 files, 6 lines: `LayoutPointCsvFormat`, `LayoutPointTools`, `PointToPipeReader`, `ScheduleExportService` | no |
| Vague | `CsvTable.ReadRows` | `CsvTable.cs:46` | Returns one dictionary per line, keyed by column name | `ReadRowsByColumnName` (keep `ReadRows` if preferred) | 5 files, 6 lines | no |
| Vague | `CsvTable.Write` | `CsvTable.cs:91` | Replaces a whole file with a header and rows | `WriteFile` | 4 files, 13 lines | no |

Callers are in Kelly-Domain and Kelly-Revit-Logic-v5, so this needs a pack and repin of the layers above. Batch it with the next Csv package.

### R4: SQL Server library: vague service and query names
| Severity | Member | File:line | What it does | Suggested | Callers | Serialized/Shown |
|---|---|---|---|---|---|---|
| Vague | `ServerServiceBase.CreateConnectionCore` (protected abstract) | `Kelly-Windows-Data-SqlServer/src/ServerServiceBase.cs:22`, `SqlServerService.cs:338` | Hook the public `CreateConnection` calls; returns an unopened connection. Here `Core` does not mean "needs the caller's transaction" | `NewConnection` | own calls only | no |
| Vague | `ServerServiceBase` (type) | `ServerServiceBase.cs:6` | Base of the database services; owns `CreateConnection` and `Dispose` | `DatabaseServiceBase` | `SqlServerService`, Exporter `SqlExportSource` | no |
| Vague | `IDatabaseReader.SelectMany<T>(name, parameters)`, `SqlServerService.SelectMany`/`SelectManyAsync` | `IDatabaseReader.cs:34`, `SqlServerService.cs:228` | All rows of a stored procedure that takes parameters; clashes in meaning with LINQ `SelectMany` | `SelectAllWhere` | none outside the library and its tests | no |

### R5 (batched Style issue): small names in the data libraries
| Severity | Member | File:line | What it does | Suggested | Callers | Serialized/Shown |
|---|---|---|---|---|---|---|
| Vague | `SqlMatch.StringEquals` | `Kelly-Windows-Data-v3/src/Services/SqlMatch.cs:17` | SQL `=` on strings: case-insensitive, trailing spaces ignored, null never equal; reads like `string.Equals` | `EqualsAsSql` (update the `Key` summary that refers to it) | 1 file, 2 lines | no |
| Style | `DataDirectory.CountOf<T>` (private) | `DataDirectory.cs:244` | Reads the whole file and counts it | `CountRows<T>` | private | no |
| Style | `IDatabaseWriter.Update(name, List<IRecord>)` | `IDatabaseWriter.cs:46` | Updates many records; the insert side is `InsertMany` | `UpdateMany` (single overload keeps `Update`) | 2 files | no |
| Style | `SqlServerReader` (type) | `SqlServerReader.cs:10` | Builds a connection string and opens a `DbDataReader`; `IDatabaseReader` is a different kind of reader | `SqlServerCommandReader` | `SqlExportSource`, `SqlServerService` | no |
| Style | `StrictJsonReader.Read<T>` parameter `description` (v3) vs `recordTypeName` (Json) | `Kelly-Windows-Data-v3/src/Services/StrictJsonReader.cs:16`, `Kelly-Windows-Data-Json/src/StrictJsonReader.cs:16` | Two internal classes of one name, one parameter named two ways. The real issue is the duplicate class (DRY) | one name when the duplicate is merged | internal | no |

## Dropped or downgraded
| Finding | Group | Why |
|---|---|---|
| Possible bug: `SqliteRecordWriter.ColumnType` throws for `sbyte`, `ushort`, `uint`, `ulong`, `decimal`, `char` | G01 | Intended: the exception says "no column type" and the record types do not use them. Doc wording only |
| Possible bug: `DatabaseConnectionTester.ReportConnectionStates` writes the connection string | G01 | Documented in its summary; one startup-diagnostic caller. Not a name/body contradiction. Note: it prints before `Open`, so a password in the string would appear |
| Possible bug: `DataFolderWriter.Write` leaves the name in `_filesBeingWritten` when `writeRows` throws | G01 | Intended: `Dispose` uses the list to delete the stray `.tmp` file |
| Vague: `JsonDataDirectory.GetRepository<T>` hides the file read and cache | G01 | Summary says "shared repository"; `Get` fits the lookup |
| Vague: `JsonFileRepository` read members `GetAll`, `GetById`, `FindAll`, `FirstOrDefault`, `Any` | G01 | `Get` by key and `Find` by predicate is a consistent split |
| Style: `DataFileProblem` docs name only `VerifyRowCounts` | G01 | Docs wording, not a name; folded into R2 |
| Style: `Load` vs `Read` (`DataFileLoadException`, `JsonFileLoadMode`) | G01 | Reader's own note says keep it; 11+ files for no gain |
| Style: `DatabaseConnectionTester` / `ReportConnectionStates` | G01 | Name fits what it does |
| Style: `SqliteIdentifier` | G01 | One-member static helper; name says what it is |
| Style: hard-coded date format in `JsonLinesFileWriter`, repeated `DateFormat` constants | G01 | DRY, not naming |
| Style: noun-named pure methods (`RecordMapper`, `Columns`, `Key`, `FileOf`, `ConnectionString`) | G01 | House style |
