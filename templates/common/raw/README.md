# Raw

**Immutable source material.** The agent reads from here but never edits.

This is the input layer of the brain — articles, papers, transcripts, book notes, podcast notes, screenshots, exported chat logs, anything you want distilled into the brain. Borrowed from Andrej Karpathy's [LLM-wiki pattern](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f): raw inputs stay untouched; the agent compiles synthesis into `brain/`.

## What goes here

- Articles & blog posts you want ingested (paste as `.md`, or save the URL + key excerpts).
- Papers (PDFs are fine; the agent can quote from them).
- Book notes, Kindle highlights, Readwise exports.
- Podcast / YouTube transcripts.
- Screenshots or images, when the source material is visual.
- Exported chat logs (Slack DMs to yourself, ChatGPT exports, etc.) — anonymize before adding.

## What does **not** go here

- Your own thoughts → `raw/inbox/`.
- Date-bound reflections → `brain/resources/journal/`.
- Anything you intend to edit later → `brain/` (raw is immutable).
- Company-sensitive content → the company brain repo, not here.

## Conventions

- **Filenames are freeform.** Use whatever helps you find it later — keep the source's title or a descriptive slug.
- **Frontmatter is optional.** Useful fields when you bother:
  ```yaml
  ---
  title: <source title>
  author: <if known>
  url: <original link>
  added: YYYY-MM-DD
  type: article | paper | transcript | book-notes | image | other
  ---
  ```
- **Subfolders are fine** (`raw/papers/`, `raw/articles/`, `raw/transcripts/`) once the volume justifies them. Don't create them up front.

## Workflow

1. **Drop a source.** Save the file into `raw/` — that's it.
2. **Tell the agent to ingest.** "Ingest the new article in raw/" or "distill raw/karpathy-llm-wiki.md into resources/".
3. **The agent reads, discusses key takeaways with you, and writes atomic notes into `brain/resources/`** (with `maturity: atomic`). Original stays in `raw/`, untouched. Distillation into topic pages happens later, when atoms accumulate.
4. **Lint periodically.** `lint the vault` flags raw sources that have been added but never ingested.

## Privacy

`private/` and `private-*.md` patterns are gitignored at any depth, so `raw/private/` and `raw/private-foo.md` work the same way as in `brain/`.
