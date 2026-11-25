# linear-issue-estimate-update: Kelly facts

- Scope: every team from `list_teams`, sub-teams included. Unlike the other Linear skills this one **includes Hasa** and its sub-teams: estimate them from the issue text only (Haiku subagents will do) and mark every one "text only". A team not in `linear-teams.md`: text only, say so.
- Code-reading teams: for a Kelly team the subagent opens the files, types and tools the issue names in the team's repository (Grep and Glob).
- Scale: KTR5 uses the Exponential scale (1, 2, 4, 8, 16 and 0), checked 2026-11-04. For a team with no estimates yet, ask the user or use KTR5's exponential scale.
- Volume: KTR5 alone holds several hundred open issues; one subagent per team, or per 150 issues of a big team.
- Rubric: points measure the work of the Senior Software Developer with Claude Code, including what the repository rules demand: a failing test first (none in the v4 Revit repositories), an NUnit test per member, `Author` and `Description` on every test, README, Changelog and XML docs for a public change, and the build in every configuration.

| Points | Typical work |
|---|---|
| 1 | A rename, a text or tooltip change, a constant, one small fix in one file whose test already exists; deleting dead code |
| 2 | A fix or change in one type with its tests; one ViewModel or command bug; a docs-only item |
| 4 | Several types in one repository, or one tool end to end; anything that needs an in-Revit test run (`*.RevitTests`, Revit 2024, add-in disabled) |
| 8 | Work across layers: a change in a lower layer that has to be packed and repinned up to Kelly-Revit; a new tool or service; a sweep over many files (for example 50 push buttons) |
| 16 | An architectural change, a migration over dozens of sites, the same change in v4 and v5 at once; anything larger: propose 16 and say it should be split into sub-issues |

- Report file: `C:\repo\jhkweb\Planning\Linear Estimates\<yyyy-mm-dd> Linear Estimates.md` (add `HHmm` when the day already has one). Issue links: `https://linear.app/jhkelly-ktr/issue/<KEY>`. It is a root working document: commit it to the outer jhkweb repository (just that path; never push). After applying, add an "Applied <date>" line and commit again.
- Closed issues keep their estimates; issues closed before 2026-11-09 without one are left as they are.
