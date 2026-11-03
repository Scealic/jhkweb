#!/usr/bin/env bash
# Show or set the Kelly pins. Since central package management, each repo pins only the layer directly below it, through ONE
# version property in its Directory.Packages.props (KellyWindowsDataVersion, KellyWindowsVersion, KellyDomainVersion, KellyRevitLogicVersion,
# KellyRevitUIVersion); a reference to any other Kelly package fails the build (KTR0006).
#   pins.sh show [repo...]          print each repo's Kelly*Version properties (default: the six v5 repos)
#   pins.sh set <repo> <version>    set that repo's one Kelly*Version property, print it
# repo = folder name under /c/repo/jhkweb, e.g. pins.sh set Kelly-Revit-Logic-v5 1.26.1103.1530
R=/c/repo/jhkweb
case $1 in
  show)
    shift; [ $# -gt 0 ] || set -- Kelly-Windows-Data-v3 Kelly-Windows-v3 Kelly-Domain Kelly-Revit-Logic-v5 Kelly-Revit-UI Kelly-Revit-v5
    for r in "$@"; do
      printf '%-22s ' "$r"
      grep -hoE "<Kelly[A-Za-z]*Version>[^<]+</Kelly[A-Za-z]*Version>" "$R/$r/Directory.Packages.props" 2>/dev/null | sed -E 's/<(Kelly[A-Za-z]*Version)>([^<]+)<.*/\1 \2/' | tr '\n' ' '
      echo
    done;;
  set)
    r=$2; v=$3; f="$R/$r/Directory.Packages.props"
    [ -f "$f" ] && [ -n "$v" ] || { sed -n 2,8p "$0"; exit 2; }
    n=$(grep -cE "<Kelly[A-Za-z]*Version>" "$f")
    [ "$n" = "1" ] || { echo "$f has $n Kelly*Version properties; expected exactly one"; exit 2; }
    perl -pi -e "s{<(Kelly[A-Za-z]*Version)>[^<]+</\\1>}{<\$1>$v</\$1>}" "$f"
    grep -hoE "<Kelly[A-Za-z]*Version>[^<]+</Kelly[A-Za-z]*Version>" "$f";;
  *) sed -n 2,8p "$0"; exit 2;;
esac
