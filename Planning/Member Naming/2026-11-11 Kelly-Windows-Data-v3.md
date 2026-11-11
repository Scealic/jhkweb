# Member Naming Check: Kelly-Windows-Data-v3 (pilot)

2026-11-11. Linear: KTR5-4798. Approach: [Member Naming Check](../Member%20Naming%20Check.md).

**Read:** all 18 source files in `src` (1,138 lines): every member, including private and internal ones, and every finding at every severity, so the pilot can settle the open decisions. Each finding was checked against its body, and for interface members against their implementations in the layers above.

**Result:** 1 interface with misleading names, 2 other misleading names, 6 vague names, 7 style notes. Every other member says what it does. The XML docs are thorough, and the three findings that matter most are in the two files that have no docs at all (`ICache`, `BoolJsonConverter`).

## Misleading

| # | Member | File | What it does | Suggested name | Reach |
|---|---|---|---|---|---|
| M1 | `ICache.GetData()` | `Caching/ICache.cs:14` | Reads the records and builds the models into `Objects`; it returns nothing and does not touch the cache (`RecordCache.GetData`, `Kelly-Windows-v3`). | `LoadModels()` | `DataFileService` in Logic calls it; 7 caches in Domain inherit it from `RecordCache` |
| M1 | `ICache.Objects` | `Caching/ICache.cs:8` | Holds the models `GetData` built, waiting to be published. Its type is `object`. | `LoadedModels` (and a typed `IReadOnlyList<TModel>` on `RecordCache`) | same |
| M1 | `ICache.FillCache()` | `Caching/ICache.cs:12` | Clears the cache, then publishes `Objects` into it; it reads nothing. | `PublishLoadedModels()` | same |
| M1 | `ICache.ClearCache()`, `CacheName` | `Caching/ICache.cs:6,10` | Clear the cache; the cache's type name. Accurate, but "Cache" repeats the type. | `Clear()`, `Name` | same |
| M2 | `JsonFileLoadException` (type) | `Services/JsonFileLoadException.cs:6` | Thrown for **every** data file format (CSV too) and by `DataDirectory.ComputeSha256` for a missing file of any kind. Its own summary says so. | `DataFileLoadException` | 19 files: Json 10, Csv 2, Domain 2, Logic 3 |
| M3 | `RecordMapper.MapAll(reader)` | `Services/RecordMapper.cs:96` | Maps the rows **remaining** from the reader's current position, not all rows; its private worker is already called `MapRemaining`. | `MapRemaining(reader)` | Csv and Json writers |

M1 is one issue: the three-step lifecycle of a cache (load, clear, publish) is named as if `GetData` fetched something and `FillCache` read data. A reader of `DataFileService` (`GetData`, `ClearCache`, `FillCache`) can't tell which step does the I/O. `ICache` has no XML docs, so nothing at this layer explains it. Type names are out of scope, but M2 is included because the type's name contradicts its own documentation.

## Vague

| # | Member | File | Note | Suggested name |
|---|---|---|---|---|
| V1 | `RecordMapper.Result(int rows)` | `Services/RecordMapper.cs:107` | Builds a `DataWriteResult` from a row count; "Result" reads like a property. | `CreateWriteResult(int rows)` |
| V2 | `DataDirectory.Verify()` | `Services/DataDirectory.cs:211` | Reads every file and compares row counts; the name doesn't say what is verified, next to `CheckPresence`, which does. | `VerifyRowCounts()` |
| V3 | `DataDirectory.TryResolveRecordType(file, problems, out type)` (private) | `Services/DataDirectory.cs:264` | On failure it also **adds a problem** to the list it is given; `Try…` suggests no side effect. | `TryResolveRecordTypeOrAddProblem` (or return the problem) |
| V4 | `RecordIndex.BySqlKeys(...)` | `Services/RecordIndex.cs:21` | First row of a key wins, like `FirstByKey`, but only one of the two names says so. | `FirstBySqlKeys` |
| V5 | `DataManifest.Settings` (internal) | `Services/DataManifest.cs:80` | Serializer settings; "Settings" alone could be anything. | `SerializerSettings` |
| V6 | `DataFolderWriter._pending` (private) | `Services/DataFolderWriter.cs:150` | File names whose write has started but not finished, kept so `Dispose` can delete their `.tmp`. | `_filesBeingWritten` |

## Style

| # | Member | Note |
|---|---|---|
| S1 | `DataWriteResult.Rows`, `DataManifestFile.Rows` | An `int` count named as a collection; `RowCount` would read better. **`DataManifestFile.Rows` is a key in every exported manifest.json**, so a rename must keep the JSON name (`[JsonProperty("Rows")]`) or raise `CurrentSchemaVersion`. |
| S2 | `DataDirectory.DirectoryInfo` and its constructor parameter `directoryInfo` | Repeats the type name; `DataFolderWriter` calls the same thing `Folder`. Pick one (`Folder`). |
| S3 | `DataFolderWriter.Write(..., write)` | The delegate parameter has the method's own name; `writeRows` says what it does. |
| S4 | `DataManifest.FileName` (const, "manifest.json") vs `DataManifestFile.FileName` (an entry's file) | Same name, different things, one type apart; `ManifestFileName` for the constant. |
| S5 | `SqlMatch.Key(value)` | Noun-named method; consistent with the house style below, so leave it. |
| S6 | `BoolJsonConverter.ReadJson` locals `s`, `b` | One-letter names (locals are outside the check; noted only). |
| S7 | `DataManifest.FileOf(Type)` | Noun-named lookup that returns null when there is no match; `FindFile` would say so. Low value. |

## What the pilot settles for the other layers

1. **Noun-named methods are house style.** Pure functions here are named for what they return (`Columns`, `Key`, `FileOf`, `FirstByKey`), consistently. Treat that as the convention, and flag a noun name only when the member has a side effect or builds something new (V1).
2. **Check interface members through their implementations.** `ICache` looks harmless alone; its meaning lives in `RecordCache` one layer up and `DataFileService` two layers up.
3. **Flag serialized members.** A public property that is a JSON key (manifest.json, the data files' columns through `DataFileFormat.Columns`) can't be renamed without a format change. Mark these in the inventory, so a finding on one names the cost.
4. **Missing XML docs predict findings.** Both undocumented files held the worst names. Put undocumented members first in the read pass.
5. **Small layers need no script.** 18 files were read directly in one pass. Keep the script and subagents for Domain, Logic and the add-in (250 to 450 files each).

## Linear issues (2026-11-11)

All in KWD3 (Kelly Windows Data 3), each related to KTR5-4798.

1. **M1 (`ICache`):** already filed as **KWD3-7** ("Decide `ICache`'s fate", 2026-11-02). Commented with the findings: it is no longer orphaned (`RecordCache` implements it), and the proposed renames if it stays. Logic's own `IDocumentCache.GetData` has the same name and is for the Logic pass.
2. **M2 (`JsonFileLoadException`):** already filed as **KWD3-13** (rename to `DataFileLoadException`, decided 2026-11-09), with follow-ups in KWDC, KWDJ, KD and KTRL5. Commented that `ComputeSha256` throws it too.
3. **M3 + V1 (`RecordMapper`):** new, **KWD3-14** (1 point). The CSV and JSON writers' follow-ups are to be filed when it is picked up.
4. **V2–V6 and S1–S4:** new, **KWD3-15** (2 points), with S1 kept JSON-compatible.
