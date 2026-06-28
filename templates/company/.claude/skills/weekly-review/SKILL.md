---
name: weekly-review
description: Guide the user through a weekly review of work — inbox, journal, projects, decisions, meetings, people, next-week intentions. Use when the user says "weekly review", "Friday review", "review the week", or "let's wrap up the week".
---

# Weekly Review (Work Brain)

A 20–30 minute Friday pass that resets the work brain for next week. Mirrors the personal weekly review but tuned for a workplace.

## Process

Walk through these stages, **one at a time**, waiting for the user at each. Keep prompts short.

### 1. Frame

- Ask: "How did this week land, in one word?"
- Note the answer (used in the summary).

### 2. Inbox

- Count `brain/inbox/` items.
- If >5, suggest running `process-inbox` now. If they decline, move on.
- **Age check.** Flag any inbox item with a `created:` date older than **14 days**. Captures lingering past two weeks are decisions being avoided. Surface them by name, not just count.

### 3. Journal scan

- List journal entries from the last 7 working days (`brain/journal/`).
- Skim them and surface:
  - Top wins / things shipped.
  - Recurring frictions (same blocker twice = pattern).
  - Decisions made that don't yet have a `brain/decisions/` record.
  - Lines tagged `<!-- portable -->` — these are candidates for the next `monthly-dump`.
- Offer to promote any pending decisions to records.

### 4. Projects

- List all files in `brain/projects/` with `status: active`.
- **Drift check, before asking the user anything.** For each active project, silently verify:
  - Has a `deadline:` (not `none`).
  - Has `linked_area:` populated, OR the user has explicitly said it's standalone.
  - `updated:` is within the last 4 weeks.
  Surface failures in a single grouped readout. Examples:
  > **Smells:**
  > - `cdv2.md` — last touched 3 weeks ago. Still active, or paused?
  > - `migrate-jenkins.md` — no `linked_area`. What's it serving?
  > - `oncall-rotations.md` — no `deadline`. Project or area?
- Resolve each smell with the user (paused / archive / link / demote to area).
- Then for each remaining active project, ask:
  - Moved forward this week? (yes / no / a little)
  - Still worth doing? (if no → archive)
  - Next concrete action for next week?
- Update each project file's "Next actions" section as the user answers.

### 5. Decisions

- List `brain/decisions/` entries with `status: proposed` whose `created:` is older than 14 days.
- For each: "This has been proposed for >2 weeks. Accept, reject, or still thinking?"
- A `proposed` decision that lingers is a decision being avoided. Flag it; don't lecture.

### 6. Meetings & 1:1s

- Count `brain/meetings/` and `brain/1on1s/` notes from the past week.
- Flag 1:1s scheduled but with no note ("you had Alex on Wednesday — no notes filed; want to capture them now?").
- Surface any **action items assigned to the user** across meeting notes that aren't yet in a project's "Next actions". Offer to lift them.

### 7. Areas health check

- Briefly: "Anything off-standard in your areas this week? (oncall load, team health, tech debt, etc.)"
- If yes, open the relevant area file and log it.
- **Starvation check.** For each `brain/areas/*.md`, scan `brain/projects/` for any project linking to it (via `linked_area:`) updated in the last 90 days. If an area has zero recent projects, surface it:
  > `platform.md` — no active project under this area in 90+ days. Is the standard holding on autopilot, or is something slipping?

### 8. Next week's focus

- Ask: "What's the *one* thing that, if it ships next week, would make the week a win?"
- Write it into next Monday's journal file (`brain/journal/YYYY-MM-DD.md`) under "Today's one thing". Create the file if needed.
- Up to 2 supporting focuses.

### 9. Summary

> **Weekly review — 2026-04-26 (Week 17)**
> - Week landed: `<word>`
> - Projects moved: N / M
> - Decisions made: N (proposed → accepted: K)
> - Portable lessons noticed: K (queued for next monthly dump)
> - One thing next week: `<text>`

Offer to save the summary as the journal day's appendix or a standalone `brain/journal/weekly-YYYY-WW.md`.

### 10. Handoff prompt (cadence-aware)

- Check `handoff/` for the most recent dump file.
- If none in the last ~30 days, mention: "No handoff in 30+ days — want to run `monthly-dump` now, or queue it for later?"
- Don't push. The cadence is the user's choice; you're just surfacing the gap.

## Tone

- Compassionate, not judgmental. A slipped week is data, not a verdict.
- Move briskly. If the user goes deep on something, let them — otherwise keep pace.
- Never lecture. The user wrote these notes; you're helping them see them clearly.
