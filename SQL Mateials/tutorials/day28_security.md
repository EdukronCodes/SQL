# Day 28: Security — Full Notes and Theory

---

## 1. Why Security Matters

Database security includes **access control** (who can see or change what), **SQL injection** prevention, and **sensitive data** protection. Grant only required privileges, use bind variables, and expose data through views or procedures when you need to restrict columns or logic. All examples use **hr.employees** and **hr.departments**.

- **Principle of least privilege** — Grant the minimum privileges required.
- **Object privileges** — SELECT, INSERT, UPDATE, DELETE on specific tables; EXECUTE on procedures.
- **Roles** — Group privileges and grant the role to users.

---

## 2. Object Privileges (SELECT on hr.employees)

**Object privileges** control access to specific objects. To allow another user or role to query hr.employees:

```sql
GRANT SELECT ON hr.employees TO report_user;
```

Similarly: **INSERT**, **UPDATE**, **DELETE**, **EXECUTE** (for procedures). Grant only what is needed. The grantee must use the schema prefix (e.g. hr.employees) unless they have a synonym.

**REVOKE:** `REVOKE SELECT ON hr.employees FROM report_user;`

---

## 3. Roles

**Roles** group privileges. Create a role, grant privileges to the role, then grant the role to users:

```sql
CREATE ROLE hr_readonly;
GRANT SELECT ON hr.employees TO hr_readonly;
GRANT SELECT ON hr.departments TO hr_readonly;
GRANT hr_readonly TO app_user;
```

Revoke: `REVOKE hr_readonly FROM app_user;`  
Revoke privilege from role: `REVOKE SELECT ON hr.employees FROM hr_readonly;`

Prefer roles for groups of users (e.g. hr_readonly, hr_analyst) so you can change privileges in one place.

---

## 4. Principle of Least Privilege

Grant the **minimum** privileges required. Prefer **roles** and **object-level** grants (e.g. SELECT ON hr.employees) over broad **system** privileges like SELECT ANY TABLE. For reporting, grant only SELECT on the tables or views needed, not INSERT/UPDATE/DELETE.

---

## 5. SQL Injection and How to Avoid (Bind Variables)

**SQL injection** occurs when user input is **concatenated** into SQL, allowing attackers to change the query structure. **Always use bind variables** for user input:

```sql
-- Safe (bind variable)
EXECUTE IMMEDIATE 'SELECT first_name FROM hr.employees WHERE employee_id = :id'
  INTO v_name USING p_emp_id;

-- Unsafe (concatenation)
EXECUTE IMMEDIATE 'SELECT first_name FROM hr.employees WHERE employee_id = ' || p_emp_id
  INTO v_name;
```

In **static SQL** (no EXECUTE IMMEDIATE), use parameters (e.g. in procedures) so values are bound, not concatenated. Never build SQL by concatenating user or application input.

---

## 6. Invoker vs Definer Rights

- **Definer rights** (default) — Procedure runs with the **owner’s** privileges. Caller does **not** need direct access to the tables the procedure uses. Good for encapsulating logic and restricting access (callers only get what the procedure returns).
- **Invoker rights** — **AUTHID CURRENT_USER** — Procedure runs with the **caller’s** privileges. Use when the same procedure should act in the caller’s context (e.g. access caller’s tables).

```sql
CREATE OR REPLACE PROCEDURE list_employees AUTHID CURRENT_USER IS
  ...
```

Default is **AUTHID DEFINER**. For a procedure that only reads hr.employees and returns data, definer rights allow you to grant EXECUTE to users without granting SELECT on the table.

---

## 7. Sensitive Columns (Salary)

Restrict access to sensitive columns (e.g. **salary**, commission_pct):

- **Do not** grant SELECT on the base table to broad roles if they should not see salary.
- Use a **view** that omits salary (and other sensitive columns). Grant SELECT on the view.
- Or use a **procedure** that returns only allowed columns. Grant EXECUTE on the procedure.

This way users get employee names and department without seeing pay.

---

## 8. Best Practices and Summary

- **Least privilege;** use roles for groups.
- **Bind variables only;** no string concatenation of user input into SQL.
- **Audit** sensitive access if required (e.g. who queried salary).
- Prefer **definer-rights** procedures that encapsulate table access when you want to hide table structure and restrict columns.

**Summary:** Grant object and role privileges with least privilege. Use bind variables to prevent SQL injection. Use definer-rights procedures and views to restrict columns (e.g. hide salary) on hr.employees and hr.departments. Apply invoker rights only when the caller’s context is required.

---

[← Day 27](./day27_performance_tuning.md) | [Back to Learning Plan](../30-day-sql-plsql-learning-plan.md) | [Next: Day 29 →](./day29_advanced_reporting.md)
