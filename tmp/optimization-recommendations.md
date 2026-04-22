# AIDLC Sprint Planning — LLM Instruction Optimization Recommendations

**Target files:** `common/*.md`, `common/templates/*.md`, `AIDLC-Sprint-Planning-Power/POWER.md`, `AIDLC-Sprint-Planning-Skill/aidlc-sprint-planning/SKILL.md`, `AIDLC-Sprint-Planning-CLI/.kiro/steering/*.md`, `AIDLC-Sprint-Planning-CLI/.kiro/agents/*.json`, `scripts/copy-common.sh`

**Goal:** Tighten instructions so an LLM follows the workflow exactly while minimizing token usage. This document itemizes concrete changes — not a rewrite. Each recommendation includes the rationale, the specific file/location, and a suggested replacement.

**Total source size today:** ~2,800 lines across 24 files. Target after changes: ~2,000 lines with significantly better instruction-following reliability.
## Executive Summary

The instruction set is **over-specified** in many places and **under-specified** in others. Key issues:

1. **Duplication across files** — The same rules appear in workflow.md, state-machine.md, and POWER.md with slight variations, creating drift risk and token waste.

2. **Vague instructions** — Phrases like "use your judgment", "follow the strategy", "apply the selected strategy" leave too much to LLM interpretation.

3. **Missing concrete templates** — Output formats (questions, status dashboards, validation reports) are described in prose but not provided as concrete templates.

4. **Negative framing** — Overuse of "do not", "never", "don't" instead of positive "always" instructions.

5. **Inconsistent terminology** — "mob elaboration", "sprint planning", "elaboration session" used interchangeably.

6. **Build script inconsistency** — The CLI build copies templates to `.kiro/templates/` but the POWER build now puts them in `steering/` — the agent instructions don't reflect this divergence.

---

## Critical Issues (blocks correct LLM behavior)

### Issue 1: State machine has no explicit entry/exit conditions

**Location:** `common/state-machine.md` (lines 1-100)

**Problem:** The state machine table shows transitions but doesn't define *when* to trigger each transition. The LLM must infer this from prose in workflow.md, creating ambiguity.

**Example:** Under "Phase: QUESTIONING", it says "If enough → READY_CHECK" but doesn't define "enough". The complexity-rubric.md has depth guidelines, but the state machine doesn't reference them.

**Fix:** Add explicit exit criteria to each phase in state-machine.md:

```markdown
## Phase: QUESTIONING

**Entry:** User confirmed depth, or returned from READY_CHECK.

**Exit criteria (any one triggers transition):**
- User explicitly asks to decompose
- Question count reaches estimated_total (from complexity-rubric depth)
- All categories in complexity-rubric have been covered

**Actions per turn:**
...
```

**Impact:** Eliminates ~50 lines of ambiguous prose in workflow.md that duplicate this logic.

---

### Issue 2: Question generation has no concrete template

**Location:** `common/workflow.md` (lines 120-140)

**Problem:** The QUESTIONING phase says "Format each question:" and shows a markdown template, but the *content* of the question is left to the LLM. There's no guidance on question structure, category mapping, or how to derive questions from answers.

**Example:** "Adapt based on all previous answers — do not follow a rigid category order" is vague. What does "adapt" mean? How many questions per category? What's the fallback if an answer doesn't close a category?

**Fix:** Add a concrete question template to `common/complexity-rubric.md`:

```markdown
## Question Template

Each question must include:
1. **Category tag:** [Users] [Scope] [Functionality] [Data] [Integration] [NFRs] [Risks]
2. **Question type:** Clarification | Decision | Constraint | Boundary
3. **Suggested answers (2-3):** Only for technology/scale decisions
4. **Follow-up trigger:** What answer would close this question?

Format:
  ```
  ## [Category] Question {N} of ~{estimated_total}

  {Question text}

  {Optional: suggested answers}

  ---
  📊 **Progress:** {answered}/{estimated_total} · 📋 **Decisions recorded:** {count}
  ```
```
**Impact:** Reduces LLM token waste on question generation and ensures consistency.

---

### Issue 3: Validation report format is described but not enforced

**Location:** `common/validator.md` (lines 20-40)

**Problem:** The report format shows a markdown table, but the LLM must fill in `{count}` and `{detailed findings}`. There's no guidance on how to count issues or what "thorough but not pedantic" means.

**Fix:** Add a validation checklist template to `common/validator.md`:

```markdown
## Validation Checklist

For each check, apply these rules:

| Check | Rule for counting issues |
|-------|--------------------------|
| Decision Coverage | Count questions in log without `**Answer:**` or answers not in any unit |
| Dependency Ordering | Count cycles, or unit 01 with dependencies |
| Functionality Gaps | Count intent functionality not covered by any unit |
| Bounded Context Integrity | Count overlapping units (same data ownership, change frequency) |
| NFR Completeness | Count NFR targets from questioning not in any unit |
| Plan Consistency | Count units missing from execution order, or merge sequence conflicts |

**Findings format:** List each issue as:
- Unit {N}: {description}
- Log line {X}: {description}

**Verdict:** If any count > 0, mark as ⚠️ and list top 3 issues.
```

**Impact:** Ensures consistent validation output and reduces LLM hallucination on "thorough but not pedantic".

---

### Issue 4: POWER.md and SKILL.md have conflicting instructions

**Location:** `AIDLC-Sprint-Planning-Power/POWER.md` vs `AIDLC-Sprint-Planning-Skill/aidlc-sprint-planning/SKILL.md`

**Problem:** POWER.md says "Templates live in `templates/`" (now `steering/template-*.md`), but SKILL.md says "Templates live in `assets/`". The build script copies them differently for each target, but the agent instructions don't reflect this divergence.

**Fix:** Remove template path references from agent instructions. Instead, reference the templates by name only:

```markdown
Use the templates from the power's `steering/` directory:
- `template-elaboration-log-template.md` → `aidlc/elaboration-log.md`
- `template-status-template.md` → `aidlc/status.md`
- `template-unit-template.md` → each `aidlc/units/NN-name.md`
- `template-plan-template.md` → `aidlc/plan.md`
```

Then add a build-time note in `scripts/copy-common.sh` comments explaining the path mapping.

**Impact:** Eliminates 20+ lines of duplicated template path instructions across files.

---

### Issue 5: "mob elaboration" vs "sprint planning" terminology drift

**Location:** All files, especially `common/workflow.md`, `common/spec-handoff.md`, `AIDLC-Sprint-Planning-Power/POWER.md`

**Problem:** The terms are used inconsistently:
- "mob elaboration session" vs "sprint planning session"
- "mob elaboration technique" vs "sprint planning approach"
- "mob elaboration questions" vs "sprint planning questions"

**Fix:** Standardize terminology:
- **"mob elaboration"** = the technique (questioning approach)
- **"sprint planning"** = the context (when the technique is applied)
- **"elaboration log"** = the session artifact (not "sprint planning log")

Use this pattern:
- "Apply the mob elaboration technique during sprint planning"
- "Record answers in the elaboration log"
- " mob elaboration questions" (not "sprint planning questions")

**Impact:** Reduces LLM confusion about when to use which term.

---

### Issue 6: Missing concrete templates for output formats

**Location:** `common/workflow.md`, `common/resume-protocol.md`, `common/validator.md`

**Problem:** Output formats are described in prose but not provided as concrete templates. The LLM must invent the structure, leading to drift.

**Fix:** Add a "Output Templates" section to `common/workflow.md`:

```markdown
## Output Templates

### Question Template
[See `common/complexity-rubric.md`]

### Status Dashboard Template
```
# AIDLC Session Status

## Overview
| Field | Value |
|-------|-------|
| Intent | {short description} |
| Complexity | {rating} |
| Current Phase | {phase} |
| Started | {date} |
| Last Updated | {date} |

## Progress
| Metric | Value |
|--------|-------|
| Questions asked | {N} |
| Questions answered | {M} |
| Decisions recorded | {count} |
| Units generated | {count or "not yet"} |
```

### Validation Report Template
[See `common/validator.md`]

### Resume Presentation Template
[See `common/resume-protocol.md`]
```

**Impact:** Ensures consistent output format and reduces LLM token waste on format invention.

---

### Issue 7: Build script has inconsistent template handling

**Location:** `scripts/copy-common.sh` (lines 60-100)

**Problem:** The build script copies templates to different locations for each target:
- Power: `steering/template-*.md` (new, after optimization)
- Skill: `assets/*.md` (unchanged)
- CLI: `.kiro/templates/*.md` (unchanged)

But the agent instructions in POWER.md reference `steering/template-*.md`, while SKILL.md references `assets/*.md`, and CLI references `.kiro/templates/*.md`. This is correct, but the build script doesn't validate that the paths match.

**Fix:** Add a build-time validation step in `scripts/copy-common.sh`:

```bash
# Validate template paths match agent instructions
if [[ ! -f "$src_dir/steering/template-elaboration-log-template.md" ]]; then
  echo "ERROR: POWER.md expects templates in steering/, but template not found"
  exit 1
fi
```

**Impact:** Catches build-time errors before they reach users.

---

## High-Value Optimization Opportunities (Top 10)

### 1. Consolidate state machine and workflow

**File:** `common/state-machine.md` + `common/workflow.md`

**Current:** 209 + 331 = 540 lines, with significant overlap.

**After:** Merge state machine into workflow.md as a "Phase Transitions" section. Remove duplicate phase descriptions.

**Savings:** ~150 lines.

---

### 2. Add concrete question templates to complexity-rubric.md

**File:** `common/complexity-rubric.md`

**Current:** 73 lines, describes question strategy but no concrete format.

**After:** Add "Question Template" section with exact format and category tags.

**Savings:** ~20 lines (removes need for LLM to invent format).

---

### 3. Add validation checklist to validator.md

**File:** `common/validator.md`

**Current:** 48 lines, describes report format but no counting rules.

**After:** Add "Validation Checklist" section with counting rules.

**Savings:** ~15 lines.

---

### 4. Remove duplicate template path instructions

**Files:** `AIDLC-Sprint-Planning-Power/POWER.md`, `AIDLC-Sprint-Planning-Skill/aidlc-sprint-planning/SKILL.md`

**Current:** ~40 lines across both files.

**After:** Reference templates by name only, move path details to build script comments.

**Savings:** ~30 lines.

---

### 5. Standardize terminology in all files

**Files:** All `.md` files

**Current:** ~50 instances of inconsistent "mob elaboration" vs "sprint planning".

**After:** Replace with standardized pattern.

**Savings:** ~10 lines (fewer words, less repetition).

---

### 6. Add output templates section to workflow.md

**File:** `common/workflow.md`

**Current:** No dedicated output template section.

**After:** Add "Output Templates" section referencing other files.

**Savings:** ~20 lines (removes need for LLM to invent formats).

---

### 7. Add build-time validation to copy-common.sh

**File:** `scripts/copy-common.sh`

**Current:** No validation of template paths.

**After:** Add validation step.

**Savings:** Prevents user-facing errors (no line savings, but higher quality).

---

### 8. Replace negative framing with positive framing

**Files:** `common/workflow.md`, `AIDLC-Sprint-Planning-Power/POWER.md`

**Current:** ~30 instances of "do not", "never", "don't".

**After:** Replace with "Always X" or "Do X" where possible.

**Savings:** ~5 lines (more concise).

---

### 9. Remove redundant phase descriptions

**Files:** `common/workflow.md`, `common/state-machine.md`

**Current:** Same phase descriptions appear in both files.

**After:** Keep only in state-machine.md, reference from workflow.md.

**Savings:** ~100 lines.

---

### 10. Add error recovery examples to state-machine.md

**File:** `common/state-machine.md`

**Current:** Error recovery section is brief.

**After:** Add concrete examples of corrupted log recovery.

**Savings:** ~10 lines (more precise instructions).

---

## Duplication Map

| Concept | Files | Line Count | Recommendation |
|---------|-------|------------|----------------|
| Phase quick reference table | workflow.md, state-machine.md | ~30 | Keep in state-machine.md, reference from workflow.md |
| Question format | workflow.md, complexity-rubric.md | ~20 | Keep in complexity-rubric.md, reference from workflow.md |
| Validation report format | validator.md, workflow.md | ~25 | Keep in validator.md, reference from workflow.md |
| Resume presentation | resume-protocol.md, workflow.md | ~30 | Keep in resume-protocol.md, reference from workflow.md |
| Template paths | POWER.md, SKILL.md | ~40 | Remove from both, reference by name only |
| State machine transitions | state-machine.md | ~20 | Keep only here |
| Complexity factors | complexity-rubric.md | ~15 | Keep only here |
| Team topology questions | team-topology.md | ~50 | Keep only here |
| Unit format | unit-format.md | ~30 | Keep only here |
| EARS notation | unit-format.md | ~15 | Keep only here |

---

## Token Compression Opportunities

### 1. Workflow.md "Formatting" section

**Original (lines 50-60):**
```markdown
Format all responses for a rich user interface experience:

- Use clear section headers to separate phases and steps
- Present all options on separate lines, numbered, with a brief description
- Use **bold** for labels, phase names, and key terms
- Use emoji section markers where the interface supports them (🎯 📊 ❓ ✅ 🚀 📄)
- Use tables for structured data (assessments, unit lists, coverage checks)
- Use progress indicators to show where the user is in the session
- Keep prose concise — structure does the heavy lifting
```

**Tightened:**
```markdown
Format all responses:
- Headers, numbered options, bold labels
- Emoji only where supported (🎯 📊 ❓ ✅ 🚀 📄)
- Tables for structured data
- Progress indicators
- Keep prose concise — structure does the heavy lifting
```

**Savings:** ~10 lines.

---

### 2. Complexity-rubric.md "Question Strategy" section

**Original (lines 50-70):**
```markdown
### Adaptive Questioning

Don't rigidly march through categories:

1. Start with the category that has the most ambiguity
2. Follow threads opened by user answers
3. If an answer closes a category, skip it
4. If an answer opens a new concern, pursue it immediately
5. Circle back to uncovered categories before READY_CHECK

### When to Suggest Answers

Suggest 2-3 possible answers when:
- The question involves a technology choice
- The question involves a scale/scope decision
- The user might not know the options available

Don't suggest answers when:
- The question is about domain knowledge only the user has
- Suggesting answers might anchor the user to options they wouldn't consider

### When to Recommend

If you'd strongly recommend something the user hasn't mentioned:

> "Based on {reason}, I'd strongly recommend considering {thing}. Want me to include it?"

Never silently add recommendations to units.

### DDD Principles During Questioning

Look for signals that help identify bounded contexts:
- Different data ownership patterns
- Different change frequencies
- Different team ownership
- Different scaling requirements
- Different deployment cadences
- Natural language boundaries (different vocabulary for different parts)
```

**Tightened:**
```markdown
### Adaptive Questioning

Follow threads from answers. Skip closed categories. Pursue new concerns immediately. Circle back before READY_CHECK.

### Suggest Answers When:
- Technology choice
- Scale/scope decision
- User might not know options

### Never Suggest When:
- Domain knowledge (user-only)
- Anchoring risk

### Recommend Strongly:
> "Based on {reason}, I'd recommend {thing}. Want me to include it?"

### Bounded Context Signals:
Different data ownership, change frequency, team ownership, scaling, deployment cadence, vocabulary boundaries.
```

**Savings:** ~30 lines.

---

### 3. Validator.md "Validation Checks" section

**Original (lines 10-20):**
```markdown
## Validation Checks

1. **Decision Coverage** — Every question/answer from the log is reflected in a unit.
2. **Dependency Ordering** — Unit 01 has no deps, no circular deps, valid DAG.
3. **Functionality Gaps** — All intent functionality is covered by units.
4. **Bounded Context Integrity** — No significant overlap between units.
5. **NFR Completeness** — All NFR targets from questioning appear in units.
6. **Plan Consistency** — `aidlc/plan.md` exists; merge sequence matches the
   dependency graph; every unit appears in the execution order table.
```

**Tightened:**
```markdown
## Validation Checks

1. Decision Coverage: Every log Q/A in a unit
2. Dependency Ordering: Unit 01 has no deps, no cycles, valid DAG
3. Functionality Gaps: All intent covered by units
4. Bounded Context Integrity: No significant overlap
5. NFR Completeness: All NFR targets in units
6. Plan Consistency: plan.md exists, merge sequence matches DAG, all units in execution order
```

**Savings:** ~10 lines.

---

### 4. Team Topology.md "Decomposition Strategies" section

**Original (lines 60-150):**
```markdown
### Strategy A: Vertical Slices (Full-Stack, Demo-Driven)

**When to use:**

- Single full-stack team
- Each unit should be demoable end-to-end
- Team prefers seeing working software at each milestone

**How to decompose:**

- Each unit delivers a complete user-facing capability: UI + API + data layer
- Units are ordered by user value, not technical dependency
- A unit is "done" when a user can interact with it in a running system
- Shared infrastructure (auth, observability) gets its own foundational unit first

**Example shape:**

```
01-foundation        (auth, DB schema, shared infra)
02-user-onboarding   (registration UI + API + email)
03-core-workflow     (main feature, full vertical slice)
04-reporting         (dashboard UI + query API)
```
```

**Tightened:**
```markdown
### Strategy A: Vertical Slices

**Use when:** Single full-stack team, demoable units, milestone-driven.

**Decompose:** Each unit = UI + API + data layer. Order by user value. Done = user can interact. Shared infra = foundational unit.

**Example:**
```
01-foundation        (auth, DB schema, shared infra)
02-user-onboarding   (registration UI + API + email)
03-core-workflow     (main feature, full vertical slice)
04-reporting         (dashboard UI + query API)
```
```

**Savings:** ~20 lines per strategy × 6 strategies = ~120 lines.

---

## Ambiguity and Contradiction Report

### Ambiguity 1: "Enough context" in QUESTIONING

**Location:** `common/state-machine.md` (line 50)

**Problem:** "If enough → READY_CHECK" — what is "enough"? The complexity-rubric.md has depth guidelines, but the state machine doesn't reference them.

**Resolution:** Add explicit exit criteria to state-machine.md (see Issue 1).

---

### Ambiguity 2: "Thorough but not pedantic" in validator

**Location:** `common/validator.md` (line 25)

**Problem:** Subjective. What counts as "pedantic"?

**Resolution:** Add concrete counting rules (see Issue 3).

---

### Contradiction 1: Template location

**Location:** POWER.md vs SKILL.md

**Problem:** POWER.md says `templates/`, SKILL.md says `assets/`. The build script now puts them in `steering/` for POWER.

**Resolution:** Remove path references, use name-only (see Issue 4).

---

## Missing Instructions

### Missing 1: Error recovery examples

**Location:** `common/state-machine.md`

**Problem:** Error recovery section is brief. No concrete examples of corrupted log recovery.

**Add:** Concrete examples of:
- Question without answer
- Phase marker without content
- Empty units after DECOMPOSE

---

### Missing 2: Validation failure response

**Location:** `common/validator.md`

**Problem:** No guidance on what to do if validation fails.

**Add:** "If validation fails, offer to regenerate or adjust the plan."

---

### Missing 3: Handoff gate verification steps

**Location:** `common/spec-handoff.md`

**Problem:** The handoff gate says "Do NOT suggest implementation until ALL of the following are true" but doesn't say what to do if they're not true.

**Add:** "If the handoff gate is not met, explain which condition is missing and what needs to happen first."

---

## Structural Recommendations

### 1. Merge state machine into workflow.md

**Rationale:** The state machine is the "when" of the workflow. They're currently separate, causing duplication.

**Action:** Move state machine to workflow.md as a "Phase Transitions" section. Remove state-machine.md.

**Files to update:**
- workflow.md (add state machine section)
- All references to `state-machine.md` → `workflow.md` (Phase Transitions section)

---

### 2. Create a "Templates" reference file

**Rationale:** Output templates are scattered across files. Centralize them.

**Action:** Create `common/templates.md` with all output templates. Reference from workflow.md.

**Files to update:**
- workflow.md (add reference to templates.md)
- All template references → `templates.md`

---

### 3. Add a "Terminology" reference file

**Rationale:** Terminology drift causes confusion.

**Action:** Create `common/terminology.md` with:
- "mob elaboration" = technique
- "sprint planning" = context
- "elaboration log" = artifact

**Files to update:**
- All files (reference terminology.md)

---

### 4. Split team-topology.md into per-strategy files

**Rationale:** The 6 strategies are independent. Splitting reduces token usage when only one strategy is needed.

**Action:** Create:
- `common/strategy-a-vertical-slices.md`
- `common/strategy-b-horizontal-layers.md`
- `common/strategy-c-risk-first.md`
- `common/strategy-d-parallel-streams.md`
- `common/strategy-e-complexity-calibrated.md`
- `common/strategy-f-domain-team-alignment.md`

**Files to update:**
- team-topology.md (reference strategy files)
- All strategy references → individual files

---

## Build Script Observations

### Observation 1: CLI build copies templates to `.kiro/templates/`

**Location:** `scripts/copy-common.sh` (lines 150-160)

**Current:** CLI copies templates to `.kiro/templates/`.

**Issue:** The CLI agent instructions don't reference this path. They reference `.kiro/steering/` for other files.

**Resolution:** This is correct — CLI uses `.kiro/templates/` while Power uses `steering/template-*.md`. The agent instructions should reflect this divergence.

**Action:** Add a comment in `scripts/copy-common.sh` explaining the path mapping.

---

### Observation 2: No validation of template paths

**Location:** `scripts/copy-common.sh`

**Current:** No validation.

**Issue:** If a template is missing, the build succeeds but the power is broken.

**Resolution:** Add validation step (see Issue 7).

---

## Summary

**Total current size:** ~2,800 lines

**Estimated savings from these changes:** ~800 lines (28% reduction)

**Expected improvement in LLM instruction-following:** High — concrete templates, explicit exit criteria, and reduced ambiguity should significantly improve reliability.

**Next steps:**
1. Implement high-value optimizations (Issues 1-3, 5, 7)
2. Run build script to verify no regressions
3. Test with sample inputs to validate improved instruction-following
4. Iterate based on test results