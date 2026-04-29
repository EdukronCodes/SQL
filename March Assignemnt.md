# Oracle SQL Joins: Notes + 20 Examples + 20 Practice Questions

## 1) Quick Notes on Oracle SQL Joins

- A **JOIN** combines rows from two tables using a related column.
- In Oracle, both ANSI join syntax and old Oracle syntax exist, but ANSI syntax is preferred.
- Main join types:
  - `INNER JOIN`: only matching rows from both tables
  - `LEFT OUTER JOIN`: all rows from left table + matched rows from right table
  - `RIGHT OUTER JOIN`: all rows from right table + matched rows from left table
  - `FULL OUTER JOIN`: all rows from both tables, matched where possible
  - `CROSS JOIN`: cartesian product (every row with every row)
  - `SELF JOIN`: table joined to itself (not used here because we use 2 tables)
- `NULL` handling matters:
  - `NULL = NULL` is not true in SQL join conditions.
  - Use `NVL`, `COALESCE`, or explicit logic when needed.

---

## 2) Dummy Data Setup (2 Tables)

These tables are designed to include:
- **one-to-many mapping**: one department has many employees
- **NULL values**: some employees have no department / no manager / no salary
- **unmatched records** on both sides

```sql
-- Table 1: Departments (parent)
CREATE TABLE departments (
    dept_id      NUMBER PRIMARY KEY,
    dept_name    VARCHAR2(50) NOT NULL,
    location     VARCHAR2(50)
);

-- Table 2: Employees (child)
CREATE TABLE employees (
    emp_id        NUMBER PRIMARY KEY,
    emp_name      VARCHAR2(50) NOT NULL,
    dept_id       NUMBER,
    manager_id    NUMBER,
    salary        NUMBER(10,2),
    hire_date     DATE,
    CONSTRAINT fk_emp_dept
        FOREIGN KEY (dept_id)
        REFERENCES departments(dept_id)
);

-- Departments (note: dept_id 50 has no employees)
INSERT INTO departments VALUES (10, 'Sales',      'Mumbai');
INSERT INTO departments VALUES (20, 'Engineering','Bengaluru');
INSERT INTO departments VALUES (30, 'HR',         'Delhi');
INSERT INTO departments VALUES (40, 'Finance',    'Pune');
INSERT INTO departments VALUES (50, 'Legal',      'Chennai');

-- Employees
-- One-to-many mapping example:
-- dept 20 has multiple employees
INSERT INTO employees VALUES (101, 'Asha',   10, 900, 60000, DATE '2022-01-10');
INSERT INTO employees VALUES (102, 'Bharat', 20, 901, 80000, DATE '2021-03-15');
INSERT INTO employees VALUES (103, 'Charu',  20, 901, 75000, DATE '2023-07-01');
INSERT INTO employees VALUES (104, 'Deep',   20, NULL, NULL, DATE '2024-02-20');
INSERT INTO employees VALUES (105, 'Esha',   30, 902, 50000, DATE '2020-11-05');
INSERT INTO employees VALUES (106, 'Farhan', NULL, 903, 45000, DATE '2024-01-12'); -- NULL dept
INSERT INTO employees VALUES (107, 'Gauri',  40, 904, 90000, DATE '2019-08-25');
INSERT INTO employees VALUES (108, 'Hari',   NULL, NULL, NULL, DATE '2025-01-01'); -- NULL dept + NULL salary

COMMIT;
```

---

## 3) 20 Join Examples (Oracle SQL)

### Example 1: Basic INNER JOIN
```sql
SELECT e.emp_id, e.emp_name, d.dept_name
FROM employees e
INNER JOIN departments d
    ON e.dept_id = d.dept_id;
```

### Example 2: LEFT OUTER JOIN (all employees)
```sql
SELECT e.emp_id, e.emp_name, d.dept_name
FROM employees e
LEFT JOIN departments d
    ON e.dept_id = d.dept_id
ORDER BY e.emp_id;
```

### Example 3: RIGHT OUTER JOIN (all departments)
```sql
SELECT d.dept_id, d.dept_name, e.emp_name
FROM employees e
RIGHT JOIN departments d
    ON e.dept_id = d.dept_id
ORDER BY d.dept_id, e.emp_name;
```

### Example 4: FULL OUTER JOIN
```sql
SELECT e.emp_name, d.dept_name
FROM employees e
FULL OUTER JOIN departments d
    ON e.dept_id = d.dept_id
ORDER BY d.dept_name, e.emp_name;
```

### Example 5: Employees with no matching department
```sql
SELECT e.emp_id, e.emp_name, e.dept_id
FROM employees e
LEFT JOIN departments d
    ON e.dept_id = d.dept_id
WHERE d.dept_id IS NULL;
```

### Example 6: Departments with no employees
```sql
SELECT d.dept_id, d.dept_name
FROM departments d
LEFT JOIN employees e
    ON d.dept_id = e.dept_id
WHERE e.emp_id IS NULL;
```

### Example 7: INNER JOIN with filter on location
```sql
SELECT e.emp_name, d.dept_name, d.location
FROM employees e
JOIN departments d
    ON e.dept_id = d.dept_id
WHERE d.location = 'Bengaluru';
```

### Example 8: Count employees per department (including empty departments)
```sql
SELECT d.dept_id,
       d.dept_name,
       COUNT(e.emp_id) AS employee_count
FROM departments d
LEFT JOIN employees e
    ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name
ORDER BY d.dept_id;
```

### Example 9: Average salary per department
```sql
SELECT d.dept_name,
       ROUND(AVG(e.salary), 2) AS avg_salary
FROM departments d
LEFT JOIN employees e
    ON d.dept_id = e.dept_id
GROUP BY d.dept_name
ORDER BY d.dept_name;
```

### Example 10: Show 'No Department' for NULL joins
```sql
SELECT e.emp_name,
       NVL(d.dept_name, 'No Department') AS dept_label
FROM employees e
LEFT JOIN departments d
    ON e.dept_id = d.dept_id
ORDER BY e.emp_id;
```

### Example 11: Employees hired after 2023 with department names
```sql
SELECT e.emp_name, e.hire_date, d.dept_name
FROM employees e
LEFT JOIN departments d
    ON e.dept_id = d.dept_id
WHERE e.hire_date >= DATE '2023-01-01'
ORDER BY e.hire_date;
```

### Example 12: Departments having at least 2 employees
```sql
SELECT d.dept_name, COUNT(*) AS emp_count
FROM departments d
JOIN employees e
    ON d.dept_id = e.dept_id
GROUP BY d.dept_name
HAVING COUNT(*) >= 2;
```

### Example 13: Employee count + total salary by department
```sql
SELECT d.dept_name,
       COUNT(e.emp_id) AS emp_count,
       SUM(e.salary) AS total_salary
FROM departments d
LEFT JOIN employees e
    ON d.dept_id = e.dept_id
GROUP BY d.dept_name
ORDER BY d.dept_name;
```

### Example 14: Use COALESCE for salary display
```sql
SELECT e.emp_name,
       COALESCE(TO_CHAR(e.salary), 'Salary Missing') AS salary_text,
       d.dept_name
FROM employees e
LEFT JOIN departments d
    ON e.dept_id = d.dept_id;
```

### Example 15: Find employees in departments located in Mumbai or Delhi
```sql
SELECT e.emp_name, d.dept_name, d.location
FROM employees e
JOIN departments d
    ON e.dept_id = d.dept_id
WHERE d.location IN ('Mumbai', 'Delhi');
```

### Example 16: Sort by department then highest salary
```sql
SELECT d.dept_name, e.emp_name, e.salary
FROM departments d
LEFT JOIN employees e
    ON d.dept_id = e.dept_id
ORDER BY d.dept_name, e.salary DESC NULLS LAST;
```

### Example 17: Anti-join style using NOT EXISTS (departments without employees)
```sql
SELECT d.dept_id, d.dept_name
FROM departments d
WHERE NOT EXISTS (
    SELECT 1
    FROM employees e
    WHERE e.dept_id = d.dept_id
);
```

### Example 18: Join with computed bucket (high/medium/low salary)
```sql
SELECT e.emp_name,
       d.dept_name,
       CASE
           WHEN e.salary >= 80000 THEN 'High'
           WHEN e.salary >= 50000 THEN 'Medium'
           WHEN e.salary IS NULL THEN 'Unknown'
           ELSE 'Low'
       END AS salary_band
FROM employees e
LEFT JOIN departments d
    ON e.dept_id = d.dept_id;
```

### Example 19: Count NULL department employees via join result
```sql
SELECT COUNT(*) AS no_dept_employees
FROM employees e
LEFT JOIN departments d
    ON e.dept_id = d.dept_id
WHERE d.dept_id IS NULL;
```

### Example 20: CROSS JOIN (all combinations)
```sql
SELECT d.dept_name, e.emp_name
FROM departments d
CROSS JOIN employees e;
```

---

## 4) 20 Practice Questions (Join-Focused)

1. Write a query to list employee name and department name for only matched rows.
2. Write a query to show all employees even if department is missing.
3. Write a query to show all departments even if no employee exists.
4. Write a query to show all rows from both sides (matched + unmatched).
5. Find employees whose `dept_id` does not exist in `departments`.
6. Find departments that currently have zero employees.
7. Count number of employees in each department (include empty departments).
8. Show average salary by department.
9. Show highest salary by department (ignore NULL salaries).
10. List employees hired in or after 2024 with their department names.
11. Show each employee with department label as `No Department` when unmatched.
12. Find departments with more than one employee.
13. Show total salary by location using department-to-employee join.
14. List employees from departments located in `Bengaluru`.
15. Return top paid employee from each department.
16. Show departments where all employee salaries are NULL.
17. Write a query using `NOT EXISTS` to find unassigned departments.
18. Show count of employees with NULL `dept_id`.
19. Produce a cartesian product of departments and employees.
20. Compare results of `INNER JOIN` vs `LEFT JOIN` and explain missing rows.

---

## 5) Why NULL + One-to-Many Are Important

- **One-to-many** is the most common real-world relationship (one department, many employees).
- **NULL foreign keys** are common in staging/incomplete data.
- Joins behave differently with `NULL`, so practicing with these cases helps avoid production bugs.

---

## 6) 30 Subquery-Based Examples (`ROWNUM`, `ROW_NUMBER`, `RANK`, `DENSE_RANK`, `LEAD`, `LAG`)

### A) `ROWNUM` (Top-N style with subqueries)

### 1. First 3 employees by `emp_id`
```sql
SELECT *
FROM (
    SELECT e.*
    FROM employees e
    ORDER BY e.emp_id
)
WHERE ROWNUM <= 3;
```

### 2. Top 2 highest salaries
```sql
SELECT *
FROM (
    SELECT e.emp_id, e.emp_name, e.salary
    FROM employees e
    WHERE e.salary IS NOT NULL
    ORDER BY e.salary DESC
)
WHERE ROWNUM <= 2;
```

### 3. Lowest 4 salaries
```sql
SELECT *
FROM (
    SELECT e.emp_name, e.salary
    FROM employees e
    WHERE e.salary IS NOT NULL
    ORDER BY e.salary
)
WHERE ROWNUM <= 4;
```

### 4. Top 3 recent hires
```sql
SELECT *
FROM (
    SELECT e.emp_name, e.hire_date
    FROM employees e
    ORDER BY e.hire_date DESC
)
WHERE ROWNUM <= 3;
```

### 5. First 2 departments alphabetically
```sql
SELECT *
FROM (
    SELECT d.dept_id, d.dept_name
    FROM departments d
    ORDER BY d.dept_name
)
WHERE ROWNUM <= 2;
```

---

### B) `ROW_NUMBER()` with subqueries

### 6. Row number by salary descending (global)
```sql
SELECT *
FROM (
    SELECT e.emp_name,
           e.salary,
           ROW_NUMBER() OVER (ORDER BY e.salary DESC NULLS LAST) AS rn
    FROM employees e
)
ORDER BY rn;
```

### 7. Row number per department by salary
```sql
SELECT *
FROM (
    SELECT d.dept_name,
           e.emp_name,
           e.salary,
           ROW_NUMBER() OVER (
               PARTITION BY e.dept_id
               ORDER BY e.salary DESC NULLS LAST
           ) AS rn
    FROM employees e
    LEFT JOIN departments d
        ON e.dept_id = d.dept_id
)
ORDER BY dept_name, rn;
```

### 8. Top paid employee per department (`rn = 1`)
```sql
SELECT *
FROM (
    SELECT d.dept_name,
           e.emp_name,
           e.salary,
           ROW_NUMBER() OVER (
               PARTITION BY e.dept_id
               ORDER BY e.salary DESC NULLS LAST
           ) AS rn
    FROM employees e
    LEFT JOIN departments d
        ON e.dept_id = d.dept_id
)
WHERE rn = 1;
```

### 9. Second highest salary overall (`rn = 2`)
```sql
SELECT *
FROM (
    SELECT e.emp_name,
           e.salary,
           ROW_NUMBER() OVER (ORDER BY e.salary DESC NULLS LAST) AS rn
    FROM employees e
)
WHERE rn = 2;
```

### 10. Employees 3 to 5 by hire date (pagination style)
```sql
SELECT *
FROM (
    SELECT e.emp_name,
           e.hire_date,
           ROW_NUMBER() OVER (ORDER BY e.hire_date) AS rn
    FROM employees e
)
WHERE rn BETWEEN 3 AND 5;
```

---

### C) `RANK()` with subqueries

### 11. Salary rank overall (ties produce gaps)
```sql
SELECT *
FROM (
    SELECT e.emp_name,
           e.salary,
           RANK() OVER (ORDER BY e.salary DESC NULLS LAST) AS sal_rank
    FROM employees e
)
ORDER BY sal_rank;
```

### 12. Salary rank within each department
```sql
SELECT *
FROM (
    SELECT d.dept_name,
           e.emp_name,
           e.salary,
           RANK() OVER (
               PARTITION BY e.dept_id
               ORDER BY e.salary DESC NULLS LAST
           ) AS dept_rank
    FROM employees e
    LEFT JOIN departments d
        ON e.dept_id = d.dept_id
)
ORDER BY dept_name, dept_rank;
```

### 13. Top-ranked earners overall (`rank = 1`)
```sql
SELECT *
FROM (
    SELECT e.emp_name,
           e.salary,
           RANK() OVER (ORDER BY e.salary DESC NULLS LAST) AS sal_rank
    FROM employees e
)
WHERE sal_rank = 1;
```

### 14. Top 2 ranks per department
```sql
SELECT *
FROM (
    SELECT d.dept_name,
           e.emp_name,
           e.salary,
           RANK() OVER (
               PARTITION BY e.dept_id
               ORDER BY e.salary DESC NULLS LAST
           ) AS dept_rank
    FROM employees e
    LEFT JOIN departments d
        ON e.dept_id = d.dept_id
)
WHERE dept_rank <= 2
ORDER BY dept_name, dept_rank;
```

### 15. Rank by earliest hire date
```sql
SELECT *
FROM (
    SELECT e.emp_name,
           e.hire_date,
           RANK() OVER (ORDER BY e.hire_date) AS hire_rank
    FROM employees e
)
ORDER BY hire_rank;
```

---

### D) `DENSE_RANK()` with subqueries

### 16. Dense salary rank overall (no gaps)
```sql
SELECT *
FROM (
    SELECT e.emp_name,
           e.salary,
           DENSE_RANK() OVER (ORDER BY e.salary DESC NULLS LAST) AS dense_sal_rank
    FROM employees e
)
ORDER BY dense_sal_rank;
```

### 17. Dense rank per department by salary
```sql
SELECT *
FROM (
    SELECT d.dept_name,
           e.emp_name,
           e.salary,
           DENSE_RANK() OVER (
               PARTITION BY e.dept_id
               ORDER BY e.salary DESC NULLS LAST
           ) AS dense_dept_rank
    FROM employees e
    LEFT JOIN departments d
        ON e.dept_id = d.dept_id
)
ORDER BY dept_name, dense_dept_rank;
```

### 18. Get second dense salary band overall
```sql
SELECT *
FROM (
    SELECT e.emp_name,
           e.salary,
           DENSE_RANK() OVER (ORDER BY e.salary DESC NULLS LAST) AS dense_sal_rank
    FROM employees e
)
WHERE dense_sal_rank = 2;
```

### 19. Top 2 dense salary bands per department
```sql
SELECT *
FROM (
    SELECT d.dept_name,
           e.emp_name,
           e.salary,
           DENSE_RANK() OVER (
               PARTITION BY e.dept_id
               ORDER BY e.salary DESC NULLS LAST
           ) AS dense_dept_rank
    FROM employees e
    LEFT JOIN departments d
        ON e.dept_id = d.dept_id
)
WHERE dense_dept_rank <= 2
ORDER BY dept_name, dense_dept_rank;
```

### 20. Dense rank by latest hire date
```sql
SELECT *
FROM (
    SELECT e.emp_name,
           e.hire_date,
           DENSE_RANK() OVER (ORDER BY e.hire_date DESC) AS dense_hire_rank
    FROM employees e
)
ORDER BY dense_hire_rank;
```

---

### E) `LEAD()` with subqueries

### 21. Next employee salary in global salary order
```sql
SELECT *
FROM (
    SELECT e.emp_name,
           e.salary,
           LEAD(e.salary) OVER (ORDER BY e.salary DESC NULLS LAST) AS next_salary
    FROM employees e
)
ORDER BY salary DESC NULLS LAST;
```

### 22. Next hire date per department
```sql
SELECT *
FROM (
    SELECT d.dept_name,
           e.emp_name,
           e.hire_date,
           LEAD(e.hire_date) OVER (
               PARTITION BY e.dept_id
               ORDER BY e.hire_date
           ) AS next_hire_date
    FROM employees e
    LEFT JOIN departments d
        ON e.dept_id = d.dept_id
)
ORDER BY dept_name, hire_date;
```

### 23. Gap to next salary (descending)
```sql
SELECT *
FROM (
    SELECT e.emp_name,
           e.salary,
           LEAD(e.salary) OVER (ORDER BY e.salary DESC NULLS LAST) AS next_salary,
           e.salary - LEAD(e.salary) OVER (ORDER BY e.salary DESC NULLS LAST) AS salary_gap
    FROM employees e
    WHERE e.salary IS NOT NULL
)
ORDER BY salary DESC;
```

### 24. Next employee name by `emp_id`
```sql
SELECT *
FROM (
    SELECT e.emp_id,
           e.emp_name,
           LEAD(e.emp_name) OVER (ORDER BY e.emp_id) AS next_emp_name
    FROM employees e
)
ORDER BY emp_id;
```

### 25. Show only rows where next salary is NULL (last in order)
```sql
SELECT *
FROM (
    SELECT e.emp_name,
           e.salary,
           LEAD(e.salary) OVER (ORDER BY e.salary DESC NULLS LAST) AS next_salary
    FROM employees e
    WHERE e.salary IS NOT NULL
)
WHERE next_salary IS NULL;
```

---

### F) `LAG()` with subqueries

### 26. Previous employee salary in global salary order
```sql
SELECT *
FROM (
    SELECT e.emp_name,
           e.salary,
           LAG(e.salary) OVER (ORDER BY e.salary DESC NULLS LAST) AS prev_salary
    FROM employees e
)
ORDER BY salary DESC NULLS LAST;
```

### 27. Previous hire date per department
```sql
SELECT *
FROM (
    SELECT d.dept_name,
           e.emp_name,
           e.hire_date,
           LAG(e.hire_date) OVER (
               PARTITION BY e.dept_id
               ORDER BY e.hire_date
           ) AS prev_hire_date
    FROM employees e
    LEFT JOIN departments d
        ON e.dept_id = d.dept_id
)
ORDER BY dept_name, hire_date;
```

### 28. Salary difference from previous salary
```sql
SELECT *
FROM (
    SELECT e.emp_name,
           e.salary,
           LAG(e.salary) OVER (ORDER BY e.salary DESC NULLS LAST) AS prev_salary,
           e.salary - LAG(e.salary) OVER (ORDER BY e.salary DESC NULLS LAST) AS diff_prev
    FROM employees e
    WHERE e.salary IS NOT NULL
)
ORDER BY salary DESC;
```

### 29. Previous employee name by `emp_id`
```sql
SELECT *
FROM (
    SELECT e.emp_id,
           e.emp_name,
           LAG(e.emp_name) OVER (ORDER BY e.emp_id) AS prev_emp_name
    FROM employees e
)
ORDER BY emp_id;
```

### 30. Show rows where previous salary is NULL (first in order)
```sql
SELECT *
FROM (
    SELECT e.emp_name,
           e.salary,
           LAG(e.salary) OVER (ORDER BY e.salary DESC NULLS LAST) AS prev_salary
    FROM employees e
    WHERE e.salary IS NOT NULL
)
WHERE prev_salary IS NULL;
```
