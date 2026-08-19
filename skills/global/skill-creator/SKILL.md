---
name: skill-creator
description: Helps design, draft, and refine SKILL.md files for this setup. Use when the user asks to create a skill, when a task pattern has repeated in a way that looks reusable, or when reviewing an existing skill's trigger description.
---

# Skill Creator

## When to suggest a new skill (don't create silently)
Notice repetition — the same multi-step task or checklist requested more than once.
1. Name what you noticed in one sentence.
2. Ask if they want it as a skill. Do not create the file yet.
3. If yes, ask: global (`~/.gemini/antigravity/skills/`) or workspace (`.agents/skills/`)?
4. Only then create the file.

## Rule vs. Skill — check this first
- Constraint on how code/output should always look → Rule.
- Multi-step task or workflow, only relevant sometimes → Skill.
- If unsure, default to Skill — it only loads when relevant, so it doesn't clutter every prompt the way an always-on rule does.

## Before creating, check for duplicates
Look in both skill folders for something that already covers this. Extend an existing skill instead of making a near-duplicate.

## Keep it focused
One skill, one job. Two distinct triggers ("review code" and "write tests") means two skills.

## Writing the description
This is the only thing the agent sees before deciding to load the skill.
- Third person, one to two sentences.
- Name the task and the trigger condition.
- Bad: "Helps with testing." Good: "Writes unit tests for React components using Vitest. Use when the user asks for tests or coverage."

## Template
    ---
    name: <kebab-case-name>
    description: <what it does + when to use it>
    ---
    # <Skill Name>
    ## When to use this
    ## Steps
    ## Things to avoid

## Scripts and resources
If the skill needs a script, put it in `scripts/` and tell the agent to run it with `--help` first rather than reading the source.
For branching logic, add a short decision tree so the agent isn't guessing.

## After creating
Tell the user where the file went and what will trigger it. Suggest testing it once before trusting the description works.