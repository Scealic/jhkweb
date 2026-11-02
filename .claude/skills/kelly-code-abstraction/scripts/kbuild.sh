#!/usr/bin/env bash
# Build, test or pack one Kelly layer. Run from Git Bash.
#   kbuild.sh <layer> verify     [config...]  build without writing a package (default: every configuration of the layer)
#   kbuild.sh <layer> test       [config...]  build and run the layer's non-Revit NUnit tests
#   kbuild.sh <layer> revittests [config...]  compile (not run) the layer's in-Revit test project
#   kbuild.sh <layer> pack                    build every configuration with ONE version, write the packages, print the version
# layer: data | windows | domain | logic | ui | revit | alltrade | pipetrade | ducttrade | contenter | manager | developer
# Kelly-Revit builds (host and modules) never install: NoInstall.targets empties GenerateAddinFile and PostBuild.
# Logs and the record of packed versions go to $KELLY_BUILD_LOGS (default $TEMP/kelly-build).
R=/c/repo/jhkweb
LOGS=${KELLY_BUILD_LOGS:-${TEMP:-/tmp}/kelly-build}
NOINSTALL="$R/Kelly-Revit-v5/test/Tests.Revit/NoInstall.targets"
layer=$1; mode=$2; shift 2 2>/dev/null
lower="Net481 Net80 Net100"; revit="2024 2025 2026"
case $layer in
  data)      proj=$R/Kelly-Windows-Data-v3/src/Data.csproj;      tests=$R/Kelly-Windows-Data-v3/tests/Data.Tests.csproj;   rtests="";                                                       sol=Kelly.Windows.Data; cfgs=$lower;;
  windows)   proj=$R/Kelly-Windows-v3/src/Logic.csproj;          tests=$R/Kelly-Windows-v3/tests/Logic.Tests.csproj;       rtests="";                                                       sol=Kelly.Windows;      cfgs=$lower;;
  domain)    proj=$R/Kelly-Domain/src/Domain.csproj;          tests=$R/Kelly-Domain/tests/Domain.Tests.csproj;       rtests="";                                                       sol=Kelly.Domain;       cfgs=$lower;;
  logic)     proj=$R/Kelly-Revit-Logic-v5/src/Revit.csproj;      tests="";                                              rtests=$R/Kelly-Revit-Logic-v5/test/Revit.Logic.RevitTests/Revit.Logic.RevitTests.csproj; sol=Kelly.Revit.Logic; cfgs=$revit;;
  ui)        proj=$R/Kelly-Revit-UI/src/Revit.UI.csproj;      tests=$R/Kelly-Revit-UI/test/Revit.UI.Tests/Revit.UI.Tests.csproj; rtests=$R/Kelly-Revit-UI/test/Revit.UI.RevitTests/Revit.UI.RevitTests.csproj; sol=Kelly.Revit.UI; cfgs=$revit;;
  revit)     proj=$R/Kelly-Revit-v5/src/Revit.csproj;            tests="";                                              rtests=$R/Kelly-Revit-v5/test/Tests.Revit/Tests.Revit.csproj; sol=Kelly.Revit; cfgs=$revit;;
  alltrade)  proj=$R/Kelly-Revit-v5/modules/AllTrade/AllTrade.csproj;   tests=""; rtests=""; sol=Kelly.Revit; cfgs=$revit;;
  pipetrade) proj=$R/Kelly-Revit-v5/modules/PipeTrade/PipeTrade.csproj; tests=""; rtests=""; sol=Kelly.Revit; cfgs=$revit;;
  ducttrade) proj=$R/Kelly-Revit-v5/modules/DuctTrade/DuctTrade.csproj; tests=""; rtests=""; sol=Kelly.Revit; cfgs=$revit;;
  contenter) proj=$R/Kelly-Revit-v5/modules/Contenter/Contenter.csproj; tests=""; rtests=""; sol=Kelly.Revit; cfgs=$revit;;
  manager)   proj=$R/Kelly-Revit-v5/modules/Manager/Manager.csproj;     tests=""; rtests=""; sol=Kelly.Revit; cfgs=$revit;;
  developer) proj=$R/Kelly-Revit-v5/modules/Developer/Developer.csproj; tests=""; rtests=""; sol=Kelly.Revit; cfgs=$revit;;
  *) sed -n 2,9p "$0"; exit 2;;
esac
[ $# -gt 0 ] && cfgs="$*"
common="-nologo -v:minimal -clp:NoSummary -p:SolutionName=$sol -p:RestoreForce=true"
[ "$sol" = "Kelly.Revit" ] && common="$common -p:CustomAfterMicrosoftCommonTargets=$(cygpath -w "$NOINSTALL")"
mkdir -p "$LOGS"
summarize() { # $1 log, $2 label: prints the distinct compiler errors; returns 1 when there are any
  local errs n; errs=$(grep -E ": error [A-Z]+[0-9]+" "$1" | sed -E 's/ \[[^]]*\]$//' | sort -u)
  n=$(printf "%s" "$errs" | grep -c .)
  echo "[$2] errors=$n (log: $1)"
  [ "$n" -gt 0 ] && printf "%s\n" "$errs" | head -40
  [ "$n" -eq 0 ]
}
rc=0
case $mode in
  verify)
    for c in $cfgs; do log=$LOGS/$layer-verify-$c.log
      dotnet build "$proj" -c $c $common -p:GeneratePackageOnBuild=false > "$log" 2>&1
      summarize "$log" "$layer $c verify" || rc=1; done;;
  test)
    [ -z "$tests" ] && { echo "$layer has no non-Revit test project (try revittests)"; exit 0; }
    for c in $cfgs; do log=$LOGS/$layer-test-$c.log
      dotnet test "$tests" -c $c $common -p:GeneratePackageOnBuild=false > "$log" 2>&1; trc=$?
      summarize "$log" "$layer $c test-build" || rc=1
      grep -E "^(Passed!|Failed!)|  Failed [A-Za-z]" "$log" | head -40
      [ $trc -ne 0 ] && rc=1; done;;
  revittests)
    [ -z "$rtests" ] && { echo "$layer has no in-Revit test project"; exit 0; }
    for c in $cfgs; do log=$LOGS/$layer-revittests-$c.log
      dotnet build "$rtests" -c $c $common -p:GeneratePackageOnBuild=false > "$log" 2>&1
      summarize "$log" "$layer $c revittests compile" || rc=1; done;;
  pack)
    [ "$sol" = "Kelly.Revit" ] && { echo "Kelly-Revit is not a package; use verify"; exit 2; }
    ver="$(date +%y).$((10#$(date +%m))).$((10#$(date +%d))).$((10#$(date +%H%M)))"
    last=$(grep "^$layer " "$LOGS/versions.log" 2>/dev/null | tail -1 | awk '{print $2}')
    if [ "$ver" = "$last" ]; then echo "version $ver was already used for $layer this minute; pack again after the minute changes"; exit 3; fi
    for c in $cfgs; do log=$LOGS/$layer-pack-$c.log
      dotnet build "$proj" -c $c $common -p:VersionCalculated=$ver -p:FileVersionCalculated=$ver -p:GeneratePackageOnBuild=true > "$log" 2>&1
      summarize "$log" "$layer $c pack" || rc=1
      # A reused version would be served stale from the NuGet cache; drop it.
      rm -rf ~/.nuget/packages/$(echo "$sol.$c" | tr 'A-Z' 'a-z')/$ver
      grep -oE "Successfully created package '[^']+'" "$log" | grep -oE "[^\\/']+\.nupkg"; done
    if [ $rc -eq 0 ]; then echo "$layer $ver" >> "$LOGS/versions.log"; echo "PACKED $layer $ver"; else echo "PACK FAILED for $layer (version $ver not recorded)"; fi;;
  *) sed -n 2,9p "$0"; exit 2;;
esac
exit $rc
