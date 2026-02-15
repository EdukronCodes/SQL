# Day 8 Assignment: All Join Types

All exercises use **hr.employees** and **hr.departments** only.

---

## Part 1: Practice Questions (With Answers and Explanations)

### Question 1  
List **all departments** and the **count of employees** in each. Include departments that have **zero** employees.

**Answer:**

```sql
SELECT d.department_id, d.department_name, COUNT(e.employee_id) AS employee_count
FROM hr.departments d
LEFT JOIN hr.employees e ON e.department_id = d.department_id
GROUP BY d.department_id, d.department_name;
```

**Explanation:** Use departments as the left table and LEFT JOIN employees so every department appears. COUNT(e.employee_id) counts only matching employees; departments with no employees get 0 (because employee_id is NULL for those rows).

---

### Question 2  
For each employee, show the employee’s first and last name and the **manager’s first and last name** (self-join on manager_id).

**Answer:**

```sql
SELECT e.first_name AS emp_first, e.last_name AS emp_last,
       m.first_name AS mgr_first, m.last_name AS mgr_last
FROM hr.employees e
LEFT JOIN hr.employees m ON e.manager_id = m.employee_id;
```

**Explanation:** Join hr.employees to itself: e = employee, m = manager. ON e.manager_id = m.employee_id. LEFT JOIN so employees with no manager (manager_id NULL) still appear with NULL for manager name.

---

### Question 3  
List employees who have **no department** (department_id is NULL in hr.employees). Use a left join to departments and filter where department is missing.

**Answer:**

```sql
SELECT e.employee_id, e.first_name, e.last_name, e.department_id
FROM hr.employees e
LEFT JOIN hr.departments d ON e.department_id = d.department_id
WHERE d.department_id IS NULL;
```

**Explanation:** LEFT JOIN keeps all employees. Where an employee has no matching department (e.g. department_id NULL or not in departments), d.department_id is NULL. Filtering WHERE d.department_id IS NULL returns only those employees.

---

## Part 2: Self-Practice (No Answers)

1. Using a self-join, show **two levels** of hierarchy: employee → manager → manager’s manager (if exists).
2. List **departments** that have **no employees** (use RIGHT JOIN or a subquery / NOT EXISTS from departments).

---

## Part 3: Additional Practice — 20 Medium + 20 Hard Questions (With Hints)

All use **hr.employees** and **hr.departments** only.

### 20 Medium Questions

1. **M1.** List all employees (employee_id, first_name, last_name) and department_name; include employees with no department (LEFT JOIN).  
   **Hint:** FROM hr.employees e LEFT JOIN hr.departments d ON e.department_id = d.department_id;

2. **M2.** For each employee show first_name, last_name, and manager's first_name and last_name (self-join).  
   **Hint:** e LEFT JOIN employees m ON e.manager_id = m.employee_id;

3. **M3.** List all departments (department_id, department_name) and count of employees; include departments with 0 employees.  
   **Hint:** FROM hr.departments d LEFT JOIN hr.employees e ON d.department_id = e.department_id GROUP BY d.department_id, d.department_name; COUNT(e.employee_id);

4. **M4.** Show employees who have no department (LEFT JOIN to departments, WHERE d.department_id IS NULL).  
   **Hint:** LEFT JOIN then WHERE d.department_id IS NULL;

5. **M5.** List employee first_name, last_name, and department_name; use COALESCE(d.department_name, 'No Dept').  
   **Hint:** LEFT JOIN; SELECT e.first_name, e.last_name, COALESCE(d.department_name, 'No Dept');

6. **M6.** Show all departments and total salary in each (include departments with 0 salary).  
   **Hint:** FROM hr.departments d LEFT JOIN hr.employees e ON d.department_id = e.department_id GROUP BY d.department_id, d.department_name; SUM(e.salary);

7. **M7.** For each employee show name and manager name; use LEFT JOIN so employees without manager appear.  
   **Hint:** e LEFT JOIN employees m ON e.manager_id = m.employee_id;

8. **M8.** List departments (department_name) that have no employees (RIGHT JOIN from employees to departments then WHERE e.employee_id IS NULL, or NOT EXISTS).  
   **Hint:** FROM hr.departments d LEFT JOIN hr.employees e ON d.department_id = e.department_id WHERE e.employee_id IS NULL;

9. **M9.** Show employee_id, first_name, department_id, department_name; include employees with null department_id.  
   **Hint:** LEFT JOIN so all employees appear;

10. **M10.** List all departments and the number of employees; show 0 for departments with no employees.  
    **Hint:** d LEFT JOIN e, GROUP BY d, COUNT(e.employee_id);

11. **M11.** Show employee name and manager name; alias manager columns as mgr_first_name, mgr_last_name.  
    **Hint:** Self-join with aliases e and m; select m.first_name AS mgr_first_name, m.last_name AS mgr_last_name;

12. **M12.** List employees (first_name, last_name) and department_name; include employees whose department_id is not in hr.departments (LEFT JOIN, they get NULL).  
    **Hint:** LEFT JOIN; no filter on d;

13. **M13.** Show department_id, department_name, and employee count; include departments with 0 employees.  
    **Hint:** FROM departments d LEFT JOIN employees e ... GROUP BY d.department_id, d.department_name;

14. **M14.** For each employee show employee_id, salary, department_name; use NVL(d.department_name, 'Unassigned').  
    **Hint:** LEFT JOIN; NVL(d.department_name, 'Unassigned');

15. **M15.** List employees with their manager's employee_id and manager's last_name (self-join).  
    **Hint:** e LEFT JOIN m ON e.manager_id = m.employee_id; select e.*, m.employee_id AS mgr_emp_id, m.last_name AS mgr_last_name;

16. **M16.** Show all departments (department_name) and min salary in that department (NULL for no employees).  
    **Hint:** d LEFT JOIN e, GROUP BY d, MIN(e.salary);

17. **M17.** List employees who have a manager (manager_id IS NOT NULL) and show manager's first_name.  
    **Hint:** INNER JOIN employees m ON e.manager_id = m.employee_id (or LEFT and filter e.manager_id IS NOT NULL);

18. **M18.** Show employee_id, first_name, department_name; include employees with no department (LEFT JOIN).  
    **Hint:** e LEFT JOIN d ON e.department_id = d.department_id;

19. **M19.** List departments (department_id, department_name) and average salary; include departments with no employees (avg NULL or 0).  
    **Hint:** d LEFT JOIN e, GROUP BY d.department_id, d.department_name, AVG(e.salary);

20. **M20.** For each employee show name and department_name; if no department show 'N/A'.  
    **Hint:** LEFT JOIN; COALESCE(d.department_name, 'N/A').

### 20 Hard Questions

1. **H1.** Show two-level hierarchy: employee name, manager name, and manager's manager name (self-join e to m, m to m2 on m.manager_id = m2.employee_id).  
   **Hint:** e LEFT JOIN m ON e.manager_id = m.employee_id LEFT JOIN employees m2 ON m.manager_id = m2.employee_id;

2. **H2.** List departments that have no employees using NOT EXISTS.  
   **Hint:** SELECT * FROM hr.departments d WHERE NOT EXISTS (SELECT 1 FROM hr.employees e WHERE e.department_id = d.department_id);

3. **H3.** Show all employees and all departments in one result (FULL OUTER JOIN): employee_id, first_name, department_id, department_name.  
   **Hint:** FULL OUTER JOIN on e.department_id = d.department_id;

4. **H4.** For each employee show name, department_name, and manager's department_name (join e to d, e to m, m to dm).  
   **Hint:** e JOIN d ON e.department_id = d.department_id LEFT JOIN employees m ON e.manager_id = m.employee_id LEFT JOIN departments dm ON m.department_id = dm.department_id;

5. **H5.** List employees (name, salary, department_name) who earn more than their manager (self-join, compare e.salary > m.salary).  
   **Hint:** e JOIN employees m ON e.manager_id = m.employee_id WHERE e.salary > m.salary;

6. **H6.** Show all departments and count of employees; also show count of employees with commission_pct not null per department (use conditional COUNT).  
   **Hint:** d LEFT JOIN e, GROUP BY d; COUNT(e.employee_id), COUNT(e.commission_pct) or SUM(CASE WHEN e.commission_pct IS NOT NULL THEN 1 ELSE 0 END);

7. **H7.** List employees who have the same manager as employee_id 104 (self-join or subquery: manager_id = (SELECT manager_id FROM hr.employees WHERE employee_id = 104)).  
   **Hint:** WHERE manager_id = (SELECT manager_id FROM hr.employees WHERE employee_id = 104) AND employee_id <> 104;

8. **H8.** Show employee name, department_name, and manager name; include employees with no department and no manager.  
   **Hint:** e LEFT JOIN d ON e.department_id = d.department_id LEFT JOIN employees m ON e.manager_id = m.employee_id;

9. **H9.** List departments (department_name) where the department's manager (d.manager_id) is not in hr.employees or has no row (LEFT JOIN employees to d.manager_id).  
   **Hint:** d LEFT JOIN employees mgr ON d.manager_id = mgr.employee_id WHERE mgr.employee_id IS NULL;

10. **H10.** Show employee_id, first_name, last_name, department_name, and manager's last_name; use LEFT JOINs so employees without department or manager appear.  
    **Hint:** e LEFT JOIN d ON e.department_id = d.department_id LEFT JOIN employees m ON e.manager_id = m.employee_id;

11. **H11.** List employees (name, salary) whose salary is greater than their manager's salary (self-join e, m).  
    **Hint:** e JOIN employees m ON e.manager_id = m.employee_id WHERE e.salary > m.salary;

12. **H12.** Show all departments and total salary; include departments with 0 employees (total 0 or NULL).  
    **Hint:** d LEFT JOIN e, GROUP BY d, SUM(e.salary);

13. **H13.** For each employee show name, department_name, and number of employees in that department (join to aggregated subquery or use COUNT(*) OVER (PARTITION BY e.department_id)).  
    **Hint:** e LEFT JOIN d; add COUNT(*) OVER (PARTITION BY e.department_id) AS dept_count;

14. **H14.** List employees who are managers (employee_id in (SELECT manager_id FROM hr.employees)) and show how many people they manage.  
    **Hint:** employees m WHERE m.employee_id IN (SELECT manager_id FROM hr.employees) JOIN (SELECT manager_id, COUNT(*) cnt FROM hr.employees GROUP BY manager_id) c ON m.employee_id = c.manager_id;

15. **H15.** Show employee name, department_name, manager name; include employees with no department (department_name NULL) and no manager (manager name NULL).  
    **Hint:** e LEFT JOIN d LEFT JOIN employees m ON e.manager_id = m.employee_id;

16. **H16.** List departments (department_name) that have at least one employee with salary > 10000 (JOIN and EXISTS or IN).  
    **Hint:** SELECT DISTINCT d.department_name FROM hr.departments d JOIN hr.employees e ON d.department_id = e.department_id WHERE e.salary > 10000;

17. **H17.** Show employee_id, first_name, last_name, department_name, and manager's first_name; use COALESCE for manager first_name to 'No Manager'.  
    **Hint:** e LEFT JOIN d LEFT JOIN m; COALESCE(m.first_name, 'No Manager');

18. **H18.** List all employees (employee_id, first_name) and all departments (department_id, department_name) in one result with FULL OUTER JOIN; show which side each row came from (e.g. CASE WHEN e.employee_id IS NOT NULL THEN 'Emp' ELSE 'Dept' END).  
    **Hint:** FULL OUTER JOIN; add a column that indicates source;

19. **H19.** For each department show department_name and the name of the employee with the highest salary in that department (join to (SELECT department_id, employee_id, ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY salary DESC) rn FROM hr.employees) WHERE rn = 1).  
    **Hint:** Subquery with ROW_NUMBER; join to departments and employees for names;

20. **H20.** List employees (name, department_name) who were hired before their manager (compare e.hire_date < m.hire_date with self-join).  
    **Hint:** e JOIN employees m ON e.manager_id = m.employee_id WHERE e.hire_date < m.hire_date;

---

[← Back to Learning Plan](../30-day-sql-plsql-learning-plan.md) | [Tutorial](../tutorials/day08_join_types.md)
