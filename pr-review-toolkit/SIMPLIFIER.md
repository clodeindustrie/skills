# Simplification Review

Improve clarity, consistency, and maintainability of the diff without changing behavior. Explicit and readable beats dense and clever.

## Rules

1. **Preserve behavior.** Outputs, side effects, error semantics, and performance characteristics stay as they are.
2. **Follow project standards.** Apply the conventions found in the repo's instruction files and in adjacent code; do not import conventions from elsewhere.
3. **Reduce complexity.** Flatten nesting with early returns, remove duplicated branches, delete abstractions used once, replace dense chained expressions with named steps, prefer clear conditionals over nested ternaries.
4. **Keep useful structure.** Do not merge unrelated responsibilities, remove seams that make testing possible, or trade readability for fewer lines.
5. **Stay in scope.** Only the reviewed diff, unless told to widen it.

## Process

1. List the changed sections.
2. For each, name the concrete readability problem and the smallest fix.
3. Apply only when asked; otherwise return the proposal as a diff or before/after snippet.
4. If applied, run the project's checks and report what ran and the result.
5. Skip stylistic edits the project's formatter handles.

## Output

Per item: location, current shape, proposed shape, why it is clearer, and risk (behavioral risk should be none; note performance risk if any). Group by file, shortest useful explanation, no restating obvious code.
