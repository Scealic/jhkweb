---
name: linear-issue-check-isdone
description: Check the open issues in the Kelly teams of the Linear workspace "jhkelly" against the code under C:\repo\jhkweb to find the ones that are clearly and 100% complete - every part of the issue's goal is in committed code on develop, with the evidence (commit, files, types, tests) to prove it - return a list with a one-sentence rationale per issue (Done, Partial, Not started or Can't tell), and mark the 100% complete ones Done in Linear with a comment giving the evidence. Use whenever the user asks which Linear issues are done, finished, complete or already implemented, to close out, check off or mark done the finished issues, to find issues that are open but already fixed, or to run "is done" on all teams, one team, one project or a list of keys.
---

# Find the Linear issues the code has already finished

The user asked for this skill to **mark an issue Done by itself when the code shows it is 100% complete**; that is the standing approval for that one change. Nothing else changes in Linear: no description, title, label, estimate, project or other status (never Canceled; obsolete issues are `linear-issue-info-review`'s job). The bar is "clearly and 100%": when in doubt, the issue stays open.

## 1. Scope

Default: every **open** issue (status type `triage`, `backlog`, `unstarted` or `started`) in every Kelly team, sub-teams included. Narrow it when the user names teams, a project, a label or keys. **Skip the Hasa team and its sub-teams** (another product, no code here). Check the teams with `list_teams` first; the user may have added or renamed some.

| Team key | Repository under `C:\repo\jhkweb` |
|---|---|
| KTR5 | Kelly-Revit-v5 (the add-in; items for all of v5; also the lower v5 layers when an issue names them) |
| KTRUI | Kelly-Revit-UI |
| KTRL5 | Kelly-Revit-Logic-v5 |
| KTR4 | Kelly-Revit-v4 (items for all of v4) |
| KTRL4 | Kelly-Revit-Logic-v4 |
| KW3 / KW2 | Kelly-Windows-v3 / Kelly-Windows-v2 |
| KWD3 / KWD2 | Kelly-Windows-Data-v3 / Kelly-Windows-Data-v2 |
| KWDC / KWDJ / KWDSS / KWDSL | Kelly-Windows-Data-Csv / -Json / -SqlServer / -Sqlite |
| KD | Kelly-Domain |

A new Kelly team not in this table: find its repository from its name, or ask.

Fetch per team: `list_issues` with `team`, `limit: 250`, `fields: ["title","description","status","statusType","labels","project","parentId","createdAt","updatedAt"]`, following `cursor` until `hasNextPage` is false, and keep the open status types. Descriptions come back truncated: call `get_issue` for the full text of every issue that gets past a first look, and `list_comments` too, since a comment may narrow or add to what is asked.

A parent issue is complete only when every sub-issue is Done (or Canceled) **and** the parent's own goal holds in the code; check its sub-issues' statuses with `list_issues` and `parentId`.

## 2. Check the code

Before checking, `git -C <repo> fetch` is not needed and not wanted: the evidence is the local `develop` branch, which is where the work is committed. Note each repository's current branch (`git -C <repo> branch --show-current`); if one is not on `develop`, check against `develop` (`git -C <repo> show develop:<path>`, `git -C <repo> log develop`) and say so.

The volume is large (KTR5 alone has about 160 open issues). Send one subagent per team, or per 100 issues of a big team, all in one message so they run in parallel. Each gets the team, its repository path, the issue keys with their full titles, descriptions and comments, the verdicts below and these instructions:

- **Only read**: no `save_issue`, no `save_comment`, no edits, no builds, no tests.
- List what the issue asks for, as a checklist for this check only (each tool, type, behaviour, file, doc or test it names, and each step of a "Steps to reproduce"); nothing is created in Linear. An issue moved from a backlog (footer "From `…/Quick-Backlog.md` › …") asks for exactly what its backlog line says.
- For each checklist item, find it in the code: Grep and Glob in the repository (the ribbon commands under `modules/` for KTR5/KTR4, `src/` for the lower layers), read the code enough to see it really does what is asked, not just that a name exists.
- Look for the change that did it: `git -C <repo> log develop --oneline -i --grep=<key or keyword>`, the `Changelog.md` headings, and the repository's `Quick-Backlog.md` (a ticked line ending ` — Linear: <KEY>` or with `— done <date> (commit …)`).
- Uncommitted work in the working tree does **not** count: an item is not done until it is committed on `develop`.
- Where the repository requires tests (every repository except the v4 Revit layers, see its `AGENTS.md`), a code change the issue asks for needs its test too; a missing test makes the issue Partial. A public-surface change also needs its `README.md`/`Changelog.md` update.
- Return one line per issue:

```
KEY | Done / Partial / Not started / Can't tell | <one-sentence rationale> | Evidence: <commit hash(es), files, types, tests, backlog line> | Missing: <the checklist items not found, or ->
```

Verdicts:

| Verdict | When |
|---|---|
| **Done** | Every checklist item is in committed code on `develop` and does what the issue asks, with a commit or a ticked backlog line to point to, and the tests and docs the repository requires. Nothing in the issue or its comments is left. |
| **Partial** | Some checklist items are done, at least one is not (name it). |
| **Not started** | No item of it is in the code. |
| **Can't tell** | The issue is too vague to check, the work is outside the code (a meeting, a decision, a Revit model, a test run, an install, a release, an issue another person must confirm), or it is about runtime behaviour that only a run in Revit could show. |

The rationale is one sentence that names what the code shows, for example: "`PipeSlopeCommand` now skips unsloped systems and `PipeSlopeCommandTests` covers it (commit `a1b2c3d`)."

## 3. Verify every Done

A Done is a change in a shared system, so **re-check each one yourself before marking it**, not on a subagent's word: read the evidence it cites (`git -C <repo> show --stat <hash>`, the files and the tests) against the issue's full text. Downgrade to Partial or Can't tell when any checklist item is unproved, when the commit only touches the area without finishing it, or when the issue names a Revit year, a version (v4 and v5) or a layer the change did not reach. Downgrade when the only evidence is a ticked backlog line with no commit.

## 4. Mark Done

For each verified Done issue:

1. `save_issue` with `id` and `state` set to the team's completed status (`Done`; call `list_issue_statuses` for the team if unsure). Change nothing else.
2. `save_comment` on it: "Marked Done by the is-done check of <yyyy-mm-dd>: <the one-sentence rationale>. Evidence: <commit hashes, files, tests>." Wrap dotted names and file names in backticks, or Linear turns them into links. Say "Major Version 4" or "v4", never "Generation"; name Kelly Tools For Revit or KTR only in the KTR* teams' issues. Add "built, not installed" or "not tested in Revit" where the evidence shows that.

The calls are independent: send them in parallel, about 25 per message. A refused call: collect it and report it, don't retry with something else.

## 5. Report

In chat, per team, a table of every checked issue, the Done ones first:

```
| Key | Title | Verdict | Rationale |
|---|---|---|---|
| KD-12 | … | Done (marked) | <one sentence> |
| KD-15 | … | Partial | <one sentence, naming what is missing> |
```

Then the totals (checked, marked Done, Partial, Not started, Can't tell), the Done candidates downgraded in step 3 and why, and any refused calls.

Issues marked Done here may still be open in a repository's `Quick-Backlog.md` (the line ending ` — Linear: <KEY>`): offer, in `wrap_up`, to tick them there with `kelly-backlog-update`. Partial issues are often worth finishing next; Can't tell issues that are vague are `linear-issue-info-review`'s job, so offer that when there are many.
