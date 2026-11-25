# Skill Audit — 2026-11-25

Scope: the 26 skills in `C:\Users\childebran\.claude\skills`, plus `_shared/` (two files: `linear-scope.md`, `skill-framework.md`) and the project context in `C:\repo\jhkweb\.claude\skill-context\`. Inputs: the structure and cost scripts' output of today, every `description:` line, the section headings, and the baseline `2026-11-25 Skill Structure Review.md`. Nothing was edited. Each skill was checked against `_shared/skill-framework.md`. All 26 skills have a `model:` line, a bold **Model:** line and a title. Every `references/` and `scripts/` path named in a SKILL.md exists. A search for `jhkweb`, `Kelly` and `KTR` in the skills folder (outside `_shared`) found nothing. All descriptions together are 7743 characters (about 1935 tokens), loaded in every session.

## Since the last audit

`git log` for `skills` shows commits 7486224, 873ac9d and 05a5285 today. The baseline's items:

| Baseline item | Status | Evidence |
|---|---|---|
| 1. Delete the four untracked copies and the empty `readme.md` | Done | None of the four folders exists; 7486224 deleted `readme.md`. |
| 1b. Commit `scopes.json` | Done | `git status` lists no change under `skills`. |
| 2. Rename six skills | Done | 873ac9d; `dotnet-dead-code-search`, `dotnet-access-modifier-tightening`, `linear-team-estimate-check`, `linear-issue-done-check`, `dotnet-test-coverage-check` exist. 05a5285 then renamed ten more. |
| 3. Move shared build scripts and `chain-release.md` to `_shared/dotnet` | Partial | `kbuild.sh`, `pins.sh`, `revit-test.sh` now live in `skill-context/scripts/` (project text, so right). `insert-changelog.pl` (`dotnet-architecture-analysis/SKILL.md:29`) and the 9317-byte `chain-release.md` are still inside `dotnet-architecture-analysis`. The pack and repin steps are still written in several places (item 6). |
| 4. Linear scope text into the shared file | Done | `_shared/linear-scope.md` (17 lines); seven skills have a `## 1. Scope` that points to it. |
| 4b. Connector id only in the shared file | Done | No `mcp__fd1c` in any skill. |
| 4c. Merge `linear-team-estimate-check` into the hygiene check | Open | Both still exist (4381 and 3383 bytes). The baseline said "if seldom run alone"; it is your call. |
| 5. Models in frontmatter, "Models" sections cut to one line | Done | All 26 skills have `model:` and a one-sentence **Model:** line; no "Models" heading left. |
| 6. Split `work-log` | Open | `work-log/SKILL.md` is still 25613 bytes; no `references/` folder. |
| 6b. `dotnet-architecture-analysis` loads only what it needs | Partial | `references/` has four files, but SKILL.md is 15644 bytes, 644 over the 15000 limit. |
| 6c. Trim `dotnet-test-coverage-check` (15.6 KB) | Partial | Now 10185 bytes; under 15 KB, 185 over the 10 KB goal. |
| 7. `repository-activity-report`: title, "Use for" clause, no repeated git gathering | Done | Title at line 9; description has "Use for"; `work-log/scripts` has no `day-facts.sh` copy. |
| 7b. Turn `skill-cost-audit` into `skill-audit` | Done | `skill-audit` exists with `scripts/structure.sh` and `scripts/cost.sh`. |

Counts: 8 Done, 3 Partial, 2 Open.

## Ranked recommendations

### 1. Overlapping triggers (real pairs)

No skill in the folder duplicates an installed one any more. These pairs would both start on one request.

1. **"Update the READMEs"**: `repository-docs-update` and the installed `anthropic-skills:update-readmemd-files`. Owner: `repository-docs-update`. Edit: keep its "update the changelog or READMEs" triggers; remove the installed one if you never use it.
2. **"Make an icon for this ribbon button"**: `revit-ribbon-buttons` and the installed `anthropic-skills:revit-icon-generator`. Owner: `revit-ribbon-buttons` for the project's ribbon buttons, the installed one for any other icon. Edit: in `revit-ribbon-buttons/SKILL.md:3` say "for this project's ribbon buttons".
3. **"What does this ribbon button or command do"**: `revit-ribbon-buttons` (its description ends "or what a ribbon button does") and the installed `anthropic-skills:revit-tool-analyzer` and `revit-external-command-skill`. Owner: the installed analyzers. Edit: drop that phrase from `revit-ribbon-buttons/SKILL.md:3`.
4. **"Find dead code" or "code only tests use"**: `yagni` and `dotnet-dead-code-search` (both descriptions name these). Owner: `dotnet-dead-code-search` when a project context exists, else `yagni`. Edit: in `dotnet-dead-code-search/SKILL.md:3` replace the triggers by "delete the next round, rerun the dead-code search, layered package repositories".
5. **"Audit my skills", "clean up skills", "too many skills"**: `skill-audit` and `detox`. Owner: `skill-audit`; `detox` owns the whole setup. Edit: remove "too many skills" from `detox/SKILL.md:3`; this also brings it under 400 characters (now 404).
6. **"Check or audit estimates", "issues with no estimate"**: `linear-issue-hygiene-check`, `linear-issue-estimate-update` (its description ends "or to find the issues with no estimate") and `linear-team-estimate-check`. Owners: hygiene check for missing estimates, estimate update for setting them, team estimate check for team settings only. Edit: remove that clause from `linear-issue-estimate-update/SKILL.md:3`.
7. **"Review, triage or audit the issues"**: `linear-issue-info-review` ("review, groom, triage") and `linear-issue-hygiene-check` ("audit, lint"). Owner: info review for thin descriptions, hygiene check for rule gaps. Edit: keep "audit, lint, rules" only in the hygiene check.
8. Low: **"What happened today"**: `repository-activity-report` and `work-log`. Owner: activity report for activity, `work-log` for the written log. **"Clean up my sessions"** (`session-archive`) against `detox`'s "clean up my Claude": `session-archive` owns it.

Effect: each request starts one skill; sizes do not change.

### 2. Names

1. `linear-issue-info-review` (`info` is shorthand) and `repository-docs-update` (`docs` is shorthand). Rename to `linear-issue-information-review` and `repository-documentation-update`. Rename the matching context files `skill-context/linear-issue-info-review.md` and `skill-context/repository-docs-update.md` and the folder `skill-context/repository-docs-update/` too, then search the skills, the context folder, the memory folder and the scheduled tasks for the old names. Effect: follows your no-abbreviation rule and the framework.
2. Low: `git-push-developbranch` runs two words together; `git-push-develop-branch` would match the framework. You chose the name, so this is optional.
3. Suffixes outside the framework's list (`-check`, `-review`, `-update`, `-report`): `linear-issue-add`, `linear-project-suggest`, `skill-audit`, `dotnet-architecture-analysis`, `dotnet-member-naming`, `dotnet-access-modifier-tightening`, `dotnet-dead-code-search`, `revit-ribbon-buttons`. Edit the "Name" section of `_shared/skill-framework.md` to allow `-add`, `-suggest`, `-audit`, `-analysis` and noun names, instead of renaming eight skills.

### 3. Shared code inside one skill

1. `dotnet-dead-code-search/SKILL.md:13,17,23` run `yagni/scripts/yagni.sh` and `refs.cs` and read `yagni/SKILL.md` steps 1 to 3 (the structure script flags it). Edit: move the five files of `yagni/scripts` to `_shared/yagni/` and change the paths in `yagni/SKILL.md:20,81` and the three lines above. *Lead check: optional. `dotnet-dead-code-search` builds on `yagni` by design, so pointing into the yagni skill is acceptable; move only if a third skill starts using these scripts.*
2. `dotnet-architecture-analysis/scripts/insert-changelog.pl` (listed at `SKILL.md:29`) is a generic Changelog script, and baseline item 3 asked to share it. Edit: move it to `_shared/dotnet/` and fix `SKILL.md:29` and `references/chain-release.md`.

### 4. Models

1. `dotnet-architecture-analysis/scripts/layer-moves.workflow.js:168`: the read-only audit agent has no `model` and inherits Opus. Edit: add `model: 'sonnet'`. Lines 132, 137 and 143 (implementers, reviewer, fix) and `layer-analysis.workflow.js:165` (reviewers) also have none, but `dotnet-architecture-analysis/SKILL.md:9` says they inherit Opus on purpose. Leave them.
2. `revit-ribbon-buttons/SKILL.md:4` is Opus for tooltip wording and icon ideas, with Sonnet subagents drafting. The framework reserves Opus for design judgment across files or layers. Edit: set `model: claude-sonnet-5-5` and rewrite line 9; try one run. Effect: cheaper runs of a 10314-byte skill. Your call, since wording consistency was the stated reason.
3. No skill sets its model in prose only (the structure report's section 4 is empty). The cost report's "no model" lines at `dotnet-dead-code-search:32`, `linear-issue-done-check:25`, `linear-issue-split-review:37` and `linear-issue-info-review:33` are false positives: each skill's **Model:** line names its subagents' model, and `_shared/linear-scope.md:13` sets `model: "sonnet"`.
4. Opus on `database-normalize`, `dotnet-architecture-analysis`, `dotnet-dead-code-search`, `dotnet-member-naming`, `dotnet-solid-check`, `linear-issue-done-check` and `linear-issue-split-review` matches the framework's table.

Other false positives: `detox/SKILL.md:21,128` name `~/.claude/mods/switches.json`, which does not exist now; the skill creates it when a mod is switched off. `detox/references/findings-schema.md:19-27` uses `example-skill` in a sample row; it is not a broken reference. No change.

### 5. Size

| Skill | Now | Edit | Effect |
|---|---|---|---|
| `work-log/SKILL.md` | 25613 bytes (over 15000) | Move "### Work log sections" (4408), "### Linear report sections" (2782) and "### How to gather the data" (9285) to `references/work-log-format.md`, `references/linear-report-format.md`, `references/gathering.md`, read at their step. | SKILL.md falls to about 9100 bytes; a run that skips a report saves up to 4100 tokens. |
| `dotnet-architecture-analysis/SKILL.md` | 15644 (over 15000) | Move the workflow fallback text (lines 67 to 71 and 113 to 114) to `references/chain-release.md`. | Under 15000. |
| `yagni/SKILL.md` | 12461 | Move "## 1. Target and scan" (4018) and "## 5. Act on it" (2526) to `references/`. | About 6500 bytes lighter on a run that only scans. |
| `revit-ribbon-buttons/SKILL.md` | 10314 | Move the subagent briefs (lines 129 to 142) to `references/`. | Under 10 KB. |
| `dotnet-test-coverage-check/SKILL.md` | 10185 | Move "## 5. Issues" (2454) to `references/`. | Under 10 KB. |

Descriptions over the framework's 300 characters (11 skills, counted from the `description:` lines): `yagni` 422, `detox` 404, `skill-audit` 354, `work-log` 352, `dotnet-architecture-analysis` 338, `dotnet-test-coverage-check` 336, `dotnet-access-modifier-tightening` 334, `repository-docs-update` 332, `revit-ribbon-buttons` 315, `database-normalize` 306, `linear-issue-dependency-check` 304. Cutting each to 300 removes 497 characters, about 124 tokens per session. Edit: drop the trailing trigger phrases that item 1 already removes.

### 6. Repeated procedures (one copy each)

| Procedure | Written in | Put the one copy in |
|---|---|---|
| Pack bottom-up and repin, with the package traps | `dotnet-dead-code-search/SKILL.md:35`, `dotnet-member-naming/SKILL.md:16,35,37`, `dotnet-member-naming/references/rename-pass-brief.md:20`, `dotnet-architecture-analysis/references/chain-release.md` (9317 bytes) and `SKILL.md:89,113` | The project context, one file `skill-context/dotnet-package-release.md` (versions, pack options and repin steps are project text). Each skill keeps one pointer line. |
| File the issues (title, description, label, estimate) | `dotnet-dead-code-search/SKILL.md:31`, `dotnet-test-coverage-check/SKILL.md:58-64`, `dotnet-member-naming/references/file-issues-brief.md` (2649 bytes), `dotnet-architecture-analysis/references/linear-filing.md` (4404 bytes) | The project context's issue rules (`skill-context/linear-teams.md`); the generic steps (check for a duplicate, one team per issue) to `_shared/linear-filing.md`. |
| "Each subagent gets the team, its repository path, its keys when split, the fetch ..." | `linear-issue-done-check/SKILL.md:25`, `linear-issue-info-review/SKILL.md:33`, `linear-issue-split-review/SKILL.md:37`, `linear-issue-estimate-update/SKILL.md:41` | `_shared/linear-scope.md`; each skill keeps only its extras. |
| "Write the proposal to the dated report file the project context names" | `linear-issue-estimate-update/SKILL.md:51`, `linear-issue-split-review/SKILL.md:63` (the cost report's one repeated line) | The framework's "Reports" section already says it; replace both with a short pointer. |
| Issue description sections ("Where", "Problem / Goal") | `linear-issue-info-review`, `linear-issue-split-review` (same headings) | The project context's issue rules, shared with `linear-issue-add`. |

Effect: a rule change lands once. The identical headings "## 6. Apply, after approval" in the info review and the split review hold different steps; leave them.

### 7. Smaller items

- `repository-activity-report/SKILL.md:4-5` is the only skill with `argument-hint` and `allowed-tools` in its frontmatter; the framework has neither. Keep them, and say so in the framework.
- `linear-team-estimate-check`: decide whether to merge it into the hygiene check (baseline item 4c).

## No change needed

- `database-normalize`: Opus fits; 7658 bytes; description 6 characters over.
- `detox`: only item 1.5 and the description length.
- `dotnet-access-modifier-tightening`: only the long description (334).
- `dotnet-architecture-analysis`: sizes (item 5) and the workflow model (item 4.1) only.
- `dotnet-dead-code-search`: only items 1.4, 3.1 and 6.
- `dotnet-member-naming`: only the repeated procedures (item 6).
- `dotnet-solid-check`: Opus matches the framework.
- `dotnet-test-coverage-check`: 185 bytes over the 10 KB goal; long description.
- `git-push-developbranch`: 2383 bytes; Sonnet fits a push that can't be undone; name only (item 2.2).
- `linear-issue-add`: fine; its suffix is outside the framework list.
- `linear-issue-dependency-check`: description 304; otherwise fine.
- `linear-issue-done-check`: Opus is justified by the bulk close; the "no model" lines are false positives.
- `linear-issue-estimate-update`: only the trigger overlap (1.6) and repeated lines (6).
- `linear-issue-hygiene-check`: Haiku subagents are named; fine.
- `linear-issue-info-review`: only the name (2.1) and the trigger overlap (1.7).
- `linear-issue-split-review`: Opus matches the framework.
- `linear-project-suggest`: fine.
- `linear-team-estimate-check`: fine; the merge question stays open.
- `repository-activity-report`: fine.
- `repository-docs-update`: only the name (2.1) and the overlap with the installed skill (1.1).
- `revit-ribbon-buttons`: items 1.2, 1.3, 4.2 and 5.
- `session-archive`: fine; 6802 bytes.
- `skill-audit`: fine; description 354.
- `software-delivery-report`: fine.
- `work-log`: item 5; model and scripts are right.
- `yagni`: items 3.1 and 5.
