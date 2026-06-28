# Ingest Book — Reference

Templates, naming conventions, and the epub extraction recipe used by the `ingest-book` skill.

---

## Slug naming convention

`raw/books/<main-title-hyphenated>-<author-last-name>.epub`

| Book | Slug |
|---|---|
| The Phoenix Project (Kim, Behr, Spafford) | `the-phoenix-project-gene-kim` |
| Storytelling with Data: Let's Practice! (Knaflic) | `storytelling-with-data-knaflic` |
| Domain Storytelling (Hofer & Schwentner) | `domain-storytelling-hofer-schwentner` |
| You've Got 8 Seconds (Hellman) | `youve-got-8-seconds-hellman` |

Rules: lowercase, hyphens, no punctuation, ≤6 words. For multi-author books use the primary/first author's last name.

---

## Epub extraction recipe

```bash
# 1. Copy epub into place
cp "<upload-path>" raw/books/<slug>.epub

# 2. Extract to temp dir
mkdir -p /tmp/epub_extract
unzip -o raw/books/<slug>.epub -d /tmp/epub_extract > /dev/null

# 3. Read table of contents
python3 -c "
import re
data = open('/tmp/epub_extract/toc.ncx').read()
titles = re.findall(r'<text>(.*?)</text>', data)
for t in titles: print(t)
"

# 4. Extract chapter prose (run for each chapter xhtml)
python3 -c "
import re, html
data = open('/tmp/epub_extract/OEBPS/c01.xhtml').read()
text = re.sub(r'<[^>]+>', ' ', data)
text = html.unescape(text)
text = re.sub(r'\s+', ' ', text)
print(text[:2500])
"
```

The OEBPS/ path and xhtml filenames vary by publisher. If the directory structure differs, run `find /tmp/epub_extract -name '*.xhtml' | sort` to discover it.

---

## `raw/books/<slug>.md` template

```md
---
title: "<Full Book Title>"
author: <Author Name(s)>
added: YYYY-MM-DD
type: book-notes
source_file: <slug>.epub
---

# <Book Title>

<Author(s)>, <Publisher>, <Year>. One paragraph summarizing what the book is, its structure, and its central argument or purpose.

## <Part/Chapter heading 1>

**<Framework or key concept name>**
One or two paragraph summary of the key ideas from this section, staying close to the book's terminology.

## <Part/Chapter heading 2>

...

## Key source for

- `brain/resources/<slug>.md` (distilled topic page)
- `brain/resources/<atomic-note-slug-1>.md`
- `brain/resources/<atomic-note-slug-2>.md`
...
```

---

## Atomic note template

File: `brain/resources/<claim-as-slug>.md`

```md
---
title: <The atomic claim as a complete sentence>
created: YYYY-MM-DD
updated: YYYY-MM-DD
maturity: atomic
tags: [<domain1>, <domain2>]
source: "<Author>, <Book Title> (<Year>)"
---

<Body: 1–3 paragraphs. One claim, in the user's voice, synthesized — not quoted. Under 300 words.>

## Why it matters

<1–2 sentences: so what? Where does this connect to how I work or think?>

## Related

- [[<existing-note-slug>]]
- [[<book-distilled-page-slug>]]
```

Tag convention (from observed patterns):
- Domain-oriented: `ddd`, `engineering`, `devops`, `communication`, `data-visualization`, `design`, `facilitation`, `management`, `lean`, `systems-thinking`
- Match tags already used in `brain/resources/` for the same domain

---

## Distilled page template

File: `brain/resources/<book-slug>.md`

```md
---
title: <Book Title> (<Author Last Name>)
created: YYYY-MM-DD
updated: YYYY-MM-DD
maturity: distilled
tags: [<domain tags>]
source: "book — <Author(s)>, \"<Full Title>\" (<Publisher>, <Year>)"
---

## Summary

<3–5 sentences. What the book is, what problem it solves, and why it matters for this brain's owner. In the user's voice — not a back-cover blurb.>

## Key ideas

### <Theme 1 — corresponds to a chapter or Part>

- [[<atomic-note-slug>]]
- [[<atomic-note-slug>]]

### <Theme 2>

- [[<atomic-note-slug>]]

## <Optional: reference table or diagram if the book has one worth preserving>

## Sources

- <Author(s)>. *<Full Title>*. <Publisher>, <Year>. → `raw/books/<slug>.epub`
- See also: [[<related-distilled-page>]] — <one-line reason>

## Open questions

- <3–5 real tensions, gaps, or follow-on questions the book raised but didn't resolve.>
```

---

## Area update pattern

In the relevant `brain/areas/<area>.md`, add before the `## Log` section:

```md
### <Book Title> — <Author Last Name> (<Year>)

- [[<book-slug>]] — distilled topic page
- [[<atomic-note-slug-1>]]
- [[<atomic-note-slug-2>]]
...
```

Then add a dated log entry:

```md
### YYYY-MM-DD — Ingested <Book Title>

<2–3 sentence summary of what the book adds to this area and which connections stood out.>
```

---

## Canonical examples

The three fully-ingested books are the reference for what a complete ingest looks like:

| Artifact type | Phoenix Project example |
|---|---|
| epub | `raw/books/the-phoenix-project-gene-kim.epub` |
| source index | `raw/books/the-phoenix-project-gene-kim.md` |
| distilled page | `brain/resources/the-phoenix-project.md` |
| atomic note | `brain/resources/wip-limits-are-the-most-powerful-flow-tool.md` |
| area update | `brain/areas/engineering.md` — DevOps/flow section |

Same pattern for `storytelling-with-data-knaflic` (communication area) and `domain-storytelling-hofer-schwentner` (engineering area).
