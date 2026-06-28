# brain-up

> One command to bring a **second brain** up on any machine — and to mint a new one from scratch.

`brain-up` is a tiny, dependency-free tool (`up.sh`) for running plain-Markdown "brain" repositories that an AI agent operates on your behalf. It clones, syncs, and wires a brain into Cursor / Claude Code, and it can scaffold a brand-new personal or company brain — agent, skills, rules, cheatsheet, and templates included.

---

## The mindset

### Why a second brain

Your memory is lossy, your attention is scarce, and your notes rot. A *second brain* is a durable, plain-text store of what you know, want, and are working on — and an AI agent that reads and writes it for you. You think out loud; the agent files, retrieves, links, and reminds. The chat is throwaway; **the brain is the artifact that compounds.**

Everything is Markdown + YAML frontmatter. No database, no app, no lock-in. It works in Obsidian, VS Code, `grep`, and any LLM. You can back it up, diff it, and read it in ten years.

### PARA × Karpathy's LLM wiki

`brain-up` brains merge two ideas:

- **[PARA](https://fortelabs.com/blog/para/)** organizes *action*: **P**rojects (finite, deadline), **A**reas (ongoing standards), **R**esources (things worth knowing), **A**rchive (done/inactive). It answers *"where does this go?"*
- **[Karpathy's LLM wiki](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f)** organizes *knowledge*: an LLM shouldn't re-derive understanding from raw documents on every query — it should incrementally maintain a **persistent, interlinked wiki** that sits between you and the sources.

The fusion gives every brain **two content layers**:

```
raw/   →   brain/resources/        plus the rest of brain/ (PARA + life-OS)
(sources)  (your synthesis)        projects, areas, journal, goals, people, career…
```

- **`raw/`** — immutable source material: articles, transcripts, exports, book dumps. Evidence, never edited.
- **`brain/resources/`** — *your* synthesis. Every note declares `maturity:` — **`atomic`** (one claim, claim-titled, Zettelkasten-style) or **`distilled`** (a topic page compiled from many atoms). Knowledge flows upward: capture atoms, distill clusters later.

The schema itself — directory layout, conventions, sensitivity rules — lives in the agent contract (`.claude/agents/*.md`), exactly the "config file that tells the LLM how to ingest, query, and lint" that Karpathy describes.

### The agent runs the brain. You run the raw.

This is the division of labor that keeps the system honest:

- **You own `raw/`.** You drop in the sources, the captures, the half-formed thoughts. Friction-free in, organize later. The raw input is *yours* — lived, opinionated, first-person.
- **The agent runs `brain/`.** It files captures into PARA, distills `raw/` into atomic notes, cross-links, lints for orphans and drift, and prompts your weekly review. You converse; it maintains.

Neither side does the other's job. The agent never invents your history; you never hand-maintain the wiki graph. Co-authored, not LLM-authored.

### Personal vs. company — a hard boundary

A brain is **portable**: it travels with you between employers, so company-owned content must not leak into it. `brain-up` ships two brain types:

- **personal** — your career (anonymized), generalizable lessons, goals, projects, people. Lives at `~/second-brain/`.
- **company** — employer-specific: real names, products, decisions, meetings, 1:1s. Lives on the work device at `~/work/<company>/`, never pushed to a personal remote.

They run concurrently and independently. The **only** path between them is one-way: the work brain produces an anonymized digest (`monthly-dump` → `handoff/YYYY-MM-DD.md`), and the personal brain ingests it (`receive-handoff`). Work → personal, periodic, deliberate. Nothing flows back.

---

## Quick start

### Bring up an existing brain

```bash
# get brain-up
git clone https://github.com/hqtoan94/brain-up.git ~/brain-up

# first run on a machine clones your brain, then links its rules into Cursor/Claude
BRAIN_REPO=https://github.com/<your-username>/<your-brain-repo>.git ~/brain-up/up.sh

# every run after: pull + relink
~/brain-up/up.sh
```

### Mint a brand-new brain from scratch

```bash
# a personal second brain
~/brain-up/up.sh --init --type personal --target ~/second-brain --name "Second Brain" --git-init

# a company brain (keep on the work device)
~/brain-up/up.sh --init --type company --target ~/work/acme --name "Acme Work Brain" --git-init
```

`--init` copies the boilerplate from [`templates/`](templates/), fills in `{{NAME}}`/`{{DATE}}`, and links the rules immediately. Then open the folder in Cursor or Claude Code — the agent auto-loads `AGENTS.md` and you can `capture`, `journal`, `weekly review`, `ingest`, and more on day one.

---

## What `up.sh` does

`up.sh` is the single entry point — like `docker compose up`, the same command on the first run and every run after. It has two modes:

**Sync mode (default):**

1. **Bootstrap** — clone `BRAIN_REPO` if the brain isn't on this machine yet.
2. **Pull** — `git pull --ff-only`, skipped cleanly if just-cloned, no upstream, or the tree is dirty.
3. **Link rules** — symlink every rule into user-level config so any project on the machine can route brain triggers here.

**Init mode (`--init`):** scaffold a new standalone brain from `templates/`, then link its rules.

### Why link only rules, not skills?

Token economics. A skill placed at user level injects its `description` into *every* editor session's system prompt — even when you're debugging unrelated code. A **rule** is a single tight pointer the model loads only when something brain-shaped comes up; it then reads the relevant `.claude/skills/<name>/SKILL.md` from disk on demand. One Read when needed, near-zero context cost otherwise.

### What gets linked

If the target app config dirs exist:

```
~/.claude/rules/<name>.mdc  ->  $BRAIN/.claude/rules/<name>.mdc
~/.cursor/rules/<name>.mdc  ->  $BRAIN/.claude/rules/<name>.mdc   (if ~/.cursor exists)
```

`up.sh` never overwrites a real file at a destination — it only creates or repairs symlinks, and exits non-zero if it finds a real file in the way.

### Environment variables

| Var | Default | Meaning |
|---|---|---|
| `BRAIN` | `~/second-brain` | local path to the brain |
| `BRAIN_REPO` | _(empty)_ | clone URL, used when `BRAIN` doesn't exist yet |
| `RULES_DIR` | `$BRAIN/.claude/rules` | source rules directory to link from |
| `TARGETS` | `claude,cursor` | which app configs to link into |
| `TEMPLATES_DIR` | `<script dir>/templates` | template source for `--init` |

### `--init` flags

| Flag | Required | Meaning |
|---|---|---|
| `--type <personal\|company>` | yes | which brain to scaffold |
| `--target <path>` | yes | output directory |
| `--name <name>` | no | display name (defaults to folder name) |
| `--git-init` | no | run `git init` in the new brain |
| `--force` | no | allow writing into a non-empty directory |

---

## What's in a generated brain

All boilerplate lives as real files under [`templates/`](templates/), so nobody needs access to anyone else's brain — `brain-up` is fully standalone. Each brain ships with an agent, sub-agent, rule, `CHEATSHEET.md`, and a working skill set.

```
templates/
├── common/      shared layout: raw/, brain/* folders, note templates, .gitignore
├── personal/    AGENTS.md + CHEATSHEET.md
│                .claude/agents/second-brain.md   (full operating contract)
│                .claude/rules/second-brain.mdc   (user-level trigger router)
│                .claude/skills/   capture · daily-journal · process-inbox · weekly-review
│                                  search-brain · lint-vault · ingest-source · ingest-book
│                                  grill-me · bootstrap-company-brain · receive-handoff
│                                  write-a-skill · vocab-add
│                brain/goals/, brain/career/, career-role template
└── company/     AGENTS.md + CHEATSHEET.md
                 .claude/agents/work-brain.md     (work brain contract + handoff ritual)
                 .claude/rules/work-brain.mdc
                 .claude/skills/   capture · daily-journal · process-inbox
                                   weekly-review · monthly-dump
                 handoff/, brain/meetings/, brain/decisions/, brain/1on1s/
                 1on1 / meeting / decision templates
```

`up.sh --init` copies `common/` first, then overlays the chosen type. Edit anything under `templates/` to change what new brains look like. Placeholders in any template file:

- `{{NAME}}` — replaced with `--name`
- `{{DATE}}` — replaced with today's date (`YYYY-MM-DD`)

---

## Daily moves (once a brain is up)

| You say… | The agent… |
|---|---|
| "Capture: *idea*" | drops a timestamped note into `brain/inbox/` |
| "Journal" | opens/creates today's file in `brain/journal/` |
| "What do I know about X?" | searches the vault and answers from your notes |
| "Process my inbox" | files inbox items into PARA |
| "Ingest `raw/<file>`" | distills a source into atomic / distilled notes |
| "Weekly review" | walks goals, projects, and reflections |
| "Lint the vault" | finds orphans, broken links, drift |
| "Start a new job" | bootstraps a company brain + anonymized career stub |

---

## Compatibility

macOS and Linux (bash). On Windows, run under WSL or Git Bash; note that rule-linking relies on symlinks, which need WSL or Developer Mode / admin under Git Bash. `--init` scaffolding is the most portable part.

## License

MIT
