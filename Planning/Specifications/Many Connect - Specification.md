# Many Connect: specification

Written 2026-11-10 from the KTR v5 source (`Kelly-Revit-v5` build 5.26.1109.1419). The goal is that someone who has never seen the code can rebuild the tool from this document alone and get the same behaviour. Section 9 lists the acceptance checks a rebuild must pass.

Normative words: **must** is required for a faithful rebuild; **should** is how the original does it, and a rebuild may differ where it says so.

## 1. Purpose

Many Connect lets a user join MEP elements one pair at a time without dragging them into place. The user picks a first element (it stays put) and a second element (a family instance, such as a fitting, that moves). The tool finds the pair of open connectors on the two elements that face each other and are closest together, moves the second element so its connector lands on the first element's connector, and connects them. It then asks for the next pair, until the user presses Esc.

## 2. Where it lives

| Item | Value |
|---|---|
| Ribbon location | Kelly Tools tab, General panel, the `BasicToolsSplitButton` (fourth item: after the Vicious fabrication hanger place, instance level assign and instance elevation assign (Racker) buttons; before Disconnect and Rotate; Point To Pipe follows a separator). The split button shows the last item used. |
| Button text | `Many Connect` (the constant `ManyConnect`, title-cased) |
| Tooltip | "Pick a pipe, duct, conduit, tray or fitting with an open connector, then a fitting or other family instance: moves the second onto the first's nearest facing open connector and connects them, asking first if they don't line up exactly. Repeats until you press Esc." |
| Icons | `ManyConnect16.png` and `ManyConnect32.png`, embedded resources of the module |
| Availability | Always enabled (no availability class) |
| Module | Trade.All (`Kelly-Revit-v5/modules/Trade.All/Commands/ManyConnect/`) |
| Command class | `ManyConnectCommand`, `internal sealed`, `[Transaction(TransactionMode.Manual)]`, derives from `CommandBase` and implements `IExternalCommandBase` |
| Push button class | `ManyConnectPushButton`, `internal sealed`, derives from `RibbonPushButton`, implements `IRibbonPushButton`; sets `ImageName`, `Text`, `ToolTip` and `Type` in its constructor |

The command uses shared code from the layers below rather than its own helpers (section 7).

## 3. Terms

- **Connector**: a Revit `Connector` of an element, read from the element's connector manager. Every connector type counts (End, Curve, Physical, Logical...); the tool does not filter by type.
- **Open connector**: a connector whose `IsConnected` is false.
- **Z axis of a connector**: `CoordinateSystem.BasisZ`, normalized. It points out of the element.
- **Facing**: two connectors face each other when the dot product of their Z axes is less than −0.99 (the axes are within about 8.1° of exactly opposite).
- **Aligned exactly**: the angle between the two Z axes, in degrees, is strictly greater than 180 − 0.125 = 179.875°. The angle is `acos` of the dot product, with the dot product clamped to [−1, 1] first.

## 4. Workflow

```
start: initialise the command (active UI document required)
loop:
    pick FIRST element   (filter A)      — Esc or failure → end, Succeeded
    pick SECOND element  (filter B)      — Esc, failure or not a FamilyInstance → end, Succeeded
    find closest facing open connector pair (a on FIRST, b on SECOND)
    if no pair  → show "Unable to connect" dialog, go to loop
    if pair not aligned exactly → ask "Connector Angle Report"; No → go to loop
    move SECOND by (a.Origin − b.Origin) and connect a to b, in one transaction
    go to loop
```

### 4.1 Start

1. Store the command data, the UI application and the active `UIDocument` (`CommandBase.InitializeCommand`).
2. With no active UI document, throw `InvalidOperationException("There is no active Revit document. Open a project and try again.")`. The add-in's command framework reports it.
3. A selection already made in Revit is not used. Picking always starts fresh.

### 4.2 First pick

- Prompt in the status bar: **"Pick an element having an open connector"**.
- Object type: whole elements (`ObjectType.Element`); references (faces, edges) are never allowed.
- **Filter A** allows an element when, after checking the element is not null and still valid (throws `ArgumentNullException` otherwise):
  - it has a category (no category → not allowed), and
  - its built-in category is one of Fabrication Containment, Fabrication Ductwork, Fabrication Pipework, Pipes (`OST_PipeCurves`), Ducts (`OST_DuctCurves`), Conduits, Cable Trays or Sprinklers, and it has at least one open connector; **or**
  - it is any `FamilyInstance` with at least one open connector.
- Esc, or any exception from the pick, or a reference with an invalid element id, means "no element": the loop ends and the command returns `Result.Succeeded` without a message.

### 4.3 Second pick

- Same prompt text and object type as the first pick.
- **Filter B** allows only a `FamilyInstance` with at least one open connector (after the same null and validity check). Pipes, ducts, conduits, trays and fabrication parts that are not family instances cannot be picked second.
- Esc, failure, or a picked element that is not a `FamilyInstance` ends the loop and the command returns `Result.Succeeded`. The first pick is simply dropped; nothing was changed.
- The tool does **not** check that the second element differs from the first. Picking the same family instance twice is allowed, and the pair search then runs on that one element's connectors.

### 4.4 Find the connector pair

For every open connector `a` of the first element and every open connector `b` of the second element (null entries skipped), keep the pair whose origins are nearest each other (`a.Origin.DistanceTo(b.Origin)`) among the pairs that face each other (section 3). On equal distances the first pair found, in connector order, is kept. Distance is measured before anything moves.

Connector sets are read through the element's connector manager. An element without a category or without a connector manager has none.

If no facing pair exists, show a plain Revit `TaskDialog`:

- Title: **Many Connect**
- Text: "Unable to connect these elements.\n\nA pair of 'closest facing' connectors could not be found."

Then go back to the first pick. Nothing is changed.

### 4.5 Confirm when not aligned exactly

If the pair faces each other but is **not** aligned exactly (angle ≤ 179.875°), ask before connecting, through the add-in's prompt seam (`Kelly.Windows.Prompts.UserPrompt.Show`), never a Revit dialog directly:

| PromptRequest field | Value |
|---|---|
| Title | `Connector Angle Report` |
| AutoPrefixTitle | true (the host may put the application name in front) |
| Buttons | Yes and No |
| DefaultButton | No |
| Icon | Warning |
| AllowCancellation | false |
| MainInstruction | the text below |

MainInstruction, lines joined by line breaks (a trailing line break follows the last line):

```
The 'closest facing' connectors of the selected elements don't align exactly.

Element Ids Involved
<TAB><id of the element owning a>
<TAB><id of the element owning b>

Continue connecting these two elements?
```

- **No** → skip this pair, go back to the first pick.
- **Yes**, any other answer, or no response at all (null) → connect.

Pairs aligned exactly connect without a question. The tolerance is the confirmation method's default of 0.125°: the caller passes no tolerance. (Before 2026-11-09 the caller passed 1e-10°, so almost every pair asked; KTR5-4775.)

### 4.6 Move and connect

One Revit transaction per pair, through the add-in's `OperationService`:

- Kind Standard, name `TransactionName.AnyConnect`, shown to the user as **"Any Connect"**, scope Selection. (The name is "Any Connect", not "Many Connect"; keep it.)
- On commit the transaction name gets the count of connections made appended, so the undo list shows **"Any Connect (1)"**, or **"Any Connect (0)"** when the connection failed.
- Each operation appends one record to the project's operation log (`OperationServiceLog.jsonl` in the project data folder: name, duration, status, counts, scope, user). A failure to write the log is ignored.

Inside the transaction:

1. Move the element that owns `b` by the vector `a.Origin − b.Origin` (`ElementTransformUtils.MoveElement`). The second element is only translated, never rotated.
2. Connect `a` to `b` (`a.ConnectTo(b)`).
3. If `a.IsConnectedTo(b)`, count one modified object.
4. Otherwise show a warning (`TaskDialogSimple.TaskDialogWarning`): main text **"Failed to connect the selected connectors."**, detail "There was an issue connecting the selected connectors. Element One: <id of a's owner>, Element Two: <id of b's owner>".
5. Any exception inside steps 1 to 4 goes to the add-in's standard exception handler (`HandleIt`, which shows and logs it); the loop carries on.
6. The transaction is **committed in every case** (`finally`). So when the connection fails, or an exception is thrown after the move, the move is kept. The user undoes it with Ctrl+Z if wanted.

Revit failure messages raised by the commit follow Revit's normal handling (the tool adds no failure preprocessor).

If the transaction cannot start (the document is not modifiable, for example), show the Error prompt titled **"Transaction Failed To Start Notification"**: "The transaction named Any Connect failed to start." / "As a result, no changes were made to the Revit document." Then go back to the first pick.

### 4.7 End

The command ends only when a pick is cancelled or fails (4.2, 4.3). It always returns `Result.Succeeded` and never sets `message`. Each connected pair is its own undo step; there is no transaction group around the whole session.

## 5. Messages

| When | Kind | Title | Text |
|---|---|---|---|
| Each pick | Status bar prompt | – | Pick an element having an open connector |
| No facing pair | Revit TaskDialog | Many Connect | Unable to connect these elements. / A pair of 'closest facing' connectors could not be found. |
| Pair facing but not exact | UserPrompt, Warning, Yes/No, default No | Connector Angle Report | section 4.5 |
| Connect did not take | Warning dialog | (TaskDialogSimple warning) | Failed to connect the selected connectors. / There was an issue connecting... Element One: …, Element Two: … |
| Transaction would not start | UserPrompt, Error | Transaction Failed To Start Notification | The transaction named Any Connect failed to start. / As a result, no changes were made to the Revit document. |
| No active document | Exception | – | There is no active Revit document. Open a project and try again. |

## 6. Numbers

| Constant | Value | Meaning |
|---|---|---|
| Facing tolerance (dot product) | 0.99 | `dot(Za, Zb) < −0.99` → facing (about 8.1° from opposite) |
| Exact-alignment tolerance | 0.125° | angle > 179.875° → no question |
| Move vector | `a.Origin − b.Origin` | second element only, translation only |

## 7. Shared code the tool uses

A rebuild in the Kelly stack should use these rather than writing its own; a standalone rebuild must reproduce their behaviour as described above.

| Member | Layer | Used for |
|---|---|---|
| `CommandBase.InitializeCommand` | Kelly.Revit.UI `Commands` | 4.1 |
| `ConnectorPickTools.PickElementWithUnusedConnector(ISelectionFilter, UIDocument)` | Kelly.Revit.UI `Selection` | 4.2, 4.3 (returns null on any failure) |
| `StraightOrFamilyInstanceHavingConnectorsSelectionFilter` | Kelly.Revit.UI `Selection` | filter A |
| `FamilyInstanceHavingConnectorsSelectionFilter` | Kelly.Revit.UI `Selection` | filter B |
| `ConnectorTools.IsStraightOrFamilyInstanceHavingUnusedConnector`, `IsFamilyInstanceHavingUnusedConnector` | Kelly.Revit.Logic `Connectors` | the filters' tests |
| `ConnectorTools.FindClosestFacingConnectors(first, second, 0.99)` | Kelly.Revit.Logic `Connectors` | 4.4 |
| `ConnectorTools.AreFacingEachOther`, `GetAngleBetweenDegrees`, `AreFacingWithinTolerance` | Kelly.Revit.Logic `Connectors` | section 3 |
| `ConnectorTools.MoveAndConnectTx(document, a, b)` | Kelly.Revit.Logic `Connectors` | 4.6 (throws `ArgumentNullException` for a null argument) |
| `ElementExtensions.GetConnectors(Element)` | Kelly.Revit.Logic `Elements` | connector sets |
| `OperationService`, `TransactionName.AnyConnect` | Kelly.Revit.Logic `Operations` | 4.6 |
| `UserPrompt.Show(PromptRequest)` | Kelly.Windows `Prompts` | 4.5, 4.6 |

The command keeps two private static helpers: `ConfirmConnectionIfNotPerfect(Connector a, Connector b, double toleranceDeg = .125)` builds the report and returns true when aligned exactly, and `ConfirmConnectorAngle(string mainInstruction)` shows the prompt and returns false only for No. The existing test reads the tolerance default by reflection, so a rebuild that keeps the test must keep that method name, its `NonPublic | Static` binding and the default of 0.125 as its third parameter.

## 8. Rules a rebuild follows (repository rules)

- Every type in its own file; namespace `Kelly.Revit.Trade.All.Commands.ManyConnect` matching the folder.
- No `//` comments; XML docs on members.
- Prompts go through `UserPrompt`, not `TaskDialog`, for anything a test must answer. (The original still uses a direct `TaskDialog` for the "Unable to connect" message; a rebuild may keep that or route it through `UserPrompt` with the same title and text.)
- Every member has an NUnit test with `Author = "Verified By Human On:"` and a `Description` saying what it checks.
- Changes to the add-in go into `Kelly-Revit-v5/Changelog.md` under a dated heading.

## 9. Acceptance checks

A rebuild is faithful when every check below holds. "Pipe" means a straight with an open end; "elbow" a pipe fitting family instance with open ends.

| # | Setup and action | Expected |
|---|---|---|
| 1 | Ribbon | Many Connect appears in the Basic Tools split button of the General panel, fourth item, with the tooltip of section 2, enabled in every view. |
| 2 | Start, press Esc at the first pick | Command ends, nothing changes, no dialog. |
| 3 | Hover a wall, a fully connected pipe, a pipe with no category | Not pickable at the first pick. |
| 4 | Hover an open pipe, duct, conduit, cable tray, fabrication part, sprinkler, or any family instance with an open connector | Pickable at the first pick. |
| 5 | First pick done; hover a pipe or a fabrication straight at the second pick | Not pickable (only family instances). |
| 6 | First pick done; press Esc at the second pick | Command ends, nothing changes. |
| 7 | Pipe end pointing +X; elbow with an open connector pointing −X a few feet away | Elbow moves so its connector origin equals the pipe connector's origin; the two are connected; no question; undo list shows "Any Connect (1)"; the tool asks for the next first pick. |
| 8 | As 7, elbow connector rotated 1° off opposite | "Connector Angle Report" asks, default No. No → nothing moves, back to the first pick. Yes → moves and connects as in 7. |
| 9 | As 7, elbow connector 0.1° off opposite | Connects without a question (inside 0.125°). |
| 10 | As 7, elbow connector 20° off opposite (not facing) and no other facing pair | "Many Connect" dialog "Unable to connect these elements..."; nothing moves; back to the first pick. |
| 11 | Elbow with two open connectors that both face the pipe end | The connector nearest the pipe's connector is used. |
| 12 | First element has two open connectors facing the elbow | The pair with the shortest origin-to-origin distance is used; ties go to the first found. |
| 13 | Connect a pair whose sizes or domains Revit refuses to join | Warning "Failed to connect the selected connectors." naming both ids; the elbow stays moved; undo list shows "Any Connect (0)". |
| 14 | Read-only or non-modifiable document | "Transaction Failed To Start Notification" error; nothing changes; the loop goes on. |
| 15 | Three pairs connected, then Esc | Three separate undo steps; the command returns Succeeded. |
| 16 | Each operation | One record appended to `OperationServiceLog.jsonl` in the project data folder. |
| 17 | Unit test `ManyConnectCommandTests.Execute_UsesTheDefaultTolerance` | Passes: the call is `ConfirmConnectionIfNotPerfect(closestA, closestB)` and the default tolerance is 0.125. |

## 10. Known quirks (kept as they are, not requirements to fix)

- The transaction is named "Any Connect" while the tool is "Many Connect".
- A failed connection, or an exception after the move, still commits the move.
- The same family instance can be picked as both first and second element.
- The second element is translated only; if the facing pair is up to about 8° off, the result is a slightly crooked joint (the user was asked first, from 0.125° up).
- The first pick's filter accepts any family instance, so a fitting can be the fixed element and another fitting the moving one.
- An existing Revit selection is ignored.
