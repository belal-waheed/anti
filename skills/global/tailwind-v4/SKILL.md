---
name: tailwind-v4
description: Conventions and configuration standards for Tailwind CSS v4. Use when setting up, styling, or refactoring CSS in modern web applications using Tailwind v4, CSS-first @theme directives, OKLCH color palettes, container queries, custom @utility rules, and modern responsive layouts.
---

# Tailwind CSS v4 Guide & Modern Styling Patterns

Runbook for styling modern web applications with Tailwind CSS v4, `@theme` tokens, and OKLCH color spaces.

## 1. Tailwind v4 Core Architecture: CSS-First

- **Single CSS Entrypoint**: `@import "tailwindcss";` in `src/index.css`.
- **The `@theme` Directive**: Define all design tokens, custom colors, fonts, and animation curves directly in CSS.
- **Modern Color Spaces (OKLCH)**: Use `oklch()` for perceptually uniform, accessible color scales.

---

## 2. Production `index.css` Theme Configuration

```css
@import "tailwindcss";

@theme {
  /* Brand Typography */
  --font-sans: "Inter", -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
  --font-display: "Outfit", "Inter", sans-serif;
  --font-mono: "JetBrains Mono", "Fira Code", monospace;

  /* Custom OKLCH Color Palette */
  --color-brand-50: oklch(0.98 0.01 240);
  --color-brand-500: oklch(0.60 0.18 250);
  --color-brand-600: oklch(0.52 0.20 250);

  /* Bespoke Neutral Surfaces */
  --color-surface-base: oklch(0.14 0.01 260);
  --color-surface-card: oklch(0.18 0.02 260);
  --color-surface-border: oklch(0.26 0.02 260);
  --color-text-primary: oklch(0.96 0.01 260);
  --color-text-muted: oklch(0.70 0.02 260);
}

/* Custom Reusable Utilities */
@utility glass-panel {
  background: oklch(0.18 0.02 260 / 0.7);
  backdrop-filter: blur(12px);
  border: 1px solid oklch(0.28 0.02 260 / 0.4);
}
```

---

## 3. Container Queries & Class Composition

```tsx
import { clsx, type ClassValue } from 'clsx';
import { twMerge } from 'tailwind-merge';

export function cn(...inputs: ClassValue[]): string {
  return twMerge(clsx(inputs));
}

export function MetricCard({ title, value }: { title: string; value: string }) {
  return (
    <div className="@container p-5 rounded-xl bg-[var(--color-surface-card)] border border-[var(--color-surface-border)]">
      <div className="flex flex-col @sm:flex-row @sm:items-center @sm:justify-between gap-2">
        <p className="text-xs uppercase text-[var(--color-text-muted)]">{title}</p>
        <p className="text-2xl font-semibold text-[var(--color-text-primary)]">{value}</p>
      </div>
    </div>
  );
}
```

---

## 4. Verification & Testing

Validate CSS build and style correctness:
1. **Build Verification:**
   ```bash
   npm run build
   ```
2. **Lint & Style Check:**
   ```bash
   npm run lint
   ```
3. **Contrast Audit:** Verify text contrast ratios achieve WCAG AA (4.5:1 for normal text, 3:1 for large text).

---

## 5. Common Pitfalls & Negative Constraints

- **Never create `tailwind.config.js`:** Configure all tokens and utilities inside CSS using `@theme` and `@utility`.
- **Never use hardcoded arbitrary values:** Avoid `bg-[#12131a]`; use semantic CSS variables.
- **Never use emojis in UI:** Use Lucide or Heroicons vector icons.
- **Avoid missing focus rings:** Always supply `focus-visible:ring-2 focus-visible:ring-brand-500`.
