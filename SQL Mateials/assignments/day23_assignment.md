# Day 23 Assignment: Functions

All exercises use **hr.employees** and **hr.departments**. Create functions in your schema or HR.

---

## Part 1: Practice Questions (With Answers and Explanations)

### Question 1
Create a **function** that takes **department_id** and returns **department_name** from hr.departments. Handle NO_DATA_FOUND (return NULL or raise). Name it (e.g. get_department_name).

**Answer:**

```sql
CREATE OR REPLACE FUNCTION get_department_name(p_dept_id IN hr.departments.department_id%TYPE)
RETURN hr.departments.department_name%TYPE IS
  v_name hr.departments.department_name%TYPE;
BEGIN
  SELECT department_name INTO v_name FROM hr.departments WHERE department_id = p_dept_id;
  RETURN v_name;
EXCEPTION
  WHEN NO_DATA_FOUND THEN RETURN NULL;
END;
/
```

**Explanation:** SELECT INTO gets the name; RETURN the variable. If no row exists, NO_DATA_FOUND is raised and we return NULL. Use in SQL: SELECT get_department_name(50) FROM DUAL;

---

### Question 2
Create a **function** **employee_count(p_dept_id)** that returns the **number of employees** in that department. Use it in a SELECT list (e.g. SELECT employee_count(50) FROM DUAL).

**Answer:**

```sql
CREATE OR REPLACE FUNCTION employee_count(p_dept_id IN hr.departments.department_id%TYPE)
RETURN NUMBER IS
  v_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count FROM hr.employees WHERE department_id = p_dept_id;
  RETURN v_count;
END;
/

-- Usage:
SELECT employee_count(50) FROM DUAL;
```

**Explanation:** COUNT(*) into v_count, then RETURN. The function can be called in SQL because it has no OUT parameters and does not modify database state (in simple form).

---

### Question 3
Use your **get_department_name** function in a **SELECT** from hr.employees: show employee_id, first_name, and department name (by calling the function with department_id).

**Answer:**

```sql
SELECT employee_id, first_name, get_department_name(department_id) AS department_name
FROM hr.employees;
```

**Explanation:** The function is called once per row with that row's department_id. This avoids joining to hr.departments in the query (but may be less efficient than a join for large result sets).

---

## Part 2: Self-Practice (No Answers)

1. Create a function that returns the **maximum salary** in a given **department_id**. Use it in a SELECT.
2. Create a function that takes **department_id** and returns a **BOOLEAN** (true if the department has at least one employee). Call it from a PL/SQL block (functions returning BOOLEAN are not used in SQL SELECT in Oracle).

---

## Part 3: Additional Practice — 20 Medium + 20 Hard Questions (With Hints)

All use **hr.employees** and **hr.departments**; create functions in your schema or HR if allowed.

### 20 Medium Questions

1. **M1.** Function get_department_name(p_dept_id) RETURN department_name; handle NO_DATA_FOUND. **Hint:** SELECT department_name INTO v FROM hr.departments WHERE department_id = p_dept_id; RETURN v; EXCEPTION WHEN NO_DATA_FOUND THEN RETURN NULL;
2. **M2.** Function employee_count(p_dept_id) RETURN NUMBER. **Hint:** SELECT COUNT(*) INTO v FROM hr.employees WHERE department_id = p_dept_id; RETURN v;
3. **M3.** Use function in SELECT: SELECT employee_id, get_department_name(department_id) FROM hr.employees. **Hint:** Call function in SELECT list with column as argument.
4. **M4.** Function max_salary(p_dept_id) RETURN NUMBER (MAX(salary)). **Hint:** SELECT MAX(salary) INTO v FROM hr.employees WHERE department_id = p_dept_id; RETURN NVL(v,0);
5. **M5.** Function full_name(p_first, p_last) RETURN VARCHAR2 DETERMINISTIC. **Hint:** RETURN p_first || ' ' || p_last;
6. **M6.** Function that returns min salary for a job_id. **Hint:** SELECT MIN(salary) INTO v FROM hr.employees WHERE job_id = p_job_id; RETURN v;
7. **M7.** Call function from PL/SQL: v := get_department_name(50); **Hint:** v_name := get_department_name(50);
8. **M8.** Function avg_salary(p_dept_id) RETURN NUMBER. **Hint:** SELECT AVG(salary) INTO v FROM hr.employees WHERE department_id = p_dept_id; RETURN NVL(v,0);
9. **M9.** Function that returns hire_date for employee_id (handle NO_DATA_FOUND). **Hint:** SELECT hire_date INTO v FROM hr.employees WHERE employee_id = p_emp_id; RETURN v; EXCEPTION WHEN NO_DATA_FOUND THEN RETURN NULL;
10. **M10.** Use employee_count(50) in WHERE: SELECT * FROM hr.departments WHERE employee_count(department_id) > 5. **Hint:** Function in WHERE (may be expensive per row).
11. **M11.** Function total_salary(p_dept_id) RETURN NUMBER. **Hint:** SELECT NVL(SUM(salary),0) INTO v FROM hr.employees WHERE department_id = p_dept_id; RETURN v;
12. **M12.** Function with two parameters: p_emp_id, return salary. **Hint:** get_salary(p_emp_id) RETURN NUMBER; SELECT salary INTO v FROM hr.employees WHERE employee_id = p_emp_id;
13. **M13.** Function that returns commission_pct or 0 if NULL. **Hint:** RETURN NVL(commission_pct, 0) or SELECT NVL(commission_pct,0) INTO v ...
14. **M14.** Function dept_has_employees(p_dept_id) RETURN NUMBER (1 if count>0, 0 else). **Hint:** v := 0; SELECT COUNT(*) INTO c FROM ...; IF c > 0 THEN v := 1; END IF; RETURN v;
15. **M15.** Use %TYPE for return type: RETURN hr.departments.department_name%TYPE. **Hint:** RETURN type matches column type.
16. **M16.** Function that returns job_id for employee_id. **Hint:** SELECT job_id INTO v FROM hr.employees WHERE employee_id = p_emp_id; RETURN v;
17. **M17.** Function in ORDER BY: SELECT * FROM hr.employees ORDER BY get_department_name(department_id). **Hint:** ORDER BY function(department_id);
18. **M18.** Function years_employed(p_emp_id) RETURN NUMBER (MONTHS_BETWEEN/12). **Hint:** SELECT MONTHS_BETWEEN(SYSDATE, hire_date)/12 INTO v FROM hr.employees WHERE employee_id = p_emp_id; RETURN v;
19. **M19.** Function that returns 1 if department exists, 0 otherwise. **Hint:** SELECT COUNT(*) INTO v FROM hr.departments WHERE department_id = p_dept_id; RETURN CASE WHEN v > 0 THEN 1 ELSE 0 END;
20. **M20.** DETERMINISTIC function: format_name(first, last) return 'Last, First'. **Hint:** RETURN p_last || ', ' || p_first; DETERMINISTIC;

### 20 Hard Questions

1. **H1.** Function that returns BOOLEAN: dept_has_employees(p_dept_id). Call from PL/SQL only. **Hint:** RETURN (SELECT COUNT(*) FROM hr.employees WHERE department_id = p_dept_id) > 0; or SELECT COUNT(*) INTO v; RETURN v > 0;
2. **H2.** Function used in function-based index: UPPER(last_name) — create function my_upper(p_val) DETERMINISTIC RETURN UPPER(p_val); **Hint:** Must be DETERMINISTIC; CREATE INDEX idx ON hr.employees(my_upper(last_name));
3. **H3.** Function that returns VARCHAR2: list of employee last_names in department (LISTAGG). **Hint:** SELECT LISTAGG(last_name, ', ') WITHIN GROUP (ORDER BY last_name) INTO v FROM hr.employees WHERE department_id = p_dept_id; RETURN v;
4. **H4.** Function with exception: return NULL on NO_DATA_FOUND, re-raise TOO_MANY_ROWS. **Hint:** EXCEPTION WHEN NO_DATA_FOUND THEN RETURN NULL; WHEN TOO_MANY_ROWS THEN RAISE;
5. **H5.** Function that takes job_id and department_id, returns count of employees. **Hint:** SELECT COUNT(*) INTO v FROM hr.employees WHERE job_id = p_job_id AND department_id = p_dept_id; RETURN v;
6. **H6.** Function returning DATE: earliest hire_date in department. **Hint:** SELECT MIN(hire_date) INTO v FROM hr.employees WHERE department_id = p_dept_id; RETURN v;
7. **H7.** Function in SELECT with GROUP BY: department_id, get_department_name(department_id). **Hint:** SELECT department_id, get_department_name(department_id) FROM hr.employees GROUP BY department_id;
8. **H8.** Function salary_band(p_salary) RETURN VARCHAR2: 'Low'/<5000, 'Mid'/<10000, 'High'. **Hint:** RETURN CASE WHEN p_salary < 5000 THEN 'Low' WHEN p_salary < 10000 THEN 'Mid' ELSE 'High' END;
9. **H9.** Function that returns manager's last_name for employee_id (self-join in function). **Hint:** SELECT m.last_name INTO v FROM hr.employees e JOIN hr.employees m ON e.manager_id = m.employee_id WHERE e.employee_id = p_emp_id; RETURN v;
10. **H10.** Function with OUT parameter (not for SQL use): get_emp_info(p_emp_id, p_name OUT) RETURN salary. **Hint:** Function can have OUT but then cannot use in SQL SELECT; RETURN v_salary;
11. **H11.** Function that returns NUMBER: difference between employee salary and department avg. **Hint:** Get employee salary and department avg (two SELECTs or one with subquery); RETURN v_sal - v_avg;
12. **H12.** Function department_name_length(p_dept_id) RETURN NUMBER. **Hint:** SELECT LENGTH(department_name) INTO v FROM hr.departments WHERE department_id = p_dept_id; RETURN v;
13. **H13.** Use function in CASE: SELECT CASE WHEN employee_count(department_id) > 10 THEN 'Large' ... **Hint:** CASE WHEN employee_count(department_id) > 10 THEN 'Large' ELSE 'Small' END FROM hr.departments;
14. **H14.** Function that returns total salary of employees reporting to a given manager_id. **Hint:** SELECT NVL(SUM(salary),0) INTO v FROM hr.employees WHERE manager_id = p_mgr_id; RETURN v;
15. **H15.** Function returning VARCHAR2: 'YES'/'NO' if department has any employee with commission_pct > 0. **Hint:** SELECT COUNT(*) INTO v FROM hr.employees WHERE department_id = p_dept_id AND commission_pct > 0; RETURN CASE WHEN v > 0 THEN 'YES' ELSE 'NO' END;
16. **H16.** Function with two IN parameters returning NUMBER: ratio of two department counts. **Hint:** c1 := employee_count(p_dept1); c2 := employee_count(p_dept2); RETURN c1/NULLIF(c2,0);
17. **H17.** Function that returns employee_id of highest-paid in department (handle tie: return one). **Hint:** SELECT employee_id INTO v FROM (SELECT employee_id FROM hr.employees WHERE department_id = p_dept_id ORDER BY salary DESC FETCH FIRST 1 ROW ONLY); RETURN v;
18. **H18.** Pipelined function (advanced): return rows of (employee_id, last_name) for department. **Hint:** PIPELINED; PIPE ROW(...); RETURN; (advanced topic)
19. **H19.** Function used in CHECK constraint (Oracle 11g+): constraint check (my_func(salary) = 1). **Hint:** Function must be DETERMINISTIC and declared in same schema; CHECK (validate_salary(salary) = 1)
20. **H20.** Function that returns default department_id if p_dept_id is NULL: NVL(p_dept_id, 50). **Hint:** RETURN NVL(p_dept_id, 50); or IF p_dept_id IS NULL THEN RETURN 50; ELSE RETURN p_dept_id; END IF;

---

[← Back to Learning Plan](../30-day-sql-plsql-learning-plan.md) | [Tutorial](../tutorials/day23_functions.md)
