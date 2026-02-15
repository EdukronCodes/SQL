# Day 12 Assignment: Correlated Subqueries

All exercises use **hr.employees** and **hr.departments** only.

---

## Part 1: Practice Questions (With Answers and Explanations)

### Question 1
List employees whose **salary is above their department average**. Use a correlated subquery that computes AVG(salary) for the same department_id.

**Answer:**

```sql
SELECT e.employee_id, e.first_name, e.salary, e.department_id
FROM hr.employees e
WHERE e.salary > (
  SELECT AVG(salary) FROM hr.employees WHERE department_id = e.department_id
);
```

**Explanation:** For each row e, the subquery computes the average salary for e.department_id. The outer query keeps only employees whose salary is greater than that department average.

---

### Question 2
List **departments** that have **no employees**. Use NOT EXISTS with a correlated subquery.

**Answer:**

```sql
SELECT d.department_id, d.department_name
FROM hr.departments d
WHERE NOT EXISTS (SELECT 1 FROM hr.employees e WHERE e.department_id = d.department_id);
```

**Explanation:** For each department d, the subquery checks if any employee has that department_id. NOT EXISTS is true when no such employee exists, so only departments with zero employees are returned.

---

### Question 3
List employees whose salary is in the **top 3** within their department. Use a correlated subquery that counts how many employees in the same department have a higher salary; keep only rows where that count is less than 3.

**Answer:**

```sql
SELECT e.employee_id, e.first_name, e.salary, e.department_id
FROM hr.employees e
WHERE (
  SELECT COUNT(DISTINCT salary) FROM hr.employees e2
  WHERE e2.department_id = e.department_id AND e2.salary > e.salary
) < 3;
```

**Explanation:** For each employee e, we count how many distinct salaries in the same department are greater than e.salary. If that count is 0, 1, or 2, the employee is in the top 3 (allowing ties). Using COUNT(*) with e2.salary > e.salary gives "number of people with higher salary"; for strict top-3 we want that number < 3.

Alternative with DENSE_RANK (window function): rank by salary DESC per department and filter WHERE rnk <= 3.

---

## Part 2: Self-Practice (No Answers)

1. List employees who were **hired after their manager** (compare hire_date with manager's hire_date using a correlated subquery or self-join).
2. List **departments** where **every** employee has a non-NULL **commission_pct** (hint: no employee in the department has NULL commission_pct; use NOT EXISTS and a condition on commission_pct).

---

## Part 3: Additional Practice — 20 Medium + 20 Hard Questions (With Hints)

All use **hr.employees** and **hr.departments** only.

### 20 Medium Questions

1. **M1.** Employees whose salary > department average (correlated: AVG(salary) WHERE department_id = e.department_id). **Hint:** WHERE e.salary > (SELECT AVG(salary) FROM hr.employees WHERE department_id = e.department_id).
2. **M2.** Departments with at least one employee: EXISTS (SELECT 1 FROM hr.employees e WHERE e.department_id = d.department_id). **Hint:** EXISTS correlated.
3. **M3.** Departments with no employees: NOT EXISTS (SELECT 1 FROM hr.employees e WHERE e.department_id = d.department_id). **Hint:** NOT EXISTS correlated.
4. **M4.** Employees who earn more than their manager (correlated: salary > (SELECT salary FROM hr.employees m WHERE m.employee_id = e.manager_id)). **Hint:** Correlated scalar for manager salary.
5. **M5.** Departments where (SELECT COUNT(*) FROM hr.employees e WHERE e.department_id = d.department_id) = 0. **Hint:** Correlated count = 0; or use NOT EXISTS.
6. **M6.** Employees where hire_date > (SELECT hire_date FROM hr.employees m WHERE m.employee_id = e.manager_id). **Hint:** Hired after manager (correlated).
7. **M7.** Departments where (SELECT AVG(salary) FROM hr.employees e WHERE e.department_id = d.department_id) BETWEEN 5000 AND 10000. **Hint:** Correlated AVG in WHERE.
8. **M8.** Employees in department that has more than 5 people: (SELECT COUNT(*) FROM hr.employees e2 WHERE e2.department_id = e.department_id) > 5. **Hint:** Correlated count > 5.
9. **M9.** List departments d where EXISTS (SELECT 1 FROM hr.employees e WHERE e.department_id = d.department_id AND e.salary > 10000). **Hint:** EXISTS with extra condition.
10. **M10.** Employees where (SELECT MIN(salary) FROM hr.employees e2 WHERE e2.department_id = e.department_id) = e.salary (lowest in dept). **Hint:** Correlated MIN = e.salary.
11. **M11.** Departments where (SELECT MAX(salary) FROM hr.employees e WHERE e.department_id = d.department_id) < 15000. **Hint:** Correlated MAX < 15000.
12. **M12.** Employees whose manager_id is not in hr.employees (manager left): NOT EXISTS (SELECT 1 FROM hr.employees m WHERE m.employee_id = e.manager_id) AND e.manager_id IS NOT NULL. **Hint:** NOT EXISTS for manager; or manager_id NOT IN (SELECT employee_id FROM hr.employees).
13. **M13.** Employees where (SELECT job_id FROM hr.employees m WHERE m.employee_id = e.manager_id) = e.job_id (same job as manager). **Hint:** Correlated scalar job_id.
14. **M14.** Departments where (SELECT COUNT(*) FROM hr.employees e WHERE e.department_id = d.department_id AND e.commission_pct IS NOT NULL) > 0. **Hint:** Correlated count of commissioned > 0.
15. **M15.** Employees where salary >= (SELECT MAX(salary) FROM hr.employees e2 WHERE e2.department_id = e.department_id) * 0.8. **Hint:** Within 80% of dept max.
16. **M16.** List departments d where NOT EXISTS (SELECT 1 FROM hr.employees e WHERE e.department_id = d.department_id AND e.hire_date < DATE '2000-01-01'). **Hint:** No employee hired before 2000 in dept.
17. **M17.** Employees where (SELECT department_name FROM hr.departments d WHERE d.department_id = e.department_id) = 'Sales'. **Hint:** Correlated department_name = 'Sales'.
18. **M18.** Departments where (SELECT SUM(salary) FROM hr.employees e WHERE e.department_id = d.department_id) > 100000. **Hint:** Correlated SUM > 100000.
19. **M19.** Employees who are the only one in their department: (SELECT COUNT(*) FROM hr.employees e2 WHERE e2.department_id = e.department_id) = 1. **Hint:** Correlated count = 1.
20. **M20.** Departments d where EXISTS (SELECT 1 FROM hr.employees e WHERE e.department_id = d.department_id AND e.manager_id IS NULL). **Hint:** At least one employee in dept has no manager.

### 20 Hard Questions

1. **H1.** Employees hired after their manager: e.hire_date > (SELECT hire_date FROM hr.employees m WHERE m.employee_id = e.manager_id). **Hint:** Correlated hire_date comparison.
2. **H2.** Departments where every employee has commission_pct: NOT EXISTS (SELECT 1 FROM hr.employees e WHERE e.department_id = d.department_id AND e.commission_pct IS NULL). **Hint:** No employee in dept with NULL commission.
3. **H3.** Employees whose salary is second-highest in department (correlated: count how many have higher salary in dept = 1). **Hint:** (SELECT COUNT(DISTINCT e2.salary) FROM hr.employees e2 WHERE e2.department_id = e.department_id AND e2.salary > e.salary) = 1.
4. **H4.** Departments where (SELECT AVG(salary) FROM hr.employees e WHERE e.department_id = d.department_id) > (SELECT AVG(salary) FROM hr.employees). **Hint:** Dept avg > company avg.
5. **H5.** Employees who have the same salary as their manager: e.salary = (SELECT salary FROM hr.employees m WHERE m.employee_id = e.manager_id). **Hint:** Correlated salary = manager salary.
6. **H6.** List departments that have at least 2 employees with salary > 8000: (SELECT COUNT(*) FROM hr.employees e WHERE e.department_id = d.department_id AND e.salary > 8000) >= 2. **Hint:** Correlated count with condition.
7. **H7.** Employees whose department has the highest total salary (dept in (SELECT department_id FROM (SELECT department_id, SUM(salary) s FROM hr.employees GROUP BY department_id ORDER BY s DESC FETCH FIRST 1 ROW ONLY))). **Hint:** Subquery in FROM + FETCH; then e.department_id IN.
8. **H8.** Departments where (SELECT COUNT(DISTINCT job_id) FROM hr.employees e WHERE e.department_id = d.department_id) >= 3. **Hint:** At least 3 distinct jobs in dept.
9. **H9.** Employees where (SELECT COUNT(*) FROM hr.employees e2 WHERE e2.department_id = e.department_id AND e2.salary > e.salary) <= 2 (top 3 salary in dept). **Hint:** At most 2 people earn more in dept.
10. **H10.** Departments d where NOT EXISTS (SELECT 1 FROM hr.employees e WHERE e.department_id = d.department_id) (no employees). **Hint:** NOT EXISTS.
11. **H11.** Employees whose manager is in a different department: (SELECT department_id FROM hr.employees m WHERE m.employee_id = e.manager_id) <> e.department_id AND e.manager_id IS NOT NULL. **Hint:** Correlated manager department_id <> e.department_id.
12. **H12.** Departments where (SELECT MIN(salary) FROM hr.employees e WHERE e.department_id = d.department_id) > 4000. **Hint:** Correlated MIN > 4000.
13. **H13.** Employees where (SELECT COUNT(*) FROM hr.employees e2 WHERE e2.department_id = e.department_id AND e2.hire_date < e.hire_date) = 0 (earliest hire in dept). **Hint:** No one hired before them in dept.
14. **H14.** List departments that have exactly 5 employees: (SELECT COUNT(*) FROM hr.employees e WHERE e.department_id = d.department_id) = 5. **Hint:** Correlated count = 5.
15. **H15.** Employees where salary > (SELECT AVG(salary) FROM hr.employees e2 WHERE e2.job_id = e.job_id). **Hint:** Above job average (correlated by job_id).
16. **H16.** Departments where (SELECT MAX(hire_date) FROM hr.employees e WHERE e.department_id = d.department_id) >= DATE '2005-01-01'. **Hint:** At least one hire in dept from 2005 onward.
17. **H17.** Employees who are managers and have more than 2 direct reports: e.employee_id IN (SELECT manager_id FROM hr.employees WHERE manager_id IS NOT NULL GROUP BY manager_id HAVING COUNT(*) > 2). **Hint:** Subquery: manager_id with COUNT > 2.
18. **H18.** Departments d where (SELECT SUM(salary) FROM hr.employees e WHERE e.department_id = d.department_id) = (SELECT MAX(s) FROM (SELECT SUM(salary) s FROM hr.employees GROUP BY department_id)). **Hint:** Dept total = max of all dept totals.
19. **H19.** Employees where (SELECT department_name FROM hr.departments d WHERE d.department_id = e.department_id) IN ('Sales','IT'). **Hint:** Correlated department_name IN list.
20. **H20.** Departments where (SELECT COUNT(*) FROM hr.employees e WHERE e.department_id = d.department_id AND e.commission_pct IS NOT NULL) = (SELECT COUNT(*) FROM hr.employees e WHERE e.department_id = d.department_id) and count > 0. **Hint:** All employees in dept have commission (and at least one employee).

---

[← Back to Learning Plan](../30-day-sql-plsql-learning-plan.md) | [Tutorial](../tutorials/day12_correlated_subqueries.md)
