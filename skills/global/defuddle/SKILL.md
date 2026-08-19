---
name: defuddle
description: Guidelines for task refinement, eliminating ambiguity, and breaking down complex vault projects into structured, testable action items with acceptance criteria. Trigger when refactoring workspace notes, clarifying ambiguous user requests, or organizing backlog items into actionable sprint plans.
---

# Defuddle: Task Refinement & Action Item Decomposition

## When to use this skill
Trigger whenever decomposing complex, ambiguous ideas, raw notes in `03-inbox/`, or high-level project goals into concrete, testable action items.

---

## 1. The Defuddle 3-Step Refinement Protocol

```
[Ambiguous Idea / Raw Capture]
             │
             ▼
1. SCOPE & GOAL DEFINITION ──► What does "Done" look like? What is out of scope?
             │
             ▼
2. DECOMPOSITION & STAGING  ──► Break into atomic tasks, tag with #now, #next, #later
             │
             ▼
3. ACCEPTANCE CRITERIA      ──► Attach concrete verification checkboxes (- [ ])
```

---

## 2. Standard Task Decomposition Template

```markdown
### Task: [Clear Action Verb] + [Specific Component]

- **Scope**: [1-sentence description of the exact change]
- **Stage**: `#now` | `#next` | `#later`
- **Dependencies**: [Pre-requisite tasks or None]

#### Acceptance Criteria
- [ ] Criteria 1: [Specific input/output or state change verified]
- [ ] Criteria 2: [Unit or integration test added and passing]
- [ ] Criteria 3: [Documentation or types updated]
```

---

## 3. Stage Lifecycles & Rules

- **`#now` (Active Execution)**: Max 2–3 items at any time. Must be actively worked on in the current session.
- **`#next` (Immediate Queue)**: Ready to be picked up as soon as current `#now` items are marked complete.
- **`#later` (Backlog / Ideas)**: Deprioritized until subsequent review or sprint planning.

---

## Things to Avoid

- Avoid vague, un-testable action items (e.g. "- [ ] Work on API" is bad; "- [ ] Add POST /items route with Zod validation and unit tests #now" is good).
- Avoid more than 3 active `#now` tasks simultaneously.
- Never mark a complex task complete without verifying its acceptance criteria.
