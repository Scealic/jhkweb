# linear-team-estimate-check: Kelly facts

- Workspace URL key `jhkelly-ktr` (`jhkelly` redirects). Estimates page: `https://linear.app/jhkelly-ktr/settings/teams/<KEY>/estimates`.
- "Allow zero estimates" on is the user's choice (2026-11-06).
- Hasa and its sub-teams are included only when the user names them or says "all".
- Browser: use Claude in Chrome (the user's Brave, where they are signed in to Linear; `list_connected_browsers` first). The built-in browser pane can't sign in to Linear (2026-11-06). If no browser is connected, ask the user to install and sign in to the Claude in Chrome extension in Brave.
- API script: `bash "C:/Users/childebran/.claude/skills/linear-team-estimate-check/check.sh" [TEAMKEY ...]` when `LINEAR_API_KEY` is set (never print it).
- Last full run 2026-11-06: 14 teams (Hasa isn't in `list_teams`). All passed the original three checks. "Allow zero estimates" was off on 11 of them and was turned on that day, confirmed after a reload, so all 14 pass all four checks.
