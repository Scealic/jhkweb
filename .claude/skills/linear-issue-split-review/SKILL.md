---
name: linear-issue-split-review
description: Review the open issues in the Kelly teams of the Linear workspace "jhkelly" for issues that are too big to finish as one change - work across layers or repositories, v4 and v5 at once, several tools or deliverables, a migration over many sites, or an estimate at the top of the team's scale - read the code each one names under C:\repo\jhkweb, propose how to split it into smaller issues (sub-issues of the original when the pieces serve one goal, or related standalone issues, in the right team, when they stand alone), write the proposal to a dated report, and after the user approves, create the new issues and link them in Linear. Use whenever the user asks to split, break down, break up, decompose or slice Linear issues, find issues that are too big, too large, epics or "should be sub-issues", or asks whether an issue is too big, for all teams, one team, one project or a list of keys.
---

# Split the Linear issues that are too big

Linear is shared: **never create, change, link or close an issue without the user's approval of the proposal in this conversation.** Steps 1 to 4 only read.

## 1. Scope

Default: every **open** issue (status type `triage`, `backlog`, `unstarted` or `started`) in every Kelly team, sub-teams included. Narrow it when the user names teams, a project, a label or keys. **Skip the Hasa team and its sub-teams** (another product, no code here) unless the user names them; then split from the text only and say so. Done, Canceled and Duplicate issues are not reviewed, nor are issues that are already parents with open sub-issues (review their sub-issues instead).

Check the teams with `list_teams` first; the user may have added or renamed some. Teams and their code:

| Team key | Repository under `C:\repo\jhkweb` | Layer |
|---|---|---|
| KWD3 / KWD2 | Kelly-Windows-Data-v3 / Kelly-Windows-Data-v2 | 1 |
| KWDC / KWDJ / KWDSS / KWDSL | Kelly-Windows-Data-Csv / -Json / -SqlServer / -Sqlite | 1 (format libraries) |
| KW3 / KW2 | Kelly-Windows-v3 / Kelly-Windows-v2 | 2 |
| KD | Kelly-Domain | 3 (v5 only) |
| KTRL5 / KTRL4 | Kelly-Revit-Logic-v5 / Kelly-Revit-Logic-v4 | 4 |
| KTRUI | Kelly-Revit-UI | 5 (v5 only) |
| KTR5 / KTR4 | Kelly-Revit-v5 / Kelly-Revit-v4 (the add-in; items for all of that major version) | 6 |

A new Kelly team not in this table: find its repository from its name, or ask.

Fetch per team: `list_issues` with `team`, `limit: 250`, `fields: ["title","description","status","statusType","labels","project","priority","estimate","parentId","createdAt"]`, following `cursor` until `hasNextPage` is false, and keep the open status types. Descriptions come back truncated; call `get_issue` when the truncated text decides the verdict, and `list_comments` when the scope may have been narrowed or widened in a comment.

## 2. Too big?

An issue is **too big** when it can't land as one focused change (one commit, or a short series, in one repository) and **at least one** of these holds:

| Signal | Example |
|---|---|
| **Crosses layers or repositories**: the work needs code in more than one repository, so a lower layer must be packed and repinned before the upper part can be done | "Move the spool numbering to Logic and add a ribbon button for it" |
| **v4 and v5 at once** | "Fix pipe slope in both versions" |
| **Several tools or commands** | "Rework the tooltips of the PipeTrade tab" (one per command, or per panel) |
| **Several independent deliverables**: a list or checklist in the description, titles joined by "and", "also", "plus" | "Add export to CSV and JSON, and validate the files" |
| **A sweep or migration over many sites** | `OperationService.Run` migration (66 sites): split by module, folder or namespace |
| **Estimate at the top of the scale**: 16 on the exponential scale (KTR5), 13 or 21 on Fibonacci, 10 on Linear, XL; `linear-issue-estimate-update` proposes 16 for exactly these | — |
| **Vague goal over a large area** ("clean up", "refactor", "improve") that the code shows covers many types | "Refactor the Manager module" |

Rate each issue **Fine**, **Split** (name the signals), or **Unclear** (too thin to tell; `linear-issue-info-review` should fill it first). Don't split work that only makes sense as one change: a rename with its callers, a type with its tests, README/Changelog/XML docs with the code they describe. Those belong in one issue whatever their size.

## 3. Propose the split, from the code

The volume is large (KTR5 alone has about 160 open issues). Send one subagent per team, or per 100 issues of a big team, all in one message so they run in parallel. Each gets: the team, its repository path, the layer table and signals above, the rules below, the issue keys with titles, descriptions, labels, estimates and projects, and these instructions:

- **Only read**: no `save_issue`, no `save_comment`, no edits.
- For each issue, search the repository (Grep and Glob; for KTR5/KTR4 the ribbon commands under `modules/`, for the lower layers `src/`; another layer's repository when the issue names it) for what the issue names, and read enough to see how much code is involved and where the natural seams are.
- Check `list_issues` with `query` (two or three keywords) in the target teams for an **existing** issue that already covers a piece; propose linking it instead of creating a duplicate.
- Return one block per issue rated Split or Unclear, and only the key for Fine issues:

```
KEY | Split: <signals> | Shape: sub-issues / standalone / mixed
Keep: <what the original issue keeps: its narrowed title, or "parent only">
1. <team> | <title> | <estimate> | <type label> | <relation> | <one-line goal> | <where: files, types, command>
2. …
Existing: <KEY of an issue that already covers a piece, or ->
Question: <what only the user can answer, or ->
```

### Rules for the pieces

- **Sub-issues** (`parentId` = the original) when the pieces together deliver the original's goal and it is done only when they all are: per command of one tool group, per module of one migration, per step of one feature in one team. The original becomes the parent: it keeps its title and goal and loses its estimate (Linear rolls the sub-issues up). A sub-issue may sit in another team (Linear allows it); use that for a layer piece of a goal owned by the add-in team.
- **Standalone related issues** (`relatedTo` the original) when a piece is worth doing on its own, may be scheduled apart or by someone else, or belongs to the other major version: "do the same in v4" is a standalone KTR4 issue related to the KTR5 one, never a sub-issue of it. The original keeps the remaining piece and a narrowed title.
- **Order across layers**: one piece per repository, in that repository's team, and each lower piece `blocks` the one above it (Kelly-Windows-Data → Kelly-Windows → Kelly-Domain → Kelly-Revit-Logic → Kelly-Revit-UI → Kelly-Revit). Say in each upper piece that it needs the lower package packed and repinned.
- **Size**: every piece fits one focused change; aim for 1 to 4 points on the exponential scale (`linear-issue-estimate-update` rubric) and never the top of the scale. A piece still at the top is split again. Two to about eight pieces per issue; more than that means splitting by a coarser seam (folder, module, panel).
- **Each piece is self-contained**: someone reading only that issue knows what to do. Title under about 80 characters, naming the tool or type and the problem or goal (the backlog's "Linear-ready items" rule); description in the layout of step 6.
- **Labels**: copy the original's "1 - Type" label (Add, Change, Fix, Delete) unless the piece is of another type, and its function label; a piece in another team gets the matching label of that team (`list_issue_labels`) or none. Copy the project when the piece's team is in it, and the priority.

## 4. Report and ask

Write the proposal to `C:\repo\jhkweb\Linear Splits\<yyyy-mm-dd> Linear Issue Splits.md` (add `HHmm` to the name when the day already has one):

- A summary table: team, open issues reviewed, Fine, Split, Unclear, new issues proposed, existing issues to link.
- One section per split issue, in the team order of step 1: a heading with the key as a link (`https://linear.app/jhkelly/issue/<KEY>`), its title and estimate, the signals, the shape, what the original keeps, then a table `# | Team | Title | Est. | Relation | Goal`.
- Then the Unclear issues (`Key | Title | Why`), to run through `linear-issue-info-review` first.
- Then the open questions.

It is a root working document: commit it to the outer jhkweb repo (just that path; never push). In chat give the summary table and the split issues with their pieces' titles, and ask the `Question:` lines with `AskUserQuestion` (issue key and title in each question, the drafted reading first marked "(Recommended)", up to four per round). Then ask in `wrap_up` whether to apply all, only some issues, or with the user's changes. Then stop and wait.

## 5. Check before applying

For each approved split, run `list_issues` with `query` once more in each target team: a matching issue created since the proposal is linked, not duplicated.

## 6. Apply, after approval

**New piece**: `save_issue` without `id`, with `team`, `title`, `description`, `labels`, `priority`, `project` (when the team is in it), `estimate`, and `parentId` (sub-issue) or `relatedTo: [<original>]` (standalone). Description layout:

```markdown
## Problem / Goal

<text>

## Where

- Repository: `<repo>`
- <project, `File.cs`, `TypeName.Member`, ribbon command>

## Done when

<what is true when this piece is finished; for an upper layer: "after the <layer> package with <piece> is packed and repinned">

---

Split from <ORIGINAL KEY> on <yyyy-mm-dd>.
```

Add "Steps to reproduce" (as in `linear-issue-info-review`) for a Fix piece when the original has them.

Create the pieces of one issue first, note their keys from the results, then add the order: `save_issue` on each lower piece with `blocks: [<upper piece key>]`, and link the approved existing issues (`parentId` or `relatedTo`).

**Original**: `save_issue` with `id` and
- for sub-issues: `estimate: null`, and a `patch` that appends `\n\nSplit on <date> into sub-issues <KEY>, <KEY>, … (split review).`;
- for standalone pieces: the narrowed `title` and `estimate` when it keeps a piece, and the same appended line naming the related issues;
- never its status, labels or project, unless the user asked.

The calls for different issues are independent: send them in parallel, about 25 per message. A refused call: collect it and report it, don't retry with something else.

Writing rules for every title and description:
- Wrap dotted names (`Kelly.Windows`) and file names in backticks, or Linear turns them into web links.
- Say "Major Version 4" or "v4", never "Generation". Name Kelly Tools For Revit or KTR only in the KTR* teams' issues.

## 7. Report and follow up

In chat, per team: issues split, new issues created (original → new keys), existing issues linked, refused calls. Add an "Applied <date>" section to the report file with the original → new keys and commit it again. Then offer in `wrap_up`:
- `linear-issue-estimate-update` for the new issues whose estimate was left `low` confidence, and
- `kelly-backlog-update` when a split issue has a line in a `Quick-Backlog.md` (` — Linear: <KEY>`): the backlog gets the new keys there.
