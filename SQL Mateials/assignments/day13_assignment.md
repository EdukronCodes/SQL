# Day 13 Assignment: Set Operations

All exercises use **hr.employees** and **hr.departments** only.

---

## Part 1: Practice Questions (With Answers and Explanations)

### Question 1
List **job_id** values that appear in employees in department 50 **UNION** job_id values that appear in employees in department 60. (Each SELECT returns one column job_id.)

**Answer:**

```sql
SELECT job_id FROM hr.employees WHERE department_id = 50
UNION
SELECT job_id FROM hr.employees WHERE department_id = 60;
```

**Explanation:** Both queries return one column (job_id). UNION combines the result sets and removes duplicates. Use UNION ALL if you want to keep duplicates.

---

### Question 2
List **department_id** values that appear in **both** hr.employees and hr.departments (departments that have at least one employee and are in the departments table). Use INTERSECT.

**Answer:**

```sql
SELECT department_id FROM hr.employees
INTERSECT
SELECT department_id FROM hr.departments;
```

**Explanation:** INTERSECT returns only rows that appear in both result sets. So we get department_ids that exist in employees and in departments. NULLs are not matched in INTERSECT.

---

### Question 3
List **department_id** values that are in hr.departments but have **no** employees in hr.employees. Use MINUS.

**Answer:**

```sql
SELECT department_id FROM hr.departments
MINUS
SELECT department_id FROM hr.employees;
```

**Explanation:** MINUS returns rows from the first query that are not in the second. So we get departments that exist in the departments table but do not appear as any employee's department_id (including departments with zero employees).

---

## Part 2: Self-Practice (No Answers)

1. Use **UNION** to combine two queries: employees with salary in range 3000–6000 and employees with salary in range 5000–8000. Show employee_id and salary. Observe how UNION removes duplicates.
2. Use **INTERSECT** to find **manager_id** values that appear in both hr.employees (as manager_id) and in hr.employees (as employee_id)—i.e. managers who are themselves employees.

---

## Part 3: Additional Practice — 20 Medium + 20 Hard Questions (With Hints)

All use **hr.employees** and **hr.departments** only.

### 20 Medium Questions

1. **M1.** UNION job_id from department 50 and job_id from department 60. **Hint:** Two SELECTs with same one column, UNION.
2. **M2.** UNION ALL employee_id, first_name from department 50 and from department 80. **Hint:** Same columns, UNION ALL.
3. **M3.** INTERSECT department_id from hr.employees and department_id from hr.departments. **Hint:** Returns dept_ids in both.
4. **M4.** MINUS: department_id from hr.departments MINUS department_id from hr.employees (depts with no employees). **Hint:** First query minus second.
5. **M5.** UNION ALL first_name, last_name from employees where salary > 10000 and first_name, last_name from employees where department_id = 90. **Hint:** Two columns, UNION ALL.
6. **M6.** INTERSECT job_id from employees where department_id = 50 and job_id from employees where department_id = 80. **Hint:** Jobs in both depts.
7. **M7.** MINUS: employee_id from employees MINUS employee_id from (select manager_id from employees where manager_id is not null). **Hint:** Employees who are not managers (if manager_id list is from employees).
8. **M8.** UNION department_id from employees and department_id from departments; ORDER BY 1. **Hint:** UNION then ORDER BY 1 at end.
9. **M9.** UNION ALL select 10, 'Dept10' from dual and select 20, 'Dept20' from dual (two columns). **Hint:** Literals; use dual; same number of columns.
10. **M10.** INTERSECT manager_id from employees (where not null) and employee_id from employees. **Hint:** People who are managers (appear as manager_id and as employee_id).
11. **M11.** MINUS: job_id from employees where department_id = 80 MINUS job_id from employees where department_id = 50. **Hint:** Jobs in 80 but not in 50.
12. **M12.** UNION salary (as one column) from employees where department_id = 50 and salary from employees where department_id = 60; show distinct salaries. **Hint:** One column, UNION.
13. **M13.** INTERSECT department_id from departments and department_id from employees (same as depts that have employees). **Hint:** INTERSECT two single-column queries.
14. **M14.** UNION ALL employee_id, salary from employees where salary < 5000 and employee_id, salary from employees where salary > 15000. **Hint:** Two columns, UNION ALL.
15. **M15.** MINUS: department_id from employees MINUS department_id from departments (employees' dept_ids not in departments table—usually empty). **Hint:** First minus second.
16. **M16.** UNION first_name from employees where job_id = 'SA_REP' and first_name from employees where job_id = 'SA_MAN'. **Hint:** One column, UNION.
17. **M17.** INTERSECT job_id from employees and job_id from (SELECT job_id FROM hr.employees WHERE department_id = 90). **Hint:** INTERSECT with subquery (all jobs vs jobs in 90).
18. **M18.** UNION ALL select department_id, department_name from departments where department_id = 10 and select department_id, department_name from departments where department_id = 20. **Hint:** Two columns from same table, different filter.
19. **M19.** MINUS: employee_id from employees where department_id = 50 MINUS employee_id from employees where salary > 7000. **Hint:** In dept 50 but not in high-salary set (interpret: IDs in first set not in second).
20. **M20.** UNION (no ALL) department_id from employees and department_id from departments. **Hint:** Distinct department_ids from both tables.

### 20 Hard Questions

1. **H1.** UNION of three queries: department_id from employees where salary < 3000, where salary between 3000 and 8000, and where salary > 8000 (one column). **Hint:** Three SELECTs, UNION.
2. **H2.** INTERSECT of manager_id from employees and employee_id from employees (managers who are employees). **Hint:** INTERSECT; use WHERE manager_id IS NOT NULL in first if needed.
3. **H3.** MINUS: departments.department_id MINUS employees.department_id; then join result to departments to show department_name. **Hint:** Use subquery: SELECT d.department_id, d.department_name FROM hr.departments d WHERE d.department_id IN (SELECT department_id FROM hr.departments MINUS SELECT department_id FROM hr.employees).
4. **H4.** UNION ALL of (employee_id, first_name, last_name, 'A' as flag) from employees where salary > 10000 and same columns with 'B' from employees where salary <= 10000. **Hint:** Add literal flag column to each SELECT; same 4 columns.
5. **H5.** INTERSECT job_id from employees where department_id IN (10,20) and job_id from employees where department_id IN (50,60). **Hint:** Jobs that appear in both sets of departments.
6. **H6.** MINUS: (SELECT employee_id FROM hr.employees) MINUS (SELECT manager_id FROM hr.employees WHERE manager_id IS NOT NULL). **Hint:** Employees who are not anyone's manager.
7. **H7.** UNION of department_id, COUNT(*) from employees group by department_id and department_id, 0 from departments (show all depts with count or 0). **Hint:** Need same columns: dept_id and number; second from departments with literal 0; then union with first grouped query—but column types/count must match (grouped gives 2 cols; second query 2 cols).
8. **H8.** INTERSECT (department_id, job_id) from employees where salary > 5000 and (department_id, job_id) from employees where commission_pct is not null. **Hint:** Two columns in each SELECT; INTERSECT (dept,job) pairs.
9. **H9.** MINUS: (employee_id, manager_id) from employees where manager_id is not null MINUS (employee_id, manager_id) from employees where department_id = 50. **Hint:** Pairs in first set not in second (two columns).
10. **H10.** UNION ALL list of department_id from employees and department_id from departments; then use this in a query to count how many times each department_id appears. **Hint:** SELECT department_id, COUNT(*) FROM (SELECT department_id FROM hr.employees UNION ALL SELECT department_id FROM hr.departments) sub GROUP BY department_id.
11. **H11.** INTERSECT (first_name, last_name) from employees where department_id = 50 and (first_name, last_name) from employees where department_id = 80. **Hint:** Same name in both departments (two columns).
12. **H12.** MINUS: job_id from employees MINUS job_id from employees where hire_date >= DATE '2005-01-01'. **Hint:** Jobs that have no one hired in 2005 or later (jobs only in older hires).
13. **H13.** UNION (SELECT department_id, SUM(salary) FROM hr.employees GROUP BY department_id) and (SELECT NULL, SUM(salary) FROM hr.employees) for grand total. **Hint:** Two columns; second row is NULL, total; types must match (NUMBER, NUMBER).
14. **H14.** INTERSECT department_id from employees where job_id = 'SA_REP' and department_id from employees where job_id = 'SA_MAN'. **Hint:** Departments that have both SA_REP and SA_MAN.
15. **H15.** MINUS: (SELECT manager_id FROM hr.employees WHERE manager_id IS NOT NULL) MINUS (SELECT employee_id FROM hr.employees WHERE department_id = 90). **Hint:** Managers who are not in department 90.
16. **H16.** UNION of employee_id, first_name, last_name, department_id from employees where salary > (SELECT AVG(salary) FROM hr.employees) and same from employees where salary < (SELECT AVG(salary) FROM hr.employees). **Hint:** Two scalar subqueries; same 4 columns.
17. **H17.** INTERSECT (department_id, job_id) from employees and (department_id, job_id) from (SELECT department_id, job_id FROM hr.employees GROUP BY department_id, job_id). **Hint:** Same (dept, job) pairs (INTERSECT with self is same set).
18. **H18.** MINUS: employee_id from employees where department_id = 80 MINUS employee_id from employees where salary > 10000. **Hint:** In dept 80 but salary <= 10000 (IDs in first not in second).
19. **H19.** UNION ALL (SELECT 1, department_id, COUNT(*) FROM hr.employees GROUP BY department_id) and (SELECT 2, NULL, COUNT(*) FROM hr.employees). **Hint:** Add level column 1 for dept rows, 2 for total; NULL for department_id in total row.
20. **H20.** INTERSECT job_id from employees where department_id IN (SELECT department_id FROM hr.departments) and job_id from employees. **Hint:** INTERSECT with subquery (all jobs in valid depts vs all jobs—result is jobs in valid depts).

---

[← Back to Learning Plan](../30-day-sql-plsql-learning-plan.md) | [Tutorial](../tutorials/day13_set_operations.md)
