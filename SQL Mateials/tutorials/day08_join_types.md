# Day 8: All Join Types — Full Notes and Theory

---

## 1. Why Join Types Matter

**INNER JOIN** (Day 7) returns only rows that match in both tables. In practice you often need **all** rows from one side even when there is no match: for example, all employees (including those with no department) or all departments (including those with no employees). **Outer joins** (LEFT, RIGHT, FULL) and **self-joins** (same table twice) handle these cases. This tutorial covers all join types using **hr.employees** and **hr.departments** only.

- **LEFT OUTER JOIN:** All rows from the left table; matching rows from the right; non-matching right columns are NULL.
- **RIGHT OUTER JOIN:** All rows from the right table; matching rows from the left.
- **FULL OUTER JOIN:** All rows from both tables; missing matches show NULL on the other side.
- **SELF JOIN:** Join a table to itself (e.g., employee to manager in hr.employees).
- **CROSS JOIN:** Every row of one table with every row of the other (use sparingly).

---

## 2. LEFT OUTER JOIN (LEFT JOIN)

**LEFT OUTER JOIN** keeps **every row** from the **left** table. For each row, the database looks for a matching row in the right table on the join condition. If found, the right table’s columns are filled in; if not found, the right table’s columns are **NULL**.

**Example: All employees and their department name (including employees with no department):**

```sql
SELECT e.employee_id, e.first_name, e.last_name, d.department_name
FROM hr.employees e
LEFT OUTER JOIN hr.departments d ON e.department_id = d.department_id;
```

Employees with `department_id` NULL or with a department_id not in hr.departments still appear; `department_name` will be NULL for them.

---

## 3. RIGHT OUTER JOIN (RIGHT JOIN)

**RIGHT OUTER JOIN** keeps **every row** from the **right** table and matching rows from the left. Use it when you want "all departments" and optional employee data.

**Example: All departments and employee info (departments with no employees show NULL for employee columns):**

```sql
SELECT d.department_id, d.department_name, e.employee_id, e.first_name
FROM hr.employees e
RIGHT OUTER JOIN hr.departments d ON e.department_id = d.department_id;
```

You can achieve the same by swapping table order and using LEFT JOIN; choose whichever reads more clearly.

---

## 4. FULL OUTER JOIN

**FULL OUTER JOIN** returns **all rows** from **both** tables. Where there is a match, both sides are filled; where there is no match, the other side’s columns are NULL. Use it when you need "all employees and all departments" in one result set.

**Example:**

```sql
SELECT e.employee_id, e.first_name, d.department_id, d.department_name
FROM hr.employees e
FULL OUTER JOIN hr.departments d ON e.department_id = d.department_id;
```

---

## 5. CROSS JOIN (Concept)

**CROSS JOIN** produces the **Cartesian product**: every row of the first table combined with every row of the second. There is **no ON** condition. Use only when you intentionally need all combinations (e.g., generating a grid). For hr.employees × hr.departments it is rarely needed in reporting.

```sql
SELECT e.employee_id, d.department_id FROM hr.employees e CROSS JOIN hr.departments d;
```

---

## 6. SELF JOIN (Employee to Manager)

A **self-join** is when you join a table to **itself**. In **hr.employees**, each row has a **manager_id** that points to another row in the same table. To show "employee name and manager name," you use two aliases (e.g., **e** for employee, **m** for manager) and join **e.manager_id = m.employee_id**.

**Example:**

```sql
SELECT e.employee_id, e.first_name AS emp_first, e.last_name AS emp_last,
       m.employee_id AS manager_id, m.first_name AS manager_first, m.last_name AS manager_last
FROM hr.employees e
LEFT JOIN hr.employees m ON e.manager_id = m.employee_id;
```

**LEFT JOIN** ensures employees with **no manager** (manager_id NULL) still appear with NULL for manager columns.

---

## 7. Handling NULL in Outer Joins

After a LEFT, RIGHT, or FULL join, columns from the non-matching side are **NULL**. You can use **NVL** or **COALESCE** for display (e.g., show 'No Department' instead of NULL):

```sql
SELECT e.employee_id, e.first_name, COALESCE(d.department_name, 'No Department') AS department_name
FROM hr.employees e
LEFT JOIN hr.departments d ON e.department_id = d.department_id;
```

To **filter** for "no match" (e.g., employees with no department), use **WHERE** on the right table’s key **IS NULL**:

```sql
SELECT e.employee_id, e.first_name
FROM hr.employees e
LEFT JOIN hr.departments d ON e.department_id = d.department_id
WHERE d.department_id IS NULL;
```

---

## 8. When to Use Each Type

| Join type | Use when |
|-----------|----------|
| **INNER** | You only want rows that have a match in both tables. |
| **LEFT** | You want all rows from the left table and optional match from the right. |
| **RIGHT** | You want all rows from the right table and optional match from the left. |
| **FULL** | You want all rows from both tables. |
| **SELF** | Rows in the same table are related (e.g., manager). |
| **CROSS** | You need every combination (use sparingly). |

---

## 9. Summary Points

- **LEFT JOIN:** All from left; match from right; right is NULL when no match.
- **RIGHT JOIN:** All from right; match from left.
- **FULL JOIN:** All from both; NULL where no match.
- **SELF JOIN:** Same table twice with different aliases (e.g., employee and manager).
- Use **WHERE right.key IS NULL** to find rows with no match after a LEFT join. Use **COALESCE/NVL** for display of NULLs.

---

[← Day 7](./day07_joins_intro.md) | [Back to Learning Plan](../30-day-sql-plsql-learning-plan.md) | [Next: Day 9 →](./day09_aggregation.md)
