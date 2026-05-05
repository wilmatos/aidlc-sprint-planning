# Implementation Plan: {Project / Intent Name}

**Generated:** {date}
**Complexity:** {Lightweight / Standard / Comprehensive}
**Strategy:** {Strategy A–F} — {strategy name}
**Team:** {team description from topology profile}
**Target unit duration:** {from topology profile}

---

## Project Summary

{One paragraph: what is being built, why it was decomposed this way, and what
the team should know before starting. Written for a developer who wasn't in the
mob elaboration session.}

---

## Unit Catalogue

{Repeat the following block for each unit}

### Unit {N}: {Name}

**File:** `aidlc/units/NN-{name}.md`
**Branch:** `feature/NN-{name}`
**Description:** {one sentence}
**Key deliverables:**

- {what is tangibly done when this unit is complete}
- {another deliverable}

**Dependencies:** {unit numbers and names, or "None — can start immediately"}
**Suggested assignee:** {role or team}
**Estimated duration:** {from topology profile target}
**Demo checkpoint:** {what can be shown or verified at the end of this unit}

---

## Dependency Graph

```
{plain-text DAG — use indentation and arrows to show what blocks what}

Unit 01 ({name})
├── Unit 02 ({name})   ← depends on 01
│   └── Unit 04 ({name})   ← depends on 02
└── Unit 03 ({name})   ← depends on 01, parallel with 02
```

{For parallel streams (Strategy B/D), show as lanes:}

```
Stream A ({team})           Stream B ({team})
─────────────────────────   ─────────────────────────
01-foundation               01-foundation
02-api-contract             02-api-contract
03-backend-core             04-frontend-core
                ↓
    05-integration (streams merge here)
```

---

## Execution Order and Assignment

| Wave | Unit | Assignee | Parallel With | Gate Before Starting |
|------|------|----------|---------------|----------------------|
| 1 | {unit} | {role} | — | Nothing — start here |
| 2 | {unit} | {role} | {unit} | Unit {N} merged to main |

*Units in the same wave have no mutual dependencies and can be worked simultaneously.*

---

## Branch and Merge Guide

### Branch Naming

| Unit | Suggested Branch |
|------|-----------------|
| {N} — {name} | `feature/NN-{name}` |

### Merge Sequence

{Repeat for each merge}

**Merge {N}: Unit {NN} → main**

- Who merges: {role}
- Prerequisite: {what must be true before this merge}
- Unblocks: {which units can start after this}
- Notes: {any special steps, e.g., run migrations, update contract consumers}

---

### Merge Conflict Hotspots

| File / Area | Touched By | Owner for Conflict Resolution |
|-------------|-----------|-------------------------------|
| {file} | Units {N}, {M} | {role} |

---

## Risk and Coordination Notes

- **{Risk name}:** {description and mitigation}
- **{Risk name}:** {description and mitigation}

---

## Definition of Done

Applies to every unit before it can be merged to main:

- [ ] All user stories from the unit file are implemented
- [ ] All NFRs from the unit file are met (with evidence)
- [ ] Unit tests written and passing
- [ ] Code reviewed by at least one other developer
- [ ] No regressions in dependent units
- [ ] Branch rebased on latest main before merge
- [ ] Demo checkpoint verified
- [ ] `aidlc/status.md` updated to reflect unit completion

{Add unit-specific items here if needed}
