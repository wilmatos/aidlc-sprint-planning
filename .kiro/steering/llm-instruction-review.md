---
title: "LLM Instruction Review"
inclusion: manual
priority: high
---

# LLM Instruction Review — Code Review for Markdown Prompts

Use this skill when reviewing markdown files that serve as instructions for LLMs:
steering files, POWER.md, SKILL.md, agent system prompts, hook prompts, or any
markdown that an LLM will consume as behavioral guidance.

## When to Activate

- Reviewing a PR/CR that modifies steering files, prompts, or agent instructions
- Auditing an existing instruction set for quality
- Before publishing a Power, Skill, or steering package
- After observing unexpected LLM behavior traceable to instruction quality

## Review Checklist

Evaluate every instruction file against these 12 dimensions. Rate each as
✅ Pass, ⚠️ Needs attention, or ❌ Fails.

---

### 1. Clarity and Specificity

| Check | Pass criteria |
|-------|--------------|
| Every directive is actionable | No vague phrases like "use good judgment", "be thorough", "handle appropriately" |
| Concrete examples for ambiguous rules | If a rule could be interpreted multiple ways, an example disambiguates |
| Measurable criteria where possible | "Ask 3-5 questions" not "ask some questions"; "< 80 chars" not "keep lines short" |
| No orphaned references | Every "see X" or "read the Y reference" points to a file that exists |

**Red flags:** "as appropriate", "when needed", "use best practices", "be reasonable"

---

### 2. Positive Framing

| Check | Pass criteria |
|-------|--------------|
| Directives state what TO do | "Always wait for confirmation" not "Don't proceed without confirmation" |
| Negative framing only for hard constraints | "Do NOT modify production data" is acceptable for safety |
| No double negatives | "Never not-X" → "Always X" |

**Metric:** Count `do not` / `don't` / `never` instances. Target: < 5 per file.
Each remaining negative should be a genuine safety constraint.

---

### 3. Token Efficiency

| Check | Pass criteria |
|-------|--------------|
| No redundant prose | Each sentence adds information the LLM needs to act correctly |
| Tables over prose for structured data | If content has 3+ parallel items with attributes, use a table |
| No repeated instructions across files | Each rule has one canonical location; others reference it |
| Inline examples are minimal | Show the pattern once, not 5 variations |

**Metric:** Lines per file. Targets:
- Workflow/orchestration: < 500 lines
- Reference/lookup: < 200 lines
- Template: < 50 lines

---

### 4. Structure and Navigability

| Check | Pass criteria |
|-------|--------------|
| Clear heading hierarchy | H1 = file title, H2 = major sections, H3 = subsections |
| Scannable for phase/context | An LLM can find "what to do in phase X" without reading the whole file |
| Logical section ordering | Setup → Rules → Per-phase details → Templates → Error handling |
| No buried critical rules | Important constraints are near the top, not hidden in prose |

---

### 5. State Machine Integrity (if applicable)

| Check | Pass criteria |
|-------|--------------|
| Every state has entry conditions | "Entry: X happened" |
| Every state has exit criteria | "Exit when: A or B or C" — concrete, testable |
| Transitions are exhaustive | No state where the LLM could get stuck with no valid next action |
| Error/recovery paths defined | What to do when state is corrupted or ambiguous |

---

### 6. Output Format Specification

| Check | Pass criteria |
|-------|--------------|
| Every user-facing output has a template | Concrete markdown/text template with placeholders |
| Templates use consistent placeholder syntax | `{variable_name}` throughout, not mixed with `<variable>` or `$variable` |
| Format matches the rendering environment | Markdown for rich UIs, plain text for terminals |
| No "invent a format" instructions | Always reference a template; never say "present this clearly" |

---

### 7. Terminology Consistency

| Check | Pass criteria |
|-------|--------------|
| Key terms defined in one place | A terminology file or glossary section exists |
| Same concept uses same word everywhere | Not "unit" in one file and "module" in another for the same thing |
| No ambiguous overloaded terms | If "session" means two things, disambiguate with qualifiers |

---

### 8. Intent Classifier Safety (Kiro-specific)

| Check | Pass criteria |
|-------|--------------|
| Pre-handoff content avoids spec trigger words | No `spec`, `specification`, `requirement`, `design`, `plan`, `architecture`, `implementation`, `user story`, `feature`, `component`, `task`, `use case`, `api`, `schema` in non-HANDOFF phases |
| Questions framed with safe vocabulary | Agent questions don't prompt users to respond with trigger words |
| HANDOFF phase explicitly uses spec language | Spec mode should trigger only when appropriate |

---

### 9. Conditional Logic Clarity

| Check | Pass criteria |
|-------|--------------|
| If/then/else is explicit | "If X, do Y. Otherwise, do Z." — not buried in prose |
| Conditions are testable | The LLM can evaluate the condition from available context |
| No implicit conditions | Every branch is stated; no "obvious" defaults left unstated |
| Edge cases addressed | What happens when the condition is ambiguous or partially met? |

---

### 10. Cross-File Consistency

| Check | Pass criteria |
|-------|--------------|
| No contradictions between files | Same rule doesn't say different things in different locations |
| References are bidirectional | If A references B, B's content supports A's claim |
| Shared concepts have one source of truth | Duplicated content is flagged as a drift risk |
| Build script produces consistent output | Generated files match source instructions |

---

### 11. Subagent/Delegation Clarity (if applicable)

| Check | Pass criteria |
|-------|--------------|
| Each subagent has a clear scope | What it does, what it reads, what it writes |
| Input/output contracts defined | What the subagent receives and what it returns |
| No overlapping responsibilities | Two subagents don't do the same thing |
| Invocation is explicit | "Invoke X" not "delegate to the appropriate agent" |

---

### 12. Resilience and Error Handling

| Check | Pass criteria |
|-------|--------------|
| Recovery paths for common failures | Corrupted state, missing files, interrupted sessions |
| Graceful degradation | If a reference file is missing, the agent can still function |
| No silent failures | Every error condition has a user-visible response |
| Retry/escalation guidance | When to retry vs. when to ask the user |

---

## Review Report Format

After evaluating all 12 dimensions, produce this report:

```markdown
## 📋 LLM Instruction Review — {file or package name}

### Summary

| Dimension | Rating | Issues |
|-----------|--------|--------|
| Clarity and Specificity | ✅/⚠️/❌ | {count} |
| Positive Framing | ✅/⚠️/❌ | {count} |
| Token Efficiency | ✅/⚠️/❌ | {count} |
| Structure and Navigability | ✅/⚠️/❌ | {count} |
| State Machine Integrity | ✅/⚠️/❌ | {count} |
| Output Format Specification | ✅/⚠️/❌ | {count} |
| Terminology Consistency | ✅/⚠️/❌ | {count} |
| Intent Classifier Safety | ✅/⚠️/❌ | {count} |
| Conditional Logic Clarity | ✅/⚠️/❌ | {count} |
| Cross-File Consistency | ✅/⚠️/❌ | {count} |
| Subagent/Delegation Clarity | ✅/⚠️/❌ | {count} |
| Resilience and Error Handling | ✅/⚠️/❌ | {count} |

### Critical Issues (must fix before shipping)

{numbered list with file, line, issue, suggested fix}

### Warnings (should fix)

{numbered list}

### Suggestions (nice to have)

{numbered list}

### Verdict

{✅ Ready to ship / ⚠️ Fix critical issues first / ❌ Significant rework needed}
```

## Common Anti-Patterns in LLM Instructions

| Anti-pattern | Example | Fix |
|-------------|---------|-----|
| Vague delegation | "Handle this appropriately" | Specify exact action and format |
| Implicit defaults | "Use the standard approach" | State the approach explicitly |
| Prose where tables work | 6 paragraphs describing 6 options | One table, 6 rows |
| Repeated rules | Same constraint in 3 files | One source, two references |
| Negative-only rules | "Don't do X, don't do Y, don't do Z" | "Always do A" (positive framing) |
| Missing error paths | Happy path only | Add "If X fails, do Y" |
| Overloaded files | 500+ line file covering 8 concerns | Split into focused files |
| Buried critical rules | Safety constraint on line 347 | Move to top-level section |
| Format invention | "Present this in a clear way" | Provide exact template |
| Trigger word contamination | "Let's design the API spec" in pre-HANDOFF | Use safe vocabulary |

## When to Fail a Review

Automatically fail (❌) if any of these are true:

1. A state machine has a state with no exit criteria
2. A user-facing output has no template
3. Two files contradict each other on the same rule
4. A safety constraint uses vague language ("be careful with...")
5. The file exceeds 500 lines without clear justification
6. Spec-trigger words appear in pre-HANDOFF agent responses
