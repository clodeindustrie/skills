# Type Design Review

Evaluate new or changed types, schemas, and domain models on invariant strength, encapsulation, and practical usefulness. The goal is types that make illegal states hard to represent, without over-engineering.

## Analysis

1. **Identify invariants**: field consistency, valid state transitions, cross-field constraints, business rules, pre- and postconditions.
2. **Encapsulation (1-10)**: are internals hidden, can an outsider violate an invariant, is the interface minimal yet complete?
3. **Invariant expression (1-10)**: do the types communicate invariants structurally, are they enforced at compile time where the language allows, is the type self-documenting?
4. **Invariant usefulness (1-10)**: do the invariants prevent real bugs, match the domain, and avoid being too strict or vacuous?
5. **Invariant enforcement (1-10)**: validated at construction and at every mutation point, impossible to build invalid instances, runtime checks where static ones are impossible?

## Output

```markdown
## Type: <name>

### Invariants
- ...

### Ratings
- Encapsulation: X/10 - ...
- Invariant expression: X/10 - ...
- Invariant usefulness: X/10 - ...
- Invariant enforcement: X/10 - ...

### Strengths
...

### Concerns
...

### Recommended improvements
...
```

## Principles

Prefer compile-time guarantees; prefer clarity over cleverness; price the maintenance cost of every suggestion; a simple type with fewer guarantees can beat a complex one.

## Flag

Anemic models with no behavior, exposed mutable internals, invariants that exist only in comments, too many responsibilities, missing construction-time validation, enforcement applied inconsistently across mutation points, invariants that depend on external code honoring them.

For each suggested change, state whether it breaks callers and whether it is worth it for this codebase. Advisory unless asked to apply.
