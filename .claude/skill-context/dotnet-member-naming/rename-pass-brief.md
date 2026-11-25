# Rename pass: shared brief

You apply already-decided member renames to ONE layer of a .NET stack under C:\repo\jhkweb, then repin the direct consumers and fix their calls. The maintainer authorized this work ("do anything you need to regarding renaming"). Use Bash (Git Bash) and the Read/Edit/Write tools; NEVER PowerShell in any form. Do NOT touch Linear (the lead agent handles issues). Do NOT push. Do NOT install the add-in.

## Read first

- `C:\repo\jhkweb\BuildConfigs\SHARED-AGENTS.md` (rules for these repos) and the layer repo's `AGENTS.md`. Key rules: work on `develop` only, commit (no push), no `Co-Authored-By` trailer; one type per file named after it; no non-XML comments (`//`); XML docs on what you touch; every test's `Author` is exactly `"Verified By Human On:"` and a test you change loses any date (`"Verified By Human On:yyyy.mm.dd"` → `"Verified By Human On:"`); each `Description` says what the test verifies; TDD (a failing test first) for any BEHAVIOUR change; public-surface changes update `README.md`, `Changelog.md` and XML docs in the same commit; Changelog headings `## <date> (package <version>): <title> (<issue keys>)`.
- The issues to apply: the lead gives you the keys. Read each with the Linear tool `get_issue` (read only) and `list_comments` (decisions are in comments; comments win over the description). Do not rely on `C:\repo\jhkweb\UBIQUITOUS-LANGUAGE.md` (out of date until the renames land).

## How to rename safely

1. Build the full old→new map from the issues before editing. For each new name, check it does not already exist as a member in the same type or as an extension on the same receiver (grep declarations across C:\repo\jhkweb\Kelly-* repos except obj/bin and the v4 `*-v2`/`*-v4` repos). A clash that compiles can silently re-bind a call (overloads, instance-vs-extension): resolve it by a distinct name or explicit parameters, and say what you chose.
2. Rename with word boundaries (perl `\b...\b` over .cs/.xaml/README files; never inside `Changelog.md` history). Rename files and types named after old names with `git mv`. Test method/class names that contain an old member name follow it (`Old_` and `OldTests`).
3. Names that are serialized or shown (JSON keys, data-file columns, settings keys, XAML bindings, ribbon item names, transaction names shown in Undo, report headers) keep their stored value unless the issue says otherwise: use the appropriate attribute (e.g. `[JsonProperty("Old")]`) and add a test that an old file still reads.
4. XML `cref`s that become ambiguous (CS0419) must name the overload. Compare warnings before/after: no NEW warnings.
5. Skip an item only if doing it would change behaviour in a way the issue does not ask for, or needs a decision nobody made; list every skipped item with the reason.

## Build, test, pack

- Configurations: `-c Net481|Net80|Net100` for Kelly-Windows-Data, Kelly-Windows, Kelly-Domain and the format libraries; `-c 2024|2025|2026` for the Revit layers. Always pass `-p:GeneratePackageOnBuild=false` except when packing.
- Tests: the three lower layers and the format libraries run their tests in ALL three configurations before packing (`dotnet test <tests csproj> -c <cfg> -p:GeneratePackageOnBuild=false`). Revit layers: build tests only (in-Revit runs are the lead's job); Kelly-Revit-UI also runs `test/Revit.UI.Tests` for 2024.
- Pack: one version for all configurations of a repo: `-p:VersionCalculated=<v> -p:FileVersionCalculated=<v>`, `<v>` = `<MajorVersion>.26.1111.<HHmm now, no leading zero>` (MajorVersion = the repo's own, see its `Version.Build.props` / last package name in `C:\Repo\NugetPackages`). A same-minute rebuild fails with KTR0003: use a later minute. Kelly-Revit-Logic-v5 and Kelly-Windows-Data need `-p:SolutionName=<solution name>` when building a project outside its solution; building the `.slnx` is simplest.
- Repin: change the version property in each consumer's `Directory.Packages.props`, then fix the consumer's calls to the renamed members (in src AND tests), build all its configurations (and run its non-Revit tests), add a Changelog entry. If the consumer is a format library or tool that is itself a package and is NOT one of the six layers (Kelly-Windows-Data-Csv/-Json/-Sqlite/-SqlServer, Kelly-Revit-Data-Exporter), pack it too in this pass. The next layer up (one of the six) is repinned and its calls fixed, but NOT packed: its own pass packs it.
- Mass CS0234 errors = a pin names a version not in `C:\Repo\NugetPackages`. "doesn't support net8.0"/NU1202 = stale `obj/project.assets.json`: delete that obj folder and restore again. If restore 401s on the Telerik feed, pass `"-p:RestoreSources=https://api.nuget.org/v3/index.json;C:\repo\NugetPackages;<local Telerik folder>"`.

## Commit and report

- One commit per repo on `develop`, message naming every issue key it works on, no trailer. Leave unrelated files alone (check `git status` first; do not sweep in other changes).
- Report back (no preamble, under ~60 lines): per repo the commit hash, the package version packed (if any), configurations built, tests run with pass/fail counts; the final old→new map (compact); clashes and how you resolved them; skipped items with reasons; anything the lead must decide or check (e.g. renames that change stored or shown text).
