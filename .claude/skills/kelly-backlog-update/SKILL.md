---
name: kelly-backlog-update
description: Update and organize the quick backlogs - each repository's Quick-Backlog.md and the "Backlog - Quick.md" index at the C:\repo\jhkweb root - back them up, check open items against the repos and tick the finished ones, sort items by function and then Add/Change/Fix/Delete, keep "To Organize" as the first heading of every file, remove duplicates, fix spelling and capitalization, and recompute the percent complete. Use whenever the user says "update the backlog", "organize the backlog", "update and organize", "check off what's done", "clean up the quick backlog", or asks where backlog items went or to recover lost ones.
---

# Update and organize the quick backlogs

Since 2026-11-02 the backlog is split:

- **One `Quick-Backlog.md` per repository**, at its root: all 18 sibling repositories (the v4 and v5 layers, the four Kelly-Windows-Data format libraries, Kelly-Revit-Data-Exporter, BuildConfigs and the two VCS schema repositories). A newly cloned repository gets one too, with a "Backlog" line in its `AGENTS.md` and a row in the index. Each repository's `AGENTS.md` points to it, and `BuildConfigs/SHARED-AGENTS.md` holds the rule. Items that cover a whole major version (every v4 or every v5 repository) live in that version's add-in repository, Kelly-Revit-v4 or Kelly-Revit-v5.
- **`C:\repo\jhkweb\Backlog - Quick.md`** is the index: a table of every repository backlog with its percent, and an "Other" section for items that belong to no repository. Unlike the repository files, its headings are one level down: `## Other` holds `### To Organize` (always its first heading 3), then `### Process`, `### Subscriptions`, ... with no Add/Change/Fix/Delete level.

The user edits these files in Typora, often while Claude works, so re-read a file right before writing it and keep every change they made.

## Scripts in this folder

| Script | What it does |
|---|---|
| `organize.pl <file> <rules.tsv>` | Moves every item of the file's To Organize, sub-items included, under `## <Function>` › `### <Add\|Change\|Fix\|Delete>`, chosen by the first rule whose regex matches the item's first line. It creates missing headings in order, and writes nothing if any item matches no rule. `rules-example/` has the rules used for Kelly-Revit-v5 on 2026-11-04. |
| `openfirst.pl <file> ...` | Within each heading, puts open items before done ones, keeping sub-items with their parent. |
| `check.sh [file ...]` | Read-only. Reports open items below a done one, duplicates within a file, mojibake, possible secrets, links whose target does not exist, the `// todo` count of every layer repository and the `new OperationService(` count. |
| `backup-diff.sh [file ...]` | Read-only. For each backlog, prints the lines added (+) and removed (-) since its newest backup that differs from it (copies identical to the file are skipped), ignoring line endings. Unchanged files are listed at the end. |
| `percent.sh [file ...]` | Rewrites the Complete lines, then copies every repository's percent into the index table (on every call). |

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

1. **Back up first.** Run `bash "$USERPROFILE/Documents/Backlog Backups/backup-jhkweb-docs.sh"`. It copies every changed root `.md` and every `*/Quick-Backlog.md` (as `<repo> Quick-Backlog yyyy-mm-dd_HHMM.md`) to `Documents\Backlog Backups` (the scheduled task "jhkweb docs backup" also runs it hourly). Then run `bash "C:/repo/jhkweb/.claude/skills/kelly-backlog-update/backup-diff.sh"` to see what the user changed since last time. Step 8 ends every run with a backup, so the copy before the one just made is where the last run stopped, and the diff shows only edits made since: items added outside To Organize, items the user ticked, reworded or deleted. Handle those in the steps below, and name them in the report. Ask about a deleted item before going on: it may be a deliberate deletion, or one lost to a chat rewind (see "Recovering lost items").
2. **Read every backlog**: the index and each `Quick-Backlog.md`.
3. **Move items out of every "To Organize"**: in a repository file, under the function and Add/Change/Fix/Delete heading it belongs to (add a function heading if none fits). In the index, into the repository file it belongs to, or into an "Other" heading 3 when it belongs to no repository. An item about a whole major version goes to Kelly-Revit-v4 or Kelly-Revit-v5. Every "To Organize" is empty afterwards, but the heading stays.
   - **Index items first, by hand** (Edit): reword each one in passing, add the note `— moved <date> from the index` with any evidence, and put it into the target repository's To Organize, so the next step files it. Items for "Other" go straight under its heading 3. `organize.pl` does not suit the index, whose headings are one level down.
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
7. **Recompute the percents**: run `bash "C:/repo/jhkweb/.claude/skills/kelly-backlog-update/percent.sh"` (every `*/Quick-Backlog.md`; a Complete line above the first heading 2 counts the whole file), then `bash "C:/repo/jhkweb/.claude/skills/kelly-backlog-update/percent.sh" "/c/repo/jhkweb/Backlog - Quick.md"` for the index's "Other" section. Either call also fills in the index table from the repository files. A new repository needs its row added by hand first (`| [<repo>](<repo>/Quick-Backlog.md) | 0% (0 of 0) |`).
8. **Back up again** with the script from step 1, and confirm each file matches its newest backup (`cmp`). Run `check.sh` once more: its first four sections should be empty. Commit the index to the jhkweb root repo. The `Quick-Backlog.md` files belong to their repositories: commit them there only when the user asks, so end the turn with a `wrap_up` question offering to commit them. That covers every repository whose file changed, including those where only a dated note changed. Commit on `develop` with the path alone (`git -C <repo> commit -m "…" -- Quick-Backlog.md`), so no file the user staged goes with it, and never push unless asked.
9. **Report**: what was ticked (with the evidence), duplicates removed, the new percents, and anything odd (missing or moved linked files, secrets). List every item that was in a "To Organize" with the file and heading it moved to (a table), and say which were ticked, so the user can find their new items: an emptied "To Organize" otherwise looks like deleted items. With many items, group them by source and target in one row ("34 open ViewModel-review bugs → Tools, ribbon and UI › Fix"), and name single items one by one.

## Rules

- Never put passwords, tokens or connection strings in a backlog. If one is there, point it out and offer to remove it.
- Don't delete an item the user wrote; tick it, mark it superseded, or merge it with its duplicate.
- Say "Major Version" or "v4"/"v5", never "Generation" in new text; old item text stays as written.

## Linear-ready items

The quick backlogs are a staging area: once Claude may connect to Linear, each repository's open items go to that repository's Linear team (or sub-team; not decided yet, see the index's Other › Process). Linear is not connected yet, so push nothing and build no sync. Keep each item ready to become one issue:

| Backlog | Linear |
|---|---|
| Repository | Team (or sub-team) |
| Item text before the first ` — `: a short title, under about 80 characters, that names the tool or type and the problem or goal | Issue title |
| The rest of the item: detail, file and line, likely fix, dated notes | Description |
| Function heading 2 (Tools, ribbon and UI, …) | Label |
| Add / Change / Fix / Delete | Feature / Improvement / Bug / Chore (type or label) |
| `severity high`, `medium` or `low` in the note | Priority High, Medium or Low (no severity: No priority) |
| Sub-items | Sub-issues |
| Done (`[x]`) and superseded items | Not moved; they stay here as the record |

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
