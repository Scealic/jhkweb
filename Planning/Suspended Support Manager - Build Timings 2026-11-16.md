# Suspended Support Manager: build timings (2026-11-16)

For [KTR5-4863](https://linear.app/jhkelly-ktr/issue/KTR5-4863) ("building the supports slows down sharply on large projects").

## How it was measured

- **Test:** `SuspendedSupportBuildTimingTests` in Kelly-Revit-Logic-v5 (`test/Revit.Logic.RevitTests/Supports`).
  - It is `[Explicit]`, so a full test run skips it.
  - It runs in Revit 2024 with the Kelly add-in loaded, so the real definitions resolve. It therefore times the installed build: Kelly.Revit.Logic 5.26.1112.1805.
- **Projects:** each run opens a detached temporary copy, never the file itself.
  - Default: the Kelly test project.
  - Another project: set the environment variable `KELLY_TIMING_MODEL` to its path.
- **Steps timed:** each step of `SuspendedSupport.CreateFromElements` is timed separately:
  - collecting the elements whose JHK Product Range is Supports;
  - `TryCreate`;
  - `LoadFromHost`, with fabrication hangers and family supports timed apart;
  - `MarkSignatureTagPairMatches`.
- **Re-runs on their own:** two parts of `LoadFromHost` were run again by themselves, to see their share:
  - the structure raycast for each family-support rod;
  - the ordered layout point lookup for each family support.
- **Reports:** each run writes `Kelly-Revit-Logic-v5/test/TestLogs/Suspended Support Build Timings - <project>.md` (git-ignored).

To run it again:

```bash
KELLY_TIMING_MODEL="<path to .rvt>" dotnet test Kelly-Revit-Logic-v5/test/Revit.Logic.RevitTests/Revit.Logic.RevitTests.csproj -c 2024 -p:SolutionName=Kelly.Revit.Logic -p:GeneratePackageOnBuild=false --filter "FullyQualifiedName~SuspendedSupportBuildTimingTests"
```

## Results

| Step | KTR Test Project (ms) | 06MP-NTT HI3-JHK (ms) |
|---|---:|---:|
| Open the project copy (not part of the manager) | 19,904 | 47,091 |
| Collect the support elements | 43 | 307 |
| `TryCreate` on each element | 52 | 488 |
| `LoadFromHost`, fabrication hangers | 33 | 240 |
| `LoadFromHost`, family supports (trapezes, pipe hangers) | 297 | 783 |
| ↳ structure raycast per family rod (re-run alone) | 46 | 339 |
| ↳ ordered layout points per family support (re-run alone) | 0 | 0 |
| `MarkSignatureTagPairMatches` | 6 | 29 |
| **Build total** (collect to mark, without the re-runs) | **431** | **1,847** |

| Count | KTR Test Project | 06MP-NTT HI3-JHK |
|---|---:|---:|
| File size | 137 MB | 325 MB |
| Elements with Product Range = Supports | 153 | 2,981 |
| Suspended supports built | 130 | 2,102 |
| Fabrication hangers / their rods | 96 / 107 | 2,088 / 2,088 |
| Family supports / their rods | 34 / 71 | 14 / 28 |

## What the numbers say

- **The support logic is not the slow part.** In the large project it builds all 2,102 supports in under 2 seconds.
  - That project has 16 times as many supports as the test project, and the build takes 4.3 times as long, so the build grows *slower* than the support count.
  - On this project the logic does not show the superlinear slowdown described in the issue.
- **Per support:** a fabrication hanger costs about 0.1 ms to load. A family support costs about 56 ms in the large project, against 9 ms in the test project.
- **Per raycast:** each structure raycast takes about 12 ms in the large project and 0.6 ms in the test project. The cost per ray grows with model size, as the issue suspected.
  - This project has only 28 family rods, so the raycasts add up to a third of a second.
  - A project with hundreds of trapezes would feel this: about 12 ms × rods, or around 1 minute per 5,000 rods at this model size.
- **Not significant:** layout point ordering and signature matching cost almost nothing.

## Not measured yet

These run in the manager's own code, not in Kelly.Revit.Logic, so the test doesn't cover them. The time the user sees is most likely here:

1. **Progress window:** "Creating Suspended Supports" renders once per element, 2,981 times here. `ItemBegin` also reads JHK Long Description for every element.
2. **Collecting elements three times:** the manager collects the elements once for each scope (Document, View, Selection), through `UIDocument`.
3. **Grid:** filling and rendering the `RadGridView` with 2,102 rows, its sort, filter and group descriptors, and the scope filter in `ApplyScope`.
4. **Large-project shape:** a project with many trapezes or linked structure, where the raycast cost grows.

Next step: time the manager itself on this project. Use a stopwatch around `BuildSuspendedSupports`, `ApplyScope` and the window's first render, or time the progress bar and the window open by hand. If most of the time turns out to be in the progress window or the grid, the fix belongs in Kelly.Windows (`ProgressWindowReporter`) or in the manager, not in `SuspendedSupport`.

## The manager window itself (06MP-NTT HI3-JHK)

Measured in your Revit 2024 with the installed Kelly-Revit-v5 5.26.1116.1133. The manager writes one line to the development log when its window first draws. Opened 2026-11-16 11:37, initial scope View:

| Step | ms |
|---|---:|
| Collect elements in 3 scopes (2,981 in document, 4 in view, 0 selected) | 252 |
| Open the progress window | 25 |
| Build 2,102 supports, with the progress window | 2,152 |
| Match signatures | 28 |
| Close the progress window | 11 |
| Apply scope (View) | 1 |
| Build the window and draw the grid (4 rows) | 1,195 |
| **Total, view model created to grid drawn** | **3,670** |

- **About 3.7 s from start to finish** on this project, so it is not slow here.
- **Build:** 2.15 s, against 1.5 s for the same steps without a window in the timing test. The progress window and the per-element scope and description reads add about 0.6 s.
- **Window and grid:** 1.2 s, with only 4 rows shown because the scope was View. That is mostly the cost of creating the window and the Telerik grid.
- **Not measured:**
  - switching to Document scope, which puts all 2,102 rows in the grid; the log line is written once, at first draw;
  - a project with many trapezes or pipe-hanger families, where the per-rod raycast (about 12 ms per rod at this model size) would add up.

## A large cloud project (opened 2026-11-16 12:31)

The same installed build, in your Revit 2024, on a large cloud project. The project's name is not in the log.

| Step | 06MP-NTT HI3-JHK (local) | Cloud project |
|---|---:|---:|
| Elements (document / view / selected) | 2,981 / 4 / 0 | 417 / 417 / 0 |
| Collect elements in 3 scopes | 252 | 55 |
| Open the progress window | 25 | 26 |
| **Build supports, with the progress window** | 2,152 (2,102 supports, 1.0 ms each) | **16,571 (369 supports, 44.9 ms each)** |
| Match signatures | 28 | 8 |
| Close the progress window | 11 | 11 |
| Apply scope (View) | 1 | 1 |
| Build the window and draw the grid | 1,195 (4 rows) | 1,825 (369 rows) |
| **Total** | **3,670** | **18,504** |

- **Building the supports is 90% of the open,** at 45 times the cost per support of the local project. Collecting the elements and drawing the window and grid are not the problem.
- **Probable cause: the per-rod structure raycast on trapezes and pipe-hanger families.** Its cost per ray grows with the size of the model and its links. Collecting the elements is fast, so the cloud connection itself doesn't seem to be the cost.
- **Not yet confirmed:** the log doesn't split the build into fabrication hangers and family supports, or count the raycasts and their time. That needs the build instrumented more finely and opened on this project again.
