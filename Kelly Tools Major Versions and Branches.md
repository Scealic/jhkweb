# Kelly Tools For Revit: major versions and branches

Kelly Tools For Revit (KTR) is released in **major versions**: Major Version 4 is the one in use, and Major Version 5 is being built (short forms v4 and v5; called generations, Gen4 and Gen5, until 2026-10-26). Each repo under the add-in also has **its own major version**, set by `<MajorVersion>` in its `.csproj`, and since 2026-10-27 the repo and folder name end in it: KTR v4 is built from Kelly-Windows-Data-v2, Kelly-Windows-v2, Kelly-Revit-Logic-v4 and Kelly-Revit-v4; KTR v5 from Kelly-Windows-Data-v3, Kelly-Windows-v3, Kelly-Domain, Kelly-Revit-Logic-v5, Kelly-Revit-UI and Kelly-Revit-v5.

## Which repo to work in

Every repo works on `develop`; the folder name is the repo name.

| Layer | KTR v4 (current) | KTR v5 (next) |
|---|---|---|
| Kelly-Windows-Data | `Kelly-Windows-Data-v2` (MajorVersion 2) | `Kelly-Windows-Data-v3` (3) |
| Kelly-Windows | `Kelly-Windows-v2` (2) | `Kelly-Windows-v3` (3) |
| Kelly-Domain | – (not in v4) | `Kelly-Domain` (1) |
| Kelly-Revit-Logic | `Kelly-Revit-Logic-v4` (4) | `Kelly-Revit-Logic-v5` (5) |
| Kelly-Revit-UI | – (not in v4) | `Kelly-Revit-UI` (1) |
| Kelly-Revit (the add-in) | `Kelly-Revit-v4` (4) | `Kelly-Revit-v5` (5; its modules build as 1, see below) |

These repos have one line and serve every KTR major version from it:

| Repo | Branch | Major Version |
|---|---|---|
| Kelly-Windows-Data-Csv, -Json, -SqlServer, -Sqlite (format libraries) | `develop` | their own Major Version 1, used by v4 now and by v5 later |
| Kelly-Revit-Data-Exporter | `develop` | 1; it writes the data files every KTR major version reads |
| BuildConfigs | `develop` | all |
| VCS-Database-General-Schema, VCS-Database-Content-Schema | `develop` (released through `production`) | all |

- **Fix what users run in the KTR v4 repos**; build new features in the v5 repos.
- History: until 2026-10-27 the v4 repos were branches of the v5 repos (`main-v2` in the two Windows repos, `main-v4` in the two Revit repos), checked out as worktrees; the v5 repos were then named without a suffix (Kelly-Revit, Kelly-Revit-Logic, Kelly-Windows, Kelly-Windows-Data). The old branches stay on the v5 repos' remotes as a read-only archive: don't commit to them.
- Never commit to `main`: it is updated through develop→main pull requests by the maintainer.
- Don't create other branches.
- **Both KTR major versions on disk:** the repos are sibling folders, so both are checked out at once. Only Kelly-Revit builds install anything, so only it needs the install guard. Builds in `Kelly-Revit-v5` don't install (warning `KTR0004`; `-p:InstallAddin=true` installs), so they can't replace the v4 add-in; the guard is the jhkweb root `Directory.Build.targets`.

## How the KTR major versions differ

| | KTR v4 | KTR v5 |
|---|---|---|
| Layers | Kelly-Windows-Data → Kelly-Windows → Kelly-Revit-Logic → Kelly-Revit (four repos) | adds Kelly-Domain and Kelly-Revit-UI (six repos) |
| Add-in | one assembly, `Kelly.Revit.dll` | a host plus one module DLL per ribbon tab (`Kelly.Revit.Trade.*`) |
| Data | CSV data files in `C:\Program Files\JH Kelly\Kelly Tools For Revit\Data`, written by Kelly-Revit-Data-Exporter; no SQL Server | the same CSV data files, no SQL Server (since 2026-10-30; `SQL-to-CSV Migration Plan - v5.md`) |
| Unit tests | Kelly-Windows-Data, Kelly-Windows and the exporter; Kelly-Revit-Logic and Kelly-Revit have none (check by building 2024–2026) | every layer, including in-Revit tests |
| Revit years | 2024, 2025, 2026 | 2024, 2025, 2026 |

## Version numbers

A project that sets `<MajorVersion>` in its `.csproj` (`<Generation>` until 2026-10-26) is versioned **`MajorVersion.yy.MMdd.HHmm`**, the build time with the repo's major version in front, by BuildConfigs' `Version.Build.props`. A project without one is versioned `yy.M.d.HHmm` and its build warns `KTR0002`; with `-p:RequireMajorVersion=true` the build fails instead. For example, `4.26.1022.1411` is Major Version 4, built 2026-10-22 at 14:11. Leading zeros are dropped, so 5 January at 09:58 is `4.27.105.958`.

| Projects | `<MajorVersion>` | Versions |
|---|---|---|
| Kelly-Windows-Data-v2, Kelly-Windows-v2 | `2` | `2.yy.MMdd.HHmm` |
| Kelly-Windows-Data-v3, Kelly-Windows-v3 | `3` | `3.yy.MMdd.HHmm` |
| Kelly-Revit-Logic-v4, Kelly-Revit-v4 | `4` | `4.yy.MMdd.HHmm` |
| Kelly-Revit-Logic-v5, Kelly-Revit-v5 host | `5` | `5.yy.MMdd.HHmm` |
| Kelly-Domain, Kelly-Revit-UI, format libraries, exporter | `1` | `1.yy.MMdd.HHmm` |

- The package name doesn't carry the major version (`Kelly.Revit.Logic.2024`); the version does.
- Older `26.x` versions sort above every `1.x`–`5.x` in NuGet, so **every Kelly package is pinned by exact version**. Never use a floating or minimum version.
- To give every project of one release the same version, pass `-p:VersionCalculated=<v> -p:FileVersionCalculated=<v>`.
- The product version adds the commit the build came from: `4.26.1026.826+96f28450…` (Windows file properties, and the add-in's startup log).
- Packing the same version twice (two builds in one minute) fails with `KTR0003` instead of replacing the package; `-p:OverwritePackage=true` allows it.
- Every project that imports `Version.Build.props` sets `<MajorVersion>` (the Kelly-Revit-v5 modules each set `5` once), so since 2026-10-30 `RequireMajorVersion` defaults to `true`: a project without one fails to build with `KTR0002`. `-p:RequireMajorVersion=false` turns that back into a warning for a one-off build.
