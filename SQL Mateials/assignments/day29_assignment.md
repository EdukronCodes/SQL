# Day 29 Assignment: Advanced Reporting with HR

All exercises use **hr.employees** and **hr.departments**.

---

## Part 1: Practice Questions (With Answers and Explanations)

### Question 1
Produce a **pivot-style** result: show **employee count** for a few **department_id** values as **separate columns** (e.g. dept_10_cnt, dept_20_cnt, dept_50_cnt). Use conditional aggregation: COUNT(CASE WHEN department_id = 10 THEN 1 END), etc.

**Answer:**

```sql
SELECT
  COUNT(CASE WHEN department_id = 10 THEN 1 END) AS dept_10_cnt,
  COUNT(CASE WHEN department_id = 20 THEN 1 END) AS dept_20_cnt,
  COUNT(CASE WHEN department_id = 50 THEN 1 END) AS dept_50_cnt
FROM hr.employees;
```

**Explanation:** Each CASE returns 1 only for the matching department_id; COUNT counts those 1s. So each column is the headcount for that department. One row result (no GROUP BY).

---

### Question 2
Write a **hierarchical query** (CONNECT BY) on **hr.employees** to list the **manager chain**: start with employees who have **no manager** (manager_id IS NULL), then connect by manager_id = PRIOR employee_id. Show LEVEL, employee_id, first_name, last_name, manager_id. Use indentation (e.g. LPAD) to show levels.

**Answer:**

```sql
SELECT LEVEL, LPAD(' ', (LEVEL-1)*2) || first_name || ' ' || last_name AS name, employee_id, manager_id
FROM hr.employees
START WITH manager_id IS NULL
CONNECT BY PRIOR employee_id = manager_id;
```

**Explanation:** START WITH defines the root(s). CONNECT BY PRIOR employee_id = manager_id means "parent row's employee_id equals current row's manager_id," so we walk from top (CEO) down. LEVEL gives depth; LPAD indents.

---

### Question 3
Build a **report** that shows **department_name**, **job_id**, **headcount**, and **total salary** for each (department, job) combination. Join hr.employees to hr.departments and use GROUP BY department_name, job_id (and department_id for grouping).

**Answer:**

```sql
SELECT d.department_name, e.job_id,
  COUNT(*) AS headcount,
  SUM(e.salary) AS total_salary
FROM hr.employees e
INNER JOIN hr.departments d ON e.department_id = d.department_id
GROUP BY d.department_id, d.department_name, e.job_id
ORDER BY d.department_name, e.job_id;
```

**Explanation:** Join then GROUP BY department and job. COUNT(*) is headcount, SUM(salary) is total salary per group. Order for readable report.

---

## Part 2: Self-Practice (No Answers)

1. Use **CONNECT BY** to show the **full manager hierarchy** with LEVEL and optionally SYS_CONNECT_BY_PATH to show the path from root to each employee.
2. Use **conditional aggregation** with **CASE** inside **SUM** to compute total salary for "Sales" vs "Non-Sales" in one row (e.g. SUM(CASE WHEN d.department_name = 'Sales' THEN e.salary END) AS sales_sal, ...).

---

## Part 3: Additional Practice — 20 Medium + 20 Hard Questions (With Hints)

All use **hr.employees** and **hr.departments**.

### 20 Medium Questions

1. **M1.** Pivot: COUNT(CASE WHEN department_id = 10 THEN 1 END) AS dept_10_cnt, same for 20, 50. **Hint:** SELECT COUNT(CASE WHEN department_id = 10 THEN 1 END) AS dept_10_cnt, ... FROM hr.employees;
2. **M2.** CONNECT BY: START WITH manager_id IS NULL CONNECT BY PRIOR employee_id = manager_id. **Hint:** SELECT LEVEL, employee_id, first_name, last_name FROM hr.employees START WITH manager_id IS NULL CONNECT BY PRIOR employee_id = manager_id;
3. **M3.** Add LPAD for indentation: LPAD(' ', (LEVEL-1)*2) || first_name. **Hint:** LPAD(' ', (LEVEL-1)*2) || first_name || ' ' || last_name AS name
4. **M4.** GROUP BY ROLLUP(department_id, job_id) with COUNT(*) and SUM(salary). **Hint:** SELECT department_id, job_id, COUNT(*), SUM(salary) FROM hr.employees GROUP BY ROLLUP(department_id, job_id);
5. **M5.** SUM(CASE WHEN department_id = 50 THEN salary END) AS dept50_sal. **Hint:** Conditional sum for one department.
6. **M6.** SYS_CONNECT_BY_PATH(last_name, '/') to show path from root. **Hint:** SYS_CONNECT_BY_PATH(last_name, '/') AS path
7. **M7.** PIVOT: SELECT * FROM (SELECT department_id, employee_id FROM hr.employees) PIVOT (COUNT(employee_id) FOR department_id IN (10, 20, 50)). **Hint:** PIVOT (COUNT(employee_id) FOR department_id IN (10 AS d10, 20 AS d20, 50 AS d50))
8. **M8.** Report: department_name, job_id, headcount, total_salary; GROUP BY department_name, job_id. **Hint:** Join e and d; GROUP BY d.department_name, e.job_id (and d.department_id).
9. **M9.** LEVEL in CONNECT BY: what is LEVEL 1? **Hint:** Root row(s); LEVEL 2 is first level of children.
10. **M10.** ORDER SIBLINGS BY last_name in hierarchy. **Hint:** ORDER SIBLINGS BY last_name (keeps tree order).
11. **M11.** One row: dept_10_cnt, dept_20_cnt, dept_50_cnt (no GROUP BY). **Hint:** Three COUNT(CASE WHEN ...) in one SELECT from hr.employees.
12. **M12.** ROLLUP result: NULL in department_id means? **Hint:** Grand total row (or subtotal).
13. **M13.** GROUPING(department_id) in SELECT to distinguish real NULL from rollup NULL. **Hint:** SELECT department_id, GROUPING(department_id) g, COUNT(*) FROM hr.employees GROUP BY ROLLUP(department_id);
14. **M14.** Window function in same query as GROUP BY: use subquery. **Hint:** SELECT * FROM (SELECT department_id, employee_id, SUM(salary) OVER (PARTITION BY department_id) dept_total FROM hr.employees) sub;
15. **M15.** Conditional aggregation: SUM(CASE WHEN job_id = 'SA_REP' THEN salary END) AS sales_rep_sal. **Hint:** One column for sum of salary where job_id = 'SA_REP'.
16. **M16.** CONNECT BY with WHERE to filter level: LEVEL <= 3. **Hint:** Add WHERE LEVEL <= 3 (or in outer query).
17. **M17.** Format salary: TO_CHAR(salary,'999,999.00'). **Hint:** Use in SELECT for report.
18. **M18.** PIVOT with SUM(salary) and COUNT(employee_id). **Hint:** PIVOT (COUNT(employee_id) AS cnt, SUM(salary) AS sal FOR department_id IN (...))
19. **M19.** CONNECT BY PRIOR parent = child (direction). **Hint:** PRIOR employee_id = manager_id means parent's employee_id = current's manager_id (top-down).
20. **M20.** Report with ORDER BY department_name, job_id. **Hint:** ORDER BY d.department_name, e.job_id;

### 20 Hard Questions

1. **H1.** Pivot department_id 10, 20, 30, 40, 50 as columns with count and sum salary. **Hint:** Five COUNT(CASE...) and five SUM(CASE...) or PIVOT with IN (10,20,30,40,50).
2. **H2.** Hierarchical query with CONNECT_BY_ROOT last_name to show root name in each row. **Hint:** CONNECT_BY_ROOT last_name AS root_manager
3. **H3.** ROLLUP with department_id and job_id; filter to show only subtotal rows (GROUPING(department_id)=1 OR GROUPING(job_id)=1). **Hint:** SELECT ... HAVING GROUPING(department_id)=1 OR GROUPING(job_id)=1 or use in outer query.
4. **H4.** CONNECT BY with cycle detection: CONNECT BY NOCYCLE PRIOR ... **Hint:** Add NOCYCLE to avoid infinite loop if cycle in data.
5. **H5.** Dashboard query: department_id, employee_id, salary, dept_total (window sum), rank_in_dept (RANK() OVER (PARTITION BY department_id ORDER BY salary DESC)). **Hint:** SELECT department_id, employee_id, salary, SUM(salary) OVER (PARTITION BY department_id) dept_total, RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) rnk FROM hr.employees;
6. **H6.** Conditional aggregation: total_sales_sal, total_nonsales_sal in one row (by department_name = 'Sales'). **Hint:** SUM(CASE WHEN d.department_name = 'Sales' THEN e.salary END), SUM(CASE WHEN d.department_name != 'Sales' OR d.department_name IS NULL THEN e.salary END).
7. **H7.** SYS_CONNECT_BY_PATH with first_name and last_name. **Hint:** SYS_CONNECT_BY_PATH(first_name||' '||last_name, ' | ') AS path
8. **H8.** PIVOT with dynamic department list (use static list for assignment). **Hint:** For dynamic need PL/SQL; static: IN (10,20,...,100).
9. **H9.** Report: department_name, then for each job_id show count (columns: job_SA_REP_cnt, job_ST_MAN_cnt, ...). **Hint:** Conditional aggregation: COUNT(CASE WHEN job_id = 'SA_REP' THEN 1 END) AS job_SA_REP_cnt, ...
10. **H10.** CUBE instead of ROLLUP: all combinations of subtotals. **Hint:** GROUP BY CUBE(department_id, job_id).
11. **H11.** CONNECT BY with ORDER SIBLINGS BY salary DESC. **Hint:** Siblings (same manager) ordered by salary.
12. **H12.** Window function: running total of salary by hire_date (ORDER BY hire_date). **Hint:** SUM(salary) OVER (ORDER BY hire_date) AS running_total
13. **H13.** Combine: CTE with department totals; join to employees; add RANK() in outer SELECT. **Hint:** WITH dept_tot AS (SELECT department_id, SUM(salary) t FROM hr.employees GROUP BY department_id) SELECT e.*, d.t, RANK() OVER (PARTITION BY e.department_id ORDER BY e.salary DESC) FROM hr.employees e JOIN dept_tot d ON e.department_id = d.department_id;
14. **H14.** GROUPING SETS: (department_id), (job_id), () for three grouping levels. **Hint:** GROUP BY GROUPING SETS ((department_id), (job_id), ());
15. **H15.** Hierarchical: list only leaf employees (no subordinates). **Hint:** SELECT * FROM (...) WHERE NOT EXISTS (SELECT 1 FROM hr.employees e2 WHERE e2.manager_id = e.employee_id) or CONNECT BY with filter.
16. **H16.** Pivot with department_name instead of id (use CASE on department_name). **Hint:** COUNT(CASE WHEN d.department_name = 'Sales' THEN 1 END) AS sales_cnt, ...
17. **H17.** Report with BREAK ON in SQL*Plus (conceptual). **Hint:** BREAK ON department_name; then run query; suppresses repeated department_name.
18. **H18.** Running sum by department: SUM(salary) OVER (PARTITION BY department_id ORDER BY hire_date). **Hint:** Cumulative salary within each department by hire date.
19. **H19.** CONNECT BY with multiple roots: START WITH department_id = 50 (e.g. start from one department's employees). **Hint:** START WITH department_id = 50 CONNECT BY ... (adjust to your hierarchy).
20. **H20.** One report query: department_name, job_id, headcount, total_salary, and % of department total (salary / SUM(salary) OVER (PARTITION BY department_id) * 100). **Hint:** Join, GROUP BY, and add window expression in outer query or use ratio_to_report.

---

[← Back to Learning Plan](../30-day-sql-plsql-learning-plan.md) | [Tutorial](../tutorials/day29_advanced_reporting.md)
