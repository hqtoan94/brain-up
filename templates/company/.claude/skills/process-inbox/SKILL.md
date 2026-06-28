---
name: process-inbox
description: Walk through items in brain/inbox/ one-by-one and help the user file each into the right place (projects, areas, resources, meetings, 1on1s, decisions, archive, delete). Use when the user says "process my inbox", "sort inbox", "clean inbox", or "inbox zero".
---

# Process Inbox (Work Brain)

Turn the capture pile into filed, useful work notes. The agent drives; the user decides.

## Process

1. **List inbox items.** Read `brain/inbox/` and sort by date (oldest first).
2. **Report the count.** "You have N items in the inbox. Ready to start?"
3. **For each item, one at a time:**
   a. Show: filename, date, full body.
   b. Suggest a destination with reasoning. Options (pick the best, mention runners-up):
      - **Project** — actionable, has an outcome → move/expand into `brain/projects/<slug>.md`. **Prompt for `linked_area:`** when creating a project. If no area fits, ask: "Should this spawn a new area, or is it a one-off?"
      - **Area** — ongoing responsibility at this job → append to or create `brain/areas/<slug>.md`.
      - **Resource (atomic)** — durable internal claim or fact → create `brain/resources/<claim-slug>.md` with `maturity: atomic`. Default destination for "an idea worth keeping".
      - **Resource (distilled)** — append to or create a topic page (`maturity: distilled`) — runbook, system overview, onboarding doc. If the topic doesn't have atomic notes yet, prefer atomic for now.
      - **Meeting** — meeting note → move to `brain/meetings/YYYY-MM-DD-<slug>.md` with frontmatter.
      - **1on1** — 1:1 note → move to `brain/1on1s/<person-kebab>/YYYY-MM-DD.md`.
      - **Decision** — a decision actually made (not just a thought) → promote to `brain/decisions/YYYY-MM-DD-<slug>.md` (ADR shape).
      - **Person** — intel about a coworker → append to `brain/people/<name>.md`.
      - **Journal** — date-bound observation → append to the corresponding `brain/journal/<date>.md`.
      - **Archive** — interesting but inactive → `brain/archive/`.
      - **Delete** — stale or now-irrelevant.
   c. Wait for the user's decision.
   d. Execute the move/transform. If creating a new note, use the appropriate template and pull useful content from the inbox item.
   e. **Delete the source inbox file** once filed.
   f. Confirm with a one-liner and move on.
4. **Allow "skip" and "stop".** User can defer an item or end the session anytime.
5. **Summarize at the end.** "Processed X items: Y filed, Z archived, W deleted. N remaining."

## Rules

- **One item at a time.** Never batch-process without explicit per-item consent.
- **Never delete without consent**, even if the item seems junk.
- **Enrich when filing.** When a raw capture becomes a project / decision / meeting note, prompt briefly for the missing structural fields (outcome, deadline, attendees, status).
- **Preserve the content.** If a file moves, its information survives — don't lose the original thought during transform.
- **Mark portability inline.** If an item turns into something with portable lessons, leave a `<!-- portable -->` marker on the lesson line so `monthly-dump` can find it.
- **Sensitivity is allowed here.** Real names, customer names, internal details — all fine. The hard boundary kicks in only at `monthly-dump` time.

## Promoting to decisions/

A capture should become a `brain/decisions/...` record only if the user **actually made the decision** (not just considered it). The shape:

- Frontmatter includes `status: proposed | accepted | superseded`.
- Body has: Context, Options considered, Decision, Consequences, Date.
- If the inbox item is exploratory ("we should think about whether…"), file it as **Knowledge** or back into **Inbox** with a `decision-pending` tag, not as a decision record.

## Promoting to meetings/ or 1on1s/

A capture is a meeting note if it has: a date, attendees (named or implied), and the user's take on what was discussed. Strip transcript-style verbatim content (those belong in `raw/`), keep the user's synthesis.

For `1on1s/`, prompt: "Whose 1:1?" and file under `brain/1on1s/<person-kebab>/<date>.md`. Create the person folder if needed.

## Good suggestion format

> **File 3/12:** `2026-04-20-cdv2-rollback-idea.md`
> "*Idea: do dual-write before cutover for cdv2 — lower risk, gives us a rollback window.*"
>
> Suggest: **Resource (atomic)** — `brain/resources/dual-write-before-cutover.md` with `maturity: atomic`. This is a recurring pattern at this team; worth a durable note.
> Alternatives: append to project `cdv2.md` under "Notes & decisions" if it's specific to this migration only.
>
> File, skip, or something else?
