# Structure Review

Instructions for an optional, independent review of the unit files and execution
order, offered after the validation report. The review reports findings only; the
user decides what to change.

## Why It Runs Separately

The validator compares units to the elaboration log. It cannot catch a log that is
itself wrong, and the session that wrote the units shares their assumptions. Run
this review as the `aidlc-structure-reviewer` subagent, which starts without the
session history. If the host has no subagents, run it inline and tell the user the
review is not independent.

## Input

- All unit files from `aidlc/units/` and `aidlc/plan.md`
- The decisions in `aidlc/elaboration-log.md`
- The existing codebase, when the intent changes one

## What to Look For

Try to break the cut. Report where it fails once someone builds it:

| Look for | Example |
|----------|---------|
| An assumption the system contradicts | A unit relies on results sorted by price; the search mode in use does not keep that order |
| A seam with no owner | Two units both read a data shape that neither unit defines |
| An order that blocks | Unit 03 needs a data shape that only Unit 05 creates |
| A target the structure cannot meet | An NFR that the chosen data store cannot reach |
| A boundary that will not hold | Two units that must change together on every edit |

Ground each finding in evidence the user can check: a unit file and line, a code
path, or a decision in the log. Label a finding backed only by preference as a
suggestion. Skip anything the validator already checks. Leave every file unchanged.

## Report Format

```markdown
## 🔍 Structure Review

### Findings

- **{Blocking / Worth fixing / Suggestion}** — Unit {NN}: {what breaks}
  - Evidence: {file:line, code path, or log Q{N}}
  - Smallest change: {what to change in the unit file or execution order}

### Verdict

{✅ No blocking findings / ⚠ Blocking findings — review before handoff}
```

## After the Review

Present the findings and ask which to apply. Apply only those the user picks:
regenerate the affected units or execution order, then re-run the validator.
