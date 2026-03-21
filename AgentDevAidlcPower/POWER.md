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
Follow all instructions in the `decomposer` steering file.

#[[file:{base}/steering/decomposer.md]]
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
Follow all instructions in the `validator` steering file.

#[[file:{base}/steering/validator.md]]
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
Follow the per-unit elaboration steps in the `spec-handoff` steering file.

#[[file:{base}/steering/spec-handoff.md]]
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
Follow all instructions in the `requirements-validation` steering file.

#[[file:{base}/steering/requirements-validation.md]]
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
generation by following the spec creation steps in the spec-handoff steering file.

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

#[[file:{base}/steering/spec-handoff.md]]
```

Create `{base}/steering/aidlc-requirements-validation.md`:

```markdown
---
inclusion: manual
---

# Requirements vs Unit Validation

#[[file:{base}/steering/requirements-validation.md]]
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
Verify the onboarding step completed. Check `{base}/agents/` for the four agent files.

### Steering file not loading for spec elaboration
Verify `{base}/steering/aidlc-spec-elaboration.md` exists with `inclusion: manual`
in its frontmatter. Reference it explicitly in chat with `#aidlc-spec-elaboration`.

### Requirements validation not running
Invoke the `aidlc-requirements-validator` subagent directly, or reference
`#aidlc-requirements-validation` in chat. Verify `{base}/steering/aidlc-requirements-validation.md`
exists with `inclusion: manual`. Check that `aidlc/units/` contains a unit file
whose name matches the current spec.
