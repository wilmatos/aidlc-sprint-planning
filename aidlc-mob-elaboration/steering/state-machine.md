# State Machine Reference

## Phase Transitions

```
INIT ──→ ASSESS ──→ QUESTIONING ──→ READY_CHECK ──→ DECOMPOSE ──→ VALIDATE ──→ HANDOFF ──→ COMPLETE
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
| `## Phase: READY_CHECK` | READY_CHECK | If ready → DECOMPOSE. If more → QUESTIONING |
| `## Phase: DECOMPOSE` | DECOMPOSE | Generate units, then VALIDATE |
| `## Phase: VALIDATE` | VALIDATE | Present validation, then HANDOFF |
| `## Phase: HANDOFF` | HANDOFF | Present spec instructions |
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
1. Evaluate complexity using the rubric (read complexity-rubric steering file)
2. Record assessment in log
3. Present assessment with depth recommendation
4. Ask user to confirm or override depth

**Exit:** User confirms depth.

**Log format (appended):**
```markdown
## Complexity Assessment
{table of factors and ratings}

Overall: {rating}
Recommended depth: {N} questions

## User Response to Complexity Assessment
{user's confirmation or override}

## Phase: ASSESS
```

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

**Exit:** Ready → DECOMPOSE. More questions → QUESTIONING.

## Phase: DECOMPOSE

**Entry:** User confirmed ready.

**Actions:**
1. Delegate to `aidlc-decomposer` subagent with full elaboration log
2. Wait for completion
3. Update status dashboard
4. Transition to VALIDATE

**Exit:** All unit files generated.

## Phase: VALIDATE

**Entry:** DECOMPOSE completed.

**Actions:**
1. Delegate to `aidlc-validator` subagent with all unit files
2. Present validation results
3. If critical issues, allow regeneration
4. If clean, proceed to HANDOFF

**Validation checks:**
- Every user decision reflected in at least one unit
- Dependency ordering is a valid DAG
- No functionality gaps
- Bounded context rationale is sound
- NFRs from questioning are captured

**Exit:** User accepts validation results.

## Phase: HANDOFF

**Entry:** Validation accepted.

**CRITICAL GATE — Do NOT suggest Spec mode prematurely:**
Before presenting spec creation instructions, verify ALL of the following:
1. ALL unit files exist in `aidlc/units/`
2. The VALIDATE phase completed successfully with no critical issues
3. The user has explicitly reviewed and accepted the full set of units

If any of these conditions are not met, do NOT mention Spec mode, do NOT suggest
switching to Spec mode, and do NOT present spec creation instructions. Instead,
guide the user back to the appropriate phase (DECOMPOSE or VALIDATE).

**Actions:**
1. Confirm all units are finalized — list them and ask the user to confirm the full set
2. Only after user confirms: present numbered unit list with spec creation instructions
3. Update status dashboard
4. Wait for user to pick a unit

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
