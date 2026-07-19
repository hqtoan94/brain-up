# Vocab Practice — Daily Routine

Daily vocab practice.

1. Pull latest, then glob `brain/resources/vocab/*.md` to build the full word list.
2. Read `brain/resources/vocab-practice-log.md` (create it if missing — a table
   with columns: date | words | status | notes). Pick 5 words that have not
   appeared in the log in the last 14 days, preferring words never practiced
   and words previously marked as "misused"; pick randomly among eligible.
3. Send a push notification listing the 5 words.
4. In the chat, show each word's entry **without** its example sentences —
   word, part of speech, category, and definition only.
5. Append today's row to the log with status `notified`. Run
   `scripts/regen-indexes` and `scripts/lint`, commit
   (`vocab practice YYYY-MM-DD: notified`), and push immediately —
   this routine is pre-authorized to commit and push without asking.
6. Ask me to write one example sentence for each word, then **end your turn
   and wait** for my reply.
7. When I reply, assess each sentence: (a) correct meaning and part of
   speech; (b) natural collocation; (c) grammar. For any issue, give the
   corrected sentence with a one-line explanation. Then reveal the vocab
   entry's own examples for comparison.
8. Update today's log row: status `answered`, note any misused words
   (so they resurface sooner). Commit and push again.
