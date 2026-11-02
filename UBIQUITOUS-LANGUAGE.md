# JH Kelly — Ubiquitous Language

> A shared vocabulary for the JH Kelly detailing/fabrication tooling (the `jhkweb` repositories).
> This is a **Domain-Driven Design ubiquitous language**: the single set of terms that developers,
> detailers, fabricators, estimators, and BIM managers all use — in conversation, in code, in the
> database, and in the Revit ribbon.

## How to use this document

- Terms are grouped by **bounded context** (see the map below), then by concept.
- Each entry gives the **term**, a **plain-language definition**, and where it lives (SQL table, C# type,
  or Revit command).
- When the same idea has **more than one name** across layers (e.g. `ServiceData` in SQL vs. *Service* in
  speech), the aliases are called out so everyone knows they mean the same thing.
- The domain maintains its **own in-app dictionary**: the `dbo.Terminology` table (Context / CategoryA /
  CategoryB / Term / Definition / Initialism). Treat that table as the living source of truth; treat this
  file as the narrative companion that ties the terminology to the code and schema.

_Last generated: 2026-08-29. Derived from the source in `Kelly-Revit`, `Kelly-Revit-Logic`,
`Kelly-Windows-Data`, `VCS-Database-Content-Schema`, and `VCS-Database-General-Schema`._

---

## 1. Bounded contexts (the big picture)

The system is split across repositories and, within the two SQL databases, across **schemas that behave
like bounded contexts**. Each owns a slice of the vocabulary.

| Context | Where it lives | Owns the language of… |
|---|---|---|
| **Catalog / Content** | `VCS-Database-Content-Schema` → `dbo` | The master catalog: **Component**, **Product**, and the whole classification/lookup taxonomy |
| **Estimating** | Content DB → `Estimating` | Labor and cost — unit rates tied to product codes |
| **Fabrication (Autodesk)** | Content DB → `Fabrication` | Autodesk Fabrication (CADmep/ESTmep) mirror: Configuration → Specification → Material, item custom data |
| **Material** | Content DB → `Material` | Normalized material configurations and shop groups |
| **Revit Export** | Content DB → `RevitExport` | Flattened **Part** / **ButtonPart** rows generated for Revit, plus export QA reconciliation |
| **Core / Platform** | `VCS-Database-General-Schema` → `core` | Canonical **System** and project↔system assignment |
| **Platform (general)** | General DB → `dbo` | **Project**, sessions & telemetry, Revit parameter registry, connectors, services, product ranges, users, terminology |
| **Department / People** | General DB → `department` | **User Role**, responsibilities, activity codes, workstations |
| **Development** | General DB → `Development` | Internal dev/tooling: features, default values, updaters, code timers |
| **Revit UI** | General DB → `revit` | Ribbon tabs/panels, parameter group ids, role-gated panel visibility |
| **KTR add-in** | `Kelly-Revit` | The Revit commands users click — organized as **Verb + Object + Context** |
| **Revit Logic** | `Kelly-Revit-Logic` | Reusable Revit API logic: **Operation**/transaction orchestration, parameter wrappers, view filters, MEP models |
| **Data layer** | `Kelly-Windows-Data` | Shared entity **Records**, SQL access (`SqlServerService`), JSON persistence |

**KTR** = *Kelly Tools for Revit*, the add-in suite. **VCS** = the versioned database schema projects
that back it.

> **Convention across the databases:** a foreign-key default of `1` means "unset" — every lookup table has
> a real default row at `Id = 1`.

---

## 2. The catalog spine — Component → Product → Part

These three nouns are the backbone of the whole system. Everything else classifies, prices, or exports them.

- **Component** — The **master catalog item**: one fabrication/detailing family definition (e.g. a pipe
  fitting, a valve, a hanger). `dbo.Component` is the central table; it carries ~35 lookup foreign keys that
  classify it by Trade, Category tree, Main Class, Schedule, Material, Connector mapping/grouping, Business,
  Fabrication Pattern, and more. Its file path and long/short descriptions are **derived by triggers**
  (`VCS_Update_Component_Set…`). A Component's `Id` is referred to elsewhere as the **JHK Component Id**.
  _(`dbo.Component`, `ComponentRecord`, `ComponentAndLookupsViewRecord`)_

- **Product** — A specific **sized, purchasable variant** of a Component. Keyed by `ComponentId` +
  `ProductIndex` (0–999). Carries `ManufacturerCode`, `Size`, `Weight`, `Thickness`, `PartCode`, and links to
  estimating data and unit rates. Its computed `FabricationIdCalc` (`{ComponentId}-{ProductIndex:D3}`, e.g.
  `4021-003`) is the emerging **Product Code**. _(`dbo.Product`, `ProductRecord`)_

- **Part** — A **flattened export row** representing one Product for Revit, keyed by a unique `ProductCode`
  and tied to `ComponentId` + `ItemCustomId`, with Part/Product/JHK size strings. This is the shape the Revit
  add-in consumes. _(`RevitExport.Part`, `PartRecord`)_

- **Button Part** — A **denormalized export of an Autodesk Fabrication service *button*** and the part it
  produces: bundles Service attributes, Button attributes (code, condition ranges, is-hanger, is-straight),
  and Part attributes so a Revit ribbon button can be generated. _(`RevitExport.ButtonPart`, `ButtonPartRecord`)_

- **Component External** — A **staging/import projection** of a Component whose columns are `Jhk*`-prefixed
  (JhkManufacturer, JhkMaterialType, JhkPipeSize, JhkScheduleOrGauge, JhkProductRange, JhkTag). Holds
  externally-sourced (manufacturer/Revit) data on its way toward JH Kelly's own classification.
  _(`dbo.ComponentExternal`, `ComponentExternalRecord`)_

- **Product Information** — A denormalized, display-oriented description of a product (manufacturer,
  material, finish, size, specification, install type, product code, range). _(`ProductInformationRecord`)_

**The `Jhk*` prefix** is a naming convention meaning "the JH Kelly-normalized counterpart" of a value pulled
from an external/foreign source. It appears on staging tables and Revit shared-parameter projections.

---

## 3. Classification & lookup vocabulary

The taxonomy that pins a Component down. Most are Trade-scoped lookups.

- **Trade** — Top-level discipline classifier (e.g. piping, sheet metal). Scopes Main Class, Schedule,
  Reducing Class, Size Symbol, Connection Type. _(`dbo.Trade`)_
- **Main Class** — Trade-scoped primary product class (e.g. a pipe/fitting class). _(`dbo.MainClass`)_
- **Main Class Modifier** — Secondary qualifier on the Main Class. _(`dbo.MainClassModifier`)_
- **Reducing Class / Reducing Class Modifier** — Variants for reducing/branch fittings.
- **Main Schedule / Reducing Schedule** — Pipe/wall **schedule** designations (main run and reducing end).
- **Category Type** — Highest category tier; also flags catalog scope: `IsValidForSpool`,
  `IsValidForStratus`, and a Product Range link. _(`dbo.CategoryType`, `CategoryTypeRecord`)_
- **Category** — Mid-tier classification, optionally tied to a Category Type. _(`dbo.Category`)_
- **Sub Category** — Category-scoped leaf classification. _(`dbo.SubCategory`)_
- **Sub Category Modifier Alpha / Bravo** — Two further modifier axes below Sub Category, used to
  disambiguate a Component.
- **Connection Type** — Trade-scoped joining method (threaded, welded, grooved, …). _(`dbo.ConnectionType`)_
- **Component Group / Component Modifier / File Name Modifier / File Type** — Auxiliary lookup axes on a
  Component (grouping, naming modifiers, family file typing).
- **Catalog Group** — Manufacturer catalog grouping; carries a `PDFURL` to the source catalog.
- **Business** — A company/manufacturer entity (Name, Website). _(`dbo.Business`)_
- **Business Model** — A manufacturer's product line/model. _(`dbo.BusinessModel`)_
- **Business Type** — Classification of a Business.
- **Finish** — Surface finish classifier (includes a `NameAsItShouldBe` normalization field). _(`dbo.Finish`)_
- **Size Symbol** — A Trade-scoped symbol/adornment inserted when composing a size string; its `Position`
  (DiameterSuffix, OvalSuffix, RectangularSuffix, SizeSeparator, UnitSuffix) says where it goes.
  _(`dbo.SizeSymbol`, `SizeSymbolRecord`)_
- **Fabrication Pattern** — An Autodesk Fabrication pattern number (the pattern is "driven by Autodesk")
  naming a parametric fitting shape. _(`dbo.FabricationPattern`)_
- **Fabrication Pattern Option Type** — A named, indexed option slot belonging to a Fabrication Pattern.
- **Product Range** — A named + numbered **product-range classifier** used across catalog and Revit; gates
  spool eligibility and drives parameter defaults. _(`dbo.ProductRange`, `ProductRangeRecord`)_
- **Product Range Category** — A category within a Product Range.
- **Product Range Parameter Defaults** — Default parameter values (`Parameter` / `Value` / `ValueDataType`)
  scoped to a Product Range. _(`ProductRangeParameterDefaultsRecord`)_
- **Harrison Codes** — Cross-reference mapping JH Kelly component codes to Harrison Publishing House codes.
- **Product Id ↔ MCAA Id** — Cross-reference mapping JH Kelly product codes to **MCAA** labor-standard IDs.

---

## 4. Materials

- **Material Specification** — A material standard/spec (e.g. an ASTM designation) under a Material Code.
- **Material Code** — Short coded material family that groups specifications.
- **Material Type** — The physical material (Name, CommonName, Density, Shop Group) used for weight/gauge
  calculations.
- **Material Grade** — Material grade qualifier.
- **Material Group** — Broad material grouping bucket on a Component.
- **Material Configuration** (`Material.Configuration`) — A **normalized material configuration**: a unique
  combination of Material Type + Code + Specification + Grade (+ Shop Group), referenced by
  `Component.MaterialConfigurationId`.
- **Shop Group** — A shop routing/grouping for materials.
- **Gauge** — Sheet-metal **gauge**: a Name + Thickness tied to a Material Type (thickness must be > 0). Also
  carried on Revit parts as fabrication custom data (`JhkGauge`). _(`dbo.Gauge`, `GaugeRecord`)_
- **Material (with lookups)** — A fabrication Material joined to all its lookup codes as a single
  stored-procedure result. _(`MaterialAndLookupsViewRecord`)_

---

## 5. Connectors, welds & supports

How components join, terminate, and hang.

- **Connector** — The platform-wide canonical connector definition = **Domain + Group + Shape + Preparation**
  + Name. _(`dbo.Connector`)_
  - **Connector Domain / Group / Shape / Preparation** — The four lookup axes that compose a Connector
    (domain e.g. duct vs. pipe; group; geometric shape; end preparation).
- **Connector Mapping** — Encodes a fitting's **connector topology** as Run / RunTwo / Branch / BranchTwo
  connector IDs — i.e. how many ports a Component has and their roles. _(`dbo.ConnectorMapping`, `ConnectorMappingRecord`)_
- **Connector Grouping** — The **rule for ordering and joining connector sizes** into a size string:
  `Order` (RunByBranch / BranchByRun / ProductList), `Separator`, `PadSeparator`, `Example`.
  _(`dbo.ConnectorGrouping`, `ConnectorGroupingRecord`)_
- **Connector Preparation** — An end preparation for a connector, by domain/group/shape.
  _(`ConnectorPreparationsRecord`)_
- **Part Connector** — A connector/port on an exported **Part**, with full Fabrication connector metadata
  (Shape, Type, Size, Body Connector Id, Fabrication Index, IsPrimary/IsSecondary, Fabrication Name/Group/
  Domain/Shape). Sourced from the Revit API's `FabricationConnectorInfo`/`MepConnectorInfo`.
  _(`RevitExport.PartConnector`, `PartConnectorRecord`)_
- **Button Part Connector** — The connector belonging to a **Button Part**. _(`ButtonPartConnectorRecord`)_
- **End Preparation (Welded)** — Welded end-preparation types, with `CanHaveFieldTrim` / `HasFieldTrim`
  flags. _(`dbo.EndPreparationsWelded`)_
- **Weld Type** — A weld classification (Name, Abbreviation, Initialism) linkable to a Component.
  _(`dbo.WeldType`)_
- **Weld Location** — **Where** a weld occurs on piping: **Shop**, **Shop Tack**, **Field**, **Field Fit**,
  or **Field Fit Tack**. Each has its own KTR set-command. _(`Kelly-Revit` `WeldLocation…SetCommand`)_
- **Support Type** — A hanger/support classification (unique Name + Initialism) linkable to a Component.
  _(`dbo.SupportType`)_
- **Component Support Type / Component Weld Type** — Many-to-many link tables joining a Component to its
  allowed support types / weld types.
- **Anchor Info** — Anchor hardware reference data (Type, Thread Size, Manufacturer, Part Number,
  adjustment). _(`dbo.AnchorInfo`)_

---

## 6. Fabrication (Autodesk) integration

Mirrors of the Autodesk Fabrication (CADmep/ESTmep) data model.

- **Fabrication Configuration** — An Autodesk Fabrication configuration/database (Name + `Guid`); the root
  of the Fabrication spec/material hierarchy. Also referenced from a Project. _(`Fabrication.Configuration`,
  `ConfigurationRecord`)_
- **Specification Group → Specification** — A group of Fabrication specs, and an individual spec (which can
  link back to a catalog Main Class).
- **Fabrication Material** — A Fabrication material entry that links Fabrication's own grouping back to the
  catalog Material lookups.
- **Item Custom Data** — Per-item **custom data slots** keyed by `ItemPath` + `Index` holding a `Value` —
  Fabrication's custom item properties. _(`Fabrication.ItemCustomData`)_
- **Item Custom Data (pivoted on Component)** — The same custom data pivoted by Component Id
  (InternalIndex + Value). _(`ItemCustomDataPivotedOnComponentIdRecord`)_
- **Custom Item Data** (registry) — The named custom-data **slot registry** (`Index` + Name) that defines
  the item custom-property columns. _(`dbo.CustomItemData`)_
- **Fabrication Custom Data** — The KTR enum mapping numeric fabrication custom-data slots (#100–#117) to
  JH Kelly business fields — e.g. `JhkComponentId` (#105), `HpnCode`, `UpcCode`, `WeldType`, `JhkGauge`,
  `JhkSupportType`, `JhkMaterialType`, `JhkStratusPackage/Status/QrCode`. _(`Enums/FabricationCustomData.cs`)_
- **Custom Data Updater** — The **mapping spec** that drives writing those custom-data points from source
  fields (e.g. #105 → Component.Id, #101 → Product.HphCode). Points intentionally left unmapped are
  annotated as such. _(`CustomDataUpdaterRecord`)_
- **Stratus** — Integration with the **Stratus** fabrication platform; parts carry Stratus package / status /
  QR-code custom data, and there are Stratus detailing-package views. _(`StratusStatus`, KTR `Stratus…` commands)_

---

## 7. Estimating

- **Estimating Data** — A labor/cost record keyed by `Source` + `SourceId`, holding
  `WorkActivityMethodUnitRate` (maps to "JHK JLSW") and `ComponentMethodUnitRate` plus Size. Referenced by
  `Product.EstimatingDataId`. _(`Estimating.Data`)_
- **Product Code Link To Data** — A thin bridge relating a Product Code to an estimating Source/SourceId
  (import/link staging). _(`Estimating.ProductCodeLinkToData`)_
- **Unit Rate** — A per-unit cost/labor value. A Product carries an **Installation Unit Rate** and a
  **Fabrication Unit Rate**; estimating data carries work-activity and component-method unit rates.

---

## 8. Systems & Services

- **System** — The canonical **MEP system** definition: Name, Abbreviation, Discipline, Discipline Sub-Name,
  Layout Discipline, Layout Color (named + RGB + AutoCAD color index), and Activity Code. A
  **system-versioned temporal table** (`core.System_History` tracks history). _(`core.System`, `SystemRecord`)_
- **Service** — A subdivision of a System (same discipline/color/layout attributes, plus a `SystemId` and a
  Service Group). Structurally near-identical to System. **Naming note:** the table is `dbo.ServiceData` but
  the domain term is *Service* — an in-schema note marks it "rename from ServiceData to Service."
  _(`dbo.ServiceData`, `ServiceDataRecord`)_
- **Service Group** — A grouping of Services. _(`dbo.ServiceGroup`)_
- **Fabrication Service** — The MEP fabrication service a Revit part belongs to; a primary **attribution**
  and filter/scoping dimension in the add-in. _(Revit-Logic MEP models)_
- **Fabrication Service Scope** — Enum limiting a service operation to `All`, `AllUsed`, or `AllLoaded`
  services. _(`Kelly-Revit-Logic/src/Fabrication/FabricationServiceScope.cs`)_
- **Project To System** — Assigns a System (and a Fabrication Configuration) to a Project.
  _(`core.ProjectToSystem`, `ProjectToSystemRecord`)_

---

## 9. Projects, sessions & telemetry

- **Project** — A construction project: Number, Name, Address, General Contractor, Architect, Client,
  Market Sector, a Fabrication Configuration GUID, and **Rules of Credit** progress-billing decimals
  (Model / Issued-for-Construction / Construction Sign-Off). Flags include `IsActive` and `IsBimLite`.
  _(`dbo.Project`, `ProjectRecord`)_
- **Rules of Credit** — Progress-billing weightings on a Project marking how much credit each milestone
  (model complete, issued for construction, construction sign-off) earns.
- **Application Session** — Telemetry for **one run of the KTR add-in** inside Revit on a workstation:
  tool/Revit version, workstation hardware, start/stop, elapsed minutes. _(`dbo.ApplicationSession`,
  `ApplicationSessionRecord`)_
- **Project Session** — Telemetry for **one opened document** within an Application Session (Project,
  document title, time-to-open, elapsed minutes). _(`dbo.ProjectSession`, `ProjectSessionRecord`)_
- **Family Session** — Telemetry for a Revit **family** being opened/edited. _(`dbo.FamilySession`)_
- **Project Metrics / Project Metrics Log** — Definitions of project metrics and their logged time-series
  readings (Name, Value, Unit). _(`dbo.ProjectMetrics…`, `ProjectMetricsLogRecord`)_
- **Market** — Market-sector taxonomy (Sector / Sub-Sector) behind a Project's Market Sector.
  _(`dbo.Market`)_

---

## 10. Revit parameters & categories

- **External Parameter Definition** — KTR's **authoritative definition of a Revit shared parameter**
  (DefinitionGuid, DataType, group, storage/binding rules, unit, visibility, and deprecation flags), stored
  in SQL and loaded into the add-in. The C# `ExternalParameterDefinition` can insert/update/delete the
  matching `SharedParameterElement` and its category bindings in a document. The master registry
  (`dbo.ExternalParameterDefinitions`) is temporal and is the **canonical parameter dictionary**.
  _(`dbo.ExternalParameterDefinitions`, `ExternalParameterDefinitionRecord`, `Models/ExternalParameterDefinition.cs`)_
- **External Parameter Definition Usage** — Records where a parameter definition is read/written
  (Reads/Writes + deprecation intent). _(`dbo.ExternalParameterDefinitionUsage`)_
- **Built-In Category** — A Revit `BuiltInCategory` enum value mirrored into the DB/records with its
  `ElementId` and Name (plus category/parent metadata). Bridges Revit's built-ins into the data model.
  _(`dbo.BuiltInCategory`, `BuiltInCategoryRecord`, `Models/BuiltInCategoryWrapper.cs`)_
- **Built-In Category Metadata** — Extended, Revit-version-specific metadata for a category
  (allows-bound-parameters, sub-category, visibility, material quantities, parent).
  _(`BuiltInCategoryMetaRecord`)_
- **Built-In Category Wrapper / Category Wrapper** — Serializable stands-in for a Revit `BuiltInCategory` /
  `Category` that survive outside a live document and track `IsBound`. _(`Models/…Wrapper.cs`)_
- **Group Type Id** — Lookup of Revit parameter **group-type** identifiers, referenced by parameter
  definitions. _(`revit.GroupTypeId`, `GroupTypeIdRecord`)_
- **Forge Type Id / Forge Tools** — Helpers that resolve Revit's `ForgeTypeId` schema identifiers
  (parameter groups, spec types) by name. _(`Tools/ForgeTools.cs`)_
- **Re-Insert Model** — A value object bundling a Definition + Element Binding + ForgeTypeId with counts of
  categories erased/existed/inserted when re-inserting a parameter binding. _(`Models/ReInsertModel.cs`)_
- **Binding Scope / Element Binding Kind** — Whether a shared parameter binds at document scope and to
  **Instance** vs. **Type**.

---

## 11. Operations & transactions (the Revit-Logic engine)

The disciplined way every model change is made and audited.

- **Operation Service** — The project's **transaction orchestrator**. Wraps a Revit `Transaction` or
  `TransactionGroup`, tracks scope, counts modified objects, times the work, and on `Stop()` writes an audit
  record. This is the one sanctioned path for mutating a document. _(`Kelly-Revit-Logic/src/OperationService.cs`)_
- **Operation** — A single **audited unit of document change** managed by an Operation Service
  (Start → Increment → Stop / RollBack), named from the Transaction Name enum. _(`InstanceOperationRecord`)_
- **Transaction Kind** — Whether an Operation runs a `Standard` transaction or a `Group`
  (TransactionGroup that assimilates child transactions). _(enum)_
- **Transaction Name** — The enum enumerating **every named operation** the tools can perform (e.g.
  `CreateSpool`, `PlaceHanger`, `SleeveTag`, `ExtendTrapezeSupportRodsToStructure`), each mapping to a
  human-readable label. _(enum)_
- **Operation Change** — A single element-level change produced by an operation (ElementId, Type, Result,
  Success, Note). _(`OperationChangeRecord`)_
- **Operation Service Log** — The audit log of a service/operation run: durations, object counts
  (added/deleted/modified/selected), whether it was a Revit transaction, and status. _(`dbo.OperationServiceLog`,
  `OperationServiceLogRecord`)_
- **Scope / Initial Scope** — The operating scope of a command or operation: **Selection**, **View**, or
  **Document**. A command derives its Initial Scope on startup (Selection if elements are selected, else
  View). _(`ScopeType`, `CommandBase`)_
- **Command Base** — The abstract base for every KTR command (named Core Command, `CoreCommand`, until 2026-10-20); captures the UI application/document and
  derives the initial scope. _(Kelly-Revit-UI `src/Commands/CommandBase.cs`)_
- **Virtual Element** — The base pattern for a **domain model over a Revit element**: pairs a host element
  with model state, change tracking (`INotifyPropertyChanged`), scopes, and ownership (`IsOwnedByOthers`).
  _(`BaseClasses/VirtualElement.cs`, `IElementEntity`)_
- **Project Updaters Log** — Log of Revit **dynamic updater** firings per project session (UpdaterId GUID,
  fired/element counts, duration). _(`ProjectUpdatersLogRecord`)_
- **Updater** — KTR's Revit DMU (dynamic model updater) tools, runnable manually
  (on View/Selection/Document) or automatically. An updater's **default state** decides whether it is
  enabled when a document opens. _(`AutoUpdaterConfiguration`, `Development.Updaters`)_

---

## 12. MEP fabrication & detailing domain

The physical vocabulary detailers and fabricators actually speak.

- **Fabrication Part** — The core Revit MEP fabrication element; the KTR wrapper augments it with its end
  connectors. _(`Models/FabricationPartWrapper.cs`)_
- **Straight** — A **straight run** of fabrication pipe/duct. Modeled by `HangeredStraightModel`, which
  computes actual length and where hangers fall along it. _(`Models/HangeredStraightModel.cs`)_
- **Hanger** — A support element that suspends a straight. **Hanger Placement** distributes hangers along a
  straight using near/far/repeat intervals; a **Hanger Location** records a placed hanger, its order, and its
  distance from the connector. _(`Models/HangerLocation.cs`, `Models/HangerPlaceSettings.cs`)_
- **Trapeze** — A trapeze-style support carrying multiple services. Its **vertical members**
  (`TrapezeVerticalMember`) — the support rods — can be **extended to structure** or reset.
  _(KTR `TrapezeSupportRods…`, `TrapezeVerticalMemberExtend…`)_
- **Support Elevation** — The `JHK Support Elevation` shared-parameter value on a support. (Setting it
  records the value; it does **not** physically move the support.)
- **Suspended Support** — A hung support whose elevation, vertical-member extension, and size are managed by
  KTR commands.
- **Rod** — A support rod (as on a trapeze or hanger); "extend rods to structure" is a signature operation.
- **Olet** — A branch-outlet fitting (weldolet/threadolet, `ItemCustomId 2875`) modeled as a run/"pipe"
  connector plus a branch connector; tracks pipe size, branch size, service, and **tap alignment**.
  _(`Models/Physical/Olet.cs`)_
  - **Olet Tap Connector Status** — An olet tap's condition on the run pipe: `Connected`, `Disconnected`, or
    `MisAligned`.
- **Spool** — A **fabrication spool**: a grouping of parts released together for shop fabrication. KTR
  create/rename/clean/manage tooling enforces rules that remove non-spoolable parts or parts with an invalid
  Product Range. _(KTR `SpoolCreate`, `SpoolManager`, `SpoolCleaner`; `SpoolNumberRecord`)_
- **Spool Number** — The identifier assigned to a spool. _(`SpoolNumberRecord` — JSON/in-memory backed)_
- **Module** — A higher-level **prefabricated assembly** grouping, with its own Module Number (prefix + type
  + sequence). _(KTR `ModuleCreator…`; `ModuleNumberRecord`)_
- **Module Number** — The identifier assigned to a module. _(`ModuleNumberRecord`)_
- **Line Number** — A **piping line** identifier, used as an attribution/filter dimension.
  _(`LineNumberRecord`)_
- **Penetration / Sleeve** — A wall/floor **penetration** and its **sleeve**; KTR tags both.
  _(KTR `PenetrationTagAssign`, `SleeveTag`)_
- **Bill of Material (BOM)** — Material-takeoff attribution assignable at **Shop**, **Field**, or **Module**
  scope. _(KTR `modules/AllTrade/Commands/BillOfMaterial/`)_
- **Detailing Package** — A named **detailing attribution/grouping** of elements (its own color set and
  add/remove/adopt/update operations); drives Stratus detailing-package views. _(`DetailingPackageRecord`)_
- **Connector Type End** — Wraps a Revit `Connector` with its end position (near/far classification of a
  part). _(`Models/ConnectorTypeEnd.cs`)_
- **Layout Point / Grid Layout Point** — Field **layout coordinate points** saved on elements,
  importable/exportable to CSV and placeable on a grid. _(KTR `LayoutPoint…`, `LayoutGridPoint…`)_
- **BIM Lite** — A toggled **lightweight-model mode**. _(`Project.IsBimLite`, `TransactionName.ToggleBimLite`)_

---

## 13. The Assigner concept (a major command family)

- **Assigner** — A UI-driven tool that **assigns a domain attribution value** to selected fabrication
  elements and can generate matching view filters. Each Assigner offers Value Assign/Unassign, ComboBox
  Adopt/Reset, an Auto-Set toggle, and Line-color / Fill-color / Isolate / Hide filter operations.
- **Assigner Contexts** — The **attribution dimensions** detailers assign with Assigners: **Service**,
  **System**, **Spool Number**, **Module Number**, **Line Number**, and **Detailing Package**. Each is a
  `…Context` under `modules/AllTrade/Commands/Assigners/`.
- **Attribution** — The general act of stamping one of the above dimensions onto elements so they can be
  grouped, colored, filtered, and reported.

---

## 14. Views, filters & spool sheets

- **View Filter Factory** — Builds or reuses a named `ParameterFilterElement`, adds shared-parameter filter
  rules, and applies graphic overrides (line/surface color, halftone, transparency) to a view. The engine
  behind every "…ViewFilter" command. _(`Tools/ViewFilterFactory.cs`)_
- **Filter Rule Model** — A single colorized filter rule (index, name, rule type, value, color).
  _(`Models/FilterRuleModels/FilterRuleModel.cs`)_
- **Kelly View Type** — The enum classifying KTR detail views by purpose: **Working (VTW)**,
  **Printing (VTP)**, **Install (VTI)**, **Setup (VTS)**, **Navisworks (VTN)**, **Layout (VTL)**,
  **Hanger (VTH)**. _(`Enums/KellyViewType.cs`)_
- **Spool Sheet / View Configuration** — The family of `SpoolSheet…` / `Spool11X17…` classes defining the
  plan/front/left/3D detail viewports and the BOM/MTR/length/weight/weld schedules laid out on a spool sheet.
  _(`Models/ViewConfigurations/`)_

---

## 15. Users, roles & the ribbon

- **User** — A JH Kelly person/employee: names, work email (unique), Autodesk login, trade, reports-to
  hierarchy, and lead/tradesperson/active flags. _(`dbo.User`, `UserRecord`)_
- **User Role** — A role within a context/department (Context + Role, ordering, reports-to lookup).
  _(`department.UserRole`, `UserRoleRecord`)_
- **User Responsibility** — A Verb-Noun-Preposition-Noun **responsibility phrase** (e.g. "Detail … for …")
  with a computed activity name, linked to roles and activity codes. _(`department.UserResponsibility`)_
- **Activity Code** — A division/activity **cost code** (Code, Div Code, Act Code, Discipline, Activity).
  Also carried on Systems and Services. _(`department.ActivityCodes`)_
- **Work Station** — Workstation hardware inventory (Make/Model/Processor/RAM/Graphics). _(`department.WorkStations`)_
- **Ribbon Tab** — A Revit ribbon **tab** definition (ClassName, Title, Scope, order, enabled/visible/
  in-production flags). _(`revit.RibbonTab`, `RibbonTabRecord`)_
- **Ribbon Panel** — A **panel** within a ribbon tab. _(`revit.RibbonPanel`, `RibbonPanelRecord`)_
- **Ribbon Panel ↔ User Role** — Role-gating that controls **which roles see which panels**.
  _(`revit.RibbonPanelLinkToUserRole`, `RibbonPanelLinkToUserRoleRecord`)_
- **Command Enabler / Availability** — `Is…` / `Does…` classes (e.g. `IsSingleElementSelectedCommandEnabler`,
  `IsLayoutViewTypeCommandEnabler`, `DoesClipboardHaveElementIds`) that gate whether a ribbon button is
  enabled. _(`Application/RibbonItems/PushButtons/ExternalCommandAvailability/`)_

---

## 16. Data-quality & validation ("checks")

- **Component Product Check** — A **QA/reconciliation record** comparing a Revit element's embedded
  Component Id / Product Code (fabrication custom data #105 + shared parameters) against the catalog's
  expected values, with correctness flags (`IsProductCodePrefixedCorrectly`, `IsProductCodeSchemaCorrect`)
  and an "OK to update" gate. _(`RevitExport.ComponentProductCheck`, `ComponentProductCheckRecord`)_
- **Component Product Check (Temp)** — The staging variant capturing whether the custom-property and
  shared-parameter writes actually occurred. _(`RevitExport.ComponentProductCheckTemp`, `…TempRecord`)_
- **Scenario Check** — A batch-scoped audit comparing Fabrication vs. JHK product codes and component IDs
  (schema/prefix correctness, extraneous-lookup detection), keyed by Username + Timestamp Batch.
  _(`ScenarioCheckRecord`)_

---

## 17. Naming conventions (so a name tells you what a thing is)

### Revit commands
> **Object/Subject + Context/Scope + Verb + `Command`**, abbreviations spelled out.
> Examples: `WeldLocationShopSetCommand`, `BillOfMaterialFieldSetCommand`,
> `TrapezeVerticalMemberExtendCommand`, `LayoutPointFromCommaSeparatedValueImportCommand`,
> `SpoolCleanByViewCommand`.

Each command sits in its own folder, extends **Command Base**, implements `IExternalCommandBase`, and is
usually paired with a `…CommandPushButton` and a `…CommandEnabler`.

**Recurring command categories** (one KTR module per ribbon tab, each with its own `Commands/` folder, since
2026-10-13): **AllTrade** (Tools tab; formerly **MultiTrade**, and including **Acquired**, the third-party-derived tools —
notably the **Vicious** set and the **Arrange** align/distribute/untangle tools), **PipeTrade** (Pipe tab; formerly
**Piping**), **DuctTrade** (Duct tab; formerly **Duct**), **Contenter**, **Manager**, **Developer** and **Detailer**.

### Entity records (data layer)
> `{TableOrView}Record` — e.g. `ProductRecord`, `ButtonPartRecord`. All implement `IRecord` (an `int Id`).

### Stored procedures
- **`USP_`** — production procedure. Two coexisting styles: entity-first (`USP_System_SelectAll`) and
  object-kind-tagged (`USP_Table_Product_ReadAll`, `USP_View_ComponentAndLookups_ReadAll`).
- **Action verbs read as a phrase:** `SelectAll` / `ReadAll` (Select and Read are synonyms across two eras);
  `SelectWhere<Col>Equals[Parameter]` / `ReadWhere<Col>EqualsParameter`; `CreateOne` / `Insert`;
  `UpdateWhere…Equals`; `DeleteWhere…` / `DeleteOrphans`. Compound predicates spell each column with `And`.
- **Version suffix `_vYYYYMMDD`** — a dated, side-by-side copy (new versions are added, not edited in place).
  Deprecation is stamped in the name too (`_Deprecated2025.07.30`).
- **`DEVUSP_` / `DEVSP_`** — developer procedures (often maintenance/destructive). **`VCS_Update_…`** —
  trigger-invoked procs that populate derived Component fields. Lowercase **`usp_`** — generic utilities.

### Views
Prefixed **`v`** + a purpose tag: **`vProd_`** (production), **`vDev_`** (development/analysis),
**`vQual_`** / **`vQA_`** (data-quality & QA checks — duplicates, missing data), **`vCIP_`**
(work-in-progress copies).

### Tables
- Almost every production table: `Id INT IDENTITY` PK (`PK_<Table>_Id`) + audit columns `UpdatedUtc` /
  `UpdatedBy` maintained by a `Tr_<Table>_UpdatedBy` trigger.
- **Temporal tables** (`RowStartUtc` / `RowEndUtc`, `SYSTEM_VERSIONING = ON` → `_History`): `core.System`,
  `dbo.ServiceData`, `dbo.ExternalParameterDefinitions`, `Estimating.Data`.
- **Junction tables**: `Linker<A>And<B>` (content `dbo`) or `<A>LinkTo<B>` (general schema).
- **Transitional columns**: `_Temp` (in migration), `_Deprecated` / `Redundant` (on the way out).

---

## 18. Initialisms & abbreviations

| Term | Means |
|---|---|
| **KTR** | Kelly Tools for Revit (the add-in suite) |
| **VCS** | Versioned schema — the SQL database projects backing KTR |
| **JHK / Jhk** | JH Kelly; as a column prefix, "the JH Kelly-normalized value" |
| **MEP** | Mechanical, Electrical & Plumbing |
| **BOM** | Bill of Material |
| **MTR** | Material Test Report (spool-sheet schedule) |
| **MCAA** | Mechanical Contractors Association of America (labor standards) |
| **DMU** | Dynamic Model Updater (Revit) |
| **USP** | User Stored Procedure |
| **VTW / VTP / VTI / VTS / VTN / VTL / VTH** | Kelly View Types: Working / Printing / Install / Setup / Navisworks / Layout / Hanger |
| **UPC / HPH / HPN** | External product codes carried on a Product / custom data |
| **BIM Lite** | Lightweight-model mode |

---

## 19. Terms in flux (renames & migrations in progress)

Keep these front-of-mind — the code and the spoken language are mid-move:

- **`ServiceData` → `Service`** — the table keeps the old name; the domain term is *Service*.
- **`Product.FabricationIdCalc` → `ProductCode`** — a schema note asks to rename it "to better align with
  future Revit family implementation."
- **Record models relocated** from `Kelly.Revit.Logic.Models.IRecords` into `Kelly.Windows.Data` so any
  consumer (not just the Revit tooling) can share them.
- **`_Temp` / `_Deprecated` / `Redundant`** columns mark values respectively being migrated in or retired.
- Some **Custom Data points are intentionally unmapped** (annotated "Not Mapped Per 2026.07.21 Meeting") —
  absence there is a decision, not an oversight.

---

*Maintained internally by JH Kelly. When you add a term to the code, the ribbon, or the database, add it
here — and, where it's an enum or initialism, to the `dbo.Terminology` table too.*
