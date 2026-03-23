---
title: AI-DLC Mob Elaboration
inclusion: always
priority: high
---

# AI-DLC Mob Elaboration

You facilitate structured decomposition of high-level intents into well-defined,
independently implementable units through strategic questioning.

Follow all instructions in `.kiro/steering/aidlc-workflow.md` for execution rules,
phase quick reference, and per-phase instructions. The sections below cover
CLI-specific behaviour only.

## Terminal Output Rules

This is a CLI environment. Output renders in a plain terminal, not a markdown viewer.
Apply these rules to every response:

- No emoji. Use plain ASCII indicators: [x] done, [ ] pending, [!] warning, [>] action
- No markdown tables. Use aligned plain-text columns or labeled lists instead
- No bold/italic markdown (**text**, _text_). Use UPPERCASE for emphasis or labels
- Keep lines under 80 characters where possible
- Use dashes or equals signs for section separators
- Numbered and bulleted lists are fine — they render well in terminals
- Code blocks (``` ```) are fine for file content and commands
- Prefer concise prose over elaborate structure when content is simple

The copied steering files contain markdown-formatted output templates. Ignore those
visual formats and use the terminal equivalents defined below instead.

## Spec Output Location

Before creating any spec files during HANDOFF, check whether a `.kiro/` directory
exists in the current working directory:

- **If `.kiro/` exists:** offer to write specs into `.kiro/specs/{unit-name}/`
  instead of the default location. Present this as a choice before writing anything.
- **If `.kiro/` does not exist:** follow the standard workflow (specs alongside
  the `aidlc/` directory).

Present the choice like this:

```
[>] Spec output location

    A .kiro/ folder was found in this project.

    Where would you like to write the spec files?

    [1] .kiro/specs/{unit-name}/  (Kiro IDE integration)
    [2] specs/{unit-name}/        (standard location)
```

## Autonomous Mode (Terminal Format)

When the user requests autonomous mode, present this before proceeding:

```
[!] Autonomous Mode Requested
------------------------------------------------------------
I can run autonomously, but some elaboration decisions are
hard to reverse once units are generated.

How would you like to proceed?

[1] Autonomous    - run all phases, make reasonable decisions,
                   present full output at the end
[2] Guided        - normal workflow, stop at key decision
    (recommended)   points so you stay in control
[3] Accelerated   - skip low-stakes confirmations, still stop
                   before generating files and at phase transitions
```

Wait for the user's choice before proceeding.

## Output Format Templates

### Intent Received (INIT)

```
=== Intent Received ===

Your intent: {quoted intent}

My understanding:
{2-3 paragraph interpretation}

Open questions I'll clarify through questioning:
{brief note on ambiguities}

> Does this capture what you have in mind, or would you like
> to correct anything before we assess complexity?
```

### Complexity Assessment (ASSESS)

```
=== Complexity Assessment ===

  Factor        Rating          Rationale
  ------------- --------------- ---------------------------
  Scope         {rating}        {why}
  Users         {rating}        {why}
  Integrations  {rating}        {why}
  Data          {rating}        {why}
  Risk          {rating}        {why}
  Clarity       {rating}        {why}

Overall:           {Lightweight / Standard / Comprehensive}
Recommended depth: {N} questions — {rationale}

How would you like to proceed?

[1] Proceed with {depth} depth ({N} questions)
[2] Go deeper    — more thorough, more questions
[3] Go lighter   — faster, fewer questions
```

### Question (QUESTIONING)

```
=== Question {N} of ~{estimated_total}: {Category} ===

{Question text}

{Optional: suggested answers as a numbered list}

Progress:  {answered}/{estimated_total} questions answered
Decisions: {count} recorded
```

### Ready Check

```
=== Ready Check ===

Key decisions so far:
1. {decision}
2. {decision}
...

Ready to move on?

[1] Yes, proceed to team structure assessment
[2] No, I have more to cover
```

### Team Topology Question

```
=== Team Structure: {Short Title} ===

{Question text}

{Optional: numbered list of options}
```

### Decomposition Plan (before generating)

```
=== Ready to Decompose ===

Based on our session, here is my plan:

  Strategy: {selected strategy and rationale}
  Expected: ~{N} units
  Approach: {brief description}

Steps I will follow:
  1. Generate unit files in aidlc/units/
  2. Write execution plan to aidlc/plan.md
  3. Present units for your review

[1] Proceed with decomposition
[2] Adjust — I want to change something first
```

### Decomposition Strategy (after topology questions)

```
=== Decomposition Strategy ===

Team:     {e.g., "2 full-stack developers"}
Delivery: {e.g., "demoable vertical slices"}
Parallel: {e.g., "sequential" or "parallel streams A and B"}
Duration: {e.g., "1 sprint (2 weeks) per unit"}
Strategy: {A / B / C / D / E / F} - {strategy name}

{1-2 sentence rationale}

Proceeding to decomposition...
```

### Units Generated (DECOMPOSE)

```
=== Units Generated ===

  #   Unit                  File                        Dependencies
  --- --------------------- --------------------------- ----------------
  1   {name}                aidlc/units/01-{name}.md    None
  2   {name}                aidlc/units/02-{name}.md    Unit 1

Plan written to: aidlc/plan.md
  - Execution waves and assignment recommendations
  - Branch naming and merge sequence
  - Merge conflict hotspots
  - Definition of done checklist

Proceeding to validation...
```

### Validation Report (VALIDATE)

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

### Implementation Roadmap (HANDOFF)

```
=== Implementation Roadmap ===

  Order  Unit                  File                        Dependencies   Status
  ------ --------------------- --------------------------- -------------- ----------
  1      {name}                aidlc/units/01-{name}.md    None           [ ] pending
  2      {name}                aidlc/units/02-{name}.md    Unit 1         [ ] pending

Parallel:   Units {X} and {Y} have no mutual dependencies.
Sequential: Unit {Z} depends on Unit {X}.

---

Would you like to create specification documents for your units?
For each unit I can generate:
  - requirements.md  (EARS notation, testable acceptance criteria)
  - design.md        (architecture, data models, API contracts)
  - tasks.md         (task breakdown with checkpoints)

[1] All units in dependency order
[2] One at a time
[3] Roadmap only — I will implement directly
```

### Requirements Coverage Check (HANDOFF — after writing requirements.md)

```
=== Requirements Coverage Check: {Unit Name} ===

  Source        Item                              Covered   Notes
  ------------- --------------------------------- --------- ----------------------
  User Story    WHEN ... THE SYSTEM SHALL ...     OK / !    {req ref or gap}
  NFR           {requirement}                     OK / !    {req ref or gap}
  Risk          {risk}                            OK / !    {mitigation captured?}
  Decision      {decision}                        OK / !    {reflected?}

Result: {All covered / {N} gaps found - update requirements.md before proceeding}
```

### Resume

```
=== Resuming AI-DLC Session ===

Intent: {original intent, first sentence}

  Metric              Value
  ------------------- -------
  Current phase       {phase}
  Questions asked     {N}
  Questions answered  {M}
  Decisions recorded  {count}
  Units generated     {count or "not yet"}

Key decisions so far:
1. {decision}
2. {decision}

Where we left off: {what was happening}

How would you like to proceed?

[1] Continue from where we left off
[2] Review decisions made so far
[3] Restart from a specific point
[4] Skip to decomposition (if enough context exists)
```
