#!/usr/bin/env bash
# Prints C# source lines per repo and per top-level folder of the v5 stack (obj, bin and tests excluded), to plan reader slices of ~4,000 lines.
# Usage: bash slices.sh [root]   (default C:\repo\jhkweb)
root=${1:-/c/repo/jhkweb}
count() { find "$1" -name '*.cs' -not -path '*/obj/*' -not -path '*/bin/*' 2>/dev/null | xargs -r cat 2>/dev/null | wc -l; }
for repo in Kelly-Windows-Data-v3 Kelly-Windows-Data-Csv Kelly-Windows-Data-Json Kelly-Windows-Data-Sqlite Kelly-Windows-Data-SqlServer Kelly-Windows-v3 Kelly-Domain Kelly-Revit-Logic-v5 Kelly-Revit-UI; do
  src="$root/$repo/src"; [ -d "$src" ] || continue
  echo "$repo total $(count "$src")"
  for d in "$src"/*/; do n=$(count "$d"); [ "$n" -gt 0 ] && echo "  ${d#$src/} $n"; done
done
addin="$root/Kelly-Revit-v5"
echo "Kelly-Revit-v5/src total $(count "$addin/src")"
for m in "$addin"/modules/*/; do
  echo "Kelly-Revit-v5/${m#$addin/} total $(count "$m") xaml=$(find "$m" -name '*.xaml' -not -path '*/obj/*' | wc -l)"
  [ -d "$m/Commands" ] && for d in "$m"/Commands/*/; do echo "  Commands/$(basename "$d") $(count "$d")"; done
done
