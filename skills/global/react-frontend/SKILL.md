---
name: react-frontend
description: Conventions for React and TypeScript frontend architecture with Vite or Next.js. Covers feature-sliced folder structures, custom hook design with cancellation, component composition, state colocation, and unit testing with Vitest. Use when creating or editing React components, pages, custom hooks, or frontend services.
---

# Modern React & TypeScript Architecture Guide

Runbook for constructing scalable, type-safe React applications using feature-sliced architecture.

## 1. Feature-Sliced Architecture

```
src/
  ├── components/      # Shared primitive UI components (Button, Modal, Input)
  ├── features/        # Feature modules
  │    └── auth/
  │         ├── components/
  │         ├── hooks/
  │         ├── services/
  │         └── types/
  ├── hooks/           # App-wide custom hooks
  ├── lib/             # Shared utilities (cn, formatting)
  └── routes/          # Application routing / pages
```

---

## 2. Custom Hook Pattern with AbortController

Always support request cancellation to prevent race conditions:

```ts
import { useState, useEffect } from 'react';

export function useProject(projectId: string) {
  const [data, setData] = useState(null);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    const controller = new AbortController();

    async function load() {
      setIsLoading(true);
      try {
        const res = await fetch(`/api/projects/${projectId}`, { signal: controller.signal });
        const json = await res.json();
        setData(json);
      } catch (err: any) {
        if (err.name !== 'AbortError') console.error(err);
      } finally {
        setIsLoading(false);
      }
    }

    load();
    return () => controller.abort();
  }, [projectId]);

  return { data, isLoading };
}
```

---

## 3. Component Composition & Colocation

- **Colocate State:** Keep state inside the lowest component consuming it.
- **Compound Components:** Use composition for complex modals and dropdowns rather than prop-drilling 10+ booleans.
- **Typed Props:** Never use `any` for component props.

---

## 4. Verification & Testing

Validate component rendering and custom hook lifecycles:
1. **Unit & Hook Testing (RTL + Vitest):**
   ```bash
   npm test -- useProject.test.ts
   ```
2. **Component Snapshot & Accessibility:**
   ```bash
   npm test -- Button.test.tsx
   ```
3. **Type-Check Run:**
   ```bash
   npm run type-check || npx tsc --noEmit
   ```

---

## 5. Common Pitfalls & Negative Constraints

- **Never omit useEffect cleanup:** Always return abort or unsubscribe functions.
- **Never use array index as key:** Use unique stable entity IDs (`task.id`).
- **Never put raw fetch calls in JSX:** Abstract API requests into feature services.
