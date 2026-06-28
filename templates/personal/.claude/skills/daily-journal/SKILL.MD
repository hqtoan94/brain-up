---
name: daily-journal
description: Open or create today's journal entry and guide the user through morning intentions or evening reflections. Use when user says "journal", "daily entry", "today's entry", "morning pages", "evening reflection", or similar.
---

# Daily Journal

One file per day. Fast, structured, optional-to-skip prompts.

## Process

1. **Resolve today's file.** `brain/journal/YYYY-MM-DD.md`.
   - If it doesn't exist → create it from `brain/templates/journal-daily.md` with today's date filled in everywhere.
   - If it exists → open it and continue.

2. **Detect mode.** Morning vs evening:
   - Before 12:00 local → morning.
   - 12:00–17:59 → ask which.
   - 18:00+ → evening.
   - If the user specified (e.g. "evening entry"), honor that.

3. **Morning flow** — fill the Morning section. Ask one at a time:
   - Mood / energy 1–10?
   - What's the *one* thing for today?
   - Up to 3 intentions.

4. **Evening flow** — fill the Evening section. Ask one at a time:
   - What went well? (wins)
   - What got in the way?
   - Any lesson or noticing worth keeping?
   - One thing you're grateful for.
   - What's tomorrow's one thing?

5. **Write as you go.** After each answer, append to the file immediately — don't batch to the end, in case the session ends early.

6. **Skip is allowed.** If the user says "skip" to any prompt, leave the field empty (or remove it) and move on.

7. **Lift durable insights.** If a lesson or noticing is clearly *not* date-bound (e.g. a principle they want to remember), ask: "This feels like a keeper — want me to lift it into an atomic note in `brain/resources/`?" If yes, create one (`maturity: atomic`) and link both directions.

8. **Close** with: "Entry saved → `brain/journal/YYYY-MM-DD.md`." No essay.

## Tone

- Terse, warm, unhurried.
- Never evaluate the user's answers. Reflect them back if you must, but don't judge or advise unprompted.
- If the user wants to *talk* rather than fill structure, drop the structure and capture the conversation verbatim under "Notes & observations".
