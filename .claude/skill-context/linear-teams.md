# Kelly Linear workspace: shared reference for the Linear skills

Read through the "Project context" lookup of `linear-issue-add`, `-dependency-check`, `-done-check`, `-estimate-update`, `-hygiene-check`, `-info-review`, `-split-review`, `linear-team-estimate-check` and `linear-project-suggest`. Change a team, a repository or a shared rule here, once. Per-skill facts are in `<skill-name>.md` beside this file. The generic scope and subagent pattern are in `C:\Users\childebran\.claude\skills\_shared\linear-scope.md`.

## Workspace and rules

- Workspace "Virtual Construction", `https://linear.app/jhkelly-ktr` (the key `jhkelly-ktr`; `jhkelly` redirects).
- The backlog rules are `C:\repo\jhkweb\BuildConfigs\LINEAR.md` (every team) and `C:\repo\jhkweb\.claude\LINEAR-KTR.md` (the KTR teams); both are loaded in jhkweb sessions. A repository's `AGENTS.md` names its team.
- The maintainer (assignee of every issue the skills create, `assignee: "me"`) is Chris Hildebran, the Senior Software Developer.
- Linear connector: `mcp__fd1c18e3-af80-4615-a5f5-1b0747b31de2__*`. Subagents load `list_issues`, `get_issue`, `list_comments` with `select:mcp__fd1c18e3-af80-4615-a5f5-1b0747b31de2__list_issues,mcp__fd1c18e3-af80-4615-a5f5-1b0747b31de2__get_issue,mcp__fd1c18e3-af80-4615-a5f5-1b0747b31de2__list_comments`; if the names have changed, they search `list_issues get_issue list_comments`. The `linear-issue-add` skill loads `save_issue,list_issues,list_issue_labels,list_teams` the same way.
- Shell rule for every subagent brief: never use PowerShell (Bash and the Read, Grep and Glob tools only).

## Teams and their code

Check the teams with `list_teams` first; the user may have added or renamed some.

| Team key | Repository under `C:\repo\jhkweb` | Layer | Major Version |
|---|---|---|---|
| KWD3 / KWD2 | Kelly-Windows-Data-v3 / Kelly-Windows-Data-v2 | 1 | 5 / 4 |
| KWDC / KWDJ / KWDSS / KWDSL | Kelly-Windows-Data-Csv / -Json / -SqlServer / -Sqlite | 1 (format libraries) | both |
| KWDE | Kelly-Windows-Data-Excel (format library; repository and team created 2026-11-18) | 1 (format libraries) | both |
| KWDSS (also) | VCS-Database-General-Schema, VCS-Database-Content-Schema (stored procedures, tables, columns; since 2026-11-06) | – | both |
| KW3 / KW2 | Kelly-Windows-v3 / Kelly-Windows-v2 | 2 | 5 / 4 |
| KD | Kelly-Domain | 3 | 5 only |
| KTRL5 / KTRL4 | Kelly-Revit-Logic-v5 / Kelly-Revit-Logic-v4 | 4 | 5 / 4 |
| KTRUI | Kelly-Revit-UI | 5 | 5 only |
| KRDE | Kelly-Revit-Data-Exporter (standalone exporter app; created 2026-11-06) | – | both |
| FDT | Fabrication Data Tools (created 2026-11-12): parent team of PSU, CDED, CDEB and CDEC; no repository of its own (added 2026-11-19, `list_teams` shows no separate CDE team any more) | – | – |
| PSU | Product Size Updater (renamed from Fabrication Kitchen Sink, key FKS, on 2026-11-23; standalone WPF/MVVM app for fabrication content: syncs SQL product entries to the ITM product lists; team created 2026-11-18) ← `Fabrication-Tools` (GitHub `jhkweb/Fabrication-Tools`; `src/FabricationTools.Core`, `src/FabricationTools`; app named Fabrication Tools since 2026-11-18) | – | – |
| CDE / CDED / CDEB / CDEC | Component-Data-Editor (editor for the VCS Content database's component catalog; created 2026-11-12). Since 2026-11-13 three sub-teams, one per project folder: CDED (Component Data Editor Desktop) ← `src/ComponentDataEditor.Desktop` (WPF), CDEB (Component Data Editor Blazor) ← `src/ComponentDataEditor.Blazor` (Blazor Server), CDEC (Component Data Edit Core) ← `src/ComponentDataEditor.Core` (shared). Work across the repo stays in CDE | – | – |
| KTR5 / KTR4 | Kelly-Revit-v5 / Kelly-Revit-v4 (the add-in; items for all of that major version; KTR5 also takes the lower v5 layers when an issue names them) | 6 | 5 / 4 |

- The Kelly teams are all of the above. **Skip the Hasa team and its sub-teams** (another product, no code here; decision of 2026-11-04) unless the skill or the user says otherwise. Hasa's projects likewise belong to another product.
- A new Kelly team not in this table: find its repository from its name, or ask. The workspace holds teams for more than one product (Kelly teams, Hasa and others), so a skill never defaults to one team.
- In a repository, the ribbon commands are under `modules/` (KTR5, KTR4) and the code of the lower layers under `src/`.
- **Open** means status type `triage`, `backlog`, `unstarted` or `started`. Done, Canceled and Duplicate issues are closed.
- Layer order, lowest first: Kelly-Windows-Data, Kelly-Windows, Kelly-Domain, Kelly-Revit-Logic, Kelly-Revit-UI, Kelly-Revit (the add-in). A lower layer's package must be packed and repinned before an upper layer can use it. v4 and v5 are separate products. The v4 Revit layers have no tests (their `AGENTS.md` overrides TDD); every other repository requires a test per member, and a public-surface change needs its `README.md` and `Changelog.md` update.
- Issues closed before 2026-11-09 without an estimate are exempt from the estimate rule and are left as they are.

## Volumes

KTR5 alone holds about 160 open issues (several hundred counting every state), so runs split it: about 100 issues per subagent for the done, information and split checks, about 150 for estimates. Haiku will do for the text-only Hasa teams.

## Writing to Linear

- Assign every issue you create to the maintainer (`assignee: "me"`).
- Write calls for different issues are independent: send them in parallel, about 25 per message (except where a skill says one at a time). A refused call: collect it and report it; don't retry with something else.
- Wrap dotted names (`Kelly.Windows`) and file names in backticks, or Linear turns them into web links.
- Say "Major Version 4" or "v4", never "Generation". Name Kelly Tools For Revit or KTR only in the issues (and projects) of the KTR* teams.
- Never abbreviate names in text the skills write.
