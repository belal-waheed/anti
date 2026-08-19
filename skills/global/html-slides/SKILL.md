---
name: html-slides
description: Build presentations as a single self-contained HTML file that behaves like PowerPoint — one full-viewport slide per "page," next/previous navigation via buttons, arrow keys, and swipe, a progress bar and slide counter — but is just HTML, CSS, and JS, so it opens offline in any browser with no software installed and can contain anything a webpage can (animation, embedded charts, video, live code, interactive widgets). Use this whenever the user wants a slide deck, pitch deck, or presentation as an HTML file instead of a PowerPoint/.pptx file, says they want it to work "offline," "in the browser," or "interactive," or asks to turn an outline, PDF, or existing .pptx into a browser-based slideshow. Prefer this over the pptx skill specifically when the deliverable should be HTML/web output rather than an editable Office file.
---

# HTML Slides

A presentation is really just an outline with strong pacing — one idea per screen, in order, with a way to step through them. PowerPoint happens to be the most common tool for that, but nothing about the format requires PowerPoint specifically. A single HTML file with inline CSS and JS can do the same job — full-screen "slides," next/previous navigation — while also opening on any device with a browser, needing no install, and allowing anything a webpage can do: real animation, embedded charts, video, live code demos, clickable interactions.

## When to use this vs. pptx

- The user wants a file they can open and edit in PowerPoint, Keynote, or Google Slides → use `.pptx` generation.
- The user wants something to open directly in a browser, run with zero setup, embed on a website, present from any laptop without PowerPoint installed, or that needs real interactivity → use this skill.

## Steps

1. **Get the content plan first**: Title, main sections, slide count.
2. **Start from `assets/template.html`**: Copy it and edit it. It already has working slide navigation, keyboard and touch-swipe controls, a progress bar, and CSS variables for theming.
3. **Fill in content by editing `<section class="slide">` blocks**: Each section is a full slide. Keep one idea per slide.
4. **Design pass**: All theming lives in `:root` CSS variables (bg, fg, muted, accent, fonts). Pick colors and typography deliberately for the subject.
5. **Keep it actually offline**: No CDN links. Embedded SVG icons and system fonts (or base64 webfonts).
6. **Save as a single `.html` file**: Opens cleanly by double-clicking in any browser.

## How the template works

- Slides are stacked with absolute positioning and cross-fade/slide between each other via CSS transitions.
- `current` index drives `.active` slide state, counter text, progress bar width, and URL hash (`#1`, `#2`).
- Controls: Prev/Next buttons, arrow keys (`←/→/↑/↓`), `PageUp/PageDown`, `Space`, `Home/End`, `F` for fullscreen, and left/right touch swipe.

## Things to avoid
- Avoid external CDN links or remote dependencies to maintain offline support.
- Avoid overcrowding slides; keep strictly to one main idea per slide.
