---
name: kelly-solid-check
description: Re-check the Kelly Tools For Revit repos against the SOLID principles and update "C:\repo\jhkweb\SOLID Check.md" (and each repo's README "SOLID principles" section) with what changed. Use when the user says "update this SOLID analysis", "update the SOLID check", "re-check SOLID", "how do the repos stand on SOLID now", or asks to refresh the SOLID ratings after recent work.
---

# SOLID check

`C:\repo\jhkweb\SOLID Check.md` rates six repos (Kelly-Windows-Data, Kelly-Windows, Kelly-Domain, Kelly-Revit-Logic, Kelly-Revit-UI, Kelly-Revit) on SRP, OCP, LSP, ISP and DIP, with a checklist of findings per repo, cross-repo patterns and "fixes with the best return". This skill brings it up to date with the code. It is a read-and-write-the-document task: never change code, build, test, pack or commit unless the user asks.

## 1. Read the current document

Read `SOLID Check.md` in full first. The user edits it too (renames, ticked boxes, notes); keep their edits and build on them. Note the date of the last re-check in its header line.

## 2. Measure

Run the measurement script with the last re-check's date and time:

```bash
bash /c/repo/jhkweb/.claude/skills/kelly-solid-check/scripts/measure.sh "2026-10-20 10:00"
```

It prints, read-only:
- each repo's commits and number of changed `src`/`modules` files since that time, and uncommitted changes,
- the five largest source files per repo,
- per-repo counts: files with a static class, interfaces, files using `MessageBox`, `TaskDialog`, `UserPrompt`, `new SqlServerService` and `NotImplementedException` call sites,
- the specific numbers the document cites (DocumentExtensions lines, `is Fabrication` checks, `Command.UiDocument` uses, and so on).

Then read the commits that touched source (`git -C <repo> show --stat <hash>`) to see *what* changed: renames, moved code, new seams, removed members. Commits that only change tests, attributes, READMEs, AGENTS.md or pins change no rating; say so in the header rather than listing them one by one.

## 3. Check every open item, and look for new ones

- For each unticked item, confirm it still holds and update its numbers, file names and line numbers. When a type was renamed, use the new name (the user may already have done this).
- Tick an item only when the code shows it fixed, and cite the commit hash(es) and package version(s) in the item, for example "fixed 2026-10-20 (`d34921f`, package 26.10.20.941)". Say "not yet committed" or "not yet pinned by Kelly-Revit-Logic and above" when that is the case.
- Treat a new hit in the per-repo counts (for example `MessageBox` or `TaskDialog` in a layer that had none) as a possible new finding: open the files, and add it to that repo's list if it is real, marked "(missed by the earlier checks)" when it was there before.
- Verify a claim from the document or a subagent before repeating it: grep it. Earlier checks got counts wrong (22 vs 18 members, 11 vs 10 properties); correct them in place and say so.
- Open a helper before calling its callers a violation; a name is not evidence. `TaskDialogSimple` and `HandleIt` look like direct dialogs but wrap `UserPrompt`, and `RevitUserPrompt` is the seam's own implementation, so none of them bypasses the prompt seam. A bypass is a direct `TaskDialog.Show`, `new TaskDialog(` or WPF `MessageBox.Show` (the script's `TaskDlg` and `MsgBox` columns count exactly those, code lines only).

## 4. Update the ratings conservatively

A rating (Strong / Mixed / Weak, with Weak–Mixed allowed) moves only when the evidence for that principle in that repo changes, and every move shows its old value: `Strong (was Mixed)`. One injected class does not lift a layer's DIP while its static registries and service locators remain. If a repo's README already rates a principle differently, reconcile the two: decide which is right from the code, and fix the wrong one.

## 5. Write the document

- Header: first-check date, every re-check date (with what it ran against), "counts and line numbers are from <date>", and one sentence on which recent work changes no rating.
- The summary paragraph: what moved since the last check, and what did not.
- The table, the per-repo checklists, "Patterns across the repos" and "Fixes with the best return": strike through (`~~…~~`) a fix that is done and add "(done <date>)"; keep the order.
- Keep the document's style: plain sentences, code names in backticks, `[x]`/`[ ]` items, no new sections unless the user asks.

## 6. Keep the READMEs in step

Each repo's `README.md` has a "SOLID principles" table (Principle | Rating | Notes) dated by the review it comes from (`BuildConfigs/SHARED-AGENTS.md` requires it). For each repo whose rating or notes moved, update that table and its date to match `SOLID Check.md`. Do not commit; tell the user which READMEs changed.

## 7. Report

Tell the user, briefly: which ratings moved (and why), which items were fixed (with commits), any new finding, any count that was corrected, and which files you changed (`SOLID Check.md`, READMEs). End with one recommended next fix from "Fixes with the best return".
