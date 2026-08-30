---
name: ui-ux-design
description: Design craftsmanship and visual guidelines for building bespoke, high-craft user interfaces. Use when choosing typography pairings, curated color palettes, 8px spatial grid systems, elevation, accessible contrast, micro-interactions, or creating custom product designs that avoid generic AI aesthetics.
---

# UI/UX Design Craftsmanship & Anti-AI-Generic Design Guide

Design standards for bespoke, high-craft, accessible interfaces without generic AI clichés.

## 1. Core Craftsmanship Principles

1. **Reject AI Clichés:** No generic dark-slate + neon purple gradients. Build intentional color schemes tailored to the domain.
2. **Zero Emojis in UI:** Use clean SVG vector icons (Lucide, Heroicons, Radix Icons).
3. **Intentional Typography:** Pair a distinctive display header (e.g. *Outfit*, *Space Grotesk*) with a clean body sans (*Inter*, *Plus Jakarta Sans*).
4. **8px Spatial Grid:** All margins, paddings, and gaps must follow strict 8px increments (8, 16, 24, 32, 48, 64px).
5. **Interactive States:** Every interactive element must define Default, Hover (150ms), Active (`scale(0.98)`), and Focus-Visible rings.

---

## 2. Aesthetic Archetypes

- **Technical Swiss Precision:** Deep obsidian (`oklch(0.14 0.01 260)`), slate borders, electric blue accent (`oklch(0.65 0.19 250)`), JetBrains Mono + Inter.
- **Editorial Elegance:** Warm cream (`oklch(0.98 0.01 60)`), charcoal body (`oklch(0.20 0.02 60)`), serif headers (Newsreader) + clean body sans.
- **Modern Obsidian Dark:** Neutral graphite (`#161618`), card elevation (`#1E1E22`), amber/gold accent (`#E5A93C`), Outfit + Inter.

---

## 3. Spatial & Elevation Tokens

```css
/* 8px Spatial Grid */
--space-1: 4px;   /* Micro padding, icon gap */
--space-2: 8px;   /* Button inline gap */
--space-3: 12px;  /* Compact card padding */
--space-4: 16px;  /* Standard card padding */
--space-6: 24px;  /* Section spacing */
--space-8: 32px;  /* Container gutters */

/* Elevation Borders */
--border-subtle: 1px solid oklch(1 0 0 / 0.08);
--border-active: 1px solid oklch(0.65 0.19 250 / 0.5);
```

---

## 4. Verification & Testing

Validate design quality and accessibility:
1. **Contrast Ratio Verification:** Run Lighthouse or axe-core to ensure 100% WCAG AA compliance (min 4.5:1 for normal text).
2. **Keyboard Navigation Check:** Tab through all interactive components; verify visible focus rings.
3. **Responsive Grid Check:** Verify layouts scale without horizontal overflow across 320px, 768px, 1024px, and 1440px breakpoints.

---

## 5. Common Pitfalls & Negative Constraints

- **Never use emojis in buttons or headers:** Always use clean SVG icons.
- **Avoid low-contrast text:** Never place `#666` gray text on `#1a1a1a` backgrounds.
- **Never animate without purpose:** Every animation must communicate state change or hierarchy.
