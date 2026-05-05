# Unit File Format Reference

## File Naming

Units are numbered with a two-digit prefix for build order, followed by kebab-case:

- `01-user-identity.md`
- `02-game-core.md`
- `03-real-time-sync.md`

Sequence so dependencies are built before dependents.

### Sanitization Rules

When deriving filenames from user intent or unit names:

1. Convert to lowercase
2. Replace spaces and underscores with hyphens
3. Strip all characters except `a-z`, `0-9`, and `-`
4. Collapse consecutive hyphens into one
5. Truncate to 40 characters (excluding the `NN-` prefix and `.md` extension)
6. Reject names that start with `.` or contain `..`

Example: "User Authentication & OAuth 2.0!" → `01-user-authentication-oauth-20.md`

## EARS Notation for User Stories

| Pattern | Template | When to Use |
|---------|----------|-------------|
| Event-driven | WHEN {event} THE SYSTEM SHALL {behavior} | Something triggers a response |
| State-driven | WHILE {state} THE SYSTEM SHALL {behavior} | Ongoing behavior during a condition |
| Unwanted | IF {condition} THEN THE SYSTEM SHALL {behavior} | Error handling, edge cases |
| Optional | WHERE {feature} THE SYSTEM SHALL {behavior} | Configurable features |
| Ubiquitous | THE SYSTEM SHALL {behavior} | Always-on requirements |

## Unit Template

```markdown
# Unit: {Name}

**Description:** {What this unit does — one paragraph}

**Bounded Context Rationale:** {Why this is a separate unit — what makes it a distinct
bounded context with its own data ownership, change frequency, or scaling needs}

**User Stories:**
- WHEN {condition} THE SYSTEM SHALL {behavior}
- IF {error condition} THEN THE SYSTEM SHALL {recovery behavior}

**NFRs:**
- {Requirement with measurable target, e.g., "Response latency: < 500ms"}

**Risks:**
- {Risk description} — mitigate with {mitigation strategy}

**Dependencies:** {Other units by number and name, or "None (foundational unit)"}

**Suggested Bolts:**
- Bolt 1: {Scope — a logical chunk of implementation work within this unit}

> A "Bolt" is a logical sub-chunk of work within the unit — a grouping of related
> tasks that can be reviewed or merged independently. Bolts are not separate units;
> they are implementation checkpoints within one unit. Use them to break large units
> into reviewable increments without splitting the bounded context.

## Implementation Reference

> ⚠️ **This section applies only after all units are defined, validated, and
> the HANDOFF phase is reached.** Ignore this section during decomposition.

When ready to implement this unit, create three implementation documents:

1. **`requirements.md`** — Full requirements using EARS notation
   - Map every user story from this unit to at least one requirement
   - Add testable acceptance criteria (specific, measurable, clear pass/fail)
   - Include NFRs with measurable targets
   - Address risks with defensive requirements
   - Scope only what this unit file defines

2. **`design.md`** — Technical design document
   - Architecture decisions and component breakdown
   - Data models and API contracts
   - Integration points with dependent units
   - Key technical risks and mitigations

3. **`tasks.md`** — Implementation task breakdown
   - Decompose the unit into concrete, independently executable tasks
   - Each task should have: clear scope, acceptance criteria, and validation checkpoint
   - Order tasks by dependency
   - Flag tasks that can be parallelized
   - Include a checkpoint after each logical group of tasks
```

## Bolts

A "Bolt" is a logical sub-chunk of implementation work within a unit — a grouping
of related tasks that can be reviewed or merged independently. Bolts are not separate
units; they are checkpoints within one bounded context. Use them to break large units
into reviewable increments.

## Scaling Detail by Depth

### Lightweight Units

- 2-3 user stories (happy path only)
- Brief NFRs (1-2 lines)
- Key risks listed without detailed mitigations
- 1-2 suggested bolts

### Standard Units

- 4-8 user stories (happy path + key error cases)
- NFRs with measurable targets
- Risks with mitigation strategies
- 2-4 suggested bolts

### Comprehensive Units

- Full user stories (happy path + edge cases + error handling)
- Detailed NFR targets with measurement methods
- Risk register with likelihood/impact/mitigation
- 3-6 suggested bolts with clear scope boundaries

## Decomposition Principles

1. **Each unit is a bounded context.** It owns its data and has clear interfaces.
2. **Prefer fewer, larger units.** Justify every split.
3. **Minimize dependencies.** Units should be implementable as independently as possible.
4. **Order by dependency.** Unit 01 has no dependencies.
5. **No circular dependencies.** If A depends on B and B on A, they're one unit.
6. **Cross-cutting concerns are units too.** Auth, observability get their own units if substantial.
