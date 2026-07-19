# Changelog

All notable changes to the **brain-up** scaffold are recorded here. This is the
feature ledger for every brain minted from `up.sh`: the single place to see what
a new brain gets, and what an older brain is missing.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

- **MAJOR** — a change that requires manual migration of an existing brain
  (a moved/renamed directory, a breaking frontmatter or script change).
- **MINOR** — a new, backward-compatible feature (a new skill, script, template,
  or workflow). Safe to adopt by re-running `up.sh --init`.
- **PATCH** — fixes and doc tweaks with no new capability.

The current scaffold version lives in [`VERSION`](VERSION).

## How a generated brain uses this file

Every brain scaffolded by `up.sh --init` carries a `.brain-version` pin at its
root recording the scaffold `version:` it was last generated/upgraded from, and
ships a **`scripts/brain-upgrade`** helper that automates the whole loop:

```bash
scripts/brain-upgrade                  # dry-run: your pin vs latest + this changelog
scripts/brain-upgrade --apply          # add files this brain is missing, re-stamp the pin
scripts/brain-upgrade --apply --force  # also overwrite changed scaffold files
```

`--apply` delegates to `up.sh --init` under the hood — **non-destructive**: it
only *adds* files that are missing (new skills, scripts, templates); your notes
and existing files are never touched. `--force` additionally overwrites changed
scaffold files (e.g. an updated `scripts/lint`), prompting first. Either way it
re-stamps `.brain-version` to the current version.

`brain-upgrade` fetches from the `source`/`ref` recorded in the pin (GitHub by
default). Under the hood it downloads and delegates to `up.sh --init`.

The version diff (your pin → latest) is the checklist of features to wire in.

## [Unreleased]

## [0.3.1] — 2026-07-19

### Fixed

- **Skill files renamed to lowercase `SKILL.md`.** The `personal` template's
  skill files (`bootstrap-company-brain`, `budget-planning`, `capture`,
  `daily-journal`, `grill-me`, `ingest-book`, `ingest-source`, `lint-vault`,
  `process-inbox`, `search-brain`, `vocab-add`, `weekly-review`,
  `write-a-skill`) shipped with an uppercase `SKILL.MD` extension, which some
  tools (including Claude Code's skill auto-discovery) don't recognize.
  Renamed to `SKILL.md` and updated the remaining `SKILL.MD` references in
  `second-brain.mdc`.

## [0.3.0] — 2026-07-19

### Added

- **Routines system.** New `templates/personal/routines/` folder with an
  `install` script that registers routine prompts as scheduled triggers for
  Claude Code (local + CCR) or Cursor via crontab. Each routine `.md` file
  carries its own `cron:` schedule in YAML frontmatter; `--cron` overrides it.
  Supports `--list` and `--remove` for management.
- **`vocab-practice` routine.** Daily vocab quiz (default 7:15 AM GMT+7).
  Picks 5 words from `brain/resources/english/vocab/` not seen in the last
  14 days, sends a push notification, quizzes the user with example sentences,
  assesses meaning/collocation/grammar, and logs progress with spaced
  repetition (misused words resurface sooner).
- **`grammar-practice` routine.** Daily grammar quiz (default 12:00 PM GMT+7).
  Same structure as vocab-practice but draws from
  `brain/resources/english/grammar/`.
- **`grammar-entry` note type.** Individual grammar notes in
  `brain/resources/english/grammar/`, exempt from `updated:` requirement
  in lint (same as `vocab-entry`).

### Changed

- **English language resources restructured under `brain/resources/english/`.**
  Vocab moves from `brain/resources/vocab/` to `brain/resources/english/vocab/`;
  grammar is new at `brain/resources/english/grammar/`. `brainlib.py` now
  supports nested subfolder type mappings (deepest match wins).
- **`vocab-add` skill rewritten.** Creates individual files with proper
  frontmatter at `brain/resources/english/vocab/<word>.md` instead of appending
  to a single dictionary file. Adds duplicate check. All PTE references removed.
- **`second-brain.mdc` rules** — trigger table cleaned of PTE reference.

### Migration (existing brains with `brain/resources/vocab/`)

```bash
git mv brain/resources/vocab brain/resources/english/vocab
mkdir -p brain/resources/english/grammar
scripts/brain-upgrade --apply --force   # pull updated scripts & skills
python3 scripts/regen-indexes
python3 scripts/lint
```

## [0.2.1] — 2026-07-12

### Fixed

- **Personal init/upgrade no longer recreates legacy top-level folders.** Removed
  stale `.gitkeep` placeholders from `templates/common/brain/{inbox,journal,people}/`
  and `templates/personal/brain/{career,goals}/`. Company placeholders moved to
  `templates/company/brain/`.
- **`up.sh --init --type personal` prunes** empty legacy `brain/{inbox,goals,journal,people,career}/`
  dirs after copy (skips any folder with real content notes).

## [0.2.0] — 2026-07-12

**Breaking migration for personal brains.** Existing personal brains must move folders
manually (or follow the migration steps below) before adopting this release.

### Changed (breaking — personal brain)

- **PARA-aligned layout.** Career, goals, journal, and people move under
  `brain/resources/` as reference subfolders (`resources/career/`, `resources/goals/`,
  `resources/journal/`, `resources/people/`).
- **Inbox moves to `raw/inbox/`.** Captures are unprocessed raw material; `capture`
  writes to `raw/inbox/`, `process-inbox` reads from there.
- **Scripts updated:** `brainlib.py`, `regen-indexes`, `digest`, `lint`, `freshness`,
  `add-types` — resource subfolder type detection, subfolder indexes, maturity checks
  scoped to top-level knowledge notes only.
- **All personal skills and agent contract** updated for new paths.

### Added

- **`budget-planning` skill** (personal).
- **`brain/templates/decision.md`** for personal decision records in
  `brain/resources/decisions/`.
- **Template stubs** for `raw/inbox/` and `brain/resources/{goals,journal,people,career}/`.

### Migration (personal brain, 0.1.0 → 0.2.0)

```bash
git mv brain/career brain/resources/career
git mv brain/goals brain/resources/goals
git mv brain/journal brain/resources/journal
git mv brain/people brain/resources/people
git mv brain/inbox raw/inbox
# Fix wiki links: ../goals/ → ../resources/goals/ from projects/areas/archive
# Fix wiki links: ../areas/ → ../../areas/ from resources/journal/
scripts/brain-upgrade --apply --force   # pull updated scripts & skills
python3 scripts/regen-indexes
python3 scripts/lint
```

Company brains are unchanged (still use `brain/inbox/`, top-level `journal/` and `people/`).

## [0.1.0] — 2026-07-05

First versioned release. Establishes the baseline feature set every brain
inherits, plus the versioning mechanism itself.

### Added

- **Versioning & upgrade contract.** A root `VERSION` file, this `CHANGELOG.md`,
  and a `.brain-version` pin written into every generated brain so brains can
  diff against the scaffold and adopt new features deliberately.
- **`scripts/brain-upgrade`.** A helper shipped in every brain that checks the
  pin against the latest scaffold version on GitHub, prints the changelog delta,
  and (with `--apply`) fetches and runs `up.sh` to pull in missing files.
- **`up.sh` — one command, two modes.** Sync mode (clone/pull/link rules for an
  existing brain) and init mode (`--init`) to scaffold a brand-new personal or
  company brain from `templates/`. Supports `--type`, `--target`, `--name`,
  `--git-init`, `--force`, and self-fetches templates when run via `curl | bash`.
- **Provider-agnostic scaffold.** `templates/common/` (shared layout: `brain/`
  PARA folders, `raw/`, note templates, `.gitignore`) overlaid by
  `templates/personal/` or `templates/company/`.
- **No-AI automation layer (`scripts/`):** `lint` (frontmatter, maturity,
  project→goal/area linkage, link resolution), `regen-indexes` (generated
  `index.md` maps), `freshness` (staleness report), `digest` (rollup),
  `add-types` (backfill `type:` frontmatter), and the shared `brainlib.py`.
- **CI backstop.** A `.github/workflows/brain-ci.yml` that runs lint and
  stale-index checks on every push. The agent runs the same checks before
  committing; CI catches anything that slips through.
- **Frontmatter convention.** OKF-style `type:` per folder; `lint` enforces
  `type`, `title`, `created`, `updated` on every content note; resources declare
  `maturity: atomic | distilled | stub`.
- **Personal brain skills:** capture, daily-journal, process-inbox, weekly-review,
  search-brain, lint-vault, ingest-source, ingest-book, grill-me,
  bootstrap-company-brain, receive-handoff, write-a-skill, vocab-add.
- **Company brain skills:** capture, daily-journal, process-inbox, weekly-review,
  monthly-dump — plus the work↔personal handoff boundary (`handoff/`).

[Unreleased]: https://github.com/hqtoan94/brain-up/compare/v0.3.0...HEAD
[0.3.0]: https://github.com/hqtoan94/brain-up/compare/v0.2.1...v0.3.0
[0.2.1]: https://github.com/hqtoan94/brain-up/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/hqtoan94/brain-up/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/hqtoan94/brain-up/releases/tag/v0.1.0
