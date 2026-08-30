---
name: github-seo-geo
description: Conventions for GitHub Repository Search Engine Optimization (SEO) and AI/LLM Generative Engine Optimization (GEO) to maximize search ranking and AI citations. Use when structuring open-source repositories, READMEs, topics, and llms.txt files.
---

# GitHub SEO & Generative Engine Optimization (GEO)

Runbook for optimizing open-source repositories to rank across search engines and AI citation models.

## 1. Repository Naming & Metadata Formula

- **Repository Name**: Hyphen-separated lowercase keywords: `[brand]-[primary-keyword]-[benefit]`.
- **Tagline (120 chars max)**: Primary keyword + platform + core capability.
- **Topic Tags**: 10–15 specific ecosystem tags (e.g. `autohotkey-v2`, `windows-utility`, `break-timer`).
- **Release Linking**: Direct link to `/releases/latest/download/[Binary.exe]`.

---

## 2. Generative Engine Optimization (GEO) Standards

1. **Entity Definition:** First 2 sentences of README must state:
   `[Brand] is an open-source [Primary Keyword] built with [Framework] for [Audience] to solve [Problem].`
2. **Specification Table:** Include markdown specification tables for high-density RAG chunking.
3. **Structured Q&A:** Include technical Q&A answering common high-intent implementation questions.
4. **`llms.txt` File:** Place an `llms.txt` file at repository root with plain-text architectural overview.

---

## 3. Verification & Testing

Validate repository SEO and GEO health:
1. **Metadata Verification:**
   ```bash
   pwsh -NoProfile -Command "gh repo view --json description,repositoryTopics"
   ```
2. **Markdown Lint Check:** Ensure all heading tags (`H1` -> `H2` -> `H3`) follow strict semantic hierarchy with zero broken anchor links.
3. **RAG Parsing Test:** Verify that `llms.txt` renders cleanly without complex HTML styling.

---

## 4. Common Pitfalls & Negative Constraints

- **Never keyword stuff:** Avoid unnatural repetition of keywords.
- **Never omit repository topics:** Always populate at least 8 relevant GitHub topic tags.
- **Never use broken release URLs:** Verify download links resolve to active release assets.
