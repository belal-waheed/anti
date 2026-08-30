---
name: defuddle
description: Guidelines for transforming ambiguous concepts into formal specifications (PRDs) and atomic tickets with acceptance criteria. Use when converting conversational requirements into specs, breaking down backlogs, or structuring sprint plans.
---

# Defuddle: Spec Shaping & Ticket Decomposition

Synthesizes PRD specification patterns with atomic task decomposition for structured engineering execution.

## 1. The 3-Phase Shaping Pipeline

```
[Conversational Concept / Feature Request]
                    │
                    ▼
 PHASE 1: SPECIFICATION SHAPING (/to-spec)
 • Define scope, user value, and non-goals
 • Map user journeys and edge cases
 • Data models and technical constraints
                    │
                    ▼
 PHASE 2: TICKET DECOMPOSITION (/to-tickets)
 • Slice into atomic, single-responsibility tickets
 • Assign stage tags (#now, #next, #later)
 • Define pass/fail Acceptance Criteria
                    │
                    ▼
 PHASE 3: VAULT & SPRINT ALIGNMENT
 • Inject active tickets into inbox/Today.md (#today)
 • Append architecture details to project hub
```

---

## 2. Formal Specification Template (`PRD.md`)

When executing Phase 1 (`/to-spec`):

```markdown
# Spec: [Feature / System Name]

## 1. Problem Statement & User Value
- **Problem**: [Clear statement of the limitation or bug]
- **Value**: [Who benefits and why]
- **Non-Goals / Out of Scope**: [Explicit boundaries on excluded capabilities]

## 2. Technical Architecture & Constraints
- **Layered Impact**: Router/Controller -> Service -> Repository
- **Data Models / Schemas**: [Pydantic, Zod, or EF Core entity changes]
- **Security / Guardrails**: [Auth, validation, rate limits]

## 3. Success Metrics & Verification Gate
- Automated test command: `npm test` / `pytest` / `dotnet test`
- Acceptance test conditions
```

---

## 3. Ticket Decomposition Template (`/to-tickets`)

When executing Phase 2, slice the spec into atomic tickets:

```markdown
### Ticket [ID]: [Action Verb] + [Target Component]
- **Context**: [Reference to PRD section]
- **Stage**: `#now` (Max 2 items) | `#next` | `#later`
- **Dependencies**: [Pre-requisite ticket IDs or None]

#### Acceptance Criteria (Mandatory Verifiable Checkboxes)
- [ ] AC-1: [Input/output or schema contract validated]
- [ ] AC-2: [Unit test added following AAA pattern and passing]
- [ ] AC-3: [Documentation / type definitions updated]
```

---

## 4. Verification & Testing

Verify that generated tickets meet the atomic standard:
1. Each ticket touches at most 1–3 files.
2. Every acceptance criterion has an automated command to assert pass/fail.
3. Total `#now` tickets does not exceed 3 concurrently.

---

## 5. Common Pitfalls & Negative Constraints

- **Never create monolithic tickets:** If a ticket says "Build auth and UI and database", reject it and split into 3 discrete tickets.
- **Never omit Non-Goals:** Every spec must explicitly state excluded capabilities.
- **Never use vague criteria:** "Make it look good" is prohibited. Use "Meets WCAG AA 4.5:1 contrast and 8px spatial grid".
