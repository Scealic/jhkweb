---
name: kelly-daily-report
description: Commit and pull-request activity report across every repo under C:\repo\jhkweb
argument-hint: "[date range — e.g. 'today', '2026-09-15..2026-09-22'; default: yesterday and today]"
allowed-tools: Bash(git*), Bash(date*), Bash(for*), Bash(ls*), Read, Write
---

Produce an activity report over the window: **$ARGUMENTS** (if empty, use yesterday 00:00 through
now, local time). Resolve relative words like "yesterday" against `date` on this machine, not against
any date you assume.

## Repo layout

`C:\repo\jhkweb` is **not** a git repo — each subfolder is an independent repo in the `jhkweb` GitHub
org. Loop over subfolders containing `.git` and always use `git -C <folder>`; never `cd`.
`Kelly-Windows` and `Kelly-Windows-Data` delete `develop` on merge, so a missing `origin/develop`
there is expected.

## Gathering the data

Run these per repo. `gh` is not installed and git credentials must not be probed, so PR data comes
from `refs/pull/*`.

1. Refresh, or the report will be built on stale refs:
   `git -C "$d" fetch --all --prune --quiet`
2. Fetch PR heads **and query them in the same command** — a background client (GitKraken) prunes
   anything under `refs/remotes/origin/` that is not in the configured refspec, so use a `refs/prs/*`
   namespace and do not split these across two tool calls:
   ```bash
   git -C "$d" fetch origin '+refs/pull/*/head:refs/prs/*' --quiet
   git -C "$d" for-each-ref --format='%(refname:short)|%(committerdate:iso-local)|%(subject)' 'refs/prs/*'
   ```
3. Commits in window, all refs, local time:
   `git -C "$d" log --all --since=<start> --until=<end> --date=iso-local --pretty=format:'%h|%ad|%an|%D|%s' --shortstat`
4. Merges landed on the default branch: `git -C "$d" log origin/main --since=<start> --merges --first-parent`
5. Merge status per PR: `git -C "$d" merge-base --is-ancestor refs/prs/<n> origin/main`
6. Tags created in window: `git -C "$d" for-each-ref --format='%(refname:short) %(creatordate:iso-local)' refs/tags`

## Output

Markdown to the terminal:

- A totals line: commits, PRs merged, PRs not in `main`, tags, author breakdown.
- One section per repo with activity, as a table of time / short SHA / what changed, including the
  diffstat and which PR head each commit is. Note when a commit sits on `develop` ahead of `main`.
- Call out PR work that has **not** reached `main`, and any duplicated or bypassed lineage you notice.
- A short cross-cutting theme paragraph — what the two days were actually about.
- List repos with no activity on one line; do not give them sections.
- Close with the PR-state caveat: `merge-base` proves merged, but a squash-merged PR is
  indistinguishable from an open one, so open vs closed-unmerged cannot be determined. Name the
  specific PRs that are ambiguous.

Do not write files or publish anything unless asked — end by offering a shareable page or a saved
markdown file.
