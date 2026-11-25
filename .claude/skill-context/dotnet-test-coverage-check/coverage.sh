#!/usr/bin/env bash
# Runs the v5-stack test projects that run without Revit, with line and branch coverage (coverlet) for those that
# reference coverlet.collector. Usage: bash coverage.sh [output folder]   (default: a new folder under $TEMP)
#
# Why the odd options:
#   -p:DebugType=portable  BuildConfigs' Output.Build.props sets DebugType None, and coverlet skips a module without a
#                          PDB: without this every report says 0 of 0 lines.
#   --settings             coverage.runsettings includes only the Kelly assemblies. Without it coverlet also tries to
#                          instrument Kelly.Markdown.TestLogger.dll, which VSTest has locked, and gives up on all of them.
#                          A repo added to PROJECTS needs its assembly in the runsettings' Include list.
# Afterwards every suite runs without coverage in each configuration in its line, so its build (no PDB) and its TestLogs
# Markdown log are the normal ones: under coverlet, Kelly-Domain's LayeringTests sees coverlet's injected tracker type
# and fails.
set -u
ROOT=/c/repo/jhkweb
HERE="$(cd "$(dirname "$0")" && pwd)"
OUT="${1:-${TEMP:-/tmp}/kelly-coverage-$(date +%Y%m%d-%H%M%S)}"
mkdir -p "$OUT"
SETTINGS="$HERE/coverage.runsettings"

# project | configuration measured with coverlet | configurations run without coverage
# Keep in step with scan.sh's SPECS when the v5 pins change.
PROJECTS=(
  "Kelly-Windows-Data-v3/tests/Data.Tests.csproj|Net80|Net80"
  "Kelly-Windows-v3/tests/Logic.Tests.csproj|Net80|Net80"
  "Kelly-Domain/tests/Domain.Tests.csproj|Net80|Net80"
  "Kelly-Windows-Data-Csv/tests/Csv.Tests/Csv.Tests.csproj|Net80|Net80"
  "Kelly-Windows-Data-Json/tests/Json.Tests/Json.Tests.csproj|Net80|Net80"
  "Kelly-Revit-UI/test/Revit.UI.Tests/Revit.UI.Tests.csproj|2025|2024 2025"
)

echo "Coverage reports in $OUT"
for spec in "${PROJECTS[@]}"; do
  IFS='|' read -r p cfg _ <<< "$spec"
  name=$(basename "$p" .csproj)
  repo=${p%%/*}
  if ! grep -q 'coverlet.collector' "$ROOT/$p"; then
    echo "== $repo: no coverlet.collector reference, not measured"
    continue
  fi
  echo "== $repo ($cfg)"
  dotnet test "$ROOT/$p" -c "$cfg" -p:GeneratePackageOnBuild=false -p:DebugType=portable \
    --collect "XPlat Code Coverage" --settings "$SETTINGS" --results-directory "$OUT/$name" 2>&1 \
    | grep -E "Passed!|Failed!|^\s+Failed | error |coverlet\]" | cut -c1-220
  xml=$(find "$OUT/$name" -name coverage.cobertura.xml | head -1)
  if [ -z "$xml" ]; then echo "   no coverage report written"; continue; fi
  grep -o '<coverage [^>]*' "$xml" | head -1 \
    | sed -E 's/.*line-rate="([^"]*)" branch-rate="([^"]*)".*lines-covered="([^"]*)" lines-valid="([^"]*)" branches-covered="([^"]*)" branches-valid="([^"]*)".*/   lines \1 (\3 of \4), branches \2 (\5 of \6)/'
  echo "   classes under 90% of lines (line rate, branch rate, class):"
  grep -oE '<class name="[^"]*" filename="[^"]*" line-rate="[^"]*" branch-rate="[^"]*"' "$xml" \
    | sed -E 's/<class name="([^"]*)" filename="[^"]*" line-rate="([^"]*)" branch-rate="([^"]*)"/\2 \3 \1/' \
    | sed 's/<.*//' | awk '$1 < 0.9' | sort -n | awk '!seen[$3]++' | head -25 | sed 's/^/     /'
done

echo
echo "== Every suite without coverage (normal build and TestLogs)"
for spec in "${PROJECTS[@]}"; do
  IFS='|' read -r p _ cfgs <<< "$spec"
  for c in $cfgs; do
    echo "   ${p%%/*} ($c): $(dotnet test "$ROOT/$p" -c "$c" -p:GeneratePackageOnBuild=false 2>&1 | grep -E 'Passed!|Failed!| error ' | head -3 | cut -c1-160)"
  done
done
