# Placement rules

The rules every finder, reviewer and implementer of a layer analysis works from. Read all of it before classifying a file.

## Contents

- The layers
- The user's rules
- What "a more appropriate layer" means (and views, view models and models)
- What makes a move unsafe or needs extra work
- The move record
- Finding moves
- Reviewing moves
- Compile probe
- Work packages and DECISIONS.md

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
3. **Approved exceptions**: the abstract framework types in Kelly-Revit-UI (the command contracts, `CommandBase`, `ViewModel`, `IView`, `IViewModel`) and the Revit-free generic `ProgressView` in Kelly-Windows. Concrete commands, views and view models never leave Kelly-Revit. Do not propose moving an exception without asking the user.
4. **Availability classes live in the command's assembly.** Revit resolves `PushButtonData.AvailabilityClassName` (the class's `Type.FullName`) in the command's assembly. Shared rules go into a Kelly-Revit-UI base class (`DocumentCommandAvailability`, `SelectionMadeCommandAvailability`) and a small sealed leaf class stays in the module (`IsSelectionMade : SelectionMadeCommandAvailability { }`). The Developer module's Availability Probe tests whether Revit accepts an assembly-qualified class from another assembly; until the user reports that it does, keep the leaf classes.
5. **Only code specific to a layer's concern belongs in it, and the namespace matches the folder** (`<RootNamespace>.<Folder>.<Subfolder>`; modules use `Kelly.Revit.<Module>.<Folder>`).
6. **Any code inside a view, view model or model may move down when it can and should** (the user's decision, 2026-11-04). This covers the code in a `*View.xaml.cs`, `*View.cs`, `*ViewModel.cs` or model, whatever its size, its form (a method, part of a method, a property's logic, a constant, a nested or extra type) and its dependencies.
   - **Can:** the target layer's references satisfy it (the placement table below).
   - **Should:** it is not presentation ("Views, view models and models", below).
   
   The view, view model or model stays as a thin MVVM shell that binds, holds UI state and calls the moved code.

`scripts/check-rules.pl` checks rules 1, 2, 3 and 5 mechanically; rule 2 there means the files, not the code inside them. Run it before and after.

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
- **A model** is any class a view or view model binds to, fills or builds from data: rows, items, settings, records and DTOs, whatever its name. Examples are `ApplicationAboutModel` in Trade.All, and `ModuleCreatorSettings` and `LayoutPointExportCandidate`, which earlier runs moved to Kelly-Domain and Kelly-Revit-Logic. A model is not a protected file, so it can also move whole.

Code that **moves**, to the lowest layer whose concern fits, however short (a one-line rule counts; round 1 moved "a weld initialism starting with S is Shop" into `WeldLocationTools`):

| Code in a view, view model or model | Usually goes to |
|---|---|
| Kelly business rules, validation, naming and numbering (spool, module and line numbers), unit choices, quality flags | Kelly-Domain |
| Parsing, formatting and converting values (lengths, fractions, text, numbers), calculations, sorting, grouping and filtering of plain data, with no Kelly meaning | Kelly-Windows |
| File, CSV, JSON and settings reading and writing | Kelly-Windows-Data, or the format libraries through Kelly-Windows or Kelly-Domain |
| Revit database work: collectors, element and parameter reads and writes, transactions (`OperationService`), geometry | Kelly-Revit-Logic |
| UI behaviour more than one tool needs: generic WPF converters, behaviours and helpers | Kelly-Windows |
| UI behaviour more than one tool needs that uses RevitAPIUI, selection, Telerik or ribbon types | Kelly-Revit-UI |
| The same code in two or more views, view models, models or commands | one copy in the lowest layer that fits; the others call it |
| A model whose data or rules are a Kelly concept | the model moves whole, or is split: Kelly-Domain if Revit-free, Kelly-Revit-Logic if it needs RevitAPI only |

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

## The move record

One record per proposed move. `scripts/layer-analysis.workflow.js` enforces this shape.

| Field | Value |
|---|---|
| `sourceRepo`, `targetRepo` | one of Kelly-Windows-Data, Kelly-Windows, Kelly-Domain, Kelly-Revit-Logic, Kelly-Revit-UI, Kelly-Revit |
| `sourcePath` | repo-relative, forward slashes: `modules/Trade.All/Commands/Spools/SpoolCreate/SpoolCreateTools.cs` |
| `granularity` | `file` (the whole file moves), `type` (one type declared in a file moves out), `member` (methods are extracted) |
| `symbol` | the type (`file`, `type`) or `Type.Member` |
| `targetFolder`, `targetNamespace` | repo-relative folder (`src/Spools`) and the namespace that matches it (`Kelly.Revit.Logic.Spools`) |
| `revitApi` | `none`, `db` (RevitAPI only) or `ui` (RevitAPIUI, AdWindows, Telerik) |
| `rationale` | why this layer, from the dependencies |
| `prerequisites` | other moves or changes that must happen first |
| `requiredChanges` | everything from the unsafe list above that applies, and the consumers to repoint |
| `consumers` | `repo:path` of every file that uses the symbol (grep all six repos, `src`, `modules` and tests; skip `bin`/`obj`) |
| `risk`, `confidence` | `low`/`medium`/`high` |

A move's key is `sourceRepo:sourcePath#symbol`.

## Finding moves

For each scope (`references/scopes.json`):

1. List every `.cs` and `.xaml` file in the scope (exclude `bin`, `obj`). Read each one; count them as `filesReviewed`.
2. In Kelly-Revit scopes, decide first whether a file is protected (rule 2). A protected file stays, but read it all the way through: in a view, view model or model, every piece of code that is not presentation is a candidate ("Views, view models and models").
3. Decide KEEP or MOVE for each file, type, member or piece of code from its real dependencies.
4. For each move, grep all six repos for consumers and for what it depends on that would also have to move (prerequisites).
5. Give every file you keep a short reason ("IExternalCommand", "ViewModel", "uses UIDocument", "ribbon", "already in the right layer").

Be precise: propose a move only when you can name the target folder and namespace and you have checked the dependencies. Leave out pure presentation and calls that only forward. A short rule, check or conversion still counts.

## Reviewing moves

Each reviewer tries to **refute** the moves it is given. Read the source and grep yourself; do not trust the proposal. Check:

1. the user's rules (Revit-free lower layers; protected Kelly-Revit files stay, though the code inside a view, view model or model may move; availability classes stay with their commands);
2. concern fit per layer (generic, Kelly-specific, Revit database, Revit UI framework, one tool). Is there an even lower valid layer, or is the proposed one too low?
3. every dependency exists in the target (nothing from a higher layer, no RevitAPIUI in Logic, no Revit at all in Domain, Windows or Data);
4. runtime identity risks (reflection, resources, pack URIs, settings, host statics, class-name strings, persisted type names, `#if REVIT20xx`);
5. for upward moves, nothing left in the source layer or below still uses the code;
6. for type and member extractions, the gain is real and not churn. Code taken out of a view, view model or model that is not presentation is a gain whatever its size: it becomes testable without the window. Reject it only as presentation, or when the target cannot satisfy it;
7. name clashes in the target or in consumers' global usings.

Verdicts: `accept`, `modify` (right idea; correct the target, folder or namespace, or add required changes) or `reject`. Reject when it is unclear the move is safe and an improvement.

## Compile probe

Whole-file moves are proven with the compiler before they are planned, in a scratch copy, never in the repos:

1. Copy the target repo's `src` into `<scratch>/probes/<repo>/src` and delete its `bin` and `obj`. The project files import BuildConfigs by absolute path, so the copy builds.
2. Copy each candidate file unchanged into `src/__probe__/<sourceRepo>/<sourcePath>`, plus the files that are themselves moving to a layer at or below this one from above it (they will be available after the move).
3. Add `src/__probe__/ProbeUsings.cs` with the global usings the files need that exist in the target or below. Never add a Revit namespace to a Revit-free target.
4. Build one configuration with `-p:GeneratePackageOnBuild=false` and the project's `-p:SolutionName`. Attribute each error to a file; remove a file that needs something the target cannot have and record why (a cascade when it only needed another removed file). Repeat until 0 errors, then build the other configurations (Net481 or 2024 as well).
5. For upward moves, also copy the source repo's `src`, delete the moving files there, and build it, recording each break.

Type and member extractions are not probed; they need code edits first.

## Work packages and DECISIONS.md

After the user confirms the plan, write the implementation inputs into `<scratch>/packages/`:

- `DECISIONS.md`: the user's decisions on the plan, the moves dropped and deferred (with why), the behaviour rule (preserve behaviour exactly; record bugs, don't fix them), the probe findings, and these hard rules.
- `P<n><letter>-<layer>-<topic>.md`, one per work package: group accepted moves by **target** layer (bottom-up), then by folder or concern, about 25 moves at most. Number the moves once across all packages (`#1` … `#N`) and keep those numbers in the report. Each move lists its record, the review notes and the probe result.
- A move whose source is above its target (the usual case) is implemented in the target layer's step, together with the consumer edits in the layers above, which are written blind and compiled when their layer's turn comes.
