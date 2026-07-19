---
name: vocab-add
description: Add a new word to the vocabulary collection at brain/resources/english/vocab/. Use when the user says "add word", "add vocab", "add to dictionary", "define word", or gives a word to look up.
---

# Vocab Add

Add a new vocabulary word as an individual note in `brain/resources/english/vocab/`. The user provides only the word; the agent derives everything else.

## Process

1. **Receive the word.** If the user's message is just a word or a phrase like "add: <word>", extract the word. If no word is present, ask: "Which word do you want to add?"

2. **Check for duplicates.** Look for an existing file at `brain/resources/english/vocab/<word>.md` (kebab-case). If it exists, tell the user and stop.

3. **Generate the entry** using your own knowledge — do not ask the user. Produce:
   - **Word line:** the word itself followed by its part(s) of speech in italics. For nouns, list both singular and plural forms separated by `/`, e.g. `deliberation / deliberations *(noun)*`.
   - **Category:** 2–3 topic domains where this word most commonly appears in academic or professional English (e.g. Law, Finance, Science, Politics, Medicine, Technology, Business, Sports, Environment, Psychology). Pick the most specific and useful labels.
   - **Definition:** one bullet per distinct part of speech, plain and precise. For verbs, append common conjugations inline (e.g. *runs / ran / running*). For nouns, use two bullets — one for singular, one for plural — when the plural carries a distinct or extended meaning. Favour definitions that reveal how the word behaves in formal or academic English.
   - **Examples:** 2–3 sentences that show the word used naturally, covering different word forms where they exist (e.g. scrutinise, scrutiny, scrutinised, scrutinies). Ensure at least one example uses a plural noun form where applicable. Keep sentences concise and at academic reading level.

4. **Create the file** at `brain/resources/english/vocab/<word>.md` (kebab-case) with this structure:

   ```markdown
   ---
   type: vocab-entry
   title: <Word>
   created: YYYY-MM-DD
   tags: [vocab, <category1>, <category2>]
   ---

   # <Word>

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

5. **Confirm and display.** Reply with a single line "Added **<Word>** to the vocab collection." followed by the full entry exactly as it was written to the file, formatted in Markdown.

## Rules

- Never ask the user for the definition or examples — derive them yourself.
- Keep definitions free of jargon; write for someone who reads academic English but is not a native speaker.
- If a word has only one part of speech, omit the extra definition bullets.
- Do not add commentary, synonyms sections, or etymology unless the user asks.
