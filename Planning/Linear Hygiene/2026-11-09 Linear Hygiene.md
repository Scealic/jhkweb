# Linear hygiene check, 2026-11-09

First run of `linear-issue-hygiene-check`, against `BuildConfigs/LINEAR.md` (with the priority rule added today) and `.claude/LINEAR-KTR.md`. Scope: every Kelly team except Hasa; every open issue plus issues closed on or after 2026-11-09. Checked: KTR5 229, KTRL5 89, KTR4 50, KD 31, KW3 17, KTRUI 6, KWD3 4, KWDJ 3, KWDSS 3, KTRL4 2, KWDC 1, KW2 1; KWD2, KWDSL and KRDE had none in scope. Nothing changed in Linear yet.

## Read first

- **Assignee** is the biggest gap: 232 open issues have none, mostly the issues created before the assignee rule of 2026-11-06. One fix, no judgement.
- **Priority**: 289 open issues have No priority. The proposals are from titles and labels only; the Urgent and High ones deserve a look:
  - Urgent (wrong data written): KTRL5-87 (overwrites signature edits), KTR5-4767 (Esc still renumbers ducts), KTR5-4754 (item numbers written with errors), KTR5-4448 (inaccurate move), KTR5-4064 (default value written to elements).
  - Lowered by review: KTR4-27 and KTR5-4631 were proposed Urgent; set to High, since an align button overriding a typed elevation is a wrong result, not data loss.
- **Feature labels**: 82 KTR5 issues lack "5 - Feature" or "5 - Module"; matching them needs the code, so it is a separate feature pass, not applied with the mechanical fixes.
- **App-named**: the hits come from a text search; several are probably only links to KTR issue keys, which the rule allows. Check by hand.
- **No-estimate**: KTRL5-4 (completed today), KTR5-4758, KTR5-4765. **Too big**: KWD3-2 (16 points, no sub-issues).
- No **stale** In Progress issue and no **cancel** without a reason were reported.

## Summary

| Team | assignee | no-priority | type | feature | retired | no-estimate | too-big | app-named |
|---|---|---|---|---|---|---|---|---|
| KTR5 | 92 | 136 | 16 | 82 | 3 | 2 | 0 | 0 |
| KTRL5 | 46 | 74 | 1 | 0 | 0 | 1 | 0 | 0 |
| KTRUI | 4 | 6 | 0 | 0 | 0 | 0 | 0 | 0 |
| KTR4 | 50 | 16 | 0 | 0 | 0 | 0 | 0 | 0 |
| KTRL4 | 2 | 2 | 0 | 0 | 0 | 0 | 0 | 0 |
| KD | 24 | 26 | 0 | 0 | 0 | 0 | 0 | 6 |
| KW3 | 10 | 17 | 0 | 0 | 0 | 0 | 0 | 2 |
| KW2 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 0 |
| KWD3 | 3 | 4 | 0 | 0 | 0 | 0 | 1 | 0 |
| KWDC | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 |
| KWDJ | 0 | 3 | 0 | 0 | 0 | 0 | 0 | 0 |
| KWDSS | 0 | 3 | 0 | 0 | 1 | 0 | 0 | 2 |
| KRDE | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 |
| **All** | **232** | **289** | **17** | **82** | **4** | **3** | **1** | **11** |

Proposed priorities: Urgent 5, High 26, Medium 10, Low 248.

## KTR5

### assignee (92)

Fix: set to the maintainer (`assignee: "me"`).

| Issue | Detail |
|---|---|
| KTR5-4701 | unassigned |
| KTR5-4699 | unassigned |
| KTR5-4697 | unassigned |
| KTR5-4702 | unassigned |
| KTR5-4704 | unassigned |
| KTR5-4706 | unassigned |
| KTR5-4707 | unassigned |
| KTR5-4719 | unassigned |
| KTR5-4640 | unassigned |
| KTR5-4642 | unassigned |
| KTR5-4680 | unassigned |
| KTR5-4657 | unassigned |
| KTR5-4749 | unassigned |
| KTR5-4748 | unassigned |
| KTR5-4747 | unassigned |
| KTR5-4745 | unassigned |
| KTR5-4743 | unassigned |
| KTR5-4661 | unassigned |
| KTR5-4626 | unassigned |
| KTR5-4708 | unassigned |
| KTR5-4637 | unassigned |
| KTR5-4700 | unassigned |
| KTR5-4698 | unassigned |
| KTR5-4696 | unassigned |
| KTR5-4618 | unassigned |
| KTR5-4660 | unassigned |
| KTR5-4659 | unassigned |
| KTR5-4643 | unassigned |
| KTR5-4625 | unassigned |
| KTR5-4655 | unassigned |
| KTR5-4705 | unassigned |
| KTR5-4703 | unassigned |
| KTR5-4663 | unassigned |
| KTR5-4667 | unassigned |
| KTR5-4666 | unassigned |
| KTR5-4648 | unassigned |
| KTR5-4647 | unassigned |
| KTR5-4624 | unassigned |
| KTR5-4658 | unassigned |
| KTR5-4656 | unassigned |
| KTR5-4664 | unassigned |
| KTR5-4665 | unassigned |
| KTR5-4646 | unassigned |
| KTR5-4636 | unassigned |
| KTR5-4652 | unassigned |
| KTR5-4651 | unassigned |
| KTR5-4650 | unassigned |
| KTR5-4649 | unassigned |
| KTR5-4641 | unassigned |
| KTR5-4639 | unassigned |
| KTR5-4638 | unassigned |
| KTR5-4635 | unassigned |
| KTR5-4678 | unassigned |
| KTR5-4682 | unassigned |
| KTR5-4645 | unassigned |
| KTR5-4644 | unassigned |
| KTR5-4714 | unassigned |
| KTR5-4713 | unassigned |
| KTR5-4716 | unassigned |
| KTR5-4717 | unassigned |
| KTR5-4718 | unassigned |
| KTR5-4654 | unassigned |
| KTR5-4653 | unassigned |
| KTR5-4715 | unassigned |
| KTR5-4631 | unassigned |
| KTR5-4662 | unassigned |
| KTR5-4668 | unassigned |
| KTR5-4693 | unassigned |
| KTR5-4627 | unassigned |
| KTR5-4634 | unassigned |
| KTR5-4632 | unassigned |
| KTR5-4633 | unassigned |
| KTR5-4689 | unassigned |
| KTR5-4712 | unassigned |
| KTR5-4711 | unassigned |
| KTR5-4710 | unassigned |
| KTR5-4709 | unassigned |
| KTR5-4581 | unassigned |
| KTR5-4582 | unassigned |
| KTR5-4597 | unassigned |
| KTR5-4602 | unassigned |
| KTR5-4608 | unassigned |
| KTR5-4609 | unassigned |
| KTR5-4610 | unassigned |
| KTR5-4623 | unassigned |
| KTR5-4630 | unassigned |
| KTR5-4681 | unassigned |
| KTR5-4685 | unassigned |
| KTR5-4694 | unassigned |
| KTR5-4601 | unassigned |
| KTR5-4621 | unassigned |
| KTR5-4596 | unassigned |

### no-priority (136)

Fix: set the proposed priority (first word).

| Issue | Detail |
|---|---|
| KTR5-3774 | Low - internal export refactor |
| KTR5-3773 | Low - internal export refactor |
| KTR5-3772 | Low - internal export refactor |
| KTR5-4128 | Low - internal port to C# |
| KTR5-4121 | Low - internal port to C# |
| KTR5-3695 | Low - tests |
| KTR5-3278 | Low - feature gap, no requester |
| KTR5-4077 | Low - review meetings |
| KTR5-3839 | Medium - Add asked by Adam Fuller |
| KTR5-4789 | Low - internal refactor |
| KTR5-4761 | Low - internal refactor |
| KTR5-4751 | Low - internal UserPrompt refactor |
| KTR5-4040 | High - tool can move categories it should not |
| KTR5-4758 | Low - internal refactor |
| KTR5-4788 | Low - internal refactor |
| KTR5-4787 | Low - internal refactor |
| KTR5-4786 | Low - internal refactor |
| KTR5-4767 | Urgent - Esc still renumbers ducts (wrong data written) |
| KTR5-4785 | Low - internal refactor |
| KTR5-4784 | Low - internal refactor |
| KTR5-4750 | Low - duplicated code cleanup |
| KTR5-4783 | Low - internal refactor |
| KTR5-4782 | Low - internal refactor |
| KTR5-4781 | Low - internal refactor |
| KTR5-4779 | Low - idea |
| KTR5-4778 | Low - idea |
| KTR5-4768 | Low - internal resource leak |
| KTR5-4757 | Low - feature gap, no requester |
| KTR5-4756 | Low - feature idea, no requester |
| KTR5-4755 | Low - feature idea, no requester |
| KTR5-4752 | Low - feature idea, no requester |
| KTR5-4753 | Low - feature idea, no requester |
| KTR5-4754 | Urgent - may write item numbers with errors |
| KTR5-4766 | Medium - Fix with a workaround |
| KTR5-4780 | High - ribbon button does nothing |
| KTR5-4085 | Low - feature idea |
| KTR5-4174 | Low - feature idea |
| KTR5-4016 | Low - UI feature idea |
| KTR5-4015 | Low - UI feature idea |
| KTR5-3924 | Medium - Change asked by Adam Fuller |
| KTR5-3911 | Low - feature idea |
| KTR5-3936 | Low - internal refactor |
| KTR5-3937 | Low - question to users |
| KTR5-3938 | Low - feature idea |
| KTR5-3279 | Low - feature idea |
| KTR5-3281 | Low - internal refactor |
| KTR5-4009 | Low - feature idea |
| KTR5-4024 | Low - feature idea |
| KTR5-4255 | Low - tool idea |
| KTR5-4028 | Low - feature idea |
| KTR5-4256 | Low - tool idea |
| KTR5-4029 | Low - feature idea |
| KTR5-4042 | High - tool fails on one duct shape |
| KTR5-4043 | Medium - Fix with a workaround |
| KTR5-4448 | Urgent - inaccurate move writes wrong geometry |
| KTR5-4063 | Low - feature idea |
| KTR5-4064 | Urgent - default value written to elements |
| KTR5-4478 | Low - performance cleanup |
| KTR5-4480 | Low - internal robustness |
| KTR5-3680 | High - trapezes too wide, wrong results |
| KTR5-4493 | Low - tooling experiment |
| KTR5-4496 | High - tool fails on nested families |
| KTR5-3703 | High - closing mid-update can leave partial data |
| KTR5-4110 | Low - internal dependency removal |
| KTR5-4517 | Low - dead code |
| KTR5-4518 | Low - dead code |
| KTR5-4519 | Low - dead code |
| KTR5-4119 | Low - feature idea |
| KTR5-4120 | Low - feature idea |
| KTR5-4122 | Low - feature idea |
| KTR5-4123 | Low - feature idea |
| KTR5-4520 | Low - dead code |
| KTR5-4124 | Low - feature idea |
| KTR5-4127 | Low - feature idea |
| KTR5-4521 | Low - dead code |
| KTR5-4697 | Low - internal refactor |
| KTR5-4702 | Low - feature idea |
| KTR5-4125 | Low - feature idea |
| KTR5-4126 | Low - feature idea |
| KTR5-4704 | Low - internal robustness |
| KTR5-4706 | Low - internal robustness |
| KTR5-4707 | Low - internal robustness |
| KTR5-4170 | Low - internal refactor |
| KTR5-4175 | Low - code style |
| KTR5-4177 | Low - feature idea |
| KTR5-4680 | Low - TODO review |
| KTR5-4749 | Low - test cleanup |
| KTR5-4748 | Medium - Fix, may fail on show |
| KTR5-4740 | Low - internal cleanup |
| KTR5-4728 | Low - internal cleanup |
| KTR5-4626 | Low - report sort order |
| KTR5-4708 | Low - test coverage |
| KTR5-4700 | Low - internal refactor |
| KTR5-4698 | Low - internal refactor |
| KTR5-4696 | Low - internal refactor |
| KTR5-4618 | Low - feature idea |
| KTR5-4625 | Low - UI refactor |
| KTR5-4705 | Low - tests |
| KTR5-4703 | Low - tests |
| KTR5-4663 | High - spool categories fail to parse |
| KTR5-4624 | Low - UI feature idea |
| KTR5-4652 | High - quality counts never fire |
| KTR5-4678 | Low - internal cleanup |
| KTR5-4682 | Low - internal cleanup |
| KTR5-4714 | Low - internal refactor |
| KTR5-4713 | Low - internal refactor |
| KTR5-4716 | Low - internal cleanup |
| KTR5-4717 | Low - internal cleanup |
| KTR5-4718 | Low - internal cleanup |
| KTR5-4715 | Low - internal cleanup |
| KTR5-4631 | High - overwrites a typed elevation (wrong result; proposed Urgent, matches KTR4-27) |
| KTR5-4693 | High - release requirement, no VPN |
| KTR5-4627 | Low - brand color idea |
| KTR5-4634 | Low - design decision |
| KTR5-4632 | Low - design refactor |
| KTR5-4633 | Low - design cleanup |
| KTR5-4689 | Low - test plan |
| KTR5-4712 | Low - tests |
| KTR5-4711 | Low - tests |
| KTR5-4710 | Low - tests |
| KTR5-4709 | Low - tests |
| KTR5-4581 | Low - recovery tool idea |
| KTR5-4582 | Low - internal refactor |
| KTR5-4597 | Low - question |
| KTR5-4602 | Low - internal settings idea |
| KTR5-4608 | Low - unclear, title only |
| KTR5-4609 | Low - unclear, title only |
| KTR5-4610 | Low - unclear, title only |
| KTR5-4623 | Low - icon design |
| KTR5-4630 | Low - internal cleanup |
| KTR5-4681 | Low - internal dedupe |
| KTR5-4685 | Low - rename cleanup |
| KTR5-4694 | Low - verify in Revit |
| KTR5-4601 | Low - installer config |
| KTR5-4621 | Low - feature idea |
| KTR5-4596 | Low - feature idea |

### type (16)

Fix: add the proposed type label; "ask" = maintainer decides.

| Issue | Detail |
|---|---|
| KTR5-4779 | none; proposed Add (idea) |
| KTR5-4778 | none; proposed Add (idea) |
| KTR5-4174 | none; proposed Add (feature idea) |
| KTR5-4255 | none; proposed Add (tool idea) |
| KTR5-4256 | none; proposed Add (tool idea) |
| KTR5-4448 | none; proposed Fix (inaccurate move) |
| KTR5-4478 | none; proposed Change (performance) |
| KTR5-4493 | none; ask (tooling experiment) |
| KTR5-4517 | none; proposed Delete (dead code) |
| KTR5-4518 | none; proposed Delete (dead code) |
| KTR5-4519 | none; proposed Delete (dead code) |
| KTR5-4520 | none; proposed Delete (dead code) |
| KTR5-4521 | none; proposed Delete (dead code) |
| KTR5-4525 | none; proposed Change (services out of commands) |
| KTR5-4136 | none; ask |
| KTR5-4177 | none; proposed Add (feature idea) |

### feature (82)

Fix: add the "5 - Feature" / "5 - Module" labels; needs a feature pass (subagent proposes from title and code).

| Issue | Detail |
|---|---|
| KTR5-2967 | no 5 - Feature and no 5 - Module |
| KTR5-4773 | no 5 - Feature and no 5 - Module |
| KTR5-4761 | no 5 - Feature and no 5 - Module |
| KTR5-4751 | no 5 - Feature and no 5 - Module |
| KTR5-4758 | no 5 - Feature and no 5 - Module |
| KTR5-4788 | no 5 - Module |
| KTR5-4787 | no 5 - Module |
| KTR5-4777 | no 5 - Feature and no 5 - Module |
| KTR5-4769 | no 5 - Feature and no 5 - Module |
| KTR5-4767 | no 5 - Feature and no 5 - Module |
| KTR5-4776 | no 5 - Feature and no 5 - Module |
| KTR5-4750 | no 5 - Feature and no 5 - Module |
| KTR5-4774 | no 5 - Feature and no 5 - Module |
| KTR5-4772 | no 5 - Feature and no 5 - Module |
| KTR5-4779 | no 5 - Feature and no 5 - Module |
| KTR5-4778 | no 5 - Feature and no 5 - Module |
| KTR5-4770 | no 5 - Feature and no 5 - Module |
| KTR5-4768 | no 5 - Feature and no 5 - Module |
| KTR5-4757 | no 5 - Feature and no 5 - Module |
| KTR5-4756 | no 5 - Feature and no 5 - Module |
| KTR5-4755 | no 5 - Feature and no 5 - Module |
| KTR5-4752 | no 5 - Feature and no 5 - Module |
| KTR5-4753 | no 5 - Feature and no 5 - Module |
| KTR5-4754 | no 5 - Feature and no 5 - Module |
| KTR5-4766 | no 5 - Feature and no 5 - Module |
| KTR5-4775 | no 5 - Feature and no 5 - Module |
| KTR5-4771 | no 5 - Feature and no 5 - Module |
| KTR5-4780 | no 5 - Feature and no 5 - Module |
| KTR5-3937 | no 5 - Feature and no 5 - Module |
| KTR5-2434 | no 5 - Feature and no 5 - Module |
| KTR5-4322 | no 5 - Feature and no 5 - Module |
| KTR5-4480 | no 5 - Feature and no 5 - Module |
| KTR5-4493 | no 5 - Feature and no 5 - Module |
| KTR5-4110 | no 5 - Feature and no 5 - Module |
| KTR5-4517 | no 5 - Feature and no 5 - Module |
| KTR5-4518 | no 5 - Feature and no 5 - Module |
| KTR5-4519 | no 5 - Feature and no 5 - Module |
| KTR5-4520 | no 5 - Feature and no 5 - Module |
| KTR5-4521 | no 5 - Feature and no 5 - Module |
| KTR5-4525 | no 5 - Feature and no 5 - Module |
| KTR5-4707 | no 5 - Feature and no 5 - Module |
| KTR5-4136 | no 5 - Feature and no 5 - Module |
| KTR5-4170 | no 5 - Feature and no 5 - Module |
| KTR5-4175 | no 5 - Feature and no 5 - Module |
| KTR5-3831 | no 5 - Feature and no 5 - Module |
| KTR5-4765 | no 5 - Feature and no 5 - Module |
| KTR5-4680 | no 5 - Feature and no 5 - Module |
| KTR5-4747 | no 5 - Feature and no 5 - Module |
| KTR5-4745 | no 5 - Feature and no 5 - Module |
| KTR5-4744 | no 5 - Feature and no 5 - Module |
| KTR5-4743 | no 5 - Feature and no 5 - Module |
| KTR5-4740 | no 5 - Feature and no 5 - Module |
| KTR5-4728 | no 5 - Feature and no 5 - Module |
| KTR5-4708 | no 5 - Feature and no 5 - Module |
| KTR5-4696 | no 5 - Feature and no 5 - Module |
| KTR5-4705 | no 5 - Feature and no 5 - Module |
| KTR5-4703 | no 5 - Feature and no 5 - Module |
| KTR5-4693 | no 5 - Feature and no 5 - Module |
| KTR5-4627 | no 5 - Feature and no 5 - Module |
| KTR5-4634 | no 5 - Feature and no 5 - Module |
| KTR5-4632 | no 5 - Feature and no 5 - Module |
| KTR5-4633 | no 5 - Feature and no 5 - Module |
| KTR5-4689 | no 5 - Feature and no 5 - Module |
| KTR5-4712 | no 5 - Feature and no 5 - Module |
| KTR5-4711 | no 5 - Feature and no 5 - Module |
| KTR5-4710 | no 5 - Feature and no 5 - Module |
| KTR5-4709 | no 5 - Feature and no 5 - Module |
| KTR5-4581 | no 5 - Feature and no 5 - Module |
| KTR5-4582 | no 5 - Feature and no 5 - Module |
| KTR5-4597 | no 5 - Feature and no 5 - Module |
| KTR5-4602 | no 5 - Feature and no 5 - Module |
| KTR5-4608 | no 5 - Feature and no 5 - Module |
| KTR5-4609 | no 5 - Feature and no 5 - Module |
| KTR5-4610 | no 5 - Feature and no 5 - Module |
| KTR5-4623 | no 5 - Feature and no 5 - Module |
| KTR5-4630 | no 5 - Feature and no 5 - Module |
| KTR5-4681 | no 5 - Feature and no 5 - Module |
| KTR5-4685 | no 5 - Feature and no 5 - Module |
| KTR5-4694 | no 5 - Feature and no 5 - Module |
| KTR5-4601 | no 5 - Feature and no 5 - Module |
| KTR5-4621 | no 5 - Feature and no 5 - Module |
| KTR5-4596 | no 5 - Feature and no 5 - Module |

### retired (3)

Fix: remove the retired label.

| Issue | Detail |
|---|---|
| KTR5-4253 | Kelly.Revit (0 - Repository): remove |
| KTR5-4110 | Application (Issue - 0 - Role): remove |
| KTR5-4175 | General (Issue - 0 - Role): remove |

### no-estimate (2)

Fix: hand to `linear-issue-estimate-update`.

| Issue | Detail |
|---|---|
| KTR5-4758 | estimate none |
| KTR5-4765 | estimate none |

## KTRL5

### assignee (46)

Fix: set to the maintainer (`assignee: "me"`).

| Issue | Detail |
|---|---|
| KTRL5-41 | unassigned |
| KTRL5-30 | unassigned |
| KTRL5-40 | unassigned |
| KTRL5-63 | unassigned |
| KTRL5-4 | unassigned |
| KTRL5-68 | unassigned |
| KTRL5-61 | unassigned |
| KTRL5-62 | unassigned |
| KTRL5-37 | unassigned |
| KTRL5-32 | unassigned |
| KTRL5-34 | unassigned |
| KTRL5-36 | unassigned |
| KTRL5-38 | unassigned |
| KTRL5-39 | unassigned |
| KTRL5-42 | unassigned |
| KTRL5-79 | unassigned |
| KTRL5-45 | unassigned |
| KTRL5-46 | unassigned |
| KTRL5-2 | unassigned |
| KTRL5-77 | unassigned |
| KTRL5-76 | unassigned |
| KTRL5-75 | unassigned |
| KTRL5-74 | unassigned |
| KTRL5-73 | unassigned |
| KTRL5-72 | unassigned |
| KTRL5-70 | unassigned |
| KTRL5-71 | unassigned |
| KTRL5-24 | unassigned |
| KTRL5-5 | unassigned |
| KTRL5-78 | unassigned |
| KTRL5-69 | unassigned |
| KTRL5-67 | unassigned |
| KTRL5-66 | unassigned |
| KTRL5-65 | unassigned |
| KTRL5-64 | unassigned |
| KTRL5-29 | unassigned |
| KTRL5-28 | unassigned |
| KTRL5-3 | unassigned |
| KTRL5-35 | unassigned |
| KTRL5-33 | unassigned |
| KTRL5-31 | unassigned |
| KTRL5-27 | unassigned |
| KTRL5-26 | unassigned |
| KTRL5-25 | unassigned |
| KTRL5-6 | unassigned |
| KTRL5-7 | unassigned |

### no-priority (74)

Fix: set the proposed priority (first word).

| Issue | Detail |
|---|---|
| KTRL5-116 | Low - internal refactor |
| KTRL5-119 | Low - internal refactor |
| KTRL5-118 | Low - internal refactor |
| KTRL5-124 | High - updater mishandles end connectors |
| KTRL5-121 | Low - XML docs wrong |
| KTRL5-117 | Low - internal refactor |
| KTRL5-41 | Low - internal error-handling refactor |
| KTRL5-123 | Low - internal refactor |
| KTRL5-122 | Low - delete dead code |
| KTRL5-80 | Low - internal refactor |
| KTRL5-120 | Low - internal refactor |
| KTRL5-30 | Low - internal refactor |
| KTRL5-40 | Low - internal helper |
| KTRL5-81 | Low - internal refactor |
| KTRL5-83 | Low - internal refactor |
| KTRL5-82 | Low - internal refactor |
| KTRL5-52 | Low - internal refactor |
| KTRL5-89 | Low - internal split |
| KTRL5-114 | Low - internal refactor |
| KTRL5-105 | Low - internal design choice |
| KTRL5-106 | Low - internal cleanup |
| KTRL5-113 | Low - internal refactor |
| KTRL5-112 | Low - internal refactor |
| KTRL5-111 | Low - internal refactor |
| KTRL5-110 | Low - internal refactor |
| KTRL5-68 | Low - test coverage |
| KTRL5-109 | Low - internal refactor |
| KTRL5-108 | Low - internal refactor |
| KTRL5-107 | Low - internal refactor |
| KTRL5-104 | Low - internal refactor |
| KTRL5-47 | Low - internal refactor |
| KTRL5-90 | Low - internal refactor |
| KTRL5-100 | Low - test helper |
| KTRL5-99 | Low - test fails on Serilog clash |
| KTRL5-97 | Low - internal naming |
| KTRL5-93 | Low - internal refactor |
| KTRL5-98 | Medium - Fix with a workaround |
| KTRL5-32 | Low - internal comparer |
| KTRL5-34 | Low - internal refactor |
| KTRL5-36 | Low - internal comparer |
| KTRL5-38 | Low - internal refactor |
| KTRL5-39 | Low - validation idea, no requester |
| KTRL5-42 | Low - internal error handling |
| KTRL5-79 | Low - verification task |
| KTRL5-2 | Low - internal move |
| KTRL5-77 | Low - test run |
| KTRL5-76 | Low - test run |
| KTRL5-75 | Low - test run |
| KTRL5-74 | Low - test run |
| KTRL5-73 | Low - test run |
| KTRL5-72 | Low - test run |
| KTRL5-70 | Low - test run |
| KTRL5-71 | Low - test run |
| KTRL5-88 | Low - cleanup |
| KTRL5-24 | Low - cleanup notes |
| KTRL5-87 | Urgent - overwrites the user's signature edits (wrong data written) |
| KTRL5-86 | Medium - Fix with a workaround |
| KTRL5-85 | High - prompt inside Execute blocks the updater |
| KTRL5-84 | Low - merge idea |
| KTRL5-5 | Low - TODO cleanup |
| KTRL5-78 | Low - doc wording |
| KTRL5-69 | Low - test coverage |
| KTRL5-67 | Low - test coverage |
| KTRL5-66 | Low - test coverage |
| KTRL5-29 | Low - cleanup notes |
| KTRL5-28 | Low - naming and placement |
| KTRL5-3 | Low - internal refactor |
| KTRL5-35 | Medium - partial commits, decision needed |
| KTRL5-33 | Low - internal refactor |
| KTRL5-31 | Low - internal refactor |
| KTRL5-27 | Low - cleanup notes |
| KTRL5-26 | Low - internal typing |
| KTRL5-25 | Low - Add, no requester |
| KTRL5-7 | Low - test |

### type (1)

Fix: add the proposed type label; "ask" = maintainer decides.

| Issue | Detail |
|---|---|
| KTRL5-79 | none; proposed Verify (verification task) |

### no-estimate (1)

Fix: hand to `linear-issue-estimate-update`.

| Issue | Detail |
|---|---|
| KTRL5-4 | completed today, no estimate |

## KTRUI

### assignee (4)

Fix: set to the maintainer (`assignee: "me"`).

| Issue | Detail |
|---|---|
| KTRUI-2 | unassigned |
| KTRUI-10 | unassigned |
| KTRUI-1 | unassigned |
| KTRUI-3 | unassigned |

### no-priority (6)

Fix: set the proposed priority (first word).

| Issue | Detail |
|---|---|
| KTRUI-26 | Low - internal refactor |
| KTRUI-25 | Low - internal refactor |
| KTRUI-2 | Low - cleanup notes |
| KTRUI-10 | Low - tests |
| KTRUI-1 | Low - review idea |
| KTRUI-3 | Low - build warning cleanup |

## KTR4

### assignee (50)

Fix: set to the maintainer (`assignee: "me"`).

| Issue | Detail |
|---|---|
| KTR4-68 | unassigned |
| KTR4-67 | unassigned |
| KTR4-50 | unassigned |
| KTR4-31 | unassigned |
| KTR4-2 | unassigned |
| KTR4-62 | unassigned |
| KTR4-59 | unassigned |
| KTR4-58 | unassigned |
| KTR4-56 | unassigned |
| KTR4-55 | unassigned |
| KTR4-54 | unassigned |
| KTR4-53 | unassigned |
| KTR4-52 | unassigned |
| KTR4-61 | unassigned |
| KTR4-60 | unassigned |
| KTR4-28 | unassigned |
| KTR4-49 | unassigned |
| KTR4-48 | unassigned |
| KTR4-45 | unassigned |
| KTR4-44 | unassigned |
| KTR4-43 | unassigned |
| KTR4-42 | unassigned |
| KTR4-41 | unassigned |
| KTR4-39 | unassigned |
| KTR4-38 | unassigned |
| KTR4-37 | unassigned |
| KTR4-36 | unassigned |
| KTR4-35 | unassigned |
| KTR4-32 | unassigned |
| KTR4-30 | unassigned |
| KTR4-29 | unassigned |
| KTR4-26 | unassigned |
| KTR4-24 | unassigned |
| KTR4-27 | unassigned |
| KTR4-51 | unassigned |
| KTR4-47 | unassigned |
| KTR4-33 | unassigned |
| KTR4-46 | unassigned |
| KTR4-34 | unassigned |
| KTR4-25 | unassigned |
| KTR4-18 | unassigned |
| KTR4-73 | unassigned |
| KTR4-72 | unassigned |
| KTR4-71 | unassigned |
| KTR4-70 | unassigned |
| KTR4-69 | unassigned |
| KTR4-66 | unassigned |
| KTR4-3 | unassigned |
| KTR4-40 | unassigned |
| KTR4-57 | unassigned |

### no-priority (16)

Fix: set the proposed priority (first word).

| Issue | Detail |
|---|---|
| KTR4-68 | Low - internal refactor notes |
| KTR4-67 | Low - internal shared code refactor |
| KTR4-2 | Low - idea: other brand colors, backlogged |
| KTR4-28 | High - button blocks a user |
| KTR4-26 | Low - internal colour cleanup |
| KTR4-24 | Low - internal refactor, named brand colors |
| KTR4-27 | High - align buttons override a typed elevation (wrong result; proposed Urgent) |
| KTR4-25 | Low - internal colour cleanup |
| KTR4-18 | Low - TODO cleanup |
| KTR4-73 | Low - internal refactor |
| KTR4-72 | Low - internal refactor notes |
| KTR4-71 | Low - internal model refactor |
| KTR4-70 | Low - internal service refactor |
| KTR4-69 | Low - internal refactor notes |
| KTR4-66 | Low - internal refactor, base class |
| KTR4-3 | Low - internal layer refactor |

## KTRL4

### assignee (2)

Fix: set to the maintainer (`assignee: "me"`).

| Issue | Detail |
|---|---|
| KTRL4-2 | unassigned |
| KTRL4-1 | unassigned |

### no-priority (2)

Fix: set the proposed priority (first word).

| Issue | Detail |
|---|---|
| KTRL4-2 | Low - internal refactor helpers |
| KTRL4-1 | Low - TODO cleanup |

## KD

### assignee (24)

Fix: set to the maintainer (`assignee: "me"`).

| Issue | Detail |
|---|---|
| KD-6 | unassigned |
| KD-27 | unassigned |
| KD-26 | unassigned |
| KD-25 | unassigned |
| KD-24 | unassigned |
| KD-5 | unassigned |
| KD-45 | unassigned |
| KD-37 | unassigned |
| KD-46 | unassigned |
| KD-49 | unassigned |
| KD-38 | unassigned |
| KD-1 | unassigned |
| KD-2 | unassigned |
| KD-3 | unassigned |
| KD-4 | unassigned |
| KD-7 | unassigned |
| KD-8 | unassigned |
| KD-9 | unassigned |
| KD-21 | unassigned |
| KD-22 | unassigned |
| KD-23 | unassigned |
| KD-30 | unassigned |
| KD-33 | unassigned |
| KD-35 | unassigned |

### no-priority (26)

Fix: set the proposed priority (first word).

| Issue | Detail |
|---|---|
| KD-6 | Low - internal name checks |
| KD-50 | Low - test-only fix |
| KD-51 | Low - design refactor |
| KD-52 | Low - design refactor |
| KD-53 | Low - internal refactor |
| KD-58 | Low - dialog summary text |
| KD-57 | High - signature text differs by framework |
| KD-27 | High - wrong spool name matches |
| KD-26 | Low - integer overflow edge case |
| KD-25 | Low - integer overflow edge case |
| KD-24 | High - proposes an invalid number 0 |
| KD-5 | Low - item number inconsistency |
| KD-37 | Low - internal refactor |
| KD-49 | Low - naming |
| KD-1 | High - wrong count in dialog |
| KD-2 | Low - cosmetic dialog text |
| KD-3 | High - export and save guards differ |
| KD-4 | Medium - default differs, setting is a workaround |
| KD-7 | Low - rule design |
| KD-8 | Low - leak on error |
| KD-9 | High - report values not quoted |
| KD-22 | High - silent Empty decode |
| KD-23 | Medium - throws NRE on a default value |
| KD-30 | Low - TODO cleanup |
| KD-33 | Low - test pins |
| KD-35 | Low - test metadata |

### app-named (6)

Fix: check by hand: a hit may only be a linked KTR issue key, which the rule allows.

| Issue | Detail |
|---|---|
| KD-58 | "KTR" hit (may be an issue key only) |
| KD-57 | "Kelly Tools For Revit" and "KTR" hits |
| KD-21 | "KTR" hit (may be an issue key only) |
| KD-47 | "Kelly Tools For Revit" hit in body |
| KD-32 | "KTR" hit (may be an issue key only) |
| KD-55 | "KTR" hit (may be an issue key only) |

## KW3

### assignee (10)

Fix: set to the maintainer (`assignee: "me"`).

| Issue | Detail |
|---|---|
| KW3-1 | unassigned |
| KW3-2 | unassigned |
| KW3-4 | unassigned |
| KW3-7 | unassigned |
| KW3-10 | unassigned |
| KW3-11 | unassigned |
| KW3-15 | unassigned |
| KW3-13 | unassigned |
| KW3-5 | unassigned |
| KW3-8 | unassigned |

### no-priority (17)

Fix: set the proposed priority (first word).

| Issue | Detail |
|---|---|
| KW3-24 | Low - internal refactor |
| KW3-21 | Low - test seam |
| KW3-22 | Low - test seam |
| KW3-23 | High - throws off the JHK network, blocks users |
| KW3-20 | Low - internal rename |
| KW3-19 | Low - logging warning |
| KW3-27 | High - logger gives wrong results |
| KW3-1 | Low - internal repin |
| KW3-2 | High - wrong column numbers returned |
| KW3-4 | Low - internal improvement |
| KW3-7 | Low - internal refactor |
| KW3-10 | Low - internal refactor |
| KW3-11 | Low - internal parse decision |
| KW3-15 | Low - test seams |
| KW3-13 | Low - test flakiness |
| KW3-5 | High - returns an arbitrary service instance |
| KW3-8 | Low - TODO cleanup |

### app-named (2)

Fix: check by hand: a hit may only be a linked KTR issue key, which the rule allows.

| Issue | Detail |
|---|---|
| KW3-25 | "Kelly Tools For Revit" hit in body |
| KW3-3 | "Kelly Tools For Revit" hit in body |

## KW2

### assignee (1)

Fix: set to the maintainer (`assignee: "me"`).

| Issue | Detail |
|---|---|
| KW2-1 | unassigned |

### no-priority (1)

Fix: set the proposed priority (first word).

| Issue | Detail |
|---|---|
| KW2-1 | Low - TODO cleanup |

## KWD3

### assignee (3)

Fix: set to the maintainer (`assignee: "me"`).

| Issue | Detail |
|---|---|
| KWD3-7 | unassigned |
| KWD3-2 | unassigned |
| KWD3-10 | unassigned |

### no-priority (4)

Fix: set the proposed priority (first word).

| Issue | Detail |
|---|---|
| KWD3-12 | Low - internal refactor |
| KWD3-7 | Low - internal cleanup |
| KWD3-2 | Low - internal rename |
| KWD3-10 | Low - test build config |

### too-big (1)

Fix: hand to `linear-issue-split-review`.

| Issue | Detail |
|---|---|
| KWD3-2 | 16 points, open, no sub-issues |

## KWDC

### no-priority (1)

Fix: set the proposed priority (first word).

| Issue | Detail |
|---|---|
| KWDC-1 | Low - test tooling |

## KWDJ

### no-priority (3)

Fix: set the proposed priority (first word).

| Issue | Detail |
|---|---|
| KWDJ-3 | Low - test tooling |
| KWDJ-2 | Low - test metadata |
| KWDJ-1 | Low - serializer property order |

## KWDSS

### no-priority (3)

Fix: set the proposed priority (first word).

| Issue | Detail |
|---|---|
| KWDSS-6 | High - schema build broken |
| KWDSS-3 | Low - schema column cleanup |
| KWDSS-1 | Low - schema procedure cleanup |

### retired (1)

Fix: remove the retired label.

| Issue | Detail |
|---|---|
| KWDSS-6 | VCS-Database-General (0 - Repository): remove |

### app-named (2)

Fix: check by hand: a hit may only be a linked KTR issue key, which the rule allows.

| Issue | Detail |
|---|---|
| KWDSS-4 | "Kelly Tools For Revit" hit in body |
| KWDSS-5 | "Kelly Tools For Revit" hit in body |

## KRDE

### app-named (1)

Fix: check by hand: a hit may only be a linked KTR issue key, which the rule allows.

| Issue | Detail |
|---|---|
| KRDE-7 | "Kelly Tools For Revit" hit in body |


## Applied 2026-11-09

The maintainer approved the four mechanical fixes. 377 issues were updated, one `save_issue` each, by four subagents working sequentially and checking each response. The eight they reported as failing were redone by hand. Several had in fact already applied, and one failed on a mistyped label id.

- **Assignee:** 232 set to the maintainer. A workspace sweep afterwards (`assignee: null`) finds no open issue unassigned; the unassigned issues left are all closed and older than the assignee rule.
- **Priority:** 289 set as proposed: Urgent 5, High 26, Medium 10, Low 248 (KTR4-27 and KTR5-4631 as High, not Urgent). A sweep for No priority in Backlog, Todo, In Progress and Triage finds none.
- **Type:** 15 added as proposed. KTR5-4493 and KTR5-4136 still have no type, waiting on the maintainer.
- **Retired labels:** removed from KTR5-4253, KTR5-4110, KTR5-4175 and KWDSS-6.
- **Stray write:** a subagent also set priority Low on KTR5-4060 (a Duplicate, closed 2026-11-04), which was not in the list. Its earlier priority can't be read back through the connector; check it in Linear's history and restore it if it wasn't Low.

Not applied, as planned: the feature labels of 82 KTR5 issues (needs a feature pass), the 11 app-named hits (check by hand), the no-estimate and too-big issues (estimate and split skills).

## Feature pass proposal (82 KTR5 issues)

Two Sonnet subagents read each issue and checked named types in Kelly-Revit-v5. Existing labels are kept; these are additions. Nothing is applied yet.

- **40** get existing feature labels (and modules).
- **38** concern the whole add-in or many tools (architecture, tests, build and install, colours, settings, dead code): no feature label fits. Decision needed (below).
- **4** need your call: KTR5-4780 (no `SpoolAutoSet` command found), KTR5-4608/4609/4610 (install-type issues named Detailer, Manager, Contenter).
- **3 new feature labels** proposed for Trade.Developer commands that have none: Coordinate Testing (`CoordinateTestingCommand`), Collector Testing (`CollectorTestingCommand`), Select Field Trim End (`SelectFieldTrimEndCommand`), used by KTR5-4777 and KTR5-4765.

| Issue | Features | Modules | Confidence | Reason |
|---|---|---|---|---|
| KTR5-2967 | none | Host | low | Validation across tools; test/architecture; could span modules |
| KTR5-4773 | All Assigner Reset,Service Assigner Tool Reset,System Assigner Tool Reset,Detailing Package Assigner Tool Reset | Trade.All | medium | Assigner resets/panel in Trade.All/Commands/Assigners |
| KTR5-4761 | none | Host,Trade.All | medium | Command base/UserPrompt switch; Rotate view is Trade.All Vicious |
| KTR5-4751 | Document Operation (Command Service) | Host,Trade.All | low | Prompt use across 39 files; command infra, no single tool |
| KTR5-4758 | none | Host | low | Static category sets; shared infrastructure |
| KTR5-4788 | none | Host | high | Existing Auto Updaters label stays; only module missing |
| KTR5-4787 | none | Host | high | Existing Application Service label stays; only module missing |
| KTR5-4777 | NEW: Coordinate Testing,NEW: Collector Testing,NEW: Select Field Trim End | Trade.Developer | medium | CoordinateTestingCommand/CollectorTestingCommand/SelectFieldTrimEnd in Trade.Developer |
| KTR5-4769 | none | Host | high | MissingSharedParametersDialog in src/EventHandlers |
| KTR5-4767 | Duct Run Item Number Set | Trade.Duct | high | DuctItemNumberSetCommand in Trade.Duct |
| KTR5-4776 | Fabrication Part Various Report,Custom Data Property Update V1 | Trade.Contenter | medium | FabricationCustomDataUpdaterCommandV1 and FabricationPartVariousReport |
| KTR5-4750 | Custom Data Property Update V1,Custom Data Property Update V2 | Trade.Contenter | high | FabricationCustomDataUpdater V1 and V2 commands |
| KTR5-4774 | Layout Point Export | Trade.All | high | LayoutPointToCommaSeparatedValueFileExportCommand |
| KTR5-4772 | Service Line Color View Filter,System Line Color View Filter | Trade.All | high | Service and System line color filters |
| KTR5-4779 | none | Host | medium | Planning task about prompt for new commands; add-in-wide |
| KTR5-4778 | none | Host | medium | Planning; code direction for whole add-in |
| KTR5-4770 | Document Opened (Event Handler),Document Saved (Event Handler) | Host | medium | Host event handlers in src/EventHandlers |
| KTR5-4768 | Line Number Assigner Value Set | Trade.All | high | Value Set for Line Number in Assigners |
| KTR5-4757 | Stratus Detailing Package Views Create | Trade.All | high | StratusDetailingPackageViewsCommand in Trade.All |
| KTR5-4756 | Layout Point Export | Trade.All | high | Layout Point Export command |
| KTR5-4755 | Layout Point Export | Trade.All | high | Layout Point Export command |
| KTR5-4752 | Module Manager | Trade.All | high | ModuleManagePushButton in Trade.All/Commands/Spools |
| KTR5-4753 | Module Manager | Trade.All | high | ModuleManagePushButton in Trade.All/Commands/Spools |
| KTR5-4754 | Module Manager | Trade.All | high | ModuleManagePushButton in Trade.All/Commands/Spools |
| KTR5-4766 | Vicious Instance Rotate Move | Trade.All | high | ViciousInstanceRotateMoveView in Trade.All |
| KTR5-4775 | Many Connect,Stratus Detailing Package Views Create,Spool Creator V2 | Trade.All | medium | Named tools exist in Trade.All; "spool tools" is vague |
| KTR5-4771 | Vicious Instance Rotate Move,Vicious File Based System Pipe Place | Trade.All | high | Rotate and Point To Pipe (FileBasedSystemPipePlace) in Trade.All |
| KTR5-4780 | ask | Trade.All | low | No SpoolAutoSet class found; may be ModuleValueAutoSet |
| KTR5-3937 | none | Host | low | BIM Lite product question; no tool found |
| KTR5-2434 | none | Host | medium | Shared parameter deprecation (content/data); no tool |
| KTR5-4322 | none | Host,Trade.All | low | XAML click handling across all views |
| KTR5-4480 | Document Operation (Command Service) | Host | high | OperationService change loops |
| KTR5-4493 | none | Host | high | Claude Code tooling, repo-wide |
| KTR5-4110 | none | Host | medium | Kelly-Windows dependency removal; no module |
| KTR5-4517 | none | Host | medium | Dead code across all repos; build/cleanup |
| KTR5-4518 | none | Host | medium | Dead code in Kelly.Revit; whole add-in (all modules) |
| KTR5-4519 | none | Host | high | Dead code in Kelly.Revit.Logic; lower layer |
| KTR5-4520 | none | Host | high | Dead code in Kelly.Windows; lower layer |
| KTR5-4521 | none | Host | high | Dead code in Kelly.Windows.Data; lower layer |
| KTR5-4525 | Auto Updaters,Manual Updater | Host | medium | Updater element services vs command use; Logic layer |
| KTR5-4707 | Document Operation (Command Service) | Host,Trade.All,Trade.Pipe,Trade.Duct,Trade.Contenter,Trade.Manager | low | Per-element catch across remaining module commands |
| KTR5-4136 | Document Operation (Command Service) | Host | high | OperationService log emailing |
| KTR5-4170 | Fabrication Part Dimension Log,Suspended Support Manager | Trade.All | medium | Both managers use the geometry signature |
| KTR5-4175 | none | Host | high | Code style across all v5 repos; no single tool |
| KTR5-3831 | none | Host | medium | Shared EventToCommand behaviour for XAML views |
| KTR5-4765 | Custom Data Property Update V2,Component/Product Code Quality Assurance,NEW: Select Field Trim End | Trade.Contenter,Trade.Developer | medium | Three footer dialogs; Developer command has no label |
| KTR5-4680 | none | Host | high | Repo-wide TODO comments sweep |
| KTR5-4747 | View Schedule To Single Excel File Export,View Schedule To Multiple Excel File Export | Trade.All | medium | ExcelInteropTools used by the schedule exports |
| KTR5-4745 | Module Manager | Trade.All | medium | ModuleManageView |
| KTR5-4744 | Service Assigner Value Adopt,Spool Number Assigner Value Adopt | Trade.All | medium | AssignerValueAdoptCommand; only these two adopt labels active |
| KTR5-4743 | Document Opened (Event Handler) | Host | high | Host DocumentOpenedEventHandler dialog text |
| KTR5-4740 | none | Host,Trade.All | medium | Commands and Grids moves across many commands |
| KTR5-4728 | Layout Point Export,View Schedule To Single Excel File Export | Trade.All | low | Layer-move source half over several tools |
| KTR5-4708 | Spool Creator V2,Spool Manager,Spool Cleaner,Suspended Support Manager,Module Create,Layout Point Import,Layout Point Export,Context Value Create | Trade.All | medium | Trade.All view models named |
| KTR5-4696 | Vicious Instance Rotate Move,Duct Run Item Number Set | Trade.All,Trade.Duct | low | 12 Run sites, also assigner filters and ElementDelete |
| KTR5-4705 | none | Trade.All | medium | Tests for 19 assigner types |
| KTR5-4703 | Document Opened (Event Handler),Project Session (Service) | Host | medium | Host tests for event handlers and session service |
| KTR5-4693 | none | Host | high | Whole add-in must work offline; release requirement |
| KTR5-4627 | none | Host | medium | Brand colours across UI and modules |
| KTR5-4634 | Olet Checker | Trade.Pipe | medium | Status colours in OletCheckViewModel |
| KTR5-4632 | none | Host | high | Brand colour resources in Windows and UI layers |
| KTR5-4633 | Dockable Assigner,Layout Point Export,Spool Creator V2,Window Mockup | Trade.All,Trade.Developer | medium | Off-palette colours in four named views |
| KTR5-4689 | none | Host | high | Test plan across all modules |
| KTR5-4712 | none | Host | medium | ApplicationLogger and EventService tests |
| KTR5-4711 | Custom Data Property Update V1,Custom Data Property Update V2,Weld Location Set,Olet Checker,Window Mockup | Trade.Contenter,Trade.Developer,Trade.Duct,Trade.Pipe | medium | Tests for 15 types over four modules |
| KTR5-4710 | none | Trade.All | medium | Tests for 17 stacked buttons and enablers |
| KTR5-4709 | Application About,Vicious Instance Rotate Move,Vicious Instance Disconnect,Auto Updaters | Trade.All | low | Mixed Trade.All command tests |
| KTR5-4581 | Document Operation (Command Service) | Host | medium | OperationService log recovery tool |
| KTR5-4582 | Application Service | Host | medium | Refactor the application services |
| KTR5-4597 | none | Host | high | File I/O moved to Kelly.Windows.Data |
| KTR5-4602 | none | Host | high | Settings file via Kelly.Windows.Data.Json |
| KTR5-4608 | ask | Host | low | Title "Detailer" under install types; no Detailer module |
| KTR5-4609 | ask | Trade.Manager | low | Title "Manager" under install types |
| KTR5-4610 | ask | Trade.Contenter | low | Title "Contenter" under install types |
| KTR5-4623 | none | Host | high | Icons for the whole ribbon |
| KTR5-4630 | none | Host | high | All push button names across modules |
| KTR5-4681 | Layout Point Import,Layout Point Export | Trade.All | high | Duplicate combo code in two layout point view models |
| KTR5-4685 | none | Host | high | App.config, addin manifest and App.cs debris |
| KTR5-4694 | none | Host | high | Tests.Revit icon contract and ribbon check |
| KTR5-4601 | none | Host | high | InstallShield install types |
| KTR5-4621 | none | Host | high | Revit light and dark theme, add-in wide |
| KTR5-4596 | none | Host | high | Hierarchical settings file |

### Feature pass applied 2026-11-09

Maintainer decisions: add-in-wide work gets a new "5 - Feature" label **Add-In Wide** (rule added to `.claude/LINEAR-KTR.md`, root 4b04236); the three Trade.Developer labels are created; the four unmatched issues are treated as add-in wide (KTR5-4780 with Trade.All).

- Labels created in KTR5: Add-In Wide, Coordinate Testing, Collector Testing, Select Field Trim End (each with a description; the three commands confirmed in `modules/Trade.Developer`).
- All 82 issues updated with `addLabels` only, one call at a time; no failures reported. 40 carry Add-In Wide (the list matches the plan); KTR5-4788 and KTR5-4787 got only their module. Spot checks of KTR5-4707, KTR5-4765 and KTR5-4788 show the labels as planned.

### App-named hits checked 2026-11-09

Of the 11 search hits, 9 are fine: they only mention KTR issue keys, links or code names (KWDSS-4, KWDSS-5, KW3-25, KW3-3, KD-58, KD-57, KD-47, KD-55, KRDE-7). Two name the application, in the same deferral note:

| Issue | State | Text now | Proposed |
|---|---|---|---|
| KD-21 | Backlog | deferred 2026-11-02: KTR is US-only (user decision); revisit only if that changes | deferred 2026-11-02: the add-in is US-only (user decision); revisit only if that changes |
| KD-32 | Done | deferred 2026-11-02: KTR is US-only (user decision); … | deferred 2026-11-02: the add-in is US-only (user decision); … |

Applied 2026-11-09 on the maintainer's approval: both now read "the add-in is US-only" (checked by re-reading the descriptions).
