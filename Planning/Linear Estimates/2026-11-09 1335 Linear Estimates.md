# Linear estimates, 2026-11-09 13:35

Scope: the three issues the 2026-11-09 hygiene check flagged with no estimate. KTR5 and KTRL5 use the Exponential scale.

| Team | Issues | Newly estimated | Changed | Skipped (parents) | Points proposed |
|---|---|---|---|---|---|
| KTR5 | 2 | 1 | 0 | 1 | 8 |
| KTRL5 | 1 | 0 | 0 | 1 | 0 |

No existing estimate changes.

| Key | Title | Proposed | Confidence | Reason |
|---|---|---|---|---|
| [KTR5-4765](https://linear.app/jhkelly-ktr/issue/KTR5-4765) | Footer dialogs: switch to UserPrompt once PromptRequest has FooterText | 8 | high | Done; spanned layers: `PromptRequest.FooterText` in Kelly-Windows, its mapping in Kelly-Revit-UI's `RevitUserPrompt`, packed and repinned, then three dialogs repointed in Trade.Contenter and Trade.Developer |

Skipped, by the parent rule:

- [KTR5-4758](https://linear.app/jhkelly-ktr/issue/KTR5-4758): parent of the open sub-issues KTRL5-104 (4), KTRL5-105 (2) and KTRL5-106 (2), which Linear rolls up.
- [KTRL5-4](https://linear.app/jhkelly-ktr/issue/KTRL5-4): Done; a container of deprecation plans, parent of KTRL5-8 (8) and KTRL5-11. An own estimate would count the work twice.

The hygiene check flagged both parents because its subagents looked for sub-issues only inside the same team; KTRL5-104 to 106 sit in KTRL5 under a KTR5 parent.
