# Day 12: Correlated Subqueries — Full Notes and Theory

---

## 1. What a Correlated Subquery Is

A **correlated subquery** is a subquery that **references a column from the outer query**. It is evaluated **once per row** of the outer query: for each outer row, the inner query runs with that row’s values (e.g., e.department_id). This lets you express conditions like "employees who earn more than their **department** average" or "departments that have **no** employees." All examples use **hr.employees** and **hr.departments** only.

- The inner query **depends** on the current outer row, so it cannot be run once and reused; it runs repeatedly.
- Correlated subqueries are powerful for row-by-row conditions but can be slower than joins or window functions on large data; consider rewriting when performance matters.

---

## 2. Reference to Outer Query and "Above Department Average"

The subquery uses a column from the outer query (e.g., **e.department_id**). For each employee, the subquery computes the average salary **of that employee’s department** and compares.

```sql
SELECT e.employee_id, e.first_name, e.salary, e.department_id
FROM hr.employees e
WHERE e.salary > (
  SELECT AVG(salary) FROM hr.employees WHERE department_id = e.department_id
);
```

So you get only employees whose salary is above the average salary of their own department.

---

## 3. EXISTS with Correlation

**EXISTS (subquery)** is true when the subquery returns at least one row. With correlation, you test "is there a row that matches this outer row?"

**Departments that have at least one employee:**

```sql
SELECT d.department_id, d.department_name
FROM hr.departments d
WHERE EXISTS (SELECT 1 FROM hr.employees e WHERE e.department_id = d.department_id);
```

For each department **d**, the subquery checks whether any employee has that department_id. If yes, the department is returned.

---

## 4. NOT EXISTS

**NOT EXISTS** is true when the subquery returns **no** rows. Use it to find "no match" cases.

**Departments with no employees:**

```sql
SELECT d.department_id, d.department_name
FROM hr.departments d
WHERE NOT EXISTS (SELECT 1 FROM hr.employees e WHERE e.department_id = d.department_id);
```

---

## 5. Performance Considerations

- Correlated subqueries run **once per outer row**, so they can be slow on large tables.
- For "exists" checks, **EXISTS** / **NOT EXISTS** with an index on the join column (e.g., department_id) is usually efficient.
- For "above average in group," consider rewriting with a **JOIN** to a grouped subquery (e.g., department_id and AVG(salary)) or with **window functions** (e.g., AVG(salary) OVER (PARTITION BY department_id)) for better performance.

---

## 6. Row-by-Row Comparison

Use correlated subqueries when the condition for each row **depends on that row’s attributes** (e.g., "above my department’s average," "same job as my manager," "department has no employees"). For simple "in list" or "equals value" cases, non-correlated subqueries or JOINs are often simpler and faster.

---

## 7. Summary Points

- **Correlated** subquery references the outer query; it is evaluated per outer row.
- Use for "above department average," "departments with/without employees," and similar row-dependent conditions.
- **EXISTS** / **NOT EXISTS** with correlation are standard patterns; consider JOIN or window functions for performance. All examples use **hr.employees** and **hr.departments** only.

---

[← Day 11](./day11_subqueries.md) | [Back to Learning Plan](../30-day-sql-plsql-learning-plan.md) | [Next: Day 13 →](./day13_set_operations.md)
