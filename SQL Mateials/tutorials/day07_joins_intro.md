# Day 7: Introduction to Joins — Full Notes and Theory

---

## 1. Why Joins Matter

In a normalized database, data is split across tables. **hr.employees** holds employee rows and a **department_id**; **hr.departments** holds **department_id** and **department_name**. To show "employee name and department name" in one result, you must **combine** rows from both tables. That combination is done with a **join**: you specify how rows in one table match rows in the other (e.g., employees.department_id = departments.department_id). Joins are the core of relational querying and reporting.

- Without joins, you would have to run separate queries and match data in the application; joins let the database do this efficiently in one statement.
- The most common join is **INNER JOIN**: only rows that **match** in both tables are returned. Employees with no department (or department_id not in hr.departments) are excluded.
- All examples use only **hr.employees** and **hr.departments** (and **hr.locations** only where mentioned for chaining).

---

## 2. INNER JOIN Syntax and Semantics

**INNER JOIN** returns only rows where the **join condition** is true. You list the two tables and the condition that links them (usually equality on a key column).

**Syntax:**

```sql
SELECT column_list
FROM table1
INNER JOIN table2 ON table1.column = table2.column;
```

The **ON** clause defines the relationship. For each row in table1, the database finds rows in table2 that satisfy the condition; only matching pairs are returned. If a row in table1 has no match in table2 (e.g., employee with department_id not in departments), that row does not appear.

---

## 3. Joining hr.employees and hr.departments

The natural link is **department_id**: employees have department_id, and departments have department_id as their primary key.

**Example:**

```sql
SELECT e.employee_id, e.first_name, e.last_name, e.department_id, d.department_name
FROM hr.employees e
INNER JOIN hr.departments d ON e.department_id = d.department_id;
```

- **e** and **d** are **table aliases**. They shorten the table names and are used to qualify column names (e.first_name, d.department_name).
- **e.department_id = d.department_id** is the **join condition**. Only employees whose department_id exists in hr.departments are returned.

---

## 4. Table Aliases and Qualifying Columns

**Aliases** (e.g., **e** for employees, **d** for departments) are used in the **FROM/JOIN** and then in **SELECT** and **WHERE**. They make the query shorter and unambiguous when the same column name exists in more than one table (e.g., department_id in both employees and departments).

**Rule:** If a column name appears in more than one table in the query, you **must** qualify it with the table (or alias) name, e.g. **e.department_id**, **d.department_id**. Otherwise the database raises "column ambiguously defined."

**Example:**

```sql
SELECT e.employee_id, e.first_name, e.last_name, e.salary, d.department_id, d.department_name
FROM hr.employees e
INNER JOIN hr.departments d ON e.department_id = d.department_id;
```

---

## 5. Selecting from Both Tables and Filtering

You can list any columns from either table in the SELECT list (with alias when needed). You can also add a **WHERE** clause to filter the joined result (e.g., only Sales department).

**Example: Employees in 'Sales' department**

```sql
SELECT e.employee_id, e.first_name, e.last_name, d.department_name
FROM hr.employees e
INNER JOIN hr.departments d ON e.department_id = d.department_id
WHERE d.department_name = 'Sales';
```

String comparison in Oracle is case-sensitive; use UPPER(d.department_name) = 'SALES' if you want case-insensitive matching.

---

## 6. Multiple Joins (Chaining Tables)

You can chain joins to include more tables. For example, to show employee, department, and **location**, you join employees → departments, then departments → locations (if hr.locations exists in your schema):

```sql
SELECT e.employee_id, e.first_name, d.department_name, l.city
FROM hr.employees e
INNER JOIN hr.departments d ON e.department_id = d.department_id
INNER JOIN hr.locations l ON d.location_id = l.location_id;
```

The same pattern applies for other tables (e.g., jobs). When the schema does not have locations, practice with employees and departments only.

---

## 7. Aggregation with Joins (COUNT per Department)

After joining, you can use **GROUP BY** and aggregate functions. For example, count employees per department and show department name:

```sql
SELECT d.department_id, d.department_name, COUNT(e.employee_id) AS employee_count
FROM hr.employees e
INNER JOIN hr.departments d ON e.department_id = d.department_id
GROUP BY d.department_id, d.department_name;
```

Every non-aggregated column in the SELECT list must appear in the GROUP BY clause.

---

## 8. Summary Points

- **Joins** combine rows from two or more tables using a condition (e.g., department_id).
- **INNER JOIN** returns only matching rows; use **ON** to specify the join condition.
- Use **table aliases** and **qualify** column names when the same name exists in multiple tables.
- You can **filter** (WHERE) and **aggregate** (GROUP BY, COUNT, SUM) on the joined result. All examples use **hr.employees** and **hr.departments** only (plus locations only where applicable).

---

[← Day 6](./day06_single_table_queries.md) | [Back to Learning Plan](../30-day-sql-plsql-learning-plan.md) | [Next: Day 8 →](./day08_join_types.md)
