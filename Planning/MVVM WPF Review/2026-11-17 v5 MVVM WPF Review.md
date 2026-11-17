# Kelly Tools For Revit v5: MVVM/WPF review, 2026-11-17

**Scope.** Every WPF view, view model and window in Major Version 5:
- the add-in modules: 22 XAML views, 34 view model files and the commands that open them;
- the Kelly-Revit-UI MVVM framework: `Mvvm`, `MvvmDialog`, `Controls`, `Resources`;
- Kelly-Windows `Wpf` (`ProgressView`).

About 14,500 lines of XAML and view model code plus 2,050 lines of code-behind.

**Method.** Four read-only reviews ran in parallel (framework; Spools; Layout, Supports and Vicious; the Assigners pane with the Duct and Pipe checks), all with one checklist. The checklist covered:
- Revit API context;
- logic in code-behind;
- dialogs;
- `INotifyPropertyChanged`;
- commands;
- bindings;
- lifetime;
- DRY;
- XAML size;
- colours;
- the house rules.

The High findings were then checked by hand against the code. Nothing was built or run. Findings marked *unverified* have not been reproduced in Revit.

## Overall state

| Area | Health | Main reason |
|---|---|---|
| Assigners pane (shared VM, request dispatcher) | Good | Correct `ExternalEvent` use and per-project state; stale project key after Save As |
| Assigners pane B (panel) | Fair | A status tick appears before the action has run; many hard-coded colours |
| Duct QA Length / Duct QA Mirror | Poor | Revit API read from a modeless window; stale document; copied code |
| Olet Checker | Poor | Same as the duct checks, plus `TaskDialog` and a double load (KTR5-4660) |
| Spool Manager | Fair | Logic is well organised (`RunAsOneEdit`); 1,638-line XAML; grid-bound commands; chained commands |
| Spool Creator | Poor | Window closes on failure; three undo steps; two messages |
| Module Manager | Fair | Obsolete selection bindings (KTR5-4745); control-typed commands |
| Module Creator | Good | `RequestClose` on success, `ReportToUser`; prefix bound twice |
| Layout Point Export | Poor | Saves before exporting (KTR5-4638); first project location forced; 400-line code-behind |
| Layout Point Import | Fair | View model drives windows and controls |
| Suspended Support Manager | Fair | Filters in code-behind; two dialogs per error; timing code ships (KTR5-4863) |
| Vicious Rotate Move | Poor | Closing with X reopens the window; no view model |
| Vicious Hanger Place | Poor | No view model; X still places (KTR5-4801); `NameOld` binding (KTR5-4812) |
| Vicious Point To Pipe | Poor | The view runs the tool from its constructor; empty view model (KTR5-4713, KTR5-4714) |
| Vicious Level Assign / Racker | Fair | A click handler and a command on the same button; Telerik controls in the view model |
| About, Window Mockup | Good | Minor |
| Context value Add window | Fair | Closing with X still adds the value |

**Framework.** Telerik `ViewModelBase`, `ModelBase` and `DelegateCommand` throughout; no CommunityToolkit.Mvvm. There are three view model styles side by side:
- the Kelly `ViewModel` + `IViewModel` (the Trade.All dialogs);
- bare `ViewModelBase` (the Assigners pane, the context value window);
- `ModelBase` (the duct and olet checks: `public`, holding a `UIDocument`).

All property raises use `nameof`. No `async void`. One type per file and namespaces hold everywhere. No non-XML comments in C#.

## Findings

### 1. Revit API context and document lifetime (High)
- **The modeless check windows read Revit from WPF handlers.** In Duct QA Length, Duct QA Mirror and Olet Checker, Reload and every Scope change query the document after `Execute` has returned. Confirmed in `DuctLengthCheckCommand.cs:23` (`Show()`) and `DuctLengthCheckViewModel.cs:20,82,173`. [KTR5-4886](https://linear.app/jhkelly-ktr/issue/KTR5-4886)
- **The check windows keep their first document.** A static `_window` keeps the first `UIDocument`. After a switch, selection ids are applied to the wrong project. The `ExternalEvent` is never released. [KTR5-4887](https://linear.app/jhkelly-ktr/issue/KTR5-4887), twin of [KTR5-4643](https://linear.app/jhkelly-ktr/issue/KTR5-4643)
- **Assigners pane, Save As.** The project key is the path or title and is not refreshed on `DocumentSavedAs`, so later adds are silently not saved. [KTR5-4890](https://linear.app/jhkelly-ktr/issue/KTR5-4890)
- **Assigners pane, document switch.** Requests run against whichever document is active when the external event fires, not the document where the user clicked. [KTR5-4891](https://linear.app/jhkelly-ktr/issue/KTR5-4891)

The Assigners pane is the model to copy: `AssignerRequestDispatcher` (a locked queue and `ExternalEvent`), `ViewActivated`/`DocumentClosing` handling, only a key held rather than a `Document`, and `UserPrompt` for its dialogs.

### 2. Windows that act wrongly on close or on click (High/Medium)
- **Rotate Move.** Closing the window with X opens it again: the `do…while (!IsCloseRequested)` loop, and `DialogSmall` has a title bar. Confirmed. [KTR5-4893](https://linear.app/jhkelly-ktr/issue/KTR5-4893)
- **Spool Creator.** A code-behind `Click` closes the window on the same click as `CommandCreate`, success or not. Confirmed. [KTR5-4892](https://linear.app/jhkelly-ktr/issue/KTR5-4892); three undo steps is [KTR5-4664](https://linear.app/jhkelly-ktr/issue/KTR5-4664)
- **Context value Add window.** It reads `ContextValue` after `ShowDialog` and never checks `DialogResult`, so closing with X still adds the value. Confirmed. [KTR5-4894](https://linear.app/jhkelly-ktr/issue/KTR5-4894)
- **Assigners pane B.** The status tick is set by a code-behind `Click` before the queued request runs. Confirmed. [KTR5-4889](https://linear.app/jhkelly-ktr/issue/KTR5-4889)
- **Layout Point Export and Import.** `ProjectLocationComboBox.SelectedIndex = 0` in `ContentRendered` replaces the active location the view model chose. *Unverified in Revit.* [KTR5-4895](https://linear.app/jhkelly-ktr/issue/KTR5-4895)
- **Several commands on one click.** Spool Manager sheet Create (item numbers, then sheets), Layout Point Export (save, export, reload), and Level Assign and Racker (close plus command). Added to [KTR5-4322](https://linear.app/jhkelly-ktr/issue/KTR5-4322).
- **Two messages for one problem.** Spool Creator with nothing spoolable [KTR5-4898](https://linear.app/jhkelly-ktr/issue/KTR5-4898); Suspended Support Manager shows a `MessageBox` and then `ReportToUser` ([KTR5-4897](https://linear.app/jhkelly-ktr/issue/KTR5-4897), [KTR5-4782](https://linear.app/jhkelly-ktr/issue/KTR5-4782)).

### 3. Window ownership and styles (Medium)
- **No owner, and Topmost.** `MvvmDialog.Show` sets no `Owner`, and every window and dialog style sets `Topmost = True`, so dialogs float above every application. Only `ProgressView` and the Assigners context picker set an owner, each with its own copy of the code. [KTRUI-42](https://linear.app/jhkelly-ktr/issue/KTRUI-42), related [KTR5-4650](https://linear.app/jhkelly-ktr/issue/KTR5-4650)
- **Resource dictionaries.** `Styles.xaml` (about 1,000 lines) is merged into each of about 18 windows. There is a dead implicit yellow `Window` style. `WindowLarge` and `WindowMedium` are duplicates. `#016043` is hard-coded in 8 places. `Menu` and `DialogMenu` are near copies. [KTRUI-43](https://linear.app/jhkelly-ktr/issue/KTRUI-43); brand brushes in [KTR5-4632](https://linear.app/jhkelly-ktr/issue/KTR5-4632) and [KTR5-4633](https://linear.app/jhkelly-ktr/issue/KTR5-4633).
- **Other hard-coded colours.** `AssignerBPanel.xaml` (`#016043`, `#DC3545`, greys), `SpoolCreateView.xaml` (`#FF007ACC`), the Layout Export cells (`AliceBlue`, `#FFF4FFF0`), and status brushes built in the check view models.

### 4. Testability: view models bound to the view (Medium)
- **Controls as command parameters.** About 30 command handlers take a `RadGridView`, `RadComboBox`, `RadMaskedTextInput` or `Window` through `CommandParameter = "{Binding ElementName=...}"`. They read selection from the control, rebind the grid, and show, hide or close windows. No such view model can be unit tested. [KTR5-4896](https://linear.app/jhkelly-ktr/issue/KTR5-4896) (blocks most of [KTR5-4708](https://linear.app/jhkelly-ktr/issue/KTR5-4708)).
- **The base `ViewModel`.** It needs a concrete `CommandBase` with a live `UiDocument`, and `SyncGridSelectionToRevit` walks the visual tree and allocates a `RadGridView`. [KTRUI-25](https://linear.app/jhkelly-ktr/issue/KTRUI-25), [KTR5-4787](https://linear.app/jhkelly-ktr/issue/KTR5-4787)
- **The lifecycle interface.** `IViewModel` is declared but hollow. `OnViewModelPropertyChanged` (Scope changes, then `CreateObjects`) is copied into about 10 view models, and `ValidateRequirements` is often `ThrowIfFewerThan(0)` or empty. The base class should own the Scope wiring (KTRUI-25).
- **Dialogs from view models.** About 15 `TaskDialog` calls in the Spools view models, plus `new TaskDialog`/`SaveFileDialog` in Layout Export, bypass `UserPrompt`, and some come from constructors. Tracked in [KTR5-4751](https://linear.app/jhkelly-ktr/issue/KTR5-4751) and [KTR5-4781](https://linear.app/jhkelly-ktr/issue/KTR5-4781)–[KTR5-4786](https://linear.app/jhkelly-ktr/issue/KTR5-4786).

### 5. Logic in code-behind (Medium/Low)
| View | Code-behind | What it holds | Issue |
|---|---|---|---|
| Layout Point Export | 400 lines | Selection mutated inside `SelectionChanged`, button enabling, duplicate isolation, 8 near-identical check-box handlers | [KTR5-4896](https://linear.app/jhkelly-ktr/issue/KTR5-4896) |
| Point To Pipe | 241 | The whole form; the constructor runs `ShowDialog` and the tool | [KTR5-4713](https://linear.app/jhkelly-ktr/issue/KTR5-4713), [KTR5-4714](https://linear.app/jhkelly-ktr/issue/KTR5-4714) |
| Assigners pane B | 180 | Drag/drop (fine as view code), row select, status reporting | [KTR5-4889](https://linear.app/jhkelly-ktr/issue/KTR5-4889) |
| Layout Point Import | 158 | Filters, `SelectedIndex` resets | [KTR5-4895](https://linear.app/jhkelly-ktr/issue/KTR5-4895) |
| Rotate Move | 130 | The whole tool; no view model | [KTR5-4716](https://linear.app/jhkelly-ktr/issue/KTR5-4716), [KTR5-4893](https://linear.app/jhkelly-ktr/issue/KTR5-4893) |
| Spool Manager | 129 | Five handlers that set `IsEnabled = true`; group-box enable and visibility | [KTR5-4896](https://linear.app/jhkelly-ktr/issue/KTR5-4896) |
| Hanger Place options | 102 | Parsing in `LostFocus`; no view model | [KTR5-4717](https://linear.app/jhkelly-ktr/issue/KTR5-4717) |
| Suspended Support Manager | 98 | The grid filter | [KTR5-4897](https://linear.app/jhkelly-ktr/issue/KTR5-4897) |

### 6. Duplication (Low)
- **The check tools.** Duct QA Length, Duct QA Mirror and Olet Checker copy the reload, scope, selection event, counts and status brushes. [KTR5-4888](https://linear.app/jhkelly-ktr/issue/KTR5-4888)
- **Layout Point Export and Import.** They share the project-location combo code ([KTR5-4681](https://linear.app/jhkelly-ktr/issue/KTR5-4681)), the isolate-duplicates code, and the reset filter and column loops (also in Suspended Support Manager).
- **Module Creator and Spool Creator.** Their settings read/write and their "Selection Error" text are copied (the text in Module Creator wrongly says "Assembly").
- **Spool Manager.** Its `Set*FromSpoolItem` / `Set*` pairs repeat parse, insert, find, edit and rebind. The Detailing Package list is changed before the edit, so it stays changed if the edit fails.
- **Large XAML.** `SpoolManagerView.xaml` has three grids of about 160–330 lines, a 430-line sidebar, 14 near-identical inline `GridViewCell` styles, and five identical weld button blocks. `LayoutPointCsvExportView.xaml` repeats a `CellStyle` per column. Extract UserControls and shared keyed cell styles when these views are next changed.

### 7. Smaller points
- **Dead obsolete members.** `SelectionShowInView` and `SelectionZoomTo` are `[Obsolete]` but still bound by Module Manager. That is the likely cause of [KTR5-4745](https://linear.app/jhkelly-ktr/issue/KTR5-4745) (comment added).
- **Diagnostics on every open.** Suspended Support Manager runs the [KTR5-4863](https://linear.app/jhkelly-ktr/issue/KTR5-4863) timing raycasts and logs on every open (comment added).
- **`CanExecute`.** It is wired only in the Assigners pane and Duct QA Length. The about 25 Trade.All commands are always enabled and validate inside the handler.
- **`ThrowIfNotReady`.** It throws `NullReferenceException`/`TypeInitializationException` for a window that is not ready; `InvalidOperationException` would fit better.
- **About window getters.** `ApplicationAboutModel` reads Revit live on every binding read.
- **History in XML docs.** Some XML docs carry history and issue keys (`ModuleManageViewModel.cs:20`, `SpoolManagerViewModel.cs:420`, `AssignerBPanel.xaml.cs`), against the rule that history belongs in commits and the Changelog. `IViewModel.cs` has a "TODO - 2026.07.31" in its docs.

## Suggested order
1. [KTR5-4893](https://linear.app/jhkelly-ktr/issue/KTR5-4893), [KTR5-4892](https://linear.app/jhkelly-ktr/issue/KTR5-4892), [KTR5-4894](https://linear.app/jhkelly-ktr/issue/KTR5-4894): one-point fixes users can hit today.
2. [KTR5-4895](https://linear.app/jhkelly-ktr/issue/KTR5-4895): reproduce first. If it holds, exported coordinates are wrong in multi-site projects.
3. [KTR5-4886](https://linear.app/jhkelly-ktr/issue/KTR5-4886), then [KTR5-4887](https://linear.app/jhkelly-ktr/issue/KTR5-4887) and [KTR5-4888](https://linear.app/jhkelly-ktr/issue/KTR5-4888) together: one shared check-window base fixes all three tools at once.
4. [KTR5-4889](https://linear.app/jhkelly-ktr/issue/KTR5-4889), [KTR5-4890](https://linear.app/jhkelly-ktr/issue/KTR5-4890), [KTR5-4891](https://linear.app/jhkelly-ktr/issue/KTR5-4891): the Assigners pane, while that work ([KTR5-4869](https://linear.app/jhkelly-ktr/issue/KTR5-4869)) is active.
5. [KTRUI-42](https://linear.app/jhkelly-ktr/issue/KTRUI-42) and [KTRUI-43](https://linear.app/jhkelly-ktr/issue/KTRUI-43) in one Kelly-Revit-UI package with KTRUI-25, then repin.
6. [KTR5-4896](https://linear.app/jhkelly-ktr/issue/KTR5-4896), one tool at a time, before writing that tool's view model tests ([KTR5-4708](https://linear.app/jhkelly-ktr/issue/KTR5-4708)).

## Issues from this review
- **New in KTR5:** [KTR5-4886](https://linear.app/jhkelly-ktr/issue/KTR5-4886) through [KTR5-4898](https://linear.app/jhkelly-ktr/issue/KTR5-4898).
- **New in KTRUI:** [KTRUI-42](https://linear.app/jhkelly-ktr/issue/KTRUI-42) and [KTRUI-43](https://linear.app/jhkelly-ktr/issue/KTRUI-43).
- **Comments added to:** [KTR5-4322](https://linear.app/jhkelly-ktr/issue/KTR5-4322), [KTR5-4745](https://linear.app/jhkelly-ktr/issue/KTR5-4745) and [KTR5-4863](https://linear.app/jhkelly-ktr/issue/KTR5-4863).

Findings already covered by open issues were not filed again: [KTR5-4638](https://linear.app/jhkelly-ktr/issue/KTR5-4638), 4643, 4650, 4660, 4664, 4713–4718, 4751, 4781–4786, 4801, 4812, 4815, and [KTRUI-25](https://linear.app/jhkelly-ktr/issue/KTRUI-25).
