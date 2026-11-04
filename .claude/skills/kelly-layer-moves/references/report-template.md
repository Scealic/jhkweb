# Report template

Two working documents at `C:\repo\jhkweb` (in no repo), both named with the run's date:

- `LAYER-MOVES-PLAN-<yyyy-mm-dd>.md`, written after the analysis and before any code changes, for the user to confirm;
- `LAYER-MOVES-<yyyy-mm-dd>.md`, written after the implementation and audit.

Every number in them is counted (grep, the workflow results, the test logs), not estimated. Keep the move numbers (`#1` … `#N`) the same in both.

## The plan

```markdown
# Layer moves plan - <date>

<Two or three sentences: what was analysed (repos, number of files read, scopes), how (finders, adversarial review, compile probe), and that nothing has changed yet.>

## Summary

| | Count |
|---|---|
| Files read | <n> of <n> in scope |
| Moves proposed | <n> |
| Rejected by review | <n> |
| Accepted (as proposed / modified) | <n> (<n> / <n>) |
| Whole-file moves that compiled in the probe | <n> of <n> |
| Type and member extractions (not probed) | <n> |

By target layer: | Target | From | Moves | Risk low/medium/high |

## Moves by target layer

### Kelly-Windows-Data (work package P1a-...)
| # | From (repo:path) | Symbol | Granularity | To (folder, namespace) | Why | Risk | Probe |
...one table per target layer, bottom-up...

## Decisions needed

<Numbered questions, one per move or group the user must decide: medium/high-risk moves, upward moves, public API breaks, moves of approved
exceptions, anything that changes persisted type names. Give a recommendation for each.>

## Rejected (and why)

<One line per rejected move, grouped by reason: protected type, needs RevitAPIUI, churn, used by the source layer, ...>

## Kept on purpose

<The notable keeps: files that look misplaced but are where they belong, with the reason.>

## Rules baseline

<check-rules.pl output summary before any change, including pre-existing hits.>

## Implementation order

<The steps and work packages bottom-up, the layers that are repin-only, and what is compiled but not run (in-Revit tests).>
```

## The after action report

```markdown
# Layer moves - <date>: after action report

<Intro: the moves went bottom-up; every move was proposed by an analysis agent, attacked by an adversarial reviewer, compile-probed
(whole-file moves), implemented test-first, reviewed again, built in every configuration and committed. Nothing was pushed.
Linear project: [Layer Moves <date>](<project url>), <state>.>

## What was planned

<One paragraph: the scopes analysed, the moves the analysis found, how many the review and probe kept, what the user dropped or
deferred at the plan, and the packages that came out of it.>

## What happened

| Repo | Run commits | Package | NUnit tests (before → after) |
|---|---|---|---|
| Kelly-Windows-Data | <n> (`<first sha>` … `<last sha>`) | `<version>` | <n> → <n> per configuration |
...
| Kelly-Revit | `<sha>` | not a package (21 configurations built, none installed) | in Revit 2024: <n> of <n> pass (name the add-in-started failures), or "compiled, not run" |

| Package | Linear | Moves | Status | Commit |
|---|---|---|---|---|
| P2a-windows-text | [KW3-12](<url>) | #4, #5, #9 | Done | `<sha>` |
...

- <n> moves planned: <n> done, <n> partial, <n> skipped.
- <n> errors in <n> configurations.
- Rules held: no Autodesk types in Windows.Data, Windows or Domain; <n> commands and <n> view/view-model files still in Kelly-Revit; namespace == folder for <n> files (check-rules.pl, before and after).

## What moved, by layer

### Into Kelly-Windows-Data
<Bullets per group: what, from where, old → new namespace.>
...

## Not done

### Partial
<#n: what is done, what is left, why.>
### Skipped
### Dropped (by the user, at the plan)
### Deferred

## Behaviour you may notice

<Anything a user of the add-in or a developer could see: a public type in a new namespace, a type that became public, a log line from a
different source. "None" if none.>

## Bugs found and deliberately NOT fixed

### High
<Linear key; file:line, what happens, how it was found; the test that characterizes it.>
### Medium

## What went well

<What worked and should be kept: a review that caught a real break, a probe that turned a whole-file move into an extraction, a
package size that committed cleanly.>

## What went wrong

<Each problem: what happened, its cost (time, rework, a failed run), and its cause. Plain facts, no blame. "Nothing" if nothing.>

## What to change next time

<Concrete changes for the next run, each tied to a "What went wrong" item: a rule for placement-rules.md, a script fix, a scope
split, a check to add. Say which were already made to the skill in this run.>

## Things to check

<What only the user can check: in-Revit test runs, a visual check in Revit, a merge order, the user's own uncommitted files left untouched.>

## Next

<One concrete recommended next step, usually: run the in-Revit tests for Logic and Kelly-Revit in Revit 2024, then push develop bottom-up.>
```
