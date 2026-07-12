---
name: weekly-review
description: Guide the user through a weekly review covering inbox, projects, goals, journal, and next-week intentions. Use when user says "weekly review", "Sunday review", "review the week", or "let's do a review".
---

# Weekly Review

The most important ritual in the system. A calm, structured 20–40 minute pass that resets the brain for the next week.

## Process

Walk through these stages, **one at a time**, waiting for the user at each. Keep prompts short.

### 1. Frame

- Ask: "How did this week feel, in one word?"
- Note the answer (you'll use it in the summary).

### 2. Inbox

- Count `raw/inbox/` items.
- If >5, suggest running `process-inbox` now. If they decline, move on.
- **Age check.** Flag any item with a `created:` date (or filename date) older than **14 days**. Items lingering past two weeks aren't "captures" anymore — they're decisions being avoided. Surface them by name, not just count.

### 3. Journal scan

- List journal entries from the last 7 days (`brain/resources/journal/`).
- Skim them and surface: top wins, recurring frictions, any durable insights that should be lifted to `brain/resources/` (as atomic notes).
- Offer to lift them.
- **Decisions.** While skimming, also watch for decision language ("deciding whether…", "leaning toward…", "still weighing…", "went with…").
  - First check `brain/resources/decisions/` for any existing `status: proposed` records — if this week's entries resolve one, update it in place rather than creating a duplicate.
  - If a decision is still *pending* (being weighed, not yet made), offer to promote it to a formal record: create `brain/resources/decisions/YYYY-MM-DD-kebab-title.md` from [`decision.md`](../../../brain/templates/decision.md) with `status: proposed` — context and options filled in, decision/rationale/consequences left open.
  - If a decision *has been made* this week, create (or update) the record with `status: decided` — context, options considered, decision, rationale, and consequences all filled in.
  - Link the new or updated record back from the relevant project or area file (one line, e.g. under its Notes section).

### 4. Projects

- List all files in `brain/projects/` with `status: active`.
- **Drift check, before asking the user anything.** For each active project, silently verify:
  - Has a `deadline:` (not `none`).
  - Has at least one of `linked_goal:` or `linked_area:` populated.
  - `updated:` is within the last 4 weeks.
  Surface any failures as a single grouped readout — don't interrogate one by one. Examples:
  > **Smells:**
  > - `redesign-portfolio.md` — no `deadline`. Project or area?
  > - `learn-rust.md` — no `linked_goal` / `linked_area`. What's it serving?
  > - `write-novel-draft.md` — last touched 6 weeks ago. Still active, or archive?
- Resolve each smell with the user before moving on (demote to area, link up, or archive).
- Then for each remaining active project, ask:
  - Moved forward this week? (yes / no / a little)
  - Still worth doing? (if no → archive)
  - Next concrete action for next week?
- Update the project file's "Next actions" section as they answer.

### 5. Goals

- Open `brain/resources/goals/YYYY/year.md` (the year file is the primary goal tracker; quarter files are retros).
- For each year goal:
  - Scan the linked projects for movement this week.
  - **Drift check.** If a year goal has no `Linked project(s):` populated, flag it: "G<N> has no project — a goal without a project for >30 days is a wish. Spawn one, or drop the goal?"
  - Append a short "<date>: <status>" note under the goal.
- **Quarter file rollup.** Open the current quarter file (`brain/resources/goals/YYYY/qN.md`) and refresh its "Projects this quarter" list: every active project with `deadline:` between the quarter's `starts:` and `ends:`. This is mechanical — just regenerate the list. Mid-quarter check-in and end-of-quarter retro stay user-driven and only get touched at those points.

### 6. Areas health check

- Briefly: "Anything off-standard in your areas this week? (health, finances, relationships, etc.)"
- If yes, open the relevant area file and log it.
- **Starvation check.** For each `brain/areas/*.md`, scan `brain/projects/` for any project linking to it (via `linked_area:`) updated in the last 90 days. If an area has zero recent projects under it, surface it:
  > `health.md` — no active project under this area in 90+ days. Either you're holding the standard on autopilot (fine), or one of its standards has slipped (spawn a project). Which is it?
  Don't lecture. One sentence per starved area, then let the user decide.

### 6b. End-of-month budget prompt

**Only trigger when today is within the last 7 days of the month.**

- Ask: "End of month coming up — ready to plan next month's budget? I'll pull your spending patterns and only ask about the outliers."
- If yes, invoke the **budget-planning** skill.
- If no, move on.

### 6c. Company handoff check

- Look for `~/work/*/handoff/*.md`. If `~/work/` doesn't exist, or no handoff files are found, skip silently — most weeks there's nothing new.
- **Boundary:** only look at filenames and the `status:` frontmatter field inside `handoff/`. Never open any other folder in a work brain (`brain/`, `raw/`, `meetings/`, `1on1s/`, etc.) — the handoff file is the only sanctioned channel in or out.
- For each handoff file, read `status:`. If any file has `status: ready` (not yet ingested), surface it:
  > Found an unread handoff: `~/work/<company>/handoff/<date>.md` — want to ingest it now?
- If yes → invoke the **receive-handoff** skill against that file.
- If no → move on; note it as deferred in the summary.

### 7. Recurring tasks

- Open `brain/areas/weekly-recurring-tasks.md`. If it doesn't exist or has no items yet, skip this stage.
- Walk through each item **one at a time** — this is a checklist pass, not a discussion, keep pace:
  - Ask: "Have you done `<task>` this week?"
  - Done → update "Last confirmed done" to today, move on.
  - Not done, still needed → offer to lift it into the next actions of its `linked_project` (or `linked_area` if no project). If it has neither, ask which project/area it belongs to before lifting.
  - Not done, no longer needed → offer to remove it from the checklist (confirm before deleting).

### 8. Next week's focus

- Ask: "What's the *one* thing that, if it happens next week, would make the week a win?"
- Write it into next Monday's journal file (`brain/resources/journal/YYYY-MM-DD.md`) under "Today's one thing". Create the file if needed.
- Ask for up to 2 supporting focuses; add them as intentions.

### 9. Summary

Close with a short readout:

> **Weekly review — 2026-04-26**
> - Week felt: `<word>`
> - Projects moved: N / M
> - Goals on track: N / M
> - Decisions recorded: N (proposed / decided)
> - Handoff: ingested / deferred / none pending
> - Recurring tasks: N / M done
> - One thing next week: `<text>`
> - Filed / archived / lifted: counts

Offer to save the summary as `brain/resources/journal/YYYY-MM-DD.md` appendix or a standalone `brain/resources/journal/weekly-YYYY-WW.md`.

## Tone

- Compassionate, not judgmental. A slipped week is data, not a verdict.
- Move briskly. If the user goes deep on something, let them — otherwise keep pace.
- Never lecture. The user wrote these notes; you're helping them see them clearly.
