# Goals

Where direction is set and held to. Two layers:

- **Vision** (`vision.md`) — identity, 5–10 year horizon. Changes rarely.
- **Year** (`YYYY/year.md`) — a handful of outcomes for the year, tied to vision. The unit where commitment lives **before** projects exist.

Anything below the year level is a **project**, not a goal entry. Quarterly files (`YYYY/qN.md`) exist only as **retro containers** — see below.

## Structure

```
goals/
├── vision.md           ← long-term vision (5–10 year horizon)
├── 2026/
│   ├── year.md         ← yearly outcomes, each linking to projects
│   ├── q1.md           ← quarter retro container (mid + end of quarter)
│   ├── q2.md
│   ├── q3.md
│   └── q4.md
└── 2027/…
```

## The cascade

- **Vision** → who I'm becoming, what matters. Re-read quarterly. Rewrite yearly if something's genuinely shifted.
- **Year** → 3–7 outcome statements for the year. Each links to the project(s) that will deliver it.
- **Project** → the actual work, in `projects/`. Has a `deadline:` and `linked_goal:` pointing back at the year file (or a heading inside it).
- **Quarter file** → retro container only. No goal entries. Lists projects whose `deadline:` falls in that quarter (rolled up during weekly review), plus the mid-quarter check-in and end-of-quarter retro.

The working unit is the **project**. The year file is the layer where you commit before you decompose. Quarters exist for the rhythm of reflection, not as a third tracking layer.

## Why no per-quarter goals

Quarterly goals duplicate projects. Every "quarterly goal" worth tracking has a deadline, an outcome, and an owner — that's a project. Tracking the same outcome in two places (a quarter file *and* a project file) creates drift; the quarter file always loses. So the quarter file holds reflection, not commitments.

## Year-goal quality

Each outcome on `year.md` should be:

- **Specific** — a reader who's never met me knows exactly what counts.
- **Measurable** — I can say yes/no on Dec 31.
- **Owned by me** — depends primarily on my actions.
- **Decomposed** — links to the project(s) that will deliver it. A year goal with no linked project for >30 days is a wish, not a goal.

Year-goal entry shape (paste directly into `year.md`):

```md
### G<N> — <outcome title>
- **Outcome (measurable):** <what's true on Dec 31 that isn't true today>
- **Why it matters:** <link to vision / area>
- **Linked project(s):** [[../../../projects/…]]
- **Status:** not-started | in-progress | done | dropped
- **Notes:**
```

## Review cadence

- **Weekly** — open `year.md`, scan each goal's linked projects for movement, append a one-line status note. (Driven by `weekly-review`.)
- **Mid-quarter** — open the quarter file, brief check-in: which year goals are tracking, which are slipping, what to drop or accelerate.
- **End of quarter** — same file: retro on what shipped, what didn't, what to carry forward.
- **End of year** — rewrite `year.md`. Re-read `vision.md`. Consider edits.
