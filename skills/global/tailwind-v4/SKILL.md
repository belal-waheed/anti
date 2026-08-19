---
name: tailwind-v4
description: Conventions and configuration standards for Tailwind CSS v4. Use when setting up, styling, or refactoring CSS in modern web applications using Tailwind v4, CSS-first @theme directives, OKLCH color palettes, container queries, custom @utility rules, and modern responsive layouts.
---

# Tailwind CSS v4 Guide & Modern Styling Patterns

## When to use this skill
Trigger whenever styling web applications with Tailwind CSS v4, defining modern `@theme` design tokens, working with OKLCH color palettes, container queries, or creating bespoke CSS utility architectures.

---

## 1. Tailwind v4 Core Architecture: CSS-First

Tailwind CSS v4 replaces `tailwind.config.js` with pure CSS configuration:

- **Single CSS Entrypoint**: `@import "tailwindcss";` in `src/index.css`.
- **The `@theme` Directive**: Define all design tokens, custom colors, fonts, and animation curves directly in CSS.
- **Modern Color Spaces (OKLCH)**: Use `oklch()` for perceptually uniform, vibrant color ramps that don't wash out across light and dark modes.

---

## 2. Production `index.css` Theme Configuration

```css
@import "tailwindcss";

@theme {
  /* Brand Typography */
  --font-sans: "Inter", -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
  --font-display: "Outfit", "Inter", sans-serif;
  --font-mono: "JetBrains Mono", "Fira Code", monospace;

  /* Custom OKLCH Color Palette (Warm Technical Archetype) */
  --color-brand-50: oklch(0.98 0.01 240);
  --color-brand-100: oklch(0.95 0.03 240);
  --color-brand-500: oklch(0.60 0.18 250);
  --color-brand-600: oklch(0.52 0.20 250);
  --color-brand-700: oklch(0.42 0.18 250);

  /* Bespoke Neutral Grays (Zero Plain Gray) */
  --color-surface-base: oklch(0.14 0.01 260);
  --color-surface-card: oklch(0.18 0.02 260);
  --color-surface-border: oklch(0.26 0.02 260);
  --color-text-primary: oklch(0.96 0.01 260);
  --color-text-muted: oklch(0.70 0.02 260);

  /* Fluid Spacing & Shadows */
  --shadow-subtle: 0 1px 2px 0 rgb(0 0 0 / 0.05);
  --shadow-elevation: 0 10px 30px -10px oklch(0.10 0.02 260 / 0.5);
}

/* Custom Reusable Utilities in v4 */
@utility glass-panel {
  background: oklch(0.18 0.02 260 / 0.7);
  backdrop-filter: blur(12px);
  border: 1px solid oklch(0.28 0.02 260 / 0.4);
}

@utility text-glow {
  text-shadow: 0 0 12px oklch(0.60 0.18 250 / 0.4);
}
```

---

## 3. Container Queries & Modern Layout Patterns

In Tailwind v4, container queries are built-in without extra plugins:

```tsx
// Responsive Card using Container Queries (@container)
export function AnalyticsCard({ title, value, change }: MetricProps) {
  return (
    <div className="@container p-5 rounded-xl bg-[var(--color-surface-card)] border border-[var(--color-surface-border)] shadow-subtle hover:border-brand-500/40 transition-colors">
      <div className="flex flex-col @sm:flex-row @sm:items-center @sm:justify-between gap-2">
        <div>
          <p className="text-xs uppercase tracking-wider text-[var(--color-text-muted)]">{title}</p>
          <p className="text-2xl @lg:text-3xl font-display font-semibold text-[var(--color-text-primary)] mt-1">{value}</p>
        </div>
        <span className="inline-flex items-center text-xs font-medium px-2.5 py-1 rounded-full bg-emerald-500/10 text-emerald-400 border border-emerald-500/20">
          {change}
        </span>
      </div>
    </div>
  );
}
```

---

## 4. Class Composition & Helper Utility (`cn`)

Always use a helper function to merge conditional classes cleanly without specificity collisions:

```ts
// src/lib/utils.ts
import { clsx, type ClassValue } from 'clsx';
import { twMerge } from 'tailwind-merge';

export function cn(...inputs: ClassValue[]): string {
  return twMerge(clsx(inputs));
}
```

---

## Things to Avoid

- Avoid creating a `tailwind.config.js` or `tailwind.config.ts` in Tailwind v4 projects — configure all tokens inside CSS using `@theme`.
- Avoid hardcoding arbitrary hex values (`bg-[#1a1a24]`) repeatedly across components — define semantic CSS variables in `@theme`.
- Avoid emoji icons in UI buttons and headers — use clean SVG icon sets (Lucide, Heroicons, Radix Icons).
- Avoid default browser focus rings — use custom `focus-visible:ring-2 focus-visible:ring-brand-500 focus-visible:outline-none`.
