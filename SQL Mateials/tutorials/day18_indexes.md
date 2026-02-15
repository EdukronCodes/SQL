# Day 18: Indexes — Full Notes and Theory

---

## 1. What Indexes Are and When They Help

An **index** is a structure that helps the database find rows quickly by one or more column values (e.g., department_id, salary). Oracle’s default is the **B-tree** index: keys are kept in sorted order, supporting equality and range lookups. Indexes **speed up** queries that filter, join, or sort on the indexed columns but **cost** storage and slow down INSERT/UPDATE/DELETE because the index must be updated. All examples refer to **hr.employees** and **hr.departments**.

- **When indexes help:** WHERE on indexed column(s), JOIN on indexed column(s), ORDER BY indexed column(s), GROUP BY indexed column(s). The optimizer chooses an index scan when it is cheaper than a full table scan.
- **When they don’t:** Very small tables; very low cardinality with no other selective condition; heavy DML; queries that return a large fraction of the table.

---

## 2. B-tree Index and CREATE INDEX

**B-tree** keeps key values in sorted order. Create an index with **CREATE INDEX** on the column(s) you query often:

```sql
CREATE INDEX idx_emp_dept ON hr.employees(department_id);
CREATE INDEX idx_emp_salary ON hr.employees(salary);
CREATE INDEX idx_emp_hire ON hr.employees(hire_date);
```

Use a **unique index** to enforce uniqueness: `CREATE UNIQUE INDEX idx_emp_email ON hr.employees(email);`

---

## 3. Composite Index Column Order

In a **composite index**, the **order** of columns matters. Put the most selective or most frequently used in the predicate **first**:

```sql
CREATE INDEX idx_emp_dept_job ON hr.employees(department_id, job_id);
```

This can be used for WHERE department_id = ? or WHERE department_id = ? AND job_id = ?, but typically **not** for WHERE job_id = ? alone (the leading column is needed for an efficient range scan in Oracle).

---

## 4. Monitoring and Best Practices

Query **USER_INDEXES**, **USER_IND_COLUMNS**, and (if available) **V$OBJECT_USAGE** or statistics to see which indexes exist and whether they are used. **Best practices:** Index foreign keys and columns used in WHERE and JOIN; prefer composite indexes for common multi-column conditions; avoid over-indexing; consider function-based or partial indexes for special cases.

---

## 5. Summary Points

- **B-tree** indexes support equality and range lookups; **composite** index column order affects which predicates can use the index.
- Create indexes on **hr.employees** (e.g., department_id, salary, hire_date) where queries benefit; monitor usage and drop unused indexes. All examples use **hr.employees** and **hr.departments**.

---

[← Day 17](./day17_normalization.md) | [Back to Learning Plan](../30-day-sql-plsql-learning-plan.md) | [Next: Day 19 →](./day19_views.md)
