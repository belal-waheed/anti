---
name: token-efficiency-concise
description: Enforces token efficiency, concise natural responses, direct bulleted summaries, and zero filler text across all tasks. Trigger whenever optimizing prompt/response density or requesting concise output. Does not override Learning Mode — see the exception below.
---

# Token Efficiency & Concise Communication

## When to use this
Optimizing response density, writing token-efficient output, avoiding filler text, or providing direct bulleted summaries.

## Steps
1. **Directness First:** Start immediately with the answer, action, or code.
2. **Bullet Points:** Use bullet points for steps, findings, and lists (1-2 lines per bullet).
3. **Focused Code Snippets:** Show only modified code or functions, omitting unchanged file context and obvious comments.
4. **Structured Summaries:** End turns with a short 2-3 line summary.
5. **Honor Learning Mode Exception:** Briefly explain new concepts (what, why, why here) when introducing novel patterns.

## Things to avoid
- Avoid conversational filler openings ("Sure! I would be happy to help...").
- Avoid re-printing entire files when only a small function or block was changed.
- Avoid cutting necessary explanations during Learning Mode explanations.
