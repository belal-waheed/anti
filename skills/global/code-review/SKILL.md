---
name: code-review
description: How to review code changes and explain findings — checks correctness, security, performance, readability, and architecture fit. Use when asked to review a file, a diff, or a pull request, or to check code before committing. Also explains what and why it's checking, since the user is new to code review.
---

# Code Review

## When to use this
Reviewing a diff, a file, or a PR — or being asked "does this look okay" / "check this before I commit."

## Steps
1. Read the whole change first to understand intent before critiquing details — a review that nitpicks line 4 without understanding what the change is trying to do isn't useful.
2. Check the following, in priority order:
   - **Correctness**: Obvious bugs, off-by-ones, unhandled null/undefined/failures.
   - **Security**: Unsanitized input, hardcoded secrets, missing auth checks.
   - **Architecture fit**: Follows project patterns, logic in the right layer.
   - **Readability & naming**: Honest names, understandable flow.
   - **Performance**: Problems at realistic scale (N+1 queries, unnecessary re-renders).
   - **Tests**: Includes tests for added/changed behavior.
3. Mark each finding with a severity label:
   - **Blocking**: bug, security issue, or breaks the architecture.
   - **Suggestion**: would improve it, not required.
   - **Nit**: minor style/naming point, purely optional.
4. Summarize: what's blocking, what's a suggestion, what's fine as-is.
5. Teach as you go: Explain the reasoning, not just the verdict (e.g., explain why N+1 is bad instead of just saying "Fix it").

## Things to avoid
- Don't just silently rewrite flagged code; explain what's wrong, why it matters, and what a better version looks like.
- Don't nitpick details without understanding the overall intent of the change first.
- Don't stay completely silent if a check passes cleanly; say so briefly so the user learns what "good" looks like.
