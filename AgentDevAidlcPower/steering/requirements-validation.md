---
title: "AI-DLC Requirements Validation"
---

# Requirements vs Unit Validation

## Purpose

Validate that implementation requirements fully cover everything defined in a source
AI-DLC unit file. This ensures no features, user stories, NFRs, or risks were missed.

## Preconditions

1. An `aidlc/` directory exists in the project root
2. A requirements document exists for the current work
3. A matching unit file exists in `aidlc/units/`

## Matching Logic

Identify the corresponding unit file by matching the current work context to a unit
file in `aidlc/units/`. Use directory names, references, or content similarity.
If ambiguous, ask the user which unit file to validate against.

## Validation Checks

1. **User Story Coverage** — Every user story (WHEN/IF/WHILE/THE SYSTEM SHALL) from
   the unit file has at least one corresponding requirement.
2. **NFR Coverage** — Every NFR listed in the unit file has a corresponding requirement.
3. **Risk Coverage** — Risks listed in the unit file are addressed by defensive
   requirements or explicitly acknowledged.
4. **Scope Fidelity** — Requirements do not introduce features or scope beyond
   what the unit file defines (no scope creep).
5. **Elaboration Answers** — Any answers from elaboration questioning are reflected
   in the requirements.

## Report Format

```markdown
## 📋 Requirements vs Unit Validation

**Unit:** {unit file name}

### Coverage Summary

| Category | Unit Items | Covered | Missing | Status |
|----------|-----------|---------|---------|--------|
| User Stories | {N} | {N} | {N} | ✅ / ⚠️ |
| NFRs | {N} | {N} | {N} | ✅ / ⚠️ |
| Risks | {N} | {N} | {N} | ✅ / ⚠️ |
| Elaboration Answers | {N} | {N} | {N} | ✅ / ⚠️ |

### Missing Items

{List each missing item with its source in the unit file}

### Scope Additions

{List any requirements that go beyond the unit file scope, if any}

### Verdict

{✅ Full coverage — no gaps detected / ⚠️ Gaps found — review recommended}
```

## Rules

1. A requirement doesn't need identical wording to "cover" a user story — just the same intent.
2. If a user story is split across multiple requirements, that counts as covered.
3. If a requirement consolidates multiple related stories, that's fine if all behaviors are testable.
4. Don't flag scope additions as errors — just note them for awareness.
5. If gaps are found, suggest specific requirements to add.
6. Do NOT auto-fix — present findings for the user to review and decide.
