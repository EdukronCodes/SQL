# Day 29: Advanced Reporting with HR — Full Notes and Theory

---

## 1. Why Advanced Reporting Matters

Reports often need **pivoted** data (rows as columns), **hierarchies** (manager chains), **subtotals** (ROLLUP), and **row-level** metrics (window functions). Combining these in SQL reduces application logic and uses the database efficiently. All examples use **hr.employees** and **hr.departments**.

- **Pivoting** — Turn row values (e.g. department_id) into columns (dept_10_cnt, dept_20_cnt).
- **Hierarchical query** — CONNECT BY for manager → employee tree.
- **ROLLUP** — Subtotals and grand total in GROUP BY.
- **Window functions** — Running totals, ranks, and row-level metrics without collapsing rows.

---

## 2. Pivoting (department_id as Columns, Count/Sum)

**Pivot** turns row values into columns. Two common approaches:

**Conditional aggregation (manual pivot):**

```sql
SELECT
  COUNT(CASE WHEN department_id = 10 THEN 1 END) AS dept_10_cnt,
  COUNT(CASE WHEN department_id = 20 THEN 1 END) AS dept_20_cnt,
  COUNT(CASE WHEN department_id = 50 THEN 1 END) AS dept_50_cnt,
  SUM(CASE WHEN department_id = 10 THEN salary END) AS dept_10_sal,
  SUM(CASE WHEN department_id = 20 THEN salary END) AS dept_20_sal
FROM hr.employees;
```

**PIVOT clause (Oracle 11g+):**

```sql
SELECT * FROM (
  SELECT department_id, employee_id, salary FROM hr.employees
) PIVOT (
  COUNT(employee_id) AS cnt, SUM(salary) AS sal
  FOR department_id IN (10 AS d10, 20 AS d20, 50 AS d50)
);
```

Use conditional aggregation when you need full control; use PIVOT when the column list is fixed and the syntax fits.

---

## 3. Hierarchical Query (CONNECT BY for Manager Chain)

**CONNECT BY** (Oracle) builds a tree from a self-relationship (e.g. manager_id → employee_id):

```sql
SELECT LEVEL, employee_id, first_name, last_name, manager_id
FROM hr.employees
START WITH manager_id IS NULL
CONNECT BY PRIOR employee_id = manager_id;
```

- **START WITH** — Root row(s) (e.g. no manager = top of tree).
- **CONNECT BY PRIOR** — Parent’s employee_id = current row’s manager_id; walk from root down.
- **LEVEL** — Depth (1 = root). Use **LPAD** for indentation in reports.
- **SYS_CONNECT_BY_PATH(column, delimiter)** — Path from root to current row (e.g. '/King/Kochhar/...').

Use for org charts, approval chains, and any parent-child hierarchy in hr.employees (manager_id).

---

## 4. Reporting Aggregates with GROUP BY ROLLUP

**ROLLUP** adds subtotals and a grand total (see Day 10). Use for reports that need department totals and company total:

```sql
SELECT department_id, job_id, COUNT(*) AS cnt, SUM(salary) AS total_sal
FROM hr.employees
GROUP BY ROLLUP(department_id, job_id)
ORDER BY department_id NULLS LAST, job_id NULLS LAST;
```

NULL in grouped columns indicates the subtotal/grand total row. Use **GROUPING(department_id)** to distinguish “real” NULL from “rollup” NULL in SELECT or ORDER BY.

---

## 5. Formatting Output

- **LPAD**, **RPAD** — Padding for alignment.
- **TO_CHAR** — Format numbers and dates (e.g. TO_CHAR(salary,'999,999.00'), TO_CHAR(hire_date,'YYYY-MM-DD')).
- **Column aliases** — Clear names for report columns.

In **SQL*Plus**: **COLUMN**, **BREAK**, **COMPUTE** for column formatting and breaks. In applications, formatting is often done in the presentation layer; SQL can still provide structured data (e.g. salary_band, formatted strings).

---

## 6. Combining Window Functions and Aggregation for Dashboards

Use **window functions** for running totals, ranks, and row-level metrics, and **GROUP BY** for department/job summaries. Combine in one query with subqueries or CTEs:

```sql
SELECT department_id, employee_id, salary,
  SUM(salary) OVER (PARTITION BY department_id) AS dept_total,
  COUNT(*) OVER (PARTITION BY department_id) AS dept_count,
  RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS sal_rank
FROM hr.employees;
```

Use such result sets as the basis for dashboard datasets (e.g. in a reporting tool or view). You can also wrap in a CTE and filter (e.g. only departments with count > 5) or add GROUP BY in an outer query.

---

## 7. Best Practices and Summary

- Use **conditional aggregation** or **PIVOT** for cross-tab reports.
- Use **CONNECT BY** for hierarchies; **LEVEL** and **SYS_CONNECT_BY_PATH** for formatting.
- Use **ROLLUP** for subtotals; **GROUPING()** to identify rollup rows.
- Combine **window functions** and **aggregation** in CTEs for complex reports.

**Summary:** Pivoting, CONNECT BY, ROLLUP, and window functions give powerful reporting on hr.employees and hr.departments. Use them for dashboards, org charts, and summary reports with subtotals.

---

[← Day 28](./day28_security.md) | [Back to Learning Plan](../30-day-sql-plsql-learning-plan.md) | [Next: Day 30 →](./day30_capstone_best_practices.md)
