# After action report: layer moves 2026-11-23

Plan: `LAYER-MOVES-PLAN-2026-11-23.md` (141 moves in 15 work packages). Linear project: [Layer Moves 2026-11-23](https://linear.app/jhkelly-ktr/project/layer-moves-2026-11-23-d2ea1c1a4146). Two implementation runs: the first from 11:20 on 2026-11-23 (35 agents, about 8.5 hours), and a follow-up overnight into 2026-11-24 (14 agents, about 4.8 hours) for the two packages the first run skipped.

## Result

| Package | Layer | Issue | Commits | Status |
|---|---|---|---|---|
| P1a enum guard | Kelly-Windows | KW3-61 | 495bc43 | Done |
| P1c text helpers | Kelly-Windows | KW3-62 | 64a4b45 | Done |
| P1d measurements and palettes | Kelly-Windows | KW3-63 | 3e83baa | Done |
| P1e collections and geometry | Kelly-Windows | KW3-64 | e20f514, review 8b96a69 | Done |
| P2 Domain source | Kelly-Domain | KD-110 | ac18bee | Done |
| P2a Assigner rules | Kelly-Domain | KD-108 | 7ad2feb | Done |
| P2b spool, support and view rules | Kelly-Domain | KD-109 | 50c0bb1, review 2753561 | Done |
| P3 Logic source | Kelly-Revit-Logic | KTRL5-206 | ecb4946 | Done |
| P3a Assigner database code | Kelly-Revit-Logic | KTRL5-204 | c8c83a5, review a105c6b | Done |
| P3b tool database code | Kelly-Revit-Logic | KTRL5-205 | 6db840e, review d77d086 | Done (follow-up run) |
| P4 UI source | Kelly-Revit-UI | KTRUI-53 | 9e3b424, review a9e1336 | Done |
| P5a receive single-module types | Kelly-Revit | KTR5-4941 | 5f22bef3 | Done |
| P5 prompts | Kelly-Revit | KTR5-4942 | 1b5d341c | Partial: the Yes/No prompts (#9, #11) wait on KW3-65 |
| P5 Assigner pane switch | Kelly-Revit | KTR5-4943 | 75e740f5, review 569bfa3a | Done (follow-up run) |
| P5 tools switch | Kelly-Revit | KTR5-4944 | 6bc45e8e, 37157827, reviews b19293ad, e0af1f4e | Done |

14 of 15 packages done, 1 partial. Packages built: Kelly-Windows 3.26.1123.1152, Kelly-Domain 1.26.1123.1213, Kelly-Revit-Logic 5.26.1123.1418 then 5.26.1123.2045, Kelly-Revit-UI 1.26.1123.1432 then 1.26.1123.2048. Kelly-Revit-v5 pins UI 1.26.1123.2048; all 21 configurations build with 0 errors. Not installed.

| Repository | Commits | Files | Lines |
|---|---|---|---|
| Kelly-Windows-v3 | 6 | 44 | +1,657 / −92 |
| Kelly-Domain | 5 | 53 | +1,239 / −417 |
| Kelly-Revit-Logic-v5 | 7 | 99 | +3,213 / −840 |
| Kelly-Revit-UI | 5 | 31 | +204 / −703 |
| Kelly-Revit-v5 | 9 (plus 4dbab8aa, not this run's) | 125 | +2,248 / −1,638 |

## What moved

- **Kelly-Windows:** one generic enum guard (about 40 inline copies gone), pluralising, identifier parse preamble, invariant number text, pasted path cleaning, inches per foot, count-and-percentage label, status colours, numeric-or-text compare, the `TryCreate` collecting loop, a generic suspension scope and the 2D annotation arrangement arithmetic with `ArrangeAction`.
- **Kelly-Domain:** Assigner rules (spool name, `JHK` parameter name, addable definitions, service-to-system lookup, `TryResolve`), the PCF path rule, straight length summary, weld numbering, hanger spacing, Stratus names, duplicate layout point ids. `ScopeTypeExtensions` deleted; `ModuleCreatorSettings` and `SpoolCreatorSettings` moved up to the add-in, their rules kept here as `ModuleCreatorPrefixOptions`.
- **Kelly-Revit-Logic:** the Assigner pane and combo box database code (document cache `Values`, project string lists, shared parameter reads and writes, service removal, filter rule pairing), `RunAsOneEdit`, `StepTimingLog` (was `ManagerTimingLog`), the support timing types, field trim markers, the ductwork-in-scope query, level choice and itemize rules, the hanger button lookup and the shared insulation elevation.
- **Kelly-Revit (up from Kelly-Revit-UI):** ten single-module types (selection filters, `ConnectorPickTools`, `FamilySymbolWrapper`, `TitleBlockExtensions`, the level and project location combo-box items and builders); one shared base for the Detailing Package and Line Number value-set commands.

The Revit condition holds: nothing naming an Autodesk type or reading the model reached Kelly-Windows, Kelly-Windows-Data or Kelly-Domain.

## Not done

- #9 and #11 (four Yes/No prompts in Spool Sheet Open, Project Filters Delete, item number replace and field trim): `PromptRequest` has no Yes/No answer. Waits on KW3-65; KTR5-4942 stays In Progress.
- `App.cs` startup messages still call `TaskDialog` directly: out of scope (KTR5-4784 to KTR5-4786).

## Behaviour you may notice

- Messages in the modules now go through `UserPrompt`: same text, title prefix on, no icon.
- Nothing else is meant to change; every move was checked line by line by a reviewer.

## Bugs found, not fixed

- [KTR5-4946](https://linear.app/jhkelly-ktr/issue/KTR5-4946): the hanger options window stores the combo box position as the button index, so Place Hangers can pick the wrong hanger or none.
- [KTR5-4945](https://linear.app/jhkelly-ktr/issue/KTR5-4945) (already filed): the ribbon's Service Remove clears fabrication parts.
- [KD-111](https://linear.app/jhkelly-ktr/issue/KD-111): Stratus hidden product ranges could come from `CategoryTypeRecord.IsValidForStratus`.
- `RemovePrefixAndNormalizeWhiteSpace` (was `GetShownTypeName`) cuts the prefix without checking it is there; kept and pinned by tests.

## Tests

- Kelly-Windows and Kelly-Domain: all tests pass in Net481, Net80 and Net100 (Kelly-Windows 866).
- Kelly-Revit-Logic in Revit 2024: the touched fixtures, 133 of 134 (the one needs a JHK Product Range binding and is inconclusive by design). The full Logic suite was not run.
- Kelly-Revit-UI in Revit 2024: 96 of 96.
- Kelly-Revit `Core.Tests` in Revit 2024, unfiltered: 1,665 of 1,669 (the 4 need the add-in started).

## What went well

- Bottom-up packing and repinning worked without a stale-package problem; every pin is this run's package of the layer below.
- `check-rules.pl` ended as it started (0 hits in sections 1 to 4).
- The reviewers caught real faults: stale tests, a missing guard, untested branches.

## What went wrong

- **Two packages skipped.** Each sub-agent prompt also carried the user's last chat message ("What other questions do you have…"). The P3b and P5-assigner agents treated it as their whole task and did nothing, so Logic was packed without P3b and a second run was needed. Fixed in the skill: the workflow's run context now says a relayed user message never cancels or narrows a stage.
- **Pushes during the run.** Kelly-Windows and Kelly-Domain reached `origin/develop` around midday, and Logic, UI and the first Kelly-Revit commit at 17:02 (the daily push task). No stage pushed.
- **ricaun timeouts.** Two filtered `Core.Tests` runs of about 1,000 tests hit the 45-minute adapter timeout although each test takes milliseconds; the unfiltered run took 2 minutes. Worth a look.
- `insert-changelog.pl` wrote CRLF into an LF `Changelog.md`; the agent normalised it.

## To check

- Push `develop` bottom-up when ready: Kelly-Revit-Logic (3 commits), Kelly-Revit-UI (2), Kelly-Revit-v5 (8).
- Install and smoke-test the Assigner pane, Spool Manager, Place Hangers and the Arrange commands, which carry most of the moved code.
- `Kelly-Revit-v5/.gitignore` has an uncommitted `HANDOFF.md` line (left as the user's).
