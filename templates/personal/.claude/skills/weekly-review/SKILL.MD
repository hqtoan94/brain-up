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

- Count `brain/inbox/` items.
- If >5, suggest running `process-inbox` now. If they decline, move on.
- **Age check.** Flag any item with a `created:` date (or filename date) older than **14 days**. Items lingering past two weeks aren't "captures" anymore — they're decisions being avoided. Surface them by name, not just count.

### 3. Journal scan

- List journal entries from the last 7 days (`brain/journal/`).
- Skim them and surface: top wins, recurring frictions, any durable insights that should be lifted to `brain/resources/` (as atomic notes).
- Offer to lift them.

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

- Open `brain/goals/YYYY/year.md` (the year file is the primary goal tracker; quarter files are retros).
- For each year goal:
  - Scan the linked projects for movement this week.
  - **Drift check.** If a year goal has no `Linked project(s):` populated, flag it: "G<N> has no project — a goal without a project for >30 days is a wish. Spawn one, or drop the goal?"
  - Append a short "<date>: <status>" note under the goal.
- **Quarter file rollup.** Open the current quarter file (`brain/goals/YYYY/qN.md`) and refresh its "Projects this quarter" list: every active project with `deadline:` between the quarter's `starts:` and `ends:`. This is mechanical — just regenerate the list. Mid-quarter check-in and end-of-quarter retro stay user-driven and only get touched at those points.

### 6. Areas health check

- Briefly: "Anything off-standard in your areas this week? (health, finances, relationships, etc.)"
- If yes, open the relevant area file and log it.
- **Starvation check.** For each `brain/areas/*.md`, scan `brain/projects/` for any project linking to it (via `linked_area:`) updated in the last 90 days. If an area has zero recent projects under it, surface it:
  > `health.md` — no active project under this area in 90+ days. Either you're holding the standard on autopilot (fine), or one of its standards has slipped (spawn a project). Which is it?
  Don't lecture. One sentence per starved area, then let the user decide.

### 7. Next week's focus

- Ask: "What's the *one* thing that, if it happens next week, would make the week a win?"
- Write it into next Monday's journal file (`brain/journal/YYYY-MM-DD.md`) under "Today's one thing". Create the file if needed.
- Ask for up to 2 supporting focuses; add them as intentions.

### 8. Summary

Close with a short readout:

> **Weekly review — 2026-04-26**
> - Week felt: `<word>`
> - Projects moved: N / M
> - Goals on track: N / M
> - One thing next week: `<text>`
> - Filed / archived / lifted: counts

Offer to save the summary as `brain/journal/YYYY-MM-DD.md` appendix or a standalone `brain/journal/weekly-YYYY-WW.md`.

## Tone

- Compassionate, not judgmental. A slipped week is data, not a verdict.
- Move briskly. If the user goes deep on something, let them — otherwise keep pace.
- Never lecture. The user wrote these notes; you're helping them see them clearly.
