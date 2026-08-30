---
name: sql-query-optimizer
description: Runbooks and diagnostic patterns for SQL query plan analysis, EXPLAIN ANALYZE interpretation, index strategy, and N+1 query elimination across PostgreSQL, Supabase, and SQL Server. Use when optimizing slow database queries, tuning indexes, or resolving database bottlenecks.
---

# SQL Query & Index Optimization Guide

Runbook for diagnosing slow database queries, auditing execution plans, and tuning composite indexes.

## 1. Execution Plan Diagnosis (`EXPLAIN ANALYZE`)

### PostgreSQL / Supabase
```sql
EXPLAIN (ANALYZE, BUFFERS, VERBOSE)
SELECT u.id, u.email, COUNT(o.id) AS total_orders
FROM users u
JOIN orders o ON o.user_id = u.id
WHERE u.created_at >= '2026-01-01'
GROUP BY u.id, u.email
ORDER BY total_orders DESC
LIMIT 50;
```

### Key Bottlenecks
* **Seq Scan**: Missing index on filtered column.
* **Bitmap Heap Scan with High Filter Loss**: Composite index needed.
* **Nested Loop (High Cost)**: Unindexed foreign key in join condition.
* **Sort (Disk / external merge)**: Sort exceeded `work_mem`; add index matching `ORDER BY`.

---

## 2. Strategic Index Design

- **Composite Index Order:** Equality columns first, range columns last:
  ```sql
  CREATE INDEX idx_orders_tenant_status_created ON orders (tenant_id, status, created_at DESC);
  ```
- **Partial Indexes:** Index only hot subsets:
  ```sql
  CREATE INDEX idx_notifications_unread ON notifications (user_id) WHERE is_read = false;
  ```
- **Covering Indexes (`INCLUDE`):** Eliminate heap lookups:
  ```sql
  CREATE INDEX idx_users_lookup ON users (email) INCLUDE (full_name, role);
  ```

---

## 3. N+1 Elimination

Always batch relations with `JOIN` or `WHERE id IN (...)` rather than looping over query results in application code.

---

## 4. Verification & Testing

Validate query speed and index usage:
1. **Execution Time Assertion:** Verify query latency is `< 50ms` on realistic data volumes.
2. **Index Usage Check:**
   ```sql
   SELECT indexrelname, idx_scan, idx_tup_read, idx_tup_fetch
   FROM pg_stat_user_indexes
   WHERE relname = 'orders';
   ```
3. **Execution Plan Check:** Confirm `EXPLAIN` output shows `Index Scan` or `Bitmap Index Scan` instead of `Seq Scan`.

---

## 5. Common Pitfalls & Negative Constraints

- **Never create redundant indexes:** An index on `(a, b)` already covers queries filtering strictly on `(a)`.
- **Avoid indexing low-cardinality boolean columns globally:** Use partial indexes (`WHERE is_active = true`) instead.
- **Never perform queries inside loops:** Always batch in a single SQL operation.
