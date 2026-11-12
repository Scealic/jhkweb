# YAGNI 2026-11-12: Kelly-Windows-v3

Code in Kelly-Windows-v3 that nothing in production uses, found with the `yagni` skill and checked by grep. Nothing has been deleted.

## 1. Scope

- **Target:** `Kelly-Windows-v3` (`develop`, as checked out on 2026-11-12).
- **Dependents searched for uses:** Kelly-Domain (pins Windows), Kelly-Revit-Logic-v5, Kelly-Revit-UI and Kelly-Revit-v5 (through the layers below them): `src`, `modules`, XAML. Their tests count only as "tests only".
- **Searched, not dependents:** BuildConfigs, Kelly-Revit-Data-Exporter, the four Kelly-Windows-Data format libraries, Kelly-Windows-Data-v3, the two VCS schema repos.
- **Dependencies read for interfaces and base types only:** Kelly-Windows-Data-v3, -Csv, -Json.
- **Configuration:** the skill's `default-entry-points.txt` and the jhkweb root `.yagni`.
- **Not visible:** nothing outside these repos uses the package (Major Version 4 uses its own Kelly-Windows-v2, which is not checked out here).
- **Checking:** each name grepped as a whole word across the production code of the five repos (C#, XAML, config, data files) and their tests.

## 2. Totals

| Unit | Types | Members | Candidates | Dead (unused) | Dead (tests only) | Used | Entry point | Keep |
|---|---|---|---|---|---|---|---|---|
| Kelly-Windows-v3 | 120 | 501 | 52 | 2 | 46 | 0 | 3 | 1 |

Dead (unused) are `IntegerExtensions` (both members used only by tests, so the whole class goes) and `UserPrincipalExtensions.GetManagerName` (its name appears only as a prompt title string in Kelly-Revit-Logic-v5 `src/Spools/Spool.cs:968`, which is not a call). Tests are in `tests/`.

## 3. Dead, by file

### Wpf

| Member | File | Tests |
|---|---|---|
| `ProgressReporter.UseFactory` | `src/Wpf/ProgressReporter.cs:45` | `ProgressReporterTests` |
| `ProgressWindowReporter.Displayed` (internal; and `ProgressDisplay`, which only it returns) | `src/Wpf/ProgressWindowReporter.cs:88` | `WpfTests` |
| `MonitorAreas` (type: `GetPrimaryMonitorFullArea`, `GetPrimaryMonitorWorkingArea`, `GetWorkingAreaForWindow`, `WriteAllMonitorsToConsole`) | `src/Wpf/Native/MonitorAreas.cs` | `MonitorAreasTests` |

### Workstation, Hosting, Logging

| Member | File | Tests |
|---|---|---|
| `UserPrincipalExtensions.GetManagerName` | `src/Workstation/UserPrincipalExtensions.cs:11` | none |
| `ApplicationSession.TimeElapsedMinutes` | `src/Hosting/ApplicationSession.cs:54` | `ApplicationSessionTests` |
| `FileLoggerFactory.OpenLogFile` | `src/Logging/FileLoggerFactory.cs:93` | `ShellToolsTests` |

### Text

| Member | File | Tests |
|---|---|---|
| `HashExtensions.ComputeMd5Hex` (the class stays: `ComputeSha256Hex` is used by Logic and UI) | `src/Text/HashExtensions.cs:45` | `HashExtensionsTests` |
| `RegexMatchTools.IsValidEmailAddress` | `src/Text/RegexMatchTools.cs:83` | `RegexMatchToolsTests` |
| `StringBuilderExtensions.AppendCsvRow` | `src/Text/StringBuilderExtensions.cs:16` | `StringBuilderExtensionsTests` |
| `StringExtensions.DigitsOnly`, `ReplaceUnsafeCharactersWithSpace`, `StripAllButAlphaNumericUnderscorePeriod`, `StripAllButAlphaNumericSpaces`, `StripAllButWordDotAtHyphen`, `ThrowIfNullOrWhiteSpace`, `ToInitials` | `src/Text/StringExtensions.cs:102, 253, 361, 373, 406, 423, 455` | `StringExtensionsTests` |

### Reflection

| Member | File | Tests |
|---|---|---|
| `AssemblyExtensions.GetFileVersion`, `GetTypesAssignableTo`, `GetTypesWithAttribute` | `src/Reflection/AssemblyExtensions.cs:53, 93, 101` | `AssemblyExtensionsTests`; `GetTypesWithAttribute` is also called by the test `ScanObsolete` (check it before deleting) |
| `ObjectDumper` (type, `Print`) | `src/Reflection/ObjectDumper.cs` | `ObjectDumperTests` |

### Palettes

| Member | File | Tests |
|---|---|---|
| `ValidValueColors` (type; an `IColors` nothing discovers by reflection) | `src/Palettes/ValidValueColors.cs` | `ColorSetTests`, `AssemblyExtensionsTests` |

### Measurements

| Member | File | Tests |
|---|---|---|
| `AngleExtensions.ParseAngle` | `src/Measurements/AngleExtensions.cs:54` | `AngleExtensionsTests` |
| `DimensionModel.ValueInches` | `src/Measurements/DimensionModel.cs:17` | `DimensionModelTests` |
| `DoubleExtensions.DecimalFeetToFeetInchFraction`, `InchesToFeet`, `IsOutOfRange` | `src/Measurements/DoubleExtensions.cs:25, 80, 90` | `DoubleExtensionsTests` |
| `FractionalLength` (struct) | `src/Measurements/FractionalLength.cs` | `FractionalLengthTests` |
| `IntegerExtensions` (type: `FlipBit`, `ToBool`) | `src/Measurements/IntegerExtensions.cs` | `IntegerExtensionsTests` |
| `RoundAmount.OneEighthDecimalPlaces`, `OneFourthDecimalPlaces`, `OneHalfDecimalPlaces`, `OneHalfInchInFeet`, `OneSixteenthDecimalPlaces`, `OneSixtyFourthDecimalPlaces`, `OneThirtySecondDecimalPlaces`, `OneTwoHundredFiftySixthDecimalPlaces` | `src/Measurements/RoundAmount.cs:10-46` | `RoundAmountTests` |

### Common and Collections

| Member | File | Tests |
|---|---|---|
| `EnumExtensions.CreateValueCollection` | `src/Common/EnumExtensions.cs:71` | `EnumExtensionsTests` |
| `ObjectExtensions.IsNull` | `src/Common/ObjectExtensions.cs:85` | `ObjectExtensionsTests` |
| `ComparerTools` (type, `CreateEmptyEqualsNullComparer`) | `src/Collections/ComparerTools.cs` | `AbstractedToolsTests` |
| `ListTools.DrainToList` | `src/Collections/ListTools.cs:14` | `AbstractedToolsTests` |

## 4. Entry point and Keep

| Member | Verdict | Reason |
|---|---|---|
| `WindowBehaviors.GetKeepCentered`, `SetKeepCentered` | Entry point | The accessors of the `KeepCentered` attached property, set in 18 Kelly-Revit-v5 XAML views; added to `.yagni` as `used:` |
| `ModelBase.GetErrors` | Entry point | `INotifyDataErrorInfo`, called by WPF binding validation; added to `.yagni` as `member: GetErrors` |
| `HashExtensions` (the class) | Keep | Flagged only because a static class name is never written; `ComputeSha256Hex` is used by Kelly-Revit-Logic-v5 `SuspendedSupport` and Kelly-Revit-UI `RibbonComboBox` |

## 5. Noted in passing

- Kelly-Revit-Logic-v5 `src/Spools/Spool.cs:968` shows a prompt titled "GetManagerName" for a missing view template: a wrong, copied title, not a use.
- Dead code cascades: after these go, scan again; `RoundAmount` and `DoubleExtensions` may lose callers inside the layer.
