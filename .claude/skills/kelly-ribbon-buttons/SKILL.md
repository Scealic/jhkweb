---
name: kelly-ribbon-buttons
description: Re-analyze the IExternalCommands of the Kelly Tools For Revit add-in (Kelly-Revit-v4 and/or Kelly-Revit-v5) by reading each command's code and everything it calls, then (1) create or rewrite the ToolTip on the ribbon push button that calls it, and (2) create ribbon icons, drawn from that tooltip in JHK green, for every button whose image is missing or still the "Scrum" placeholder. Use whenever the user asks to update, rewrite, fix, add, check or "re-analyze" tooltips, ribbon button descriptions or help text; to make, draw, design, replace or fix ribbon icons, button images or the Scrum placeholder images; when a new command or push button is added; or asks what a ribbon button actually does. Applies to all buttons, one tab or module, a folder, or a single named command.
---

# Ribbon buttons: tooltips and icons from the code

Every ribbon button in Kelly Tools For Revit is a `*PushButton.cs` class deriving from `RibbonPushButton`. Its constructor sets:

- `Text`
- `ImageName`: the icon, loaded as `<ImageName>16.png` and `<ImageName>32.png` from the button assembly's embedded `RibbonIcons`
- `Type = typeof(<Command>)`: the `IExternalCommand` the button runs
- an optional `AvailabilityClassType`
- `ToolTip`

If `ToolTip` is missing, empty or `"[tooltip]"`, Revit shows the button text instead. If `ImageName` is blank, `RibbonPushButton` substitutes `"Scrum"`. That was a placeholder image, deleted on 2026-11-02, so the button now shows no icon and logs "Ribbon icon resource not found".

This skill does two jobs, in this order, because the second builds on the first:

1. **Tooltips.** Write each tooltip from what the command's code actually does. The old tooltip is not evidence: many were vague Title Case labels, and some were wrong.
2. **Icons.** Draw an icon for every button whose image is missing or still the placeholder. The icon's metaphor comes from the tooltip: the object it acts on plus its action.

Reading the code also turns up broken or unfinished commands. Those findings are half the value of the job, so report them.

The user may ask for only one of the two jobs; then do only that one. For icons, if a button's tooltip is still old or vague, write its tooltip first (job 1), because the icon is drawn from it.

## 1. Settle the scope

- **Major version.** The add-in has two trees, both on `develop`:
  - **v4:** `C:\repo\jhkweb\Kelly-Revit-v4`.
    - Buttons are under `src\`.
    - Icons are in `src\Application\Graphics\RibbonIcons`, embedded by a `*.png` wildcard in `src\Revit.csproj`.
    - It calls `Kelly-Revit-Logic-v4`, `Kelly-Windows-v2` and `Kelly-Windows-Data-v2`.
  - **v5:** `C:\repo\jhkweb\Kelly-Revit-v5`.
    - Buttons are under `modules\Trade.*\` (one DLL per ribbon tab) and `src\`.
    - Each module embeds its own `Graphics\RibbonIcons\*.png`, so an icon goes into the module of the button that uses it.
    - It calls `Kelly-Revit-UI` (which holds `RibbonPushButton`), `Kelly-Revit-Logic-v5`, `Kelly-Domain`, `Kelly-Windows-v3` and `Kelly-Windows-Data-v3`.

  If the user doesn't say which version, ask, and offer both. When they choose both:
  - Analyze once and reuse the text and icons in each tree.
  - Still check each command's code in each tree: the two have drifted apart.
  - If the other version already has code-checked tooltips, use them as a head start. A tooltip is a draft until you confirm the command does the same thing in this tree.
- **Breadth:** all buttons, one tab or folder, or named commands.
- **Tooltip length:** default to one or two sentences (section 4). Ask only if the user hints at something else.

## 2. Inventory

```bash
bash /c/repo/jhkweb/.claude/skills/kelly-ribbon-buttons/scripts/inventory.sh /c/repo/jhkweb/Kelly-Revit-v5 [path filter]
```

It prints two kinds of tab-separated rows:

- `BUTTON <file> <command type> <tooltip or (none)> <ImageName or (none)> <icon state>`, one per push button. The icon state is:
  - `ok`
  - `placeholder`: no `ImageName`, a blank one, or `"Scrum"`/`"scrum"`
  - `missing`: `<ImageName>16.png` or `32.png` isn't in the folder that assembly embeds
- `ORPHAN <file> <class>`, one for each command class that no push button names.

An orphan has no button to describe. List the orphans for the user, and create a push button for one only if they ask: it needs a panel, button text and an icon too.

The script runs `grep` over the whole tree and takes a minute or two per tree, so run it in the background.

Also run `git -C <repo> status --short`. The trees often hold uncommitted edits the user made, so note them and leave them alone.

## 3. Read each command until you know what it does

For each button, open the class named by `Type` and follow the code from there:

- base classes such as `CoreCommand` and `CommandBase`
- the services and Logic or Windows methods it calls in the lower-layer repos
- the view model and window it opens
- the availability class

Stop when you could explain to a detailer what happens when they click the button:

- **What it acts on:** the current selection, elements it asks you to pick, the active view, the whole document, all open documents, a family document, a file it asks for, or the clipboard.
- **What it changes or produces:**
  - which parameter it writes, by its user-facing name (`JHK Line Number`, `JHK BOM Type`), and to what value
  - what it deletes
  - what view filter it creates and what that filter shows
  - what window opens and what you can do there
  - what file it writes, where, and whether the file or folder opens afterwards
- **What it needs first:** a selection, a value chosen in an assigner combo box, a family loaded, a view template present, Excel installed, a Kelly project, fabrication parts. Also which views enable the button: read the `AvailabilityClassType` class, don't guess from its name.
- **Surprises a user should know about:** it runs without asking, it can't be undone, it does a second thing the button text doesn't mention, it ignores elements of other types, it repeats until you press Esc, or it works session-wide (for example `UpdaterRegistry` on or off applies to all open projects).

When a fact comes from data rather than code, check the data rather than infer it from names. For example, a weld location code read from the terminology CSV decides Shop or Field. If you can't check it, say that the tooltip rests on an inference.

**Broken or unfinished commands.** The code may not do what the button promises. Examples: an empty or commented-out body, a `throw "not built out"`, an operation that is never started, or a transaction committed inside a loop. Say so plainly in the tooltip ("Not finished yet: …") and add it to the findings (step 7). Don't fix code under this skill; fixes are separate work for the user to approve.

## 4. Write the tooltip

- One or two plain sentences, present tense, ending with a period, about 80–250 characters. Sentence case, not Title Case.
- Lead with the action and its object, then the main precondition or surprise. Example: "Clears JHK Item Number and the Revit Item Number on the selected fabrication ductwork. Other selected elements are ignored."
- Use the names the user sees: parameter and folder names, and the ribbon names of the combo boxes ("Line Number Selector"). Leave out class names, transactions, GUIDs and method names.
- Don't name "Kelly Tools For Revit" or "KTR" in the tooltip.
- Sibling buttons share one sentence pattern and change only what differs. Write siblings together. Examples:
  - the hide, isolate, line-color and fill-color filters across the assigner contexts
  - the align and distribute buttons
  - the schedule export variants
  - the weld location codes
  - the three manual updaters
- Folder paths are C# strings: escape backslashes (`C:\\Projects\\Revit\\<project title>`) and double quotes.

**Editing the tooltip:**

- Change only the string literal on the `ToolTip` line, and keep the line's alignment.
- If there is no `ToolTip` line, add one in the constructor next to `Text` or above `Type`, aligned like its neighbours.
- Use the Edit tool or a quoted heredoc. An unquoted `sed` or `perl` substitution once put a backslash before every character of the tooltip lines.
- Keep each file's byte-order mark and line endings. Both repos have `core.autocrlf=true`, so working copies are CRLF.
  - Git Bash `sed -i` strips the CRs. If you used it, put them back (`sed -i 's/$/\r/'`).
  - Then truncate a CR that this leaves after the last line of a file with no final newline. Otherwise git sees every line as changed.
- Don't touch button text, availability classes, XAML or command code.

## 5. Draw the icons (buttons whose state is `placeholder` or `missing`)

### Metaphor

The glyph is the tooltip's **object + action**, never the class internals. Use one action badge per verb across the whole set, so a user learns them:

| Action (tooltip verb) | Badge | Color |
|---|---|---|
| runs, updates, reloads | circular arrows | JHK green |
| creates, adds | plus | JHK green |
| writes a report or exports a file | disc with an up arrow cut out | JHK green |
| sets or edits parameters | pencil | JHK green |
| locates, shows coordinates | crosshair ring | JHK green |
| developer test or sandbox | lab flask | JHK green |
| deletes, erases | X | JHK red |
| purges, clears, removes | disc with a minus cut out | JHK red |
| (only shows or copies something) | no badge; the object alone | |

Map objects to simple shapes:

| Object | Shape |
|---|---|
| model or element | isometric cube |
| view | frame with a mountain |
| selection | dashed marquee |
| family | nested squares |
| parameter | tag |
| category tree | indented list |
| filter | funnel |
| material | shaded sphere |
| people | two figures |
| schedule | table with a header band |
| storage | database cylinder |
| clipboard | clipboard |
| pipe | straight with flanges |
| project location | globe |
| code | `{ }` braces |
| ribbon button | rounded square |

Siblings share the object and differ by badge, or share the badge and differ by object. Every icon must still be recognizable and distinct from its siblings at 16 px by shape alone. Never put text, letters or trademarked marks in an icon.

Reuse an existing icon when one already fits. List them with `ls <RibbonIcons folder>` and look at a few with the Read tool. Don't draw a near-duplicate.

### Colors (from jhkelly.com, checked 2026-11-02)

| Token | Hex | Use |
|---|---|---|
| **JHK green** | **`#016043`** | **Every action badge.** The user's brand color; don't substitute a brighter green. |
| JHK red | `#DC3545` | Destructive badges only (delete, purge) |
| object | `#5E6F80` | Main object fill and outline (the slate gray of the existing ribbon icons) |
| object detail | `#8A97A4` | Inner detail, highlights, secondary figures |

- jhkelly.com's own colors are only JHK green `#016043` and neutral grays (`#2F2F2F`, `#444444`, `#696969`, `#707674`). Its teal, yellow and bright green are Bootstrap's alert colors, not the brand.
- `#016043` is dark, so badges are faint on Revit's dark ribbon theme. The user chose it anyway. Mention it when you show the set, but don't change it.
- No pure black or white as ink. `#000000` and `#FFFFFF` appear only inside the knockout masks.

### Masters

Two SVG masters per icon, named by `ImageName`:

- `<Name>.svg`: drawn on a 32 px grid, glyph inside 2–30, about 2 px strokes.
- `<Name>.16.svg`: drawn separately on a 16 px grid, glyph inside 1–15, about 1 px strokes snapped to the pixel grid, fewer parts. It is not the 32 px master scaled down.

Shared rules:

- Draw objects in the top-left and badges in the bottom-right, centered at (22,22) on the 32 px grid and about (11,11) on the 16 px grid.
- Cut the badge out of the object with a mask (a black circle, or a stroked copy of the badge shape), so there's a gap between them on any background.
- Use filled shapes only: no live strokes and no text.
- Give the groups ids (`object-…`, `action-…`) so a designer can refine them in Figma; the SVG imports into Figma as editable vectors.

`scripts/icon-masters.sh` is the library from the 2026-11-02 set. It has every badge above, about 20 objects, and an `icon <Name> <object> <badge>` function that writes both masters. To make a new icon:

1. Copy the script to the scratchpad.
2. Add any new object as `o32_<name>` and `o16_<name>` variables.
3. Replace the `icon` lines at the bottom with the icons you need.
4. Run it: `bash icon-masters.sh <svg folder>`.

### Render

There is no Python, Node, Inkscape or ImageMagick on this machine, and headless Edge doesn't write screenshots. Render in the built-in browser with the bundled server instead:

1. Copy `scripts/icon-render` to the scratchpad (not the skill folder: `dotnet run` writes `bin/` and `obj/`). Put the masters in its `svg/` subfolder.
2. Add an `icon-render` configuration to `C:\repo\jhkweb\.claude\launch.json`, then start it with `preview_start` (port 5317):
   - `runtimeExecutable`: `dotnet`
   - `runtimeArgs`: `["run","--project","<copy>\\IconRender.csproj","--","<copy>"]`
3. In that tab, run `await window.runAll()` with the javascript tool. It does three things:
   - draws each master on a canvas at 32 or 16 px, using Chromium's renderer
   - saves `png/<Name>32.png` and `png/<Name>16.png` (8-bit RGBA, transparent)
   - shows a contact sheet: each icon at 32 and 16 px on a light and a dark ribbon swatch, and enlarged
4. Screenshot the sheet and check every icon:
   - it reads at 16 px
   - siblings are distinct
   - nothing is clipped
   - badges are cut out cleanly
5. Fix the masters and render again until every check passes. Then stop the server with `preview_stop`.

Check the PNGs: color type 6 (RGBA), exact size (`od -An -tu1 -j16 -N10 <file>` gives width, height, depth and color type).

### Wire in

- Copy `<Name>16.png` and `<Name>32.png` into the RibbonIcons folder from step 1. In v5 that's each button's own module.
- Copy both masters to the repo's `res/Masters`.
- Set the button's `ImageName` to `<Name>`. Use the same edit rules as for tooltips: only that line, keep the line endings.
- Projects embed by wildcard, so no `.csproj` change is needed.
- If a placeholder image (`Scrum16.png` and `Scrum32.png` in any RibbonIcons folder, `res/MastersOld/Scrum.psd`) is back, remove it with `git rm`, but only once no button uses it.

## 6. Verify

1. Rerun the inventory. No button should show `(none)` for its tooltip, `placeholder` or `missing`.
2. `git -C <repo> diff -U0 -- '*.cs' | grep -E '^[+-][^+-]' | grep -v -E 'ToolTip|ImageName'` must print nothing.
3. `git -C <repo> diff --stat -- '*.cs'` shows one changed line per edited button. If it shows a whole file, the line endings broke (see section 4).
4. Build every year without installing:

   ```bash
   dotnet build /c/repo/jhkweb/Kelly-Revit-v4/Kelly.Revit.slnx -c 2024 -p:GeneratePackageOnBuild=false "-p:CustomAfterMicrosoftCommonTargets=C:\repo\jhkweb\Kelly-Revit-v5\test\Tests.Revit\NoInstall.targets" -v q -nologo
   ```

   - Repeat for 2025 and 2026, and for `Kelly-Revit-v5/Kelly.Revit.slnx`.
   - v4 must not install. The override also stops the build from renaming the other version's `.addin` manifest. v5 doesn't install anyway (warning `KTR0004`).
   - Afterwards confirm the manifests in `C:\ProgramData\Autodesk\Revit\Addins\<year>` kept their timestamps.

## 7. Report and record

**Tell the user:**

- the counts: tooltips changed, tooltips added, icons drawn, placeholders removed
- notable before/after examples
- the contact sheet, or a screenshot of it
- the orphan commands
- the broken or unfinished findings, grouped by command, with the file and the reason
- that nothing was checked in Revit: tooltips and icons can only be seen there after an install

**Record it:**

- **`Changelog.md`** of each add-in repo: add a heading `## <date> (not yet in a build): <summary>`.
- **The release notes doc**, as the memory note "Update KTR release notes" describes. v4 and v5 have separate docs. Add the user-facing line to the application tab, and update the head and version in the repo releases table when you commit.

**Commit only when the user asks.**

- Stage by explicit path: the changed push buttons, the new PNGs and masters, the removed placeholders and `Changelog.md`. Use `git add --pathspec-from-file`, because the tree may hold the user's own changes.
- Never use a path-less commit or `--amend` while other files are staged.
- No `Co-Authored-By` line.
- Push only when asked.

## Large batches

For more than about 20 buttons, split the tooltip analysis by folder across parallel subagents. Suitable groups: the assigners, the rest of Trade.All or MultiTrade, Acquired, Developer, and the trade/manager tabs. The files never overlap.

Give each subagent:

- this skill's path and its folder
- the repo paths from step 1
- the rules in sections 3 and 4
- the other version's commit, if it has one, as a head start

Tell each subagent:

- edit only its own files; don't build or commit
- return a table (file, new tooltip) plus its findings
- name any helper file after its group (`tips-assigners.tsv`). Subagents share the scratchpad and overwrite each other's files.

Afterwards:

- Read every table and make the wording consistent across groups.
- Spot-check any tooltip that rests on an inference.
- Draw the icons yourself in one pass, so the set stays consistent.
