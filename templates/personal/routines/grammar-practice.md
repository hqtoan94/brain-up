---
cron: 0 5 * * *
---

# Grammar Practice — Daily Routine

Daily English grammar practice.

1. Pull latest, then search `brain/resources/` for notes related to English
   grammar (match by tags, title, or content — e.g. tense, clause, article,
   preposition, conditional, subject-verb agreement, etc.).
2. Read `brain/resources/grammar-practice-log.md` (create it if missing — a
   table with columns: date | topics | status | notes). Pick 5 grammar
   resources that have not appeared in the log in the last 14 days, preferring
   resources never practiced and resources previously marked as "weak";
   pick randomly among eligible.
3. In the chat, show a concise summary of each grammar resource — the title,
   the core rule or pattern, and one example from the note. Keep it brief
   enough to review at a glance.
4. Append today's row to the log with status `notified`. Run
   `scripts/regen-indexes` and `scripts/lint`, commit
   (`grammar practice YYYY-MM-DD: notified`), and push immediately —
   this routine is pre-authorized to commit and push without asking.
5. Send a push notification with the 5 grammar topics and their summaries
   so I can re-read them throughout the day.
6. Ask me to write one example sentence demonstrating each grammar rule,
   then **end your turn and wait** for my reply.
7. When I reply, assess each sentence: (a) does it correctly demonstrate
   the target grammar rule; (b) are there any other grammar issues. For
   any problem, give the corrected sentence with a one-line explanation.
   Then show the note's own examples for comparison.
8. Update today's log row: status `answered`, note any grammar topics I
   got wrong (so they resurface sooner). Commit and push again.
