# Unit Decomposer

Instructions for generating implementation unit files from a completed mob elaboration
session during sprint planning.

## Input

Read the full content of `aidlc/sprints/{sprint}/elaboration-log.md` and `aidlc/sprints/{sprint}/status.md`.

## Output Boundary

Write only to the active sprint folder, `aidlc/sprints/{sprint}/`. All generated
files must resolve within `aidlc/sprints/{sprint}/units/`,
`aidlc/sprints/{sprint}/plan.md`, or `aidlc/sprints/{sprint}/status.md`. Reject any
path that resolves outside `aidlc/sprints/{sprint}/`.

## Output

Write numbered unit files to `aidlc/sprints/{sprint}/units/` using EARS notation for user stories.
Each file uses a two-digit prefix for build order (e.g., `01-user-identity.md`).
Sequence units so dependencies are built before dependents.

## Rules

1. Every user decision must appear in at least one unit.
2. Use EARS notation: WHEN/IF/WHILE/THE SYSTEM SHALL patterns.
3. Number files for dependency order. Unit 01 has no dependencies.
4. Prefer fewer, larger units. Justify every split with bounded context rationale.
5. Only include what the user asked for.
6. After writing all unit files, generate `aidlc/sprints/{sprint}/plan.md` using the plan-generator
   reference and the plan template.
7. After writing units and plan, update `aidlc/sprints/{sprint}/status.md` and append a decomposition
   summary to `aidlc/sprints/{sprint}/elaboration-log.md`.

## Applying Team Topology

Before generating units, read the `## Team Topology` section of the elaboration log.
Identify the selected strategy (A–F), then read the corresponding strategy file
(e.g., `strategy-a-vertical-slices.md`) and follow its decomposition rules for
determining unit boundaries, ordering, and naming.

If no `## Team Topology` section exists in the log, default to Strategy A (read
`strategy-a-vertical-slices.md`) and note the assumption in the decomposition summary.

## Scale Detail by Depth

- Lightweight: 2-3 stories, brief NFRs, key risks
- Standard: 4-8 stories, NFRs with targets, risks with mitigations
- Comprehensive: Full stories with edge cases, detailed NFRs, risk register

See the unit-format reference for the full unit template.
See the plan-generator reference for instructions on writing `aidlc/sprints/{sprint}/plan.md`.
