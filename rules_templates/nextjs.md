# Next.js & React 19 Project Rules

- Use Next.js 15+ App Router architecture.
- Server Components by default; keep 'use client' strictly at leaf interactive components.
- Colocate feature logic within feature-sliced directories.
- Always implement request cancellation with AbortController in custom hooks.
- Use Tailwind CSS v4 CSS-first @theme tokens; zero inline style objects.
- Zero emojis in UI; use clean SVG vector icons (Lucide/Heroicons).
