#!/usr/bin/env bash
# Shows what changed in each backlog since its last different backup (step 1 of SKILL.md). Changes nothing.
# Usage: backup-diff.sh [file ...]   (default: the index and every */Quick-Backlog.md)
# For each file it takes the newest copy in Documents\Backlog Backups that differs from the file
# (copies identical to it, such as the one the backup script just made, are skipped), and prints
# the item lines added (+) and removed (-) since then. A reworded or ticked item shows as a - and a + line.
# Line endings are ignored. Files with no change, or no backup yet, are listed at the end.

root=/c/repo/jhkweb
backups="$USERPROFILE/Documents/Backlog Backups"
cd "$root" || exit 1
if [ $# -eq 0 ]; then set -- "Backlog - Quick.md" */Quick-Backlog.md; fi

tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
unchanged=(); nobackup=()

for f in "$@"; do
    if [ "$f" = "Backlog - Quick.md" ]; then prefix="Backlog - Quick"; else prefix="${f%%/*} Quick-Backlog"; fi
    tr -d '\r' < "$f" > "$tmp/now"
    previous=""
    # backup names end in yyyy-mm-dd_HHMM.md, so a reverse name sort is newest first
    while IFS= read -r b; do
        tr -d '\r' < "$b" > "$tmp/old"
        if ! cmp -s "$tmp/now" "$tmp/old"; then previous="$b"; break; fi
    done < <(ls "$backups/$prefix "[0-9]*.md 2>/dev/null | sort -r)

    if [ -z "$previous" ]; then
        if ls "$backups/$prefix "[0-9]*.md >/dev/null 2>&1; then unchanged+=("$f"); else nobackup+=("$f"); fi
        continue
    fi

    echo "=== $f   (since $(basename "$previous" .md | sed "s/^$prefix //"))"
    diff -U0 "$tmp/old" "$tmp/now" | grep -E '^[+-]' | grep -vE '^(\+\+\+|---) ' | cut -c1-200
    echo
done

[ ${#unchanged[@]} -gt 0 ] && echo "No change since the last backup: ${unchanged[*]}"
[ ${#nobackup[@]} -gt 0 ] && echo "No backup yet: ${nobackup[*]}"
exit 0
