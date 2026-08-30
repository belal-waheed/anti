---
name: intent-unpacker
description: Decodes informal, brief, or colloquial user prompts with fragmented technical terms into precise technical objectives, inferred architecture, and actionable execution steps. Use when user prompts are brief, casual, underspecified, or lack structured engineering detail.
---

# Intent Unpacker: Informal Prompt Decomposition

Protocol for expanding fragmented or informal prompts into concrete engineering actions without user friction.

## 1. The 3-Phase Intent Unpacking Protocol

```
[Casual / Fragmented User Prompt]
                │
                ▼
 1. SILENT RECONNAISSANCE ──► Inspect workspace manifests, git diff, and stack conventions
                │
                ▼
 2. INTENT RECONSTRUCTION ──► Map to Target Objective + Inferred Defaults + Layer
                │
                ▼
 3. EXECUTION BRANCHING   ──► Execute directly (if clear) OR present concise defaults
```

---

## 2. Phase 1: Silent Workspace Grounding

Before generating a response or asking questions, silently inspect:
1. **Manifests**: Check `package.json`, `*.csproj`, `pyproject.toml`, `requirements.txt`, `*.ahk` to identify the stack.
2. **Architecture**: Map keywords to existing project layers (Controller/Router -> Service -> Repository).
3. **Recent State**: Run `git status` or check recent file modifications to understand context.

---

## 3. Phase 2: Intent Extraction Table

| Vector | Extraction Strategy |
|:---|:---|
| **Core Objective** | Translate colloquial shorthand into precise technical actions (e.g. "make auth 401" -> "Add 401 Unauthorized middleware with Zod token validation"). |
| **Target Layer** | Identify touched components (Routes, Services, Repositories, UI). |
| **Inferred Defaults** | Apply workspace rules (strict typing, AAA tests, zero emojis, `-NoProfile` pwsh). |
| **Verification** | Identify test commands (`npm test`, `dotnet test`, `pytest`). |

---

## 4. Phase 3: Execution Branching

- **Branch A (Unambiguous):** Output a single-line summary (`Inferred Goal: [Action]`) and execute directly.
- **Branch B (High Architectural Ambiguity):** State inferred goal, list 2 concrete defaults, and ask a single focused multiple-choice question via `ask_question`.

---

## 5. Verification & Testing

Verify that intent unpacking succeeds:
1. **Grounding Assertion:** Ensure proposed file paths and functions actually exist in the workspace before modifying.
2. **Test Execution:** Run test suite against modified components to prove behavior matches intent.
   ```bash
   npm test -- --watch=false
   ```

---

## 6. Common Pitfalls & Negative Constraints

- **Never ask the user to rewrite their prompt:** The assistant carries the full cognitive burden of intent expansion.
- **Never stall with open-ended filler:** Avoid asking "Can you provide more details?". Propose sensible defaults instead.
- **Never guess installed packages:** Always check `package.json` / workspace files before using library APIs.
