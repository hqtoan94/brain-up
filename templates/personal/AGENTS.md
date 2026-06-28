# Second Brain

This repository is operated by the **second-brain** sub-agent at [`.claude/agents/second-brain.md`](.claude/agents/second-brain.md). That file is the source of truth for the vault's operating contract — directory layout, capture/journal/review conventions, the work-vs-personal boundary, sensitivity rules, and the skills the agent invokes.

When this folder is opened in any agent that auto-loads root `AGENTS.md` (Cursor, Claude Code, Codex, Hermes, …), treat the second-brain agent's instructions as authoritative for any work in this directory.

When invoking from another agent's Task tool or sub-agent interface, the agent name is `second-brain`.

## Git Workflow

This vault is operated **directly on `main`** — no feature branches, no pull requests — so anyone can pick it up and use it without branch juggling. The rules:

1. **Pull latest `main` before making changes.** At the start of any task that will edit files, sync the sandbox first: `git pull --rebase origin main` (fetch + rebase). This keeps everyone working from the same base and prevents conflicts.
2. **Commit and push straight to `main`.** When the user asks to save or "push to main", commit on `main` and `git push origin main` directly. Never create a feature branch or open a PR for this repo.
3. **Only commit/push when the user asks.** Summarize the changed files for review first; push only after explicit approval.
4. **If a push is rejected because `main` moved**, pull/rebase again and retry — don't force-push.
