# AI-DLC Mob Elaboration — Kiro CLI Package

Structured feature planning that decomposes intents into implementation units through strategic questioning.

## Usage

Open Kiro CLI in this directory (or any project that has this `.kiro/` structure copied into it):

```bash
cd AgentDevAidlcCLI
kiro-cli chat
```

The main steering file (`aidlc-mob-elaboration.md`) loads automatically via `inclusion: always` and guides the entire workflow.

## What's Included

### Steering Files (`.kiro/steering/`)

| File | Inclusion | Purpose |
|------|-----------|---------|
| `aidlc-mob-elaboration.md` | always | Core workflow — loaded on every conversation |
| `aidlc-state-machine.md` | manual | Phase transitions and state detection |
| `aidlc-complexity-rubric.md` | manual | Complexity assessment and question strategy |
| `aidlc-unit-format.md` | manual | EARS notation and unit templates |
| `aidlc-decomposer.md` | manual | Unit generation rules |
| `aidlc-validator.md` | manual | Cross-validation checks |
| `aidlc-spec-handoff.md` | manual | Implementation roadmap and handoff |
| `aidlc-resume-protocol.md` | manual | Session resumption and recovery |
| `aidlc-requirements-validation.md` | manual | Requirements coverage validation |

### Agents (`.kiro/agents/`)

| Agent | Purpose |
|-------|---------|
| `aidlc-decomposer.json` | Generates unit files from elaboration log |
| `aidlc-validator.json` | Cross-validates unit files |
| `aidlc-spec-elaborator.json` | Per-unit implementation questioning |
| `aidlc-requirements-validator.json` | Validates requirements against units |

### Templates (`.kiro/templates/`)

| Template | Purpose |
|----------|---------|
| `elaboration-log-template.md` | Starting template for `aidlc/elaboration-log.md` |
| `status-template.md` | Starting template for `aidlc/status.md` |
| `unit-template.md` | Template for individual unit files |

## Installing Into Another Project

Copy the `.kiro/` directory into your project root:

```bash
cp -r AgentDevAidlcCLI/.kiro/ /path/to/your/project/.kiro/
```

Then open Kiro CLI in that project directory.
