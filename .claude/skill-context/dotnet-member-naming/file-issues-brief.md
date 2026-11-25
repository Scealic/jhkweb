# Member naming check: Linear filing brief

The lead gives you either the **bugs** (a table of confirmed bugs with team, report and priority) or the **renames** (which reports and teams). Bugs: see "Bugs" at the end. Renames: you file the "Proposed rename issues" (R1, R2, …) of the pass reports in `C:\repo\jhkweb\Planning\Member Naming\<date> Pass <n> <layer>.md` as Linear issues (workspace "Virtual Construction", jhkelly-ktr), one issue per proposed R. Use the Linear MCP tools (load with ToolSearch: save_issue, save_comment, list_issues, list_issue_labels, list_teams). Never use PowerShell. Do not edit code, git or the reports.

Read first: `C:\repo\jhkweb\BuildConfigs\LINEAR.md` and `C:\repo\jhkweb\.claude\LINEAR-KTR.md`, and one first-pass issue as the model for style (KD-63 or KTRL5-140: `get_issue`).

## Maintainer decisions for this run (the lead fills these in; the standing rules in the skill always apply)

1. (the lead lists this run's decisions here, e.g. "rename `X` to `Y`; the Undo text changes to match")
2. Add-in push-button classes may be renamed even though the ribbon item id (from the class name) changes; users re-add shortcuts. Note "ribbon item id changes" in the issue.
3. **`Core` rule:** per Kelly-Revit-Logic-v5 `AGENTS.md` (KTRL5-149) a method name carries no Transaction/Tx/Operation suffix; whether it opens its own transaction is said in its XML docs; `…Core` is used only to tell twin methods apart (one opens a transaction, the other needs the caller's). Where a report suggests adding `Core` to a method that has no twin, change the suggestion to "document in XML docs that it needs the caller's transaction" (no rename). Keep `Core` suggestions only for real twins.
4. Do not use `UBIQUITOUS-LANGUAGE.md` for any term.
5. Serialized/Shown names keep their stored value unless the report says the shown text itself is wrong (then say the shown text changes).

## Every issue

- Team: the layer's team (below). State Backlog. Assignee "me".
- Title under ~80 chars, from the report's R title (backticks around dotted names).
- Description: "Found <date> by member naming check pass <n> (`Planning/Member Naming/<date> Pass <n> <layer>.md`, R<n>)." then the report's table for that R (Member | What it does | Suggested; keep Callers and Serialized/Shown notes), then a "## Goal" paragraph like the first pass: the renames with XML docs; tests renamed with `Author` reset to "Verified By Human On:"; README, Changelog and XML docs updated; every configuration builds (and tests, for the three lower layers); package packed (not for the add-in); note callers in the layers above that must follow after the repin.
- Labels: exactly one type label "Change" ("Delete" if the R only removes dead code); exactly one "Function" label from `list_issue_labels` (Architecture and services, Data and file I/O, Modeling and geometry, Views and graphics, Content and parameters, Tools, ribbon and UI, Updaters and project information, Code quality and cleanup, …; "Spools and welds", "Domain types", "Windows helpers" and "Process" are RETIRED; for spools use "Modeling and geometry"). Batched Style issues use "Code quality and cleanup".
- KTR5 issues also: one or more "5 - Feature" labels (the ribbon tools the R names; search `list_issue_labels` team "Kelly Tools For Revit 5" by name; "Add-In Wide" when it spans many tools) and the "5 - Module" labels (Trade.All, Trade.Pipe, Trade.Duct, Trade.Contenter, Trade.Manager, Trade.Developer, Host).
- Estimate (Exponential scale): 1 small, 2 typical, 4 for a large R with many callers. Priority 4 (Low).
- Before creating, `list_issues` in the team with a query on the main member name: if an open issue already covers the same rename, add a dated comment with the pass-2 detail instead of filing.
- Name "Kelly Tools For Revit"/KTR only in KTR5 issues.

Reply only with a table: report R | issue key (or "comment on KEY") | title | estimate. Then anything you could not file and why.

## Bugs

For each confirmed bug: read its row in the layer report ("Confirmed bugs"), open the code at file:line, and search the team (`list_issues`, query on the member name) for an open issue that already covers it; if one does, add a dated comment with the new evidence instead of filing. A new bug issue gets: state Backlog; a title naming the type or tool and the problem; a description with Where (repo, file, member), What was found, Steps to show it (the call and arguments, or the command and model), Expected, and "Found <date> by member naming check pass <n> (`Planning/Member Naming/<date> Pass <n> <layer>.md`)"; the priority from the table (1 Urgent, 2 High, 3 Medium, 4 Low); an estimate (1 for a one-line fix, 2 typical); exactly one type label "Fix"; one "Function" label; KTR5 also a "5 - Feature" and a "5 - Module" label; assignee "me". Set Related on the issues the report names. Do not file Major Version 4 twins (the v4 repos are not checked out); say "may also hold in v4" where the report does.

Reply with a table: bug | issue key (or "comment on KEY") | title | priority.
