# Day 1: SQL Basics & SELECT — Full Notes and Theory

---

## 1. Introduction to SQL: What Is It and Why It Matters

**SQL (Structured Query Language)** is the universal language for managing and querying relational databases. It was developed in the 1970s and has since become the de facto standard adopted by Oracle, Microsoft SQL Server, PostgreSQL, MySQL, and many other database systems. Understanding SQL is essential for anyone working with data: developers, analysts, DBAs, and support staff.

- **Declarative nature:** You describe *what* data you want, not *how* to get it. The database engine decides the best way to execute your request.
- **Set-based processing:** SQL works on sets of rows. You write one statement that applies to many rows at once, which is why it scales well for large tables like `hr.employees` and `hr.departments`.
- **Portability:** Core SQL (SELECT, INSERT, UPDATE, DELETE, JOINs, aggregation) is similar across vendors. Oracle-specific extensions (e.g., `NVL`, `ROWNUM`, `CONNECT BY`) add power but reduce portability.

In this course, every example and assignment uses **only** the **HR schema**: primarily the tables **hr.employees** and **hr.departments**. The HR schema models a typical company: employees, departments, jobs, locations, and related data. Focusing on one schema helps you build strong, transferable skills without switching between fictional or unrelated systems.

---

## 2. The Role of the SELECT Statement

The **SELECT** statement is used to **retrieve** data from one or more tables. It does not change data; it only reads. In practice, SELECT is the most frequently used SQL command because reporting, dashboards, and application screens all need to display data.

- SELECT can return **all rows** or a **subset** (using WHERE, which you will see on Day 2).
- The result of a SELECT is always a **result set**: a table of rows and columns that can be displayed, passed to an application, or used inside another query (subquery).

---

## 3. SELECT Syntax: The Foundation

The simplest form of a SELECT statement is:

```sql
SELECT column1, column2, ...
FROM table_name;
```

- **SELECT** is a keyword that begins the statement. Following it, you list the **columns** or **expressions** you want in the result. Each item is separated by a comma.
- **FROM** is another keyword. After FROM you specify the **table** (or tables, when you use joins) that contain the data. The database reads from this table and projects only the columns you listed in SELECT.

**Order of execution (conceptual):** The database logically processes FROM first (which table?), then SELECT (which columns?). Filtering (WHERE) and sorting (ORDER BY) are applied in between in later topics.

**Important:** SQL is case-insensitive for keywords and often for identifiers (table and column names), depending on how the database was created. In Oracle, unquoted identifiers are stored in uppercase. So `SELECT employee_id FROM hr.employees` and `select employee_id from hr.employees` are equivalent.

---

## 4. Selecting Columns from hr.employees: Practical Examples

The **hr.employees** table stores one row per employee. Typical columns include:

| Column           | Type        | Description |
|-----------------|------------|-------------|
| employee_id     | NUMBER(6)  | Unique identifier (primary key). |
| first_name      | VARCHAR2(20) | Employee’s first name. |
| last_name       | VARCHAR2(25) | Employee’s last name. |
| email           | VARCHAR2(25) | Email (often used for login). |
| phone_number    | VARCHAR2(20) | Phone (can be NULL). |
| hire_date       | DATE       | Date the employee was hired. |
| job_id          | VARCHAR2(10) | Reference to job (e.g., SA_REP, IT_PROG). |
| salary          | NUMBER(8,2) | Monthly salary. |
| commission_pct   | NUMBER(2,2) | Commission percentage (NULL if not applicable). |
| manager_id      | NUMBER(6)  | References another row in employees (the manager). |
| department_id   | NUMBER(4)  | References hr.departments. |

**Example: Get employee ID, first name, and last name**

```sql
SELECT employee_id, first_name, last_name
FROM hr.employees;
```

This returns one row per employee with only those three columns. The order of columns in the result matches the order in your SELECT list.

**Select all columns with asterisk (*)**

```sql
SELECT *
FROM hr.employees;
```

The asterisk means “all columns.” The database returns every column in the table in the default order (usually the order they were defined in the table).

- **When to use *:** Quick exploration, ad-hoc checks, or when you genuinely need every column. In production code and reports, avoid * because:
  - The application may break if someone adds or drops a column.
  - You may be fetching more data than needed (e.g., large or sensitive columns).
  - Explicit column lists make the intent of the query clear and are easier to maintain.

---

## 5. Literal Values and Expressions in the SELECT List

The SELECT list is not limited to column names. You can include:

- **Literal values:** Fixed numbers or strings that appear in every row.
- **Expressions:** Calculations or function calls that are evaluated for each row.

**Example: Adding a literal column**

```sql
SELECT employee_id, first_name, 'Active' AS status
FROM hr.employees;
```

Here, every row gets the literal value `'Active'` in a column named `status`. Literals are useful for tagging result sets (e.g., 'HR', 'Current', or a fixed number) without storing them in the table.

- **String literals** in Oracle are enclosed in single quotes. Double quotes are used for identifiers (e.g., column aliases with spaces or mixed case).
- **Numeric literals** are written without quotes (e.g., 12, 0.1).

---

## 6. Column Aliases (AS): Naming Your Output

When you use an expression or a literal, the resulting column often has no meaningful name or has an auto-generated one. You can give it a **display name** using an **alias**.

**Syntax:** `expression AS alias_name`

**Example:**

```sql
SELECT first_name, last_name, salary AS monthly_salary
FROM hr.employees;
```

The third column is still the `salary` column from the table, but in the result set it is labeled `monthly_salary`. The keyword **AS** is optional in many databases (e.g., `salary monthly_salary`), but using AS improves readability.

**Alias with spaces or special characters (Oracle):** If the alias contains spaces or you want to preserve case, enclose it in **double quotes**:

```sql
SELECT first_name AS "First Name", last_name AS "Last Name"
FROM hr.employees;
```

- Without quotes, Oracle stores and displays the alias in uppercase (e.g., FIRST NAME). With double quotes, the exact spelling and case are preserved.
- Alias names (without quotes) cannot contain spaces; use underscores (e.g., monthly_salary) for readability.

---

## 7. Arithmetic in SELECT: Calculations on Numeric Columns

You can perform arithmetic directly in the SELECT list. Standard operators are: `+` (addition), `-` (subtraction), `*` (multiplication), `/` (division). The result is computed for each row.

**Example: Annual salary**

```sql
SELECT employee_id, first_name, last_name, salary, salary * 12 AS annual_salary
FROM hr.employees;
```

Here, `salary` is the monthly salary; `salary * 12` is the annual salary. The alias `annual_salary` makes the meaning clear in the output.

**Example: Salary including commission**

Suppose total compensation is `salary + salary * commission_pct`. If `commission_pct` can be NULL, the whole expression becomes NULL. You must handle NULL explicitly:

```sql
SELECT employee_id, salary,
  salary * (1 + NVL(commission_pct, 0)) AS salary_with_commission
FROM hr.employees;
```

- **NVL(commission_pct, 0)** means: if `commission_pct` is NULL, use 0; otherwise use `commission_pct`. So employees without commission are treated as having 0% commission.
- Arithmetic with NULL yields NULL. So `salary + NULL` is NULL unless you use NVL or COALESCE.

---

## 8. NULL Handling: Understanding and Using NULL

**NULL** in SQL means “unknown” or “missing.” It is not the same as zero or an empty string. NULL indicates that a value is not known or not applicable.

- **Comparison with NULL:** Any comparison involving NULL (e.g., `column = NULL`) evaluates to **unknown**, which in a WHERE clause is treated as false. So you never use `= NULL`; you use **IS NULL** or **IS NOT NULL**.
- **Arithmetic with NULL:** `NULL + 1`, `NULL * 10`, etc., all yield **NULL**. So one NULL in a calculation can make the whole result NULL unless you replace it.

**NVL (Oracle)**  
`NVL(column, value)` — If `column` is NULL, return `value`; otherwise return `column`. Both arguments must be compatible types (e.g., both numeric or both character).

**Example:**

```sql
SELECT employee_id, commission_pct, NVL(commission_pct, 0) AS commission_default_zero
FROM hr.employees;
```

Employees with no commission (NULL) will show 0 in the last column. This is useful for reporting and calculations.

**COALESCE (standard SQL, supported in Oracle)**  
`COALESCE(a, b, c, ...)` — Returns the first non-NULL value in the list. Useful when you have multiple possible columns or fallback values.

---

## 9. Basic Terminology: Table, Row, Column

| Term     | Meaning |
|----------|---------|
| **Table** | A database object that stores data in a grid: rows and columns. Example: `hr.employees`, `hr.departments`. |
| **Row**   | A single record in a table. In `hr.employees`, one row represents one employee. |
| **Column**| One attribute or field. Each column has a name and a data type (e.g., `salary` NUMBER(8,2)). |

- A table is often drawn as a grid: columns are vertical, rows are horizontal. The intersection of a row and a column is a **cell** holding one value (or NULL).
- **Schema:** A collection of objects (tables, views, procedures) owned by a user. `hr.employees` means the table `employees` in the schema `hr`.

---

## 10. Best Practices and Summary Points

**Best practices:**

1. **List only the columns you need** instead of `*`. This reduces network traffic, clarifies intent, and avoids breakage when the table structure changes.
2. **Use meaningful aliases** for expressions and calculated columns (e.g., `annual_salary`, `full_name`) so that anyone reading the query or the report understands the meaning.
3. **Handle NULLs explicitly** in calculations (NVL, COALESCE) so that totals and averages behave as intended and reports do not show blank or misleading values.

**Summary points:**

- SQL is the standard language for querying and managing relational databases.
- SELECT retrieves data; FROM specifies the table(s).
- You can select columns, literals, and expressions; use AS to alias them.
- Arithmetic in SELECT is evaluated per row; NULL in an expression usually yields NULL.
- NVL (Oracle) and COALESCE replace NULL with a default value.
- Always prefer explicit column lists and NULL handling in real-world queries.

---

[← Back to Learning Plan](../30-day-sql-plsql-learning-plan.md) | [Next: Day 2 →](./day02_filtering_sorting.md)
