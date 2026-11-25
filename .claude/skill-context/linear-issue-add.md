# linear-issue-add: Kelly facts

- Rules: `C:\repo\jhkweb\BuildConfigs\LINEAR.md` and `.claude\LINEAR-KTR.md` (already loaded in jhkweb sessions).
- Team hints beyond a named team: examples "KD", "Hasa", "the exporter"; the repository map is `linear-teams.md`; an item covering a whole Kelly major version goes to KTR5 or KTR4; the repository the session works in names its team in its `AGENTS.md`. Never default to one team: the workspace holds Kelly, Hasa and other teams.
- Estimate and priority rules above are the Kelly ones. Estimate by size on the Exponential scale: one line or label 1, one member or small fix 2, a tool or several files 4, several tools or layers 8; when 16 seems right use 8 and report that it needs `linear-issue-split-review`.
- Priority: Urgent when the app fails to start or install, or data is lost or written wrong; High when a tool gives wrong results or blocks a user; Medium for a requested Add or Change, or a Fix with a workaround; Low for internal work (refactoring, cleanup, tests, docs) and ideas.
- Labels, KTR5 only: one "5 - Feature" (the ribbon button or type; "Add-In Wide" for work across the add-in) and one "5 - Module" (Trade.All, Trade.Pipe, Trade.Duct, Trade.Contenter, Trade.Manager, Trade.Developer, Host). Use an existing feature label; never create one.
- Name Kelly Tools For Revit or KTR only in KTR* teams' issues. Say "Major Version 4" or "v4", never "Generation".
- The duplicate check and report mention the "missing feature label" case for KTR5.
