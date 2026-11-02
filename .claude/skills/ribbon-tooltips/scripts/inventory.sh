#!/usr/bin/env bash
# Lists the ribbon push buttons of one Kelly-Revit add-in tree and the external commands no push button calls.
# Usage: inventory.sh <add-in repo folder> [subfolder filter]
#   e.g. inventory.sh /c/repo/jhkweb/Kelly-Revit-v4
#        inventory.sh /c/repo/jhkweb/Kelly-Revit-v5 Trade.Pipe
# Output (tab-separated): BUTTON <file> <command type> <current tooltip or (none)>
#                         ORPHAN <file> <command class>   (an IExternalCommand no push button names in Type = typeof(...))
set -euo pipefail

repo="${1:?add-in repo folder, e.g. /c/repo/jhkweb/Kelly-Revit-v4}"
filter="${2:-}"

cd "$repo"

roots=()
for d in src modules; do [ -d "$d" ] && roots+=("$d"); done

mapfile -t buttons < <(grep -rlE --include='*.cs' 'class\s+\w+\s*:\s*RibbonPushButton' "${roots[@]}" | grep -v '/obj/\|/bin/' | grep -- "$filter" | sort)

declare -A called=()

for f in "${buttons[@]}"; do
    # Anchored: AvailabilityClassType = typeof(...) also ends in "Type = typeof"
    type=$(grep -E '^\s*Type\s*=\s*typeof\(' "$f" | head -1 | sed -E 's/.*typeof\(\s*([A-Za-z0-9_.]+)\s*\).*/\1/')
    tip=$(grep -E '^\s*ToolTip\s*=' "$f" | head -1 | sed -E 's/^\s*ToolTip\s*=\s*//; s/;\s*\r?$//' || true)
    [ -z "$tip" ] && tip='(none)'
    [ -n "$type" ] && called["${type##*.}"]=1
    printf 'BUTTON\t%s\t%s\t%s\n' "$f" "${type:-(no Type)}" "$tip"
done

# Commands: classes that implement IExternalCommand directly or through IExternalCommandBase / a command base class.
while IFS= read -r f; do
    cls=$(grep -oE 'class\s+\w+' "$f" | head -1 | awk '{print $2}')
    [ -z "$cls" ] && continue
    case "$cls" in *Base|*Abstract*) continue;; esac
    grep -qE "abstract\s+class\s+$cls" "$f" && continue
    [ -n "${called[$cls]:-}" ] || printf 'ORPHAN\t%s\t%s\n' "$f" "$cls"
done < <(grep -rlE --include='*.cs' '\[Transaction\(TransactionMode' "${roots[@]}" | grep -v '/obj/\|/bin/' | grep -- "$filter" | sort)
