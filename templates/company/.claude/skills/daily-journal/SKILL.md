---
name: daily-journal
description: Open or create today's work journal entry and guide the user through morning intentions or end-of-day reflections. Use when the user says "journal", "daily entry", "today's entry", "EOD", "end of day", or "morning standup notes".
---

# Daily Journal (Work Brain)

One file per workday. Lightweight, structured, optional-to-skip prompts. Tuned for the rhythms of a workday — what's on deck, what shipped, what's blocked, what to remember.

## Process

1. **Resolve today's file.** `brain/journal/YYYY-MM-DD.md`.
   - If it doesn't exist → create it from `brain/templates/journal-daily.md` with today's date filled in everywhere.
   - If it exists → open it and continue.

2. **Detect mode.** Morning vs end-of-day:
   - Before 12:00 local → morning.
   - 12:00–16:59 → ask which.
   - 17:00+ → EOD.
   - If the user specified (e.g. "EOD entry"), honor that.

3. **Morning flow** — fill the Morning section. Ask one at a time, terse:
   - Today's *one* thing to ship?
   - What's on deck today (3 bullets max)?
   - Any blockers or pending decisions?

4. **EOD flow** — fill the EOD section. Ask one at a time:
   - What shipped / moved forward?
   - Anything blocked, and on whom?
   - What did you learn or notice today? (technical, organizational, human)
   - Decisions made today worth promoting to `brain/decisions/`?
   - What's tomorrow's one thing?

5. **Write as you go.** Append to the file immediately after each answer — don't batch in case the session ends early.

6. **Promote durable insights, don't lift them.** If a lesson sounds *portable* (works at any company, any team), tag it inline with `<!-- portable -->` so `monthly-dump` finds it later. Do not write to the personal brain from this skill.

7. **Promote decisions.** If the user describes a decision they actually made (not just considered), ask: "Worth its own decision record in `brain/decisions/`?" If yes, create a stub there and link both directions.

8. **Close** with: "Entry saved → `brain/journal/YYYY-MM-DD.md`." No essay.

## Tone

- Terse, professional, unhurried.
- Never evaluate the user's answers. Reflect them back if helpful, never judge.
- If the user wants to *talk* rather than fill structure, drop the structure and capture the conversation under "Notes & observations".

## Do not

- Do not write to the personal brain. Portability is `monthly-dump`'s job.
- Do not prompt for "gratitude" or feelings-style entries — that fits the personal journal, not the work one. If the user wants those, they've got a personal brain for it.
- Do not auto-fill yesterday's "tomorrow's one thing" into today's "one thing" — show it as context, let the user confirm or override.
