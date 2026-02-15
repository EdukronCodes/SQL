# Day 15 Assignment: Window Functions – Value and Frame

All exercises use **hr.employees** only.

---

## Part 1: Practice Questions (With Answers and Explanations)

### Question 1
Show a **running total of salary** ordered by **hire_date** (company-wide). For each row, show employee_id, hire_date, salary, and running_total_salary.

**Answer:**

```sql
SELECT employee_id, hire_date, salary,
  SUM(salary) OVER (ORDER BY hire_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total_salary
FROM hr.employees;
```

**Explanation:** The window is all rows from the start of the result set up to the current row, ordered by hire_date. SUM(salary) over that frame gives the cumulative sum. Default frame for SUM with ORDER BY in Oracle is often equivalent; explicit ROWS UNBOUNDED PRECEDING AND CURRENT ROW makes it clear.

---

### Question 2
For each employee, show **previous employee salary** within the same **department** (order by employee_id). Use LAG(salary) with PARTITION BY department_id ORDER BY employee_id.

**Answer:**

```sql
SELECT employee_id, department_id, salary,
  LAG(salary) OVER (PARTITION BY department_id ORDER BY employee_id) AS prev_salary_in_dept
FROM hr.employees;
```

**Explanation:** LAG(salary) returns the salary of the previous row in the partition. Partition by department_id and order by employee_id so "previous" is by employee_id within the department. First row in each partition has no previous row, so prev_salary_in_dept is NULL.

---

### Question 3
Show a **moving 3-row average** of salary within each **department**. Order by employee_id; for each row, average the current row and the two preceding rows (or fewer at the start). Use AVG(salary) with ROWS BETWEEN 2 PRECEDING AND CURRENT ROW.

**Answer:**

```sql
SELECT employee_id, department_id, salary,
  AVG(salary) OVER (PARTITION BY department_id ORDER BY employee_id ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg_3
FROM hr.employees;
```

**Explanation:** For each row, the frame is at most the current row and the two preceding rows (by employee_id within department). AVG over that frame gives the moving average. At the start of a department there are fewer than 3 rows, so the average is over 1 or 2 values.

---

## Part 2: Self-Practice (No Answers)

1. Use **LEAD(hire_date)** to show the **next employee hire date** within the same department (order by hire_date).
2. Show **cumulative salary** (running total) **per department**, ordered by hire_date within each department.

---

## Part 3: Additional Practice — 20 Medium + 20 Hard Questions (With Hints)

All use **hr.employees** and **hr.departments** only.

### 20 Medium Questions

1. **M1.** LAG(salary) OVER (PARTITION BY department_id ORDER BY employee_id). **Hint:** Previous row's salary in dept.
2. **M2.** LEAD(salary) OVER (PARTITION BY department_id ORDER BY employee_id). **Hint:** Next row's salary in dept.
3. **M3.** SUM(salary) OVER (ORDER BY hire_date ROWS UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total. **Hint:** Running total by hire_date.
4. **M4.** AVG(salary) OVER (PARTITION BY department_id). **Hint:** Dept average per row.
5. **M5.** LAG(hire_date) OVER (PARTITION BY department_id ORDER BY hire_date). **Hint:** Previous hire date in dept.
6. **M6.** SUM(salary) OVER (PARTITION BY department_id ORDER BY hire_date ROWS UNBOUNDED PRECEDING AND CURRENT ROW). **Hint:** Running total per dept by hire_date.
7. **M7.** LEAD(hire_date) OVER (PARTITION BY department_id ORDER BY hire_date). **Hint:** Next hire date in dept.
8. **M8.** AVG(salary) OVER (PARTITION BY department_id ORDER BY employee_id ROWS BETWEEN 2 PRECEDING AND CURRENT ROW). **Hint:** Moving 3-row average per dept.
9. **M9.** FIRST_VALUE(salary) OVER (PARTITION BY department_id ORDER BY salary). **Hint:** Min salary in dept.
10. **M10.** LAST_VALUE(salary) OVER (PARTITION BY department_id ORDER BY salary RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING). **Hint:** Max salary in dept.
11. **M11.** LAG(salary, 2, 0) OVER (ORDER BY employee_id). **Hint:** Salary from 2 rows back; default 0.
12. **M12.** SUM(salary) OVER (PARTITION BY job_id ORDER BY hire_date). **Hint:** Running total per job.
13. **M13.** LEAD(commission_pct) OVER (PARTITION BY department_id ORDER BY employee_id). **Hint:** Next row's commission_pct in dept.
14. **M14.** AVG(salary) OVER (ORDER BY hire_date ROWS BETWEEN 4 PRECEDING AND CURRENT ROW). **Hint:** Moving 5-row average.
15. **M15.** LAG(first_name) OVER (PARTITION BY department_id ORDER BY employee_id). **Hint:** Previous employee's first name in dept.
16. **M16.** SUM(salary) OVER () AS total_company_salary (same value per row). **Hint:** No PARTITION/ORDER or ORDER BY with full window.
17. **M17.** FIRST_VALUE(hire_date) OVER (PARTITION BY department_id ORDER BY hire_date). **Hint:** Earliest hire in dept.
18. **M18.** LAST_VALUE(hire_date) OVER (PARTITION BY department_id ORDER BY hire_date RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING). **Hint:** Latest hire in dept.
19. **M19.** LAG(salary) OVER (ORDER BY salary DESC). **Hint:** Next lower salary (order by salary desc so "previous" in that order).
20. **M20.** COUNT(*) OVER (PARTITION BY department_id). **Hint:** Count of employees in dept per row.

### 20 Hard Questions

1. **H1.** Running total of salary by hire_date for whole company; also show running count (COUNT(*) OVER (ORDER BY hire_date ROWS UNBOUNDED PRECEDING AND CURRENT ROW)). **Hint:** SUM and COUNT with same frame.
2. **H2.** For each employee show salary, LAG(salary), and salary - LAG(salary) AS diff_from_prev (difference from previous row's salary in partition). **Hint:** LAG in SELECT; then expression; partition by dept order by employee_id.
3. **H3.** Moving average of salary (5 rows: 2 preceding, current, 2 following) per department. **Hint:** ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING.
4. **H4.** FIRST_VALUE(salary) and LAST_VALUE(salary) OVER (PARTITION BY department_id ORDER BY salary) with correct frame for LAST_VALUE. **Hint:** LAST_VALUE needs RANGE UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING.
5. **H5.** Lead of hire_date (next hire in dept) and DATEDIFF or (LEAD(hire_date) - hire_date) for days between hires. **Hint:** LEAD(hire_date) - hire_date; Oracle date arithmetic gives days.
6. **H6.** Running sum of salary partitioned by department_id, ordered by hire_date; also show row number within department by hire_date. **Hint:** SUM(...) OVER (PARTITION BY department_id ORDER BY hire_date); ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY hire_date).
7. **H7.** LAG(salary, 1, salary) OVER (PARTITION BY department_id ORDER BY employee_id) (previous salary or self if first). **Hint:** Default third arg = salary for first row.
8. **H8.** Percent of department total: salary * 100.0 / SUM(salary) OVER (PARTITION BY department_id). **Hint:** Ratio to sum; no ORDER BY in SUM for full partition.
9. **H9.** Running total of salary by department and hire_date; show also cumulative percentage of department total (running_sum / SUM(salary) OVER (PARTITION BY department_id) * 100). **Hint:** Running sum and fixed sum per dept.
10. **H10.** LEAD(salary, 2) OVER (PARTITION BY job_id ORDER BY salary DESC) (salary of person 2 ranks below in job). **Hint:** LEAD with offset 2.
11. **H11.** FIRST_VALUE(first_name) OVER (PARTITION BY department_id ORDER BY salary DESC) (name of highest-paid in dept). **Hint:** ORDER BY salary DESC; first value is top earner.
12. **H12.** Moving 3-row median or middle value: use NTH_VALUE(salary, 2) OVER (PARTITION BY department_id ORDER BY salary ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) if available, or average of 3. **Hint:** Oracle: NTH_VALUE or (LAG(salary)+salary+LEAD(salary))/3 for 3-row window.
13. **H13.** Running sum of salary per department; reset at each new department. **Hint:** SUM(salary) OVER (PARTITION BY department_id ORDER BY employee_id ROWS UNBOUNDED PRECEDING AND CURRENT ROW).
14. **H14.** LAG(salary) and LEAD(salary) in same SELECT; show salary, prev, next. **Hint:** Both LAG and LEAD with same PARTITION/ORDER.
15. **H15.** LAST_VALUE(employee_id) OVER (PARTITION BY department_id ORDER BY hire_date RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) (employee_id of last hired in dept). **Hint:** LAST_VALUE with full frame.
16. **H16.** Running average (not sum) of salary over hire_date: AVG(salary) OVER (ORDER BY hire_date ROWS UNBOUNDED PRECEDING AND CURRENT ROW). **Hint:** AVG with same frame as running sum.
17. **H17.** Difference from department average: salary - AVG(salary) OVER (PARTITION BY department_id). **Hint:** No ORDER BY in AVG for partition average.
18. **H18.** LAG(salary) OVER (PARTITION BY department_id ORDER BY hire_date) and compare to current (salary - LAG(salary)). **Hint:** LAG by hire_date; then diff.
19. **H19.** COUNT(*) OVER (PARTITION BY department_id ORDER BY hire_date ROWS UNBOUNDED PRECEDING AND CURRENT ROW) (running count of employees in dept by hire order). **Hint:** Running count with same frame.
20. **H20.** FIRST_VALUE and LAST_VALUE of salary OVER (PARTITION BY job_id ORDER BY salary); show job_id, salary, min_sal, max_sal. **Hint:** FIRST_VALUE and LAST_VALUE with full frame for LAST_VALUE.

---

[← Back to Learning Plan](../30-day-sql-plsql-learning-plan.md) | [Tutorial](../tutorials/day15_window_value_frame.md)
