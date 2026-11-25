#!/usr/bin/env bash
# Writes the Kelly ribbon icon masters in the Assigners pane line style (KTR5-4844). Usage: icon-masters.sh <svg folder>
# Every icon is drawn once on a 16-unit grid. <Name>.16.svg renders at 16 px with 1.5 px ink strokes;
# <Name>.svg renders at 32 px with 2.2 px ink strokes. A badge (bottom right) is cut out of the object.
set -euo pipefail
out="$1"; mkdir -p "$out"

INK='#2F2F2F'; ACC='#016043'; RED='#DC3545'

expand() {
  local s="$1" iw="$2" aw="$3"
  local common='fill="none" stroke-linecap="round" stroke-linejoin="round"'
  s="${s//\{I\}/$common stroke=\"$INK\" stroke-width=\"$iw\"}"
  s="${s//\{IT\}/$common stroke=\"$INK\" stroke-width=\"$iw\" stroke-opacity=\"0.4\"}"
  s="${s//\{ID\}/$common stroke=\"$INK\" stroke-width=\"$iw\" stroke-dasharray=\"1.6 1.9\"}"
  s="${s//\{A\}/$common stroke=\"$ACC\" stroke-width=\"$aw\"}"
  s="${s//\{AD\}/$common stroke=\"$ACC\" stroke-width=\"$aw\" stroke-dasharray=\"1.6 1.9\"}"
  s="${s//\{R\}/$common stroke=\"$RED\" stroke-width=\"$aw\"}"
  s="${s//\{IF\}/fill=\"$INK\"}"
  s="${s//\{AF\}/fill=\"$ACC\"}"
  s="${s//\{RF\}/fill=\"$RED\"}"
  s="${s//\{K\}/fill=\"#000000\"}"
  s="${s//\{KS\}/fill=\"none\" stroke=\"#000000\" stroke-linecap=\"round\" stroke-width=\"$((0))\"}"
  printf '%s' "$s"
}

# icon <Name> <object> [badge] [knockout]
icon() {
  local name="$1" obj="$2" badge="${3:-}" knock="${4:-}"
  [ -n "$badge" ] && [ -z "$knock" ] && knock='<circle {K} cx="11.5" cy="11.5" r="4.9"/>'
  local size iw aw file
  for size in 32 16; do
    if [ $size = 16 ]; then iw=1.5; aw=1.75; file="$out/$name.16.svg"; else iw=1.1; aw=1.3; file="$out/$name.svg"; fi
    {
      printf '<svg xmlns="http://www.w3.org/2000/svg" width="%s" height="%s" viewBox="0 0 16 16">' $size $size
      if [ -n "$knock" ]; then
        printf '<defs><mask id="cut" maskUnits="userSpaceOnUse" x="0" y="0" width="16" height="16"><rect x="0" y="0" width="16" height="16" fill="#FFFFFF"/>%s</mask></defs>' "$(expand "$knock" $iw $aw)"
        printf '<g id="object" mask="url(#cut)">%s</g>' "$(expand "$obj" $iw $aw)"
      else
        printf '<g id="object">%s</g>' "$(expand "$obj" $iw $aw)"
      fi
      [ -n "$badge" ] && printf '<g id="action">%s</g>' "$(expand "$badge" $iw $aw)"
      printf '</svg>\n'
    } > "$file"
  done
}

# ---------- Badges (centred on 11.5,11.5) ----------
B_PLUS='<path {A} d="M11.5,8.5 V14.5 M8.5,11.5 H14.5"/>'
B_RUN='<path {A} d="M14.5,11.5 A3,3 0 1 1 11.5,8.5 M10.1,7.2 L11.6,8.5 L10.1,9.8"/>'
B_UP='<path {A} d="M11.5,14.75 V8.5 M9,11 L11.5,8.5 L14,11"/>'
B_DOWN='<path {A} d="M11.5,8.25 V14.5 M9,12 L11.5,14.5 L14,12"/>'
B_CHECK='<path {A} d="M8.5,11.75 L10.75,14 L14.75,9.25"/>'
B_X='<path {R} d="M9,9 L14,14 M14,9 L9,14"/>'
B_MINUS='<path {R} d="M8.5,11.5 H14.5"/>'
B_GEAR='<circle {A} cx="11.5" cy="11.5" r="1.9"/><path {A} d="M11.5,8 V8.9 M11.5,14.1 V15 M8,11.5 H8.9 M14.1,11.5 H15 M9.05,9.05 L9.65,9.65 M13.35,13.35 L13.95,13.95 M13.95,9.05 L13.35,9.65 M9.65,13.35 L9.05,13.95"/>'
B_PENCIL='<path {A} d="M8.75,14.5 L9.1,12.4 L13,8.5 L14.75,10.25 L10.85,14.15 Z M12,9.5 L13.75,11.25"/>'
B_TARGET='<circle {A} cx="11.5" cy="11.5" r="2.4"/><path {A} d="M11.5,7.75 V9.1 M11.5,13.9 V15.25 M7.75,11.5 H9.1 M13.9,11.5 H15.25"/><circle {AF} cx="11.5" cy="11.5" r="0.8"/>'
B_FLASK='<path {A} d="M10,8.25 H13 M10.5,8.25 V10.4 L8.7,13.9 Q8.4,14.75 9.3,14.75 H13.7 Q14.6,14.75 14.3,13.9 L12.5,10.4 V8.25"/>'
B_TAG='<path {A} d="M8.5,9.25 H12.4 L14.75,11.5 L12.4,13.75 H8.5 Z"/><circle {AF} cx="10.25" cy="11.5" r="0.75"/>'
B_PIN='<path {A} d="M11.5,15 C10.2,13.6 8.75,12.1 8.75,10.6 A2.75,2.75 0 0 1 14.25,10.6 C14.25,12.1 12.8,13.6 11.5,15 Z"/><circle {AF} cx="11.5" cy="10.6" r="0.85"/>'
B_FACTORY='<path {A} d="M8.5,14.5 V10.5 L10.5,9 V10.5 L12.5,9 V10.5 L14.5,9 V14.5 Z"/>'
B_GRID='<path {A} d="M8.75,8.75 H14.25 V14.25 H8.75 Z M11.5,8.75 V14.25 M8.75,11.5 H14.25"/>'

# ---------- Objects ----------
O_DOC='<path {I} d="M2.5,1.5 H8.5 L11.5,4.5 V14.5 H2.5 Z M8.5,1.5 V4.5 H11.5"/><path {I} d="M4.75,7.5 H9.25 M4.75,10 H9.25 M4.75,12.5 H7"/>'
O_DOCWIDE='<path {I} d="M3,1.5 H9.5 L12.5,4.5 V14.5 H3 Z M9.5,1.5 V4.5 H12.5"/><path {A} d="M5.25,7.5 H10.25 M5.25,10 H10.25 M5.25,12.5 H8.5"/>'
O_CUBE='<path {I} d="M6.5,1.5 L11.5,4.25 V9.75 L6.5,12.5 L1.5,9.75 V4.25 Z M1.5,4.25 L6.5,7 L11.5,4.25 M6.5,7 V12.5"/>'
O_MODULE='<path {I} d="M1.5,2.5 H11.5 V11.5 H1.5 Z M1.5,7 H11.5 M6.5,2.5 V11.5"/><path {I} d="M3,11.5 V13.5 M10,11.5 V13.5"/>'
O_VIEW='<rect {I} x="1.5" y="2.5" width="11" height="9" rx="0.75"/><path {I} d="M3.5,9.5 L6,6.5 L7.75,8.25 L8.75,7.25 L10.5,9.5"/><circle {IF} cx="9.5" cy="5" r="0.9"/>'
O_MARQUEE='<rect {ID} x="1.5" y="1.5" width="11" height="11"/><rect {I} x="4.75" y="4.75" width="4.5" height="4.5"/>'
O_FUNNEL='<path {I} d="M1.5,2 H12.5 L8.25,7 V11.5 L5.75,13 V7 Z"/>'
O_DB='<ellipse {I} cx="6.5" cy="3.5" rx="4.75" ry="1.9"/><path {I} d="M1.75,3.5 V12 A4.75,1.9 0 0 0 11.25,12 V3.5 M1.75,7.75 A4.75,1.9 0 0 0 11.25,7.75"/>'
O_FOLDER='<path {I} d="M1.5,3.25 A0.75,0.75 0 0 1 2.25,2.5 H5.75 L7.25,4 H13.75 A0.75,0.75 0 0 1 14.5,4.75 V12.75 A0.75,0.75 0 0 1 13.75,13.5 H2.25 A0.75,0.75 0 0 1 1.5,12.75 Z"/>'
O_FOLDER_ACC="$O_FOLDER"'<path {A} d="M1.5,6.25 H14.5"/>'
O_SPHERE='<circle {I} cx="6.5" cy="6.5" r="5"/><path {I} d="M3.9,5.4 A2.9,2.9 0 0 1 6.2,3.4"/><ellipse {I} cx="6.5" cy="6.5" rx="5" ry="1.6" stroke-opacity="0.5"/>'
O_GLOBE='<circle {I} cx="6.5" cy="6.5" r="5"/><ellipse {I} cx="6.5" cy="6.5" rx="2.1" ry="5"/><path {I} d="M1.5,6.5 H11.5"/>'
O_FAMILY='<rect {I} x="1.5" y="1.5" width="10" height="10" rx="0.75"/><rect {I} x="4.25" y="4.25" width="4.5" height="4.5"/>'
O_LIST='<path {I} d="M2,2.5 H2.5 M5,2.5 H11.5 M4.5,6 H5 M7.5,6 H11.5 M4.5,9.5 H5 M7.5,9.5 H9 M2,13 H2.5 M5,13 H6.5"/>'
O_SCHEDULE='<rect {I} x="1.5" y="2" width="11" height="11" rx="0.75"/><path {I} d="M1.5,5 H12.5 M5.25,5 V13 M1.5,8 H12.5 M1.5,10.75 H12.5"/>'
O_PEOPLE='<circle {I} cx="5" cy="4.5" r="2"/><path {I} d="M1.5,12.5 V11.5 A3.5,3.5 0 0 1 8.5,11.5 V12.5"/><circle {I} cx="10.25" cy="3.75" r="1.6"/><path {I} d="M9.5,7.4 A3,3 0 0 1 13.25,9"/>'
O_AXES='<path {I} d="M2.5,1.5 V12 H13"/><path {I} d="M1.25,2.9 L2.5,1.5 L3.75,2.9 M11.6,10.75 L13,12 L11.6,13.25"/><path {I} d="M2.5,12 L7.5,7"/>'
O_BRACES='<path {I} d="M5,1.5 C3.75,1.5 3.5,2.25 3.5,3.5 V5.25 C3.5,6.25 2.75,7 1.5,7 C2.75,7 3.5,7.75 3.5,8.75 V10.5 C3.5,11.75 3.75,12.5 5,12.5 M8,1.5 C9.25,1.5 9.5,2.25 9.5,3.5 V5.25 C9.5,6.25 10.25,7 11.5,7 C10.25,7 9.5,7.75 9.5,8.75 V10.5 C9.5,11.75 9.25,12.5 8,12.5"/>'
O_ELEMENTS='<rect {I} x="1.5" y="1.5" width="4.25" height="4.25" rx="0.5"/><rect {I} x="7.75" y="1.5" width="4.25" height="4.25" rx="0.5"/><rect {I} x="1.5" y="7.75" width="4.25" height="4.25" rx="0.5"/>'
O_BUTTON='<rect {I} x="1.5" y="1.5" width="11" height="11" rx="2.5"/><rect {IT} x="4.5" y="4.5" width="5" height="5" rx="0.5"/>'
O_CLIP='<path {I} d="M5,3 H3.25 A0.75,0.75 0 0 0 2.5,3.75 V14 A0.75,0.75 0 0 0 3.25,14.75 H12.75 A0.75,0.75 0 0 0 13.5,14 V3.75 A0.75,0.75 0 0 0 12.75,3 H11"/><rect {I} x="5" y="1.5" width="6" height="3" rx="0.75"/>'
O_CAL='<rect {I} x="1.5" y="3" width="11" height="9.5" rx="0.75"/><path {I} d="M1.5,6 H12.5 M4.25,1.5 V4.25 M9.75,1.5 V4.25"/><path {I} d="M4,8.5 H4.5 M6.75,8.5 H7.25 M9.5,8.5 H10 M4,10.5 H4.5"/>'
O_DUCT='<path {I} d="M1.5,4 H11 V9.5 H1.5 Z M3.25,2.75 V10.75 M9.25,2.75 V10.75"/>'
O_DUCTRUN='<path {I} d="M1,4 H6.5 V9 H1 Z M6.5,4 H12 V9 H6.5 Z M6.5,2.75 V10.25 M1,2.75 V10.25 M12,2.75 V10.25"/>'
O_POINT='<circle {I} cx="6.5" cy="6.5" r="3.25"/><path {I} d="M6.5,1 V3.25 M6.5,9.75 V12 M1,6.5 H3.25 M9.75,6.5 H12"/><circle {AF} cx="6.5" cy="6.5" r="1.1"/>'
O_GRIDPOINTS='<path {I} d="M4.25,1 V13 M1,4.25 H13 M10.25,1 V7 M1,10.25 H7"/><circle {A} cx="4.25" cy="4.25" r="1.75"/><circle {A} cx="10.25" cy="4.25" r="1.75"/><circle {A} cx="4.25" cy="10.25" r="1.75"/>'
O_HANGER='<path {I} d="M6.5,1.25 V4 M6.5,4 L2.5,8 A4,4 0 0 0 10.5,8 L6.5,4"/><circle {I} cx="6.5" cy="8.25" r="2.25"/>'
O_SLEEVE='<circle {I} cx="6.5" cy="6.5" r="5"/><circle {I} cx="6.5" cy="6.5" r="2.5"/>'
O_TRAPEZE='<path {I} d="M3,1.5 V10.5 M10,1.5 V10.5 M1.5,10 H11.5"/><circle {I} cx="6.5" cy="7.6" r="2.15"/>'
O_PIPE_END='<path {I} d="M1.5,4 H9.5 M1.5,9 H9.5 M9.5,2.75 V10.25"/>'

O_FOLDER_ACC="$O_FOLDER"'<path {I} d="M1.5,6 H14.5"/>'
O_SPHERE='<circle {I} cx="6.5" cy="6.5" r="5"/><path {I} d="M3.75,5.5 A3,3 0 0 1 6.25,3.4"/>'
O_LIST='<rect {IF} x="1.5" y="1.75" width="2" height="2" rx="0.4"/><rect {IF} x="4" y="5.25" width="2" height="2" rx="0.4"/><rect {IF} x="4" y="8.75" width="2" height="2" rx="0.4"/><rect {IF} x="1.5" y="12.25" width="2" height="2" rx="0.4"/><path {I} d="M5.5,2.75 H12.5 M8,6.25 H12.5 M8,9.75 H9 M5.5,13.25 H6.5"/>'
O_DUCT='<path {I} d="M1.5,4 H11 V9.5 H1.5 Z M3.25,3 V10.5 M9.25,3 V10.5"/>'
O_DUCTRUN='<path {I} d="M1,4 H12 V9 H1 Z M6.5,3 V10 M1,3 V10 M12,3 V10"/>'
O_GRIDPOINTS='<path {I} d="M4.25,1 V13 M1,4.25 H13 M10.25,1 V7 M1,10.25 H7"/><circle {AF} cx="4.25" cy="4.25" r="1.4"/><circle {AF} cx="10.25" cy="4.25" r="1.4"/><circle {AF} cx="4.25" cy="10.25" r="1.4"/>'
O_HANGER='<path {I} d="M6.5,1.25 V3.5 M2.75,3.5 H10.25 M2.75,3.5 V8 A3.75,3.75 0 0 0 10.25,8 V3.5"/><circle {A} cx="6.5" cy="8" r="2"/>'
O_TRAPEZE='<path {I} d="M2.5,1.5 V10 M9.5,1.5 V10 M1.25,9.5 H10.75"/><circle {I} cx="6" cy="7.25" r="2"/>'
O_PIPE_END='<path {I} d="M1.5,3.5 H9.5 M1.5,8.5 H9.5"/><path {A} d="M9.75,2 V10"/>'
# ---------- Icons ----------
# Arranger (tags and text notes)
icon ArrangerAlignLeft   '<path {A} d="M2,1.5 V14.5"/><rect {I} x="4.25" y="3" width="9.5" height="3.5" rx="0.75"/><rect {I} x="4.25" y="9.5" width="6" height="3.5" rx="0.75"/>'
icon ArrangerAlignRight  '<path {A} d="M14,1.5 V14.5"/><rect {I} x="2.25" y="3" width="9.5" height="3.5" rx="0.75"/><rect {I} x="5.75" y="9.5" width="6" height="3.5" rx="0.75"/>'
icon ArrangerAlignCenter '<path {A} d="M8,1 V15"/><rect {I} x="3" y="3" width="10" height="3.5" rx="0.75"/><rect {I} x="5" y="9.5" width="6" height="3.5" rx="0.75"/>'
icon ArrangerAlignTop    '<path {A} d="M1.5,2 H14.5"/><rect {I} x="3" y="4.25" width="3.5" height="9.5" rx="0.75"/><rect {I} x="9.5" y="4.25" width="3.5" height="6" rx="0.75"/>'
icon ArrangerAlignBottom '<path {A} d="M1.5,14 H14.5"/><rect {I} x="3" y="2.25" width="3.5" height="9.5" rx="0.75"/><rect {I} x="9.5" y="5.75" width="3.5" height="6" rx="0.75"/>'
icon ArrangerAlignMiddle '<path {A} d="M1,8 H15"/><rect {I} x="3" y="3" width="3.5" height="10" rx="0.75"/><rect {I} x="9.5" y="5" width="3.5" height="6" rx="0.75"/>'
icon ArrangerDistributeHorizontally '<rect {I} x="1.5" y="2" width="2.75" height="8.5" rx="0.6"/><rect {I} x="6.625" y="3.5" width="2.75" height="5.5" rx="0.6"/><rect {I} x="11.75" y="1.5" width="2.75" height="9.5" rx="0.6"/><path {A} d="M4.25,13.5 H6.625 M9.375,13.5 H11.75 M4.25,12.25 V14.75 M6.625,12.25 V14.75 M9.375,12.25 V14.75 M11.75,12.25 V14.75"/>'
icon ArrangerDistributeVertically '<rect {I} x="2" y="1.5" width="8.5" height="2.75" rx="0.6"/><rect {I} x="3.5" y="6.625" width="5.5" height="2.75" rx="0.6"/><rect {I} x="1.5" y="11.75" width="9.5" height="2.75" rx="0.6"/><path {A} d="M13.5,4.25 V6.625 M13.5,9.375 V11.75 M12.25,4.25 H14.75 M12.25,6.625 H14.75 M12.25,9.375 H14.75 M12.25,11.75 H14.75"/>'
icon ArrangerUntangleHorizontally '<path {I} d="M1.5,1.5 H14.5 V5.5 H1.5 Z M5.83,1.5 V5.5 M10.17,1.5 V5.5"/><path {A} d="M3.67,5.5 L2.5,12.75 M8,5.5 V12.75 M12.33,5.5 L13.5,12.75"/><circle {AF} cx="2.5" cy="13.25" r="1.25"/><circle {AF} cx="8" cy="13.25" r="1.25"/><circle {AF} cx="13.5" cy="13.25" r="1.25"/>'
icon ArrangerUntangleVertically '<path {I} d="M9.5,1.5 H14.5 V14.5 H9.5 Z M9.5,5.83 H14.5 M9.5,10.17 H14.5"/><path {A} d="M9.5,3.67 L3,2.5 M9.5,8 H3 M9.5,12.33 L3,13.5"/><circle {AF} cx="2.5" cy="2.5" r="1.25"/><circle {AF} cx="2.5" cy="8" r="1.25"/><circle {AF} cx="2.5" cy="13.5" r="1.25"/>'
icon ArrangerAround '<rect {ID} x="1" y="1" width="14" height="14"/><rect {I} x="1.75" y="3" width="3.5" height="2.5" rx="0.5"/><rect {I} x="1.75" y="10.5" width="3.5" height="2.5" rx="0.5"/><rect {I} x="10.75" y="3" width="3.5" height="2.5" rx="0.5"/><rect {I} x="10.75" y="10.5" width="3.5" height="2.5" rx="0.5"/><path {A} d="M5.25,4.25 L7,7 M5.25,11.75 L7,9 M10.75,4.25 L9,7 M10.75,11.75 L9,9"/><rect {IF} x="6.75" y="6.75" width="2.5" height="2.5" rx="0.4"/>'

# Assigners
icon AssignerPane '<rect {I} x="1.5" y="2" width="13" height="12" rx="1"/><path {I} d="M1.5,4.75 H14.5 M8.75,4.75 V14"/><path {A} d="M10.5,7.25 H12.75 M10.5,9.5 H12.75 M10.5,11.75 H12.75"/>'
icon ContextAdopt '<circle {I} cx="8" cy="8" r="5"/><path {I} d="M8,1 V4.5 M8,11.5 V15 M1,8 H4.5 M11.5,8 H15"/><circle {AF} cx="8" cy="8" r="1.9"/>'
icon ContextReset '<path {I} d="M1.5,3 H7 M1.5,7.5 H5.5 M1.5,12 H5.5"/><path {A} d="M8.5,6.5 H11.75 A3,3 0 0 1 11.75,12.5 H8.5 M10.5,4.5 L8.5,6.5 L10.5,8.5"/>'
icon ContextAutoAssign '<path {I} d="M1.5,2 H8 L11,5 L8,8 H1.5 Z"/><circle {IF} cx="4.25" cy="5" r="1"/><path {A} d="M14.25,12 A2.75,2.75 0 1 1 11.5,9.25 M10.1,7.9 L11.6,9.25 L10.1,10.6"/>'
icon ContextAddTo '<path {I} d="M5.5,5.75 V1.5 H10.25 L14,5.25 V14.5 H5.5 V12.25 M10.25,1.5 V5.25 H14"/><path {A} d="M1.25,9 H10 M7.5,6.5 L10,9 L7.5,11.5"/>'
icon ContextRemoveFrom '<path {I} d="M5.5,5.75 V1.5 H10.25 L14,5.25 V14.5 H5.5 V12.25 M10.25,1.5 V5.25 H14"/><path {R} d="M10,9 H1.25 M3.75,6.5 L1.25,9 L3.75,11.5"/>'
icon ObjectIsolate '<path {I} d="M1,8 C3,4.25 5.5,3 8,3 C10.5,3 13,4.25 15,8 C13,11.75 10.5,13 8,13 C5.5,13 3,11.75 1,8 Z"/><circle {AF} cx="8" cy="8" r="2.6"/><circle fill="#FFFFFF" cx="8.9" cy="7.1" r="0.8"/>'
icon ObjectHide '<path {I} d="M1,8 C3,4.25 5.5,3 8,3 C10.5,3 13,4.25 15,8 C13,11.75 10.5,13 8,13 C5.5,13 3,11.75 1,8 Z"/><circle {IF} cx="8" cy="8" r="2.25"/>' '<path {A} d="M2.5,14 L13.5,2"/>' '<path fill="none" stroke="#000000" stroke-width="4" stroke-linecap="round" d="M2.5,14 L13.5,2"/>'
icon PowerOn  '<path {A} d="M5,3.6 A5.5,5.5 0 1 0 11,3.6 M8,1.5 V7.75"/>'
icon PowerOff '<path {IT} d="M5,3.6 A5.5,5.5 0 1 0 11,3.6 M8,1.5 V7.75"/>'

# BOM type: a parts list with where it is built
O_BOM='<path {I} d="M2.5,1.5 H8.5 L11.5,4.5 V14.5 H2.5 Z M8.5,1.5 V4.5 H11.5"/><path {I} d="M4.5,7 H5 M6.75,7 H9.5 M4.5,9.75 H5 M6.75,9.75 H9.5 M4.5,12.5 H5"/>'
icon BillOfMaterialTypeField  "$O_BOM" "$B_PIN"
icon BillOfMaterialTypeShop   "$O_BOM" "$B_FACTORY"
icon BillOfMaterialTypeModule "$O_BOM" "$B_GRID"

# Data, files and folders
icon DataReload       "$O_DB" "$B_RUN"
icon DatabaseDownload "$O_DB" "$B_DOWN"
icon DirectoryWithGerry "$O_FOLDER_ACC"
icon LayoutPointDirectoryOpen "$O_FOLDER" "$B_TARGET"
icon ReportExport     "$O_DOC" "$B_UP"
icon ViewLogs         "$O_DOCWIDE"
icon ProjectInformationEdit "$O_DOC" "$B_PENCIL"
icon Version          "$O_CAL" "$B_PENCIL"

# Reports (Developer)
icon CategoriesReport "$O_LIST" "$B_UP"
icon FiltersReport    "$O_FUNNEL" "$B_UP"
icon MaterialsReport  "$O_SPHERE" "$B_UP"
icon UserReport       "$O_PEOPLE" "$B_UP"
icon FamilyParameterReport "$O_FAMILY" "$B_UP"
icon ClipboardIds     "$O_CLIP"'<path {A} d="M5.5,8 H10.5 M5.5,10.5 H10.5 M5.5,13 H8.5"/>'

# Developer tests
icon AvailabilityProbe "$O_BUTTON" "$B_FLASK"
icon CollectorTest     "$O_ELEMENTS" "$B_FLASK"
icon CoordinateTest    "$O_AXES" "$B_FLASK"
icon Sandbox           "$O_BRACES" "$B_FLASK"
icon FieldTrimEndSelect "$O_PIPE_END" "$B_FLASK"

# Purges and deletes
icon Broom '<path {I} d="M14.5,1.5 L8.75,7.25"/><path {I} d="M9.5,6.5 L4.25,8.75 L1.5,13.75 L2.25,14.5 L7.25,11.75 L9.5,6.5 Z"/><path {R} d="M3.5,11.25 L1.75,13 M5.5,10.75 L3,14.25 M7,9.75 L4.75,13.25"/>'
icon ExtensibleStorageDelete "$O_DB" "$B_X"
icon FamilyMaterialsPurge "$O_SPHERE" "$B_MINUS"
icon ViewFilterRemove "$O_FUNNEL" "$B_X"
icon ViewFilterApply  "$O_FUNNEL" "$B_PLUS"
icon Nuke '<path {RF} d="M9.15,9.99 L11.25,13.63 A6.5,6.5 0 0 1 4.75,13.63 L6.85,9.99 A2.3,2.3 0 0 0 9.15,9.99 Z M5.7,8 L1.5,8 A6.5,6.5 0 0 1 4.75,2.37 L6.85,6.01 A2.3,2.3 0 0 0 5.7,8 Z M9.15,6.01 L11.25,2.37 A6.5,6.5 0 0 1 14.5,8 L10.3,8 A2.3,2.3 0 0 0 9.15,6.01 Z"/><circle {RF} cx="8" cy="8" r="1.3"/>'

# Locations
icon CoordinatesElement "$O_CUBE" "$B_TARGET"
icon CoordinatesProject "$O_GLOBE" "$B_TARGET"

# Updaters
icon UpdaterRunDocument  "$O_DOC" "$B_RUN"
icon UpdaterRunSelection "$O_MARQUEE" "$B_RUN"
icon UpdaterRunView      "$O_VIEW" "$B_RUN"

# Spools and modules
icon SpoolCreator  "$O_CUBE" "$B_PLUS"
icon SpoolCleaner  "$O_CUBE" "$B_MINUS"
icon SpoolManager  "$O_CUBE" "$B_GEAR"
icon ModuleCreator "$O_MODULE" "$B_PLUS"
icon ModuleManager "$O_MODULE" "$B_GEAR"
icon OpenMultipleViews '<path {I} d="M4.5,3.5 V1.5 H14.5 V10 H12.5"/><rect {I} x="1.5" y="4.5" width="11" height="10" rx="0.5"/><path {A} d="M1.5,11.5 H12.5 M8.5,11.5 V14.5"/>'
icon StratusDetailingPackageViews "$O_VIEW" "$B_GRID"
icon ProductRangeSchedules "$O_SCHEDULE" "$B_PLUS"

# Layout points
icon LayoutPointExporter "$O_POINT" "$B_UP"
icon LayoutPointImporter "$O_POINT" "$B_DOWN"
icon PlaceGridLayoutPoint "$O_GRIDPOINTS" "$B_PLUS"
icon UpdateGridLayoutPoints "$O_GRIDPOINTS" "$B_RUN"

# Modeling
icon DisconnectElement '<path {I} d="M1.5,3 H5.5 M1.5,9 H5.5 M5.5,1.75 V10.25 M14.5,3 H10.5 M14.5,9 H10.5 M10.5,1.75 V10.25"/><path {A} d="M3,13.5 H13 M4.75,11.75 L3,13.5 L4.75,15.25 M11.25,11.75 L13,13.5 L11.25,15.25"/>'
icon ManyConnect '<path {I} d="M1.5,4 H6 M1.5,12 H6 M6,2.75 V13.25"/><path {I} d="M10.5,2.75 V13.25 M10.5,4 H14.5 M10.5,12 H14.5"/><path {A} d="M9.25,8 H6.75 M8,6.5 L6.5,8 L8,9.5"/>'
icon LevelCorrect '<path {I} d="M1.5,3.5 L3,2 L4.5,3.5 L3,5 Z M5.5,3.5 H14.5 M1.5,13 L3,11.5 L4.5,13 L3,14.5 Z M5.5,13 H14.5"/><rect {I} x="9.5" y="5.75" width="4" height="3.25" rx="0.4"/><path {A} d="M7.25,5.75 V11 M5.75,9.5 L7.25,11 L8.75,9.5"/>'
icon PointToPipe '<path {I} d="M2.5,13 L6.5,4 L13.5,9.5"/><path {I} d="M2.5,13 L6.5,4 L13.5,9.5" stroke-opacity="0.25" transform="translate(0.9,0.6)"/><circle {AF} cx="2.5" cy="13" r="1.6"/><circle {AF} cx="6.5" cy="4" r="1.6"/><circle {AF} cx="13.5" cy="9.5" r="1.6"/>'
icon Racker '<circle {I} cx="5" cy="8" r="3.75"/><circle {I} cx="11.75" cy="9.5" r="2.25"/><path {A} d="M1,12.75 H15"/>'
icon Rotate '<path {I} d="M3.5,6.25 L8,3 L10.75,6.75 L6.25,10 Z"/><path {A} d="M14.25,8 A6.25,6.25 0 0 1 3,12.25 M3,12.25 L5.4,12.6 M3,12.25 L3.4,9.9"/>'
icon HangerPlace "$O_HANGER" "$B_PLUS"
icon SleeveTagger "$O_SLEEVE" "$B_TAG"
icon SupportTagger "$O_TRAPEZE" "$B_TAG"
icon Trapeze-Rods-Extend '<path {I} d="M1.5,1.75 H14.5"/><path {I} d="M1.5,12.5 H14.5"/><circle {I} cx="8" cy="10.25" r="1.75"/><path {A} d="M4,12.5 V2.75 M12,12.5 V2.75 M2.6,4.25 L4,2.75 L5.4,4.25 M10.6,4.25 L12,2.75 L13.4,4.25"/>'
icon Trapeze-Rods-Reset '<path {I} d="M1.5,1.75 H14.5"/><path {I} d="M1.5,12.5 H14.5 M4,12.5 V8.5 M12,12.5 V8.5"/><circle {I} cx="8" cy="10.25" r="1.75"/><path {A} d="M4,3.5 V7 M2.6,5.6 L4,7 L5.4,5.6 M12,3.5 V7 M10.6,5.6 L12,7 L13.4,5.6"/>'
icon ViewParametersSet "$O_VIEW" "$B_PENCIL"

# Duct
icon DuctItemNumberSet    "$O_DUCT" "$B_PENCIL"
icon DuctRunItemNumberSet "$O_DUCTRUN" "$B_PENCIL"
icon DuctItemNumberReset  "$O_DUCT" "$B_X"
icon DuctLengthCheck '<path {I} d="M1.5,6 H11 V11 H1.5 Z M3.25,5 V12 M9.25,5 V12"/><path {I} d="M1.5,2.75 H11 M1.5,1.5 V4 M11,1.5 V4"/>' "$B_CHECK"
icon DuctMirrorCheck '<path {AD} d="M7,1 V13"/><path {I} d="M1.5,10.5 L5.5,3 V10.5 Z M12.5,10.5 L8.5,3 V10.5 Z"/>' "$B_CHECK"

# Pipe
icon OletCheck '<path {I} d="M1.5,7 H13 M1.5,12 H13"/><path {I} d="M4,7 L4.75,4.25 H9.25 L10,7 M5.5,4.25 V1.5 M8.5,4.25 V1.5"/>' "$B_CHECK"
icon ValveClearanceSphere '<circle {AD} cx="8" cy="8" r="6.75"/><path {I} d="M4,6 V11.5 L12,6 V11.5 Z M8,8.75 V4 M6.25,4 H9.75"/>'
icon WeldStrike '<path {I} d="M1.5,4 H6.25 M1.5,12 H6.25 M14.5,4 H9.75 M14.5,12 H9.75"/><rect {AF} x="6.5" y="3" width="3" height="10" rx="1.2"/>'

# Revisions after the first review
icon Broom '<path {I} d="M14.5,1.5 L9.25,6.75"/><path {I} d="M7.75,5.25 L10.75,8.25 L9.75,9.25 L5,14.5 H1.5 V11 L6.75,6.25 Z"/><path {R} d="M3.5,12.5 L7.25,8.75 M5.5,13 L8.5,10"/>'
icon ArrangerAround '<rect {ID} x="1" y="1" width="14" height="14"/><rect {I} x="1.75" y="3" width="4" height="3" rx="0.5"/><rect {I} x="10.25" y="10" width="4" height="3" rx="0.5"/><path {A} d="M5.75,4.5 L7,7 M10.25,11.5 L9,9"/><rect {IF} x="6.5" y="6.5" width="3" height="3" rx="0.4"/>'
icon ArrangerDistributeHorizontally '<rect {I} x="1.5" y="2" width="2.75" height="8.5" rx="0.6"/><rect {I} x="6.625" y="3.5" width="2.75" height="5.5" rx="0.6"/><rect {I} x="11.75" y="1.5" width="2.75" height="9.5" rx="0.6"/><path {A} d="M4.75,13.75 H6.125 M9.875,13.75 H11.25"/>'
icon ArrangerDistributeVertically '<rect {I} x="2" y="1.5" width="8.5" height="2.75" rx="0.6"/><rect {I} x="3.5" y="6.625" width="5.5" height="2.75" rx="0.6"/><rect {I} x="1.5" y="11.75" width="9.5" height="2.75" rx="0.6"/><path {A} d="M13.75,4.75 V6.125 M13.75,9.875 V11.25"/>'
icon Rotate '<path {I} d="M4.75,5.75 L8.5,3.25 L11,7 L7.25,9.5 Z"/><path {A} d="M14,8.5 A6.25,6.25 0 0 1 2.25,10.5 M1.1,8.4 L2.25,10.5 L4.4,9.5"/>'
O_DUCT='<path {I} d="M1.5,4 H11 M1.5,9.5 H11 M1.5,2.75 V10.75 M11,2.75 V10.75"/>'
O_DUCTRUN='<path {I} d="M1,4 H12.5 M1,9.5 H12.5 M1,2.75 V10.75 M6.75,2.75 V10.75 M12.5,2.75 V10.75"/>'
icon Rotate '<path {I} d="M5.75,7 L9,5.75 L10.25,9 L7,10.25 Z"/><path {A} d="M13.5,8 A5.5,5.5 0 1 1 11.9,4.1 M11.4,1.77 L11.9,4.1 L9.57,3.61"/>'
icon DuctItemNumberSet    "$O_DUCT" "$B_PENCIL"
icon DuctRunItemNumberSet "$O_DUCTRUN" "$B_PENCIL"
icon DuctItemNumberReset  "$O_DUCT" "$B_X"
icon DuctLengthCheck '<path {I} d="M1.5,6.5 H11 M1.5,11.5 H11 M1.5,5.25 V12.75 M11,5.25 V12.75"/><path {I} d="M1.5,2.25 H11 M1.5,1 V3.5 M11,1 V3.5"/>' "$B_CHECK"
ls "$out" | wc -l
