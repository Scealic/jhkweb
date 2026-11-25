# Context for the repository-activity-report skill

- Project folder: `C:\repo\jhkweb`; each subfolder that contains `.git` is an independent repository with its own GitHub remote.
- Since 2026-11-02 the root itself is also a git repository (branch `main`, no remote) that tracks only the working documents at that level. Report its commits as a repository named `jhkweb (root docs)`; skip `fetch` and the PR steps for it.
- Repository names carry their own major version (since 2026-10-27): `Kelly-Windows-Data-v2`/`-v3`, `Kelly-Windows-v2`/`-v3`, `Kelly-Domain`, `Kelly-Revit-Logic-v4`/`-v5`, `Kelly-Revit-UI`, `Kelly-Revit-v4`/`-v5`, plus BuildConfigs, the format libraries, Fabrication-Tools and the two VCS schema repositories (Kelly-Revit-Data-Exporter was merged into Fabrication-Tools and deleted on 2026-11-25).
- The VCS schema repositories (`VCS-Database-General-Schema`, `VCS-Database-Content-Schema`) use `production`, not `main`, as their default branch: use `origin/production` for them in steps 4 and 5.
- `gh` is installed but not logged in (as of the skill's writing); PR data comes from `refs/pull/*`.
- The skill's report window default (yesterday and today) was written for a two-day look; examples in the argument hint use dates of 2026-09.
