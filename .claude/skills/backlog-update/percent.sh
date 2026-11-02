#!/usr/bin/env bash
# Rewrites the "**Complete: N% (done of total)**" line under each heading 2 of the backlog.
# Counts every checkbox in the section, sub-items included; [x] (also struck-through superseded items) is closed.
# Usage: percent.sh ["/c/repo/jhkweb/Backlog - Quick.md"]

file="${1:-/c/repo/jhkweb/Backlog - Quick.md}"

awk '
    { lines[NR] = $0 }
    /^## / { h++ }
    /^ *- \[[ xX]\]/ { total[h]++ }
    /^ *- \[[xX]\]/ { done[h]++ }
    END {
        h = 0
        for (i = 1; i <= NR; i++) {
            line = lines[i]
            if (line ~ /^## /) h++
            if (line ~ /^\*\*Complete: /) {
                t = total[h] + 0; d = done[h] + 0
                p = (t == 0) ? 0 : int((d * 100 + t / 2) / t)
                line = sprintf("**Complete: %d%% (%d of %d)**", p, d, t)
            }
            print line
        }
    }' "$file" > "$file.tmp" && mv "$file.tmp" "$file"

grep -n -B2 "^\*\*Complete: " "$file" | grep -E "## |Complete"
