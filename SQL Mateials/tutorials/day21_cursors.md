# Day 21: Cursors — Full Notes and Theory

---

## 1. What Cursors Are and Why They Matter

A **cursor** in PL/SQL is a pointer to a result set—the rows returned by a SELECT. You use cursors when you need to process rows **one at a time** (e.g. loop and do logic per row) instead of in a single set. Oracle provides **implicit** cursors (for single DML or SELECT INTO) and **explicit** cursors (you declare, open, fetch, close). All examples use **hr.employees** and **hr.departments**.

- **Implicit cursor:** Created automatically for one DML or SELECT INTO; you can use **SQL%ROWCOUNT**, **SQL%FOUND**, **SQL%NOTFOUND** after the statement.
- **Explicit cursor:** You declare a name and a query, then OPEN, FETCH in a loop, and CLOSE. Gives full control over multi-row processing.

---

## 2. Implicit Cursor (FOR UPDATE, SQL%ROWCOUNT)

An **implicit cursor** is created by the database for a single DML or SELECT INTO. You do not declare it; you use the **SQL** keyword to access its attributes after the statement:

- **SQL%ROWCOUNT** — number of rows affected (DML) or fetched (SELECT INTO: 0 or 1).
- **SQL%FOUND** — TRUE if at least one row was affected/fetched.
- **SQL%NOTFOUND** — TRUE if no row was affected/fetched.

**Example: use SQL%ROWCOUNT after UPDATE**

```sql
BEGIN
  UPDATE hr.employees SET salary = salary * 1.05 WHERE department_id = 60;
  DBMS_OUTPUT.PUT_LINE('Rows updated: ' || SQL%ROWCOUNT);
  COMMIT;
END;
/
```

**SELECT ... FOR UPDATE** locks the selected rows. The cursor is still implicit if you use it in a single SELECT INTO or in a **FOR ... IN (SELECT ...)** loop (which uses an implicit cursor internally). Use FOR UPDATE when you plan to UPDATE or DELETE those rows in the same transaction.

---

## 3. Explicit Cursor: DECLARE, OPEN, FETCH, CLOSE

With an **explicit cursor** you:

1. **DECLARE** the cursor with a SELECT (no INTO here).
2. **OPEN** the cursor (executes the query).
3. **FETCH** rows one at a time INTO variables (or a record).
4. **CLOSE** the cursor when done.

**Cursor attributes:** *cursor_name*%**NOTFOUND**, *cursor_name*%**FOUND**, *cursor_name*%**ROWCOUNT**, *cursor_name*%**ISOPEN**.

**Example: full OPEN / FETCH / CLOSE loop**

```sql
DECLARE
  CURSOR c_emp IS
    SELECT employee_id, first_name, last_name
    FROM hr.employees
    WHERE department_id = 60;
  v_id   hr.employees.employee_id%TYPE;
  v_fname hr.employees.first_name%TYPE;
  v_lname hr.employees.last_name%TYPE;
BEGIN
  OPEN c_emp;
  LOOP
    FETCH c_emp INTO v_id, v_fname, v_lname;
    EXIT WHEN c_emp%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(v_id || ': ' || v_fname || ' ' || v_lname);
  END LOOP;
  CLOSE c_emp;
END;
/
```

Always **CLOSE** the cursor (in EXCEPTION too if you open it) to free resources. Use **EXIT WHEN cursor%NOTFOUND** after FETCH to leave the loop when there are no more rows.

---

## 4. Cursor FOR Loop

The **cursor FOR loop** opens the cursor, fetches each row into a record variable, and closes the cursor automatically. You do not write OPEN, FETCH, or CLOSE. Use **%ROWTYPE** or a record type that matches the select list.

**Example: cursor FOR loop with %ROWTYPE**

```sql
DECLARE
  CURSOR c_emp IS
    SELECT employee_id, first_name, last_name
    FROM hr.employees
    WHERE department_id = 60;
BEGIN
  FOR rec IN c_emp LOOP
    DBMS_OUTPUT.PUT_LINE(rec.employee_id || ': ' || rec.first_name || ' ' || rec.last_name);
  END LOOP;
END;
/
```

You can also use an **inline** query: **FOR rec IN (SELECT ... FROM hr.employees ...) LOOP** without declaring a cursor. The loop variable **rec** has columns matching the SELECT list.

---

## 5. Parameterized Cursor (by department_id)

A **parameterized cursor** accepts parameters (e.g. department_id) so the same cursor definition can be reused with different values. Parameters are passed when you **OPEN** the cursor or when you use the cursor in a **FOR** loop.

**Example: parameterized cursor**

```sql
DECLARE
  CURSOR c_emp(p_dept_id NUMBER) IS
    SELECT employee_id, first_name, last_name
    FROM hr.employees
    WHERE department_id = p_dept_id;
BEGIN
  FOR rec IN c_emp(50) LOOP
    DBMS_OUTPUT.PUT_LINE(rec.first_name || ' ' || rec.last_name);
  END LOOP;
  -- Same cursor, different department:
  FOR rec IN c_emp(60) LOOP
    DBMS_OUTPUT.PUT_LINE(rec.first_name || ' ' || rec.last_name);
  END LOOP;
END;
/
```

With OPEN/FETCH/CLOSE you would write: **OPEN c_emp(50);** then FETCH and CLOSE.

---

## 6. Cursor with JOIN (employees + departments)

The cursor’s SELECT can join multiple tables. The loop variable then has columns from all selected columns (use aliases to avoid ambiguity).

**Example: cursor with JOIN**

```sql
DECLARE
  CURSOR c_emp_dept IS
    SELECT e.employee_id, e.first_name, d.department_name
    FROM hr.employees e
    INNER JOIN hr.departments d ON e.department_id = d.department_id;
BEGIN
  FOR rec IN c_emp_dept LOOP
    DBMS_OUTPUT.PUT_LINE(rec.employee_id || ' - ' || rec.first_name || ' - ' || rec.department_name);
  END LOOP;
END;
/
```

---

## 7. Best Practices and Summary

- Prefer **cursor FOR loop** when you only need to read rows; less code and no risk of forgetting to CLOSE.
- Use **explicit OPEN/FETCH/CLOSE** when you need to exit the loop early or branch logic based on cursor state.
- Use **parameterized cursors** to avoid duplicating similar queries.
- Always **CLOSE** explicit cursors (and in EXCEPTION handler if opened).
- Use **SQL%ROWCOUNT** after DML to report or check how many rows were affected.
- For read-only processing, avoid **FOR UPDATE** unless you need to lock rows.

**Summary:** Implicit cursors apply to single DML/SELECT INTO; use SQL%ROWCOUNT and FOR UPDATE when needed. Explicit cursors give controlled multi-row processing; use cursor FOR loop for simplicity, or OPEN/FETCH/CLOSE for more control. Parameterized and join cursors keep code reusable and clear on hr.employees and hr.departments.

---

[← Day 20](./day20_plsql_basics.md) | [Back to Learning Plan](../30-day-sql-plsql-learning-plan.md) | [Next: Day 22 →](./day22_stored_procedures.md)
