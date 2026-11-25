#!/usr/bin/env bash
# The day's facts for the work log, as one Markdown file: commits and merges per repo, changelog
# changes, packages, installs, test logs, Revit journals, instruction and memory files, loose ends.
# Usage: day-facts.sh <yyyy-mm-dd> [--commits-only] > facts.md
#   --commits-only prints just the commits section (seconds), to catch commits made after the full run.
# Read-only: never commits, pushes, renames or kills anything.
set -u
DAY="${1:?usage: day-facts.sh <yyyy-mm-dd> [--commits-only]}"; DAY="${DAY//./-}"
ONLY="${2:-}"
NEXT=$(date -d "$DAY +1 day" +%F) || exit 1
ROOT=/c/repo/jhkweb
SINCE="$DAY 00:00"; UNTIL="$NEXT 00:00"
# modified <path> [find tests and actions]: files under <path> last modified on the day.
modified() { local p="$1"; shift; find "$p" -newermt "$DAY" ! -newermt "$NEXT" "$@" 2>/dev/null; }

repos=$(for d in "$ROOT" "$ROOT"/*/ "$ROOT"/KTR4/*/; do [ -e "$d/.git" ] && echo "${d%/}"; done)

echo "# Facts — $DAY"
echo
echo "## Commits (reachable from a branch; merges listed separately)"
echo
none=()
for r in $repos; do
  n=$(basename "$r"); [ "$r" = "$ROOT" ] && n="jhkweb (root docs repo)"
  log=$(git -C "$r" log --branches --remotes --since "$SINCE" --until "$UNTIL" --no-merges --date=format:%H:%M \
        --pretty='- %ad `%h` %s' --shortstat 2>/dev/null | sed -E 's/^ ([0-9]+ files? changed.*)/  - \1/' | grep -v '^$')
  merges=$(git -C "$r" log --branches --remotes --since "$SINCE" --until "$UNTIL" --merges --date=format:%H:%M \
        --pretty='- %ad `%h` %s' 2>/dev/null)
  if [ -z "$log$merges" ]; then none+=("$n"); continue; fi
  c=$(printf '%s\n' "$log" | grep -c '^- ')
  echo "### $n ($c commits; current branch \`$(git -C "$r" branch --show-current)\`)"
  echo
  [ -n "$log" ] && printf '%s\n' "$log"
  [ -n "$merges" ] && { echo; echo "Merges:"; printf '%s\n' "$merges"; }
  other=$(git -C "$r" log --all --since "$SINCE" --until "$UNTIL" --no-merges --pretty=%h 2>/dev/null | wc -l)
  [ "$other" -gt "$c" ] && echo "- Note: $((other - c)) more commits of the day are reachable only from other refs (stash, refs/prs, reflog)."
  echo
done
echo "No commits: ${none[*]:-none}"
echo
[ "$ONLY" = "--commits-only" ] && exit 0
echo "## Changelog changes"
echo
for r in $repos; do
  [ -f "$r/Changelog.md" ] || continue
  com=$(git -C "$r" log --branches --since "$SINCE" --until "$UNTIL" -p -- Changelog.md 2>/dev/null | grep -E '^\+## ' | sed 's/^+/  - committed: /')
  unc=$(git -C "$r" diff HEAD -- Changelog.md 2>/dev/null | grep -E '^\+## ' | sed 's/^+/  - uncommitted: /')
  [ -n "$com$unc" ] && { echo "- $(basename "$r")"; [ -n "$com" ] && echo "$com"; [ -n "$unc" ] && echo "$unc"; }
done
echo
echo "## Packages built"
echo
modified /c/Repo/NugetPackages -name '*.nupkg' -printf '- %TH:%TM %f\n' | sort
echo
echo "## Repins (Kelly package versions changed in Directory.Packages.props or .csproj)"
echo
for r in $repos; do
  com=$(git -C "$r" log --branches --since "$SINCE" --until "$UNTIL" -p -- '*Directory.Packages.props' '*.csproj' 2>/dev/null | grep -E '^\+.*Kelly[^"]*" *Version=|^\+ *<Kelly[A-Za-z]*Version>' | sed 's/^+ */  - committed: /')
  unc=$(git -C "$r" diff HEAD -- '*Directory.Packages.props' '*.csproj' 2>/dev/null | grep -E '^\+.*Kelly[^"]*" *Version=|^\+ *<Kelly[A-Za-z]*Version>' | sed 's/^+ */  - uncommitted: /')
  [ -n "$com$unc" ] && { echo "- $(basename "$r")"; [ -n "$com" ] && echo "$com" | sort -u; [ -n "$unc" ] && echo "$unc" | sort -u; }
done
echo
echo "## Add-in manifests (installs)"
echo
for y in 2024 2025 2026; do
  for m in "/c/ProgramData/Autodesk/Revit/Addins/$y/"Kelly\ Tools\ For\ Revit*.addin*; do
    [ -f "$m" ] || continue
    asm=$(grep -o '<Assembly>[^<]*' "$m" | head -1 | sed 's/<Assembly>//')
    pv=""; [ -n "$asm" ] && [ -f "$(cygpath -u "$asm" 2>/dev/null)" ] && pv=$(date -r "$(cygpath -u "$asm")" '+%F %H:%M')
    echo "- $y: \`$(basename "$m")\` modified $(date -r "$m" '+%F %H:%M'); assembly \`$asm\`${pv:+ (DLL modified $pv)}"
  done
done
echo
echo "## Test logs modified on the day"
echo
modified "$ROOT" -path '*TestLogs*' -name '*.md' | while read -r f; do
  echo "- \`${f#$ROOT/}\` ($(date -r "$f" +%H:%M)): $(grep -iE '^\**(total|passed|failed)|Missing results|journal' "$f" | tr -d '\r' | tail -3 | paste -sd' ' -)"
done
e="$LOCALAPPDATA/Kelly Unit Test Logs/errors.txt"; e=$(cygpath -u "$e" 2>/dev/null || echo "$e")
[ -n "$(modified "$e")" ] && echo "- Logger errors changed: \`errors.txt\`, last lines: $(tail -3 "$e" | tr -d '\r' | paste -sd' ' -)"
echo
echo "## Revit journals of the day"
echo
for y in 2024 2025 2026; do
  d=$(cygpath -u "$LOCALAPPDATA/Autodesk/Revit/Autodesk Revit $y/Journals" 2>/dev/null)
  modified "$d" -name 'journal.*.txt' | while read -r j; do
    printf -- '- %s %s (%s KB): ricaun %s, Kelly %s, exception/error lines %s\n' "$y" "$(basename "$j")" "$(( $(stat -c %s "$j") / 1024 ))" \
      "$(grep -ci ricaun "$j")" "$(grep -ci kelly "$j")" "$(grep -ciE 'exception|fatal|crash' "$j")"
  done
done
echo
echo "## Instruction, skill and memory files modified on the day"
echo
modified "$HOME/.claude" -type f \( -name 'CLAUDE.md' -o -path '*/skills/*' -o -path '*/scheduled-tasks/*' -o -path '*/memory/*' \) ! -path '*/.git/*' ! -path "$HOME/.claude/plugins/*" -printf '- %TH:%TM %p\n' | sort
modified "$ROOT" -maxdepth 3 -type f \( -name 'CLAUDE.md' -o -name 'AGENTS.md' -o -name 'SHARED-AGENTS.md' -o -path '*/.claude/*' \) ! -path '*/.git/*' -printf '- %TH:%TM %p\n' | sort
echo
echo "## Loose ends (as of $(date '+%F %H:%M'))"
echo
for r in $repos; do
  n=$(basename "$r"); s=$(git -C "$r" status --porcelain 2>/dev/null | wc -l); st=$(git -C "$r" stash list 2>/dev/null | wc -l)
  ah=$(git -C "$r" for-each-ref --format='%(refname:short) %(upstream:track)' refs/heads 2>/dev/null | grep -o '^[^ ]* \[ahead [0-9]*' | sed 's/\[ahead /ahead /' | paste -sd',' -)
  [ "$s" -gt 0 ] || [ "$st" -gt 0 ] || [ -n "$ah" ] && echo "- $n: $s uncommitted files, $st stashes${ah:+, $ah}"
done
ls /c/ProgramData/Autodesk/Revit/Addins/*/Kelly\ Tools\ For\ Revit*.addin.x 2>/dev/null | sed 's/^/- renamed manifest: /'
tasklist 2>/dev/null | grep -iE "Revit.exe|ricaun|testhost" | awk '{print "- running: " $1 " (pid " $2 ")"}'
