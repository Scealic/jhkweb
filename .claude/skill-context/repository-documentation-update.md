# Context for the repository-documentation-update skill

- Project folder: `C:\repo\jhkweb` (sibling git repositories, each with `develop` and `main`; the Major Version 4 repositories sit under `KTR4\` in some checkouts). The Kelly repositories, 18 in all, keep a `Changelog.md`.
- Scripts run from `C:\repo\jhkweb`: `REPOSITORY_ROOT=C:/repo/jhkweb REPOSITORY_GLOBS='*/ KTR4/*/' bash C:/Users/childebran/.claude/skills/repository-documentation-update/drift.sh`; `perl C:/Users/childebran/.claude/skills/repository-documentation-update/stamp.pl` finds `C:\repo\jhkweb\.claude\skill-context\repository-documentation-update\configuration.json` (root, package folder `C:\Repo\NugetPackages`, globs, which repositories say `(version X)` or `(build X)`, and which repository packs which package id; since 2026-11-06 the Major Version 4 repositories are in `KTR4`). Add a new repository to that table.
- The rule: `C:\repo\jhkweb\BuildConfigs\SHARED-AGENTS.md`, "Documentation". The docs-check mod: `C:\Users\childebran\.claude\mods\General\docs-check`.
- Heading format: `## <date> (package X)`, `(version X)` for Kelly-Revit-v4 and Kelly-Revit-v5, `(build X)` was Kelly-Revit-Data-Exporter's, merged into Fabrication-Tools on 2026-11-25. The VCS schema repositories (VCS-Database-General-Schema, VCS-Database-Content-Schema) have no packages: their headings are the date alone.
- Coverage numbers belong to the `dotnet-test-coverage-check` skill.
- Do not build Kelly-Revit-v4 just to get a version: a v4 build installs and makes v4 active. Kelly-Revit-v5 builds do not install unless `-p:InstallAddin=true`; never pass it from this skill.
- README outline: `C:\repo\jhkweb\Planning\Documentation\README-OUTLINE.md`. Never add `Co-Authored-By` to a commit that changes a README (README-OUTLINE.md, "Conventions"). Commit on `develop`.
- Machine: no Python or Node; Bash and Perl only.
- Changelog entries name the Linear key the commit names.
