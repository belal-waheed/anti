---
name: web-perf-audit
description: Production workflows and optimization standards for Web Performance, Core Web Vitals (LCP, INP, CLS), JavaScript bundle size reduction, image optimization, critical rendering path, and WCAG AA accessibility. Use when auditing page speed, fixing performance regressions, or optimizing frontend builds.
---

# Web Performance & Core Web Vitals Optimization Guide

## When to use this skill
Trigger whenever auditing page load speed, optimizing bundle sizes in Vite/Next.js, tuning Core Web Vitals (LCP, INP, CLS), or resolving accessibility/rendering bottlenecks.

---

## 1. Core Web Vitals Metrics & Targets

| Metric | Target | Focus Area | Primary Optimizations |
| :--- | :--- | :--- | :--- |
| **LCP** (Largest Contentful Paint) | $le 2.5	ext{s}$ | Hero element load time | Preload hero image/font, SSR critical HTML, remove render-blocking CSS. |
| **INP** (Interaction to Next Paint) | $le 200	ext{ms}$ | Main-thread responsiveness | Yield main thread (`scheduler.yield()`), debounce inputs, offload heavy compute to Web Workers. |
| **CLS** (Cumulative Layout Shift) | $le 0.1$ | Visual stability | Set explicit `width`/`height` on images/embeds, reserve space for dynamic content, avoid injecting DOM above viewport. |

---

## 2. JavaScript Bundle Optimization

### A. Dynamic Imports & Code Splitting
```tsx
import dynamic from 'next/dynamic';

// Split heavy non-critical components (charts, modals, rich text)
const DataChart = dynamic(() => import('@/components/DataChart'), {
  ssr: false,
  loading: () => <div className="h-64 animate-pulse rounded-lg bg-surface-muted" />
});
```

### B. Tree-Shaking & Direct Barrel Imports
```ts
// BAD: Imports entire icon bundle (adds 500KB+ to bundle)
import { ChevronRight, Check } from 'lucide-react';

// GOOD: Direct import or modern package bundler with tree-shaking
import ChevronRight from 'lucide-react/dist/esm/icons/chevron-right';
import Check from 'lucide-react/dist/esm/icons/check';
```

---

## 3. Font & Asset Delivery
* **Font Display**: Always use `font-display: swap;` with preloaded WOFF2 subset files.
* **Images**: Serve modern formats (AVIF / WebP) with explicit `srcset` and `sizes` attributes.
* **Hero Image Priority**: Mark above-the-fold hero images with `priority` / `fetchpriority="high"` and never `loading="lazy"`.

---

## 4. WCAG AA Accessibility Checklist
* **Contrast**: Text contrast ratio $ge 4.5:1$ (large text $ge 3:1$).
* **Focus Rings**: Never remove `outline: none` without providing a visible custom focus ring (`focus-visible:ring-2`).
* **Interactive Elements**: All interactive controls must have accessible names (`aria-label` or visible label) and keyboard navigability (`Enter`, `Space`, `Tab`).
