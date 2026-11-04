---
name: work-log
description: Write the day's work log of Chris Hildebran from the commits in every repository under C:\repo\jhkweb - a "yyyy.mm.dd Work Log Of Chris Hildebran.md" in the Notes-JHKelly repo, a one-page "yyyy.mm.dd Work Summary Of Chris Hildebran.md" for senior management, and a separate private "yyyy.mm.dd Claude Code Savings Of Chris Hildebran.md" report. Takes an optional date (yyyy.mm.dd or yyyy-mm-dd; default today). Use whenever the user asks for the work log, the work summary or the Claude Code savings report, to write, redo, backfill or update the log for a day, or when the "Work Log For Today" scheduled task runs.
---

# Work log

Create a Work Log of the day's commits in all repositories located in "C:\repo\jhkweb".

**The day** is the date given as the argument (`yyyy.mm.dd` or `yyyy-mm-dd`), or today (local time) when none is given. Every "the day" and `<day>` below means that date, and `<next day>` the date after it. Only the Loose Ends section describes the state when the log is written, whatever the day.

Group By Repository.
Summarize what changed using the sub-groups (Added, Changed, Fixed, Deleted).

Separately, write a private Savings report for Chris only: the day's savings (hours, dollars at $100/hr (total package)) from using Claude Code instead of manual coding by a senior .NET developer, and the actual cost of using Claude Code for the day. The savings and cost never go in the work log (decision of 2026-11-03).

Also write a Work Summary: a "10,000-foot" one-page view of the work log that Chris can submit to their manager's manager (decision of 2026-11-03). It is written last, from the finished work log.

In all three files, refer to Chris by role as "Senior Software Developer", never as "developer" (for example "by one Senior Software Developer using Claude Code"; decision of 2026-11-04). The hypothetical "senior .NET developer" of the savings comparison is someone else and keeps that name.

## Revit Testing
Gather information about revit testing for the day from any and all journal files. It goes in the `## Builds and Testing` section below.

## Format

Write the log exactly in the format of this example. Read it first and copy its structure, headings, tone and level of detail, except its `## Savings` section and `### Actual Cost` subsection, which now go in the separate Savings report:

`C:\repo\chrishildebran\Notes-JHKelly\2026\10 - October\2026.10.26 Work Log Of Chris Hildebran.md`

If that file is missing or has changed, follow the rules below; they describe the same format. The example predates sections 5 to 14 below; add them in the order given.

### Files

- Work log: `yyyy.mm.dd Work Log Of Chris Hildebran.md` (for example `2026.10.27 Work Log Of Chris Hildebran.md`).
- Work summary: `yyyy.mm.dd Work Summary Of Chris Hildebran.md`, in the same folder.
- Savings report: `yyyy.mm.dd Claude Code Savings Of Chris Hildebran.md`, in the same folder.
- Folder: `C:\repo\chrishildebran\Notes-JHKelly\yyyy\MM - MonthName\` (for example `2026\10 - October\`). Create the month folder if it does not exist.
- If a file already exists, merge into it: keep what is there, add what is missing, correct what is wrong. If an existing work log still has a Savings section, move it to the Savings report.
- Never commit or push the Notes-JHKelly repo.
- Do not write a copy into `C:\repo\jhkweb`.

### Markdown rules (Notes-JHKelly is an Obsidian vault)

- Escape every dollar amount outside code as `\$` (`\$100/hr`, `\$4/\$20`); Obsidian reads an unescaped `$...$` pair as inline math and the text disappears.
- Put placeholders and paths that contain `<...>` in code spans (`` `V5\<year>` ``, `` `V<n>` ``); a bare `<year>` or `<n>` is swallowed as an HTML tag.
- Put colour codes in code spans (`` `#016043` ``) so Obsidian does not read them as tags.
- Don't write Claude Code session links (`[title](#local_...)`); they only work inside the Claude app. Name the session in bold instead.
- Link the files with Obsidian links: the Work Summary and the Savings report each open with `[[yyyy.mm.dd Work Log Of Chris Hildebran]]`.

### Work log sections, in this order

1. `# yyyy.mm.dd Work Log Of Chris Hildebran`
2. Opening paragraph: the author, the number of commits and their time span, the develop→main pull requests merged and when, how many repositories changed, which repositories had no commits, and which branches the work was on (for example that the v5 `develop` branches were untouched).
3. `## Themes across Repos`: bullets of the work that ran across several repositories, each with a bold name and the times.
4. `## By Repo`: one `### <Repo> (`<branch>`, N Commits + PR #n Merged to `main` at HH:MM)` per repository with commits. Under each, bold `**Added**`, `**Changed**`, `**Fixed**`, `**Deleted**` sub-groups with bullets; leave out a sub-group that has nothing. Give versions, file counts and times where they help. Folders that share history with a worktree (Kelly-Windows-Data / -v2, Kelly-Windows / -v2, Kelly-Revit-Logic / -v4, Kelly-Revit / -v4) are listed once, under the name of the worktree that holds the branch the commits are on.
5. `## Changelog Updates`: one `### <Repo>` per repository whose `Changelog.md` changed on the day, listing each heading added or edited (its date and package or build version) with a one-line summary of its entries, and whether the change is committed or still uncommitted. Write "No changelog updates today." if none changed.
6. `## Claude Artifacts`: a table `| Artifact | Created or Updated | Time | What Changed |`, one row per artifact created or updated on the day, the title as a link to its URL. Write "No artifacts created or updated today." if none.
7. `## Packages and Installs`: a table `| Package | Version | Built At |` of the NuGet packages built on the day; then bullets of the repins made (which layer now pins which version, committed or not); then which Revit years the add-in was installed for and when. Write "No packages built or add-in installs today." if none.
8. `## Builds and Testing`: first the failed builds of the day, one bullet each: repo, configuration, time, the error codes and what caused them, and whether a later build passed. Then a table `| Test Assembly | Framework | Passed | Failed | Skipped | Run At |` from the day's test logs, the failed tests by name with their message, any log that reports **Missing results**, and the Revit testing gathered from the journal files.
9. `## Decisions and Rationale`: one bullet per design, architecture or working-practice decision made on the day: a bold short name, what was chosen, what it was chosen over, and why ("Chose X over Y because Z"), with the repo or area. Only decisions actually made, by the user or agreed by the user, not options that were only discussed. Write "No decisions recorded today." if none.
10. `## Bugs Found`: one `### <short name>` per bug found on the day, fixed or not: where (repo, file or command), the symptom, the repro steps, the cause if known, and its status (fixed in which commit, or still open). Write "No bugs found today." if none.
11. `## Gotchas Learned`: bullets of the surprises that cost time on the day and are worth remembering: Revit API behavior, transaction edge cases, build, package, test-adapter or tooling traps. Each gives the trap and how to avoid it, with a short code or command snippet where it helps, and says if it was saved as a memory. Write "No new gotchas today." if none.
12. `## Instruction and Memory Changes`: bullets of each instruction, skill, scheduled task or memory file created or changed on the day, with one line on what it now says. Write "No instruction or memory changes today." if none.
13. `## Loose Ends at End of Day`: bullets, one per item, as found when the log is written: repositories with uncommitted changes (file count) or stashes; branches with commits not pushed (how many); any `Kelly Tools For Revit*.addin.x` rename still in place; any `Revit.exe`, `ricaun.RevitTest.Console` or `testhost` process still running. Write "Nothing left open." if none. When the day is not today, say that these were found on the date the log was written.
14. `## Tomorrow`: first the blockers, each marked **Blocked:** with what it waits on (a person, an answer, a licence, another layer's package); then bullets of Claude Code sessions still running or waiting on an answer, task cards proposed but not started, and follow-ups named in the day's wrap-ups that were not done.
15. `## Notes`: the worktree note and anything else worth knowing (for example which repositories merged to `main`).

### Work summary sections, in this order

The reader is a senior manager, not a developer. Headings are in title case. Copy the structure and tone of `C:\repo\chrishildebran\Notes-JHKelly\2026\11 - November\2026.11.02 Work Summary Of Chris Hildebran.md`. One page; plain business language: outcomes and why they matter, not repo names, commit hashes, package versions, error codes or file names. Every number comes from the day's work log. No savings, hours saved or cost figures: those stay in the private Savings report.

1. `# yyyy.mm.dd Work Summary Of Chris Hildebran`, then one line: `Kelly Tools For Revit · Chris Hildebran · detail in [[yyyy.mm.dd Work Log Of Chris Hildebran]]`.
2. Lead: one sentence with the day's main result and its numbers.
3. `## At a Glance`: one line on when and how the work was done, then a table `| Measure | Result |` of 4 to 6 numbers (code changes and repositories, new tests and whether every suite passes, defects fixed and still open, installs, user-visible changes).
4. `## What Was Delivered`: a table `| Area | Outcome | Why it matters |`, one row per area of the day's work (for example Quality, Reliability, Installation, Usability, Code review, Planning), leaving out areas with nothing.
5. `## Risks and Open Items`: 2 to 5 bullets, each a bold short name and one or two plain sentences, from the work log's blockers, open bugs and loose ends that a manager would care about.
6. `## Next Steps`: a numbered list of 3 to 5 items from the work log's Tomorrow section.

If there are no commits for the day, write one line saying no development work was recorded.

### Savings report sections, in this order

1. `# yyyy.mm.dd Claude Code Savings Of Chris Hildebran`, then one line: private report, the link to the day's work log, and the commits it covers.
2. `## Savings: Claude Code vs. a Senior .NET Developer`: one line on how the estimates were made; a table `| Work | Manual Estimate (h) |` with one row per piece of work and a bold total; then the table `| | Hours | Dollars |` with the rows Manual (senior .NET developer at \$100/hr), With Claude Code: Senior Software Developer time supervising at \$100/hr (the time span of the commits and merges), With Claude Code: Claude usage (API-equivalent), and bold **Net Savings**.
3. `## Actual Cost of Claude Code for the Day`: the number of sessions, requests and models, then the table `| Usage | Tokens | Rate per 1M Tokens | Cost |` with Input (uncached), Output, Cache reads, Cache writes 5-minute, Cache writes 1-hour and a bold total, then bullets: the plan and its extra usage spent (the actual out-of-pocket cost), what the API-equivalent figure means and the rates assumed, that the seat price share is not included, and that the sessions cover all Claude Code work of the day.

### How to gather the data

- Commits: loop over every folder in `C:\repo\jhkweb` that has a `.git`, `git -C <repo> log --all --since "<day> 00:00" --until "<next day> 00:00" --no-merges --shortstat`, plus `--merges` for the pull requests. Use `git branch -a --contains <hash>` to name the branch. A force-pushed rewrite leaves old commits in `--all`; count commits on `HEAD`.
- Changelogs: for each repo, `git -C <repo> log --since "<day> 00:00" --until "<next day> 00:00" -p -- Changelog.md` for committed changes, and `git -C <repo> diff HEAD -- Changelog.md` for uncommitted ones.
- Artifacts: call the Artifact tool with `action: "list"`, `scope: "mine"`, `limit: 200`, and keep those whose last-updated time falls on the day (local time). Read an artifact with `action: "read"` only when its title does not say what changed; match it to the day's Claude Code sessions to tell created from updated. Never publish, edit or delete an artifact from this skill.
- Packages: `find /c/Repo/NugetPackages -name '*.nupkg' -newermt "<day>" ! -newermt "<next day>"`; the version is in the file name. Repins: the day's commits and uncommitted diffs that change a Kelly package version in `Directory.Packages.props` or a `.csproj`. Installs: the modified time and `<ProductVersion>` of each `C:\ProgramData\Autodesk\Revit\Addins\<year>\Kelly Tools For Revit <n>.addin` and of the add-in DLL its `<Assembly>` names, for 2024, 2025 and 2026.
- Builds: in the day's `.jsonl` transcripts, the Bash `dotnet build`, `dotnet pack` and `dotnet test` calls whose result has `error` lines or `Build FAILED`, with the reasoning around them for the cause. Builds run from the IDE leave no record; say so in the section.
- Testing: every `TestLogs\*.md` under `C:\repo\jhkweb` modified on the day (its rows and totals, and the last-line journal check); `%LOCALAPPDATA%\Kelly Unit Test Logs\errors.txt` if it changed on the day; and the Revit journal files of the day.
- Decisions, bugs and gotchas: read the day's `.jsonl` transcripts (the user's messages, the assistant's text and the `mcp__ccd_turn__wrap_up` recaps), the memory files created or changed on the day (most record a decision or a trap), and the day's commit messages and changelog entries (a "Fixed" entry is a bug found). Take each from what was said or done; never invent a rationale or a repro that is not there. If a bug's repro is not recorded, say "repro not recorded".
- Instruction and memory changes: files modified on the day in `C:\Users\childebran\.claude` (`CLAUDE.md`, `skills`, `scheduled-tasks`, `projects\*\memory`; not the `.jsonl` transcripts) and in `C:\repo\jhkweb` (every `CLAUDE.md`, `AGENTS.md`, `BuildConfigs\SHARED-AGENTS.md`, `.claude\`). Use `find ... -newermt "<day>" ! -newermt "<next day>"` and compare with git where the file is in a repo.
- Loose ends: per repo `git -C <repo> status --porcelain`, `git -C <repo> stash list` and `git -C <repo> rev-list --count @{u}..HEAD` for each local branch with an upstream; `ls` each `C:\ProgramData\Autodesk\Revit\Addins\<year>\` for `*.addin.x`; `tasklist | grep -iE "Revit.exe|ricaun|testhost"`. Report them only; never commit, push, rename or kill anything from this skill.
- Tomorrow: `mcp__ccd_session_mgmt__list_sessions` for sessions not archived that are running or waiting on the user; in the day's `.jsonl` transcripts, the `mcp__ccd_turn__wrap_up` calls (their recap, ask and `blocked` flag) and the `mcp__ccd_session__start_session` proposals with `initiation` "own_initiative" that no later session started. Blockers are the wrap-ups with `blocked: true` or an ask still unanswered, and anything the transcripts say is waiting on someone else.
- Claude Code cost (Savings report): sum the `usage` fields of every `"type":"assistant"` line in `~\.claude\projects\**\*.jsonl` whose `timestamp` falls on the day (local time), counting each message id + request id once, per model (input, output, cache_creation split into ephemeral_5m and ephemeral_1h, cache_read). Python and Node are not installed; use Perl or awk in Bash (write the Perl to a script file in the scratchpad; inline `perl -e` loses backslashes in Git Bash). Price the tokens with the current API rates from the `claude-api` skill (cache writes at 1.25× input for 5-minute and 2× for 1-hour). Get the plan and extra usage spent from `mcp__ccd_session_mgmt__get_usage`.
- If there are no commits for the day, still write all three files, saying so; the Savings report then shows zero savings and the day's Claude Code cost.
