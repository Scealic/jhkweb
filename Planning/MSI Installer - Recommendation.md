# Kelly Tools For Revit 5 MSI installers: recommendation

2026-11-12, KTR5-4601. Builds on [the role matrix](MSI%20Install%20Types%20-%20Role%20Matrix.md). The proof of concept is in [`MSI Installer PoC`](MSI%20Installer%20PoC/).

## Recommendation in one paragraph

Build the installers with **WiX Toolset 5.0.2** (`WixToolset.Sdk`), the same tool and version as Component Data Editor's installer (CDE-7). Use one installer project in Kelly-Revit-v5 that builds **five MSIs, one per install type**. Each MSI holds **all three Revit years** and the data files, and all five share **one UpgradeCode**, so installing another role replaces the one already installed. The proof of concept built all five MSIs today from the existing Release output, with no errors or warnings.

## What the proof of concept showed

| Check | Result |
|---|---|
| Build, all five roles (`dotnet build -p:Role=<role>`) | Succeeded, 0 warnings, 0 errors, about 18 MB per MSI |
| Files per year (admin-extracted with `msiexec /a`, which installs nothing) | 2024: 33 host DLLs + modules; 2025/2026: 28 + modules. That matches the files a developer build installs today (`*.dll` from the output; no `.config`, `.xml` or satellite folders) |
| Modules per role | Detailer and Third Party: All, Pipe, Duct. Lead Detailer / Manager: + Contenter, Manager. Matches the matrix |
| `.addin` manifests | Generated at build time for each year, the same content the build writes (AddInId `…1925<year>`, `Kelly.Revit.Core.App`, absolute path under `V5\<year>`) |
| Data files | 23 CSVs + the exporter's `manifest.json` in the shared `Kelly Tools For Revit\Data` |

**Not yet verified:** no real install, upgrade, role switch or uninstall was run (that would replace the add-in on this machine), and Revit has not loaded the add-in from an MSI install. Follow-up issue below.

## Decisions and why

### Tool: WiX 5.0.2, not InstallShield

- WiX is already the house tool (Component Data Editor), it builds with `dotnet build` (no IDE, no per-machine licence), and the source is plain XML in git, which diffs and reviews well.
- InstallShield 2025 is installed and has a command-line builder (`IsCmdBld.exe`), but the existing InstallShield project is in none of the jhkweb repos, every build machine needs a licence, and `.ism` files diff poorly.
- Stay on **WiX 5.x**. Check the licence terms before moving to WiX 6 or later: as I understand it, they come under the "Open Source Maintenance Fee", which charges organisations that earn revenue from them.

### Layout: one MSI per role, all years inside

- 5 MSIs, not 15: a user who has Revit 2024 and 2026 runs one installer. Each year is a feature with its own folder (`V5\<year>`) and manifest, exactly as the build lays them out today.
- A year whose Revit is not installed just gets an unused manifest. Later, each year's feature could be conditioned on that Revit being installed (a registry search), but that isn't needed now.
- Roles are a build-time property (`-p:Role=…`) that switches the module files on and off in one source (`Year.wxi`). The role → module list lives in one place, the `.wixproj`.

### Upgrades and versions

- MSI ProductVersion takes the first three parts, which `5.yy.MMdd` fits (5.26.1112), and **ignores the fourth** (HHmm). So two builds on one day count as the same version. `MajorUpgrade AllowSameVersionUpgrades="yes"` lets the later build replace the earlier one; CDE does the same and suppresses ICE61 for it. *This corrects the earlier note that the version was too large for an MSI.*
- **One UpgradeCode for all five roles.** The roles install to the same folders, so only one can be installed at a time. Installing another role (or a newer build of any role) removes the old one first.

### Side by side with v4

- The build renames the other versions' manifests to `.addin.x`. The MSI does the same with `CopyFile Delete="yes"` (MSI's MoveFile) for `Kelly Tools For Revit 4.addin` and the unversioned `Kelly Tools For Revit.addin`, and removes a leftover `Kelly Tools For Revit 5.addin.x`. Uninstalling v5 does not rename v4's manifest back; the user reinstalls v4 or renames it by hand, as with builds today.
- **Risk: the data files are shared with v4.** If the v5 MSI owns `Data\*.csv`, uninstalling v5 deletes the files v4 needs. Mark the data components **Permanent** (never removed on uninstall), or put the data in its own MSI that both versions depend on. Recommended: Permanent now, a separate data MSI only if data starts updating more often than the code.

### Third Party

- Same MSI build as Detailer with a different name, plus the data files (decided 2026-11-12).
- Before it leaves the company: code signing (below), licence terms, and `Data\manifest.json`, which records the exporting user's Windows account and the stored procedure names. Strip those for a third-party build, or leave the manifest out.

### Signing

- No `signtool.exe` on this machine (no Windows SDK) and no code-signing certificate in the build. Unsigned MSIs show "Unknown publisher" in UAC. Internal installs can live with that for now; Third Party should not. This needs a certificate from IT.

## Build steps (as the proof of concept runs)

1. Build Kelly-Revit-v5 in Release for 2024, 2025 and 2026, without installing it (the jhkweb `Directory.Build.targets` guard already prevents the install).
2. `dotnet build installer\KellyToolsForRevit.Installer.wixproj -p:Role=<role> -p:Version=<build version>` for each of the five roles (copy each MSI out between runs; the SDK's incremental clean deletes the previous role's MSI).
3. The data files are taken from `C:\Program Files\JH Kelly\Kelly Tools For Revit\Data` (`-p:DataRoot=` to point elsewhere, e.g. the exporter's output).

## Follow-up issues

- **KTR5-4833** (4 points): move the installer into Kelly-Revit-v5, with one command that builds all five roles, Permanent data components and a shared `.addin` source.
- **KTR5-4834** (2 points, blocked by KTR5-4833): install, upgrade, role switch and uninstall on a clean machine with v4 installed.
- **KTR5-4835** (2 points): code-sign the MSIs and assemblies.
