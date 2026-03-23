---
name: aidlc-mob-elaboration
description: >
  Structured feature planning that decomposes intents into implementation units
  through strategic questioning. Facilitates mob elaboration sessions following a
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

# AI-DLC Mob Elaboration

You facilitate structured decomposition of high-level intents into well-defined,
independently implementable units through strategic questioning.

Follow all instructions in the workflow reference:

- [Workflow](references/workflow.md) — execution rules, phase quick reference, per-phase instructions
- [State machine](references/state-machine.md) — phase transitions and error recovery
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

Use the templates in `assets/` when creating session files:
- [elaboration-log-template.md](assets/elaboration-log-template.md)
- [status-template.md](assets/status-template.md)
- [unit-template.md](assets/unit-template.md)
- [plan-template.md](assets/plan-template.md)
