---
name: ribbon-tooltips
description: Re-analyze the IExternalCommands of the Kelly Tools For Revit add-in (Kelly-Revit-v4 and/or Kelly-Revit-v5) by reading each command's code and everything it calls, then create or rewrite the ToolTip on the ribbon push button that calls it, whether or not a tooltip already exists. Use whenever the user asks to update, rewrite, fix, add, check or "re-analyze" tooltips, ribbon button descriptions or help text for KTR commands, says a tooltip is wrong or vague, adds a new command or push button, or asks what a ribbon button actually does in order to describe it, for all buttons, one tab/module, a folder or a single named command.
---

# Ribbon tooltips from the code

Every ribbon button in Kelly Tools For Revit is a `*PushButton.cs` class deriving from `RibbonPushButton`. Its constructor sets `Text`, `ImageName`, `Type = typeof(<Command>)` (the `IExternalCommand` it runs), an optional `AvailabilityClassType` and `ToolTip`. When `ToolTip` is missing, empty or `"[tooltip]"`, Revit shows the button text instead.

This skill writes each tooltip from what the command's code actually does. The old tooltip is not evidence: many were vague, Title Case labels, and some were wrong. Reading the code also turns up commands that are broken or unfinished, and those findings are half the value of the job, so report them.

## 1. Settle the scope

- **Major version.** The add-in has two trees, both on `develop`:
  - v4: `C:\repo\jhkweb\Kelly-Revit-v4`. Buttons are under `src\`. It calls `Kelly-Revit-Logic-v4`, `Kelly-Windows-v2` and `Kelly-Windows-Data-v2`.
  - v5: `C:\repo\jhkweb\Kelly-Revit-v5`. Buttons are under `modules\Trade.*\` (one DLL per ribbon tab) and `src\`. It calls `Kelly-Revit-UI` (where the `RibbonPushButton` base class lives), `Kelly-Revit-Logic-v5`, `Kelly-Domain`, `Kelly-Windows-v3` and `Kelly-Windows-Data-v3`.

  If the user doesn't say which version, ask, and offer both. If they choose both, analyze once and apply the same text to each tree, but check the command code in each tree: the two have drifted apart.
- **Breadth:** all buttons, one tab or folder, or named commands.
- **Length:** default to one or two sentences (below). Ask only if the user hints at something else.

## 2. Inventory

```bash
bash /c/repo/jhkweb/.claude/skills/ribbon-tooltips/scripts/inventory.sh /c/repo/jhkweb/Kelly-Revit-v4 [path filter]
```

It prints one tab-separated row per push button: `BUTTON <file> <command type> <current tooltip or (none)>`. It also prints `ORPHAN <file> <class>` for each command class that no push button names. An orphan has no button to put a tooltip on. List the orphans for the user, and create a push button for one only if they ask: a new button also needs icons (`<ImageName>16.png`/`32.png`, embedded) and a place on a ribbon panel.

Run `git -C <repo> status --short` too. The trees often hold uncommitted edits the user made, so note them now and leave them alone.

## 3. Read each command until you know what it does

For each button, open the class named by `Type` and follow the code from there. Go through base classes such as `CoreCommand` and `CommandBase`, the services and Logic or Windows methods it calls in the lower-layer repos, the view model and window it opens, and the availability class. Stop when you could explain to a detailer what happens when they click the button:

- **What it acts on:** the current selection, elements it asks you to pick, the active view, the whole document, all open documents, a family document, a file it asks for, or the clipboard.
- **What it changes or produces:** which parameter it writes (by its user-facing name, such as `JHK Line Number` or `JHK BOM Type`) and to what value. What it deletes. What view filter it creates and what that filter shows. What window opens and what you can do there. What file it writes, where, and whether the file or folder opens afterwards.
- **What it needs first:** a selection, a value chosen in an assigner combo box, a family loaded, a view template present, Excel installed, a Kelly project, fabrication parts. Also which views enable the button: read the `AvailabilityClassType` class, don't guess from its name.
- **Surprises a user should know about:** it runs without asking, it can't be undone, it also does a second thing the button text doesn't mention, it ignores elements of other types, or it repeats until you press Esc.

When a fact comes from data rather than code, check the data rather than infer from the names. For example, a weld-location code read from the terminology CSV decides Shop or Field. If you can't check it, say the tooltip rests on an inference.

**Broken or unfinished commands.** If the code doesn't do what the button promises (an empty body, a commented-out body, a `throw "not built out"`, an operation that is never started, a transaction committed inside a loop), say so plainly in the tooltip, for example "Not finished yet: …". Add it to the findings list in step 6. Don't fix code under this skill: the job is the tooltip. Fixes are separate work for the user to approve.

## 4. Write the tooltip

- One or two plain sentences, present tense, ending with a period, about 80 to 250 characters. Use sentence case, not the old Title Case.
- Lead with the action and its object, then the main precondition or surprise. For example: "Clears JHK Item Number and the Revit Item Number on the selected fabrication ductwork. Other selected elements are ignored."
- Use the user's words: the parameter and folder names they see, and the ribbon names of the combo boxes ("Line Number Selector"). Leave out class names, transactions, GUIDs and method names.
- Don't name "Kelly Tools For Revit" or "KTR" in the tooltip; the user is already inside it.
- Write sibling buttons consistently: the same sentence pattern, changing only what differs. Examples are the hide, isolate, line-color and fill-color filters across the assigner contexts; align left, right, top and so on; the schedule export variants; and the weld location codes. Write the siblings together.
- Folder paths are C# strings: escape backslashes (`C:\\Projects\\Revit\\<project title>`) and double quotes.

## 5. Edit

- Change only the string literal on the `ToolTip` line, and keep the line's alignment.
- If the button has no `ToolTip` line, add one in the constructor, next to `Text` or above `Type`, aligned like its neighbours.
- Keep the file's byte-order mark and its line endings: some files are CRLF and some are LF, so check before editing.
- Don't touch button text, icons, availability classes, XAML or command code.

**More than about 20 buttons:** split the work by folder (for example the assigners, the rest of Trade.All or MultiTrade, Acquired, Developer, and the trade/manager tabs) across parallel subagents. The files never overlap. Give each subagent this skill's path, its folder, the repo paths from step 1 and the rules in steps 3 to 5. Ask it to edit only its own files, not build or commit, and return a table (file, new tooltip) plus its findings list. Tell each subagent to name any helper file after its group (`tips-assigners.tsv`), because they share the scratchpad and overwrite each other's same-named files. Also tell it to edit with the Edit tool or a quoted heredoc: an unquoted sed or perl substitution once backslash-escaped every character of the tooltip lines.

When the other major version already has code-checked tooltips, give the subagents its commit as a head start: they use a tooltip as a draft only after confirming the command does the same thing in this tree. Afterwards, read every returned table for consistency across the groups. Also spot-check any tooltip that rests on an inference (step 3).

## 6. Verify and report

1. Rerun the inventory. No button should show `(none)`, and every changed row should be new text.
2. `git -C <repo> diff -U0 | grep -E '^[+-][^+-]' | grep -v ToolTip` must print nothing. Only `ToolTip` lines changed.
3. Build every year without installing.
   - v4 must not install, so pass the override:
     ```bash
     dotnet build /c/repo/jhkweb/Kelly-Revit-v4/Kelly.Revit.slnx -c 2024 -p:GeneratePackageOnBuild=false "-p:CustomAfterMicrosoftCommonTargets=C:\repo\jhkweb\Kelly-Revit-v5\test\Tests.Revit\NoInstall.targets" -v q -nologo
     ```
     Repeat for 2025 and 2026, or loop over the three. The override also stops the build from renaming the other version's `.addin` manifest.
   - v5 builds don't install anyway (warning `KTR0004`).
   - Afterwards, confirm the `.addin` manifests in `C:\ProgramData\Autodesk\Revit\Addins\<year>` kept their timestamps.
4. Report to the user:
   - The count of buttons changed and of buttons added.
   - Notable before/after examples.
   - The orphan commands.
   - The broken or unfinished findings, grouped by command, with the file and the reason.
   - That nothing was checked in Revit (tooltips can only be seen there after an install).

## 7. Record it

- **`Changelog.md`** of the add-in repo: add a heading `## <date> (not yet in a build): <summary>` with the counts, the buttons that had no tooltip, and the unfinished buttons the tooltips now flag.
- **The release notes doc**, as the memory note "Update KTR release notes" describes: v4 and v5 have separate docs. Add the user-facing line to the application tab, and update the head and version in the repo releases table when you commit.
- **Commit only when the user asks.**
  - Stage by explicit path: the changed push buttons and `Changelog.md`. Use `git add --pathspec-from-file`, because the tree may hold the user's own changes.
  - Never use a path-less commit or `--amend` while other files are staged.
  - No `Co-Authored-By` line.
  - Push only when asked.
