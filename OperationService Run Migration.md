# OperationService.Run migration

Working notes, 2026-10-20. `OperationService.Run` / `Run<T>` were added in Kelly-Revit-Logic (not yet in a package). This lists every `new OperationService(` in `Kelly-Revit-Logic-v5\src` and `Kelly-Revit-v5\modules` (none in `Kelly-Revit-v5\src` or `Kelly-Revit-UI\src`), sorted by how safely each can move to `Run`. Line = the line of `Start()` at the time of writing.

## Categories

- **A, straight.** `Start; if (IsStarted) { try { work; Stop } catch { RollBack; report } }`, the try/catch/finally-IsStarted variant, or plain Start → work → Stop. Converts mechanically. If the catch swallows and reports today, wrap `Run` in a try/catch that reports.
- **B, the catch does not roll back.** It commits partial work (try/finally Stop, a catch that swallows, a per-element catch that continues). `Run` would roll back instead. **Decide per site** whether the partial commit is intended.
- **C, code after Stop inside the block**, several Start/Stop on one instance, or RollBack plus an early return. Restructure first.
- **D, unusual.** Groups with nested transactions, Stop/RollBack in another method, commits in the middle of the operation. Leave them on the old pattern.

## Counts

| Repo | A | B | C | D | Total |
|---|---|---|---|---|---|
| Kelly-Revit-Logic-v5\src | 38 | 2 | 2 | 3 | 45 |
| Kelly-Revit-v5\modules | 20 | 13 | 2 | 1 | 36 |
| **Total** | **58** | **15** | **4** | **4** | **81** |

## Found while sorting

- **Bug:** `Kelly-Revit-v5\modules\AllTrade\Commands\Spools\ModuleManage\ModuleManageViewModel.cs` sets `committed = operationService.IsStarted;` right after `Stop()`. `Stop()` always leaves `IsStarted` false, so `committed` is always false and the grid models never get the new BOM type. **Fixed** in Kelly-Revit `2a3db282` (reads the transaction status through `IsCommitted`).
- `SpoolManagerViewModel` has 11 try/finally-Stop operations with no catch. A throw commits whatever was done so far.
- `DocumentExtensions` purges returned `GetTransaction().GetStatus()`, which threw `NullReferenceException` when the operation could not start. **Fixed** in Kelly-Revit-Logic `f56d711`.
- `TrapezeVerticalMemberTools` (46, 177) calls RollBack in an `else` branch where the operation never started, so it throws.

## Sites

| File | Line | Method | Cat | Note |
|---|---|---|---|---|
| Kelly-Revit-Logic-v5\src\Arrangement\AnnotationArranger.cs | 55 | Arrange | D | Inside a raw TransactionGroup (Start/RollBack/Start/Assimilate); Stop only if count>1, otherwise disposal rolls back |
| Kelly-Revit-Logic-v5\src\Arrangement\AnnotationArranger.cs | 257 | PrepareAnnotationElements | A | No try; sets a failure preprocessor via GetTransaction() inside the work; runs within the caller's group |
| Kelly-Revit-Logic-v5\src\Connectors\ConnectorTools.cs | 53 | Disconnect… | A | **Converted (70728bc).** Early-return-if-not-started style; returns count/null |
| Kelly-Revit-Logic-v5\src\Documents\DocumentExtensions.cs | 393 | Create3DViewTransaction | A | **Converted (f56d711).** try/catch/finally with IsStarted check; catch sets view=null and reports (swallows) |
| Kelly-Revit-Logic-v5\src\Documents\DocumentExtensions.cs | 463 | DeletePlacedFamiliesTransaction | A | **Converted (f56d711).** Reads status and shows a prompt after Stop (outside the if) |
| Kelly-Revit-Logic-v5\src\Documents\DocumentExtensions.cs | 508 | DeleteUnusedEditableFamiliesTransaction | A | **Converted (f56d711).** Returns GetTransaction().GetStatus(); NRE if Transaction is null |
| Kelly-Revit-Logic-v5\src\Documents\DocumentExtensions.cs | 602 | DeleteUnusedFilterElementsTransaction | A | **Converted (f56d711).** Returns status |
| Kelly-Revit-Logic-v5\src\Documents\DocumentExtensions.cs | 640 | DeleteUnusedSharedParameterElements | A | **Converted (f56d711).** Returns status (same NRE risk) |
| Kelly-Revit-Logic-v5\src\Documents\DocumentExtensions.cs | 1048 | GetOrCreateWorkset | C | **Converted (f56d711).** SynQuishOnDemand (sync with central) runs inside the if after Stop |
| Kelly-Revit-Logic-v5\src\Documents\DocumentExtensions.cs | 1428 | SetActiveProjectLocation | A | **Converted (f56d711).** |
| Kelly-Revit-Logic-v5\src\Documents\DocumentExtensionsJhk.cs | 30 | DeleteKellySharedParameterElementsTransaction | A | **Converted (867a515).** Returns status |
| Kelly-Revit-Logic-v5\src\Documents\DocumentExtensionsJhk.cs | 165 | SetActiveProject | A | **Converted (867a515).** Result captured in an outer local |
| Kelly-Revit-Logic-v5\src\Documents\DocumentExtensionsJhk.cs | 200 | SetIdTransaction | A | **Converted (867a515).** |
| Kelly-Revit-Logic-v5\src\Documents\DocumentSchemaExtensions.cs | 50 | (delete schemas by vendor) | B | Per-schema catch in the loop collects failures and continues; Stop after the loop |
| Kelly-Revit-Logic-v5\src\Elements\ElementExtensions.cs | 752 | SetCorrectLevelWithOperation | A | **Converted (4c3e82b).** |
| Kelly-Revit-Logic-v5\src\Elements\ElementExtensions.cs | 818 | SetOffsetBaseWithOperation | A | **Converted (4c3e82b).** |
| Kelly-Revit-Logic-v5\src\Elements\ElementExtensionsJhk.cs | 162 | ResetValuesInOneTransaction | A | **Converted (4c3e82b).** Returns true/false, which matches Run exactly |
| Kelly-Revit-Logic-v5\src\Elements\ElementExtensionsJhk.cs | 233 | ResetValuesTransaction | A | **Converted (4c3e82b).** One instance per loop iteration |
| Kelly-Revit-Logic-v5\src\Elements\GroupTools.cs | 32 | (ungroup) | A | Progress bar created inside; ProcessComplete after Stop |
| Kelly-Revit-Logic-v5\src\Elements\PenetrationTagTools.cs | 44 | ApplyTags | A | try/catch/finally variant; HandleIt swallows |
| Kelly-Revit-Logic-v5\src\Elements\WorksetExtensions.cs | 15 | SetVisibilityWithOperation | A | |
| Kelly-Revit-Logic-v5\src\Fabrication\BillOfMaterialTypeAssigner.cs | 58 | UpdateElements | A | Progress ProcessComplete after Stop |
| Kelly-Revit-Logic-v5\src\Fabrication\WeldLocationService.cs | 50 | SetEndPreparation | A | Progress after Stop |
| Kelly-Revit-Logic-v5\src\Fabrication\WeldLocationService.cs | 137 | SetWeldLocation | A | Progress after Stop |
| Kelly-Revit-Logic-v5\src\Families\FamilySymbolExtensions.cs | 86 | NewFamilyInstances2 | A | Returns new ids, or an empty list if not started |
| Kelly-Revit-Logic-v5\src\LayoutPoints\LayoutPointTools.cs | 85 | ImportTx | C | RollBack plus `return Cancelled` mid-loop; failure preprocessor set before Stop |
| Kelly-Revit-Logic-v5\src\LayoutPoints\LayoutPointTools.cs | 404 | (layout point update) | A | Returns Succeeded/Failed |
| Kelly-Revit-Logic-v5\src\Mep\ValveClearanceSphereTools.cs | 51 | (insert spheres) | A | |
| Kelly-Revit-Logic-v5\src\Projects\ProjectInformationWrapper.cs | 245 | Set | A | |
| Kelly-Revit-Logic-v5\src\Spools\ItemNumberTools.cs | 68 | (item numbers) | A | |
| Kelly-Revit-Logic-v5\src\Spools\SpoolTools.cs | 55 | (remove invalid product range) | A | Catch rolls back, then rethrows or calls onRolledBack and returns null; needs try/catch around Run |
| Kelly-Revit-Logic-v5\src\Spools\SpoolTools.cs | 401 | ChangeSpoolItemsTransaction | A | Returns true/false |
| Kelly-Revit-Logic-v5\src\Supports\HangerPlacementService.cs | 45 | (place hanger) | A | do/while with break (loop only) |
| Kelly-Revit-Logic-v5\src\Supports\TrapezeVerticalMemberTools.cs | 46 | (extend rods to structure) | D | Group with nested Transaction start/commit; RollBack in else (throws) |
| Kelly-Revit-Logic-v5\src\Supports\TrapezeVerticalMemberTools.cs | 177 | Reset | D | Group with nested Transactions; RollBack in else, then Stop outside the if (throws) |
| Kelly-Revit-Logic-v5\src\Updaters\ElementServiceExtensions.cs | 30 | ProcessElementsTransaction | A | Returns true/false |
| Kelly-Revit-Logic-v5\src\Updaters\ElementServices\ModuleNumberElementService.cs | 76 | (set value tx) | A | Returns true/false |
| Kelly-Revit-Logic-v5\src\Updaters\ManualUpdaterRunner.cs | 70 | (run updaters) | A | Per-configuration op in a loop; an outer catch swallows |
| Kelly-Revit-Logic-v5\src\Views\ScheduleExportService.cs | 63 | (export schedules CSV) | B | Per-schedule catch (file export only) continues; effectively A |
| Kelly-Revit-Logic-v5\src\Views\StratusViewTools.cs | 48 | (create Stratus views) | A | Progress after Stop |
| Kelly-Revit-Logic-v5\src\Views\ViewExtensions.cs | 29 | (apply non-BOM shop filters) | A | Stop("Added 3 View Filters") uses notes |
| Kelly-Revit-Logic-v5\src\Views\ViewExtensions.cs | 105 | Export (DWG) | A | |
| Kelly-Revit-Logic-v5\src\Views\ViewExtensions.cs | 327 | (remove all filters) | A | |
| Kelly-Revit-Logic-v5\src\Views\ViewExtensions.cs | 558 | SetViewTemplateOperation | A | |
| Kelly-Revit-Logic-v5\src\Views\VisibilityCommon.cs | 66 | ApplyOrCreateViewFilterTransaction (Obsolete) | A | Outer catch has no explicit RollBack (relies on Dispose) |
| Kelly-Revit-v5\modules\AllTrade\Commands\Acquired\Vicious\Rotate\ViciousInstanceRotateMoveCommand.cs | 118 | RotateSelected | A | Failure preprocessor set before Start; modal dialog loop as the work |
| Kelly-Revit-v5\modules\AllTrade\Commands\Acquired\Vicious\Rotate\ViciousInstanceRotateMoveCommand.cs | 170 | RotateViewport | D | Early returns without Stop; GetCropBoxElement commits/restarts the transaction mid-op |
| Kelly-Revit-v5\modules\AllTrade\Commands\Assigners\DetailingPackageContext\LineColorFilterAssign\DetailingPackageLineColorViewFilterCommand.cs | 15 | Execute | A | |
| Kelly-Revit-v5\modules\AllTrade\Commands\Assigners\LineNumberContext\LineColorFilterAssign\LineNumberLineColorViewFilterCommand.cs | 15 | Execute | A | |
| Kelly-Revit-v5\modules\AllTrade\Commands\Assigners\ModuleNumberContext\LineColorFilterAssign\ModuleNumberLineColorViewFilterCommand.cs | 17 | Execute | A | |
| Kelly-Revit-v5\modules\AllTrade\Commands\Assigners\ServiceContext\FillColorFilterAssign\ServiceFillColorViewFilterCommand.cs | 36 | Execute | A | |
| Kelly-Revit-v5\modules\AllTrade\Commands\Assigners\ServiceContext\LineColorFilterAssign\ServiceLineColorViewFilterCommand.cs | 38 | Execute | A | No Increment |
| Kelly-Revit-v5\modules\AllTrade\Commands\Assigners\SpoolNumberContext\LineColorFilterAssign\SpoolNumberLineColorViewFilterCommand.cs | 26 | Execute | A | |
| Kelly-Revit-v5\modules\AllTrade\Commands\Assigners\SystemContext\FillColorFilterAssign\SystemFillColorViewFilterCommand.cs | 31 | Execute | A | |
| Kelly-Revit-v5\modules\AllTrade\Commands\Assigners\SystemContext\LineColorFilterAssign\SystemLineColorViewFilterCommand.cs | 42 | Execute | A | |
| Kelly-Revit-v5\modules\AllTrade\Commands\Layout\LayoutPointExport\LayoutPointToCommaSeparatedValueFileExportViewModel.cs | 238 | (export to CSV) | C | After Stop inside the if: ViewPlan.Export (its own OperationService), then Process.Start |
| Kelly-Revit-v5\modules\AllTrade\Commands\Layout\LayoutPointExport\LayoutPointToCommaSeparatedValueFileExportViewModel.cs | 292 | Reset | A | |
| Kelly-Revit-v5\modules\AllTrade\Commands\Layout\LayoutPointExport\LayoutPointToCommaSeparatedValueFileExportViewModel.cs | 325 | Save | A | Rebind after the if |
| Kelly-Revit-v5\modules\AllTrade\Commands\Layout\LayoutPointExport\LayoutPointToCommaSeparatedValueFileExportViewModel.cs | 564 | UpdateCoordinates | A | Rebind only on success (use Run's bool) |
| Kelly-Revit-v5\modules\AllTrade\Commands\ManyConnect\ManyConnectCommand.cs | 104 | Transaction | B | Catch swallows (HandleIt); finally Stop commits partial work |
| Kelly-Revit-v5\modules\AllTrade\Commands\Spools\ModuleManage\ModuleManageViewModel.cs | 211 | (set BOM type Module) | A | Has the `committed` bug above |
| Kelly-Revit-v5\modules\AllTrade\Commands\Spools\ModuleManage\ModuleManageViewModel.cs | 292 | UpdateComponentItemNumbers | A | Catch rolls back and reports; rebind after |
| Kelly-Revit-v5\modules\AllTrade\Commands\Spools\SpoolCreate\SpoolCreateViewModel.cs | 320 | CreateSpool | C | RollBack plus early return when AssemblyInstance is null |
| Kelly-Revit-v5\modules\AllTrade\Commands\Spools\SpoolCreate\SpoolCreateViewModel.cs | 529 | UpdateSpoolData | A | |
| Kelly-Revit-v5\modules\AllTrade\Commands\Spools\SpoolCreate\SpoolCreateViewModel.cs | 555 | UpdateSpoolName | A | |
| Kelly-Revit-v5\modules\AllTrade\Commands\Spools\SpoolManager\SpoolManagerViewModel.cs | 318 | (create spool sheets) | B | try/finally Stop, no catch: commits partial work on throw |
| Kelly-Revit-v5\modules\AllTrade\Commands\Spools\SpoolManager\SpoolManagerViewModel.cs | 457 | SetDetailingPackage | B | try/finally Stop |
| Kelly-Revit-v5\modules\AllTrade\Commands\Spools\SpoolManager\SpoolManagerViewModel.cs | 525 | SetDetailingPackageFromSpoolItem | B | try/finally Stop |
| Kelly-Revit-v5\modules\AllTrade\Commands\Spools\SpoolManager\SpoolManagerViewModel.cs | 586 | SetLineNumber | B | try/finally Stop |
| Kelly-Revit-v5\modules\AllTrade\Commands\Spools\SpoolManager\SpoolManagerViewModel.cs | 654 | SetLineNumberFromSpoolItem | B | try/finally Stop |
| Kelly-Revit-v5\modules\AllTrade\Commands\Spools\SpoolManager\SpoolManagerViewModel.cs | 746 | SetSpoolName | B | try/finally Stop; ObjectCountSelected set before Start |
| Kelly-Revit-v5\modules\AllTrade\Commands\Spools\SpoolManager\SpoolManagerViewModel.cs | 796 | SetSpoolNameUsingSpoolItem | B | try/finally Stop |
| Kelly-Revit-v5\modules\AllTrade\Commands\Spools\SpoolManager\SpoolManagerViewModel.cs | 838 | UpdateBillOfMaterialType | B | try/finally Stop |
| Kelly-Revit-v5\modules\AllTrade\Commands\Spools\SpoolManager\SpoolManagerViewModel.cs | 882 | UpdateItemNumbers | B | try/finally Stop |
| Kelly-Revit-v5\modules\AllTrade\Commands\Spools\SpoolManager\SpoolManagerViewModel.cs | 931 | UpdateTag | B | try/finally Stop |
| Kelly-Revit-v5\modules\AllTrade\Commands\Spools\SpoolManager\SpoolManagerViewModel.cs | 978 | UpdateWeldLocation | B | try/finally Stop |
| Kelly-Revit-v5\modules\AllTrade\Commands\Supports\SuspendedSupportManage\SuspendedSupportManagerViewModel.cs | 480 | RunSelectionOperation | A | Already a Run-style helper; could be rebuilt on Run; one caller passes a Group with nested Transactions |
| Kelly-Revit-v5\modules\Contenter\Commands\FabricationCustomDataUpdaterV2\FabricationCustomDataUpdaterCommandV2.cs | 179 | Execute | B | Per-part SubTransaction plus catch that continues; Stop if writtenCount>0, else RollBack |
| Kelly-Revit-v5\modules\DuctTrade\Commands\DuctItemNumberReset\DuctItemNumberResetCommand.cs | 34 | Step02_ExecuteOperation | A | |
| Kelly-Revit-v5\modules\DuctTrade\Commands\DuctItemNumberSet\DuctItemNumberSetCommand.cs | 101 | Transaction | A | Called inside the caller's raw TransactionGroup loop |
| Kelly-Revit-v5\modules\Manager\Commands\DeleteById\ElementDeleteCommand.cs | 26 | Execute | A | Success/failure dialog shown before Stop |
