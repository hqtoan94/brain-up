# Work Brain — Cheatsheet

Quick lookups. For full conventions see [`.claude/agents/work-brain.md`](.claude/agents/work-brain.md).

## Skills (trigger phrases)

| Skill            | Say…                                                                 | Does…                                                                 |
|------------------|----------------------------------------------------------------------|----------------------------------------------------------------------|
| `capture`        | "capture", "save this", "remember this"                              | Drops to `brain/inbox/YYYY-MM-DD-<slug>.md`. No sensitivity gate.    |
| `daily-journal`  | "journal", "today's entry", "EOD"                                    | Opens / creates `brain/journal/YYYY-MM-DD.md`; morning or EOD prompts. |
| `process-inbox`  | "process inbox", "sort inbox"                                        | Walks inbox items one at a time; files into projects/areas/decisions/etc. |
| `weekly-review`  | "weekly review", "Friday review"                                     | Inbox + journal + projects + decisions + meetings + next-week focus.  |
| `monthly-dump`   | "monthly dump", "prep handoff", "lift to personal", "exit ritual"    | Drafts an anonymized digest at `handoff/YYYY-MM-DD.md` for the personal brain. |

## Where things go

| Note type            | Path                                          | Filename                              |
|----------------------|-----------------------------------------------|---------------------------------------|
| Quick capture        | `brain/inbox/`                                | `YYYY-MM-DD-kebab-title.md`           |
| Daily journal        | `brain/journal/`                              | `YYYY-MM-DD.md`                       |
| Project              | `brain/projects/`                             | `kebab-case.md`                       |
| Area                 | `brain/areas/`                                | `kebab-case.md`                       |
| Resource (atomic)    | `brain/resources/`  + `maturity: atomic`      | `kebab-case.md` (claim-titled)        |
| Resource (distilled) | `brain/resources/`  + `maturity: distilled`   | `kebab-case.md` (topic-titled)        |
| Person               | `brain/people/`                               | `firstname-lastname.md`               |
| 1:1                  | `brain/1on1s/<name-kebab>/`                   | `YYYY-MM-DD.md`                       |
| Meeting              | `brain/meetings/`                             | `YYYY-MM-DD-kebab-title.md`           |
| Decision             | `brain/decisions/`                            | `YYYY-MM-DD-decision-slug.md`         |
| Verbatim artifact    | `raw/`                                        | freeform                              |
| Handoff to personal  | `handoff/`                                    | `YYYY-MM-DD.md`                       |

## Two content layers

```
raw/  →  brain/resources/  (atomic | distilled, declared in frontmatter)
```

- **`raw/`** — verbatim, immutable evidence.
- **`brain/resources/`** — your synthesis. Every note has `maturity: atomic | distilled` (or `stub`).
  - **`atomic`** — one claim, claim-titled, <300 words. Default.
  - **`distilled`** — synthesized topic page (runbook, system overview, onboarding). Cites many atoms via `[[link]]`.

Distil when a topic has 5+ atomic notes but no distilled page yet, or when you've answered the same question 3+ times.

## Frontmatter minimum

```yaml
---
title: …
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: […]
---
```

Type-specific extras: see [`brain/templates/`](brain/templates/).

## Portability marker

In journal entries, project notes, decisions, or meeting notes, tag any line that's **portable to the personal brain** with an inline HTML comment:

```md
- Decisions filed within 24h are 5× more useful than ones filed Friday in batch. <!-- portable -->
```

`monthly-dump` finds these markers when scanning the window.

## Boundary in one line

This repo writes only here and to `handoff/`. The personal brain only reads `handoff/`, never `brain/`, never `raw/` ever.

## Don't do

- Don't add or change git remotes after setup without confirming. Routine pushes to the existing `origin` are fine.
- Don't read `raw/` while running `monthly-dump`.
- Don't write to `~/second-brain/` from any skill in this repo.
- Don't anonymize *here* — anonymization is `monthly-dump`'s job, on the way out.
