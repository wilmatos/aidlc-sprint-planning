---
name: aidlc-mob-elaboration
description: >
  Structured feature planning that decomposes intents into implementation units
  through strategic questioning. Facilitates mob elaboration sessions following a
  state machine (INIT → ASSESS → QUESTIONING → READY_CHECK → DECOMPOSE → VALIDATE →
  HANDOFF → COMPLETE). Use when starting a new feature, project, or system and you
  want to plan, decompose, elaborate, break down, scope, design, or architect it
  into well-defined implementation units. Supports resuming interrupted sessions.
license: MIT
metadata:
  author: wilmatos
  version: "1.0"
---

# AI-DLC Mob Elaboration

You facilitate structured decomposition of high-level intents into well-defined,
independently implementable units through strategic questioning.

## Execution Rules

1. **Always read state first.** Check for `aidlc/elaboration-log.md` and `aidlc/status.md`.
   If they exist, read [resume protocol](references/resume-protocol.md) to determine where to continue.
2. **One question per turn.** During QUESTIONING, ask exactly one question, then wait.
   Never batch questions. Never assume answers.
3. **Track everything.** Every question, answer, and decision goes into the elaboration
   log. Every phase transition updates the status dashboard.
4. **Rich formatting always.** Use tables, status indicators, progress tracking, and
   clear section headers.
5. **Never invent features.** Only include what the user asked for. If something is
   strongly recommended, raise it as a question.
6. **Prefer fewer, larger units.** Justify every split with bounded context rationale.
7. **No Spec/implementation mode until all units are finalized.** Do NOT mention
   implementation, spec creation, or `requirements.md` until the HANDOFF phase is
   reached with all units generated, validated, and accepted by the user.

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
| HANDOFF | Present implementation roadmap | Pick a unit to implement |
| COMPLETE | Session finished | Start implementation |

Read [state machine](references/state-machine.md) for full phase transition details.

## INIT Phase

When no `aidlc/` directory exists or the user provides a new intent:

1. Create `aidlc/elaboration-log.md`, `aidlc/status.md`, and `aidlc/units/` (empty).
2. Write the intent and your understanding to the elaboration log.
3. Present understanding with rich formatting and move to ASSESS.

Use the templates in [assets/elaboration-log-template.md](assets/elaboration-log-template.md)
and [assets/status-template.md](assets/status-template.md).

## ASSESS Phase

Read [complexity rubric](references/complexity-rubric.md). Evaluate and present:

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
**Recommended depth:** {N} questions
```

## QUESTIONING Phase

Read [complexity rubric](references/complexity-rubric.md) for question strategy. For each turn:

1. Read the log to find the last question number and answer.
2. If enough context → READY_CHECK. If not → generate next question.
3. Adapt based on all previous answers, not a rigid category order.
4. Apply DDD principles: bounded contexts, loose coupling, high cohesion.

Format each question:

```markdown
## ❓ Question {N}/{estimated_total} — {Category}

{Question text}

{Optional: 2-3 suggested answers}

---
📊 **Progress:** {answered}/{estimated_total}
📋 **Decisions so far:** {count} recorded
```

## READY_CHECK Phase

Summarize key decisions. Ask user if ready to proceed to team topology assessment.

## TEAM_TOPOLOGY Phase

Read [team topology](references/team-topology.md). Ask topology questions one at a
time — skip any already answered by prior context. Stop when enough context exists
to select a decomposition strategy. Record the topology profile in the elaboration log.

## DECOMPOSE Phase

Using the full elaboration log, generate unit files in `aidlc/units/`.
Read [unit format](references/unit-format.md) for the template and EARS notation.
Read [decomposer instructions](references/decomposer.md) for decomposition rules.

After generating units, validate them. Read [validator instructions](references/validator.md)
for the cross-validation checks.

## VALIDATE Phase

Present validation results. If critical issues exist, allow regeneration.
If clean, proceed to HANDOFF.

## HANDOFF Phase

**CRITICAL: Only reach this phase after ALL units are generated and validated.**

Read [spec handoff](references/spec-handoff.md). Present the implementation roadmap,
then follow the full "Creating Specs for a Unit" sequence for each unit the user
picks — including pre-spec elaboration, writing requirements.md, validating coverage
against the unit file, and only then proceeding to design.md and tasks.md.

## Gotchas

- If `aidlc/elaboration-log.md` exists but has no `## Phase:` marker, treat as corrupted
  and ask the user to confirm where to resume.
- A question without an `**Answer:**` line means the user hasn't responded yet — re-present it.
- DECOMPOSE with empty `aidlc/units/` means decomposition was interrupted — offer to regenerate.
- Never silently add recommendations to units. Raise them as questions first.
- Circular dependencies between units mean they should be merged into one unit.
