---
name: linear-issue-estimate-update
description: Estimate, or re-estimate, every issue in every Linear team of the "jhkelly" workspace - read each issue (and, for the Kelly teams, the code it names in its repository under C:\repo\jhkweb), propose a point estimate on that team's scale, write the proposal to a dated report, and after the user approves, set the estimates in Linear. Use whenever the user asks to estimate, size, point, re-estimate or update the estimates of Linear issues, for all teams, one team, one project or a list of issues, or asks which issues have no estimate, even without saying "estimate".
---

# Estimate the Linear issues of every team

Setting an estimate changes Linear, which is shared: **never set or clear an estimate without the user's approval of the proposal in this conversation.** Everything before step 5 only reads.

## 1. Scope

Default: every team from `list_teams` (follow `cursor`), sub-teams included, and every issue that is **open** (status type `triage`, `backlog`, `unstarted` or `started`). Narrow it when the user names teams, a project, a label or issue keys. Done, Canceled and Duplicate issues keep their estimates: they record past work. Estimate them only when the user asks for closed issues too.

Teams and their code (repository backlog ↔ team table in `C:\repo\jhkweb\.claude\skills\kelly-backlog-update\SKILL.md`, "Linear-ready items"):

| Team key | Repository under `C:\repo\jhkweb` |
|---|---|
| KTR5 | Kelly-Revit-v5 (the add-in; items for all of v5) |
| KTRUI | Kelly-Revit-UI |
| KTRL5 | Kelly-Revit-Logic-v5 |
| KTR4 | Kelly-Revit-v4 (items for all of v4) |
| KTRL4 | Kelly-Revit-Logic-v4 |
| KW3 / KW2 | Kelly-Windows-v3 / Kelly-Windows-v2 |
| KWD3 / KWD2 | Kelly-Windows-Data-v3 / Kelly-Windows-Data-v2 |
| KWDC / KWDJ / KWDSS / KWDSL | Kelly-Windows-Data-Csv / -Json / -SqlServer / -Sqlite |
| KD | Kelly-Domain |
| HASA and its sub-teams | Another product, no code here: estimate from the issue text only, and mark every one "text only" |

A team not in this table (added since): estimate from the text only and say so in the report.

## 2. Find each team's scale

The connector does not show a team's estimation settings, so read the scale from the estimates already set: `list_issues` with `team`, `includeArchived: true`, `limit: 250`, `fields: ["estimate"]`, following `cursor`.

| Values seen | Scale | Allowed values |
|---|---|---|
| only 1, 2, 4, 8, 16 (and 0) | Exponential | 1, 2, 4, 8, 16 (KTR5 uses this, checked 2026-11-04) |
| 3, 5 or 13 among them | Fibonacci | 1, 2, 3, 5, 8, 13, 21 |
| 6, 7, 9 or 10 among them | Linear | 1 to 10 |
| shown with names XS, S, M, L, XL | T-shirt | XS 1, S 2, M 3, L 5, XL 8 |
| none | Unknown | ask the user: estimates may be off for the team (Team settings › Estimates), or use KTR5's exponential scale |

Zero is allowed only where the team already has a 0 estimate.

## 3. Estimate

Fetch the issues: `list_issues` per team with the state filter (one call per open state type, or none and filter on `statusType`), `fields: ["title","description","estimate","status","statusType","labels","priority","parentId","project"]`, `limit: 250`, following `cursor` until `hasNextPage` is false. Descriptions come back truncated; call `get_issue` for one when the truncated text is not enough to size it.

The volume is large (KTR5 alone holds several hundred open issues). Send one subagent per team, or per 150 issues of a big team, all in one message so they run in parallel, each with: the team, its repository path, its scale, the rubric below, the issue keys, and the instruction to **only read** (no `save_issue`) and to return one line per issue: `KEY<TAB>current<TAB>proposed<TAB>confidence (high/medium/low)<TAB>reason (one short clause)`. The subagent reads the issue, and for a Kelly team opens the files, types and tools it names in the repository (Grep / Glob there) to see how much code is involved.

### Rubric

Points measure the work of the Senior Software Developer with Claude Code, including what the repository rules demand: a failing test first (none in the v4 Revit repos), an NUnit test per member, `Author`/`Description` on every test, README, Changelog and XML docs for a public change, and the build in every configuration. On the exponential scale:

| Points | Typical work |
|---|---|
| 1 | A rename, a text or tooltip change, a constant, one small fix in one file whose test already exists; deleting dead code |
| 2 | A fix or change in one type with its tests; one ViewModel or command bug; a docs-only item |
| 4 | Several types in one repository, or one tool end to end; anything that needs an in-Revit test run (`*.RevitTests`, Revit 2024, add-in disabled) |
| 8 | Work across layers: a change in a lower layer that has to be packed and repinned up to Kelly-Revit; a new tool or service; a sweep over many files (for example 50 push buttons) |
| 16 | An architectural change, a migration over dozens of sites, the same change in v4 and v5 at once; anything larger: propose 16 and say it should be split into sub-issues |

On another scale take the nearest allowed value of the same size (Fibonacci: 1, 2, 3, 5, 8, 13; Linear: 1, 2, 4, 6, 8 then 10; T-shirt: XS, S, M, L, XL).

- **Parents:** an issue with open sub-issues gets no estimate of its own (Linear rolls the sub-issues up); estimate the sub-issues.
- **Can't tell:** an issue whose text is too thin to size (a title only, no matching code) gets the size its title suggests with confidence `low`; don't guess silently.
- **Already estimated:** re-estimate it too, and keep the current value unless the evidence clearly points elsewhere (the code turned out much larger or smaller, or the issue's scope changed). A person may have set it.

## 4. Report and ask

Write the proposal to `C:\repo\jhkweb\Linear Estimates\<yyyy-mm-dd> Linear Estimates.md` (add `HHmm` to the name when the day already has one):

- A summary table: team, open issues, newly estimated, changed, unchanged, skipped (parents, closed), total points proposed, text-only count.
- **Changes to existing estimates** first, in their own table (`Key | Title | Current | Proposed | Reason`), because these overwrite a value someone set.
- Then one table per team in the table-1 order: `Key | Title | Proposed | Confidence | Reason`, with the issue key as a link (`https://linear.app/jhkelly/issue/<KEY>`).
- Then the low-confidence issues, and the issues proposed at 16 that should be split.

It is a root working document: commit it to the outer jhkweb repo (just that path; never push). In chat give the summary table and the changes to existing estimates, and ask in `wrap_up` whether to apply all, only the new estimates, or with the user's changes. Then stop and wait.

## 5. Apply, after approval

For each approved issue call `save_issue` with `id` (the key) and `estimate` (the number; on a T-shirt scale the number behind the size) and nothing else. The calls are independent: send them in parallel, about 25 per message. Never clear an estimate (`null`) unless the user asked. A refused call usually means the team has estimates off or the value is not on its scale: collect those and report them, don't retry with another value.

## 6. Report

Per team: estimates set, changed, refused (with the error), and the points total. Add an "Applied <date>" line to the report file with those numbers and commit it again. The backlog files don't change: estimates live only in Linear.
