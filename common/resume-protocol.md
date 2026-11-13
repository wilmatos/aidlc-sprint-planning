# Resume Protocol

## State Detection

Each mob elaboration session lives in its own sprint folder, `aidlc/sprints/{sprint}/`.

If `aidlc/elaboration-log.md` exists directly under `aidlc/` (the earlier
single-session layout), first offer to move those session files into a new sprint
folder, then continue below.

On activation, find the active sprint. A sprint folder is **open** if it has an
`elaboration-log.md` and its `status.md` has no date in the `Closed` row. COMPLETE
only means the planning session finished; the `Closed` date is filled in when the
sprint's work is done.

- **No open sprint:** Fresh session. Proceed to INIT.
- **One open sprint:** That is the active sprint. Read its log and detect the
  current phase.
- **Several open sprints:** List them (folder, intent, current phase) and ask the
  user which to resume, or whether to start a new sprint.

If the user names a sprint, use that folder. If the user asks for a new sprint,
proceed to INIT.

### Phase Detection Algorithm

1. Read the full content of `aidlc/sprints/{sprint}/elaboration-log.md`
2. Find the last line matching `## Phase: {PHASE_NAME}`
3. Extract the phase name and any parameters (e.g., question number)
4. Cross-reference with `aidlc/sprints/{sprint}/status.md` if it exists

### Detecting Incomplete Phases

| Condition | Interpretation |
|-----------|---------------|
| QUESTIONING but last question has no `**Answer:**` | User hasn't answered yet |
| READY_CHECK but no answer follows | User hasn't confirmed readiness |
| DECOMPOSE but `aidlc/sprints/{sprint}/units/` is empty | Decomposition was interrupted |
| HANDOFF or COMPLETE but status.md shows no work started | User hasn't started implementation |

## Resume Presentation

```markdown
## 🔄 Resuming AIDLC Session

**Sprint:** `aidlc/sprints/{sprint}/`

**Intent:** {original intent, first 2 sentences}

### Session Progress

| Metric | Value |
|--------|-------|
| Current phase | {phase} |
| Questions asked | {N} |
| Questions answered | {M} |
| Decisions recorded | {count} |
| Units generated | {count or "not yet"} |

### Key Decisions So Far

{numbered list of important decisions}

### Where We Left Off

{what was happening when interrupted}

---

> **How would you like to proceed?**
>
> 1. **Continue** from where we left off
>
> 2. **Review** decisions made so far
>
> 3. **Restart** from a specific point
>
> 4. **Skip to decomposition** (if enough context exists)
```

## Recovery Scenarios

### Interrupted During Questioning

1. Check if last question has an answer
2. If no answer: re-present the last question
3. If answer exists but no next question: generate the next one

### Interrupted During Decomposition

1. Check `aidlc/sprints/{sprint}/units/` for generated files
2. If partial: list what was generated and what's missing
3. Offer to regenerate all or just missing units

### Interrupted During Handoff

1. Check `aidlc/sprints/{sprint}/status.md` for progress
2. Present roadmap with current status
3. Ask which unit to work on next

### Corrupted Log

1. Present what you can determine
2. Ask user to confirm current state
3. Append recovery note:

```markdown
## Recovery Note

Session resumed. Previous state: {detected}. User confirmed: {phase}.
```
