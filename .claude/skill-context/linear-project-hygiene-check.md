# linear-project-hygiene-check: Kelly facts

- Rules: `C:\repo\jhkweb\BuildConfigs\LINEAR.md` ("Labels and projects": projects only for bounded work with an end; a feature or module is a label) and `C:\repo\jhkweb\.claude\LINEAR-KTR.md` (never a per-tool project in KTR5).
- Scope: every Kelly team in `linear-teams.md`; skip the Hasa team and its sub-teams and their projects.
- Maintainer (lead of every project): Chris Hildebran, `lead: "me"`.
- Per-feature suffixes (the old one-per-command projects, Completed since 2026-11-04): `(Command)`, `(Application Cache)`, `(Document Cache)`, `(Event Handler)`, `(Service)`, `(Command Service)`, `(User Control)`. An open one is flagged; its issues get the "5 - Feature" and "5 - Module" labels instead.
- Naming: Title Case, no team key, no shorthand, never "Generation"; name Kelly Tools For Revit or KTR only in projects whose teams are all KTR* teams.
- Stale period: 14 days.
- Statuses are shared by the workspace: In Progress is `b9bcd6ab-02ec-4771-9b9b-21d4a2f0bd28`, Backlog is `7a5bda07-3268-49dd-a92d-13058c6aafc0`. On 2026-11-25 one of eight parallel status writes was dropped; a retry with the status id worked.
- Report file: `C:\repo\jhkweb\Planning\Linear Hygiene\<yyyy-mm-dd> Linear Project Hygiene.md`; commit just that path to the jhkweb root repository (`git -C C:/repo/jhkweb add` the file); never push. Commit again after applying.
