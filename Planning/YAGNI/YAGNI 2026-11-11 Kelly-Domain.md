# YAGNI 2026-11-11: Kelly-Domain

Code in Kelly-Domain that nothing in production uses, found with the `yagni` skill (personal skills folder) and checked by hand. Nothing has been deleted or filed yet.

## 1. Scope

- **Target:** `Kelly-Domain` (`develop`, as checked out on 2026-11-11).
- **Dependents searched for uses** (found from the package references and namespace imports): Kelly-Revit-Logic-v5 (pins Kelly-Domain), Kelly-Revit-UI (through Logic) and Kelly-Revit-v5 (through UI). Their `src`, `modules` and XAML count as uses; their tests count only as "tests only".
- **Dependencies read for interfaces and base types only:** Kelly-Windows-v3, Kelly-Windows-Data-v3, Kelly-Windows-Data-Csv, Kelly-Windows-Data-Json.
- **Searched, not dependents:** Kelly-Windows-Data-Sqlite, -SqlServer, Kelly-Revit-Data-Exporter, BuildConfigs, the two VCS schema repos, the jhkweb root.
- **Configuration:** the skill's `default-entry-points.txt` and the jhkweb root `.yagni` (Revit and Kelly reflection entry points, `IRecord` properties).
- **Not visible:** the Major Version 4 repos are not checked out, but they don't use Kelly-Domain (v5 only). Kelly-Domain is a NuGet package in `C:\Repo\NugetPackages`; no consumer outside these repos is known.
- **Checking:** every candidate was grepped across the corpus, code and data (including the CSV data files in `C:\Program Files\JH Kelly\Kelly Tools For Revit\Data`), and checked for reflection, serializers, XAML bindings and data-file mapping.

## 2. Totals

| Unit | Types | Members | Candidates | Dead (unused) | Dead (tests only) | Used | Entry point | Keep |
|---|---|---|---|---|---|---|---|---|
| Kelly-Domain | 271 | 1356 | 130 | 59 | 71 | 0 | 0 | 0 |

Every candidate checked out as dead. 71 of them are named by tests, so deleting them also deletes or trims those tests. Two groups are a decision rather than a fact (section 5).

## 3. Dead: no use at all

### `src/Pcf/VtfrSettings.cs` and `src/Pcf/VicMaterial.cs`, `src/Pcf/KeyboardShortcut.cs` (the Victaulic settings shape)

Nothing assigns `VtfrSettings.VtfrUserSettings`, and nothing reads its settings apart from `GetGlobalUnits` (used by `PointToPipeUnits`; it always answers Imperial, as the Changelog says). The settings classes are left over from the Victaulic tool's own settings file, which v5 never loads.

- `VtfrSettings`: `RevisionNumber`, `RodSizeConversionValues`, `UnitConversionValues`, `Year`, the private const `BuildNumber`.
- `FtpTemplate` (whole class): 9 properties.
- `VtfrSettingsRow`: 43 properties, everything except `Units`.
- `VicMaterial.IsActive`, `VicMaterial.Shininess` (the type is reached only through the dead `FtpTemplate.MaterialMappings`).
- `Shortcut.Clone` (`Shortcut` is reached only through the dead `VtfrSettingsRow.ContentShortcuts`).
- Tests that go with them: `tests/Pcf/VtfrSettingsTests.cs` (keep its `GetGlobalUnits` cases), `tests/Pcf/VicMaterialTests.cs`, `tests/Pcf/KeyboardShortcutTests.cs`.

### `src/Vocabulary/Names.cs` (shared parameter names)

The parameter names reach the add-in through `ExternalParameterDefinition.csv`; these constants are not what any code uses.

- `BoundToAny.JhkRevisionDate` (Kelly-Revit-Logic-v5 `DocumentExtensions` has its own private constant with the same text), `BoundToAny.JhkSubmittalNotApproved`.
- `BoundToFamily.JhkAuthorizedContent`, `JhkLod`, `JhkLodDisclaimer`, `JhkPartNumber`, `JhkPlaceholder`, `JhkTagSuffix`.
- `BoundToProject.JhkModelStatusCso`, `JhkModelStatusIfc`.
- `Deprecated.JhkDescriptionFlag`, `Deprecated.JhkIfcAssemblySignature` (see section 5).

### `src/Vocabulary/Nouns.cs`

31 nouns with no use of the name or the text: `Concatenator`, `Database`, `Experiment`, `Hardware`, `LayoutPointVirtual`, `ManagerTools`, `MethodParameter`, the 21 `Role…` nouns (Apprentice … VicePresident), `ScopeInActiveView`, `ScopeInProject`, `ScopeInSelection`, `Software`, `Taggers`, `TakeOff`, `UpdaterTools`, `ViewFilterTools`, `Website`. Only `tests/Enums/EnumTests.cs` reflects over every noun, and it pins no count. Seven of them (`Database`, `Developer`, `Hardware`, `Software`, `Website`, …) also appear as words in unrelated strings, which is why the scan marked them "string-only".

### Others

- `src/Projects/AddInConfiguration.cs`: `IsConfigured`, never read, not even in tests.
- `src/Definitions/DefinitionRegistry.cs`: `IsRegistered`, no caller and no test (the scan's string hit was an XML doc and the unrelated `UserPrompt.IsRegistered`).
- `src/Caches/DataFiles.cs`: `IsRegistered<T>`, no caller and no test.
- `src/Products/Manufacturer.cs`: the `Manufacturer` class, built only in `tests/Models/SimpleModelTests.cs`; not an `IRecord`, and there is no `Manufacturer.csv`.

## 4. Dead: used only by tests

| File | Member | Test that goes with it |
|---|---|---|
| `src/Spools/ModuleNumber.cs` | `TryCompose` | `tests/Identifiers/ModuleNumberTests.cs` (its cases); `Create` is the path used |
| `src/Signatures/ColoredSignatureLookup.cs` | `FindBySignature` | `tests/Signatures/ColoredSignatureLookupTests.cs`; the add-in uses `FindBySignaturesIgnoreCase` |
| `src/Signatures/ServiceSignatureTools.cs` | `FindServiceExact` | `tests/Signatures/ServiceSignatureToolsFindTests.cs`; a Logic architecture test already asserts it is no longer used |
| `src/LayoutPoints/LayoutPointExportNotice.cs` | `CanProceed` | `tests/LayoutPoints/LayoutPointExportNoticeTests.cs`, `LayoutPointExportQualityTests.cs` |
| `src/Caches/DataFiles.cs` | `IsStoreRegistered` | `tests/Caches/DataFilesStoreTests.cs` (its asserts) |
| `src/Categories/BuiltInCategoryWrapper.cs` | `IsBound` | none in Domain; no XAML binding |
| `src/Common/FilePath.cs` | the `FilePath` class (`LocalPath`, `ServerPath`) | `tests/Models/SimpleModelTests.cs` (its cases); `Component` and `ProjectRecord` keep their own string `FilePath` |
| `src/Products/Manufacturer.cs` | `SizeActual`, `SizeName` | `tests/Models/SimpleModelTests.cs` |
| `src/Vocabulary/Names.cs` | `ComponentData.JhkFinish`, `Deprecated.JhkCahf`, `JhkCipe`, `JhkClassDescription`, `JhkManufacturer`, `JhkShortDescription`, `JhkTradeName` | `Kelly-Revit-Logic-v5/test/Revit.Logic.RevitTests/Updaters/ElementDataModelsTests.cs` (lines 186, 353, 355) |
| `src/Pcf/VtfrSettings.cs` | the 55 settings members of section 3 | `tests/Pcf/VtfrSettingsTests.cs` |

## 5. Your call

- **`Names.DefinitionsInternal.Deprecated`.** Each constant is marked `[Obsolete("Deprecated 6/18/2026 - See SpreadSheet")]`, and the live ones are named one by one in the definition sets (`SizeDefinitionSet`, `JhkWeldDefinitionSet`, …). Nothing enumerates the class, so the unreferenced ones (2 unused, 6 tests-only) are dead code. The class may still be meant as a record of the retired names. `tests/Vocabulary/NamesTests.cs` asserts exactly 31 fields, so deleting any of them changes that count.
- **The Pcf settings shape.** It is dead as v5 stands, but it may be a hook for a Victaulic settings loader that was never written.
- **`Nouns` roles and scopes.** They are unused, but the class may be a deliberate catalogue.

## 6. `.yagni` changes

None. The run found no entry points the root `.yagni` was missing, and no false positives to record as `used:`.

## How to delete, when approved

Kelly-Domain is a layer package: delete with the tests named above, build `-c Net481`, `Net80` and `Net100` and run `tests/Domain.Tests.csproj` in each. Re-run the in-Revit `ElementDataModelsTests` if a `Deprecated` member it names goes. Then update the Changelog (public surface) and README, pack, repin Kelly-Revit-Logic-v5 and rebuild the layers above. The removals file under the KD team in Linear (type "Delete", function "Code quality and cleanup").

## Filed 2026-11-12

- KD-85: the Victaulic settings shape in `Pcf` (related KD-77, KD-81).
- KD-86: the parameter-name constants in `Names`, with the `Deprecated` decision (related KD-81).
- KD-87: the 31 unused `Nouns` (related KD-81).
- KD-88: the single members (related KD-75, which proposed renaming `FindBySignature` and `FindServiceExact`).
- Not filed again: `ModuleNumber.TryCompose` (already deleted by KD-81) and `Manufacturer` (KD-78).
