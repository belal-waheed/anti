---
name: agent-delegation
description: Multi-agent orchestration protocol for delegating background tasks, parallel research, and isolated feature implementations to Antigravity subagents. Use when parallelizing large refactors, offloading broad codebase exploration, or running background validation.
---

# Agent Delegation: Native Subagent Orchestration

Runbook for delegating tasks to native Antigravity background subagents with workspace isolation and quality review gates.

## 1. Subagent Archetypes & Roles

| Agent Type | Purpose | Tool Access | Workspace Mode |
| :--- | :--- | :--- | :--- |
| **`research`** | Codebase exploration, web searches, documentation lookups | Read-only tools | `inherit` |
| **`self` (Implementer)** | Isolated feature development, migrations, bug fixes | Full Read + Write + Terminal | `branch` (isolated copy) or `share` |

---

## 2. Delegation & Dispatch Protocol

```
[Complex / Multi-Component Task]
                 │
                 ▼
 1. TASK DECOMPOSITION & CONTEXT ISOLATION
 • Define unambiguous, single-responsibility prompt for the subagent
 • Specify exact deliverables and expected verification commands
                 │
                 ▼
 2. SUBAGENT INVOCATION (invoke_subagent)
 • Select TypeName ('research' or 'self')
 • Select Model ('inherit', 'flash', or 'pro')
 • Select Workspace mode ('branch', 'share', or 'inherit')
                 │
                 ▼
 3. REACTIVE WAKEUP (Zero Polling)
 • Parent agent continues other work or ends turn; system auto-notifies on completion
                 │
                 ▼
 4. QUALITY GATE & DIFF REVIEW (The Iron Review Pass)
 • Review subagent diffs against /code-review quality guards
 • Merge approved deliverables into primary workspace
```

---

## 3. Invocation Schema Example

```json
{
  "TypeName": "self",
  "Role": "Backend Migration Specialist",
  "Model": "inherit",
  "Workspace": "branch",
  "Prompt": "Implement Zod schema validation for user auth endpoints in src/features/auth/. Run 'npm test' to verify all test suites pass. Return a bulleted diff summary."
}
```

---

## 4. Verification & Testing

Validate subagent results before landing changes:
1. **Subagent Test Verification:** Inspect subagent execution logs to ensure unit tests passed in the branched workspace.
2. **Pre-Landing Review:** Run [`code-review`](file:///C:/Users/bel/.gemini/config/skills/code-review/SKILL.md) pass over modified files.
3. **Primary Workspace Build Test:**
   ```bash
   npm test && npm run build
   ```

---

## 5. Common Pitfalls & Negative Constraints

- **Never poll subagents in a loop:** Rely strictly on reactive wakeup notifications from the messaging system.
- **Never delegate without explicit acceptance criteria:** Every subagent prompt must define how to prove success.
- **Never land subagent code without review:** Always inspect diffs against quality guards (anti-mock abuse, API drift).
