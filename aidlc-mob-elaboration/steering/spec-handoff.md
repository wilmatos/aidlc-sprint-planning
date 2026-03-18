# Spec Handoff Reference

## Overview

After mob elaboration produces unit files, each unit becomes the input for a Kiro spec.
This reference describes how to guide the user through creating specs from units.

## CRITICAL: Spec Mode Gate

**Do NOT suggest Spec mode or spec creation until ALL of the following are true:**

1. ALL unit files have been generated (DECOMPOSE phase complete)
2. Validation has passed with no critical issues (VALIDATE phase complete)
3. The user has explicitly reviewed and accepted the complete set of units
4. The session phase in `aidlc/status.md` is HANDOFF or COMPLETE

If the user asks to start spec work before all units are defined, respond:

> "Let's finish defining all units first. Once every unit is generated and validated,
> I'll walk you through creating specs for each one. This ensures cross-unit
> dependencies are properly mapped before we commit to implementation details."

**Never mention Spec mode during INIT, ASSESS, QUESTIONING, READY_CHECK, DECOMPOSE,
or VALIDATE phases.**

## Handoff Presentation

Present units as a numbered implementation roadmap:

```markdown
## 🚀 Implementation Roadmap

| Order | Unit | File | Dependencies | Status |
|-------|------|------|-------------|--------|
| 1 | {name} | `aidlc/units/01-xxx.md` | None | ⬜ Not started |
| 2 | {name} | `aidlc/units/02-xxx.md` | Unit 1 | ⬜ Not started |

### Parallel Opportunities
Units {X} and {Y} have no mutual dependencies and can be implemented simultaneously.

### Sequential Requirements
Unit {Z} depends on Unit {X} — implement {X} first.
```

## Creating a Spec from a Unit

### Step 1: Switch to Spec Mode
Tell the user to switch to Kiro's Spec mode using the mode selector.

### Step 2: Start a New Spec
The user should start a new spec and reference:
- The unit file: `#aidlc/units/XX-unit-name.md`
- The elaboration log: `#aidlc/elaboration-log.md`
- Any additional artifacts generated during elaboration

### Step 3: Requirements Generation
The steering file `aidlc-spec-elaboration.md` activates on `requirements.md`.
It instructs the agent to:

1. Read the referenced unit file for scope and user stories
2. Read the elaboration log for decisions and context
3. Ask clarifying questions specific to this unit before writing
4. Use EARS notation consistent with the unit file
5. Ensure every user story from the unit is covered
6. Add testable, specific acceptance criteria

### Step 3b: Requirements vs Unit Validation
After `requirements.md` is written, the `aidlc-requirements-unit-validation` hook
fires automatically via `postTaskExecution`. It activates the
`aidlc-requirements-validation` steering file, which runs a coverage validation that:

1. Identifies the corresponding unit file in `aidlc/units/`
2. Compares every user story, NFR, and risk from the unit against the requirements
3. Checks that spec elaboration answers are reflected in the requirements
4. Flags any scope additions not present in the unit file
5. Presents a coverage summary table and verdict to the user

If gaps are found, the agent suggests specific requirements to add but does not
auto-fix — the user reviews and decides.

The user can also trigger this validation manually at any time by referencing
`#aidlc-requirements-validation` in chat.

### Step 4: Design and Tasks
After requirements are approved, Kiro's standard spec workflow handles design.md
and tasks.md. The unit file provides enough context for the design phase.

## Updating Status

After a spec is created for a unit, update `aidlc/status.md`:

```markdown
| 1 | Authentication System | `aidlc/units/01-auth.md` | ✅ Spec created | `.kiro/specs/authentication-system/` |
```

## Reference Linking

| Reference | Purpose | How to Include |
|-----------|---------|---------------|
| Unit file | Scope, stories, NFRs | `#aidlc/units/XX-name.md` |
| Elaboration log | Decisions, context | `#aidlc/elaboration-log.md` |
| Status dashboard | Overall progress | `#aidlc/status.md` |
| Other unit files | Cross-unit dependencies | `#aidlc/units/YY-dependency.md` |

## Per-Spec Elaboration

When the `aidlc-spec-elaborator` subagent is invoked for a specific unit:

1. Read the unit file to understand scope
2. Read relevant elaboration log sections
3. Identify ambiguities needing clarification before requirements
4. Ask 2-5 focused questions specific to implementation details:
   - Specific API contracts
   - Error handling details
   - Data validation rules
   - Edge cases not covered in the unit
   - Integration specifics with dependent units
5. Answers feed directly into requirements.md generation

## Parallel Spec Creation

If multiple units have no mutual dependencies, note this:

```markdown
### Parallel Opportunities
These units can be implemented simultaneously:
- Units {X} and {Y}: no mutual dependencies

These must be sequential:
- Unit {Z} depends on Unit {X} — implement {X} first
```
