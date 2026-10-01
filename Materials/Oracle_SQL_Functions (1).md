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




# Oracle SQL Window Frames – 30 Examples with Detailed Comments

## Table Used

```sql
HR.EMPLOYEES
```

## Window Frame Syntax

```sql
ROWS BETWEEN <starting_point> AND <ending_point>
```

### Important Options

```text
UNBOUNDED PRECEDING
→ Start from the first row of the window.

n PRECEDING
→ Go n rows before the current row.

CURRENT ROW
→ The row currently being processed.

n FOLLOWING
→ Go n rows after the current row.

UNBOUNDED FOLLOWING
→ Continue until the last row of the window.
```

---

# 1. Running Total – First Row to Current Row

```sql
SELECT
    employee_id,
    first_name,
    salary,

    -- SUM() is used as an analytic function.
    -- ORDER BY employee_id decides the sequence of employees.
    -- UNBOUNDED PRECEDING means start from the first row.
    -- CURRENT ROW means stop at the current employee.
    -- Therefore, this calculates a cumulative/running salary total.
    SUM(salary) OVER (
        ORDER BY employee_id
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND CURRENT ROW
    ) AS running_total

FROM hr.employees

-- Display employees in the same order used for calculation.
ORDER BY employee_id;
```

### Logic

```text
Row 1 → Row 1
Row 2 → Row 1 + Row 2
Row 3 → Row 1 + Row 2 + Row 3
Row 4 → Row 1 + Row 2 + Row 3 + Row 4
```

---

# 2. Department-Wise Running Total

```sql
SELECT
    employee_id,
    first_name,
    department_id,
    salary,

    -- PARTITION BY creates a separate window for each department.
    -- Running total restarts when department_id changes.
    -- Employees inside each department are ordered by employee_id.
    -- Calculation starts from the first employee in the department.
    -- It ends at the current employee.
    SUM(salary) OVER (
        PARTITION BY department_id
        ORDER BY employee_id
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND CURRENT ROW
    ) AS department_running_total

FROM hr.employees

ORDER BY department_id, employee_id;
```

### Logic

```text
Department 10

Employee 1 → Salary 1
Employee 2 → Salary 1 + Salary 2
Employee 3 → Salary 1 + Salary 2 + Salary 3


Department 20

Employee 1 → Salary 1
Employee 2 → Salary 1 + Salary 2
Employee 3 → Salary 1 + Salary 2 + Salary 3
```

---

# 3. Running Average Salary

```sql
SELECT
    employee_id,
    first_name,
    salary,

    -- AVG() calculates the average salary.
    -- Window starts from the first employee.
    -- Window grows until the current employee.
    -- Therefore, this gives a running average.
    AVG(salary) OVER (
        ORDER BY employee_id
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND CURRENT ROW
    ) AS running_average

FROM hr.employees

ORDER BY employee_id;
```

### Logic

```text
Row 1:

Salary1 / 1

Row 2:

(Salary1 + Salary2) / 2

Row 3:

(Salary1 + Salary2 + Salary3) / 3
```

---

# 4. Maximum Salary Seen So Far

```sql
SELECT
    employee_id,
    first_name,
    salary,

    -- MAX() finds the highest salary.
    -- Window starts from the first employee.
    -- Window ends at the current employee.
    -- Result shows the highest salary encountered so far.
    MAX(salary) OVER (
        ORDER BY employee_id
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND CURRENT ROW
    ) AS maximum_salary_so_far

FROM hr.employees

ORDER BY employee_id;
```

---

# 5. Minimum Salary Seen So Far

```sql
SELECT
    employee_id,
    first_name,
    salary,

    -- MIN() finds the smallest salary.
    -- Start from the first employee.
    -- Continue until the current employee.
    -- This gives the minimum salary seen so far.
    MIN(salary) OVER (
        ORDER BY employee_id
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND CURRENT ROW
    ) AS minimum_salary_so_far

FROM hr.employees

ORDER BY employee_id;
```

---

# 6. Running Employee Count

```sql
SELECT
    employee_id,
    first_name,
    salary,

    -- COUNT(*) counts rows.
    -- First employee sees 1 row.
    -- Second employee sees 2 rows.
    -- Third employee sees 3 rows.
    -- Therefore, this creates a running count.
    COUNT(*) OVER (
        ORDER BY employee_id
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND CURRENT ROW
    ) AS running_employee_count

FROM hr.employees

ORDER BY employee_id;
```

### Output Concept

```text
Employee 1 → 1
Employee 2 → 2
Employee 3 → 3
Employee 4 → 4
Employee 5 → 5
```

---

# 7. Complete Company Salary Total

```sql
SELECT
    employee_id,
    first_name,
    salary,

    -- UNBOUNDED PRECEDING = first row.
    -- UNBOUNDED FOLLOWING = last row.
    -- Therefore, the complete table is considered.
    -- Every employee receives the same company salary total.
    SUM(salary) OVER (
        ORDER BY employee_id
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND UNBOUNDED FOLLOWING
    ) AS company_total_salary

FROM hr.employees

ORDER BY employee_id;
```

### Window

```text
FIRST ROW
    ↓
    ↓
CURRENT ROW
    ↓
    ↓
LAST ROW
```

---

# 8. Complete Department Salary Total

```sql
SELECT
    employee_id,
    first_name,
    department_id,
    salary,

    -- Create a separate window for every department.
    -- Start from the first employee of the department.
    -- Continue until the last employee of the department.
    -- Therefore, every employee sees the total salary
    -- of their department.
    SUM(salary) OVER (
        PARTITION BY department_id
        ORDER BY employee_id
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND UNBOUNDED FOLLOWING
    ) AS department_total_salary

FROM hr.employees

ORDER BY department_id, employee_id;
```

---

# 9. Complete Department Average Salary

```sql
SELECT
    employee_id,
    first_name,
    department_id,
    salary,

    -- Employees are separated department-wise.
    -- Complete department is included in the window.
    -- AVG() calculates the average salary of that department.
    AVG(salary) OVER (
        PARTITION BY department_id
        ORDER BY employee_id
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND UNBOUNDED FOLLOWING
    ) AS department_average_salary

FROM hr.employees

ORDER BY department_id, employee_id;
```

---

# 10. Reverse Running Total

```sql
SELECT
    employee_id,
    first_name,
    salary,

    -- CURRENT ROW means start from the current employee.
    -- UNBOUNDED FOLLOWING means continue until the last employee.
    -- This is the opposite of a normal running total.
    SUM(salary) OVER (
        ORDER BY employee_id
        ROWS BETWEEN CURRENT ROW
        AND UNBOUNDED FOLLOWING
    ) AS reverse_running_total

FROM hr.employees

ORDER BY employee_id;
```

### Example

```text
Salary:

1000
2000
3000
4000

Results:

Row 1 → 1000 + 2000 + 3000 + 4000 = 10000
Row 2 → 2000 + 3000 + 4000        = 9000
Row 3 → 3000 + 4000               = 7000
Row 4 → 4000                      = 4000
```

---

# 11. Reverse Running Average

```sql
SELECT
    employee_id,
    first_name,
    salary,

    -- Start from current employee.
    -- Continue until last employee.
    -- Calculate average salary of all remaining employees.
    AVG(salary) OVER (
        ORDER BY employee_id
        ROWS BETWEEN CURRENT ROW
        AND UNBOUNDED FOLLOWING
    ) AS reverse_running_average

FROM hr.employees

ORDER BY employee_id;
```

---

# 12. Previous Row + Current Row

```sql
SELECT
    employee_id,
    first_name,
    salary,

    -- 1 PRECEDING means one row before the current row.
    -- CURRENT ROW means include the current row.
    -- Maximum two rows participate.
    SUM(salary) OVER (
        ORDER BY employee_id
        ROWS BETWEEN 1 PRECEDING
        AND CURRENT ROW
    ) AS previous_current_total

FROM hr.employees

ORDER BY employee_id;
```

### Window

```text
Previous Row
     +
Current Row
```

---

# 13. Previous Two Rows + Current Row

```sql
SELECT
    employee_id,
    first_name,
    salary,

    -- 2 PRECEDING means start two rows before current row.
    -- Include:
    --     2nd previous employee
    --     1st previous employee
    --     current employee
    -- Maximum window size = 3 rows.
    SUM(salary) OVER (
        ORDER BY employee_id
        ROWS BETWEEN 2 PRECEDING
        AND CURRENT ROW
    ) AS three_row_total

FROM hr.employees

ORDER BY employee_id;
```

### Window

```text
2 PRECEDING
     ↓
1 PRECEDING
     ↓
CURRENT ROW
```

---

# 14. Previous Three Rows + Current Row Average

```sql
SELECT
    employee_id,
    first_name,
    salary,

    -- Start three rows before the current employee.
    -- End at current employee.
    -- Maximum four employees participate.
    AVG(salary) OVER (
        ORDER BY employee_id
        ROWS BETWEEN 3 PRECEDING
        AND CURRENT ROW
    ) AS four_row_moving_average

FROM hr.employees

ORDER BY employee_id;
```

---

# 15. Previous + Current + Next Row

```sql
SELECT
    employee_id,
    first_name,
    salary,

    -- Start one row before current row.
    -- End one row after current row.
    -- Maximum three employees participate.
    SUM(salary) OVER (
        ORDER BY employee_id
        ROWS BETWEEN 1 PRECEDING
        AND 1 FOLLOWING
    ) AS three_row_moving_total

FROM hr.employees

ORDER BY employee_id;
```

### Window

```text
1 PRECEDING
     ↓
CURRENT ROW
     ↓
1 FOLLOWING
```

---

# 16. Three-Row Moving Average

```sql
SELECT
    employee_id,
    first_name,
    salary,

    -- Previous employee
    -- +
    -- Current employee
    -- +
    -- Next employee
    --
    -- AVG() calculates the moving average.
    AVG(salary) OVER (
        ORDER BY employee_id
        ROWS BETWEEN 1 PRECEDING
        AND 1 FOLLOWING
    ) AS three_row_moving_average

FROM hr.employees

ORDER BY employee_id;
```

---

# 17. Two Previous + Current + Two Following

```sql
SELECT
    employee_id,
    first_name,
    salary,

    -- Start two rows before current employee.
    -- End two rows after current employee.
    -- Maximum window size = 5 employees.
    SUM(salary) OVER (
        ORDER BY employee_id
        ROWS BETWEEN 2 PRECEDING
        AND 2 FOLLOWING
    ) AS five_row_moving_total

FROM hr.employees

ORDER BY employee_id;
```

### Window

```text
2 PRECEDING
1 PRECEDING
CURRENT ROW
1 FOLLOWING
2 FOLLOWING
```

---

# 18. Five-Row Moving Average

```sql
SELECT
    employee_id,
    first_name,
    salary,

    -- Take maximum five employees:
    -- two previous
    -- current
    -- two following
    --
    -- Calculate average salary.
    AVG(salary) OVER (
        ORDER BY employee_id
        ROWS BETWEEN 2 PRECEDING
        AND 2 FOLLOWING
    ) AS five_row_moving_average

FROM hr.employees

ORDER BY employee_id;
```

---

# 19. Current Row + Next Row

```sql
SELECT
    employee_id,
    first_name,
    salary,

    -- Start from current employee.
    -- Include one employee after current employee.
    -- Maximum two employees participate.
    SUM(salary) OVER (
        ORDER BY employee_id
        ROWS BETWEEN CURRENT ROW
        AND 1 FOLLOWING
    ) AS current_next_total

FROM hr.employees

ORDER BY employee_id;
```

---

# 20. Current Row + Next Two Rows

```sql
SELECT
    employee_id,
    first_name,
    salary,

    -- Start at current employee.
    -- Include next two employees.
    -- Maximum window size = 3 employees.
    SUM(salary) OVER (
        ORDER BY employee_id
        ROWS BETWEEN CURRENT ROW
        AND 2 FOLLOWING
    ) AS current_next_two_total

FROM hr.employees

ORDER BY employee_id;
```

### Window

```text
CURRENT ROW
     ↓
1 FOLLOWING
     ↓
2 FOLLOWING
```

---

# 21. Current Row + Next Three Rows Average

```sql
SELECT
    employee_id,
    first_name,
    salary,

    -- Start at current employee.
    -- Include maximum next three employees.
    -- Maximum window size = 4 rows.
    AVG(salary) OVER (
        ORDER BY employee_id
        ROWS BETWEEN CURRENT ROW
        AND 3 FOLLOWING
    ) AS forward_moving_average

FROM hr.employees

ORDER BY employee_id;
```

---

# 22. Department-Wise Moving Average

```sql
SELECT
    employee_id,
    first_name,
    department_id,
    salary,

    -- PARTITION BY prevents the window
    -- from crossing department boundaries.
    --
    -- For each employee calculate average of:
    -- previous employee
    -- current employee
    -- next employee
    AVG(salary) OVER (
        PARTITION BY department_id
        ORDER BY employee_id
        ROWS BETWEEN 1 PRECEDING
        AND 1 FOLLOWING
    ) AS department_moving_average

FROM hr.employees

ORDER BY department_id, employee_id;
```

---

# 23. Department Running Salary Based on Hire Date

```sql
SELECT
    employee_id,
    first_name,
    department_id,
    hire_date,
    salary,

    -- Create separate window for every department.
    -- Arrange employees according to joining date.
    -- employee_id is used as a tie-breaker.
    --
    -- Start from earliest employee.
    -- Continue until current employee.
    SUM(salary) OVER (
        PARTITION BY department_id
        ORDER BY hire_date, employee_id
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND CURRENT ROW
    ) AS salary_running_total

FROM hr.employees

ORDER BY department_id, hire_date, employee_id;
```

---

# 24. Highest Salary Seen So Far Based on Hire Date

```sql
SELECT
    employee_id,
    first_name,
    hire_date,
    salary,

    -- Arrange employees based on joining date.
    -- Start from earliest employee.
    -- Continue until current employee.
    --
    -- MAX() returns the highest salary
    -- encountered up to that employee.
    MAX(salary) OVER (
        ORDER BY hire_date, employee_id
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND CURRENT ROW
    ) AS highest_salary_so_far

FROM hr.employees

ORDER BY hire_date, employee_id;
```

---

# 25. FIRST_VALUE – Highest Salary

```sql
SELECT
    employee_id,
    first_name,
    salary,

    -- salary DESC places highest salary first.
    --
    -- Complete window:
    -- first row → last row.
    --
    -- FIRST_VALUE() therefore returns
    -- the highest salary.
    FIRST_VALUE(salary) OVER (
        ORDER BY salary DESC, employee_id
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND UNBOUNDED FOLLOWING
    ) AS highest_salary

FROM hr.employees

ORDER BY salary DESC, employee_id;
```

---

# 26. LAST_VALUE – Lowest Salary

```sql
SELECT
    employee_id,
    first_name,
    salary,

    -- salary DESC places:
    --
    -- Highest salary → first
    -- Lowest salary  → last
    --
    -- UNBOUNDED FOLLOWING is important because
    -- we want Oracle to examine the entire window.
    --
    -- LAST_VALUE() therefore returns
    -- the lowest salary.
    LAST_VALUE(salary) OVER (
        ORDER BY salary DESC, employee_id
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND UNBOUNDED FOLLOWING
    ) AS lowest_salary

FROM hr.employees

ORDER BY salary DESC, employee_id;
```

---

# 27. Highest and Lowest Salary in Each Department

```sql
SELECT
    employee_id,
    first_name,
    department_id,
    salary,

    -- =============================================
    -- FIRST_VALUE
    -- =============================================
    -- Divide employees department-wise.
    -- Sort salary highest to lowest.
    -- First salary = highest department salary.
    FIRST_VALUE(salary) OVER (
        PARTITION BY department_id
        ORDER BY salary DESC, employee_id
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND UNBOUNDED FOLLOWING
    ) AS highest_department_salary,


    -- =============================================
    -- LAST_VALUE
    -- =============================================
    -- Same sorting:
    --
    -- Highest → first
    -- Lowest  → last
    --
    -- Therefore LAST_VALUE returns
    -- lowest department salary.
    LAST_VALUE(salary) OVER (
        PARTITION BY department_id
        ORDER BY salary DESC, employee_id
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND UNBOUNDED FOLLOWING
