#!/usr/bin/env bash
# Run an in-Revit (ricaun) test project in Revit 2024 against THIS source: every active Kelly add-in manifest for 2024 is renamed to .addin.x
# for the run and renamed back afterwards, also when the run fails or is interrupted. Kelly-Revit-v5 builds never install (NoInstall.targets).
#   revit-test.sh <test csproj> <filter|-> <log> [extra msbuild args...]
# e.g. revit-test.sh /c/repo/jhkweb/Kelly-Revit-Logic-v5/test/Revit.Logic.RevitTests/Revit.Logic.RevitTests.csproj "FullyQualifiedName~Fabrication" /tmp/logic.log -p:SolutionName=Kelly.Revit.Logic
# Prints the totals, the failed tests and the TestLogs journal check. Exit code = dotnet test's.
set -u
proj=$1; filter=$2; log=$3; shift 3
ADDINS="/c/ProgramData/Autodesk/Revit/Addins/2024"
NOINSTALL='C:\repo\jhkweb\Kelly-Revit-v5\test\Tests.Revit\NoInstall.targets'
if tasklist | grep -qiE "Revit.exe|ricaun"; then echo "Revit or ricaun.RevitTest.Console is running; close it first"; exit 3; fi
disabled=()
restore() {
  for a in "${disabled[@]}"; do [ -f "$a.x" ] && [ ! -f "$a" ] && mv "$a.x" "$a"; done
  echo "manifests after the run:"; ls -la "$ADDINS" | grep -i kelly
}
trap restore EXIT
for a in "$ADDINS"/Kelly\ Tools\ For\ Revit*.addin; do [ -f "$a" ] || continue; mv "$a" "$a.x" && disabled+=("$a"); done
args=(test "$proj" -c 2024 -p:GeneratePackageOnBuild=false "-p:CustomAfterMicrosoftCommonTargets=$NOINSTALL" "$@")
[ "$filter" != "-" ] && args+=(--filter "$filter")
dotnet "${args[@]}" > "$log" 2>&1
rc=$?
echo "dotnet test exit code $rc (log: $log)"
grep -E " error [A-Z]+[0-9]+|Passed!|Failed!|  Failed [A-Za-z]|KTR0001|Missing results" "$log" | sed -E 's/ \[[^]]*\]$//' | sort -u | head -60
exit $rc
