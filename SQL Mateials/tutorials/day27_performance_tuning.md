# Day 27: Performance Tuning — Full Notes and Theory

---

## 1. Why Performance Tuning Matters

Slow queries and PL/SQL blocks affect user experience and system load. **Performance tuning** involves understanding how the database executes SQL (execution plan), when to use indexes vs full scans, how to avoid unnecessary work (e.g. N+1 queries), and how to write stable, efficient SQL. All examples use **hr.employees** and **hr.departments**.

- **Execution plan** — Shows tables, access paths (index vs full scan), join methods, and cost.
- **Bind variables** — Reduce hard parses and improve scalability.
- **Avoid N+1** — One query that gets all needed data (join or bulk) instead of one query per row.

---

## 2. Execution Plan (EXPLAIN PLAN)

The **execution plan** shows how the database will (or did) execute a query. In Oracle:

```sql
EXPLAIN PLAN FOR
SELECT e.employee_id, e.first_name, d.department_name
FROM hr.employees e
INNER JOIN hr.departments d ON e.department_id = d.department_id;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
```

Use it to see:
- **Full table scan** vs **index** access
- **Join order** and join method (nested loops, hash join, merge join)
- **Sorts** and **aggregations**

Interpret the plan from inside out (or top to bottom in some tools): leaf nodes are table/index access; parent nodes are joins, filters, sorts.

---

## 3. Full Table Scan vs Index

- **Full table scan** — Read every row of the table. Can be best for small tables or when a large fraction of rows is returned (e.g. most employees in one department). No index used.
- **Index scan** — Use an index to find rowids (by key or range), then access the table for remaining columns. Prefer when a **small fraction** of rows is returned and the index is **selective** (e.g. WHERE employee_id = 100, or WHERE department_id = 50 with many departments).

The optimizer chooses based on statistics (table and index), selectivity, and cost. Ensure statistics are up to date (DBMS_STATS).

---

## 4. Join Order

The order in which tables are joined affects cost (which table is the “driver,” which is probed). The optimizer usually chooses the order. You can influence it with **hints** (e.g. LEADING, ORDERED) or by writing the query so the optimizer has good statistics and selectivity (e.g. filter early). For hr.employees and hr.departments, joining on department_id with indexes on both sides typically gives an efficient plan.

---

## 5. Hint Syntax (/*+ */)

**Hints** are comments that suggest access path or join order. Place **immediately after SELECT** (no space before +):

```sql
SELECT /*+ INDEX(e idx_emp_dept) */ e.employee_id, e.first_name
FROM hr.employees e
WHERE e.department_id = 50;
```

Use hints **only when** the optimizer choice is wrong and you have evidence (e.g. from execution plan and stats). Overuse can backfire when data or statistics change.

---

## 6. Common Hints (INDEX, FULL, USE_NL, USE_HASH)

- **INDEX(table_alias index_name)** — Use this index on the table.
- **FULL(table_alias)** — Full table scan on this table.
- **USE_NL(table1 table2)** — Nested loops join between the two tables.
- **USE_HASH(table1 table2)** — Hash join.
- **LEADING(table1 table2)** — Join in this order (table1 first).

Example: force use of index on department_id:

```sql
SELECT /*+ INDEX(e idx_emp_dept) */ e.employee_id, e.first_name, d.department_name
FROM hr.employees e
INNER JOIN hr.departments d ON e.department_id = d.department_id;
```

---

## 7. Identifying Expensive SQL on hr.employees

Use **AWR** (Automatic Workload Repository), **Statspack**, or **V$SQL** to find queries with high elapsed time, buffer gets, or disk reads. Then run **EXPLAIN PLAN** for those queries and optimize: add or drop indexes, rewrite (e.g. correlated subquery to join), use bind variables, reduce round-trips.

---

## 8. Bind Variables

Use **bind variables** in application and PL/SQL so the same SQL text is reused; this avoids hard parses and reduces latch contention:

```sql
-- In PL/SQL
EXECUTE IMMEDIATE 'SELECT salary FROM hr.employees WHERE employee_id = :1'
  INTO v_sal USING v_emp_id;
```

In a loop over employee IDs, use **:1** (or named binds) instead of concatenating IDs into the string. Static SQL in PL/SQL (e.g. SELECT salary FROM hr.employees WHERE employee_id = p_id) automatically uses binds for variables.

---

## 9. Avoiding N+1 in PL/SQL

**N+1** means one query to get a list (e.g. departments) and then **one query per row** (e.g. employees per department). This is inefficient. Prefer:

- **One query with a join** — e.g. SELECT e.*, d.department_name FROM hr.employees e JOIN hr.departments d ON ...
- **BULK COLLECT** — Fetch many rows at once into collections instead of row-by-row.
- **Single query with cursor** that fetches all needed data, or a query that returns aggregated data (e.g. count per department in one SELECT) instead of querying inside a loop per department.

---

## 10. Best Practices and Summary

- Run **EXPLAIN PLAN** for slow queries; look for full scans on large tables and expensive joins.
- Use **bind variables** everywhere for user or loop-driven values.
- Prefer **set-based** SQL (join, aggregation) over row-by-row processing in PL/SQL when possible.
- Use hints sparingly and document why.

**Summary:** Use execution plans to understand and improve query performance. Prefer indexes for selective filters; use bind variables; avoid N+1 by joining or bulk operations. Apply these to queries on hr.employees and hr.departments for consistent, scalable performance.

---

[← Day 26](./day26_transactions.md) | [Back to Learning Plan](../30-day-sql-plsql-learning-plan.md) | [Next: Day 28 →](./day28_security.md)
