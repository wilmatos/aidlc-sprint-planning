---
title: "AI-DLC State Machine"
inclusion: manual
priority: medium
---

# State Machine Reference

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

## Phase: INIT

**Entry:** No `aidlc/elaboration-log.md` exists, or user starts a new session.

**Actions:**
1. Create `aidlc/` directory structure
2. Create `aidlc/elaboration-log.md` with intent and understanding
3. Create `aidlc/status.md` with initial state
4. Present understanding to user

**Exit:** User confirms or corrects understanding.

**Log format:**
```markdown
# Mob Elaboration Log

## Intent
{raw intent from user}

## Understanding
{your interpretation}

## Phase: INIT
```

## Phase: ASSESS

**Entry:** User confirmed understanding from INIT.

**Actions:**
1. Evaluate complexity using the rubric
2. Record assessment in log
3. Present assessment with depth recommendation
4. Ask user to confirm or override depth

**Exit:** User confirms depth.

## Phase: QUESTIONING

**Entry:** User confirmed depth, or returned from READY_CHECK.

**Actions per turn:**
1. Read the log to find the last question number and answer
2. If previous question has no answer, wait
3. If answer exists, evaluate whether enough context exists
4. If enough → READY_CHECK
5. If not → generate next question, append to log, present

**Question selection strategy:**
- Adapt based on all previous answers, not a rigid category order
- Follow threads opened by user answers
- If an answer closes a category, skip remaining questions in it
- Apply DDD principles: bounded contexts, loose coupling, high cohesion
- If you'd strongly recommend something, frame it as a question

**Exit:** Enough context (→ READY_CHECK) or user asks to decompose.

**Log format (per question):**
```markdown
## Question {N}: {Short Title}
{question text}

{optional suggested answers}

## Phase: QUESTIONING ({N})
**Answer:** {user's answer, appended after they respond}
```

## Phase: READY_CHECK

**Entry:** Facilitator determines enough context exists.

**Actions:**
1. Summarize key decisions
2. Ask user if ready to proceed

**Exit:** Ready → TEAM_TOPOLOGY. More questions → QUESTIONING.

## Phase: TEAM_TOPOLOGY

**Entry:** User confirmed ready from READY_CHECK.

**Actions:**
1. Read the team-topology reference for the full question set and strategies
2. Ask topology questions one at a time — skip any already answered
3. Stop when enough context exists to select a decomposition strategy
4. Record the topology profile in the elaboration log
5. Transition to DECOMPOSE

**Minimum required before proceeding:**
- Team size and structure (Q1)
- Unit delivery expectation (Q2)

All other questions are conditional on the answers to Q1 and Q2.

**Exit:** Topology profile recorded → DECOMPOSE.

**Log format:**
```markdown
## Team Topology Question: {Short Title}
{question text}

## Phase: TEAM_TOPOLOGY
**Answer:** {user's answer}
```

Followed by the full topology profile block after all questions are answered.

## Phase: DECOMPOSE

**Entry:** Topology profile recorded.

**Actions:**
1. Generate unit files from the elaboration log, applying the topology strategy
2. Generate `aidlc/plan.md` using the plan-generator reference
3. Update status dashboard
4. Transition to VALIDATE

**Exit:** All unit files and `aidlc/plan.md` generated.

## Phase: VALIDATE

**Entry:** DECOMPOSE completed.

**Validation checks:**
- Every user decision reflected in at least one unit
- Dependency ordering is a valid DAG
- No functionality gaps
- Bounded context rationale is sound
- NFRs from questioning are captured
- `aidlc/plan.md` exists and merge sequence is consistent with dependency graph

**Exit:** User accepts validation results.

## Phase: HANDOFF

**Entry:** Validation accepted.

**CRITICAL GATE:** Before presenting implementation instructions, verify:
1. ALL unit files exist in `aidlc/units/`
2. The VALIDATE phase completed successfully with no critical issues
3. The user has explicitly reviewed and accepted the full set of units

**Exit:** User picks a unit or ends session.

## Phase: COMPLETE

**Entry:** All units handed off or user ends session.

## Error Recovery

If the log is inconsistent (question without answer, phase marker without content):

1. Present what you can determine
2. Ask user to confirm where to resume
3. Append recovery note:

```markdown
## Recovery Note
Session resumed. Previous state: {detected}. User confirmed: {phase}.
```
