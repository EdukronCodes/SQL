# Day 2: Filtering & Sorting — Full Notes and Theory

---

## 1. Why Filtering and Sorting Matter

In Day 1 you learned how to **select** columns from a table. In real applications, tables like **hr.employees** and **hr.departments** can have hundreds or thousands of rows. You rarely need every row; you need rows that meet certain conditions (e.g., a specific department, a salary range, or a name pattern). **Filtering** is the process of restricting the result set to only those rows that satisfy a **condition**. **Sorting** is the process of ordering the result set by one or more columns (ascending or descending). Together, filtering and sorting are the backbone of almost every query you will write.

- **Filtering** reduces the number of rows returned and often improves performance when the database can use indexes or early termination.
- **Sorting** makes reports and user interfaces predictable and readable (e.g., "top 10 by salary," "newest hires first").
- The **WHERE** clause performs filtering; the **ORDER BY** clause performs sorting. In Oracle you can also limit the number of rows with **FETCH FIRST n ROWS ONLY** or **ROWNUM**.

---

## 2. The WHERE Clause: Syntax and Semantics

The **WHERE** clause appears **after** the **FROM** clause and **before** **ORDER BY** (if present). It contains a **boolean expression** (a condition) that is evaluated **once per row**. Only rows for which the condition evaluates to **TRUE** are included in the result. Rows for which the condition is FALSE or UNKNOWN (e.g., when NULL is involved) are excluded.

**Syntax:**

```sql
SELECT column_list
FROM table_name
WHERE condition;
```

- **condition** can be a comparison (e.g., `salary > 5000`), a logical combination of conditions (AND, OR, NOT), or special predicates such as IN, BETWEEN, LIKE, IS NULL.
- The database typically evaluates the WHERE clause **before** computing expressions in the SELECT list (for rows that pass the filter), which can reduce work when many rows are filtered out.

**Example:** Return only employees in department 50.

```sql
SELECT employee_id, first_name, last_name, department_id
FROM hr.employees
WHERE department_id = 50;
```

Every row is checked: if `department_id = 50` is true, the row is returned; otherwise it is discarded.

---

## 3. Comparison Operators in Detail

SQL provides standard comparison operators. Both sides of the operator must be **comparable** (compatible data types). Comparing a number to a string may require implicit or explicit conversion depending on the database.

| Operator | Meaning | Example |
|----------|---------|---------|
| **=** | Equal | `department_id = 50` |
| **<>** or **!=** | Not equal | `job_id <> 'SA_REP'` |
| **<** | Less than | `salary < 5000` |
| **>** | Greater than | `salary > 10000` |
| **<=** | Less than or equal | `salary <= 8000` |
| **>=** | Greater than or equal | `hire_date >= DATE '2020-01-01'` |

- **Important:** Any comparison with **NULL** (e.g., `column = NULL`) yields **UNKNOWN**, which is treated as false in a WHERE clause. So you never use `= NULL`; you use **IS NULL** or **IS NOT NULL** (covered later).
- For **strings**, comparison is usually **case-sensitive** in Oracle unless you use functions like UPPER() or LOWER() in the condition (e.g., `UPPER(last_name) = 'KING'`).
- For **dates**, use standard date literals (e.g., `DATE '2020-01-01'`) or TO_DATE so that the comparison is correct regardless of session format.

---

## 4. Combining Conditions: AND, OR, and NOT

Real-world filters often require more than one condition. You combine conditions using the logical operators **AND**, **OR**, and **NOT**.

- **AND:** All conditions must be true for the row to be returned. If any condition is false, the row is excluded.
- **OR:** At least one condition must be true. The row is excluded only if every condition is false.
- **NOT:** Reverses the result of a condition. NOT true → false, NOT false → true. NOT unknown remains unknown.

**Operator precedence:** AND is evaluated before OR. So `a OR b AND c` is interpreted as `a OR (b AND c)`. To avoid confusion, **always use parentheses** when mixing AND and OR.

**Example: AND**

```sql
SELECT employee_id, first_name, salary, department_id
FROM hr.employees
WHERE department_id = 60 AND salary > 5000;
```

Only employees in department 60 **and** with salary greater than 5000 are returned.

**Example: OR**

```sql
SELECT employee_id, first_name, job_id
FROM hr.employees
WHERE job_id = 'SA_REP' OR job_id = 'SA_MAN';
```

Employees who are either Sales Representatives or Sales Managers are returned.

**Example: NOT**

```sql
SELECT employee_id, first_name, department_id
FROM hr.employees
WHERE NOT department_id = 100;
```

Rows where department_id is not 100 are returned. Note: rows where department_id is NULL will also be included (because NULL = 100 is unknown, and NOT unknown is unknown, but in practice Oracle may treat it as not matching). For clarity, use `department_id <> 100 AND department_id IS NOT NULL` if you want to exclude NULLs.

**Example: Parentheses**

```sql
SELECT employee_id, first_name, salary, department_id
FROM hr.employees
WHERE (department_id = 50 AND salary > 6000) OR (department_id = 60 AND job_id = 'IT_PROG');
```

Without parentheses, the meaning could change. Here we explicitly require either (dept 50 and high salary) or (dept 60 and IT_PROG).

---

## 5. The IN Predicate: Matching a List of Values

The **IN** predicate tests whether a column (or expression) equals **any** value in a given list. It is equivalent to multiple OR conditions but is shorter and often optimized well by the database.

**Syntax:** `column IN (value1, value2, ...)`

**Example:**

```sql
SELECT employee_id, first_name, department_id
FROM hr.employees
WHERE department_id IN (10, 20, 30);
```

This returns employees whose department_id is 10, 20, or 30. It is equivalent to:

`WHERE department_id = 10 OR department_id = 20 OR department_id = 30`

- The list can contain literals, numbers, or strings. Types must be compatible with the column.
- **NOT IN (list)** returns rows where the column is **not** equal to any value in the list. **Caution:** If the list contains NULL, then NOT IN can behave counter-intuitively (e.g., nothing matches because "column <> NULL" is unknown). Prefer NOT EXISTS or ensure the list has no NULLs when using NOT IN.

---

## 6. The BETWEEN Predicate: Range Checks

**BETWEEN** tests whether a value lies within a **range**, inclusive of both boundaries.

**Syntax:** `column BETWEEN low AND high`  
This is equivalent to: `column >= low AND column <= high`

**Example:**

```sql
SELECT employee_id, first_name, salary
FROM hr.employees
WHERE salary BETWEEN 5000 AND 10000;
```

Employees with salary from 5000 to 10000 (both inclusive) are returned.

- **Order matters:** Always write the smaller value first: `BETWEEN 5000 AND 10000`, not BETWEEN 10000 AND 5000 (which would return no rows for a positive salary).
- BETWEEN works with numbers, dates, and strings (lexicographic order). For dates, use date literals or TO_DATE for clarity.

---

## 7. Pattern Matching: LIKE and Wildcards

When you need to match a **pattern** rather than an exact value (e.g., "last name starts with 'K'" or "job_id contains 'MAN'"), you use the **LIKE** predicate with **wildcards**.

- **%** (percent): Matches **any sequence** of characters (including zero characters).
- **_ ** (underscore): Matches **exactly one** character.

**Example: Last name starts with 'K'**

```sql
SELECT employee_id, first_name, last_name
FROM hr.employees
WHERE last_name LIKE 'K%';
```

'K', 'King', 'Kochhar' would match; 'Smith' would not.

**Example: Last name contains 'll'**

```sql
SELECT employee_id, last_name
FROM hr.employees
WHERE last_name LIKE '%ll%';
```

Any last name containing the substring "ll" (e.g., "Kelly", "Bull") matches.

**Example: Exactly four characters**

```sql
SELECT job_id FROM hr.employees WHERE job_id LIKE '____';
```

Four underscores match exactly four characters.

- **Escape character:** If you need to search for a literal % or _, use an escape (e.g., `LIKE '%\%%' ESCAPE '\'` to find strings containing %).
- LIKE is case-sensitive in Oracle. Use UPPER(column) LIKE 'K%' for case-insensitive matching.

---

## 8. NULL Tests: IS NULL and IS NOT NULL

Because NULL means "unknown," the comparison `column = NULL` does **not** return true for rows where the column is NULL; it yields unknown. Therefore SQL provides special predicates:

- **IS NULL:** True if the column (or expression) is NULL.
- **IS NOT NULL:** True if the column is not NULL.

**Example: Employees with no commission**

```sql
SELECT employee_id, first_name, commission_pct
FROM hr.employees
WHERE commission_pct IS NULL;
```

**Example: Employees who have a commission**

```sql
SELECT employee_id, first_name, commission_pct
FROM hr.employees
WHERE commission_pct IS NOT NULL;
```

- Never write `= NULL` or `<> NULL`. Always use IS NULL or IS NOT NULL.

---

## 9. ORDER BY: Sorting the Result Set

The **ORDER BY** clause specifies the **order** in which rows are returned. It appears **after** WHERE (and after GROUP BY/HAVING when used). Without ORDER BY, the order of rows is **not guaranteed** (it may follow physical storage or execution plan).

**Syntax:** `ORDER BY column_or_expression [ASC | DESC], ...`

- **ASC** (ascending): Default. Smallest values first (A before Z, 1 before 2).
- **DESC** (descending): Largest values first.

**Example: Sort by salary descending**

```sql
SELECT employee_id, first_name, salary
FROM hr.employees
ORDER BY salary DESC;
```

**Example: Sort by multiple columns**

```sql
SELECT employee_id, first_name, last_name, department_id, salary
FROM hr.employees
ORDER BY department_id ASC, salary DESC;
```

Rows are first ordered by department_id (ascending); within the same department_id, rows are ordered by salary (descending).

- You can order by a column name, alias (defined in SELECT), or expression. You can also use **positional** ordering: ORDER BY 1, 3 (first and third columns in the SELECT list).
- **NULLs:** In Oracle, by default NULLs sort as "largest" (appear last in ASC, first in DESC). You can control this with **NULLS FIRST** or **NULLS LAST** (e.g., `ORDER BY commission_pct DESC NULLS LAST`).

---

## 10. NULLS FIRST and NULLS LAST

In Oracle, you can explicitly place NULLs at the beginning or end of the sorted result:

```sql
SELECT employee_id, commission_pct
FROM hr.employees
ORDER BY commission_pct DESC NULLS LAST;
```

So the highest commission values come first, and employees with NULL commission appear at the end.

---

## 11. Limiting the Number of Rows: FETCH FIRST and ROWNUM

Often you want only the **top N** rows (e.g., top 5 highest-paid employees). In **Oracle 12c and later**, you can use **FETCH FIRST n ROWS ONLY** (optionally with **OFFSET**). In older Oracle, you use **ROWNUM**.

**FETCH FIRST (Oracle 12c+):**

```sql
SELECT employee_id, first_name, salary
FROM hr.employees
ORDER BY salary DESC
FETCH FIRST 5 ROWS ONLY;
```

The query is sorted first, then the first 5 rows are returned. So you get the 5 highest-paid employees.

**ROWNUM (older Oracle):** ROWNUM is assigned **before** sorting. So you must use a subquery: sort in the inner query, then apply ROWNUM in the outer query:

```sql
SELECT * FROM (
  SELECT employee_id, first_name, salary
  FROM hr.employees
  ORDER BY salary DESC
) WHERE ROWNUM <= 5;
```

---

## 12. DISTINCT: Removing Duplicate Rows

**DISTINCT** in the SELECT list eliminates **duplicate** rows from the result. The database compares the entire row (all selected columns) to determine duplicates.

**Example:**

```sql
SELECT DISTINCT job_id
FROM hr.employees;
```

This returns each unique job_id once, no matter how many employees have that job.

```sql
SELECT DISTINCT department_id, job_id
FROM hr.employees;
```

This returns unique (department_id, job_id) pairs.

- DISTINCT can add cost (sorting or hashing) for large result sets. Use it only when you need unique rows.
- To count distinct values, use COUNT(DISTINCT column) (covered in aggregation).

---

## 13. Combining Filter, Sort, and Limit

The standard order of clauses is:

**SELECT … FROM … [WHERE …] [ORDER BY …] [FETCH FIRST n ROWS ONLY];**

**Example:**

```sql
SELECT employee_id, first_name, last_name, salary
FROM hr.employees
WHERE department_id = 80
ORDER BY salary DESC
FETCH FIRST 10 ROWS ONLY;
```

This returns the top 10 highest-paid employees in department 80.

---

## 14. Best Practices and Summary Points

**Best practices:**

1. Always use **WHERE** when you do not need every row; it improves performance and clarity.
2. Use **parentheses** when mixing AND and OR so the logic is unambiguous.
3. Use **IS NULL** / **IS NOT NULL** for NULL checks; never use = NULL.
4. For "top N" queries, use **ORDER BY** then **FETCH FIRST n** (or subquery with ROWNUM) so that the limit is applied after sorting.
5. Use **LIKE** with care on large tables; leading wildcards (e.g., `%name`) often prevent index use.

**Summary points:**

- WHERE filters rows using conditions (comparisons, IN, BETWEEN, LIKE, IS NULL, AND, OR, NOT).
- ORDER BY sorts the result by one or more columns (ASC/DESC, NULLS FIRST/LAST).
- FETCH FIRST n ROWS ONLY (or ROWNUM in a subquery) limits the number of rows returned.
- DISTINCT removes duplicate rows from the result set.

---

[← Day 1](./day01_sql_basics.md) | [Back to Learning Plan](../30-day-sql-plsql-learning-plan.md) | [Next: Day 3 →](./day03_ddl_basics.md)
