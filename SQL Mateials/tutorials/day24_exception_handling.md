# Day 24: Exception Handling — Full Notes and Theory

---

## 1. Why Exception Handling Matters

In PL/SQL, when an error occurs (e.g. no row found for SELECT INTO, duplicate key on INSERT), Oracle raises an **exception**. If you do not handle it, the block fails and the error propagates to the caller. The **EXCEPTION** section lets you catch named or generic errors, log them, correct data, or re-raise so the caller can react. All examples use **hr.employees** and **hr.departments**.

- **EXCEPTION section** — optional part of a block: **EXCEPTION WHEN exception_name THEN ...; WHEN OTHERS THEN ...; END;**
- Handling **NO_DATA_FOUND** and **TOO_MANY_ROWS** is common when using SELECT INTO. Use **RAISE_APPLICATION_ERROR** for business rules.

---

## 2. EXCEPTION Section and Flow

When an exception is raised, control jumps to the EXCEPTION section. Oracle matches the first **WHEN** that fits; **OTHERS** catches any exception. After the handler runs, the block ends (unless the handler re-raises).

```sql
BEGIN
  -- statements
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No row found');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
```

**SQLCODE** and **SQLERRM** give the error code and message; use them in OTHERS for logging.

---

## 3. NO_DATA_FOUND

**NO_DATA_FOUND** is raised when a **SELECT INTO** returns no rows.

```sql
DECLARE
  v_name VARCHAR2(100);
BEGIN
  SELECT first_name INTO v_name
  FROM hr.employees
  WHERE employee_id = 99999;
  DBMS_OUTPUT.PUT_LINE(v_name);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Employee not found');
END;
/
```

Always handle NO_DATA_FOUND when using SELECT INTO with user or external input (e.g. employee_id), or return NULL in a function.

---

## 4. TOO_MANY_ROWS

**TOO_MANY_ROWS** is raised when **SELECT INTO** returns more than one row. Fix the query (e.g. add criteria so at most one row) or use a cursor and fetch one row.

```sql
EXCEPTION
  WHEN TOO_MANY_ROWS THEN
    DBMS_OUTPUT.PUT_LINE('More than one row returned; narrow the query.');
END;
```

---

## 5. DUP_VAL_ON_INDEX and Other Predefined Exceptions

**DUP_VAL_ON_INDEX** is raised when an INSERT or UPDATE violates a unique or primary key constraint. You can handle it by name:

```sql
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN
    DBMS_OUTPUT.PUT_LINE('Duplicate key');
END;
```

Other common predefined exceptions: **INVALID_CURSOR**, **ZERO_DIVIDE**, **VALUE_ERROR**, **CURSOR_ALREADY_OPEN**. Use **PRAGMA EXCEPTION_INIT** to associate a name with a numeric error code.

---

## 6. OTHERS and RAISE_APPLICATION_ERROR

**WHEN OTHERS** catches any exception. Use it to log (e.g. SQLERRM) and then **RAISE;** to re-raise so the caller sees the error. Avoid swallowing errors without logging or re-raising.

**RAISE_APPLICATION_ERROR** raises a user-defined error with code in the range **-20000 to -20999** and a message:

```sql
IF v_salary > 50000 THEN
  RAISE_APPLICATION_ERROR(-20001, 'Salary exceeds limit');
END IF;
```

This stops execution and returns the code and message to the client. No EXCEPTION handler is required for the caller to see it.

---

## 7. PRAGMA EXCEPTION_INIT

**PRAGMA EXCEPTION_INIT** associates a named exception with a specific Oracle error code so you can handle it by name (e.g. foreign key violation -2291):

```sql
DECLARE
  e_foreign_key EXCEPTION;
  PRAGMA EXCEPTION_INIT(e_foreign_key, -2291);
BEGIN
  INSERT INTO hr.employees (...) VALUES (...);
EXCEPTION
  WHEN e_foreign_key THEN
    DBMS_OUTPUT.PUT_LINE('Invalid department_id');
END;
/
```

---

## 8. Custom Exceptions and Logging

- **Declare** your own exception: `e_high_salary EXCEPTION;`
- **Raise** it when a business rule fails: `RAISE e_high_salary;`
- **Handle** it: `WHEN e_high_salary THEN ...`

Use a logging table or **autonomous transaction** to log errors without losing the main transaction or masking the original error when you re-raise.

---

## 9. Handling in Procedures That Use hr.employees

In any procedure or block that queries or updates **hr.employees**:

- Handle **NO_DATA_FOUND** for single-row lookups (e.g. SELECT INTO by employee_id).
- Handle **TOO_MANY_ROWS** if SELECT INTO could return multiple rows.
- Use **RAISE_APPLICATION_ERROR** for business rules (e.g. salary out of range, invalid department_id).
- In **OTHERS**, log **SQLERRM** and consider **RAISE;** so callers are notified.

---

## 10. Best Practices and Summary

- Handle only what you can resolve or report clearly; otherwise re-raise.
- Use **RAISE_APPLICATION_ERROR(-20000 to -20999, 'message')** for application errors.
- Avoid empty **WHEN OTHERS**; at least log and/or RAISE.
- In functions used in SQL, handle NO_DATA_FOUND (e.g. RETURN NULL) so the query does not fail.

**Summary:** Use the EXCEPTION section to handle NO_DATA_FOUND, TOO_MANY_ROWS, DUP_VAL_ON_INDEX, and custom or OTHERS exceptions. Use RAISE_APPLICATION_ERROR for business rules and PRAGMA EXCEPTION_INIT for Oracle error codes. Apply these patterns consistently in blocks and procedures that use hr.employees and hr.departments.

---

[← Day 23](./day23_functions.md) | [Back to Learning Plan](../30-day-sql-plsql-learning-plan.md) | [Next: Day 25 →](./day25_triggers.md)
