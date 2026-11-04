---
name: linear-issue-info-review
description: Review every open issue in the Kelly teams of the Linear workspace "jhkelly" to check it has enough information to be worked on by Claude Code or another person - a stated problem or goal, where in the code it lives, and for fixes the steps to reproduce - draft the missing information from the code under C:\repo\jhkweb, interview the user only about what the code can't answer, propose Done or Canceled for issues that are already finished or obsolete, and after approval rewrite the issue descriptions in Linear. Use whenever the user asks to review, audit, check, clean up, groom, triage, fill in or improve Linear issues, find thin, vague or title-only issues, or asks whether the issues have enough detail, for all teams, one team, one project or a list of keys.
---

# Review the Linear issues for enough information

Linear is shared, and a description someone wrote is theirs: **never change a description, a status or anything else in Linear without the user's approval in this conversation.** Steps 1 to 4 only read. The result lives in the issues themselves: no report file.

## 1. Scope

Default: every **open** issue (status type `triage`, `backlog`, `unstarted` or `started`) in every Kelly team, sub-teams included. Narrow it when the user names teams, a project, a label or keys. **Skip the Hasa team and its sub-teams** (another product, no code here; decision of 2026-11-04). Done, Canceled and Duplicate issues are not reviewed.

Check the teams with `list_teams` first; the user may have added or renamed some. Teams and their code:

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

Fetch per team: `list_issues` with `team`, `limit: 250`, `fields: ["title","description","status","statusType","labels","project","priority","parentId","createdAt","updatedAt"]`, following `cursor` until `hasNextPage` is false, and keep the open status types. Descriptions come back truncated; call `get_issue` when the truncated text decides the verdict. Read `list_comments` for an issue that fails a check before calling it thin: the information may be in a comment.

## 2. The checks

An issue has enough information when **all that apply** pass:

| Check | Passes when | Applies to |
|---|---|---|
| **Problem or goal** | The title or description says what is wrong or wanted, and why it matters or what it is for, clearly enough that someone who didn't write it knows what to do. "Limit what they can be used for" fails (what? limit how?). | Every issue |
| **Where** | It names the repository (or the team implies it) **and** at least one of: project, file, type, member, ribbon command or tool, data file, build file. The `(Command)` project an issue sits in counts as naming the tool. | Every issue |
| **Steps to reproduce** | The steps, the Revit year (2024/2025/2026), the model or kind of model, what was expected and what happened. A failing test or a review finding with file and line also counts. | Issues labelled **Fix** (workspace label group "1 - Type"), or old issues whose title starts with "Fix" or "Bug" |

Rate each issue **Pass**, **Thin** (fails at least one check; name which), **Stale** (see step 3) or **Wrong team** (the code it names now lives in another repository, for example after a layer move; the description often says "this item belongs in the … backlog"; KD-10 was the first, checked 2026-11-04). An issue can be Thin and Wrong team at once. A parent issue whose sub-issues carry the detail passes on its own title and a one-line goal.

The issues moved from the backlogs on 2026-11-04 (footer "From `…/Quick-Backlog.md` › …") usually pass "Where" and "Problem". The older KTR5 issues (keys below about 4500, labels like "Meeting -> Review", titles like "Add - …") are often title-only.

## 3. Draft from the code

The volume is large (KTR5 alone has about 160 open issues). Send one subagent per team, or per 100 issues of a big team, all in one message so they run in parallel. Each gets: the team, its repository path, the checks above, the issue keys with their titles, descriptions, labels and projects, and these instructions:

- **Only read**: no `save_issue`, no `save_comment`, no edits.
- For each issue, search the repository (Grep and Glob; for KTR5/KTR4 the ribbon commands under `modules/`, for the lower layers `src/`) for the tool, type or behaviour the issue names, and read enough to fill the gaps: the files and types involved, what the code does now, and for a fix how the bug would show.
- Check `git -C <repo> log --oneline -i --grep=<keyword>` and the repository's `Quick-Backlog.md` for evidence it was **already done** (a commit, a ticked backlog item with this key) or is **obsolete** (the tool, type or file no longer exists; the item was superseded). Such an issue is Stale: give the evidence.
- Return one block per issue that is not Pass:

```
KEY | Thin: <checks failed> | Stale: <done/obsolete + evidence, or -> | Team: <right team key + evidence, or ->
Problem / Goal: <drafted text, or "?" if the code can't tell>
Where: <repo, project, files, types, command>
Steps to reproduce: <drafted, or "?" (Fix only)>
Question: <what only the user can answer, or ->
```

and for Pass issues only the key. A drafted line is the subagent's reading of the code, so it states what the code shows ("`PipeSlopeCommand` sets the slope of every selected pipe; nothing limits it to sloped systems"), never a guess at what the user meant.

## 4. Interview

Show a summary first: per team, open issues, Pass, Thin, Stale. Then go through the Thin issues **grouped by project or command**, and ask with `AskUserQuestion` **only what the code can't answer** (the `Question:` lines), up to four issues per round:

- Put the issue key and its title in the question, and say what the draft already holds.
- Options are the likely answers, with the drafted reading first marked "(Recommended)" where the code points to one; add "Cancel this issue" when it may no longer be wanted. The user can always answer in "Other".
- An issue whose drafts have no `?` needs no question: show its draft in the batch for approval in step 5.
- An answer that doesn't fit, or that is uncertain ("not sure", "ask Bob"), leaves the issue Thin: note it and move on.

Then list the Stale issues in a table (`Key | Title | Proposed | Evidence`), with Done for finished work and Canceled for obsolete work, and the Wrong team issues in another (`Key | Title | Move to | Evidence`).

## 5. Approve

Show what will be written, per team: each Thin issue's new description (or, for many, the key, title and the three drafted lines) and the Stale issues' new status. Ask in `wrap_up` whether to apply all, only the descriptions, or with the user's changes. Then stop and wait.

## 6. Apply, after approval

**Description** of a Thin issue: `save_issue` with `id` and `description` in this layout. Keep everything that was there:

```markdown
## Problem / Goal

<text>

## Where

- Repository: `<repo>`
- <project, `File.cs`, `TypeName.Member`, ribbon command>

## Steps to reproduce

1. <step> (Revit <year>, <model>)
2. …

Expected: <…>. Actual: <…>.

## Original description

<the previous description, unchanged; omit the heading if it was empty>

---

Information reviewed <yyyy-mm-dd> (from the code and the Senior Software Developer's answers).
```

- "Steps to reproduce" only for Fix issues.
- Keep an existing footer (for example the "From `…/Quick-Backlog.md`" line) above the review line.
- Wrap dotted names (`Kelly.Windows`) and file names in backticks, or Linear turns them into web links.
- Say "Major Version 4" or "v4", never "Generation". Name Kelly Tools For Revit or KTR only in the KTR* teams' issues.
- Change only the description: not the title, labels, priority or project, unless the user asked.

**Status** of an approved Stale issue: `save_issue` with `id` and `state` (`Done` or `Canceled`, by the team's status names; call `list_issue_statuses` if unsure), then `save_comment` on it with the evidence ("Closed in the information review of <date>: <commit or reason>").

**Team** of an approved Wrong team issue: `save_issue` with `id` and `team` (the new team key). Linear gives it a new key, and labels that the new team lacks can be dropped, so note the new key from the result and report both keys. The repository backlog line keeps the old key until `kelly-backlog-update` moves it.

The calls are independent: send them in parallel, about 25 per message. A refused call: collect it and report it, don't retry with something else.

## 7. Report and follow up

In chat, per team: descriptions rewritten, issues closed (Done / Canceled), issues moved (old key → new key), issues still Thin (with what is missing), and refused calls. Issues closed here may still be open in a `Quick-Backlog.md` (the line ending ` — Linear: <KEY>`): offer, in `wrap_up`, to tick or mark them there with `kelly-backlog-update`. The backlog files don't change otherwise.
