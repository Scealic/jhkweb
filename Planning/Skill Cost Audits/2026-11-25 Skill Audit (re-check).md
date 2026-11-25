# Skill Audit — 2026-11-25 (re-check)

Scope: the 26 skills in `C:\Users\childebran\.claude\skills`, plus `_shared/` (now `linear-scope.md`, `package-chain.md`, `skill-framework.md` and `scripts/insert-changelog.pl`) and the project context in `C:\repo\jhkweb\.claude\skill-context\`. Inputs: the structure and cost reports of this re-check, every `description:` line, the section headings, `_shared/skill-framework.md`, and the baseline `2026-11-25 Skill Audit.md`. Nothing was edited. All 26 skills have a `model:` line, a bold **Model:** line and a title. The structure report lists only the known decisions (the `git-push-developbranch` name, the `detox` paths, `dotnet-dead-code-search` into `yagni`). Section 4 (model in prose only), section 7 (project terms) and section 8 (names shared with installed skills) are empty. All descriptions together are 7690 characters (about 1922 tokens), loaded in every session; the baseline had 7743. The biggest SKILL.md files are `dotnet-architecture-analysis` (13263 bytes), `yagni` (12408), `work-log` (11513), `revit-ribbon-buttons` (10444) and `dotnet-test-coverage-check` (10185). None is over 15000.

## Since the last audit

Commits in `skills` since the baseline (`git -C C:/Users/childebran/.claude log`): 1e0f64d (trimmed triggers, two renames, Sonnet for two agents), 2bee50c (work-log split), 51b744c (architecture trim), 7f0d537 (`insert-changelog.pl` to `_shared/scripts`), 9401628 (yagni description), c26a932 (`_shared/package-chain.md`).

| Baseline item | Status | Evidence |
|---|---|---|
| 1.1 "Update the READMEs": `repository-docs-update` against the installed `update-readmemd-files` | Open | `repository-documentation-update` still says "update the changelog or READMEs"; the installed skill is unchanged. |
| 1.2 Ribbon icons: narrow `revit-ribbon-buttons` | Done | Description now says "this project's Revit add-in" and "this project's ribbon icons". |
| 1.3 Drop "what a ribbon button does" | Done | The phrase is gone from the description. |
| 1.4 Dead code: `yagni` against `dotnet-dead-code-search` | Done | `dotnet-dead-code-search` now ends "(otherwise yagni)"; `yagni` ends with a pointer back. See item 2.3 below for the part that is left. |
| 1.5 Drop "too many skills" from `detox` | Done | Not in the description; length 404 down to 386. |
| 1.6 Drop the "no estimate" clause from `linear-issue-estimate-update` | Done | Description is 216 characters and ends "Use to estimate, size, point or re-estimate issues". |
| 1.7 Info review against hygiene check | Done | Info review says "groom or fill in thin issue descriptions"; "audit, lint" is only in the hygiene check. |
| 1.8 "What happened today": activity report against `work-log` | Open | Descriptions unchanged. Low. |
| 2.1 Rename to `linear-issue-information-review` and `repository-documentation-update` | Done | Both folders exist (commit 1e0f64d); context files and folder renamed to match. One stale name is left outside the skills folder (item 1 below). |
| 2.3 Framework suffix list | Open | `_shared/skill-framework.md` "Name" still lists only `-check`, `-review`, `-update`, `-report`. |
| 3.2 Move `insert-changelog.pl` to `_shared` | Done | `_shared/scripts/insert-changelog.pl`; `dotnet-architecture-analysis/SKILL.md:30` points to it. |
| 4.1 Audit agent in `layer-moves.workflow.js` on Sonnet | Done | Line 174 now has `model: 'sonnet'`. |
| 4.2 `revit-ribbon-buttons` on Sonnet | Done | `model: claude-sonnet-5-5`; **Model:** line says Sonnet. |
| 5 `work-log` over 15000 bytes | Done | 25613 down to 11513; five files in `references/`. Still 1.5 KB over the 10 KB goal. |
| 5 `dotnet-architecture-analysis` over 15000 | Done | 15644 down to 13263; `references/audit-and-report.md` added. |
| 5 `yagni`, `revit-ribbon-buttons`, `dotnet-test-coverage-check` over 10 KB | Open | 12408 (was 12461), 10444 (was 10314, grew), 10185 (unchanged). |
| 5 Descriptions over 300 characters | Partial | `yagni` 422 to 370, `detox` 404 to 386. Now 13 skills are over 300 (see item 6); the excess is 457 characters (baseline 497). |
| 6 Pack and repin written in many places | Done | One copy in `_shared/package-chain.md` (6345 bytes) with the project values in `skill-context/package-chain.md`; `chain-release.md` 9317 down to 4297 bytes; `dotnet-dead-code-search/SKILL.md:35` and `rename-pass-brief.md:20` point to it. |
| 6 File-the-issues steps in four places | Open | `dotnet-dead-code-search/SKILL.md:31`, `dotnet-test-coverage-check/SKILL.md:58-64`, `file-issues-brief.md`, `linear-filing.md` are unchanged. |
| 6 "Each subagent gets the team, its repository path ..." | Open | Still at `linear-issue-done-check/SKILL.md:25`, `linear-issue-estimate-update/SKILL.md:41`, `linear-issue-information-review/SKILL.md:33`, `linear-issue-split-review/SKILL.md:37`. |
| 6 "Write the proposal to the dated report file ..." | Open | Still at `linear-issue-estimate-update/SKILL.md:51` and `linear-issue-split-review/SKILL.md:63`; the cost report's only repeated line. |
| 6 Same issue-description headings in two skills | Open | "Problem / Goal" and "Where" still in `linear-issue-information-review` and `linear-issue-split-review`. |
| 7 `argument-hint` and `allowed-tools` only in `repository-activity-report` | Open | Lines 4-5 unchanged; framework silent. |
| 7 Merge `linear-team-estimate-check` into the hygiene check | Open | Both exist (4381 and 3383 bytes). Your call. |

Counts: 13 Done, 1 Partial, 12 Open. The Open items are mostly small or your call.

## Ranked recommendations

### 1. Broken reference (one)

`C:\Users\childebran\.claude\mods\General\docs-check\README.md:11` says "The `kelly-docs-update` skill stamps them". That skill does not exist; it is now `repository-documentation-update`. Edit: replace the name. Effect: the mod's documentation names a real skill. (`BuildConfigs/SHARED-AGENTS.md:56` already has the new name.) No skill in the folder fails to load, and no `references/` or `scripts/` path in a SKILL.md is missing.

### 2. Overlapping triggers

1. **"Review my skills" or "improve this skill"**: `skill-audit` and the installed `anthropic-skills:skill-creator` ("edit, or optimize an existing skill"). Owner: `skill-audit` for a whole folder; `skill-creator` for one skill. Edit: in `skill-audit/SKILL.md:3` say "a folder of skills" and drop "review" from its triggers. Effect: also helps item 6, since the description is 354 characters.
2. **"Update the READMEs"**: `repository-documentation-update` and the installed `anthropic-skills:update-readmemd-files`. Owner: `repository-documentation-update` for every repository in the project folder, the installed one for a single README. Edit: in `repository-documentation-update/SKILL.md:3` change "update the changelog or READMEs" to "update the changelogs and READMEs of every repository". Effect: a one-repository request is less likely to start the wrong skill. The installed one can't be edited from here.
3. **"Find or delete the dead code" in a layered .NET stack**: `yagni` and `dotnet-dead-code-search` still both match. The pointers in each description settle it only after one has loaded. Owner: `dotnet-dead-code-search` where a project context exists. Edit: in `yagni/SKILL.md:3` drop "or code only tests use" and "unreferenced members" (they are the other skill's words); this also saves about 40 characters.
4. Low, carried over: **"what did I do yesterday"**: `repository-activity-report` ("what happened in my repositories") and `work-log`. Owner: the activity report for an answer in chat, `work-log` for the written log. Edit: none; their descriptions already name different outputs.

### 3. Project text in skills
*Lead check: Revit is the host platform these skills are built for, not Kelly project text; the request was to remove Kelly references. Generalising the Revit-free layer rule is optional.*

The structure script looks only for `jhkweb`, `Kelly` and `KTR`, and finds none. It does not look for `Revit`, which is hard-wired in `dotnet-architecture-analysis`, a skill whose description says "layered .NET NuGet package repositories". Lines that name Revit: `scripts/check-rules.pl` 18 (roles `revit-free`, `revit-database`, `revit-ui` at lines 6-13; messages at 85, 116, 123), `scripts/layer-moves.workflow.js` 13, `scripts/layer-analysis.workflow.js` 9, `references/placement-rules.md` 6 (lines 26, 39, 64, 66, 67, 80), `references/report-template.md` 6, `SKILL.md` 6. Edit: rename the roles in `check-rules.pl` and `project.json` to generic names (host-free, host-database, host-ui) and read the labels from `skill-context/dotnet-architecture-analysis/project.json`; replace "in-Revit" in the references by "host-application". Add `Revit` to the term list in `skill-audit/scripts/structure.sh`. Effect: the skill is reusable and the audit catches the next case. Cost: moderate, since the workflows and the check script share the role names; do it with a run of `check-rules.pl` before and after.

### 4. Shared code inside one skill

None left. `dotnet-dead-code-search` into `yagni/scripts` is the known decision (see No change needed).

### 5. Models

No change. Models match the framework's table. The cost report's "no model" lines are false positives (see No change needed).

### 6. Size and repeated text

Size:

| Skill | Now | Edit | Effect |
|---|---|---|---|
| `yagni/SKILL.md` | 12408 | Move "## 1. Target and scan" (4018) and "## 5. Act on it, after approval" (2526) to `references/target-and-scan.md` and `references/act.md`, read at their step. | About 6500 bytes (about 1600 tokens) less on a run that only reports. |
| `revit-ribbon-buttons/SKILL.md` | 10444 | Move "## Large batches" (lines 129-145 of the file) to `references/large-batches.md`. | Under 10 KB; read only above about 20 buttons. |
| `dotnet-test-coverage-check/SKILL.md` | 10185 | Move "## 5. Issues" (2454) to `references/issues.md`. | Under 10 KB. |
| `work-log/SKILL.md` | 11513 | Optional: move "### Markdown rules" to `references/`. | Near the 10 KB goal. |

Descriptions over the framework's 300 characters (13 skills, characters now): `skill-audit` 355, `detox` 386, `yagni` 370, `work-log` 353, `dotnet-architecture-analysis` 339, `dotnet-test-coverage-check` 337, `dotnet-access-modifier-tightening` 335, `repository-documentation-update` 333, `revit-ribbon-buttons` 317, `dotnet-dead-code-search` 313, `database-normalize` 307, `linear-issue-information-review` 306, `linear-issue-dependency-check` 305. Cutting each to 300 removes 457 characters, about 114 tokens per session. Edit: drop trailing example phrases and the parenthetical lists; the edits in item 2 cover three of them.

Repeated procedures (one copy each):

| Procedure | Written in | One copy goes in |
|---|---|---|
| File the issues (title, description, labels, estimate) | `dotnet-dead-code-search/SKILL.md:31`, `dotnet-test-coverage-check/SKILL.md:58-64`, `dotnet-member-naming/references/file-issues-brief.md` (2649 bytes), `dotnet-architecture-analysis/references/linear-filing.md` (4404 bytes) | `_shared/linear-filing.md` for the generic steps (check for a duplicate, one team per issue, comment the evidence); the project's issue rules stay in `skill-context/linear-teams.md`. Each skill keeps its own table of what it files. |
| "Each subagent gets the team, its repository path, its keys when split, the fetch ..." | the four `linear-issue-*` lines listed in the table above | `_shared/linear-scope.md` (17 lines); each skill keeps only its extras. |
| "Write the proposal to the dated report file the project context names" | `linear-issue-estimate-update/SKILL.md:51`, `linear-issue-split-review/SKILL.md:63` | The framework's "Reports" section already says it. Replace both by one short pointer. |
| Issue description sections ("Problem / Goal", "Where") | `linear-issue-information-review`, `linear-issue-split-review` | The project's issue rules, shared with `linear-issue-add`. |

Effect: a rule change lands once. The two "## 6. Apply, after approval" headings hold different steps; leave them.

### 7. Names

1. Suffixes outside the framework's list: `linear-issue-add`, `linear-project-suggest`, `skill-audit`, `dotnet-architecture-analysis`, `dotnet-member-naming`, `dotnet-access-modifier-tightening`, `dotnet-dead-code-search`, `revit-ribbon-buttons`. Edit: add `-add`, `-suggest`, `-audit`, `-analysis` and noun names to the "Name" section of `_shared/skill-framework.md`. Effect: the framework matches the folder; no rename.
2. Low: the framework's `SKILL.md` template shows a "Project context" line. `database-normalize`, `detox`, `session-archive`, `yagni` and `dotnet-access-modifier-tightening` have none, and no context file exists for them. Edit: write "optional" in the template. `repository-activity-report` carries `argument-hint` and `allowed-tools`; say in the framework that they are allowed.
3. Low, your call: merge `linear-team-estimate-check` into the hygiene check.

## No change needed

- `database-normalize`: Opus fits; description 307 (item 6).
- `detox`: its `~/.claude/mods/switches.json` paths and the `example-skill` sample in `references/findings-schema.md` are known decisions, not broken; description 386 (item 6).
- `dotnet-access-modifier-tightening`: description 335 (item 6); no project context needed.
- `dotnet-architecture-analysis`: items 3 and 6 only. Reviewers and per-package implementers in the two workflows inherit Opus on purpose (`SKILL.md:9`), so the "no model" line at `SKILL.md:68` and the unset agents at `layer-moves.workflow.js:132,137,143` and `layer-analysis.workflow.js:165` are false positives.
- `dotnet-dead-code-search`: pointing into `yagni/scripts` is by design; the "no model" lines at 32-33 are false positives (the **Model:** line names the subagents' model); description 313 (item 6).
- `dotnet-member-naming`: pack and repin point to `_shared/package-chain.md`; filing text in item 6 only.
- `dotnet-solid-check`: Opus matches the framework.
- `dotnet-test-coverage-check`: items 6 only (size, description, filing text).
- `git-push-developbranch`: the name is your chosen one; 2383 bytes; Sonnet fits a push that can't be undone.
- `linear-issue-add`: fine.
- `linear-issue-dependency-check`: description 305 (item 6).
- `linear-issue-done-check`: Opus is justified by the bulk close; the "no model" lines (17, 19, 25, 51) are false positives because `_shared/linear-scope.md` sets `model: "sonnet"`.
- `linear-issue-estimate-update`: repeated lines only (item 6).
- `linear-issue-hygiene-check`: Haiku subagents named; fine.
- `linear-issue-information-review`: repeated lines and description 306 (item 6); the name is now whole words.
- `linear-issue-split-review`: Opus matches the framework; repeated lines only (item 6).
- `linear-project-suggest`: fine.
- `linear-team-estimate-check`: fine; the merge question stays open.
- `repository-activity-report`: fine; frontmatter note in item 7.
- `repository-documentation-update`: item 2.2 and description 333.
- `revit-ribbon-buttons`: Sonnet now; size only (item 6).
- `session-archive`: fine; 6802 bytes.
- `skill-audit`: description 355 and item 2.1.
- `software-delivery-report`: fine.
- `work-log`: split done; model and scripts are right.
- `yagni`: size and the trigger words (items 2.3 and 6).
