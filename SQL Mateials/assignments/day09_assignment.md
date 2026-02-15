# Day 9 Assignment: Aggregation & GROUP BY

All exercises use **hr.employees** (and **hr.departments** if needed).

---

## Part 1: Practice Questions (With Answers and Explanations)

### Question 1  
Show **total salary** per **department_id**.

**Answer:**

```sql
SELECT department_id, SUM(salary) AS total_salary
FROM hr.employees
GROUP BY department_id;
```

**Explanation:** GROUP BY department_id creates one row per department. SUM(salary) is the total salary for that department.

---

### Question 2  
Show **average salary** per **job_id**.

**Answer:**

```sql
SELECT job_id, AVG(salary) AS avg_salary
FROM hr.employees
GROUP BY job_id;
```

**Explanation:** GROUP BY job_id; AVG(salary) computes the average salary for each job.

---

### Question 3  
Show the **number of employees** per **department_id**.

**Answer:**

```sql
SELECT department_id, COUNT(*) AS employee_count
FROM hr.employees
GROUP BY department_id;
```

**Explanation:** COUNT(*) counts rows in each group. GROUP BY department_id gives one row per department.

---

### Question 4  
Show the **minimum** and **maximum** hire_date per **department_id**. Use MIN(hire_date) and MAX(hire_date).

**Answer:**

```sql
SELECT department_id, MIN(hire_date) AS earliest_hire, MAX(hire_date) AS latest_hire
FROM hr.employees
GROUP BY department_id;
```

**Explanation:** MIN and MAX work on dates; they give the earliest and latest hire date in each department.

---

## Part 2: Self-Practice (No Answers)

1. Show **average salary** per **job_id** only for job_ids that have **more than 5** employees (use HAVING COUNT(*) > 5).
2. Show the **sum of salary** for **department_id 50** only (one row).
3. Show the **maximum** **commission_pct** per **department_id** (remember NULLs are ignored by MAX).

---

## Part 3: Additional Practice — 20 Medium + 20 Hard Questions (With Hints)

All use **hr.employees** and **hr.departments** only.

### 20 Medium Questions

1. **M1.** Show total salary (SUM(salary)) for the whole company from hr.employees.  
   **Hint:** SELECT SUM(salary) FROM hr.employees;

2. **M2.** Count employees per job_id.  
   **Hint:** GROUP BY job_id, COUNT(*);

3. **M3.** Show average salary per department_id.  
   **Hint:** GROUP BY department_id, AVG(salary);

4. **M4.** List department_id and min(salary), max(salary) per department.  
   **Hint:** GROUP BY department_id, MIN(salary), MAX(salary);

5. **M5.** Count employees per department_id.  
   **Hint:** GROUP BY department_id, COUNT(*);

6. **M6.** Show job_id and total salary per job.  
   **Hint:** GROUP BY job_id, SUM(salary);

7. **M7.** List department_id and number of employees with non-null commission_pct (COUNT(commission_pct)).  
   **Hint:** GROUP BY department_id, COUNT(commission_pct);

8. **M8.** Show min(hire_date) and max(hire_date) per job_id.  
   **Hint:** GROUP BY job_id, MIN(hire_date), MAX(hire_date);

9. **M9.** Count total employees (COUNT(*)) in hr.employees.  
   **Hint:** SELECT COUNT(*) FROM hr.employees;

10. **M10.** Show department_id, avg(salary), and count(*) per department.  
    **Hint:** GROUP BY department_id;

11. **M11.** List job_id and average salary per job; order by average salary desc.  
    **Hint:** GROUP BY job_id, AVG(salary) ORDER BY AVG(salary) DESC;

12. **M12.** Show department_id and sum(salary) for department_id in (50, 60, 80).  
    **Hint:** WHERE department_id IN (50,60,80) GROUP BY department_id, SUM(salary);

13. **M13.** Count employees per manager_id (include only where manager_id is not null).  
    **Hint:** WHERE manager_id IS NOT NULL GROUP BY manager_id, COUNT(*);

14. **M14.** Show job_id and min(salary) per job.  
    **Hint:** GROUP BY job_id, MIN(salary);

15. **M15.** List department_id and max(hire_date) per department.  
    **Hint:** GROUP BY department_id, MAX(hire_date);

16. **M16.** Show total salary for department_id 90 only.  
    **Hint:** SELECT SUM(salary) FROM hr.employees WHERE department_id = 90;

17. **M17.** Count distinct job_id values (COUNT(DISTINCT job_id)).  
    **Hint:** SELECT COUNT(DISTINCT job_id) FROM hr.employees;

18. **M18.** Show department_id, job_id, and count(*) per (department_id, job_id).  
    **Hint:** GROUP BY department_id, job_id;

19. **M19.** List department_id and avg(salary) rounded to 2 decimals per department.  
    **Hint:** GROUP BY department_id, ROUND(AVG(salary), 2);

20. **M20.** Show job_id and count of employees; only job_ids with at least 2 employees.  
    **Hint:** GROUP BY job_id HAVING COUNT(*) >= 2;

### 20 Hard Questions

1. **H1.** Show department_id, department_name (join to hr.departments), and total salary per department.  
   **Hint:** Join employees to departments, GROUP BY d.department_id, d.department_name, SUM(e.salary);

2. **H2.** List job_id and average salary for jobs that have more than 3 employees.  
   **Hint:** GROUP BY job_id HAVING COUNT(*) > 3;

3. **H3.** Show department_id and count of employees, and also count of employees hired after 2000 (use SUM(CASE WHEN EXTRACT(YEAR FROM hire_date) > 2000 THEN 1 ELSE 0 END)).  
   **Hint:** GROUP BY department_id; COUNT(*), SUM(CASE WHEN EXTRACT(YEAR FROM hire_date) > 2000 THEN 1 ELSE 0 END);

4. **H4.** List department_id where total salary is greater than 100000.  
   **Hint:** GROUP BY department_id HAVING SUM(salary) > 100000;

5. **H5.** Show job_id and max(salary) and min(salary) per job; only jobs where max - min > 5000.  
   **Hint:** GROUP BY job_id HAVING MAX(salary) - MIN(salary) > 5000;

6. **H6.** List department_name (join) and employee count per department; order by count desc.  
   **Hint:** Join e and d, GROUP BY d.department_id, d.department_name, ORDER BY COUNT(*) DESC;

7. **H7.** Show department_id and average tenure in years (AVG(MONTHS_BETWEEN(SYSDATE, hire_date)/12)) per department.  
   **Hint:** GROUP BY department_id; AVG(MONTHS_BETWEEN(SYSDATE, hire_date)/12);

8. **H8.** List job_id and total salary for jobs with word 'MAN' in job_id.  
   **Hint:** WHERE job_id LIKE '%MAN%' GROUP BY job_id, SUM(salary);

9. **H9.** Show department_id, count(*), and sum(salary) per department; only departments with avg(salary) > 7000.  
   **Hint:** GROUP BY department_id HAVING AVG(salary) > 7000;

10. **H10.** List department_name and min(salary), max(salary) per department (join).  
    **Hint:** Join e and d, GROUP BY d.department_id, d.department_name;

11. **H11.** Show manager_id and count of direct reports; only managers with more than 2 reports.  
    **Hint:** WHERE manager_id IS NOT NULL GROUP BY manager_id HAVING COUNT(*) > 2;

12. **H12.** List department_id and count of distinct job_id in that department.  
    **Hint:** GROUP BY department_id, COUNT(DISTINCT job_id);

13. **H13.** Show job_id and average salary; only for departments 50, 80, 90.  
    **Hint:** WHERE department_id IN (50,80,90) GROUP BY job_id, AVG(salary);

14. **H14.** List department_id where the number of employees is greater than 5 and total salary > 200000.  
    **Hint:** GROUP BY department_id HAVING COUNT(*) > 5 AND SUM(salary) > 200000;

15. **H15.** Show department_name and total salary per department; only departments with at least 1 employee with commission_pct not null.  
    **Hint:** Join; HAVING COUNT(e.commission_pct) > 0 or SUM(CASE WHEN e.commission_pct IS NOT NULL THEN 1 ELSE 0 END) > 0;

16. **H16.** List job_id and count of employees; order by count desc, then job_id.  
    **Hint:** GROUP BY job_id ORDER BY COUNT(*) DESC, job_id;

17. **H17.** Show department_id and sum(salary) and avg(salary) per department; round avg to 2 decimals.  
    **Hint:** GROUP BY department_id; SUM(salary), ROUND(AVG(salary), 2);

18. **H18.** List department_id that has the maximum total salary (use subquery: WHERE SUM(salary) = (SELECT MAX(total) FROM (SELECT SUM(salary) total FROM hr.employees GROUP BY department_id))).  
    **Hint:** GROUP BY department_id HAVING SUM(salary) = (SELECT MAX(s) FROM (SELECT SUM(salary) s FROM hr.employees GROUP BY department_id));

19. **H19.** Show department_id, job_id, count(*), and sum(salary) per (department_id, job_id); use ROLLUP(department_id, job_id).  
    **Hint:** GROUP BY ROLLUP(department_id, job_id);

20. **H20.** List department_name and employee count; include departments with 0 employees (LEFT JOIN from departments to employees, then GROUP BY).  
    **Hint:** FROM hr.departments d LEFT JOIN hr.employees e ON d.department_id = e.department_id GROUP BY d.department_id, d.department_name; COUNT(e.employee_id);

---

[← Back to Learning Plan](../30-day-sql-plsql-learning-plan.md) | [Tutorial](../tutorials/day09_aggregation.md)
