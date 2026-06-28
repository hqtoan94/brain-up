---
name: vocab-add
description: Add a new word to the PTE vocabulary dictionary at brain/resources/pte-vocab-dictionary.md. Use when the user says "add word", "add vocab", "add to dictionary", "define word for PTE", or gives a word to look up for their PTE reading practice.
---

# PTE Vocab Add

Add a new vocabulary word to `brain/resources/pte-vocab-dictionary.md` with its definition and usage examples. The user provides only the word; the agent derives everything else.

## Process

1. **Receive the word.** If the user's message is just a word or a phrase like "add: <word>", extract the word. If no word is present, ask: "Which word do you want to add?"

2. **Generate the entry** using your own knowledge — do not ask the user. Produce:
   - **Word line:** the word itself followed by its part(s) of speech in italics. For nouns, list both singular and plural forms separated by `/`, e.g. `deliberation / deliberations *(noun)*`.
   - **Category:** 2–3 topic domains where this word most commonly appears in academic or professional English (e.g. Law, Finance, Science, Politics, Medicine, Technology, Business, Sports, Environment, Psychology). Pick the most specific and useful labels for a PTE reading context.
   - **Definition:** one bullet per distinct part of speech, plain and precise. For verbs, append common conjugations inline (e.g. *runs / ran / running*). For nouns, use two bullets — one for singular, one for plural — when the plural carries a distinct or extended meaning. Favour definitions that reveal how the word behaves in formal or academic English (PTE context).
   - **Examples:** 2–3 sentences that show the word used naturally, covering different word forms where they exist (e.g. scrutinise, scrutiny, scrutinised, scrutinies). Ensure at least one example uses a plural noun form where applicable. Keep sentences concise and at PTE academic reading level.

3. **Format the entry** exactly as:
   ```
   ### <Word>

   - **Word:** <word> *(<pos>)* | <singular> / <plural> *(noun)*
   - **Category:** <topic1>, <topic2>, <topic3>
   - **Definition:**
     - *verb* — <definition>; *<conjugations>*
     - *adjective* — <definition>
     - *noun (singular: <word>)* — <definition>
     - *noun (plural: <words>)* — <definition>
   - **Examples:**
     1. <example sentence>
     2. <example sentence>
     3. <example sentence — omit if only 2 natural examples exist>
   ```

4. **Locate the insertion point** in `brain/resources/pte-vocab-dictionary.md`. Entries live under the `## Words` heading in alphabetical order by the word's lowercase form. Find the right position — if the word is already present, skip and tell the user.

5. **Write the entry** by editing the file. Insert a blank line before the new `### <Word>` heading and after the last example if followed by another entry.

6. **Update frontmatter.** Set `updated:` to today's date (`YYYY-MM-DD`).

7. **Confirm and display.** Reply with a single line "Added **<Word>** to the PTE dictionary." followed by the full entry exactly as it was written to the file, formatted in Markdown.

## Rules

- Never ask the user for the definition or examples — derive them yourself.
- Keep definitions free of jargon; write for someone who reads academic English but is not a native speaker.
- If a word has only one part of speech, omit the extra definition bullets.
- Maintain strict alphabetical order (case-insensitive, ignore articles).
- Do not add commentary, synonyms sections, or etymology unless the user asks.
- Do not modify any other part of the file.
