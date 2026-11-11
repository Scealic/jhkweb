# Member naming check, pass 2: Kelly-Windows-v3 (2026-11-11)

Second pass after the first-pass renames landed. Sources: groups G02 (Collections, Commands, Common, Files, Geometry, Hosting, Logging, Measurements) and G03 (Palettes, Persistence, Prompts, Reflection, Text, Workstation, Wpf). Readers: Sonnet; checked by: Opus.

Line numbers are from the working copy of 2026-11-11 afternoon. It has 73 uncommitted modified files on top of `0be3b82`, mostly a member reorder (IDE cleanup), so the readers' line numbers no longer match. Re-check them before editing. G07 and G16 reported `PathExtensions.Get*Directory` creating folders: that member is in Kelly-Revit-Logic-v5, not here, so it is not in this report.

## Summary

| Severity | Reported (rows) | Confirmed (rows) | Notes |
|---|---|---|---|
| Misleading | 7 | 1 | 6 downgraded: 4 to Vague, 1 to Style, 1 dropped (`SplitPascalCaseWords`, first-pass name) |
| Vague | 36 | 31 | includes 4 from Misleading and 1 from a bug; 9 dropped |
| Style | 46 | 32 | includes 1 from Misleading and 2 from bugs; the rest dropped or merged |

Possible bugs: 11 reported; 3 confirmed (one reshaped), 8 dropped (documented behaviour, no callers, or already filed). 2 more bugs found while checking. **5 confirmed bugs** in all, one of them in the add-in's XAML.

Most of what remains is in the Measurements helpers, `FileServices` (nearly unused outside its own file), the WPF converters and the progress window. Most of the weak names have no outside callers, so the renames are cheap. The exceptions are `GetService<T>` (about 100 callers) and `MatchObjects` (about 20).

## Confirmed bugs

| Member | File:line | What is wrong | Evidence | Steps to show it | Priority |
|---|---|---|---|---|---|
| `SpoolManagerView` / `ModuleManageView` "invalid items" cell colour (add-in XAML, uses `QualityColorConverter`) | `Kelly-Revit-v5/modules/Trade.All/Commands/Spools/SpoolManager/SpoolManagerView.xaml:202`; `.../ModuleManage/ModuleManageView.xaml:409` | The cell background binds the **bool** `Spool.HasInvalidSpoolItems` through resource `NameQualityCellColor` (`QualityColorConverter`). That converter only maps `MatchObjects` values and returns Transparent for anything else, so a spool with invalid items is never highlighted. `ValueToColorConverter` (true to LightCoral) was probably meant. | `Kelly-Revit-Logic-v5/src/Spools/Spool.cs:100` `public bool HasInvalidSpoolItems`; `Palettes/QualityColorConverter.cs` switch on `MatchObjects` only, default Transparent. Bool since the binding was added (`74f7e8dc`). Not in any earlier report. | Open Spool Manager on a spool with a non-spoolable item: the "invalid items" check box column is ticked, but its cell stays uncoloured. | Medium (KTR5, Trade.All) |
| `DoubleExtensions.ToInchFraction` | `Measurements/DoubleExtensions.cs:175` | For a negative length with whole inches it drops the whole inches: -1.5 gives `-1/2"`, because the whole part is written only when `wholeValue > 0`. It also returns the text "Error" when no power-of-two denominator fits (only reachable with a `maxDenominator` that is not a power of 2; every caller passes 16). | `return (wholeValue > 0 ? wholeValue + "-" : "") + numerator + ...`; `return "Error";`. Callers: `CeilingToInchFraction` (Domain `VerticalSupportTypeTools`, Logic `FabricationPartExtensions`, `SuspendedSupport`), `FractionDecimal.FractionForm`, `DecimalInchesToFeetInchFraction`. `ToFractionalInches` guards negatives with "-", the others do not. | `(-1.5).ToInchFraction(16)` returns `-1/2"`. | Low (no current caller passes a negative) |
| `StringExtensions.SplitPascalCaseWords` | `Text/StringExtensions.cs:255` | With `preserveNumbers: false` the text is stripped to ASCII letters **after** the null/white-space check, then `text[0]` is read: a text with no ASCII letters ("123", "--") throws `IndexOutOfRangeException`. The docs promise an empty string only for null or white space. | `if (!preserveNumbers) text = text.StripAllButAlpha();` then `newText.Append(text[0]);`. Only caller with `false`: Domain `ViewFilterNames.ServiceFilterName`, which always prefixes "Service - ", so it cannot hit it today. | `"123".SplitPascalCaseWords(true, false)` throws. | Low |
| `ObjectDumper.Write` / `WriteDictionary` / `WriteEnumerable` / `WriteProperties` (private) | `Reflection/ObjectDumper.cs:107, 195, 243, 263` | Simple values, nulls, delegates and the depth/circular notes are indented `depth * 4`; collection and object headers and their notes `depth * 2`. A nested object's header sits at 2 spaces while its sibling values sit at 4 and its children at 8, so `Dump` output is misaligned. | `new string(' ', depth * 4)` vs `new string(' ', depth * 2)` and `(depth + 1) * 2`. No production caller of `Dump`/`Print` (tests only). | `ObjectDumper.Dump(new { A = 1, B = new { C = 2 } })`: `A` at 4 spaces, `B` header at 2, `C` at 8. | Low |
| `ToPoundFormatConverter.Convert` | `Measurements/ToPoundFormatConverter.cs:8` | A missing or negative weight shows "0 lb" (with a space); a real weight shows "12.5lb" (no space). It also floors to 2 decimals without saying so. | `nullValue = $"0 {suffix}"` vs `pound.RoundToDecimalPlaces(2, RoundDirection.Down) + suffix`. Used as `ToPounds` in `ModuleManageView.xaml:205, 357, 586`. | Module Manage: a spool without weight shows "0 lb", one with weight "12.5lb". | Low |

## Proposed rename issues

All in KW3 unless noted, Low priority. Each renames, adds or fixes XML docs, resets the `Author` stamp of the tests it touches, and needs a repin in the layers above where callers exist.

### R1: `RegexMatchTools` drive matchers and `StringExtensions` length-text helpers

| Severity | Member | File:line | What it does | Suggested | Callers | Serialized/Shown |
|---|---|---|---|---|---|---|
| Misleading | `RegexMatchTools.IsFileStoreCeeDrive`, `IsFileStoreMappedNetworkDrive`, `IsFileStoreNetworkDrive` (first pass, not applied) | `Text/RegexMatchTools.cs:35, 53, 71` | `Is…` returns a `Match` (null for empty input), not a bool. "MappedNetworkDrive" matches every drive D: to Z:, local disks included. "Cee" and "FileStore" are noise | `MatchDriveCRoot`, `MatchDriveDToZRoot`, `MatchUncRoot` | 3, all in `Files/PathTools.cs` | no |
| Vague | `StringExtensions.DoubleToSingleQuotes` | `Text/StringExtensions.cs:113` | Replaces each `"` with two `'` (inch mark to two foot marks) | `DoubleQuoteToTwoSingleQuotes` | ~14 | no |
| Vague | `StringExtensions.CleanFraction` | `Text/StringExtensions.cs:85` | Keeps digits, space, `/ - " ' .` and collapses spaces: a feet-inch text filter | `KeepFeetInchCharacters` | 3 (`ConstructionServices`) | no |
| Vague | `StringExtensions.FileName` | `Text/StringExtensions.cs:147` | Removes invalid file-name characters (`FileServices.CleanFileName`) and normalises white space | `ToCleanFileName` | 1 | no |
| Vague | `IdentifierTools.BuildIdentifier` | `Text/IdentifierTools.cs:6` | Joins trimmed parts and upper-cases; one part is returned untrimmed | `JoinPartsUpperCase` (and document the one-part case) | 7 | no |

### R2: Match result enum and the WPF value converters

| Severity | Member | File:line | What it does | Suggested | Callers | Serialized/Shown |
|---|---|---|---|---|---|---|
| Vague | `MatchObjects` (enum) | `Text/MatchObjects.cs:3` | One result of comparing two values (`NamesMatch`); plural, "Objects", not flags | `MatchResult` (no clash found) | ~20 | no |
| Vague (from Misleading) | `QualityColorConverter` | `Palettes/QualityColorConverter.cs:6` | Maps `MatchObjects` to `MatchColors`. Used only for the QA match columns, so "Quality" is not false, but it says nothing of the input | `MatchResultColorConverter` | 1 resource (`NameQualityCellColor`, 5 XAML uses) | resource key is bound by name |
| Vague | `ValueToColorConverter` | `Palettes/ValueToColorConverter.cs:5` | `true` to a LightCoral brush, anything else White | `TrueToErrorBrushConverter` | 1 (`LayoutPointFromCommaSeparatedValueImportView.xaml.cs:56`) | no |
| Vague | `FlagExistsConverter` | `Common/FlagExistsConverter.cs:7` | Non-empty text to the Caution brush, else Transparent | `NonEmptyTextToCautionBrushConverter` | 1 resource (`FlagExists`, `SpoolManagerView.xaml:726`) | resource key is bound by name |
| Vague | `BoolAttribute` | `Common/BoolAttribute.cs:6` | Validation: the property must equal `DesiredValue` | `RequiredBoolValueAttribute` | 1 | no |
| Vague | `ComboBoxItemData<TEnum>` | `Wpf/ComboBoxItemData.cs:7` | Enum value and its display text | `EnumComboBoxItem<TEnum>` (keep `Readable`: bound in XAML) | 8 | properties bound in XAML |

### R3: Measurements: fraction text, rounding amounts and length formatting

| Severity | Member | File:line | What it does | Suggested | Callers | Serialized/Shown |
|---|---|---|---|---|---|---|
| Vague (from Misleading) | `RoundAmount.OneHalfOfAnInch`, `OneSixTeenthOfAnInch` | `Measurements/RoundAmount.cs:22, 29` | Half and a sixteenth of an inch **in feet** (`/12`), beside `OneHalf` = 0.5 (in inches). Not false, but the unit is missing | `OneHalfInchInFeet`, `OneSixteenthInchInFeet` | 1 / 2 | no |
| Vague | `DoubleExtensions.ToFractionalFeetAndInches`, `ToFractionalInches` | `Measurements/DoubleExtensions.cs:158, 166` | **Floor** to 1/16 and return "-" for a negative; siblings `DecimalInchesToFeetInchFraction` / `ToInchFraction` round to nearest | `FloorToFeetInchSixteenths`, `FloorToInchSixteenths` (`FloorToFeetInchFraction` already exists, with a `maxDenominator`) | 2 / 6 | "-" is shown |
| Vague | `DoubleExtensions.ToInchFraction` sentinel | `Measurements/DoubleExtensions.cs:202` | Returns "Error" as a length text (see bug above); same pattern as the pending `GetFabricationName` decision | decide with that decision; at least document it | see bug | shown |
| Vague | `FractionDecimal` (type) | `Measurements/FractionDecimal.cs:3` | Decimal inches plus their 1/16 fraction text (`FractionForm`) | `InchLength` | 15 | no |
| Vague | `ConstructionServices` (type) | `Measurements/ConstructionServices.cs:7` | Feet-inch-fraction parsing, formatting and rounding; `RoundInchesOfDecimalFeet` is not an extension like its siblings | `FeetInchTools` | 7 | no |
| Style | `RoundAmount.OneSixTeenth`, `OneSixTeenthDecimalPlaces`, `OneSixTeenthOfAnInch` | `Measurements/RoundAmount.cs:24-29` | Casing; siblings `OneThirtySecond`, `OneSixtyFourth` | `OneSixteenth…` | 11 | no |
| Style | `RoundAmount.OneTwoFiftySixth` (+ `DecimalPlaces`) | `Measurements/RoundAmount.cs:41` | Sibling style is whole words | `OneTwoHundredFiftySixth` | 3 | no |
| Style | `RoundAmount.InchesToFeet`, private `LengthOfDecimal` | `Measurements/RoundAmount.cs:48, 53` | A length conversion in the rounding-increments class; the private one counts decimal places | move `InchesToFeet` to `DoubleExtensions`; `CountDecimalPlaces` | 1 | no |
| Style | Fraction vocabulary | `FractionalFormat`, `FeetInchAndFraction`, `ToFractionalInches`, `ToInchFraction`, `FloorToFeetInchFraction`, `ConvertDecimalFeetToFractionalFormat` | "Fraction"/"Fractional", "Inch"/"Inches", "And" or not, for one feet-inch-fraction text | one term, `FeetInchFraction` / `InchFraction`, applied with the rows above | n/a | `FractionalFormat` values are not stored |
| Style | `FractionTools` (type) | `Measurements/FractionTools.cs:3` | Non-static class with only `GreatestCommonDivisor` | static `GreatestCommonDivisorTools` (or into `IntegerExtensions`) | 5 | no |
| Style | `IntegerExtensions.FlipBit` | `Measurements/IntegerExtensions.cs:6` | Not an extension (no `this`) in an extensions class | add `this` or move | 1 | no |

### R4: `FileServices`, CSV prompts and the Xlsx writer

| Severity | Member | File:line | What it does | Suggested | Callers | Serialized/Shown |
|---|---|---|---|---|---|---|
| Vague (from Misleading) | `CommaSeparatedValueFileTools.ShowMalformedHeaderSchemaWarning`, `ShowMissingDataWarning` | `Files/CommaSeparatedValueFileTools.cs:31, 56` | Show an **Error**-icon prompt titled "CSV Import Error" with Retry/Cancel; the first pass named them "Warning" without noticing (the duplicate-record one is a real warning) | `ShowMalformedHeaderSchemaError`, `ShowMissingDataError` | 1 each (`LayoutPointFromCommaSeparatedValueImportViewModel`) | prompt texts unchanged |
| Vague | `FileServices.VetFileName` (private), `IsFileNameVetted`, `VettedFileName` | `Files/FileServices.cs:422, 38, 42` | Checks nothing: strips illegal characters (`CleanFileName`) | `SanitizeFileName`, `IsFileNameSanitized`, `SanitizedFileName` | private; props used in-layer only | no |
| Vague | `FileServices` (type) | `Files/FileServices.cs` | Instance file writer mixed with unrelated statics. Outside its file only `DomainGroupReport` and `StringExtensions.FileName` use it; most statics (`ReleaseObject`, `StripCharacterFromFile`, `RemoveLineAt`, `CountLines`, `AppendLineIfMissing`, `DeDuplicateAndSortLines`, `PrepareDirectory`) have no caller | split: `TextFileWriter` for the instance part; delete the unused statics rather than rename them | 2 files | no |
| Vague | `MinimalXlsxWriter.Write` | `Files/Xlsx/MinimalXlsxWriter.cs:10` | Writes a one-sheet workbook; `WriteWorkbook` writes many | `WriteSingleSheetWorkbook` | ~4 | no |
| Style | `FileServices.ReleaseObject` | `Files/FileServices.cs:287` | Wraps `ComObjectTools.Release` and nulls the variable; no callers | delete | 0 | no |
| Style | `FileServices.StripCharacterFromFile` | `Files/FileServices.cs:333` | Temp file named `<name>AlphaNumericSpacesHyphenUnder<ext>`, a leftover from an older use; no callers | delete (or a neutral temp name) | 0 | no |
| Style | `FileServices.DeDuplicateAndSortLines` | `Files/FileServices.cs:194` | "Deduplicate" is one word; no callers | `DeduplicateAndSortLines`, or delete | 0 | no |
| Style | `WorksheetNameTools.MaxLength` | `Files/Xlsx/WorksheetNameTools.cs:63` | Max characters of a worksheet name (31) | `MaxSheetNameLength` | 6 | no |

### R5: Progress window, hosting, logging and reflection loaders

| Severity | Member | File:line | What it does | Suggested | Callers | Serialized/Shown |
|---|---|---|---|---|---|---|
| Vague | `IProgressReporter.ProcessComplete` (+ `ProgressBarService`, `NullProgressReporter`) | `Wpf/IProgressReporter.cs:22` | Ends the reporter: stops the timer, closes the window, disposes | `Finish` | ~23 | no |
| Vague | `ProgressBarService` (type) | `Wpf/ProgressBarService.cs:9` | A WPF progress window implementing `IProgressReporter`, not a start-up service; members mix "Process", "Item" and "Object" for one idea | `ProgressWindowReporter`; "Item" for what is counted. Do not use "Operation" (taken by `OperationService`) | 8 | window labels are shown |
| Vague | `LoggerServices` (type) | `Logging/LoggerServices.cs:7` | Builds Serilog file loggers for one folder, deletes old logs | `FileLoggerFactory` | 12 | no |
| Vague | `LoggerServices.GetFullPath` (private) | `Logging/LoggerServices.cs:97` | Returns the rolling-file pattern; the property it fills is already `LogFilePattern` | `GetLogFilePattern` | private | no |
| Vague | `AssemblyExtensions.FindLoaded` | `Reflection/AssemblyExtensions.cs:34` | Not an extension; finds a loaded assembly by simple name, else the fallback | `FindLoadedAssembly` | 1 | no |
| Vague | `References.LoadReference` | `Reflection/References.cs:49` | Loads one DLL beside an assembly; false only for a null assembly path, a missing file throws; `reference` is a file name | `LoadReferenceFile`, param `referenceFileName`; document the throw | 4 | no |
| Vague | `References.LoadAssembliesInDirectory` | `Reflection/References.cs:20` | Also prompts the user (`ReportToUser`) on the first failure; the remarks say so, the name does not | `LoadAssembliesInDirectoryOrReport` | 3 | no |
| Vague | `CommandType` (enum) | `Commands/CommandType.cs:3` | Start/Stop/Pause, used nowhere; clashes with `System.Data.CommandType`, which the exporter uses | delete | 0 | no |
| Style (from Misleading) | `ServiceProvider.TryStartAndRegister` (internal) | `Hosting/ServiceProvider.cs:138` | Never throws (the `Try` part holds) but returns the failure `Exception` instead of `bool` + `out`; first-pass name | `StartAndRegisterOrGetFailure`, or keep and leave as is | 1 + tests | no |
| Style | `LoggerTools` | `Logging/LoggerTools.cs:4` | Non-static class with only static members | `static` | 3 | no |
| Style | `LoggerTools.LogKeyValuePairs<TKey,TValue>(List<Tuple<…>>)` | `Logging/LoggerTools.cs:50` | Logs "The Dictionary object is null" for a list | message "list of pairs" | 1 | log text |
| Style | `IApplicationService.StartOrder` doc | `Hosting/IApplicationService.cs:15` | Summary says "Addin Services" | doc only | n/a | no |
| Style | `CodeLocations` (type) | `Reflection/CodeLocations.cs:3` | No caller in any layer (tests only); `GetFullCodePath` has no `NoInlining`, so its frame index can shift by one when inlined | delete | 0 | no |

### R6: Default values, guards and alignment references

| Severity | Member | File:line | What it does | Suggested | Callers | Serialized/Shown |
|---|---|---|---|---|---|---|
| Vague | `ValueIfNull` vs `ValueDefault` | `Common/ValueIfNull.cs:4`, `Common/ValueDefault.cs:4` | Same four values under the same names (aligned by the first pass, not merged); `ValueDefault.InvalidDouble`, `InvalidInteger`, `NoDateSentinel` are used only by tests | keep one class (`ValueDefault`, fewer callers to move: or `ValueIfNull`, ~130 uses, and move the extra three into it); delete the unused | ValueIfNull ~130, ValueDefault 4 | no |
| Vague | `ArgumentExtensions` (type) | `Collections/ArgumentExtensions.cs:7` | `HasAtLeast` (bool), list/collection/dictionary guards, `ThrowIfNull(ICommand)`, `ThrowIfNullOrWhiteSpace(string)` | `CollectionGuards` for the collection members; move the string and `ICommand` guards | `ThrowIfFewerThan`/`ThrowIfNull` ~56 | no |
| Vague | `ListExtensions.ThrowIfNullOrEmpty` vs `ThrowIfFewerThan(1)` | `Collections/ListExtensions.cs:48` | Same guard in two classes | keep one, in the class above | 1 | no |
| Vague | `ObjectReference` (enum) | `Geometry/ObjectReference.cs:5` | Alignment edges and axes, used by `SetOffset` and in `PushButtonText` | `AlignmentReference`, values kept | 44 | **Shown**: member names are ribbon button text (Kelly-Revit-UI `PushButtonText.cs:10-16`) |

### R7: Style batch (Kelly-Windows-v3)

| Severity | Member | File:line | What it does | Suggested | Callers | Serialized/Shown |
|---|---|---|---|---|---|---|
| Style | `ServiceProvider.GetService<T>`, `AddInServices.GetService<T>` | `Hosting/ServiceProvider.cs:17`, `Hosting/AddInServices.cs:19` | Throw when absent, unlike `System.IServiceProvider.GetService`; the type name clashes with `Microsoft.Extensions.DependencyInjection.ServiceProvider` | `GetRequiredService<T>`; split into its own issue if taken up (~100 callers, every layer) | ~100 | no |
| Style | `ExceptionExtensions.ReportToUser` text | `Common/ExceptionExtensions.cs:29` | "An error occured" | "occurred" | 56 | **Shown** |
| Style | `PositiveNumberToYesConverter` | `Common/PositiveNumberToYesConverter.cs:6` | Returns "Y" | `PositiveNumberToYConverter` | 1 resource (`PositiveNumberToYes`) | Shown; key bound |
| Style | `Point3Extensions.ToStakeoutReportDecimal` / `…Fractional` | `Geometry/Point3Extensions.cs:24, 43` | Labels "X: Y: Z:" vs "E/W: N/S: Elevation:" for the same coordinates | one label set | 5 | **Shown** |
| Style | `ColorWrapper` | `Palettes/ColorWrapper.cs:3` | Palette entry; "Wrapper" says nothing | `NamedColor` | 9 | no |
| Style | `ExtractSuffixIfInteger` vs `RegexMatchTools.TrailingInteger` | `Text/StringExtensions.cs:118` | Two words for one concept; local `asdf`; 0 when none | `TrailingIntegerOrZero` | 2 | no |
| Style | `StripAllButAlphaNumericHyphenUnder`, `…HyphenUnderPeriod`, `…PeriodUnder`, `…SpacesHyphenUnder` | `Text/StringExtensions.cs:321-377` | "Under" = underscore; character order differs | `…Underscore`, one order (Spaces, Hyphen, Underscore, Period) | 1-2 each (`WorksheetNameTools` 2) | no |
| Style | `ClipboardTools.SetText(string)` | `Wpf/ClipboardTools.cs:22` | Puts "No Value was Provided" on the clipboard for empty text | document, or `SetTextOrPlaceholder` | 7 | placeholder shown |
| Style | `StringExtensions.AppendToLogFile` / `AppendToFile` | `Text/StringExtensions.cs:67, 19` | Param `filename` vs `fileName`; different timestamp formats; default folder `c:\temp` | unify parameter names and timestamp | 2 / 6 | log line format |
| Style | `StringBuilderExtensions.WriteToCsvFile`, `WriteToLogFile`, private `Write` | `Text/StringBuilderExtensions.cs:62, 90, 119` | `fileName` gets " - <timestamp>" added; private `Write` has a `FileType` param named `extension` | param `fileNameWithoutTimestamp`; private `WriteToFile(…, FileType fileType)` | 17 / 3 | file names |
| Style | `StringExtensions.NamesMatch(doesThis, equalThis)` | `Text/StringExtensions.cs:179` | Parameter names | `name`, `otherName` | 4 | no |
| Style | `UserPrompt.Show(title, message)` vs `ShowError/…(title, mainContent)` | `Prompts/UserPrompt.cs:52, 84` | Same body text is `message` (into `MainInstruction`) in one and `mainContent` in the others | one term, `mainContent`; decide where the body goes | 75 | dialog layout |
| Style | `ScreenInfo`, `Monitorinfo` | `Wpf/Native/ScreenInfo.cs:3, 91` | Non-static class of statics; casing; no outside callers | static `MonitorAreas`, `MonitorInfo` | 1 | no |
| Style | `WindowExtensions.TopOffsetPixels`, `BottomMarginPixels` (private) | `Wpf/WindowExtensions.cs:88` | WPF device-independent units, not pixels | `TopOffset`, `BottomMargin` | private | no |
| Style | `ImageTools.LoadEmbeddedImage(nameSpace, …)` | `Wpf/ImageTools.cs:12` | Param casing; log says "Ribbon icon" for a generic loader | `resourceNamespace`; neutral log text | 1+ | log text |
| Style | `WorkstationModel.GetMemoryCapacity` (private) | `Workstation/WorkstationModel.cs:46` | Returns text, fills `MemoryCapacityText` | `GetMemoryCapacityText` | private | text |
| Style | `ProgressView` `x:Name`s | `Wpf/ProgressView.xaml:10, 21, 31` | `ProgressBar` equals its type; `WindowScaffold`, `PrimaryStackPanel` | `ProgressIndicator`, `ContentPanel` | n/a | no |

## Dropped or downgraded

| Finding | Group | Why |
|---|---|---|
| `ToOppositeTurn` vague | G02 | Wrong: `360 - degrees` is the same turn measured the other way, as the docs say. Name fits. |
| `FileServices.PrepareDirectory` vague + possible bug | G02 | First-pass name; the docs state the top-level-only delete and the swallowed exceptions; no caller outside the file. |
| `FileInfoExtensions.TryDelete` | G02 | First-pass name, chosen knowing it returns void. |
| `FileDialogTools.ShowAndConfirm` | G02 | First-pass name; restates that decision. |
| `ObjectExtensions.EqualsStoredValue` | G02 | First-pass name; the duplicate of `MatchesCancelValue` is kept on purpose. |
| `Point3Extensions.Rounded(null)` bug | G02 | Documented: "a null point is treated as the origin". |
| `FileServices.StripCharacterFromFile` bug | G02 | No caller; kept as Style (R4). |
| `ClipboardTools.SetText(List<string>)` bug | G03 | Already filed: KW3-22. |
| `CodeLocations.GetFullCodePath` bug | G03 | No caller in any layer; kept as delete in R5. |
| `StringExtensions.ParseLeadingNumber` bug | G03 | Documented ("1-2" gives 0.0); the only caller reads a weight text, not a feet-inch length. |
| `FrameworkElementExtensions.ThrowIfNotReady` bug | G03 | The exception types are documented; a design choice, not a naming bug. |
| `UserPrompt.Confirm` bug | G03 | Documented layout; the parameter-name part is in R7. |
| `ProgressBarService.ProcessedItems` vague | G03 | Documented: `IProgressReporter` says skipped items count as processed. |
| `AssemblyExtensions.CreateInstancesAssignableTo` vague | G03 | First-pass name; restates that decision. |
| `RecordCache.LoadModels` vague | G03 | An `ICache` member just renamed by KWD3-7 in Kelly-Windows-Data-v3; leave to that work. |
| `UserPrincipalExtensions.GetManagerName` vague | G03 | First-pass name; the error-text-as-result question is the same as the pending `GetFabricationName` sentinel decision. |
| `StringExtensions.DigitsOnly` style | G03 | First-pass name. |
| `ProgressReporter.UseFactory`, `ProgressView.SetOwnerHandle` style | G03 | First-pass names. |
| `StringExtensions.SplitPascalCaseWords` Misleading | G03 | First-pass name, and "split into words" fits the inserted spaces; renaming 31 callers again is not worth it. The crash is a bug above. |
| `QualityColorConverter` Misleading | G03 | Downgraded to Vague: used only for QA match columns. |
| `CommaSeparatedValueFileTools.Show*Warning` Misleading | G02 | Downgraded to Vague: a prompt is still shown, only the kind is wrong. |
| `RoundAmount.*OfAnInch` Misleading | G02 | Downgraded to Vague: the value is half an inch; only the unit is missing. |
| `ServiceProvider.TryStartAndRegister` Misleading | G02 | Downgraded to Style: it never throws, which is the `Try` promise. |
| `ToPoundFormatConverter` | G02 | Kept as a Low bug, not a rename; its resource key `ToPounds` is already in the UI pass-2 report. |
| `PathExtensions.Get*Directory` | G07, G16 | Kelly-Revit-Logic-v5 member, not this layer. |
