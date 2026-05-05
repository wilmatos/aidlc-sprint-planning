# Comprehensive Code Review — AIDLC Sprint Planning

**Reviewed against:** MCP best practices, LLM instruction quality, modularity, security, clarity
**Scope:** All files in common/, implementation entry points, build script, CI pipelines
**Date:** 2026-05-05

---

## Overall Assessment: ⚠️ Good with improvements needed

The repo is well-structured with strong modularity (single source of truth in common/,
three client-specific builds). The instruction quality is above average for LLM steering
files. However, there are issues in MCP-adjacent patterns, security, and a few structural
gaps that should be addressed.

---

## 1. Modularity — ✅ Strong

| Criterion | Rating | Notes |
|-----------|--------|-------|
| Bounded context per file | ✅ | Each file owns one concern (workflow, topology, validation, etc.) |
| < 10 tools/concerns per server | ✅ | 4 subagents, each with 1 job |
| Single source of truth | ✅ | common/ is canonical; implementations are generated |
| Read/write separation | ✅ | validator and requirements-validator are read-only; decomposer and spec-elaborator write |

**Strengths:**
- Strategy files split into individual files (strategy-a through strategy-f)
- Templates separated from logic
- Build script generates all three targets from one source

**Issue:** `common/workflow.md` at 500 lines is at the upper limit. Consider whether the
Output Template Reference table and Error Recovery section could be extracted.

---

## 2. Security — ⚠️ Needs attention

| Criterion | Rating | Notes |
|-----------|--------|-------|
| Input validation | ⚠️ | No guidance on validating user input before writing to files |
| Path traversal prevention | ⚠️ | Unit file naming uses user-derived names without sanitization rules |
| Scope containment | ✅ | Subagents have explicit tool restrictions (read-only vs read/write) |
| Secret handling | ✅ | No secrets in any instruction file |

**Issues:**

1. **Unit file naming has no sanitization rule** (common/unit-format.md)
   - The naming convention says "two-digit prefix + kebab-case" but doesn't specify
     what to do if the user's intent contains characters that are unsafe for filenames
   - **Fix:** Add a sanitization rule: "Strip all characters except a-z, 0-9, and hyphens.
     Truncate to 40 characters. Reject names that start with `.` or contain `..`"

2. **No file write boundary** (common/decomposer.md)
   - The decomposer writes to `aidlc/units/` and `aidlc/plan.md` but there's no
     explicit constraint preventing writes outside the `aidlc/` directory
   - **Fix:** Add: "Write only to the `aidlc/` directory. Reject any path that resolves
     outside `aidlc/`."

3. **Build script uses `local` in loops** (scripts/copy-common.sh)
   - `local filename` inside a `for` loop is a bashism that works but is technically
     undefined behavior in POSIX sh. Since the shebang is `#!/usr/bin/env bash` this
     is fine, but worth noting for portability.

---

## 3. Agent-Friendly Implementation — ✅ Strong

| Criterion | Rating | Notes |
|-----------|--------|-------|
| Descriptive naming | ✅ | Subagent names are clear: aidlc-decomposer, aidlc-validator |
| Detailed descriptions | ✅ | Each subagent has a multi-line description explaining when to use it |
| Structured output | ✅ | All outputs use markdown tables and templates |
| Error messages | ✅ | Validation report format includes specific issue descriptions |

**Strengths:**
- Question template in complexity-rubric.md specifies exact format
- Validation counting rules eliminate ambiguity
- Error recovery table maps conditions to specific actions

---

## 4. Clarity for LLMs — ⚠️ Minor issues

| Criterion | Rating | Notes |
|-----------|--------|-------|
| Explicit conditionals | ✅ | Exit criteria use "any one triggers" / "all required" |
| No vague delegation | ⚠️ | 2 instances remain |
| Positive framing | ✅ | workflow.md has 0 negatives; remaining negatives are safety constraints |
| Consistent terminology | ✅ | terminology.md defines all key terms |

**Remaining vague phrases:**

1. `common/decomposer.md` line 30: "Apply the selected strategy when determining unit
   boundaries, ordering, and naming" — what does "apply" mean concretely? The strategy
   files define this, but the decomposer should say "Read the selected strategy file
   and follow its decomposition rules."

2. `AIDLC-Sprint-Planning-Power/POWER.md` line 115: "Spec Reference section (boilerplate —
   do not act on it during decomposition)" — "boilerplate" is vague. Replace with
   "This section is included in every unit file but is only relevant during HANDOFF."

---

## 5. State Machine Integrity — ✅ Pass

| Criterion | Rating | Notes |
|-----------|--------|-------|
| Every state has entry conditions | ✅ | All 9 phases have explicit entry |
| Every state has exit criteria | ✅ | QUESTIONING, READY_CHECK, TEAM_TOPOLOGY have concrete criteria |
| Transitions are exhaustive | ✅ | No dead-end states |
| Error recovery defined | ✅ | 5-row recovery table covers common failures |

**One gap:** The COMPLETE phase has no actions defined. It should specify:
- Update status.md to mark session complete
- Present a session summary (total questions, units generated, time elapsed)

---

## 6. Cross-File Consistency — ⚠️ Minor drift

| Issue | Location | Description |
|-------|----------|-------------|
| README references `state-machine.md` | README.md line ~60 | File was deleted in HVO #1; README still lists it in the Power package contents |
| Decomposer duplicates strategy summaries | common/decomposer.md lines 28-50 | Same content exists in team-topology.md; decomposer should reference it |
| POWER.md subagent still says "Spec Reference section" | POWER.md line 115 | Should be "Implementation Reference section" to match the template rename |

---

## 7. Build Script — ✅ Solid

| Criterion | Rating | Notes |
|-----------|--------|-------|
| Source validation | ✅ | validate_sources() checks all 11 logic files + 4 templates |
| Consistent output structure | ✅ | Each target gets the right files in the right locations |
| Idempotent | ✅ | rm -rf stage before building ensures clean output |
| Error handling | ✅ | set -euo pipefail + explicit error messages |

**Suggestion:** Add a `--dry-run` flag that lists what would be built without creating files.
Useful for CI debugging.

---

## 8. CI/CD Pipelines — ✅ Pass

| Criterion | Rating | Notes |
|-----------|--------|-------|
| GitLab CI | ✅ | 3 parallel jobs, artifacts never expire |
| GitHub Actions | ✅ | Mirrors GitLab exactly |
| Trigger conditions | ✅ | Main branch + tags |

**Suggestion:** Add a `validate` job that runs `copy-common.sh all` on PRs (not just main)
to catch build failures before merge.

---

## 9. Token Efficiency — ⚠️ One file over limit

| File | Lines | Target | Status |
|------|-------|--------|--------|
| workflow.md | 500 | < 500 | ⚠️ At limit |
| plan-generator.md | 202 | < 200 | ⚠️ Slightly over |
| team-topology.md | 149 | < 200 | ✅ |
| spec-handoff.md | 178 | < 200 | ✅ |
| All others | < 120 | < 200 | ✅ |

**Fix for workflow.md:** Extract the "Gotchas" section (5 lines, duplicates Error Recovery)
and the Autonomous Mode section (20 lines) into a separate file if needed.

---

## 10. Intent Classifier Safety — ✅ Strong

| Criterion | Rating | Notes |
|-----------|--------|-------|
| Trigger word avoidance | ✅ | 16-entry substitution table in workflow.md |
| Safe question framing | ✅ | Examples in complexity-rubric.md |
| HANDOFF uses spec language | ✅ | Spec-handoff.md freely uses trigger words |

**One remaining risk:** The `common/decomposer.md` "Applying Team Topology" section
uses the word "implementation" 0 times (good) but the phrase "plan-generator" contains
"plan" which is a trigger word. Since this is a filename reference, not conversational
text, it's acceptable — but worth noting.

---

## Summary of Recommended Fixes

### Critical (fix before shipping)

1. Add filename sanitization rule to unit-format.md
2. Add write boundary constraint to decomposer.md
3. Update README.md to remove `state-machine.md` from Power package contents

### Warnings (should fix)

4. Replace "apply the selected strategy" in decomposer.md with explicit instruction
5. Replace "boilerplate" in POWER.md with clear explanation
6. Add COMPLETE phase actions to workflow.md
7. Remove duplicate strategy summaries from decomposer.md (reference team-topology.md)

### Suggestions (nice to have)

8. Add `--dry-run` flag to copy-common.sh
9. Add PR validation job to CI pipelines
10. Extract Autonomous Mode from workflow.md if it exceeds 500 lines

---

## Verdict: ⚠️ Fix critical issues, then ready to ship

The instruction set is well-architected with strong modularity, clear state machine,
and good LLM-friendly patterns. The security gaps (filename sanitization, write boundary)
are the most important fixes. The cross-file drift issues are minor but should be
cleaned up to prevent confusion.
