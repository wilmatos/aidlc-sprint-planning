# Unit File Format Reference

## File Naming

Units are numbered with a two-digit prefix for build order, followed by kebab-case:
- `01-user-identity.md`
- `02-game-core.md`
- `03-real-time-sync.md`

Sequence so dependencies are built before dependents.

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

## Spec Reference

> ⚠️ **Do not act on this section until all units are defined and validated.**

To implement this unit as a Kiro spec (after HANDOFF):
1. Switch to **Spec mode** in Kiro
2. Start a new spec and reference this file: `#aidlc/units/{filename}`
3. Also reference the elaboration log: `#aidlc/elaboration-log.md`
4. The steering file will guide elaboration-informed requirements generation
```

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
