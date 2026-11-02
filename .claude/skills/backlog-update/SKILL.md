---
name: backlog-update
description: Update and organize the "Backlog - Quick.md" working document at the C:\repo\jhkweb root - back it up, check open items against the repos and tick the finished ones, sort items by function, keep "To Organize" as the first heading 3 of every heading 2, remove duplicates within each heading 2, fix spelling and capitalization, and recompute the percent complete under each heading 2. Use whenever the user says "update the backlog", "organize the backlog", "update and organize", "check off what's done", "clean up Backlog - Quick", or asks where backlog items went or to recover lost ones.
---

# Update and organize Backlog - Quick

The file is `C:\repo\jhkweb\Backlog - Quick.md` (Bash: `/c/repo/jhkweb/Backlog - Quick.md`). It is a working document, not in any repo. The user edits it in Typora, often while Claude works, so re-read it right before writing and keep every change they made.

## Steps

1. **Back up first.** Run `bash "$USERPROFILE/Documents/Backlog Backups/backup-jhkweb-docs.sh"`. It copies every changed root `.md` to `Documents\Backlog Backups\<name> yyyy-mm-dd_HHMM.md` (the scheduled task "jhkweb docs backup" also runs it hourly). Then diff the file against its previous backup to see what the user changed since last time.
2. **Read the file.**
3. **Check items against the repos** (the layer repos named in `C:\repo\jhkweb\.claude\CLAUDE.md`). Tick an item `[x]` only on evidence: code, commits (`git -C <repo> log`), or a plan document's progress section. Add or refresh a dated note after the item: `— 2026-10-30: <what was found>` or `— done 2026-10-30: <evidence>`. Useful checks:
   - `.sln`/`.slnx` files per repo; `<MajorVersion>` in every `.csproj`.
   - `// todo` counts per repo: `grep -rni '//\s*todo' <repo> --include=*.cs | grep -v /obj/ | wc -l`.
   - `new OperationService(` sites in Kelly-Revit-Logic-v5/src and Kelly-Revit-v5/modules.
   - Push-button tooltips in Kelly-Revit-v5/modules (`*PushButton.cs` files with `ToolTip`, and their median length against v4).
   - Plan documents at the jhkweb root (their "Progress", "Left" or "Not done" lines), and whether linked `.md` files exist.
   - Never tick something only because it is in source: say "built, not installed" or "not tested in Revit" where that is the case.
4. **Organize.**
   - Heading 2 sections: one per product or repo (`Kelly Tools For Revit v4`, `Kelly Tools For Revit v5`, `VCS-Database-General-Schema`, ..., `Other` last). Never drop a heading 2 the user added.
   - Directly under each heading 2: the percent line, then `### To Organize` as the **first** heading 3, always present. Move its items into the function heading they belong to, so it is empty afterwards; add a new function heading if none fits.
   - Function headings in use: Architecture (and services), Data (and file I/O), Versioning, build and install, Updaters and project information, Domain types, Tools, ribbon and UI, Code quality and cleanup, Testing (and documentation), Process, Schema changes, Subscriptions. Use the same names in v4 and v5 where they apply.
   - Within each heading 3: open items first, then done items. Sub-items stay under their parent.
   - Superseded items: `- [x] ~~text~~ — superseded: <why>`; they count as closed.
5. **Deduplicate within each heading 2.** The same item may appear in v4 and in v5 (that is intended); within one heading 2 keep one copy, merging their notes. An item that is part of another becomes its sub-item.
6. **Fix spelling and capitalization**: sentence case for item text, keep proper names (Kelly Tools For Revit, KTR, Revit, SQL Server, CSV, JSON, Linear, InstallShield, Contenter, type and file names). Code names in backticks. Don't change meaning; leave `[links](file.md)` targets alone.
7. **Recompute the percents**: put a `**Complete: 0% (0 of 0)**` line under any new heading 2, then run `bash "C:/repo/jhkweb/.claude/skills/backlog-update/percent.sh"`. It counts every checkbox in the section, sub-items included.
8. **Back up again** with the script from step 1, and confirm the file and its newest backup match (`cmp`).
9. **Report**: what was ticked (with the evidence), duplicates removed, the new percents, and anything odd (missing linked files, secrets). List every item that was in "To Organize" with the heading it moved to (a table), and say which were ticked, so the user can find their new items: an emptied "To Organize" otherwise looks like deleted items.

## Rules

- Never put passwords, tokens or connection strings in the file. If one is there, point it out and offer to remove it.
- Don't delete an item the user wrote; tick it, mark it superseded, or merge it with its duplicate.
- Say "Major Version" or "v4"/"v5", never "Generation" in new text; old item text stays as written.

## Recovering lost items

A chat rewind that restores code puts the file back to how it was when that chat first edited it, dropping the user's later Typora edits. If the user says items are missing, gather every copy and list the items in any copy that the current file lacks:

- `Documents\Backlog Backups\Backlog - Quick *.md` (the hourly copies),
- `~/.claude/file-history/*/8b956d113aa16513@v*` (Claude's per-chat backups of this file),
- `%APPDATA%\Typora\draftsRecover\* Backlog - Quick *.md` (Typora autosave drafts).

Most differences are rewordings; show the user the genuinely new ones and where each came from before restoring them into "To Organize".
