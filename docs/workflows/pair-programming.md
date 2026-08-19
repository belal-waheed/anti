# Collaborative Pair Programming & Planning Mode

Antigravity operates in distinct modes based on task complexity.

---

## 1. Planning Mode Workflow

For non-trivial architectural changes, refactors, or new projects:

```text
[User Request]
      |
      v
[1. Research & Analysis] (Read files, check dependencies, zero destructive edits)
      |
      v
[2. Generate implementation_plan.md] (Architecture, file diff targets, verification plan)
      |
      v
[3. User Review & Approval] (Wait for explicit user approval)
      |
      v
[4. Step-by-Step Execution] (Apply changes, maintain clean architecture, test)
      |
      v
[5. Verification & Walkthrough] (Run unit tests, produce walkthrough.md)
```

---

## 2. Direct Execution Mode

For minor bug fixes, single-line edits, investigatory questions, or syntax errors, the agent proceeds immediately without blocking for planning overhead.
