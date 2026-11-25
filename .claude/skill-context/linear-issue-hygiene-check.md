# linear-issue-hygiene-check: Kelly facts

- Rules: `C:\repo\jhkweb\BuildConfigs\LINEAR.md` (every team) and `C:\repo\jhkweb\.claude\LINEAR-KTR.md` (KTR teams).
- Scope: the teams the user named, else every Kelly team in `linear-teams.md` (Hasa skipped). Issues: every open issue, plus issues closed or canceled on or after 2026-11-09 (older closed issues are exempt from the estimate rule).
- Haiku subagent brief (fill in the team key and the date):

> Read-only. Load `list_issue_labels`, `list_issues`, `list_comments` (Linear MCP) with one ToolSearch call. 1) `list_issue_labels(team, includeGroups: true, limit 250)`: map every label name to its `parent` group. 2) `list_issues(team, limit 250, fields [id,title,statusType,status,estimate,labels,assignee,priority,parentId,createdAt,updatedAt,completedAt,canceledAt])`, following `cursor`; keep open issues and those completed or canceled on or after 2026-11-09. 3) For each kept issue, flag:
> - **no-estimate**: estimate null, unless it is a parent: check with `list_issues(parentId: KEY)`, because sub-issues can sit in another team;
> - **too-big**: open, estimate 16, and no issue has it as parent;
> - **type**: not exactly one label in group "Type"; **function**: not exactly one in "Function";
> - **feature** (team KTR5 only): no label in "5 - Feature" or none in "5 - Module"; (other teams) any label in those groups;
> - **assignee**: not Chris Hildebran;
> - **no-priority**: open and priority None (0); detail = a proposed priority by this rubric, then a reason of a few words: Urgent (fails to start or install, data lost, wrong data written to models or files), High (a tool gives wrong results or blocks a user, a release requirement), Medium (an Add or Change a person asked for, judged from the title; a Fix with a workaround), Low (internal: refactoring, cleanup, tests, docs, ideas, meetings). Judge from the title and labels; don't read bodies;
> - **retired**: a label from a retired group ("0 - Repository", "Issue - 0 - Role") or a retired type (Plan, Require, Technical Debt) on an open issue;
> - **stale**: status type `started` and `updatedAt` more than 7 days ago;
> - **cancel**: canceled on or after 2026-11-09: call `list_comments`; flag when no comment gives a reason or names a duplicate.
> 4) Team not KTR4/KTR5/KTRL4/KTRL5/KTRUI: `list_issues(team, query "Kelly Tools For Revit")` and `query "KTR"`; flag **app-named** only where the title, description or a comment names the application; a KTR issue key, an issue link or a repository name such as `Kelly-Revit-v5` is allowed, so read the hit before flagging it.
> Return only lines `KEY<TAB>flag<TAB>detail` (detail under 80 characters, e.g. the labels found), then one line `TOTAL<TAB>checked=<n><TAB>flagged=<n>`. No issue bodies.

- Fixes: assignee flag proposes the maintainer (`assignee: "me"`); retired type maps to Add, Change, Fix, Delete or Verify by title (definitions in `LINEAR.md`); retired group labels are removed.
- Report file: `C:\repo\jhkweb\Planning\Linear Hygiene\<yyyy-mm-dd> Linear Hygiene.md`; commit just that path to the jhkweb root repository (`git -C C:/repo/jhkweb add` the file); never push. Commit again after applying.
- Applying: one `save_issue` call at a time (parallel writes to Linear have been dropped silently) and check each returned `labels` and `assignee`. Subagents applying a long list misread responses and report false failures: redo their failures by hand, then confirm with sweeps (`list_issues` with `assignee: null`, and `priority: 0` per open state).
