# Day 18 Assignment: Indexes

All exercises refer to **hr.employees** and **hr.departments**. Create indexes only if your environment allows (e.g. on a copy table or with proper privileges).

---

## Part 1: Practice Questions (With Answers and Explanations)

### Question 1
Write the SQL to **create an index** on **hr.employees(department_id)**. Name the index (e.g. idx_emp_dept).

**Answer:**

```sql
CREATE INDEX idx_emp_dept ON hr.employees(department_id);
```

**Explanation:** This supports queries that filter or join on department_id. The optimizer can use the index for WHERE department_id = ? or JOIN on department_id.

---

### Question 2
Write the SQL to create a **composite index** on **hr.employees** that would help a query filtering by **department_id** and **job_id** together (e.g. WHERE department_id = 50 AND job_id = 'ST_CLERK').

**Answer:**

```sql
CREATE INDEX idx_emp_dept_job ON hr.employees(department_id, job_id);
```

**Explanation:** Put the more selective or commonly used column first. The index can be used for (department_id), or (department_id, job_id). It is not used for WHERE job_id = ? alone (leading column is department_id).

---

### Question 3
Explain whether an index on **salary** would likely be **used** for the condition **salary > 5000** (assume many rows have salary > 5000). What if only a few rows have salary > 5000?

**Answer:** If **many** rows have salary > 5000, the optimizer may choose a **full table scan** because reading a large fraction of the table via the index can be more expensive than scanning the table once. If **few** rows have salary > 5000, an index on salary can be used for a range scan and look up only those rows, which is usually more efficient. The decision depends on statistics (table size, distribution, selectivity).

---

## Part 2: Self-Practice (No Answers)

1. Write **CREATE INDEX** for a query that filters by **hire_date** range (e.g. hire_date BETWEEN date1 AND date2).
2. In what situation might a **full table scan** be preferred over an index scan on hr.employees? (Consider table size and selectivity.)

---

## Part 3: Additional Practice — 20 Medium + 20 Hard Questions (With Hints)

Refer to **hr.employees** and **hr.departments**; create indexes only if your environment allows.

### 20 Medium Questions

1. **M1.** Create index on hr.employees(department_id). **Hint:** CREATE INDEX idx_emp_dept ON hr.employees(department_id);
2. **M2.** Create index on hr.employees(salary). **Hint:** CREATE INDEX idx_emp_sal ON hr.employees(salary);
3. **M3.** Create composite index (department_id, job_id). **Hint:** CREATE INDEX idx_dj ON hr.employees(department_id, job_id);
4. **M4.** Create index on hr.employees(hire_date). **Hint:** CREATE INDEX idx_hire ON hr.employees(hire_date);
5. **M5.** Create unique index on hr.employees(email). **Hint:** CREATE UNIQUE INDEX idx_email ON hr.employees(email);
6. **M6.** When would index on department_id help? **Hint:** WHERE department_id = ? or JOIN on department_id.
7. **M7.** Name an index meaningfully. **Hint:** idx_emp_dept, idx_employees_salary, etc.
8. **M8.** Create index on hr.departments(department_id) — usually PK already has one. **Hint:** CREATE INDEX ... or note PK index.
9. **M9.** Why composite (department_id, job_id) order? **Hint:** Leading column department_id used in many WHERE clauses.
10. **M10.** When might index on low-cardinality column not help? **Hint:** Very few distinct values (e.g. gender) with no other filter.
11. **M11.** Create index for ORDER BY hire_date. **Hint:** CREATE INDEX idx_hire ON hr.employees(hire_date);
12. **M12.** Drop an index by name. **Hint:** DROP INDEX index_name;
13. **M13.** What type of index is default in Oracle? **Hint:** B-tree.
14. **M14.** Index for WHERE salary > 5000. **Hint:** CREATE INDEX on salary; range scan possible.
15. **M15.** Why not index every column? **Hint:** Storage and DML cost; optimizer may not use all.
16. **M16.** Composite index (job_id, department_id) — which predicates can use it? **Hint:** job_id = ? or (job_id = ? AND department_id = ?); not department_id alone.
17. **M17.** Create index on hr.departments(location_id) if used in JOIN. **Hint:** CREATE INDEX idx_dept_loc ON hr.departments(location_id);
18. **M18.** What is a covering index? **Hint:** Index includes all columns needed by query; avoid table access.
19. **M19.** When does INSERT become slower? **Hint:** More indexes on table; each must be updated.
20. **M20.** Index for COUNT(*) WHERE department_id = 50. **Hint:** Index on department_id helps filter.

### 20 Hard Questions

1. **H1.** Design composite index for WHERE department_id = ? AND job_id = ? AND salary > ?. **Hint:** (department_id, job_id, salary) or (department_id, job_id) with salary for filter.
2. **H2.** When would full table scan be chosen over index? **Hint:** Large fraction of rows returned; small table; low selectivity.
3. **H3.** Create function-based index UPPER(last_name) for case-insensitive search. **Hint:** CREATE INDEX idx_upper_last ON hr.employees(UPPER(last_name));
4. **H4.** Explain index range scan for salary BETWEEN 5000 AND 10000. **Hint:** B-tree finds first key >= 5000 and scans until > 10000.
5. **H5.** Why might two separate indexes (department_id) and (job_id) be less efficient than one composite (department_id, job_id) for dept+job query? **Hint:** One index access vs two; composite can satisfy both.
6. **H6.** What is index skip scan? **Hint:** Oracle can use composite index when leading column is not in predicate but has few distinct values.
7. **H7.** Create index for ORDER BY department_id, salary DESC. **Hint:** CREATE INDEX idx_dept_sal ON hr.employees(department_id, salary DESC);
8. **H8.** When to avoid index on column that is always used with function (e.g. TRUNC(hire_date))? **Hint:** Function on column prevents index use; consider function-based index on TRUNC(hire_date).
9. **H9.** Monitor index usage (concept). **Hint:** USER_INDEXES; V$OBJECT_USAGE; or statistics.
10. **H10.** Partial index (Oracle: not standard) — concept: index only rows where condition. **Hint:** Some DBs support WHERE in index definition; Oracle has limited support.
11. **H11.** Composite index (manager_id, department_id) — for which query? **Hint:** WHERE manager_id = ? AND department_id = ? or manager_id = ?.
12. **H12.** Why unique index on email? **Hint:** Enforce uniqueness; fast lookup for login.
13. **H13.** Rebuild or coalesce index (concept). **Hint:** ALTER INDEX ... REBUILD; for fragmentation.
14. **H14.** Index on (department_id, hire_date) for "earliest hire per department." **Hint:** Supports ORDER BY department_id, hire_date and filter by department_id.
15. **H15.** When might optimizer choose full scan despite index? **Hint:** Statistics show large % of rows; index clustering factor poor.
16. **H16.** Create index for JOIN hr.employees e ON e.department_id = d.department_id. **Hint:** Index on employees(department_id).
17. **H17.** Bitmap index (concept): when? **Hint:** Low cardinality; data warehouse; read-heavy.
18. **H18.** Why not composite (salary, department_id) for WHERE department_id = 50? **Hint:** Leading column should be department_id for that predicate.
19. **H19.** Invisible index (Oracle): purpose. **Hint:** Test impact of dropping without actually dropping; make invisible first.
20. **H20.** List indexes on hr.employees. **Hint:** SELECT index_name, column_name FROM user_ind_columns WHERE table_name = 'EMPLOYEES';

---

[← Back to Learning Plan](../30-day-sql-plsql-learning-plan.md) | [Tutorial](../tutorials/day18_indexes.md)
