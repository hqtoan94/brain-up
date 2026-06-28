---
name: ingest-book
description: Add a new book epub to raw/books/, extract its content, and autonomously produce a raw source-index note, a distilled brain/ topic page, 8–15 atomic notes, and area-page updates — all in one commit. Use when the user says "add this book", "ingest this book", "digest this book", "add to raw and digest", or drops a book epub with intent to synthesize it. Differs from ingest-source (which is interactive, one claim at a time) — this skill runs end-to-end autonomously and produces the full set of artifacts before asking anything.
---

# Ingest Book

Turn an epub into a complete brain/ distillation in one shot. The epub is immutable; everything else is created new.

See [REFERENCE.md](REFERENCE.md) for file templates, naming conventions, and the epub extraction recipe.

## Pre-flight checks

Before doing any work:

1. **Duplicate check.** Search `raw/books/` for a matching epub and `brain/resources/` for a matching distilled page. If the book is already fully ingested (distilled page + 8+ atomic notes exist), tell the user and stop — don't re-ingest.
2. **Identify the epub.** Resolve the source: user upload path, or a file already in `raw/books/` with no inbound brain links.
3. **Check branch.** Confirm you are on the right feature branch (or create one).

## Process

### Step 1 — Copy the epub

Copy the epub to `raw/books/<slug>.epub`. Slug rule: `<main-title-words>-<author-last-name>` (max ~6 words, all lowercase, hyphens). See REFERENCE.md for examples.

### Step 2 — Extract and read

Extract epub content using the recipe in REFERENCE.md. Read the `toc.ncx` for chapter structure first, then extract prose from each main chapter xhtml (strip tags, unescape html, grab first ~2500 chars per chapter).

### Step 3 — Create `raw/books/<slug>.md`

Source-index file: frontmatter + one-paragraph book summary + per-chapter framework summaries + "Key source for" list. See REFERENCE.md for the exact template.

### Step 4 — Plan atomic notes

Before writing, list 8–15 candidate atomic claims — one per key insight, covering all major chapters/sections proportionally. Each candidate: a claim sentence (becomes the file slug and title) + one-line rationale. Then write them all.

### Step 5 — Write atomic notes

Create `brain/resources/<claim-slug>.md` for each candidate. One claim per file, in the user's voice, <300 words. Template: frontmatter → body paragraph(s) → `## Why it matters` → `## Related` (wikilinks to ≥1 existing note + the distilled page once created).

### Step 6 — Create distilled page

Create `brain/resources/<book-slug>.md` (`maturity: distilled`). Structure: frontmatter → `## Summary` (3–5 sentences) → `## Key ideas` (grouped by chapter/theme, each line a `[[wikilink]]` to an atomic note) → optional reference tables/diagrams → `## Sources` → `## Open questions` (3–5 real tensions or unanswered questions from the book).

### Step 7 — Update areas

Identify 1–2 existing `brain/areas/<area>.md` files whose scope covers this book's domain. Add a new `### <Book Title> — <Author> (<Year>)` subsection listing the distilled page + all atomic notes as wikilinks. Add a dated log entry under `## Log`.

### Step 8 — Commit and push

```
git add raw/books/<slug>.epub raw/books/<slug>.md brain/resources/ brain/areas/
git commit -m "Ingest <Book Title> (<Author>) — <N> atomic notes + distilled page"
git push -u origin <branch>
```

## End-of-run summary

Report to the user:

> **Ingested:** `raw/books/<slug>.epub`
> - `raw/books/<slug>.md` — source index
> - `brain/resources/<slug>.md` — distilled page (maturity: distilled)
> - N atomic notes in `brain/resources/`
> - `brain/areas/<area>.md` — updated
> - Committed and pushed to `<branch>`

## Rules

- **Epub stays immutable.** Copy it to raw/books/ — never edit, rename, or reformat the epub.
- **User's voice, not verbatim.** Atomic notes synthesize in the user's voice. Short quotes are fine with attribution; no paragraph-length lifts.
- **Default maturity is atomic.** Raw notes start at `maturity: atomic`; the distilled page starts at `maturity: distilled`. Never promote existing atomic notes.
- **Cross-link.** Every atomic note's `## Related` section links to ≥1 existing note in `brain/resources/`. Fabricate nothing — if no real connection exists, leave Related empty.
- **Sensitivity gate.** Scan for company-sensitive signals (see `capture` skill's list). If found, pause and ask before writing to brain/.
- **Duplicate gate.** If the book is already ingested, stop and report — don't produce redundant notes.
