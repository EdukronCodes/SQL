# Day 5: DCL & TCL — Full Notes and Theory

---

## 1. DCL and TCL: What They Are and Why They Matter

**DCL (Data Control Language)** deals with **access control**: who can read or change which tables and objects. In Oracle you use **GRANT** and **REVOKE** to give or take away privileges on objects (e.g., **hr.employees**, **hr.departments**) or to assign **roles**. **TCL (Transaction Control Language)** deals with **transactions**: when changes become permanent (**COMMIT**) or are discarded (**ROLLBACK**), and how to create checkpoints (**SAVEPOINT**) within a transaction. Both are essential for secure and correct use of the database.

- **DCL** protects data by ensuring only authorized users (or roles) can query or modify HR tables.
- **TCL** ensures that multi-step updates (e.g., several UPDATEs on hr.employees) either all succeed and are committed together or are rolled back so the database stays consistent.
- In this course you will use **backup tables** (e.g., hr_emp_backup) for hands-on DML and TCL so that production hr.employees is not altered; DCL is typically run by the schema owner or DBA.

---

## 2. Object Privileges: GRANT and REVOKE

An **object privilege** is the right to perform a specific action on a specific object (e.g., SELECT on hr.employees). The **owner** of the object (e.g., user HR) can grant privileges to other users or to roles.

**Grant SELECT on hr.employees:**

```sql
-- Run as schema owner (e.g., HR)
GRANT SELECT ON hr.employees TO other_user;
```

**Grant multiple privileges:**

```sql
GRANT SELECT, INSERT, UPDATE ON hr.employees TO report_user;
```

**Revoke:**

```sql
REVOKE SELECT ON hr.employees FROM other_user;
```

- Common object privileges: **SELECT** (query), **INSERT**, **UPDATE**, **DELETE**, **EXECUTE** (for procedures). Grant only what is needed (**principle of least privilege**).
- After REVOKE, the user (or role) can no longer perform that action on that object. Existing sessions may retain the privilege until they reconnect, depending on the database.

---

## 3. System Privileges and Roles

**System privileges** allow broader actions (e.g., CREATE TABLE, CREATE SESSION, SELECT ANY TABLE). They are granted by DBAs and should be used sparingly.

**Roles** are named groups of privileges. You grant privileges to the role, then grant the role to users. This simplifies management (e.g., one role "hr_reader" for everyone who should only read HR tables).

**Example:**

```sql
CREATE ROLE hr_reader;
GRANT SELECT ON hr.employees TO hr_reader;
GRANT SELECT ON hr.departments TO hr_reader;
GRANT hr_reader TO report_user;
```

Users with **hr_reader** can then query hr.employees and hr.departments without needing direct object grants on each table.

---

## 4. TCL: COMMIT and ROLLBACK

A **transaction** is a logical unit of work. It starts implicitly when you connect or right after a previous COMMIT or ROLLBACK. It ends when you issue **COMMIT** or **ROLLBACK**.

- **COMMIT** makes **all** changes since the last COMMIT (or since the start of the session) **permanent**. Other sessions can then see the new data. After COMMIT, you cannot roll back those changes.
- **ROLLBACK** **undoes** all changes since the last COMMIT. The database restores the state to what it was at that point. Use ROLLBACK when you realize an UPDATE or DELETE was wrong.

**Example:** After `UPDATE hr_emp_backup SET salary = salary * 1.1 WHERE department_id = 50`:

- **COMMIT;** — the salary changes are permanent.
- **ROLLBACK;** — the salary changes are discarded.

Always verify the result (e.g., SELECT or SQL%ROWCOUNT) before committing.

---

## 5. Transaction Boundaries and Design

- A transaction should represent one **logical** unit of work (e.g., "move these employees to department 60" or "apply a raise to department 50"). Either the whole unit succeeds (COMMIT) or none of it does (ROLLBACK).
- **Keep transactions short.** Long-running uncommitted transactions hold locks and can block other users. Do not leave a transaction open during user input or long pauses.
- In **PL/SQL** or application code, you can explicitly COMMIT or ROLLBACK at the end of a procedure or after a batch of DML. In ad-hoc SQL, you commit or roll back after checking the result.

---

## 6. SAVEPOINT: Partial Rollback

A **SAVEPOINT** is a named point within the current transaction. You can **ROLLBACK TO SAVEPOINT name** to undo only the work done **after** that savepoint, while keeping the work done **before** it. This is useful in scripts where you want to try a step and, if something goes wrong, undo just that step without losing earlier steps.

**Example:**

```sql
UPDATE hr_emp_backup SET salary = salary * 1.05 WHERE employee_id = 100;
SAVEPOINT after_first_update;

UPDATE hr_emp_backup SET salary = salary * 1.10 WHERE employee_id = 101;
-- If something is wrong:
ROLLBACK TO SAVEPOINT after_first_update;

COMMIT;  -- Only the first update is committed
```

After ROLLBACK TO SAVEPOINT, only the second update is undone. The first update remains in the transaction and is committed by COMMIT.

---

## 7. Read Consistency and Locking

**Read consistency:** In Oracle, when a session runs a query, it sees a **consistent snapshot** of the data as of a point in time. It does **not** see uncommitted changes from other sessions. So your UPDATE is invisible to others until you COMMIT.

**Locking:** When you **UPDATE** (or DELETE) a row, that row is **locked**. Another session that tries to UPDATE the same row will **wait** until you COMMIT or ROLLBACK. This prevents lost updates and supports ACID (Atomicity, Consistency, Isolation, Durability). Locking is row-level in Oracle, so other rows in the table remain available to other sessions.

---

## 8. Best Practices for Production

1. Always use **WHERE** on UPDATE/DELETE and **verify** with SELECT first.
2. **COMMIT** only after confirming the result; use **ROLLBACK** if anything is wrong.
3. Use **SAVEPOINT** in multi-step scripts so you can roll back partway without losing everything.
4. Grant **minimal** privileges (object and system) and use **roles** for groups of users.
5. Avoid **long-running** uncommitted transactions to reduce blocking and lock contention.

---

## 9. Summary Points

- DCL (GRANT, REVOKE, roles) controls who can access hr.employees and hr.departments.
- TCL (COMMIT, ROLLBACK, SAVEPOINT) controls when changes become permanent and how to undo them.
- COMMIT makes changes visible and permanent; ROLLBACK discards all changes since the last COMMIT.
- SAVEPOINT allows partial rollback within a transaction.
- Use short transactions, verify before commit, and test on backup tables.

---

[← Day 4](./day04_dml_basics.md) | [Back to Learning Plan](../30-day-sql-plsql-learning-plan.md) | [Next: Day 6 →](./day06_single_table_queries.md)
