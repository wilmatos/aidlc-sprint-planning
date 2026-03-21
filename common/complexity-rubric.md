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
