# Linear issue splits: 2026-11-25

This review covers one issue, [KTR5-4951](https://linear.app/jhkelly-ktr/issue/KTR5-4951). The maintainer asked for this split and suggested splitting it by team.

| Team | Open issues reviewed | Fine | Split | Unclear | New issues proposed | Existing issues to link |
|---|---|---|---|---|---|---|
| KTR5 | 1 | 0 | 1 | 0 | 37 (8 team pieces, 29 folder pieces) | KTRUI-10 (Related) |

## [KTR5-4951](https://linear.app/jhkelly-ktr/issue/KTR5-4951): Unit test backfill: 450 types with untested members (16 points)

**Signals:**
- It crosses eight repositories.
- It is a sweep over 450 types and 1,217 members.
- Its estimate is at the top of the scale.

**Shape:** sub-issues on two levels.
- The first level has one sub-issue per team, in that team, as the maintainer asked.
- A team piece that would be more than 4 points becomes a parent, with folder pieces of 1 to 4 points as its sub-issues.
- No piece blocks another: tests in one repository don't need a package from another.

**What the original keeps:** it becomes a parent only. It keeps its title and goal and loses its estimate.

**Estimates:**
- The proposal's per-type rubric, which totals 955 points, is too high for test work. These estimates go by the number of members:
  - 1 point: up to about 8 members, or tiny contract types.
  - 2 points: 9 to 20 members.
  - 4 points: 21 to 40 members.
- In-Revit work goes one step up where a test document has to be built.
- The total comes to about 88 points.

**Labels:** every piece copies Add and "Testing and documentation" and gets Low priority. The KTR5 pieces also get "Add-In Wide" (or the matching feature label) and their module label.

### Level 1: one per team (sub-issues of KTR5-4951)

| # | Team | Title | Est. | Relation | Goal |
|---|---|---|---|---|---|
| T1 | KWD3 | Tests: name the 7 untested members of `DataDirectory`, `DataFolderWriter`, `RecordMapper` | 1 | sub-issue | `src/Services`; a single piece |
| T2 | KWDC | Tests: name the 6 untested members of the Csv readers and writers | 1 | sub-issue | `CsvDataFileReader` and 2 others; a single piece |
| T3 | KWDJ | Tests: name the 6 untested members of the Json repository types | 1 | sub-issue | 2 types; a single piece |
| T4 | KW3 | Unit test backfill: Kelly-Windows-v3 (20 types, 56 members) | – | sub-issue, parent of KW3-a to c | |
| T5 | KD | Unit test backfill: Kelly-Domain (48 types, 231 members) | – | sub-issue, parent of KD-a to f | |
| T6 | KTRL5 | Unit test backfill: Kelly-Revit-Logic-v5 (86 types, 310 members) | – | sub-issue, parent of KTRL5-a to j | |
| T7 | KTRUI | Unit test backfill: Kelly-Revit-UI (19 types, 88 members) | – | sub-issue, parent of KTRUI-a to c; Related to KTRUI-10 | |
| T8 | KTR5 | Unit test backfill: Kelly-Revit-v5 (269 types, 513 members) | – | sub-issue, parent of KTR5-a to m | |

### Level 2: folder pieces

| # | Team | Title | Est. | Goal (folders under `src/`, or `modules/` for KTR5) |
|---|---|---|---|---|
| KW3-a | KW3 | Tests: `Wpf` members (`ProgressWindowReporter` and 4 more) | 4 | `Wpf`, `Wpf/Native`: 28 members |
| KW3-b | KW3 | Tests: `Files` and `Files/Xlsx` members (`MinimalXlsxWriter`, `TextFileWriter`) | 2 | 14 members |
| KW3-c | KW3 | Tests: Collections, Common, Hosting, Logging, Measurements and more | 2 | Collections, Common, Hosting, Logging, Measurements, Palettes, Persistence, Text, Workstation: 14 members |
| KD-a | KD | Tests: `Component` members | 4 | `Products`, `Component`: 34 members |
| KD-b | KD | Tests: the other `Products` types (records, `Product`) | 4 | `Products`: 53 members in 6 types |
| KD-c | KD | Tests: `Projects` types (`ProjectRecord` and 8 more) | 4 | 40 members |
| KD-d | KD | Tests: `Vocabulary/Nouns` | 2 | 30 members, all constants |
| KD-e | KD | Tests: `Parameters`, `Parameters/FilterRules`, `Definitions` | 2 | 24 members |
| KD-f | KD | Tests: Identifiers, Spools, Views/Spools, Caches, Categories, Connectors, Data | 4 | 50 members in 21 types, mostly small |
| KTRL5-a | KTRL5 | Tests: `Spools` types | 4 | 34 members |
| KTRL5-b | KTRL5 | Tests: `Supports` types (`SuspendedSupport` and 3 more) | 4 | 31 members |
| KTRL5-c | KTRL5 | Tests: `Entities` (`PhysicalElementEntity` and 2 more) | 4 | 28 members |
| KTRL5-d | KTRL5 | Tests: `Updaters/ElementDataModels` and `Updaters/Configurations` | 4 | 28 members |
| KTRL5-e | KTRL5 | Tests: `Updaters/ElementServices` and `Updaters` | 4 | 32 members in 18 types |
| KTRL5-f | KTRL5 | Tests: `Views` and `Geometry` | 2 | 22 members |
| KTRL5-g | KTRL5 | Tests: Arrangement, Caches, Categories, Families, Parameters | 4 | 29 members |
| KTRL5-h | KTRL5 | Tests: Common, Connectors, Fabrication, Mep | 4 | 42 members |
| KTRL5-i | KTRL5 | Tests: Documents, Elements, Operations (`OperationService`) | 4 | 37 members |
| KTRL5-j | KTRL5 | Tests: LayoutPoints and Projects (`ProjectInformationWrapper`) | 4 | 28 members |
| KTRUI-a | KTRUI | Tests: `Mvvm` (`ViewModel`, `CheckWindowViewModel`) | 4 | 24 members |
| KTRUI-b | KTRUI | Tests: `Ribbon` types and the ribbon interfaces | 4 | 40 members |
| KTRUI-c | KTRUI | Tests: Commands, Controls, Prompts, Requests, Scope | 4 | 24 members, mostly in Revit |
| KTR5-a | KTR5 | Tests: Host (`src`, Properties, Services) | 2 | 14 members; Host |
| KTR5-b | KTR5 | Tests: Assigner dockable pane | 4 | `Trade.All/DockablePanes/Assigner`: 55 members; Dockable Assigner |
| KTR5-c | KTR5 | Tests: Assigner B dockable pane | 4 | `Trade.All/DockablePanes/AssignerB`: 26 members; Dockable Assigner |
| KTR5-d | KTR5 | Tests: Spool Manager view model | 4 | `Spools/SpoolManager`: 34 members |
| KTR5-e | KTR5 | Tests: Spool Create, Module Creator, Module Manage and others | 4 | `Spools/*`: 44 members |
| KTR5-f | KTR5 | Tests: Layout Point Export and Import view models | 4 | `Layout/*`: 41 members |
| KTR5-g | KTR5 | Tests: Suspended Support Manage and the trapeze rod commands | 2 | `Supports/*`: 25 members |
| KTR5-h | KTR5 | Tests: Arrange commands (align, distribute, untangle) | 2 | `Acquired/Arrange`: 21 members, contract types |
| KTR5-i | KTR5 | Tests: Vicious commands (Level, Point To Pipe, Racker and more) | 4 | `Acquired/Vicious`: 37 members |
| KTR5-j | KTR5 | Tests: Assigner ribbon commands (six contexts) | 4 | `Commands/Assigners`: about 80 members, mostly contract types |
| KTR5-k | KTR5 | Tests: other Trade.All commands and ribbon items | 4 | About, Bill Of Material, Schedule Export, Updaters, Views, RibbonItems and more: about 69 members, mostly small |
| KTR5-l | KTR5 | Tests: Trade.Pipe commands (Olet Checker, Weld Location) | 2 | 19 members; Trade.Pipe |
| KTR5-m | KTR5 | Tests: Trade.Duct, Trade.Manager, Trade.Contenter and Trade.Developer commands | 4 | 46 members, one or two per command |

The KTR5 parent has 13 pieces, more than the usual eight. That number already uses the module and folder seam; going any coarser would push pieces over 4 points.

Each piece's description lists its types and members from `Planning/Unit Test Coverage/2026-11-25 Coverage Gaps.csv` (the rows of its repository and folders). It also points to "How to backfill a type" and reminds that every test needs `Author = "Verified By Human On:"` and a `Description`.

## Unclear

None.

## Open questions

- [KTRUI-10](https://linear.app/jhkelly-ktr/issue/KTRUI-10) ("Tests for the 16 untested Kelly-Revit-UI types", 4 points, child of KTR5-4689) overlaps T7. The drafted reading is to link it as Related to T7 and leave it as it is.
