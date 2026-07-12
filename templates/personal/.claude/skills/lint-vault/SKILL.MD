---
name: lint-vault
description: Run a cold mechanical health check across brain/ — surface orphan knowledge notes, broken links, missing or malformed frontmatter, drifted projects/goals/areas, stale captures, untyped notes, and possible duplicates. Use when the user says "lint the vault", "lint the brain", "vault health check", "find orphans", "find broken links", "what's rotting", or "what's drifted".
---

# Lint Vault

A cold, mechanical pass over `brain/`. Reports problems, suggests fixes, **never fixes silently**. Complements `weekly-review` — that's the conversational ritual; this is the diff between the system's current state and its rules.

Borrowed from the Obsidian PKM canon (orphan / dangling-link / frontmatter checks) plus the drift checks already specified in `.claude/agents/second-brain.md` and `CHEATSHEET.md`.

## Scope

- Inspect `brain/` only. Skip `raw/` (immutable) for content edits, but flag `raw/` files that have **never been ingested** (no inbound link from any `brain/` file) so the user can decide.
- Skip `brain/archive/` for staleness checks, but still validate frontmatter there.
- Never quote private content. If a flagged file is `private-*.md` or under `private/`, surface the path only.

## Checks

Run all checks. Group findings by category. If a category is clean, omit it.

### 1. Inbox hygiene
- Items in `raw/inbox/` whose date (filename or `created:`) is **> 14 days old** → "decision being avoided".
- If `raw/inbox/` has **> 30 items** → suggest "inbox bankruptcy" per CHEATSHEET.

### 2. Project drift
For each `brain/projects/*.md` with `status: active`:
- Missing `deadline:` or `deadline: none`.
- Missing **both** `linked_goal:` and `linked_area:` (linkage rule violation).
- `updated:` older than **4 weeks**.

### 3. Goal drift
For each year-goal entry (`### G<N> …`) in `brain/resources/goals/YYYY/year.md`:
- No `Linked project(s):` or empty.
- Status hasn't changed in 30+ days (best-effort: scan recent journal/weekly-review notes).

### 4. Area starvation
For each `brain/areas/*.md`:
- No project with `linked_area:` pointing to it, updated in the last **90 days**.

### 5. Resource orphans (atomic notes with no neighbors)
For each `brain/resources/*.md` with `maturity: atomic`:
- **Zero inbound links** from any other file in `brain/` (search for the filename and `[[<slug>]]`).
- If it ALSO has no `## Related` outbound links → fully isolated; surface as "consider deleting or linking".

### 5b. Distillation candidates
- Cluster `brain/resources/*.md` files (`maturity: atomic`) by tag. Any tag with **5+ atomic notes** but **no distilled page** (no `maturity: distilled` note tagged the same) → surface as "ready to distil".

### 6. Broken / dangling links
- `[[wiki-style]]` links pointing to files that don't exist anywhere in `brain/`.
- Markdown links `[text](relative/path.md)` where the path doesn't resolve.
- Frontmatter `linked_goal:` / `linked_area:` paths that don't resolve.

### 7. Frontmatter health
For every `*.md` outside `raw/inbox/` and `brain/templates/`:
- Missing any of `title:`, `created:`, `updated:`, `tags:` (per the second-brain agent's frontmatter minimum).
- For every top-level `brain/resources/*.md` (not subfolders): missing `maturity:` (must be `atomic` | `distilled` | `stub`).
- `created:` or `updated:` not in `YYYY-MM-DD` form.

### 8. Misplaced or maturity-misaligned notes
- File in `brain/projects/` whose tags include `area` (or vice versa).
- File in `brain/resources/` with `maturity: atomic` longer than ~400 words → probably ready to promote to `maturity: distilled` (or split into multiple atoms).
- File in `brain/resources/` with `maturity: distilled` shorter than ~150 words → probably an atom mislabeled (or a stub that hasn't been filled).

### 9. Possible duplicates
- Resource notes with very similar titles (same stem after lowercasing + removing stopwords). Surface for human merge decision; never auto-merge.

### 10. Un-ingested sources
- Files in `raw/` (excluding `raw/README.md`) with **zero inbound links** from any `brain/` file. Surface as "added but never distilled".

### 11. Privacy leaks (light pass, conservative)
- Files outside `private/` or `private-*.md` containing patterns that look like a real employer / customer / coworker name combined with internal-sounding specifics. False positives are fine — these are surfaced for review only.

## Output

Lead with the worst category. One line per finding. Cap each category at 10 findings; if more, append `+N more — say "show all" to expand`.

```
## Lint report — 2026-04-27

### Project drift (3)
- `brain/projects/redesign-portfolio.md` — no `linked_goal` / `linked_area`. Demote, link up, or kill.
- `brain/projects/learn-rust.md` — last `updated:` 6 weeks ago. Still active?
- `brain/projects/write-novel.md` — `deadline: none`. Project or area?

### Resource orphans (5)
- `brain/resources/spaced-repetition-beats-massed-practice.md` — 0 inbound, 0 outbound. Fully isolated.
- `brain/resources/testing-effect.md` — 0 inbound. Worth linking from `brain/resources/learning.md`?
- ...

### Distillation candidates (1)
- Tag `learning` has 6 atomic notes but no distilled page. Promote one or write a fresh `brain/resources/learning.md`?

### Broken links (1)
- `brain/resources/journal/2026-04-12.md` → `[[deep-work-rules]]` — target doesn't exist.

### Frontmatter (2)
- `brain/resources/people/jane-doe.md` — missing `created:`.
- `brain/resources/career/2024-present-staff-engineer.md` — `updated: "Apr 2026"` (not ISO).

### Un-ingested sources (1)
- `raw/karpathy-llm-wiki.md` — added 12 days ago, never linked from `brain/`.
```

Close with a short summary count and an offer:

> Found **N issues across M categories**. Want me to walk through them one at a time and fix as we go, or just leave the report?

## Rules

- **Never auto-fix.** Surface the finding; let the user decide. Some issues are intentional (an atomic note can be rightly orphaned if it's a seed).
- **One walkthrough at a time** if the user opts in — same shape as `process-inbox`. Show, suggest, wait, execute, confirm, next.
- **Don't lint `raw/`** for content edits — only run the un-ingested check there.
- **Don't lint `private/` or `private-*.md`** content; surface the path only.
- **Be conservative on duplicates and privacy leaks.** Both are heuristics; a false positive wastes 5 seconds, a false negative wastes hours.
- **No auto-commit.** As with everything else: never `git commit` unless the user asks.

## Cadence

- **Monthly** by default, more often when the vault has grown a lot.
- After a heavy `process-inbox` session, a quick lint catches anything filed wrong.
- Before an `exit ritual`, lint reveals what's worth lifting and what's stale.
- After a structural change to the vault (folder rename, mass move), lint catches every link that didn't survive the move.
- After a `receive-handoff` ingest, lint surfaces fresh distillation candidates from the new atomic notes.
