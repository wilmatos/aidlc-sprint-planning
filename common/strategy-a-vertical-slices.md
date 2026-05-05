# Strategy A: Vertical Slices

**Use when:** Single full-stack team, demoable units, milestone-driven.

**Decompose:** Each unit = complete user-facing capability (UI + API + data). Order by user value. Shared infra = foundational unit.

**Example:**

```text
01-foundation        (auth, DB schema, shared infra)
02-user-onboarding   (registration UI + API + email)
03-core-workflow     (main feature, full vertical slice)
04-reporting         (dashboard UI + query API)
```text
