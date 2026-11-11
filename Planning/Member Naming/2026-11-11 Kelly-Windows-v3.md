# Member Naming Check: Kelly-Windows-v3

2026-11-11. Linear: KTR5-4798. Approach: [Member Naming Check](../Member%20Naming%20Check.md). Previous layer: [Kelly-Windows-Data-v3](2026-11-11%20Kelly-Windows-Data-v3.md).

**Read:** all 115 source files in `src` (about 7,700 lines), every member at every severity, private ones included. Three Sonnet agents each read a third in full: (1) Files, Text, Collections; (2) Measurements, Wpf, Palettes, Commands; (3) Common, Reflection, Prompts, Hosting, Logging, Geometry, Workstation, Persistence. I checked every Misleading finding below against the code before it went in. Reach is the number of files outside Kelly-Windows-v3 that use the name (a short or common name gives a noisy count).

**Result:** this layer has far weaker names than Kelly-Windows-Data-v3: 32 misleading rows below (some cover several overloads), plus two already in KW3; about 40 vague and 30 style findings. The weak names cluster in the files without XML docs: `FileServices`, `StringExtensions`, `StringBuilderExtensions`, `ListExtensions`, `ListTools`, `AssemblyExtensions`, `CodeLocations`, `ObjectExtensions`, `LoggerServices`, the Measurements helpers (`DoubleExtensions`, `RoundAmount`, …) and the Palettes. The documented files (`ServiceProvider`, `ProgressBarService`, `RecordCache`, `ExceptionExtensions`) are mostly accurate; where they are not, the docs already admit it ("despite the name").

## Behaviour bugs found on the way (filed)

| Issue | Member | Bug |
|---|---|---|
| **KW3-29** | `FileServices.DeleteContentsOfDirectory` | Returns early when the folder has no top-level files, so its subfolders are never deleted. |
| **KW3-30** | `LoggerServices.OpenFile` / `FullPath` | Opens `<name>_.log`; the rolling Serilog sink writes `<name>_<date>.log`, so the file never exists. |
| **KW3-31** | `StringExtensions.TruncateWithEllipsis` | Returns the whole text when `maxLength` ≤ 3. |
| *(in R5 below)* | `ObjectExtensions.PrintProperties` | A null `StringBuilder` is replaced by a local one that is thrown away, so the output is lost. |

## Already in KW3

| Issue | Covers |
|---|---|
| **KW3-20** | `IProgressReporter.LoopBegin` / `LoopEnd` / `LoopSkipped`: called once per item, not per loop (Domain 2, Logic 15, Revit 2). Already planned as a rename. |
| **KW3-10** | `ConstructionServices.ConvertFractionToDecimalFeet`: returns **inches** (its docs say "despite the name"). KW3-10 changes its parsing; the rename (`ParseLengthToInches`) should ride with it. |
| **KW3-22** | `ClipboardTools.SetText(List<string>)` adds a placeholder to the caller's list. |
| **KW3-12** (Done) | `WorkstationModel.Get` text; its name is still vague (R5). |

## Misleading

### Text and Files

| Member | File | What it does | Suggested | Reach |
|---|---|---|---|---|
| `StringExtensions.ToTitleCase` | `Text/StringExtensions.cs:320` | Never changes case: inserts spaces before capitals and digits (PascalCase → words); with `preserveNumbers=false` strips every non-letter first | `SplitPascalCaseWords` | **Domain 6, Logic 9, UI 4, Revit 11** |
| `StringExtensions.StripAllButSafe` | `Text/StringExtensions.cs` | Replaces a listed set of characters with a space and collapses white space; keeps everything else | `ReplaceUnsafeCharactersWithSpace` | none |
| `StringExtensions.ToLog` | `Text/StringExtensions.cs` | Appends a timestamped line to `<dir>\<file>.log`, creates the folder, swallows every exception | `AppendToLogFile` | none |
| `StringExtensions.Write` | `Text/StringExtensions.cs:382` | Appends (never overwrites) and swallows IO errors | `AppendToFile` | noisy |
| `StringBuilderExtensions.ToCsv` / `ToLog` | `Text/StringBuilderExtensions.cs` | Write the builder to a timestamped file and may open it; `To…` reads as a conversion. Parameter order differs between the two | `WriteToCsvFile` / `WriteToLogFile` | ToCsv: Domain 2, Logic 6, Revit 3; ToLog: Logic 3 |
| `FileDialogTools.IsShowDialog` | `Files/FileDialogTools.cs:19` | Shows a modal dialog, returns whether the user confirmed | `ShowAndConfirm` | Revit 3 |
| `FileServices.DeDuplicateLines` | `Files/FileServices.cs:133` | Removes duplicates **and sorts** the lines, then rewrites the file | `DeDuplicateAndSortLines` | none |
| `FileServices.AppendFile` (6 overloads) | `Files/FileServices.cs` | Appends one line (never a file), always returns true; one `string` parameter is named `stringBuilder` | `AppendLine` (void) | none |
| `FileServices.WriteToFile` | `Files/FileServices.cs` | Appends the line only if it is not already in the file | `AppendLineIfMissing` | none |
| `FileServices.StripLineFromFile` | `Files/FileServices.cs` | Deletes line N; returns the removed line, or an error sentence as an ordinary result | `RemoveLineAt` | none |

### Collections

| Member | File | What it does | Suggested | Reach |
|---|---|---|---|---|
| `ListExtensions.IsNullOrEmptyArgument` | `Collections/ListExtensions.cs:36` | An `Is…` that **throws** `ArgumentNullException` (named after the element type) unless `throwException` is false | `ThrowIfNullOrEmpty` + `IsNullOrEmpty` | none |
| `ListExtensions.IsNullOrEmptyLocal` | `Collections/ListExtensions.cs:52` | Only calls the above; "Local" means nothing | delete | none |
| `ListTools.GetGroupings` | `Collections/ListTools.cs:28` | Returns only the duplicated values, as `Tuple<object,object>(count, key)` | `FindDuplicateCounts` | Logic 2, Revit 1 |

### Hosting, Logging, Common, Reflection, Workstation, Persistence

| Member | File | What it does | Suggested | Reach |
|---|---|---|---|---|
| `IApplicationService.SuperClassName` / `ApplicationService.SuperClassName` | `Hosting/ApplicationService.cs:17` | The service's **own** (most-derived) type name, title-cased; no super class involved | `DisplayName` | Logic 6, UI 9, Revit 14 (noisy: also `CommandBase.SuperClassName` in UI) |
| `ExceptionExtensions.HandleIt` | `Common/ExceptionExtensions.cs:18` | Shows the error prompt and returns the report text; handles nothing, throws when no prompt is registered | `ReportToUser` | **Logic 22, UI 1, Revit 13** |
| `ServiceProvider.AddService` / `AddServices` | `Hosting/ServiceProvider.cs:15, 42` | **Start** each service (progress window, order, failure prompt), then register it; the docs say so, the name doesn't | `StartAndRegister` / `StartAndRegisterAll` | AddServices: Revit 1 |
| `ServiceProvider.StartService` (internal) | `Hosting/ServiceProvider.cs:138` | Starts and registers, and returns the failure instead of throwing | `TryStartAndRegister` | internal |
| `LoggerServices.GetFileLogger` | `Logging/LoggerServices.cs:53` | Builds a new logger every call and overwrites `FullPath` | `CreateFileLogger` | Logic 2, Revit 2 |
| `LoggerServices.FullPath` | `Logging/LoggerServices.cs:17` | A Serilog path **pattern**, publicly settable (see KW3-30) | `LogFilePattern` (private set) | noisy |
| `ObjectExtensions.PrintProperties` | `Common/ObjectExtensions.cs:58` | Appends to a `StringBuilder`; prints nothing (and loses output for a null builder) | `AppendProperties` | none |
| `ModelBase.Validate` (protected) | `Persistence/ModelBase.cs:41` | Validates one property, rewrites its error entry, raises `ErrorsChanged` | `ValidatePropertyAndNotify` | derived in Domain 3, Logic 2, Revit 1 |
| `AssemblyExtensions.GetInstancesThatInheritFrom` (and the other `GetInstances…`) | `Reflection/AssemblyExtensions.cs:49` | **Creates** an instance of each concrete type; `…InheritFrom` is a copy of `…ImplementInterface` | `CreateInstancesAssignableTo` | `GetInstancesThatImplementInterface`: Revit 1 |
| `AssemblyExtensions.GetTypesThatImplementInterface` / `GetTypesThatInheritFrom` | `Reflection/AssemblyExtensions.cs:103, 110` | The first also matches base classes and drops abstract types; the second keeps them and is not an extension | one `GetConcreteTypesAssignableTo` | none |
| `AssemblyExtensions.GetReferenceNames` | `Reflection/AssemblyExtensions.cs:65` | Returns **file** names (`Name + ".dll"`); `lookPosition` is a magic string | `GetReferenceFileNames`; an enum | none |
| `AssemblyExtensions.GetVersion` | `Reflection/AssemblyExtensions.cs:120` | The **file** version, not the assembly version | `GetFileVersion` | none |
| `CodeLocations.GetMethodName` | `Reflection/CodeLocations.cs:33` | Returns the signature `Name(params)`, or "Constructor" | `GetMethodSignature` | none |
| `NowStamp.DateTime` / `DateTimeWithSeconds` / `DateTimeWithSecondsDelimited` | `Common/NowStamp.cs:8–14` | Strings named `DateTime` (shadows `System.DateTime`); the `…Delimited` docs give a different format from the code | `DateTimeText` …; fix the doc | Domain 3, Logic 7, Revit 5 |

### Measurements, Wpf, Palettes

| Member | File | What it does | Suggested | Reach |
|---|---|---|---|---|
| `WindowExtensions.HeightCheck` | `Wpf/WindowExtensions.cs:20` | Shrinks the window to the working area and re-centres it | `FitHeightToWorkingArea` | Revit 1 |
| `VisualTreeExtensions.FindChild` | `Wpf/VisualTreeExtensions.cs:6` | Depth-first search of **all descendants**; not an extension method | `FindDescendant` | none |
| `ScreenInfo.GetAllMonitorsInfo` | `Wpf/Native/ScreenInfo.cs:8` | Returns nothing; writes every monitor to `Console` | `WriteAllMonitorsToConsole` (or delete) | none |
| `ColorSet.LightYellow` | `Palettes/ColorSet.cs:16` | (255, 255, 0): pure yellow | `Yellow` | Logic 2 |
| `ColorNameTools.GetHueName` (private) | `Palettes/ColorNameTools.cs:42` | Describes saturation and brightness as well as hue | `DescribeColor` | private |

## Vague (highlights)

| Member | Note | Suggested | Reach |
|---|---|---|---|
| `ArgumentExtensions.Validate` (5 overloads) | Throw on null, empty or too short; never fix anything. `minimumListCount` is used for dictionaries too | `ThrowIfFewerThan` / `ThrowIfNullOrEmpty`; `minimumCount` | **~170 uses** across Domain, Logic, UI, Revit |
| `DoubleExtensions` parameters `value` | They are inches; only the docs (where any) say so | `inches` | n/a |
| `DoubleExtensions.AsFraction` | Inches to an eighths-only "X-Y/8" string | `ToEighthInchFraction` | Logic 3 |
| `ConstructionServices.RoundBaseTenNumber` | Ceiling/floor to N decimals; returns 0 for any other direction | `RoundToDecimalPlaces` | Domain 1, Logic 3 |
| `RoundAmount.OfAnInch`, `*Length` constants | Divides by 12; the "lengths" are decimal-place counts | `InchesToFeet`, `*DecimalPlaces` | none |
| `MeasurementModel.Value`, `LengthUnits` | Unit kept apart from the number; `LengthUnits` is one unit | `Magnitude`, `LengthUnit` | Logic 2, Revit 1 |
| `ImageTools.GetImageSource` | Loads an embedded resource, logs, returns null on failure | `LoadEmbeddedImage` | UI 2 |
| `ProgressReporter.Use`, `ProgressView.Own` | Swap the process-wide factory; set the owner handle | `UseFactory`, `SetOwnerHandle` | noisy / internal |
| `CommaSeparatedValueFileTools.*Notification` | Each shows a modal prompt and returns the button | `Show…Warning`; params `duplicateCount`, `acceptedHeaders` | Revit 1 each |
| `FileServices.PathOptions`, `TotalLines`, `VetDirectoryPath` | Prepare a folder (create or empty, maybe open); count lines; ensure a folder | `PrepareDirectory`, `CountLines`, `EnsureDirectory` | none |
| `FileInfoExtensions.DeleteFile` | Deletes and silently ignores IO errors | `TryDelete` | Logic 1 |
| `ListTools.GetDistinctValuesOrdered`, `GetListOfObjects`; `ListExtensions.Chop` | Distinct *measurements*; drains an enumerator; chunks (params `l`, `n`) | `GetDistinctMeasurementsOrdered`, `DrainToList`, `SplitIntoChunks` | Logic 2–4 |
| `ComparerTools.GetBasicComparer` | Builds a comparer that treats empty and null as equal | `CreateEmptyEqualsNullComparer` | none |
| `StringExtensions.Initialise`, `GetNumeric`, `StripIntegers`, `CleanInput`, `StripAllButObjectSignature`, `FixInch` | Initials; digits only; strip digits; keep `\w.@-`; keep `\w._`; wrapper of `DoubleToSingleQuotes` | `ToInitials`, `DigitsOnly`, `StripDigits`, … ; delete `FixInch` | mostly none; FixInch Domain 1 |
| `EnumExtensions.ToObservableCollection<T>()`, `GetComboBoxItemData<T>()` | Build new collections from all values of `T` (no input) | `CreateValueCollection`, `CreateComboBoxItems` | Revit 1 |
| `ObjectExtensions.HasParity`, `IsEqualToCancelValue` | Both `value.Equals(stored)`; the `Is…` throws on null | `EqualsStoredValue`, `MatchesCancelValue` (null-safe) | Logic 1 each |
| `UserPrincipalExtensions.GetManager` | Returns the manager's CN, failures as text | `GetManagerName` | Logic 1 |
| `ValueDefault.DefaultDate` | A magic sentinel date string ("3/17/1923 06:00:00 AM") | `NoDateSentinel` | none |
| `NowStamp.GetDate` / `GetTime` | yyyyMMdd / HHmmss as an int, or -1 | `GetDateAsInteger` / `GetTimeAsInteger` | Logic 4 / 1 |
| `WorkstationModel.Get` (private), `Name` | WMI query keeping the last row; `Environment.MachineName` | `ReadWmiProperty`, `MachineName` | none |
| `ColorWrapper.Id` | Never set (always 0), beside `Index` | delete or document | none |
| `CommandType` (Start, Stop, Pause) | No docs; unclear what it types | document or rename | Data-Exporter 6 (may be its own enum) |

## Style (highlights)

- **Typos and casing:** `StripAllButAlphaNumeric…Hypen…` ×3 (Hyphen; Domain 5, Logic 2, Revit 3); `GetNameSpaceName`; `IncludeTimeStamp` vs `includeTimestamp`; `Username` vs `userName`.
- **Type name repeated:** `BitmapToBitmapSource`, `ConvertIntToBool`, `ValueDefault.Default*`, `RecordCache.Cache` (`Models`), `PerimeterTools.*Perimeter`, `LoggerServices.DirectoryInfo`.
- **Three names for the same defaults:** `ValueDefault.DefaultInteger`, `ValueIfNull.Int`, `CancelValue.Integer` (Logic 24, Revit 2 for `ValueIfNull`).
- **`Is…` returning a `Match`:** `RegexMatchTools.IsFileStoreCeeDrive` and two siblings.
- **Hash names:** `ComputeMd5Hash` returns hex, beside `ComputeSha256Hex`.
- **`IApplicationService.Stop` returns `bool`** that all five implementations set to true and `ServiceProvider.Stop` ignores.
- **`PromptResult.None` / `PromptButtons.None` / `PromptRequest.DefaultButton`:** `None` means three different things.
- **Duplicate palette colours** under different names (`MatchColors.None` = `Missing`, `No` = `Some`, `All` = `Yes` = `QualityCheckColors.Good`); `MatchObjects` enum is vague.
- **Parameter names:** `FileServices` mixes `path` (folder) and `filePath` (file); `LoggerTools.LogKeyValuePair(dictionary)` takes a list; `References.LoadReference(reference)` is a file name; `ColorNameTools` `c`.

No flagged member is serialized. Possible XAML bindings by name: `ComboBoxItemData.Readable` (Domain 1, Revit 2); check the XAML before renaming it.

## Linear issues (filed 2026-11-11)

R1 **KW3-32**, R2 **KW3-33**, R3 **KW3-34**, R4 **KW3-35**, R5 **KW3-36**, R6 **KW3-37**. All in KW3, Low, related to KTR5-4798. Each renames, adds XML docs where missing, resets the `Author` stamp of the tests it touches, and is followed by repin issues in the layers above where the reach column is not "none".

| # | Scope | Highest reach | Estimate |
|---|---|---|---|
| R1 | **Text**: `ToTitleCase`, `StripAllButSafe`, `ToLog`/`Write`, `StringBuilder.ToCsv`/`ToLog` (and parameter order), `Hypen` typos, the vague strip/clean helpers, `FixInch` | `ToTitleCase` 30 files | 2 |
| R2 | **Files**: `FileServices` (`AppendFile`, `WriteToFile`, `StripLineFromFile`, `DeDuplicateLines`, `PathOptions`, `TotalLines`, `path`/`filePath`), `IsShowDialog`, CSV notification prompts, `FileInfoExtensions.DeleteFile` | `IsShowDialog` 3 | 2 |
| R3 | **Argument checks and collections**: `ArgumentExtensions.Validate` → `ThrowIf…`, `IsNullOrEmptyArgument`/`Local`, `ListTools`, `Chop`, `ComparerTools` | `Validate` ~170 uses | 4 |
| R4 | **Hosting, logging, errors**: `SuperClassName`, `HandleIt`, `AddService(s)`/`StartService`, `GetFileLogger`, `IApplicationService.Stop` | `HandleIt` 36, `SuperClassName` ~29 | 2 |
| R5 | **Reflection, Common, Workstation**: `AssemblyExtensions` family (one implementation), `CodeLocations`, `PrintProperties` (+ null builder fix), `HasParity`/`IsEqualToCancelValue`, `NowStamp`, `ValueDefault`/`ValueIfNull`/`CancelValue`, `GetManager`, `WorkstationModel`, `ModelBase.Validate` | `NowStamp` 15 | 2 |
| R6 | **Measurements, Wpf, Palettes**: `HeightCheck`, `FindChild`, `GetAllMonitorsInfo`, `LightYellow`, `GetHueName`, `DoubleExtensions` (`inches`, `AsFraction`), `RoundBaseTenNumber`, `RoundAmount`, `MeasurementModel`, `GetImageSource`, `BitmapToBitmapSource`, `ConvertIntToBool`, palette duplicates | `DoubleExtensions` Logic 3 | 2 |

`ConvertFractionToDecimalFeet` goes to KW3-10 and the progress `Loop*` names to KW3-20 (both already filed). R3 is the largest: `Validate` is called about 170 times across the layers above, so its follow-ups are the most work; split it if it grows.
