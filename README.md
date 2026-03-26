# AgentDevAidlc — AI-DLC Mob Elaboration

Structured feature planning through strategic questioning. Decomposes high-level intents into well-defined, independently implementable units using the AI-DLC Methodology's mob elaboration approach.

This repository contains three implementations of the same workflow, each tailored to a different client:

| Implementation | Client | Format |
|---|---|---|
| [AgentDevAidlcPower](#agentdevaidlcpower) | Kiro IDE | `POWER.md` + `steering/` |
| [AgentDevAidlcSkill](#agentdevaidlcskill) | Generic / any agent | `SKILL.md` + `references/` + `assets/` |
| [AgentDevAidlcCLI](#agentdevaidlccli) | Kiro CLI | `.kiro/steering/` + `.kiro/agents/*.json` |

All three implement the same state machine and elaboration logic — they differ only in how they integrate with their target client. Core logic lives in `common/` and is copied into each implementation by the CI pipeline.

## What it does

1. Parses your intent and assesses complexity
2. Asks focused, one-at-a-time questions to clarify scope and decisions
3. Decomposes the elaborated intent into bounded implementation units (EARS notation)
4. Validates units for completeness, dependency ordering, and coverage
5. Hands off each unit for implementation — optionally generating `requirements.md`, `design.md`, and `tasks.md` for each

State machine: `INIT → ASSESS → QUESTIONING → READY_CHECK → TEAM_TOPOLOGY → DECOMPOSE → VALIDATE → HANDOFF → COMPLETE`

---

## AgentDevAidlcPower

A [Kiro Power](https://kiro.dev/docs/powers/) — the native extension format for Kiro IDE.

- Entry point is `POWER.md`, which contains the full agent instructions and onboarding steps
- On first activation, onboards the workspace by creating subagent files, steering files, and hooks
- Supports Kiro-specific features: subagent `.md` files, `fileMatch` steering, and hooks

### Package contents

```
AgentDevAidlcPower/
├── POWER.md                        # Agent instructions, onboarding steps, subagent delegation
└── steering/
    ├── workflow.md                 # Execution rules, phase quick reference, per-phase instructions
    ├── complexity-rubric.md        # Complexity assessment rubric and question strategy
    ├── decomposer.md               # Unit generation rules and decomposition principles
    ├── plan-generator.md           # Plan generation guidance
    ├── requirements-validation.md  # Validates requirements.md against unit definitions
    ├── resume-protocol.md          # Session state detection and recovery
    ├── spec-handoff.md             # Spec creation from units, per-unit elaboration
    ├── state-machine.md            # Phase transitions, edge cases, error recovery
    ├── team-topology.md            # Team structure and decomposition strategy
    ├── unit-format.md              # EARS notation, unit file template, scaling rules
    └── validator.md                # Cross-validation checks for unit files
```

The `POWER.md` onboarding installs these artifacts into the target workspace:

| Artifact | Path | Purpose |
|---|---|---|
| Subagent | `.kiro/agents/aidlc-decomposer.md` | Generates unit files from elaboration log |
| Subagent | `.kiro/agents/aidlc-validator.md` | Cross-validates unit files |
| Subagent | `.kiro/agents/aidlc-spec-elaborator.md` | Per-unit requirements elaboration |
| Subagent | `.kiro/agents/aidlc-requirements-validator.md` | Validates requirements against units |

### Installation

- **Kiro Powers panel (recommended):** Add Custom Power → Import from GitHub → provide this repo URL
- **Local path:** Add power from Local Path → point to the `AgentDevAidlcPower` directory
- **CI artifact:** Download `aidlc-mob-elaboration-power.zip` from pipeline artifacts, extract, and import via Local Path

---

## AgentDevAidlcSkill

A generic Skill — client-agnostic, no file copying to client-specific folders.

- Entry point is `SKILL.md`, which contains the full agent instructions
- Sub-concern logic lives in `references/`, templates in `assets/`
- No hooks, no workspace onboarding — works with any agent host that supports the skills format

### Package contents

```
AgentDevAidlcSkill/
└── aidlc-mob-elaboration/
    ├── SKILL.md                        # Agent instructions and phase reference
    ├── assets/
    │   ├── elaboration-log-template.md # Starting template for aidlc/elaboration-log.md
    │   ├── plan-template.md            # Starting template for aidlc/plan.md
    │   ├── status-template.md          # Starting template for aidlc/status.md
    │   └── unit-template.md            # Template for individual unit files
    └── references/
        ├── workflow.md             # Execution rules, phase quick reference, per-phase instructions
        ├── complexity-rubric.md        # Complexity assessment rubric and question strategy
        ├── decomposer.md               # Unit generation rules and decomposition principles
        ├── requirements-validation.md  # Validates requirements.md against unit definitions
        ├── resume-protocol.md          # Session state detection and recovery
        ├── spec-handoff.md             # Spec creation from units, per-unit elaboration
        ├── state-machine.md            # Phase transitions, edge cases, error recovery
        ├── team-topology.md            # Team structure and decomposition strategy
        ├── unit-format.md              # EARS notation, unit file template, scaling rules
        └── validator.md                # Cross-validation checks for unit files
```

### Installation

Copy the `AgentDevAidlcSkill/aidlc-mob-elaboration/` directory into your skills folder and activate it from your agent host.

---

## AgentDevAidlcCLI

A configuration package for [Kiro CLI](https://kiro.dev/docs/cli/).

- Main steering file (`aidlc-mob-elaboration.md`) loads automatically via `inclusion: always`
- All other steering files are `inclusion: manual` — reference them with `#` in chat as needed
- Agents use `.json` format (Kiro CLI does not support `.md` subagents or hooks)

### Package contents

```
AgentDevAidlcCLI/
├── README.md
└── .kiro/
    ├── agents/
    │   ├── aidlc-decomposer.json               # Generates unit files from elaboration log
    │   ├── aidlc-requirements-validator.json   # Validates requirements against units
    │   ├── aidlc-spec-elaborator.json          # Per-unit requirements elaboration
    │   └── aidlc-validator.json                # Cross-validates unit files
    ├── steering/
    │   ├── aidlc-mob-elaboration.md            # Core workflow — CLI formatting, delegates to aidlc-workflow.md
    │   ├── aidlc-workflow.md                   # Execution rules and per-phase instructions (inclusion: manual)
    │   ├── aidlc-complexity-rubric.md          # Complexity assessment (inclusion: manual)
    │   ├── aidlc-decomposer.md                 # Unit generation rules (inclusion: manual)
    │   ├── aidlc-plan-generator.md             # Plan generation (inclusion: manual)
    │   ├── aidlc-requirements-validation.md    # Requirements validation (inclusion: manual)
    │   ├── aidlc-resume-protocol.md            # Session recovery (inclusion: manual)
    │   ├── aidlc-spec-handoff.md               # Spec creation and handoff (inclusion: manual)
    │   ├── aidlc-state-machine.md              # Phase transitions (inclusion: manual)
    │   ├── aidlc-team-topology.md              # Team topology (inclusion: manual)
    │   ├── aidlc-terminal-format.md            # Terminal output formatting (inclusion: manual)
    │   ├── aidlc-unit-format.md                # EARS notation and unit template (inclusion: manual)
    │   └── aidlc-validator.md                  # Cross-validation checks (inclusion: manual)
    └── templates/
        ├── elaboration-log-template.md         # Starting template for aidlc/elaboration-log.md
        ├── plan-template.md                    # Starting template for aidlc/plan.md
        ├── status-template.md                  # Starting template for aidlc/status.md
        └── unit-template.md                    # Template for individual unit files
```

### Installation

Copy the `.kiro/` directory into your project root:

```bash
cp -r AgentDevAidlcCLI/.kiro/ /path/to/your/project/.kiro/
```

Then run `kiro-cli chat` in that project directory.

---

## Implementation differences

| Capability | Power (Kiro IDE) | Skill (Generic) | CLI (Kiro CLI) |
|---|---|---|---|
| Entry point | `POWER.md` | `SKILL.md` | `aidlc-mob-elaboration.md` (steering) |
| Sub-concern files | `steering/*.md` (power-loaded) | `references/*.md` | `.kiro/steering/*.md` |
| Templates | `templates/` (power-loaded) | `assets/` | `.kiro/templates/` |
| Agent/subagent format | `.md` (Kiro subagents) | N/A | `.json` |
| Hooks support | ❌ (not installed during onboarding) | ❌ | ❌ |
| Workspace onboarding | ✅ (installs agents and steering files) | ❌ | Manual `cp` |
| Activation | Keyword-triggered | Client-dependent | `inclusion: always` on main steering file |

---

## Repository structure

```
/
├── common/                        # Single source of truth for all logic files
│   ├── workflow.md
│   ├── complexity-rubric.md
│   ├── decomposer.md
│   ├── plan-generator.md
│   ├── requirements-validation.md
│   ├── resume-protocol.md
│   ├── spec-handoff.md
│   ├── state-machine.md
│   ├── team-topology.md
│   ├── unit-format.md
│   ├── validator.md
│   └── templates/
│       ├── elaboration-log-template.md
│       ├── plan-template.md
│       ├── status-template.md
│       └── unit-template.md
│
├── AgentDevAidlcPower/            # Kiro IDE power implementation
├── AgentDevAidlcSkill/            # Generic skill implementation
├── AgentDevAidlcCLI/              # Kiro CLI implementation
│
├── scripts/
│   └── copy-common.sh             # Copies common/ into each implementation
│
└── .gitlab-ci.yml                 # Runs copy-common.sh then packages each artifact
```

### Editing logic files

All core logic lives in `common/`. Never edit the copied files directly — they will be overwritten by the next CI run.

To update logic:
1. Edit the file in `common/`
2. Run `bash scripts/copy-common.sh all` to sync locally
3. Commit both the `common/` change and the synced copies

To update implementation-specific behavior:
- Power: edit `AgentDevAidlcPower/POWER.md`
- Skill: edit `AgentDevAidlcSkill/aidlc-mob-elaboration/SKILL.md`
- CLI: edit `AgentDevAidlcCLI/.kiro/steering/aidlc-mob-elaboration.md` or the agent JSON files

---

## Keywords

`plan` · `decompose` · `elaborate` · `break down` · `scope` · `build` · `design` · `architect` · `specs` · `requirements` · `feature` · `project` · `discovery` · `prd` · `aidlc` · `roadmap` · `breakdown` · `map out` · `outline` · `structure` · `strategy` · `approach` · `proposal` · `implement` · `create` · `develop` · `new feature` · `new app` · `new application` · `new service` · `new system` · `refactor` · `migrate` · `integrate` · `epic` · `milestone` · `mvp` · `where do i start` · `how do i approach` · `help me think` · `not sure how to`

## Learn more

- [Kiro Powers documentation](https://kiro.dev/docs/powers/)
- [Creating custom powers](https://kiro.dev/docs/powers/create/)
- [Installing powers](https://kiro.dev/docs/powers/installation/)
