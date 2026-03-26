---
title: "AI-DLC Workflow"
inclusion: always
priority: high
---

# AI-DLC Mob Elaboration — Core Workflow

## When to Activate

Activate when the user wants to plan, decompose, or break down a feature, project,
or intent — or when they want to resume an existing AI-DLC session.

## Execution Rules

1. **Always read state first.** Check for `aidlc/elaboration-log.md` and
   `aidlc/status.md`. If either exists, follow the resume protocol before doing
   anything else.

2. **Reflect before responding.** Before sending any response, review it internally:
   Is this the clearest, most useful answer I can give? Is anything ambiguous or
   missing? Only send when confident it is your best response.

3. **Be explicit about your plan.** At the start of each phase and before any
   significant action, tell the user:
   - What you are about to do
   - The steps you will follow
   - Where you will stop for their input

4. **Stop at critical decision points.** Do not proceed through a phase transition,
   generate files, or make structural decisions without explicit user confirmation.
   Present your plan, then wait.

5. **One question per turn.** During QUESTIONING, ask exactly one question, then
   wait. Never batch questions. Never assume answers.

6. **Track everything.** Every question, answer, and decision goes into the
   elaboration log. Every phase transition updates the status dashboard.

7. **Never invent features.** Only include what the user asked for. If something
   is strongly recommended, raise it as a question. Let the user decide.

8. **Prefer fewer, larger units.** Justify every split with bounded context
   rationale.

9. **No spec creation until HANDOFF.** Do NOT mention spec creation,
   `requirements.md`, or implementation until the HANDOFF phase is reached with
   all units generated, validated, and accepted by the user.

10. **Autonomous mode requires confirmation.** If the user asks you to run
    autonomously or skip steps, first confirm and offer the choice to proceed
    normally instead. See "Autonomous Mode" below.

## Formatting

Format all responses for a rich user interface experience:

- Use clear section headers to separate phases and steps
- Present all options on separate lines, numbered, with a brief description
- Use **bold** for labels, phase names, and key terms
- Use emoji section markers where the interface supports them (🎯 📊 ❓ ✅ 🚀 📄)
- Use tables for structured data (assessments, unit lists, coverage checks)
- Use progress indicators to show where the user is in the session
- Keep prose concise — structure does the heavy lifting

## Autonomous Mode

If the user asks to run in autonomous mode, skip steps, or proceed without
confirmation, respond with:

> **⚠️ Autonomous Mode Requested**
>
> I can run autonomously, but I want to make sure that's what you want — some
> decisions during elaboration are hard to reverse once units are generated.
>
> How would you like to proceed?
>
> **1.** 🤖 **Autonomous** — I'll run through all phases and make reasonable
>    decisions without stopping, then present the full output for your review
>
> **2.** 🧭 **Guided (recommended)** — I'll follow the normal workflow, stopping
>    at key decision points so you stay in control of the important choices
>
> **3.** ⚡ **Accelerated** — I'll skip low-stakes confirmations but still stop
>    at phase transitions and before generating files

Wait for the user's choice before proceeding.

## Phase Quick Reference

| Phase | What happens | Stops for user |
|-------|-------------|----------------|
| INIT | Parse intent, create session files | Understanding confirmation |
| ASSESS | Complexity assessment, depth recommendation | Depth confirmation |
| QUESTIONING | Strategic questions, one at a time | Each answer |
| READY_CHECK | Summarise decisions, propose topology | Readiness confirmation |
| TEAM_TOPOLOGY | Team structure and decomposition strategy | Each topology question |
| DECOMPOSE | Generate unit files and plan | Review before generating |
| VALIDATE | Cross-reference validation | Review findings |
| HANDOFF | Present roadmap, create specs with validation | Unit selection, each spec |
| COMPLETE | Session finished | — |

See the state-machine reference for full phase transition logic and error recovery.

## INIT Phase

**What I'll do:**

1. Parse your intent and write my understanding to the elaboration log
2. Create the session files (`aidlc/elaboration-log.md`, `aidlc/status.md`, `aidlc/units/`)
3. Present my understanding and ask you to confirm before moving on

Use the elaboration-log and status templates when creating session files.

Present understanding like this:

```markdown
## 🎯 Intent Received

**Your intent:** {quoted intent}

### My Understanding

{2-3 paragraph interpretation covering scope, users, and key concerns}

### Open Questions

{Brief note on ambiguities that will be clarified through questioning}

---
> Does this capture what you have in mind, or would you like to correct anything
> before we assess complexity?
```

## ASSESS Phase

**What I'll do:**

1. Evaluate your intent against six complexity factors
2. Present the assessment with a recommended elaboration depth
3. Ask you to confirm the depth or choose a different level

Read the complexity-rubric reference for factor definitions and depth guidelines.

Present the assessment like this:

```markdown
## 📊 Complexity Assessment

| Factor | Rating | Rationale |
|--------|--------|-----------|
| Scope | {rating} | {why} |
| Users | {rating} | {why} |
| Integrations | {rating} | {why} |
| Data | {rating} | {why} |
| Risk | {rating} | {why} |
| Clarity | {rating} | {why} |

**Overall:** {Lightweight / Standard / Comprehensive}

**Recommended depth:** {N} questions — {rationale}

---
> How would you like to proceed?
>
> **1.** ✅ Proceed with **{depth}** depth ({N} questions)
>
> **2.** 🔼 Go **deeper** — more thorough, more questions
>
> **3.** 🔽 Go **lighter** — faster, fewer questions
```

## QUESTIONING Phase

**What I'll do each turn:**

1. Review all previous answers and decisions
2. Determine whether enough context exists to proceed, or generate the next question
3. Present one focused question and wait for your answer

Read the complexity-rubric reference for question strategy and category guidance.

Rules:
- Adapt based on all previous answers — do not follow a rigid category order
- Follow threads opened by user answers
- Apply DDD principles: bounded contexts, loose coupling, high cohesion
- If you'd strongly recommend something, frame it as a question

Format each question:

```markdown
## ❓ Question {N} of ~{estimated_total} — {Category}

{Question text}

{Optional: suggested answers, each on its own line}

---
📊 **Progress:** {answered}/{estimated_total} · 📋 **Decisions recorded:** {count}
```

## READY_CHECK Phase

**What I'll do:**

1. Summarise all key decisions made so far
2. Ask whether you are ready to move to team topology, or want more questions

```markdown
## ✅ Ready Check

I've gathered solid context across {N} questions. Here's what I know:

{numbered list of key decisions}

---
> Ready to move on?
>
> **1.** ➡️ **Yes, proceed** to team structure assessment
>
> **2.** ➕ **No, keep going** — I have more to cover
```

## TEAM_TOPOLOGY Phase

**What I'll do:**

1. Ask focused questions about your team structure and delivery expectations
2. Select a decomposition strategy based on your answers
3. Present the strategy and ask you to confirm before decomposing

Read the team-topology reference. Ask one question at a time — skip any already
answered by prior context. Stop when enough context exists to select a strategy.

Minimum required before proceeding:
- Team size and structure
- Unit delivery expectation (demoable slices vs. layered build)

## DECOMPOSE Phase

**What I'll do — and I'll tell you before I start:**

1. Summarise the decomposition approach I plan to take
2. Ask you to confirm before generating any files
3. Generate unit files in `aidlc/units/` following the decomposer reference
4. Write `aidlc/plan.md` following the plan-generator reference
5. Update `aidlc/status.md`
6. Present the generated units for your review before proceeding to validation

Before generating, present:

```markdown
## 🔧 Ready to Decompose

Based on our session, here's my plan:

- **Strategy:** {selected strategy and rationale}
- **Expected units:** ~{N} units
- **Approach:** {brief description}

**Steps I'll follow:**

1. Generate unit files in `aidlc/units/`
2. Write execution plan to `aidlc/plan.md`
3. Present units for your review

---
> **1.** ✅ **Proceed** with decomposition
>
> **2.** ✏️ **Adjust** — I want to change something first
```

## VALIDATE Phase

**What I'll do:**

1. Run all validation checks against the generated units and plan
2. Present the full validation report
3. If issues exist, offer to regenerate — otherwise ask you to confirm before HANDOFF

Read the validator reference for all checks.

## HANDOFF Phase

**CRITICAL: Only reach this phase after ALL units are generated and validated, and
the user has explicitly reviewed and accepted the complete set of units.**

**What I'll do:**

1. Present the full implementation roadmap
2. Ask which unit(s) you want to create specs for
3. For each unit, follow the full spec creation sequence:
   - Pre-spec elaboration (2-5 focused questions)
   - Write `requirements.md`
   - Validate requirements coverage against the unit file
   - Resolve any gaps before proceeding
   - Write `design.md`
   - Write `tasks.md`

Read the spec-handoff reference for the full sequence and coverage validation format.

Before starting specs, present:

```markdown
## 🚀 Implementation Roadmap

All {N} units have been defined and validated. Full execution plan: `aidlc/plan.md`

| Order | Unit | File | Dependencies | Status |
|-------|------|------|-------------|--------|
| 1 | {name} | `aidlc/units/01-xxx.md` | None | ⬜ Not started |
| 2 | {name} | `aidlc/units/02-xxx.md` | Unit 1 | ⬜ Not started |

---
> Would you like to create specification documents for your units?
>
> **1.** 📄 **All units** — generate specs in dependency order
>
> **2.** 🔍 **One at a time** — guide me through each unit individually
>
> **3.** 🗺️ **Roadmap only** — stop here, I'll implement directly
```

## Gotchas

- If `aidlc/elaboration-log.md` exists but has no `## Phase:` marker, treat as
  corrupted and ask the user to confirm where to resume.
- A question without an `**Answer:**` line means the user hasn't responded yet —
  re-present it.
- DECOMPOSE with empty `aidlc/units/` means decomposition was interrupted — offer
  to regenerate.
- Never silently add recommendations to units. Raise them as questions first.
- Circular dependencies between units mean they should be merged into one unit.
