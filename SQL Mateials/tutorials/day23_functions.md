# Day 23: Functions — Full Notes and Theory

---

## 1. What Functions Are and Why They Matter

A **function** is a named PL/SQL subprogram that **returns a single value** (or one composite value). Unlike a procedure, a function has a **RETURN** type and at least one **RETURN** statement. Functions can be used inside SQL (SELECT, WHERE, ORDER BY) provided they follow Oracle’s purity and usage rules. All examples use **hr.employees** and **hr.departments**.

- **When to use a function:** When the goal is to compute and return one value (e.g. department name for a department_id, count of employees, full name).
- **When to use a procedure:** When you perform an action (UPDATE, INSERT) or need multiple distinct outputs (use OUT parameters).

---

## 2. CREATE FUNCTION Syntax

```sql
CREATE OR REPLACE FUNCTION function_name (
  p_param1 IN datatype,
  p_param2 IN datatype
) RETURN return_datatype
IS
  v_result return_datatype;
BEGIN
  -- compute v_result (and/or use p_param1, p_param2)
  RETURN v_result;
EXCEPTION
  WHEN NO_DATA_FOUND THEN RETURN NULL;  -- optional
END;
/
```

- The **RETURN** clause specifies the data type of the result (NUMBER, VARCHAR2, DATE, BOOLEAN for PL/SQL-only use, etc.).
- At least one **RETURN** expression must be executed. Multiple RETURN statements are allowed (e.g. in different branches).
- For use in SQL, avoid OUT/IN OUT parameters and avoid modifying database state (or follow restricted patterns).

---

## 3. RETURN Type and Use in SELECT

Once created, a function can be used in SQL expressions:

```sql
SELECT employee_id, first_name, get_department_name(department_id) AS dept_name
FROM hr.employees;
```

You can also use it in **WHERE** and **ORDER BY** (e.g. WHERE get_department_name(department_id) = 'Sales'). For heavy use in SQL, consider performance: calling a function per row can be costly compared to a join.

---

## 4. Function: department_name Given department_id

Return the department name for a given department_id. Handle **NO_DATA_FOUND** (e.g. invalid id) by returning NULL.

```sql
CREATE OR REPLACE FUNCTION get_department_name (
  p_dept_id IN hr.departments.department_id%TYPE
) RETURN hr.departments.department_name%TYPE
IS
  v_name hr.departments.department_name%TYPE;
BEGIN
  SELECT department_name INTO v_name
  FROM hr.departments
  WHERE department_id = p_dept_id;
  RETURN v_name;
EXCEPTION
  WHEN NO_DATA_FOUND THEN RETURN NULL;
END;
/
```

Usage: `SELECT get_department_name(50) FROM DUAL;` or in SELECT list as above.

---

## 5. Function: employee_count(dept_id) RETURN NUMBER

Return the number of employees in a department:

```sql
CREATE OR REPLACE FUNCTION employee_count (
  p_dept_id IN hr.departments.department_id%TYPE
) RETURN NUMBER
IS
  v_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count
  FROM hr.employees
  WHERE department_id = p_dept_id;
  RETURN v_count;
END;
/
```

Usage: `SELECT employee_count(50) FROM DUAL;` or in SELECT/WHERE.

---

## 6. Purity (DETERMINISTIC)

**DETERMINISTIC** means the function returns the same value for the same input(s). Oracle uses this for function-based indexes and possible caching. Do not use DETERMINISTIC if the result depends on data that can change (e.g. current row count).

```sql
CREATE OR REPLACE FUNCTION full_name (
  p_first VARCHAR2,
  p_last  VARCHAR2
) RETURN VARCHAR2
DETERMINISTIC
IS
BEGIN
  RETURN p_first || ' ' || p_last;
END;
/
```

---

## 7. Functions vs Procedures

| Aspect            | Function                    | Procedure                    |
|------------------|-----------------------------|-----------------------------|
| Return value     | Single value via RETURN     | No RETURN; can have OUT/IN OUT |
| Use in SQL       | Yes (if no OUT, follows rules) | No; use CALL/EXEC or PL/SQL |
| Typical use      | Compute and return one value | Perform action or return multiple values |

Use a function when you need one return value and may use it in SQL. Use a procedure when you update data or need multiple outputs.

---

## 8. Best Practices and Summary

- Use **%TYPE** for parameters and return type when matching table columns.
- Handle **NO_DATA_FOUND** (and optionally **TOO_MANY_ROWS**) so the function does not propagate errors when used in SQL.
- Avoid DML inside functions that are used in SQL (or use autonomous transaction only if necessary and documented).
- Mark **DETERMINISTIC** only when the result truly depends only on the arguments.

**Summary:** Functions return a single value via RETURN and can be used in SQL. Implement get_department_name, employee_count, and similar helpers on hr.employees and hr.departments; use DETERMINISTIC when appropriate; prefer functions for computations and procedures for actions.

---

[← Day 22](./day22_stored_procedures.md) | [Back to Learning Plan](../30-day-sql-plsql-learning-plan.md) | [Next: Day 24 →](./day24_exception_handling.md)
