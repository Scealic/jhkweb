# Coverage Linear issues: the rules the subagent follows

Section 5 of `dotnet-test-coverage-check`. The `coverage-linear` subagent reads this file; the main conversation only approves.

**Teams:** the repo → team table in `C:\repo\jhkweb\.claude\skill-context\linear-teams.md`; check with `list_teams`. A repo with no team there: report it and file nothing for it.

**Label** "Test Coverage" on every issue: it is how the next review finds them (`list_issues` with that label, per team, every state, following `cursor`). It did not exist on 2026-11-05: create it as a workspace label the first time, as part of the approved list.

**Each issue:**
- Title: `Tests: <Type> — <n> members untested` (or `— no test`), under about 80 characters.
- Description: the repo, the file path, the untested members (name and kind), the test file to extend if one exists, the review date, and a pointer to "How to backfill a type" in the report. Remind that new tests carry `Author = "Verified By Human On:"` and a real `Description`.
- Estimate by untested members: **1** for 1–2, **2** for 3–5, **4** for 6–10, **8** for more. No priority. Every team in scope used the exponential scale (1, 2, 4, 8, 16) when checked on 2026-11-05: KWD3, KW3, KD, KTRL5, KTRUI and KTR5 from their estimates; KWDC and KWDJ had no issues yet, so assumed. Don't look the scales up again. If Linear refuses an estimate, or a team is added, find that team's scale as step 2 "Find each team's scale" of `C:\Users\childebran\.claude\skills\linear-issue-estimate-update\SKILL.md` says, and update this line.

**Earlier issues** (found by the label):
- Still a gap → update the description to today's member list if it changed; reopen one that was closed.
- Every member now named in a test → Done, with a comment: the review date, the test file(s) and the commit that added the tests (`git log` on the test file).
- Type removed or renamed → Canceled, with a comment naming the commit; the new name gets its own issue.
