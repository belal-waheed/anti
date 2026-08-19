---
name: react-frontend
description: Conventions for React and TypeScript frontend architecture with Vite or Next.js. Covers feature-sliced folder structures, custom hook design with cancellation, component composition, state colocation, and unit testing with Vitest. Use when creating or editing React components, pages, custom hooks, or frontend services.
---

# Modern React & TypeScript Architecture Guide

## When to use this skill
Trigger whenever developing or structuring React applications with TypeScript (Vite SPAs, Next.js, or shared component libraries), writing custom hooks, or creating frontend feature modules.

---

## 1. Feature-Sliced Architecture

Organize code by business domain/feature rather than technical type:

```
src/
  ├── assets/          # Static assets & SVGs
  ├── components/      # Shared primitive UI components (Button, Modal, Input)
  ├── features/        # Feature modules
  │    └── auth/
  │         ├── components/
  │         │    └── LoginForm.tsx
  │         ├── hooks/
  │         │    └── useAuth.ts
  │         ├── services/
  │         │    └── authApi.ts
  │         └── types/
  │              └── auth.types.ts
  ├── hooks/           # App-wide custom hooks
  ├── lib/             # Shared utilities (cn, formatting)
  └── routes/          # Application routing / pages
```

---

## 2. Production Custom Hook Pattern with AbortController

Always support request cancellation to prevent race conditions and memory leaks:

```ts
// src/features/projects/hooks/useProject.ts
import { useState, useEffect } from 'react';
import type { Project } from '../types/project.types';
import { fetchProjectById } from '../services/projectApi';

interface UseProjectState {
  project: Project | null;
  isLoading: boolean;
  error: string | null;
}

export function useProject(projectId: string): UseProjectState {
  const [state, setState] = useState<UseProjectState>({
    project: null,
    isLoading: true,
    error: null,
  });

  useEffect(() => {
    const controller = new AbortController();

    async function load() {
      setState((prev) => ({ ...prev, isLoading: true, error: null }));
      try {
        const data = await fetchProjectById(projectId, controller.signal);
        setState({ project: data, isLoading: false, error: null });
      } catch (err: any) {
        if (err.name !== 'AbortError') {
          setState({ project: null, isLoading: false, error: err.message || 'Failed to fetch project' });
        }
      }
    }

    load();

    return () => {
      controller.abort();
    };
  }, [projectId]);

  return state;
}
```

---

## 3. Component Composition & State Colocation

- **Colocate State**: Keep state inside the lowest possible component tree node where it is consumed.
- **Compound Components**: For complex components (e.g. `Dialog`, `Dropdown`, `Tabs`), use compound patterns rather than passing 10+ configuration props.
- **Explicit Prop Types**: Never use `any` or loose `Record<string, any>` for component props.

---

## Things to Avoid

- Avoid prop drilling past 2 levels; lift to Context or state manager.
- Never omit dependency arrays or cleanup return functions in `useEffect` when subscribing to events or fetching data.
- Avoid using indexes as React keys for lists that can reorder, filter, or delete items.
- Avoid mixing business logic and raw fetch calls directly inside presentation JSX components.
