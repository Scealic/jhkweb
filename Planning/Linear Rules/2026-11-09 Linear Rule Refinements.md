# Linear rule refinements, 2026-11-09

Proposal. The rule text is drafted, uncommitted, in `BuildConfigs/LINEAR.md` (with its `Changelog.md` entry) and `.claude/LINEAR-KTR.md`; review the diffs there. The Linear changes below are not made yet: each waits on approval.

## 1. Decisions the draft assumed

Each is drafted as stated; change any you disagree with before the draft is committed.

| # | Question | Drafted as | Alternative |
|---|---|---|---|
| D1 | What happens to the extra "1 - Type" labels? | Keep **Verify** (a check with no code change expected). Retire **Plan** and **Require** ("4 - Function" already has "Planning and requirements") and **Technical Debt** ("Code quality and cleanup" covers it), after relabelling their issues. | Keep all eight and define each in the rule. |
| D2 | Priority and cycles | Agents set no priority; the maintainer sets priority and cycles. | Agents propose a priority (Urgent only for a broken install or data loss). |
| D3 | Done vs In Review | Done when committed and checked as far as the session can. In Review only when the issue's own goal needs a maintainer step (in-Revit run of an untested fix, an install a user waits for). "Built, not installed" alone is still Done. | In Review whenever anything is unverified. |
| D4 | "2 - Who" / "3 - How" | Set only when a person raised the issue; agents' own findings get neither. | Retire both groups. |
| D5 | Feature and module labels outside KTR5 | None for KTR4 or the layer teams. | Add "4 - Feature" / "4 - Module" groups to KTR4. |
| D6 | v4/v5 twins | Filed in both teams, linked Related. | Filed only in the version where it was found, with a note. |

## 2. Linear changes (after approval)

1. **Retire label group "0 - Repository"** (active: `VCS-Database-General`, `VCS-Database-Content-Schema`, `Kelly.Windows`, `Kelly.Revit.Logic`, `Kelly.Revit`). The team already names the repository, and the labels use pre-2026-10-27 names.
2. **Retire label group "Issue - 0 - Role"** (active: Application, General, Content). No rule uses it, and "4 - Function" sorts the same issues.
3. **"1 - Type"** per D1: count the issues on Plan, Require and Technical Debt, relabel each (Plan/Require → Add or Change with function "Planning and requirements"; Technical Debt → Change with "Code quality and cleanup"), then retire the three. Add descriptions to the five kept labels, matching the rule.
4. **"5 - Feature" descriptions**: none of the active labels has one. Fill each with the command class or type it stands for (read from Kelly-Revit-v5 `modules/`), so agents match features to code rather than guess.
5. **Issue templates**:
   - Retire the stale workspace templates: "Add - SQL Many-To-Many Table", "Add - SQL Table", "Add - SQL Database - Field" (move to KWDSS if the schema repos still want them), "External Command", "C# Class - Create (Personal)", "C# Record - Create Data Transfer Object (Personal)", "Issue - Developer (Personal)", "Testing - Development End".
   - Move "Create Kelly Tools Release" and "Version Release - Kelly Tools For Revit (Personal)" from the workspace to KTR4 and KTR5 (they name the application).
   - Add two workspace templates that follow the filing rule: **Fix** (Where in the code / What happens / Expected / Steps to show it / Found on) and **Add or Change** (Where in the code / Goal / Done when / Found on).

## 3. Enforcement: a `linear-issue-hygiene-check` skill

The rules are prose; nothing checks them between the estimate and split passes. A cheap read-only skill (Haiku subagent, one `list_issues` page loop per team) that reports, per team, the issues missing or breaking a rule:

- no estimate (except parents with open sub-issues), or 16 points with no sub-issues;
- not exactly one "1 - Type" and one "4 - Function" label;
- KTR5 without a "5 - Feature" or "5 - Module" label;
- not assigned to the maintainer;
- a priority set by an agent (D2), a Canceled issue with no comment, a Duplicate with no relation;
- In Progress with no update in 7 days;
- application named in a non-KTR team's issue.

It writes a dated report under `Planning\Linear Hygiene` and, after one approval, fixes the mechanical gaps (assignee, missing relation) and lists the rest. Description kept short so it costs little per session.

## Applied 2026-11-09

Approved by the maintainer as drafted (D1–D6 unchanged).

- **Rules committed:** `BuildConfigs/LINEAR.md` and `Changelog.md` (BuildConfigs bba4b31), `.claude/LINEAR-KTR.md` (root 6488486).
- **"1 - Type" relabelled:** 58 KTR5 issues (6 Plan, 25 Require, 27 Technical Debt; no other team used them), each to Add, Change, Fix, Delete or Verify by its title; the function label was left as it was. Afterwards no issue carries Plan, Require or Technical Debt, and the three labels are retired. Add, Change, Fix, Delete and Verify have descriptions matching the rule.
- **Retired groups:** "0 - Repository" and "Issue - 0 - Role" (with their labels; issues keep them, new issues can't get them).
- **"5 - Feature" descriptions:** all 120 active labels described; 102 name the type found in the code, 18 say there is no code yet. Matched with less confidence, worth a look:
  - Spool Creator V1 / V2: only `SpoolCreateCommand` exists; given to V2, V1 marked "no separate code".
  - Shop and Field Line Color View Filter: no own command; `PipeAndWeldFieldTrimLineColorViewFilterCommand` went to its own label.
  - Stratus Detailing Package Views Create With User Interface: the command has no dialog; marked no code.
  - Family Shared Parameter Manager → `FamilySharedParameterReportCommand` (a report, not a manager).
  - Project Session (Service) → `ApplicationSessionService` (name differs).
  - All Server Data Recache: removed 2026-10-30, replaced by Reload Data.
  - The "(Application Cache)" labels point at the `Kelly.Domain.Caches.*Cache` types.
  - Olet Checker, Valve Clearance Sphere Place, Family Revision Setter, Duct QA Length/Mirror, Spool Cleaner and the Vicious tools: worded from class name and tooltip.
- **Enforcement:** `linear-issue-hygiene-check` skill added to the personal skills (commit 3513e70).
- **Not applied, templates (item 5):** the Linear connector cannot edit, move or delete issue templates. They need the Linear UI (Settings › Templates) or Claude in Chrome.
- **Seen during the work:** Linear caps label descriptions at 255 characters; parallel `save_issue` and `save_issue_label` calls were sometimes dropped silently, so writes go one at a time (written into the new skill).
