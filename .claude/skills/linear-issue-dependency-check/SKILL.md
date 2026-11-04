---
name: linear-issue-dependency-check
description: Check one or more issues in the Kelly teams of the Linear workspace "jhkelly" for other open issues that block them or wait on them - work in a lower layer that must be packed and repinned first, a type or member another issue adds, a decision, the other half of a split, the same change in the other major version - by reading the issues and the code under C:\repo\jhkweb, then add the missing Linear relationship (Blocked By, Blocking or Related) with a comment giving the reason. Use whenever the user asks whether an issue is Blocked By or Blocking another, blocked, waiting on or depends on another, to find, check, add or fix dependencies, blockers or relations between Linear issues, or to run the dependency check on one issue, a list of keys, one project, one team or all teams.
---

# Find and link the issues an issue is Blocked By or Blocking

The user asked for this skill to **add the relationship by itself when the dependency is clear**; that is the standing approval for adding `blockedBy`, `blocks` and `relatedTo` relations and one comment explaining them. Nothing else changes in Linear: no title, description, status, estimate, label, project or parent, and no relation is removed or marked duplicate without the user's approval in this conversation. The bar is "clear": a dependency the code or the issue text proves. A doubtful one is proposed, not added.

**Terms**: use Linear's names in everything the user or Linear sees (report, questions, comments): **Blocked By**, **Blocking** and **Related**. The `save_issue` parameters behind them are `blockedBy`, `blocks` and `relatedTo`.

## 1. Scope

The user names one issue key, or several. Also accepted: a project, a team, or "all" (every **open** issue, status type `triage`, `backlog`, `unstarted` or `started`, of the named teams). With no key and no scope given, ask for one. **Skip the Hasa team and its sub-teams** (another product, no code here) unless the user names them; then work from the text only and say so.

| Team key | Repository under `C:\repo\jhkweb` | Layer |
|---|---|---|
| KWD3 / KWD2 | Kelly-Windows-Data-v3 / Kelly-Windows-Data-v2 | 1 |
| KWDC / KWDJ / KWDSS / KWDSL | Kelly-Windows-Data-Csv / -Json / -SqlServer / -Sqlite | 1 (format libraries) |
| KW3 / KW2 | Kelly-Windows-v3 / Kelly-Windows-v2 | 2 |
| KD | Kelly-Domain | 3 (v5 only) |
| KTRL5 / KTRL4 | Kelly-Revit-Logic-v5 / Kelly-Revit-Logic-v4 | 4 |
| KTRUI | Kelly-Revit-UI | 5 (v5 only) |
| KTR5 / KTR4 | Kelly-Revit-v5 / Kelly-Revit-v4 (the add-in; items for all of that major version) | 6 |

The v3 Windows teams, KD, KTRL5, KTRUI and KTR5 are Major Version 5; the v2 Windows teams, KTRL4 and KTR4 are Major Version 4; the format libraries serve both. A new Kelly team not in this table: find its repository from its name, or ask (`list_teams`).

## 2. Read the issue

For each issue checked:

- `get_issue` with `includeRelations: true` for the full description, status, team, project, parent and its existing relations;
- `list_comments`, since a comment often says "needs X first" or "after Y";
- its parent and sibling sub-issues (`list_issues` with `parentId`), when it has a parent.

Write down what the issue **needs** before it can be done (types, members, packages, data, a decision, another fix) and what it **delivers** that someone else might need.

## 3. Find the candidates

Look for other issues, open or recently done, that deliver what this one needs, or need what it delivers:

1. **Named keys**: any issue key in the description or comments (`KTR5-123`), and "Split from" / "Linear:" footers.
2. **Keyword search**: `list_issues` with `query` (two or three distinctive words: the type, command or tool name, not "fix" or "add"), in the issue's own team, in the teams of the layers below it (what it may need) and above it (what may need it), and in the other major version's team for the same layer.
3. **The code**: Grep and Glob the issue's repository, and the lower layers' repositories, for each type or member it needs. If it already exists on the `develop` branch (`git -C <repo> show develop:<path>`, `git -C <repo> log develop --oneline -i --grep=<name>`), nothing blocks on it. If it is missing, the issue that adds it is the blocker.
4. **Quick-Backlog.md** of the repositories involved: a line ending ` — Linear: <KEY>` that says "after", "needs", "depends on" or "once … is packed".

A run over many issues (a team, a project, "all"): send one subagent per team, all in one message, each with the team, its repository path, the layer table, sections 2 to 4 and the instruction **only read: no `save_issue`, no `save_comment`, no edits**. Each returns lines in the format of section 4's table. Verify each "Add" yourself before applying it (section 5).

## 4. Decide the relationship

| Finding | Relation, set on the checked issue | Confidence |
|---|---|---|
| The other issue adds a type, member, package, data file, table or setting this issue's code needs, and it is not yet on `develop` | `blockedBy` the other (Blocked By) | Clear |
| The other issue is in a **lower layer** of the same major version and this issue uses what it changes (the lower package must be packed and repinned first) | `blockedBy` the other (Blocked By) | Clear |
| This issue adds what the other needs, or is the lower layer of the other | `blocks` the other (Blocking) | Clear |
| The issue or a comment says "after", "needs", "depends on", "once", "waiting on" another named issue | `blockedBy` (or `blocks`) as written | Clear |
| A decision, design or investigation issue whose outcome this issue's approach depends on | `blockedBy` the decision issue | Clear when the text says so; otherwise Doubtful |
| Both change the same file or type and would conflict, but neither needs the other | `relatedTo` | Clear |
| The same change in the other major version (v4 ↔ v5), or the other half of a split with no order between them | `relatedTo` | Clear |
| Same goal, same team, same code: one is a duplicate | Propose `duplicateOf`; never add it here | Doubtful |
| Only a shared keyword, area or tool | Nothing | — |

Rules:

- **Order follows the layers**: a lower layer blocks an upper one, never the reverse (Kelly-Windows-Data → Kelly-Windows → Kelly-Domain → Kelly-Revit-Logic → Kelly-Revit-UI → Kelly-Revit). Within one repository, the issue that adds a type blocks the one that uses it.
- **v4 and v5 never block each other**: they are separate products; use `relatedTo`.
- **A Done or Canceled issue blocks nothing**: if the blocker is already finished and its code is on `develop`, add nothing (say so in the report). If it is Done but the code is missing, report it as a finding; don't relate.
- **Already related**: skip a relation that exists in either direction. The exception is a pair that is only Related while the text gives an order ("waiting on", "feeds", "builds on", "holds the rows of"): propose Blocked By or Blocking. Linear then replaces the Related link (a pair holds one relation), so say "replaces the Related link" in the comment. Report a relation that points the wrong way (A blocks B, but B is the lower layer) for the user to fix; don't remove it.
- **No cycles**: before adding `blockedBy X`, follow X's own `blockedBy` chain (`get_issue` with `includeRelations`); if it reaches the checked issue, report it instead.
- **Parent and sub-issue**: don't add blocking relations between an issue and its own parent; Linear already orders them. Between sibling sub-issues, add them as usual.

## 5. Apply the clear ones

For each checked issue with at least one **Clear** relation:

1. `save_issue` with `id` and only `blockedBy`, `blocks` and/or `relatedTo` (all append-only; existing relations stay). Change nothing else.
2. `save_comment` on it: "Dependency check of <yyyy-mm-dd>: Blocked By <KEY> (<one-line reason>); Blocking <KEY> (<reason>); Related <KEY> (<reason>)." Name only the relations added in this run. Wrap dotted names and file names in backticks, or Linear turns them into links. Say "Major Version 4" or "v4", never "Generation"; name Kelly Tools For Revit or KTR only in the KTR* teams' issues.

Linear shows the relation on both issues, so the other issue needs no call. Calls for different issues are independent: send them in parallel, about 25 per message. A refused call: collect it and report it, don't retry with something else.

**Doubtful** ones (and every duplicate, wrong-way or cycle finding) are not applied: list them in the report and ask with `AskUserQuestion` (issue keys and titles in each question, the drafted relation first marked "(Recommended)", up to four per round). Apply the approved ones as above.

## 6. Report

In chat, per checked issue:

```
| Issue | Other issue | Relation | Status | Reason |
|---|---|---|---|---|
| KTR5-40 Pipe slope tool | KTRL5-12 `SlopeService` | Blocked By | Added | needs `SlopeService.Apply`, not yet in Kelly-Revit-Logic-v5 |
| KTR5-40 Pipe slope tool | KTR4-88 Pipe slope tool | Related | Added | same fix in v4 |
| KTR5-40 Pipe slope tool | KTR5-77 Slope tooltip | Related | Proposed | both touch `PipeSlopeCommand` |
```

Then: issues checked, relations added, already present, proposed, refused calls, and any finding (a Done blocker whose code is missing, a wrong-way relation, a cycle). An issue with no dependency gets one line: "KEY: none found".

Then offer in `wrap_up` what follows from the result: when a blocker is open and small, starting it first; when an issue is Blocked By a lower-layer issue, that the lower package must be packed and repinned before the issue can land; when many issues were vague about what they need, `linear-issue-info-review`.
