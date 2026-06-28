---
name: capture
description: Quickly drop a thought, idea, link, or task into the brain/inbox/ folder with a timestamped filename. Use when the user says "capture", "remember this", "save to inbox", "jot this down", "add to inbox", or shares a thought with no clear instruction.
---

# Capture

Zero-friction capture. Ask as little as possible, file the thought, get out of the way — **unless** the content looks company-specific, in which case pause first.

## Process

1. **Don't interrogate.** If the user's message already contains the thought, use it verbatim. Only ask if they said "capture this" with no payload.
2. **Sensitivity check.** Before writing, scan the content for company-sensitive signals (see below). If any hit, run the **Sensitivity flow** instead of the fast path.
3. **Derive a slug.** From the content, pick 3–6 words → kebab-case → max ~50 chars.
4. **Create the file** at `brain/inbox/YYYY-MM-DD-<slug>.md` using today's date.
5. **Minimal frontmatter:**
   ```yaml
   ---
   created: YYYY-MM-DD
   source: <own thought | conversation | article | other if obvious>
   tags: [inbox]
   ---
   ```
6. **Body = the user's words.** Lightly cleaned up (typos, basic grammar) but never summarized or editorialized. If they shared a link, keep the link.
7. **Confirm in one line.** "Captured → `brain/inbox/2026-04-26-slug.md`." No fanfare.

## Sensitivity signals

Treat content as company-sensitive if it contains any of:

- A **proper noun** that looks like a product, internal tool, codename, customer, or vendor (not a well-known public brand / tool).
- **Quoted speech** attributed to a coworker ("Alex said…", "my manager told me…").
- **Specific numbers** tied to business (revenue, users, churn, headcount, runway, salaries, comp).
- **Strategy / roadmap / architecture** detail ("our plan for Q3 is…", "we're migrating X to Y…").
- **Meeting notes** feel: agendas, attendee lists, action items assigned to named people.
- **Credentials, URLs to internal systems**, JIRA/Linear ticket IDs, Slack channel names.
- Any mention of **performance reviews, promotions, comp, hiring / firing** about real people.

When unsure, assume it's sensitive and run the sensitivity flow.

## Sensitivity flow

Do **not** write anything to `brain/inbox/` yet. Reply with:

> This looks company-specific. Three options:
> 1. **Company repo** — I won't write it here; log it in your `~/work/<company>/` repo instead.
> 2. **Anonymize and keep the learning** — I'll propose a redacted version using placeholders (`$COMPANY`, `$PROJECT_X`, etc.); you approve before I write.
> 3. **Drop it** — don't capture.

Honor whichever the user picks:

- **(1)** — don't write. Suggest they open the company repo and optionally remind them of its path.
- **(2)** — propose a redacted draft. Strip names, specific numbers, quotes. Keep the generalizable lesson. Show the draft, wait for approval, then write to `brain/inbox/` with `tags: [inbox, anonymized]`.
- **(3)** — acknowledge and move on. Don't argue.

## Do not

- Do not ask clarifying questions if the content is usable as-is **and** passes the sensitivity check.
- Do not classify into projects / areas / etc. That happens in `process-inbox`.
- Do not add your own commentary, headings, or structure to the body.
- Do not overwrite an existing file with the same slug — append `-2`, `-3`, etc.
- Do not silently redact and write. The user approves the anonymized version.

## Do not

- Do not ask clarifying questions if the content is usable as-is.
- Do not classify into projects / areas / etc. That happens in `process-inbox`.
- Do not add your own commentary, headings, or structure to the body.
- Do not overwrite an existing file with the same slug — append `-2`, `-3`, etc.

## Edge cases

- **Multiple thoughts in one message** → create multiple files (one per distinct thought).
- **Obviously belongs in the journal** (e.g. "today I…") → still capture to inbox; the journal skill is a separate trigger.
- **User asks to "capture" but no content yet** → reply "Go ahead — what do you want to capture?"
