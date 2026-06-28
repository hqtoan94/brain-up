# {{NAME}}

Standalone personal brain repository (plain Markdown, portable, greppable).

## Structure

- `raw/` immutable sources — read and ingest, never edit
- `brain/` living notes and organization (PARA + Zettelkasten)
- `.claude/` agent and rule configuration

## Daily usage

- capture quick thoughts to `brain/inbox/`
- journal in `brain/journal/`
- organize into `brain/projects/`, `brain/areas/`, `brain/resources/` during review

## How the agent works

This brain is operated by the **second-brain** sub-agent at
[`.claude/agents/second-brain.md`](.claude/agents/second-brain.md) — the source of truth for
layout, conventions, the work-vs-personal boundary, and sensitivity rules. Trigger phrases
(capture, journal, process inbox, weekly review, search, ingest, lint, …) route to skills in
[`.claude/skills/`](.claude/skills/). Quick lookups live in [`CHEATSHEET.md`](CHEATSHEET.md).

Install / sync this brain on a machine with [brain-up](https://github.com/hqtoan94/brain-up).
