# Day 19: Views — Full Notes and Theory

---

## 1. What Views Are and Why Use Them

A **view** is a **saved query** that acts like a table. You **SELECT** from it; the database runs the underlying query. Views simplify reporting (hide joins and filters), restrict access (expose only certain columns or rows), and provide a stable interface when the underlying tables change. All examples use **hr.employees** and **hr.departments**.

- **Simple view:** Based on one table; often updatable (subject to rules).
- **Complex view:** Joins, aggregation, or DISTINCT; in Oracle often not directly updatable; update the base tables instead.
- **WITH CHECK OPTION:** Ensures INSERT/UPDATE through the view satisfy the view’s WHERE condition.
- **WITH READ ONLY:** Prevents any DML through the view.

---

## 2. CREATE VIEW and Simple vs Complex

**CREATE OR REPLACE VIEW** name **AS** query. Usage: `SELECT * FROM view_name;`

**Simple view (single table):**

```sql
CREATE OR REPLACE VIEW hr.emp_short AS
SELECT employee_id, first_name, last_name, department_id
FROM hr.employees;
```

**Complex view (join):**

```sql
CREATE OR REPLACE VIEW hr.emp_dept_view AS
SELECT e.employee_id, e.first_name, e.last_name, e.salary, d.department_name
FROM hr.employees e
INNER JOIN hr.departments d ON e.department_id = d.department_id;
```

---

## 3. WITH CHECK OPTION and WITH READ ONLY

**WITH CHECK OPTION** ensures inserts and updates through the view satisfy the view’s WHERE clause:

```sql
CREATE OR REPLACE VIEW hr.emp_sales AS
SELECT employee_id, first_name, last_name, department_id
FROM hr.employees
WHERE department_id = 80
WITH CHECK OPTION;
```

**WITH READ ONLY** prevents DML: `WITH READ ONLY` at the end of the view definition.

---

## 4. Benefits and Materialized View Concept

**Benefits:** **Security** (expose only certain columns/rows, e.g., hide salary); **simplicity** (hide join/filter logic behind a name). A **materialized view** stores the query result physically and can be refreshed on demand or on commit; used for precomputed aggregates and reporting.

---

## 5. Summary Points

- **Views** are saved queries used like tables; **simple** (one table) vs **complex** (join/aggregation).
- Use **WITH CHECK OPTION** to enforce view predicate on DML; **WITH READ ONLY** to block DML. All examples use **hr.employees** and **hr.departments**.

---

[← Day 18](./day18_indexes.md) | [Back to Learning Plan](../30-day-sql-plsql-learning-plan.md) | [Next: Day 20 →](./day20_plsql_basics.md)
