---
name: process-inbox
description: Walk through items in brain/inbox/ one-by-one and help the user file each into the right place (projects, areas, resources, knowledge, archive, delete). Use when the user says "process my inbox", "sort inbox", "clean inbox", or "inbox zero".
---

# Process Inbox

Turn the capture pile into filed, useful notes. The agent drives; the user decides.

## Process

1. **List inbox items.** Read `brain/inbox/` and sort by date (oldest first).
2. **Report the count.** "You have N items in the inbox. Ready to start?"
3. **For each item, one at a time:**
   a. Show: filename, date, and the full body.
   b. **Sensitivity check.** Scan the content for company-sensitive signals (see the `capture` skill for the full list: proper-noun product/customer/tool names, quoted coworkers, specific business numbers, strategy/roadmap/architecture detail, meeting-note shape, credentials, comp/review content). If any hit, surface it explicitly in your suggestion.
   c. Suggest a destination with reasoning. Options (pick the best, mention runners-up):
      - **Project** — actionable, has an outcome → move/expand into `brain/projects/<slug>.md`. **Always prompt for linkage** when creating a project: "What does this serve — a year goal in `brain/goals/YYYY/year.md`, or an area in `brain/areas/`?" Set `linked_goal:` and/or `linked_area:` accordingly. If the user can't name either, that's a smell — propose filing as a **Resource (atomic)** or **Inbox** (keep) instead.
      - **Area** — ongoing responsibility → append to or create `brain/areas/<slug>.md`.
      - **Resource (atomic)** — a durable claim or idea worth recalling → create `brain/resources/<claim-slug>.md` with `maturity: atomic` (use the resource template). This is the default destination for "an idea worth keeping" — most filed items land here.
      - **Resource (distilled)** — append to or create a topic page (`maturity: distilled`) when the inbox item is a synthesis or fits an existing distilled page. If creating new and there are no atomic notes underneath, prefer atomic for now.
      - **Goal** — a year-level desired outcome → add a `### G<N>` entry to `brain/goals/YYYY/year.md` (use the entry shape in `brain/goals/README.md`). Then ask: "What project will deliver this?" If they have one, link it; if not, gently flag that a year goal without a project for >30 days drifts. Never create per-quarter goal entries — quarter files are retros.
      - **Person** — intel about someone → append to `brain/people/<name>.md`.
      - **Journal** — date-bound reflection → append to `brain/journal/<date>.md`.
      - **Career** — a generalized career lesson or win → append to the current-role file in `brain/career/`.
      - **Archive** — interesting but inactive → `brain/archive/`.
      - **Delete** — stale or now-irrelevant.
      - **Company repo** — if sensitivity flagged: do not file here; suggest the user move it to `~/work/<company>/` and delete the inbox item.
      - **Anonymize then file** — if sensitivity flagged but there's a portable lesson: propose a redacted version with placeholders (`$COMPANY`, `$PROJECT_X`, etc.), then file the redacted version to one of the destinations above. Original inbox file is deleted, not moved.
   d. Wait for user's decision.
   e. Execute the move/transform. If creating a new note, use the appropriate template and pull any useful content from the inbox item.
   f. **Delete the source inbox file** once filed.
   g. Confirm with a one-liner and move on.
4. **Allow "skip" and "stop".** User can defer an item or end the session anytime.
5. **Summarize at the end.** "Processed X items: Y filed, Z archived, W deleted. N remaining."

## Rules

- **One item at a time.** Never batch-process without explicit per-item consent.
- **Never delete without consent**, even if the item seems junk.
- **Enrich when filing.** If a raw capture becomes a knowledge note, the user will likely want to add a source, related links, and a "why it matters" line — prompt briefly for those.
- **Preserve the content.** If a file moves, its information survives — don't lose the original thought during transform.
- **Sensitivity is a hard gate.** If an inbox item contains company-sensitive content, it must either (a) leave this repo entirely, or (b) be anonymized with the user's approval before filing. Never file raw sensitive content into `brain/resources/`, `brain/career/`, `brain/journal/`, `brain/people/`, or anywhere else in this repo.

## Good suggestion format

> **File 3/12:** `2026-04-20-re-read-deep-work.md`
> "*Re-read Deep Work — focus on the 4 disciplines chapter.*"
>
> Suggest: **Resource (distilled)** — append to `brain/resources/deep-work.md` (create it; you've got related captures).
> Alternatives: a fresh atomic resource note, or a project if you want to actually schedule the re-read.
>
> File, skip, or something else?

## Good suggestion format (sensitive item)

> **File 7/12:** `2026-04-22-retro-notes.md`
> "*Retro on $BIG_CUSTOMER migration — Jane pushed back on the rollback plan; we ended up shipping the dual-write fix first…*"
>
> **Sensitivity flagged:** customer name, coworker quote, internal project detail.
>
> Suggest: **Anonymize then file** — lift the portable lesson ("dual-write is a lower-risk first step than a cutover when stakeholders disagree on rollback") into `brain/resources/` as an atomic note. Drop the rest.
> Alternative: **Company repo** — keep the full retro there; delete this inbox item.
>
> Anonymize, send to company repo, or something else?
