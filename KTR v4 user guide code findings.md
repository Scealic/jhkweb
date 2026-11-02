# KTR v4: code problems found while writing user guides

Working notes, 2026-10-30. Found by reading the Kelly-Revit-v4 code (and the Logic and Windows layers it calls) while writing the user guides in `Kelly-Revit-v4/docs/user-guides`. Nothing here was checked in Revit and no code was changed. Paths are under `Kelly-Revit-v4/src` unless they name another repo; line numbers are as of the scan. Each guide's own Notes say what users will see.

## Found in the first batches

- Spool eligibility (`Common/Modelle/SpoolItem.cs` `IsSpoolAble`): insulation is meant to be excluded but returns eligible, because the rejection adds no report line and the method returns true when the report is empty.
- Update Custom Data (V1): the transaction always commits, even after an error part way (`FabricationCustomDataUpdaterCommandV1.cs`); its "Workshared Elements" message joins Element objects, so it shows type names, not ids; it calls every part a "hanger".
- Update Custom Data (V2): only the first part is checked for required custom data points; the gauge error still mentions SQL Server though the gauge comes from Gauge.csv.
- Custom Data Report / Custom Data Report (Proposed): CSV values unquoted, commas shift columns.
- Dimension Data Report: says it needs a selection; nothing stops it without one.
- Set Revision Date (`Kelly-Revit-Logic-v4/src/Extensions/DocumentExtensions.cs` `SetRevisionInformation`): no success message; silent no-op without JHK parameters; time stored as a number (09:30:15 becomes 93015).
- Align Conduit Bottom (Developer): button reuses `Names.PushButtonText.AlignConduitBottoms` but copies built-in parameter group ids to the clipboard.
- Collector Testing (Developer): always returns Failed.
- Duct Length Check / Duct Mirror Check: stubs; they collect ductwork and do nothing, with no message.
- Set Part Item Number: picking a duct part not collected at start (probably one inside an assembly) ends the pick loop silently; renumbering leaves gaps (also Set Run Item Number).
- Spool Creator: Create and Update are both `IsDefault`.

## tag-updater (10 written)
- TrapezeExtendSplitButton labelled "Spool" (SplitButtons/TrapezeExtendSplitButton.cs:11)
- Rod with nothing above: Extend sets 0.5 ft (TrapezeVerticalMemberExtendCommand.cs:80), Manager 0.125 ft (SuspendedSupportManagerViewModel.cs:569)
- TrapezeVerticalMemberExtendCommand: no error handling, open transaction on throw; line 21 Failed with no message; NotifyDetailer unused
- Trapeze commands number rods by all layout points (LayoutPointTools.cs:71) vs manager filters rods (SuspendedSupport.cs:405)
- Override Size not saved for family supports (SuspendedSupport.cs:343-349), still clears tags
- Field trim stored in inches where feet expected (SuspendedSupport.cs:338)
- SSM window: two IsDefault buttons (xaml:209,243); Override Size Set not gated
- Allow Un-Hosted Hangers never matches fabrication hangers (VM:678)
- Sleeve Tagger: finish message unused; size "Undefined" when both/neither
- Unquoted CSV: FamilySharedParameterReportCommand.cs:30; AutoUpdaterService.cs:118-133,372-381 (stray " IsEnabled")
- Outdated SuspendedSupportManage/Suspended Support Manager - User Guide.md
- IsElementSelectedAndViewEligibleCommandEnabler doesn't check view
## viewfilters (11 written)
- PipeAndWeldFieldTrimLineColorViewFilterCommand.cs:17 GetFilters().Clear() clears a copy; existing filters never removed
- PipeAndWeldFieldTrimLineColorViewFilterPushButton.cs:79-85 no availability class (sheets/schedules)
- SystemLineColorViewFilterCommand.cs:59 Validate(1) shows exception box when no system matches, then commits empty
- ViewExtensionsToMove.cs:14-17 empty service list throws ArgumentException in transaction; ServiceLineColor never Increments
- DocumentExtensions.cs:1565 GetViewsWithFilters counts only plan/ceiling/elev/section/3D: Remove Unused deletes filters used only on detail/structural/area/drafting views; also deletes unused selection sets
- AllUnusedInProjectDeleteViewFilterCommand.cs:43 dialog title says "All Filters"; lives under Developer, no availability class
- Service vs System line color fill rules differ (Navis+Export vs Export)
- Fill Color commands add empty undo step; palette copied in four classes
## arrange-export (16 written)
- ArrangeDistributeTagsAroundCommand.cs:1422,1451 Validate(1) shows 3-6 exception boxes when a side has no leader tags
- ArrangeDistributeTagsAroundCommand.cs:1381 slots to max*2, tags placed above crop
- TagLeader.cs:1670 forces leader end Attached (replaces free ends)
- Arranger.cs:812 UnTangle Vertically adds previous tag height (overlaps)
- Arranger.cs:917 room/space/area tags without leader never arranged; MoveTo leader code dead
- Arranger.cs:925 moves any selected element incl. model elements
- Arranger.cs:681 one element: transaction started never stopped, no message; "aligned" prompt for all tools
- Arranger.cs:733/749,765/783 outermost by edge not center; undo names "Align Up/Down"
- CSV export (…CommaSeparatedValueFilesExportCommand.cs:44-45,75): ", " delimiter no qualifier; unquoted folder path; no seconds; two dialogs on empty; "<" names skipped silently but counted
- Excel export commands catch nothing (COM/Excel missing -> Revit failure, multi-file stops part way)
- CSV export uses transaction for read-only work; others don't
## assign-b (22 written)
- ElementService.cs:79-87 overwrite prompt: "apply to remaining"+No skips one, then overwrites all remaining without asking
- LineNumberAssignerValueSetCommand.cs:56-63 + RibbonComboBox.cs:87 new value picked as last list item; can write "Select Line Number"
- LineNumberUpdaterElementService.cs:31-33 auto-assign can write "Select Line Number" header text
- ContextValueAddViewModel.cs:10 label "Set Line NumberCombo Box"; closing with X still proceeds
- CommonComboBoxContextAdoptCommand.cs:109 Adopt reports Failed when it added the value
- SpoolNumberAssignerIsolateViewFilterCommand.cs:16 "Isolate By Assembly" vs "Hide By Spool"
- LineNumberModuleSpoolAutoAssignStackedButtons.cs:13-19 row order Line,Spool,Module (others Line,Module,Spool)
- Spool value set/reset buttons no availability class (silent no-op)
- AllAssignerResetPushButton.cs:14 wrong availability (greyed outside model views); ignores sub-results
- value-resets with nothing qualifying show raw ArgumentOutOfRange box (ElementExtensions.cs:129)
- SpoolValueAutoSetCommand.cs:14 comment "MODULE NUMBER"; DEFAULT-LN/MOD/SPL-001 placeholders can be written
- auto-assign icon shared across projects, state per project
## manage-pipe (15 written)
- DocumentOpenedEventHandler.cs:46 / DocumentTools.cs:25 enable only Tools tab; Active Project switches Pipe/Duct too
- ActiveProjectCommand.cs:45-57 "still attached to central" shown for detached models
- FamilySymbolExtensions.cs:137 HasInstancesFast: Purge Unused Families deletes tag families with placed tags (and tags)
- DocumentInformationManageView.xaml:415 Model slider label percent format (50 -> "5,000.00 %")
- ProjectInformationWrapper.cs:68 Market Sector hard-coded "TBD", editable but never saved
- DocumentInformationManageViewModel.cs:27-29 read-only mode still editable
- ValveClearanceSpheres: placed at insertion point not center (cmd:83, ValveData.cs:33); fails with no bbox; titles "Export Valve Information Issue"; double dialogs
- WeldLocationSetCommand.cs:42 connectedStraights never cleared; 69-71 progress drift; 113 missing term throws; Weld*Set silent when no welds
- ConnectOletsExternalEventHandler.cs:20 uses active doc; OletCheckViewModel.cs:251 reload reads changed selection
- SharedParameterBindingsReport…:34-38,98 "Cancelled" never written; appended without date
- ElementDeleteCommand.cs:38-45 dialog with transaction open; failed delete commits empty
## general (12 written)
- PointToPipe probably never creates pipes (ViciousFileBasedSystemPipePlaceTools.cs:50 collector narrowed; 87/149/180); disposed collector reused in 3D
- PointToPipe sizes wrong after 100 points (212/221); conversion repeated (240); OK with no file NullRef (30); import runs even on cancel (View.xaml.cs:54)
- Racker: Esc applies (Align is IsDefault+IsCancel, View.xaml:172-178); bad text becomes 0 ft (VM:341); only Product Range "1"
- Stratus DP views: "no detailing packages" unreachable due to DEFAULT-DP-001 (DetailingPackageDocumentCache.cs:43); duplicated sentence
- Hanger Place: start 0 + repeat>0 places nothing silently (cmd:135); "StartTransaction End Distance"; Esc error; X places; fallback 5 vs default 8; hidden checkbox
- Rotate: X reopens dialog (View.xaml.cs:107); empty angle throws; swallows all warnings; crop hidden
- About: user add-ins folder never shown; "UserDomain Information" header
- ManyConnect: failed connect leaves element moved; 1e-10° tolerance -> frequent report
- Level Correct: no-category throws; no model elements throws; raw decimal-feet levels
## assign-a (21 written)
- ElementService.cs:46 Service Value Set ignores LogicalAndFilter: all selected elements processed; non-fab get selector service / cleared; tooltip says otherwise
- DetailingPackageAssignerValueSetCommand.cs:458 unticked box writes "Select Detailing Package"
- Detailing Package auto-assign writes placeholder; overwrite prompt can open inside updater (ElementService.cs:66)
- Adopt returns Failed on success (CommonComboBoxContextAdoptCommand ~104)
- DP Value Reset error box "List must contain at least 1 items" (ElementExtensions.cs:129)
- ContextValueAddViewModel.cs:10 label missing space; X proceeds
- VisibilityCommon.cs:24 throws outside try when param unbound; line 53 refuses values starting "Select"
- ServiceOfNonFabricationPartElementService.cs:73-82 stale JHK Navis System when service not found
## bom-container-layout (12 written)
- LayoutPoint export VM:479-529 cancel save dialog doesn't stop export (cleanup error, stamps Exported, DWG, opens folder); :813-864 placeholder dialog text; :297/:395 index out of range on type swap
- LayoutPointExportCandidate.cs:107-110 quality check always UnChecked
- Export View.xaml.cs:413-414 enable rule overwritten; :582-605 count omits Data Too Long, stray ")"
- Import VM:238-285 header check accepts 6 layouts, reader maps exact names -> most fail; Cancel without return (:255,:280); null FamilySymbols crash (:292,:552); failed placement SetValue on null (:426-434); changing Site changes active location
- Import View.xaml:165 "x__Layout Reference" label
- GridLayoutPointPlaceCommand.cs:29 "Entities Not Found" unreachable; duplicates on re-run; double family dialogs
- SpoolItem.cs:396 writes "Invalid Tag '...'" to JHK Tag; BOM None writes "None" (SpoolManagerViewModel.cs:907/SpoolItem.cs:305)
- SpoolManagerView.xaml:1285,1476 Create Sheets/BOM Update renumber silently; :1108-1111 empty EventName; .xaml.cs:79 tab index 4
- ProductRange10Joints01Weld.cs:54 any code but "S" -> Field
- ModuleManageViewModel.cs:192-195 SetSelectedComponents stub; :334-375 numbers run on across modules; View.xaml.cs:76 sorts by missing "Number"
- ModuleNumberDocumentCache.cs:42-46 DEFAULT-MOD-001 makes first module 002
- ModuleCreatorViewModel.cs:33 "Assembly inclusion" text
- Spool.cs:485 Spool Clean never removes subcategory parts; insulation passes
- SpoolCleanCommon.cs:25 "in this Revit Project" means view
