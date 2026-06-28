---
name: bootstrap-company-brain
description: One-shot setup for a new (or newly tracked) employer. Creates a private company brain at ~/work/<company>/ using brain-up, and adds an anonymized career stub to brain/career/ in this personal brain. Use when the user says "start a new job", "bootstrap a company brain", "set up a work brain", "I'm starting at <company>", or "new job at <company>".
---

# Bootstrap Company Brain

One-time setup when the user starts (or starts tracking) a new employer. Two outputs:

1. A new company brain at `~/work/<company>/` — scaffolded with `brain-up` (`up.sh --init --type company`).
2. An anonymized career stub here — `brain/career/<start-year>-present-<role>.md` — using `brain/templates/career-role.md`.

The company brain is for company-owned content (real names allowed). The career stub is the only thing this personal brain learns about the new role, and it stays anonymized as `$COMPANY`.

## Process

1. **Frame, then confirm.** Reply with:
   > I'll create `~/work/<company>/` as the new company brain (real names allowed there) and add an anonymized career stub to this repo's `brain/career/` (`$COMPANY` placeholder, generic role title). OK?

   Wait for explicit OK before continuing.

2. **Gather inputs in one batched message.**
   - **Company name** (used for the folder, will be kebab-cased).
   - **Generic role title** — e.g. "Senior Software Engineer". Strip company branding if present.
   - **Start date** — default to today.

3. **Compute paths.**
   - `<company-kebab>` — lowercase, hyphens (e.g. "Gridware" → `gridware`).
   - `<role-kebab>` — lowercase, hyphens (e.g. "Senior Software Engineer" → `senior-software-engineer`).
   - `<start-year>` — year of start date.
   - Company repo dir: `~/work/<company-kebab>/`.
   - Career stub path: `brain/career/<start-year>-present-<role-kebab>.md`.

4. **Pre-flight checks.** Stop and ask the user before clobbering anything:
   - `~/work/<company-kebab>/` already exists.
   - The career stub already exists at the computed path.

5. **Create the company brain.**
   - Ensure `~/work/` exists; create if not.
   - Run `brain-up` in init mode (it copies the company boilerplate and sets the README name):
     ```bash
     ~/brain-up/up.sh --init --type company --target ~/work/<company-kebab> --name "<Company> Brain"
     ```
     Adjust the path to `up.sh` to wherever `brain-up` is cloned on this machine.
   - The company template ships with the **work-brain** sub-agent (`.claude/agents/work-brain.md`) and five skills (`capture`, `daily-journal`, `process-inbox`, `weekly-review`, `monthly-dump`) pre-installed. The user can use them immediately on first open.
   - **Do not** pass `--git-init`; leave git setup to the user. Mention it in the final summary.
   - **Do not** add a git remote.

6. **Create the personal-side career stub.**
   - `cp brain/templates/career-role.md brain/career/<start-year>-present-<role-kebab>.md`.
   - Fill the YAML frontmatter:
     - `title:` → role title (e.g. "Senior Software Engineer")
     - `created:` and `updated:` → today
     - `tags: [career]`
     - `employer: $COMPANY` (placeholder; never the real name)
     - `started: <YYYY-MM>`
     - `ended: present`
     - `level:` → leave with a `# TODO` if the user hasn't said
   - Replace `<role title>` and `<start year>–<end year>` in the H1 with concrete values.
   - Leave section bodies as the template's placeholders — the user fills them over time.

7. **Print the summary.** Use this shape:

   ```
   Done.

   Company brain → ~/work/<company-kebab>/
     - Has its own AGENTS.md → routes to .claude/agents/work-brain.md (real names allowed).
     - Skills pre-installed: capture, daily-journal, process-inbox, weekly-review, monthly-dump.
     - See CHEATSHEET.md in the new repo for trigger phrases and where things go.
     - Next: cd ~/work/<company-kebab> && git init   (no personal remote).
     - Then open it in Cursor on the work device.

   Personal brain → brain/career/<start-year>-present-<role-kebab>.md
     - Anonymized as $COMPANY.
     - Lessons land here over time via the `receive-handoff` skill — the user runs
       `monthly-dump` in the work repo, reviews the handoff/YYYY-MM-DD.md file,
       then runs `receive-handoff` here to ingest.

   Reminders:
     - The two brains run concurrently and independently. Don't cp files manually
       across the boundary; use monthly-dump → receive-handoff.
     - Don't push the company repo to a personal remote.
   ```

## Sensitivity rules

- The company's real name is allowed in the company repo (folder name, README title) and **only** there.
- The career stub here uses `$COMPANY`. Never write the real company name into the personal brain's filesystem.
- The role title can be the user's literal title if it's generic ("Senior Software Engineer"). If it includes the company's branding ("Gridware Engineer III"), strip the brand ("Engineer III").

## Edge cases

- **Existing employer the user has been at for a while** — same flow; `started:` is the actual start year.
- **No `~/work/` yet** — create it.
- **User asks for a different parent dir** (not `~/work/`) — accept the override; everything else is the same.
- **Personal brain isn't reachable from the agent's CWD** (e.g. running on a work-only device) — do step 5 only and tell the user to add the career stub from a personal-device session.

## Do not

- Do not run `git init` or add a git remote.
- Do not write the company's real name anywhere in the personal brain.
- Do not skip the framing confirmation in step 1, even if the trigger phrase was unambiguous.
