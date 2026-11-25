# linear-issue-done-check: Kelly facts

- Default scope: every open issue in every Kelly team, sub-teams included, Hasa skipped. KTR5 alone has about 160 open issues; one subagent per team, or per 100 issues of a big team.
- Evidence is the local `develop` branch of each repository (`git -C <repo> branch --show-current`; if not on `develop`, use `git -C <repo> show develop:<path>` and `git -C <repo> log develop`, and say so). No `git fetch`.
- The ribbon commands are under `modules/` for KTR5/KTR4, `src/` for the lower layers.
- An issue moved from an old backlog (footer "From `…/Quick-Backlog.md` › …") asks for exactly what that line said.
- Repositories require tests (every repository except the v4 Revit layers, see its `AGENTS.md`); a missing test makes the issue Partial. A public-surface change also needs its `README.md` and `Changelog.md` update. Check the `Changelog.md` headings for the change.
- Add "built, not installed" or "not tested in Revit" to the Done comment where the evidence shows that. Can't tell covers work outside the code: a Revit model, a test run, an install, a release.
- Version wording: a Done issue naming a Revit year, a version (v4 or v5) or a layer the change did not reach is downgraded.
- Comment format for the Done comment: "Marked Done by the is-done check of <yyyy-mm-dd>: <rationale>. Evidence: <commit hashes, files, tests>." Example rationale: "`PipeSlopeCommand` now skips unsloped systems and `PipeSlopeCommandTests` covers it (commit `a1b2c3d`)."
- Example table row key: `KD-12`.
- Follow-up: Partial issues are often worth finishing next; vague Can't tell issues go to `linear-issue-information-review`.
