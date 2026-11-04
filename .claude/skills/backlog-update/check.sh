#!/usr/bin/env bash
# Read-only checks of the quick backlogs (step 4 and 5 of SKILL.md). Changes nothing.
# Usage: check.sh            (every */Quick-Backlog.md and the index)
#        check.sh file ...   (only those files; the repository counts still run)
# Reports: open items below a done one, duplicate items within a file, mojibake, open items with no short title,
# possible secrets, links whose target does not exist (relative to the file),
# and the `// todo` and `new OperationService(` counts to copy into the dated notes.

root=/c/repo/jhkweb
cd "$root" || exit 1
if [ $# -eq 0 ]; then set -- */Quick-Backlog.md "Backlog - Quick.md"; fi

echo "== Open items below a done item (open items come first in each heading)"
for f in "$@"; do
    awk -v f="$f" '/^#/{d=0} /^- \[[xX]\]/{d=1} /^- \[ \]/{if(d) printf "%s:%d: %s\n", f, NR, substr($0,1,90)}' "$f"
done

echo "== Duplicate items within a file (first 70 characters)"
for f in "$@"; do
    grep -oE '^\s*- \[.\] .{0,70}' "$f" | sed -E 's/^\s*- \[.\] //' | sort | uniq -d | sed "s|^|$f: |"
done

echo "== Mojibake (double-encoded UTF-8)"
grep -n 'Ã\|â€' "$@" | cut -c1-120

echo "== Possible secrets"
grep -niE 'password|pwd=|connection ?string=|server=[^ ]+;|token=|api[_ -]?key' "$@" | cut -c1-120

echo "== Links whose target does not exist (relative to the backlog file)"
for f in "$@"; do
    dir=$(dirname "$f")
    grep -oE '\]\([^)]+\)' "$f" | sed -E 's/^\]\(//; s/\)$//' | grep -vE '^(https?:|mailto:|#)' | sort -u |
    while IFS= read -r t; do
        t=${t%%#*}; t=${t//%20/ }
        [ -e "$dir/$t" ] || echo "$f: $t"
    done
done

echo "== Open items with no short title (no ' — ' within the first 100 characters; see 'Linear-ready items')"
for f in "$@"; do
    n=$(grep -E '^\s*- \[ \]' "$f" | perl -CSD -ne 's/^\s*- \[ \] //; $i = index($_, " \x{2014} "); print if $i < 0 || $i > 100' | wc -l)
    [ "$n" -gt 0 ] && printf '%-48s %s\n' "$f" "$n"
done

echo "== // todo comments per repository"
for r in Kelly-Revit-v5 Kelly-Revit-Logic-v5 Kelly-Revit-UI Kelly-Domain Kelly-Windows-v3 Kelly-Windows-Data-v3 \
         Kelly-Revit-v4 Kelly-Revit-Logic-v4 Kelly-Windows-v2 Kelly-Windows-Data-v2; do
    [ -d "$r" ] && printf '%-24s %s\n' "$r" "$(grep -rniE '//\s*todo' "$r" --include=*.cs | grep -v /obj/ | wc -l)"
done

echo "== new OperationService( sites (Kelly-Revit-Logic-v5/src + Kelly-Revit-v5/modules)"
grep -rn 'new OperationService(' Kelly-Revit-Logic-v5/src Kelly-Revit-v5/modules --include=*.cs 2>/dev/null | wc -l
