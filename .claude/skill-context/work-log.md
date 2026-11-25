# Context for the work-log skill

## Person, product and paths

- Author: Chris Hildebran; role title "Senior Software Developer" (decision of 2026-11-04; never "developer"). Product line in the summary and Linear report headers: `Kelly Tools For Revit · Chris Hildebran · detail in [[<yyyy.mm.dd> Work Log Of Chris Hildebran]]`.
- Project folder: `C:\repo\jhkweb` (sibling git repositories, plus the root repository `jhkweb (root docs repo)`, which holds working documents).
- Notes folder (Obsidian vault Notes-JHKelly): `C:\repo\chrishildebran\Notes-JHKelly\yyyy\MM - MonthName\dd\` (for example `2026\11 - November\05\`; one folder per day since 2026-11-05). File names: `yyyy.mm.dd Work Log Of Chris Hildebran.md`, `... Work Summary Of ...`, `... Claude Code Savings Of ...`, `... Linear Report Of ...`. Never commit or push Notes-JHKelly; write no copy into `C:\repo\jhkweb`.
- Examples to copy: work log `C:\repo\chrishildebran\Notes-JHKelly\2026\11 - November\12\2026.11.12 Work Log Of Chris Hildebran.md`; work summary `...\2026\11 - November\02\2026.11.02 Work Summary Of Chris Hildebran.md`.
- Hourly rate for the savings comparison: \$100/hr (total package). Time log with its own by-hand estimate: `C:\repo\jhkweb\Planning\Dockable Assigner Pane - Time Log.md` (Dockable Assigner work).
- Decisions of 2026-11-03: savings and cost never go in the work log, only in the private Savings report; a one-page Work Summary for the manager's manager is written last. Decision of 2026-11-11: the Linear report is a separate file, the work log keeps a one-line pointer, and the report has no clock times except the SLA table's Breaches At column.
- Sizes seen: a day's transcripts ran to 316 MB on 2026-11-04; the digest ran to 230 KB on 2026-11-12. The Artifact listing's "updated" dates lagged on 2026-11-12 (it showed 10-30 for an artifact published that day). The v5 release notes are a Claude Doc.
- The scheduled task "work-log-for-today" runs this skill from `C:\repo\jhkweb`.

## Linear

- Workspace "Virtual Construction" (`jhkelly-ktr`); issue url prefix `https://linear.app/jhkelly-ktr/issue/`; example link `[KTRL5-129](https://linear.app/jhkelly-ktr/issue/KTRL5-129)`; range example "KTRL5-80 to 88". Rules: `C:\repo\jhkweb\BuildConfigs\LINEAR.md`. Teams table: `C:\repo\jhkweb\.claude\skill-context\linear-teams.md`.
- Link the keys with: `perl <skill>/scripts/link-keys.pl --teams C:/repo/jhkweb/.claude/skill-context/linear-teams.md --url https://linear.app/jhkelly-ktr/issue/ <the four files>` (or set `LINEAR_TEAMS_FILE` and `LINEAR_ISSUE_URL`).
- A team with no cycle breaks `BuildConfigs/LINEAR.md` (a new team gets cycles when it is created).
- Backlog rule breaks to list under New Issues: no priority, no type or function label, no estimate, 16 points or more and not split.

## Scripts

- Facts script: `C:\repo\jhkweb\.claude\skill-context\work-log\day-facts.sh <day> [--commits-only]` (run with `bash`). It covers `C:\repo\jhkweb`, its sibling repositories and `KTR4\*`; commits per repository, Changelog headings, `.nupkg` files in `C:\Repo\NugetPackages`, Kelly package pins changed in `Directory.Packages.props` or `.csproj`, add-in manifests (`C:\ProgramData\Autodesk\Revit\Addins\<year>\Kelly Tools For Revit*.addin*`) and their DLL times, the Markdown test logs, `%LOCALAPPDATA%\Kelly Unit Test Logs\errors.txt`, Revit journals of the day (`%LOCALAPPDATA%\Autodesk\Revit\Autodesk Revit <year>\Journals`), instruction, skill and memory files, and loose ends.
- Build scripts of the project, whose failed calls the digest also lists: `BUILD_COMMAND_PATTERN='kbuild\.sh|revit-test\.sh'` (the build scripts in `BuildConfigs`; `dotnet build/pack/test` is always matched).
- Digest and cost scripts: `C:\Users\childebran\.claude\skills\work-log\scripts\day-digest.pl` and `day-cost.pl`; rates in `scripts\rates.tsv`.

## Section specifics

- Opening paragraph: mention develop to main pull requests, and that the v5 `develop` branches were untouched when they were.
- By Repo: folders that share history with a worktree (Kelly-Windows-Data / -v2, Kelly-Windows / -v2, Kelly-Revit-Logic / -v4, Kelly-Revit / -v4) are listed once, under the name of the worktree that holds the branch the commits are on.
- Packages and Installs: the packages are NuGet packages; repins say which layer pins which version; installs say which Revit years the add-in was installed for and when. Read a manifest's `<ProductVersion>` only for an install of the day.
- Builds and Testing: also the Revit testing gathered from the journal files; any log whose last line says **Missing results**. Grep a big journal for `ricaun|Kelly|exception|fatal` with `-m` limits; they run to tens of MB.
- Loose ends also include any `Kelly Tools For Revit*.addin.x` rename still in place, and any `Revit.exe`, `ricaun.RevitTest.Console` or `testhost` process still running.
- Savings report heading and rubric: 2 hours per point for code committed on the day, 0.1 hour per issue closed for earlier commits (decisions as in the skill).
