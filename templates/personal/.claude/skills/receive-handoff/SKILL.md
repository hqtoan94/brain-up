---
name: receive-handoff
description: Ingest an anonymized handoff/YYYY-MM-DD.md file produced by a work brain's monthly-dump skill, and write its sections into the personal brain (brain/career/, brain/resources/ as atomic notes, project/area logs). Use when the user says "receive handoff", "ingest handoff", "process the handoff from work", "lift the dump", or "ingest ~/work/<company>/handoff/...".
---

# Receive Handoff (Personal Side of the Work → Personal Bridge)

The inbound counterpart to a work brain's `monthly-dump`. Reads a single, already-anonymized `handoff/YYYY-MM-DD.md` file from a work brain repo and writes the right pieces into the personal brain.

This is the only legitimate channel for content moving from a work brain into here.

## Hard rules

1. **Source is `handoff/YYYY-MM-DD.md` only.** Never read other folders in the work brain — not `brain/`, not `raw/`, not `meetings/`, not `1on1s/`, nothing else. The handoff file is the contract.
2. **Source must already be anonymized.** Re-scan it as a sanity check (see Sensitivity re-check below). If anything looks like it slipped through, pause and surface it; never silently ingest.
3. **Per-item user approval before any write to this brain.** Same shape as `process-inbox` — show, suggest, wait, write, confirm.
4. **The handoff file is read-only from this skill.** The only mutation is updating its frontmatter (`status: ingested`, `ingested_at:`) at the end, in the source repo. No content edits.

## Process

### 1. Resolve the source file

- If the user named a path → use it.
- Otherwise → ask for the path: "Which handoff file? (e.g. `~/work/gridware/handoff/2026-04-30.md`)".
- Verify the file exists and has the expected frontmatter shape (`window_start`, `window_end`, `source_repo`, `status`).
- If `status: ingested` already → ask: "This was marked ingested on `<date>`. Re-ingest anyway, or stop?"

### 2. Sensitivity re-check

Read the file end-to-end. Scan for:

- Proper-noun product / customer / vendor names that don't look generic.
- Quoted speech attributed to a named person ("Alex said…") — only generic roles ("my manager") should appear.
- Specific business numbers (revenue, headcount, ARR, exact request rates without an order-of-magnitude hedge).
- URLs to internal systems, ticket IDs, Slack channel names.
- Anything that reads as obviously about a specific real entity even after substitution.

If any hit:

> Found possible identifying content in the handoff:
> - line N: "…"
> - line N: "…"
>
> The work brain's `monthly-dump` should have anonymized these. Two options:
> 1. **Stop, fix the handoff in the work repo, re-run.** Safer.
> 2. **Continue, re-anonymizing on the fly.** I'll propose redactions per item before writing.

Default to option 1.

### 3. Identify the target role file

The handoff describes work at one employer. Resolve which `brain/career/<role>.md` file it lands on:

- Look for an active role file (`ended: present`).
- If exactly one → use it. Confirm with user.
- If multiple → ask which.
- If none → tell the user to run `bootstrap-company-brain` first to create the career stub, then come back.

### 4. Walk the four sections

Each section in the handoff maps to a destination here. Walk them in order, **one item at a time**.

#### a. Career

For each bullet under `## Career`:
- Show the bullet.
- Suggest: append to `brain/career/<role>.md` under the appropriate sub-section (Wins, Scope changes, Mentoring, Shipped, etc. — let the user choose if ambiguous).
- Append a date prefix in front of the bullet if not already present: `- YYYY-MM (window_end month) — <bullet>`.
- Confirm.

#### b. Knowledge → atomic resource notes

For each `### <slug>` block under `## Knowledge`:
- Show the block.
- Check if `brain/resources/<slug>.md` already exists.
  - **No** → create it from `brain/templates/resource.md` with `maturity: atomic`. Title is the atomic claim (a sentence). Body is the `_Why it matters:_` text. `source:` is `handoff:<source_repo>:<window_end>`. Tags from the handoff `_Tags:_` line.
  - **Yes** → show a diff-style preview: existing content vs. handoff version. Ask: merge / replace / skip / file as `<slug>-2.md`. **Don't** auto-promote `maturity:` — leave it as it was.
- Confirm.

#### c. Skill log entries

For each `### Target: <path>` block:
- Verify the target file exists in this brain.
- If yes → append the entries under that file's `## Log` section (newest on top).
- If no → ask: "Target `<path>` doesn't exist. Create it (project? area?), file under another path, or skip?"
- Confirm.

#### d. Decisions worth remembering

For each `### <slug>` block under `## Decisions worth remembering`:
- Treat like Knowledge: turn each into `brain/resources/<slug>.md` (`maturity: atomic`) if not present.
- Body shape: combine `_Decision:_`, `_Reasoning (portable):_`, `_Org context (anonymized):_` into the atomic note's main body and Why-it-matters.
- Confirm.

### 5. Backlink the source

After all approved writes:
- The career file gets a line under its log linking back to the handoff: `- See [handoff/<source_repo>/<filename>](path-if-meaningful)` — but only if the work brain is on the same machine and the path is stable. Otherwise just cite it textually: `(via $COMPANY handoff 2026-04-30)`.
- Each new atomic note's `source:` field cites the handoff path.

### 6. Stamp the handoff

Update the source file's frontmatter (in the work brain repo):

```yaml
status: ingested
ingested_at: YYYY-MM-DD
```

This is the only write into the work brain repo. Confirm with the user before doing it.

### 7. Summarize

> **Ingested:** `~/work/gridware/handoff/2026-04-30.md`
> - Career: 3 bullets appended to `brain/career/2026-present-senior-software-engineer.md`
> - Resources (atomic): 4 new notes (2 from Knowledge, 2 from Decisions); 1 merged into existing `brain/resources/dual-write-before-cutover.md`
> - Skill log: 1 entry on `brain/areas/engineering.md`
> - Source stamped `status: ingested`

## Rules

- **One item at a time.** Same as `process-inbox` and `ingest-source`. Show, suggest, wait, write, confirm.
- **User's voice, not verbatim.** Even though the handoff was already drafted, when creating an atomic note you may lightly rephrase to match the personal brain's voice — but never *add* claims. Only what's in the handoff lands.
- **Cross-link.** Every new atomic note gets a `## Related` section linking to ≥1 existing note in `brain/resources/` when there's a real connection.
- **Source citation.** Every new atomic note's `source:` cites the handoff file. The career file's appended bullets reference the handoff window in their date prefix.
- **All handoff content lands as `maturity: atomic`.** Distillation into topic pages happens later, not during ingest.
- **No extras.** Don't infer wins or claims that aren't in the handoff. If the user wants more, they re-run `monthly-dump` over there.
- **No partial states left in the source.** If the user aborts midway, do not stamp `status: ingested`. Leave it `ready` so a future session can pick up.

## Edge cases

- **Source file from an old / superseded handoff** (`status: superseded`) → tell the user; ask whether they really want to re-ingest. Most often they don't.
- **Source file is on a different machine** (e.g. work brain is on the work device, personal brain on personal device) — the user runs `monthly-dump` on the work side, copies the *single approved file* to the personal device (USB, anonymized cloud doc, manual paste), and runs this skill against the local copy. The skill doesn't care where the file came from, as long as it has the expected shape.
- **Handoff is huge** (full-tenure exit dump) → offer to break ingestion into multiple sessions by section. The handoff file is read-only, so multiple sessions over the same file are safe; just track which sections are already done in the user's session memory.
- **Conflicting claims** — an existing atomic or distilled note in `brain/resources/` makes a contrary claim → don't auto-merge. Surface the conflict, ask the user to reconcile manually.

## Do not

- Do not read any path under the work brain other than the named handoff file.
- Do not stamp `status: ingested` until *all* approved items have been written.
- Do not create career stubs from this skill; that's `bootstrap-company-brain`'s job.
- Do not anonymize content here — anonymization is the work brain's responsibility. If you find un-anonymized content, stop.
- Do not write to the work brain's `brain/` or `raw/`. Only the source handoff file's frontmatter.
