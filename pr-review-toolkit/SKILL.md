---
name: pr-review-toolkit
description: "Comprehensive pull request review across six specialist aspects: general code review, comment accuracy, test coverage, silent failures, type design, and simplification. Use before opening or merging a PR, or when asked to review a branch, PR, or recent changes. Harness-agnostic: each aspect is a self-contained review brief that runs as a sub-agent where supported and sequentially otherwise."
---

# PR Review Toolkit

Six aspect reviews of one diff, aggregated into a single prioritized report. Each aspect is a standalone file:

| Aspect | File | Include when |
|---|---|---|
| code | `CODE-REVIEWER.md` | always |
| tests | `TEST-COVERAGE.md` | test files changed, or new behavior added |
| comments | `COMMENT-ANALYZER.md` | comments or docstrings added or modified |
| errors | `SILENT-FAILURES.md` | error handling, catch blocks, fallbacks, or defaults touched |
| types | `TYPE-DESIGN.md` | new or changed types, schemas, or domain models |
| simplify | `SIMPLIFIER.md` | review passed, or code works but reads badly |

## 1. Pin the scope

Read the user's arguments as aspects and/or a range:

- Aspect names: `code`, `tests`, `comments`, `errors`, `types`, `simplify`, `all` (default).
- A range: `<ref>`, `<base>..<head>`, or `<base>...<head>` (three-dot compares against the merge-base).
- A PR identifier: resolve it first (`gh pr view <n>`, `gh pr diff <n>`) and use its base ref as the fixed point.

Default when neither range nor PR is given:

1. `git diff` and `git diff --cached` for work in progress.
2. If both are empty, `git show --patch HEAD` for the last commit.

Confirm the range resolves and the diff is non-empty before spending review effort. If it is empty, stop and say so. Do not review the whole repository unless asked.

Capture once and reuse for every aspect: the diff command, `git log --oneline <range>`, and the changed file names.

## 2. Pick aspects

Start from the requested aspects. Under `all`, include `code` always and add other aspects only when their include condition matches the changed files. Add `simplify` only when asked, or when the code aspect found nothing structural left to fix.

## 3. Run each aspect

Each aspect gets the diff command, commit list, and changed files, plus the full contents of its file.

- Harness with sub-agents: run aspects in parallel, one fresh context each, then aggregate their reports.
- No sub-agents: run aspects one at a time, finish and write down each report before loading the next file, so earlier findings do not bias the later standard.

Do not merge the aspect files into one prompt. Their value is that each applies a different standard to the same diff.

If the harness allows a per-step model, use the strongest available for `types`, `errors`, and `comments` (judgement-heavy) and a fast model for `code` and `simplify` (mechanical). With one model, use it everywhere.

## 4. Aggregate

Merge into one report:

```markdown
# PR Review

## Critical
- [aspect] description — file:line

## Important
- [aspect] description — file:line

## Suggestions
- [aspect] description — file:line

## Strengths
- ...

## Action plan
1. ...
```

Rules:

- Deduplicate. Same defect from several aspects becomes one entry naming every aspect.
- Rank by the severity each aspect assigned, not by aspect order. Severities are not comparable across aspects (confidence score, 1–10 criticality, CRITICAL/HIGH/MEDIUM); keep them as reported.
- A finding with no file:line is not actionable. Resolve the location or drop it.
- Report what the diff introduced or made wrong. Defects outside the diff go in a one-line "Noted, not part of this change" list.
- End with counts per severity and the worst issue, per aspect.

## 5. Change code only when asked

Aspects are advisory by default. When the user asks to apply fixes - typically `simplify` - edit only the reviewed diff, preserve behavior exactly, and re-run the checks the project provides afterwards. Say which checks ran and their result.

## Notes

- Read the project's own instruction sources first (`CLAUDE.md`, `AGENTS.md`, `.cursor/rules`, `CONTRIBUTING.md`, lint/format configs) and let them override any generic advice here.
- Skip anything the project's tooling enforces. Do not repeat formatter, linter, or type-checker output.
- Do not report style opinions the project has no standard for.
