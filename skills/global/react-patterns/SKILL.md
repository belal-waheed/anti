---
name: react-patterns
description: Advanced React 19 patterns for Next.js App Router projects specifically — Server Components, Server Actions, use() hook, useActionState, useOptimistic, Suspense boundaries, Error Boundaries, custom hooks, and compound components. Trigger only in Next.js App Router codebases.
---

# React Patterns

## When to use this
Advanced React 19 patterns in Next.js App Router projects specifically — Server Components, Server Actions, `use()`, `useActionState`, `useOptimistic`, Suspense boundaries, and compound components.

## Steps
1. **Scope Usage:** Use these patterns strictly in Next.js App Router projects (not plain Vite SPAs).
2. **Server Components:** Default to Server Components, keeping `'use client'` strictly at leaf components requiring state/interactivity.
3. **React 19 Hooks:** Use `use()` for Promises/Context, `useActionState` for form submissions, and `useOptimistic` for instantaneous UI updates.
4. **Suspense & Error Boundaries:** Wrap asynchronous rendering components in `<Suspense>` boundaries.
5. **Component Composition:** Prefer compound components and colocate state as close as possible to consumers.

## Things to avoid
- Don't use React 19 Server Component/Action patterns in plain client-side Vite SPAs.
- Don't overuse `React.memo` or `useCallback` without profiling real re-render bottlenecks.
- Avoid unstable or index-only keys when rendering dynamic lists.

## 1. use() Hook (React 19)

`use()` reads values from Promises and Context directly in render. Unlike standard hooks, `use()` can be called inside conditionals and loops.

```tsx
import { use } from 'react';

function UserProfile({ userPromise }: { userPromise: Promise<User> }) {
  const user = use(userPromise);
  return <h1>{user.name}</h1>;
}

function ThemeButton() {
  const theme = use(ThemeContext);
  return <button style={{ background: theme.primary }}>Click</button>;
}
```

Wrap components using `use(promise)` with a `<Suspense>` boundary.

## 2. Server Components

```tsx
// app/users/page.tsx - Server Component (default)
import { UserList } from './UserList';

export default async function UsersPage() {
  const users = await fetch('https://api.example.com/users', {
    next: { revalidate: 60 },
  }).then(r => r.json());

  return <UserList users={users} />;
}
```

Keep `'use client'` as deep in the component tree as possible — only on leaf components requiring state or interactivity.

## 3. Server Actions

```tsx
// app/actions.ts
'use server';

import { revalidatePath } from 'next/cache';
import { redirect } from 'next/navigation';

export async function createPost(formData: FormData) {
  const title = formData.get('title') as string;
  const body = formData.get('body') as string;

  await db.insert(posts).values({ title, body });

  revalidatePath('/posts');
  redirect('/posts');
}
```

## 4. useActionState (React 19)

```tsx
'use client';

import { useActionState } from 'react';
import { createUser } from './actions';

function SignupForm() {
  const [state, formAction, isPending] = useActionState(createUser, {
    errors: {},
    message: '',
  });

  return (
    <form action={formAction}>
      <input name="email" />
      {state.errors?.email && <p>{state.errors.email}</p>}
      <button disabled={isPending}>
        {isPending ? 'Creating...' : 'Sign Up'}
      </button>
      {state.message && <p>{state.message}</p>}
    </form>
  );
}
```

## 5. useOptimistic (React 19)

```tsx
'use client';

import { useOptimistic } from 'react';
import { likePost } from './actions';

function LikeButton({ count, postId }: { count: number; postId: string }) {
  const [optimisticCount, addOptimistic] = useOptimistic(count);

  async function handleLike() {
    addOptimistic(prev => prev + 1);
    await likePost(postId);
  }

  return (
    <form action={handleLike}>
      <button type="submit">{optimisticCount} Likes</button>
    </form>
  );
}
```

## 6. Suspense Boundaries

```tsx
import { Suspense } from 'react';

function Dashboard() {
  return (
    <div>
      <Suspense fallback={<StatsSkeleton />}>
        <StatsPanel />
      </Suspense>
      <div className="grid grid-cols-2">
        <Suspense fallback={<ChartSkeleton />}>
          <RevenueChart />
        </Suspense>
        <Suspense fallback={<ListSkeleton />}>
          <RecentActivity />
        </Suspense>
      </div>
    </div>
  );
}
```

## 7. Compound Components

```tsx
function Tabs({ children }: { children: ReactNode }) {
  const [active, setActive] = useState(0);
  return (
    <TabsContext.Provider value={{ active, setActive }}>
      <div role="tablist">{children}</div>
    </TabsContext.Provider>
  );
}

Tabs.Tab = function Tab({ index, children }: { index: number; children: ReactNode }) {
  const { active, setActive } = use(TabsContext);
  return (
    <button
      role="tab"
      aria-selected={active === index}
      onClick={() => setActive(index)}
    >
      {children}
    </button>
  );
};

Tabs.Panel = function Panel({ index, children }: { index: number; children: ReactNode }) {
  const { active } = use(TabsContext);
  if (active !== index) return null;
  return <div role="tabpanel">{children}</div>;
};
```

## 8. Performance Rules

- Colocate state: keep state as close as possible to where it is consumed
- Prefer component composition over prop drilling beyond 2 levels
- Use `React.memo` and `useCallback` only when profiling shows real re-render bottlenecks
- Always provide key attributes on lists using stable, unique IDs
