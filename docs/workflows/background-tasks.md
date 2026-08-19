# Background Tasks, Schedulers & Reactive Wakeup

Antigravity manages background commands, long-running processes, and schedulers natively.

---

## 1. One-Shot Timers & Cron Schedules

- **One-Shot Timer**: Triggers after `DurationSeconds` with condition policies (`never`, `any`, or sender ID).
- **Recurring Cron**: Triggers on a 5-field cron schedule (`*/5 * * * *`) with optional `MaxIterations`.

---

## 2. Long-Running Daemons & Task Management

- Launch commands with async execution.
- Monitor, send input, or cancel background processes via `manage_task` (`list`, `status`, `send_input`, `kill`).
