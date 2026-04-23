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
2. **`design.md`** — Technical design document
3. **`tasks.md`** — Implementation task breakdown with checkpoints

See the handoff reference for detailed instructions on each document.
