# Member Naming Check: approach

Drafted 2026-11-10; work starts 2026-11-11. Linear: KTR5-4798.

**Question:** does every class member's name say what the member actually does?

## Scope

| Layer (v5) | Repo | Source files (`.cs`, tests excluded) |
|---|---|---|
| Windows Data | `Kelly-Windows-Data-v3` | 18 |
| Windows | `Kelly-Windows-v3` | 115 |
| Domain | `Kelly-Domain` | 256 |
| Revit Logic | `Kelly-Revit-Logic-v5` | 253 |
| Revit UI | `Kelly-Revit-UI` | 59 |
| Add-in (host and modules) | `Kelly-Revit-v5` | 448 |

About 1,150 files. Go **bottom-up**, one layer per pass, so a rename in a lower layer is decided before the layers above are read against it. Kelly-Windows-Data-v3 is small enough to be the pilot that tunes the rules.

Members checked: methods, properties, fields, events, and parameters. Type names are out of scope unless a member check shows the type itself is misnamed. Tests are out of scope (their names follow the test conventions). v4 is a separate pass, if wanted.

## What counts as a mismatch

| Rule | Example of a mismatch |
|---|---|
| The verb states the effect | `GetX` that writes or starts a transaction; `CheckX` that changes state; `TryX` that throws; `CreateX` that only finds |
| Specific, not vague | `Process`, `Handle`, `DoWork`, `Execute2`, `Helper`, `Data`, `Info`, `Temp`, `Manager` with no object |
| Covers all it does | `SetLineNumber` that also recolours the view; name says one thing, body does two (often also an SRP finding) |
| Kept up with the behaviour | the name of an older behaviour, left after a change (check `git log -L` when in doubt) |
| Bools read as questions | `Is`/`Has`/`Can`/`Should` only on bools; a bool without one (`Enabled` vs `IsEnabled`) is minor |
| Plural for collections | `Element` holding a list; `Elements` holding one |
| Domain language | terms from `UBIQUITOUS-LANGUAGE.md` (spool, detailing package, line number, …), not synonyms |
| Agrees with its XML docs | `<summary>` describes something the name doesn't, or the other way round |
| Async | `Task`-returning members end in `Async` |
| No noise | Hungarian prefixes, type names repeated (`elementList`), abbreviations not in the domain glossary |

Each finding gets a severity:

- **Misleading**: the name says something the code doesn't do (wrong verb, stale name). Fix these.
- **Vague**: the name is true but says too little. Fix when the member is public or widely called.
- **Style**: conventions only (bool prefix, plural, Async, noise). Batch these into one issue per layer, or skip.

## How the check runs (kept cheap)

1. **Inventory script** (in the scratchpad, not committed): list every member per layer with kind, name, signature, access, XML summary, line count, and the first statements of the body. One TSV per layer, so nothing large is read into context.
2. **Heuristic flags** from the script: vague-name list, `Get`/`Find`/`Is`/`Check` members whose body calls a write (`Set`, `Delete`, `Create`, `Transaction`, `Start`, `Commit`, `Add`, `Remove`, `=` to a field), bool rules, plural rules, Async rule, summary/name word overlap.
3. **Read pass**: Sonnet subagents, one per folder group, read the body of every flagged member plus a sample of unflagged ones (to catch what the heuristics miss) and return: member, file:line, rule, severity, a suggested name, and how many call sites it has.
4. **Report**: `Planning/Member Naming/<date> <layer>.md`, with the findings ranked by severity, then by number of callers.
5. **After approval**, file the renames in the owning layer's Linear team (KW*, KD, KTRL5, KTRUI, KTR5): one issue per type or feature for Misleading/Vague findings, one batched Style issue per layer. Lower-layer public renames block the layers above (Blocked By), because they reach the add-in only after pack and repin.

No renames happen in the check itself.

## Lessons from the pilot (2026-11-11)

The [Kelly-Windows-Data-v3 pilot](Member%20Naming/2026-11-11%20Kelly-Windows-Data-v3.md) read every member at every severity. It adds these rules for the other layers:

- **Noun-named pure methods are house style** (`Columns`, `Key`, `FileOf`). Flag a noun name only when the member has a side effect or builds something new.
- **Check interface members through their implementations** in the layers above (`ICache` means what `RecordCache` and `DataFileService` do with it).
- **Mark serialized members** (manifest.json keys, data file columns) in the inventory. Renaming one changes a file format, and its finding must say so.
- **Read undocumented members first.** The two undocumented files held the worst names.
- **Read a layer of under ~50 files directly**; use the script and subagents only for the large layers.
- **Kelly-Windows-v3 (115 files, 7,700 lines) needed no script either:** three Sonnet agents each read a third in full, and every Misleading finding was checked against the code before it went into the report. Keep the script for Domain, Logic and the add-in only if full reads stop fitting.
- **Naming checks find bugs.** A name that contradicts its body sometimes means the body is wrong. File those as Fix issues at once (Kelly-Windows-v3: KW3-29, KW3-30, KW3-31), separate from the renames.
- **Look for existing issues first.** Several findings were already filed (KWD3-7, KWD3-13, KW3-10, KW3-20, KW3-22).
- **Kelly-Domain (256 files, 13,300 lines):** five Sonnet agents, one shared brief file listing the rules, the glossary and the open KD issues (so known items weren't reported again). Ask agents for "Possible bugs" separately; about half of theirs were documented behaviour or already filed, so check each before filing.
- **Kelly-Revit-Logic-v5 (253 files, 30,000 lines):** nine Sonnet agents (about 3,300 lines each) on one brief. Of their ~25 possible bugs, 7 were filed after checking, 5 were documented on purpose, 3 were uncertain. Many names hide a dialog, a file write or a transaction behind `Get`/`Is`; a cross-cutting suffix rule for self-transacting methods is better decided once (L10) than member by member.
- **Keep serialized names apart.** In Domain many weak names are data-file columns, settings keys or Revit parameter names; they go in their own issue (D6) for a per-name decision with the exporter, not into the code-only renames.

## Decisions for the maintainer (2026-11-11)

1. Public members only, or private and internal ones too?
2. Report Style findings, or only Misleading and Vague?
3. ~~Start with the Kelly-Windows-Data-v3 pilot, or go straight to the layer you care about most?~~ Settled 2026-11-10: pilot first.
4. Check v4 as well, or v5 only?
5. Make it a reusable skill (like `kelly-solid-check`) after the pilot, if the method holds up?
