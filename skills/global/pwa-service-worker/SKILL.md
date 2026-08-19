---
name: pwa-service-worker
description: Progressive Web App (PWA) patterns including service worker setup, caching strategies, offline support, manifest.json, and iOS/Android install support.
---

# PWA Service Worker Skill

## When to use this
Implementing Progressive Web App (PWA) capabilities, service workers, offline support, caching strategies, and app install manifests.

## Steps
1. **Create Web App Manifest:** Define `public/manifest.json` with icons, theme colors, and display mode.
2. **Add HTML Meta Tags:** Include viewport, theme-color, and iOS/Android manifest tags in `public/index.html`.
3. **Implement Service Worker:** Define static asset caching, API network-first fetching, and navigation fallbacks in `public/service-worker.js`.
4. **Register Service Worker:** Register `service-worker.js` in production entrypoint with update-detection logic.

## Things to avoid
- Never run service workers in development mode (`npm run build` only).
- Never serve service workers over non-HTTPS (localhost is the only exception).
- Never cache API responses with cache-first — use network-first strategy for `/api/*`.
- Avoid missing navigation fallback to `index.html` (causes blank offline screens).

## 1. public/manifest.json

```json
{
  "name": "App Name",
  "short_name": "App",
  "description": "Track your application offline",
  "start_url": "/",
  "scope": "/",
  "display": "standalone",
  "orientation": "portrait-primary",
  "background_color": "#ffffff",
  "theme_color": "#6366f1",
  "icons": [
    {
      "src": "/icons/icon-192.png",
      "sizes": "192x192",
      "type": "image/png"
    },
    {
      "src": "/icons/icon-512.png",
      "sizes": "512x512",
      "type": "image/png"
    },
    {
      "src": "/icons/icon-512.png",
      "sizes": "512x512",
      "type": "image/png",
      "purpose": "maskable"
    }
  ]
}
```

## 2. public/index.html — Meta Tags

```html
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />

  <!-- PWA theme -->
  <meta name="theme-color" content="#6366f1" />

  <!-- iOS support -->
  <meta name="apple-mobile-web-app-capable" content="yes" />
  <meta name="apple-mobile-web-app-status-bar-style" content="default" />
  <meta name="apple-mobile-web-app-title" content="App" />
  <link rel="apple-touch-icon" href="/icons/icon-192.png" />

  <!-- Android / standard -->
  <link rel="manifest" href="/manifest.json" />
  <link rel="icon" href="/icons/icon-192.png" />
</head>
```

## 3. public/service-worker.js

```js
const STATIC_CACHE = 'app-static-v1'
const API_CACHE = 'app-api-v1'

const STATIC_ASSETS = [
  '/',
  '/index.html',
  '/manifest.json',
  '/icons/icon-192.png',
  '/icons/icon-512.png',
]

// INSTALL
self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(STATIC_CACHE).then((cache) => {
      return cache.addAll(STATIC_ASSETS)
    }).then(() => self.skipWaiting())
  )
})

// ACTIVATE
self.addEventListener('activate', (event) => {
  const validCaches = [STATIC_CACHE, API_CACHE]
  event.waitUntil(
    caches.keys().then((keys) =>
      Promise.all(
        keys.map((key) => {
          if (!validCaches.includes(key)) {
            return caches.delete(key)
          }
        })
      )
    ).then(() => self.clients.claim())
  )
})

// FETCH
self.addEventListener('fetch', (event) => {
  const { request } = event
  const url = new URL(request.url)

  if (request.method !== 'GET' || !request.url.startsWith('http')) return

  // API calls -> Network First
  if (url.pathname.startsWith('/api/')) {
    event.respondWith(networkFirst(request, API_CACHE))
    return
  }

  // Navigation requests -> Serve index.html fallback
  if (request.mode === 'navigate') {
    event.respondWith(
      fetch(request).catch(() => caches.match('/index.html'))
    )
    return
  }

  // Static assets -> Cache First
  event.respondWith(cacheFirst(request, STATIC_CACHE))
})

async function cacheFirst(request, cacheName) {
  const cached = await caches.match(request)
  if (cached) return cached

  try {
    const networkResponse = await fetch(request)
    if (networkResponse.ok && networkResponse.type !== 'opaque') {
      const cache = await caches.open(cacheName)
      cache.put(request, networkResponse.clone())
    }
    return networkResponse
  } catch {
    return new Response('Offline', { status: 503 })
  }
}

async function networkFirst(request, cacheName) {
  try {
    const networkResponse = await fetch(request)
    if (networkResponse.ok) {
      const cache = await caches.open(cacheName)
      cache.put(request, networkResponse.clone())
    }
    return networkResponse
  } catch {
    const cached = await caches.match(request)
    if (cached) return cached

    return new Response(
      JSON.stringify({ success: false, message: 'You are offline' }),
      {
        status: 503,
        headers: { 'Content-Type': 'application/json' },
      }
    )
  }
}
```

## 4. SW Registration in App Entry

```tsx
if ('serviceWorker' in navigator && process.env.NODE_ENV === 'production') {
  window.addEventListener('load', () => {
    navigator.serviceWorker
      .register('/service-worker.js')
      .then((registration) => {
        registration.addEventListener('updatefound', () => {
          const newWorker = registration.installing
          newWorker?.addEventListener('statechange', () => {
            if (newWorker.state === 'installed' && navigator.serviceWorker.controller) {
              if (window.confirm('New version available! Refresh to update?')) {
                window.location.reload()
              }
            }
          })
        })
      })
  })
}
```

## Common Failures & Solutions

| Symptom | Cause | Fix |
|---|---|---|
| Blank screen offline | Navigation request not handled | Serve cached `index.html` on navigate failure |
| Old code after deploy | Cache version unchanged | Increment `STATIC_CACHE` version string |
| SW not activating immediately | `skipWaiting` omitted | Call `self.skipWaiting()` in install |
| API data cached when offline | Cache-first used on `/api/*` | Use network-first strategy for API routes |
