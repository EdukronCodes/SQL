# Day 20: PL/SQL Basics — Full Notes and Theory

---

## 1. What PL/SQL Is and Block Structure

**PL/SQL** is Oracle’s procedural extension to SQL. You write **blocks** of code that can include variables, control flow (IF, LOOP), and exception handling. A block has up to three sections: **DECLARE** (variables, cursors), **BEGIN** (executable statements), **EXCEPTION** (handlers). Only **BEGIN...END** is required; DECLARE and EXCEPTION are optional. All examples use **hr.employees** and **hr.departments**.

- Use **SET SERVEROUTPUT ON** (SQL*Plus/SQL Developer) to see output from **DBMS_OUTPUT.PUT_LINE**.
- **Assignment** uses **:=**. **SELECT INTO** reads one row into variables.

---

## 2. Variables and Types (%TYPE, %ROWTYPE)

Declare variables with explicit type or **anchor** to table columns/rows:

```sql
DECLARE
  v_emp_id   hr.employees.employee_id%TYPE;
  v_salary   hr.employees.salary%TYPE;
  v_emp_row  hr.employees%ROWTYPE;
BEGIN
  v_emp_id := 100;
  SELECT salary INTO v_salary FROM hr.employees WHERE employee_id = v_emp_id;
  SELECT * INTO v_emp_row FROM hr.employees WHERE employee_id = v_emp_id;
END;
/
```

**%TYPE** matches the column type; **%ROWTYPE** matches a full row. This keeps types in sync with the table.

---

## 3. Assignment and DBMS_OUTPUT

Use **:=** for assignment. Use **DBMS_OUTPUT.PUT_LINE** to print; enable with **SET SERVEROUTPUT ON**:

```sql
DECLARE
  v_name VARCHAR2(100);
BEGIN
  SELECT first_name || ' ' || last_name INTO v_name FROM hr.employees WHERE employee_id = 100;
  DBMS_OUTPUT.PUT_LINE('Name: ' || v_name);
END;
/
```

---

## 4. IF / ELSIF / ELSE and LOOP, WHILE, FOR

**IF** condition **THEN** ... **ELSIF** ... **ELSE** ... **END IF;**

**LOOP** ... **EXIT WHEN** condition; **END LOOP;**  
**WHILE** condition **LOOP** ... **END LOOP;**  
**FOR** i **IN** 1..10 **LOOP** ... **END LOOP;**

Example: FOR loop over a range; WHILE for condition-based iteration; simple LOOP with EXIT WHEN.

---

## 5. Cursors Preview and Simple Block

A **cursor** is a handle to a result set; you open, fetch rows, and close. (Covered in Day 21.) Simple block selecting from hr.employees:

```sql
SET SERVEROUTPUT ON
DECLARE
  v_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count FROM hr.employees WHERE department_id = 50;
  DBMS_OUTPUT.PUT_LINE('Employees in dept 50: ' || v_count);
END;
/
```

---

## 6. Summary Points

- **PL/SQL** blocks: DECLARE, BEGIN, EXCEPTION, END. Use **%TYPE** and **%ROWTYPE** for variables. **SELECT INTO** for single-row fetch. **DBMS_OUTPUT.PUT_LINE** for output. **IF**, **LOOP**, **WHILE**, **FOR** for control flow. All examples use **hr.employees** and **hr.departments**.

---

[← Day 19](./day19_views.md) | [Back to Learning Plan](../30-day-sql-plsql-learning-plan.md) | [Next: Day 21 →](./day21_cursors.md)
