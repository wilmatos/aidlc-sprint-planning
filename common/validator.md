# Unit Validator

Instructions for cross-validating AIDLC unit files for completeness and consistency.

## Input

All unit files from `aidlc/units/` and `aidlc/elaboration-log.md`.

## Validation Checks

1. Decision Coverage — every log Q/A reflected in a unit
2. Dependency Ordering — unit 01 has no deps, no cycles, valid DAG
3. Functionality Gaps — all intent functionality covered by units
4. Bounded Context Integrity — no significant overlap between units
5. NFR Completeness — all NFR targets from questioning in units
6. Plan Consistency — `aidlc/plan.md` exists, merge sequence matches DAG, all units in execution order

## How to Count Issues

| Check | Count as an issue when |
|-------|----------------------|
| Decision Coverage | A question in the log has an `**Answer:**` but no unit references that decision |
| Dependency Ordering | Unit 01 lists dependencies, a cycle exists, or a dependency references a nonexistent unit |
| Functionality Gaps | A capability described in the intent or answers is not covered by any unit |
| Bounded Context Integrity | Two units own the same data, share the same change frequency, or have overlapping user stories |
| NFR Completeness | An NFR target from a question answer does not appear in any unit's NFRs section |
| Plan Consistency | A unit is missing from the execution order table, or the merge sequence contradicts the dependency graph |

## Findings Format

List each issue as a single line:

- `Unit {NN}: {description of the gap or conflict}`
- `Log Q{N}: {decision not reflected in any unit}`

Only report issues the user can act on. Do not flag stylistic preferences or suggest features the user did not ask for.

## When Validation Fails

If any check has issues:

1. Present the full report
2. Offer to regenerate affected units or adjust the plan
3. Wait for user decision before proceeding

## Report Format

Return a summary table followed by findings, recommendations, and verdict.

```markdown
## 📋 Validation Report

| Check | Status | Issues |
|-------|--------|--------|
| Decision Coverage | ✅ / ⚠️ | {count} |
| Dependency Ordering | ✅ / ⚠️ | {count} |
| Functionality Gaps | ✅ / ⚠️ | {count} |
| Bounded Context Integrity | ✅ / ⚠️ | {count} |
| NFR Completeness | ✅ / ⚠️ | {count} |
| Plan Consistency | ✅ / ⚠️ | {count} |

### Findings

{detailed findings}

### Recommendations

{specific recommendations}

### Verdict

{✅ All checks passed / ⚠️ Issues found — review recommended}
```
