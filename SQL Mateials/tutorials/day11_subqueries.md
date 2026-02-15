# Day 11: Subqueries – Scalar & Table — Full Notes and Theory

---

## 1. What a Subquery Is and Why It Matters

A **subquery** is a SELECT statement written **inside** another SQL statement. It can appear in **WHERE** (to filter by a list or a single value), in **SELECT** (to compute a value per row), in **FROM** (as a derived table), or in **HAVING**. Subqueries let you express "employees who earn more than the company average" or "departments that have at least one employee" in one query. All examples use **hr.employees** and **hr.departments** only.

- A subquery that returns **one row and one column** is called a **scalar** subquery; it can be used with comparison operators (=, <, >, IN) and in the SELECT list.
- A subquery that returns **multiple rows and one column** can be used with **IN**, **ANY**, **ALL**, or **EXISTS**.
- A subquery in **FROM** returns a **table** (derived table); you must give it an alias and can then join or filter it.

---

## 2. Subquery in WHERE: IN and Scalar Comparison

**IN (subquery):** The subquery returns one column; the outer WHERE checks whether the row’s value is in that set.

```sql
SELECT employee_id, first_name, department_id
FROM hr.employees
WHERE department_id IN (SELECT department_id FROM hr.departments WHERE location_id = 1700);
```

**Scalar comparison:** The subquery must return **exactly one row and one column**. Use with =, <, >, <=, >=, <>.

```sql
SELECT employee_id, first_name, salary
FROM hr.employees
WHERE salary > (SELECT AVG(salary) FROM hr.employees);
```

If the scalar subquery returns no rows, the comparison yields UNKNOWN (treated as false); if it returns more than one row, Oracle raises an error.

---

## 3. Scalar Subquery (Single Value)

A **scalar subquery** returns one row and one column. You can use it in **SELECT**, **WHERE**, or **HAVING**.

**In SELECT (per-row value):**

```sql
SELECT employee_id, first_name, salary,
  (SELECT AVG(salary) FROM hr.employees) AS company_avg_salary
FROM hr.employees;
```

**In WHERE (correlated example):** Departments with more than 5 employees:

```sql
SELECT department_id, department_name
FROM hr.departments d
WHERE (SELECT COUNT(*) FROM hr.employees e WHERE e.department_id = d.department_id) > 5;
```

---

## 4. Table Subquery in FROM (Derived Table)

A subquery in **FROM** acts as a **derived table**. You **must** give it an alias. You can then filter, join, or aggregate on it.

```sql
SELECT dept_id, emp_count
FROM (
  SELECT department_id AS dept_id, COUNT(*) AS emp_count
  FROM hr.employees
  GROUP BY department_id
) sub
WHERE emp_count > 3;
```

Use this for multi-step logic: e.g., aggregate first, then filter or join to another table.

---

## 5. Subquery in SELECT (Scalar, Often Correlated)

A scalar subquery in the SELECT list is evaluated **once per row** of the outer query. It must return one value per row. Correlated: it references the outer row (e.g., e.department_id).

```sql
SELECT e.employee_id, e.first_name, e.department_id,
  (SELECT d.department_name FROM hr.departments d WHERE d.department_id = e.department_id) AS department_name
FROM hr.employees e;
```

If the subquery returns no row, the result is NULL; if it returns more than one row, you get an error.

---

## 6. EXISTS

**EXISTS (subquery)** is **true** if the subquery returns **at least one row**; it does not matter what columns or how many rows. Often used with a **correlated** subquery.

```sql
SELECT department_id, department_name
FROM hr.departments d
WHERE EXISTS (SELECT 1 FROM hr.employees e WHERE e.department_id = d.department_id);
```

This returns departments that have at least one employee. **EXISTS** can be more efficient than IN for large sets because the database can stop at the first match. Use **SELECT 1** (or any constant) since only existence is checked.

---

## 7. Subqueries Using hr.employees and hr.departments

- **Employees in valid departments:** `WHERE department_id IN (SELECT department_id FROM hr.departments)`.
- **Employees above company average salary:** `WHERE salary > (SELECT AVG(salary) FROM hr.employees)`.
- **Department name in SELECT:** scalar subquery from hr.departments using current row’s department_id.
- **Departments with at least one employee:** `WHERE EXISTS (SELECT 1 FROM hr.employees e WHERE e.department_id = d.department_id)`.

---

## 8. Summary Points

- Subqueries in **WHERE** can supply a list (IN) or a single value (scalar); scalar must return one row, one column.
- **Scalar** subqueries can be used in SELECT, WHERE, HAVING.
- Subquery in **FROM** is a derived table; give it an alias and use it like a table.
- **EXISTS** checks for at least one row; use with correlated subqueries for "has a match" logic. All examples use **hr.employees** and **hr.departments** only.

---

[← Day 10](./day10_having_aggregation.md) | [Back to Learning Plan](../30-day-sql-plsql-learning-plan.md) | [Next: Day 12 →](./day12_correlated_subqueries.md)
