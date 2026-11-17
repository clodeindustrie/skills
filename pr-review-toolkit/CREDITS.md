# Credits

Adapted from `pr-review-toolkit` in
[anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official/tree/ea0a38e1d671aa18a30431c9160e31193dc9860b/plugins/pr-review-toolkit)
at commit `ea0a38e1d671aa18a30431c9160e31193dc9860b`.

Original author: Daisy (daisy@anthropic.com), Anthropic. Licensed under
Apache License 2.0; see `LICENSE`.

## Changes From The Original

- Repackaged from six Claude Code sub-agent definitions plus a slash command
  into one harness-agnostic skill: `SKILL.md` orchestrates, and each aspect
  prompt became a standalone reference file under `pr-review-toolkit/`.
- Removed Claude-specific machinery: agent frontmatter (`model`, `color`),
  `Task` tool invocation examples, `/pr-review-toolkit:review-pr` command
  syntax, and prose describing automatic triggering by a specific assistant.
  The skill now states when to run each aspect and works with any agent or
  LLM; sub-agents are used when the harness has them, sequentially otherwise.
- Made project-specific assumptions generic: `CLAUDE.md` became "the repo's
  instruction files"; Sentry/Statsig helpers, `constants/errorIds.ts`, ES
  module/React rules, and other claude-code-specific conventions were replaced
  with "follow the project's own logging, error-ID, and style standards".
- Dropped duplicate content: the six per-aspect "When to invoke" sections and
  the README's usage/installation notes are folded into `SKILL.md` scope
  selection and aspect-selection tables.
- Kept the review substance: confidence scoring, 1-10 criticality and type
  ratings, silent-failure severity levels, and each aspect's output structure.
- Added explicit rules that aspects are advisory and that code is edited only
  on request.
