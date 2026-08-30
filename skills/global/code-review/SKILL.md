---
name: code-review
description: Comprehensive quality guard and code review runbook. Checks correctness, anti-slop guardrails, mock-abuse, API drift, security, and architecture fit before landing Git commits. Use when reviewing diffs, PRs, or validating changes before staging.
---

# Code Review & Pre-Landing Quality Guards

Synthesizes rigorous code review standards with automated quality guard gates to prevent bugs, AI slop, and architectural drift.

## 1. The Pre-Landing Review Pipeline

```
[Git Working Tree Diff / Staged Changes]
                   │
                   ▼
 STEP 1: AUTOMATED GUARD PASS
 • Mock-Abuse Check    : Are unit tests mocking the system under test? (Forbidden)
 • API Drift Check     : Are all imported packages in package.json / requirements.txt?
 • Secret Scan         : Are any API keys, tokens, or .env files exposed?
                   │
                   ▼
 STEP 2: ARCHITECTURAL & LOGICAL AUDIT
 • Layer Integrity     : Controller/Router -> Service -> Repository
 • Error Boundaries    : Are operations wrapped in Result<T, E> or try/catch?
 • Edge Cases          : Null/undefined, empty arrays, network timeouts handled?
                   │
                   ▼
 STEP 3: DIFF REPORT & COMMIT PROPOSAL
 • Blockers (Must fix) vs Suggestions vs Nits
 • Formatted Conventional Commit message ready for user approval
```

---

## 2. Strict Quality Guards

### Guard 1: Anti-Mock Abuse
- **Rule:** NEVER mock the system under test (SUT). Only mock external boundary interfaces (e.g., third-party Stripe API, external SMTP server).
- **Rule:** Database tests must verify actual query constraints or use isolated in-memory instances where appropriate.

### Guard 2: Dependency & Import Drift
- **Rule:** Verify that newly imported libraries are already present in project manifests (`package.json`, `.csproj`, `pyproject.toml`).
- **Rule:** Never introduce unapproved heavy dependencies when a standard library solution exists.

### Guard 3: Security & Clean Input
- **Rule:** Validate all inputs at the boundary using Zod / Pydantic before passing to services.
- **Rule:** Zero hardcoded secrets, database strings, or personal filepaths in code.

---

## 3. Severity Labeling Rubric

Categorize all review findings clearly:
- **[BLOCKER]**: Fatal bug, security vulnerability, broken architecture layer, or failing test. Must be resolved before commit.
- **[SUGGESTION]**: Performance optimization or readability refactor that improves maintainability.
- **[NIT]**: Minor style or naming improvement. Non-blocking.

---

## 4. Verification & Testing

Always run the full automated test suite before concluding review:
```bash
# Node / TypeScript
npm test -- --run

# C# / .NET
dotnet test

# Python
pytest -v
```

---

## 5. Common Pitfalls & Negative Constraints

- **Never approve without diff inspection:** Always run `git diff` or inspect exact modified lines.
- **Never perform silent commits:** Present the diff summary and Conventional Commit message, awaiting explicit user confirmation.
- **Do not nitpick formatting:** Rely on Prettier/ESLint/Ruff rather than manual style debates.
