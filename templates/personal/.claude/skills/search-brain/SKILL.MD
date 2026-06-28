---
name: search-brain
description: Search the second-brain vault for notes relevant to a query and answer strictly from the user's own notes. Use when user says "what do I know about X", "find notes on X", "search my brain", "what did I say about X", or asks a question about themselves or their work that the vault might answer.
---

# Search Brain

Answer questions using the user's own notes, not outside knowledge. The user owns the truth here — your job is to retrieve and synthesize, not to educate.

## Process

1. **Parse the query.** Identify the topic, any time hints ("this quarter", "last week"), and any folder hints ("in my goals", "in the journal").

2. **Search scope.** Default scope is `brain/`. Only include `raw/` if the user explicitly asks ("check my sources", "look in raw") or if the question is clearly about a source (e.g. "what did that paper say…").

3. **Search strategy (in order):**
   - Filename match (Glob): `brain/**/*<keyword>*.md`
   - Grep title fields in frontmatter for the term
   - Grep body content (use ripgrep via Grep tool, case-insensitive)
   - If narrow, broaden to synonyms the user is likely to have used

4. **Read the top hits.** Prioritize:
   - Exact-title matches
   - Files in `brain/resources/` for conceptual questions (prefer `maturity: distilled` topic pages first if present, then atomic notes)
   - Files in `brain/projects/`, `brain/goals/`, `brain/journal/` for status/personal questions
   - Skip `brain/archive/` unless the user asked to include it or the query is historical

5. **Synthesize the answer.**
   - Quote or paraphrase from the notes.
   - **Cite every claim** with a file path: e.g. `(see brain/resources/spaced-repetition-beats-massed-practice.md)`.
   - If sources conflict, say so and show both.
   - If the vault is silent on the question, say **"No notes on this yet"** — don't fill in with general knowledge unless the user explicitly asks for your outside view.

6. **Offer next moves.** After answering, optionally suggest:
   - A new atomic resource note to capture what they just asked (if it's a good question with no answer yet).
   - Related notes they might have forgotten about.
   - If the topic has many atomic notes but no distilled page, flag it as a distillation candidate.

## Format

```
<direct answer in 1–3 sentences>

### From your notes
- `<file>` — <one-line excerpt or summary>
- `<file>` — <…>

### Related (you may have forgotten)
- `<file>`
```

## Rules

- **Never fabricate a citation.** If you can't point to the file, don't claim it exists.
- **Don't quote `private-*.md` or `private/` files** unless the user explicitly asked to include private notes.
- **Prefer recency** when multiple notes conflict and the question is about current state.
