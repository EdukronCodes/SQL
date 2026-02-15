# Day 2 Assignment: Filtering & Sorting

All exercises use **hr.employees** and **hr.departments** only.

---

## Part 1: Practice Questions (With Answers and Explanations)

### Question 1  
List employees in `department_id` 50.

**Answer:**

```sql
SELECT employee_id, first_name, last_name, department_id
FROM hr.employees
WHERE department_id = 50;
```

**Explanation:** Filter with `WHERE department_id = 50`. Only rows that satisfy the condition are returned.

---

### Question 2  
List employees whose salary is between 5000 and 10000 (inclusive).

**Answer:**

```sql
SELECT employee_id, first_name, last_name, salary
FROM hr.employees
WHERE salary BETWEEN 5000 AND 10000;
```

**Explanation:** `BETWEEN 5000 AND 10000` is equivalent to `salary >= 5000 AND salary <= 10000`. Both bounds are inclusive.

---

### Question 3  
List employees whose last name starts with 'K'.

**Answer:**

```sql
SELECT employee_id, first_name, last_name
FROM hr.employees
WHERE last_name LIKE 'K%';
```

**Explanation:** `LIKE 'K%'` matches any last name that starts with 'K' followed by any characters. `%` is the wildcard for zero or more characters.

---

### Question 4  
List the top 5 highest-paid employees (employee_id, first_name, salary).

**Answer:**

```sql
SELECT employee_id, first_name, salary
FROM hr.employees
ORDER BY salary DESC
FETCH FIRST 5 ROWS ONLY;
```

**Explanation:** Sort by `salary DESC` so highest salary first, then limit to 5 rows. In older Oracle use a subquery with `ROWNUM <= 5` instead of `FETCH FIRST`.

---

## Part 2: Self-Practice (No Answers)

Using **hr.employees** only:

1. List employees who have **no** `commission_pct` (NULL).
2. List employees whose `job_id` **contains** the string `'MAN'`.
3. List all employees ordered by `hire_date` **descending** (newest first).

---

## Part 3: Additional Practice — 20 Medium + 20 Hard Questions (With Hints)

All use **hr.employees** and **hr.departments** only.

### 20 Medium Questions

1. **M1.** List employees in department_id 80 with salary greater than 8000.  
   **Hint:** WHERE department_id = 80 AND salary > 8000.

2. **M2.** Find employees whose last_name ends with 'n'.  
   **Hint:** WHERE last_name LIKE '%n'.

3. **M3.** List employees hired after January 1, 2005.  
   **Hint:** WHERE hire_date > DATE '2005-01-01' or hire_date >= DATE '2005-01-01'.

4. **M4.** Get employees whose job_id is either 'SA_REP' or 'SA_MAN'.  
   **Hint:** WHERE job_id IN ('SA_REP', 'SA_MAN').

5. **M5.** List employees with salary between 4000 and 7000 (inclusive).  
   **Hint:** WHERE salary BETWEEN 4000 AND 7000.

6. **M6.** Find employees who have a manager (manager_id is not null).  
   **Hint:** WHERE manager_id IS NOT NULL.

7. **M7.** List departments with department_id 10, 20, or 30 from hr.departments.  
   **Hint:** WHERE department_id IN (10, 20, 30).

8. **M8.** Get the top 3 employees by hire_date (oldest first).  
   **Hint:** ORDER BY hire_date ASC then FETCH FIRST 3 ROWS ONLY.

9. **M9.** List employees in department 50, ordered by last_name ascending.  
   **Hint:** WHERE department_id = 50 ORDER BY last_name.

10. **M10.** Find employees whose first_name starts with 'J'.  
    **Hint:** WHERE first_name LIKE 'J%'.

11. **M11.** List employees with salary not in the range 5000 to 10000.  
    **Hint:** WHERE salary NOT BETWEEN 5000 AND 10000, or salary < 5000 OR salary > 10000.

12. **M12.** Get employees whose job_id contains 'CLERK'.  
    **Hint:** WHERE job_id LIKE '%CLERK%'.

13. **M13.** List employees with commission_pct greater than 0.2.  
    **Hint:** WHERE commission_pct > 0.2 (and optionally commission_pct IS NOT NULL).

14. **M14.** Find the 10 most recently hired employees.  
    **Hint:** ORDER BY hire_date DESC FETCH FIRST 10 ROWS ONLY.

15. **M15.** List employees in departments 50 or 60, ordered by department_id then salary descending.  
    **Hint:** WHERE department_id IN (50, 60) ORDER BY department_id, salary DESC.

16. **M16.** Get employees whose last_name has exactly 5 characters.  
    **Hint:** WHERE last_name LIKE '_____' (5 underscores).

17. **M17.** List departments where manager_id is not null from hr.departments.  
    **Hint:** FROM hr.departments WHERE manager_id IS NOT NULL.

18. **M18.** Find employees with salary >= 10000, ordered by salary ascending.  
    **Hint:** WHERE salary >= 10000 ORDER BY salary.

19. **M19.** List employees whose email ends with '.com' or contains 'example' (if applicable; otherwise use a pattern that exists).  
    **Hint:** WHERE email LIKE '%.com' or email LIKE '%example%' depending on data.

20. **M20.** Get distinct job_id values from employees in department 50.  
    **Hint:** SELECT DISTINCT job_id FROM hr.employees WHERE department_id = 50.

### 20 Hard Questions

1. **H1.** List employees in department 80 with salary > 7000 OR job_id = 'SA_MAN', ordered by salary DESC.  
   **Hint:** WHERE (department_id = 80 AND salary > 7000) OR job_id = 'SA_MAN' ORDER BY salary DESC.

2. **H2.** Find employees hired between Jan 1, 2000 and Dec 31, 2005.  
   **Hint:** WHERE hire_date BETWEEN DATE '2000-01-01' AND DATE '2005-12-31'.

3. **H3.** List employees whose last_name is 4 characters and starts with 'K'.  
   **Hint:** WHERE last_name LIKE 'K___'.

4. **H4.** Get top 5 highest-paid employees in department 50 only.  
   **Hint:** WHERE department_id = 50 ORDER BY salary DESC FETCH FIRST 5 ROWS ONLY.

5. **H5.** List employees with no manager and salary > 5000.  
   **Hint:** WHERE manager_id IS NULL AND salary > 5000.

6. **H6.** Find employees whose first_name has an 'a' as the second character.  
   **Hint:** WHERE first_name LIKE '_a%'.

7. **H7.** List departments (hr.departments) with department_id between 40 and 90.  
   **Hint:** WHERE department_id BETWEEN 40 AND 90.

8. **H8.** Get employees with salary < 3000 or salary > 15000, ordered by salary.  
   **Hint:** WHERE salary < 3000 OR salary > 15000 ORDER BY salary.

9. **H9.** List employees in department 60 with job_id 'IT_PROG', or in department 100 with job_id like 'FI%'.  
   **Hint:** WHERE (department_id = 60 AND job_id = 'IT_PROG') OR (department_id = 100 AND job_id LIKE 'FI%').

10. **H10.** Find employees whose hire_date is in the year 2003.  
    **Hint:** WHERE EXTRACT(YEAR FROM hire_date) = 2003 or hire_date between DATE '2003-01-01' AND DATE '2003-12-31'.

11. **H11.** List employees with commission_pct NULL and job_id starting with 'SA'.  
    **Hint:** WHERE commission_pct IS NULL AND job_id LIKE 'SA%'.

12. **H12.** Get the 3 oldest employees (earliest hire_date) in department 90.  
    **Hint:** WHERE department_id = 90 ORDER BY hire_date ASC FETCH FIRST 3 ROWS ONLY.

13. **H13.** List employees whose last_name does not start with 'A', 'B', or 'C'.  
    **Hint:** WHERE last_name NOT LIKE 'A%' AND last_name NOT LIKE 'B%' AND last_name NOT LIKE 'C%'; or use NOT IN with SUBSTR.

14. **H14.** Find employees with salary in (5000, 6000, 7000, 8000).  
    **Hint:** WHERE salary IN (5000, 6000, 7000, 8000).

15. **H15.** List employees ordered by department_id ASC, then by hire_date DESC within each department.  
    **Hint:** ORDER BY department_id, hire_date DESC.

16. **H16.** Get employees whose first_name and last_name both start with the same letter (simplified: same first letter).  
    **Hint:** WHERE SUBSTR(first_name,1,1) = SUBSTR(last_name,1,1).

17. **H17.** List employees with manager_id not null and department_id in (50, 80, 100).  
    **Hint:** WHERE manager_id IS NOT NULL AND department_id IN (50, 80, 100).

18. **H18.** Find employees with salary between 3000 and 5000 and job_id containing 'REP'.  
    **Hint:** WHERE salary BETWEEN 3000 AND 5000 AND job_id LIKE '%REP%'.

19. **H19.** List departments (hr.departments) ordered by department_name descending.  
    **Hint:** SELECT * FROM hr.departments ORDER BY department_name DESC.

20. **H20.** Get employees with hire_date not in 2004 (all years except 2004).  
    **Hint:** WHERE EXTRACT(YEAR FROM hire_date) <> 2004 or hire_date < DATE '2004-01-01' OR hire_date > DATE '2004-12-31'.

---

[← Back to Learning Plan](../30-day-sql-plsql-learning-plan.md) | [Tutorial](../tutorials/day02_filtering_sorting.md)
