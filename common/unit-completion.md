# Unit and Sprint Completion

Hands the outcome of a unit, and later of the whole sprint, back to the plan, and
keeps what the developer corrected along the way as lessons for the next session.

## When to Run

- **Unit done:** the user says a unit is done, its PR is ready or merged, or a unit
  file's "When this unit is done, run unit-completion." line brings you here.
- **Sprint done:** the user says the sprint is done or asks to close it.

If it is unclear which unit is meant, ask the user which file in `aidlc/units/` it is.

## Read Lessons First

Before anything else, read `aidlc/lessons.md` if it exists and apply it.

## When a Unit Is Done

Record the outcome in the unit's own PR description, and commit any lessons (below)
on the same branch. Write nothing to `aidlc/status.md` or `aidlc/plan.md` here: the
sprint-close PR does that once, so unit branches never edit them in parallel.

```markdown
## Unit Outcome

**Unit:** `aidlc/units/{NN-name}.md`
**Status:** {Done / Partly done — what is left}
**Shipped:** {what this PR delivers, in one to three lines}
**PR:** {link to this PR}
**Drift from the unit definition:** {stories dropped, added, or changed, and why — or "None"}
```

If there is no PR yet, show this block to the user and ask them to paste it into
the PR when they open it.

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
fits, creating the heading if needed:

```markdown
# Lessons

## Corrections

- {the rule, stated as what to do} (learned {YYYY-MM-DD})

## Testing

- {lesson} (learned {YYYY-MM-DD})

## Forbidden

- {what never to do} (learned {YYYY-MM-DD})
```

A lesson kept "for the team" also goes in the file, and is offered as a change to
the planning skill at sprint close.

The first time you write `aidlc/lessons.md`, add this line to the project's
`AGENTS.md` (create the file if it does not exist), so every later session reads it:

```markdown
Before deciding how to plan or build something in this repo, read `aidlc/lessons.md` for lessons from earlier sprints.
```

## When a Sprint Is Done

Open one sprint-close PR from a branch off main. The team reviews it like code.

1. Compare `aidlc/plan.md` with what shipped: the Unit Outcome blocks of the merged
   PRs and the git log on main. Note units that shipped, were dropped, were added
   outside the plan, or drifted from their definition.
2. Update the Units table in `aidlc/status.md` to match, and put the comparison in
   the PR description.
3. Merge duplicate lessons in `aidlc/lessons.md`, drop ones that no longer hold, and
   keep the file to about 30 lines.
4. For each lesson that would apply beyond this project, offer to draft it as an
   issue or PR against the planning skill's own repository.
