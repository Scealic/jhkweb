# linear-issue-information-review: Kelly facts

- Default scope: every open issue in every Kelly team, sub-teams included. Hasa is skipped (decision of 2026-11-04). KTR5 alone has about 160 open issues: one subagent per team, or per 100 issues of a big team.
- Where check: the repository (or the team implies it) plus a project, file, type, member, ribbon command or tool, data file or build file. The `(Command)` project an issue sits in counts as naming the tool.
- Steps to reproduce: the Revit year (2024/2025/2026) and the model or kind of model; applies to issues labelled Fix (label group "1 - Type") or old issues whose title starts with "Fix" or "Bug".
- Wrong team: the code now lives in another repository, for example after a layer move; the description often says "this item belongs in the … backlog"; KD-10 was the first, checked 2026-11-04.
- Issues moved from the old backlog files on 2026-11-04 (footer "From `…/Quick-Backlog.md` › …") usually pass Where and Problem. The older KTR5 issues (keys below about 4500, labels like "Meeting -> Review", titles like "Add - …") are often title-only.
- Subagents search the repository: for KTR5/KTR4 the ribbon commands under `modules/`, for the lower layers `src/`; `git -C <repo> log --oneline -i --grep=<keyword>` for evidence of done or obsolete.
- Example draft: "`PipeSlopeCommand` sets the slope of every selected pipe; nothing limits it to sloped systems".
- Description footer: "Information reviewed <yyyy-mm-dd> (from the code and the Senior Software Developer's answers)."; keep an existing "From `…/Quick-Backlog.md`" footer above it. Where layout: `Repository: <repo>` plus `File.cs`, `TypeName.Member`, ribbon command; steps list "(Revit <year>, <model>)".
