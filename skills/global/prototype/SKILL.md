---
name: prototype
description: Rapidly builds throwaway spike code, isolated experiments, and proof-of-concept scripts to answer technical questions and validate libraries before production implementation. Use when testing unverified APIs, validating SDK compatibility, or evaluating implementation trade-offs in scratch directories.
---

# Prototype: Throwaway Spike & Hypothesis Validation

Runbook for executing rapid, isolated experiments to test technical hypotheses without polluting production codebases.

## 1. The 4-Step Spike Protocol

```
[Technical Question / Unverified API Hypothesis]
                       │
                       ▼
 1. HYPOTHESIS & BOUNDARY DEFINITION
 • State exact question (e.g. "Does Neon WebSocket work in Cloudflare Worker?")
 • Restrict file changes strictly to scratch/ or isolated test scripts
                       │
                       ▼
 2. RAPID EXPERIMENTAL IMPLEMENTATION
 • Write minimum code needed to produce a boolean answer
 • Ignore clean architecture layers; optimize purely for test speed
                       │
                       ▼
 3. PROOF & TELEMETRY COLLECTION
 • Execute script, log response payloads, latency, and failure modes
                       │
                       ▼
 4. HARVEST & DISCARD (The Golden Rule)
 • Extract winning architecture pattern to production / ADR
 • Delete or archive scratch test files
```

---

## 2. Scratch Sandbox Pattern

Place all spike scripts in the isolated conversation scratch directory:

```bash
# Scratch Script Location
<appDataDir>/brain/<conversation-id>/scratch/test_spike.js
# Or local temporary workspace script
./scratch/api-test.mjs
```

### Example Node.js Spike Script
```javascript
// scratch/test-neon-connection.mjs
import { Client } from 'pg';

async function testConnection() {
  const client = new Client({ connectionString: process.env.DATABASE_URL });
  try {
    const start = Date.now();
    await client.connect();
    const res = await client.query('SELECT NOW() as server_time');
    console.log('[SPIKE SUCCESS]:', res.rows[0], `Latency: ${Date.now() - start}ms`);
  } catch (err) {
    console.error('[SPIKE FAILED]:', err.message);
  } finally {
    await client.end();
  }
}

testConnection();
```

---

## 3. Verification & Testing

Validate experimental findings:
1. **Hypothesis Assertion Command:**
   ```bash
   node ./scratch/api-test.mjs
   ```
2. **Failure Mode Test:** Test invalid credentials or network disconnects to observe exact error codes.
3. **Artifact Summary:** Document the conclusion in a 3-bullet technical memo before writing production code.

---

## 4. Common Pitfalls & Negative Constraints

- **Never merge spike code directly into production:** Always rewrite the confirmed pattern using proper layered architecture (Controller -> Service -> Repository).
- **Never install global packages for spikes:** Use local project dependencies or npx one-liners.
- **Never leave scratch scripts in root directories:** Keep experimental code isolated in `scratch/`.
