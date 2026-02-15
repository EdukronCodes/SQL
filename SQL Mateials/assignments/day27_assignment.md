# Day 27 Assignment: Performance Tuning

All exercises use **hr.employees** and **hr.departments**.

---

## Part 1: Practice Questions (With Answers and Explanations)

### Question 1
Get the **execution plan** for a query that **joins** hr.employees and hr.departments on department_id and selects employee_id, first_name, department_name. Use EXPLAIN PLAN and DBMS_XPLAN.DISPLAY (or your tool's equivalent).

**Answer:**

```sql
EXPLAIN PLAN FOR
SELECT e.employee_id, e.first_name, d.department_name
FROM hr.employees e
INNER JOIN hr.departments d ON e.department_id = d.department_id;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
```

**Explanation:** EXPLAIN PLAN FOR stores the plan for the following statement. DBMS_XPLAN.DISPLAY returns the plan in a readable form. Look for join method (NESTED LOOPS, HASH JOIN, etc.) and access paths (INDEX vs FULL TABLE SCAN).

---

### Question 2
Assume an index **idx_emp_dept** exists on **hr.employees(department_id)**. Add a **hint** to the same join query to suggest use of that index on the employees table (alias e).

**Answer:**

```sql
SELECT /*+ INDEX(e idx_emp_dept) */ e.employee_id, e.first_name, d.department_name
FROM hr.employees e
INNER JOIN hr.departments d ON e.department_id = d.department_id;
```

**Explanation:** The hint INDEX(e index_name) tells the optimizer to use the named index on table with alias e. Use hints only when you have evidence the default plan is wrong.

---

### Question 3
Rewrite a **correlated subquery** that returns "employees earning more than their department average" as a **join** (e.g. join employees to a subquery that computes department average). Compare the two approaches: which is usually more efficient and why?

**Answer (join version):**

```sql
SELECT e.employee_id, e.first_name, e.salary, e.department_id
FROM hr.employees e
INNER JOIN (SELECT department_id, AVG(salary) AS avg_sal FROM hr.employees GROUP BY department_id) d
  ON e.department_id = d.department_id AND e.salary > d.avg_sal;
```

**Explanation:** The correlated subquery runs the inner query once per row. The join computes department averages once (grouped subquery) and then joins, so the optimizer can use a single scan and hash/broadcast. The join is usually more efficient and often gets a better execution plan.

---

## Part 2: Self-Practice (No Answers)

1. Run **EXPLAIN PLAN** for a query that **aggregates** (e.g. SUM(salary) GROUP BY department_id) on hr.employees. Note whether you see a full table scan or index usage.
2. In a PL/SQL loop over employee IDs, use a **bind variable** in the SELECT (e.g. WHERE employee_id = :id) instead of concatenating the ID into the SQL string. Show the EXECUTE IMMEDIATE ... USING syntax.

---

## Part 3: Additional Practice — 20 Medium + 20 Hard Questions (With Hints)

All use **hr.employees** and **hr.departments**.

### 20 Medium Questions

1. **M1.** Get EXPLAIN PLAN for SELECT * FROM hr.employees WHERE department_id = 50. **Hint:** EXPLAIN PLAN FOR SELECT ...; SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
2. **M2.** Add hint /*+ FULL(e) */ to force full table scan on employees (alias e). **Hint:** SELECT /*+ FULL(e) */ ... FROM hr.employees e WHERE ...
3. **M3.** Use bind variable in EXECUTE IMMEDIATE: SELECT salary FROM hr.employees WHERE employee_id = :1 INTO v USING v_id. **Hint:** EXECUTE IMMEDIATE 'SELECT salary FROM hr.employees WHERE employee_id = :1' INTO v USING v_id;
4. **M4.** Run EXPLAIN PLAN for join of employees and departments. **Hint:** EXPLAIN PLAN FOR SELECT ... FROM hr.employees e JOIN hr.departments d ON e.department_id = d.department_id;
5. **M5.** Hint INDEX(e index_name) to use index on employees. **Hint:** SELECT /*+ INDEX(e idx_emp_dept) */ ... FROM hr.employees e WHERE e.department_id = 50;
6. **M6.** In loop FOR id IN 100..110 use EXECUTE IMMEDIATE ... USING id (not concatenate). **Hint:** EXECUTE IMMEDIATE 'SELECT first_name FROM hr.employees WHERE employee_id = :1' INTO v USING id;
7. **M7.** What does full table scan mean? **Hint:** Database reads every row of the table.
8. **M8.** Query that aggregates SUM(salary) GROUP BY department_id; get plan. **Hint:** EXPLAIN PLAN FOR SELECT department_id, SUM(salary) FROM hr.employees GROUP BY department_id;
9. **M9.** Use USE_NL(e d) hint for nested loops join. **Hint:** SELECT /*+ USE_NL(e d) */ ... FROM hr.employees e JOIN hr.departments d ON ...
10. **M10.** Use USE_HASH(e d) for hash join. **Hint:** SELECT /*+ USE_HASH(e d) */ ...
11. **M11.** Static SQL in PL/SQL: SELECT salary INTO v FROM hr.employees WHERE employee_id = p_id. Is p_id bound? **Hint:** Yes; static SQL uses bind for variables.
12. **M12.** List columns that might benefit from index for WHERE on hr.employees. **Hint:** department_id, job_id, employee_id (PK), hire_date.
13. **M13.** EXPLAIN PLAN for SELECT with ORDER BY salary DESC. **Hint:** May show SORT ORDER BY; index on salary could avoid sort.
14. **M14.** Avoid N+1: one query that gets employees and department_name (join). **Hint:** SELECT e.*, d.department_name FROM hr.employees e JOIN hr.departments d ON e.department_id = d.department_id;
15. **M15.** BULK COLLECT into collection instead of row-by-row FETCH. **Hint:** OPEN c; FETCH c BULK COLLECT INTO v_ids, v_names LIMIT 100;
16. **M16.** Hint LEADING(d e) to join departments first then employees. **Hint:** SELECT /*+ LEADING(d e) */ ... FROM hr.departments d JOIN hr.employees e ON ...
17. **M17.** Why concatenating v_id into SQL string is bad. **Hint:** Hard parse per value; SQL injection risk; no plan reuse.
18. **M18.** Run plan for subquery: employees earning more than department avg. **Hint:** EXPLAIN PLAN FOR SELECT ... FROM hr.employees e WHERE salary > (SELECT AVG(salary) FROM hr.employees WHERE department_id = e.department_id);
19. **M19.** Same query as join; compare plan. **Hint:** Join version often has HASH JOIN or single scan of aggregated subquery.
20. **M20.** SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY(format => 'BASIC')). **Hint:** Shorter plan output.

### 20 Hard Questions

1. **H1.** Rewrite correlated subquery "employees above department avg salary" as join; compare plans. **Hint:** JOIN (SELECT department_id, AVG(salary) avg_sal FROM hr.employees GROUP BY department_id) d ON e.department_id = d.department_id AND e.salary > d.avg_sal.
2. **H2.** Find expensive SQL: query V$SQL for elapsed_time or buffer_gets (if available). **Hint:** SELECT sql_id, elapsed_time, buffer_gets, sql_text FROM V$SQL WHERE ... ORDER BY elapsed_time DESC;
3. **H3.** Procedure with dynamic SQL and bind: pass department_id and return count. **Hint:** EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM hr.employees WHERE department_id = :1' INTO v_count USING p_dept_id;
4. **H4.** N+1 anti-pattern: loop over departments, for each SELECT employees. **Hint:** Instead: one query with join or GROUP BY.
5. **H5.** Use INDEX_COMBINE or multiple INDEX hints if multiple indexes (advanced). **Hint:** Depends on Oracle version; INDEX(e idx1 idx2) or bitmap.
6. **H6.** EXPLAIN PLAN for window function: RANK() OVER (PARTITION BY department_id ORDER BY salary DESC). **Hint:** May show WINDOW SORT; EXPLAIN PLAN FOR SELECT ..., RANK() OVER (...) FROM hr.employees;
7. **H7.** Gather statistics: EXEC DBMS_STATS.GATHER_TABLE_STATS('HR','EMPLOYEES'); then re-run plan. **Hint:** Ensures optimizer has current stats.
8. **H8.** Hint to force join order: ORDERED (tables in FROM order). **Hint:** SELECT /*+ ORDERED */ ... FROM hr.departments d, hr.employees e WHERE e.department_id = d.department_id;
9. **H9.** Avoid N+1 in PL/SQL: cursor that returns (department_id, employee list or count) in one query. **Hint:** SELECT department_id, COUNT(*) FROM hr.employees GROUP BY department_id; or cursor with join.
10. **H10.** Bind variable in IN list: WHERE employee_id IN (:1,:2,:3) USING id1, id2, id3. **Hint:** EXECUTE IMMEDIATE '... WHERE employee_id IN (:1,:2,:3)' INTO ... USING 100, 101, 102;
11. **H11.** Execution plan: what is "cost"? **Hint:** Optimizer's estimated cost (CPU, I/O); lower often better; compare relative.
12. **H12.** Full scan on small table may be better than index. **Hint:** When table is small or selectivity is high (many rows match).
13. **H13.** Use NO_INDEX hint to disable index. **Hint:** SELECT /*+ NO_INDEX(e idx_emp_dept) */ ... FROM hr.employees e ...
14. **H14.** Parallel hint: /*+ PARALLEL(e 4) */ for 4-way parallel scan (if licensed). **Hint:** Use only when appropriate for large tables.
15. **H15.** Explain: "hard parse" vs "soft parse". **Hint:** Hard parse: new SQL, full compile. Soft parse: reuse plan. Bind variables encourage soft parse.
16. **H16.** Query with UNION; get plan; note concatenation of row sources. **Hint:** EXPLAIN PLAN FOR SELECT ... UNION SELECT ...
17. **H17.** Procedure that builds dynamic IN list (e.g. department_id IN (10,20,30)) safely with binds. **Hint:** Use bind for each value or pass collection; EXECUTE IMMEDIATE with USING.
18. **H18.** Index on (department_id, job_id); query WHERE department_id = 50 AND job_id = 'SA_REP'. **Hint:** Composite index can be used for both predicates.
19. **H19.** Compare plan for SELECT * FROM hr.employees vs SELECT employee_id, first_name FROM hr.employees. **Hint:** Covering index could avoid table access if all columns in index.
20. **H20.** Identify "table access by index rowid" in plan. **Hint:** Index is used to get rowids; then table is accessed for remaining columns.

---

[← Back to Learning Plan](../30-day-sql-plsql-learning-plan.md) | [Tutorial](../tutorials/day27_performance_tuning.md)
