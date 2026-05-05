# Unit Decomposer

Instructions for generating implementation unit files from a completed mob elaboration
session during sprint planning.

## Input

Read the full content of `aidlc/elaboration-log.md` and `aidlc/status.md`.

## Output Boundary

Write only to the `aidlc/` directory. All generated files must resolve within
`aidlc/units/`, `aidlc/plan.md`, or `aidlc/status.md`. Reject any path that
resolves outside `aidlc/`.

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
6. After writing all unit files, generate `aidlc/plan.md` using the plan-generator
   reference and the plan template.
7. After writing units and plan, update `aidlc/status.md` and append a decomposition
   summary to `aidlc/elaboration-log.md`.

## Applying Team Topology

Before generating units, read the `## Team Topology` section of the elaboration log.
Apply the selected strategy when determining unit boundaries, ordering, and naming.

- **Strategy A (Vertical Slices):** Each unit is a full vertical slice ordered by
  user value. Foundation unit first, then demoable capabilities.

- **Strategy B (Horizontal Layers):** Add a contract unit before parallel streams.
  Frontend units include mock setup instructions. Add an integration unit to close streams.

- **Strategy C (Risk-First):** Spike units come first with explicit time-boxes and
  a clear question to answer. Remaining units are planned after the spike.

- **Strategy D (Parallel Streams):** Identify independent streams. Number parallel
  units with a lane suffix (e.g., 02a, 02b). Add sync units at merge points.

- **Strategy E (Complexity-Calibrated):** Size each unit to the target duration from
  the topology profile. Split any area that would exceed 2x the target.

- **Strategy F (Domain-Team Alignment):** Map units to team ownership boundaries.
  Minimize cross-unit dependencies. Shared capabilities become platform units.

If no `## Team Topology` section exists in the log, default to Strategy A and note
the assumption in the decomposition summary.

## Scale Detail by Depth

- Lightweight: 2-3 stories, brief NFRs, key risks
- Standard: 4-8 stories, NFRs with targets, risks with mitigations
- Comprehensive: Full stories with edge cases, detailed NFRs, risk register

See the unit-format reference for the full unit template.
See the plan-generator reference for instructions on writing `aidlc/plan.md`.
