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

- **state-machine** — Phase transitions, state detection, edge cases, and error recovery
- **complexity-rubric** — Complexity assessment rubric, question depth, question categories and strategy
- **unit-format** — EARS notation, unit file template, decomposition principles, scaling by depth
- **spec-handoff** — Creating specs from units, reference linking, parallel opportunities, per-spec elaboration
- **requirements-validation** — Validates requirements.md coverage against unit definitions; invoke manually with `#aidlc-requirements-validation` after writing requirements
- **resume-protocol** — Session state detection, resume presentation, recovery scenarios

Both `aidlc-spec-elaboration` and `aidlc-requirements-validation` are installed as
`inclusion: manual` steering files. Reference them explicitly in chat when needed:
- `#aidlc-spec-elaboration` — before writing requirements.md for a unit
- `#aidlc-requirements-validation` — after writing requirements.md to validate coverage

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
   coverage checks against unit definitions. Invoke subagents directly — do not rely
   on hooks for any part of this workflow.

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
| READY_CHECK | Propose moving to team topology | Confirm or request more |
| TEAM_TOPOLOGY | Team structure and decomposition strategy | Answer topology questions |
| DECOMPOSE | Generate unit files via subagents | Review units |
| VALIDATE | Cross-reference validation | Review findings |
| HANDOFF | Present spec creation instructions, write specs with validation | Pick a unit to implement |
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

**Ready to assess team structure and decompose into units.**

> Shall I proceed, or is there more to cover?
```

### TEAM_TOPOLOGY Phase

Read the team-topology steering file. Ask topology questions one at a time.
Skip any already answered by prior context. Stop when enough context exists to
select a decomposition strategy. Record the topology profile in the elaboration log.

Minimum required before proceeding to DECOMPOSE:
- Team size and structure
- Unit delivery expectation (demoable slices vs. layered build)

### DECOMPOSE Phase

1. Read the `## Team Topology` section of the elaboration log.
2. Invoke `aidlc-decomposer` subagent with the elaboration log and topology profile.
3. Invoke `aidlc-validator` subagent to cross-validate.
4. Present results with unit table and dependency graph.

Read the unit-format and team-topology steering files for decomposition details.

### HANDOFF Phase

**CRITICAL: Only reach this phase after ALL units are generated and validated.**
Do NOT present spec creation instructions until the user has reviewed and accepted
the complete set of units. Never mention Spec mode during earlier phases.

Read the spec-handoff steering file. Present the implementation roadmap, then offer
to create specification documents (requirements.md, design.md, tasks.md) for each unit.
Follow the "Spec Creation Offer" and "Creating Specs for a Unit" sections in spec-handoff.

#### Creating specs for a unit

For each unit the user picks to implement, follow this sequence:

1. **Pre-spec elaboration.** Before writing requirements.md, invoke the
   `aidlc-spec-elaborator` subagent. It will ask 2-3 focused clarifying questions
   about implementation details specific to that unit. Record answers in the
   elaboration log under `## Spec Elaboration: {Unit Name}`.

2. **Write requirements.md.** Using the unit definition, elaboration log, and
   spec elaboration answers, create the requirements.md for the spec. Follow the
   instructions in the spec-handoff steering file.

3. **Validate requirements coverage.** Immediately after writing requirements.md,
   invoke the `aidlc-requirements-validator` subagent. It will cross-check the
   written requirements against:
   - Every user story in the unit file
   - Every NFR in the unit file
   - Every risk and its mitigation strategy
   - All decisions recorded in the elaboration log that apply to this unit

   Present the validation result as a coverage table:

   ```markdown
   ## ✅ Requirements Coverage Check — {Unit Name}

   | Source | Item | Covered | Notes |
   |--------|------|---------|-------|
   | User Story | WHEN ... THE SYSTEM SHALL ... | ✅ / ❌ | {req ref or gap} |
   | NFR | {requirement} | ✅ / ❌ | {req ref or gap} |
   | Risk | {risk} | ✅ / ❌ | {mitigation captured?} |
   | Decision | {decision} | ✅ / ❌ | {reflected in requirements?} |

   **Result:** {All covered ✅ / {N} gaps found ❌}
   ```

4. **Resolve gaps.** If any gaps are found, update requirements.md to address them,
   then re-run the validator until the result is fully covered.

5. **Proceed to design.md and tasks.md** only after requirements coverage is confirmed.

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

Each unit follows this structure (see unit-format steering file for full details):

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

When ready to implement this unit (after HANDOFF), create three specification documents:

1. **`requirements.md`** — Full requirements using EARS notation
2. **`design.md`** — Technical design document
3. **`tasks.md`** — Implementation task breakdown with checkpoints

See the spec-handoff steering file for detailed instructions on each document.
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
- Write requirements.md without first running pre-spec elaboration via `aidlc-spec-elaborator`
- Skip requirements coverage validation after writing requirements.md — always invoke `aidlc-requirements-validator` before moving to design.md
- **Mention Spec mode before ALL units are defined and validated** — no references to
  "Switch to Spec mode", spec creation, or `requirements.md` until the HANDOFF phase
  is reached with all units generated, validated, and accepted by the user

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
