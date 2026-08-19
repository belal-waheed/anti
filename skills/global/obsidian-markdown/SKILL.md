---
name: obsidian-markdown
description: Vault structure, routing rules, and formatting standards for Obsidian markdown notes. Covers the 9-folder vault taxonomy (00-files through 99-quick), YAML frontmatter schemas, wikilinks, Dataview queries, Templater syntax, callouts, and task stage tags (#now, #next, #later). Trigger whenever creating or editing markdown notes in an Obsidian vault.
---

# Obsidian Vault Architecture & Markdown Guide

## When to use this skill
Trigger whenever creating, editing, or re-structuring markdown notes, templates, Dataview queries, or task plans within an Obsidian vault.

---

## 1. Vault Taxonomy & Routing Matrix (Unnumbered PARA)

| Folder | Purpose | Standard Content / Notes |
|:---|:---|:---|
| **`inbox/`** | Fast capture & active daily execution | [`inbox/Today.md`](file:///d:/belal/obsidian/hola/inbox/Today.md) (rolling daily note), [`inbox/Inbox.md`](file:///d:/belal/obsidian/hola/inbox/Inbox.md) |
| **`sprints/`** | Weekly sprint cycles & backlog rollover | [`sprints/Week-YYYY-Wxx.md`](file:///d:/belal/obsidian/hola/sprints/), `_sprints.md` |
| **`projects/`** | Dedicated project workspaces | `projects/[name]/_[name].md` (hub), guides, task lists |
| **`areas/`** | Long-term knowledge base & domains | `areas/tech/backend/`, `areas/tech/frontend/`, `areas/career/` |
| **`resources/`** | Reference library & bookmarks | `resources/articles/`, `resources/bookmarks/` |
| **`archive/`** | Cold storage & completed milestones | `archive/completed-projects/`, `archive/backups/` |
| **`system/`** | System templates, scripts & assets | `system/templates/`, `system/scripts/`, `system/assets/` |

---

## 2. Note Types & YAML Frontmatter Schemas

### A. Rolling Daily Execution Note (`inbox/Today.md`)
```markdown
---
type: task-daily
date: 2026-08-18
day: Tuesday
week: "[[sprints/Week-2026-W34|Week-2026-W34]]"
tags:
  - daily
  - planning
---

# Today — 2026-08-18, Tuesday

## The Frog (Top 3 Priority Actions)
- [ ] Priority Action 1 #today
- [ ] Priority Action 2 #today
- [ ] Priority Action 3 #today

---

## Execution Checklist
- [ ] Subtask or secondary action

---

## Daily Scratchpad & Notes
*Technical decisions, snippets, endpoints, and commands run today.*
```

### B. Project Folder Hub Note (`projects/o2om/_o2om.md`)
```markdown
---
type: project-hub
project: o2om
status: active
tags: [project, ahk, health]
created: 2026-08-14
---

# O2om — Stand-Up & Physical Health Reminder

## Overview
Lightweight AutoHotkey v2 desktop utility for posture and stretch reminders.

## Project Deliverables & Milestones
- [ ] Implement DPI-aware dark theme GUI #week
- [x] Configure Windows Task Scheduler daemon

## Architecture & Guides
- [[projects/o2om/01-system-architecture|System Architecture]]
```

---

## 3. Dynamic Folder Hubs & Navigation Footers

1. **Folder Hub Notes**: Always name folder hub notes as `_[foldername].md` (e.g., `projects/o2om/_o2om.md`, `sprints/_sprints.md`).
2. **Navigation Callout**: Maintain the boundary-safe `> [!NAV] Navigation` dataviewjs block at the end of notes.
3. **Task Tags**:
   - `#today`: Daily execution items rolling into `inbox/Today.md` and triggering desktop/cloud alerts.
   - `#week`: Sprint milestones rolling into current weekly sprint.
   - `#later`: Backlog ideas.

---

## 4. Scoped Dataview Dashboards

Always scope Dataview queries to specific folders for high performance:

### A. Active Tasks Dashboard (`#today`)
```dataview
TASK
FROM ""
WHERE contains(tags, "#today") AND !completed AND file.path != this.file.path
GROUP BY file.link
```

### B. Active Sprint Tasks (`#week`)
```dataview
TASK
FROM ""
WHERE contains(tags, "#week") AND !completed AND file.path != this.file.path
GROUP BY file.link
```

---

## 5. Wikilinks & Formatting Best Practices

1. **Wikilinks**: Use `[[Note Name]]` or `[[Target Note|Custom Display Text]]`.
2. **Callouts**: Use standard Obsidian callouts for visual hierarchy:
   ```markdown
   > [!NOTE]
   > Helpful context or reference.
   
   > [!IMPORTANT]
   > Critical acceptance criteria or blocker.
   
   > [!TIP]
   > Performance or workflow optimization.
   ```

---

## Things to Avoid

- Never perform unscoped full-vault `dv.pages()` scans without folder filters.
- Avoid loose markdown files in the root folder (route them into `inbox/`, `projects/`, `areas/`, or `resources/`).
- Avoid mixing emojis in task headers or notes unless explicitly requested.
- Avoid broken wikilinks by verifying target note names.
