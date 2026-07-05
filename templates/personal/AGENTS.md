# Second Brain

This repository is operated by the **second-brain** sub-agent at [`.claude/agents/second-brain.md`](.claude/agents/second-brain.md). That file is the source of truth for the vault's operating contract — directory layout, capture/journal/review conventions, the work-vs-personal boundary, sensitivity rules, and the skills the agent invokes.

When this folder is opened in any agent that auto-loads root `AGENTS.md` (Cursor, Claude Code, Codex, Hermes, …), treat the second-brain agent's instructions as authoritative for any work in this directory.

When invoking from another agent's Task tool or sub-agent interface, the agent name is `second-brain`.

## The brain and AI tools are two different things

This repo is the **brain**: plain markdown + git, fully operable with no AI provider at all. AI tools (Claude Code, Cursor, Codex, whatever comes next) are optional accelerators that depend on the brain — the brain never depends on a tool.

- **`.claude/skills/` is a discovery location, not a tool commitment.** The skills' *content* is tool-neutral markdown procedure any agent (or human) can follow; the path exists because Claude Code and Codex auto-discover `SKILL.md` there. This `AGENTS.md` is the canonical entry point for every tool. Revisit this exception only if a second ecosystem requires a genuinely different *format*, not just a different path.
- **Generated files are never hand-edited.** Root `index.md` and every `brain/<folder>/index.md` are produced by `scripts/regen-indexes` — rerun the script instead of editing them.
- **`scripts/` is the no-AI automation layer** (plain python, no network): `lint`, `regen-indexes`, `freshness`, `digest`. Runnable by hand, by CI (`.github/workflows/brain-ci.yml`), or by any agent. After adding, renaming, moving, or archiving notes, run `scripts/regen-indexes`; run `scripts/lint` before committing bulk changes.
- **Commits are gated locally.** Run `scripts/install-hooks` once per clone: the tracked `.githooks/pre-commit` hook regenerates + stages the index maps and blocks the commit on lint errors (warnings pass). CI runs the same checks as the backstop for hook-less commits (web editor, `--no-verify`). If a commit is rejected, fix the reported errors — don't reach for `--no-verify` unless it's a genuine emergency.

## Git Workflow

This vault is operated **directly on `main`** — no feature branches, no pull requests — so anyone can pick it up and use it without branch juggling. The rules:

1. **Pull latest `main` before making changes.** At the start of any task that will edit files, sync the sandbox first: `git pull --rebase origin main` (fetch + rebase). This keeps everyone working from the same base and prevents conflicts.
2. **Commit and push straight to `main`.** When the user asks to save or "push to main", commit on `main` and `git push origin main` directly. Never create a feature branch or open a PR for this repo.
3. **Only commit/push when the user asks.** Summarize the changed files for review first; push only after explicit approval.
4. **If a push is rejected because `main` moved**, pull/rebase again and retry — don't force-push.
