# Day 10 Assignment: HAVING & Advanced Aggregation

All exercises use **hr.employees** and **hr.departments** only.

---

## Part 1: Practice Questions (With Answers and Explanations)

### Question 1  
List **departments** (department_id) where the **average salary** is **greater than 8000**. Use HAVING.

**Answer:**

```sql
SELECT department_id, AVG(salary) AS avg_salary
FROM hr.employees
GROUP BY department_id
HAVING AVG(salary) > 8000;
```

**Explanation:** GROUP BY department_id, then HAVING AVG(salary) > 8000 filters out departments whose average salary is 8000 or less.

---

### Question 2  
List **job_id** values that have **more than 3** employees.

**Answer:**

```sql
SELECT job_id, COUNT(*) AS emp_count
FROM hr.employees
GROUP BY job_id
HAVING COUNT(*) > 3;
```

**Explanation:** GROUP BY job_id, then HAVING COUNT(*) > 3 keeps only jobs with more than 3 employees.

---

### Question 3  
Show **department name** and **total salary** for each department. (Join hr.employees to hr.departments and use GROUP BY with SUM(salary).)

**Answer:**

```sql
SELECT d.department_name, SUM(e.salary) AS total_salary
FROM hr.employees e
INNER JOIN hr.departments d ON e.department_id = d.department_id
GROUP BY d.department_id, d.department_name;
```

**Explanation:** Join on department_id, then GROUP BY department identifier and name. SUM(e.salary) gives total salary per department.

---

## Part 2: Self-Practice (No Answers)

1. List **departments** (by id or name) where **total salary** is **greater than 200000**.
2. List **job_id** where the **minimum salary** in that job is **less than 3000**.
3. Use **ROLLUP** on **department_id** in a query that shows COUNT(*) and SUM(salary), and describe the extra rows ROLLUP adds.

---

## Part 3: Additional Practice — 20 Medium + 20 Hard Questions (With Hints)

All use **hr.employees** and **hr.departments** only.

### 20 Medium Questions

1. **M1.** List department_id where average salary > 8000 (HAVING AVG(salary) > 8000).  
   **Hint:** GROUP BY department_id HAVING AVG(salary) > 8000;

2. **M2.** Show job_id that have more than 3 employees.  
   **Hint:** GROUP BY job_id HAVING COUNT(*) > 3;

3. **M3.** List department_name and total salary per department (join and GROUP BY).  
   **Hint:** Join e and d, GROUP BY d.department_id, d.department_name, SUM(e.salary);

4. **M4.** List department_id where total salary > 150000.  
   **Hint:** GROUP BY department_id HAVING SUM(salary) > 150000;

5. **M5.** Show job_id where min(salary) < 4000.  
   **Hint:** GROUP BY job_id HAVING MIN(salary) < 4000;

6. **M6.** List department_id and count(*) per department; only departments with more than 5 employees.  
   **Hint:** GROUP BY department_id HAVING COUNT(*) > 5;

7. **M7.** Show department_name and average salary per department (join, GROUP BY).  
   **Hint:** Join, GROUP BY d.department_id, d.department_name, AVG(e.salary);

8. **M8.** List job_id and total salary for jobs with more than 2 employees.  
   **Hint:** GROUP BY job_id HAVING COUNT(*) > 2;

9. **M9.** Show department_id where max(salary) > 12000.  
   **Hint:** GROUP BY department_id HAVING MAX(salary) > 12000;

10. **M10.** List department_name and employee count; only departments with at least 3 employees.  
    **Hint:** Join, GROUP BY d.department_id, d.department_name HAVING COUNT(e.employee_id) >= 3;

11. **M11.** Show job_id and avg(salary) for jobs with total salary > 50000.  
    **Hint:** GROUP BY job_id HAVING SUM(salary) > 50000;

12. **M12.** List department_id where average salary is between 6000 and 10000.  
    **Hint:** GROUP BY department_id HAVING AVG(salary) BETWEEN 6000 AND 10000;

13. **M13.** Show department_name and min(salary), max(salary) per department (join).  
    **Hint:** Join, GROUP BY d.department_id, d.department_name;

14. **M14.** List job_id that have exactly 2 employees.  
    **Hint:** GROUP BY job_id HAVING COUNT(*) = 2;

15. **M15.** Show department_id and sum(salary); only departments with avg(salary) < 7000.  
    **Hint:** GROUP BY department_id HAVING AVG(salary) < 7000;

16. **M16.** List department_name and total salary; only departments with more than 10 employees.  
    **Hint:** Join, GROUP BY d.department_id, d.department_name HAVING COUNT(*) > 10;

17. **M17.** Show job_id and count(*) for job_id starting with 'SA'.  
    **Hint:** WHERE job_id LIKE 'SA%' GROUP BY job_id;

18. **M18.** List department_id where min(hire_date) is after 2005-01-01.  
    **Hint:** GROUP BY department_id HAVING MIN(hire_date) > DATE '2005-01-01';

19. **M19.** Show department_name and employee count; only departments with total salary > 200000.  
    **Hint:** Join, GROUP BY d.department_id, d.department_name HAVING SUM(e.salary) > 200000;

20. **M20.** List job_id and avg(salary) for jobs with at least 1 employee; order by avg(salary) desc.  
    **Hint:** GROUP BY job_id HAVING COUNT(*) >= 1 ORDER BY AVG(salary) DESC;

### 20 Hard Questions

1. **H1.** Show department_id, job_id, count(*), sum(salary) with ROLLUP(department_id, job_id).  
   **Hint:** GROUP BY ROLLUP(department_id, job_id);

2. **H2.** List department_name and total salary; only departments where average salary > 8000 and count > 3.  
   **Hint:** Join, GROUP BY d.department_id, d.department_name HAVING AVG(e.salary) > 8000 AND COUNT(*) > 3;

3. **H3.** Show job_id and count of employees; only for department_id 50, 60, 80.  
   **Hint:** WHERE department_id IN (50,60,80) GROUP BY job_id;

4. **H4.** List department_id where total salary is in the top 3 (use subquery: HAVING SUM(salary) IN (SELECT ... ORDER BY SUM(salary) DESC FETCH FIRST 3 ROWS ONLY)).  
   **Hint:** GROUP BY department_id HAVING SUM(salary) IN (SELECT SUM(salary) FROM hr.employees GROUP BY department_id ORDER BY SUM(salary) DESC FETCH FIRST 3 ROWS ONLY);

5. **H5.** Show department_name, count(*), and sum(salary); only departments with at least one employee with commission_pct not null.  
   **Hint:** Join, GROUP BY d.department_id, d.department_name HAVING COUNT(e.commission_pct) > 0;

6. **H6.** List job_id and average salary; only jobs where max(salary) - min(salary) > 5000.  
   **Hint:** GROUP BY job_id HAVING MAX(salary) - MIN(salary) > 5000;

7. **H7.** Show department_id, department_name (join), count(*), sum(salary), avg(salary) per department; only departments with count > 2 and avg > 6000.  
   **Hint:** Join, GROUP BY d.department_id, d.department_name HAVING COUNT(*) > 2 AND AVG(e.salary) > 6000;

8. **H8.** List department_name and number of employees with salary > 5000 in that department (use SUM(CASE WHEN e.salary > 5000 THEN 1 ELSE 0 END)).  
   **Hint:** Join, GROUP BY d.department_id, d.department_name; SUM(CASE WHEN e.salary > 5000 THEN 1 ELSE 0 END);

9. **H9.** Show job_id and total salary for jobs that have at least 2 employees and total salary > 20000.  
   **Hint:** GROUP BY job_id HAVING COUNT(*) >= 2 AND SUM(salary) > 20000;

10. **H10.** List department_id where the department has both at least 3 employees and average salary < 9000.  
    **Hint:** GROUP BY department_id HAVING COUNT(*) >= 3 AND AVG(salary) < 9000;

11. **H11.** Show department_name and avg(salary) rounded to 2 decimals; only departments with total salary > 100000.  
    **Hint:** Join, GROUP BY d.department_id, d.department_name HAVING SUM(e.salary) > 100000; ROUND(AVG(e.salary), 2);

12. **H12.** List job_id and count(*) and sum(salary); only job_ids that have more than 1 employee and sum(salary) > 30000.  
    **Hint:** GROUP BY job_id HAVING COUNT(*) > 1 AND SUM(salary) > 30000;

13. **H13.** Show department_id, job_id, count(*) with GROUPING SETS ((department_id), (job_id)) to get two grouping levels.  
    **Hint:** GROUP BY GROUPING SETS (department_id, job_id);

14. **H14.** List department_name and total salary; exclude departments with only 1 employee.  
    **Hint:** Join, GROUP BY d.department_id, d.department_name HAVING COUNT(*) > 1;

15. **H15.** Show department_id where min(salary) > 3000 and max(salary) < 15000.  
    **Hint:** GROUP BY department_id HAVING MIN(salary) > 3000 AND MAX(salary) < 15000;

16. **H16.** List job_id and average salary; only for employees hired after 2000.  
    **Hint:** WHERE hire_date > DATE '2000-12-31' GROUP BY job_id, AVG(salary);

17. **H17.** Show department_name, count(*), sum(salary), and avg(salary) per department; only departments with count between 2 and 10.  
    **Hint:** Join, GROUP BY d.department_id, d.department_name HAVING COUNT(*) BETWEEN 2 AND 10;

18. **H18.** List department_id that has the highest average salary (subquery: HAVING AVG(salary) >= ALL (SELECT AVG(salary) FROM hr.employees GROUP BY department_id)).  
   **Hint:** GROUP BY department_id HAVING AVG(salary) = (SELECT MAX(av) FROM (SELECT AVG(salary) av FROM hr.employees GROUP BY department_id));

19. **H19.** Show department_id, job_id, count(*) with CUBE(department_id, job_id).  
    **Hint:** GROUP BY CUBE(department_id, job_id);

20. **H20.** List department_name and total salary; only departments where at least one employee has job_id 'SA_REP'.  
    **Hint:** Join, WHERE e.job_id = 'SA_REP' or HAVING MAX(CASE WHEN e.job_id = 'SA_REP' THEN 1 ELSE 0 END) = 1; GROUP BY d.department_id, d.department_name;

---

[← Back to Learning Plan](../30-day-sql-plsql-learning-plan.md) | [Tutorial](../tutorials/day10_having_aggregation.md)
