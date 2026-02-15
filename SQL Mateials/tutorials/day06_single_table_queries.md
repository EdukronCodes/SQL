# Day 6: Single-Table Queries Deep Dive — Full Notes and Theory

---

## 1. Why Single-Table Queries Matter

After mastering basic SELECT, filtering, and sorting, the next step is to write **richer single-table queries** on **hr.employees** (and **hr.departments** when needed for conditions). You will combine **complex WHERE** conditions, **CASE** expressions, **NULL handling** (NVL, COALESCE), **date functions**, and **string functions** to shape and compute columns without leaving one table. These skills are the foundation for reporting, analytics, and clean data presentation.

- Single-table queries avoid joins and can be easier to read and tune when all needed data lives in one table.
- **CASE** lets you classify rows (e.g., salary bands, job labels). **NVL/COALESCE** make calculations and display safe when NULLs are present.
- **Date** and **string** functions let you filter by time (e.g., hire year) and format or slice text (e.g., tenure, initials, first three characters).

---

## 2. Complex WHERE with AND/OR and Parentheses

You can combine multiple conditions in the **WHERE** clause using **AND** and **OR**. **AND** has higher precedence than **OR**, so the order of evaluation can change the result. Always use **parentheses** when mixing AND and OR so the logic is explicit.

**Example:**

```sql
SELECT employee_id, first_name, salary, department_id, job_id
FROM hr.employees
WHERE (department_id = 50 AND salary > 5000)
   OR (department_id = 60 AND job_id = 'IT_PROG');
```

Without parentheses, `department_id = 50 AND salary > 5000 OR department_id = 60 AND job_id = 'IT_PROG'` is read as `(department_id = 50 AND salary > 5000) OR (department_id = 60 AND job_id = 'IT_PROG')` because AND is evaluated first. Using parentheses makes the intent clear and avoids mistakes.

---

## 3. IN with Subquery Preview

The **IN** predicate can take a **subquery** that returns a single column. The subquery is evaluated once (or optimized as a set), and the outer query keeps only rows whose value is in that set. This is a preview of subqueries (covered fully later).

**Example:** Employees in departments that are in location 1700.

```sql
SELECT employee_id, first_name, department_id
FROM hr.employees
WHERE department_id IN (SELECT department_id FROM hr.departments WHERE location_id = 1700);
```

The subquery returns department_id values from hr.departments for location_id = 1700. The outer query returns employees whose department_id is in that list. If the HR schema has no location_id on departments, you can use a different filter (e.g., department_id IN (10, 20, 30)) for practice.

---

## 4. CASE in SELECT: Conditional Logic in the Result

**CASE** is an expression that returns a value based on conditions. It is like IF/ELSE in other languages but is written inside the SELECT (or WHERE, ORDER BY) list.

**Searched CASE (multiple conditions):**

```sql
SELECT employee_id, first_name, salary,
  CASE
    WHEN salary < 5000 THEN 'Low'
    WHEN salary < 12000 THEN 'Medium'
    ELSE 'High'
  END AS salary_band
FROM hr.employees;
```

Conditions are evaluated in order; the first **true** one determines the result. **ELSE** is optional; if no condition matches and there is no ELSE, the result is NULL.

**Simple CASE (single expression compared to values):**

```sql
SELECT employee_id, job_id,
  CASE job_id
    WHEN 'SA_REP' THEN 'Sales Rep'
    WHEN 'SA_MAN' THEN 'Sales Manager'
    ELSE 'Other'
  END AS job_label
FROM hr.employees;
```

Here you compare one expression (job_id) to several values. Use simple CASE when you are matching one column to literal values; use searched CASE for ranges or multiple columns.

---

## 5. COALESCE and NVL for NULL Handling

- **NVL(column, value)** (Oracle): If **column** is NULL, return **value**; otherwise return **column**. Both arguments must be compatible types.
- **COALESCE(a, b, c, ...)** (standard SQL, Oracle): Returns the **first non-NULL** in the list. Useful for multiple fallbacks.

**Example: Total compensation (salary + commission)**

```sql
SELECT employee_id, salary, commission_pct,
  salary * (1 + NVL(commission_pct, 0)) AS total_comp
FROM hr.employees;
```

If commission_pct is NULL, NVL makes it 0 so the expression does not become NULL.

**Example: Display phone or 'N/A'**

```sql
SELECT employee_id, first_name, phone_number,
  COALESCE(phone_number, 'N/A') AS contact_phone
FROM hr.employees;
```

---

## 6. Date Functions (hire_date and SYSDATE)

Common Oracle date functions used with **hire_date** and **SYSDATE**:

| Function | Purpose |
|----------|---------|
| **SYSDATE** | Current date and time (session). |
| **MONTHS_BETWEEN(date1, date2)** | Number of months between two dates. |
| **ADD_MONTHS(date, n)** | Add n months to date. |
| **TRUNC(date)** | Truncate to midnight (day) or other part. |
| **EXTRACT(YEAR \| MONTH \| DAY FROM date)** | Get year, month, or day. |

**Tenure in years:**

```sql
SELECT employee_id, first_name, hire_date,
  ROUND(MONTHS_BETWEEN(SYSDATE, hire_date) / 12, 1) AS tenure_years
FROM hr.employees;
```

**Employees hired in 2005:**

```sql
SELECT employee_id, first_name, hire_date
FROM hr.employees
WHERE EXTRACT(YEAR FROM hire_date) = 2005;
```

Or with a date range (often better for index use):

```sql
WHERE hire_date >= DATE '2005-01-01' AND hire_date < DATE '2006-01-01';
```

**Add 6 months to hire_date (e.g., review date):**

```sql
SELECT employee_id, hire_date, ADD_MONTHS(hire_date, 6) AS review_date
FROM hr.employees;
```

---

## 7. String Functions (Names and Text)

Common Oracle string functions:

| Function | Purpose |
|----------|---------|
| **UPPER(s), LOWER(s)** | Change case. |
| **INITCAP(s)** | First letter of each word capitalized. |
| **SUBSTR(s, start, length)** | Substring (1-based; length optional to end). |
| **LENGTH(s)** | Length of string. |
| **a \|\| b** or **CONCAT(a,b)** | Concatenate. |
| **TRIM, LTRIM, RTRIM** | Remove spaces (or other characters). |

**Examples on hr.employees:**

```sql
SELECT employee_id, UPPER(last_name) AS last_upper, LENGTH(first_name) AS first_name_len
FROM hr.employees;
```

```sql
SELECT employee_id, SUBSTR(first_name, 1, 3) AS first_3_chars
FROM hr.employees;
```

```sql
SELECT employee_id, first_name || ' ' || last_name AS full_name
FROM hr.employees;
```

---

## 8. Best Practices and Summary

- Use **parentheses** in WHERE when mixing AND/OR. Use **CASE** for bands and labels in the SELECT list.
- Handle **NULLs** with **NVL** or **COALESCE** in calculations and display. Use **date ranges** (e.g., >= and <) when filtering by year for better index use.
- Use **string functions** for display and **EXTRACT** or date ranges for time-based filters. All examples here use only **hr.employees** and **hr.departments**.

---

[← Day 5](./day05_dcl_tcl.md) | [Back to Learning Plan](../30-day-sql-plsql-learning-plan.md) | [Next: Day 7 →](./day07_joins_intro.md)
