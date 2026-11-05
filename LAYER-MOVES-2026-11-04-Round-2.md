# Layer moves - 2026-11-04 Round 2: after action report

The moves went bottom-up through the six Major Version 5 layers. Each move was proposed by an analysis agent and challenged by an adversarial reviewer. Each was then implemented test-first, reviewed again, built in every configuration and committed on `develop`. Nothing was installed. Linear project: [Layer Moves 2026-11-04 Round 2](https://linear.app/jhkelly/project/layer-moves-2026-11-04-round-2-69c9c35f968c), In Progress. The plan is `LAYER-MOVES-PLAN-2026-11-04-Round-2.md`.

## What was planned

- **Analysis:** 17 scopes covering all 1129 source files, run by 54 agents. They proposed 329 moves; the review kept 302 (56 of them changed by the reviewer) and rejected 27. None was high risk and none moved upward. 43 were medium risk, and the user chose to do them in this run.
- **Packages:** 17 target packages, which add the new members in the lower layer, and 25 source packages, which switch the originals over and delete them. That made 42 work packages and 42 Linear issues across six teams. Each source issue is a sub-issue of its target issue, and the layers are chained by "blocked by" links.
- **Order:** bottom-up, from Kelly-Windows-Data to Kelly-Revit, packing each layer and repinning the one above.

## What happened

| Repo | Run commits | Package | Tests |
|---|---|---|---|
| Kelly-Windows-Data-v3 | 3 (`cfbcdda` … `8ae8e88`) | `3.26.1104.1819` | 179 of 179 pass in Net481, Net80, Net100 (was 166) |
| Kelly-Windows-v3 | 3 (`5b39ab0` … `d64dfad`) | `3.26.1104.1840` | 830 pass in Net481, Net80, Net100 |
| Kelly-Domain | 8 (`c110dc3` … `89547d0`) | `1.26.1104.1928` | 1797 pass in Net481, Net80, Net100 |
| Kelly-Revit-Logic-v5 | 14 (`d62733f` … `a0d5b2d`) | `5.26.1104.2207` | in-Revit tests (1437) compiled for 2024-2026, **not run** |
| Kelly-Revit-UI | 8 (`5e24110` … `9e2d1c4`) | `1.26.1104.2254` | 224 of 224 pass (2024-2026); in-Revit tests compiled, **not run** |
| Kelly-Revit-v5 | 18 (`d90cbdea` … `1ab4e135`) | not a package; host and Trade.All 2024 build with 0 errors, not installed | Core.Tests (706) compiled for 2024-2026, **not run** |

- **Moves:** 302 planned. 38 packages are done and 4 are partial (below), and no move was skipped.
- **Rules (`check-rules.pl`):** 0 hits in rules 1-4, the same as the baseline. Rule 5 counts 130 commands instead of 133 only because 4 reset commands now derive from a shared base that the script does not count.
- **Pins:** each repo pins this run's package of the layer below.
- **State:** every working tree is clean, and the 2024 add-in manifests are as they were.
- **In-Revit tests:** not run, because Revit 2024 (PID 31420) was open for the whole run.

| Package | Linear | Status | Commit |
|---|---|---|---|
| P1a-data-services | KWD3-11 | Done | `cfbcdda` |
| P2a-windows-collections-files | KW3-16 | Done | `5b39ab0` |
| P3a-domain-common-definitions | KD-39 | Done | `c110dc3` |
| P3b-domain-layoutpoints-pcf | KD-40 | Done | `218eaf2` |
| P3c-domain-spools-supports | KD-41 | Done | `df0e131` |
| P3d-domain-views-vocabulary | KD-42 | Done | `4bdca66` |
| P3e-domain-source-services | KD-43 | Done | `39847df` |
| P3f-domain-source-collections-files | KD-44 | Done | `29c4c38` |
| P4a-logic-arrangement-common | KTRL5-47 | **Partial** | `d62733f` |
| P4b-logic-documents-elements | KTRL5-48 | Done | `8957dff` |
| P4c-logic-fabrication-families | KTRL5-49 | Done | `0475d3f` |
| P4d-logic-mep-operations | KTRL5-50 | Done | `1a549a4` |
| P4e-logic-signatures-spools | KTRL5-51 | Done | `facd687` |
| P4f-logic-supports-updaters | KTRL5-52 | **Partial** | `dd79caf` |
| P4g-logic-views | KTRL5-53 | Done | `25de9dc` |
| P4h to P4l (Logic source halves) | KTRL5-54 to 58 | Done | `101dee6`, `8b834da`, `5654e01`, `6f64669`, `fc66e59` |
| P5a, P5b, P5c (UI) | KTRUI-12 to 14 | Done | `5e24110`, `3039698`, `c4c0e7a` |
| P5d, P5e, P5f (UI source halves) | KTRUI-15 to 17 | Done | `1290cb8`, `e40bce8`, `050e242` |
| P6a-revit-assigners-scheduleexport | KTR5-4727 | Done | `d90cbdea` |
| P6b-revit-source-collections-files | KTR5-4728 | **Partial** | `7c8c4297` |
| P6c to P6m (Kelly-Revit source halves) | KTR5-4729 to 4739 | Done | `3b5e6796` … `b6a9ece4` |
| P6n-revit-source-commands-grids | KTR5-4740 | **Partial** | `ddb84348` |
| P6o, P6p | KTR5-4741, 4742 | Done | `fcd9b340`, `ffc9fe87` |

Each layer also has one review-fix commit (`76ef4ee`, `9ec81f0`, `cd7f924`, `6dda4d6`, `84203c0`, `02750d71`) and one version-docs commit.

## What moved, by layer

- **Kelly-Windows-Data:** `RecordIndex` (first-row-wins and SQL-key indexes) from Kelly.Domain's `DataStore`.
- **Kelly-Windows:** generic helpers out of Logic, Domain and the add-in:
  - shortest-path search, folders and the file-store description;
  - coordinate parsing, angle and weight conversion, colour names;
  - the record cache lifecycle, prompts in place of raw TaskDialogs, and window centring;
  - `ApplicationSession`, now in `Kelly.Windows.Hosting`.
- **Kelly-Domain:**
  - 17 shared-parameter definition sets that were nested inside Logic types;
  - default identifiers, signature lookup and composition rules;
  - layout point, PCF and spool rules, support family and tag rules;
  - schedule export file names and Kelly vocabulary literals.
- **Kelly-Revit-Logic:** Revit database code out of commands and view models:
  - the transactions of Spool Create, Spool Manager, Module Manager, Support Manager, Layout Point Export and Import, Many Connect and Delete By Id;
  - Point to Pipe and Olet Check, the weld location setters and the fabrication reports;
  - the updater loops, view filters and the document-opened check.
- **Kelly-Revit-UI:** framework shared by the modules:
  - the MVVM dialog show sequence and a command runner;
  - availability base rules and grid descriptor resets;
  - a ribbon panel template and a combo box base for the six assigners, with their settings and drop-down handlers;
  - stacked combo-box rows, select-and-show, and picks.
- **Kelly-Revit:** every command, view and view model now calls the moved code. The duplicated assigner reset commands and the Excel lifecycle code are shared within Trade.All.

## Not done

### Partial

- **KTRL5-47 (#97):** the Point to Pipe settings file name stays a literal in Logic. Kelly-Domain had already been packed, so the constant could not be added there. The rest is filed as KD-47.
- **KTRL5-52 (#201):** the un-hosted hanger skip rule is a private `SuspendedSupport.IsTaggable` in Logic instead of being in Kelly.Domain, also because Domain was already packed. Filed as KD-48.
- **KTR5-4728 (#22):** Vicious Racker still builds its own TaskDialog, because Kelly-Revit-UI's `RevitUserPrompt` ignores `AllowCancellation`. That UI change was in P2a's spec but no package was given it. Filed as KTRUI-18.
- **KTR5-4740 (#244):** `IsDocumentOfTypeFamily` was not rebased on the shared base, because doing so would change its behaviour with a null `uiApp`. Filed as KTR5-4746.

### Skipped, dropped, deferred

None.

## Behaviour you may notice

- Layout Point Export's window is now centred correctly on displays scaled above 100%. The old code mixed device pixels with WPF units.
- **Layout Point Export:** with Export Background DWG checked and no view chosen, the export now skips the DWG and opens the folder; before, it threw after writing the CSV. The window checks the view when it opens, so this rarely happens.
- **Exception types:** a few null inputs that no caller passes now throw `ArgumentNullException` instead of `NullReferenceException`, for example a null panel in the assigner visibility panel or a null `UIDocument` in select-and-zoom. Each is recorded in its layer's Changelog.
- **Distinct type names:** some extracted types were renamed so they would not clash, for example `ElementComponent` → `ModuleComponentModel` in Kelly.Domain. They are public types in new namespaces, and the layers above have been repointed.

## Bugs found and deliberately NOT fixed

Each is a Linear issue in the project. Behaviour was kept and each one is pinned by a test.

### Medium

- **KW3-17:** `PathTools.DescribeFileStore` describes a UNC path that contains `C:\` as drive C:.
- **KW3-18:** `DirectoryTools.GetOrCreate` returns a folder that still doesn't exist after three failed attempts, with no warning.
- **KTRL5-59:** the two service updaters match a service by signature differently: one ignores case and the other doesn't, and they handle an empty signature differently.
- **KTRL5-60:** `RunWithProgress` returns true when Revit rolls the commit back.
- **KTR5-4744:** the assigner adopt buttons report Failed after successfully adding a new value.
- **KTRUI-18:** `RevitUserPrompt` ignores `PromptRequest.AllowCancellation`.

### Low

- **KD-45:** `ModuleComponentModel` checks double columns against integer ranges, so values like 100.5 pass.
- **KD-46:** support tag pairing is case-sensitive but `NextTag` ignores case. The family-name checks also mix `Contains` and `StartsWith`.
- **KTR5-4743:** the missing shared parameters dialog says the list was copied to the clipboard, but it wasn't.
- **KTRL5-61:** Spool Manager and Module Manager write different JHK BOM Type values. The partial-commit part is the existing KTR5-4637.
- **KTRL5-62:** duct item number Reset and Run Item Number Set clear item numbers differently.
- **KTRL5-63:** `AutoUpdaterService` throws a NullReferenceException for an updater that was never built.
- **KTRL5-64:** `GetCropBoxRotationAxis` throws a NullReferenceException when the crop box has no bounding box.
- **KTRL5-65:** `IsModelInstance` throws a NullReferenceException for an element with no owner view and no category.
- **KTR5-4745:** Module Manager's Show In View checkbox does nothing.
- **KTR5-4746:** `IsDocumentOfTypeFamily` throws on a null `uiApp`.
- **KTR5-4747:** `ExcelInteropTools.FormatWorksheet` and `ImportTabDelimitedText` have no tests.

## What went well

- **Linear:** filing all 42 issues before implementing gave every commit an issue to name. The audit closed 38 of them with commit evidence, and the cross-layer "blocked by" links matched the real build order.
- **Every layer is complete:** each layer had a target and a source package, so this time no layer was left holding both the old and the new copy. In round 2a, 82 moves ended with both copies kept and only the old one called.
- **Reviews:** the adversarial reviews caught real problems, such as a test description that claimed more than it checked and an untested null contract. They were fixed before each pack.
- **Builds:** all five packs built first time in every configuration, and no layer needed a second fix attempt.
- **Behaviour:** the "preserve behaviour, record bugs" rule held. 17 defects were found, pinned by tests and filed instead of being quietly changed.

## What went wrong

- **Usage limit during the analysis:** three agents (the cross-repo duplication finder and two compile probes) stopped when the usage limit was reached. Resuming from cache recovered them, at the cost of one extra round trip.
- **Lower layer already packed:** in four cases a package needed a small addition to a layer that had already been packed. Two moves landed in the wrong layer as a result (KD-47, KD-48), and one cross-layer change was never assigned to any package (KTRUI-18). Cause: the specs listed "required changes" in lower layers without turning them into packages.
- **In-Revit tests not run:** Revit 2024 was open for the whole run, so about 2,100 in-Revit tests were only compiled.
- **Pushes during the run:** Kelly-Windows-Data-v3 (to `8ae8e88`) and Kelly-Domain (to `c110dc3`) were pushed at 18:49 on 2026-11-04, in the middle of the run. The run must never push, and the log does not show who did. Please confirm it was you.
- **Commits that don't build:** Kelly-Revit-v5's commits `d90cbdea` to `fcd9b340` do not build on their own, because the source packages depend on each other within the layer. Only HEAD builds. This is recorded in the Changelog.
- **Doc comments in Revit-free layers:** they now name the higher-layer repo each member came from ("Moved on 2026-11-04 from ... in Kelly-Revit-Logic-v5"). The word "Revit" appears 113 times in the Revit-free layers, up from 65. None of it is Revit API use, but it is noise against rule 1's spirit.
- **Backlog keys:** the bugs the agents added to the Quick-Backlogs do not yet carry their new Linear keys.

## What to change next time

- **Lower-layer changes become packages:** when a spec's required changes include anything in a lower layer, the planner should make it a target package in that layer, or move the dependent move to the next round. The skill should say this in step 3 (work packages). Not yet changed in the skill.
- **Check Revit before implementing:** step 5 should check for a running Revit 2024 before the workflow starts and ask the user to close it, rather than finding out per layer. Not yet changed.
- **Provenance in the Changelog:** the implementer prompt should keep "moved from" notes in the Changelog rather than in XML remarks of the Revit-free layers.
- **Backlog keys:** the audit step should add each bug's Linear key to the Quick-Backlog line the implementer wrote (`kelly-backlog-update` can do it).

## Things to check

- **In-Revit tests:** run them in Revit 2024 once it is closed, with `revit-test.sh` for Logic, UI and Kelly-Revit. The Logic run takes about 30 minutes.
- **Pushes:** confirm the two pushes at 18:49 were yours.
- **Manual check in Revit:** try Layout Point Export (window centring, the background DWG case), the assigner combo boxes and their adopt buttons, Spool Manager and Module Manager select-and-zoom, and the Support Manager actions.
- **Push the rest:** Kelly-Windows-v3 (3 commits), Kelly-Domain (7), Kelly-Revit-Logic-v5 (14), Kelly-Revit-UI (8) and Kelly-Revit-v5 (18) are ahead of `origin/develop`. Push them bottom-up when ready.

## Next

Close Revit 2024 and run the in-Revit tests for Kelly-Revit-Logic, Kelly-Revit-UI and Kelly-Revit with `revit-test.sh`. Then push `develop` bottom-up.

## Follow-up sweep (2026-11-05)

The 6 medium defects and the 4 partial moves were fixed bottom-up in one pass. Each layer was packed and the layer above repinned. Nothing was installed or pushed.

| Repo | Commits | Package | Items | Tests |
|---|---|---|---|---|
| Kelly-Windows-v3 | `361f7e7`, `6ca04a6` | `3.26.1105.810` | KW3-17, KW3-18 | 835 of 835 pass (Net481, Net80, Net100) |
| Kelly-Domain | `fea4acf`, `3639c9c` | `1.26.1105.812` | KD-47, KD-48 | 1804 of 1804 pass (Net481, Net80, Net100) |
| Kelly-Revit-Logic-v5 | `977fd9f`, `df838f8` | `5.26.1105.816` | KTRL5-59, KTRL5-60, KD-48 switch | in-Revit tests compiled 2024-2026, **not run** |
| Kelly-Revit-UI | `f45ef5c`, `b3fedfb`, `64a0f13`, `f58eeb7` | `1.26.1105.818`, then `1.26.1105.821` | KTRUI-18, KTR5-4744 | 230 of 230 pass (2024-2026); in-Revit tests compiled, **not run** |
| Kelly-Revit-v5 | `e7480dc8`, `c7029201` | not a package; all 21 configurations build, not installed | KTR5-4728 (Racker), KTR5-4746, KD-47 switch | in-Revit tests compiled 2024-2026, **not run** |

- **Linear:** KW3-17, KW3-18, KD-47, KD-48 and KTRUI-18 are Done. KTRL5-59, KTRL5-60, KTR5-4744 and KTR5-4746, and the partial parents KTRL5-47, KTRL5-52, KTR5-4728 and KTR5-4740, are in **Testing** until the in-Revit run.
- **KTR5-4744** was fixed in Kelly-Revit-UI (`SelectOrAddProjectMember` returns whether the value is current), not in the add-in. A live ribbon combo box can't be built in a test, so it needs the hand check of the adopt buttons.
- **KD-47:** the `PointToPipe.txt` literal was in Kelly-Revit-v5's Point To Pipe window, not in Logic as the report said.
- **Behaviour changes users may notice:** the Suspended Support Manager no longer treats a rolled-back edit as done. The layout discipline updater matches services ignoring case. A UNC path containing `C:\` is "Network Drive". A folder that cannot be created now stops with a "Directory Error".
- **Left open:** the 11 low-severity defects. Kelly.Domain's `ServiceSignatureTools.FindServiceExact` no longer has a caller, and can be deleted in the next Domain change.
- **Still to do:** run the in-Revit tests (Revit 2024 was closed at 08:27) for Logic, UI and Kelly-Revit; then do the hand check; then install and push.
