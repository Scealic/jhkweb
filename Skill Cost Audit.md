# Skill Cost Audit — 2026-11-05

Review of the 14 personal skills in `C:\Users\childebran\.claude\skills` for token cost. Nothing has been changed yet; each item below is a proposed edit.

Rough rule used: 4 bytes ≈ 1 token. Opus costs several times what Sonnet does per token, so *which model reads* matters as much as *how much is read*.

## Where the cost comes from

| Source | When it is paid | Size today |
|---|---|---|
| Skill descriptions | Every session, every project, even if no skill runs | 9.5 KB ≈ 2.4K tokens |
| SKILL.md body | Each time the skill runs (and again in each subagent that is told to read it) | 3.8–23.7 KB ≈ 1–6K tokens |
| Data the skill reads | Each run | from small to hundreds of MB (work-log) |
| Subagents | Each run; every subagent starts with its own context and runs on **Opus** (no skill sets a model) | 5–15 agents per run in 7 skills |

## Ranked recommendations

### 1. work-log — script the transcript reading (largest recurring cost)

Runs every weekday from the "Work Log For Today" scheduled task. "How to gather the data" tells the model to read the day's `.jsonl` transcripts for decisions, bugs, failed builds, wrap-ups and session proposals. Those were **146 MB (54 files) on 2026-11-03 and 316 MB (310 files) on 2026-11-04**. Whatever part of that the model greps and reads goes into an Opus context. The Perl script for the cost totals is also written again on every run.

- Add `work-log/scripts/day-digest.pl <day>`: from the day's transcripts, write one small Markdown digest with the user messages (truncated), the `wrap_up` recaps, asks and `blocked` flags, the `start_session` "own_initiative" proposals, and the failed `dotnet build/pack/test` calls with their first error lines. The skill then reads only the digest, probably tens of KB instead of hundreds of MB.
- Add `work-log/scripts/day-cost.pl <day>`: the usage sum per model, saved once instead of rewritten each run.
- Add `work-log/scripts/day-facts.sh <day>`: commits, packages, installs, TestLogs, journals, loose ends. These are all fixed shell loops already spelled out in the skill.
- Optionally run the scheduled task on Sonnet once the scripts do the gathering: what is left is writing prose from facts.

### 2. Linear review skills — stop passing every issue through the main context, and use Sonnet for the readers

Applies to `linear-issue-check-isdone`, `-info-review`, `-split-review` and `-estimate-update`, and to `-dependency-check` on large runs.

Today the main session fetches every open issue of every team (`list_issues` with descriptions, then `get_issue` and `list_comments`), then copies "the issue keys with their full titles, descriptions and comments" into each subagent's prompt. So every issue is paid for **twice**, and the main Opus context grows by the whole backlog (KTR5 alone is about 160 issues).

- Have each team's subagent fetch its own team's issues. The main session gets back only the one-line verdicts.
- Launch those subagents with `model: "sonnet"`. Their work is read-only (read issue, grep code, return a line). The main session already re-checks every Done or change itself before writing to Linear, and that check stays on Opus.
- Move the team → repository → layer table, the "skip Hasa" rule, the open status types and the "parallel, about 25 per message" rule into one shared file, for example `skills/_shared/linear-teams.md`. It is repeated in five or six skills now. The token saving is small (about 1.5 KB per skill), but a new team then means one edit instead of six.

### 3. kelly-layer-moves — set models in the workflow scripts

`scripts/layer-analysis.workflow.js` (3 `agent()` calls per scope) and `scripts/layer-moves.workflow.js` (7) give no model, so every finder, reviewer, probe and package agent runs on Opus.

- Finders and probes (read-only searches) → Sonnet. Reviewers, and the agents that edit code, pack and repin → keep Opus. Check the `workflow-authoring` reference for the exact `agent()` option name before editing.
- SKILL.md is the largest at 23.7 KB. "4. File the recommendations in Linear" (4.6 KB) and "7. After action report" (1.6 KB) are only needed late in a run; move them to `references/` and have the skill read them at that step.

### 4. kelly-ribbon-buttons — split out the icon half, Sonnet for batch readers

- "5. Draw the icons" (Metaphor, Colors, Masters, Render, Wire in, about 5.6 KB) is needed only when a button has a placeholder or missing icon. Move it to `references/icons.md`.
- "Large batches" sends subagents per folder for more than about 20 buttons. Tell them to use `model: "sonnet"` for the read-and-draft step, and keep the final tooltip pass in the main session.

### 5. kelly-backlog-update — trim what every run loads

It runs on its own and also inside `kelly-docs-update`, so it is often loaded together with another 9 KB skill.

- Move "Linear-ready items" (3.7 KB) and "Recovering lost items" (0.9 KB) to `references/`. They are needed only when preparing items for Linear or recovering lost lines.
- "Steps" (8.6 KB) is the core; check it for anything `organize.pl` or `check.sh` already does, and cut that prose to one line naming the script.

### 6. tdd-coverage-check — move the rarely needed parts out

- "5. Linear issues" (3.4 KB) and "Traps met before" (1.6 KB) → `references/`.
- Make sure `scan.sh` and `coverage.sh` write their full output to a file and print only totals, so build and test logs do not land in the context.

### 7. Shorten the 14 descriptions

They load in every session in every project. Ten are 650–900 characters long:

| Skill | Characters |
|---|---|
| linear-issue-split-review | 895 |
| kelly-docs-update | 806 |
| linear-issue-dependency-check | 788 |
| kelly-ribbon-buttons | 782 |
| linear-issue-info-review | 769 |
| linear-issue-check-isdone | 755 |
| kelly-layer-moves | 742 |
| tdd-coverage-check | 685 |
| kelly-backlog-update | 659 |
| work-log | 616 |

Target about 300–400 characters: what it does in one sentence, then the trigger phrases. Leave out how it works, which belongs in the body. Saves about 1–1.5K tokens per session. That is small per session, but it is paid in every session. Check each against `skill-creator`'s triggering advice so the skills are still picked up.

### No change needed

- `kelly-solid-check` (5 KB, measuring already scripted in `measure.sh`), `kelly-linear-projects` (6.8 KB), `kelly-repo-activity` (3.8 KB, 79-character description) and `kelly-docs-update` (9 KB, `drift.sh` and `stamp.pl` already do the mechanical work) are reasonable as they are.

## How to check the savings

1. Before the edits, run each changed skill once and run `explain-usage` afterwards to record its tokens. For `work-log`, the "Claude Code cost" figure in its own Savings report gives the day's total.
2. Make the edits, rerun on the same input (same day for `work-log`, same team for a Linear skill), and compare.
3. For trimmed descriptions, use `skill-creator` to check that triggering still works.

## Suggested order

1 (work-log scripts), then 2 (Linear subagents), then 3 (layer-moves models). Together these cover the recurring daily cost and the largest multi-agent runs. Items 4 to 7 are smaller, one-sitting edits.
