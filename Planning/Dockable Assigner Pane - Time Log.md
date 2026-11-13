# Dockable Assigner Pane - Time Log

Time Claude Code spends on the Kelly Assigners dockable pane ([KTR5-4085](https://linear.app/jhkelly-ktr/issue/KTR5-4085), Kelly-Revit-v5 `modules/Trade.All/Commands/Assigners/DockablePane`), set against an estimate of the same work done by hand. One row per work session; how each column is worked out is at the end.

## Totals

312 minutes of Claude Code time (5 h 12 min) in 17 sessions on 2026-11-12; about 79 hours of a senior .NET developer's time by hand.

| | Hours | Cost |
|---|---|---|
| By hand (senior .NET developer at \$100/hr) | 79 | \$7,900 |
| With Claude Code: Claude usage (API-equivalent, the sessions below) | 5.2 | \$73.03 |
| **Difference** | **73.8** | **\$7,826.97** |

The Claude cost of the sessions below is \$73.03. To 15:09 the whole session cost \$74.85 at API rates; the sessions logged to then cost \$60.64, and the rest went to work this log does not count, such as the startup-exception fix, the work log and the pushes. The maintainer's own time supervising and checking in Revit is in neither column.

**Rate:** 39 points of issues in about 249 minutes, roughly 6 minutes a point; with the shell, design, checks, installs and this log, 312 minutes.

## By issue

| Issue | Points | State | Claude (min, est.) | By hand (h, est.) | Claude cost | By-hand cost | Work |
|---|---|---|---|---|---|---|---|
| KTR5-4085 (shell) | – | Done | 7 | 4 | \$1.75 | \$400 | Real dockable pane, registration, show/hide button, icon |
| Design and split | – | – | 15 | 1.5 | \$3.75 | \$150 | Interview, decisions recorded, split into 8 sub-issues |
| KTR5-4827 | 4 | Done | 24 | 8.5 | \$6.00 | \$850 | MVVM rows, per-project choices, modeless request dispatcher |
| KTR5-4828 | 2 | Done | 10 | 4 | \$2.50 | \$400 | Value lists, Refresh, Service picks System |
| KTR5-4831 | 2 | Done | 9 | 4 | \$2.25 | \$400 | Add a new value, validated with the Kelly.Domain structs |
| KTR5-4829 | 4 | Done | 16 | 6 | \$4.00 | \$600 | Adopt, Add To Selected, Remove From Selected for every row |
| KTRL5-180 | 4 | Done | 25 | 6.5 | \$6.25 | \$650 | Logic writers take a value source; packed and repinned |
| KTRL5-181 | 2 | Done | 10 | 5 | \$2.50 | \$500 | One owner per assigner selection; packed and repinned |
| KTR5-4830 | 2 | Done | 10 | 3.5 | \$2.50 | \$350 | Pane Auto-Assign owns its context |
| KTR5-4826 | 2 | Done | 11 | 2.5 | \$2.75 | \$250 | Repins; ribbon toggles, Reset and Add Selected respect the owner |
| KTR5-4064, KTR5-4780, KTR5-4832 | 4 | Done | 10 | 3 | \$2.50 | \$300 | Turned up by the pane work: ribbon auto-assign refuses the default (2), Spool and Module auto-set kept disabled (1), contract test runs in any UI state (1) |
| KTR5-3938 | 4 | Done | 26 | 5 | \$3.29 | \$500 | Adopt All, on the ribbon and in the pane |
| KTR5-4836 | 1 | Done | 18 | 4 | \$3.63 | \$400 | More padding, one Auto-Assign All toggle, buttons under the rows |
| KTR5-4838 | 1 | Done | 24 | 4 | \$3.29 | \$400 | Red message and border for a typed value that is not valid; one-line message, spool numbers of any category |
| KTRUI-39 | 1 | Done | 7 | 2.5 | \$1.67 | \$250 | `RevitUserPrompt` asked for a verification checkbox the dialog did not have; packed and repinned |
| KTR5-4839 | 2 | Done | 9 | 3 | \$3.06 | \$300 | Hide and Isolate on every row, the ribbon's twelve commands on the same definition |
| KTR5-4840 | 1 | Done | 3 | 1 | \$1.02 | \$100 | All buttons as row-sized icons under their columns |
| KTR5-4841 | 1 | Done | 8 | 1 | \$2.03 | \$100 | Value boxes 200 px wide, drop-down as wide as its widest item |
| KTR5-4842 | 2 | Done | 29 | 6 | \$10.36 | \$600 | Floating window sized to its UI; the first build failed the add-in's startup, fixed the same day |
| Checks, installs and pushes | – | – | 37 | 3.5 | \$7.20 | \$350 | Final in-Revit run 281/281, pane shown at startup, hand check, installs for 2024, pushes |
| This log | – | – | 4 | 0.5 | \$0.73 | \$50 | Human time and cost columns |
| **Total** | **39** | | **312** | **79** | **\$73.03** | **\$7,900** | |

Points and states from Linear on 2026-11-12, at 17:10.

## Open items (as of 17:10)

- Every pane issue is Done after the maintainer's checks in Revit 2024.
- Kelly-Revit-v5's last four commits (`67497e76`, `80aa4041`, its README commit, `c4e6846f`) are not pushed.
- 2025 and 2026 still have the morning's pane build.
- The new tests have not run in Revit.
- KD-90 (what a spool number is) waits on a decision.

## Sessions

### 2026-11-12

| Start | End | Issues | Claude (min) | By hand (h, est.) | Claude cost | By-hand cost | Work |
|---|---|---|---|---|---|---|---|
| 08:45 | 08:52 | KTR5-4085 | 7 | 4 | \$2.52 | \$400 | Found the stub; maintainer decision "keep ribbon", recorded on KTR5-4085; 11 tests written; pane made a WPF `Page`; provider, registration, show/hide command, button and `AssignerPane` icon added; built for 2024, 2025 and 2026; docs updated; committed Kelly-Revit-v5 `e6dc2f6f`. The lookup of the stub before 08:45 is not counted. |
| 08:52 | 09:31 | KTR5-4085, KTR5-4827 | 39 | 10 | \$4.93 | \$1,000 | Started the in-Revit test run (pane and contract tests); design interview (goal, contexts, features, independence, writers in Logic, auto-assign ownership, refresh, layout, new values, per-project memory, icons), recorded on KTR5-4085; split into KTRL5-180, KTRL5-181, KTR5-4826 to KTR5-4831; KTR5-4827 built test-first (row and pane view models, choice store, project key, request dispatcher and handler, `AssignerContext` bound as the row view), built for 2024 to 2026, committed Kelly-Revit-v5 `60e2c764`. |
| 09:31 | 10:00 | KTR5-4828, KTR5-4831, KTR5-4829 | 29 | 11 | \$9.49 | \$1,100 | KTR5-4828 (value lists, Refresh, Service picks System; `cd8be450`), KTR5-4831 (add a new value, validated with the Kelly.Domain structs; `88352b6c`, `58f6e63c`), KTR5-4829 part (Adopt, Remove From Selected, Spool and Module Add To Selected; `66d9ea63`); two in-Revit runs of the `Assigner*` tests (149/151, then 178/178 after fixing two tests); filed KTR5-4832. |
| 10:00 | 10:22 | KTRL5-180, KTR5-4829 | 22 | 6 | \$4.26 | \$600 | KTRL5-180 in Kelly-Revit-Logic-v5 (writers take a value source, `ProcessSelectedElements` with a service; `34fa70c`), tests first, built for 2024 to 2026; in-Revit runs: Kelly-Revit `Assigner*` 189/189 (KTR5-4829 handler), Logic element services 72/72. |
| 10:22 | 10:28 | KTRL5-180, KTR5-4826 | 6 | 1 | \$1.95 | \$100 | Packed Kelly.Revit.Logic 5.26.1112.1026 (KTRL5-180, Done), repinned and packed Kelly.Revit.UI 1.26.1112.1026, repinned Kelly-Revit-v5 (KTR5-4826 part); all built for 2024 to 2026. |
| 10:50 | 10:56 | KTR5-4829 | 6 | 3 | \$1.79 | \$300 | Maintainer decision on Service Add To Selected; wired Service, System, Detailing Package and Line Number through the Logic writers with the pane's value (`AssignerPaneServiceElementService` composite); tests first, built for 2024 to 2026, committed `ffde41c4`; started the in-Revit run; fixed this table (blank lines had split it). Start estimated from the first Linear comment. |
| 11:07 | 11:47 | KTR5-4829, KTRL5-181, KTR5-4830, KTR5-4826, KTR5-4064, KTR5-4780, KTR5-4832 | 40 | 14 | \$12.31 | \$1,400 | KTR5-4829 results (186/186); KTRL5-181 (one owner per assigner selection; 112/112 Logic tests; package 5.26.1112.1129, UI 1.26.1112.1129, repinned); KTR5-4830 (pane Auto-Assign owns its context) and KTR5-4826 (ribbon toggles take it back, Reset and Add Selected respect the owner); installed v5 for 2024; also KTR5-4064, KTR5-4780 and KTR5-4832, which the pane work turned up; committed Kelly-Revit-v5 `97477d0d`. In-Revit 220/223 (3 test faults fixed, not rerun). |
| 11:50 | 12:13 | KTR5-4780, KTR5-4832, KTR5-4773 | 23 | 2 | \$5.21 | \$200 | Final in-Revit run, 281/281 (`Assigner*` and `AddInContractTests`), KTR5-4780 and KTR5-4832 Done; pane shows when Revit starts (`6c5c58a9`, pushed); time summary; pushed six repos' develop; KTR5-4773 checked (already Done, follow-ups noted); reinstalled v5 for 2024. Gaps between turns not counted, so the start and end are approximate. |
| 12:35 | 13:01 | KTR5-3938 | 26 | 5 | \$3.29 | \$500 | Adopt All, on the ribbon and in the pane (`AssignerElementValues`, `AllAssignerAdoptCommand`, pane `AdoptAllCommand`), tests first, committed `557fa9e9`; in-Revit run 280/286 (6 inconclusive tests, replaced by a direct `ActiveProject` test, `4a7d6527`); installed for 2024. The startup-exception fix before it (`64584c7c`) is not logged here. |
| 13:01 | 13:14 | KTR5-4836 | 13 | 3 | \$2.99 | \$300 | Started Revit 2024 for the hand check; pushed Kelly-Revit-v5; more padding, one Auto-Assign All toggle, tests first, built for 2024 to 2026, committed `26b51638`; installed for 2024 (5.26.1112.1313). |
| 13:14 | 13:27 | KTR5-4836 | 13 | 1.5 | \$1.66 | \$150 | Hand check passed: KTR5-4085, KTR5-4826 to KTR5-4831, KTR5-3938 and KTR5-4064 marked Done with evidence; buttons moved under the rows instead of at the pane's bottom (`9983ef1a`, KTR5-4836 Done); installed for 2024 twice (5.26.1112.1313, 1322). |
| 13:27 | 13:38 | KTR5-4838, KTRUI-39 | 11 | 4 | \$2.62 | \$400 | KTR5-4838: a red message and border for a typed value that is not valid (`5cd0b6b0`). KTRUI-39 (the exception the maintainer hit): `RevitUserPrompt` asked Revit for a verification checkbox the dialog did not have; fixed test-first in Kelly-Revit-UI `c670410`, packed 1.26.1112.1334, repinned in Kelly-Revit-v5 `e58f7293`. |
| 14:33 | 14:57 | KTR5-4838, KD-90 | 24 | 3 | \$2.81 | \$300 | Installed for 2024 (5.26.1112.1433) when Revit was closed; confirmed the pane loads for every install type (it is in Trade.All); the invalid-value message made one short line under the row, full format in its tooltip (`40ca700a`); spool numbers with any category accepted, as Spool Create makes them (`abdcb1f2`); filed KD-90 for the `SpoolNumber` struct; installed for 2024 (1445, 1457). The wait for Revit to close (13:38 to 14:33) is not counted. |
| 14:57 | 15:09 | KTR5-4839, KTR5-4840 | 12 | 4 | \$4.08 | \$400 | KTR5-4839: Hide and Isolate on every row, as the ribbon's, with the ribbon's twelve commands moved onto the same per-context definition and filter domain (`dd64f57d`); KTR5-4840: the All buttons as row-sized icons under their columns (`cdf8f2c8`); installed for 2024 (1500, 1507). |
| 15:09 | 15:13 | – | 4 | 0.5 | \$0.73 | \$50 | This log: the human time and cost columns, and the rows from 13:14 on. |
| 15:13 | 15:42 | KTR5-4841, KTR5-4842 | 29 | 6 | \$7.35 | \$600 | Pushed Kelly-Revit-UI and Kelly-Revit-v5; KTR5-4841: value boxes 200 px wide (`67497e76`), hand check passed, KTR5-4838 to KTR5-4841 and KTRUI-39 Done; KTR5-4842: floating window fitted to the UI (`80aa4041`). That build failed the add-in's startup (`API_ERROR`, then an `SEHException` crash). Found in the journal and fixed (`c4e6846f`: no layout work while Revit registers the pane; floating told by the window's owner); installed (1532), and the journal showed a clean start. |
| 17:02 | 17:10 | KTR5-4842 | 8 | 1 | \$5.04 | \$100 | The pane still opened tall once; listed Revit's windows (the floating window is a WPF window owned by the main window) while the maintainer floated it again: 600 by 300, "shrunk down to just the right size"; KTR5-4842 Done; this log. |

## How the columns are worked out

Added 2026-11-12; the layout (totals first, by issue, open items, sessions by day) and the column names since the evening of 2026-11-12.

- **Start, End:** Pacific time. A start is taken from the first recorded event (the Linear state change or the first tool call), so it can be a few minutes late. Waits for the maintainer's answers count, because the session stays open; gaps between turns do not.
- **Issues:** the Linear issues the session worked on, so the by-issue table can be totalled from the sessions.
- **Claude (min):** Claude Code's working time in the session. The in-Revit test runs (about 2 to 30 minutes each) ran in the background while other work went on, so their time is not added.
- **By hand (h, est.):** an estimate of the hours a senior .NET developer would need to do the row's work by hand to the same standard: tests first, XML docs, Changelog and README, builds for 2024, 2025 and 2026, and the Linear updates.
- **Claude cost:** the API-equivalent cost of the session's tokens in that window, from the session's transcript, at the rates in the `work-log` skill's `rates.tsv` (Opus 5.5: \$4 input, \$20 output, \$0.20 cache read, \$5 or \$8 cache write per million tokens). It leaves out the maintainer's time supervising and the plan's flat seat price.
- **By-hand cost:** By hand (h, est.) at \$100 an hour (total package).
- **By issue:** the log records sessions, so the minutes, hours and cost per issue are estimates that split each session by the work listed in it. The morning sessions (to 11:47) spread their \$37.25 over their 149 minutes (\$0.25 a minute); later sessions split each session's own cost by its minutes. The cost therefore follows the minutes, not each issue's own tokens.
