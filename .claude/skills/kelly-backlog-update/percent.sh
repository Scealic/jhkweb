#!/usr/bin/env bash
# Rewrites the "**Complete: N% (done of total)**" lines of one or more backlog files.
# A Complete line before the first heading 2 counts the whole file (the per-repo Quick-Backlog.md files);
# one under a heading 2 counts that section only.
# Counts every checkbox, sub-items included; [x] (also struck-through superseded items) is closed.
# Empty "- [ ] " placeholders (the index's "Add To Linear as Issue" lines) are not counted.
# Usage: percent.sh [file ...]   (default: every C:\repo\jhkweb\*\Quick-Backlog.md)

if [ $# -eq 0 ]; then
    set -- /c/repo/jhkweb/*/Quick-Backlog.md
fi

for file in "$@"; do
    awk '
        { lines[NR] = $0 }
        /^## / { h++ }
        /^ *- \[[ xX]\] *[^ \r]/ { total[h]++; all++ }
        /^ *- \[[xX]\]/ { done[h]++; alldone++ }
        END {
            h = 0
            for (i = 1; i <= NR; i++) {
                line = lines[i]
                if (line ~ /^## /) h++
                if (line ~ /^\*\*Complete: /) {
                    if (h == 0) { t = all + 0; d = alldone + 0 } else { t = total[h] + 0; d = done[h] + 0 }
                    p = (t == 0) ? 0 : int((d * 100 + t / 2) / t)
                    line = sprintf("**Complete: %d%% (%d of %d)**", p, d, t)
                }
                print line
            }
        }' "$file" > "$file.tmp" && mv "$file.tmp" "$file"

    echo "$(basename "$(dirname "$file")"): $(grep -m1 "^\*\*Complete: " "$file")"
done

