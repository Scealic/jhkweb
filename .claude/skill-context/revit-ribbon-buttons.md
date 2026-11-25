# Context for the revit-ribbon-buttons skill

The add-in is Kelly Tools For Revit (KTR). Every ribbon button is a `*PushButton.cs` class deriving from `RibbonPushButton` (in Kelly-Revit-UI for v5). Its constructor sets `Text`, `ImageName` (icon loaded as `<ImageName>16.png` and `<ImageName>32.png` from the button assembly's embedded `RibbonIcons`), `Type = typeof(<Command>)` (some classes use `CommandType`), an optional `AvailabilityClassType` and `ToolTip`. If `ToolTip` is missing, empty or `"[tooltip]"`, Revit shows the button text. If `ImageName` is blank, `RibbonPushButton` substitutes `"Scrum"`, a placeholder image deleted on 2026-11-02, so the button now shows no icon and logs "Ribbon icon resource not found".

## Add-in trees (both on `develop`)

- **v4:** `C:\repo\jhkweb\Kelly-Revit-v4` (some checkouts: `KTR4\Kelly-Revit-v4`). Buttons under `src\`; icons in `src\Application\Graphics\RibbonIcons`, embedded by a `*.png` wildcard in `src\Revit.csproj`. Calls `Kelly-Revit-Logic-v4`, `Kelly-Windows-v2`, `Kelly-Windows-Data-v2`.
- **v5:** `C:\repo\jhkweb\Kelly-Revit-v5`. Buttons under `modules\Trade.*\` (one DLL per ribbon tab) and `src\`; each module embeds its own `Graphics\RibbonIcons\*.png`, so an icon goes into the module of the button that uses it. Calls `Kelly-Revit-UI` (which holds `RibbonPushButton`), `Kelly-Revit-Logic-v5`, `Kelly-Domain`, `Kelly-Windows-v3`, `Kelly-Windows-Data-v3`.
- Ask the user which version when not stated; offer both.

## Inventory

`PLACEHOLDER_IMAGE=Scrum bash C:/Users/childebran/.claude/skills/revit-ribbon-buttons/scripts/inventory.sh /c/repo/jhkweb/Kelly-Revit-v5 [path filter]`; v4: `.../Kelly-Revit-v4` (or `KTR4/Kelly-Revit-v4`). Defaults match Kelly's layout (`modules`, `Graphics/RibbonIcons`, `src/Application/Graphics/RibbonIcons`, `src/Graphics/RibbonIcons`). Other environment variables: `RIBBON_BUTTON_BASE`, `MODULE_FOLDER`, `ICON_SUBFOLDER`, `HOST_ICON_FOLDERS`.

## Tooltips

- Don't name "Kelly Tools For Revit" or "KTR" in a tooltip.
- User-facing names: parameters such as `JHK Line Number`, `JHK BOM Type`, `JHK Item Number`; the combo box "Line Number Selector"; folder path example `C:\\Projects\\Revit\\<project title>`. Example tooltip: "Clears JHK Item Number and the Revit Item Number on the selected fabrication ductwork. Other selected elements are ignored."
- Data-based facts: a weld location code read from the terminology CSV decides Shop or Field. Information needed first: an assigner combo value, a Kelly project, fabrication parts. Session-wide example: `UpdaterRegistry` on or off applies to all open projects.
- Sibling groups: the hide, isolate, line-color and fill-color filters across the assigner contexts; the align and distribute buttons; the schedule export variants; the weld location codes; the three manual updaters.
- Both repositories have `core.autocrlf=true`.
- Large-batch groups: the assigners, the rest of Trade.All or MultiTrade, Acquired, Developer, and the trade and manager tabs.
- The other version's commit may serve as a head start.

## Icons

- Brand: the JHK colours (branding repository jhkelly-ui palette). Ink `#2F2F2F` (jhkelly.com charcoal); **JHK green `#016043`** for every action mark and accent, never a brighter green; JHK red `#DC3545` for delete, remove, clear and purge marks only. Dark-theme icons are KTR5-4623.
- Since 2026-11-12 (KTR5-4844) every v5 ribbon icon but `JHKLogo` is drawn in the Assigners pane line style (the pane's `AssignerPaneIcons.xaml`, KTR5-4843), which the maintainer chose.
- Masters script: `C:\repo\jhkweb\.claude\skill-context\revit-ribbon-buttons\icon-masters.sh <svg folder>` (holds the colours and the whole Kelly icon set).
- Render with the bundled `scripts/icon-render` server (port 5317) through the `icon-render` entry of `C:\repo\jhkweb\.claude\launch.json`.
- Wire in: icons go into the RibbonIcons folder of the button's own module (v5), and into every folder that already holds the name (some names are in several modules; the Context icons are also in Trade.All's `Graphics/WindowIcons`). Masters go to the repository's `res/Masters`. The placeholder is `Scrum16.png` and `Scrum32.png` in any RibbonIcons folder and `res/MastersOld/Scrum.psd`; `git rm` it once no button uses it.

## Build and verify

```bash
dotnet build /c/repo/jhkweb/KTR4/Kelly-Revit-v4/Kelly.Revit.slnx -c 2024 -p:GeneratePackageOnBuild=false "-p:CustomAfterMicrosoftCommonTargets=C:\repo\jhkweb\Kelly-Revit-v5\test\Tests.Revit\NoInstall.targets" -v q -nologo
```

Repeat for 2025 and 2026, and for `Kelly-Revit-v5/Kelly.Revit.slnx`. v4 must not install; the override also stops the build from renaming the other version's `.addin` manifest. v5 doesn't install anyway (warning `KTR0004`). Afterwards confirm the manifests in `C:\ProgramData\Autodesk\Revit\Addins\<year>` kept their timestamps.

## Record

- `Changelog.md` of each add-in repository: heading `## <date> (not yet in a build): <summary>`.
- The release notes document, as the memory note "Update KTR release notes" describes. v4 and v5 have separate docs. Add the user-facing line to the application tab, and update the head and version in the repository releases table when committing.
- Commit with no `Co-Authored-By` line; push only when asked.
