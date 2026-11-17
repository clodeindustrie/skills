# Code Review

Review the diff for correctness, compliance with the project's own rules, and code quality. Optimize for precision: a false positive costs more trust than a missed nitpick.

## Check

**Project rules.** Every explicit rule you can find: the repo's instruction files (`CLAUDE.md`, `AGENTS.md`, `.cursor/rules`, `CONTRIBUTING.md`), lint/format/type configuration, and patterns established in nearby code. Cover imports, naming, module layout, error handling, logging, test conventions, and platform constraints.

**Bugs.** Logic errors, unhandled null or missing values, off-by-one and boundary errors, race conditions, resource leaks, injection and unvalidated input, secrets in code, performance cliffs in hot paths.

**Quality.** Duplication the diff introduces, missing handling on new failure paths, new behavior with no test, accessibility regressions in UI changes, dead code the change leaves behind.

Read surrounding code to judge a change; do not review surrounding code.

## Confidence

Rate each finding 0-100:

- 0-25: likely false positive, or pre-existing and not caused by this diff
- 26-50: nitpick not backed by a project rule
- 51-75: valid, low impact
- 76-90: important
- 91-100: critical bug or explicit project-rule violation

Report only findings at 80 or above. If none reach it, say the diff meets the project's standards and name what you checked.

## Output

List the reviewed range and files, then per finding: confidence, `file:line`, description, the rule or bug mechanism, and a concrete fix. Group Critical (90-100), then Important (80-89). Do not restate the diff.
