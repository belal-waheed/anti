---
name: html-slides
description: Build presentations as a single self-contained HTML file that behaves like PowerPoint. Features offline browser presentation, keyboard/swipe navigation, progress bar, and embedded charts. Use when creating browser-based slide decks, pitch decks, or interactive presentations.
---

# HTML Slides: Browser-Based Presentations

Runbook for generating single-file, offline-capable, interactive HTML slide decks.

## 1. Core Workflow

1. **Content Structure:** Plan slide count and outline (strictly 1 core concept per slide).
2. **Template Instantiation:** Base presentation on `assets/template.html`.
3. **Slide Markup:** Implement each screen inside `<section class="slide">` blocks.
4. **Offline Assets:** Embed SVG vector icons directly; never link external CDN stylesheets or remote scripts.
5. **Theme Variables:** Configure color tokens and font families via `:root` CSS variables.

---

## 2. Navigation & Controls Architecture

- **Keyboard Support:** `ArrowLeft` / `ArrowRight`, `PageUp` / `PageDown`, `Space`, `Home` / `End`, `F` (toggle fullscreen).
- **Touch Support:** Touchstart/touchend delta detection for left/right swipe.
- **State Sync:** URL hash update (`#1`, `#2`) to preserve slide position on refresh.

---

## 3. Verification & Testing

Verify presentation functionality across browsers:
1. **Local Preview Command:**
   ```bash
   pwsh -NoProfile -Command "Start-Process 'msedge.exe' -ArgumentList @('file:///path/to/presentation.html')"
   ```
2. **Offline Integrity:** Disable network adapter and verify all fonts, SVGs, and scripts function with zero console errors.
3. **Keybinding Check:** Verify arrow keys cycle slides forwards/backwards cleanly.

---

## 4. Common Pitfalls & Negative Constraints

- **Never include external CDN URLs:** Scripts and styles must be fully bundled inline for offline execution.
- **Avoid text overcrowding:** Keep slide text sparse; use visual diagrams and key bullets.
- **Avoid layout jumping:** Ensure all slide containers share identical aspect ratio containers (`16:9`).
