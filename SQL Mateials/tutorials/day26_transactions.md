# Day 26: Transactions — Full Notes and Theory

---

## 1. What Transactions Are and Why They Matter

A **transaction** is a logical unit of work: one or more DML (or DDL with implicit commit) operations that either all succeed (and are made permanent with **COMMIT**) or all are undone (**ROLLBACK**). Transactions ensure data consistency and allow concurrent users to work without corrupting data. All examples use **hr.employees** and **hr.departments** (or backup tables for updates).

- **Transaction boundaries:** Begin implicitly with the first executable statement (or after a previous COMMIT/ROLLBACK). End with COMMIT (make changes permanent) or ROLLBACK (undo since last commit).
- **Use backup tables** (e.g. hr_emp_backup) for practice so production hr.employees is not modified.

---

## 2. ACID Properties

Transactions should be **ACID**:

- **Atomicity** — All changes in the transaction commit together or all roll back. No partial commit.
- **Consistency** — The database moves from one consistent state to another; constraints (PK, FK, CHECK) hold after the transaction.
- **Isolation** — Concurrent transactions do not see each other’s uncommitted changes in a way that breaks consistency. Oracle provides read-consistent snapshots and row-level locking.
- **Durability** — Once committed, changes persist even after a crash (written to redo log).

---

## 3. Explicit COMMIT and ROLLBACK

- **COMMIT** — Makes all changes since the last commit permanent. Releases locks. Starts a new transaction on the next statement.
- **ROLLBACK** — Undoes all changes since the last commit. Releases locks. Starts a new transaction on the next statement.

In PL/SQL you can issue COMMIT and ROLLBACK explicitly, or leave transaction boundaries to the client (e.g. application commits after a successful operation). For batch updates to hr.employees (or backup), decide whether to commit once at the end (one big transaction) or in chunks (e.g. COMMIT every N rows) to balance consistency and lock duration.

---

## 4. Isolation Levels (Read Committed, Serializable)

- **Read committed** (Oracle default) — A query sees only data committed before the query started. It does not see uncommitted changes from other sessions, or changes committed after the query started. This avoids dirty reads.
- **Serializable** — A transaction sees a consistent snapshot of the database as of the start of the transaction. If the transaction would be affected by changes committed by others after that snapshot, Oracle can raise an error so you can retry. Use when you need repeatable reads.

Set at session level when needed: `SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;`

---

## 5. Locking (Row-Level)

When you **UPDATE** (or **DELETE**) a row, that row is **locked**. Other sessions that try to UPDATE or DELETE the same row will **wait** until you COMMIT or ROLLBACK. This avoids lost updates and supports isolation. **SELECT** does not lock rows by default (unless you use **SELECT ... FOR UPDATE**). Oracle uses row-level locking, so other rows in the same table remain available to other sessions.

---

## 6. Transaction Design

- **Keep transactions short and focused.** Long transactions hold locks and increase the chance of blocking and deadlocks.
- **Do not leave transactions open during user input** (e.g. wait for user confirmation before committing). This can cause lock escalation and blocking.
- For **bulk updates** to hr.employees (or backup), consider **batch commits** (COMMIT every N rows) to avoid huge rollback segments and long locks, while still preserving logical units where required (e.g. “move all employees in dept 50 to 60” as one transaction).
- In PL/SQL, use **EXCEPTION** handler to **ROLLBACK** and then **RAISE** so the caller knows the transaction failed and no partial commit occurred.

---

## 7. Savepoints

**SAVEPOINT name** sets a point to which you can **ROLLBACK TO SAVEPOINT name** without rolling back the whole transaction. Useful for “try this step, and if it fails, undo only this step” while keeping earlier work.

```sql
UPDATE hr_emp_backup SET salary = salary * 1.05 WHERE employee_id = 100;
SAVEPOINT after_first;
UPDATE hr_emp_backup SET salary = salary * 1.10 WHERE employee_id = 101;
ROLLBACK TO SAVEPOINT after_first;
COMMIT;
```

Only the first update is committed. **ROLLBACK TO SAVEPOINT** does not end the transaction; you still need COMMIT or ROLLBACK. Reusing a savepoint name (same name again) moves the savepoint to the current point.

---

## 8. Long-Running Transactions and HR Batch Updates

For large batch updates:

- Use a **single transaction** only if the business requires all-or-nothing (e.g. move entire department).
- Otherwise, **commit in batches**, log progress, and design so that a failure can **resume or retry** from a known state (e.g. last committed batch id).
- Avoid holding locks over slow operations (network, user input).

---

## 9. Best Practices and Summary

- Use **COMMIT** only when a logical unit of work is complete.
- In PL/SQL blocks that perform DML, use **EXCEPTION WHEN OTHERS THEN ROLLBACK; RAISE;** so no partial commit on error.
- Use **SAVEPOINT** for optional steps that can be undone without losing prior work.
- Prefer **short transactions** and **batch commits** for bulk work where appropriate.

**Summary:** Transactions provide ACID behavior. Use COMMIT and ROLLBACK explicitly; use savepoints for partial rollback. Keep transactions short, use row-level locking awareness, and design batch updates on hr.employees (or backup) with clear commit strategy.

---

[← Day 25](./day25_triggers.md) | [Back to Learning Plan](../30-day-sql-plsql-learning-plan.md) | [Next: Day 27 →](./day27_performance_tuning.md)
