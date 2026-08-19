---
name: redis-caching
description: Conventions for using Redis for caching, sessions, and rate limiting in Node.js or ASP.NET Core backends. Use when adding a cache layer, session store, queue, or rate limiter backed by Redis.
---

# Redis Caching

## When to use this
Any time Redis is used for caching, sessions, rate limiting, or as a lightweight queue/pub-sub layer.

## Steps
1. **Implement Cache-Aside Pattern:** Read from Redis first, fall back to DB on miss, then write back to Redis. Wrap logic in repository/service layer. Set explicit TTL for every key.
2. **Standardize Keys:** Centralize namespaced, predictable key patterns (`user:{id}`, `session:{token}`). Version keys when data schema changes.
3. **Handle Invalidation:** Invalidate specific keys immediately upon data mutation. Prefer short TTLs for multi-key dependencies.
4. **Sessions & Rate Limiting:** Store minimal session data with matching TTL. Use atomic operations (`INCR` + `EXPIRE` or Lua scripts) for rate limiting.
5. **Ensure Resilience:** Treat Redis as a non-fatal cache optimization; degrade gracefully to the DB if Redis fails.

## Things to avoid
- Avoid un-expiring cached keys without explicit TTLs.
- Avoid building ad-hoc un-namespaced key strings inline across call sites.
- Avoid read-then-write rate limiting in application code (causes race conditions).
- Avoid failing user requests when Redis is unavailable (unless Redis is explicitly the system of record).
