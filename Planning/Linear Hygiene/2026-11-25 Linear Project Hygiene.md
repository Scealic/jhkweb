# Linear Project Hygiene, 2026-11-25

First run of the `linear-project-hygiene-check` skill. Scope: all 204 projects of the Kelly teams (no Hasa projects exist): 50 open (26 Backlog, 24 started) and 154 closed (151 Completed, 3 Canceled). Issue counts come from one `list_issues` call per project; the open and started counts of the flagged projects were confirmed with direct calls.

The 34 projects created earlier today (`linear-project-suggest`) pass every check except two status flags.

## Summary

| Flag | Projects | Proposed fix |
|---|---|---|
| lead | 12 (all closed) | Set the lead to Chris Hildebran |
| summary | 21 (5 open, 16 closed) | Write a summary for the 5 open ones; leave the closed ones |
| teams | 0 | – |
| status | 2 | Move to In Progress |
| finished | 2 | Move to Completed |
| empty | 0 open | – |
| stale | 4 | Listed; ask |
| closed-open | 0 | – |
| single | 5 | Listed; ask |
| per-feature | 10 | Ask: rename (a tool being built) or label the issues and complete |
| name | 9 (all closed) | Listed; leave the closed ones |
| overdue | 0 | – |
| overlap | 1 possible | Ask |

## Mechanical fixes

### status: Backlog project with a started issue → In Progress

| Project | Issues | Started issue |
|---|---|---|
| Dead Code Deletion (`P-KTR5-219`) | 9 open | [KD-130](https://linear.app/jhkelly-ktr/issue/KD-130) (In Review) |
| Unit Test Backfill (`P-KTR5-188`) | 62 open | [KTRL5-225](https://linear.app/jhkelly-ktr/issue/KTRL5-225) (In Progress) |

### finished: In Progress with every issue closed → Completed

| Project | Issues |
|---|---|
| Project Session (Service) (`P-KTR5-27`) | 12, all completed or canceled |
| Duct QA Mirror (Command) (`P-KTR5-111`) | 5, all completed |

### summary: open projects without a summary → write one

| Project | Issues | Proposed summary |
|---|---|---|
| Auto Updater Configurations (`P-KTR5-160`) | 4 (3 open) | Agree and set the configuration of every auto and manual updater. |
| Family Instance End Swap (Command) (`P-KTR5-165`) | 1 open | Build the Family Instance End Swap command. |
| Pipe Offset Create (Command) (`P-KTR5-166`) | 2 open | Build the Pipe Offset Create command for lateral, vertical and rolling offsets. |
| Element Select By Context (Command) (`P-KTR5-167`) | 1 open | Build the Element Select By Context command. |
| Dockable Assigner System (`P-KTR5-168`) | 37 (7 open) | Replace the assigner ribbon panels with the dockable Assigners pane. |

The 16 closed projects without a summary (the old per-command projects, `General` and the `Tool - …` projects from before 2026-11-04) are left as they are.

### lead: closed projects led by no one or by a second account → Chris Hildebran

- No lead: Component/Product Code Quality Assurance (Command) (`P-KTR5-162`), Stratus Package Quality Check View Creator? (`P-KTR5-164`), Document Saved (Event Handler) (`P-KTR5-170`), Reload Data (Command) (`P-KTR5-171`).
- Lead "Chris Hildebran (Outlook)", a second user account: `P-KTR5-1`, `P-KTR5-3` to `P-KTR5-9` (the oldest projects, all closed and empty).

All twelve are closed, so the fix only tidies the record.

## For a decision

### per-feature: open projects named per tool

| Project | Issues | Note |
|---|---|---|
| Family Instance End Swap (Command) (`P-KTR5-165`) | 1 open | single; a tool being built? |
| Pipe Offset Create (Command) (`P-KTR5-166`) | 2 open | stale; a tool being built: rename to "Pipe Offset Create" and add [KTRL5-45](https://linear.app/jhkelly-ktr/issue/KTRL5-45), [KTRL5-46](https://linear.app/jhkelly-ktr/issue/KTRL5-46), [KD-38](https://linear.app/jhkelly-ktr/issue/KD-38) |
| Element Select By Context (Command) (`P-KTR5-167`) | 1 open | single, stale |
| Project Session (Service) (`P-KTR5-27`) | 0 open | finished |
| Detailer View 3D Create (Command) (`P-KTR5-52`) | 1 open | single, stale |
| Spool Creator V2 (Command) (`P-KTR5-98`) | 6 open | a tool being built; see overlap |
| Duct QA Mirror (Command) (`P-KTR5-111`) | 0 open | finished |
| Stratus Detailing Package Views Create With User Interface (Command) (`P-KTR5-120`) | 1 open | single, stale |
| Valve Tag Assign (Idea) (Command) (`P-KTR5-129`) | 1 open | single; an idea, not bounded work |
| Duct QA Length (Command) (`P-KTR5-153`) | 1 open | nearly done |

Proposed: a project that builds a new tool keeps its project with the suffix dropped (Pipe Offset Create, Spool Creator V2, and Family Instance End Swap and Element Select By Context if they are new tools). For the rest, label the open issue with its feature and complete the project.

### stale: In Progress, nothing started, no issue updated in 14 days

Pipe Offset Create (Command), Element Select By Context (Command), Detailer View 3D Create (Command), and Stratus Detailing Package Views Create With User Interface (Command). Each issue was last updated on 2026-11-09. Proposed: move them back to Backlog, or settle them with the per-feature decision above.

### single: open projects with one issue

Family Instance End Swap (Command), Element Select By Context (Command), Detailer View 3D Create (Command), Stratus Detailing Package Views Create With User Interface (Command), and Valve Tag Assign (Idea) (Command). All are covered by the per-feature decision.

### overlap (possible)

- Spool Creator V2 (Command) (`P-KTR5-98`, 6 open) and Spool And Module Manager Fixes (`P-KTR5-199`, 24 open). The first builds the new version of Spool Creator; the second fixes the current Spool and Module tools. They are probably separate goals. Check whether any Spool Creator issue in the second belongs in the first.

### name: closed projects with old naming

`Stratus Package Quality Check View Creator?`, `Support Tag Manager Command Old (41)`, `41 - Support Tag Manager Command Old` and the six `Tool - …` projects (`P-KTR5-3` to `P-KTR5-8`). All are closed and hold no issues. Proposed: leave them as they are.

## Applied

Nothing yet.

---
Projects checked 2026-11-25 with `linear-project-hygiene-check`.
