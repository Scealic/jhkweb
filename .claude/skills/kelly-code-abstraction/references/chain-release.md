# Chain release: implementing moves bottom-up

How the accepted moves reach the add-in. Each layer is a NuGet package pinned by exact version in the layer above, so moved code exists for a higher layer only after its new home is packed and the higher layer is repinned. Every layer from the lowest one that changes up to Kelly-Revit is repinned, rebuilt and (except Kelly-Revit) repacked, **even a layer with no moves of its own**: a package compiled against the old lower layer fails at run time (a moved type is a `TypeLoadException`), and the user keeps all five pins in step on purpose.

Paths, test projects, where each README states its pins and each Changelog's heading form are in `references/layers.md`.

Scripts (Git Bash; `S=/c/repo/jhkweb/.claude/skills/kelly-code-abstraction/scripts`):

| Script | Use |
|---|---|
| `bash $S/kbuild.sh <layer> verify\|test\|revittests\|pack [configs]` | Build without a package, run the non-Revit tests, compile the in-Revit test project, or pack every configuration with one version. Kelly-Revit builds never install. Prints `errors=N` per configuration and `PACKED <layer> <version>`. |
| `bash $S/pins.sh set <csproj> <family> <version>`, `pins.sh show <csproj...>` | Set every `<family>.Net481/Net80/Net100/2024/2025/2026` pin in a project, or list projects' Kelly pins. |
| `perl $S/insert-changelog.pl <Changelog.md> <entry.md>` | Insert an entry above the newest `## ` heading. |
| `perl $S/check-rules.pl` | The layer rules, mechanically (run after each layer and in the audit). |

## Contents

- Per layer
- Kelly-Revit last
- Changelog entries
- Commits
- Push
- Pitfalls

## Per layer

From the lowest layer that has moves (or must be repinned) upward:

1. **Repin** every csproj of the repo that has Kelly pins (`git -C <repo> ls-files '*.csproj'`, test projects included) to the packages packed so far in this run: `bash $S/pins.sh set <csproj> Kelly.Domain 26.10.20.835`, and so on. `pins.sh show` must then print one identical set per project.
2. **Red: tests first.** Move the tests that cover the moving code into the target repo's test project (namespace == folder; `git mv` keeps history), and write the missing ones: every type member needs a test, and new or changed tests use the attribute form in `BuildConfigs/SHARED-AGENTS.md` (today `Author = "Verified By Human On:"`, `Description` = what the test does; never a date). Characterize **current** behaviour: if a test exposes a bug, assert what the code does now, add a short comment, and record the bug. Run `kbuild.sh <layer> test <one config>`: it fails to compile until the code arrives. Kelly-Revit-Logic's tests run only inside Revit, so write them in `test/Revit.Logic.RevitTests` and compile them with `revittests`.
3. **Move.** Add the code in the target folder with the namespace that matches it, remove it from the source with `git mv` where a whole file moves, and repoint every consumer in all six repos (`src`, `modules`, tests; skip `bin`/`obj`). Fix `GlobalUsings.cs` where namespaces appear or disappear, make a type `public` when a consumer in another assembly needs it, and give new public members XML docs. Consumers in higher repos cannot compile yet; edit them carefully from the code, and their layer's turn compiles them. Preserve behaviour exactly; a protected file keeps its class and calls the new API.
4. **Green.** `kbuild.sh <layer> verify` (every configuration), `kbuild.sh <layer> test` where the layer has non-Revit tests (check the run's `TestLogs/*.md` has a row per test), `kbuild.sh <layer> revittests 2024` where it has an in-Revit project, and `perl $S/check-rules.pl`.
5. **Review** the diff against `HEAD` adversarially before packing: behaviour changed (old and new code line by line: conditions, ordering, transactions, exception and null handling, messages, logging, return values, static state), a consumer still pointing at the old place, a copy left behind, dead usings, namespace ≠ folder, Revit wording in a Revit-free layer, a protected file moved, wrong accessibility, missing XML docs, tests not moved. Fix what is real and verify again.
6. **Docs** in the same commit: README (types moved in or out with old → new namespace, the pin line or table, "Running the tests", "SOLID principles" if a rating moves), the Changelog entry (below) and XML docs.
7. **Pack** (not Kelly-Revit): `kbuild.sh <layer> pack`. Write down the printed version; the layers above pin it.
8. **Commit** with explicit paths (below), then `git show --stat HEAD` to check nothing of the user's went in.

## Kelly-Revit last

- Pin all five packages in `src/Revit.csproj` and the six `modules/*/*.csproj`.
- This is the first time the blind consumer edits compile. Fix every error the run caused.
- Build all 21 configurations: `for l in revit alltrade pipetrade ducttrade contenter manager developer; do bash $S/kbuild.sh $l verify; done`, and compile `test/Tests.Revit` with `kbuild.sh revit revittests 2024` (it checks every module's commands, availability classes and push buttons).
- Confirm restore used the new versions: `find src/obj modules/*/obj -maxdepth 2 -name project.assets.json | xargs grep -ohE '"Kelly\.[A-Za-z.]+\.(Net481|2024)/[0-9.]+"' | sort | uniq -c`. All 21 show the new numbers.
- Kelly-Revit has no package; its Changelog heading says `(not yet built)` after verify-only builds.

Then update the working documents at the jhkweb root that name moved types (`UBIQUITOUS-LANGUAGE.md`, `SOLID Check.md`, `CLAUDE.md`). Leave historical records alone: older Changelog entries, `ARCHITECTURAL-ANALYSIS-moves.csv`, `Kelly-Revit-v5/doc/Design/*.csv`.

## Changelog entries

Headings are always dated, never "Unreleased". A version drops the leading zero of the minutes (built at 08:01 → `26.10.20.801`).

- Package repos: `## 2026-10-20 (package 26.10.20.832): <summary of the moves>`
- Kelly-Revit: `## 2026-10-20 (not yet built): ...`, or `(version 26.10.15.1428)` for an installed build.

Body, kept to what is true and counted with grep:
- `### Breaking`: a `| Was | Now |` table of every public type or member moved or removed, with namespaces;
- `### Added` / `### Changed`: what moved in, from where, and that behaviour did not change;
- the dependency changes (`| Package | Was | Now |`);
- `### Tests`: tests moved and added, counts per configuration, what was compiled but not run;
- bugs found and deliberately not fixed.

Match the sections of the newest entry in that Changelog.

## Commits

- One commit per repo per run, on `develop`. Subject ≤ 72 characters summarising the moves; body with a bullet per group of moved items and the pins. No `Co-Authored-By` or similar line.
- Stage and commit with explicit paths: `git -C <repo> add -- <paths>`, then `git -C <repo> commit -q -m "<msg>" -- <paths>`. Never `git add -A`, a path-less `git commit` or `git commit --amend` while the user has anything staged: they sweep the user's files in. Compare `git status --short` with the baseline taken at the start; files that were already modified are the user's.
- If a file the user is editing also needs your change, stage only your change: apply the same edit to the committed blob, put it in the index, and commit the index without paths (`git commit -- <path>` would take their working-tree version):
  ```bash
  git show HEAD:<path> | perl -pe 's/\bOld\.Namespace\b/New.Namespace/g' > /tmp/staged.cs
  git update-index --cacheinfo 100644,$(git hash-object -w /tmp/staged.cs),<path>
  git add -- <your other paths>; git commit -q -m "<msg>"     # index only
  git diff -- <path>                                          # their edits, still unstaged
  ```
- The user's IDE (ReSharper cleanup on save, background builds) can rewrite, re-wrap or stage files while you work. Just before every pack and commit, run `git status --short` and `git diff` again; keep their formatting, re-apply content of yours it undid, and unstage nothing of theirs.
- Check line endings with a raw read (`perl -e 'open(my $f,"<:raw",shift);local $/;$_=<$f>;print tr/\r//,"\n"' <file>`); `grep -c $'\r'` is unreliable in Git Bash.

## Push (only when the user asks)

```bash
for r in <repos>; do git -C $r push -u origin develop 2>&1 | grep -E "\->|rejected|error|pull/new"; git -C $r fetch -q origin; echo "$r: local $(git -C $r rev-parse --short HEAD) | origin/develop $(git -C $r rev-parse --short origin/develop)"; done
```

`-u` re-attaches tracking when the push recreates a `develop` that a merged pull request deleted. Merge order is bottom-up (Data, Windows, Domain, Logic, UI, Kelly-Revit): the new packages exist only in `C:\repo\NugetPackages`.

## Pitfalls

- **Same-minute pack:** `pack` refuses a version it already used for that layer this minute (the NuGet cache would serve the old package). Wait for the minute to change.
- **Mass `CS0234`/`CS0246` after a repin** means a pin names a version that is not in `C:\repo\NugetPackages`, not broken source.
- **`$(SolutionName)` assemblies:** Logic and Kelly-Revit name their assembly `$(SolutionName)`; built alone without `-p:SolutionName=...` the assembly is `Revit.dll`. The scripts pass it.
- **Stale WPF resources:** after the last XAML page leaves a project, incremental builds keep the old `*.g.resources` and BAML. Delete that project's `obj` and `bin` before the final build.
- **Short exception names:** a cleanup can turn `catch (Autodesk.Revit.Exceptions.OperationCanceledException)` into `catch (OperationCanceledException)` plus a using; that binds correctly only while the using stays. Keep the full name in files you move.
- **Moved namespaces in XAML:** `x:Class` and `clr-namespace:` references are strings the compiler checks only at the XAML build; grep `.xaml` files too.
