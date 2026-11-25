# linear-issue-dependency-check: Kelly facts

- Skip the Hasa team and its sub-teams unless the user names them; then work from the text only and say so.
- Wording: say "Major Version 4" or "v4", never "Generation"; name Kelly Tools For Revit or KTR only in the KTR* teams' issues.
- Layers: teams, repositories and layers are in `linear-teams.md`. Order follows the layers: a lower layer blocks an upper one, never the reverse (Kelly-Windows-Data, Kelly-Windows, Kelly-Domain, Kelly-Revit-Logic, Kelly-Revit-UI, Kelly-Revit). Within one repository, the issue that adds a type blocks the one that uses it.
- v4 and v5 are separate products and never block each other; use Related.
- Candidate searches: named keys look like `KTR5-123`; search the issue's own team, the teams of the layers below (what it may need) and above (what may need it), and the other major version's team for the same layer. For the code, the repository of the issue and of the lower layers, on the `develop` branch (`git -C <repo> show develop:<path>`, `git -C <repo> log develop --oneline -i --grep=<name>`).
- Same code, same team, one a duplicate: propose, never add.
- Example report rows:

```
| Issue | Other issue | Relation | Status | Reason |
|---|---|---|---|---|
| KTR5-40 Pipe slope tool | KTRL5-12 `SlopeService` | Blocked By | Added | needs `SlopeService.Apply`, not yet in Kelly-Revit-Logic-v5 |
| KTR5-40 Pipe slope tool | KTR4-88 Pipe slope tool | Related | Added | same fix in v4 |
| KTR5-40 Pipe slope tool | KTR5-77 Slope tooltip | Related | Proposed | both touch `PipeSlopeCommand` |
```

- Follow-up offers: when a blocker is open and small, start it first; when an issue is Blocked By a lower-layer issue, the lower package must be packed and repinned before the issue can land; when many issues were vague about what they need, `linear-issue-info-review`.
