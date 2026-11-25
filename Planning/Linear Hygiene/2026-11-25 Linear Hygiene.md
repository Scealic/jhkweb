# Linear hygiene check, 2026-11-25

Rules: `BuildConfigs/LINEAR.md` and `.claude/LINEAR-KTR.md`. Scope: every open issue, plus issues closed or canceled on or after 2026-11-09, in 19 Kelly teams. Skipped: KTR4 and KTRL4 (no Major Version 4 work), KRDE (retired 2026-11-25, its issues moved to SDE) and Hasa. One Haiku checker per team; every flagged label and the three CDEC application-name search hits were re-checked by hand.

## Summary

| Team | Checked | Flagged | Flags |
|---|---:|---:|---|
| KTR5 | 400 | 15 | type 2, stale 13 |
| KTRL5 | 191 | 1 | function 1 |
| KTRUI | 38 | 0 | |
| KD | 101 | 4 | retired 1, function 1, app-named 2 |
| KW3 | 65 | 3 | retired 3 |
| KW2 | 1 | 0 | |
| KWD3 | 14 | 0 | |
| KWD2 | 1 | 0 | |
| KWDC | 6 | 0 | |
| KWDJ | 7 | 0 | |
| KWDSS | 35 | 1 | function 1 |
| KWDSL | 2 | 0 | |
| KWDE | 4 | 0 | |
| SDE | 8 | 2 | function 1, app-named 1 |
| PSU | 104 | 0 | |
| CDED | 36 | 1 | app-named 1 |
| CDEB | 6 | 4 | cancel 4 |
| CDEC | 25 | 0 | |
| FDT | 1 | 0 | |
| **Total** | **1,045** | **31** | |

No issue lacks an estimate (parents excepted), is too big, has the wrong assignee or has no priority.

## Rule documents out of step with Linear

The label groups are named **"Type"** and **"Function"** in the workspace (both single-select), not "1 - Type" and "4 - Function" as `LINEAR.md`, `LINEAR-KTR.md` and the `linear-issue-hygiene-check` brief say. Proposed: rename the groups in the three documents (or rename the groups in Linear back to the numbered names, which is a "1 - Type" change that needs the maintainer).

## Proposed fixes

### Function label missing (all Done 2026-11-17, the `IsAssignerContext` and view-filter work)

| Issue | Title | Proposed function label |
|---|---|---|
| [SDE-17](https://linear.app/jhkelly-ktr/issue/SDE-17) | Export the new `IsAssignerContext` column | Data and file I/O |
| [KWDSS-12](https://linear.app/jhkelly-ktr/issue/KWDSS-12) | `ExternalParameterDefinitions`: add `IsAssignerContext` | Data and file I/O |
| [KD-98](https://linear.app/jhkelly-ktr/issue/KD-98) | `ExternalParameterDefinition`: add `IsAssignerContext` | Content and parameters |
| [KTRL5-189](https://linear.app/jhkelly-ktr/issue/KTRL5-189) | `ViewFilterVisibility`: numeric filter rules | Views and graphics |

### Retired function label (open, Backlog)

| Issue | Title | Remove | Add |
|---|---|---|---|
| [KW3-54](https://linear.app/jhkelly-ktr/issue/KW3-54) | Move the shared WPF style dictionaries to `Kelly.Windows` | Windows helpers | Tools, ribbon and UI |
| [KW3-60](https://linear.app/jhkelly-ktr/issue/KW3-60) | `Kelly.Windows`: add the brand style dictionaries | Windows helpers | Tools, ribbon and UI |
| [KW3-58](https://linear.app/jhkelly-ktr/issue/KW3-58) | `DomainGroupReport.BuildMemberReport`: read EmployeeId | Windows helpers | Data and file I/O |
| [KD-61](https://linear.app/jhkelly-ktr/issue/KD-61) | Identifier `Empty` values throw from `GetHashCode` | Domain types | Architecture and services |

### Type label missing (open, Backlog)

| Issue | Title | Proposed type |
|---|---|---|
| [KTR5-4136](https://linear.app/jhkelly-ktr/issue/KTR5-4136) | OperationService: email the logs at every document close | Add |
| [KTR5-4493](https://linear.app/jhkelly-ktr/issue/KTR5-4493) | Claude Code: try Nice3point's revit-skills | Verify (ask: an evaluation, no code change expected) |

## For the maintainer (no automatic fix)

### Stale: started and not updated for more than 7 days (KTR5)

In Progress: [KTR5-4870](https://linear.app/jhkelly-ktr/issue/KTR5-4870) (11-17), [KTR5-4834](https://linear.app/jhkelly-ktr/issue/KTR5-4834) (11-13).
Testing: [KTR5-4744](https://linear.app/jhkelly-ktr/issue/KTR5-4744) (11-09).
In Review: [KTR5-4885](https://linear.app/jhkelly-ktr/issue/KTR5-4885) (11-17), [KTR5-4624](https://linear.app/jhkelly-ktr/issue/KTR5-4624) (11-16), [KTR5-4819](https://linear.app/jhkelly-ktr/issue/KTR5-4819), [KTR5-4822](https://linear.app/jhkelly-ktr/issue/KTR5-4822), [KTR5-4824](https://linear.app/jhkelly-ktr/issue/KTR5-4824) (11-12), [KTR5-4804](https://linear.app/jhkelly-ktr/issue/KTR5-4804) to [KTR5-4808](https://linear.app/jhkelly-ktr/issue/KTR5-4808) (11-11).

The In Review ones wait on a maintainer step (an install or an in-Revit run); `linear-issue-done-check` can say which are finished.

### Canceled without a reason on the issue (CDEB)

[CDEB-5](https://linear.app/jhkelly-ktr/issue/CDEB-5), [CDEB-6](https://linear.app/jhkelly-ktr/issue/CDEB-6), [CDEB-7](https://linear.app/jhkelly-ktr/issue/CDEB-7), [CDEB-8](https://linear.app/jhkelly-ktr/issue/CDEB-8): the reason is only in a comment on their parent [CDEB-1](https://linear.app/jhkelly-ktr/issue/CDEB-1). Fix: a one-line comment on each pointing to CDEB-1's reason.

### Application named outside the KTR teams

- [SDE-15](https://linear.app/jhkelly-ktr/issue/SDE-15): description names Kelly Tools For Revit in a folder path.
- [CDED-15](https://linear.app/jhkelly-ktr/issue/CDED-15): description says "KTRV5".
- [KD-119](https://linear.app/jhkelly-ktr/issue/KD-119): description says "switched in KTR5".
- [KD-127](https://linear.app/jhkelly-ktr/issue/KD-127): description names the file "Kelly Tools For Revit.md".

Checked and clear: CDEC-17, CDEC-18 and CDEC-28 matched the search but do not name the application.
