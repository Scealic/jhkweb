# MSI install types: role-to-module matrix (draft)

Draft 2026-11-12 for KTR5-4601. Kelly Tools For Revit 5 only. Every row marked **?** needs the maintainer's decision.

## Building blocks

The add-in (`Kelly.Revit.dll`, its Kelly packages, the `.addin` manifest and the data files) goes into every install. Each ribbon tab is one module DLL, loaded only when its file is beside the add-in (`RibbonService.LoadModulesAndCreateRibbons`), so an install type is a choice of these files:

| Module DLL | Tab | What it holds (commands in the module) |
|---|---|---|
| `Kelly.Revit.Trade.All.dll` | Tools | Assigners (Service, System, Line, Module, Spool, Detailing Package numbers) and their pane; spools (create, manager, sheets); modules; layout points and grid; arrange and tag tools; bill of material setters; supports, trapeze and hangers; view filters and colors; schedule export (CSV/XLSX); updaters; Reload Data, About (~120 commands) |
| `Kelly.Revit.Trade.Pipe.dll` | Pipe | Weld locations (shop, field, tack), olet check, valve clearance spheres |
| `Kelly.Revit.Trade.Duct.dll` | Duct | Duct item numbers, length and mirror checks |
| `Kelly.Revit.Trade.Contenter.dll` | Content | Fabrication custom data reports and updaters, hanger and part logs, product code check, revision setter |
| `Kelly.Revit.Trade.Manager.dll` | Manage | Delete elements by id, unused families and unused shared parameters; coordinate reports; shared parameter bindings report |
| `Kelly.Revit.Trade.Developer.dll` | Develop | Diagnostics and data dumps (categories, filters, materials to CSV), extensible storage and parameter clean-up, sandbox and mockups |

## Draft matrix

✓ = installed, – = not installed.

| Install type | Tools | Pipe | Duct | Content | Manage | Develop | Notes |
|---|---|---|---|---|---|---|---|
| Detailer | ✓ | ✓ | ✓ | – | – | – | Day-to-day detailing |
| Lead Detailer / Manager | ✓ | ✓ | ✓ | – | ✓ | – | Adds model clean-up and reports. **?** How it differs from Manager |
| Manager | ✓ | ✓ | ✓ | ✓ | ✓ | – | **?** Content for checking fabrication data, or not |
| Content Developer | ✓ | ✓ | ✓ | ✓ | – | – | **?** Needs Tools/Pipe/Duct at all, or Content only |
| Third Party | ✓ | ✓ | ✓ | – | – | – | **?** See the Third Party questions below |
| Developer | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | Everything |

## Findings that shape the design

1. **Roles and trades cross.** Pipe and Duct are trade tabs, not role tabs. Either every detailer role gets both (as drafted), or each role comes in Pipe and Duct variants (12 install types), or trade is an install option (an MSI feature or property) rather than a separate MSI. Recommendation: trade as a feature of one MSI.
2. **Tools is too coarse for role control.** About 120 of the ~170 commands are in `Trade.All`. Any role that should not have, say, Spool Manager, Module Creator or the updaters can't be served by leaving out a DLL. If roles must differ inside Tools, that needs either more module splits (as KTR5-4585 did for the tabs) or a role setting read at startup that hides panels. Recommendation: keep DLL-level roles for now; split only where a real need is named.
3. **Lead Detailer / Manager and Manager may be one install.** As drafted they differ only by Content. If that is not the intended difference, they can merge.
4. **Hiding a tab is not a security boundary.** The other modules' code is still on the machine through the shared Kelly packages (Logic, UI), and anyone can copy a DLL across. That's fine for internal roles, but it matters for Third Party.

## Third Party questions

- Who are they? Do they work in JH Kelly models or their own?
- Do they get the data files (`...\Kelly Tools For Revit\Data`)? Those hold JH Kelly's lists and shared parameter definitions, and the add-in fails startup without them.
- Is the Tools tab acceptable as is (Stratus views, JH Kelly numbering, spools), or do they need a reduced Tools tab? A reduced tab means splitting `Trade.All` (finding 2).
- Licence terms and code signing for an MSI that leaves the company.

## What this means for the MSI

- One shared component group (the add-in, packages, manifest, data files) plus one feature per module DLL.
- An install type is a preset of features: either six MSIs built from one source with different feature sets, or one MSI with a `ROLE=` property that selects the preset (simpler to build and upgrade; the role can be changed by reinstalling).
- Revit years 2024-2026 as features of the same MSI, each with its own folder and manifest, as `AddinInstall.Build.targets` lays them out today.
