# KTR v5 user guides: code findings

This is a working document from writing the end-user guides on 2026-10-30. The guides are in `Kelly-Revit-v5/docs/user-guides/` and the manifest is `_index.md`. The open questions are left in the guides as `TODO: confirm` (183 in 83 guides). To list them, run `grep -rn "TODO: confirm" Kelly-Revit-v5/docs/user-guides`.

What follows are behaviors found in the code while writing: likely bugs, dead controls and misleading messages. Each was derived from reading the source, not from running it in Revit.

## Dead or no-op controls

- **Duct Length Check** and **Duct Mirror Check** collect the ductwork and return. They do nothing.
- **Turn On/Off Module Number Auto Assign** and **Turn On/Off Assembly Name Auto Assign** are always greyed out (`IsDisabledCommandEnabler`), and their commands are empty.
- **Hanger Place:** the "Stop At Direction Change?" checkbox isn't wired to anything.
- **Stratus Detailing Package Views:** the "Project Has No Detailing Packages" message can never appear, because `DetailingPackageDocumentCache` adds `DEFAULT-DP-001` when the project has none.
- **Assign Non Shop BOM View Filters:** its tooltip promises a Shop filter, but it adds Field Trim > 0, BOM = Field and BOM = Module, and no Shop filter, even though a ready-made one exists in the code.

## Wrong results or data loss

- **Spool list vs Spool Creator:** the ribbon Spool list keeps only numbers matching `<prefix>-(SPL|RCK|ESP)-<n>`. Spool Creator names spools `<line>-<category>-<seq>`, so its spools never appear in the list; Adopt Assembly Name is the only way in.
- **Auto updaters switch back on:** Suspend while already suspended pushes a second set of saved states, and Resume restores the first. Any manual update (Update Selection, Update Active View, Update Project) or a Synchronize with Central therefore turns suspended updaters back on, and the icon then shows on.
- **Auto Update State:** suspending also runs Reset All Assigners after recording the assigners as enabled, so Resume re-enables them while their icons show off.
- **Remove Service Name** may undo itself on fabrication parts: the always-on service updater rewrites the service when JHK Service Signature changes.
- **Add Service Name and Service Auto Assign** clear all four service parameters when the service isn't in the data files.
- **Update Custom Data (V1)** commits in `finally`, so a failure partway through keeps a partial update.
- **Spool Manager > Create Spool Sheets** stops in `finally`, so a missing template commits the partial work and the exception escapes.
- **Layout Export** saves the points to their elements before Save As, so the points are saved even if the user cancels.
- **The Site combo boxes on Layout Export and Import** change the project's active site.
- **UnTangle Vertically** spaces each annotation by the height of the previous one, so annotations of different heights overlap or leave gaps.
- **Distribute Tags Around** builds tag slots up to twice the crop height, so tags can land above the crop region. It also arranges every tag in the view, not just the selection.
- **Arrange tools** move any selected element, model elements included.
- **Hanger Place:**
  - Closing the options window with X still places hangers, using the first hanger in the list.
  - A start distance of 0 with a repeat distance above 0 places nothing and shows no message.
  - The hanger is matched by its list position against the fabrication ButtonIndex.
- **Many Connect:**
  - The alignment tolerance is 1e-10 degrees, so almost every pair raises the angle prompt.
  - The second element is moved but never rotated.
- **Racker:**
  - Align is both IsDefault and IsCancel, so Esc applies the change.
  - Unparseable manual text becomes 0.
  - Fabrication containment is listed but never moved.
- **Suspended Support Manager:**
  - Allow Un-Hosted Hangers never skips truly unhosted hangers (their host size is "Un-Hosted", not empty).
  - Override Size writes nothing for trapeze and pipe hangers but still clears their tags.
  - An invalid tag prefix writes an empty JHK Tag but still writes JHK Tag Signature.
- **Spool Manager:**
  - Update Tag writes the literal text "Invalid Tag '<text>'" into JHK Tag.
  - The SPL, LN and DP columns say "(Editable)" but can't be edited.
  - Create jumps to tab index 4, which doesn't exist.
- **Point To Pipe:** settings are saved in the project's Settings folder, which is emptied when the document closes.
- **Export To .csv File(s):**
  - The ", " separator has no quoting, so a value with a comma splits into two columns.
  - The file-name stamp has minute resolution.
- **Remove Unused From Project:**
  - It also deletes saved selection sets.
  - It treats filters used only in detail views, area plans or structural plans as unused.
  - Its dialog title says "Delete All Filters".
- **Line Color and Fill Color by Service/System** share filter names, so whichever runs last replaces the other's look.

## Unhandled errors (raw Revit or "JH Kelly Exception Handler" dialogs)

- **Remove Line Number, Remove Module Number and Remove Detailing Package:** an empty collection throws when no selected element has the parameter.
- **None of the view filter tools check for a view template.** The Line Color, Fill Color and Non Shop BOM tools don't catch errors at all.
- **Rotate:** an empty or unparseable angle throws. The window's X reopens the dialog.
- **Level Correct:** having no model elements or no levels throws from validation, with no user message.
- **Weld buttons:** a missing weld-location term in the data throws.
- **Interop xlsx exports:** there is no try/catch around Excel startup or each schedule.
- **Layout Export:** an empty starting scope throws from validation.
- **Layout Import:**
  - A missing layout family throws on file read.
  - After Cancel on a malformed header, it keeps going and may throw.
- **Spool Manager:** throws when the project has no "Spool - " title block.
- **Line Number and Detailing Package auto assign:** with the list on its header, they throw inside the updater, and the error is only logged.

## Misleading messages and labels

- **Spool Creator:** "could not be loaded from the server" — the list comes from the data files.
- **Update Custom Data (V2):** "Gauge Lookup Error … in SQL Server".
- **Module Manager:** the Id column's tooltip mentions SQL Server.
- **Update Custom Data (V1):** the "Workshared Elements" message shows type names instead of ids, and says "hanger(s)".
- **Adopt commands:**
  - They report failure whenever the value was new to the list.
  - "The selection contained 0 elements" appears when one element is selected but lacks the parameter.
- **Add Selected To Spool / Remove Selected From Assembly** with no spool picked: "There was no Spool Found having the number Select Spool", plus an empty undo step.
- **Add Line Number / Add Detailing Package:**
  - The checkbox reads "Set Line NumberCombo Box" (missing space).
  - Typing an existing package picks the list's last item.
- **Spool Isolate/Hide tooltips** disagree ("Spool Name" vs "Assembly Name").
- **Line Color For Spool Name** tests the assembly type name, not JHK Spool Number.
- **Hanger Place:** "'StartTransaction End Distance'" (a leftover from a rename), and "An error occured" (typo).
- **Racker:** "Elements with be aligned at:" (typo).
- **Set Part Item Number:** title "UpdateElements Item Number Warning".
- **Valve Clearance Spheres:** the "no valves" message is titled "Export Valve Information Issue".
- **Create Grid:** the tooltip says "In The View", but it works on the whole project.
- **Reload Data** gives no feedback on success.
- **BOM Field / Module / Shop** do nothing silently when no selected element has JHK BOM Type.
- **Set Revision Date** does nothing silently when the family has no "JHK" parameter.
- **Line Color For Module Number** and **Line Color For Spool Name** have no tooltip.
- **Stratus view errors** name a specific person to contact.
