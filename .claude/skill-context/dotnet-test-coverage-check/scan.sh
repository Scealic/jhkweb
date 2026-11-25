#!/usr/bin/env bash
# Member-level scan of the eight v5-stack repos (scan.cs), then Kelly-Revit-v5 again against its behavioural tests only.
# Usage: bash scan.sh [output folder]   (default: a new folder under $TEMP)
# Writes <out>/all/summary.psv and detail.psv, <out>/behavior/summary.psv and detail.psv, and prints both summaries.
# Then writes <out>/gaps.csv (the review's gap list, without known-covered.txt) and <out>/diff/ (new, closed and
# changed gap types since the previous review's CSV; PREV=<csv> picks another) and prints the changes.
#
# scan.cs runs as a .NET 10 file-based app from the output folder, outside C:\repo\jhkweb, so the jhkweb
# Directory.Build.props/targets don't apply to it. The first run restores Microsoft.CodeAnalysis.CSharp from nuget.org.
set -u
HERE="$(cd "$(dirname "$0")" && pwd)"
OUT="${1:-${TEMP:-/tmp}/kelly-scan-$(date +%Y%m%d-%H%M%S)}"
mkdir -p "$OUT"
cp "$HOME/.claude/skills/dotnet-test-coverage-check/scripts/scan.cs" "$OUT/scan.cs"
export SCAN_CONTRACT_REPOSITORY=Kelly-Revit-v5
export SCAN_CONTRACT_BASES="IExternalCommand,IExternalCommandAvailability,CommandBase,IExternalCommandBase,IExternalCommandMvvm,PushButtonBase,IRibbonPushButton,IRibbonStackedButton,IRibbonPullDownButton,IRibbonSplitButton,IRibbonComboBox,AvailabilityBase,Window,UserControl,IRibbonPanelConfiguration"
export SCAN_CONTRACT_ENABLER_NAMES=1
export SCAN_CONTRACT_NAME_PATTERN='(Command|PushButton|CommandEnabler|Window|View|StackedButtons|PullDownButton|SplitButton)(V\d)?$'
R='C:\repo\jhkweb'

# Kelly-Revit-v5 test files that read source text (a .cs file) and check a call is there, rather than run the code.
# They name types without exercising them, so the behaviour scan leaves them out. Add a file here when one is added.
SOURCE_RULE_TESTS=("Commands/LowerLayerRulesTests.cs" "Ribbon/RibbonMovesTests.cs")

# Keep in step with coverage.sh's PROJECTS when the v5 pins change.
SPECS=(
  "Kelly-Windows-Data-v3|$R\Kelly-Windows-Data-v3\src|$R\Kelly-Windows-Data-v3\tests"
  "Kelly-Windows-Data-Csv|$R\Kelly-Windows-Data-Csv\src|$R\Kelly-Windows-Data-Csv\tests"
  "Kelly-Windows-Data-Json|$R\Kelly-Windows-Data-Json\src|$R\Kelly-Windows-Data-Json\tests"
  "Kelly-Windows-v3|$R\Kelly-Windows-v3\src|$R\Kelly-Windows-v3\tests"
  "Kelly-Domain|$R\Kelly-Domain\src|$R\Kelly-Domain\tests"
  "Kelly-Revit-Logic-v5|$R\Kelly-Revit-Logic-v5\src|$R\Kelly-Revit-Logic-v5\test"
  "Kelly-Revit-UI|$R\Kelly-Revit-UI\src|$R\Kelly-Revit-UI\test"
  "Kelly-Revit-v5|$R\Kelly-Revit-v5\src;$R\Kelly-Revit-v5\modules|$R\Kelly-Revit-v5\test"
)

cd "$OUT" || exit 1
echo "== All tests"
dotnet run scan.cs -- "$(cygpath -w "$OUT/all")" "${SPECS[@]}" 2>&1 | grep -v "NU1903\|warning NU"

# Kelly-Revit-v5 against a copy of its tests without the source-text rule files.
BEH="$OUT/v5-behavior-tests"
rm -rf "$BEH"; mkdir -p "$BEH"
cp -r /c/repo/jhkweb/Kelly-Revit-v5/test/Tests.Revit "$BEH/"
rm -rf "$BEH/Tests.Revit/bin" "$BEH/Tests.Revit/obj"
for f in "${SOURCE_RULE_TESTS[@]}"; do rm -f "$BEH/Tests.Revit/$f"; done
echo
echo "== Kelly-Revit-v5, behavioural tests only (without ${SOURCE_RULE_TESTS[*]})"
dotnet run scan.cs -- "$(cygpath -w "$OUT/behavior")" "Kelly-Revit-v5|$R\Kelly-Revit-v5\src;$R\Kelly-Revit-v5\modules|$(cygpath -w "$BEH")" 2>&1 | grep -v "NU1903\|warning NU"
echo
echo "Detail: $OUT/all/detail.psv and $OUT/behavior/detail.psv"

# ---- Gap list: the scan's detail without the checked false positives in known-covered.txt, as the review's CSV.
KNOWN="$HERE/known-covered.txt"
GAPS="$OUT/gaps.csv"
{
  echo "Repo,Access or kind,Folder,Type,Member,Status"
  tail -n +2 "$OUT/all/detail.psv" | tr -d '\r' | awk -F'|' -v known="$KNOWN" '
    BEGIN { while ((getline line < known) > 0) { sub(/\r$/, "", line); if (line ~ /^#/ || line == "") continue
              split(line, k, "|"); skip[k[1] "|" k[2] "|" k[3]] = 1 } }
    skip[$1 "|" $4 "|*"] || skip[$1 "|" $4 "|" $5] { next }
    { st = ($6 == "type-untested") ? "type not named in any test" : "member not named in a test of its type"
      print $1 "," $2 "," $3 "," $4 "," $5 "," st }'
} > "$GAPS"
echo
echo "Gap list (known-covered removed): $GAPS ($(($(wc -l < "$GAPS") - 1)) rows)"

# ---- Changes since the previous review's CSV (the newest one in Planning/Unit Test Coverage dated before today, or $PREV).
PREV="${PREV:-$(ls /c/repo/jhkweb/Planning/Unit\ Test\ Coverage/*" Coverage Gaps.csv" 2>/dev/null | grep -v "/$(date +%Y-%m-%d) " | sort | tail -1)}"
if [ -z "$PREV" ]; then echo "No previous gap list: every gap type is new."; exit 0; fi
DIFF="$OUT/diff"; mkdir -p "$DIFF"
# type key Repo|Type -> sorted member list
keys() { tail -n +2 "$1" | tr -d '\r' | awk -F, '{m[$1 "|" $4] = m[$1 "|" $4] " " ($5 == "" ? "(type)" : $5)} END {for (k in m) print k "\t" m[k]}' | sort; }
keys "$PREV" > "$DIFF/prev.tsv"; keys "$GAPS" > "$DIFF/now.tsv"
join -t$'\t' -v2 <(cut -f1 "$DIFF/prev.tsv") <(cut -f1 "$DIFF/now.tsv") > "$DIFF/new-types.txt"
join -t$'\t' -v1 <(cut -f1 "$DIFF/prev.tsv") <(cut -f1 "$DIFF/now.tsv") > "$DIFF/closed-types.txt"
join -t$'\t' "$DIFF/prev.tsv" "$DIFF/now.tsv" | awk -F'\t' '$2 != $3 {print $1}' > "$DIFF/changed-types.txt"
echo
echo "== Since $(basename "$PREV") (types with a gap: Repo|Type)"
printf '%-24s %6s %6s %6s %6s %6s\n' Repo before now new closed changed
for r in $(cut -d'|' -f1 "$DIFF/prev.tsv" "$DIFF/now.tsv" | sort -u); do
  c() { grep -c "^$r|" "$1" || true; }
  printf '%-24s %6s %6s %6s %6s %6s\n' "$r" "$(c "$DIFF/prev.tsv")" "$(c "$DIFF/now.tsv")" "$(c "$DIFF/new-types.txt")" "$(c "$DIFF/closed-types.txt")" "$(c "$DIFF/changed-types.txt")"
done
for f in new-types closed-types changed-types; do
  n=$(wc -l < "$DIFF/$f.txt"); echo "-- $f ($n)"; head -40 "$DIFF/$f.txt" | sed 's/^/   /'; [ "$n" -gt 40 ] && echo "   ... all in $DIFF/$f.txt"
done
if [ ! -s "$DIFF/new-types.txt" ] && [ ! -s "$DIFF/closed-types.txt" ] && [ ! -s "$DIFF/changed-types.txt" ]; then echo "Nothing changed since the previous review: skip Linear."; fi
