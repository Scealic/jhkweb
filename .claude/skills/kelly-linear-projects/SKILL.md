---
name: kelly-linear-projects
description: Suggest Linear projects for the Kelly repositories under C:\repo\jhkweb from the open items in each repository's Quick-Backlog.md, show them as a list grouped by repository, and after the user approves, create them in Linear (workspace "jhkelly") and put the matching Linear issues in them. Use whenever the user asks to suggest, plan, propose, create, set up or refresh Linear projects for the repos, to group backlog items or Linear issues into projects, or asks which projects a repo or team should have, even without saying "Linear project".
---

# Suggest and create Linear projects for the Kelly repositories

Each repository backlog maps to a Linear team (the table in `C:\repo\jhkweb\.claude\skills\kelly-backlog-update\SKILL.md`, "Linear-ready items"). Its items have already been moved to Linear as issues, and each backlog line ends ` — Linear: <KEY-123> (<date>)`. A **project** groups related issues around one goal. This skill proposes those groups, and after approval creates them and files the issues in them.

Creating projects in Linear is outward-facing: **never create, rename or delete a project without the user's approval of the list in this conversation.**

## 1. Gather

Run these together:

- **Teams:** the Linear connector's `list_teams`. The user may have renamed or added teams since the mapping table was written. The connector cannot create teams.
- **Existing projects:** `list_projects` with `includeArchived: true` and `fields: ["name","teams","status","summary"]`. Follow `cursor` until `hasNextPage` is false. KTR5 already holds about 140 projects, **one per command** (`<Tool> (Command)`, for example "Layout Point Export (Command)"), plus "Scope (User Control)", "Application Service" and similar. The Hasa team's projects belong to another product: leave them out.
- **Open backlog items** per repository, with their function heading, type and Linear key:

```bash
cd /c/repo/jhkweb; for f in */Quick-Backlog.md; do n=$(grep -c '^- \[ \]' "$f"); [ "$n" -gt 0 ] || continue; echo "=== $f ($n open)"; awk '/^## /{h=$0} /^### /{s=$0} /^- \[ \]/{t=$0; k=""; if (match(t, /Linear: [A-Z0-9]+-[0-9]+/)) k=substr(t, RSTART+8, RLENGTH-8); sub(/ — .*/,"",t); print h" / "substr(s,5)": "substr(t,7)" ["k"]"}' "$f"; done
```

Also look in `C:\repo\jhkweb` for plans that span repositories (for example the layer-moves reports, the data format libraries plan) and note which backlog items they cover.

## 2. Suggest

Group the open items into **theme projects**: a goal several issues serve, that can be finished and marked Completed.

- **Don't duplicate.** No new project whose goal an existing one already covers. A fix to one tool goes in that tool's existing `(Command)` project, not a new per-tool project. When a theme cuts across many tools (a review that found bugs in a dozen tools), one theme project is fine; say that its issues could go in the per-command projects instead.
- **Cross-repository work is one project with several teams**, listed under its lead repository: the same bug in v4 and v5 (one issue per team), a layer move (the source layer, the target layer and the layers that are repinned), an item that appears in every repository (the "TODO notes" sweep). The first team is the lead team.
- **No project for one issue**, and none for a repository with nothing open. Name those repositories under "No project suggested" with the reason.
- **No team, no project:** BuildConfigs, Kelly-Revit-Data-Exporter, the VCS schemas and the index's Other have no Linear team, and a project needs at least one. Re-check `list_teams` before saying so.
- **Names:** short, the goal or theme in Title Case, no team key and no "(Command)" suffix (that suffix marks the per-tool projects). Follow the user's naming rules: "Major Version 4" or "v4", never "Generation"; name Kelly Tools For Revit / KTR only in projects whose teams are the Kelly-Revit* ones.

## 3. Show the list grouped by repository

Before creating anything, show one heading per repository in layer order: Kelly-Revit-v5, Kelly-Revit-v4, Kelly-Revit-Logic-v5, Kelly-Revit-Logic-v4, Kelly-Revit-UI, Kelly-Domain, Kelly-Windows-v3, -v2, Kelly-Windows-Data-v3, -v2, the format libraries. Then "Across repos", then "No project suggested". Under each heading give a table:

| Project | Teams | What goes in it |
|---|---|---|

"What goes in it" names the backlog items (by short title) that the project would hold. Close with the defaults below and ask, in `wrap_up`, whether to create them. Then stop and wait.

## 4. Create, after approval

Create only the projects the user approved, with the changes they asked for. Call `save_project` once per project. Calls are independent, so send them in parallel:

- `name`; `setTeams` (all its teams) and `leadTeam` (the first one).
- `summary`: one sentence, the goal (under 255 characters).
- `description`: the goal, then the backlog items it covers as a list, then a footer `---` and ``From the Quick-Backlog.md files of <repos> (projects suggested <date>).`` Wrap dotted names (`Kelly.Windows`) in backticks, or Linear turns them into web links.
- `state: "Backlog"` and `lead: "me"` unless the user said otherwise. Give no dates or priority unless asked.

Then **file the issues**: for each backlog item a project covers, read its Linear key from the line and set the issue's project with `save_issue` (`id` = key, `project` = project name). An item with no key is not in Linear yet: list it and leave it. An issue already in another project: ask before moving it.

## 5. Report

List each created project with its link (from the `save_project` result), its teams and the number of issues filed, and name any item that was skipped and why. The backlog files don't change: projects live only in Linear. If the user wants the project named in the backlog too, that is a `kelly-backlog-update` change, so ask first.
