# Chain release: implementing moves bottom-up

How the accepted moves reach the add-in. Each layer is a NuGet package, and each repo pins **only the layer directly below it**: one `Kelly*Version` property in its `Directory.Packages.props` (central package management; `LayerPackages.Build.targets` fails any other Kelly reference with KTR0006). The layers further down arrive through that package. So moved code exists for a higher layer only after its new home is packed and the layer above is repinned, and that layer is packed in turn. Every layer from the lowest one that changes up to Kelly-Revit is therefore repinned, rebuilt and (except Kelly-Revit) repacked, **even a layer with no moves of its own**. Otherwise the layer above would still get the old lower package through it, and a moved type would be a `TypeLoadException` at run time.

`layers.md` lists the paths, test projects and pin properties, where each README states its pin, and each Changelog's heading form. `scripts/layer-moves.workflow.js` follows this procedure for large plans. Follow it yourself for small ones.

Scripts (Git Bash; `S=/c/repo/jhkweb/.claude/skills/kelly-layer-moves/scripts`):

| Script | Use |
|---|---|
| `bash $S/kbuild.sh <layer> verify\|test\|revittests\|pack [configs]` | Build without a package, run the non-Revit tests, compile the in-Revit test project, or pack every configuration with one version. Kelly-Revit builds never install. Prints `errors=N` per configuration and `PACKED <layer> <version>`. |
| `bash $S/pins.sh set <repo> <version>`, `pins.sh show [repo...]` | Set a repo's one `Kelly*Version` property (`pins.sh set Kelly-Revit-UI 5.26.1104.930`), or print every repo's pin (default: the six v5 repos). |
| `bash $S/revit-test.sh <test csproj> <filter\|-> <log> [msbuild args]` | Run an in-Revit test project in Revit 2024 against this source. It disables the active Kelly manifests for the run and restores them afterwards, even when the run fails. Never rename the manifests yourself. |
| `perl $S/insert-changelog.pl <Changelog.md> <entry.md>` | Insert an entry above the newest `## ` heading. |
| `perl $S/check-rules.pl` | The layer rules, mechanically (run after each layer and in the audit). |

## Contents

- Per layer
- Kelly-Revit last
- Version numbers and Changelog entries
- Commits
- Push
- Pitfalls

## Per layer

Start from the lowest layer that has moves and work upward. For each layer:

1. **Repin** the repo to the package of the layer below that this run packed: `bash $S/pins.sh set <repo> <version>`. Skip this for the lowest layer that changes. `pins.sh show` then prints the new version for that repo.
2. **Red: tests first.** Move the tests that cover the moving code into the target repo's test project (namespace == folder; `git mv` keeps history), and write the missing ones. Every type member needs a test. New or changed tests use the attribute form in `BuildConfigs/SHARED-AGENTS.md` (today `Author = "Verified By Human On:"` and a `Description` of what is verified, never a date). Characterize **current** behaviour: if a test exposes a bug, assert what the code does now, add a short comment, and record the bug. Run `kbuild.sh <layer> test <one config>`: it fails until the code arrives. Kelly-Revit-Logic's tests run only inside Revit, so write them in `test/Revit.Logic.RevitTests` and compile them with `revittests`.
3. **Move.** Add the code in the target folder with the namespace that matches it. Remove it from the source with `git mv` where a whole file moves. Repoint every consumer in all six repos (`src`, `modules`, tests; skip `bin`/`obj`). Fix `GlobalUsings.cs` where namespaces appear or disappear, make a type `public` when a consumer in another assembly needs it, and give new public members XML docs. Consumers in higher repos cannot compile yet: edit them carefully from the code, and their layer's turn compiles them. Preserve behaviour exactly. A protected file keeps its class and calls the new API.
4. **Docs.** These go in the same commit as the code (`SHARED-AGENTS.md`):
   - the README: types moved in or out with old → new namespace, "Running the tests", and "SOLID principles" if a rating moves;
   - the Changelog entry (below), headed `(not yet in a package)` for now;
   - the XML docs;
   - `Quick-Backlog.md`: add new items under "To Organize", and tick an item only with the commit as evidence.
5. **Commit** the package with explicit paths (below). Then run `git show --stat HEAD` to check that nothing of the user's went in.
6. **Green.** Run all of these:
   - `kbuild.sh <layer> verify` (every configuration);
   - `kbuild.sh <layer> test` where the layer has non-Revit tests (check the run's `TestLogs/*.md` has a row per test);
   - `kbuild.sh <layer> revittests 2024` where it has an in-Revit project;
   - `perl $S/check-rules.pl`.
7. **In-Revit tests.** Run them through `revit-test.sh` with a filter for the fixtures this run touched, or all of them when shared code changed (Logic: about 30 minutes). Compare the log's rows with the number of tests discovered. If Revit 2024 is open or no licence is available, don't run them: report them as "compiled, not run".
8. **Review** the layer's commits against the run's starting sha, adversarially, before packing. Look for:
   - changed behaviour: compare old and new code line by line (conditions, ordering, transactions, exception and null handling, messages, logging, return values, static state);
   - a consumer still pointing at the old place, or a copy left behind;
   - dead usings, namespace ≠ folder, or Revit wording in a Revit-free layer;
   - a protected file moved;
   - wrong accessibility, missing XML docs, or tests not moved.

   Fix what is real in a `Review fixes: …` commit and verify again.
9. **Pack** (not Kelly-Revit): `kbuild.sh <layer> pack`. Write down the printed version: the layer above pins it.
10. **Version docs.** Change this run's Changelog headings from `(not yet in a package)` to `(package <version>)`, and update the README's pin statement. Commit that with explicit paths.

## Kelly-Revit last

- Repin it to this run's Kelly.Revit.UI package (`pins.sh set Kelly-Revit-v5 <ui version>`). The host and all six modules share that one property.
- The host also pins the CSV reader, `Kelly.Windows.Data.Csv`, by a literal version outside the chain. If Kelly-Windows-Data was repacked, check that restore shows no `NU1605`/`NU1608` warning for it.
- This is the first time the blind consumer edits compile. Fix every error the run caused.
- Build all 21 configurations (host and six modules × 2024, 2025, 2026): `for l in revit alltrade pipetrade ducttrade contenter manager developer; do bash $S/kbuild.sh $l verify; done`. Then compile `test/Tests.Revit/Core.Tests.csproj` with `kbuild.sh revit revittests 2024`. It checks every module's commands, availability classes and push buttons.
- Confirm that restore used the new versions: `find src/obj modules/*/obj -maxdepth 2 -name project.assets.json | xargs grep -ohE '"Kelly\.[A-Za-z.]+\.(Net481|2024)/[0-9.]+"' | sort | uniq -c`. Every Kelly package must show this run's number.
- Kelly-Revit has no package. Its Changelog heading says `(not yet in a build)` after verify-only builds.

Then update the working documents at the jhkweb root that name moved types (`UBIQUITOUS-LANGUAGE.md`, `SOLID Check.md`, `.claude/CLAUDE.md`), and commit them to the root repo (local, never pushed). Leave historical records alone: older Changelog entries, `ARCHITECTURAL-ANALYSIS-moves.csv` and `Kelly-Revit-v5/doc/Design/*.csv`.

## Version numbers and Changelog entries

`BuildConfigs/dotnet/.props/Version.Build.props` sets the version as `<MajorVersion>.yy.MMdd.HHmm`, each number without leading zeros. `MajorVersion` is the repo's own (Kelly-Windows-Data-v3 and Kelly-Windows-v3: 3; Kelly-Domain and Kelly-Revit-UI: 1; Kelly-Revit-Logic-v5 and Kelly-Revit-v5: 5). For example, Kelly-Domain built on 2026-11-03 at 17:17 is `1.26.1103.1717`, and at 08:01 it would be `1.26.1103.801`.

Headings are always dated, never "Unreleased":
- package repos: `## 2026-11-03 (not yet in a package): <summary>`, then `## 2026-11-03 (package 1.26.1103.1717): <summary>` once packed;
- Kelly-Revit: `## 2026-11-03 (not yet in a build): <summary>`, or `(version 5.26.1103.1035)` for an installed build.

The body is kept to what is true and counted with grep:
- `### Breaking`: a `| Was | Now |` table of every public type or member moved or removed, with namespaces;
- `### Added` / `### Changed`: what moved in, from where, and that behaviour did not change;
- the dependency change (`| Package | Was | Now |`);
- `### Tests`: tests moved and added, counts per configuration, and what was compiled but not run;
- bugs found and deliberately not fixed.

Match the sections of the newest entry in that Changelog.

## Commits

- Commit on `develop`, one commit per work package (tests and code together, test-first), then a `Review fixes: …` commit if the review found anything, then the version-docs commit after packing. Each subject is 72 characters or fewer; the body has a bullet per group of moved items. No `Co-Authored-By` or similar line.
- Stage and commit with explicit paths: `git -C <repo> add -- <paths>`, then `git -C <repo> commit -q -m "<msg>" -- <paths>`. While the user has anything staged, never use `git add -A`, a path-less `git commit` or `git commit --amend`: they sweep the user's files in. Compare `git status --short` with the baseline taken at the start. Files that were already modified then are the user's.
- If a file the user is editing also needs your change, stage only your change. Apply the same edit to the committed blob, put it in the index, and commit the index without paths (`git commit -- <path>` would take their working-tree version):
  ```bash
  git show HEAD:<path> | perl -pe 's/\bOld\.Namespace\b/New.Namespace/g' > /tmp/staged.cs
  git update-index --cacheinfo 100644,$(git hash-object -w /tmp/staged.cs),<path>
  git add -- <your other paths>; git commit -q -m "<msg>"     # index only
  git diff -- <path>                                          # their edits, still unstaged
  ```
- The user's IDE (ReSharper cleanup on save, background builds) can rewrite, re-wrap or stage files while you work. Just before every pack and commit, run `git status --short` and `git diff` again. Keep their formatting, re-apply any content of yours it undid, and unstage nothing of theirs.
- Check line endings with a raw read (`perl -e 'open(my $f,"<:raw",shift);local $/;$_=<$f>;print tr/\r//,"\n"' <file>`). `grep -c $'\r'` is unreliable in Git Bash.

## Push (only when the user asks)

```bash
for r in <repos>; do git -C $r push -u origin develop 2>&1 | grep -E "\->|rejected|error|pull/new"; git -C $r fetch -q origin; echo "$r: local $(git -C $r rev-parse --short HEAD) | origin/develop $(git -C $r rev-parse --short origin/develop)"; done
```

`-u` re-attaches tracking when the push recreates a `develop` that a merged pull request deleted. Merge bottom-up (Data, Windows, Domain, Logic, UI, Kelly-Revit), because the new packages exist only in `C:\repo\NugetPackages`.

## Pitfalls

- **Same-minute pack:** `pack` refuses a version it already used for that layer this minute (exit code 3), because the NuGet cache would serve the old package. Wait for the minute to change.
- **Mass `CS0234`/`CS0246` after a repin** means the pin names a version that is not in `C:\repo\NugetPackages`, not that the source is broken.
- **`$(SolutionName)` assemblies:** Logic and Kelly-Revit name their assembly `$(SolutionName)`. Built alone without `-p:SolutionName=...`, the assembly is `Revit.dll`. The scripts pass it.
- **Stale WPF resources:** after the last XAML page leaves a project, incremental builds keep the old `*.g.resources` and BAML. Delete that project's `obj` and `bin` before the final build.
- **Short exception names:** a cleanup can turn `catch (Autodesk.Revit.Exceptions.OperationCanceledException)` into `catch (OperationCanceledException)` plus a using. That binds correctly only while the using stays, so keep the full name in files you move.
- **Moved namespaces in XAML:** `x:Class` and `clr-namespace:` references are strings that the compiler checks only at the XAML build. Grep `.xaml` files too.
