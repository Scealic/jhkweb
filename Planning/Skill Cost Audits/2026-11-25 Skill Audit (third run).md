# Skill Audit — 2026-11-25 (third run)

Scope: the 26 skills in `C:\Users\childebran\.claude\skills`, `_shared/` (`linear-scope.md`, `package-chain.md`, `skill-framework.md`, `scripts/`) and the mods that name skills. Inputs: the structure and cost reports of this run, every `description:` line, the section headings, the framework, and the baseline `2026-11-25 Skill Audit (re-check).md`. Nothing was edited. The structure report lists only the known decisions; sections 2, 3, 4, 7, 8, 9, 10 and the new section 11 (old skill names still in use) are empty. All 26 skills have a `model:` line, a bold **Model:** line and a title. All descriptions together are 7690 characters (about 1922 tokens), loaded in every session, the same as at the baseline. SKILL.md sizes are unchanged from the baseline: the largest are `dotnet-architecture-analysis` 13263 bytes, `yagni` 12408, `work-log` 11513, `revit-ribbon-buttons` 10444, `dotnet-test-coverage-check` 10185; none is over 15000.

## Since the last audit

One commit since the baseline: `c5cc024` ("docs-check mod names repository-documentation-update; skill-audit searches mods and finds old skill names still in use (section 11)"). Verified: `mods/General/docs-check/README.md:11` now says `repository-documentation-update`, and no other file under `mods/` names `kelly-docs-update`. `skill-audit/scripts/structure.sh` has section 11, and its output lists no old name. No skill file changed, so every other number is the baseline's number.

| Baseline item | Status | Evidence |
|---|---|---|
| Broken reference: `docs-check/README.md:11` named `kelly-docs-update` | Done | `c5cc024`; the README names the new skill; section 11 of the structure report is empty. |
| 1.1 "Update the READMEs": `repository-documentation-update` against installed `update-readmemd-files` | Open | `repository-documentation-update/SKILL.md:3` still says "update the changelog or READMEs". |
| 1.2 Ribbon icons narrowed | Done | Already done at baseline. |
| 1.3 Drop "what a ribbon button does" | Done | Already done. |
| 1.4 `yagni` against `dotnet-dead-code-search` | Done (part left, item 2.2) | Pointers in both descriptions; `yagni/SKILL.md:3` still has the other skill's trigger words. |
| 1.5 Drop "too many skills" from `detox` | Done | Already done. |
| 1.6 Estimate clause | Done | Already done. |
| 1.7 Information review against hygiene check | Done | Already done. |
| 1.8 Activity report against `work-log` | Open | Descriptions unchanged. Low. |
| 2.1 Whole-word renames | Done | Folders `linear-issue-information-review` and `repository-documentation-update` exist; no old name is in use (section 11). |
| 2.3 Framework suffix list | Open | `_shared/skill-framework.md` "Name" still lists `-check`, `-review`, `-update`, `-report`. |
| 3.2 `insert-changelog.pl` to `_shared/scripts` | Done | Already done. |
| 4.1 Audit agent on Sonnet | Done | Already done. |
| 4.2 `revit-ribbon-buttons` on Sonnet | Done | Already done. |
| 5 `work-log` over 15000 | Done | 11513 bytes; still 1.5 KB over the 10 KB goal. |
| 5 `dotnet-architecture-analysis` over 15000 | Done | 13263 bytes. |
| 5 `yagni`, `revit-ribbon-buttons`, `dotnet-test-coverage-check` over 10 KB | Open | 12408, 10444, 10185; unchanged. |
| 5 Descriptions over 300 characters | Partial | 13 skills still over 300 (item 4); no description changed since the baseline. |
| 6 Pack and repin in many places | Done | One copy in `_shared/package-chain.md`. |
| 6 File-the-issues steps in four places | Open | `dotnet-dead-code-search/SKILL.md:31`, `dotnet-test-coverage-check/SKILL.md:58-64`, `dotnet-member-naming/references/file-issues-brief.md`, `dotnet-architecture-analysis/references/linear-filing.md`. |
| 6 "Each subagent gets the team, its repository path ..." | Open | `linear-issue-done-check/SKILL.md:25`, `linear-issue-estimate-update/SKILL.md:41`, `linear-issue-information-review/SKILL.md:33`, `linear-issue-split-review/SKILL.md:37`. |
| 6 "Write the proposal to the dated report file ..." | Open | `linear-issue-estimate-update/SKILL.md:51`, `linear-issue-split-review/SKILL.md:63`; the cost report's one repeated line. |
| 6 Same issue-description headings in two skills | Open | `linear-issue-information-review`, `linear-issue-split-review`. |
| 7 Frontmatter keys outside the framework | Open | `repository-activity-report/SKILL.md:4-5` (`argument-hint`, `allowed-tools`); `linear-issue-add/SKILL.md:4` also has `argument-hint`. The framework is silent. |
| 7 Merge `linear-team-estimate-check` into the hygiene check | Open | Both exist (4381 and 3383 bytes). Your call. |

Counts: 14 Done, 1 Partial, 11 Open (the re-check's 26 rows plus its broken-reference item; its Revit item became a known decision and is not counted).

## Ranked recommendations

Little is left. No broken reference, no project text, no shared code inside one skill, no wrong model. What remains is trigger overlap, size and repeated text.

### 1. Broken references

None. Section 5 and 6 hits are the known decisions.

### 2. Overlapping triggers

1. `skill-audit` and installed `anthropic-skills:skill-creator` ("edit, or optimize an existing skill"). Edit: `skill-audit/SKILL.md:3`, say "a folder of skills" and replace "Use to review, audit, clean up, reorganize or cut the cost of skills" by "Use to audit a skills folder or cut its cost". Effect: a one-skill request goes to `skill-creator`; the description drops from 354 characters.
2. `yagni` and `dotnet-dead-code-search` both match "dead code". Edit: `yagni/SKILL.md:3`, drop "or code only tests use" and "unreferenced members" (the other skill's words; its description says "test-only"). Effect: a layered .NET request is less likely to start `yagni`; saves about 40 of 369 characters.
3. `repository-documentation-update` and installed `anthropic-skills:update-readmemd-files`. Edit: `repository-documentation-update/SKILL.md:3`, change "update the changelog or READMEs" to "update the changelogs and READMEs of every repository". Effect: a single-README request is less likely to start the wrong skill.
4. Low: `linear-team-estimate-check` ("audit a team's estimate settings") and `linear-issue-hygiene-check` ("audit, lint or check Linear hygiene"). Edit: in `linear-team-estimate-check/SKILL.md:3` replace "check, verify or audit" by "check or verify". Effect: "audit Linear" points to the hygiene check.

### 3. Project text

None found; the terms report is empty.

### 4. Size and repeated text

Descriptions over 300 characters (13 skills): `detox` 386, `yagni` 370, `skill-audit` 355, `work-log` 353, `dotnet-architecture-analysis` 339, `dotnet-test-coverage-check` 337, `dotnet-access-modifier-tightening` 335, `repository-documentation-update` 333, `revit-ribbon-buttons` 317, `dotnet-dead-code-search` 314, `database-normalize` 307, `linear-issue-information-review` 306, `linear-issue-dependency-check` 305. Edit: drop trailing example phrases and parentheses; items 2.1 to 2.3 cover three. Effect: about 450 characters, about 110 tokens per session.

SKILL.md size:

| Skill | Bytes | Edit | Effect |
|---|---|---|---|
| `yagni` | 12408 | Move "## 1. Target and scan" (4018) and "## 5. Act on it, after approval" (2526) to `references/`, read at their step. | About 6500 bytes less on a report-only run. |
| `revit-ribbon-buttons` | 10444 | Move "## Large batches" (line 127 on) to `references/large-batches.md`. | Under 10 KB. |
| `dotnet-test-coverage-check` | 10185 | Move "## 5. Issues" (2454) to `references/issues.md`. | Under 10 KB. |

Repeated procedures, one copy each:

| Procedure | Written in | Edit |
|---|---|---|
| "Each subagent gets the team, its repository path, its keys when split, the fetch ..." | the four `linear-issue-*` lines listed above | Put the common sentence in `_shared/linear-scope.md`; each skill keeps its extras. |
| "Write the proposal to the dated report file ..." | `linear-issue-estimate-update/SKILL.md:51`, `linear-issue-split-review/SKILL.md:63` | The framework's "Reports" section says it; replace both with one pointer. |
| File the issues | `dotnet-dead-code-search`, `dotnet-test-coverage-check`, `file-issues-brief.md`, `linear-filing.md` | Generic steps to `_shared/linear-filing.md`; each skill keeps its table of what it files. |
| Issue description sections ("Problem / Goal", "Where") | `linear-issue-information-review`, `linear-issue-split-review` | Take them from the project's issue rules, shared with `linear-issue-add`. |

### 5. Names

1. Add `-add`, `-suggest`, `-audit`, `-analysis` and noun names to the "Name" section of `_shared/skill-framework.md`; no rename.
2. Say in the framework that `argument-hint` and `allowed-tools` are allowed (`linear-issue-add`, `repository-activity-report`), and mark the "Project context" line optional in the template.
3. Low, your call: merge `linear-team-estimate-check` into the hygiene check.

## No change needed

- `database-normalize`: Opus fits; description 307 (item 4).
- `detox`: its `~/.claude/mods/switches.json` paths and the `example-skill` sample are known decisions, not broken; description 386.
- `dotnet-access-modifier-tightening`: description 335 only.
- `dotnet-architecture-analysis`: Revit is the host platform, not project text; the "no model" line at `SKILL.md:68` is a false positive (the workflows set models).
- `dotnet-dead-code-search`: pointing into `yagni/scripts` is by design; the "no model" lines at 32-33 are false positives; description 314.
- `dotnet-member-naming`: fine; filing text in item 4 only.
- `dotnet-solid-check`: fine.
- `dotnet-test-coverage-check`: size, description and filing text only.
- `git-push-developbranch`: the name is your chosen one.
- `linear-issue-add`: fine.
- `linear-issue-dependency-check`: description 305 only.
- `linear-issue-done-check`: the "no model" lines are false positives (`_shared/linear-scope.md` sets `model: "sonnet"`).
- `linear-issue-estimate-update`: repeated lines only.
- `linear-issue-hygiene-check`: fine.
- `linear-issue-information-review`: repeated lines and description 306.
- `linear-issue-split-review`: repeated lines only.
- `linear-project-suggest`: fine.
- `linear-team-estimate-check`: fine; the merge stays your call.
- `repository-activity-report`: fine.
- `repository-documentation-update`: item 2.3 and description 333.
- `revit-ribbon-buttons`: Revit is the host platform; size only.
- `session-archive`: fine.
- `skill-audit`: item 2.1; section 11 now works.
- `software-delivery-report`: fine.
- `work-log`: fine; 1.5 KB over the goal, optional.
- `yagni`: items 2.2 and 4.
