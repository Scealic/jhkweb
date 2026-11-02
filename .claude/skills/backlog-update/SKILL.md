---
name: backlog-update
description: Update and organize the quick backlogs - each repository's Quick-Backlog.md and the "Backlog - Quick.md" index at the C:\repo\jhkweb root - back them up, check open items against the repos and tick the finished ones, sort items by function and then Added/Changed/Fixed/Deleted, keep "To Organize" as the first heading of every file, remove duplicates, fix spelling and capitalization, and recompute the percent complete. Use whenever the user says "update the backlog", "organize the backlog", "update and organize", "check off what's done", "clean up the quick backlog", or asks where backlog items went or to recover lost ones.
---

# Update and organize the quick backlogs

Since 2026-11-02 the backlog is split:

- **One `Quick-Backlog.md` per repository**, at its root: all 18 sibling repositories (the v4 and v5 layers, the four Kelly-Windows-Data format libraries, Kelly-Revit-Data-Exporter, BuildConfigs and the two VCS schema repositories). A newly cloned repository gets one too, with a "Backlog" line in its `AGENTS.md` and a row in the index. Each repository's `AGENTS.md` points to it, and `BuildConfigs/SHARED-AGENTS.md` holds the rule. Items that cover a whole major version (every v4 or every v5 repository) live in that version's add-in repository, Kelly-Revit-v4 or Kelly-Revit-v5.
- **`C:\repo\jhkweb\Backlog - Quick.md`** is the index: a table of every repository backlog with its percent, and an "Other" section for items that belong to no repository (process, subscriptions), with its own "To Organize".

The user edits these files in Typora, often while Claude works, so re-read a file right before writing it and keep every change they made.

## Layout of a repository backlog

```
# Quick Backlog - <repo>

<one paragraph: what lives here>

**Complete: N% (d of t)**

## To Organize            <- always the first heading 2, new items land here

## <Function>              <- Architecture and services, Data and file I/O, Versioning, build and install,
                              Updaters and project information, Domain types, Tools, ribbon and UI,
                              Code quality and cleanup, Testing and documentation, Process, Schema changes
### Added | Changed | Fixed | Deleted   <- only those in use, in that order
- [ ] open items first, then [x] done items; sub-items stay under their parent
```

Links to the working documents at the jhkweb root use `../` (`[Plan.md](../Plan.md)`).

## Steps

1. **Back up first.** Run `bash "$USERPROFILE/Documents/Backlog Backups/backup-jhkweb-docs.sh"`. It copies every changed root `.md` and every `*/Quick-Backlog.md` (as `<repo> Quick-Backlog yyyy-mm-dd_HHMM.md`) to `Documents\Backlog Backups` (the scheduled task "jhkweb docs backup" also runs it hourly). Then diff each file against its previous backup to see what the user changed since last time.
2. **Read every backlog**: the index and each `Quick-Backlog.md`.
3. **Move items out of every "To Organize"**: in a repository file, under the function and Added/Changed/Fixed/Deleted heading it belongs to (add a function heading if none fits). In the index, into the repository file it belongs to, or into an "Other" heading when it belongs to no repository. An item about a whole major version goes to Kelly-Revit-v4 or Kelly-Revit-v5. Every "To Organize" is empty afterwards, but the heading stays.
4. **Check items against the repos.** Tick an item `[x]` only on evidence: code, commits (`git -C <repo> log`), or a plan document's progress section. Add or refresh a dated note after the item: `— 2026-10-30: <what was found>` or `— done 2026-10-30: <evidence>`. Useful checks:
   - `.sln`/`.slnx` files per repo; `<MajorVersion>` in every `.csproj`.
   - `// todo` counts per repo: `grep -rni '//\s*todo' <repo> --include=*.cs | grep -v /obj/ | wc -l` (each repository's file has its own TODO item with its own count).
   - `new OperationService(` sites in Kelly-Revit-Logic-v5/src and Kelly-Revit-v5/modules.
   - Push-button tooltips in Kelly-Revit-v5/modules (`*PushButton.cs` files with `ToolTip`, and their median length against v4).
   - Plan documents at the jhkweb root (their "Progress", "Left" or "Not done" lines), and whether linked `.md` files exist.
   - Never tick something only because it is in source: say "built, not installed" or "not tested in Revit" where that is the case.
   - Superseded items: `- [x] ~~text~~ — superseded: <why>`; they count as closed.
5. **Deduplicate within each file.** The same item may appear in the v4 and the v5 files (that is intended); within one file keep one copy, merging their notes. An item that is part of another becomes its sub-item.
6. **Fix spelling and capitalization**: sentence case for item text, keep proper names (Kelly Tools For Revit, KTR, Revit, SQL Server, CSV, JSON, Linear, InstallShield, Contenter, type and file names). Code names in backticks. Don't change meaning; leave link targets alone. Don't name Kelly Tools For Revit or KTR in the Kelly-Windows-Data, Kelly-Windows and Kelly-Domain files.
7. **Recompute the percents**: run `bash "C:/repo/jhkweb/.claude/skills/backlog-update/percent.sh"` (every `*/Quick-Backlog.md`; a Complete line above the first heading 2 counts the whole file), then `bash "C:/repo/jhkweb/.claude/skills/backlog-update/percent.sh" "/c/repo/jhkweb/Backlog - Quick.md"` for the index's "Other" section, and copy each repository's percent into the index table.
8. **Back up again** with the script from step 1, and confirm each file matches its newest backup (`cmp`). Commit the index to the jhkweb root repo. The `Quick-Backlog.md` files belong to their repositories: commit them there only when the user asks.
9. **Report**: what was ticked (with the evidence), duplicates removed, the new percents, and anything odd (missing linked files, secrets). List every item that was in a "To Organize" with the file and heading it moved to (a table), and say which were ticked, so the user can find their new items: an emptied "To Organize" otherwise looks like deleted items.

## Rules

- Never put passwords, tokens or connection strings in a backlog. If one is there, point it out and offer to remove it.
- Don't delete an item the user wrote; tick it, mark it superseded, or merge it with its duplicate.
- Say "Major Version" or "v4"/"v5", never "Generation" in new text; old item text stays as written.

## Recovering lost items

A chat rewind that restores code puts a file back to how it was when that chat first edited it, dropping the user's later Typora edits. A `Quick-Backlog.md` that was committed is also in its repository's git history. If the user says items are missing, gather every copy and list the items in any copy that the current files lack:

- `Documents\Backlog Backups\Backlog - Quick *.md` and `Documents\Backlog Backups\<repo> Quick-Backlog *.md` (the hourly copies; `Backlog - Quick` copies before 2026-11-02 13:07 hold the whole backlog in one file),
- `git -C <repo> log -p -- Quick-Backlog.md`,
- `~/.claude/file-history/*/` (Claude's per-chat backups of each file it edited),
- `%APPDATA%\Typora\draftsRecover\*.md` (Typora autosave drafts).

Most differences are rewordings; show the user the genuinely new ones and where each came from before restoring them into the right "To Organize".
