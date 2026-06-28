---
name: capture
description: Quickly drop a work thought, idea, link, or task into brain/inbox/ with a timestamped filename. Use when the user says "capture", "remember this", "save to inbox", "jot this down", "add to inbox", or shares a work-relevant thought with no clear instruction.
---

# Capture (Work Brain)

Zero-friction capture for work content. Real names, project names, customers, internal tools — all welcome here. The personal brain's `capture` has a sensitivity gate; this one does not.

## Process

1. **Don't interrogate.** If the user's message already contains the thought, use it verbatim. Only ask if they said "capture this" with no payload.
2. **Derive a slug.** From the content, pick 3–6 words → kebab-case → max ~50 chars.
3. **Create the file** at `brain/inbox/YYYY-MM-DD-<slug>.md` using today's date.
4. **Minimal frontmatter:**
   ```yaml
   ---
   created: YYYY-MM-DD
   source: <own thought | meeting | slack | call | other if obvious>
   tags: [inbox]
   ---
   ```
5. **Body = the user's words.** Lightly cleaned up (typos, basic grammar) but never summarized or editorialized. If they shared a link, keep the link. If they referenced a ticket or PR, keep the ID.
6. **Confirm in one line.** "Captured → `brain/inbox/2026-04-26-slug.md`." No fanfare.

## What's a "work-relevant thought"

If you're unsure whether a thought belongs in this repo or the personal one, ask:

> Is this about your work at $COMPANY (file here) or about you-the-person across companies (file in personal brain)?

When in doubt, file here — it's easier to lift later than to scrub the personal brain's git history.

## Do not

- Do not run a sensitivity check. Real names and specifics are the *point* of this repo.
- Do not classify into projects / areas / decisions. That happens in `process-inbox`.
- Do not add commentary, headings, or structure to the body.
- Do not overwrite an existing file with the same slug — append `-2`, `-3`, etc.
- Do not write to `~/second-brain/` from this skill. Captures stay here; portability happens via `monthly-dump`.

## Edge cases

- **Multiple thoughts in one message** → create multiple files (one per distinct thought).
- **Looks like a meeting note** ("standup notes:", "1:1 with Alex…") → still capture to inbox; let `process-inbox` route it to `meetings/` or `1on1s/` later.
- **Looks like a decision in flight** → still capture to inbox; `process-inbox` can promote it to `decisions/`.
- **User asks to "capture" but no content yet** → reply "Go ahead — what do you want to capture?"
