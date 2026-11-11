# 2026-11-11 High Priority Review

Every open High issue assigned to the maintainer (64 in Backlog, 2 in Todo, 2 In Review: 68), checked against the priority rubric in BuildConfigs `LINEAR.md`:

- **Urgent:** the application fails to start or install, data is lost, or wrong data is written to models or files.
- **High:** a tool or call gives wrong results or blocks a user, or the issue is a release requirement.
- **Medium:** an Add or Change a person asked for, or a Fix with a workaround.
- **Low:** internal work (refactoring, cleanup, tests, docs), ideas and meetings.

Proposals only; nothing is changed until the maintainer approves. Read from the issue titles and labels, not from the code.

## Keep High (30)

Wrong results or a blocked user:
- **Layout points:** KTR5-4635 and KTR4-29 (hidden saved points dropped on save), KTR5-4636 and KTR4-30 (Specify Level always fails), KTR5-4652 (quality counts never fire), KD-3 (export and save length guards disagree), KD-22 (legacy names decode to Empty without a report).
- **Spools:** KTR5-4637 and KTR4-31 (a failed edit commits partial changes), KTR5-4663 (SPA and SPT don't parse), KTR5-4699, KTR5-4701, KTRL5-37 and KTR5-3144 (Spool Creator V1 assembly failure), KD-27 (next spool number matched on the name's start), KTR5-4780 (Spool Auto Set does nothing).
- **Supports and racking:** KTRL5-133 (elevation stored as inches), KTR5-3277 (Match shows true when nothing matches), KTR5-4631 and KTR4-27 (align buttons overwrite the typed elevation), KTR5-4448 (inaccurate move).
- **Other tools:** KTR5-4801 (hangers placed after closing the window), KTRL5-134 (filter visibility set on a filter never added), KTRUI-29 (adding an existing value makes the last item current), KTR4-28 (Item Numbers button stays disabled), KTR5-4496 (Family Version fails on nested families), KTR5-3142 (auto updaters sometimes stop), KD-57 (support signature text differs between frameworks, In Review).
- **Release requirement:** KTR5-4693 and KW3-23 (work off the JHK network).

**Rubric says Urgent:** KTRL5-133 (wrong data written to the model), KTR5-4635 and KTR4-29 (data lost), KTR5-4637 and KTR4-31 (wrong data written). Raising them would put them on the tighter Urgent SLA; the maintainer decides.

## High → Medium (29)

A person's request, a change, or a fix with a workaround or no repro yet:
- **Requested features (Add):** KTR5-3791, KTR5-3792, KTR5-3795, KTR5-3796, KTR5-3797 (Darrick Dunn), KTR5-3794 (Module Creator views), KTR5-3809 (Layout Point Export counts), KTR5-3800, KTR5-3932, KTR5-3933, KTR5-3934, KTR5-3935 (Spool Creator V2).
- **Requested changes:** KTR5-3747 (Adam Fuller), KTR5-3808 (Crystal Wyre), KTR5-2434 (Casey Puyleart), KTR5-2958 (Module Manager on duct projects), KTR5-2775 (check point families on open), KTR5-3703 (disable Close during the update), KTR5-4040 (limit the categories it moves), KTR5-4064 (refuse auto-assign on the default value), KTR5-4754 (block Update Item Numbers on errors), KTR5-3280 (rod geometry read and write).
- **Fixes with a workaround or no repro:** KD-9 (report doesn't quote values), KD-1 (selection label miscount), KD-24 (sequence 0 when too large), KW3-2 (spreadsheet column beyond Z), KTR5-3680 (trapeze too wide, needs investigation), KTR5-4042 (one duct shape, reproduce first), KWDSS-6 (schema project build fails; the exporter is unaffected).

## High → Low (9)

Internal work: KTR5-4017, KTR5-4018, KTR5-4019, KTR5-4020 (Element Select Zoom refactoring), KTR5-2967 (validation refactoring), KTR5-2461 (definition name suffix), KTRL5-91 (updater configuration review), KW3-5 (service provider duplicates, latent), KW3-27 (logger list detection, In Review).

## Effect on the Cycle

High issues in Backlog whose SLA breaches by 2026-11-18: 97 points today, 63 points if the proposals are applied (Medium and Low have no SLA). With the 94 points already committed, the cycle holds 157 of the 160 points to commit.
