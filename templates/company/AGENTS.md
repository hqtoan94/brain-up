# Work Brain

This repository is operated by the **work-brain** sub-agent at [`.claude/agents/work-brain.md`](.claude/agents/work-brain.md). That file is the source of truth for the vault's operating contract — directory layout, capture/journal/review conventions, the work-vs-personal boundary, the handoff ritual, and the skills the agent invokes.

When this folder is opened in any agent that auto-loads root `AGENTS.md` (Cursor, Claude Code, Codex, Hermes, …), treat the work-brain agent's instructions as authoritative for any work in this directory.

When invoking from another agent's Task tool or sub-agent interface, the agent name is `work-brain`.

## The brain and AI tools are two different things

This repo is the **brain**: plain markdown + git, fully operable with no AI provider at all. AI tools (Claude Code, Cursor, Codex, whatever comes next) are optional accelerators that depend on the brain — the brain never depends on a tool.

- **`.claude/skills/` is a discovery location, not a tool commitment.** The skills' *content* is tool-neutral markdown procedure any agent (or human) can follow; the path exists because Claude Code and Codex auto-discover `SKILL.md` there. This `AGENTS.md` is the canonical entry point for every tool. Revisit this exception only if a second ecosystem requires a genuinely different *format*, not just a different path.
- **Generated files are never hand-edited.** Root `index.md` and every `brain/<folder>/index.md` are produced by `scripts/regen-indexes` — rerun the script instead of editing them.
- **`scripts/` is the no-AI automation layer** (plain python, no network): `lint`, `regen-indexes`, `freshness`, `digest`. Runnable by hand, by CI (`.github/workflows/brain-ci.yml`), or by any agent. After adding, renaming, moving, or archiving notes, run `scripts/regen-indexes`; run `scripts/lint` before committing bulk changes.
- **Commits are gated locally.** Run `scripts/install-hooks` once per clone: the tracked `.githooks/pre-commit` hook regenerates + stages the index maps and blocks the commit on lint errors (warnings pass). CI runs the same checks as the backstop for hook-less commits (web editor, `--no-verify`). If a commit is rejected, fix the reported errors — don't reach for `--no-verify` unless it's a genuine emergency.

## Quick orientation (for humans)

- **`brain/`** — synthesized work notes (what you wrote). Read and write freely.
- **`raw/`** — verbatim work artifacts (transcripts, exports). Read-only for the agent.
- **`handoff/`** — anonymized digests staged for the personal brain. Produced by the `monthly-dump` skill, consumed by the personal brain's `receive-handoff` skill.
- **`brain/templates/`** — copy these for new notes.
- **`CHEATSHEET.md`** — quick lookups for filenames, frontmatter, and skill triggers.

## The boundary, in one sentence

This repo never reaches into the personal brain. The personal brain only ever reads `handoff/` files this repo produced — never `brain/` directly, never `raw/` ever.
