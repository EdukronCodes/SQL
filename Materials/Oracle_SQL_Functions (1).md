# Oracle SQL Analytic Functions – HR.EMPLOYEES

## Functions Covered

1. `ROW_NUMBER()`
2. `RANK()`
3. `DENSE_RANK()`
4. `FIRST_VALUE()`
5. `LAST_VALUE()`

---

# 1. ROW_NUMBER()

## Definition

`ROW_NUMBER()` assigns a **unique sequential number** to every row.

Even when two employees have the same salary, they will receive different row numbers.

### Example 1: Rank employees based on salary

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

- `ORDER BY salary DESC` → Highest salary comes first.
- `ROW_NUMBER()` → Assigns 1, 2, 3, 4, 5...
- Duplicate salaries still receive different numbers.

### Sample Output

| FIRST_NAME | SALARY | ROW_NUM |
|------------|-------:|--------:|
| Steven     | 24000  | 1 |
| Neena      | 17000  | 2 |
| Lex        | 17000  | 3 |
| John       | 14000  | 4 |

Notice:

Neena and Lex have the same salary.

Still:

Neena → 2  
Lex → 3

---

# 2. RANK()

## Definition

`RANK()` assigns the **same rank to duplicate values**, but it skips the next rank.

### Example

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

### Sample Output

| FIRST_NAME | SALARY | RANK |
|------------|-------:|-----:|
| Steven     | 24000 | 1 |
| Neena      | 17000 | 2 |
| Lex        | 17000 | 2 |
| John       | 14000 | 4 |

### Important

Neena and Lex both earn `17000`.

Therefore:

Neena → Rank 2  
Lex → Rank 2

The next rank becomes **4**, not 3.

So `RANK()` creates gaps.

---

# 3. DENSE_RANK()

## Definition

`DENSE_RANK()` also gives the same rank to duplicate values.

However, it **does not skip ranks**.

### Example

```sql
SELECT
    employee_id,
    first_name,
    salary,

    DENSE_RANK() OVER (
        ORDER BY salary DESC
    ) AS dense_rank

FROM hr.employees;
```

### Sample Output

| FIRST_NAME | SALARY | DENSE_RANK |
|------------|-------:|-----------:|
| Steven     | 24000 | 1 |
| Neena      | 17000 | 2 |
| Lex        | 17000 | 2 |
| John       | 14000 | 3 |

### Important

Neena and Lex both have rank 2.

But the next employee gets rank **3**.

There is no gap.

---

# RANK vs DENSE_RANK vs ROW_NUMBER

Consider salaries:

```text
24000
17000
17000
14000
13500
```

Results:

| Salary | ROW_NUMBER | RANK | DENSE_RANK |
|-------:|-----------:|-----:|-----------:|
| 24000 | 1 | 1 | 1 |
| 17000 | 2 | 2 | 2 |
| 17000 | 3 | 2 | 2 |
| 14000 | 4 | 4 | 3 |
| 13500 | 5 | 5 | 4 |

### Key Difference

ROW_NUMBER
→ Always unique numbers  
→ 1, 2, 3, 4, 5

RANK
→ Same rank for duplicates  
→ Skips rank after duplicate  
→ 1, 2, 2, 4, 5

DENSE_RANK
→ Same rank for duplicates  
→ Does NOT skip ranks  
→ 1, 2, 2, 3, 4

---

# 4. FIRST_VALUE()

## Definition

`FIRST_VALUE()` returns the **first value from the window** based on the specified ordering.

### Example: Highest salary in the company

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

### Sample Output

| FIRST_NAME | SALARY | HIGHEST_SALARY |
|------------|-------:|---------------:|
| Steven | 24000 | 24000 |
| Neena  | 17000 | 24000 |
| Lex    | 17000 | 24000 |
| John   | 14000 | 24000 |

### Explanation

We are sorting:

```sql
ORDER BY salary DESC
```

Therefore the highest salary appears first.

`FIRST_VALUE(salary)` returns that first salary.

So every employee can be compared against the highest salary.

---

# FIRST_VALUE Department-Wise

Suppose we want the highest salary in **each department**.

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

```sql
PARTITION BY department_id
```

creates separate groups/windows for each department.

Then:

```sql
ORDER BY salary DESC
```

puts the highest-paid employee first.

Therefore:

```sql
FIRST_VALUE(salary)
```

returns the highest salary in each department.

---

# 5. LAST_VALUE()

## Definition

`LAST_VALUE()` returns the **last value in the window**.

For `LAST_VALUE()`, understanding the window frame is extremely important.

### Example: Lowest salary in the company

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

We sort salaries:

```sql
ORDER BY salary DESC
```

Highest salary comes first.

Lowest salary comes last.

Then:

```sql
LAST_VALUE(salary)
```

returns the salary from the last row.

---

# Understanding the Window Frame

```sql
ROWS BETWEEN UNBOUNDED PRECEDING
AND UNBOUNDED FOLLOWING
```

means:

```text
UNBOUNDED PRECEDING
        ↓
Start from the first row

        TO

UNBOUNDED FOLLOWING
        ↓
Continue until the last row
```

Therefore the complete dataset is considered.

---

# LAST_VALUE Department-Wise

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

First:

```sql
PARTITION BY department_id
```

divides employees by department.

Then:

```sql
ORDER BY salary DESC
```

sorts employees from highest salary to lowest salary.

Finally:

```sql
LAST_VALUE(salary)
```

returns the lowest salary within that department.

---

# All 5 Functions in One Query

```sql
SELECT
    employee_id,
    first_name,
    department_id,
    salary,

    -- Unique sequential number
    ROW_NUMBER() OVER (
        ORDER BY salary DESC
    ) AS row_num,

    -- Same rank for duplicates, but skips ranks
    RANK() OVER (
        ORDER BY salary DESC
    ) AS salary_rank,

    -- Same rank for duplicates without skipping ranks
    DENSE_RANK() OVER (
        ORDER BY salary DESC
    ) AS dense_rank,

    -- Highest salary
    FIRST_VALUE(salary) OVER (
        ORDER BY salary DESC
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND UNBOUNDED FOLLOWING
    ) AS highest_salary,

    -- Lowest salary
    LAST_VALUE(salary) OVER (
        ORDER BY salary DESC
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND UNBOUNDED FOLLOWING
    ) AS lowest_salary

FROM hr.employees
ORDER BY salary DESC;
```

---

# Final Summary

| Function | Purpose | Duplicate Handling |
|----------|---------|-------------------|
| `ROW_NUMBER()` | Gives unique row numbers | Different numbers |
| `RANK()` | Gives ranking | Same rank + gaps |
| `DENSE_RANK()` | Gives dense ranking | Same rank + no gaps |
| `FIRST_VALUE()` | Returns first value in window | Based on ordering |
| `LAST_VALUE()` | Returns last value in window | Based on ordering/frame |

## Easy Way to Remember

```text
ROW_NUMBER
1 2 3 4 5

RANK
1 2 2 4 5

DENSE_RANK
1 2 2 3 4

FIRST_VALUE
→ First value in the window

LAST_VALUE
→ Last value in the window
```
