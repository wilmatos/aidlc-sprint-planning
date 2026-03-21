# AgentDevAidlc — AI-DLC Mob Elaboration

Structured feature planning through strategic questioning. Decomposes high-level intents into well-defined, independently implementable units using the AI-DLC Methodology's mob elaboration approach.

This repository contains three implementations of the same workflow, each tailored to a different client:

| Implementation | Client | Format |
|---|---|---|
| [AgentDevAidlcPower](#agentdevaidlcpower) | Kiro (IDE) | `POWER.md` + `steering/` |
| [AgentDevAidlcSkill](#agentdevaidlcskill) | Generic / any agent | `SKILL.md` + `references/` |
| [AgentDevAidlcCLI](#agentdevaidlccli) | Kiro CLI | `.kiro/steering/` + `.kiro/agents/*.json` |

All three implement the same state machine and elaboration logic — they differ only in how they integrate with their target client. Core logic lives in `common/` and is copied into each implementation by the CI pipeline.

## What it does

1. Parses your intent and assesses complexity
2. Asks focused, one-at-a-time questions to clarify scope and decisions
3. Decomposes the elaborated intent into bounded implementation units (EARS notation)
4. Validates units for completeness, dependency ordering, and coverage
5. Hands off each unit for implementation — optionally generating `requirements.md`, `design.md`, and `tasks.md` for each

State machine: `INIT → ASSESS → QUESTIONING → READY_CHECK → DECOMPOSE → VALIDATE → HANDOFF → COMPLETE`

## Implementations

### AgentDevAidlcPower

## Repository Structure

```
/
├── common/                        # Single source of truth for all logic files
│   ├── complexity-rubric.md
│   ├── state-machine.md
│   ├── resume-protocol.md
│   ├── unit-format.md
│   ├── decomposer.md
│   ├── validator.md
│   ├── spec-handoff.md
│   ├── requirements-validation.md
│   └── templates/
│       ├── elaboration-log-template.md
│       ├── status-template.md
│       └── unit-template.md
│
├── AgentDevAidlcPower/            # Kiro Power implementation
│   ├── POWER.md                   # Entry point + onboarding (implementation-specific)
│   └── steering/                  # Populated from common/ by CI
│
├── AgentDevAidlcSkill/            # Generic Skill implementation
│   └── aidlc-mob-elaboration/
│       ├── SKILL.md               # Entry point (implementation-specific)
│       ├── assets/                # Templates — populated from common/templates/ by CI
│       └── references/            # Populated from common/ by CI (no frontmatter)
│
├── AgentDevAidlcCLI/              # Kiro CLI implementation
│   └── .kiro/
│       ├── agents/                # JSON agent definitions (implementation-specific)
│       ├── steering/              # Populated from common/ by CI (with frontmatter)
│       └── templates/             # Populated from common/templates/ by CI
│
├── scripts/
│   └── copy-common.sh             # Copies common/ into each implementation
│
└── .gitlab-ci.yml                 # Runs copy-common.sh then packages each artifact
```

### Editing Logic Files

All core logic lives in `common/`. **Never edit the copied files directly** — they
will be overwritten by the next CI run or `scripts/copy-common.sh` invocation.

To update logic:
1. Edit the file in `common/`
2. Run `bash scripts/copy-common.sh all` to sync locally
3. Commit both the `common/` change and the synced copies

To update implementation-specific behavior:
- Power: edit `AgentDevAidlcPower/POWER.md`
- Skill: edit `AgentDevAidlcSkill/aidlc-mob-elaboration/SKILL.md`
- CLI: edit `AgentDevAidlcCLI/.kiro/steering/aidlc-mob-elaboration.md` or the agent JSON files



A [Kiro Power](https://kiro.dev/docs/powers/) — the native extension format for Kiro IDE.

- Uses `POWER.md` as the entry point with `steering/` files for sub-concerns
- Supports Kiro-specific features: `.kiro/` folder, hooks, subagent `.md` files, and steering files placed in Kiro-specific locations
- On first activation, onboards the workspace by creating subagent files, steering files, and hooks

```
AgentDevAidlcPower/
├── POWER.md
└── steering/
    ├── complexity-rubric.md
    ├── requirements-validation.md
    ├── resume-protocol.md
    ├── spec-handoff.md
    ├── state-machine.md
    └── unit-format.md
```

#### Installation

- **Kiro Powers panel (recommended):** Add Custom Power → Import from GitHub → provide this repo URL
- **Local path:** Add power from Local Path → point to the `AgentDevAidlcPower` directory
- **CI artifact:** Download `aidlc-mob-elaboration.zip` from pipeline artifacts, extract, and import via Local Path

### AgentDevAidlcSkill

A generic Skill — client-agnostic, no file copying to client-specific folders.

- Uses `SKILL.md` as the entry point with `references/` for sub-concerns and `assets/` for templates
- Follows the standard skills definition format — no assumptions about the host client's folder structure
- Does not create hooks or copy files into client-specific directories

```
AgentDevAidlcSkill/
└── aidlc-mob-elaboration/
    ├── SKILL.md
    ├── assets/
    │   ├── elaboration-log-template.md
    │   ├── status-template.md
    │   └── unit-template.md
    └── references/
        ├── complexity-rubric.md
        ├── decomposer.md
        ├── requirements-validation.md
        ├── resume-protocol.md
        ├── spec-handoff.md
        ├── state-machine.md
        ├── unit-format.md
        └── validator.md
```

### AgentDevAidlcCLI

A configuration package for [Kiro CLI](https://kiro.dev/docs/cli/).

- Uses `.kiro/steering/` markdown files (with `inclusion` metadata) and `.kiro/agents/*.json` for subagents
- Kiro CLI has `.kiro/` folders like Kiro IDE but agents use `.json` format instead of `.md`
- Does **not** support hooks

```
AgentDevAidlcCLI/
├── README.md
└── .kiro/
    ├── agents/
    │   ├── aidlc-decomposer.json
    │   ├── aidlc-requirements-validator.json
    │   ├── aidlc-spec-elaborator.json
    │   └── aidlc-validator.json
    ├── steering/
    │   ├── aidlc-mob-elaboration.md        # inclusion: always
    │   ├── aidlc-complexity-rubric.md      # inclusion: manual
    │   ├── aidlc-decomposer.md
    │   ├── aidlc-requirements-validation.md
    │   ├── aidlc-resume-protocol.md
    │   ├── aidlc-spec-handoff.md
    │   ├── aidlc-state-machine.md
    │   ├── aidlc-unit-format.md
    │   └── aidlc-validator.md
    └── templates/
        ├── elaboration-log-template.md
        ├── status-template.md
        └── unit-template.md
```

#### Installation

Copy the `.kiro/` directory into your project root:

```bash
cp -r AgentDevAidlcCLI/.kiro/ /path/to/your/project/.kiro/
```

Then run `kiro-cli chat` in that project directory.

## Implementation differences

| Capability | Power (Kiro IDE) | Skill (Generic) | CLI (Kiro CLI) |
|---|---|---|---|
| Entry point | `POWER.md` | `SKILL.md` | `aidlc-mob-elaboration.md` (steering) |
| Sub-concern files | `steering/*.md` | `references/*.md` | `.kiro/steering/*.md` |
| Agent/subagent format | `.md` (Kiro subagents) | N/A | `.json` |
| Hooks support | ✅ | N/A | ❌ |
| File copying on install | ✅ (onboarding) | ❌ | Manual `cp` |
| Templates | Embedded in POWER.md | `assets/` | `.kiro/templates/` |
| Activation | Keyword-triggered | Client-dependent | `inclusion: always` on main steering file |

## Keywords

`plan` · `decompose` · `elaborate` · `break down` · `scope` · `build` · `design` · `architect` · `specs` · `requirements` · `feature` · `project` · `discovery` · `prd` · `aidlc`

## Learn more

- [Kiro Powers documentation](https://kiro.dev/docs/powers/)
- [Creating custom powers](https://kiro.dev/docs/powers/create/)
- [Installing powers](https://kiro.dev/docs/powers/installation/)
