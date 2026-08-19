---
name: structured-clear-thinking
description: Mandatory framework for first-principles reasoning, Architecture Decision Records (ADRs), 5-Whys root cause analysis, and edge-case elimination across all engineering tasks. Use when making complex design decisions, evaluating architectural trade-offs, or auditing edge cases.
---

# Structured Clear Thinking & First-Principles Decision Framework

## When to use this skill
Trigger whenever reasoning through non-trivial architecture decisions, evaluating trade-offs, planning complex workflows, or auditing edge cases before writing code.

---

## 1. First-Principles Engineering Protocol

```
1. DECONSTRUCT ──► Strip assumptions. What are the fundamental constraints?
2. EVALUATE    ──► Does this solution solve the core problem with minimum complexity?
3. AUDIT       ──► Trace data flows against the Edge-Case Matrix.
4. DOCUMENT    ──► Record the decision in an ADR format.
```

---

## 2. The Edge-Case Verification Matrix

Before implementing any non-trivial logic, verify against all 5 edge-case vectors:

| Edge Case Vector | Critical Question | Defense Pattern |
|:---|:---|:---|
| **Null & Empty** | What if the list is empty `[]`, string is `""`, or input is `None`/`undefined`? | Safe fallbacks, schema defaults, optional chaining |
| **Boundaries & Extremes** | What happens at `0`, `-1`, `MAX_INT`, or 10,000 items? | Pagination, input range guards, clamp functions |
| **Network & Offline** | What happens if the API drops mid-request or server returns 503? | Retry policies, offline caching, graceful degradation |
| **Concurrency & Race Conditions** | What if the user double-clicks submit or 2 workers mutate state? | Debouncing, optimistic locking, idempotent endpoints |
| **Authentication & AuthZ** | What if an unauthenticated user sends a spoofed request? | Edge token validation, server-side authorization guards |

---

## 3. The 5-Whys Root Cause Protocol

When analyzing systemic bugs or design friction:
1. *Why 1*: Why did the query fail? (e.g. DB connection timeout)
2. *Why 2*: Why did it time out? (e.g. Connection pool exhausted)
3. *Why 3*: Why was pool exhausted? (e.g. `PrismaClient` instantiated per-request)
4. *Why 4*: Why was it instantiated per-request? (e.g. Missing singleton module)
5. *Why 5 (Root Cause)*: Missing repository lifecycle pattern in backend architecture.

---

## Things to Avoid

- Avoid premature optimization on code paths that are not proven bottlenecks.
- Avoid guessing API signatures or assuming third-party library behavior without checking docs.
- Avoid deploying fixes that address only symptom layer (Why 1) without fixing root cause (Why 5).
