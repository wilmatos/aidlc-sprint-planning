# AIDLC-Sprint-Planning

Structured feature planning through strategic questioning. Applies the AI-DLC mob elaboration technique to sprint planning, decomposing high-level intents into well-defined, independently implementable units that teams can pick up and execute using Spec-Driven Development.

## Methodology

AIDLC Sprint Planning implements the **mob elaboration** approach from the [AI-DLC Methodology](https://github.com/awslabs/aidlc-workflows). Mob elaboration is a facilitated questioning technique where a group collectively refines a vague intent into concrete, bounded implementation units through structured, one-at-a-time questions.

This project applies that technique specifically to sprint planning: the output is a set of units sized and ordered for sprint execution, each ready to be handed off to Kiro's Spec-Driven Development workflow. The result is an AI-DLC process that fits naturally into existing sprint workflows without competing with SDD — it feeds into it.

This repository contains three implementations of the same workflow, each tailored to a different client:

| Implementation | Client | Format |
|---|---|---|
| [AIDLC-Sprint-Planning-Power](#aidlc-sprint-planning-power) | Kiro IDE | `POWER.md` + `steering/` |
| [AIDLC-Sprint-Planning-Skill](#aidlc-sprint-planning-skill) | Generic / any agent | `SKILL.md` + `references/` + `assets/` |
| [AIDLC-Sprint-Planning-CLI](#aidlc-sprint-planning-cli) | Kiro CLI | `.kiro/steering/` + `.kiro/agents/*.json` |

All three implement the same state machine and elaboration logic — they differ only in how they integrate with their target client. Core logic lives in `common/` and is copied into each implementation by the CI pipeline.

## What it does

1. Parses your intent and assesses complexity
2. Asks focused, one-at-a-time questions to clarify scope and decisions
3. Decomposes the elaborated intent into bounded implementation units (EARS notation)
4. Validates units for completeness, dependency ordering, and coverage
5. Hands off each unit for implementation — optionally generating `requirements.md`, `design.md`, and `tasks.md` for each

State machine: `INIT → ASSESS → QUESTIONING → READY_CHECK → TEAM_TOPOLOGY → DECOMPOSE → VALIDATE → HANDOFF → COMPLETE`

---

## AIDLC-Sprint-Planning-Power

A [Kiro Power](https://kiro.dev/docs/powers/) — the native extension format for Kiro IDE.

- Entry point is `POWER.md`, which contains the full agent instructions and onboarding steps
- On first activation, onboards the workspace by creating subagent files, steering files, and hooks
- Supports Kiro-specific features: subagent `.md` files, `fileMatch` steering, and hooks

### Package contents

```
AIDLC-Sprint-Planning-Power/
├── POWER.md                        # Agent instructions, onboarding steps, subagent delegation
└── steering/
    ├── workflow.md                 # Execution rules, phase quick reference, per-phase instructions
    ├── complexity-rubric.md        # Complexity assessment rubric and question strategy
    ├── decomposer.md               # Unit generation rules and decomposition principles
    ├── plan-generator.md           # Plan generation guidance
    ├── requirements-validation.md  # Validates requirements.md against unit definitions
    ├── resume-protocol.md          # Session state detection and recovery
    ├── spec-handoff.md             # Spec creation from units, per-unit elaboration
    ├── team-topology.md            # Team structure and decomposition strategy
    ├── unit-format.md              # EARS notation, unit file template, scaling rules
    ├── validator.md                # Cross-validation checks for unit files
    ├── template-elaboration-log-template.md  # Starting template for aidlc/elaboration-log.md
    ├── template-plan-template.md             # Starting template for aidlc/plan.md
    ├── template-status-template.md           # Starting template for aidlc/status.md
    └── template-unit-template.md             # Template for individual unit files
```

The `POWER.md` onboarding installs these artifacts into the target workspace:

| Artifact | Path | Purpose |
|---|---|---|
| Subagent | `~/.kiro/agents/aidlc-decomposer.md` | Generates unit files from elaboration log |
| Subagent | `~/.kiro/agents/aidlc-validator.md` | Cross-validates unit files |
| Subagent | `~/.kiro/agents/aidlc-spec-elaborator.md` | Per-unit requirements elaboration |
| Subagent | `~/.kiro/agents/aidlc-requirements-validator.md` | Validates requirements against units |

### Installation

- **Kiro Powers panel (recommended):** Add Custom Power → Import from GitHub → provide this repo URL
- **Local path:** Add power from Local Path → point to the `AIDLC-Sprint-Planning-Power` directory
- **CI artifact:** Download `aidlc-sprint-planning-power.zip` from pipeline artifacts, extract, and import via Local Path

---

## AIDLC-Sprint-Planning-Skill

A generic Skill — client-agnostic, no file copying to client-specific folders.

- Entry point is `SKILL.md`, which contains the full agent instructions
- Sub-concern logic lives in `references/`, templates in `assets/`
- No hooks, no workspace onboarding — works with any agent host that supports the skills format

### Package contents

```
AIDLC-Sprint-Planning-Skill/
└── aidlc-sprint-planning/
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
        ├── team-topology.md            # Team structure and decomposition strategy
        ├── unit-format.md              # EARS notation, unit file template, scaling rules
        └── validator.md                # Cross-validation checks for unit files
```

### Installation

Copy the `AIDLC-Sprint-Planning-Skill/aidlc-sprint-planning/` directory into your skills folder and activate it from your agent host.

---

## AIDLC-Sprint-Planning-CLI

A configuration package for [Kiro CLI](https://kiro.dev/docs/cli/).

- Main steering file (`aidlc-sprint-planning.md`) loads automatically via `inclusion: always`
- All other steering files are `inclusion: manual` — reference them with `#` in chat as needed
- Agents use `.json` format (Kiro CLI does not support `.md` subagents or hooks)

### Package contents

```
AIDLC-Sprint-Planning-CLI/
├── README.md
└── .kiro/
    ├── agents/
    │   ├── aidlc-decomposer.json               # Generates unit files from elaboration log
    │   ├── aidlc-requirements-validator.json   # Validates requirements against units
    │   ├── aidlc-spec-elaborator.json          # Per-unit requirements elaboration
    │   └── aidlc-validator.json                # Cross-validates unit files
    ├── steering/
    │   ├── aidlc-sprint-planning.md            # Core workflow — CLI formatting, delegates to aidlc-workflow.md
    │   ├── aidlc-workflow.md                   # Execution rules and per-phase instructions (inclusion: manual)
    │   ├── aidlc-complexity-rubric.md          # Complexity assessment (inclusion: manual)
    │   ├── aidlc-decomposer.md                 # Unit generation rules (inclusion: manual)
    │   ├── aidlc-plan-generator.md             # Plan generation (inclusion: manual)
    │   ├── aidlc-requirements-validation.md    # Requirements validation (inclusion: manual)
    │   ├── aidlc-resume-protocol.md            # Session recovery (inclusion: manual)
    │   ├── aidlc-spec-handoff.md               # Spec creation and handoff (inclusion: manual)
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
cp -r AIDLC-Sprint-Planning-CLI/.kiro/ /path/to/your/project/.kiro/
```

Then run `kiro-cli chat` in that project directory.

---

## Implementation differences

| Capability | Power (Kiro IDE) | Skill (Generic) | CLI (Kiro CLI) |
|---|---|---|---|
| Entry point | `POWER.md` | `SKILL.md` | `aidlc-sprint-planning.md` (steering) |
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
├── common/                            # Single source of truth for all logic files
│   ├── workflow.md
│   ├── complexity-rubric.md
│   ├── decomposer.md
│   ├── plan-generator.md
│   ├── requirements-validation.md
│   ├── resume-protocol.md
│   ├── spec-handoff.md
│   ├── team-topology.md
│   ├── unit-format.md
│   ├── validator.md
│   └── templates/
│       ├── elaboration-log-template.md
│       ├── plan-template.md
│       ├── status-template.md
│       └── unit-template.md
│
├── AIDLC-Sprint-Planning-Power/       # Kiro IDE power implementation
├── AIDLC-Sprint-Planning-Skill/       # Generic skill implementation
├── AIDLC-Sprint-Planning-CLI/         # Kiro CLI implementation
│
├── scripts/
│   └── copy-common.sh                # Copies common/ into each implementation
│
└── .gitlab-ci.yml                     # Runs copy-common.sh then packages each artifact
```

### Editing logic files

All core logic lives in `common/`. The copied files in each package are generated
by `scripts/copy-common.sh` and are excluded from version control via `.gitignore`.
Never edit the generated files directly — they will be overwritten.

To update logic:

1. Edit the file in `common/`
2. Run `bash scripts/copy-common.sh all` to sync locally and verify output
3. Commit only the `common/` change

To update implementation-specific behavior:

- Power: edit `AIDLC-Sprint-Planning-Power/POWER.md`
- Skill: edit `AIDLC-Sprint-Planning-Skill/aidlc-sprint-planning/SKILL.md`
- CLI entry point: edit `AIDLC-Sprint-Planning-CLI/.kiro/steering/aidlc-sprint-planning.md`
- CLI terminal format: edit `AIDLC-Sprint-Planning-CLI/.kiro/steering/aidlc-terminal-format.md`
- CLI agents: edit files in `AIDLC-Sprint-Planning-CLI/.kiro/agents/`

To add a new frontmatter override for a CLI file (e.g., change `inclusion` or `priority`),
add a `case` entry in the `cli_frontmatter()` function in `scripts/copy-common.sh`.

---

## Keywords

`plan` · `decompose` · `elaborate` · `break down` · `scope` · `build` · `design` · `architect` · `specs` · `requirements` · `feature` · `project` · `discovery` · `prd` · `aidlc` · `mob elaboration` · `sprint planning` · `roadmap` · `breakdown` · `map out` · `outline` · `structure` · `strategy` · `approach` · `proposal` · `implement` · `create` · `develop` · `new feature` · `new app` · `new application` · `new service` · `new system` · `refactor` · `migrate` · `integrate` · `epic` · `milestone` · `mvp` · `where do i start` · `how do i approach` · `help me think` · `not sure how to`

## Learn more

- [Kiro Powers documentation](https://kiro.dev/docs/powers/)
- [Creating custom powers](https://kiro.dev/docs/powers/create/)
- [Installing powers](https://kiro.dev/docs/powers/installation/)
