# Rename pass: shared brief

You apply already-decided member renames to ONE layer of a .NET stack under C:\repo\jhkweb, then repin the direct consumers and fix their calls. The maintainer authorized this work ("do anything you need to regarding renaming"). Use Bash (Git Bash) and the Read/Edit/Write tools; NEVER PowerShell in any form. Do NOT touch Linear (the lead agent handles issues). Do NOT push. Do NOT install the add-in.

## Read first

- `C:\repo\jhkweb\BuildConfigs\SHARED-AGENTS.md` (rules for these repos) and the layer repo's `AGENTS.md`. Key rules: work on `develop` only, commit (no push), no `Co-Authored-By` trailer; one type per file named after it; no non-XML comments (`//`); XML docs on what you touch; every test's `Author` is exactly `"Verified By Human On:"` and a test you change loses any date (`"Verified By Human On:yyyy.mm.dd"` → `"Verified By Human On:"`); each `Description` says what the test verifies; TDD (a failing test first) for any BEHAVIOUR change; public-surface changes update `README.md`, `Changelog.md` and XML docs in the same commit; Changelog headings `## <date> (package <version>): <title> (<issue keys>)`.
- The issues to apply: the lead gives you the keys. Read each with the Linear tool `get_issue` (read only) and `list_comments` (decisions are in comments; comments win over the description). Do not rely on `C:\repo\jhkweb\UBIQUITOUS-LANGUAGE.md` (out of date until the renames land).

## How to rename safely

1. Build the full old→new map from the issues before editing. For each new name, check it does not already exist as a member in the same type or as an extension on the same receiver (grep declarations across C:\repo\jhkweb\Kelly-* repos except obj/bin and the v4 `*-v2`/`*-v4` repos). A clash that compiles can silently re-bind a call (overloads, instance-vs-extension): resolve it by a distinct name or explicit parameters, and say what you chose.
2. Rename with word boundaries (perl `\b...\b` over .cs/.xaml/README files; never inside `Changelog.md` history). Rename files and types named after old names with `git mv`. Test method/class names that contain an old member name follow it (`Old_` and `OldTests`).
3. Names that are serialized or shown (JSON keys, data-file columns, settings keys, XAML bindings, ribbon item names, transaction names shown in Undo, report headers) keep their stored value unless the issue says otherwise: use the appropriate attribute (e.g. `[JsonProperty("Old")]`) and add a test that an old file still reads.
4. XML `cref`s that become ambiguous (CS0419) must name the overload. Compare warnings before/after: no NEW warnings.
5. Skip an item only if doing it would change behaviour in a way the issue does not ask for, or needs a decision nobody made; list every skipped item with the reason.

## Build, test, pack

Packing, repinning, versions, Changelog headings, the application last, push order and traps: `package-chain.md` beside this file (procedure: `~/.claude/skills/_shared/package-chain.md`). This pass packs its own layer; the next of the six layers is repinned and its calls fixed, not packed. If the consumer is a format library or Kelly-Revit-Data-Exporter, pack it too in this pass.

## Commit and report

- One commit per repo on `develop`, message naming every issue key it works on, no trailer. Leave unrelated files alone (check `git status` first; do not sweep in other changes).
- Report back (no preamble, under ~60 lines): per repo the commit hash, the package version packed (if any), configurations built, tests run with pass/fail counts; the final old→new map (compact); clashes and how you resolved them; skipped items with reasons; anything the lead must decide or check (e.g. renames that change stored or shown text).
