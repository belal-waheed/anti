---
name: wayfinder
description: Maps out large, complex, or ambiguous software initiatives into structured architectural decision trees, technical milestones, and risk-mitigated execution paths. Use when planning multi-session efforts, evaluating high-level architecture trade-offs, or navigating major codebase refactors.
---

# Wayfinder: Architectural Milestone & Decision Mapping

Runbook for navigating large-scale technical ambiguity, mapping decision forks, and sequencing project milestones.

## 1. The 4-Stage Wayfinder Protocol

```
[Large / Ambiguous Technical Initiative]
                   │
                   ▼
 STAGE 1: LANDSCAPE & UNKNOWN IDENTIFICATION
 • Identify core technical unknowns and assumptions
 • Define hard constraints (budget, latency, hosting, team)
                   │
                   ▼
 STAGE 2: ARCHITECTURAL DECISION FORKS (ADFs)
 • Map divergent branches (e.g. Option A vs Option B)
 • Evaluate trade-offs with explicit scoring criteria
                   │
                   ▼
 STAGE 3: SPIKE & EXPERIMENT ISOLATION
 • Isolate high-risk unknowns into throwaway prototypes
 • Define pass/fail criteria before committing
                   │
                   ▼
 STAGE 4: SEQUENTIAL MILESTONE ROADMAP
 • Slice project into independent, testable milestones
 • Feed Milestone 1 directly into /defuddle for PRD slicing
```

---

## 2. Decision Fork Matrix Template

When evaluating competing architectural paths:

| Fork Dimension | Option A: [Name] | Option B: [Name] |
| :--- | :--- | :--- |
| **Operational Overhead** | Low (Serverless / Managed) | Medium (Docker / VPS) |
| **Scalability Limit** | 10k req/min | 100k+ req/min |
| **Implementation Risk** | Low (Standard SDK) | Medium (Custom protocol) |
| **Recommendation** | **(Recommended)** Primary choice for MVP | Secondary choice if latency bounds fail |

---

## 3. Milestone Decomposition Output

```markdown
# Roadmap: [Initiative Name]

## Milestone 1: Core Foundation & Data Plane
- **Goal**: [Minimum viable data layer operational]
- **Deliverables**: Database schemas, base repositories, unit test harness.
- **Risk Gate**: DB write throughput verified.

## Milestone 2: Service Logic & API Boundaries
- **Goal**: [Business logic and controllers operational]
- **Deliverables**: Services returning `Result<T, E>`, edge validation, router endpoints.

## Milestone 3: UI Integration & Polish
- **Goal**: [Client frontend connected and styled]
- **Deliverables**: Accessible UI components, state caching, end-to-end user journey.
```

---

## 4. Verification & Testing

Validate roadmap feasibility before proceeding:
1. **Dependency Cycle Check:** Verify no milestone depends on deliverables from a later milestone.
2. **Spike Verification:** High-risk third-party libraries must pass an isolated spike test before Milestone 1 begins.
3. **Constraint Alignment:** Confirm selected architectural forks satisfy system rules (package isolation, zero emojis).

---

## 5. Common Pitfalls & Negative Constraints

- **Never plan past 3 milestones in deep detail:** Milestone 1 should be fully specified; Milestones 2 and 3 should remain flexible.
- **Never skip risk isolation:** If an API or SDK is unproven, isolate it into a spike before writing production architecture.
- **Avoid single-point failure designs:** Always document fallback paths for critical external services.
