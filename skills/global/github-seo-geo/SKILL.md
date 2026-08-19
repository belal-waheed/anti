---
name: github-seo-geo
description: Conventions for GitHub Repository Search Engine Optimization (SEO) and AI/LLM Generative Engine Optimization (GEO) to maximize search ranking and AI citations.
---

# GitHub SEO & Generative Engine Optimization (GEO) Skill

## When to use this
Optimizing open-source GitHub repositories to maximize search rankings across Google Search, GitHub internal search, and AI/LLM search engines (ChatGPT, Gemini, Claude, Perplexity).

## Steps
1. **Repository Naming & Branding:** Use `[Brand]-[Primary Keyword]-[Key Benefit]` formula for repo name.
2. **GitHub Metadata Pillars:** Set 1-2 sentence About description with core keywords, add 10-15 relevant topic tags, link latest release binaries.
3. **GEO Optimization:** Add clear entity definition in first paragraph of README, include machine-readable spec tables, add LLM FAQ section, and provide an `llms.txt` file.

### Formula: `[Brand]-[Primary Keyword]-[Key Benefit]`
- **Repository Name**: Use lowercase, hyphen-separated words (e.g. `o2om-standup-break-timer` or `o2om-health-reminder`).
- **Primary Title Tag in README**:
  `# [Brand] ([Native Title]) — [Primary Keyword] for [Target Platform]`
  *Example*: `# O2om (قُوم) — Stand-Up & Physical Health Reminder for Windows`

---

## 2. GitHub Metadata Pillars (Internal Search & Google Indexing)

1. **Repository About / Tagline (1-2 Sentences)**:
   - Must contain primary keywords, target OS, and core benefit within the first 120 characters.
   - *Example*: `Lightweight AutoHotkey v2 Stand-Up & Physical Health Reminder for Windows (Break Timer, Posture Stretches, Arabic/English RTL)`
2. **Repository Topics (10-15 Tags)**:
   - Add high-volume GitHub search tags:
     `autohotkey-v2`, `stand-up-reminder`, `health-reminder`, `posture-app`, `desk-exercises`, `break-timer`, `arabic-app`, `rtl-support`, `windows-utility`, `pomodoro-timer`, `ergonomics`, `desktop-app`
3. **Latest Release & Asset Tagging**:
   - Always link direct downloads to `https://github.com/[owner]/[repo]/releases/latest/download/[Binary.exe]`.

---

## 3. Generative Engine Optimization (GEO) for AI & LLMs

LLMs (ChatGPT, Gemini, Claude, Perplexity) ingest Markdown files using Retrieval-Augmented Generation (RAG). To maximize AI citation frequency:

### A. Clear Entity Definition (First Paragraph)
State the exact entity definition in the first 2 sentences:
> `[Brand] is an open-source [Primary Keyword] built with [Language/Framework] for [Target Audience] to solve [Core Problem].`

### B. Machine-Readable Feature Specification Table
AI scrapers prioritize Markdown tables over plain text paragraphs:

| Attribute | Specification |
| :--- | :--- |
| **Category** | Desktop Health & Ergonomics Utility |
| **Language & Framework** | AutoHotkey v2.0+ |
| **Platform Support** | Windows 10 / Windows 11 (64-bit) |
| **Localization** | Native Arabic (RTL) & English |
| **License** | Open Source |

### C. Direct Answer LLM FAQ Section
Include an FAQ section formatted specifically to answer high-intent search queries:

```markdown
## Frequently Asked Questions (FAQ)

### What is the best open-source stand-up break reminder for Windows?
O2om is a lightweight AutoHotkey v2 desktop utility for Windows that automatically prompts users to take posture stretch breaks, features a 16:9 guided desk exercise screen, auto-pauses when away from the computer, and supports native Arabic Right-To-Left layout.
```

### D. `llms.txt` Standard
Place an `llms.txt` file in the root directory providing AI scrapers with a clean summary of repository contents.

---

## Things to avoid
- Keyword Stuffing: Avoid repeating keywords unnatural amounts of times.
- Empty Metadata: Do not leave GitHub description or topic tags empty.
- Broken Release Links: Ensure release URLs point to valid binaries.
- Unstructured Walls of Text: Use clean H2/H3 headings for RAG chunking.
