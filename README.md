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

The fastest start is to **create a brand-new brain locally** — no GitHub repo required. You can add git and push to a remote whenever you're ready.

### Create a new brain

Two ways to do it. Both just **create the brain on disk** — they don't touch git, so you can set up version control later (see below).

**Option A — remote one-liner** (nothing to clone; templates are fetched automatically):

```bash
# personal brain at ~/second-brain (the defaults)
curl -fsSL https://raw.githubusercontent.com/hqtoan94/brain-up/main/up.sh | bash -s -- --init

# or pick type / location / name
curl -fsSL https://raw.githubusercontent.com/hqtoan94/brain-up/main/up.sh \
  | bash -s -- --init --type company --target ~/work/acme --name "Acme Work Brain"
```

**Option B — manual** (clone `brain-up`, then run the local script):

```bash
git clone https://github.com/hqtoan94/brain-up.git ~/brain-up

# personal brain at ~/second-brain (the defaults)
~/brain-up/up.sh --init

# or pick type / location / name
~/brain-up/up.sh --init --type company --target ~/work/acme --name "Acme Work Brain"
```

Defaults: `--type personal`, `--target ~/second-brain`, `--name` = the target folder name.

`--init` copies the boilerplate from [`templates/`](templates/), fills in `{{NAME}}`/`{{DATE}}`, and links the rules immediately. Then open the folder in Cursor or Claude Code — the agent auto-loads `AGENTS.md` and you can `capture`, `journal`, `weekly review`, `ingest`, and more on day one.

Re-running `--init` is non-destructive: it only adds missing files and never touches your existing ones.

Every generated brain ships with a `scripts/` directory (lint, index generation, freshness reports, digest, `brain-upgrade`) and a `.githooks/pre-commit` hook that gates commits on lint. If you use `--git-init`, the hooks are installed automatically; otherwise run `scripts/install-hooks` once after your first `git init`.

### Version control is optional (do it later)

You don't need a git repo to use a brain. When you want history and backups, turn the folder into one — either pass `--git-init` when creating it, or set it up yourself afterwards:

```bash
cd ~/second-brain
git init
git add -A && git commit -m "Initialize my brain"
# then, when you have a remote:
git remote add origin https://github.com/<your-username>/<your-brain-repo>.git
git push -u origin main
```

### Already have a brain in a git repo?

Bring it up on any machine — clone (first run) + pull + relink in one step. Run it remotely, with nothing to install:

```bash
curl -fsSL https://raw.githubusercontent.com/hqtoan94/brain-up/main/up.sh \
  | BRAIN_REPO=https://github.com/<your-username>/<your-brain-repo>.git bash
```

…or with a local clone of `brain-up`:

```bash
# first run clones your brain; every run after is pull + relink
BRAIN_REPO=https://github.com/<your-username>/<your-brain-repo>.git ~/brain-up/up.sh
~/brain-up/up.sh
```

---

## What `up.sh` does

`up.sh` is the single entry point — like `docker compose up`, the same command on the first run and every run after. It has two modes:

**Sync mode (default):**

1. **Bootstrap** — clone `BRAIN_REPO` if the brain isn't on this machine yet.
2. **Pull** — `git pull --ff-only`, skipped cleanly if just-cloned, no upstream, or the tree is dirty.
3. **Link rules** — symlink every rule into user-level config so any project on the machine can route brain triggers here.

**Init mode (`--init`):** scaffold a new standalone brain from `templates/`, then link its rules. It only creates the brain — it never touches git. If the bundled `templates/` aren't next to the script (e.g. when piped via `curl | bash`), it downloads them from the `brain-up` repo first. Re-running is non-destructive — it adds only missing files and leaves existing ones untouched; pass `--force` to overwrite from templates (it lists the affected files and asks for confirmation first).

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
| `TEMPLATES_DIR` | `<script dir>/templates` | local template source for `--init` |
| `TEMPLATES_REPO` | `hqtoan94/brain-up` | repo to fetch templates from when none are local |
| `TEMPLATES_REF` | `main` | branch/tag to fetch templates from |

### `--init` flags

| Flag | Default | Meaning |
|---|---|---|
| `--type <personal\|company>` | `personal` | which brain to scaffold |
| `--target <path>` | `~/second-brain` | output directory to create the brain in |
| `--name <name>` | target folder name | display name |
| `--git-init` | _(off)_ | run `git init` in the new brain |
| `--force` | _(off)_ | overwrite existing files from templates (prompts for confirmation first) |

---

## What's in a generated brain

All boilerplate lives as real files under [`templates/`](templates/), so nobody needs access to anyone else's brain — `brain-up` is fully standalone. Each brain ships with an agent, sub-agent, rule, `CHEATSHEET.md`, and a working skill set.

```
templates/
├── common/      shared layout: raw/, brain/* folders, note templates, .gitignore,
│                scripts/ (lint, regen-indexes, freshness, digest, add-types,
│                install-hooks, brain-upgrade),
│                .githooks/pre-commit, .github/workflows/brain-ci.yml
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

Every generated brain also gets a `.brain-version` pin at its root recording the
scaffold version it was minted from — see [Versioning & upgrades](#versioning--upgrades).

### Frontmatter convention

Every note template includes a `type:` field (OKF-style convention) mapping folder to note kind — e.g. `type: project`, `type: area`, `type: resource`. The `scripts/lint` checker enforces `type`, `title`, `created`, and `updated` on every content note. Run `scripts/add-types` to backfill `type:` on existing notes that lack it.

---

## Versioning & upgrades

`brain-up` is a living scaffold: new skills, scripts, and templates land over
time. Versioning is how an already-generated brain finds out what's new and
pulls it in on its own terms.

Three pieces make this work:

- **[`VERSION`](VERSION)** — the scaffold's current [SemVer](https://semver.org/)
  version, the single source of truth.
- **[`CHANGELOG.md`](CHANGELOG.md)** — the feature ledger. Every entry lists the
  concrete files/skills/scripts a version introduced. MINOR = new backward-compatible
  feature (safe to adopt), MAJOR = manual migration required, PATCH = fixes.
- **`.brain-version`** — a pin written into *every generated brain* at its root by
  `up.sh --init`, recording the scaffold version it was minted/last-upgraded from,
  plus the source repo, ref, and generated/stamped dates. It's a plain committed
  file, so `git log` shows a brain's upgrade history.

### Adopting new features in an existing brain

Every generated brain ships a **`scripts/brain-upgrade`** helper that runs the
whole loop — check the pin, show the changelog delta, and pull in what's missing:

```bash
cd ~/second-brain

scripts/brain-upgrade                  # dry-run: your pin vs latest + changelog
scripts/brain-upgrade --apply          # ADD files you're missing, re-stamp the pin
scripts/brain-upgrade --apply --force  # also OVERWRITE changed scaffold files
```

`--apply` is **non-destructive** (only adds missing files; your notes are never
touched) and re-stamps `.brain-version`. It fetches from the `source`/`ref`
recorded in the pin (GitHub by default), downloads `up.sh`, and delegates to
`up.sh --init` — so no local `brain-up` clone is needed.

In **sync mode**, `up.sh` also prints the brain's current pin so you know when
it's time to run `brain-upgrade`.

Because `.brain-version` and the changelog are both plain text, the brain's own
agent can do all of this for you: read the pin, diff it against the changelog,
and offer to wire in the new features.

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
