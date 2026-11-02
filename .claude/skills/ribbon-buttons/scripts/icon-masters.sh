#!/usr/bin/env bash
# Writes the 32px and 16px SVG masters: an object (slate gray) with an action badge cut out of it.
set -euo pipefail
out="$1"; mkdir -p "$out"
# Objects in the ribbon's slate grays; every action badge in JHK green (jhkelly.com #016043), destructive ones in the site's red.
O='#5E6F80'; d='#8A97A4'; G='#016043'; T="$G"; W="$G"; R='#DC3545'

# Badges and the knockout each cuts from its object
b32_run="<g id=\"action-run\" fill=\"$G\"><path d=\"M14.27 19.93A8 8 0 0 1 27.66 16.34L25.89 18.11A5.5 5.5 0 0 0 16.69 20.58Z\"/><path d=\"M24.83 19.17L29.07 14.93L28.97 21.39Z\"/><path d=\"M29.73 24.07A8 8 0 0 1 16.34 27.66L18.11 25.89A5.5 5.5 0 0 0 27.31 23.42Z\"/><path d=\"M19.17 24.83L14.93 29.07L15.03 22.61Z\"/></g>"
k32_run="<circle fill=\"#000000\" cx=\"22\" cy=\"22\" r=\"10.5\"/>"
b16_run="<g id=\"action-run\" fill=\"$G\"><path d=\"M15 10.5A4.5 4.5 0 1 1 10.5 6L10.5 8A2.5 2.5 0 1 0 13 10.5Z\"/><path d=\"M10.5 4.5L10.5 9.5L13.5 7Z\"/></g>"
k16_run="<circle fill=\"#000000\" cx=\"10.5\" cy=\"10.5\" r=\"5.5\"/>"

b32_export="<path id=\"action-export\" fill=\"$W\" fill-rule=\"evenodd\" d=\"M22 14A8 8 0 1 1 21.99 14Z M22 16.5L27 21.5H23.5V27.5H20.5V21.5H17Z\"/>"
k32_export="<circle fill=\"#000000\" cx=\"22\" cy=\"22\" r=\"10\"/>"
b16_export="<path id=\"action-export\" fill=\"$W\" fill-rule=\"evenodd\" d=\"M11 6.5A4.5 4.5 0 1 1 10.99 6.5Z M11 7.6L13.6 10.4H11.8V13.6H10.2V10.4H8.4Z\"/>"
k16_export="<circle fill=\"#000000\" cx=\"11\" cy=\"11\" r=\"5.5\"/>"

b32_delete="<path id=\"action-delete\" fill=\"$R\" d=\"M17 15.5L22 20.5L27 15.5L28.5 17L23.5 22L28.5 27L27 28.5L22 23.5L17 28.5L15.5 27L20.5 22L15.5 17Z\"/>"
k32_delete="<circle fill=\"#000000\" cx=\"22\" cy=\"22\" r=\"9.5\"/>"
b16_delete="<path id=\"action-delete\" fill=\"$R\" d=\"M8 7L11 10L14 7L15 8L12 11L15 14L14 15L11 12L8 15L7 14L10 11L7 8Z\"/>"
k16_delete="<circle fill=\"#000000\" cx=\"11\" cy=\"11\" r=\"5.5\"/>"

b32_remove="<path id=\"action-remove\" fill=\"$R\" fill-rule=\"evenodd\" d=\"M22 14A8 8 0 1 1 21.99 14Z M17 20.5H27V23.5H17Z\"/>"
k32_remove="$k32_export"
b16_remove="<path id=\"action-remove\" fill=\"$R\" fill-rule=\"evenodd\" d=\"M11 6.5A4.5 4.5 0 1 1 10.99 6.5Z M8 10.2H14V11.8H8Z\"/>"
k16_remove="$k16_export"

b32_plus="<path id=\"action-create\" fill=\"$G\" d=\"M20.5 15H23.5V20.5H29V23.5H23.5V29H20.5V23.5H15V20.5H20.5Z\"/>"
k32_plus="<circle fill=\"#000000\" cx=\"22\" cy=\"22\" r=\"9.5\"/>"
b16_plus="<path id=\"action-create\" fill=\"$G\" d=\"M10.2 7H11.8V10.2H15V11.8H11.8V15H10.2V11.8H7V10.2H10.2Z\"/>"
k16_plus="<circle fill=\"#000000\" cx=\"11\" cy=\"11\" r=\"5.5\"/>"

b32_pencil="<path id=\"action-edit\" fill=\"$T\" d=\"M25.5 14L30 18.5L19.5 29H15V24.5Z\"/>"
k32_pencil="<circle fill=\"#000000\" cx=\"22\" cy=\"22\" r=\"10.5\"/>"
b16_pencil="<path id=\"action-edit\" fill=\"$T\" d=\"M13 6.5L15.5 9L10 14.5H7.5V12Z\"/>"
k16_pencil="<circle fill=\"#000000\" cx=\"11\" cy=\"11\" r=\"5.5\"/>"

b32_target="<g id=\"action-locate\" fill=\"$T\"><path fill-rule=\"evenodd\" d=\"M22 16A6 6 0 1 1 21.99 16Z M22 18A4 4 0 1 0 22.01 18Z\"/><rect x=\"21\" y=\"13.5\" width=\"2\" height=\"2.5\"/><rect x=\"21\" y=\"28\" width=\"2\" height=\"2.5\"/><rect x=\"13.5\" y=\"21\" width=\"2.5\" height=\"2\"/><rect x=\"28\" y=\"21\" width=\"2.5\" height=\"2\"/><rect x=\"21\" y=\"21\" width=\"2\" height=\"2\"/></g>"
k32_target="<circle fill=\"#000000\" cx=\"22\" cy=\"22\" r=\"10\"/>"
b16_target="<g id=\"action-locate\" fill=\"$T\"><path fill-rule=\"evenodd\" d=\"M11 7.5A3.5 3.5 0 1 1 10.99 7.5Z M11 8.7A2.3 2.3 0 1 0 11.01 8.7Z\"/><rect x=\"10.5\" y=\"5.5\" width=\"1\" height=\"1.5\"/><rect x=\"10.5\" y=\"15\" width=\"1\" height=\"1\"/><rect x=\"5.5\" y=\"10.5\" width=\"1.5\" height=\"1\"/><rect x=\"15\" y=\"10.5\" width=\"1\" height=\"1\"/><rect x=\"10.5\" y=\"10.5\" width=\"1\" height=\"1\"/></g>"
k16_target="<circle fill=\"#000000\" cx=\"11\" cy=\"11\" r=\"5.5\"/>"

flask32="M19 14H25V16H24V19.5L29.3 27.8C30 28.9 29.3 30 28 30H16C14.7 30 14 28.9 14.7 27.8L20 19.5V16H19Z"
flask16="M8.5 7H13.5V8H12.8V9.8L15.3 14C15.6 14.6 15.3 15 14.7 15H7.3C6.7 15 6.4 14.6 6.7 14L9.2 9.8V8H8.5Z"
b32_test="<path id=\"action-test\" fill=\"$T\" d=\"$flask32\"/>"
k32_test="<path fill=\"#000000\" stroke=\"#000000\" stroke-width=\"3\" stroke-linejoin=\"round\" d=\"$flask32\"/>"
b16_test="<path id=\"action-test\" fill=\"$T\" d=\"$flask16\"/>"
k16_test="<path fill=\"#000000\" stroke=\"#000000\" stroke-width=\"2\" stroke-linejoin=\"round\" d=\"$flask16\"/>"

# Objects
o32_cube="<path fill=\"$d\" d=\"M13 3L23 8.5L13 14L3 8.5Z\"/><path fill=\"$O\" d=\"M3 10L12 15V26L3 21Z\"/><path fill=\"$O\" d=\"M14 15L23 10V21L14 26Z\"/>"
o16_cube="<path fill=\"$d\" d=\"M6.5 1L12 3.8L6.5 6.6L1 3.8Z\"/><path fill=\"$O\" d=\"M1 4.8L6 7.4V13.5L1 10.9Z\"/><path fill=\"$O\" d=\"M7 7.4L12 4.8V10.9L7 13.5Z\"/>"
o32_view="<path fill=\"$O\" fill-rule=\"evenodd\" d=\"M3 4H25V22H3Z M5 6V20H23V6Z\"/><path fill=\"$d\" d=\"M7 18L12 11L16 15.5L18 13.5L21 18Z\"/><circle fill=\"$d\" cx=\"18.5\" cy=\"9.5\" r=\"1.5\"/>"
o16_view="<path fill=\"$O\" fill-rule=\"evenodd\" d=\"M1 2H13V12H1Z M2 3V11H12V3Z\"/><path fill=\"$d\" d=\"M3 10L6 6L8 8.5L9 7.5L11 10Z\"/>"
o32_marquee="<g fill=\"$O\"><rect x=\"3\" y=\"3\" width=\"4\" height=\"2\"/><rect x=\"10\" y=\"3\" width=\"4\" height=\"2\"/><rect x=\"17\" y=\"3\" width=\"4\" height=\"2\"/><rect x=\"3\" y=\"19\" width=\"4\" height=\"2\"/><rect x=\"10\" y=\"19\" width=\"4\" height=\"2\"/><rect x=\"17\" y=\"19\" width=\"4\" height=\"2\"/><rect x=\"3\" y=\"5\" width=\"2\" height=\"2\"/><rect x=\"3\" y=\"10\" width=\"2\" height=\"4\"/><rect x=\"3\" y=\"17\" width=\"2\" height=\"2\"/><rect x=\"19\" y=\"5\" width=\"2\" height=\"2\"/><rect x=\"19\" y=\"10\" width=\"2\" height=\"4\"/><rect x=\"19\" y=\"17\" width=\"2\" height=\"2\"/></g><rect fill=\"$d\" x=\"8\" y=\"8\" width=\"8\" height=\"8\"/>"
o16_marquee="<g fill=\"$O\"><rect x=\"1\" y=\"1\" width=\"2\" height=\"1\"/><rect x=\"5\" y=\"1\" width=\"2\" height=\"1\"/><rect x=\"9\" y=\"1\" width=\"2\" height=\"1\"/><rect x=\"1\" y=\"10\" width=\"2\" height=\"1\"/><rect x=\"5\" y=\"10\" width=\"2\" height=\"1\"/><rect x=\"9\" y=\"10\" width=\"2\" height=\"1\"/><rect x=\"1\" y=\"2\" width=\"1\" height=\"1\"/><rect x=\"1\" y=\"5\" width=\"1\" height=\"2\"/><rect x=\"1\" y=\"9\" width=\"1\" height=\"1\"/><rect x=\"10\" y=\"2\" width=\"1\" height=\"1\"/><rect x=\"10\" y=\"5\" width=\"1\" height=\"2\"/><rect x=\"10\" y=\"9\" width=\"1\" height=\"1\"/></g><rect fill=\"$d\" x=\"4\" y=\"4\" width=\"4\" height=\"4\"/>"
o32_family="<path fill=\"$O\" fill-rule=\"evenodd\" d=\"M3 3H21V21H3Z M5 5V19H19V5Z\"/><rect fill=\"$d\" x=\"8.5\" y=\"8.5\" width=\"7\" height=\"7\"/>"
o16_family="<path fill=\"$O\" fill-rule=\"evenodd\" d=\"M1 1H11V11H1Z M2 2V10H10V2Z\"/><rect fill=\"$d\" x=\"4\" y=\"4\" width=\"4\" height=\"4\"/>"
o32_list="<g fill=\"$O\"><rect x=\"3\" y=\"4\" width=\"3\" height=\"3\"/><rect x=\"8\" y=\"4.5\" width=\"14\" height=\"2\"/><rect x=\"7\" y=\"10\" width=\"3\" height=\"3\"/><rect x=\"12\" y=\"10.5\" width=\"10\" height=\"2\"/><rect x=\"7\" y=\"16\" width=\"3\" height=\"3\"/><rect x=\"12\" y=\"16.5\" width=\"6\" height=\"2\"/><rect x=\"3\" y=\"22\" width=\"3\" height=\"3\"/><rect x=\"8\" y=\"22.5\" width=\"5\" height=\"2\"/></g><rect fill=\"$d\" x=\"4\" y=\"7\" width=\"1\" height=\"15\"/>"
o16_list="<g fill=\"$O\"><rect x=\"1\" y=\"1\" width=\"2\" height=\"2\"/><rect x=\"4\" y=\"1.5\" width=\"8\" height=\"1\"/><rect x=\"3\" y=\"5\" width=\"2\" height=\"2\"/><rect x=\"6\" y=\"5.5\" width=\"5\" height=\"1\"/><rect x=\"1\" y=\"9\" width=\"2\" height=\"2\"/><rect x=\"4\" y=\"9.5\" width=\"2\" height=\"1\"/></g>"
o32_funnel="<path fill=\"$O\" fill-rule=\"evenodd\" d=\"M3 4H25L17 14V26L11 22V14Z M7.4 6L13 13.2V21L15 22.3V13.2L20.6 6Z\"/>"
o16_funnel="<path fill=\"$O\" d=\"M1 2H13L8.5 7V13L5.5 11V7Z\"/>"
o32_sphere="<circle fill=\"$O\" cx=\"12\" cy=\"12\" r=\"9\"/><circle fill=\"$d\" cx=\"9\" cy=\"9\" r=\"3\"/>"
o16_sphere="<circle fill=\"$O\" cx=\"6\" cy=\"6\" r=\"5\"/><circle fill=\"$d\" cx=\"4.5\" cy=\"4.5\" r=\"1.5\"/>"
o32_users="<circle fill=\"$d\" cx=\"18\" cy=\"6.5\" r=\"3.5\"/><path fill=\"$d\" d=\"M13 13.2C14.3 12 16 11.5 18 11.5C21.5 11.5 24.5 13.8 25 18H18.6C17.6 15.5 15.7 14 13 13.2Z\"/><circle fill=\"$O\" cx=\"10\" cy=\"9\" r=\"4\"/><path fill=\"$O\" d=\"M2 24C2 18.5 5.5 15.5 10 15.5C14.5 15.5 18 18.5 18 24Z\"/>"
o16_users="<circle fill=\"$d\" cx=\"10\" cy=\"3.5\" r=\"2\"/><path fill=\"$d\" d=\"M7.5 6.8C8.2 6.3 9 6 10 6C12 6 13.5 7.2 13.8 9.3H9.6C9.2 8 8.5 7.2 7.5 6.8Z\"/><circle fill=\"$O\" cx=\"5\" cy=\"4.5\" r=\"2.5\"/><path fill=\"$O\" d=\"M1 12.5C1 9.3 2.8 7.8 5 7.8C7.2 7.8 9 9.3 9 12.5Z\"/>"
o32_tag="<path fill=\"$O\" fill-rule=\"evenodd\" d=\"M9 3H24V14H9L3 8.5Z M9.8 5L5.9 8.5L9.8 12H22V5Z\"/><circle fill=\"$d\" cx=\"10.5\" cy=\"8.5\" r=\"1.5\"/>"
o16_tag="<path fill=\"$O\" fill-rule=\"evenodd\" d=\"M5 1H13V7H5L1 4Z M5.4 2L2.6 4L5.4 6H12V2Z\"/>"
o32_schedule="<path fill=\"$O\" fill-rule=\"evenodd\" d=\"M3 3H25V25H3Z M5 9V23H23V9Z\"/><g fill=\"$d\"><rect x=\"5\" y=\"13.5\" width=\"18\" height=\"1.5\"/><rect x=\"5\" y=\"18\" width=\"18\" height=\"1.5\"/><rect x=\"11\" y=\"9\" width=\"1.5\" height=\"14\"/></g>"
o16_schedule="<path fill=\"$O\" fill-rule=\"evenodd\" d=\"M1 1H13V13H1Z M2 4V12H12V4Z\"/><g fill=\"$d\"><rect x=\"2\" y=\"7\" width=\"10\" height=\"1\"/><rect x=\"5\" y=\"4\" width=\"1\" height=\"8\"/></g>"
o32_db="<path fill=\"$O\" d=\"M4 6V21A9 3 0 0 0 22 21V6Z\"/><ellipse fill=\"$d\" cx=\"13\" cy=\"6\" rx=\"9\" ry=\"3\"/><path fill=\"$d\" d=\"M4 11A9 3 0 0 0 22 11V12.5A9 3 0 0 1 4 12.5Z\"/><path fill=\"$d\" d=\"M4 16A9 3 0 0 0 22 16V17.5A9 3 0 0 1 4 17.5Z\"/>"
o16_db="<path fill=\"$O\" d=\"M1 3V11A5 1.8 0 0 0 11 11V3Z\"/><ellipse fill=\"$d\" cx=\"6\" cy=\"3\" rx=\"5\" ry=\"1.8\"/><path fill=\"$d\" d=\"M1 6.5A5 1.8 0 0 0 11 6.5V7.5A5 1.8 0 0 1 1 7.5Z\"/>"
o32_clipboard="<path fill=\"$O\" fill-rule=\"evenodd\" d=\"M7 5H25V29H7Z M9 7V27H23V7Z\"/><rect fill=\"$O\" x=\"12\" y=\"2\" width=\"8\" height=\"6\"/><g fill=\"$d\"><rect x=\"11\" y=\"12\" width=\"10\" height=\"2\"/><rect x=\"11\" y=\"17\" width=\"10\" height=\"2\"/><rect x=\"11\" y=\"22\" width=\"6\" height=\"2\"/></g>"
o16_clipboard="<path fill=\"$O\" fill-rule=\"evenodd\" d=\"M3 2H13V15H3Z M4 3V14H12V3Z\"/><rect fill=\"$O\" x=\"6\" y=\"1\" width=\"4\" height=\"3\"/><g fill=\"$d\"><rect x=\"5.5\" y=\"6\" width=\"5\" height=\"1\"/><rect x=\"5.5\" y=\"8.5\" width=\"5\" height=\"1\"/><rect x=\"5.5\" y=\"11\" width=\"3\" height=\"1\"/></g>"
o32_squares="<g fill=\"$O\"><rect x=\"3\" y=\"3\" width=\"7\" height=\"7\"/><rect x=\"12\" y=\"3\" width=\"7\" height=\"7\"/><rect x=\"3\" y=\"12\" width=\"7\" height=\"7\"/></g><rect fill=\"$d\" x=\"12\" y=\"12\" width=\"5\" height=\"5\"/>"
o16_squares="<g fill=\"$O\"><rect x=\"1\" y=\"1\" width=\"4\" height=\"4\"/><rect x=\"6\" y=\"1\" width=\"4\" height=\"4\"/><rect x=\"1\" y=\"6\" width=\"4\" height=\"4\"/></g>"
o32_axes="<g fill=\"$O\"><rect x=\"3\" y=\"5\" width=\"2\" height=\"12\"/><path d=\"M1 6.5L4 1.5L7 6.5Z\"/><rect x=\"3\" y=\"15\" width=\"11\" height=\"2\"/><path d=\"M13 13L17.5 16L13 19Z\"/></g><circle fill=\"$d\" cx=\"11\" cy=\"9\" r=\"2\"/>"
o16_axes="<g fill=\"$O\"><rect x=\"1.5\" y=\"3\" width=\"1\" height=\"7.5\"/><path d=\"M0.5 3.5L2 1L3.5 3.5Z\"/><rect x=\"1.5\" y=\"9.5\" width=\"4\" height=\"1\"/><path d=\"M5 8.3L7.5 10L5 11.7Z\"/></g><circle fill=\"$d\" cx=\"5.5\" cy=\"5\" r=\"1\"/>"
o32_button="<path fill=\"$O\" fill-rule=\"evenodd\" d=\"M5 2H15A3 3 0 0 1 18 5V15A3 3 0 0 1 15 18H5A3 3 0 0 1 2 15V5A3 3 0 0 1 5 2Z M5 4A1 1 0 0 0 4 5V15A1 1 0 0 0 5 16H15A1 1 0 0 0 16 15V5A1 1 0 0 0 15 4Z\"/><rect fill=\"$d\" x=\"7\" y=\"7\" width=\"6\" height=\"6\"/>"
o16_button="<path fill=\"$O\" fill-rule=\"evenodd\" d=\"M2 1H8A1 1 0 0 1 9 2V8A1 1 0 0 1 8 9H2A1 1 0 0 1 1 8V2A1 1 0 0 1 2 1Z M2 2V8H8V2Z\"/><rect fill=\"$d\" x=\"3.5\" y=\"3.5\" width=\"3\" height=\"3\"/>"
brace32="M8 3H10V5H9.5C9 5 8.5 5.4 8.5 6V9C8.5 10 8 10.6 7.3 11C8 11.4 8.5 12 8.5 13V16C8.5 16.6 9 17 9.5 17H10V19H8C7.2 19 6.5 18.3 6.5 17.5V13.5C6.5 12.7 5.9 12 5 12V10C5.9 10 6.5 9.3 6.5 8.5V4.5C6.5 3.7 7.2 3 8 3Z"
brace16="M4 1H5V2H4.6C4.3 2 4 2.3 4 2.6V4.3C4 4.8 3.7 5.2 3.3 5.5C3.7 5.8 4 6.2 4 6.7V8.4C4 8.7 4.3 9 4.6 9H5V10H4C3.4 10 3 9.6 3 9V7C3 6.5 2.6 6 2 6V5C2.6 5 3 4.5 3 4V2C3 1.4 3.4 1 4 1Z"
o32_braces="<path fill=\"$O\" d=\"$brace32\"/><path fill=\"$O\" transform=\"matrix(-1 0 0 1 22 0)\" d=\"$brace32\"/><rect fill=\"$d\" x=\"10\" y=\"10\" width=\"2\" height=\"2\"/>"
o16_braces="<path fill=\"$O\" d=\"$brace16\"/><path fill=\"$O\" transform=\"matrix(-1 0 0 1 12 0)\" d=\"$brace16\"/><rect fill=\"$d\" x=\"5.5\" y=\"5\" width=\"1\" height=\"1\"/>"
o32_pipe="<g fill=\"$O\"><rect x=\"4\" y=\"6\" width=\"12\" height=\"8\"/><rect x=\"2\" y=\"4\" width=\"2\" height=\"12\"/><rect x=\"16\" y=\"4\" width=\"2\" height=\"12\"/></g><rect fill=\"$d\" x=\"4\" y=\"9\" width=\"12\" height=\"2\"/>"
o16_pipe="<g fill=\"$O\"><rect x=\"2\" y=\"3\" width=\"6\" height=\"4\"/><rect x=\"1\" y=\"2\" width=\"1\" height=\"6\"/><rect x=\"8\" y=\"2\" width=\"1\" height=\"6\"/></g>"
o32_globe="<path fill=\"$O\" fill-rule=\"evenodd\" d=\"M12 3A9 9 0 1 1 11.99 3Z M12 5A7 7 0 1 0 12.01 5Z\"/><path fill=\"$d\" fill-rule=\"evenodd\" d=\"M12 4A3.5 8 0 1 1 11.99 4Z M12 5.5A2 6.5 0 1 0 12.01 5.5Z\"/><rect fill=\"$d\" x=\"4\" y=\"11\" width=\"16\" height=\"2\"/>"
o16_globe="<path fill=\"$O\" fill-rule=\"evenodd\" d=\"M6 1A5 5 0 1 1 5.99 1Z M6 2A4 4 0 1 0 6.01 2Z\"/><rect fill=\"$d\" x=\"2\" y=\"5.5\" width=\"8\" height=\"1\"/><rect fill=\"$d\" x=\"5.5\" y=\"2\" width=\"1\" height=\"8\"/>"

icon() { # name object badge
  local n="$1" ob="$2" ba="$3" s o b k file v
  for s in 32 16; do
    v="o${s}_${ob}"; o="${!v}"; b=""; k=""
    if [ -n "$ba" ]; then v="b${s}_${ba}"; b="${!v}"; v="k${s}_${ba}"; k="${!v}"; fi
    file="$out/$n.svg"; [ "$s" = 16 ] && file="$out/$n.16.svg"
    {
      echo "<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"$s\" height=\"$s\" viewBox=\"0 0 $s $s\">"
      if [ -n "$ba" ]; then
        echo "  <defs><mask id=\"badge-knockout\" maskUnits=\"userSpaceOnUse\" x=\"0\" y=\"0\" width=\"$s\" height=\"$s\"><rect fill=\"#FFFFFF\" width=\"$s\" height=\"$s\"/>$k</mask></defs>"
        echo "  <g id=\"object-$ob\" mask=\"url(#badge-knockout)\">$o</g>"
        echo "  $b"
      else
        echo "  <g id=\"object-$ob\">$o</g>"
      fi
      echo "</svg>"
    } > "$file"
  done
}

icon UpdaterRunDocument       cube      run
icon UpdaterRunView           view      run
icon UpdaterRunSelection      marquee   run
icon FamilyParameterReport    family    export
icon CategoriesReport         list      export
icon FiltersReport            funnel    export
icon MaterialsReport          sphere    export
icon UserReport               users     export
icon BuiltInParametersReport  tag       export
icon ProductRangeSchedules    schedule  plus
icon ViewParametersSet        view      pencil
icon ExtensibleStorageDelete  db        delete
icon FamilyMaterialsPurge     sphere    remove
icon ClipboardIds             clipboard ""
icon CollectorTest            squares   test
icon CoordinateTest           axes      test
icon AvailabilityProbe        button    test
icon Sandbox                  braces    test
icon FieldTrimEndSelect       pipe      test
icon CoordinatesElement       cube      target
icon CoordinatesProject       globe     target
