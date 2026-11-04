---
name: kelly-backlog-update
description: Update and organize the quick backlogs - each repository's Quick-Backlog.md and the "Backlog - Quick.md" index at the C:\repo\jhkweb root - see what the user changed since the last commit, check open items against the repos and tick the finished ones, sort items by function and then Add/Change/Fix/Delete, keep "To Organize" as the first heading of every file, remove duplicates, fix spelling and capitalization, and recompute the percent complete. Use whenever the user says "update the backlog", "organize the backlog", "update and organize", "check off what's done", "clean up the quick backlog", or asks where backlog items went or to recover lost ones.
---

# Update and organize the quick backlogs

Since 2026-11-02 the backlog is split:

- **One `Quick-Backlog.md` per repository**, at its root: all 18 sibling repositories (the v4 and v5 layers, the four Kelly-Windows-Data format libraries, Kelly-Revit-Data-Exporter, BuildConfigs and the two VCS schema repositories). A newly cloned repository gets one too, with a "Backlog" line in its `AGENTS.md`, and a linked heading 2 in the index if it has a Linear team. Each repository's `AGENTS.md` points to it, and `BuildConfigs/SHARED-AGENTS.md` holds the rule. Items that cover a whole major version (every v4 or every v5 repository) live in that version's add-in repository, Kelly-Revit-v4 or Kelly-Revit-v5.
- **`C:\repo\jhkweb\Backlog - Quick.md`** is the index: one heading 2 per repository that has a Linear team, linked to its `Quick-Backlog.md` (the table of percents was removed 2026-11-04 at the user's request), each holding only `### Add To Linear as Issue` and an empty `- [ ] ` task for the user to type into (since 2026-11-04; step 3 files these into Linear and into the repository's backlog), and an "Other" section for items that belong to no repository. Unlike the repository files, its headings are one level down: `## Other` holds `### To Organize` (always its first heading 3), then `### Process`, `### Subscriptions`, ... with no Add/Change/Fix/Delete level.

The user edits these files in Typora, often while Claude works, so re-read a file right before writing it and keep every change they made.

## Scripts in this folder

| Script | What it does |
|---|---|
| `organize.pl <file> <rules.tsv>` | Moves every item of the file's To Organize, sub-items included, under `## <Function>` › `### <Add\|Change\|Fix\|Delete>`, chosen by the first rule whose regex matches the item's first line. It creates missing headings in order, and writes nothing if any item matches no rule. `rules-example/` has the rules used for Kelly-Revit-v5 on 2026-11-04. |
| `openfirst.pl <file> ...` | Within each heading, puts open items before done ones, keeping sub-items with their parent. |
| `check.sh [file ...]` | Read-only. Reports open items below a done one, duplicates within a file, mojibake, possible secrets, links whose target does not exist, the `// todo` count of every layer repository and the `new OperationService(` count. |
| `backup-diff.sh [file ...]` | Read-only. For recovering lost items, not part of a normal run. For each backlog, prints the lines added (+) and removed (-) since its newest backup that differs from it (copies identical to the file are skipped), ignoring line endings. Unchanged files are listed at the end. |
| `percent.sh [file ...]` | Rewrites the Complete lines. |

## Environment traps

- There is no Python or Node on this machine. Script with Bash or Perl (Git Bash ships Perl).
- The backlogs mix CRLF and LF line endings and hold UTF-8 punctuation (`—`, `’`, `→`). A `sed 's/…$/…/'` silently misses a CRLF line, and `.` matches only one byte of `’`. Edit with `perl -i -pe 's/…(\r?)$/…$1/'`, or with the Edit tool after a Read, and grep afterwards to confirm that every intended line changed.
- Keep the scratch rules files in the session scratchpad, not in the skill folder.

## Layout of a repository backlog

```
# Quick Backlog - <repo>

<one paragraph: what lives here>

**Complete: N% (d of t)**

## To Organize            <- always the first heading 2, new items land here

## <Function>              <- Architecture and services, Data and file I/O, Versioning, build and install,
                              Updaters and project information, Domain types, Tools, ribbon and UI,
                              Code quality and cleanup, Testing and documentation, Process, Schema changes
### Add | Change | Fix | Delete   <- only those in use, in that order (renamed from Added/Changed/Fixed/Deleted on 2026-11-04)
- [ ] open items first, then [x] done items; sub-items stay under their parent
```

Links are relative to the backlog file: a working document at the jhkweb root is `../Plan.md`, and one kept in the same repository is `Plan.md`. Working documents move from the root into the repositories (on 2026-11-04 the v4 and v5 SQL-to-CSV plans, the v5 Layer Straightening Plan and the dependency diagrams moved into Kelly-Revit-v4 and Kelly-Revit-v5). When a link breaks, `find /c/repo/jhkweb -name "<file>"` before calling the document missing, and point the link at the new place.

## Steps

1. **See what the user changed since the last commit.** Every backlog is committed at the end of a run (step 8), so `git -C /c/repo/jhkweb diff HEAD -- "Backlog - Quick.md"` and, for each repository, `git -C <repo> diff HEAD -- Quick-Backlog.md` show only the user's edits since then: items added outside To Organize, items the user ticked, reworded or deleted. Handle those in the steps below, and name them in the report. Ask about a deleted item before going on: it may be a deliberate deletion, or one lost to a chat rewind (see "Recovering lost items"). No backup step is needed (since 2026-11-04): the scheduled task "jhkweb docs backup" runs `backup-jhkweb-docs.sh` hourly, and git holds every committed version. `backup-diff.sh` stays for recovering lost items; it skips backups identical to the file, so when nothing changed it shows the previous run's edits, and it is not a guide to the user's changes.
2. **Read every backlog**: the index and each `Quick-Backlog.md`.
3. **Move items out of every "To Organize"**: in a repository file, under the function and Add/Change/Fix/Delete heading it belongs to (add a function heading if none fits). In the index, into the repository file it belongs to, or into an "Other" heading 3 when it belongs to no repository. An item about a whole major version goes to Kelly-Revit-v4 or Kelly-Revit-v5. Every "To Organize" is empty afterwards, but the heading stays.
   - **"Add To Linear as Issue" first.** Under each repository's heading 2 in the index, every non-empty task (the empty `- [ ] ` placeholder is skipped) becomes a Linear issue in that repository's team ("Linear-ready items" has the table and the field mapping). Writing it there is the user's approval: create it without asking, after checking the team with `list_teams` and searching the team with `list_issues` for the same title. Then:
     - Status Backlog; title the text before the first ` — ` (with none, a short title of under about 80 characters, and the full text as the description); "1 - Type" and "4 - Function" labels only where the wording makes them plain; in KTR5, the "5 - Feature" label of every tool the item names (several when it names several; no new feature labels without asking) and the matching "5 - Module" labels, and never a project for a single tool (features are labels since 2026-11-04); sub-items become sub-issues. Footer: ``From `Backlog - Quick.md` › <Repo> › Add To Linear as Issue (filed <date>).``
     - Add the item to that repository's `Quick-Backlog.md`, made Linear-ready, ending ` — Linear: <KEY-123> (<date>)`: under its function and Add/Change/Fix/Delete heading when they are plain, otherwise in its To Organize (the next bullets file it).
     - Delete the line from the index and leave one empty `- [ ] ` under the heading 3, so the user always has a line to type into.
     - A matching issue already in Linear (any team, sub-teams too) still never leaves the line behind (user decision 2026-11-04): every non-empty line is handled in the same run.
       - **The same work** (same goal and same scope, in this repository's team): create nothing. Add the line's wording and anything new in it (who asked, a date) to the existing issue as a comment, add it as a dated note to that issue's item in the repository's `Quick-Backlog.md` (or add the item there with the existing key if it is missing), and clear the index line. Report it as merged into `<KEY>`.
       - **Overlapping but not the same** (another layer's half of the work, a wider or narrower scope, another team): create the new issue as above, say in its description which part the other issue covers, and link the two as Related. Report both keys.
       - Only when you can't tell which of the two it is, leave the line and ask in the report.
     - If Linear can't be reached, leave every line and say so.
     - List each new key with its title and repository in the report.
   - **Index items next, by hand** (Edit): reword each one in passing, add the note `— moved <date> from the index` with any evidence, and put it into the target repository's To Organize, so the next step files it. Items for "Other" go straight under its heading 3. `organize.pl` does not suit the index, whose headings are one level down.
   - **Then each repository file with `organize.pl`**. Write a rules file per repository in the scratchpad: specific rules first (a regex on the item's start, such as `^- \[x\] Host root namespace`, or a distinctive phrase), and a catch-all `.` last. Run it on a copy first, and check that the item count (`grep -c '^\s*- \['`) is the same before and after. Then run it on the real file, followed by `openfirst.pl`.
   - With a few items, the Edit tool is just as good.
4. **Check items against the repos.** Tick an item `[x]` only on evidence: code, commits (`git -C <repo> log`), or a plan document's progress section. Add or refresh a dated note after the item: `— 2026-10-30: <what was found>` or `— done 2026-10-30: <evidence>`. Start with `bash "C:/repo/jhkweb/.claude/skills/kelly-backlog-update/check.sh"`. Useful checks:
   - `git -C <repo> log --since="<last run>"` in every repository: the commits since the last update are the likeliest evidence.
   - `.sln`/`.slnx` files per repo; `<MajorVersion>` in every `.csproj`.
   - `// todo` counts per repo (`check.sh` prints all ten). Each repository's file has its own TODO item with its own count; refresh its note on every run, with `unchanged <date>` when the count has not moved.
   - `new OperationService(` sites in Kelly-Revit-Logic-v5/src and Kelly-Revit-v5/modules (`check.sh`).
   - Push-button tooltips in Kelly-Revit-v5/modules (`*PushButton.cs` files with `ToolTip`, and their median length against v4).
   - Plan documents (their "Progress", "Left" or "Not done" lines), and the broken links `check.sh` lists (see the link rule above).
   - An open bug with a file and line: grep for the code it names, to say whether it is still there.
   - Never tick something only because it is in source: say "built, not installed" or "not tested in Revit" where that is the case.
   - Superseded items: `- [x] ~~text~~ — superseded: <why>`; they count as closed.
5. **Deduplicate within each file** (`check.sh` lists items whose first 70 characters match; also look for the same bug worded differently). The same item may appear in the v4 and the v5 files (that is intended); within one file keep one copy, merging their notes. An item that is part of another becomes its sub-item.
6. **Fix spelling and capitalization**: sentence case for item text, keep proper names (Kelly Tools For Revit, KTR, Revit, SQL Server, CSV, JSON, Linear, InstallShield, Contenter, type and file names). Code names in backticks. Don't change meaning; leave link targets alone. Don't name Kelly Tools For Revit or KTR in the Kelly-Windows-Data, Kelly-Windows and Kelly-Domain files. Make every item you file, move or touch Linear-ready (see "Linear-ready items"): give it a short title if it has none, and add the severity word where a note gives one. Leave untouched items alone; `check.sh` lists open items with no short title, for a later pass.
7. **Recompute the percents**: run `bash "C:/repo/jhkweb/.claude/skills/kelly-backlog-update/percent.sh"` (every `*/Quick-Backlog.md`; a Complete line above the first heading 2 counts the whole file), then `bash "C:/repo/jhkweb/.claude/skills/kelly-backlog-update/percent.sh" "/c/repo/jhkweb/Backlog - Quick.md"` for the index's "Other" section.
8. **Check and commit.** Run `check.sh` once more: its first four sections should be empty. Commit the index to the jhkweb root repo. The `Quick-Backlog.md` files belong to their repositories: commit them there only when the user asks, so end the turn with a `wrap_up` question offering to commit them. That covers every repository whose file changed, including those where only a dated note changed. Commit on `develop` with the path alone (`git -C <repo> commit -m "…" -- Quick-Backlog.md`), so no file the user staged goes with it, and never push unless asked.
9. **Report**: what was ticked (with the evidence), duplicates removed, the new percent of each repository, and anything odd (missing or moved linked files, secrets). List every item that was in a "To Organize" with the file and heading it moved to (a table), and say which were ticked, so the user can find their new items: an emptied "To Organize" otherwise looks like deleted items. With many items, group them by source and target in one row ("34 open ViewModel-review bugs → Tools, ribbon and UI › Fix"), and name single items one by one.

## Rules

- Never put passwords, tokens or connection strings in a backlog. If one is there, point it out and offer to remove it.
- Don't delete an item the user wrote; tick it, mark it superseded, or merge it with its duplicate. The one exception is an index "Add To Linear as Issue" line, which is removed once it is in Linear and in the repository's backlog.
- Say "Major Version" or "v4"/"v5", never "Generation" in new text; old item text stays as written.

## Linear-ready items

The quick backlogs are a staging area: each repository's items go to that repository's Linear team (workspace "jhkelly"; teams created 2026-11-04; every item that had a team was moved on 2026-11-04). Push an item only after the user approves it, and build no automatic sync. An item the user writes under an index "Add To Linear as Issue" heading is already approved (step 3). A new item added later is moved the same way, then keeps its key here. Keep each item ready to become one issue.

| Repository backlog | Linear team (key) |
|---|---|
| Kelly-Revit-v5 (all of v5) | Kelly Tools For Revit 5 (KTR5) |
| Kelly-Revit-UI | Kelly Tools For Revit 5 › Kelly-Revit-UI (KTRUI) |
| Kelly-Revit-Logic-v5 | Kelly Tools For Revit 5 › Kelly Revit Logic 5 (KTRL5) |
| Kelly-Revit-v4 (all of v4) | Kelly Tools For Revit 4 (KTR4) |
| Kelly-Revit-Logic-v4 | Kelly Tools For Revit 4 › Kelly Revit Logic 4 (KTRL4) |
| Kelly-Windows-v3 / -v2 | Kell Windows 3 (KW3) / Kell Windows 2 (KW2) |
| Kelly-Windows-Data-v3 / -v2 | Kell Windows Data 3 (KWD3) / Kell Windows Data 2 (KWD2) |
| Kelly-Windows-Data-Csv / -Json | Kelly Windows Data CSV (KWDC) / JSON (KWDJ) |
| Kelly-Windows-Data-SqlServer / -Sqlite | Kelly Windows Data SQL Server (KWDSS) / Sqlite (KWDSL) |
| Kelly-Domain | Kelly Domain (KD) |
| BuildConfigs, Kelly-Revit-Data-Exporter, the VCS schemas, the index's Other | No team yet: don't push |

Check the teams with the Linear connector's `list_teams` before a push; the user may have renamed or added some. The connector cannot create teams.

The item maps to an issue like this:

| Backlog | Linear |
|---|---|
| Repository | Team (table above) |
| Item text before the first ` — `: a short title, under about 80 characters, that names the tool or type and the problem or goal | Issue title |
| The rest of the item: detail, file and line, likely fix, dated notes | Description |
| Function heading 2 (Tools, ribbon and UI, …) | Label in the workspace group "4 - Function" (v4's "Architecture", "Data", "Testing" use the longer labels; To Organize: none). A new function heading needs a new label in that group first |
| Add / Change / Fix / Delete | Label of the same name in the workspace group "1 - Type" |
| `severity high`, `medium` or `low` in the note; deferred items | Priority High, Medium or Low; deferred: Low (otherwise No priority) |
| Sub-items | Sub-issues |
| Description footer | `---` then ``From `<Repo>/Quick-Backlog.md` › <H2> › <H3> (moved <date>).`` Wrap dotted names (`Kelly.Windows`) in backticks or Linear makes them web links |
| Open (`[ ]`) / done (`[x]`) / superseded items | Status Backlog / Done / Canceled. Every item moves, done ones too (user decision 2026-11-04) |

- **Title first.** A new item starts with its short title, then ` — `, then the detail: `- [ ] Layout Point Import: 'Specify Level?' always fails the import — The level combo binds a Level to … — found 2026-11-03 …`. When an existing item has no short title, write one in front of the current text and keep that text, word for word, as the detail. Rewording it would lose evidence.
- **One item, one issue.** An item that holds two problems becomes two items, or a parent with sub-items.
- **Linear key once moved.** When an item has been created in Linear, add ` — Linear: <KEY-123> (<date>)` after it, and leave it open here until it is done in Linear. An item with a Linear key is never sent again; tick it when its Linear issue is done, with the key as the evidence.
- The same bug in v4 and v5 is one item in each add-in backlog, so it becomes one issue per team; say in each note that the other version has it too (the ViewModel-review items already do).

## Recovering lost items

A chat rewind that restores code puts a file back to how it was when that chat first edited it, dropping the user's later Typora edits. A `Quick-Backlog.md` that was committed is also in its repository's git history. If the user says items are missing, gather every copy and list the items in any copy that the current files lack:

- `Documents\Backlog Backups\Backlog - Quick *.md` and `Documents\Backlog Backups\<repo> Quick-Backlog *.md` (the hourly copies; `Backlog - Quick` copies before 2026-11-02 13:07 hold the whole backlog in one file),
- `git -C <repo> log -p -- Quick-Backlog.md`,
- `~/.claude/file-history/*/` (Claude's per-chat backups of each file it edited),
- `%APPDATA%\Typora\draftsRecover\*.md` (Typora autosave drafts).

Most differences are rewordings; show the user the genuinely new ones and where each came from before restoring them into the right "To Organize".
