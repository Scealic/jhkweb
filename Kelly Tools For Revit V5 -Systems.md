# Kelly Tools For Revit V5 - Systems

The overarching systems that run in Kelly Tools For Revit Major Version 5: how the add-in starts, which services and events run, how commands reach the ribbon, and the shared machinery they use. Per-tool detail lives in the code and the Linear KTR5 labels; this file is the map.

| | |
|---|---|
| Last updated | 2026-11-10 (initial version) |
| Read from | Kelly-Revit-v5 `a0a3afad`, Kelly-Revit-Logic-v5 `7c12f3b`, Kelly-Revit-UI `a752b73` (all `develop`) |
| Update rule | Root `.claude/CLAUDE.md`: refresh at the end of each day, or whenever this file is missing |

## 1. Layers

```
Kelly-Windows-Data-v3 → Kelly-Windows-v3 → Kelly-Domain → Kelly-Revit-Logic-v5 → Kelly-Revit-UI → Kelly-Revit-v5
  (data access)           (hosting, prompts,    (domain types,   (Revit API logic,      (ribbon, commands,   (host + six
                           logging, WPF)          registries)      services, updaters)    MVVM, prompts)       ribbon modules)
```

Each layer is a NuGet package pinned by exact version in the layer above. Kelly-Revit-v5 is the add-in: `src/` is the host, and each ribbon tab is a module DLL under `modules/`.

## 2. Startup (`Kelly-Revit-v5/src/App.cs`)

`App` is the `IExternalApplication`. Its constructor sets up Serilog (`LoggerServices` from Kelly.Windows, the "Application Logger", old log files deleted). `OnStartup` then runs, in order:

1. `RibbonHost.Initialize` (Kelly.Revit.UI): stores the `UIControlledApplication` for the ribbon code and the modules.
2. `AddInId` from a fixed GUID prefix plus the Revit year.
3. **Process-wide seams** - registered before anything uses them (section 3).
4. `DataFileLoader.Load` with a new `DataFileService`: loads the CSV data files from `C:\Program Files\JH Kelly\Kelly Tools For Revit\Data`. Failure shows "Kelly Tools For Revit Data Error" and fails startup.
5. **Application services** started through `ServiceProvider.AddServices` (section 4). Any failure shows "Application Service Start Error" and fails startup.
6. Telerik assemblies loaded and the Telerik licence registered; failure fails startup.
7. Application, Revit and referenced-assembly information written to the log.

`OnShutdown` stops every service (`ServiceProvider.Stop`) and flushes the log.

## 3. Process-wide seams (registries)

Static registries in the lower layers that the host fills once at startup, so shared code never references the host. Each throws when read before registration (no silent defaults).

| Seam | Layer | Registered with | Used for |
|---|---|---|---|
| `UserPrompt` | Kelly.Windows `Prompts` | `RevitUserPrompt` (Kelly.Revit.UI, shows TaskDialogs) | Every prompt and error dialog; tests register a recording `IUserPrompt` |
| `DefinitionRegistry` | Kelly.Domain `Definitions` | `App.GetDefinition` (external parameter definition cache by name) | Resolving Kelly shared parameter definitions by name |
| `DataFiles` | Kelly.Domain `Caches` | `App.Caches` getters: components, products, product ranges, services, systems, terminology, category types; `RegisterStore` for the `DataStore` | Data-file lists for shared code; functions, so a reload is seen without re-registering |
| `AddInConfiguration` | Kelly.Domain `Projects` | `Settings.Default.AlternateLookupTrigger` | Host settings that shared code reads |
| `AddInServices` | Kelly.Windows `Hosting` | `App.ServiceProvider` | Lets modules (which do not reference the host) get running services, e.g. `AutoUpdaterService` |
| `RibbonHost` | Kelly.Revit.UI `Ribbon` | `UIControlledApplication` | Creating tabs, panels and finding combo boxes |

## 4. Application services

`IApplicationService` / `ApplicationService` / `ServiceProvider` live in Kelly.Windows `Hosting`. The host collects every `IApplicationService` declared in its own assembly plus two it creates itself, and `ServiceProvider.AddServices` starts them in ascending `StartOrder` behind a progress window. A service that does not report itself started is not registered; the first failure stops the loop. `GetService<T>()` resolves by exact type, base class or interface (e.g. `IAutoUpdaterControl`).

| Order | Service | Layer | What it does |
|---|---|---|---|
| 0 | `DataFileService` | Logic `Caches` | Loads the data files into a `DataStore` and builds the caches (components, external parameter definitions, products, product ranges, services, systems, terminology). One load path for startup and Reload Data; a failed load keeps the current data. |
| 2 | `AutoUpdaterService` | Logic `Updaters` | Facade over `AutoUpdaterManager`: builds the auto updaters per document, suspends/resumes them (`RunningChanged` event drives the ribbon power icon), enables/disables single updaters, writes updater reports, unregisters all on stop. Implements `IAutoUpdaterControl`. |
| 3 | `ApplicationSessionService` | host `Services` | On `ApplicationInitialized`, records the `ApplicationSession` (user, Revit version/build). Nothing is persisted (SQL Server dropped 2026-10-30). |
| 4 | `RibbonService` | host `Services` | Builds the ribbon by loading the modules (section 6). |
| 5 | `EventService` | host `Services` | Subscribes the Revit application and UI events (section 5). |

## 5. Events

### 5.1 Revit events (`EventService`)

Handlers live in the host (`src/EventHandlers`) and in Kelly.Revit.Logic `Documents`. Bodies run through `EventHandlerTools.Run`, which logs the event and reports exceptions through `HandleIt`. Events without behaviour go to `LogOnly`.

| Event | Handler | Behaviour |
|---|---|---|
| `DocumentOpened` | Logic `DocumentOpenedEventHandler` | Skips families and failed opens. Reports missing Kelly shared parameters (host `MissingSharedParametersDialog`); in a Kelly project builds the auto updaters for the document and ensures the add-in's views exist. |
| `DocumentClosing` | Logic `DocumentClosingEventHandler` | Removes the document's updater state (`AutoUpdaterService.Remove`). |
| `DocumentSynchronizingWithCentral` | Logic `DocumentSynchronizingEventHandler` | Suspends the auto updaters. |
| `DocumentSynchronizedWithCentral` | Logic `DocumentSynchronizedEventHandler` | Resumes the auto updaters. |
| `DocumentSaved` | Logic `DocumentSavedEventHandler` | Family documents: stamps revision information (`SetRevisionInformation`). Projects: nothing yet (empty status switch). |
| `DocumentChanged`, `ViewActivated`, `ViewActivating` | host `EventHandlers` | Log only (empty body through `EventHandlerTools.Run`). |
| `ApplicationInitialized`, `DocumentClosed`, `DocumentCreated/Creating`, `DocumentOpening`, `DocumentReloadedLatest/ReloadingLatest`, `DocumentSavedAs/Saving/SavingAs`, `LinkedResourceOpened/Opening`, `FabricationPartBrowserChanged`, `SelectionChanged` | `LogOnly` | Log only. |

`ApplicationSessionService` subscribes `ApplicationInitialized` separately.

### 5.2 Add-in events

- `AutoUpdaterService.RunningChanged(bool)`: raised after Suspend/Resume; Trade.All's Updater panel sets its power icon from it.
- Ribbon combo box `DropDownClosed` (11 subscriptions in the modules, mostly the assigner combo boxes): shared handler `RibbonComboBoxEvents.RefillOnRefreshList` (Kelly.Revit.UI) refills on "Refresh List" and refreshes the active view.
- Revit `ExternalEvent`s: only Trade.Pipe's Olet Checker (`SelectionExternalEventHandler`, `ConnectOletsExternalEventHandler`) for modeless work.

## 6. Ribbon and modules

- `RibbonService` → `RibbonModuleLoader.LoadModules` (Kelly.Revit.UI) loads, in tab order, `Kelly.Revit.Trade.All.dll`, `.Pipe`, `.Duct`, `.Contenter`, `.Manager`, `.Developer` from beside the add-in. A missing file means no tab; a failing module is reported and never stops startup.
- Each module declares an `IRibbonModule`; its `CreateRibbon` adds panels through `RibbonPanelConfigurationBase` subclasses, which add `RibbonPushButton`, `RibbonSplitButton`, stacked/pull-down buttons and `RibbonComboBox`/`ProjectRibbonComboBox` items. Icons are embedded `<ImageName>16.png` / `32.png` (`RibbonIconResources`).
- `test/Tests.Revit/AddIn/AddInContractTests` checks every module's commands, availability classes and buttons.

| Module (tab) | Panels | Commands | Areas |
|---|---|---|---|
| Trade.All (Tools) | General, Layout, TagAndNumber, AssignerVisibility, BillOfMaterials, Container, Supports, Updater | 79 | Assigners (service, system, line/module/spool number, detailing package) with combo boxes and view filters; bill of material; layout points; spools and modules; supports; updaters (auto toggle, manual run); views; data reload; Many Connect; schedule export; about |
| Trade.Pipe (Pipe) | PipeGeneral, PipeWeld | 7 | Olet checker, valve clearance spheres, weld location assign |
| Trade.Duct (Duct) | SheetMetalAnnotation, SheetMetalQualityCheck | 5 | Duct item numbers, length and mirror checks |
| Trade.Contenter (Content) | ContentFabricationParts, ContentFamily | 8 | Fabrication custom data reports/updaters, product code check, part dimension export, revision setter |
| Trade.Manager (Manage) | Manager, Parameter | 6 | Coordinates, delete by id, family, shared parameters |
| Trade.Developer (Develop) | Developer | 18 | Reports, purges, probes, sandboxes |

## 7. Commands

Kelly.Revit.UI `Commands`:

- `CommandBase` / `IExternalCommandBase`: base of the `IExternalCommand`s; `InitializeCommand` captures `ExternalCommandData` (UI application, document).
- `CommandRunner`: runs a command's work and maps the outcome to `CommandResult` (Escape → Cancelled; `ErrorMessageException` or any other exception → Failed with the message); `CommandResultExtensions.ToResult` gives Revit's `Result`.
- `IExternalCommandMvvm` + `MvvmDialog.Show(viewModel, view)`: the MVVM tool pattern (create and validate view model and view, show modal, dispose). `Mvvm/ViewModel`, `IView`, `IViewModel`; shared XAML in `Resources` and `Controls` (DialogFooter, DialogMenu, ScopeControl, ElementControl). Views and view models stay in Kelly-Revit.
- Availability: `DocumentCommandAvailability` (needs an active document), `SelectionMadeCommandAvailability`, `DocumentHasElementsOfTypeCommandAvailability`; each module's concrete availability classes derive from these.
- Selection filters and scope helpers (`Selection`, `Scope`: `UiDocumentScopeExtensions`, `ScopeSourceExtensions`).

## 8. Transactions (`OperationService`)

Kelly.Revit.Logic `Operations/OperationService` wraps a Revit `Transaction` or `TransactionGroup` (`TransactionKind`, `TransactionName`) with timing (`StopWatchState`) and an operation log (`OperationServiceLogRecord`) under `C:\Projects\Revit\<document title>`. `Stop` commits or assimilates; `IsCommitted` is true only when the change actually reached the document. Migration of the remaining call sites to `OperationService.Run` is parked.

## 9. Updaters

Kelly.Revit.Logic `Updaters`:

- **Auto updaters**: `AutoUpdaterManager` creates one `AutoUpdater` (`IUpdater`) per `IAutoUpdaterConfiguration` (19 in `Configurations/Auto`: bill of material type, checkbox defaults, content identity, detailing package, detailing phase, end preparation, fabrication part instances, field trim, layout discipline, line number, material, schedule gauge, service (fabrication and non-fabrication), size, suspended support, system, weld). Built per document on open, bound to the document's element service and trigger filter, ordered by the service's execution order.
- **Element services**: `ElementService` (base, `IElementService`) per configuration holds the elements, the filter and the processing loop; `ElementDataModel`s read and write the Kelly parameters.
- **Manual updaters**: `ManualUpdaterRunner` suspends the auto updaters, runs each manual configuration (15 in `Configurations/Manual`, `ManualUpdaterConfigurationSet`) over a scope (document, view, selection) each in its own operation with a progress window, and always resumes. Used by Trade.All's Updater Manual commands and the Spool Manager.
- **Fabrication custom data**: `CustomDataUpdater` / `CustomDataUpdateEvaluator` write data-file values into fabrication part custom data (Contenter's updater commands).
- Suspend/resume points: sync with central, manual runs, the Updater power button.

## 10. Data and caches

- **Data files** (`DataFileService` + `DataFileLoader`): CSV only, with `manifest.json` (SHA-256 and row counts checked). Reload Data (Trade.All, Updater panel) uses the same loader; an older export loads only if the user agrees.
- **Application caches**: `ComponentCache`, `ExternalParameterDefinitionCache` (with `CacheByDefinitionName`), `ProductCache`, `ProductRangeCache`, `ServiceCache`, `SystemCache`, `TerminologyCache`, exposed through `App.Caches` and the `DataFiles` seam.
- **Document caches** (Logic `Caches`): `DocumentCache` / `IDocumentCache` with `ServiceDocumentCache`, `SystemDocumentCache`, `NumberedDocumentCache` (line, module, spool numbers) and `DetailingPackageDocumentCache`; they feed the assigner combo boxes.

## 11. Cross-cutting

- **Logging**: Serilog through `LoggerServices` (application log in the application logs folder); `EventHandlerTools` writes event names to the development log.
- **Errors**: `ExceptionExtensions.HandleIt` (Kelly.Windows) logs and shows a "JH Kelly Exception Handler" prompt through `UserPrompt`; `ErrorMessageException` carries a user-facing message to `CommandRunner`.
- **Progress**: `ProgressBarService` (Kelly.Windows `Wpf`) for service start-up, updater builds and manual runs.
- **Install**: builds of Kelly-Revit-v5 do not install unless `-p:InstallAddin=true`; V5 installs to `C:\Program Files\JH Kelly\Kelly Tools For Revit\V5\<year>` with manifest `Kelly Tools For Revit 5.addin`; the version installed last is active in a Revit year.

## Change log

- 2026-11-10: initial version.
