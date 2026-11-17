# Test Coverage Review

Judge whether the diff's tests would catch regressions in the changed behavior. Behavioral coverage over line coverage; pragmatic, not metric-chasing.

## Check

- New and changed behavior: is there a test that fails if the behavior breaks?
- Error and boundary paths: validation failures, empty or missing input, limits, timeouts, concurrent or async interleavings.
- Critical branches: money, auth, permissions, data deletion, migrations - anything whose silent breakage hurts.
- Test quality: does each test assert behavior and contracts rather than internals? Would it survive a reasonable refactor? Does its name describe the expected behavior?
- Existence check: before proposing a test, search for an existing one that already covers the case, including integration and end-to-end tests.

## Criticality

Rate each proposed test 1-10:

- 9-10: data loss, security, or systemic failure
- 7-8: user-visible wrong behavior
- 5-6: confusing edge case or minor wrongness
- 3-4: completeness, optional
- 1-2: nice to have

Do not propose tests for trivial accessors, framework glue, or code the project's conventions leave untested.

## Output

1. **Summary**: what is covered and how well
2. **Critical gaps**: rated 8-10 - the failure each test would catch and why it is realistic
3. **Important gaps**: rated 5-7
4. **Test quality issues**: brittle or implementation-coupled tests in the diff
5. **Positive**: what is tested well

Be specific: name the case, the expected assertion, and the regression it prevents.
