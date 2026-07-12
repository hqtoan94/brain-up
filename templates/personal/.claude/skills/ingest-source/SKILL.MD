---
name: ingest-source
description: Read a source file in raw/, discuss key takeaways with the user, and distill it into brain/ as atomic knowledge notes, updates to relevant resource pages, and (optionally) people notes — leaving the source itself untouched in raw/. Use when the user says "ingest", "ingest this source", "distill raw/...", "process this article", "lift takeaways from <file>", or drops a new file into raw/ with intent to synthesize it.
---

# Ingest Source

Turn a source in `raw/` into synthesized notes in `brain/`. The source stays put — only the distillate crosses into the brain. User drives every write.

This is the inbound side of the Karpathy LLM-wiki pattern: `raw/` is immutable, `brain/` is the compiled wiki.

## Process

1. **Resolve the source.**
   - If the user named a file, use it.
   - Otherwise, list files in `raw/` (recursively, excluding `raw/README.md`) that have **no inbound links** from any `brain/` file — these are un-ingested. If multiple, ask which one.
   - If the file is `private-*.md` or under `private/` → confirm before reading: "This is marked private. Proceed?"

2. **Read the source.** Skim for: claims worth keeping, named people, topics it belongs to, contradictions with atomic notes already in `brain/resources/`.

3. **Sensitivity re-check.** Even though it's in personal `raw/`, scan for company-sensitive signals (see the `capture` skill's list). If any hit, pause:
   > This source contains company-specific content (names / quotes / specifics). It probably belongs in the company repo's `raw/`, not here. Want to:
   > 1. Move it to `~/work/<company>/raw/` and stop here.
   > 2. Anonymize the takeaways as we go (placeholders, generic numbers).
   > 3. Continue as-is — you're confident it's portable.

4. **Surface candidate lifts** in one readout. Don't write yet:
   > **Source:** `raw/karpathy-llm-wiki.md` (Karpathy, 2026-04-03)
   >
   > **Candidate atomic claims (5):**
   > a. LLMs should compile knowledge, not just retrieve at query time.
   > b. The wiki is a persistent, compounding artifact.
   > c. Two-layer split: `raw/` immutable, `wiki/` LLM-owned.
   > d. Schema files (CLAUDE.md / AGENTS.md) are the configuration layer.
   > e. Index + log replace embedding-based RAG at moderate scale.
   >
   > **Topic this fits:** `brain/resources/personal-knowledge-management.md` (exists, `maturity: distilled`) — would update Key ideas + Sources.
   >
   > **People mentioned:** Andrej Karpathy (no existing note).
   >
   > **Contradicts:** nothing in `brain/resources/` matches.
   >
   > Which to lift? (any, all, none, or pick by letter)

5. **Per user-approved item, one at a time:**
   - **Atomic claim** → create `brain/resources/<claim-slug>.md` from `brain/templates/resource.md` with `maturity: atomic`. Title is the claim as a sentence (per the convention in `brain/resources/README.md`). Body is your synthesis in the user's voice, not a verbatim quote. The `source:` field cites the file in `raw/` (relative path).
   - **Distilled topic page update** → if `brain/resources/<topic>.md` exists with `maturity: distilled`, append the source to its `## Sources` section and add the new atomic notes under `## Key ideas`. If the topic page doesn't exist, default to atomic — distillation happens later, not on first ingest.
   - **Person note** → create or append to `brain/resources/people/<name>.md`. Only if there's durable signal worth tracking. If unclear, skip and ask.
   - **Confirm each write** with a one-liner; move to next.

6. **Backlink pass.** When done, every new atomic note's `source:` frontmatter cites `raw/<source>`. Any updated distilled page links to the new atomic notes. The source has gained inbound links from `brain/` — `lint-vault`'s un-ingested check now passes for it.

7. **Summarize at the end.**
   > **Ingested:** `raw/karpathy-llm-wiki.md`
   > - 3 new atomic notes in `brain/resources/`
   > - 1 distilled page updated (`brain/resources/personal-knowledge-management.md`)
   > - 1 person note created (`brain/resources/people/andrej-karpathy.md`)
   > - Source unchanged in `raw/`.

## Rules

- **Source stays immutable.** Never edit files in `raw/`. If the user wants a fix, they edit the source manually; the next ingest re-reads it.
- **User's voice, not verbatim.** Atomic notes synthesize the claim in the user's voice. Brief quotes are fine with citation; never copy a paragraph wholesale.
- **One item at a time** during writes. Same shape as `process-inbox`. Show, suggest, wait, write, confirm.
- **Cite the source** in every atomic note's `source:` frontmatter, using the path under `raw/`.
- **Default is atomic.** New notes from this skill always start at `maturity: atomic`. Don't promote to `distilled` here — that's a separate, deliberate distillation pass.
- **Cross-link.** Every new atomic note gets a `## Related` section linking to ≥1 existing note in `brain/resources/` when there's a real connection. If there isn't, leave it empty rather than fabricate.
- **Sensitivity is a hard gate.** Same rules as `capture` — never write company-sensitive content into `brain/` without per-item anonymization.
- **No batch ingests.** One source per session. If the user has 10 articles in `raw/`, walk them one at a time across sessions — the value is the conversation, not the throughput.

## Cadence

- Ingest **as sources arrive** — don't let `raw/` accumulate. `lint-vault` surfaces un-ingested sources during a vault health check.
- Run a `lint-vault` pass after a heavy ingest stretch — it catches dangling links and orphan atomic notes the ingest may have created.
