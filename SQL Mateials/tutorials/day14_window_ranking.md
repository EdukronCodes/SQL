# Day 14: Window Functions – Ranking — Full Notes and Theory

---

## 1. What Window Functions Are

**Window functions** compute a value from a set of rows that are related to the current row (a "window") **without** collapsing rows into groups. So each row stays one row, but you can add columns like "average salary in my department," "rank by salary," or "running total." The window is defined by **OVER ()**, optionally with **PARTITION BY** and **ORDER BY**. All examples use **hr.employees** and **hr.departments** only.

- **PARTITION BY** splits the result into partitions; the function is computed within each partition.
- **ORDER BY** inside OVER defines order within the partition (and for ranking, who is first, second, etc.).
- Common ranking functions: **ROW_NUMBER()**, **RANK()**, **DENSE_RANK()**, **NTILE(n)**.

---

## 2. OVER () and PARTITION BY

**OVER ()** with no partition: the window is the whole result set.

```sql
SELECT employee_id, first_name, salary, AVG(salary) OVER () AS company_avg
FROM hr.employees;
```

**PARTITION BY:** The window is per partition (e.g., per department).

```sql
SELECT employee_id, first_name, department_id, salary,
  AVG(salary) OVER (PARTITION BY department_id) AS dept_avg_salary
FROM hr.employees;
```

---

## 3. ORDER BY in Window and ROW_NUMBER()

**ORDER BY** inside OVER defines order within the partition. For ranking functions, it defines who gets 1, 2, 3, …

**ROW_NUMBER()** assigns a unique sequential number (1, 2, 3, …) within the partition; ties get different numbers.

```sql
SELECT employee_id, first_name, department_id, salary,
  ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY salary DESC) AS rn
FROM hr.employees;
```

Use this in a subquery and filter **WHERE rn = 1** to get "top one per department" (e.g., highest salary per department).

---

## 4. RANK() and DENSE_RANK()

- **RANK():** Ties get the same rank; the next rank **skips** (e.g., 1, 2, 2, 4).
- **DENSE_RANK():** Ties get the same rank; the next rank **does not skip** (e.g., 1, 2, 2, 3).

```sql
SELECT employee_id, first_name, salary,
  RANK() OVER (ORDER BY salary DESC) AS rank_sal,
  DENSE_RANK() OVER (ORDER BY salary DESC) AS dense_rank_sal
FROM hr.employees;
```

---

## 5. NTILE

**NTILE(n)** splits rows into **n** roughly equal groups (e.g., quartiles with NTILE(4)).

```sql
SELECT employee_id, first_name, salary,
  NTILE(4) OVER (ORDER BY salary) AS salary_quartile
FROM hr.employees;
```

---

## 6. Examples on hr.employees

- Rank employees by salary within department: `RANK() OVER (PARTITION BY department_id ORDER BY salary DESC)`.
- Top earner per department: ROW_NUMBER() as above, then outer query WHERE rn = 1.
- DENSE_RANK by hire_date per job_id: `DENSE_RANK() OVER (PARTITION BY job_id ORDER BY hire_date)`.

---

## 7. Summary Points

- **OVER ()** defines the window; **PARTITION BY** and **ORDER BY** narrow and order it.
- **ROW_NUMBER()** = unique rank; **RANK()** = ties same rank, then skip; **DENSE_RANK()** = ties same rank, no skip.
- **NTILE(n)** splits into n groups. All examples use **hr.employees** and **hr.departments** only.

---

[← Day 13](./day13_set_operations.md) | [Back to Learning Plan](../30-day-sql-plsql-learning-plan.md) | [Next: Day 15 →](./day15_window_value_frame.md)
