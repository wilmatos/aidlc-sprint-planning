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

### Strategy A: Vertical Slices

**Use when:** Single full-stack team, demoable units, milestone-driven.

**Decompose:** Each unit = complete user-facing capability (UI + API + data). Order by user value. Shared infra = foundational unit.

**Example:**
```
01-foundation        (auth, DB schema, shared infra)
02-user-onboarding   (registration UI + API + email)
03-core-workflow     (main feature, full vertical slice)
04-reporting         (dashboard UI + query API)
```

### Strategy B: Horizontal Layers

**Use when:** Separate frontend/backend teams, parallel work, contract-first integration.

**Decompose:** Add a CONTRACT unit first (API shape, schemas, error codes, auth model). Backend implements contract. Frontend mocks contract, replaces mocks at integration. Integration unit closes streams.

**Contract unit contains:** API schema, request/response examples, error shapes, auth flow, pagination conventions, versioning strategy.

**Example:**
```
01-foundation        (shared infra, auth)
02-api-contract      (OpenAPI spec, shared types, error model)
03-backend-core      (implements contract endpoints)
04-frontend-core     (mocks contract, builds UI)
05-integration       (replace mocks with real API, E2E tests)
```

### Strategy C: Risk-First

**Use when:** High uncertainty in one or more areas, experimental integrations, unfamiliar technology.

**Decompose:** Isolate uncertain areas into spike units with time-box and clear question to answer. Spikes produce decisions + proof-of-concept, not production code. Remaining units planned after spike. Spikes are always unit 01 or 02.

**Example:**
```
01-spike-realtime    (validate WebSocket approach, time-boxed 3 days)
02-foundation        (built on validated approach from spike)
```

### Strategy D: Parallel Streams

**Use when:** Multiple developers/sub-teams, mix of independent and dependent units, maximize parallelism.

**Decompose:** Identify dependency graph. Group independent units into parallel streams. Add sync units at merge points. Number parallel units with lane suffix (02a, 02b).

**Example:**
```
01-foundation        (everyone depends on this)
02a-user-auth        (stream A)
02b-data-pipeline    (stream B, parallel with 02a)
03-integration       (sync point: merges A and B)
```

### Strategy E: Complexity-Calibrated

**Use when:** Mixed-complexity features, varying team experience, need to match unit size to capacity.

**Decompose:** Assess each area independently. Combine simple areas into larger units. Split complex areas into smaller units. Split any unit exceeding 2x target duration.

| Target duration | Max stories | Max tasks |
|----------------|------------|-----------|
| 2-3 days       | 3-4        | 5-8       |
| 1 week         | 5-8        | 8-15      |
| 2 weeks        | 8-12       | 15-25     |

### Strategy F: Domain-Team Alignment

**Use when:** Teams organized around business domains, each team owns a domain end-to-end, minimize cross-team coordination.

**Decompose:** Map units to team ownership boundaries. Each unit ownable by one team. Shared capabilities (auth, notifications, payments) become platform units. Cross-domain interactions = explicit contracts.

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
