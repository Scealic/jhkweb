# linear-issue-split-review: Kelly facts

- Default scope: every open issue in every Kelly team, sub-teams included; Hasa skipped unless the user names it (then split from the text only and say so). KTR5 alone has about 160 open issues: one subagent per team, or per 100 issues of a big team.
- Scale: the Exponential scale (KTR5): the top is 16; pieces aim for 1 to 4 points. `linear-issue-estimate-update` proposes 16 for exactly the too-big issues.
- Signal examples: crosses layers ("Move the spool numbering to Logic and add a ribbon button for it"); v4 and v5 at once ("Fix pipe slope in both versions"); several tools ("Rework the tooltips of the PipeTrade tab": one per command or panel); several deliverables ("Add export to CSV and JSON, and validate the files"); a sweep (`OperationService.Run` migration, 66 sites: split by module, folder or namespace); a vague goal ("Refactor the Manager module").
- Indivisible: a rename with its callers, a type with its tests, README, Changelog and XML docs with the code they describe.
- Subagents search the repository: for KTR5/KTR4 the ribbon commands under `modules/`, for the lower layers `src/`, another layer's repository when the issue names it.
- Layer order across repositories, one piece per repository in that repository's team; each lower piece Blocks the one above it: Kelly-Windows-Data, Kelly-Windows, Kelly-Domain, Kelly-Revit-Logic, Kelly-Revit-UI, Kelly-Revit. Each upper piece says it needs the lower package packed and repinned.
- "Do the same in v4" is a standalone KTR4 issue Related to the KTR5 one, never a sub-issue.
- A sub-issue may sit in another team: use that for a layer piece of a goal owned by the add-in team.
- Labels: copy the original's "Type" label (Add, Change, Fix, Delete) and its function label.
- Report file: `C:\repo\jhkweb\Planning\Linear Splits\<yyyy-mm-dd> Linear Issue Splits.md` (add `HHmm` when the day already has one); issue links `https://linear.app/jhkelly-ktr/issue/<KEY>`. A root working document: commit just that path to the outer jhkweb repository, never push; commit again after adding "Applied <date>".
- Piece description footer: "Split from <ORIGINAL KEY> on <yyyy-mm-dd>."; "Where" lists `Repository: <repo>` plus project, `File.cs`, `TypeName.Member`, ribbon command. Original note: "Split on <date> into sub-issues <KEY>, <KEY>, … (split review)."
- Follow-ups to offer: `linear-issue-estimate-update` for pieces left low confidence, and `linear-issue-dependency-check` for the new pieces.
