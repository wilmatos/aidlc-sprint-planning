# Complexity Assessment Rubric

## Factor Ratings

| Factor | Lightweight | Standard | Comprehensive |
|--------|-------------|----------|---------------|
| Scope | Single component | Multi-component | Multi-service / system-wide |
| Users | One persona | 2-3 personas | Many personas, different needs |
| Integrations | None or one | A few APIs | Multiple external systems |
| Data | Simple CRUD | Relationships / lifecycle | Complex models, compliance |
| Risk | Low, internal | User-facing, moderate | Critical, regulatory, financial |
| Clarity | Very specific | Some ambiguity | Vague or exploratory |

## Depth Guidelines

| Depth | Question Count | Categories Covered |
|-------|---------------|-------------------|
| Lightweight | 3-5 | Scope, Functionality |
| Standard | 6-10 | Users, Scope, Functionality, Data. Touch Integration/NFRs if relevant |
| Comprehensive | 10+ | All categories. Probe NFRs for measurable targets. Cover Risks and compliance |

## Question Categories

| Category | Purpose | Example Questions |
|----------|---------|-------------------|
| Users | Identify personas and access patterns | Who are the primary users? What personas exist? |
| Scope | Define boundaries and MVP | What's MVP vs future? What's explicitly out of scope? |
| Functionality | Map core workflows | What are the core workflows? What triggers what? |
| Data | Understand persistence and lifecycle | What data needs to persist? What's the lifecycle? |
| Integration | Map external dependencies | What external systems? What APIs? What protocols? |
| NFRs | Set measurable targets | Performance targets? Security requirements? Scale? |
| Risks | Identify threats and mitigations | What could go wrong? Compliance concerns? |

## Question Strategy

### Adaptive Questioning

Start with the most ambiguous category. Follow threads from answers. Skip closed categories. Pursue new concerns immediately. Circle back to uncovered categories before READY_CHECK.

### Suggest Answers When:
- Technology choice or scale/scope decision
- User might not know the available options

### Recommend Strongly:
> "Based on {reason}, I'd recommend {thing}. Want me to include it?"

Always raise recommendations as questions. Let the user decide.

### Bounded Context Signals

Look for: different data ownership, change frequency, team ownership, scaling requirements, deployment cadence, or vocabulary boundaries.

## Question Template

Each question must include:
1. **Category tag:** [Users] [Scope] [Functionality] [Data] [Integration] [NFRs] [Risks]
2. **Question type:** Clarification | Decision | Constraint | Boundary
3. **Suggested answers (2-3):** Only for technology/scale decisions
4. **Follow-up trigger:** What answer would close this question?

Format:
```markdown
## [Category] Question {N} of ~{estimated_total}

{Question text}

{Optional: suggested answers}

---
📊 **Progress:** {answered}/{estimated_total} · 📋 **Decisions recorded:** {count}
```

### Safe Question Framing

When asking questions, avoid trigger words that could cause the host IDE to
switch modes. Frame questions using the safe alternatives from the workflow's
Execution Mode table. For example:

- Instead of: "What's the API design?"
- Use: "How should the endpoints be structured?"

- Instead of: "What are the requirements?"
- Use: "What behavior do you expect?"

- Instead of: "Describe the architecture"
- Use: "How should the system be structured?"
