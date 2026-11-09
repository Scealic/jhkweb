# Linear: Kelly Tools For Revit rules

The rules shared by every Linear team are in `BuildConfigs/LINEAR.md`. This file adds what concerns the Kelly Tools For Revit (KTR) teams. It sits at the jhkweb root because the lower layers, BuildConfigs and the schema repos may not name the application, while their issues may still belong to a KTR team.

## Teams

- The workspace is "Kelly Tools For Revit", `https://linear.app/jhkelly-ktr` (named "jhkelly" until 2026-11-09; old `linear.app/jhkelly` links redirect).
- Kelly Tools For Revit 5 (KTR5) ← Kelly-Revit-v5, with Kelly Revit Logic 5 (KTRL5) ← Kelly-Revit-Logic-v5 and Kelly Revit UI (KTRUI) ← Kelly-Revit-UI.
- Kelly Tools For Revit 4 (KTR4) ← Kelly-Revit-v4, with Kelly Revit Logic 4 (KTRL4) ← Kelly-Revit-Logic-v4.
- The full map of every Kelly team to its repository is in `C:\Users\childebran\.claude\skills\_shared\linear-teams.md`. Re-check with `list_teams`: teams are added and re-parented.

## Rules

- Items that cover a whole major version go to that version's add-in team (KTR4 or KTR5), whichever layer turned them up.
- KTR5 issues get a label from the group "5 - Feature" (the command, control, cache, handler or service) and from "5 - Module" (Trade.All, Trade.Pipe, Trade.Duct, Trade.Contenter, Trade.Manager, Trade.Developer, Host). Never create a per-tool project; a feature is a label.
- Name Kelly Tools For Revit or KTR only in the issues of the KTR* teams; issues in the other Kelly teams describe the code without naming the application.
- Say "Major Version 4" or "v4", never "Generation".
