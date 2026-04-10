---
title: AIDLC Terminal Format Overrides
inclusion: always
priority: high
---

# Terminal Format Overrides

This file overrides the output format templates defined in the other steering files.
Those files were written for markdown-rendering environments. This is a plain terminal.

When any steering file specifies a markdown-formatted output template (tables with
pipes, emoji, bold/italic markers), use the plain-text equivalent below instead.

## General Rules

- Lines under 80 characters
- No emoji
- No markdown bold (**) or italic (_)
- No pipe-style markdown tables — use spaced columns or labeled lists
- Section headers: use === Title === or --- title --- instead of ## Heading
- Status indicators: OK, !, ?, [ ], [x] instead of checkmarks and emoji
- Use [1] [2] [3] for numbered choices presented to the user

## Requirements Validation Report

Replace the markdown coverage table with:

```
=== Requirements vs Unit Validation ===

Unit: {unit file name}

  Category             Unit Items  Covered  Missing  Status
  -------------------- ----------  -------  -------  ------
  User Stories         {N}         {N}      {N}      OK / !
  NFRs                 {N}         {N}      {N}      OK / !
  Risks                {N}         {N}      {N}      OK / !
  Elaboration Answers  {N}         {N}      {N}      OK / !

Missing items:
{list each missing item}

Scope additions (beyond unit file):
{list any, or "None"}

Verdict: {Full coverage - no gaps / Gaps found - review recommended}
```

## Spec Creation Offer

Replace the markdown table with:

```
=== Create Specifications? ===

For each unit I can generate three documents:

  requirements.md  Full requirements in EARS notation with acceptance criteria
  design.md        Architecture, data models, API contracts
  tasks.md         Task breakdown with checkpoints and validation steps

[1] Yes, all units in dependency order
[2] Yes, one at a time
[3] No, just the roadmap
```

## Unit Listing (Decompose / Handoff)

Replace markdown tables with:

```
  #   Unit Name             File                          Deps     Status
  --- --------------------- ----------------------------- -------- ----------
  1   {name}                aidlc/units/01-{name}.md      None     [ ] pending
  2   {name}                aidlc/units/02-{name}.md      Unit 1   [ ] pending
```

## Validation Report (Unit Validator)

```
=== Validation Report ===

  Check                     Status   Issues
  ------------------------- -------- ------
  Decision Coverage         OK       0
  Dependency Ordering       OK       0
  Functionality Gaps        !        2
  Bounded Context Integrity OK       0
  NFR Completeness          !        1

Findings:
{plain prose or bulleted list}

Recommendations:
{plain prose or bulleted list}

Verdict: {All checks passed / Issues found - review recommended}
```

## Session Status Summary

Replace markdown tables with labeled key-value output:

```
  Intent:             {short description}
  Complexity:         {rating}
  Current phase:      {phase}
  Questions asked:    {N}
  Questions answered: {N}
  Decisions:          {N}
  Units generated:    {N}
```

## Plan Document (aidlc/plan.md)

The plan document is written to disk — it does not need to be reproduced in the
terminal. When plan generation completes, print a brief summary:

```
=== Plan Generated: aidlc/plan.md ===

  Units:          {N}
  Execution waves: {N}
  Merge sequences: {N}
  Strategy:       {A-F} - {name}

Sections written:
  - Project summary
  - Unit catalogue ({N} units)
  - Dependency graph
  - Execution order and assignment
  - Branch and merge guide ({N} merges)
  - Merge conflict hotspots
  - Risk and coordination notes
  - Definition of done checklist
```

## Validation Report (with Plan Check)

```
=== Validation Report ===

  Check                     Status   Issues
  ------------------------- -------- ------
  Decision Coverage         OK / !   {N}
  Dependency Ordering       OK / !   {N}
  Functionality Gaps        OK / !   {N}
  Bounded Context Integrity OK / !   {N}
  NFR Completeness          OK / !   {N}
  Plan Consistency          OK / !   {N}

{findings if any}

Verdict: {All checks passed / Issues found - review recommended}
```
