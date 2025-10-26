# Architecture Documentation

Cross-project architecture documentation.

## Structure

```
architecture/
├── diagrams/      # Visual representations
└── decisions/     # Architecture Decision Records (ADRs)
```

## `diagrams/`

System-level diagrams:
- System architecture
- Data flow diagrams
- Network topology
- Deployment architecture

**Formats:** `.png`, `.svg`, `.mermaid`, `.drawio`

## `decisions/`

Architecture Decision Records (ADRs) that affect multiple projects.

**Format:** `NNNN-title.md`

**Examples:**
- `0001-use-postgres-everywhere.md`
- `0002-microservices-vs-monolith.md`
- `0003-api-authentication-pattern.md`

## When to Create an ADR Here

**YES (Cross-project):**
- "All projects use PostgreSQL"
- "We deploy with Docker Compose"
- "APIs follow REST conventions"

**NO (Project-specific):**
- "User service uses Redis for caching" → Goes in project repo
- "Admin dashboard uses React" → Goes in project repo

## ADR Template

```markdown
# ADR NNNN: [Title]

Date: YYYY-MM-DD
Status: Accepted | Rejected | Deprecated | Superseded by ADR-XXXX

## Context
What's the problem? What constraints exist?

## Decision
What did we decide?

## Consequences
### Positive
- Benefit 1

### Negative
- Tradeoff 1

## Alternatives Considered
- Option A: Why rejected
```


