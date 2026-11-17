# Silent Failure Review

Audit the diff's error handling. Every error must be surfaced, contextualized, and actionable; anything swallowed is a defect.

## Principles

1. An error handled without logging and without user feedback is a defect, not a fallback.
2. Error messages must say what failed and what the caller or user can do next.
3. Fallbacks must be explicit, intentional, and documented; a fallback that hides the cause is a bug.
4. Catch blocks must be narrow; broad catches hide unrelated failures.
5. Mocks, stubs, and fakes belong in tests, never in production fallbacks.

## Check

Locate every error-handling site in the diff: try/catch/except, `Result` handling, error callbacks and event handlers, conditional error branches, default values on failure, log-and-continue paths, optional chaining or null-coalescing that can swallow problems, retry loops.

For each, ask:

- **Logging**: right severity? enough context to debug in six months (operation, identifiers, state)? does the project define a logging helper or error-identifier scheme that should be used?
- **User feedback**: does the caller learn what happened and what to do? Is the message specific, or generic filler?
- **Catch scope**: which unrelated error types can this catch? Should it be narrowed or split?
- **Fallback**: is it requested by the spec, or invented here? Does it mask the cause? Would a user notice they are on a degraded path?
- **Propagation**: should this bubble up instead? Does catching here break cleanup or resource release?
- **Hidden-failure patterns**: empty catch, catch-and-continue, `return null` on error, optional chaining that skips a required operation, exhausted retries without notice.

## Output

Per finding: location (`file:line`); severity - CRITICAL (silent failure, empty catch, mock fallback), HIGH (unjustified fallback, unactionable message, broad catch), MEDIUM (missing context) - description; the specific unexpected errors it could hide; user impact; recommended code; and a short corrected example.

Acknowledge error handling that is done well; it is rare and worth naming. Distinguish the project's requirements from generic advice, and skip sites the project's error-handling conventions explicitly allow.
