# Layer moves - 2026-11-06: after action report

Run of the `kelly-layer-moves` skill on 2026-11-06 (Major Version 5). Plan: [LAYER-MOVES-PLAN-2026-11-06.md](LAYER-MOVES-PLAN-2026-11-06.md). Linear project: [Layer Moves 2026-11-06](https://linear.app/jhkelly-ktr/project/layer-moves-2026-11-06-3a476fe05668) (P-KW3-184).

## What was planned

- **Analysis:** 17 scopes, 1178 files read. Finders proposed 155 moves, reviewers rejected 58, and 100 survived. At my check I merged 17 duplicates and dropped 4, leaving **79 moves in 18 work packages**: 9 target and 9 source.
- **Decisions by the Senior Software Developer:**
  - Accept the plan with the recommended choices: the 9 TaskDialogs switch to `UserPrompt`, the breaking and upward moves go ahead, and the high-risk #70 is included.
  - New rule: **no WPF MVVM type moves out of Kelly-Revit**. Only code inside views, view models and models may move, into non-MVVM types.
  - #86 (with #87 and #91) was dropped because it would have put a view-model handler on the UI `ViewModel` base.
  - The eight code extractions from views and view models were kept.
  - Models stay with their MVVM set "for now".
- **Finish:** commit, push, build and pin.

## What happened

| Package | Repo | Linear | Commit(s) | Status |
|---|---|---|---|---|
| P2a windows helpers | Kelly-Windows-v3 | KW3-25 | 22412f7, 0533bf6 | Done |
| P2b QualityCheck source | Kelly-Windows-v3 | KW3-26 | ca51f45 | Done |
| P3a quality, spools, supports | Kelly-Domain | KD-54 | 04da6fe, 4420b0b | Done |
| P3b fabrication | Kelly-Domain | KD-55 | af4bf24 | Done |
| P3c Domain source | Kelly-Domain | KD-56 | ee39307 | Done |
| P4a Logic source | Kelly-Revit-Logic-v5 | KTRL5-96 | 7ca74d3, 272291f | Done |
| P4b common, documents | Kelly-Revit-Logic-v5 | KTRL5-92 | 36f0467 | Done |
| P4c fabrication, geometry, MEP | Kelly-Revit-Logic-v5 | KTRL5-93 | 335d070 | **Partial** (#53 → KD-58) |
| P4d spools, supports | Kelly-Revit-Logic-v5 | KTRL5-94 | f3b8b06 | Done |
| P4e updaters, views | Kelly-Revit-Logic-v5 | KTRL5-95 | e26fc64, 3f0242f | Done |
| P5a UI source | Kelly-Revit-UI | KTRUI-28 | 5a69889 | Done |
| P5b grids | Kelly-Revit-UI | KTRUI-27 | 3b82d2b | Done |
| P6a repin breaks | Kelly-Revit-v5 | KTR5-4760 | b1d2e29d | Done |
| P6b commands to Windows/UserPrompt | Kelly-Revit-v5 | KTR5-4761 | c4d3d504 | **Partial** (#12, half of #13 → KTR5-4765) |
| P6c domain and host | Kelly-Revit-v5 | KTR5-4762 | c81886ab | Done |
| P6d commands to Logic (a) | Kelly-Revit-v5 | KTR5-4763 | a130900f | Done |
| P6e view models to Logic (b) | Kelly-Revit-v5 | KTR5-4764 | 142b635b | Done |
| P6f views and de-duplication | Kelly-Revit-v5 | KTR5-4759 | 052c04f4, d2e30880, 0dd03005 | Done |

Planned 79 moves: 76 done and 3 partial or not done (#12, the second dialog of #13, and #53). None skipped, none deferred by the user.

**Packages and pins.** Every repo pins this run's package of the layer below:

| Layer | Package | Pinned by |
|---|---|---|
| Kelly-Windows | 3.26.1106.1532 | Kelly-Domain |
| Kelly-Domain | 1.26.1106.1600 | Kelly-Revit-Logic-v5 |
| Kelly-Revit-Logic | 5.26.1106.1931 | Kelly-Revit-UI |
| Kelly-Revit-UI | 1.26.1106.1944 | Kelly-Revit-v5 |

Kelly-Windows-Data was not changed.

**Builds and tests:**
- Kelly-Windows: 914/914 in Net481, Net80 and Net100.
- Kelly-Domain: 1889/1889 in all three configurations.
- Kelly-Revit-UI: 238/238 in 2024, 2025 and 2026. In-Revit: 91/91.
- Kelly-Revit-Logic in-Revit (Revit 2024, add-in disabled): 1549/1557.
  - 4 stale tests were fixed in 3f0242f and the rerun passed 79/79.
  - The other 4 fail on the known Revit 2024 Serilog clash, the same way at the base sha (KTRL5-18, KTRL5-99).
- Kelly-Revit in-Revit: 904/908. The 4 failures need the add-in started, which is by design in these runs.
- Final build after the push: host and six modules × 2024/2025/2026, 21/21 with 0 errors. Built, not installed; the 2024 manifests are unchanged.

**Rules:** `check-rules.pl` sections 1–4 match the baseline. Section 5's count of "Revit" in the Revit-free layers rose from 111 to 116, from the Domain `<remarks>` (KD-59). Kelly-Revit's IExternalCommand count fell from 130 to 125 only because the seven leaf commands now inherit the interface from their new base classes. Every command still exists in its file with `[Transaction]`.

**Git:** Pushed `develop` for Kelly-Windows-v3, Kelly-Domain, Kelly-Revit-Logic-v5, Kelly-Revit-UI and Kelly-Revit-v5, at the Senior Software Developer's request. `main` was not touched. There are no co-author lines.

## What moved, by layer

- **Into Kelly-Windows:**
  - `FileTypeTools.FromPath` (replaces Domain `PointFiles`/`PointFileKind`);
  - `ObjectPropertyLogger.LogProperties` (Logic `WriteToLog` forwards to it with "FamilyInstance");
  - `AngleExtensions.ParseAngle`, `TryParseAngle` and `RadiansToDegrees`;
  - `Measurements.DimensionModel`;
  - `ClipboardReportPrompt`;
  - `DomainGroupReport.MemberReportFileName` and `SaveMemberReport`.
  - `QualityCheck` left Kelly-Windows for Kelly-Domain.
- **Into Kelly-Domain:**
  - `LayoutPoints.QualityCheck`;
  - the `ScopeType.ThrowIfNotDefined` guard;
  - `TypeBoundSharedParameter` and its report;
  - `ModuleNumber.DefaultModuleType`;
  - the spool BOM builder, item numbering and suffix parsing;
  - support signatures and hanger spacing;
  - `ProductCodeCheckResult` (Revit-free) and `ProductCodeCheckReport`;
  - the fabrication data-model and end-preparation rules, and `FabricationCustomDataNames`.
  - The seven `Nouns.Revit*` members were removed.
- **Into Kelly-Revit-Logic:**
  - `Caches.DataFileLoader` and `Common.AddInNames` (from UI);
  - `EventHandlerTools.Run`;
  - the command and view-model database logic of #39–#83: Rotate, the Custom Data writers, BOM, coordinates, Point To Pipe, valve spheres, the spool/module/element-id helpers, the Suspended Support operations, the value set/reset, `SignatureViewFilterTools`, the Stratus guard and the schedule export loops;
  - `ProductCodeChecks.Create`;
  - the shared updater validation.
- **Into Kelly-Revit-UI:** `RadGridViewExtensions.SetOrFilter`. `DataFileLoader`, `AddInNames` and the `AssignerContext` control were removed.
- **Inside Kelly-Revit:**
  - `AssignerContext` moved into Trade.All (a view belongs in Kelly-Revit);
  - `AssignerAutoSetToggleCommand<T>`, `BillOfMaterialTypeSetCommand` and `ContextValueAddDialog` replace duplicated `Execute` bodies, and every leaf command stays.
  - Commands, views and view models stay as thin shells.

## Not done

### Partial

- **#53** (KTRL5-93): the Product Code Check summary text belongs on `ProductCodeCheckReport`, which had moved to Kelly-Domain, already packed. Filed as KD-58.
- **#12 and the second dialog of #13** (KTR5-4761): these dialogs use `FooterText`, which `PromptRequest` does not have, so they still build their own TaskDialog. Filed as KTR5-4765.

### Skipped, dropped, deferred

None in the run. Dropped at the plan: #86/#87/#91 (MVVM rule) and #88–#90 (one module only).

## Behaviour you may notice

None intended. Every package was a MOVE.
- The nine switched dialogs now go through `UserPrompt`, rendered by `RevitUserPrompt`, with the same title, text, buttons, default button, icon and cancellation as before.
- AssignerContext lives in Trade.All but is still never shown (KTR5-4773).

## Bugs found and deliberately NOT fixed

All are in the project as Backlog issues.

### Medium

- KTR5-4769: Missing Shared Parameters dialog says the list is on the clipboard.
- KTR5-4772: Service/System line colour filters.
- KTR5-4774: the Layout Point Export " IsExported" filter.
- KTR5-4776: Contenter V1 message and the Various Report cast.
- KTRL5-101: SpoolItem.IsSpoolAble lets Insulation through.
- KTRL5-102: inches/feet in SetVerticalMemberExtensions, and defaults.
- KD-57: support signature text differs between .NET Framework and .NET 8.

### Low

- KTR5-4766: Rotate throws on empty text.
- KTR5-4767: Esc on the Duct Item Number Set question still renumbers.
- KTR5-4768: Line Number doesn't dispose its add-value view model.
- KTR5-4770: host handlers.
- KTR5-4771: Vicious Rotate and Point To Pipe.
- KTR5-4773: assigners.
- KTR5-4775: Many Connect, Stratus and the spool tools.
- KTR5-4777: Developer tools.
- KTRL5-98: the Stratus no-packages prompt can never show.
- KTRL5-99: Serilog clash test.
- KW3-27: IsList misses IList<T>.

**Follow-ups (Change):**
- KTRL5-103: seven remaining ScopeType guards.
- KD-59: Domain remarks name higher layers.
- KTRL5-97: PathExtensions repeats the add-in name.
- KTRL5-100: one ViewFamilyType test helper.
- KD-58 and KTR5-4765: the two partial moves.

## What went well

- The MVVM rule, set during the plan, held: no MVVM type left Kelly-Revit, and the audit found none moved.
- Running the first package of each layer as the repin-absorbing source package kept every layer compiling after its repin.
- Revit 2024 was free, so all in-Revit suites ran instead of being only compiled. The full Logic run caught 4 stale tests.

## What went wrong

- The base did not compile. The ReSharper cleanup (0763021) removed two needed usings from Kelly-Windows; they were restored in 20dd3de before the run.
- The analysis read the working trees while that cleanup was being committed, so each package had to re-check its moves first.
- Two moves needed an option or a home in a layer that was already packed: FooterText and the report summary.
- The Domain package added provenance `<remarks>` despite the rule.
- One commit (22412f7) has no blank line after its subject line. It was not amended.

## What to change next time (done in the skill)

- **Workflow loading:** the Workflow tool refuses `scriptPath` in the skills folder. SKILL.md now says to read the script and pass it inline.
- **First package of a layer:** SKILL.md now says it absorbs the repin.
- **Lower-layer coverage:** before writing the specs, check that the lower layer covers every option a source half needs.
- **Provenance:** the rule that provenance stays out of the Revit-free layers' XML docs is restated in every Revit-free spec.
- **MVVM rule:** written into `placement-rules.md` (rule 2), the analysis prompt and memory.

## Things to check

- Open the tools whose dialogs switched to `UserPrompt` (#6–#10, #13 first dialog, #14) and compare each dialog with v4's.
- Suspended Support Manager (#70, high risk): attach/extend, tag, extensions and size on a real model.
- After the next install, run the Kelly-Revit tests that need the add-in started, to clear the 4 by-design failures.

## Next

- The two partials: KTR5-4765 (needs `PromptRequest.FooterText` in Kelly-Windows first) and KD-58.
- Then a develop→main pull request per repo, bottom-up, when the Senior Software Developer chooses.
