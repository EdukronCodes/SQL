# Day 10: HAVING & Advanced Aggregation — Full Notes and Theory

---

## 1. What HAVING Does and When to Use It

**HAVING** filters **groups** after **GROUP BY** and aggregation. **WHERE** filters **rows** before grouping; **HAVING** filters **groups** after. So you use HAVING when the condition involves an aggregate (e.g., "departments where average salary > 8000" or "job_id with more than 3 employees"). All examples use **hr.employees** and **hr.departments** only.

- HAVING can use aggregate expressions: COUNT(*), SUM(salary), AVG(salary), MIN, MAX.
- You can combine HAVING with WHERE: WHERE filters rows first, then GROUP BY, then HAVING filters groups.

---

## 2. HAVING Clause Syntax and Examples

**Syntax:** After GROUP BY, add **HAVING** condition. Only groups that satisfy the condition are returned.

**Example: Departments with average salary > 8000:**

```sql
SELECT department_id, AVG(salary) AS avg_sal
FROM hr.employees
GROUP BY department_id
HAVING AVG(salary) > 8000;
```

**Example: job_id with more than 3 employees:**

```sql
SELECT job_id, COUNT(*) AS emp_count
FROM hr.employees
GROUP BY job_id
HAVING COUNT(*) > 3;
```

---

## 3. HAVING vs WHERE

| Clause | When applied | What it filters |
|--------|----------------|------------------|
| **WHERE** | Before grouping | Rows (individual). |
| **HAVING** | After grouping | Groups (aggregated). |

**Example:** Departments with more than 3 employees **and** average salary > 7000, but only among employees with salary > 3000:

```sql
SELECT department_id, COUNT(*) AS cnt, AVG(salary) AS avg_sal
FROM hr.employees
WHERE salary > 3000
GROUP BY department_id
HAVING COUNT(*) > 3 AND AVG(salary) > 7000;
```

WHERE drops rows with salary <= 3000; then grouping and aggregates are computed; HAVING keeps only groups with count > 3 and avg_sal > 7000.

---

## 4. GROUP BY with Joins (employees + departments)

Join first, then group, so you can show **department name** and aggregates:

```sql
SELECT d.department_name, COUNT(e.employee_id) AS emp_count, SUM(e.salary) AS total_salary
FROM hr.employees e
INNER JOIN hr.departments d ON e.department_id = d.department_id
GROUP BY d.department_id, d.department_name;
```

Non-aggregated columns in SELECT (e.g., department_name) must be in GROUP BY. Grouping by department_id and department_name is correct because name is unique per department.

---

## 5. ROLLUP (Oracle) for Subtotals

**ROLLUP** adds **subtotal** and **grand total** rows. It rolls up the grouping columns from right to left: you get rows per (department_id, job_id), then per department_id (job_id NULL), then one grand total (both NULL).

```sql
SELECT department_id, job_id, COUNT(*) AS cnt, SUM(salary) AS total_sal
FROM hr.employees
GROUP BY ROLLUP(department_id, job_id);
```

Use ROLLUP for reports that need department and company-wide totals.

---

## 6. CUBE and GROUPING SETS

**CUBE** produces all combinations of the grouping columns plus grand total. **GROUPING SETS** lets you specify exactly which groupings you want. Both are useful for multi-level reports on HR data.

---

## 7. Practical Reporting on HR Data

Combine **WHERE**, **JOIN**, **GROUP BY**, and **HAVING** for reports such as: total salary and headcount per department (with department name); job_id with more than 5 employees; departments where total salary exceeds a threshold.

---

## 8. Summary Points

- **HAVING** filters groups after GROUP BY; use it for conditions on aggregates.
- **WHERE** filters rows before grouping; **HAVING** filters groups after.
- Join then **GROUP BY** when you need department (or other) names with aggregates.
- **ROLLUP** adds subtotals and grand total; **CUBE** and **GROUPING SETS** offer more grouping options.

---

[← Day 9](./day09_aggregation.md) | [Back to Learning Plan](../30-day-sql-plsql-learning-plan.md) | [Next: Day 11 →](./day11_subqueries.md)
