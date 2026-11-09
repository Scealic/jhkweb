# Linear issue splits, 2026-11-09 13:35

Scope: KWD3-2, the one open issue at 16 points that the 2026-11-09 hygiene check found with no sub-issues.

| Team | Reviewed | Fine | Split | Unclear | New issues | Existing to link |
|---|---|---|---|---|---|---|
| KWD3 | 1 | 0 | 1 | 0 | 6 | 0 |

## [KWD3-2](https://linear.app/jhkelly-ktr/issue/KWD3-2): Rename `JsonFileLoadException`, the declared failure for every format, CSV included (16)

**Signals:** crosses repositories (the type is declared in the data layer and thrown or caught in the CSV and JSON format libraries, Kelly-Domain and Kelly-Revit-Logic-v5); v4 and v5 at once (the format libraries pin `Kelly.Windows.Data` 2.x, the v4 data layer, while v5 builds on 3.x from `Kelly-Windows-Data-v3`; both declare the type, which is the "v2 signature compatibility" the issue names).

**Where it is used (2026-11-09):** declared in `Kelly-Windows-Data-v3/src/Services/JsonFileLoadException.cs` (and in the 2.x package; `Kelly-Windows-Data-v2` is not checked out under jhkweb); 6 files in Kelly-Windows-Data-v3, 10 in Kelly-Windows-Data-Json, 2 in Kelly-Windows-Data-Csv, 2 in Kelly-Domain (XML docs and a test helper), 3 in Kelly-Revit-Logic-v5 (`DataFileLoader`, `DataFileService`, the test `TestJsonReader`). No v4 layer above the data layer names it.

**Shape:** sub-issues. **Keep:** parent only (goal and title kept, estimate removed).

| # | Team | Title | Est. | Relation | Goal |
|---|---|---|---|---|---|
| 1 | KWD2 | Rename `JsonFileLoadException` to `DataFileLoadException` in the v4 data layer | 2 | sub-issue; blocks 3, 4 | Rename the type in Kelly-Windows-Data-v2 with its tests, README, Changelog and XML docs; pack |
| 2 | KWD3 | Rename `JsonFileLoadException` to `DataFileLoadException` in the v5 data layer | 2 | sub-issue; blocks 3, 4, 5 | Same in `Kelly-Windows-Data-v3` (`Services/JsonFileLoadException.cs`, `DataDirectory`, `StrictJsonReader`, `IDataFileReader`, tests); pack |
| 3 | KWDC | CSV reader: throw `DataFileLoadException` | 1 | sub-issue; blocked by 1, 2 | `CsvDataFileReader` and its tests use the new name; repin both data-layer packages |
| 4 | KWDJ | JSON reader and repository: throw `DataFileLoadException` | 2 | sub-issue; blocked by 1, 2 | The 10 files of Kelly-Windows-Data-Json (`JsonDataDirectory`, `JsonDataFileReader`, `JsonFileRepository`, `StrictJsonReader`, `GlobalUsings`, tests) use the new name; repin |
| 5 | KD | `DataStore`: document and test `DataFileLoadException` | 1 | sub-issue; blocked by 2 | XML docs of `DataStore` and the test reader in `DataStoreTests` use the new name, after Kelly-Windows is repinned on the new data package |
| 6 | KTRL5 | Data file loading: catch `DataFileLoadException` | 2 | sub-issue; blocked by 5 | `DataFileLoader`, `DataFileService` docs and `TestJsonReader` use the new name; repin Kelly-Domain |

Total 10 points (was 16).

## Open question

The issue says to rename "when that constraint lifts": the format libraries are shared by v4 and v5 through the same type name. The split renames it in both data layers at once, which lifts the constraint by changing both sides together. The new name `DataFileLoadException` is a proposal.
