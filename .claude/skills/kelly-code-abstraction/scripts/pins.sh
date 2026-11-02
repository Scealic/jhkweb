#!/usr/bin/env bash
# Set or show the Kelly package pins of project files.
#   pins.sh set <csproj> <family> <version>   set every "<family>.<Net481|Net80|Net100|2024|2025|2026>" PackageReference to <version>
#   pins.sh show <csproj...>                  print each project's Kelly pins as one line ("<family> <version>, ...")
# Handles Include="..." Version="..." on one line and the IDE layout with spaces around '=' and Version on the next line.
# e.g. pins.sh set /c/repo/jhkweb/Kelly-Revit-v5/src/Revit.csproj Kelly.Revit.UI 26.10.20.838
suffix='(?:Net481|Net80|Net100|2024|2025|2026)'
case $1 in
  set)
    f=$2; fam=$(printf '%s' "$3" | sed 's/\./\\./g'); v=$4
    [ -f "$f" ] && [ -n "$fam" ] && [ -n "$v" ] || { sed -n 2,6p "$0"; exit 2; }
    perl -0pi -e "s/(Include\\s*=\\s*\"$fam\\.$suffix\"\\s+Version\\s*=\\s*\")[^\"]+/\${1}$v/g" "$f"
    perl -0ne "while (/Include\\s*=\\s*\"($fam\\.$suffix)\"\\s+Version\\s*=\\s*\"([^\"]+)\"/g) { print \"  \$1 \$2\\n\" }" "$f";;
  show)
    shift
    for f in "$@"; do
      printf '%s: ' "$f"
      perl -0ne "my %v; while (/Include\\s*=\\s*\"(Kelly\\.[A-Za-z.]+?)\\.$suffix\"\\s+Version\\s*=\\s*\"([^\"]+)\"/g) { \$v{\"\$1 \$2\"}++ } print join(', ', sort keys %v) || 'no Kelly pins', \"\\n\"" "$f"
    done;;
  *) sed -n 2,6p "$0"; exit 2;;
esac
