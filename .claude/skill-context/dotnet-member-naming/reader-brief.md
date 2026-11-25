# Member naming check: reader brief

You check whether every member name in your slice of a .NET code base says what the member actually does. **READ ONLY**: do not edit any file except your own findings file, do not run git commands that change anything, do not touch Linear, do not build. Use Bash (Git Bash), Read, Grep, Glob. Never PowerShell.

## Context

The code is Kelly Tools For Revit v5, a layered stack under `C:\repo\jhkweb` (Kelly-Windows-Data-v3 and its format libraries → Kelly-Windows-v3 → Kelly-Domain → Kelly-Revit-Logic-v5 → Kelly-Revit-UI → Kelly-Revit-v5, the add-in). Earlier passes and their renames are listed in the known list; look for what they missed, what their renames introduced, and names that are still wrong.

- **Do NOT use `C:\repo\jhkweb\UBIQUITOUS-LANGUAGE.md`** (or any glossary) to judge or suggest names. It is out of date. Take domain terms from the code itself: the term the code uses most for a concept, and the Revit API or data-file name where one exists. Two terms for one concept is a finding.
- Read `<work>\known.md` first: items already decided, deliberately kept or already filed. Do not report them again.
- Rules every repo follows: methods carry NO `Transaction`, `Tx`, `Operation` or `WithOperation` suffix; whether a method opens its own transaction is said in its XML docs; building blocks that need the caller's transaction end in `Core`. Don't suggest names that break this.

## Scope

- Every member in your slice: methods, properties, fields, events, constants, enum members, parameters; public, internal and private. Also XAML `x:Name`s, event handlers and binding paths in your slice's `.xaml` files, and type names when the type is clearly misnamed.
- Read every file of your slice in full. Skip `obj/`, `bin/` and tests.
- For public members you flag, count callers across `C:\repo\jhkweb\Kelly-*` (src and modules, not tests), excluding the `*-v2` and `*-v4` repos, roughly (grep the name).

## What counts as a mismatch

| Rule | Example |
|---|---|
| The verb states the effect | `GetX` that writes, prompts, opens a transaction or creates a folder; `CheckX` that changes state; `TryX` that throws; `CreateX` that only finds; `IsX` that shows a dialog |
| Specific, not vague | `Process`, `Handle`, `DoWork`, `Run`, `Data`, `Info`, `Helper`, `Manager`, `Temp`, numbered names |
| Covers all it does | name says one thing, body does two |
| Kept up with the behaviour | a name left from an older behaviour |
| Bools read as questions | `Is`/`Has`/`Can`/`Should` on bools only |
| Plural for collections, singular for one | |
| One term per concept | two words for one thing across the code, or one word for two things |
| Agrees with its XML docs | summary says something the name doesn't, or the reverse; units (feet vs inches, degrees vs radians) in the name when the type is a bare double |
| Async | `Task`-returning members end in `Async` |
| No noise | Hungarian prefixes, the type name repeated, unexplained abbreviations, typos, casing (`UnTangle`, `SpoolAble`) |

House style, not findings: noun-named pure methods (`Columns`, `Key`), and names that are serialized or shown (data-file columns, JSON keys, Revit parameter names, Undo texts, ribbon item names, icon keys) unless the shown text itself is wrong — mark those **Serialized/Shown** so a rename keeps the stored value.

Severity: **Misleading** (the name says something the code doesn't do), **Vague** (true but says too little), **Style** (conventions only).

Also report **Possible bugs** separately: a name that contradicts its body sometimes means the body is wrong. Check each against the code before listing it; say why you think it is a bug and not intended.

## Output

Write your findings to `<work>\naming-<group>.md` (your group id is in your prompt):

```
# <group>: <repos/folders>
Files read: N, lines: N
## Findings
| Severity | Member | File:line | Rule | What it actually does | Suggested | Callers | Serialized/Shown |
## Possible bugs
| Member | File:line | What is wrong | Evidence |
## Not reported (already known)
(one line per known item you saw, or "none")
```

Sort findings Misleading, then Vague, then Style; within a severity, most callers first. Suggested names must follow the rules above and not clash with an existing member of the same type or an extension on the same receiver (check).

Your final reply to the lead is ONLY: the file path, the counts per severity, the possible-bug count, and the five most important Misleading findings in one line each. No other text.
