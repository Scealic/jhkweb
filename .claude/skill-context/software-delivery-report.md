# Context for the software-delivery-report skill

- Linear workspace: "Virtual Construction" (`jhkelly-ktr`); team keys and repositories are in `linear-teams.md` beside this file.
- Readers: the department director and the CEO. Artifact title: `Software Delivery Report <period>`; the first report's artifact is `https://claude.ai/artifact/Mj38xerFwxNc5cEMVocNJa`.
- Files in `software-delivery-report/` beside this file: `configuration.json` (workspace name, product lines with spoken names, teams, areas, adoption note and dates) and `template.html` (the approved layout, a copy of the first report of 2026-11-17, with the eyebrow "Revit Software Development · JH Kelly" and the byline "Chris Hildebran, Senior Software Developer"). `build_report.py` finds them from `C:\repo\jhkweb` upward, or with `--context-folder`.
- Script: `C:/Users/childebran/.claude/skills/software-delivery-report/scripts/build_report.py`.
- Reports folder: `C:\repo\jhkweb\Planning\Reports\Software Delivery Report <file suffix>.html`; first report `Software Delivery Report 2026-11-17.html`.
- Commit the report to the jhkweb root repository (`git -C C:/repo/jhkweb`), never push. The scheduled task "software-delivery-report-monthly" runs from `C:\repo\jhkweb`; the delivery report is for the department director and the CEO.
- Skip the Hasa team and its sub-teams. Add a new team to its product line in `configuration.json`.
- Product line groups: version-5 (KTR5, KTRL5, KTRUI), libraries, component-data-editor, product-size-updater, version-4, exporter.
- Refer to Chris Hildebran as "Senior Software Developer". The backlog moved to Linear on 4 November 2026; estimating started 2026-11-09.
