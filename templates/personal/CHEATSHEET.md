# Cheatsheet

Quick lookups while using the brain. For *what is this* see [`README.md`](README.md); for *how the agent behaves* see the [`second-brain` sub-agent](.claude/agents/second-brain.md) (root [`AGENTS.md`](AGENTS.md) is a thin pointer to it).

## Three rules

1. **Capture > organize.** Friction kills the system. Sort later.
2. **Split > merge.** Atomic notes default. Claim-titled. One idea per file. Promote to distilled later.
3. **Sensitive > safe.** When in doubt about work content, treat as sensitive.

## Where does X go?

| If it is… | It goes to… |
|---|---|
| Random thought, no clear destination | `raw/inbox/` (via "capture: …") |
| Finite effort with a deadline | `brain/projects/<slug>.md` |
| Forever standard / responsibility | `brain/areas/<slug>.md` |
| Atomic claim worth recalling | `brain/resources/<claim>.md` (`maturity: atomic`) |
| Distilled topic page (compiled from atoms) | `brain/resources/<topic>.md` (`maturity: distilled`) |
| Year-level outcome you want by Dec 31 | `brain/resources/goals/YYYY/year.md` (entry, linked to a project) |
| Skill being actively built | a `## Log` section inside the project (end-state) or area (ongoing) it serves |
| A choice being weighed or made | `brain/resources/decisions/YYYY-MM-DD-<slug>.md` (`status: proposed` while weighing, `decided` once made — ADR shape) |
| Recurring weekly commitment (not one-off) | `brain/areas/weekly-recurring-tasks.md`, walked item-by-item during weekly review |
| Date-bound reflection | `brain/resources/journal/YYYY-MM-DD.md` |
| Person you want to remember | `brain/resources/people/<firstname-lastname>.md` |
| Career narrative (anonymized) | `brain/resources/career/<years>-<role>.md` |
| Done / inactive from above | `brain/archive/` (preserve filename, set `status:`) |
| Source material to be ingested | `raw/` (immutable; agent reads, distills into `brain/resources/`) |
| Anonymized handoff from a work brain | a single file you produced via `monthly-dump`; ingest with `receive-handoff` |
| Anything sensitive (private notes) | `private/` or `private-*.md` anywhere (gitignored) |

## Two content layers

```
raw/  →  brain/resources/  (atomic | distilled, declared in frontmatter)
```

- **`raw/`** — verbatim sources, immutable.
- **`brain/resources/`** — your synthesis. Every note has `maturity: atomic | distilled` (or `stub`).
  - **`atomic`** — one claim, claim-titled, <300 words. Default for new notes.
  - **`distilled`** — synthesized topic page. Cites many atoms via `[[link]]`.

Distil when a topic has 5+ atomic notes but no distilled page yet. `lint-vault` flags candidates.

## Work boundary

| Boundary | Strictness | Rule |
|---|---|---|
| **Data** | Hard | Raw company content never lands in this repo's filesystem. Anonymize or send to the company repo. |
| **Session** | Soft | One agent session can read the company repo and write to this one — as long as every write is anonymized + per-item approved. |

Placeholders: `$COMPANY`, `$PREVIOUS_COMPANY_N`, `$CLIENT`, `$PROJECT_X`. Specific numbers → orders of magnitude.

## Cadence

| Cadence | Action |
|---|---|
| Daily | Capture freely. Optional: `journal` (morning intentions / evening reflection). |
| Weekly | `weekly review` — full or lite. Never skip without rescheduling. Year goals + project rollup. |
| As cadence allows | `receive-handoff` whenever a work brain has produced a fresh `handoff/YYYY-MM-DD.md`. |
| Mid-quarter | Open `brain/resources/goals/YYYY/qN.md`, fill the mid-quarter check-in. |
| End of quarter | Open `brain/resources/goals/YYYY/qN.md`, fill the retro. Open the next quarter's file. |
| Yearly | Rewrite `brain/resources/goals/YYYY/year.md`. Re-read `brain/resources/goals/vision.md`; consider edits. |
| Per job | Final `monthly-dump` over there → `receive-handoff` here → archive the work repo. |

## Agent vs. direct edit

| Operation | Tool |
|---|---|
| Typo, one-character fix, reformatting | Direct edit |
| Pasting a long quote / block | Direct edit |
| Dropping a source into `raw/` (article, paper, transcript) | Direct save |
| Editing the agent's own draft | Direct edit |
| Quick capture (anywhere, anytime) | **Agent** (`capture: …`) |
| Process-inbox / weekly-review / exit ritual | **Agent** |
| Distill a `raw/` source into `brain/` notes | **Agent** (`ingest raw/<file>`) |
| Search across many files | **Agent** (`search-brain`) |
| Vault health check (orphans, drift, broken links) | **Agent** (`lint the vault`) |

Rule of thumb: **one keystroke + one decision → edit. Many decisions or cross-file → agent.**

## Triggers (the agent listens for these)

| Say | Agent |
|---|---|
| "capture …" / "remember this" | `capture` |
| "process my inbox" | `process-inbox` |
| "weekly review" / "Sunday review" | `weekly-review` |
| "journal" / "daily entry" | `daily-journal` |
| "what do I know about X" / "search my brain" | `search-brain` |
| "ingest raw/…" / "distill this source" | `ingest-source` |
| "receive handoff" / "ingest the dump from work" | `receive-handoff` |
| "lint the vault" / "find orphans" / "what's rotting" | `lint-vault` |
| "grill me on this" | `grill-me` |
| "start a new job" / "bootstrap a company brain" / "set up a work brain" | `bootstrap-company-brain` |
| "exit ritual" / "I'm leaving $COMPANY" | final `monthly-dump` over there → `receive-handoff` here |

Practice logs (e.g. "I practiced X for 30 min") have no dedicated trigger — they get appended as a `## Log` entry inside the relevant project or area. If neither exists yet, create one first (project if it has an end-state, area if it's ongoing).

## When the system breaks

- **Inbox > 15 items** → run `process-inbox` now.
- **Inbox item > 14 days old** → it's a decision being avoided, not a capture. Force a destination this week.
- **Inbox > 30 items, dread** → declare bankruptcy: move it all to `brain/archive/inbox-bankruptcy-YYYY-MM-DD/`, do a 10-minute lite review, restart.
- **`raw/` source has sat un-ingested for 30+ days** → either it's not actually interesting (move to `brain/archive/`) or you're avoiding the synthesis (run `ingest-source` on it). `lint-vault` flags these.
- **Project hasn't moved in 4 weeks** → archive it (`status: abandoned` + one-line postmortem). Don't let it linger.
- **Active project has no `deadline` or no `linked_goal`/`linked_area`** → it's an area in disguise, or an unnamed goal. Demote, link up, or kill.
- **An area has had no active project under it for 90+ days** → either you're holding the standard on autopilot (fine) or a standard has slipped (spawn a project). Decide which.
- **Year goal has no `Linked project(s):` for 30+ days** → it's a wish, not a goal. Spawn a project, or drop the goal.
- **A practice log entry has nowhere to go** → you don't have a project or area for that activity yet. Create the project (end-state) or area (ongoing) first, then log inside it.
- **A note feels like it doesn't fit anywhere** → it's probably an inbox item you haven't processed yet. Or it's an atomic resource note dressed up as something else.
- **An atomic resource note is past 300 words** → time to either split it into smaller atoms or promote to `maturity: distilled` and add structure.
- **You're editing the agent's output via long prompts** → stop, edit the file directly.

## Defaults under uncertainty

| Question | Default |
|---|---|
| Atomic or distilled? | Atomic (split > merge). Promote later when there's a real cluster to compile. |
| Sensitive or fine? | Sensitive (asymmetric cost). |
| Project or area? | If there's a finish line → project. Otherwise area. |
| New skill — where does it go? | Run the project/area test. End-state → log inside a project. Ongoing → log inside an area. Never a separate folder. |
| New project — goal or area? | At least one of `linked_goal:` / `linked_area:` must be set. If you can't name either, it's not a project — it's an inbox item. |
| Quarterly goal or year goal? | Year. Quarter files are retros; goals only live in `year.md`. |
| Capture or organize first? | Capture. Always capture. |
