---
name: monthly-dump
description: Draft an anonymized handoff file from this work brain into handoff/YYYY-MM-DD.md, ready for the personal brain to ingest via receive-handoff. Use when the user says "monthly dump", "prep handoff", "lift to personal", "what's portable", "send to second-brain", "wiki dump", or "exit ritual".
---

# Monthly Dump (Work → Personal Bridge)

The single legitimate path from this work brain to the personal brain. Produces an anonymized, structured digest that the personal brain's `receive-handoff` skill can consume mechanically.

**Cadence is the user's choice** — weekly, monthly, quarterly, or ad-hoc. The skill takes a window and produces one file.

## Hard rules

1. **Source is `brain/` only — never `raw/`.** No exceptions during this skill.
2. **Anonymization is non-negotiable.** Real names → generic roles. Company / product / customer names → placeholders. Specific business numbers → orders of magnitude.
3. **Per-item user approval before anything lands in the file.** No silent writes.
4. **Output stays in this repo.** This skill does not write to `~/second-brain/`. The user reviews `handoff/YYYY-MM-DD.md`, then runs `receive-handoff` from the personal brain.
5. **Original notes in `brain/` are unchanged.** This is a read-and-distill pass, not a move.

## Process

### 1. Scope the window

Ask the user, then echo back:

> Window for this dump? Defaults to **since the last handoff** (or last 30 days if none).
> - Custom: "since 2026-04-01", "the past quarter", "my whole tenure".

Compute:
- `start_date` (inclusive)
- `end_date` (defaults to today)
- `out_path` = `handoff/YYYY-MM-DD.md` (using `end_date`).

If `out_path` already exists, ask before overwriting; offer `-2`, `-3`, etc. as alternatives.

### 2. Gather candidates (read-only pass)

Scan, in this order, anything `created:` or `updated:` within the window:

1. `brain/journal/` — look for lines tagged `<!-- portable -->`, plus general lessons / wins / surprises.
2. `brain/decisions/` — every decision record in the window, regardless of status.
3. `brain/projects/` — `status: active` and `status: done` projects with movement in the window. Pull "Notes & decisions" and "Outcome" sections.
4. `brain/meetings/` — only meetings tagged `type: retro | review | planning` (those tend to surface lessons). Skip standups.
5. `brain/inbox/` — only items with `<!-- portable -->` markers (rare; `process-inbox` usually moves them out first).

**Do not read** `raw/`, `1on1s/`, or `people/` — too high-leak-risk for portable lifts.

### 3. Categorize candidates

Group findings into the four sections that match the personal brain's destinations:

- **Career** — wins, scope changes, leadership moments, projects shipped. Destined for `~/second-brain/brain/career/<role>.md`.
- **Knowledge** — durable, generalizable atomic claims (technical patterns, organizational lessons, principles). Destined for `~/second-brain/brain/resources/<slug>.md` with `maturity: atomic`. **One atomic idea each.** These feed the personal brain's Zettelkasten substrate; over time the user distils clusters of atoms into `maturity: distilled` topic pages — but that's their job, not this skill's.
- **Skill log entries** — practice notes for skills the user is sharpening. Destined as `## Log` entries on the relevant `brain/projects/` or `brain/areas/` file in the personal brain.
- **Decisions worth remembering** — decision records whose *reasoning* is portable (the situation isn't, but the framework is). Destined as anonymized atomic notes in the personal brain's `brain/resources/`.

### 4. Surface candidates in one readout (no writes yet)

Show the full set in a single message, grouped, with raw → anonymized side by side. Example:

> **Window:** 2026-04-01 → 2026-04-30 (29 days)
> **Source files scanned:** 18 journal, 4 decisions, 6 projects, 2 retros, 0 portable-flagged inbox items.
>
> **Career (3 candidates)**
> a. Shipped cdv2 dual-write rollout (3 months, ~2M req/day). → "Led migration of a high-traffic write path using a dual-write pattern, $ORDER_OF_MAGNITUDE req/day."
> b. Took over oncall rotation for the platform area. → "Took ownership of oncall for a platform team."
> c. Mentored Alex through their first major feature ship. → "Mentored an engineer through their first major feature ship."
>
> **Knowledge (5 candidates)**
> a. Dual-write before cutover lowers migration risk when stakeholders disagree on rollback.
> b. A `proposed` decision that lingers >14 days is a decision being avoided.
> c. Meeting notes filed within 24h are 5× more useful than ones filed Friday in batch.
> d. Oncall fatigue compounds — protect the rotation, don't optimize it.
> e. Architecture reviews work better as written async docs than live whiteboards above ~4 attendees.
>
> **Skill log entries (1 candidate)**
> a. Practice: technical writing — wrote 4 design docs this month, noticed pattern X improved review velocity. → log entry on personal `brain/areas/engineering.md` or wherever the skill lives.
>
> **Decisions worth remembering (1 candidate)**
> a. Decision to adopt gRPC for internal service-to-service. The *reasoning* is portable (latency budget, schema discipline); the org context isn't.
>
> Pick by letter (e.g. "career a, c; knowledge a, b, d; skill a") or "all" / "none".

### 5. Per approved item, propose the anonymized text

For each pick, show the final text the way it'll appear in `handoff/`. Example:

> **Knowledge a:** dual-write-before-cutover.md
> ```
> ### Knowledge: dual-write-before-cutover
> _Atomic claim:_ Dual-write before cutover is a lower-risk first step than a hard cutover when stakeholders disagree on rollback strategy.
>
> _Why it matters:_ Buys a rollback window measured in writes, not deploys. Surfaces real-world divergence before commitment. Slower than cutover but cheaper than a failed migration.
>
> _Source context (anonymized):_ Used during a high-traffic write path migration at $COMPANY. Stakeholders couldn't agree on rollback; dual-write defused the conflict by making rollback equivalent to "stop reading from new path".
>
> _Tags:_ migrations, risk-management, stakeholder-management
> ```
>
> Approve, edit, or skip?

Wait for approval per item. If the user edits, accept their edits verbatim.

### 6. Assemble the handoff file

Once all approved items are gathered, write `handoff/YYYY-MM-DD.md`:

```md
---
title: Handoff — YYYY-MM-DD
created: YYYY-MM-DD
window_start: YYYY-MM-DD
window_end: YYYY-MM-DD
source_repo: $COMPANY work brain
status: ready  # ready | ingested | superseded
ingested_at:   # filled by the personal brain's receive-handoff
---

# Handoff — YYYY-MM-DD

Window: <YYYY-MM-DD> → <YYYY-MM-DD>.
Anonymized for the personal brain. No real names, no company / product names, no specific business numbers.

## Career

<!-- One bullet per career item, anonymized, ready to append to a role file. -->

- …

## Knowledge

<!-- One sub-section per atomic claim. The personal brain's receive-handoff turns each into an atomic note in brain/resources/. -->

### dual-write-before-cutover
_Atomic claim:_ …
_Why it matters:_ …
_Source context (anonymized):_ …
_Tags:_ …

## Skill log entries

<!-- One sub-section per practice log entry. Each names its target file in the personal brain. -->

### Target: brain/areas/engineering.md
- 2026-04-30 — wrote 4 design docs this month; noticed pattern X improved review velocity.

## Decisions worth remembering

<!-- Anonymized decisions whose reasoning is portable. Each becomes an atomic note in the personal brain's brain/resources/. -->

### adopt-rpc-framework-for-internal-services
_Decision:_ Standardize on a typed RPC framework for service-to-service.
_Reasoning (portable):_ Latency budget, schema discipline, codegen client safety.
_Org context (anonymized):_ Mid-size platform team migrating off ad-hoc HTTP/JSON.
```

Confirm with: "Drafted → `handoff/YYYY-MM-DD.md`. Review it in this repo, then run `receive-handoff` from the personal brain."

### 7. Do not write to the personal brain

Even if the personal brain repo is open in the same workspace, this skill does not write there. The user crosses the boundary deliberately by switching context and invoking `receive-handoff`. That's the point of the staging file.

## Anonymization conventions

| Real | Replacement |
|---|---|
| Current employer | `$COMPANY` |
| Internal product | `$PROJECT_X`, `$PRODUCT_Y` |
| External customer | `$CLIENT`, `$CUSTOMER` |
| Coworker by name | "my manager", "a PM I worked with", "a senior engineer" |
| Specific revenue / users | "$ORDER_OF_MAGNITUDE req/day", "low-millions in revenue" |
| Specific dates inside a year | "Q2", "mid-year", "around 6 months in" |
| Internal tool names | rewrite to category — "our internal CI", "our deploy pipeline" |
| URLs to internal systems | drop entirely |

If a sentence still reads as obviously about a specific real entity after substitution, rewrite it more generically or drop it.

## Edge cases

- **Empty window** — window has no candidates. Tell the user and stop. Don't fabricate a handoff to fill space.
- **First-ever dump on a long-tenure repo** — the user may want to do a "tenure dump" covering everything. Respect the request; the categorization process is the same. Warn the file may be long; offer to split by quarter (`handoff/YYYY-MM-DD-q1.md`, `-q2.md`, …) if it gets unwieldy.
- **Exit ritual** — same flow, with `window_end = last_workday`, and add a final section:
  ```md
  ## Exit notes
  - Reminder: archive this repo per employer policy after personal brain ingests.
  - Reminder: don't add a new backup remote on the way out — archive this repo per employer policy.
  ```
- **User says "just dump everything, anonymization can come later"** — refuse politely. The whole point is to never produce a non-anonymized artifact that could be ingested by accident. Offer to split into a longer, structured session instead.
- **Re-running over the same window** — if `handoff/YYYY-MM-DD.md` exists with `status: ingested`, ask: "That dump was already ingested. New file as `-2`, or are you redoing the categorization?"

## Do not

- Do not read from `raw/` during this skill. Hard rule.
- Do not include `1on1s/` or `people/` content. Even anonymized, those notes carry too much identifying texture.
- Do not write to `~/second-brain/`.
- Do not auto-infer placeholders without showing the substitution to the user. They approve each anonymized line.
- Do not delete or modify source notes in `brain/`. Read-only.
