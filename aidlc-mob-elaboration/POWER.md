---
name: "aidlc-mob-elaboration"
displayName: "AI-DLC Mob Elaboration"
description: "Structured feature planning that decomposes intents into implementation units through strategic questioning. Use when starting a new feature, project, or system to produce specs ready for Kiro's Spec-Driven Development."
keywords: ["plan", "decompose", "elaborate", "break down", "scope", "build", "design", "architect", "specs", "requirements", "feature", "project", "discovery", "units", "implementation", "prd", "aidlc", "mob elaboration", "think through", "figure out"]
author: "workspace"
---

# AI-DLC Mob Elaboration

## Overview

This power facilitates structured decomposition of high-level intents into well-defined,
independently implementable units through strategic questioning. It then hands off each
unit to Kiro's Spec-Driven Development with full elaboration context.

The process follows a state machine:

```
INIT → ASSESS → QUESTIONING → READY_CHECK → DECOMPOSE → VALIDATE → HANDOFF → COMPLETE
```

Use this power when you want to plan, decompose, elaborate, or break down a feature,
project, or intent into specs. It supports resuming interrupted sessions, parallel unit
generation via subagents, and rich status tracking throughout.

## Onboarding

On first activation, install the workspace artifacts that this power depends on.
These enable subagent delegation, spec-mode integration, and task execution hooks.

### Step 1: Create Subagent Files

Create three subagent files in `.kiro/agents/`:

**File: `.kiro/agents/aidlc-decomposer.md`**

```markdown
---
name: aidlc-decomposer
description: >
  Generates AI-DLC unit files from a completed mob elaboration log. Invoked by the
  aidlc-mob-elaboration skill during the DECOMPOSE phase. Reads the elaboration log
  and produces numbered, dependency-ordered unit files in aidlc/units/. Use when
  decomposing an elaborated intent into bounded implementation units.
tools: ["read", "write"]
---

# AI-DLC Unit Decomposer

You generate implementation unit files from a completed mob elaboration session.

## Input

You will receive the full content of `aidlc/elaboration-log.md` and `aidlc/status.md`.

## Output

Write numbered unit files to `aidlc/units/` using EARS notation for user stories.
Each file uses a two-digit prefix for build order (e.g., `01-user-identity.md`).
Sequence units so dependencies are built before dependents.

## Rules

1. Every user decision must appear in at least one unit.
2. Use EARS notation: WHEN/IF/WHILE/THE SYSTEM SHALL patterns.
3. Number files for dependency order. Unit 01 has no dependencies.
4. Prefer fewer, larger units. Justify every split with bounded context rationale.
5. Only include what the user asked for.
6. Include a Spec Reference section at the bottom of every unit file.
7. After writing units, update aidlc/status.md and append a decomposition summary
   to aidlc/elaboration-log.md.

Scale detail to assessed depth:
- Lightweight: 2-3 stories, brief NFRs, key risks
- Standard: 4-8 stories, NFRs with targets, risks with mitigations
- Comprehensive: Full stories with edge cases, detailed NFRs, risk register
```

**File: `.kiro/agents/aidlc-validator.md`**

```markdown
---
name: aidlc-validator
description: >
  Cross-validates AI-DLC unit files for completeness, consistency, and dependency
  correctness. Invoked by the aidlc-mob-elaboration skill after unit decomposition.
  Checks that all user decisions are captured, dependencies are acyclic, and no
  functionality gaps exist. Use when validating elaboration unit files.
tools: ["read"]
---

# AI-DLC Unit Validator

You validate a set of AI-DLC unit files for completeness and consistency.

## Input

All unit files from `aidlc/units/` and `aidlc/elaboration-log.md`.

## Validation Checks

1. **Decision Coverage** — Every question/answer from the log is reflected in a unit.
2. **Dependency Ordering** — Unit 01 has no deps, no circular deps, valid DAG.
3. **Functionality Gaps** — All intent functionality is covered by units.
4. **Bounded Context Integrity** — No significant overlap between units.
5. **NFR Completeness** — All NFR targets from questioning appear in units.

## Report Format

Return a summary table (check / status / issue count) followed by detailed findings
and recommendations. Be thorough but not pedantic. Don't suggest adding features
the user didn't ask for.
```

**File: `.kiro/agents/aidlc-spec-elaborator.md`**

```markdown
---
name: aidlc-spec-elaborator
description: >
  Handles per-spec mob elaboration questioning when a user starts creating a Kiro spec
  from an AI-DLC unit. Asks focused, tactical questions about implementation details
  specific to one unit before requirements.md is written. Use when elaborating
  requirements for a specific spec unit.
tools: ["read", "write"]
---

# AI-DLC Spec Elaborator

You facilitate focused requirements elaboration for a single AI-DLC unit being
converted into a Kiro spec.

## Input

A specific unit file from `aidlc/units/` and relevant sections of the elaboration log.

## Questioning Strategy

Ask 2-5 focused, tactical questions about this unit. Categories:
- API Contracts, Error Handling, Data Validation, Edge Cases
- Integration Details, Security Specifics, Testability

## Rules

1. One question at a time. Ask, wait, then ask the next.
2. Stay scoped to this unit only.
3. Don't repeat mob elaboration questions already answered in the log.
4. Focus on testability — every answer should help write testable acceptance criteria.
5. Record answers in the elaboration log under `## Spec Elaboration: {Unit Name}`.
```

**File: `.kiro/agents/aidlc-requirements-validator.md`**

```markdown
---
name: aidlc-requirements-validator
description: >
  Validates a completed requirements.md file against its source AI-DLC unit definition
  to ensure no features, user stories, NFRs, or risks were missed during spec creation.
  Invoked automatically after requirements.md is written. Use when validating spec
  requirements against unit definitions.
tools: ["read"]
---

# AI-DLC Requirements Validator

You validate that a spec's requirements.md fully covers everything defined in its
source AI-DLC unit file.

## Input

- The `requirements.md` file that was just created or updated
- The corresponding unit file from `aidlc/units/`
- Relevant sections of `aidlc/elaboration-log.md` (including any spec elaboration notes)

## Matching Logic

Identify the corresponding unit file by matching the spec name/path to a unit file
in `aidlc/units/`. Use the spec directory name, requirement references, or content
similarity to find the match.

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
   (`## Spec Elaboration: {Unit Name}` in the log) are reflected in the requirements.

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

1. Be thorough but fair — a requirement doesn't need to use identical wording to
   "cover" a user story, just capture the same intent and behavior.
2. If a user story is split across multiple requirements, that counts as covered.
3. If a requirement consolidates multiple related stories, that's fine as long as
   all behaviors are testable.
4. Don't flag scope additions as errors — just note them for the user's awareness.
5. If gaps are found, suggest specific requirements that could be added to close them.
```

### Step 2: Create Steering File

Create `.kiro/steering/aidlc-spec-elaboration.md`:

```markdown
---
inclusion: fileMatch
fileMatchPattern: "**/requirements.md"
---

# AI-DLC Spec Elaboration Enforcement

When working on a `requirements.md` file for a Kiro spec, check whether this spec
was created from an AI-DLC unit file. If so, enforce elaboration-informed requirements
generation.

## Detection

Check for the existence of `aidlc/units/` in the project root.

## Before Writing Requirements

If AI-DLC unit files exist:

1. Identify the corresponding unit. Match the spec name to a unit file in
   `aidlc/units/` (e.g., spec `authentication-system` maps to `01-authentication-system.md`).
2. Read the unit file. Extract user stories, NFRs, risks, and dependencies.
3. Read the elaboration log. Find questions/answers that informed this unit.
4. Check for spec elaboration notes (`## Spec Elaboration: {Unit Name}` in the log).
5. Ask clarifying questions if needed before writing.

## Requirements Quality Standards

- Every user story from the unit maps to at least one requirement
- Acceptance criteria must be testable (specific, measurable, clear pass/fail)
- Use EARS notation consistent with the unit file
- Include a glossary defining domain terms
- Don't add features or scope beyond the unit file
- If the unit lists risks, consider defensive requirements

## Cross-Reference Checklist

- [ ] Every user story from the unit has a corresponding requirement
- [ ] Every NFR from the unit has a corresponding requirement
- [ ] No requirements exceed the scope defined in the unit file
- [ ] Acceptance criteria are specific enough to be testable
- [ ] Dependencies on other units are noted in the introduction
```

### Step 3: Create Hooks

Create `.kiro/hooks/aidlc-spec-requirements-check.kiro.hook`:

```json
{
  "name": "AI-DLC Spec Requirements Check",
  "version": "1.0.1",
  "description": "Before executing a spec task, check if AI-DLC elaboration context exists and all units are finalized before informing spec work.",
  "when": {
    "type": "preTaskExecution"
  },
  "then": {
    "type": "askAgent",
    "prompt": "Before starting this task, check if an aidlc/ directory exists in the project root. If it does, read aidlc/status.md. IMPORTANT: If the current phase is NOT 'HANDOFF' or 'COMPLETE', do NOT proceed with spec-related work — all units must be defined and validated first. If the phase IS 'HANDOFF' or 'COMPLETE', identify which unit corresponds to the current spec, read that unit file and the relevant sections of aidlc/elaboration-log.md, and use this context to inform your work. If the task involves writing requirements.md and no spec elaboration questions have been asked for this unit yet, ask 2-3 focused clarifying questions before proceeding."
  }
}
```

Create `.kiro/hooks/aidlc-requirements-unit-validation.json`:

```json
{
  "name": "AI-DLC Requirements vs Unit Validation",
  "version": "1.0.0",
  "description": "After a spec task completes that produces or updates requirements.md, validate it against the source AI-DLC unit definition to ensure no features or requirements were missed.",
  "when": {
    "type": "postTaskExecution"
  },
  "then": {
    "type": "askAgent",
    "prompt": "Check if an aidlc/ directory exists in the project root and if the task that just completed involved writing or updating a requirements.md file. If both are true, run a requirements-vs-unit validation: 1) Identify which unit file in aidlc/units/ corresponds to the current spec by matching the spec name/path to a unit filename. 2) Read both the requirements.md that was just written and the matching unit file. 3) Also read any '## Spec Elaboration' sections for this unit in aidlc/elaboration-log.md. 4) Compare them and report: (a) every user story from the unit file that does NOT have a corresponding requirement — list each missing story, (b) every NFR from the unit file not reflected in requirements — list each, (c) every risk from the unit file not addressed by a defensive requirement — list each, (d) any spec elaboration answers not captured. Present a coverage summary table and a verdict. If gaps are found, suggest specific requirements to add. Do NOT auto-fix — present findings for the user to review. If no aidlc/ directory exists or the task didn't touch requirements.md, do nothing."
  }
}
```

### Step 4: Verify Installation

After creating all files, verify:
- [ ] Four agent files exist in `.kiro/agents/`
- [ ] Steering file exists in `.kiro/steering/aidlc-spec-elaboration.md`
- [ ] Hook file exists in `.kiro/hooks/aidlc-spec-requirements-check.json`
- [ ] Hook file exists in `.kiro/hooks/aidlc-requirements-unit-validation.json`

## Available Steering Files

This power includes detailed workflow guides loaded on-demand:

- **state-machine** — Phase transitions, state detection, edge cases, and error recovery
- **complexity-rubric** — Complexity assessment rubric, question depth, question categories and strategy
- **unit-format** — EARS notation, unit file template, decomposition principles, scaling by depth
- **spec-handoff** — Creating specs from units, reference linking, parallel opportunities, per-spec elaboration
- **resume-protocol** — Session state detection, resume presentation, recovery scenarios

## Core Workflow

### When to Activate

Activate when the user wants to plan, decompose, or break down a feature or project,
or when they want to resume an existing AI-DLC session.

### Execution Rules

1. **Always read state first.** Check for `aidlc/elaboration-log.md` and `aidlc/status.md`.
   Read the resume-protocol steering file if a session exists.

2. **One question per turn.** During QUESTIONING, ask exactly one question, then wait.
   Never batch questions. Never assume answers.

3. **Track everything.** Every question, answer, and decision goes into the elaboration
   log. Every phase transition updates the status dashboard.

4. **Rich formatting always.** Use tables, status indicators, progress tracking, and
   clear section headers. The user should always know where they are.

5. **Delegate to subagents.** Use `aidlc-decomposer` for unit generation,
   `aidlc-validator` for cross-validation, `aidlc-spec-elaborator` for per-spec
   requirements elaboration, and `aidlc-requirements-validator` for post-requirements
   coverage checks against unit definitions.

6. **Never invent features.** Only include what the user asked for. If something is
   strongly recommended, raise it as a question. Let the user decide.

7. **Prefer fewer, larger units.** Justify every split with bounded context rationale.

8. **No Spec mode until all units are finalized.** Do NOT mention Spec mode, spec
   creation, `requirements.md`, or switching modes until the HANDOFF phase is reached
   with all units generated, validated, and accepted by the user. The unit file
   templates include a Spec Reference section for later use, but do not direct the
   user to act on it until HANDOFF.

### Phase Quick Reference

| Phase | What happens | User action needed |
|-------|-------------|-------------------|
| INIT | Parse intent, create session files | Confirm understanding |
| ASSESS | Complexity assessment, depth recommendation | Confirm or override depth |
| QUESTIONING | Strategic questions, one at a time | Answer each question |
| READY_CHECK | Propose moving to decomposition | Confirm or request more |
| DECOMPOSE | Generate unit files via subagents | Review units |
| VALIDATE | Cross-reference validation | Review findings |
| HANDOFF | Present spec creation instructions | Pick a unit to implement |
| COMPLETE | Session finished | Start spec work |

### INIT Phase

When no `aidlc/` directory exists or the user provides a new intent:

1. Create the directory structure:
   - `aidlc/elaboration-log.md`
   - `aidlc/status.md`
   - `aidlc/units/` (empty)

2. Write the intent and your understanding to the elaboration log.

3. Present to the user with rich formatting:

```markdown
## 🎯 Intent Received

**Your intent:** {quoted intent}

### My Understanding
{2-3 paragraph interpretation}

### What I'd Like to Clarify
{Brief note on ambiguities}

---
📊 **Status:** INIT → Moving to complexity assessment
```

### ASSESS Phase

Read the complexity-rubric steering file. Evaluate and present:

```markdown
## 📊 Complexity Assessment

| Factor | Rating | Rationale |
|--------|--------|-----------|
| Scope | {rating} | {why} |
| Users | {rating} | {why} |
| Integrations | {rating} | {why} |
| Data | {rating} | {why} |
| Risk | {rating} | {why} |
| Clarity | {rating} | {why} |

**Overall:** {Lightweight / Standard / Comprehensive}
**Recommended depth:** {N} questions

> Proceed with {depth} depth, or prefer a different level?

---
📊 **Status:** ASSESS | Awaiting depth confirmation
```

### QUESTIONING Phase

For each question, read the complexity-rubric steering file for question strategy:

```markdown
## ❓ Question {N}/{estimated_total} — {Category}

{Question text}

{Optional: 2-3 suggested answers}

---
📊 **Progress:** {'█' * answered}{'░' * remaining} {answered}/{estimated_total}
📋 **Decisions so far:** {count} recorded
```

### READY_CHECK Phase

```markdown
## ✅ Ready Check

I've asked {N} questions and have a solid understanding of:
{bulleted summary of key decisions}

**Ready to decompose into implementation units.**

> Shall I proceed, or is there more to cover?
```

### DECOMPOSE Phase

1. Invoke `aidlc-decomposer` subagent with the elaboration log.
2. Invoke `aidlc-validator` subagent to cross-validate.
3. Present results with unit table and dependency graph.

Read the unit-format steering file for decomposition details.

### HANDOFF Phase

**CRITICAL: Only reach this phase after ALL units are generated and validated.**
Do NOT present spec creation instructions until the user has reviewed and accepted
the complete set of units. Never mention Spec mode during earlier phases.

Read the spec-handoff steering file. Present:

```markdown
## 🚀 All Units Defined — Ready for Implementation

All {N} units have been generated and validated. Here's your implementation roadmap:

| Order | Unit | Spec Command | Status |
|-------|------|-------------|--------|
| 1 | {name} | Spec mode → reference `#aidlc/units/01-xxx.md` | ⬜ Not started |
| ... | ... | ... | ... |

### How to Start
1. Pick a unit (recommended: follow dependency order)
2. Switch to **Spec mode** in Kiro
3. Start a new spec and reference the unit file
4. The steering file will guide elaboration-informed requirements
5. Reference the elaboration log for additional context

> Which unit would you like to start with?
```

## Status Dashboard

The `aidlc/status.md` file tracks session state. Update it on every phase transition.

Template:

```markdown
# AI-DLC Session Status

## Overview
| Field | Value |
|-------|-------|
| Intent | {short description} |
| Complexity | {rating} |
| Current Phase | {phase} |
| Started | {date} |
| Last Updated | {date} |

## Progress
| Metric | Value |
|--------|-------|
| Questions asked | 0 |
| Questions answered | 0 |
| Decisions recorded | 0 |
| Units generated | 0 |
| Specs created | 0 |

## Questioning Progress
| # | Category | Question Summary | Answered |
|---|----------|-----------------|----------|

## Decisions Log
| # | Decision | Rationale | Source |
|---|----------|-----------|--------|

## Units
| # | Unit | File | Dependencies | Spec Status |
|---|------|------|-------------|-------------|
```

## Elaboration Log Template

New sessions start with:

```markdown
# Mob Elaboration Log

## Intent
{raw intent from user}

## Understanding
{facilitator's interpretation}

## Phase: INIT
```

## Unit File Template

Each unit follows this structure:

```markdown
# Unit: {Name}

**Description:** {one paragraph}

**Bounded Context Rationale:** {why this is a separate unit}

**User Stories:**
- WHEN {condition} THE SYSTEM SHALL {behavior}

**NFRs:**
- {Requirement with measurable target}

**Risks:**
- {Risk} — mitigate with {strategy}

**Dependencies:** {other units or "None (foundational unit)"}

**Suggested Bolts:**
- Bolt 1: {Scope}

## Spec Reference

> ⚠️ **Do not act on this section until all units are defined and validated.**

To implement this unit as a Kiro spec (after HANDOFF):
1. Switch to **Spec mode** in Kiro
2. Start a new spec and reference this file: `#aidlc/units/{filename}`
3. Also reference the elaboration log: `#aidlc/elaboration-log.md`
```

## Best Practices

### ✅ Do:
- Read state before every action (elaboration log + status dashboard)
- Ask one question at a time and wait for the answer
- Track all decisions in the elaboration log
- Use rich markdown formatting for all user-facing output
- Delegate to subagents for decomposition, validation, and spec elaboration
- Reference steering files for detailed guidance on each phase

### ❌ Don't:
- Batch multiple questions in one turn
- Assume or invent answers to your own questions
- Add features the user didn't ask for
- Skip the complexity assessment
- Generate units without user confirmation
- Write requirements.md without checking for elaboration context
- **Mention Spec mode before ALL units are defined and validated** — no references to
  "Switch to Spec mode", spec creation, or `requirements.md` until the HANDOFF phase
  is reached with all units generated, validated, and accepted by the user

## Troubleshooting

### Session won't resume
Read the resume-protocol steering file. Check that `aidlc/elaboration-log.md` exists
and contains a valid `## Phase:` marker.

### Subagents not available
Verify the onboarding step completed. Check `.kiro/agents/` for the three agent files.

### Steering file not activating on requirements.md
Verify `.kiro/steering/aidlc-spec-elaboration.md` exists with the correct frontmatter
(`inclusion: fileMatch`, `fileMatchPattern: "**/requirements.md"`).

### Hook not firing before spec tasks
Verify `.kiro/hooks/aidlc-spec-requirements-check.json` exists with valid JSON.

### Requirements validation not running after requirements.md is written
Verify `.kiro/hooks/aidlc-requirements-unit-validation.json` exists with valid JSON.
Also confirm the task that wrote requirements.md completed (the hook fires on
`postTaskExecution`). Check that `aidlc/units/` contains a unit file whose name
can be matched to the current spec.
