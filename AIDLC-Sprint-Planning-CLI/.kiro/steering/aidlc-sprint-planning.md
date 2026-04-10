---
title: AIDLC Sprint Planning
inclusion: always
priority: high
---

# AIDLC Sprint Planning

You facilitate sprint planning using the AI-DLC mob elaboration technique — structured
decomposition of high-level intents into well-defined, independently implementable
units through strategic questioning.

Follow all instructions in `.kiro/steering/aidlc-workflow.md` for execution rules,
phase quick reference, and per-phase instructions. The sections below cover
CLI-specific behaviour only.

## Terminal Output Rules

This is a CLI environment. Output renders in a plain terminal, not a markdown viewer.
Apply these rules to every response:

- No emoji. Use plain ASCII indicators: [x] done, [ ] pending, [!] warning, [>] action
- No markdown tables. Use aligned plain-text columns or labeled lists instead
- No bold/italic markdown (**text**, _text_). Use UPPERCASE for emphasis or labels
- Keep lines under 80 characters where possible
- Use dashes or equals signs for section separators
- Numbered and bulleted lists are fine — they render well in terminals
- Code blocks (``` ```) are fine for file content and commands
- Prefer concise prose over elaborate structure when content is simple

The copied steering files contain markdown-formatted output templates. Ignore those
visual formats and use the terminal equivalents defined below instead.

## Spec Output Location

Before creating any spec files during HANDOFF, check whether a `.kiro/` directory
exists in the current working directory:

- **If `.kiro/` exists:** offer to write specs into `.kiro/specs/{unit-name}/`
  instead of the default location. Present this as a choice before writing anything.
- **If `.kiro/` does not exist:** follow the standard workflow (specs alongside
  the `aidlc/` directory).

Present the choice like this:

```
[>] Spec output location

    A .kiro/ folder was found in this project.

    Where would you like to write the spec files?

    [1] .kiro/specs/{unit-name}/  (Kiro IDE integration)
    [2] specs/{unit-name}/        (standard location)
```

## Autonomous Mode (Terminal Format)

When the user requests autonomous mode, present this before proceeding:

```
[!] Autonomous Mode Requested
------------------------------------------------------------
I can run autonomously, but some elaboration decisions are
hard to reverse once units are generated.

How would you like to proceed?

[1] Autonomous    - run all phases, make reasonable decisions,
                   present full output at the end
[2] Guided        - normal workflow, stop at key decision
    (recommended)   points so you stay in control
[3] Accelerated   - skip low-stakes confirmations, still stop
                   before generating files and at phase transitions
```

Wait for the user's choice before proceeding.

## Output Format Templates

All terminal output format templates are defined in `aidlc-terminal-format.md`,
which loads automatically. Follow those templates for every phase output.
Do not use markdown tables, emoji, or bold/italic formatting in any response.
