# Unit and Sprint Completion

Hands the outcome of a unit, and later of the whole sprint, back to the plan, and
keeps what the developer corrected along the way as lessons for the next session.

## When to Run

- **Unit done:** the user says a unit is done, its PR is ready or merged, or a unit
  file's "When this unit is done, run unit-completion." line brings you here.
- **Sprint done:** the user says the sprint is done or asks to close it.

Before anything else, read `aidlc/lessons.md` if it exists and apply it. It sits at
the `aidlc/` root, outside the sprint folders, because lessons carry from one sprint
to the next.

A unit belongs to the sprint folder it lives in: `aidlc/sprints/{sprint}/units/{NN-name}.md`
is a unit of sprint `{sprint}`. If there is no `aidlc/sprints/*/units/` directory,
this is not an AIDLC project: say so and stop. If it is unclear which unit is
meant, ask the user which unit file it is.

## When a Unit Is Done

Record the outcome in the unit's own PR description, and commit any lessons (below)
on the same branch. Leave the sprint's `status.md` and `plan.md` alone here: the
sprint-close PR updates them once, so parallel unit branches never rewrite the same
tables.

```markdown
## Unit Outcome

**Unit:** `aidlc/sprints/{sprint}/units/{NN-name}.md`
**Status:** {Done / Partly done — what is left}
**Shipped:** {what this PR delivers, in one to three lines}
**PR:** {link to this PR}
**Drift from the unit definition:** {stories dropped, added, or changed, and why — or "None"}
```

If there is no PR yet, or you cannot edit it, show this block to the user and ask
them to paste it into the PR.

## Lessons

Offer a lesson only for something the developer corrected during the unit that
would apply next time: a convention, a rule for this project or team. A one-off fix
(a typo, a wrong name, one value in one file) is not a lesson. Read corrections from
this conversation and from the PR's review comments. Ask about each one once:

```markdown
You asked me to {their correction, in their words}. Keep that for next time, for
this project or the team?
```

If the developer already said to keep something ("from now on…", "next time…"),
keep it without asking and say in one line where you put it.

Write each kept lesson as one line in `aidlc/lessons.md` under the topic heading it
fits, creating the heading if needed. The file only grows by appended lines, so when
two unit branches conflict on it, keep both sides.

```markdown
# Lessons

## Corrections

- {the rule, stated as what to do} (learned {YYYY-MM-DD})

## Testing

- {lesson} (learned {YYYY-MM-DD})

## Forbidden

- {what never to do} (learned {YYYY-MM-DD})
```

Tag a lesson kept for the team `(team, learned {YYYY-MM-DD})`.

If the project's `AGENTS.md` does not already have this line, add it (create the
file if it does not exist), so every later session reads the lessons:

```markdown
Before deciding how to plan or build something in this repo, read `aidlc/lessons.md` for lessons from earlier sprints.
```

## When a Sprint Is Done

Close the sprint the user names. Otherwise close the sprint folder whose
`status.md` has no `Closed` row; if there are several, ask which.

Open one sprint-close PR from a branch off main. The team reviews it like code.

1. Compare `aidlc/sprints/{sprint}/plan.md` with what shipped: the Unit Outcome
   blocks of the merged PRs and the git log on main. Note units that shipped, were
   dropped, were added outside the plan, or drifted from their definition.
2. Update the Units table in `aidlc/sprints/{sprint}/status.md` to match, add any
   unit built outside the plan to `aidlc/sprints/{sprint}/plan.md`, and put the
   comparison in the PR description.
3. In `aidlc/sprints/{sprint}/status.md`, set Current Phase to COMPLETE if it is not
   already, and add a `Closed` row with today's date to the Overview table. The
   resume protocol then no longer treats the sprint as open, and the next planning
   session starts a new sprint folder.
4. Merge duplicate lessons in `aidlc/lessons.md`, drop ones that no longer hold, and
   keep the file to about 30 lines.
5. For each lesson tagged `team`, offer to draft it as a proposed change to the
   planning skill the team uses, as an issue or PR on that skill's repository.
