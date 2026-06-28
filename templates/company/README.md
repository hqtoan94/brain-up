# {{NAME}}

Standalone company brain repository. Keep this on the work-issued device only.

## Structure

- `raw/` immutable work artifacts (transcripts, exports, dumps)
- `brain/` synthesized work notes
- `handoff/` anonymized summaries staged for transfer to a personal brain
- `.claude/` agent and rule configuration

## Suggested cadence

- daily capture + journal
- weekly inbox processing + review
- periodic anonymized handoff generation into `handoff/`

## How the agent works

This brain is operated by the **work-brain** sub-agent at
[`.claude/agents/work-brain.md`](.claude/agents/work-brain.md). Trigger phrases route to skills
in [`.claude/skills/`](.claude/skills/) (`capture`, `daily-journal`, `process-inbox`,
`weekly-review`, `monthly-dump`). Quick lookups live in [`CHEATSHEET.md`](CHEATSHEET.md).
The only outbound path to a personal brain is a `handoff/` file produced by `monthly-dump`.

Install / sync this brain on a machine with [brain-up](https://github.com/hqtoan94/brain-up).
