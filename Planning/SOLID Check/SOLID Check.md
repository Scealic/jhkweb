SOLID Check

First checked 2026-10-15; re-checked against the `develop` working trees on 2026-10-19, and twice on 2026-10-20: after the package 26.10.20.8xx builds and the test attribute commits, and at 11:10 after the `IDatabaseDataService` deletion, with `kelly-solid-check/scripts/measure.sh` (in the personal skills folder since 2026-11-05). A ticked box is fixed (or, for a "Good" item, still holds). Counts and line numbers are from 2026-10-20 11:10. The commits since the morning check touch only READMEs (the shared outline and a troubleshooting row for lost in-Revit test results), and change no rating. The work since 2026-10-19 (base classes renamed to the `…Base` suffix: `CacheBase`, `ServerServiceBase`, `DefinitionSetBase`, `CommandBase`, `RibbonPanelConfigurationBase`; layout point and connection work; test attributes; AGENTS.md moved to `BuildConfigs/SHARED-AGENTS.md`) changes no rating.

The pattern is still the same from bottom to top. The layers mostly do well on interface segregation (ISP) and substitution (LSP). Dependency inversion (DIP) is the weakest principle in every layer, and single responsibility (SRP) gets worse as you go up the stack. Since the first check, the work of 2026-10-19 removed `IModel`, took every `MessageBox` out of Kelly-Windows and fixed `ServiceProvider.GetService`; that lifts Kelly-Windows' SRP and Kelly-Domain's LSP. Kelly-Domain's ISP (`IColorPalette`) and DIP (static registries, SQL and file I/O in the domain) stay where they were. Removing `UpdateElement`/`UpdateModel` from `IElementEntity` lifts Kelly-Revit-Logic's LSP, and Kelly-Revit-UI's `nameof(T)` message is fixed; otherwise Kelly-Revit-Logic, Kelly-Revit-UI and Kelly-Revit are unchanged.

| Repo               | SRP                    | OCP                 | LSP                | ISP                | DIP                    |
| ------------------ | ---------------------- | ------------------- | ------------------ | ------------------ | ---------------------- |
| Kelly-Windows-Data | Strong                 | Mixed               | Strong             | Mixed              | Mixed                  |
| Kelly-Windows      | Mixed (was Weak–Mixed) | Mixed               | Mixed              | Strong             | Mixed                  |
| Kelly-Domain       | Mixed                  | Mixed               | Strong (was Mixed) | Mixed              | Weak–Mixed             |
| Kelly-Revit-Logic  | **Weak**               | Mixed               | Strong (was Mixed) | Mixed              | **Weak**               |
| Kelly-Revit-UI     | Mixed                  | **Strong**          | Mixed              | Mixed              | **Weak**               |
| Kelly-Revit        | Mixed                  | Mixed (host strong) | Strong             | Strong             | **Weak**               |

### Per repo

**Kelly-Windows-Data** is the cleanest repo. Its types are small and do one job each, and new database engines plug in through `ServerServiceBase.CreateConnection()`.

- [x] **Fat interface:** fixed 2026-10-20, and `IDatabaseDataService` is now deleted. It had 18 methods plus `Dispose` (the first check said 22, which was wrong); the nine unused async methods went on 2026-10-19 (`c526133`). Then it was split into `IDatabaseReader` (4 select methods) and `IDatabaseWriter` (5 write methods) and marked obsolete (packages Kelly.Windows.Data 26.10.20.941, Kelly.Windows 26.10.20.942, Kelly.Domain 26.10.20.946; commits `d34921f`, `9fed64c`, `5c89902`), and every consumer moved to the side it uses: 7 readers, `ApplicationSessionStore` a writer. Its last user, Kelly-Revit-Logic's `ProjectInformationWrapper`, now names `SqlServerService`, so it was deleted (Kelly.Windows.Data 26.10.20.957, repinned through Kelly.Windows 26.10.20.958 and Kelly.Domain 26.10.20.959, commits `f118aaa`, `5ac7787`, `166cbf8`; Kelly.Revit.Logic 26.10.20.1031, Kelly.Revit.UI 26.10.20.1033 and the add-in repinned but not yet committed). It added only `IDisposable`, and `ServerServiceBase.Dispose` is a no-op, so `SqlServerService` stays usable in `using`. The two test fakes lost their dead async methods (the reader-only fake in `SqlRecordCacheTests` has 4 members, was 19).
- [ ] **Hard-wired cache:** `CacheBase` creates `new SqlServerService(...)` itself (`Caching/CacheBase.cs:8`), and it doesn't implement the parallel `ICache` interface. — Linear: KWD3-12 (2026-11-06)

**Kelly-Windows**

- [x] **Good:** `UserPrompt` is a model seam: the host registers it, it fails fast when nothing is registered, and tests can reset it. It is now the only way this layer reports to the user.
- [x] **Bypassed prompt seam:** fixed 2026-10-19 (`2ad3c02`). `HandleIt` reports through `UserPrompt` and throws if none is registered; argument checks throw instead of prompting. No `MessageBox` is left in `src`.
- [x] **Mixed jobs:** fixed 2026-10-19 (`9d4be62`). `IModel` is gone; `Persistence/ModelBase` keeps only `INotifyPropertyChanged`/`INotifyDataErrorInfo`.
- [x] **Lookup bug:** fixed 2026-10-19 (`7b63f6a`, `e214a7e`). `GetService<T>` tries the exact type first, then a single assignable service, and throws when none or several match.
- [ ] **Still open:** `Persistence/SqlRecordCache.cs` keeps a convenience constructor that does `new SqlServerService`, so SQL Server knowledge stays in the Windows layer. (The WPF `ProgressBarService` is now created only behind the `ProgressReporter` seam, not by `ServiceProvider`.) — Linear: KW3-24 (2026-11-06)

**Kelly-Domain**

- [x] **Good:** its own interfaces are narrow, it has very few `switch` statements, and every class that reaches the database takes an injected `IDatabaseReader` or `IDatabaseWriter` (was `IDatabaseDataService`, deleted 2026-10-20). New since the first check: `Projects/ApplicationSessionStore` (2026-10-19) owns the session's stored procedures and takes the data service in its constructor, so `ApplicationSession` only describes itself.
- [ ] **Global registries:** `DefinitionRegistry` and `ServerData` are global service locators. `DefinitionSetBase` resolves from `DefinitionRegistry` in its constructor (`Definitions/DefinitionSetBase.cs:16`), and `DefinitionSetCache` freezes the result in a static `Lazy` for the life of the process. — Linear: KD-51 (2026-11-06)
- [ ] **Infrastructure in the domain:** still present. 14 files name `USP_` stored procedures; `GaugeNameResolver` creates `new SqlServerService` (`Products/GaugeNameResolver.cs:9`), as do the string-constructor overloads of `ConnectorPreparationResolver` and `ConnectorSizeDataResolver`; `PcfReaderController` and `StandardUnits` read the file system directly. — Linear: KD-52 (2026-11-06)
- [x] **Stub methods:** fixed 2026-10-19 (`f78b65b`). No model implements `IModel` any more, so no `RecordInsert`/`RecordUpdate` stubs remain.
- [ ] **Still open:** `Signatures/IColorPalette` has 10 numbered `Color00..Color09` properties instead of an indexed collection. — Linear: KD-53 (2026-11-06)

**Kelly-Revit-Logic**

- [ ] **Large static files:** `DocumentExtensions.cs` is now 1,862 lines with about 51 unrelated static methods. `Spool.cs` (1,242 lines) is a domain model that also creates views, schedules and sheets, and calls `UserPrompt` (7 times). — Linear: KTRL5-89 (2026-11-06)
- [ ] **Few abstractions:** 92 files contain a static class (95 on 2026-10-15, 91 on 2026-10-19), and there are still only 7 interfaces.
- [x] **Prompt seam:** every prompt in this layer goes through `UserPrompt`. Correction: the 2026-10-20 morning check listed `Common/TaskDialogSimple` and its 6 calling files as a bypass, but `TaskDialogSimple` builds a `PromptRequest` and calls `UserPrompt.Show`, and `HandleIt` does too. The one real bypass, a WPF `MessageBox` in `DocumentExtensions.Create3DViewTransaction` (whose text spoke of "setting support elevations"), was replaced on 2026-10-20 (`6504bdb`, not yet in a package): it reports through `UserPrompt`, returns `null`, and no longer throws from calling `Stop` after `RollBack`. `PenetrationTagTools.ApplyTags` had the same crash and reported each error twice; fixed 2026-10-20 (not yet committed or packed), it now reports once through `HandleIt` and returns normally.
- [ ] **Type checks:** `FabricationPartExtensions` has 46 `is Fabrication…` checks. — Linear: KTRL5-90 (2026-11-06)
- [x] **Broken contract:** fixed 2026-10-19 (`ad384df`, package 26.10.19.1145; the full in-Revit run passes, 511 of 511). `IElementEntity` no longer declares `UpdateElement` and `UpdateModel`, which `VirtualElement` implemented by throwing `NotImplementedException` and `PhysicalElementEntity` by doing nothing; nothing called them through the interface.
- [x] **Best area:** the updater subsystem. New updaters are added as new classes without editing `AutoUpdater`, and `AutoUpdater` follows Revit's `IUpdater` rules, including never throwing into Revit.
- [x] **Since the first check:** `BuiltInCategoryMeta` no longer implements `IModel` (`06d90b0`); list and view-name checks throw instead of prompting (`7f83118`, `99e8ca6`); progress goes through the `ProgressReporter` seam instead of a concrete window (`e7dcc0c`, `9fd2bea`); disconnecting goes through one `ConnectorTools.DisconnectAll` and the new `ElementConnectionExtensions`, and the `VictaulicConnectorTools` copies are marked obsolete (`a5cf24d`).

**Kelly-Revit-UI** (since the first check: repins, the `nameof(T)` fix, `CoreCommand` renamed to `CommandBase` and `BaseRibbonPanelConfiguration` to `RibbonPanelConfigurationBase`)

- [x] **Good extension points:** `DocumentCommandAvailability` is a clean template method where subclasses override only `IsAvailable`. `RibbonModuleLoader` finds modules by reflection.
- [ ] **`ViewModel` does too much (375 lines):** it runs element queries, shows its errors (through `TaskDialogSimple`, which is `UserPrompt`; the earlier checks said it called `TaskDialog` directly, which was wrong), walks the WPF tree, and depends on the concrete `Command.UiDocument` (the view model's `CommandBase`). — Linear: KTRUI-25 (2026-11-06)
- [ ] **Unimplemented interface:** `ViewModel` (`Mvvm/ViewModel.cs:6`) still derives only from `ViewModelBase` and doesn't implement the `IViewModel` lifecycle it declares, so the lifecycle order exists only in comments. — Linear: KTRUI-25 (2026-11-06)
- [ ] **Static locator:** `RibbonHost.UiControlledApplication` is a static service locator. — Linear: KTRUI-26 (2026-11-06)
- [ ] **Bypassed prompt seam:** `RibbonExtensions` shows two Revit `TaskDialog`s directly (`RevitTaskDialog.Show`, lines 168 and 177) instead of going through `UserPrompt`. They are the layer's only ones; `RevitUserPrompt` is the seam's own Revit implementation. — Linear: KTRUI-26 (2026-11-06)
- [x] **Small bug:** fixed 2026-10-19 (`0cc6c77`, package 26.10.19.1145). `SetPowerIcon<T>` used `nameof(T)`, which always printed "T"; its message now comes from `ToItemIdErrorMessage<T>`, which names the button type, and is tested.

**Kelly-Revit (the add-in)**

- [x] **Host is good:** startup services are found by reflection and started in `StartOrder`, and the modules use narrow interfaces.
- [ ] **Hard-coded module list:** `RibbonService.cs:36` names every module DLL, so a new tab needs a host edit. It's deliberate, because it sets the tab order, and kept as is (reviewed 2026-10-20): the reflection-based discovery behind it is what lets a module DLL be optional.
- [x] **Modules toggling each other's tabs:** fixed 2026-10-20 (not yet committed or packed). Manager's `ActiveProjectCommand` enabled Tools, Pipe and Duct itself, and the host's `DocumentOpenedEventHandler` enabled only Tools, so the two disagreed. Now each trade module subscribes its own tab to Kelly.Revit.UI's new `ActiveProjectSignal`, and both raise it without naming any tab.
- [ ] **Module ranking:** Manager, DuctTrade and PipeTrade are thin and delegate to Logic. AllTrade is the worst:
  - `SpoolManagerViewModel.cs` is 1,056 lines and runs 7 transactions plus its own dialogs.
  - The Supports and Vicious ViewModels and code-behind open raw `Transaction`s.
  - The "Acquired" Vicious code has no Logic layer at all.
- [ ] **Duplication in Contenter:** `FabricationCustomDataUpdaterV1` and `V2` still sit side by side doing the same job. — Linear: KTR5-4750 (2026-11-06)
- [ ] **Static dependencies:** — Linear: KTR5-4751 (2026-11-06)
  - 36 files show a Revit `TaskDialog` directly (`TaskDialog.Show` or `new TaskDialog`; the earlier checks counted only `TaskDialog.Show`, 25 files), against 8 that use `UserPrompt` and 7 more that go only through `TaskDialogSimple`, which is `UserPrompt`.
  - Three WPF `MessageBox.Show` calls bypass both (missed by the earlier checks): `ViciousFileBasedSystemPipePlaceTools.cs:329`, `SuspendedSupportManagerViewModel.cs:508` and `UserReportCommand.cs:25`.
  - `Command.UiDocument` (the view model's `CommandBase`, called `CoreCommand` until 2026-10-20) is used 49 times.
  - There are 9 `AddInServices.GetService<AutoUpdaterService>()` lookups by concrete class (was 10).
- [x] **Since the first check:** the session row is saved through the injected `ApplicationSessionStore` (`01067324`), and progress goes through `ProgressReporter` (`98ceacb7`).

### Patterns across the repos

1. **Static seams instead of injection.** `UserPrompt`, `DefinitionRegistry`, `ServerData`, `RibbonHost`, `App.*` and `Command.UiDocument` (the view model's `CommandBase`) are all reached through statics. Registering them in `OnStartup` keeps lower layers from depending on the add-in, which is real dependency inversion. But they work as service locators, so dependencies don't show in signatures and tests have to swap globals, which is why `KellyDefinitions` exists. The database classes show the alternative: since 2026-10-20 each takes a constructor-injected `IDatabaseReader` or `IDatabaseWriter`, `ApplicationSessionStore` first.
2. **Bypassing `UserPrompt`.** Fixed in Kelly-Windows and (2026-10-20, not yet committed) Kelly-Revit-Logic. Left: two direct `TaskDialog`s in Kelly-Revit-UI (`RibbonExtensions`), and in Kelly-Revit 36 files with a direct `TaskDialog` and three WPF `MessageBox` calls. They are what blocks headless tests. (`TaskDialogSimple` is a `UserPrompt` wrapper, not a bypass; earlier checks counted it as one.)
3. ~~**`IModel`.** Mixing persistence with UI binding causes the stub methods in Domain.~~ Fixed 2026-10-19: `IModel` is removed from every layer.
4. **Large static extension classes** in Logic, and **logic in ViewModels** in AllTrade.

### Fixes with the best return

1. Route every dialog through `IUserPrompt`: done in Kelly-Windows and Kelly-Revit-Logic (2026-10-20); Kelly-Revit-UI (`RibbonExtensions`, 2 calls) and Kelly-Revit (36 files with `TaskDialog`, three `MessageBox`) remain.
2. Move transactions and business logic out of the AllTrade ViewModels into Logic.
3. Split `DocumentExtensions` by concern.
4. ~~Split `IModel`~~ (done: removed). ~~Remove the unused async methods~~ (done, package 26.10.19.1136). ~~Split `IDatabaseDataService` into read and write interfaces, and trim the two test fakes with it~~ (done 2026-10-20; `IDatabaseDataService` is deleted).
5. ~~Fix the small bugs: `GetService` type matching, `nameof(T)`, and the `VirtualElement` throws.~~ All done 2026-10-19.
