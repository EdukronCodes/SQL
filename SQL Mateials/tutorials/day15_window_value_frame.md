# Day 15: Window Functions – Value & Frame — Full Notes and Theory

---

## 1. LAG and LEAD

- **LAG(column, offset, default):** Value from a **previous** row in the partition (by order). Default offset 1; default value NULL if omitted.
- **LEAD(column, offset, default):** Value from a **following** row.

```sql
SELECT employee_id, first_name, department_id, salary,
  LAG(salary) OVER (PARTITION BY department_id ORDER BY employee_id) AS prev_salary,
  LEAD(salary) OVER (PARTITION BY department_id ORDER BY employee_id) AS next_salary
FROM hr.employees;
```

Use LAG/LEAD for before/after comparisons (e.g., previous salary, next hire date). All examples use **hr.employees** and **hr.departments** only.

---

## 2. Window Frame (ROWS BETWEEN, RANGE)

A **frame** limits which rows in the partition are used for the calculation.

- **UNBOUNDED PRECEDING** — from the first row of the partition.
- **CURRENT ROW** — up to or including the current row.
- **UNBOUNDED FOLLOWING** — to the last row of the partition.
- **n PRECEDING / n FOLLOWING** — n rows before or after (with ROWS).

---

## 3. Running Total

Sum of salary from the start of the partition to the current row:

```sql
SELECT employee_id, first_name, hire_date, salary,
  SUM(salary) OVER (ORDER BY hire_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total_salary
FROM hr.employees;
```

Per department: add **PARTITION BY department_id** and order by hire_date (or employee_id) within the partition.

---

## 4. Moving Average

**Moving 3-row average** (current row and 2 preceding):

```sql
SELECT employee_id, department_id, salary,
  AVG(salary) OVER (PARTITION BY department_id ORDER BY employee_id
    ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg_3
FROM hr.employees;
```

---

## 5. FIRST_VALUE and LAST_VALUE

- **FIRST_VALUE(column):** Value from the first row in the frame.
- **LAST_VALUE(column):** With the default frame, you often need **RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING** to get the partition’s last value.

```sql
SELECT employee_id, department_id, salary,
  FIRST_VALUE(salary) OVER (PARTITION BY department_id ORDER BY salary) AS min_sal_in_dept,
  LAST_VALUE(salary) OVER (PARTITION BY department_id ORDER BY salary RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS max_sal_in_dept
FROM hr.employees;
```

---

## 6. Application to Salary and Tenure

Use **LAG/LEAD** for previous/next salary or hire date; **running sum** for cumulative salary; **moving average** for smoothing; **FIRST_VALUE/LAST_VALUE** for min/max within a partition.

---

## 7. Summary Points

- **LAG** = previous row value; **LEAD** = next row value.
- **Frame** (ROWS/RANGE BETWEEN) defines which rows are used for the calculation.
- **Running total:** SUM(...) OVER (ORDER BY ... ROWS UNBOUNDED PRECEDING AND CURRENT ROW).
- **FIRST_VALUE/LAST_VALUE** need explicit frame for "whole partition" when used with ORDER BY. All examples use **hr.employees** and **hr.departments** only.

---

[← Day 14](./day14_window_ranking.md) | [Back to Learning Plan](../30-day-sql-plsql-learning-plan.md) | [Next: Day 16 →](./day16_constraints.md)
