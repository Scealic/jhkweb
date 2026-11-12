# Linear Issue Splits, 2026-11-12

Scope: KTR5-4085 only, at the maintainer's request, after the design interview of 2026-11-12 (decisions in the issue's comments).

| Team | Open issues reviewed | Fine | Split | Unclear | New issues proposed | Existing issues to link |
|---|---|---|---|---|---|---|
| KTR5 | 1 | 0 | 1 | 0 | 8 (2 in KTRL5) | 3 (Related) |

## [KTR5-4085](https://linear.app/jhkelly-ktr/issue/KTR5-4085) Assigners: dockable assigner panel (2)

- **Signals:** crosses layers (Kelly-Revit-Logic value writers, then the add-in); several independent deliverables (six contexts, value lists, writes, auto-assign, add value, Reset All); a full MVVM rebuild of the ribbon assigners, far beyond 2 points.
- **Shape:** sub-issues. The pane shell (registration, show/hide button) is already committed (Kelly-Revit-v5 `e6dc2f6f`).
- **Original keeps:** parent only; its estimate is removed.

| # | Team | Title | Est. | Relation | Goal |
|---|---|---|---|---|---|
| 1 | KTRL5 | Element services: take the value to write instead of reading `RibbonSelections` | 4 | sub-issue; blocks 3, 6 | `RibbonValueElementService` (Detailing Package, Line Number), `ServiceElementWriter` and `SystemElementService` take the value (or a `Func<string>` source) from the caller, so the ribbon and the pane can each pass their own. |
| 2 | KTRL5 | Auto-assign updaters: one switchable value source per context | 2 | sub-issue; blocks 3, 7 | Each assigner auto updater reads its value from a per-context source that the owner (ribbon or pane) sets when it turns auto-assign on, so only one value is stamped. |
| 3 | KTR5 | Repin Kelly.Revit.Logic; the ribbon assigners pass their own values | 2 | sub-issue; blocked by 1, 2 | The ribbon value-set commands and auto-assign toggles pass the ribbon's values to the changed services; behaviour unchanged. |
| 4 | KTR5 | Assigners pane: MVVM rows, per-project choices and modeless Revit calls | 4 | sub-issue | Pane view model with six labelled row view models (label, value list, icon buttons with tooltips, ribbon Context icons), Reset All at the bottom, choices kept per open project for the session, and an `ExternalEvent` dispatcher so the modeless pane can change the model. Replaces the `AssignerContext` mock-up. |
| 5 | KTR5 | Assigners pane: value lists load on project open/activate, Refresh, Service picks System | 2 | sub-issue; blocked by 4 | Lists reload when a project opens or becomes active, a Refresh button, and choosing a Service selects its matching System (ignoring case). |
| 6 | KTR5 | Assigners pane: Adopt, Add To Selected, Remove From Selected, Reset, Reset All | 4 | sub-issue; blocked by 1, 4 | The per-context write and read buttons for all six contexts, through the Logic services with the pane's value (spools through `AddElementsToSpool`, modules through `ModuleNumberElementService`). |
| 7 | KTR5 | Assigners pane: Auto-Assign toggle, one owner per context with the ribbon | 2 | sub-issue; blocked by 2, 3, 4; related KTR5-4064 | Turning auto-assign on in the pane switches the ribbon's off for that context and the other way round; the row and the ribbon icon show the owner. |
| 8 | KTR5 | Assigners pane: add a new value (Detailing Package, Line Number, Spool, Module) | 2 | sub-issue; blocked by 4 | Type a value that isn't in the project yet, for the four contexts; Service and System don't allow it. |

**Existing issues to link (Related):** KTR5-4064 (refuse to turn on auto-assign while the value is the default) to #7; KTR5-4780 (Spool Auto Set does nothing) and KTR5-3938 (Inherit All copies a picked element's contexts) to the parent.

## Unclear

None.

## Open questions

- The ribbon's Spool Number and Module Number auto-assign toggles do nothing today (KTR5-4780). Should the pane have auto-assign for those two contexts?

## Applied 2026-11-12

The maintainer answered the open question: no auto-assign for Spool Number and Module Number in the pane; their rows show the Auto-Assign button disabled (added to #7).

| # | Key | Relation |
|---|---|---|
| 1 | [KTRL5-180](https://linear.app/jhkelly-ktr/issue/KTRL5-180) | sub-issue; blocks KTR5-4826, KTR5-4829 |
| 2 | [KTRL5-181](https://linear.app/jhkelly-ktr/issue/KTRL5-181) | sub-issue; blocks KTR5-4826, KTR5-4830 |
| 3 | [KTR5-4826](https://linear.app/jhkelly-ktr/issue/KTR5-4826) | sub-issue; blocks KTR5-4830 |
| 4 | [KTR5-4827](https://linear.app/jhkelly-ktr/issue/KTR5-4827) | sub-issue; blocks KTR5-4828 to KTR5-4831 |
| 5 | [KTR5-4828](https://linear.app/jhkelly-ktr/issue/KTR5-4828) | sub-issue |
| 6 | [KTR5-4829](https://linear.app/jhkelly-ktr/issue/KTR5-4829) | sub-issue |
| 7 | [KTR5-4830](https://linear.app/jhkelly-ktr/issue/KTR5-4830) | sub-issue; related KTR5-4064 |
| 8 | [KTR5-4831](https://linear.app/jhkelly-ktr/issue/KTR5-4831) | sub-issue |

KTR5-4085 lost its estimate (the sub-issues roll up to 22 points) and is related to KTR5-4780 and KTR5-3938.
