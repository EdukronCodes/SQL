# Day 22: Stored Procedures — Full Notes and Theory

---

## 1. What Stored Procedures Are and Why They Matter

A **stored procedure** is a named PL/SQL block stored in the database. It can take parameters (IN, OUT, IN OUT), perform queries and DML, and be called from other PL/SQL blocks or from SQL (CALL/EXEC). Procedures help centralize business logic, improve security (definer rights), and reduce network round-trips. All examples use **hr.employees** and **hr.departments**.

- **Procedure vs anonymous block:** Procedure has a name and is stored; it can be reused and called with arguments.
- **Procedure vs function:** Procedure does not return a value in the sense of RETURN; it can have OUT/IN OUT parameters to return multiple values or perform side effects (e.g. UPDATE, INSERT).

---

## 2. CREATE PROCEDURE Syntax

```sql
CREATE OR REPLACE PROCEDURE proc_name (
  p_param1 IN  datatype,
  p_param2 OUT datatype,
  p_param3 IN OUT datatype
) IS
  -- local variables (optional)
BEGIN
  -- executable statements
END;
/
```

- **CREATE OR REPLACE** — creates or overwrites the procedure.
- Parameters are optional but often used. Each has a mode: **IN** (default), **OUT**, or **IN OUT**.
- **IS** (or **AS**) starts the body; **END;** ends it. Semicolon after **END** and **/** executes the DDL.

---

## 3. IN, OUT, IN OUT Parameters

- **IN** — input only. Caller passes a value; the procedure cannot change the value for the caller. Default mode.
- **OUT** — output. Caller passes a variable; the procedure assigns a value to it; the caller reads it after the call. Initial value of OUT is NULL inside the procedure.
- **IN OUT** — input and output. Caller passes a variable; the procedure can read and modify it; the caller sees the change after the call.

**Example: get employee count by department (OUT)**

```sql
CREATE OR REPLACE PROCEDURE get_emp_count_by_dept (
  p_dept_id  IN  hr.departments.department_id%TYPE,
  p_count    OUT NUMBER
) IS
BEGIN
  SELECT COUNT(*) INTO p_count
  FROM hr.employees
  WHERE department_id = p_dept_id;
END;
/
```

**Call from PL/SQL:**

```sql
DECLARE
  v_count NUMBER;
BEGIN
  get_emp_count_by_dept(50, v_count);
  DBMS_OUTPUT.PUT_LINE('Count: ' || v_count);
END;
/
```

---

## 4. Procedure to Update Salary by employee_id

Procedures commonly perform DML. Use **SQL%ROWCOUNT** to check if any row was updated and optionally raise an error.

```sql
CREATE OR REPLACE PROCEDURE raise_salary (
  p_emp_id IN hr.employees.employee_id%TYPE,
  p_pct    IN NUMBER
) IS
BEGIN
  UPDATE hr.employees
  SET salary = salary * (1 + p_pct/100)
  WHERE employee_id = p_emp_id;
  IF SQL%ROWCOUNT = 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Employee not found: ' || p_emp_id);
  END IF;
  COMMIT;
END;
/
```

**Call:** `EXEC raise_salary(100, 10);` or from PL/SQL: `raise_salary(100, 10);`

Whether to **COMMIT** inside the procedure or leave it to the caller is a design choice; document it.

---

## 5. Calling from SQL and PL/SQL

- **From PL/SQL:** Call by name with arguments: `proc_name(arg1, arg2, ...);` For OUT parameters, pass variables: `proc_name(v_in, v_out);`
- **From SQL:** Use **EXEC** or **CALL** for procedures. If the procedure has OUT parameters, you must use a PL/SQL block from SQL: `BEGIN get_emp_count_by_dept(50, :v_count); END;` (with bind variable :v_count in SQL*Plus).

Procedures that query or update **hr.employees** follow the same pattern: pass IDs or filter values (IN), optionally return counts or messages via OUT parameters.

---

## 6. Default Parameter Values

You can give default values to IN parameters so callers can omit them:

```sql
CREATE OR REPLACE PROCEDURE list_emp_by_dept (
  p_dept_id IN hr.departments.department_id%TYPE DEFAULT 50
) IS
  ...
```

Call: `list_emp_by_dept;` or `list_emp_by_dept(60);`

---

## 7. Best Practices and Summary

- Use **%TYPE** for parameters that match table columns (e.g. p_dept_id hr.departments.department_id%TYPE).
- Use OUT parameters to return one or more values; avoid using OUT for “return” when a function would be clearer.
- Check **SQL%ROWCOUNT** after DML and raise a clear error (e.g. RAISE_APPLICATION_ERROR) when no row was affected if that is unexpected.
- Document whether the procedure commits or not.
- Use meaningful names: e.g. **list_emp_by_dept**, **raise_salary**, **get_dept_total_salary**.

**Summary:** Stored procedures are named, stored PL/SQL blocks with optional IN/OUT/IN OUT parameters. Use IN for inputs, OUT for single or multiple return values, and procedures for actions (DML, reporting to DBMS_OUTPUT) on hr.employees and hr.departments. Call from PL/SQL or SQL (EXEC/CALL) as appropriate.

---

[← Day 21](./day21_cursors.md) | [Back to Learning Plan](../30-day-sql-plsql-learning-plan.md) | [Next: Day 23 →](./day23_functions.md)
