# YAGNI 2026-11-12: Kelly-Windows-v3

Code in Kelly-Windows-v3 that nothing in production uses, found with the `yagni` skill and checked by grep. Nothing has been deleted.

## 1. Scope

- **Target:** `Kelly-Windows-v3` (`develop`, 2026-11-12).
- **Dependents searched for uses:** Kelly-Domain (direct), Kelly-Revit-Logic-v5, Kelly-Revit-UI, Kelly-Revit-v5 (transitive): `src`, `modules`, XAML.
- **Dependencies read for interfaces and base types only:** Kelly-Windows-Data-v3, -Csv, -Json.
- **Unseen dependents (local feed `C:\Repo\NugetPackages`):** none. Major Version 4 uses Kelly.Windows 2.x from Kelly-Windows-v2, not this repository.
- **Other code on the machine:** no use under `C:\repo\chrishildebran`, `C:\repo\jhkweb - non KTR` or the user profile's documents.
- **Configuration:** the skill's `default-entry-points.txt` (now with `INotifyDataErrorInfo` members and WPF attached-property accessors) and the jhkweb `.yagni`.
- **Not every dead member is found:** matching is by name; a dead member sharing a name with a live one is not flagged.

## 2. Totals

| Unit | Types | Members | Candidates | Dead (unused) | Dead (tests only) | Used | Entry point | Keep |
|---|---|---|---|---|---|---|---|---|
| Kelly-Windows-v3 | 120 | 501 | 52 | 3 | 42 | 1 | 3 | 3 |

(After the compiled check: `HashExtensions` as a whole is Used; `ProgressWindowReporter.Displayed` is Keep.)

Entry points (the scanner now knows them): `WindowBehaviors.GetKeepCentered` / `SetKeepCentered` (WPF calls them for the attached property `KeepCentered`, set in 18 views) and `ModelBase.GetErrors` (`INotifyDataErrorInfo`).

## 3. Dead

Tests are in `tests/` of this repository.

### Measurements

| Member | File | Tests |
|---|---|---|
| `AngleExtensions.ParseAngle` | `src/Measurements/AngleExtensions.cs:54` | `AngleExtensionsTests` |
| `DimensionModel.ValueInches` | `src/Measurements/DimensionModel.cs:17` | `DimensionModelTests` |
| `DoubleExtensions.DecimalFeetToFeetInchFraction`, `InchesToFeet`, `IsOutOfRange` | `src/Measurements/DoubleExtensions.cs:25, 80, 90` | `DoubleExtensionsTests` |
| `IntegerExtensions` (type: `FlipBit`, `ToBool`) | `src/Measurements/IntegerExtensions.cs` | `IntegerExtensionsTests` |
| `RoundAmount`: `OneEighthDecimalPlaces`, `OneFourthDecimalPlaces`, `OneHalfDecimalPlaces`, `OneHalfInchInFeet`, `OneSixteenthDecimalPlaces`, `OneSixtyFourthDecimalPlaces`, `OneThirtySecondDecimalPlaces`, `OneTwoHundredFiftySixthDecimalPlaces` | `src/Measurements/RoundAmount.cs` | `RoundAmountTests` |

### Text

| Member | File | Tests |
|---|---|---|
| `HashExtensions` (type: `ComputeMd5Hex`) | `src/Text/HashExtensions.cs` | `HashExtensionsTests` |
| `RegexMatchTools.IsValidEmailAddress` | `src/Text/RegexMatchTools.cs:83` | `RegexMatchToolsTests` |
| `StringBuilderExtensions.AppendCsvRow` | `src/Text/StringBuilderExtensions.cs:16` | `StringBuilderExtensionsTests` |
| `StringExtensions`: `DigitsOnly`, `ReplaceUnsafeCharactersWithSpace`, `StripAllButAlphaNumericUnderscorePeriod`, `StripAllButAlphaNumericSpaces`, `StripAllButWordDotAtHyphen`, `ThrowIfNullOrWhiteSpace`, `ToInitials` | `src/Text/StringExtensions.cs` | `StringExtensionsTests` |

### WPF, reflection, logging and the rest

| Member | File | Tests |
|---|---|---|
| `ProgressWindowReporter.Displayed` | `src/Wpf/ProgressWindowReporter.cs:88` | `WpfTests` |
| `MonitorAreas` (type, 4 methods) | `src/Wpf/Native/MonitorAreas.cs` | `MonitorAreasTests` |
| `AssemblyExtensions.GetFileVersion`, `GetTypesAssignableTo`, `GetTypesWithAttribute` | `src/Reflection/AssemblyExtensions.cs:53, 93, 101` | `AssemblyExtensionsTests` (`ScanObsolete` also uses `GetTypesWithAttribute`) |
| `ObjectDumper` (type, `Print`) | `src/Reflection/ObjectDumper.cs` | `ObjectDumperTests` |
| `ValidValueColors` (type) | `src/Palettes/ValidValueColors.cs` | `ColorSetTests`, `AssemblyExtensionsTests` |
| `FileLoggerFactory.OpenLogFile` | `src/Logging/FileLoggerFactory.cs:93` | `ShellToolsTests` |
| `ApplicationSession.TimeElapsedMinutes` | `src/Hosting/ApplicationSession.cs:54` | `ApplicationSessionTests` |
| `EnumExtensions.CreateValueCollection` | `src/Common/EnumExtensions.cs:71` | `EnumExtensionsTests` |
| `ObjectExtensions.IsNull` | `src/Common/ObjectExtensions.cs:85` | `ObjectExtensionsTests` |
| `ComparerTools` (type, `CreateEmptyEqualsNullComparer`) | `src/Collections/ComparerTools.cs` | `AbstractedToolsTests` |
| `ListTools.DrainToList` | `src/Collections/ListTools.cs:14` | `AbstractedToolsTests` |
| `UserPrincipalExtensions.GetManagerName` | `src/Workstation/UserPrincipalExtensions.cs:11` | none. Its only "use" is a wrong dialog title in Kelly-Revit-Logic-v5 `Spools/Spool.cs:968` (filed as a bug) |

## 4. Keep (your call)

- `FractionalLength` (`src/Measurements/FractionalLength.cs`): built on purpose (KD-10, moved here by KW3-1's round 2); no caller yet.
- `ProgressReporter.UseFactory`: a test seam by design (its docs: "meant for tests").

## 5. Overlaps

- KW3-40 (`ObjectDumper` indentation), KW3-30 (`LoggerServices.OpenFile`, now `FileLoggerFactory.OpenLogFile`): deleting the member makes the fix moot.
- KW3-15 and KW3-23 (`UserPrincipalExtensions` seams and off-network failures): `GetManagerName` goes.
- KW3-1: both of its repoint sub-issues are Done; what is left is deleting the upper-layer copies it names.

## 6. Deleted 2026-11-12

At the user's request, after a compiled-reference check: the built assemblies of Kelly-Domain and Kelly-Revit-UI (newest feed packages), Kelly-Revit-Logic-v5 (feed package) and Kelly-Revit-v5 (fresh build and the installed V5 add-in for 2024 to 2026), 57 DLLs, were read for every reference to a `Kelly.Windows` member. It found one the scan had missed: `HashExtensions.ComputeSha256Hex`, declared in `#if NET80 || NET100` / `#elif NET481` blocks that the scan did not parse (fixed in the scanner). So `HashExtensions` stays and only `ComputeMd5Hex` went. `ProgressWindowReporter.Displayed` also stays: it is internal and the progress-window tests read the window state through it (a test seam).

Kelly-Windows-v3 `develop`: `9f9100c` and `9318eed`. 46 members and the private `RoundAmount.CountDecimalPlaces` deleted; their tests removed, and seven tests that also checked members that stay keep those checks. Net481, Net80 and Net100 build; 826 tests pass in each (897 before). KW3-51, KW3-52, KW3-53 In Review (the package is not packed); KW3-40 and KW3-30 canceled. Not pushed.

**Reverted the same day** at the user's request, while the skill is reviewed: `f0bfe32` and `d7b9fdf` revert `9318eed` and `9f9100c`. The tree is identical to `3c469c7` again; 897 tests pass in Net481, Net80 and Net100. KW3-51 to KW3-53 back to Backlog; KW3-40 and KW3-30 reopened.

**Cascade (not deleted, waiting for a decision):** `RoundAmount.OneEighth`, `OneFourth`, `OneHalf`, `OneSixtyFourth`, `OneTwoHundredFiftySixth` are now used nowhere.

## 7. Skill and `.yagni` changes

The scanner now treats `GetX`/`SetX` beside an `XProperty` field as used when `X` is used (WPF attached properties), and the defaults name `GetErrors`, `HasErrors`, `ErrorsChanged`, `CanExecuteChanged`. The skill's checks now mark documented test seams Keep. The jhkweb `.yagni` needed nothing.
