# Work Brain

This repository is operated by the **work-brain** sub-agent at [`.claude/agents/work-brain.md`](.claude/agents/work-brain.md). That file is the source of truth for the vault's operating contract — directory layout, capture/journal/review conventions, the work-vs-personal boundary, the handoff ritual, and the skills the agent invokes.

When this folder is opened in any agent that auto-loads root `AGENTS.md` (Cursor, Claude Code, Codex, Hermes, …), treat the work-brain agent's instructions as authoritative for any work in this directory.

When invoking from another agent's Task tool or sub-agent interface, the agent name is `work-brain`.

## Quick orientation (for humans)

- **`brain/`** — synthesized work notes (what you wrote). Read and write freely.
- **`raw/`** — verbatim work artifacts (transcripts, exports). Read-only for the agent.
- **`handoff/`** — anonymized digests staged for the personal brain. Produced by the `monthly-dump` skill, consumed by the personal brain's `receive-handoff` skill.
- **`brain/templates/`** — copy these for new notes.
- **`CHEATSHEET.md`** — quick lookups for filenames, frontmatter, and skill triggers.

## The boundary, in one sentence

This repo never reaches into the personal brain. The personal brain only ever reads `handoff/` files this repo produced — never `brain/` directly, never `raw/` ever.
