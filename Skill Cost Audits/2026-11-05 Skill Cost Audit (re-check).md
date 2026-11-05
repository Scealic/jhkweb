# Skill Cost Audit — 2026-11-05 (re-check)

This re-check covers the 15 personal skills in `C:\Users\childebran\.claude\skills`, measured with `skill-cost-audit/scripts/measure.sh`, and the seven recommendations of the audit written earlier today. Nothing was changed. 4 bytes ≈ 1 token.

## Since the last audit

`git log --since=2026-11-05 -- skills` shows no commits. The only new work is untracked files and one new skill.

| Recommendation | Status | Evidence |
|---|---|---|
| 1. work-log: script the transcript reading | Partial | `work-log/scripts/day-digest.pl` (6594 bytes), `day-cost.pl` (4341) and `rates.tsv` exist but are untracked. `work-log/SKILL.md` never names them (no match for `day-digest` or `day-cost`). Lines 87-93 still tell the model to read the `.jsonl` transcripts. `day-facts.sh` does not exist. SKILL.md is still 16440 bytes. |
| 2. Linear review skills: subagents fetch their own team, use Sonnet, shared team table | Open | Report §4 still flags no-model lines in check-isdone:36, dependency-check:47, estimate-update:49, info-review:48, split-review:48. §6 still shows the main session fetching with `list_issues` (check-isdone:28, info-review:30, split-review:28, estimate-update:47). No `skills/_shared/` folder. §5 still lists the same repeated team tables. |
| 3. kelly-layer-moves: models in the workflow scripts, move late sections | Open | `layer-analysis.workflow.js`: 3 agent() calls, 0 model settings. `layer-moves.workflow.js`: 7 calls, 0 settings. SKILL.md still 23694 bytes; section 4 (4582 bytes) and section 6 (2051) still inline. |
| 4. kelly-ribbon-buttons: icons to references, Sonnet for batch readers | Open | Lines 261, 263, 270, 274 still name no model. SKILL.md 17450 bytes. No `references/` folder. |
| 5. kelly-backlog-update: move Linear-ready items, trim Steps | Open | SKILL.md 18894 bytes. "Steps" 8628 and "Linear-ready items" 3690 bytes still inline. No `references/` folder. |
| 6. tdd-coverage-check: move section 5 and traps, scripts print totals only | Partial | Line 88 now names `model: "sonnet"` for the Linear subagent (commit d02823b), and `scan.sh` writes the gap CSV (commit 9be0bf5). But section 5 is still 4845 bytes inline, and SKILL.md is 17373 bytes. |
| 7. Shorten descriptions | Open | 12 descriptions still over 400 characters (longest 895). Total 9406 characters ≈ 2351 tokens. The new skill-cost-audit is fine at 339. |

Totals: Done 0, Partial 2, Open 5.

## Where the cost comes from

| Source | Today's number |
|---|---|
| Descriptions | 15 skills, 9406 characters ≈ 2351 tokens, loaded in every session. 12 are over 400 characters. |
| SKILL.md bodies | 3790 to 23694 bytes each (≈ 947 to 5923 tokens). Five are over 16 KB: layer-moves 23694, backlog-update 18894, ribbon-buttons 17450, tdd-coverage-check 17373, work-log 16440. Other files add 107536 bytes to layer-moves and 21800 to ribbon-buttons. |
| Inputs | Transcripts: 316.3 MB (310 files) on 2026-11-04, 146.1 MB on 2026-11-03, 27.8 MB on 2026-11-02. Whole Linear teams are fetched in five Linear skills (KTR5 alone has about 160 open issues). |
| Subagents | 10 `agent()` calls in two layer-moves workflow scripts with no model. Prose lines with no model in 7 skills (layer-moves, ribbon-buttons, check-isdone, dependency-check, estimate-update, info-review, split-review). All run on Opus. |

## Ranked recommendations

### 1. work-log: wire in the digest scripts (scheduled daily, biggest input)

The scripts now exist, but nothing uses them. `work-log/SKILL.md:87-93` still says to read the day's `.jsonl` transcripts for builds, decisions, tomorrow's items and cost. That is 316.3 MB of transcripts on 2026-11-04, every weekday, from the "Work Log For Today" task.

- Edit `work-log/SKILL.md` lines 87, 89, 92 and 93 so they read the output of `scripts/day-digest.pl <day>` and `scripts/day-cost.pl <day>` instead of the transcripts. Keep the rest.
- Commit the three untracked files in `work-log/scripts/`.
- Add `scripts/day-facts.sh <day>` for the fixed shell loops (loose ends at line 92, test logs at line 88, changed files at line 90).
- Once the scripts do the gathering, run the scheduled task on Sonnet.

Expected effect: the model reads a small digest instead of searching hundreds of MB. This is the largest daily saving, and it needs only a few lines of SKILL.md.

### 2. Linear review skills: each team subagent fetches its own issues, on Sonnet

Applies to `linear-issue-check-isdone` (:28, :36), `linear-issue-info-review` (:30, :48), `linear-issue-split-review` (:28, :48), `linear-issue-estimate-update` (:47, :49) and, for big runs, `linear-issue-dependency-check` (:47).

- The main session fetches every open issue with `list_issues`, then each subagent prompt carries them again, so they are paid twice. Change the text so the main session only lists teams, and each subagent does its own `list_issues` for its team.
- Add `model: "sonnet"` to those subagent lines. Their work is read-only: read the issue, search the code, return one line. Keep Opus for the main session's re-check at check-isdone:63 and for every write to Linear.
- Put the team to repository table, the "skip Hasa" rule and the "about 25 calls per message" rule in `skills/_shared/linear-teams.md`. §5 lists the same lines repeated in 2 or 3 skills (for example the KWD3 / KWD2 and KWDC / KWDJ / KWDSS / KWDSL rows).

Expected effect: the main Opus context no longer holds the whole backlog, and the per-issue reading moves to the cheaper model.

### 3. kelly-layer-moves: set models in the two workflow scripts

`scripts/layer-analysis.workflow.js` has 3 `agent()` calls and `scripts/layer-moves.workflow.js` has 7, with no model in any. Also `SKILL.md:116` suggests parallel `Agent` subagents with no model.

- Finders and probes (read-only) to Sonnet. Reviewers and the agents that edit, pack and repin stay on Opus. Check `workflow-authoring` for the option name first.
- At `SKILL.md:116`, add `model: "sonnet"` for the finder subagents.
- Move "## 4. File the recommendations in Linear" (4582 bytes) and "## 6. Audit" (2051) to `references/`, read at that step.

Expected effect: each run's many finder agents cost far less. SKILL.md drops by about 6.6 KB (≈ 1.7K tokens) per run.

### 4. kelly-backlog-update: move the rare sections

It runs alone and inside `kelly-docs-update`. Total 18894 bytes.

- Move "## Linear-ready items" (3690 bytes) to `references/linear-ready.md`, read only when items are prepared for Linear.
- "## Steps" is 8628 bytes. Cut any prose that `organize.pl`, `check.sh` or `percent.sh` already does to one line naming the script. Keep the rest.

Expected effect: about 900 tokens less per run from the move alone.

### 5. tdd-coverage-check: move sections 5 and 3

- Move "## 5. Linear issues" (4845 bytes) and "## 3. Scan every repo member by member" (2683) to `references/`. The Linear step already goes to a Sonnet subagent (line 88), so the main session needs only a pointer.
- Lines 90 and 91 (File, Check the counts) continue the same Sonnet subagent with SendMessage; say so there, so the model is not assumed to change.

Expected effect: about 1.9K tokens less in the main context.

### 6. kelly-ribbon-buttons: Sonnet for batch readers, split section 3

- Lines 261-274 ("split the tooltip analysis by folder across parallel subagents"): add `model: "sonnet"` for the read-and-draft step; keep the final tooltip pass in the main session.
- "## 3. Read each command until you know what it does" is 2144 bytes. Move it to `references/` if it is needed only for commands that are not obvious. The earlier audit also suggested moving the icon section (step 5) to `references/icons.md`; the report no longer lists it as 2000+ bytes, so measure it before moving it.

Expected effect: lower cost on batches over about 20 buttons.

### 7. Shorten twelve descriptions

Paid in every session. Over 400 characters: split-review 895, docs-update 806, dependency-check 788, ribbon-buttons 782, info-review 769, check-isdone 755, layer-moves 742, tdd-coverage-check 685, backlog-update 659, work-log 616, estimate-update 569, linear-projects 546. Cut each to about 300-400 characters: one sentence on what it does, then the trigger phrases. Saves about 1K tokens per session (9406 characters now).

## No change needed

- `kelly-repo-activity`: 3790 bytes, 79-character description.
- `kelly-solid-check`: 5145 bytes, 376-character description, no subagents.
- `skill-cost-audit`: 339-character description, measures with a script, judges on Sonnet. Its brief (3343 bytes) is needed at one step but is small.
- `kelly-docs-update`: 9336 bytes; `drift.sh` and `stamp.pl` already do the mechanical work (only its 806-character description is long, item 7).
- `kelly-linear-projects`: 6813 bytes, no subagents or large-input flags beyond its description (item 7).

## How to check the savings

1. Before each edit, run the skill once on a fixed input (same day for `work-log`, same team for a Linear skill) and record its tokens with `explain-usage`. For `work-log`, the day's cost in its Claude Code Savings report also works.
2. Make the edit, rerun on the same input, and compare.
3. Check trimmed descriptions with `skill-creator` so each skill still triggers on its phrases.
4. Rerun `measure.sh`: the no-model count in §4 and the sizes in §1 should fall.
