# Placement rules: project part

The layers, the user's rules, the placement table and the unsafe-move list of this project. The generic method (move record, finding, reviewing, compile probe, work packages) is in the skill's `references/placement-rules.md`; this file overrides it where they differ. Finders, reviewers and implementers read both.

## The layers

Bottom to top. Each layer is a NuGet package pinned by exact version in every layer above it, and may use only the layers below it.

| # | Repo | Assembly, project | What belongs there | May reference |
|---|---|---|---|---|
| 1 | Kelly-Windows-Data | `Kelly.Windows.Data`, `src/Data.csproj` | The data core, with no file format or database of its own: the read-only data folder (`DataDirectory`, `manifest.json`, file hashes and checks, records read through pluggable readers), the writer side an export uses, caching infrastructure, and the interfaces the other layers build on (`IRecord`, `ICache`). The formats live in separate libraries (Kelly-Windows-Data-Csv, -Json, -SqlServer, -Sqlite); v5 uses only the CSV reader, which the host pins. | BCL. No Revit. Net481, Net80, Net100. |
| 2 | Kelly-Windows | `Kelly.Windows`, `src/Logic.csproj` | Generic Windows and WPF helpers with no Kelly business meaning: logging, files, text, measurements, palettes, prompts (`UserPrompt`, UI-agnostic), WPF helpers and the progress window, collections, hosting/DI, reflection, workstation. | Windows.Data, Serilog, ObjectsComparer, WpfScreenHelper, System.Management, DirectoryServices. No Revit. |
| 3 | Kelly-Domain | `Kelly.Domain`, `src/Domain.csproj` | The Kelly business model without Revit: enums, records, DTOs, identifiers, caches, PCF, shared-parameter definitions and sets (`DefinitionRegistry`, `DefinitionSetBase`), vocabulary, `ScopeType`. | Windows, Windows.Data, Newtonsoft.Json, CsvHelper. No Revit (a layering test enforces it). |
| 4 | Kelly-Revit-Logic | `Kelly.Revit.Logic`, `src/Revit.csproj` | Revit database behaviour: extensions, element services, updaters, `OperationService` transactions, collectors, purges, spools, MEP. | The three above, **RevitAPI.dll only** (no RevitAPIUI, AdWindows or Telerik), CsvHelper. 2024 (net481), 2025 and 2026 (net8.0-windows). |
| 5 | Kelly-Revit-UI | `Kelly.Revit.UI`, `src/Revit.UI.csproj` | The shared ribbon, command, MVVM, selection-filter and availability framework: `CommandBase`, `IExternalCommandBase`, `IExternalCommandMvvm`, `ViewModel`, `IView`, `IViewModel`, availability base classes (`DocumentCommandAvailability`, `SelectionMadeCommandAvailability`), ribbon types (`RibbonPanelConfigurationBase`, `RibbonModuleLoader`), selection filters, shared WPF controls, `UIDocument` scope helpers. | The four above, RevitAPI, RevitAPIUI, AdWindows, Telerik. |
| 6 | Kelly-Revit | `Kelly.Revit` (`src/Core.csproj`; its namespaces are `Kelly.Revit.Core.*`), `Kelly.Revit.Trade.<Module>` (`modules/Trade.<Module>/`) | The add-in. `src/` is the host: `App` (`IExternalApplication`), `EventService`, `RibbonService`, `ApplicationSessionService`, document event handlers, `Properties`. Each module (`Trade.All`, `Trade.Pipe`, `Trade.Duct`, `Trade.Contenter`, `Trade.Manager`, `Trade.Developer`; once called AllTrade, PipeTrade, DuctTrade, Contenter, Manager, Developer) holds its tools: commands, push buttons, availability classes, views, view models and helpers only that tool uses. Office interop, ExcelDataReader. | Everything below it, but no SQL Server: since 2026-10-30 the add-in reads only the CSV data files, and `NoSqlServer.Build.targets` fails the build on the SQL client, Dapper, a SQL Server service type, a `USP_` string or a connection string. Its only Kelly layer package is `Kelly.Revit.UI` (KTR0006); the lower layers arrive through it. The host also pins the CSV reader, `Kelly.Windows.Data.Csv`. |

Each project has `src/GlobalUsings.cs` (modules: `modules/<Module>/GlobalUsings.cs`) with the global usings and aliases its files rely on. Kelly-Revit aliases `Element`, `Category`, `View`, `Settings` and `Component` there.

## The user's rules

These are hard rules. A move that breaks one is rejected, whatever it gains.

1. **Kelly-Windows and Kelly-Windows-Data must not know anything about the Revit API**: no Autodesk types or references, and no Revit behaviour encoded in names, comments or string literals. Kelly-Domain stays Revit-free too.
2. **These files stay in Kelly-Revit**: every class implementing `IExternalCommand` (directly or through `IExternalCommandBase`/`IExternalCommandMvvm`), every `*View.xaml` with its `*View.xaml.cs`, every `*View.cs` and every `*ViewModel.cs`. The file and its class stay. The code inside a view, view model or model does not have to (rule 6). Code inside a command moves on the same terms as any other code.
   **No type that is part of WPF MVVM moves out of Kelly-Revit** (the user, 2026-11-06, emphatic). That covers views and every XAML window, page or user control with its code-behind, view models, models a view or view model binds to or fills (rows, items, settings, DTOs, `INotifyPropertyChanged` classes), `ICommand` implementations, value converters and behaviours. Never propose a `file` or `type` move of one of them out of Kelly-Revit, and never add members to them in a lower layer. Moving one into Kelly-Revit is fine. Only code inside them may leave (rule 6), and it leaves as new members of non-MVVM types (tools, services, extensions, constants).
3. **Approved exceptions**: the abstract framework types in Kelly-Revit-UI (the command contracts, `CommandBase`, `ViewModel`, `IView`, `IViewModel`) and the Revit-free generic `ProgressView` in Kelly-Windows. Concrete commands, views and view models never leave Kelly-Revit. Do not propose moving an exception without asking the user.
4. **Availability classes live in the command's assembly.** Revit resolves `PushButtonData.AvailabilityClassName` (the class's `Type.FullName`) in the command's assembly. Shared rules go into a Kelly-Revit-UI base class (`DocumentCommandAvailability`, `SelectionMadeCommandAvailability`) and a small sealed leaf class stays in the module (`IsSelectionMade : SelectionMadeCommandAvailability { }`). The Developer module's Availability Probe tests whether Revit accepts an assembly-qualified class from another assembly; until the user reports that it does, keep the leaf classes.
5. **Only code specific to a layer's concern belongs in it, and the namespace matches the folder** (`<RootNamespace>.<Folder>.<Subfolder>`; modules use `Kelly.Revit.<Module>.<Folder>`).
6. **Any code inside a view, view model or model may move down when it can and should** (the user's decision, 2026-11-04). This covers the code in a `*View.xaml.cs`, `*View.cs`, `*ViewModel.cs` or model, whatever its size, its form (a method, part of a method, a property's logic, a constant, a nested or extra type) and its dependencies.
   - **Can:** the target layer's references satisfy it (the placement table below).
   - **Should:** it is not presentation ("Views, view models and models", below).
   
   The view, view model or model stays as a thin MVVM shell that binds, holds UI state and calls the moved code.
7. **Every C# type gets its own file, named after the type** (the user, 2026-11-04). This covers classes, records, structs, interfaces, enums and delegates, in `src` and in tests. A type extracted or moved goes into a new file in the target folder, never beside another type. Reviewers and audits check it on every file a run adds or changes.

The skill's `scripts/check-rules.pl` (configured by `project.json` here) checks rules 1, 2, 3 and 5 mechanically; rule 2 there means the files, not the code inside them. Run it before and after.

## What "a more appropriate layer" means

The right layer is the **lowest layer whose concern matches the code and whose references can satisfy it**. Classify by the code's real dependencies (read it; don't go by the name):

| The code uses or encodes | Belongs in |
|---|---|
| Host statics (`App.*`, `App.ServiceProvider`, `App.UiControlledApplication`), `Kelly.Revit.Core.Properties.Settings`/`Resources`, Office interop, ExcelDataReader, one module's resources | Kelly-Revit: the module that uses it, or the host if only the host does |
| RevitAPIUI (`UIDocument`, `UIApplication`, `Selection`, `ISelectionFilter`, `TaskDialog`, `ExternalEvent`/`IExternalEventHandler`, `DockablePane`), AdWindows, Telerik or ribbon types, **and** is reusable framework shared by tools or modules | Kelly-Revit-UI |
| The same, but specific to one tool | that tool's module |
| Only RevitAPI.dll (`Autodesk.Revit.DB.*`, `ApplicationServices`, `Attributes`, `DB.Events`, `ExtensibleStorage`, `Creation`) | Kelly-Revit-Logic |
| No Revit, a Kelly business concept | Kelly-Domain |
| No Revit, generic and reusable, no Kelly meaning | Kelly-Windows |
| Pure data access | Kelly-Windows-Data |

Also look for code that sits **too low** or in the wrong sibling:

- a Kelly business concept inside Kelly-Windows belongs in Kelly-Domain; data access in Kelly-Windows belongs in Kelly-Windows-Data; non-data code in Kelly-Windows-Data belongs in Kelly-Windows;
- something only Revit-coupled code uses, and that encodes Revit behaviour, does not belong in Domain;
- ribbon, command or MVVM code in Kelly-Revit-Logic belongs in Kelly-Revit-UI;
- framework code repeated in several modules belongs once in Kelly-Revit-UI; Revit database logic in Kelly-Revit-UI belongs in Kelly-Revit-Logic.

An upward move is valid only if nothing left in the source layer, or below it, still uses the code.

**Duplication across layers or folders** counts as a move: helpers, extension methods, constants, enums, models, converters, colour tables, string/file/path/number helpers, collector or transaction code re-implemented in several commands, or a re-implementation of something a lower layer already has. Report one move per redundant copy, with the lowest appropriate layer owning the single implementation. Only report duplication you have read, not similar names.

**Mixed types**: split them. The Revit-free part moves down; an extension method over the Revit type stays in Logic and calls it.

### Views, view models and models

Read every view, view model and model line by line (rule 6).
- **A view** is any XAML window, page or user control with its code-behind. That includes `*View.xaml(.cs)`, `*View.cs` and windows not named `*View`, such as `OletCheckWindow.xaml.cs`.
- **A model** is any class a view or view model binds to, fills or builds from data: rows, items, settings, records and DTOs, whatever its name, for example `ApplicationAboutModel` in Trade.All. A model is an MVVM type and never moves out of Kelly-Revit (rule 2, 2026-11-06); only its rules do. Earlier runs (before 2026-11-06) moved `ModuleCreatorSettings` to Kelly-Domain and `LayoutPointExportCandidate` to Kelly-Revit-Logic; don't repeat that.

Code that **moves**, to the lowest layer whose concern fits, however short (a one-line rule counts; round 1 moved "a weld initialism starting with S is Shop" into `WeldLocationTools`):

| Code in a view, view model or model | Usually goes to |
|---|---|
| Kelly business rules, validation, naming and numbering (spool, module and line numbers), unit choices, quality flags | Kelly-Domain |
| Parsing, formatting and converting values (lengths, fractions, text, numbers), calculations, sorting, grouping and filtering of plain data, with no Kelly meaning | Kelly-Windows |
| File, CSV, JSON and settings reading and writing | Kelly-Windows-Data, or the format libraries through Kelly-Windows or Kelly-Domain |
| Revit database work: collectors, element and parameter reads and writes, transactions (`OperationService`), geometry | Kelly-Revit-Logic |
| UI behaviour more than one tool needs, as a static helper or extension method (not a converter, behaviour or control type: those stay in Kelly-Revit) | Kelly-Windows |
| The same, using RevitAPIUI, selection, Telerik or ribbon types | Kelly-Revit-UI |
| The same code in two or more views, view models, models or commands | one copy in the lowest layer that fits, as a member of a non-MVVM type; the others call it |
| Rules inside a model that are a Kelly concept | new members in Kelly-Domain if Revit-free, Kelly-Revit-Logic if they need RevitAPI only; the model type stays in Kelly-Revit |

Code that **stays**, because it is presentation:
- bindable properties, `INotifyPropertyChanged` plumbing, `ICommand` wiring, and `CanExecute` that only reads UI state;
- UI state (selection, visibility, enabled and busy flags), opening and closing windows and dialogs, and code-behind event handlers that only forward to the view model;
- the orchestration that calls the moved code in order, with its messages through `UserPrompt`;
- a row or item model that exists only to bind one tool's grid (display text, check boxes); rules inside it still move;
- RevitAPIUI, `ExternalEvent` or Telerik code that only one tool uses and no other tool repeats.

The moved code keeps its behaviour exactly: the same conditions, order, messages and defaults. It gets tests in its new layer, written test-first. The shell calls it, and a guard test checks that the old copy is gone (for example `TryParseDesiredElevation_LivesInConstructionServices_NotInTheViewModel`).

Constraints on every move:

- never create a dependency from a lower layer to a higher one;
- Windows.Data, Windows and Domain must also compile for net481 with C# 12; Logic and UI must compile for 2024, 2025 and 2026 (watch `#if REVIT20xx`);
- behaviour stays exactly the same (conditions, ordering, transactions, messages, logging, exception handling). Bugs found on the way are noted, not fixed.

## What makes a move unsafe or needs extra work

Put each in the move's `requiredChanges` and raise its risk:

- `internal` types or members that must become `public` (or need `InternalsVisibleTo`) when the consumer is in another assembly;
- assembly identity: `Assembly.GetExecutingAssembly()`, `typeof(X).Assembly`, `pack://application:,,,/Kelly.Revit;component/...` URIs, embedded resources and ribbon icons (`<RootNamespace>.Application.Graphics.RibbonIcons.<name>16.png`/`32.png`), `Settings.Default`, `Resources.*`, full class-name strings for `PushButtonData` and availability classes (these stay in the add-in assembly);
- static state and process-wide seams: `App.ServiceProvider` (inject instead), and the registrations `App.OnStartup` makes before anything runs (`UserPrompt.Register`, `DefinitionRegistry.Register`, `DataFiles.Register`, `DataFiles.RegisterStore`, `AddInServices.Register`) must still happen before first use;
- names persisted by type: JSON `$type`, saved settings, extensible-storage schema names and GUIDs. A namespace change breaks stored data;
- XAML `x:Class` and `xmlns:...="clr-namespace:..."` references;
- name clashes in the target or in the consumers' global usings and aliases;
- `#if REVIT20xx` blocks;
- a public type renamed or moved is a breaking change: `### Breaking` in the Changelog;
- tests that cover moved code move with it (and Logic tests run only inside Revit).

## Project details for the generic method

- Move record: `sourceRepo` and `targetRepo` are one of Kelly-Windows-Data, Kelly-Windows, Kelly-Domain, Kelly-Revit-Logic, Kelly-Revit-UI, Kelly-Revit; a `sourcePath` example is `modules/Trade.All/Commands/Spools/SpoolCreate/SpoolCreateTools.cs`; a target example is folder `src/Spools`, namespace `Kelly.Revit.Logic.Spools`. Consumers are grepped in all six repositories.
- Compile probe: the project files import BuildConfigs by absolute path, so a copied `src` builds; copy `Directory.Packages.props` and `NuGet.Config` too.
- Work packages: round 2a (2026-11-04) left source halves as `requiredChanges` notes for "the layer above", and 82 moves ended up with both copies and only the old one called. A public member removed from Kelly-Revit-Logic or Kelly-Revit-UI is listed with its callers above it, and the source package of each layer above repoints them.
