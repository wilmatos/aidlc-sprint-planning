# AI-DLC Mob Elaboration — Kiro Power

A [Kiro Power](https://kiro.dev/docs/powers/) that facilitates structured feature planning through strategic questioning. It decomposes high-level intents into well-defined, independently implementable units ready for Kiro's Spec-Driven Development.

## What it does

When you want to plan, design, or break down a feature or project, this power guides you through a structured elaboration process:

1. Parses your intent and assesses complexity
2. Asks focused, one-at-a-time questions to clarify scope and decisions
3. Decomposes the elaborated intent into bounded implementation units (using EARS notation)
4. Validates units for completeness, dependency ordering, and coverage
5. Hands off each unit to Kiro's Spec mode for implementation

The process follows a state machine: `INIT → ASSESS → QUESTIONING → READY_CHECK → DECOMPOSE → VALIDATE → HANDOFF → COMPLETE`

## Power structure

```
aidlc-mob-elaboration/
├── POWER.md                          # Power definition and agent instructions
└── steering/
    ├── complexity-rubric.md          # Complexity assessment and question strategy
    ├── resume-protocol.md            # Session recovery and resume handling
    ├── spec-handoff.md               # Spec creation from units
    ├── state-machine.md              # Phase transitions and error recovery
    └── unit-format.md                # EARS notation and unit templates
```

## Installation

### From the Kiro Powers panel (recommended)

1. Open the Powers panel in Kiro (ghost icon with lightning bolt)
2. Click "Add Custom Power"
3. Select "Import Power from GitHub" and provide this repository URL
4. Confirm the installation

### From a local path

1. Download or clone this repository
2. Open the Powers panel in Kiro
3. Select "Add power from Local Path"
4. Point to the `aidlc-mob-elaboration` directory

### From the CI artifact

1. Download `aidlc-mob-elaboration.zip` from the latest pipeline artifacts
2. Extract the archive
3. In Kiro, open the Powers panel → "Add power from Local Path" → select the extracted `aidlc-mob-elaboration` folder

## Usage

Once installed, just mention planning-related keywords in chat — things like "plan", "decompose", "break down", "design", "architect", or "elaborate" — and Kiro will automatically activate the power.

On first activation, the power will walk you through onboarding: creating the required subagent files, steering file, and hook in your workspace.

## Keywords

`plan` · `decompose` · `elaborate` · `break down` · `scope` · `build` · `design` · `architect` · `specs` · `requirements` · `feature` · `project` · `discovery` · `prd` · `aidlc`

## Learn more

- [Kiro Powers documentation](https://kiro.dev/docs/powers/)
- [Creating custom powers](https://kiro.dev/docs/powers/create/)
- [Installing powers](https://kiro.dev/docs/powers/installation/)
