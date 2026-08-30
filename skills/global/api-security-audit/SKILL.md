---
name: api-security-audit
description: Security auditing workflows and defensive patterns for REST APIs, OWASP API Security Top 10, JWT/Session hardening, CORS/CSP headers, rate limiting, and input sanitization across Node.js, Express, and ASP.NET Core. Use when performing security audits, hardening API endpoints, or reviewing auth logic.
---

# API Security & OWASP Hardening Guide

## When to use this skill
Trigger whenever auditing backend endpoints, configuring authentication/authorization, setting security headers, implementing rate limiting, or hardening against OWASP API Security risks.

---

## 1. OWASP API Security Top 10 Defenses

### A. Broken Object Level Authorization (BOLA / IDOR)
Always verify that the authenticated user owns the requested resource:
```ts
// BAD: Relies solely on route parameter ID
const order = await db.order.findById(req.params.id);

// GOOD: Scopes query by authenticated tenant/user ID
const order = await db.order.findOne({
  _id: req.params.id,
  userId: req.user.id
});
if (!order) return res.status(404).json({ error: 'Resource not found' });
```

### B. Strict Schema Validation at the Edge
Validate every request payload with Zod before controller execution:
```ts
export const UpdateProfileSchema = z.object({
  body: z.object({
    displayName: z.string().min(1).max(50).trim(),
    bio: z.string().max(500).optional(),
  }).strict() // Reject unexpected extra fields (Mass Assignment defense)
});
```

---

## 2. HTTP Security Headers
Ensure the following headers are configured via middleware (e.g. Helmet / ASP.NET middleware):

```ts
// Content-Security-Policy
"Content-Security-Policy": "default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline'; object-src 'none';"

// Strict-Transport-Security (HSTS)
"Strict-Transport-Security": "max-age=31536000; includeSubDomains; preload"

// Framing & MIME Sniffing
"X-Frame-Options": "DENY"
"X-Content-Type-Options": "nosniff"
"Referrer-Policy": "strict-origin-when-cross-origin"
```

---

## 3. Rate Limiting & Abuse Prevention
Protect public and auth endpoints with distributed sliding-window rate limiting (Redis-backed):
* **Auth Endpoints** (`/login`, `/reset-password`): $le 5$ requests / 15 minutes per IP.
* **Public APIs**: $le 100$ requests / minute per IP / token.
