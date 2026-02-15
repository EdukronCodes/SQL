# Day 13: Set Operations — Full Notes and Theory

---

## 1. What Set Operations Do

**Set operations** combine the result sets of two (or more) SELECT statements into one result: **UNION** (all rows from both, duplicates removed), **UNION ALL** (all rows, duplicates kept), **INTERSECT** (rows in both), **MINUS** (rows in first but not in second; in standard SQL: EXCEPT). They require both queries to return the **same number of columns** and **compatible types**. All examples use **hr.employees** and **hr.departments** only.

- Use **UNION** to merge two lists and remove duplicates; use **UNION ALL** when duplicates are fine or you know there are none (often faster).
- Use **INTERSECT** to find common values (e.g., department_id in both employees and departments).
- Use **MINUS** to find values in the first set that are not in the second (e.g., departments with no employees).

---

## 2. UNION

**UNION** combines the two result sets and **removes duplicate** rows. Column count and types must match.

```sql
SELECT job_id FROM hr.employees WHERE department_id = 50
UNION
SELECT job_id FROM hr.employees WHERE department_id = 60;
```

Column names come from the first SELECT. Use aliases in the first query if you want specific names.

---

## 3. UNION ALL

**UNION ALL** does **not** remove duplicates; it simply concatenates the result sets. Use it when duplicates are acceptable or when you know there are no duplicates (faster than UNION because no deduplication).

```sql
SELECT employee_id, first_name, last_name FROM hr.employees WHERE department_id = 50
UNION ALL
SELECT employee_id, first_name, last_name FROM hr.employees WHERE department_id = 60;
```

---

## 4. INTERSECT

**INTERSECT** returns only rows that appear in **both** result sets.

```sql
SELECT department_id FROM hr.employees
INTERSECT
SELECT department_id FROM hr.departments;
```

This returns department_id values that exist in both tables (departments that have at least one employee and are in hr.departments).

---

## 5. MINUS (EXCEPT)

**MINUS** (Oracle) returns rows from the **first** query that are **not** in the second.

```sql
SELECT department_id FROM hr.departments
MINUS
SELECT department_id FROM hr.employees;
```

This returns department_id values that are in hr.departments but have no employees. Order of the two queries matters: first minus second.

---

## 6. Same Number and Compatible Types

All set operations require:

- **Same number of columns** in both SELECTs.
- **Compatible data types** in corresponding positions (e.g., NUMBER with NUMBER, VARCHAR2 with VARCHAR2).

Use **ORDER BY** only at the **end** of the full statement, by column position (e.g., ORDER BY 1) or by alias from the first query.

---

## 7. Summary Points

- **UNION** = combine and remove duplicates; **UNION ALL** = combine and keep duplicates.
- **INTERSECT** = rows in both; **MINUS** = rows in first but not in second.
- Both queries must have the same number of columns and compatible types. All examples use **hr.employees** and **hr.departments** only.

---

[← Day 12](./day12_correlated_subqueries.md) | [Back to Learning Plan](../30-day-sql-plsql-learning-plan.md) | [Next: Day 14 →](./day14_window_ranking.md)
