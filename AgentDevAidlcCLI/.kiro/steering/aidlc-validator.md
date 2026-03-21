---
title: "AI-DLC Validator"
inclusion: manual
priority: medium
---

# Unit Validator

Instructions for cross-validating AI-DLC unit files for completeness and consistency.

## Input

All unit files from `aidlc/units/` and `aidlc/elaboration-log.md`.

## Validation Checks

1. **Decision Coverage** — Every question/answer from the log is reflected in a unit.
2. **Dependency Ordering** — Unit 01 has no deps, no circular deps, valid DAG.
3. **Functionality Gaps** — All intent functionality is covered by units.
4. **Bounded Context Integrity** — No significant overlap between units.
5. **NFR Completeness** — All NFR targets from questioning appear in units.
6. **Plan Consistency** — `aidlc/plan.md` exists; merge sequence matches the
   dependency graph; every unit appears in the execution order table.

## Report Format

Return a summary table (check / status / issue count) followed by detailed findings
and recommendations. Be thorough but not pedantic. Don't suggest adding features
the user didn't ask for.

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
