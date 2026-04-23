# Team Topology Assessment

## Purpose

Before decomposing into units, understand how the work will actually be executed.
Team structure, size, and working style directly determine the right unit boundaries.
A unit that makes perfect sense as a bounded context may be the wrong size or shape
for the team that will build it.

This phase runs after READY_CHECK and before DECOMPOSE.

## Entry

User confirmed readiness to decompose. Before generating units, run this assessment.

## Questions to Ask

Ask these questions one at a time, in order. Skip any that the user's previous
answers have already resolved. Stop when you have enough to select a decomposition
strategy — you don't need all answers if the picture is clear.

### Q1: Team Size and Structure

> How many developers will be working on this? And are they organized as a single
> full-stack team, or split into specializations (e.g., frontend / backend / mobile /
> data / infra)?

This is the most important question. The answer determines which decomposition
strategies are even applicable.

### Q2: Unit Delivery Expectation

> What should be deliverable at the end of each unit — a complete demoable slice of
> functionality, or a layer/component that feeds into a later integration?

This distinguishes vertical-slice teams (demo at end of each unit) from
horizontal-layer teams (frontend and backend built in parallel, integrated later).

### Q3: Parallel Work Appetite

> Do you want units that can be worked on simultaneously by different developers or
> sub-teams, or do you prefer a sequential build where each unit is fully complete
> before the next begins?

Parallel work requires explicit contracts between units. Sequential work allows
looser interfaces but creates a critical path.

### Q4: Unit Size Preference

> Roughly how long should a single unit take to implement? A few days, a sprint
> (1-2 weeks), or longer?

This calibrates granularity. A 3-day unit and a 2-week unit have very different
decomposition shapes even for the same feature set.

### Q5: Integration and Contract Approach (if parallel or split teams)

> If frontend and backend are being built in parallel, how do you want to handle
> the integration point? Options:
> 1. Define a contract unit first — both sides implement against it independently,
>    then integrate
> 2. Backend-first — frontend waits for working API endpoints
> 3. Mock-first — frontend mocks the API, backend implements the same contract,
>    mocks are replaced at integration

Only ask this if Q1 or Q2 revealed split teams or parallel work.

### Q6: Complexity Tolerance per Unit

> Are developers comfortable picking up a unit that spans multiple concerns
> (e.g., auth + data model + API + UI), or do you prefer units scoped to a
> single concern even if that means more coordination overhead?

This reveals whether the team prefers depth-first (one concern at a time) or
breadth-first (full vertical slices) execution.

### Q7: Risk and Unknowns

> Are there parts of this system where the approach is uncertain or experimental?
> If so, should those be isolated into their own units so the risk is contained?

Spike units or proof-of-concept units should be identified early so they don't
block the rest of the roadmap.

## Decomposition Strategies

Based on the answers, select one or more strategies. Record the selected strategy
in the elaboration log under `## Team Topology` before generating units.

| Strategy | Name | Use when |
|----------|------|----------|
| A | Vertical Slices | Single full-stack team, demoable units |
| B | Horizontal Layers | Separate frontend/backend teams, contract-first |
| C | Risk-First | High uncertainty, spike needed |
| D | Parallel Streams | Multiple sub-teams, maximize parallelism |
| E | Complexity-Calibrated | Mixed complexity, match unit size to capacity |
| F | Domain-Team Alignment | Teams organized by business domain |

Each strategy is defined in its own reference file (strategy-a through strategy-f).
Read the selected strategy file before generating units.

## Topology Profile

After completing the assessment, record a topology profile in the elaboration log:

```markdown
## Team Topology

**Team structure:** {e.g., "2 full-stack developers", "frontend team (3) + backend team (2)"}
**Unit delivery expectation:** {e.g., "demoable vertical slices", "horizontal layers with integration"}
**Parallel work:** {e.g., "sequential", "parallel streams A and B"}
**Target unit duration:** {e.g., "1 sprint (2 weeks)"}
**Integration approach:** {e.g., "contract-first, mock-then-replace"}
**Risk areas:** {e.g., "real-time sync is uncertain — spike unit needed"}
**Selected strategy:** {Strategy A / B / C / D / E / F or combination}
**Decomposition notes:** {any additional constraints or preferences}
```

## Decomposer Instructions

When generating units, read the `## Team Topology` section of the elaboration log
and apply the selected strategy:

- **Strategy A:** Each unit is a full vertical slice. Order by user value.
- **Strategy B:** Add a contract unit. Split into backend and frontend streams.
  Frontend units include mock setup. Integration unit closes the streams.
- **Strategy C:** Spike units come first. Remaining units planned after spike.
- **Strategy D:** Identify parallel streams. Add sync units at merge points.
- **Strategy E:** Size each unit to the target duration. Split oversized areas.
- **Strategy F:** Map units to team ownership. Minimize cross-unit dependencies.

If no topology profile exists in the log, default to Strategy A (vertical slices)
and note the assumption in the decomposition summary.

## Log Format

Append to `aidlc/elaboration-log.md` after each topology question:

```markdown
## Team Topology Question: {Short Title}

{question text}

## Phase: TEAM_TOPOLOGY

**Answer:** {user's answer}
```

After all questions are answered, append the full topology profile block.
