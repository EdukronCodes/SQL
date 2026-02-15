# Day 30 Assignment: Capstone and Best Practices

All exercises use **hr.employees** and **hr.departments** only.

---

## Part 1: Practice Questions (With Answers and Explanations)

### Question 1
Build a procedure **department_summary(p_dept_id)** that returns (e.g. via OUT parameters or DBMS_OUTPUT) the following for the given department: **headcount**, **total salary**, **min hire_date**, **max hire_date**. Use hr.employees and optionally hr.departments for the department name.

**Answer:**

```sql
CREATE OR REPLACE PROCEDURE department_summary(
  p_dept_id   IN  hr.departments.department_id%TYPE,
  p_count     OUT NUMBER,
  p_total_sal OUT NUMBER,
  p_min_hire  OUT DATE,
  p_max_hire  OUT DATE
) IS
BEGIN
  SELECT COUNT(*), NVL(SUM(salary),0), MIN(hire_date), MAX(hire_date)
  INTO p_count, p_total_sal, p_min_hire, p_max_hire
  FROM hr.employees
  WHERE department_id = p_dept_id;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    p_count := 0; p_total_sal := 0; p_min_hire := NULL; p_max_hire := NULL;
END;
/

-- Call example:
DECLARE
  v_cnt NUMBER; v_sal NUMBER; v_min DATE; v_max DATE;
BEGIN
  department_summary(50, v_cnt, v_sal, v_min, v_max);
  DBMS_OUTPUT.PUT_LINE('Count: ' || v_cnt || ', Total: ' || v_sal || ', Min hire: ' || v_min || ', Max hire: ' || v_max);
END;
/
```

**Explanation:** One SELECT INTO computes all four aggregates for the given department_id. OUT parameters return the values. For an empty department, COUNT returns 0 and MIN/MAX are NULL; SUM is NULL so NVL gives 0. NO_DATA_FOUND is not raised for aggregate-only queries; handle empty department in the caller if needed.

---

### Question 2
Create a **view** that assigns a **salary band** (e.g. Low/Medium/High) to each employee using CASE on salary, and a **procedure** that selects from this view (or from hr.employees with the same logic) and prints or returns a simple "salary band report" (e.g. band and count). The procedure should be callable by a user who has EXECUTE on it but may not have direct SELECT on the base table (definer rights).

**Answer (view + procedure):**

```sql
CREATE OR REPLACE VIEW emp_salary_band AS
SELECT employee_id, first_name, last_name, salary,
  CASE WHEN salary < 5000 THEN 'Low' WHEN salary < 12000 THEN 'Medium' ELSE 'High' END AS salary_band
FROM hr.employees;

CREATE OR REPLACE PROCEDURE report_salary_bands IS
  CURSOR c IS SELECT salary_band, COUNT(*) AS cnt FROM emp_salary_band GROUP BY salary_band;
BEGIN
  FOR rec IN c LOOP
    DBMS_OUTPUT.PUT_LINE(rec.salary_band || ': ' || rec.cnt);
  END LOOP;
END;
/
```

**Explanation:** The view encapsulates the band logic. The procedure runs with definer rights (default), so it uses the owner's privileges to read the view. Grant EXECUTE on the procedure to users; they get the report without direct table access.

---

## Part 2: Self-Practice (No Answers)

1. **Design** an **audit trigger** for **hr.employees** that logs changes to salary and department_id (old and new values, user, timestamp) into an audit table. List the trigger event, level (row/statement), and the audit table columns.
2. Write **one complex report query** that uses: join (employees + departments), aggregation (COUNT, SUM per department), a **window function** (e.g. rank by salary within department), and **filtering** (e.g. only departments with more than 2 employees). Combine these in a single SELECT (using subqueries/CTEs as needed).

---

## Part 3: Additional Practice — 20 Medium + 20 Hard Questions (With Hints)

All use **hr.employees** and **hr.departments** only.

### 20 Medium Questions

1. **M1.** Build procedure department_summary(p_dept_id) with OUT: headcount, total_salary. **Hint:** SELECT COUNT(*), NVL(SUM(salary),0) INTO p_count, p_total FROM hr.employees WHERE department_id = p_dept_id;
2. **M2.** Create view: employee_id, first_name, last_name, department_name (join). **Hint:** CREATE VIEW v_emp_dept AS SELECT e.employee_id, e.first_name, e.last_name, d.department_name FROM hr.employees e JOIN hr.departments d ON e.department_id = d.department_id;
3. **M3.** Function get_department_name(p_dept_id) RETURN VARCHAR2. **Hint:** SELECT department_name INTO v FROM hr.departments WHERE department_id = p_dept_id; RETURN v; EXCEPTION WHEN NO_DATA_FOUND THEN RETURN NULL;
4. **M4.** Procedure that prints (DBMS_OUTPUT) headcount and total salary for a department. **Hint:** Get count and sum; DBMS_OUTPUT.PUT_LINE('Count: ' || v_cnt || ', Total: ' || v_total);
5. **M5.** View with salary_band: CASE WHEN salary < 5000 THEN 'Low' ... **Hint:** CREATE VIEW v_emp_band AS SELECT *, CASE WHEN salary < 5000 THEN 'Low' WHEN salary < 12000 THEN 'Medium' ELSE 'High' END AS salary_band FROM hr.employees;
6. **M6.** Use p_ for parameters, v_ for variables in one procedure. **Hint:** p_dept_id IN NUMBER, v_count NUMBER;
7. **M7.** Handle NO_DATA_FOUND in procedure that SELECTs one row. **Hint:** EXCEPTION WHEN NO_DATA_FOUND THEN ... (set defaults or raise).
8. **M8.** RAISE_APPLICATION_ERROR(-20001, 'Invalid department') when department_id not in hr.departments. **Hint:** SELECT COUNT(*) INTO v FROM hr.departments WHERE department_id = p_dept_id; IF v = 0 THEN RAISE_APPLICATION_ERROR(-20001, 'Invalid department');
9. **M9.** Procedure list_emp_by_dept(p_dept_id) with cursor FOR loop. **Hint:** CURSOR c IS SELECT first_name, last_name FROM hr.employees WHERE department_id = p_dept_id; FOR rec IN c LOOP ...
10. **M10.** Function employee_count(p_dept_id) RETURN NUMBER. **Hint:** SELECT COUNT(*) INTO v FROM hr.employees WHERE department_id = p_dept_id; RETURN v;
11. **M11.** Document procedure: comment at top with purpose and parameters. **Hint:** -- Purpose: Returns headcount and total salary for department. -- p_dept_id: department ID
12. **M12.** Create view that excludes salary (for security). **Hint:** SELECT employee_id, first_name, last_name, department_id, job_id, hire_date FROM hr.employees;
13. **M13.** Procedure department_summary with 4 OUT: count, total_sal, min_hire, max_hire. **Hint:** SELECT COUNT(*), NVL(SUM(salary),0), MIN(hire_date), MAX(hire_date) INTO ... FROM hr.employees WHERE department_id = p_dept_id;
14. **M14.** Call department_summary(50, v_c, v_s, v_min, v_max); print all. **Hint:** DECLARE v_c NUMBER; v_s NUMBER; ... BEGIN department_summary(50, v_c, v_s, v_min, v_max); DBMS_OUTPUT.PUT_LINE(...); END;
15. **M15.** Trigger (design): AFTER UPDATE OF salary ON hr.employees FOR EACH ROW; insert into audit. **Hint:** Log :OLD.salary, :NEW.salary, :NEW.employee_id, SYSDATE.
16. **M16.** Use get_department_name in SELECT: SELECT employee_id, get_department_name(department_id) FROM hr.employees. **Hint:** Function in SELECT list.
17. **M17.** Naming: procedure raise_salary (action), function get_department_name (result). **Hint:** Verbs for procedures, get_/compute_ for functions.
18. **M18.** In WHEN OTHERS log SQLERRM then RAISE. **Hint:** WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM); RAISE;
19. **M19.** View: department_id, department_name, employee_count, total_salary (join + group). **Hint:** SELECT d.department_id, d.department_name, COUNT(e.employee_id), NVL(SUM(e.salary),0) FROM hr.departments d LEFT JOIN hr.employees e ON e.department_id = d.department_id GROUP BY d.department_id, d.department_name;
20. **M20.** Procedure report_salary_bands: select from view with salary_band, GROUP BY salary_band, count. **Hint:** CURSOR c IS SELECT salary_band, COUNT(*) FROM v_emp_band GROUP BY salary_band; FOR rec IN c LOOP DBMS_OUTPUT.PUT_LINE(rec.salary_band || ': ' || rec.cnt); END LOOP;

### 20 Hard Questions

1. **H1.** End-to-end: create view (emp+dept name), function (get_department_name), procedure (department_summary), trigger (audit salary). **Hint:** Build all four; ensure they use only hr.employees and hr.departments (and audit table).
2. **H2.** Complex report: join e and d, GROUP BY department, COUNT and SUM; add RANK() OVER (PARTITION BY department_id ORDER BY salary DESC); filter HAVING COUNT(*) > 2. **Hint:** Use CTE: WITH base AS (SELECT e.*, d.department_name, COUNT(*) OVER (PARTITION BY e.department_id) cnt, RANK() OVER (PARTITION BY e.department_id ORDER BY e.salary DESC) rnk FROM hr.employees e JOIN hr.departments d ON e.department_id = d.department_id) SELECT * FROM base WHERE cnt > 2;
3. **H3.** Procedure that returns REF CURSOR (employee_id, first_name, department_name) for a given department_id. **Hint:** OPEN p_rc FOR SELECT e.employee_id, e.first_name, d.department_name FROM hr.employees e JOIN hr.departments d ON e.department_id = d.department_id WHERE e.department_id = p_dept_id;
4. **H4.** Audit trigger design: table emp_audit (audit_id, employee_id, column_name, old_val, new_val, changed_by, changed_at). **Hint:** Trigger AFTER UPDATE ON hr.employees FOR EACH ROW; insert one row per column changed (salary, department_id).
5. **H5.** View that shows employees with salary above department average (join to avg subquery). **Hint:** SELECT e.* FROM hr.employees e JOIN (SELECT department_id, AVG(salary) a FROM hr.employees GROUP BY department_id) d ON e.department_id = d.department_id AND e.salary > d.a;
6. **H6.** Procedure with default: department_summary(p_dept_id DEFAULT 50). **Hint:** Call without argument uses 50.
7. **H7.** Error handling: in department_summary if no rows, set OUT to 0 and NULL for dates (not NO_DATA_FOUND for aggregate query). **Hint:** Aggregate query returns one row; handle empty department: COUNT=0, total=0, min/max=NULL.
8. **H8.** Document "Caller must commit" vs "Procedure commits" for a procedure. **Hint:** Comment in header.
9. **H9.** One query: department_name, job_id, headcount, total_salary, and rank of (headcount) within department. **Hint:** Use RANK() OVER (PARTITION BY department_id ORDER BY headcount DESC) in subquery after join and group.
10. **H10.** Create role hr_report; grant SELECT on views only (no base tables). **Hint:** GRANT SELECT ON v_emp_dept, v_dept_summary TO hr_report;
11. **H11.** Function that returns BOOLEAN: department_has_employees(p_dept_id). **Hint:** RETURN (SELECT COUNT(*) FROM hr.employees WHERE department_id = p_dept_id) > 0; call from PL/SQL only.
12. **H12.** Procedure that updates salary and logs to audit table in same procedure (no trigger). **Hint:** UPDATE hr.employees SET salary = ... WHERE employee_id = p_id; INSERT INTO audit_table VALUES (...); COMMIT or not.
13. **H13.** Combine view (salary band) and procedure (report by band): procedure selects from view, groups by band. **Hint:** Procedure: FOR rec IN (SELECT salary_band, COUNT(*) c FROM v_emp_band GROUP BY salary_band) LOOP ...
14. **H14.** Best practice: index on hr.employees(department_id) for department_summary and list_emp_by_dept. **Hint:** CREATE INDEX idx_emp_dept ON hr.employees(department_id);
15. **H15.** README: list objects (view v_emp_dept, procedure department_summary, function get_department_name), purpose, tables used. **Hint:** Short markdown or comment block.
16. **H16.** Procedure that calls get_department_name and employee_count for same department_id; print both. **Hint:** v_name := get_department_name(50); v_cnt := employee_count(50); DBMS_OUTPUT.PUT_LINE(v_name || ': ' || v_cnt);
17. **H17.** Trigger to prevent salary decrease; call RAISE_APPLICATION_ERROR in BEFORE UPDATE. **Hint:** WHEN (NEW.salary < OLD.salary) RAISE_APPLICATION_ERROR(-20002, 'No decrease');
18. **H18.** One complex SELECT: join, WHERE department_id IN (SELECT department_id FROM hr.employees GROUP BY department_id HAVING COUNT(*) > 2), window RANK(), and aggregation in outer layer. **Hint:** CTE with join and filter; outer with RANK and GROUP BY or filter.
19. **H19.** Naming consistency: all procedures verb_noun (raise_salary, list_employees), functions get_/has_/count_. **Hint:** Establish and follow convention.
20. **H20.** Capstone checklist: view created, procedure with OUT params, function used in SQL, trigger on backup table, all use hr.employees/hr.departments only. **Hint:** Verify each object and that no other tables are referenced.

---

[← Back to Learning Plan](../30-day-sql-plsql-learning-plan.md) | [Tutorial](../tutorials/day30_capstone_best_practices.md)
