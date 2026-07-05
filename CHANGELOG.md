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
  `add-types` (backfill `type:` frontmatter), `install-hooks`, and the shared
  `brainlib.py`.
- **Commit gating.** A tracked `.githooks/pre-commit` hook (regen + stage indexes,
  block on lint errors) and a `.github/workflows/brain-ci.yml` backstop that runs
  the same checks in CI.
- **Frontmatter convention.** OKF-style `type:` per folder; `lint` enforces
  `type`, `title`, `created`, `updated` on every content note; resources declare
  `maturity: atomic | distilled | stub`.
- **Personal brain skills:** capture, daily-journal, process-inbox, weekly-review,
  search-brain, lint-vault, ingest-source, ingest-book, grill-me,
  bootstrap-company-brain, receive-handoff, write-a-skill, vocab-add.
- **Company brain skills:** capture, daily-journal, process-inbox, weekly-review,
  monthly-dump — plus the work↔personal handoff boundary (`handoff/`).

[Unreleased]: https://github.com/hqtoan94/brain-up/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/hqtoan94/brain-up/releases/tag/v0.1.0
