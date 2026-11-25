# Skill structure review (2026-11-25)

Scope: the 33 folders in `C:\Users\childebran\.claude\skills` (about 700 KB; 32 `SKILL.md` files, about 265 KB of them). This review covers organization, overlap, naming and shared code. Token cost is covered by the Skill Cost Audits beside this file; the last one is from 2026-11-05.

## 1. Delete or resolve: four untracked copies (high)

These four were added today (untracked in `~/.claude` git). Each one is also loaded from the organization's plugin as `anthropic-skills:<name>`.

| Folder | Problem | Recommendation |
|---|---|---|
| `revit-external-command` | Its frontmatter name `Revit-External-Command-Skill` doesn't match the folder and uses capitals. It refers to a `LICENSE.txt` that doesn't exist. It hard-codes one command (`ModuleManageCommand`) and the path `C:\repo\jhkweb\Kelly-Revit\src\...`, which no longer exists. `revit-tool-analyzer` covers everything it does. | Delete it. |
| `revit-tool-analyzer` | Duplicates the organization copy. It overlaps the analysis step of `kelly-ribbon-buttons` and `dotnet-architecture-analysis` only loosely. | Keep only one copy. Keep the personal copy only if you plan to tailor it to Kelly (layers, `OperationService`); otherwise delete it. |
| `revit-icon-generator` | Duplicates the organization copy. It conflicts with `kelly-ribbon-buttons/references/icons.md`, which sets the JHK green palette and the Kelly icon sizes. The two skills will both trigger on "make an icon". | Delete it. Say "for Kelly ribbon icons use kelly-ribbon-buttons" in `icons.md`, or fold the generic metaphor guidance into `icons.md`. |
| `update-readmemd-files` | A 145-byte stub: "Update the readme file for this repository". It overlaps `kelly-docs-update`, which does this properly. | Delete it. |

Also: the empty `readme.md` at the folder root, and the uncommitted change to `dotnet-architecture-analysis/references/scopes.json`, which should be committed.

## 2. Renames

The renames are cheap: each name below is referenced in one or two places at most, and no scheduled task uses any of them.

| Now | Rename to | Why | References to update |
|---|---|---|---|
| `dotnet-deadcodesearch` | `kelly-dead-code-search` | The words are run together, and the skill is Kelly-specific (`yagni` is the generic one) | `yagni/SKILL.md` |
| `dotnet-architecture-analysis` | `kelly-architecture-analysis` | Kelly-specific (its description names Kelly Tools For Revit) | `kelly-member-naming/SKILL.md`, memory `no-mvvm-types-leave-kelly-revit.md` |
| `dotnet-accessmodifier-tightening` | `dotnet-access-modifier-tightening` | The words are run together; it is generic, so `dotnet-` is right | none |
| `linear-estimate-isexponential` | `linear-team-estimate-check` | It checks team settings, not issues; "isexponential" is two words run together | `linear-issue-estimate-update/SKILL.md` |
| `linear-issue-check-isdone` | `linear-issue-done-check` | Matches the `linear-issue-*-check` family | `_shared/linear-teams.md` |
| `tdd-coverage-check` | `kelly-test-coverage-check` | Kelly v5 only; matches the prefix rule below | none |

This gives one prefix rule: `kelly-` for anything tied to `C:\repo\jhkweb`, `dotnet-` / `linear-` only for generic skills, and no prefix for the rest (`yagni`, `work-log`, `session-archive`, `detox`). Keep `work-log` and `kelly-develop-push` as they are, because scheduled tasks call them by name.

## 3. Shared .NET build scripts live inside one skill (medium)

`kbuild.sh`, `pins.sh`, `revit-test.sh` and `insert-changelog.pl` sit in `dotnet-architecture-analysis/scripts`, but other skills use them too:

- `kelly-member-naming` and `work-log` already point to them.
- `dotnet-deadcodesearch` ("Packing and repinning, when asked") and `kelly-member-naming/references/rename-pass-brief.md` each write out the bottom-up pack and repin procedure again in prose.
- `dotnet-architecture-analysis/references/chain-release.md` holds a third, fuller copy.

Move the scripts and `chain-release.md` to `_shared/dotnet/`, and replace the two prose copies with a one-line pointer. A rule change to packing (KTR0003 on same-minute packs, the `SolutionName` trap) then lands in one place.

## 4. Linear family: the scope boilerplate is still repeated (low to medium)

`_shared/linear-teams.md` already factors out the teams, the meaning of "open" and the Hasa rule. Each of the six `linear-issue-*` skills still opens with about 1 KB of near-identical text:

- default every open Kelly issue;
- narrow by team, project, label or keys;
- list titles first to size each team;
- the subagent's `list_issues` call, then `get_issue` / `list_comments` when truncated.

Put the common scope paragraph in the shared file. Each skill then keeps only its exceptions: estimate-update includes Hasa, hygiene-check includes issues closed since 2026-11-09, split-review skips parents. Each skill also keeps its own `fields` list.

Two more Linear points:

- `linear-estimate-isexponential` is a team-settings check that could be one section of `linear-issue-hygiene-check` (the hygiene check already checks estimates per issue). Merge it if you seldom run it on its own.
- The connector's id (`mcp__fd1c18e3-...`) is hard-coded in `linear-issue-add`, `software-delivery-report` and `_shared/linear-teams.md`. Keep it only in the shared file, because a reconnected connector gets a new id.

## 5. Models: use frontmatter instead of prose (low)

Only four skills set `model:` in their frontmatter. Eight others spend 250 to 670 characters each on a "Models" section explaining the choice. The prose is advisory only: the session's model is used anyway.

- Add `model: claude-sonnet-5-5` to `kelly-docs-update`, `kelly-linear-projects` and `kelly-repo-activity`, the skills whose prose says "run it in a Sonnet session".
- Cut every "Models" section to one line naming the subagent models. The reasons behind the choices belong in the commit message.

## 6. Oversized skills: load the format on demand (medium)

| Skill | Size | Split |
|---|---|---|
| `work-log` | 26 KB | The format specifications of the four outputs (log, summary, savings, Linear report) total about 11 KB, and "How to gather the data" about 9.5 KB. Move each output's format to `references/<output>.md` and the gathering steps to a script plus a short list. |
| `dotnet-architecture-analysis` | 22 KB + 22 KB `placement-rules.md` | Already split into references. Check that the Analyse-only path doesn't load `chain-release.md` or `linear-filing.md`. |
| `tdd-coverage-check` | 15.6 KB | "Traps met before" can move to a reference read only when a step fails. |

## 7. Smaller items

- `kelly-repo-activity` has no `# Title`, and its description has no "Use when" clause, so it rarely triggers. Its git gathering repeats `work-log/scripts/day-facts.sh`. Either make it call that script with a date range, or drop it and let `work-log` answer "what happened in the repositories this week".
- `skill-cost-audit` covers cost only. Adding this review's checks (duplicates of organization skills, frontmatter that doesn't match the folder, stale paths, shared code living inside one skill, naming) would make it a repeatable `skill-audit`. That also overlaps the skills part of `detox`.
- Many skills point to `C:\repo\jhkweb\KTR4\...` paths, which don't exist because the v4 repositories aren't checked out. That is expected; the skills already say to `ls` first.
- `_shared` has one file. If section 3 is done, it becomes `_shared/linear-teams.md` plus `_shared/dotnet/`.

## Suggested order

1. Delete the four untracked copies and `readme.md`; commit `scopes.json`.
2. Rename the six skills and their references.
3. Move the build scripts and `chain-release.md` to `_shared/dotnet`.
4. Factor the Linear scope text and the connector id into the shared file.
5. Change the "Models" sections to frontmatter.
6. Split `work-log`.
