# Context for the git-push-developbranch skill

- Project folder: `C:\repo\jhkweb`, holding the sibling Kelly repositories (each with its own git, `develop` and `main`).
- Skip the jhkweb root repository (branch `main`, remote `github.com/Scealic/jhkweb`): it is pushed only when the maintainer asks.
- The scheduled task "end-of-day-commit-and-push" runs this skill from `C:\repo\jhkweb`.
- Report commit contents by their messages and Linear keys.
