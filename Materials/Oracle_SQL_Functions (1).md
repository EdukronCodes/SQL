# Oracle SQL Analytic Functions – 30 Examples

## Table Used

```sql
HR.EMPLOYEES
```

## Functions Covered

1. `ROW_NUMBER()`
2. `RANK()`
3. `DENSE_RANK()`
4. `FIRST_VALUE()`
5. `LAST_VALUE()`

---

# PART 1 – ROW_NUMBER()

## Example 1 – Assign Row Number Based on Highest Salary

```sql
SELECT
    employee_id,
    first_name,
    salary,

    ROW_NUMBER() OVER (
        ORDER BY salary DESC
    ) AS row_num

FROM hr.employees;
```

### Explanation

`ROW_NUMBER()` assigns a unique sequential number.

Highest salary gets row number 1.

```text
Salary     Row Number
24000      1
17000      2
17000      3
14000      4
```

Even if salaries are equal, row numbers are different.

---

## Example 2 – Row Number Based on Lowest Salary

```sql
SELECT
    employee_id,
    first_name,
    salary,

    ROW_NUMBER() OVER (
        ORDER BY salary ASC
    ) AS row_num

FROM hr.employees;
```

### Explanation

`ASC` means lowest salary comes first.

Therefore the employee with the lowest salary gets row number 1.

---

## Example 3 – Department-Wise Row Number

```sql
SELECT
    employee_id,
    first_name,
    department_id,
    salary,

    ROW_NUMBER() OVER (
        PARTITION BY department_id
        ORDER BY salary DESC
    ) AS row_num

FROM hr.employees;
```

### Explanation

`PARTITION BY department_id` creates a separate ranking for every department.

```text
Department 10
1
2
3

Department 20
1
2
3

Department 30
1
2
3
```

The row number restarts for every department.

---

## Example 4 – Row Number Based on Hire Date

```sql
SELECT
    employee_id,
    first_name,
    hire_date,

    ROW_NUMBER() OVER (
        ORDER BY hire_date ASC
    ) AS joining_order

FROM hr.employees;
```

### Explanation

The employee with the earliest `hire_date` receives row number 1.

This can be used to identify employee joining order.

---

## Example 5 – Latest Employee in Each Department

```sql
SELECT *
FROM
(
    SELECT
        employee_id,
        first_name,
        department_id,
        hire_date,

        ROW_NUMBER() OVER (
            PARTITION BY department_id
            ORDER BY hire_date DESC
        ) AS rn

    FROM hr.employees
)
WHERE rn = 1;
```

### Explanation

Inside the subquery:

```sql
ROW_NUMBER()
```

ranks employees based on latest hire date.

`DESC` means latest employee comes first.

Outer query:

```sql
WHERE rn = 1
```

returns only the latest employee from each department.

---

## Example 6 – Top 3 Highest Paid Employees in Each Department

```sql
SELECT *
FROM
(
    SELECT
        employee_id,
        first_name,
        department_id,
        salary,

        ROW_NUMBER() OVER (
            PARTITION BY department_id
            ORDER BY salary DESC
        ) AS rn

    FROM hr.employees
)
WHERE rn <= 3;
```

### Explanation

Employees are ranked separately inside every department.

Then:

```sql
WHERE rn <= 3
```

returns the first three employees.

---

# PART 2 – RANK()

## Example 7 – Rank Employees Based on Salary

```sql
SELECT
    employee_id,
    first_name,
    salary,

    RANK() OVER (
        ORDER BY salary DESC
    ) AS salary_rank

FROM hr.employees;
```

### Explanation

Employees with the same salary receive the same rank.

Example:

```text
Salary     Rank
24000      1
17000      2
17000      2
14000      4
```

Notice that rank 3 is skipped.

---

## Example 8 – Rank Employees from Lowest Salary

```sql
SELECT
    employee_id,
    first_name,
    salary,

    RANK() OVER (
        ORDER BY salary ASC
    ) AS salary_rank

FROM hr.employees;
```

### Explanation

Lowest salary gets rank 1.

Higher salaries receive higher rank numbers.

---

## Example 9 – Department-Wise Salary Rank

```sql
SELECT
    employee_id,
    first_name,
    department_id,
    salary,

    RANK() OVER (
        PARTITION BY department_id
        ORDER BY salary DESC
    ) AS department_rank

FROM hr.employees;
```

### Explanation

Ranking starts again for every department.

Employees with equal salaries receive the same rank.

---

## Example 10 – Rank Employees Based on Hire Date

```sql
SELECT
    employee_id,
    first_name,
    hire_date,

    RANK() OVER (
        ORDER BY hire_date ASC
    ) AS joining_rank

FROM hr.employees;
```

### Explanation

Earlier joining employees receive a smaller rank.

---

## Example 11 – Highest Paid Employees in Every Department

```sql
SELECT *
FROM
(
    SELECT
        employee_id,
        first_name,
        department_id,
        salary,

        RANK() OVER (
            PARTITION BY department_id
            ORDER BY salary DESC
        ) AS salary_rank

    FROM hr.employees
)
WHERE salary_rank = 1;
```

### Explanation

This finds the highest-paid employee in every department.

Important:

If two employees have the same highest salary, both are returned.

---

## Example 12 – Top 3 Salary Ranks in Every Department

```sql
SELECT *
FROM
(
    SELECT
        employee_id,
        first_name,
        department_id,
        salary,

        RANK() OVER (
            PARTITION BY department_id
            ORDER BY salary DESC
        ) AS salary_rank

    FROM hr.employees
)
WHERE salary_rank <= 3;
```

### Explanation

This returns employees belonging to the top three salary ranks.

Because `RANK()` handles ties, more than three employees may be returned.

---

# PART 3 – DENSE_RANK()

## Example 13 – Dense Rank Based on Salary

```sql
SELECT
    employee_id,
    first_name,
    salary,

    DENSE_RANK() OVER (
        ORDER BY salary DESC
    ) AS salary_rank

FROM hr.employees;
```

### Explanation

Example:

```text
Salary     Dense Rank
24000      1
17000      2
17000      2
14000      3
```

Unlike `RANK()`, there are no gaps.

---

## Example 14 – Dense Rank from Lowest Salary

```sql
SELECT
    employee_id,
    first_name,
    salary,

    DENSE_RANK() OVER (
        ORDER BY salary ASC
    ) AS salary_rank

FROM hr.employees;
```

### Explanation

Lowest salary receives dense rank 1.

Duplicate salaries receive the same dense rank.

---

## Example 15 – Department-Wise Dense Rank

```sql
SELECT
    employee_id,
    first_name,
    department_id,
    salary,

    DENSE_RANK() OVER (
        PARTITION BY department_id
        ORDER BY salary DESC
    ) AS department_rank

FROM hr.employees;
```

### Explanation

Dense ranking starts separately for each department.

---

## Example 16 – Find Second Highest Salary

```sql
SELECT *
FROM
(
    SELECT
        employee_id,
        first_name,
        salary,

        DENSE_RANK() OVER (
            ORDER BY salary DESC
        ) AS salary_rank

    FROM hr.employees
)
WHERE salary_rank = 2;
```

### Explanation

This is a very common interview query.

```text
Highest salary        → Rank 1
Second highest salary → Rank 2
Third highest salary  → Rank 3
```

All employees earning the second-highest salary are returned.

---

## Example 17 – Third Highest Salary

```sql
SELECT *
FROM
(
    SELECT
        employee_id,
        first_name,
        salary,

        DENSE_RANK() OVER (
            ORDER BY salary DESC
        ) AS salary_rank

    FROM hr.employees
)
WHERE salary_rank = 3;
```

### Explanation

Employees with the third distinct highest salary are returned.

---

## Example 18 – Second Highest Salary in Every Department

```sql
SELECT *
FROM
(
    SELECT
        employee_id,
        first_name,
        department_id,
        salary,

        DENSE_RANK() OVER (
            PARTITION BY department_id
            ORDER BY salary DESC
        ) AS salary_rank

    FROM hr.employees
)
WHERE salary_rank = 2;
```

### Explanation

The ranking happens independently for every department.

Then only rank 2 is selected.

---

# PART 4 – FIRST_VALUE()

## Example 19 – Display Highest Salary Against Every Employee

```sql
SELECT
    employee_id,
    first_name,
    salary,

    FIRST_VALUE(salary) OVER (
        ORDER BY salary DESC
    ) AS highest_salary

FROM hr.employees;
```

### Explanation

Because salaries are sorted descending:

```text
24000
17000
17000
14000
...
```

the first value is the highest salary.

---

## Example 20 – Display Lowest Salary Using FIRST_VALUE

```sql
SELECT
    employee_id,
    first_name,
    salary,

    FIRST_VALUE(salary) OVER (
        ORDER BY salary ASC
    ) AS lowest_salary

FROM hr.employees;
```

### Explanation

Because salaries are sorted ascending, the first salary is the lowest salary.

---

## Example 21 – Highest Salary in Each Department

```sql
SELECT
    employee_id,
    first_name,
    department_id,
    salary,

    FIRST_VALUE(salary) OVER (
        PARTITION BY department_id
        ORDER BY salary DESC
    ) AS department_highest_salary

FROM hr.employees;
```

### Explanation

`PARTITION BY department_id` creates separate windows.

`ORDER BY salary DESC` places the highest salary first.

`FIRST_VALUE()` returns that salary.

---

## Example 22 – Name of Highest Paid Employee in Each Department

```sql
SELECT
    employee_id,
    first_name,
    department_id,
    salary,

    FIRST_VALUE(first_name) OVER (
        PARTITION BY department_id
        ORDER BY salary DESC
    ) AS highest_paid_employee

FROM hr.employees;
```

### Explanation

Instead of returning the salary, we return:

```sql
FIRST_VALUE(first_name)
```

Therefore the name of the highest-paid employee is displayed.

---

## Example 23 – Earliest Joining Date in Each Department

```sql
SELECT
    employee_id,
    first_name,
    department_id,
    hire_date,

    FIRST_VALUE(hire_date) OVER (
        PARTITION BY department_id
        ORDER BY hire_date ASC
    ) AS earliest_hire_date

FROM hr.employees;
```

### Explanation

`ASC` places the oldest/earliest hire date first.

Therefore `FIRST_VALUE()` returns the earliest hire date.

---

## Example 24 – First Employee Who Joined Each Department

```sql
SELECT
    employee_id,
    first_name,
    department_id,
    hire_date,

    FIRST_VALUE(first_name) OVER (
        PARTITION BY department_id
        ORDER BY hire_date ASC
    ) AS first_joined_employee

FROM hr.employees;
```

### Explanation

Employees are ordered based on `hire_date`.

The first employee name in each department is returned.

---

# PART 5 – LAST_VALUE()

## Example 25 – Display Lowest Salary Against Every Employee

```sql
SELECT
    employee_id,
    first_name,
    salary,

    LAST_VALUE(salary) OVER (
        ORDER BY salary DESC
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND UNBOUNDED FOLLOWING
    ) AS lowest_salary

FROM hr.employees;
```

### Explanation

Salary is arranged from highest to lowest.

The last row therefore contains the lowest salary.

The frame:

```sql
ROWS BETWEEN UNBOUNDED PRECEDING
AND UNBOUNDED FOLLOWING
```

means:

```text
First Row
   ↓
Entire Window
   ↓
Last Row
```

---

## Example 26 – Highest Salary Using LAST_VALUE

```sql
SELECT
    employee_id,
    first_name,
    salary,

    LAST_VALUE(salary) OVER (
        ORDER BY salary ASC
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND UNBOUNDED FOLLOWING
    ) AS highest_salary

FROM hr.employees;
```

### Explanation

Because salary is sorted ascending:

```text
Lowest
↓
...
↓
Highest
```

the last value becomes the highest salary.

---

## Example 27 – Lowest Salary in Each Department

```sql
SELECT
    employee_id,
    first_name,
    department_id,
    salary,

    LAST_VALUE(salary) OVER (
        PARTITION BY department_id
        ORDER BY salary DESC
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND UNBOUNDED FOLLOWING
    ) AS department_lowest_salary

FROM hr.employees;
```

### Explanation

Each department gets its own window.

Within that department:

```text
Highest Salary
↓
Middle Salaries
↓
Lowest Salary
```

`LAST_VALUE()` returns the lowest salary.

---

## Example 28 – Lowest Paid Employee Name in Each Department

```sql
SELECT
    employee_id,
    first_name,
    department_id,
    salary,

    LAST_VALUE(first_name) OVER (
        PARTITION BY department_id
        ORDER BY salary DESC
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND UNBOUNDED FOLLOWING
    ) AS lowest_paid_employee

FROM hr.employees;
```

### Explanation

The last employee after descending salary sorting is the lowest-paid employee.

---

## Example 29 – Latest Hire Date in Each Department

```sql
SELECT
    employee_id,
    first_name,
    department_id,
    hire_date,

    LAST_VALUE(hire_date) OVER (
        PARTITION BY department_id
        ORDER BY hire_date ASC
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND UNBOUNDED FOLLOWING
    ) AS latest_hire_date

FROM hr.employees;
```

### Explanation

Employees are sorted from earliest to latest.

Therefore the last value is the latest hire date.

---

## Example 30 – Compare Employee Salary with Highest and Lowest Department Salary

```sql
SELECT
    employee_id,
    first_name,
    department_id,
    salary,

    FIRST_VALUE(salary) OVER (
        PARTITION BY department_id
        ORDER BY salary DESC
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND UNBOUNDED FOLLOWING
    ) AS highest_department_salary,

    LAST_VALUE(salary) OVER (
        PARTITION BY department_id
        ORDER BY salary DESC
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND UNBOUNDED FOLLOWING
    ) AS lowest_department_salary

FROM hr.employees
ORDER BY department_id, salary DESC;
```

### Explanation

This query gives three important salary values together:

```text
Employee Salary
Highest Salary in Department
Lowest Salary in Department
```

Example output:

| Employee | Dept | Salary | Highest | Lowest |
|----------|-----:|-------:|--------:|-------:|
| A | 50 | 12000 | 12000 | 3000 |
| B | 50 | 9000  | 12000 | 3000 |
| C | 50 | 6000  | 12000 | 3000 |
| D | 50 | 3000  | 12000 | 3000 |

---

# IMPORTANT INTERVIEW DIFFERENCE

Consider salaries:

```text
24000
17000
17000
14000
13500
```

The three ranking functions produce:

| Salary | ROW_NUMBER | RANK | DENSE_RANK |
|-------:|-----------:|-----:|-----------:|
| 24000 | 1 | 1 | 1 |
| 17000 | 2 | 2 | 2 |
| 17000 | 3 | 2 | 2 |
| 14000 | 4 | 4 | 3 |
| 13500 | 5 | 5 | 4 |

## ROW_NUMBER()

```text
1
2
3
4
5
```

Every row receives a unique number.

## RANK()

```text
1
2
2
4
5
```

Duplicates receive the same rank.

Ranks are skipped.

## DENSE_RANK()

```text
1
2
2
3
4
```

Duplicates receive the same rank.

Ranks are NOT skipped.

---

# FIRST_VALUE vs LAST_VALUE

## FIRST_VALUE

```sql
FIRST_VALUE(salary) OVER (
    ORDER BY salary DESC
)
```

Returns the first salary after sorting.

With `DESC`, this normally means the highest salary.

## LAST_VALUE

```sql
LAST_VALUE(salary) OVER (
    ORDER BY salary DESC
    ROWS BETWEEN UNBOUNDED PRECEDING
    AND UNBOUNDED FOLLOWING
)
```

Returns the last salary from the complete window.

With `DESC`, this means the lowest salary.

---

# Final Cheat Sheet

| Function | Main Purpose |
|---|---|
| `ROW_NUMBER()` | Unique sequential number |
| `RANK()` | Ranking with gaps |
| `DENSE_RANK()` | Ranking without gaps |
| `FIRST_VALUE()` | First value in ordered window |
| `LAST_VALUE()` | Last value in ordered window |

```text
ROW_NUMBER → 1 2 3 4 5

RANK       → 1 2 2 4 5

DENSE_RANK → 1 2 2 3 4

FIRST_VALUE → First value of window

LAST_VALUE  → Last value of window
```

# Important Syntax

```sql
-- ROW NUMBER
ROW_NUMBER() OVER (
    PARTITION BY department_id
    ORDER BY salary DESC
)

-- RANK
RANK() OVER (
    PARTITION BY department_id
    ORDER BY salary DESC
)

-- DENSE RANK
DENSE_RANK() OVER (
    PARTITION BY department_id
    ORDER BY salary DESC
)

-- FIRST VALUE
FIRST_VALUE(salary) OVER (
    PARTITION BY department_id
    ORDER BY salary DESC
)

-- LAST VALUE
LAST_VALUE(salary) OVER (
    PARTITION BY department_id
    ORDER BY salary DESC
    ROWS BETWEEN UNBOUNDED PRE
