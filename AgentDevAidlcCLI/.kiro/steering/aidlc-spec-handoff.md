---
title: "AI-DLC Spec Handoff"
inclusion: manual
priority: medium
---

# Spec Handoff Reference

## Overview

After mob elaboration produces unit files, each unit becomes the input for implementation.
This reference describes how to present the implementation roadmap and guide the user
through creating specification documents for each unit.

## CRITICAL: Handoff Gate

**Do NOT suggest implementation or spec creation until ALL of the following are true:**

1. ALL unit files have been generated (DECOMPOSE phase complete)
2. Validation has passed with no critical issues (VALIDATE phase complete)
3. The user has explicitly reviewed and accepted the complete set of units
4. The session phase in `aidlc/status.md` is HANDOFF or COMPLETE

If the user asks to start implementation before all units are defined, respond:

> "Let's finish defining all units first. Once every unit is generated and validated,
> I'll walk you through the implementation roadmap. This ensures cross-unit
> dependencies are properly mapped before we commit to implementation details."

## Handoff Presentation

Present units as a numbered implementation roadmap. Reference `aidlc/plan.md` —
it contains the full execution guide, branch/merge instructions, and assignment
recommendations already generated during DECOMPOSE.

```markdown
## 🚀 Implementation Roadmap

All {N} units have been defined, validated, and a full execution plan has been
written to `aidlc/plan.md`. That document contains:
- Unit summaries and key deliverables
- Dependency graph and execution waves
- Branch naming and merge sequence (who merges what, in what order)
- Merge conflict hotspots
- Definition of done checklist

| Order | Unit | File | Dependencies | Status |
|-------|------|------|-------------|--------|
| 1 | {name} | `aidlc/units/01-xxx.md` | None | ⬜ Not started |
| 2 | {name} | `aidlc/units/02-xxx.md` | Unit 1 | ⬜ Not started |

### Parallel Opportunities
Units {X} and {Y} have no mutual dependencies and can be implemented simultaneously.

### Sequential Requirements
Unit {Z} depends on Unit {X} — implement {X} first.
```

## Spec Creation Offer

After presenting the roadmap, ask the user if they want to create specification
documents for each unit. Present this as a clear choice:

```markdown
## 📄 Create Specifications?

For each unit, I can generate three specification documents:

| Document | Purpose |
|----------|---------|
| `requirements.md` | Full requirements using EARS notation, with testable acceptance criteria |
| `design.md` | Technical design — architecture, data models, API contracts |
| `tasks.md` | Implementation task breakdown with checkpoints and validation steps |

> Would you like me to create specifications for your units?
> 1. **Yes, all units** — generate specs for every unit in dependency order
> 2. **Yes, one at a time** — I'll guide you through each unit individually
> 3. **No, just the roadmap** — I'll stop here and you can implement directly
```

If the user chooses to create specs, proceed unit by unit following the steps below.

## Creating Specs for a Unit

For each unit the user picks to implement, follow this sequence in order. Do not
skip steps or reorder them.

### Step 1: Pre-Spec Elaboration

Before writing any spec document, ask 2-5 focused, tactical questions about this
specific unit. These are implementation-detail questions not covered in mob elaboration:
- Specific API contracts and response shapes
- Error handling and recovery behavior
- Data validation rules and edge cases
- Integration specifics with dependent units
- Security and authorization details
- Testability and observable outcomes

Ask one question at a time. Record answers in the elaboration log under
`## Spec Elaboration: {Unit Name}`.

### Step 2: Write requirements.md

Using the unit definition, elaboration log, and spec elaboration answers, write
a requirements document using EARS notation:
- Map every user story from the unit to at least one requirement
- Add testable acceptance criteria (specific, measurable, clear pass/fail)
- Include NFRs with measurable targets
- Address risks with defensive requirements
- Do not add scope beyond the unit file

### Step 3: Validate Requirements Coverage

Immediately after writing requirements.md, validate it against the source unit file
before proceeding to design. Cross-check against:
- Every user story in the unit file
- Every NFR in the unit file
- Every risk and its mitigation strategy
- All decisions recorded in the elaboration log that apply to this unit

Present the result as a coverage table:

```
## Requirements Coverage Check — {Unit Name}

| Source | Item | Covered | Notes |
|--------|------|---------|-------|
| User Story | WHEN ... THE SYSTEM SHALL ... | ✅ / ❌ | {req ref or gap} |
| NFR | {requirement} | ✅ / ❌ | {req ref or gap} |
| Risk | {risk} | ✅ / ❌ | {mitigation captured?} |
| Decision | {decision} | ✅ / ❌ | {reflected in requirements?} |

Result: {All covered ✅ / {N} gaps found ❌}
```

If gaps are found, update requirements.md to address them and re-run the check
until the result is fully covered. Do NOT proceed to Step 4 until coverage is confirmed.

### Step 4: Write design.md

Write a technical design document:
- Architecture decisions and component breakdown
- Data models and API contracts
- Integration points with dependent units
- Key technical risks and mitigations
- Technology choices with rationale

### Step 5: Write tasks.md

Break the unit into concrete, independently executable implementation tasks:
- Each task has: clear scope, acceptance criteria, and a validation checkpoint
- Order tasks by dependency
- Flag tasks that can be parallelized
- Group related tasks with a checkpoint after each group
- Checkpoints should be verifiable (e.g., "all tests pass", "API endpoint returns expected shape")

## Updating Status

After specs are created for a unit, update `aidlc/status.md`:

```markdown
| 1 | Authentication System | `aidlc/units/01-auth.md` | ✅ Specs created | |
```

## Parallel Spec Creation

If multiple units have no mutual dependencies:

```markdown
### Parallel Opportunities
These units can be implemented simultaneously:
- Units {X} and {Y}: no mutual dependencies

These must be sequential:
- Unit {Z} depends on Unit {X} — implement {X} first
```
