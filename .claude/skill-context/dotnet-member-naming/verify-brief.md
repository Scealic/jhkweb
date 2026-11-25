# Member naming check: reviewer brief (verify and report)

Readers (Sonnet) checked every member name in their slice and wrote findings files `naming-G<nn>.md` in `<work>\`. In earlier passes about half of the readers' "possible bugs" were documented behaviour, already filed or wrong, and some Misleading findings were overstated. Your job is to check them against the code and write one report.

READ ONLY on code: never edit source, never run git commands that change anything, never build, never touch Linear. Bash (Git Bash), Read, Grep, Glob only; never PowerShell. You may write only your report file.

Read first: the readers' brief `reader-brief.md` and the known list `known.md` (same folder). Do not use `C:\repo\jhkweb\UBIQUITOUS-LANGUAGE.md`: it is out of date; take terms from the code.

## Steps

1. Read your group files. Merge duplicates (the same member reported by two groups, or a finding in a lower layer reported again from a caller's side: keep it in the layer that owns the member, and mention the callers there).
2. **Every Misleading finding and every Possible bug: open the code and check it.** Keep it only if the code really does what the reader says. Downgrade overstated Misleading to Vague; drop wrong ones. For bugs, check the XML docs, callers and git history (`git -C <repo> log -L` or `log -S` when useful) to tell a bug from intended behaviour, and check the known list and existing issues (`grep -r` the member in `C:\repo\jhkweb\Planning` reports; known issues are in known.md).
3. Vague and Style: spot-check about one in four; keep the rest as reported unless clearly wrong. Drop items that are pure house style (noun-named pure methods) or that only restate a known decision.
4. Check each suggested name: no clash with an existing member of the same type or an extension on the same receiver (grep), follows the no-Transaction/Tx/Operation-suffix rule and `…Core` for building blocks that need the caller's transaction. Improve the suggestion if needed.
5. Mark Serialized/Shown names (data-file columns, JSON keys, Revit parameter names, Undo texts, ribbon item names, icon keys, XAML bindings by name).
6. Group the confirmed renames into proposed Linear issues (about 2 points each, one per area/type family, as earlier passes did: see `C:\repo\jhkweb\Planning\Member Naming\<date> <layer>.md` for the style), and the confirmed bugs into one issue each.

## Report

Write `C:\repo\jhkweb\Planning\Member Naming\<date> Pass <n> <layer>.md` (layer name given in your prompt):

```
# Member naming check, pass <n>: <layer> (<date>)
Pass <n>. Sources: groups <ids>. Readers: Sonnet; checked by: <you>.
## Summary
counts confirmed per severity, bugs confirmed / dropped
## Confirmed bugs
| Member | File:line | What is wrong | Evidence | Steps to show it | Priority (Urgent/High/Medium/Low per BuildConfigs/LINEAR.md) |
## Proposed rename issues
### R1: <title under 80 chars, names the type/area>
| Severity | Member | File:line | What it does | Suggested | Callers | Serialized/Shown |
(… R2, R3 …; a last batched Style issue)
## Dropped or downgraded
| Finding | Group | Why |
```

Plain English, short sentences. Wrap dotted names and file names in backticks. Under ~250 lines.

Your final reply: only the report path, counts (confirmed Misleading/Vague/Style, bugs confirmed/dropped), the proposed issue titles one per line, and the confirmed bugs one per line with priority.
