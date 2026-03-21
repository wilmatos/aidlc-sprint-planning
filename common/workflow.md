# AI-DLC Mob Elaboration — Core Workflow

## When to Activate

Activate when the user wants to plan, decompose, or break down a feature or project,
or when they want to resume an existing AI-DLC session.

## Execution Rules

1. **Always read state first.** Check for `aidlc/elaboration-log.md` and `aidlc/status.md`.
   If either exists, follow the resume protocol before doing anything else.

2. **One question per turn.** During QUESTIONING, ask exactly one question, then wait.
   Never batch questions. Never assume answers.

3. **Track everything.** Every question, answer, and decision goes into the elaboration
   log. Every phase transition updates the status dashboard.

4. **Never invent features.** Only include what the user asked for. If something is
   strongly recommended, raise it as a question. Let the user decide.

5. **Prefer fewer, larger units.** Justify every split with bounded context rationale.

6. **No spec creation until HANDOFF.** Do NOT mention spec creation, `requirements.md`,
   or implementation until the HANDOFF phase is reached with all units generated,
   validated, and accepted by the user.

## Phase Quick Reference

| Phase | What happens | User action needed |
|-------|-------------|-------------------|
| INIT | Parse intent, create session files | Confirm understanding |
| ASSESS | Complexity assessment, depth recommendation | Confirm or override depth |
| QUESTIONING | Strategic questions, one at a time | Answer each question |
| READY_CHECK | Propose moving to team topology | Confirm or request more |
| TEAM_TOPOLOGY | Team structure and decomposition strategy | Answer topology questions |
| DECOMPOSE | Generate unit files | Review units |
| VALIDATE | Cross-reference validation | Review findings |
| HANDOFF | Present roadmap, create specs with validation | Pick a unit to implement |
| COMPLETE | Session finished | Start implementation |

See the state-machine reference for full phase transition logic and error recovery.

## INIT Phase

When no `aidlc/` directory exists or the user provides a new intent:

1. Create `aidlc/elaboration-log.md`, `aidlc/status.md`, and `aidlc/units/` (empty).
   Use the elaboration-log and status templates.
2. Write the intent and your understanding to the elaboration log.
3. Present your understanding to the user and move to ASSESS.

## ASSESS Phase

Read the complexity-rubric reference. Evaluate all six factors (Scope, Users,
Integrations, Data, Risk, Clarity), present the assessment table, recommend a depth,
and ask the user to confirm or override.

## QUESTIONING Phase

Read the complexity-rubric reference for question strategy. For each turn:

1. Read the log to find the last question number and answer.
2. If enough context exists → READY_CHECK. If not → generate the next question.
3. Adapt based on all previous answers — do not follow a rigid category order.
4. Apply DDD principles: bounded contexts, loose coupling, high cohesion.

## READY_CHECK Phase

Summarize key decisions. Ask the user if they are ready to proceed to team topology
assessment, or if there is more to cover.

## TEAM_TOPOLOGY Phase

Read the team-topology reference. Ask topology questions one at a time — skip any
already answered by prior context. Stop when enough context exists to select a
decomposition strategy. Record the topology profile in the elaboration log before
proceeding to DECOMPOSE.

Minimum required before proceeding:
- Team size and structure
- Unit delivery expectation (demoable slices vs. layered build)

## DECOMPOSE Phase

1. Read the `## Team Topology` section of the elaboration log.
2. Generate unit files in `aidlc/units/` following the decomposer reference.
3. Write `aidlc/plan.md` following the plan-generator reference.
4. Update `aidlc/status.md`.
5. Proceed to VALIDATE.

## VALIDATE Phase

Read the validator reference. Run all validation checks against the generated unit
files and `aidlc/plan.md`. Present the validation report. If critical issues exist,
offer to regenerate. If clean, proceed to HANDOFF.

## HANDOFF Phase

**CRITICAL: Only reach this phase after ALL units are generated and validated, and
the user has explicitly reviewed and accepted the complete set of units.**

Read the spec-handoff reference. Present the implementation roadmap, then follow
the full "Creating Specs for a Unit" sequence for each unit the user picks —
including pre-spec elaboration, writing requirements.md, validating coverage against
the unit file, and only then proceeding to design.md and tasks.md.

## Gotchas

- If `aidlc/elaboration-log.md` exists but has no `## Phase:` marker, treat as
  corrupted and ask the user to confirm where to resume.
- A question without an `**Answer:**` line means the user hasn't responded yet —
  re-present it.
- DECOMPOSE with empty `aidlc/units/` means decomposition was interrupted — offer
  to regenerate.
- Never silently add recommendations to units. Raise them as questions first.
- Circular dependencies between units mean they should be merged into one unit.
