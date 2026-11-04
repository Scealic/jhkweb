#!/usr/bin/env bash
# Rewrites the "**Complete: N% (done of total)**" lines of one or more backlog files.
# A Complete line before the first heading 2 counts the whole file (the per-repo Quick-Backlog.md files);
# one under a heading 2 counts that section only.
# Counts every checkbox, sub-items included; [x] (also struck-through superseded items) is closed.
# Usage: percent.sh [file ...]   (default: every C:\repo\jhkweb\*\Quick-Backlog.md)

if [ $# -eq 0 ]; then
    set -- /c/repo/jhkweb/*/Quick-Backlog.md
fi

for file in "$@"; do
    awk '
        { lines[NR] = $0 }
        /^## / { h++ }
        /^ *- \[[ xX]\]/ { total[h]++; all++ }
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

# Copy each repository's percent into the index table ("| [Repo](Repo/Quick-Backlog.md) ... | N% (d of t) |"),
# reading the whole-file Complete line of every */Quick-Backlog.md. Runs on every call.
index="/c/repo/jhkweb/Backlog - Quick.md"
if [ -f "$index" ]; then
    perl -i -pe '
        BEGIN {
            for my $f (glob "/c/repo/jhkweb/*/Quick-Backlog.md") {
                my ($repo) = $f =~ m{/([^/]+)/Quick-Backlog\.md$};
                open my $h, "<", $f or next;
                while (<$h>) { last if /^## /; if (/^\*\*Complete: (\d+% \(\d+ of \d+\))\*\*/) { $pct{$repo} = $1; last } }
            }
        }
        if (/^\| \[([^\]]+)\]\(\1\/Quick-Backlog\.md\)/ && exists $pct{$1}) {
            my $r = $1; s/\| *\d+% \(\d+ of \d+\) *\|(\s*)$/| $pct{$r} |$1/;
        }
    ' "$index"
    echo "index table: $(grep -c '^| \[' "$index") rows updated from the repository files"
fi
