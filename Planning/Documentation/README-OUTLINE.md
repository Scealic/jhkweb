# README outline for Kelly Tools For Revit repositories

Derived from the current `README.md` of every repository under `C:\repo\jhkweb` (Kelly-Windows-Data, Kelly-Windows, Kelly-Domain, Kelly-Revit-Logic, Kelly-Revit-UI, Kelly-Revit, BuildConfigs, VCS-Database-General-Schema, VCS-Database-Content-Schema), the README rules in `BuildConfigs/SHARED-AGENTS.md`, and a comparison with common README guidance (GitHub's "About READMEs", Google's README style guide, Standard Readme). Sections marked **Required** are mandated by the shared rules or apply to every repository; the rest are present where they apply.

A README describes what the repository is *now*. Check every claim against the files before writing it, and never carry over text from a sibling repository without verifying it here.

## Reading order

The sections run in two halves. A reader who only wants to **use** the repository stops after the first half; a person who **changes** it reads on. The halves are an ordering guide, not headings.

| Half | Sections | Reader's question |
|---|---|---|
| Use it | 1–10 | What is this, how do I use it, what does it need, how do I build it, what goes wrong? |
| Change it | 11–19 | How is it developed, how healthy is it, how do I test it, who owns it? |

---

## Use it

### 1. Title and summary  — Required

- `# <Repository or package name>`, using the name the code uses (`Kelly.Domain`, not `Kelly-Domain`, for a layer library).
- One paragraph, 1–3 sentences: what the repository holds, what it deliberately does not hold (for a layer: "no dependency on the Revit API"), and who consumes it.
- A one-line **Status** under it: `Active`, `Experimental` or `Deprecated`, and for a package the current version it ships. Leave it out only for a repository with no release (BuildConfigs, the database projects).
- Do not describe other repositories' contents. A pointer is enough ("shared MSBuild props live in `BuildConfigs`").

### 2. Contents  — Required when the README is longer than about 100 lines

- A bulleted list of links to every `##` heading, in order, one level deep. Do not list the title or "Contents" itself.
- Keep it in step with the headings: a renamed or added section updates it in the same commit.

### 3. Using this package  — Required

The first section a consumer reads: how to get it and the smallest working example.

- **Layer library or package:** the `PackageReference` (package id per configuration, for example `Kelly.Domain.Net80`, or `Kelly.Revit.Logic.2026`), the exact version to pin, and where packages come from (`C:\Repo\NugetPackages`). Then one short, runnable C# example that calls the most-used type. Name the namespace to import.
- **Add-in (Kelly-Revit):** how to install and start it (installer, or build for a Revit year), and the first thing a user sees in Revit.
- **BuildConfigs:** the `<Import>` lines and which combination each kind of project uses (this is already its "Usage" section).
- **Database project:** open the `.slnx`, build to produce the DACPAC, publish to a development database first (this is the "Working with this project" section).
- Keep the example to what a consumer relies on. Detail goes to the feature sections and the XML docs.

### 4. Overview  — Layer libraries, add-in

A short bullet list of facts a reader looks up first:

- **Project:** path of the `.csproj`.
- **Assembly name and root namespace** (and where they come from, e.g. `$(SolutionName)`).
- **Packages:** NuGet package ids per configuration.
- **Tests:** test project paths, runner (NUnit 4 or NUnit 3), with or without Revit.
- The layer rule from the repository's `AGENTS.md` ("Only Revit-free domain types belong here").

### 5. Layout / Solution structure  — Required

- State the namespace rule: a file's namespace is the root namespace plus its folder path under `src/`.
- A two-column table, one row per `src/` folder: `Folder | Holds`. List real type names, not categories. Every folder that exists appears; no folder that does not exist appears.
- Mention what is outside `src/`: `tests/`, `doc/`, `res/`, `.build/`, solution files.
- Database projects: a `Schema | Purpose` table instead, plus the non-schema files (`ExtendedProperties.sql`, `Compares/`, `Storage/`, `Service Broker/`).
- BuildConfigs: a `File | Purpose` table of the `.props` files.

### 6. Feature sections  — Where the repository has a public surface

One `##` per area of capability (Kelly-Revit-Logic "Key capabilities", Kelly-Revit-UI "Modules", "Ribbon buttons and icons", "XAML"; Kelly-Revit "Command & Tool Catalog", "Adding a New Command"). Each states the contract, with a short code sketch only where the contract is not obvious from the type names. Keep these to behavior a consumer relies on; leave implementation detail to the XML docs.

### 7. Target frameworks / Supported Revit versions  — Required for .NET repositories

Table of `Configuration | Revit (if any) | Target framework | Package`. Then:

- `-c` is required; an unrecognised configuration falls back to `net46` and restore fails.
- Preprocessor symbols (`REVIT2024`…) and where they are defined.

### 8. Prerequisites  — Required for .NET repositories

- .NET SDK (note a `global.json` pin if there is one).
- Revit versions installed, and which DLLs are referenced from `C:\Program Files\Autodesk\Revit <year>`.
- `BuildConfigs` checked out at `C:\Repo\jhkweb\BuildConfigs`, and which of its props the project imports.
- NuGet sources needed (`C:\Repo\NugetPackages`, Telerik feed).

### 9. Dependencies and Build  — Required for .NET repositories

**Dependencies**

- Kelly layer packages with their **exact pinned versions** (they are pinned by exact version; the README must match the csproj).
- Third-party packages, and framework references that differ per target.
- One line on what a consumer must pin because of this repository.

**Build**

- Visual Studio steps (solution file, configuration, project to build).
- CLI command in a fenced `bash` block, one command per block, always with `-c`.
- `-p:GeneratePackageOnBuild=false` unless a release package is wanted; say where packages are written.
- Anything a build does as a side effect (Kelly-Revit: installs the add-in).

### 10. Troubleshooting  — Required for .NET repositories and the add-in

One table, `Symptom | Cause | Fix`, collecting the failures that people hit, so the other sections do not each explain them:

| Symptom | Cause | Fix |
|---|---|---|
| Restore fails on `net46` | No `-c` given, or an unknown configuration | Pass the configuration for the layer |
| Mass `CS0234` (missing namespace) | A Kelly package pin names a version not in `C:\Repo\NugetPackages` | Fix the pin; the source is not broken |
| 401 from the Telerik feed | Feed not authorised | Pass `-p:RestoreSources=…` explicitly |
| `MissingMethodException` in an in-Revit test | The installed add-in's DLLs were loaded instead of this source | Disable the add-in for the run |
| Log has fewer rows than tests discovered | The ricaun adapter hit `NUnit.Timeout` and dropped the rest | Raise `NUnit.Timeout` in the project |
| Log's last line says **Missing results** (warning `KTR0001`) | The ricaun adapter lost a block of results from a run that finished, with no error; the tests did not fail | Every result is in the Revit journal the log names; run the missing fixtures again with `--filter` |
| Revit still running after a stopped test run | A killed run leaves Revit, `ricaun.RevitTest.Console`, `testhost` and the `.addin.x` rename behind | End the processes, rename the manifest back |
| Add-in assembly built as `Revit.dll` and fails to load | Project built outside its solution | Pass `-p:SolutionName=…` |

List only rows that apply to the repository. Add a row when a failure costs someone time twice.

---

## Change it

### 11. Development paradigm  — Required

The same fixed paragraph in every repository: Test Driven Design — start each change with a failing test, write the simplest code that passes, refactor with the tests as a safety net. Repositories without a test project say what the failing check is instead (BuildConfigs: a run of a sibling repository's tests).

### 12. SOLID principles  — Required for .NET repositories

Mandated by `SHARED-AGENTS.md`.

- Opening sentence: "Where the library stands, from a read of the source on `<date>`. Update it with each change that moves a rating."
- Table: `Principle | Rating | Notes`, with five rows (Single responsibility, Open/closed, Liskov substitution, Interface segregation, Dependency inversion).
- Rating is exactly **Strong**, **Mixed** or **Weak** (a range such as `Weak–Mixed` is acceptable when a change is mid-way).
- Notes name the types that justify the rating, in both directions (what is good, what is not).
- Re-date it whenever a change moves a rating.

### 13. Unit testing  — Required

Measured results, so readers can see the state of the tests at a glance.

- Opening sentence: "Measured on `<date>` from `develop`. Update this section when the counts or the coverage move."
- Table: `Test project | Runs | Frameworks or Revit | Tests | Result`.
- **Coverage** subsection: overall line and branch coverage with the tool and version, then a table by `src` folder, lowest first (`Folder | Lines covered | Line coverage | Branch coverage`), followed by a sentence naming the biggest gaps.
- In-Revit tests cannot be measured by coverlet. Say so, and give a per-folder count of tests instead.
- The exact command that re-measures coverage, in a fenced block, and where the report is written.
- Database projects with no test project: "This repository has no unit test project yet", then the manual checks (build the project, publish to a development database first, exercise each changed procedure), and where tests would live when added.

### 14. Tests  — Required where a test project exists

- What each test project covers, and what it deliberately does not (and why: needs SQL Server, needs an active view, calls the Revit API).
- Folder and namespace conventions for fixtures; shared test doubles under `tests/Support` or `Abstractions/`.
- The rules specific to the project: NUnit 3.13.3 for in-Revit tests (`Assert.That` only), `Description`/`Author` attribute rules from the shared file.
- Link to this from Unit testing rather than repeating the numbers.

### 15. Running the tests  — Required

Mandated by `SHARED-AGENTS.md`. Numbered steps a person can follow without other documents:

1. Preconditions (Revit closed, no `ricaun.RevitTest.Console` — with the `tasklist` command).
2. Disable the installed add-in (the `ren` command) for in-Revit runs.
3. The `dotnet test` command with `-c` and `-p:GeneratePackageOnBuild=false`; the filter option for one fixture.
4. Re-enable the add-in, also when the run failed or was stopped.
5. Check the Markdown log `<test folder>\TestLogs\<assembly> - <framework>.md` has a row for every expected test, and where logger errors go.

The steps give the action and the reason in one clause; the failure modes themselves live in **Troubleshooting** (section 10), which the last step links to. For Revit-free layers this collapses to the single command and the three configurations to run before a package is built.

### 16. Configuration  — Optional

`App.config`, connection strings, per-machine settings, and what is intentionally empty.

### 17. Installer and documentation  — Add-in only

Where the installer project is, and what `doc/` and the user guides hold.

### 18. Naming conventions and known issues  — Database projects

Prefixes (`USP_`, `vProd_`, `DEPREC_`), versioning suffixes, the deprecation convention, and a pointer to the code-review reports of outstanding issues.

### 19. Ownership, help and contributing  — Required

- **Ownership:** the team or person who maintains the repository, and who approves changes.
- **Getting help:** where to ask (issues, a channel, or a named contact), and what to include in a report (configuration, the log file, the commit).
- **Contributing:** a short numbered list (the change stays in this layer, validate the affected configurations, update the README, `Changelog.md` and XML docs in the same commit) and a link to `AGENTS.md` and `SHARED-AGENTS.md` for the working rules.
- **License:** `See /LICENSE.md.`, last in the file, only where the repository has a `LICENSE.md`.

---

## Conventions that apply to every section

- **Tables** for anything enumerable (folders, packages, configurations, ratings, coverage, failures). Prose only for rules and reasons.
- **Commands** in fenced `bash` blocks, one command per block, no `$` prompt, paths relative to the repository folder, always with `-c` and, for tests/builds that are not releases, `-p:GeneratePackageOnBuild=false`.
- **Dates**: every measured or reviewed section states the date it was measured (`2026-10-20`) and the branch or commit. A section without a date is assumed stale.
- **Exact numbers** (test counts, coverage, pinned versions) come from a run or the csproj, never from memory. Update them in the same commit as the change that moves them.
- **Same-commit rule**: a public-surface change updates `README.md`, `Changelog.md` and the XML docs together; so does a new or renamed heading and the Contents list.
- **One home per fact**: shared rules live in `BuildConfigs/SHARED-AGENTS.md` and a layer's rules in its `AGENTS.md`; the README links to them rather than copying them, except for the "Running the tests" steps, which must stand alone.
- **Lead with the consumer**: nothing about SOLID ratings, coverage or test procedure appears before "Using this package".
- **No other repositories' content**: a README does not carry the five-layer diagram or table, a related-repositories list, or cross-links; dependencies the build needs are stated as dependencies.
- **Never** add `Co-Authored-By` to the commit that updates a README.

## Order at a glance

| # | Section | Layer library | Add-in | Database project | BuildConfigs |
|---|---|---|---|---|---|
| 1 | Title and summary (with Status) | ✔ | ✔ | ✔ | ✔ |
| 2 | Contents (over ~100 lines) | ✔ | ✔ | if long | if long |
| 3 | Using this package | ✔ | ✔ (install) | ✔ (working with) | ✔ (usage) |
| 4 | Overview | ✔ | ✔ | – | – |
| 5 | Layout / Solution structure | ✔ | ✔ | ✔ (schema table) | ✔ (file table) |
| 6 | Feature sections | ✔ | ✔ | – | – |
| 7 | Target frameworks / Revit versions | ✔ | ✔ | – | – |
| 8 | Prerequisites | ✔ | ✔ | – | – |
| 9 | Dependencies and Build | ✔ | ✔ | ✔ (build only) | ✔ (dependencies only) |
| 10 | Troubleshooting | ✔ | ✔ | – | – |
| 11 | Development paradigm | ✔ | ✔ | ✔ | ✔ |
| 12 | SOLID principles | ✔ | ✔ | – | – |
| 13 | Unit testing | ✔ | ✔ | ✔ (manual checks) | – |
| 14 | Tests | ✔ | ✔ | – | – |
| 15 | Running the tests | ✔ | ✔ | – | ✔ (shared rules) |
| 16 | Configuration | optional | – | – | – |
| 17 | Installer and documentation | – | ✔ | – | – |
| 18 | Naming conventions, known issues | – | – | ✔ | – |
| 19 | Ownership, help and contributing | ✔ | ✔ | ✔ | ✔ |

## Where the current READMEs differ from this outline

Gaps found while reading them; fix them in the next README update, not here:

- **No "Using this package" section** in any layer library README (Kelly-Windows-Data, Kelly-Windows, Kelly-Domain, Kelly-Revit-UI; Kelly-Revit-Logic has only "Typical usage patterns"). Add the `PackageReference` and one example.
- **No Contents list** in any README, although all but BuildConfigs and the two database READMEs are over 100 lines.
- **No Status line, Getting help or Troubleshooting section.** Only Kelly-Revit has Ownership. The failure modes sit as bullets inside "Running the tests"; move them to one table.
- **Maintainer material comes first.** SOLID, Unit testing and coverage precede or interleave with Build and Prerequisites in most READMEs. Reorder to the two halves above.
- **Kelly-Windows-Data** has no summary paragraph under its title (its Development paradigm section follows the heading directly).
- **Testing section names vary:** "Unit testing", "Tests", "Testing status" and "Running the tests". Use Unit testing + Tests + Running the tests.
- **The SOLID and Unit testing dates differ** (`2026-10-19` vs `2026-10-20`); each is correct for its own review, but a reader cannot tell if they describe the same state.
- **BuildConfigs** has no SOLID principles section and no Prerequisites, as is right for a props repository, but it should say so in a sentence so the omission is deliberate.
- **Changelog.md** is required by `SHARED-AGENTS.md`; none of the READMEs mention it. Link it from "Ownership, help and contributing".
