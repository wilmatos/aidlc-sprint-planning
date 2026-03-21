# Plan Generator

Instructions for generating `aidlc/plan.md` after all unit files have been written.

## When to Run

After all unit files exist in `aidlc/units/` and before transitioning to VALIDATE.
The plan is generated as the final step of the DECOMPOSE phase.

## Input

- All unit files from `aidlc/units/`
- `aidlc/elaboration-log.md` (for the Team Topology profile and key decisions)
- `aidlc/status.md`

## Output

Write `aidlc/plan.md` — a single document that serves as the team's execution guide.

## Document Structure

### 1. Project Summary

One paragraph describing the overall intent, the complexity rating, and the
decomposition strategy chosen. Written for a developer who wasn't in the
elaboration session.

### 2. Unit Catalogue

For each unit, a concise summary block:

```markdown
#### Unit {N}: {Name}
**File:** `aidlc/units/NN-name.md`
**Branch:** `feature/NN-name` (suggested)
**Description:** {one sentence from the unit's Description field}
**Key deliverables:** {2-4 bullet points — what is tangibly done when this unit is complete}
**Dependencies:** {unit numbers and names, or "None — can start immediately"}
**Suggested assignee:** {role or team, e.g., "backend developer", "frontend team", "any"}
**Estimated duration:** {from topology profile target, or "unknown"}
**Demo checkpoint:** {what can be shown/verified at the end of this unit}
```

### 3. Dependency Graph

A plain-text representation of the dependency DAG. Use indentation to show
what blocks what:

```
Unit 01 (foundation)
├── Unit 02 (user-auth)          ← depends on 01
│   └── Unit 04 (profile)        ← depends on 02
└── Unit 03 (data-pipeline)      ← depends on 01, parallel with 02
    └── Unit 05 (reporting)      ← depends on 03
Unit 06 (integration)            ← depends on 02, 03
```

If parallel streams exist (Strategy B or D), show them as lanes:

```
Stream A (backend team)     Stream B (frontend team)
───────────────────────     ────────────────────────
01-foundation               01-foundation
02-api-contract             02-api-contract
03-backend-core             04-frontend-core (mocks contract)
                            ↓
              05-integration (both streams merge here)
```

### 4. Execution Order and Assignment

A table showing the recommended execution sequence, who should do it, and
whether it can run in parallel with other units:

```markdown
| Wave | Unit | Assignee | Parallel With | Gate Before Starting |
|------|------|----------|---------------|----------------------|
| 1 | 01-foundation | {role} | — | Nothing — start here |
| 2 | 02-user-auth | {role} | 03-data-pipeline | Unit 01 merged to main |
| 2 | 03-data-pipeline | {role} | 02-user-auth | Unit 01 merged to main |
| 3 | 04-profile | {role} | — | Unit 02 merged to main |
| 4 | 05-integration | {role} | — | Units 02 + 03 merged to main |
```

"Wave" groups units that can be worked simultaneously. Units in the same wave
have no mutual dependencies.

### 5. Branch and Merge Guide

#### Branch Naming

Suggest a branch name for each unit:
- `feature/01-foundation`
- `feature/02-user-auth`
- For parallel streams: `feature/03a-backend-core`, `feature/03b-frontend-core`

#### Merge Order

List the exact merge sequence with the responsible party and any prerequisites:

```markdown
**Merge 1: Unit 01 → main**
- Who merges: {role or "any team lead"}
- Prerequisite: Unit 01 complete, all tests pass, code reviewed
- Unblocks: Units 02 and 03 (both teams can branch from main after this)
- Notes: {any special instructions, e.g., "run DB migrations after merge"}

**Merge 2a: Unit 02 → main** (parallel with Merge 2b)
- Who merges: {role}
- Prerequisite: Unit 01 merged, Unit 02 complete and reviewed
- Unblocks: Unit 04
- Notes: {e.g., "backend team merges independently of frontend"}

**Merge 2b: Unit 03 → main** (parallel with Merge 2a)
- Who merges: {role}
- Prerequisite: Unit 01 merged, Unit 03 complete and reviewed
- Unblocks: Unit 05
- Notes: {any notes}

...and so on for each unit.
```

#### Merge Conflict Hotspots

Identify files or areas likely to cause merge conflicts based on the unit
boundaries and dependencies:

- Shared configuration files (e.g., `package.json`, `schema.prisma`, `routes.ts`)
- Foundation files touched by multiple units
- Contract files (if Strategy B — both streams reference the contract)

For each hotspot, note which units touch it and who should own conflict resolution.

#### Integration Unit Merges (Strategy B/D)

If an integration unit exists, describe the merge ceremony:

1. Ensure all upstream branches are merged to main first
2. Create the integration branch from main (not from any feature branch)
3. Run the full test suite — mock replacements are the primary risk here
4. The integration unit owner coordinates with both stream owners for conflict resolution
5. After integration merge, tag the release candidate

### 6. Risk and Coordination Notes

List cross-unit risks that the team should watch for:

- **Shared schema changes:** If Unit 02 and Unit 03 both modify the DB schema,
  coordinate migrations to avoid conflicts
- **Contract drift:** If using Strategy B, any change to the contract unit after
  parallel work has started requires both stream owners to update their implementations
- **Spike outcomes:** If a spike unit (Strategy C) changes the approach, downstream
  units may need to be re-scoped before work begins
- **Long-running units:** If a unit is estimated to take significantly longer than
  others, flag it as a potential bottleneck and suggest splitting or pairing

### 7. Definition of Done

A checklist that applies to every unit before it can be merged:

```markdown
## Definition of Done — All Units

- [ ] All user stories from the unit file are implemented
- [ ] All NFRs from the unit file are met (with evidence)
- [ ] Unit tests written and passing
- [ ] Code reviewed by at least one other developer
- [ ] No regressions in dependent units (run integration tests if available)
- [ ] Branch rebased on latest main before merge
- [ ] Demo checkpoint verified (something runnable/showable)
- [ ] `aidlc/status.md` updated to reflect unit completion
```

Add unit-specific additions where relevant (e.g., "contract validated against
both backend and frontend implementations" for Strategy B integration units).

## Writing Guidelines

- Write for a developer who wasn't in the elaboration session
- Be specific about who does what — use role names from the topology profile
- If the topology profile didn't specify roles, use generic labels:
  "Developer A", "Backend team", "Frontend team"
- Flag assumptions explicitly: "Assuming one developer per unit based on team size"
- Keep the dependency graph and merge order as the most prominent sections —
  these are what the team will reference daily
- If the team is small (1-2 developers), simplify: skip the wave table and just
  list units in order with a note about which can overlap

## After Writing

Update `aidlc/status.md` to note that `plan.md` has been generated.
Append a note to `aidlc/elaboration-log.md`:

```markdown
## Plan Generated
`aidlc/plan.md` written. {N} units, {N} merge sequences, strategy {X}.
```
