---
name: daily-sprint-planner
description: Interactive workflows for daily planning, weekly sprint management, task execution tracking, and automatic documentation sync in Obsidian. Use when the user asks to plan their day or week, review tasks, log completed work, or update vault documentation after a work session.
---

# Daily & Weekly Planning and Post-Work Documentation Sync Guide

## When to use this skill
Activate this skill whenever:
- The user asks to plan their day, start a morning kickoff, or review today's schedule.
- The user asks to plan their week, review the current sprint, or start a new sprint.
- The user finishes or works on a feature/task and needs documentation, tasks, and project hubs updated.
- The user asks for an end-of-day review, task rollover, or session wrap-up.

---

## 1. Core Operating Modes

```
┌─────────────────────────────────────────────────────────────┐
│                 daily-sprint-planner Modes                  │
├──────────────────┬──────────────────┬───────────────────────┤
│ Mode 1: Daily    │ Mode 2: Weekly   │ Mode 3: Post-Work     │
│ Planning Kickoff │ Sprint Planning  │ Reconciliation        │
├──────────────────┼──────────────────┼───────────────────────┤
│ • Date rollover  │ • New sprint     │ • Task check-off      │
│ • Frog Top 3     │ • Top 3 weeklies │ • Project hub sync    │
│ • Time blocks    │ • Deliverables   │ • Tech scratchpad log │
│ • #today tags    │ • #week tags     │ • Living doc updates  │
├──────────────────┴──────────────────┴───────────────────────┤
│ Mode 4: End-of-Day Review & Sprint Rollover                 │
│ • Energy/focus review • Carried-over task rollover to sprint│
└─────────────────────────────────────────────────────────────┘
```

---

## Mode 1: Daily Planning Kickoff (`plan day` / morning routine)

### Trigger phrases:
`"plan my day"`, `"let's plan today"`, `"morning kickoff"`, `"what's on my plate?"`, `"today's tasks"`

### Step-by-Step Procedure:
1. **Determine Current Date & ISO Week**:
   - Extract current date (e.g. `2026-08-18`), weekday (`Tuesday`), and ISO week (`Week-2026-W34`).
2. **Inspect [`inbox/Today.md`](file:///d:/belal/obsidian/hola/inbox/Today.md)**:
   - Check the frontmatter `date:`.
   - **If the note is from a previous day**:
     - Extract any unfinished tasks (`- [ ] ...`) and daily reflections.
     - Append them into the active sprint note ([`sprints/Week-2026-W34.md`](file:///d:/belal/obsidian/hola/sprints/Week-2026-W34.md)) under `## Carried-Over & Backlog Tasks`.
     - Reset `Today.md` with today's date, day, and week link.
3. **Establish "The Frog" (Top 3 Priority Actions)**:
   - Identify the 3 most impactful tasks for today with the user.
   - Format them clearly under `## The Frog (Top 3 Priority Actions)`:
     ```markdown
     - [ ] [Task description] #today
     ```
   - If a specific time is desired, add the time tag (e.g., `- [ ] Team sync at 10:30 am #today`).
4. **Configure Time Blocks**:
   - Align Morning (09:00–12:00), Afternoon (13:00–17:00), and Evening (19:00–22:00) focus areas.
5. **Verify Vault-Wide `#today` Tasks**:
   - Ensure the Dataview block in `Today.md` renders tasks tagged with `#today` across project notes.

---

## Mode 2: Weekly Sprint Planning (`plan week` / sprint kickoff)

### Trigger phrases:
`"plan week"`, `"weekly sprint"`, `"new sprint"`, `"sprint kickoff"`, `"review this week"`

### Step-by-Step Procedure:
1. **Locate / Create Sprint Note**:
   - Target path: [`sprints/Week-YYYY-Wxx.md`](file:///d:/belal/obsidian/hola/sprints/) (e.g., `sprints/Week-2026-W34.md`).
   - If not present, initialize using [`system/templates/Weekly-Sprint.md`](file:///d:/belal/obsidian/hola/system/templates/Weekly-Sprint.md).
2. **Define Top 3 Weekly Priorities**:
   - Formulate 3 high-impact milestones under `## Top Priorities This Week` tagged with `#week`.
3. **Update Key Project Deliverables Table**:
   - Matrix active projects ([`projects/loop/`](file:///d:/belal/obsidian/hola/projects/loop), [`projects/o2om/`](file:///d:/belal/obsidian/hola/projects/o2om), [`projects/portfolio/`](file:///d:/belal/obsidian/hola/projects/portfolio), [`projects/markbel/`](file:///d:/belal/obsidian/hola/projects/markbel)).
   - Set deliverables, target dates, and statuses (`Planned` | `In Progress` | `Completed`).
4. **Reconcile Carried-Over Tasks**:
   - Review backlog tasks from previous sprints and assign them or prioritize them.

---

## Mode 3: Continuous Execution & Post-Work Reconciliation (Post-Task Sync)

### Trigger phrases / moments:
- The user finishes a coding session, fixes a bug, completes a deployment, or configures a feature.
- Explicit calls: `"sync docs"`, `"update task plan"`, `"log what we did"`, `"we finished [X]"`.

### The 4-Step Mandatory Reconciliation Pipeline:

```
[Completed Work] ──► [Step 1: Check Off Tasks] ──► [Step 2: Update Project Hub]
                                                             │
[Next Action]   ◄── [Step 4: Tech Scratchpad]  ◄── [Step 3: Living Tech Docs]
```

1. **Step 1: Task Check-Off**:
   - Find matching task items in [`inbox/Today.md`](file:///d:/belal/obsidian/hola/inbox/Today.md) (The Frog or Execution Checklist) and [`sprints/Week-YYYY-Wxx.md`](file:///d:/belal/obsidian/hola/sprints/).
   - Mark them completed: `- [x] Task name #today`.
2. **Step 2: Project Hub Sync**:
   - Open the corresponding folder note ([`projects/<project>/_<project>.md`](file:///d:/belal/obsidian/hola/projects/)).
   - Update project status, milestone deliverables, and link any newly created deployment/architecture guides.
3. **Step 3: Living Technical Documentation**:
   - If new architecture, API routes, database schemas, or deployment pipelines were created:
     - Update or create living docs in `projects/<project>/` or `areas/tech/<domain>/`.
     - Include clear Mermaid sequence/architecture diagrams when appropriate.
4. **Step 4: Daily Technical Scratchpad & Decision Log**:
   - Under `## Daily Scratchpad & Notes` in [`inbox/Today.md`](file:///d:/belal/obsidian/hola/inbox/Today.md), append concise bullets:
     - What was implemented / resolved.
     - Key commands executed, test results, or endpoints created.
     - Important architectural decisions or environment variables configured.
5. **Step 5: Next Action Recommendation**:
   - Highlight the next logical task or offer to proceed to the next item on the daily checklist.

---

## Mode 4: End-of-Day Review & Sprint Rollover (`end of day`)

### Trigger phrases:
`"end of day"`, `"evening review"`, `"wrap up today"`, `"rollover tasks"`

### Step-by-Step Procedure:
1. **Audit Completed vs. Pending Tasks**:
   - Review which of today's frogs and checklist items were completed.
2. **Complete End-of-Day Reflection in [`inbox/Today.md`](file:///d:/belal/obsidian/hola/inbox/Today.md)**:
   - Fill in:
     - `- **Energy / Focus:**` [High | Medium | Low]
     - `- **What went well:**` [Highlights of the day]
     - `- **What was blocked:**` [Blockers or pending dependencies]
3. **Rollover Unfinished Tasks**:
   - Copy any incomplete tasks from `Today.md` into the active weekly sprint note ([`sprints/Week-YYYY-Wxx.md`](file:///d:/belal/obsidian/hola/sprints/)) under `## Carried-Over & Backlog Tasks`.
4. **Prepare Tomorrow**:
   - Set up `Today.md` for the following morning or keep it clean for the next morning kickoff.

---

## 2. Vault Daemons & Notification Compatibility Rules

1. **Standard Markdown Tasks**:
   - Always write tasks as `- [ ] [Task Text]` or `- [x] [Task Text]`.
   - Never replace with non-standard bullet symbols or HTML checkboxes.
2. **Time Alarms for Background Daemons**:
   - Format times in tasks using one of these supported patterns:
     - `- [ ] Meeting with client at 10:30 am #today`
     - `- [ ] Standup @ 14:00 #today`
     - `- [ ] 09:30 AM Sprint review #today`
   - These will be automatically picked up by [`ob-hola.ahk`](file:///d:/belal/obsidian/hola/system/scripts/ob-hola.ahk) and [`cloud-notifier.js`](file:///d:/belal/obsidian/hola/system/scripts/cloud-notifier.js) for desktop toasts and mobile push notifications.
3. **Preserve Navigation & Dataview JS**:
   - Always preserve the `> [!NAV] Navigation` callout and Dataview blocks at the bottom of notes.

---

## 3. Things to Avoid

- Do not perform unscoped file sweeps across the entire vault without directory filtering.
- Do not remove existing note frontmatter or overwrite user scratchpad notes without archiving them to the weekly sprint.
- Do not let completed coding work pass without immediately executing the 4-step post-work reconciliation protocol.
- Do not use emojis in headers or task text unless explicitly requested.
