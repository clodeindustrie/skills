# Comment And Documentation Review

Check every comment, docstring, and documentation block the diff adds or changes. Each is a claim about code that must stay true as the code evolves.

## Check

1. **Accuracy.** Cross-reference each claim with the implementation: parameters, return values, behavior, referenced identifiers, edge cases the comment says are handled, complexity claims.
2. **Completeness.** Are critical preconditions, non-obvious side effects, error conditions, and algorithm rationale stated? Is anything redundant with self-evident code?
3. **Long-term value.** Prefer "why" over "what". Flag comments that restate the code, describe transient states, or will silently rot at the next change.
4. **Misleading wording.** Ambiguous terms, references to refactored code, examples that no longer match, TODOs already resolved.
5. **Placement.** Documentation on the wrong item, missing from the public surface, or duplicated in places that can drift apart.

## Output

- **Summary**: scope and overall quality
- **Critical**: factually wrong or misleading - location, problem, corrected wording or removal
- **Improvements**: location, what is missing, suggested addition
- **Removals**: location, why the comment earns nothing
- **Positive**: comments worth copying as the local example

Advisory only: propose exact wording where you flag a problem; do not edit files unless the caller asked you to.
