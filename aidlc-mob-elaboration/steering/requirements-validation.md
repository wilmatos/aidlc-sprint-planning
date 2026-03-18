# Requirements vs Unit Validation

## Purpose

Validate that a spec's `requirements.md` fully covers everything defined in its
source AI-DLC unit file. This ensures no features, user stories, NFRs, or risks
were missed during spec creation.

This steering file is used in two ways:
- Automatically via the `aidlc-requirements-unit-validation` hook after a spec task completes
- Manually by the user at any time via the `#aidlc-requirements-validation` context key

## Preconditions

Before running validation, confirm:
1. An `aidlc/` directory exists in the project root
2. A `requirements.md` file exists for the current spec
3. A matching unit file exists in `aidlc/units/`

If any precondition is not met, skip validation silently (for hook invocations)
or inform the user what's missing (for manual invocations).

## Matching Logic

Identify the corresponding unit file by matching the spec name/path to a unit file
in `aidlc/units/`. Use the spec directory name, requirement references, or content
similarity to find the match. If ambiguous, ask the user which unit file to validate
against.

## Validation Steps

1. Read the `requirements.md` file for the current spec
2. Read the matching unit file from `aidlc/units/`
3. Read any `## Spec Elaboration: {Unit Name}` sections in `aidlc/elaboration-log.md`
4. Compare and check coverage across all categories below

## Validation Checks

1. **User Story Coverage** — Every user story (WHEN/IF/WHILE/THE SYSTEM SHALL) from
   the unit file has at least one corresponding requirement in requirements.md.
2. **NFR Coverage** — Every NFR listed in the unit file has a corresponding
   non-functional requirement in requirements.md.
3. **Risk Coverage** — Risks listed in the unit file are addressed by defensive
   requirements or explicitly acknowledged in requirements.md.
4. **Scope Fidelity** — requirements.md does not introduce features or scope beyond
   what the unit file defines (no scope creep).
5. **Elaboration Answers** — Any answers from the spec elaboration questioning
   are reflected in the requirements.

## Report Format

Present results as a coverage report:

```markdown
## 📋 Requirements vs Unit Validation

**Unit:** {unit file name}
**Spec:** {spec path}

### Coverage Summary
| Category | Unit Items | Covered | Missing | Status |
|----------|-----------|---------|---------|--------|
| User Stories | {N} | {N} | {N} | ✅ / ⚠️ |
| NFRs | {N} | {N} | {N} | ✅ / ⚠️ |
| Risks | {N} | {N} | {N} | ✅ / ⚠️ |
| Spec Elaboration | {N} | {N} | {N} | ✅ / ⚠️ |

### Missing Items
{List each missing item with its source in the unit file}

### Scope Additions
{List any requirements that go beyond the unit file scope, if any}

### Verdict
{✅ Full coverage — no gaps detected / ⚠️ Gaps found — review recommended}
```

## Rules

1. Be thorough but fair — a requirement doesn't need identical wording to "cover"
   a user story, just capture the same intent and behavior.
2. If a user story is split across multiple requirements, that counts as covered.
3. If a requirement consolidates multiple related stories, that's fine as long as
   all behaviors are testable.
4. Don't flag scope additions as errors — just note them for the user's awareness.
5. If gaps are found, suggest specific requirements that could be added to close them.
6. Do NOT auto-fix — present findings for the user to review and decide.
