---
name: ui-ux-design
description: Design craftsmanship and visual guidelines for building bespoke, high-craft user interfaces. Use when choosing typography pairings, curated color palettes, 8px spatial grid systems, elevation, accessible contrast, micro-interactions, or creating custom product designs that avoid generic AI aesthetics.
---

# UI/UX Design Craftsmanship & Anti-AI-Generic Design Guide

## When to use this skill
Trigger whenever designing, styling, or evaluating user interfaces, picking color palettes, establishing typography hierarchies, structuring spatial layouts, designing micro-interactions, or building bespoke product aesthetics.

---

## 1. The Anti-AI-Generic Design Philosophy

1. **Reject AI Clichés**: Avoid generic dark slate backgrounds with purple/cyan neon gradients and emoji-stuffed buttons. Every application must feel purposefully crafted for its specific domain.
2. **Zero Emojis in UI**: Use clean, precise vector icons (Lucide, Heroicons, Radix Icons) instead of emojis. Emojis render inconsistently across platforms and degrade visual professionalism.
3. **Intentional Typography**: Pair a distinctive display font for headings with a high-legibility sans-serif for body text.
4. **Perceptual Color Harmony**: Use curated OKLCH or tailored HSL color ramps with distinct foreground/background contrast (WCAG AA minimum 4.5:1 for normal text).
5. **Generous Spatial Rhythm**: Build layouts strictly on an 8px grid (8, 16, 24, 32, 48, 64px) with ample breathing room.

---

## 2. Curated Aesthetic Archetypes

When starting a project, select a deliberate aesthetic archetype:

### A. Technical Swiss Precision (Developer Tools, Dashboards, IDEs)
- **Palette**: Deep obsidian black (`oklch(0.14 0.01 260)`), slate borders (`oklch(0.25 0.02 260)`), crisp electric blue accent (`oklch(0.65 0.19 250)`).
- **Fonts**: *JetBrains Mono* / *Space Grotesk* for headers + *Inter* for body.
- **Details**: 1px subtle borders, mono data tables, micro status badges, zero heavy blur.

### B. Editorial Elegance (Knowledge Bases, Writing Tools, Notes)
- **Palette**: Warm cream background (`oklch(0.98 0.01 60)`), charcoal text (`oklch(0.20 0.02 60)`), terracotta or forest accent.
- **Fonts**: *Newsreader* / *Fraunces* for headings + *Plus Jakarta Sans* for body.
- **Details**: Generous line heights (1.7), subtle serif quotes, clean horizontal dividers.

### C. Modern Obsidian Dark (Vaults, Focus Utilities, Desktop Apps)
- **Palette**: Neutral graphite (`#161618`), card elevation (`#1E1E22`), amber/gold accent (`#E5A93C`).
- **Fonts**: *Outfit* for headings + *Segoe UI* / *Inter* for body.
- **Details**: Smooth hover highlights, soft inset shadows, high contrast metadata badges.

---

## 3. The 8px Spatial Grid & Elevation Token System

```
Space Tokens:
  --space-1:  4px   (Micro padding, icon gap)
  --space-2:  8px   (Button inline gap, badge padding)
  --space-3: 12px   (Compact card padding, list item gap)
  --space-4: 16px   (Standard card padding, form input spacing)
  --space-6: 24px   (Section spacing, modal padding)
  --space-8: 32px   (Container gutters, page margin)
  --space-12: 48px  (Hero section padding)

Elevation Borders (Prefer subtle borders over heavy drop shadows):
  --border-subtle: 1px solid oklch(1 0 0 / 0.08)
  --border-active: 1px solid oklch(0.65 0.19 250 / 0.5)
```

---

## 4. Micro-Interactions & State Design

Every interactive element must define 4 distinct states:
1. **Default**: Clear visual affordance (cursor-pointer, clean contrast).
2. **Hover**: Smooth transition (150ms-200ms cubic-bezier), slight brightness or border shift.
3. **Active / Pressed**: Subtle scale down (`scale(0.98)`).
4. **Focus-Visible**: High-visibility outline/ring (`2px solid brand-accent`, 2px offset) for keyboard accessibility.

---

## Things to Avoid

- Never sprinkle emojis on buttons, cards, or status indicators — use SVG icons.
- Avoid low-contrast gray text on dark backgrounds (e.g. text `#555` on `#222` fails accessibility).
- Avoid generic default templates across different applications.
- Never animate elements purely for decoration; animation must guide focus or communicate state changes.
- Avoid noisy, multi-colored rainbow gradients.
