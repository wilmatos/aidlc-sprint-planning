---
name: "aidlc-mob-elaboration"
displayName: "AI-DLC Mob Elaboration"
description: "Structured feature planning that decomposes intents into implementation units through strategic questioning. Use when starting a new feature, project, or system to produce specs ready for Kiro's Spec-Driven Development."
keywords: ["plan", "decompose", "elaborate", "break down", "scope", "build", "design", "architect", "specs", "requirements", "feature", "project", "discovery", "units", "implementation", "prd", "aidlc", "mob elaboration", "think through", "figure out", "roadmap", "breakdown", "map out", "outline", "structure", "strategy", "approach", "proposal", "implement", "create", "develop", "new feature", "new app", "new application", "new service", "new system", "refactor", "migrate", "integrate", "epic", "milestone", "mvp", "where do i start", "how do i approach", "help me think", "not sure how to"]
author: "workspace"
---

# AI-DLC Mob Elaboration

## Overview

This power facilitates structured decomposition of high-level intents into well-defined,
independently implementable units through strategic questioning. It then hands off each
unit to Kiro's Spec-Driven Development with full elaboration context.

The process follows a state machine:

```
INIT → ASSESS → QUESTIONING → READY_CHECK → TEAM_TOPOLOGY → DECOMPOSE → VALIDATE → HANDOFF → COMPLETE
```

Use this power when you want to plan, decompose, elaborate, or break down a feature,
project, or intent into specs. It supports resuming interrupted sessions, parallel unit
generation via subagents, and rich status tracking throughout.

## Onboarding

On first activation, ask the user where to install the workspace artifacts:

```
Where would you like to install the AI-DLC Mob Elaboration artifacts?

1. **Local** — installs into this workspace only (`.kiro/` in the current project root)
2. **Global** — installs for all projects (`~/.kiro/` in your home directory)

> Local or global?
```

- If **local**, use `.kiro/` as the base path for all files below.
- If **global**, use `~/.kiro/` as the base path for all files below.

Referred to as `{base}` in the steps that follow.

These artifacts enable subagent delegation and spec-mode integration.

Note: hooks are not installed during onboarding — requirements validation and spec
elaboration context are enforced directly in the workflow (see HANDOFF phase).

### Step 1: Create Subagent Files

Create four subagent files in `{base}/agents/`. Each file has a frontmatter header
followed by instructions that reference the corresponding steering file for its logic.

**File: `{base}/agents/aidlc-decomposer.md`**

```markdown
---
name: aidlc-decomposer
description: >
  Generates AI-DLC unit files from a completed mob elaboration log. Invoked during
  the DECOMPOSE phase. Reads the elaboration log and produces numbered,
  dependency-ordered unit files in aidlc/units/. Use when decomposing an elaborated
  intent into bounded implementation units.
tools: ["read", "write"]
---

# AI-DLC Unit Decomposer

You generate implementation unit files from a completed mob elaboration session.

## Input

Read the full content of `aidlc/elaboration-log.md` and `aidlc/status.md`.

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
6. Before generating units, read the `## Team Topology` section of the elaboration
   log and apply the selected strategy (A–F) to unit boundaries and ordering.
   If no topology section exists, default to Strategy A (vertical slices).
7. After writing all unit files, generate `aidlc/plan.md` following the
   `plan-generator` steering file from the AI-DLC Mob Elaboration power.
8. After writing units and plan, update `aidlc/status.md` and append a
   decomposition summary to `aidlc/elaboration-log.md`.

## Scale Detail by Depth

- Lightweight: 2-3 stories, brief NFRs, key risks
- Standard: 4-8 stories, NFRs with targets, risks with mitigations
- Comprehensive: Full stories with edge cases, detailed NFRs, risk register

## Unit File Structure

Each unit file must include:
- Description (one paragraph)
- Bounded Context Rationale (why this is a separate unit)
- User Stories (EARS notation)
- NFRs (with measurable targets)
- Risks (with mitigation strategies)
- Dependencies (other units by number and name, or "None")
- Suggested Bolts (logical sub-chunks of implementation work within the unit)
- Spec Reference section (boilerplate — do not act on it during decomposition)
```

**File: `{base}/agents/aidlc-validator.md`**

```markdown
---
name: aidlc-validator
description: >
  Cross-validates AI-DLC unit files for completeness, consistency, and dependency
  correctness. Invoked after unit decomposition. Checks that all user decisions are
  captured, dependencies are acyclic, and no functionality gaps exist. Use when
  validating elaboration unit files.
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
```

**File: `{base}/agents/aidlc-spec-elaborator.md`**

```markdown
---
name: aidlc-spec-elaborator
description: >
  Handles per-unit elaboration questioning when a user starts creating specs from an
  AI-DLC unit. Asks focused, tactical questions about implementation details specific
  to one unit before requirements.md is written. Use when elaborating requirements
  for a specific unit.
tools: ["read", "write"]
---

# AI-DLC Spec Elaborator

You facilitate focused requirements elaboration for a single AI-DLC unit.

## Input

A specific unit file from `aidlc/units/` and relevant sections of the elaboration log.

## Questioning Strategy

Ask 2-5 focused, tactical questions about this specific unit. These are
implementation-detail questions not covered in mob elaboration:
- Specific API contracts and response shapes
- Error handling and recovery behavior
- Data validation rules and edge cases
- Integration specifics with dependent units
- Security and authorization details
- Testability and observable outcomes

## Rules

1. Ask one question at a time. Ask, wait for the answer, then ask the next.
2. Stay scoped to this unit only — don't re-ask mob elaboration questions.
3. Focus on testability — every answer should help write testable acceptance criteria.
4. Record answers in the elaboration log under `## Spec Elaboration: {Unit Name}`.
5. Stop after 2-5 questions or when enough detail exists to write requirements.md.
```

**File: `{base}/agents/aidlc-requirements-validator.md`**

```markdown
---
name: aidlc-requirements-validator
description: >
  Validates a completed requirements.md file against its source AI-DLC unit definition
  to ensure no features, user stories, NFRs, or risks were missed. Invoked automatically
  after requirements.md is written. Use when validating spec requirements against unit
  definitions.
tools: ["read"]
---

# AI-DLC Requirements Validator

You validate that requirements fully cover everything defined in the source AI-DLC unit.

## Input

- The requirements document for the current spec
- The corresponding unit file from `aidlc/units/`
- Relevant sections of `aidlc/elaboration-log.md`

## Matching Logic

Identify the corresponding unit file by matching the current spec name to a unit
file in `aidlc/units/`. If ambiguous, ask the user which unit file to validate against.

## Validation Checks

1. **User Story Coverage** — Every user story (WHEN/IF/WHILE/THE SYSTEM SHALL) from
   the unit file has at least one corresponding requirement.
2. **NFR Coverage** — Every NFR listed in the unit file has a corresponding requirement.
3. **Risk Coverage** — Risks listed in the unit file are addressed by defensive
   requirements or explicitly acknowledged.
4. **Scope Fidelity** — Requirements do not introduce features beyond the unit file.
5. **Elaboration Answers** — Spec elaboration answers are reflected in requirements.

## Rules

1. Same intent counts as covered — wording doesn't need to be identical.
2. A story split across multiple requirements counts as covered.
3. Don't flag scope additions as errors — just note them for awareness.
4. Suggest specific requirements to close any gaps found.
5. Do NOT auto-fix — present findings for the user to review and decide.

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
```

### Step 2: Create Steering Files

Create `{base}/steering/aidlc-spec-elaboration.md`:

```markdown
---
inclusion: manual
---

# AI-DLC Spec Elaboration Enforcement

When working on a `requirements.md` file for a Kiro spec, check whether this spec
was created from an AI-DLC unit file. If so, enforce elaboration-informed requirements
generation by following the spec creation steps in the `spec-handoff` steering file
from the AI-DLC Mob Elaboration power.

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
```

Create `{base}/steering/aidlc-requirements-validation.md`:

```markdown
---
inclusion: manual
---

# Requirements vs Unit Validation

Validate that the current requirements document fully covers everything defined
in the corresponding AI-DLC unit file.

## Matching

Identify the unit file by matching the current spec name to a file in `aidlc/units/`.
If ambiguous, ask the user which unit file to validate against.

## Checks

1. Every user story (WHEN/IF/WHILE/THE SYSTEM SHALL) from the unit has a requirement.
2. Every NFR from the unit has a corresponding requirement.
3. Every risk from the unit is addressed or explicitly acknowledged.
4. No scope creep — requirements don't introduce features beyond the unit file.
5. Spec elaboration answers (from `## Spec Elaboration:` in the log) are reflected.

## Report Format

Present a coverage table, then list any missing items, then give a verdict.
Same intent counts as covered. Don't auto-fix — present findings for user review.
```

### Step 3: Verify Installation

After creating all files, verify:
- [ ] Four agent files exist in `{base}/agents/`
- [ ] Steering file exists in `{base}/steering/aidlc-spec-elaboration.md`
- [ ] Steering file exists in `{base}/steering/aidlc-requirements-validation.md`

## Available Steering Files

This power includes detailed workflow guides loaded on-demand:

- **workflow** — Execution rules, phase quick reference, and per-phase instructions
- **state-machine** — Phase transitions, state detection, edge cases, and error recovery
- **complexity-rubric** — Complexity assessment rubric, question depth, question categories and strategy
- **unit-format** — EARS notation, unit file template, decomposition principles, scaling by depth
- **team-topology** — Team structure assessment and decomposition strategy selection
- **decomposer** — Unit generation rules
- **validator** — Cross-validation checks for unit files
- **plan-generator** — Execution plan generation
- **spec-handoff** — Creating specs from units, per-unit elaboration, requirements coverage validation
- **requirements-validation** — Validates requirements.md coverage against unit definitions
- **resume-protocol** — Session state detection, resume presentation, recovery scenarios

Both `aidlc-spec-elaboration` and `aidlc-requirements-validation` are installed as
`inclusion: manual` steering files. Reference them explicitly in chat when needed:
- `#aidlc-spec-elaboration` — before writing requirements.md for a unit
- `#aidlc-requirements-validation` — after writing requirements.md to validate coverage

## Core Workflow

Read the workflow steering file for execution rules, phase quick reference, and
per-phase instructions. The sections below cover Power-specific behaviour only.

### Session State on Activation

Before doing anything else on activation, check for `aidlc/elaboration-log.md`
in the current workspace. If it exists, read the resume-protocol steering file
and follow the resume flow before proceeding. Do not start a new session if one
is already in progress.

### Templates

When creating session files during INIT, use the templates from the power's
`templates/` directory:

- `templates/elaboration-log-template.md` → `aidlc/elaboration-log.md`
- `templates/status-template.md` → `aidlc/status.md`
- `templates/unit-template.md` → each `aidlc/units/NN-name.md`
- `templates/plan-template.md` → `aidlc/plan.md`

### Subagent Delegation

Delegate to subagents rather than performing these tasks inline:
- **DECOMPOSE phase:** invoke `aidlc-decomposer` to generate unit files
- **VALIDATE phase:** invoke `aidlc-validator` to cross-validate units
- **HANDOFF — pre-spec elaboration:** invoke `aidlc-spec-elaborator` per unit
- **HANDOFF — requirements coverage:** invoke `aidlc-requirements-validator` after writing requirements.md

Invoke subagents directly — do not rely on hooks for any part of this workflow.

### Formatting

Use rich markdown formatting for all user-facing output: tables, status indicators,
progress bars, emoji section headers, and clear section separators. The user should
always know which phase they are in and what happens next.

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
- Write requirements.md without first running pre-spec elaboration via `aidlc-spec-elaborator`
- Skip requirements coverage validation after writing requirements.md
- Mention spec creation before ALL units are defined and validated

## Troubleshooting

### Session won't resume
Read the resume-protocol steering file. Check that `aidlc/elaboration-log.md` exists
and contains a valid `## Phase:` marker.

### Subagents not available
Verify the onboarding step completed. Check `.kiro/agents/` (local) or `~/.kiro/agents/`
(global) for the four agent files.

### Steering file not loading for spec elaboration
Verify `aidlc-spec-elaboration.md` exists in `.kiro/steering/` or `~/.kiro/steering/`
with `inclusion: manual` in its frontmatter. Reference it explicitly in chat with
`#aidlc-spec-elaboration`.

### Requirements validation not running
Invoke the `aidlc-requirements-validator` subagent directly, or reference
`#aidlc-requirements-validation` in chat. Verify `aidlc-requirements-validation.md`
exists in `.kiro/steering/` or `~/.kiro/steering/` with `inclusion: manual`.
Check that `aidlc/units/` contains a unit file whose name matches the current spec.
