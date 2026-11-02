# KTR v5 layer straightening plan

Written 2026-10-30. KTR v4 is out of scope.

## Progress

**2026-10-30, done and committed on `develop` (not pushed):** steps 0, 1 (pin half), 3 and 4.
- The v3/v5 `NuGet.Config` files were empty; they now carry v4's package source mapping (no more Telerik 401). Data-v3's stale `tests/Data.Tests` output removed.
- BuildConfigs `LayerPackages.Build.targets` (`KTR0006`, commit 2777896): a project that sets `KellyLayerBelow` fails when it references any other Kelly package.
- Every repo has a `Directory.Packages.props` and pins only the layer below. Packages: Kelly.Windows.Data `3.26.1030.629`, Kelly.Windows `3.26.1030.631`, Kelly.Domain `1.26.1030.632`, Kelly.Revit.Logic `5.26.1030.633`, Kelly.Revit.UI `1.26.1030.634`. Kelly-Revit-v5 builds for 2024/2025/2026 (not installed).
- Tests run: Data 180, Windows 493, Domain 535 (×3 configurations), UI without Revit 164. **No in-Revit tests yet.**

**2026-10-30, second round (step 1's add-in half and step 2):** Kelly.Domain `1.26.1030.648` adds `ContentQueries`, `DatabaseConnections.Read` / `Test` / `ReadContent` / `ReadGeneral` and `ApplicationSessionStore.Open` (548 tests); Logic `5.26.1030.649` and UI `1.26.1030.650` repinned. The add-in uses them, has no `Kelly.Windows.Data.Database` using, and imports `NoSqlServer.Build.targets` (configuration-file part off, `NoSqlServerConfigCheck`); it builds for all three years.

**Left:** nothing. Step 5's in-Revit tests ran on 2026-10-30 as the baseline of the SQL-to-CSV migration (Revit 2024, add-in disabled): Logic 573/573, UI 44/44, the add-in 69/73 (the 4 that need the add-in started). The fallback connection strings in `App.ResolveConnectionStrings` are gone with SQL Server (`SQL-to-CSV Migration Plan - v5.md`, step 6, Kelly-Revit-v5 `c205a576`), together with the `connectionStrings` section of `Kelly.Revit.dll.config`.

```
Kelly-Windows-Data-v3 → Kelly-Windows-v3 → Kelly-Domain → Kelly-Revit-Logic-v5 → Kelly-Revit-UI → Kelly-Revit-v5
```

## Target rules

1. **Code:** a layer may use any layer below it, never one above or beside it. Using a lower layer's ordinary types (for example `Kelly.Windows` helpers from Kelly-Revit) is fine.
2. **Database access:** only Kelly-Windows-Data (the mechanism) and Kelly-Domain / Kelly-Revit-Logic (the stores and queries). The add-in never opens a connection or names a stored procedure.
3. **Pins:** each repo pins only the Kelly package directly below it; the rest arrive through that package's own dependencies (the packages declare them; none use `PrivateAssets`).
4. **One place per repo** for each pinned version: a `Directory.Packages.props` (central package management), as the v4 repos, the format libraries and the exporter already do.

## What is crooked now (read 2026-10-30, all repos clean on `develop`)

### Upward references

None. Kelly-Windows-v3 uses only Windows.Data, Kelly-Domain uses nothing from Revit, Kelly-Revit-Logic-v5 uses nothing from Revit.UI.

### Pins skip layers

| Repo | Project | Pins now | Should pin |
|---|---|---|---|
| Kelly-Windows-v3 | `src/Logic.csproj` | Windows.Data | Windows.Data (already straight) |
| Kelly-Domain | `src/Domain.csproj` | Windows.Data, Windows | Windows |
| Kelly-Revit-Logic-v5 | `src/Revit.csproj` | Windows.Data, Windows, Domain | Domain |
| Kelly-Revit-UI | `src/Revit.UI.csproj` | Windows.Data, Windows, Domain, Revit.Logic | Revit.Logic |
| Kelly-Revit-v5 | the 6 `modules/Trade.*/*.csproj` | Windows.Data, Windows, Domain, Revit.Logic, Revit.UI (15 lines each, 90 in all) | Revit.UI, once in `Directory.Packages.props` |

Each pin is repeated per configuration (Net481/Net80 or 2024/2025/2026).

**None of the pinned versions exist.** `26.10.20.957` (Windows.Data), `.958` (Windows), `.959` (Domain), `.1330` (Revit.Logic) and `.1331` (Revit.UI) are not in `C:\Repo\NugetPackages` or the NuGet cache, and there is no Kelly.Domain or Kelly.Revit.UI package there at all. v5 cannot restore until the chain is rebuilt.

### The add-in uses the database directly (skips four layers)

| Where | What |
|---|---|
| `Kelly-Revit-v5/src/App.cs` `ResolveConnectionStrings` | `ConnectionStringResolver.Read` and `DatabaseConnectionTester.Test` |
| `Kelly-Revit-v5/src/Services/ApplicationSessionService.cs` | `new ApplicationSessionStore(new SqlServerService(...))`: the store is already in Kelly-Domain, but the add-in builds its connection |
| `Trade.Contenter/.../FabricationCustomDataProposedReportCommand.cs` | `SqlServerService` → `[dbo].[USP_CustomDataUpdater_SelectAll_v20260811]` |
| `Trade.Contenter/.../FabricationCustomDataUpdaterCommandV1.cs` | `SqlServerService` → `[fabrication].[USP_ItemCustomDataPivotedOnComponentIdView_Select…]` |
| `Trade.Contenter/.../FabricationCustomDataUpdaterCommandV2.cs` | `SqlServerService` → the CustomDataUpdater select-all procedure |
| `Trade.Developer/.../ProductRangeSchedulesCommand.cs` | `SqlServerService` → `[dbo].[USP_CategoryType_SelectAll_v20250221]` |
| `src` and 5 modules' `GlobalUsings.cs` (not Trade.Manager) | `global using Kelly.Windows.Data.Database;` |

### Sensitive information

`App.cs` `ResolveConnectionStrings` holds built-in fallback connection strings naming the production server (`lvsqlp03\misc`, databases `VCS` and `VCS Content`). Move them into the shipped `.config` only, or into the layer that owns the connections, and decide whether a missing config should fail rather than fall back to production. *Resolved 2026-10-30: `ResolveConnectionStrings` and the connection strings were deleted when v5 moved to the CSV data files.*

## Steps

Each step follows the shared rules: `develop` only, TDD (failing test first), README / Changelog / XML docs with any public-surface change, no co-author lines.

0. **Make v5 buildable** (needs the hold lifted). Package source mapping so restore no longer hits the Telerik feed's 401 (NU1301); clear Data-v3's stale `obj` from the moved test project (CS0579). Build every configuration of each repo, bottom up, with `-p:GeneratePackageOnBuild=false`, to get a clean baseline.
1. **Guard test first.** Add an architecture test that fails today, for example in BuildConfigs or each repo's test project, that reads the project files and checks:
   - a project pins only the Kelly package directly below its layer;
   - nothing in Kelly-Revit-v5 references `Kelly.Windows.Data.Database`.
2. **Move the SQL into the lower layers** (TDD in Kelly-Domain / Kelly-Revit-Logic):
   - Kelly-Domain (or Windows.Data) owns connection resolution and the connection test; `App.OnStartup` only registers it, as it already does `ServerData.Register`.
   - Kelly-Domain provides the `ApplicationSessionStore` already wired to its connection; `ApplicationSessionService` just asks for it.
   - One store per data set the four commands read (CustomDataUpdater records, ItemCustomData pivoted on component ID, CategoryType records), in Kelly-Domain if Revit-free, else Kelly-Revit-Logic; the commands call the store.
   - Remove the six `global using Kelly.Windows.Data.Database;` lines.
3. **Central package management.** Add `Directory.Packages.props` to Kelly-Windows-v3, Kelly-Domain, Kelly-Revit-Logic-v5, Kelly-Revit-UI and Kelly-Revit-v5, with only the direct-below pin per configuration; drop `Version=` from the `PackageReference` items and remove the skip-layer references.
4. **Rebuild the chain bottom up**, one shared version per release (`-p:VersionCalculated=<v> -p:FileVersionCalculated=<v>`): build each layer's packages in every configuration, re-pin the layer above, build it, and so on to Kelly-Revit-v5 (no install: the jhkweb `Directory.Build.targets` guard, KTR0004).
5. **Verify:** the guard test passes, every configuration builds, then the in-Revit tests in Revit 2024 with the add-in disabled (`.addin` → `.addin.x` and back).
6. **Record:** Changelog headings dated with the package versions, README "SOLID principles" (Dependency Inversion should move with step 2) and "Running the tests", the KTR release notes doc.

## Order and dependencies

Step 0 before anything. Step 1 before 2 and 3. Steps 2 and 3 are independent of each other but both change the same project files in Kelly-Revit-v5, so do them one after the other. Step 4 needs 2 and 3. Changes in a lower layer reach the add-in only after step 4.
