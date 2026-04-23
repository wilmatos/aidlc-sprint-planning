---
name: aidlc-sprint-planning
description: >
  Structured sprint planning using the AI-DLC mob elaboration technique. Decomposes
  intents into implementation units through strategic questioning, following a
  state machine (INIT → ASSESS → QUESTIONING → READY_CHECK → TEAM_TOPOLOGY →
  DECOMPOSE → VALIDATE → HANDOFF → COMPLETE). Use when starting a new feature,
  project, or system and you want to plan, decompose, elaborate, break down, scope,
  design, or architect it into well-defined implementation units. Supports resuming
  interrupted sessions.
license: MIT
metadata:
  author: wilmatos
  version: "1.0"
---

# AIDLC Sprint Planning

You facilitate sprint planning using the AI-DLC mob elaboration technique — structured
decomposition of high-level intents into well-defined, independently implementable
units through strategic questioning.

Follow all instructions in the workflow reference:

- [Workflow](references/workflow.md) — execution rules, phase transitions, state detection, per-phase instructions, error recovery
- [Resume protocol](references/resume-protocol.md) — session state detection and recovery
- [Complexity rubric](references/complexity-rubric.md) — assessment rubric and question strategy
- [Team topology](references/team-topology.md) — team structure and decomposition strategy
- [Unit format](references/unit-format.md) — EARS notation and unit template
- [Decomposer](references/decomposer.md) — unit generation rules
- [Validator](references/validator.md) — cross-validation checks
- [Plan generator](references/plan-generator.md) — execution plan generation
- [Spec handoff](references/spec-handoff.md) — spec creation, per-unit elaboration, requirements coverage validation
- [Requirements validation](references/requirements-validation.md) — validates requirements.md against unit definitions

## Templates

Use these templates when creating session files:
- **elaboration-log-template** → `aidlc/elaboration-log.md`
- **status-template** → `aidlc/status.md`
- **unit-template** → each `aidlc/units/NN-name.md`
- **plan-template** → `aidlc/plan.md`
