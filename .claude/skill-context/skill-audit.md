# Context for the skill-audit skill

- Skills folder audited: `C:\Users\childebran\.claude\skills` (the user's personal skills; part of the `~/.claude` git repository, so `git -C C:/Users/childebran/.claude log -- skills` gives the history). Commit skill fixes there, one message per kind of change, and only the `skills` paths; never push.
- The framework every skill follows: `C:\Users\childebran\.claude\skills\_shared\skill-framework.md`.
- Report folder: `C:\repo\jhkweb\Planning\Skill Cost Audits`; file name `<yyyy-mm-dd> Skill Audit.md`. Earlier reports there are named `Skill Cost Audit` and `Skill Structure Review`; the newest of any of them is the baseline.
- Commit only the new report to the jhkweb root repository: `git -C C:/repo/jhkweb add -- "Planning/Skill Cost Audits/<file>"`, then commit that path. Never push.
- Project terms that must stay out of skills (one per line in `terms.txt`): Kelly, KTR, JHK, jhkweb, Hildebran, Hasa, Virtual Construction, jhkelly-ktr, fd1c18e3, `C:\repo`. The project specifics belong in `C:\repo\jhkweb\.claude\skill-context\<skill-name>.md`.
- Also check, on a rename: the scheduled tasks in `C:\Users\childebran\.claude\scheduled-tasks`, `C:\Users\childebran\.claude\CLAUDE.md`, the jhkweb `.claude` files, `BuildConfigs\SHARED-AGENTS.md` and `BuildConfigs\LINEAR.md`, and memory in `C:\Users\childebran\.claude\projects\C--repo-jhkweb\memory` (memory files may hold the user's own uncommitted changes: edit, don't commit).
- Large inputs seen: day transcripts (work-log) and whole Linear teams (linear-issue-* skills).
- The savings report is the private Claude Code Savings report of the work-log skill.
