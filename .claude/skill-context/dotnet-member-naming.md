# Context for the `dotnet-member-naming` skill: Kelly v5 layers under `C:\repo\jhkweb`

Read by the skill before step 1. The Linear teams are in `.claude/skill-context/linear-teams.md`.

Kelly-specific versions of the four briefs (the generic ones are in the skill's `references/`) and the slicing script are in `.claude/skill-context/dotnet-member-naming/`. Give the agents the Kelly brief in addition to the generic one; the Kelly brief holds the full project rules (workspace "Virtual Construction", `jhkelly-ktr`, KTR5 labels, build and pack commands, paths):

| File | Use |
|---|---|
| `slices.sh` | Check step 2: source lines per repository and folder, for slicing (`bash slices.sh [root]`, default `C:\repo\jhkweb`) |
| `reader-brief.md` | Readers |
| `verify-brief.md` | Reviewers; reports go to `C:\repo\jhkweb\Planning\Member Naming\<date> Pass <n> <layer>.md` |
| `file-issues-brief.md` | Linear filers |
| `rename-pass-brief.md` | Rename agents |

## The stack

```
Kelly-Windows-Data-v3 (+ -Csv, -Json, -Sqlite, -SqlServer) → Kelly-Windows-v3 → Kelly-Domain → Kelly-Revit-Logic-v5 → Kelly-Revit-UI → Kelly-Revit-v5 (src host + modules)
        Net481 / Net80 / Net100                                                  2024 / 2025 / 2026
```

## Runs so far

Reports in `C:\repo\jhkweb\Planning\Member Naming\`, approach and lessons in `C:\repo\jhkweb\Planning\Member Naming Check.md`; commit the reports to the jhkweb root repository.
- **2026-11-11, pass 1** (KTR5-4798): about 40 rename issues and 20 bugs. All renames applied and pushed the same day.
- **2026-11-11, pass 2**: 52 rename issues (KWD3-16..18, KWDC-4, KWDSS-9, KW3-42..48, KD-74..81, KTRL5-157..174, KTRUI-35..38, KTR5-4816..4825) and 25 bugs (17 new: KD-72/73, KW3-38..41, KTRL5-150..156, KTR5-4811..4815; 8 comments on existing issues).

**Last checked against the repositories: 2026-11-11.**

## Standing rules (maintainer decisions)

- **Never use `UBIQUITOUS-LANGUAGE.md` to judge or suggest a name** (2026-11-11). Take terms from the code: the term it uses most for a concept, and the Revit API or data-file name. Two words for one concept is a finding. The glossary is updated after all naming work (KTR5-4809).
- **No `Transaction`, `Tx`, `Operation` or `WithOperation` suffix** on methods (KTRL5-149). The XML docs say whether a method opens its own transaction. `…Core` only tells twin methods apart (one opens a transaction, the other needs the caller's). `GetTransaction` and `CreateSelectionOperation` keep their names.
- **Stored and shown values keep their values** (data-file columns, JSON keys, Revit parameter names, Undo texts, report columns) unless the issue says the shown text itself is wrong. Data-file columns are documented, never renamed (KD-68).
- **Ribbon item ids may change** when an add-in command class is renamed (2026-11-11); say so in the issue and the Changelog.
- Add-in vocabulary: AutoAssign + Toggle; SelectorReset (combo box, updater, icon) / ValueClear (clears the parameter).
- The user files bugs right away. Rename issues are filed after the user approves (all at once, or per layer).

## Model choice

Reviewers that check bugs in Logic, Kelly-Windows, Domain or the add-in modules are Opus (inherit), the small layers Sonnet.

## Check details

- Step 1: see the "Kept on purpose" lists on the last run's issues and in `Member Naming Check.md`.
- Step 2: the whole stack is about 17 slices.
- Step 4: Logic gets two reviewers.
- Step 7: three filing agents: lower layers; Logic; UI and add-in.
- Step 8: add lessons to `Member Naming Check.md`.

## Rename details

- The next of the six layers is repinned; format libraries and the exporter are repinned and packed in the same pass.
- Add-in rename: XAML bindings, resource keys, `Member=` strings and names held as text in tests (`LowerLayerRulesTests`, `RibbonMovesTests`) do not fail the build.
- Push through `git-push-developbranch`. Then lower-layer and UI issues go Done; Logic and add-in issues stay In Review until the in-Revit runs pass (the build scripts are named in `.claude/skill-context/scripts/`; the add-in suite `test/Tests.Revit/Core.Tests.csproj` runs in about a minute; run Logic one test folder at a time, because the full suite hangs) and the renamed windows are opened in Revit to check for binding errors.
- Traps: same-minute packs fail with KTR0003; mass CS0234 means a pin names a missing package.
