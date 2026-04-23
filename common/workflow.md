# AIDLC Sprint Planning — Core Workflow

This workflow implements the AI-DLC mob elaboration technique for sprint planning.
Through structured, one-at-a-time questioning, it decomposes a high-level intent
into bounded implementation units sized for sprint execution.

## When to Activate

Activate when the user wants to plan, decompose, or break down a feature, project,
or intent — or when they want to resume an existing AIDLC session.

## Phase Transitions

```
INIT ──→ ASSESS ──→ QUESTIONING ──→ READY_CHECK ──→ TEAM_TOPOLOGY ──→ DECOMPOSE ──→ VALIDATE ──→ HANDOFF ──→ COMPLETE
                         ↑                │
                         └────────────────┘
                      (user wants more questions)
```

## State Detection

Read `aidlc/elaboration-log.md` and look for the last `## Phase:` marker:

| Marker | Phase | Next Action |
|--------|-------|-------------|
| No file exists | INIT | Create session, parse intent |
| `## Phase: INIT` | INIT | Present understanding, move to ASSESS |
| `## Phase: ASSESS` | ASSESS | Record depth confirmation, ask first question |
| `## Phase: QUESTIONING (N)` | QUESTIONING | Read last answer, ask next or READY_CHECK |
| `## Phase: READY_CHECK` | READY_CHECK | If ready → TEAM_TOPOLOGY. If more → QUESTIONING |
| `## Phase: TEAM_TOPOLOGY` | TEAM_TOPOLOGY | Ask topology questions, then DECOMPOSE |
| `## Phase: DECOMPOSE` | DECOMPOSE | Generate units, then VALIDATE |
| `## Phase: VALIDATE` | VALIDATE | Present validation, then HANDOFF |
| `## Phase: HANDOFF` | HANDOFF | Present implementation instructions |
| `## Phase: COMPLETE` | COMPLETE | Session finished |

## Execution Mode

All phases from INIT through VALIDATE operate in **action mode** — the agent
performs actions (creates files, asks questions, generates units) without
referencing specifications, spec documents, or formal requirements documents.

Avoid using the words "spec", "specification", or "requirements document" in any
response before the HANDOFF phase. Use these alternatives instead:

| Instead of | Use |
|-----------|-----|
| spec / specification | unit file, implementation document |
| requirements document | unit definition |
| create a spec | define the unit |
| spec creation | implementation planning |

The HANDOFF phase is the only phase where specification language is appropriate.
This prevents premature triggering of specification workflows in the host IDE.

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

4. **Wait for confirmation at decision points.** Always present your plan and wait
   for explicit user confirmation before proceeding through a phase transition,
   generating files, or making structural decisions.

5. **One question per turn.** During QUESTIONING, ask exactly one question, then
   wait. Always wait for the answer before generating the next question.

6. **Track everything.** Every question, answer, and decision goes into the
   elaboration log. Every phase transition updates the status dashboard.

7. **Only include what the user asked for.** If something is strongly recommended,
   raise it as a question. Let the user decide.

8. **Prefer fewer, larger units.** Justify every split with bounded context
   rationale.

9. **Implementation planning happens only in HANDOFF.** Only mention implementation
   documents, specifications, or `requirements.md` after all units are generated,
   validated, and accepted by the user. Before HANDOFF, refer to "unit files" and
   "unit definitions" instead.

10. **Autonomous mode requires confirmation.** If the user asks you to run
    autonomously or skip steps, first confirm and offer the choice to proceed
    normally instead. See "Autonomous Mode" below.

## Formatting

Format all responses with:
- Section headers, numbered options, **bold** labels
- Emoji markers where supported (🎯 📊 ❓ ✅ 🚀 📄)
- Tables for structured data, progress indicators
- Concise prose — structure does the heavy lifting

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

---

## INIT Phase

**Entry:** No `aidlc/elaboration-log.md` exists, or user starts a new session.

**Exit:** User confirms or corrects understanding.

**Actions:**
1. Parse your intent and write my understanding to the elaboration log
2. Create the session files (`aidlc/elaboration-log.md`, `aidlc/status.md`, `aidlc/units/`)
3. Present my understanding and ask you to confirm before moving on

Use the elaboration-log and status templates when creating session files.

**Log format:**

```markdown
# Sprint Planning — Mob Elaboration Log

## Intent

{raw intent from user}

## Understanding

{your interpretation}

## Phase: INIT
```

**Present understanding like this:**

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

---

## ASSESS Phase

**Entry:** User confirmed understanding from INIT.

**Exit:** User confirms depth.

**Actions:**
1. Evaluate your intent against six complexity factors
2. Record assessment in log
3. Present the assessment with a recommended elaboration depth
4. Ask you to confirm the depth or choose a different level

Read the complexity-rubric reference for factor definitions and depth guidelines.

**Present the assessment like this:**

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

---

## QUESTIONING Phase

**Entry:** User confirmed depth, or returned from READY_CHECK.

**Exit criteria (any one triggers transition to READY_CHECK):**
- User explicitly asks to decompose or move to DECOMPOSE phase
- Question count reaches estimated_total (from complexity-rubric depth guidelines)
- All categories in complexity-rubric have been covered (Users, Scope, Functionality, Data, Integration, NFRs, Risks)

**Actions per turn:**
1. Review all previous answers and decisions
2. If previous question has no answer, wait
3. If answer exists, evaluate whether exit criteria are met
4. If exit criteria met → READY_CHECK
5. If not → generate next question, append to log, present one focused question

Read the complexity-rubric reference for question strategy and category guidance.

Rules:
- Adapt based on all previous answers — follow threads, skip closed categories
- Follow threads opened by user answers
- Apply DDD principles: bounded contexts, loose coupling, high cohesion
- If you'd strongly recommend something, frame it as a question

**Log format (per question):**

```markdown
## Question {N}: {Short Title}

{question text}

{optional suggested answers}

## Phase: QUESTIONING ({N})

**Answer:** {user's answer, appended after they respond}
```

**Present each question like this:**

```markdown
## ❓ Question {N} of ~{estimated_total} — {Category}

{Question text}

{Optional: suggested answers, each on its own line}

---
📊 **Progress:** {answered}/{estimated_total} · 📋 **Decisions recorded:** {count}
```

---

## READY_CHECK Phase

**Entry:** Facilitator determines enough context exists.

**Exit criteria (any one triggers transition):**
- User explicitly confirms ready to proceed → TEAM_TOPOLOGY
- User explicitly asks for more questions → QUESTIONING

**Actions:**
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

---

## TEAM_TOPOLOGY Phase

**Entry:** User confirmed ready from READY_CHECK.

**Exit criteria (all required before transition to DECOMPOSE):**
- Team size and structure (Q1) answered
- Unit delivery expectation (Q2) answered
- Decomposition strategy can be selected based on answers

**Actions:**
1. Ask focused questions about your team structure and delivery expectations
2. Select a decomposition strategy based on your answers
3. Present the strategy and ask you to confirm before decomposing
4. Record the topology profile in the elaboration log

Read the team-topology reference. Ask one question at a time — skip any already
answered by prior context. Stop when enough context exists to select a strategy.

**Log format:**

```markdown
## Team Topology Question: {Short Title}

{question text}

## Phase: TEAM_TOPOLOGY

**Answer:** {user's answer}
```

Followed by the full topology profile block after all questions are answered.

---

## DECOMPOSE Phase

**Entry:** Topology profile recorded.

**Exit:** All unit files and `aidlc/plan.md` generated.

**Actions — tell the user before starting:**
1. Summarise the decomposition approach I plan to take
2. Ask you to confirm before generating any files
3. Generate unit files in `aidlc/units/` following the decomposer reference
4. Write `aidlc/plan.md` following the plan-generator reference
5. Update `aidlc/status.md`
6. Present the generated units for your review before proceeding to validation

**Before generating, present:**

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

---

## VALIDATE Phase

**Entry:** DECOMPOSE completed.

**Exit:** User accepts validation results.

**Actions:**
1. Run all validation checks against the generated units and plan
2. Present the full validation report
3. If issues exist, offer to regenerate — otherwise ask you to confirm before HANDOFF

Read the validator reference for all checks.

---

## HANDOFF Phase

**Entry:** Validation accepted.

**CRITICAL GATE:** Before presenting implementation instructions, verify:
1. ALL unit files exist in `aidlc/units/`
2. The VALIDATE phase completed successfully with no critical issues
3. The user has explicitly reviewed and accepted the full set of units

If any gate condition is not met, explain which condition is missing and what
needs to happen first.

**Exit:** User picks a unit or ends session.

**Actions:**
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

**Before starting specs, present:**

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

---

## COMPLETE Phase

**Entry:** All units handed off or user ends session.

---

## Output Template Reference

Each phase uses a specific output format. Use the templates defined in these files:

| Output | Template location | Used in phase |
|--------|------------------|---------------|
| Question format | complexity-rubric (Question Template section) | QUESTIONING |
| Status dashboard | status-template | INIT (create), all phases (update) |
| Complexity assessment | workflow.md ASSESS Phase section above | ASSESS |
| Ready check summary | workflow.md READY_CHECK Phase section above | READY_CHECK |
| Topology profile | team-topology (Topology Profile section) | TEAM_TOPOLOGY |
| Unit files | unit-template | DECOMPOSE |
| Execution plan | plan-template | DECOMPOSE |
| Validation report | validator (Report Format section) | VALIDATE |
| Implementation roadmap | workflow.md HANDOFF Phase section above | HANDOFF |
| Resume presentation | resume-protocol (Resume Presentation section) | Resume |

Always use the template from the referenced file. Invent formats only if no template exists.

## Error Recovery

If the log is inconsistent, apply these recovery rules:

| Condition | Recovery action |
|-----------|----------------|
| Question without `**Answer:**` | Re-present the unanswered question |
| `## Phase:` marker with no content after it | Ask user to confirm current phase |
| DECOMPOSE phase but `aidlc/units/` is empty | Offer to regenerate all units |
| HANDOFF phase but status.md shows no work started | Present roadmap with current status |
| No `## Phase:` marker in log | Treat as corrupted — ask user where to resume |

After recovery, append:

```markdown
## Recovery Note

Session resumed. Previous state: {detected}. User confirmed: {phase}.
```

## Gotchas

- If `aidlc/elaboration-log.md` exists but has no `## Phase:` marker, treat as
  corrupted and ask the user to confirm where to resume.
- A question without an `**Answer:**` line means the user hasn't responded yet —
  re-present it.
- DECOMPOSE with empty `aidlc/units/` means decomposition was interrupted — offer
  to regenerate.
- Always raise recommendations as questions first. Let the user decide.
- Circular dependencies between units mean they should be merged into one unit.
