# Day 22 Assignment: Stored Procedures

All exercises use **hr.employees** and **hr.departments**. Create procedures in your schema or in HR if you have privileges.

---

## Part 1: Practice Questions (With Answers and Explanations)

### Question 1
Create a procedure **list_emp_by_dept(p_dept_id)** that takes a department ID and **outputs** (e.g. via DBMS_OUTPUT) the first and last name of each employee in that department. Use a cursor FOR loop.

**Answer:**

```sql
CREATE OR REPLACE PROCEDURE list_emp_by_dept(p_dept_id IN hr.departments.department_id%TYPE) IS
  CURSOR c IS SELECT first_name, last_name FROM hr.employees WHERE department_id = p_dept_id;
BEGIN
  FOR rec IN c LOOP
    DBMS_OUTPUT.PUT_LINE(rec.first_name || ' ' || rec.last_name);
  END LOOP;
END;
/
```

**Explanation:** IN parameter p_dept_id is used in the cursor WHERE clause. The procedure loops and prints each name. Call with EXEC list_emp_by_dept(50); (and SET SERVEROUTPUT ON).

---

### Question 2
Create a procedure **raise_salary(p_emp_id, p_pct)** that **updates** the salary of the given employee by increasing it by **p_pct** percent (e.g. 10 for 10%). Use UPDATE ... WHERE employee_id = p_emp_id. Optionally check SQL%ROWCOUNT and raise an error if no row was updated.

**Answer:**

```sql
CREATE OR REPLACE PROCEDURE raise_salary(
  p_emp_id IN hr.employees.employee_id%TYPE,
  p_pct    IN NUMBER
) IS
BEGIN
  UPDATE hr.employees SET salary = salary * (1 + p_pct/100) WHERE employee_id = p_emp_id;
  IF SQL%ROWCOUNT = 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Employee not found: ' || p_emp_id);
  END IF;
  COMMIT;
END;
/
```

**Explanation:** UPDATE multiplies salary by (1 + p_pct/100). SQL%ROWCOUNT = 0 means no row matched; raise a user-defined error. COMMIT makes the change permanent (omit if caller should commit).

---

### Question 3
Create a procedure that takes **department_id** as IN and returns the **total salary** of that department in an **OUT** parameter. Call it from a block and print the result.

**Answer:**

```sql
CREATE OR REPLACE PROCEDURE get_dept_total_salary(
  p_dept_id IN  hr.departments.department_id%TYPE,
  p_total   OUT NUMBER
) IS
BEGIN
  SELECT NVL(SUM(salary), 0) INTO p_total FROM hr.employees WHERE department_id = p_dept_id;
END;
/

-- Call:
DECLARE v_total NUMBER; BEGIN get_dept_total_salary(50, v_total); DBMS_OUTPUT.PUT_LINE('Total: ' || v_total); END;
/
```

**Explanation:** The OUT parameter p_total is set by SELECT INTO. NVL(SUM(salary),0) returns 0 when the department has no employees. The caller passes a variable for the OUT and prints it.

---

## Part 2: Self-Practice (No Answers)

1. Create a procedure that **inserts** one row into a backup table (e.g. hr_emp_backup) with parameters for employee_id, first_name, last_name, salary, department_id.
2. Create a procedure with a **default** parameter (e.g. p_dept_id IN NUMBER DEFAULT 50) and call it with and without that parameter.

---

## Part 3: Additional Practice — 20 Medium + 20 Hard Questions (With Hints)

All use **hr.employees** and **hr.departments**; create procedures in your schema or HR if allowed.

### 20 Medium Questions

1. **M1.** Create procedure get_emp_count(p_dept_id IN, p_count OUT); SELECT COUNT(*) INTO p_count. **Hint:** CREATE PROCEDURE ... (p_dept_id IN NUMBER, p_count OUT NUMBER) IS BEGIN SELECT COUNT(*) INTO p_count FROM hr.employees WHERE department_id = p_dept_id; END;
2. **M2.** Procedure raise_salary(p_emp_id, p_pct); UPDATE salary by p_pct percent. **Hint:** UPDATE hr.employees SET salary = salary * (1 + p_pct/100) WHERE employee_id = p_emp_id;
3. **M3.** Procedure with two OUT params: total_salary and emp_count for a department. **Hint:** SELECT SUM(salary), COUNT(*) INTO p_total, p_count FROM hr.employees WHERE department_id = p_dept_id;
4. **M4.** Call a procedure from anonymous block and print OUT parameter. **Hint:** DECLARE v NUMBER; BEGIN get_emp_count(50, v); DBMS_OUTPUT.PUT_LINE(v); END;
5. **M5.** Procedure list_emp_by_dept(p_dept_id) that prints first_name, last_name using cursor FOR loop. **Hint:** CURSOR c IS SELECT first_name, last_name FROM hr.employees WHERE department_id = p_dept_id; FOR rec IN c LOOP DBMS_OUTPUT.PUT_LINE(...);
6. **M6.** Use %TYPE for procedure parameters (p_dept_id hr.departments.department_id%TYPE). **Hint:** p_dept_id IN hr.departments.department_id%TYPE
7. **M7.** Procedure that takes employee_id and returns first_name, last_name in OUT parameters. **Hint:** p_fname OUT hr.employees.first_name%TYPE, p_lname OUT ...; SELECT first_name, last_name INTO p_fname, p_lname FROM hr.employees WHERE employee_id = p_emp_id;
8. **M8.** Check SQL%ROWCOUNT after UPDATE in procedure; raise error if 0. **Hint:** IF SQL%ROWCOUNT = 0 THEN RAISE_APPLICATION_ERROR(-20001, 'Not found');
9. **M9.** Procedure with default: p_dept_id IN NUMBER DEFAULT 50. **Hint:** p_dept_id IN NUMBER DEFAULT 50
10. **M10.** Procedure get_dept_total_salary(p_dept_id, p_total OUT); use NVL(SUM(salary),0). **Hint:** SELECT NVL(SUM(salary),0) INTO p_total FROM hr.employees WHERE department_id = p_dept_id;
11. **M11.** Procedure to update department_id for an employee (p_emp_id, p_dept_id). **Hint:** UPDATE hr.employees SET department_id = p_dept_id WHERE employee_id = p_emp_id;
12. **M12.** EXEC procedure_name(args) from SQL*Plus. **Hint:** EXEC raise_salary(100, 5);
13. **M13.** Procedure that inserts into hr_emp_backup (params: emp_id, fname, lname, sal, dept_id). **Hint:** INSERT INTO hr_emp_backup (employee_id, first_name, last_name, salary, department_id) VALUES (p_emp_id, p_fname, p_lname, p_sal, p_dept_id);
14. **M14.** Procedure with IN OUT parameter: pass number, add 10 to it, return. **Hint:** p_val IN OUT NUMBER; p_val := p_val + 10;
15. **M15.** Procedure that prints department_name for given department_id (SELECT INTO, DBMS_OUTPUT). **Hint:** SELECT department_name INTO v FROM hr.departments WHERE department_id = p_dept_id; DBMS_OUTPUT.PUT_LINE(v);
16. **M16.** Procedure with three IN params: min_sal, max_sal, dept_id; print employee count in range. **Hint:** SELECT COUNT(*) INTO v FROM hr.employees WHERE department_id = p_dept_id AND salary BETWEEN p_min AND p_max; DBMS_OUTPUT.PUT_LINE(v);
17. **M17.** Call procedure without optional parameter (use default). **Hint:** list_emp_by_dept; -- p_dept_id defaults to 50
18. **M18.** Procedure that returns max salary of department in OUT. **Hint:** SELECT MAX(salary) INTO p_max_sal FROM hr.employees WHERE department_id = p_dept_id;
19. **M19.** Procedure to set commission_pct for an employee (p_emp_id, p_comm). **Hint:** UPDATE hr.employees SET commission_pct = p_comm WHERE employee_id = p_emp_id;
20. **M20.** Procedure with two IN params: p_job_id, p_dept_id; print count of employees. **Hint:** SELECT COUNT(*) INTO v FROM hr.employees WHERE job_id = p_job_id AND department_id = p_dept_id; DBMS_OUTPUT.PUT_LINE(v);

### 20 Hard Questions

1. **H1.** Procedure that accepts REF CURSOR OUT; open it for SELECT * FROM hr.employees WHERE department_id = p_dept_id. **Hint:** p_rc OUT SYS_REFCURSOR; OPEN p_rc FOR SELECT * FROM hr.employees WHERE department_id = p_dept_id;
2. **H2.** Procedure with OUT parameter as associative array of employee last_names (TYPE t_tab IS TABLE OF VARCHAR2(25) INDEX BY PLS_INTEGER). **Hint:** BULK COLLECT INTO p_arr FROM (SELECT last_name FROM hr.employees WHERE department_id = p_dept_id);
3. **H3.** Procedure that updates salary and logs old/new to audit table in same procedure (no trigger). **Hint:** SELECT salary INTO v_old FROM hr.employees WHERE employee_id = p_emp_id; UPDATE ...; INSERT INTO audit_table VALUES (...);
4. **H4.** Procedure with exception handler: on NO_DATA_FOUND set OUT parameter to -1 and don't re-raise. **Hint:** EXCEPTION WHEN NO_DATA_FOUND THEN p_count := -1;
5. **H5.** Procedure that raises custom RAISE_APPLICATION_ERROR if department_id does not exist in hr.departments. **Hint:** SELECT COUNT(*) INTO v FROM hr.departments WHERE department_id = p_dept_id; IF v = 0 THEN RAISE_APPLICATION_ERROR(-20002, 'Invalid dept');
6. **H6.** Procedure to "transfer" an employee to another department (update department_id); validate both departments exist. **Hint:** Check source and target department_id in hr.departments; then UPDATE hr.employees SET department_id = p_new_dept WHERE employee_id = p_emp_id;
7. **H7.** Procedure with COMMIT inside vs procedure without COMMIT (caller commits). **Hint:** Document; either END with COMMIT; or leave to caller.
8. **H8.** Procedure that returns multiple OUT: min_sal, max_sal, avg_sal for a department. **Hint:** SELECT MIN(salary), MAX(salary), AVG(salary) INTO p_min, p_max, p_avg FROM hr.employees WHERE department_id = p_dept_id;
9. **H9.** Create procedure that calls another procedure (e.g. get count then call list_emp_by_dept). **Hint:** get_emp_count(50, v); list_emp_by_dept(50);
10. **H10.** Procedure with IN OUT parameter: pass employee_id, return full name (first||' '||last) in same IN OUT or second OUT. **Hint:** p_emp_id IN, p_fullname OUT VARCHAR2; SELECT first_name||' '||last_name INTO p_fullname FROM hr.employees WHERE employee_id = p_emp_id;
11. **H11.** Procedure that updates salaries for all employees in a department by p_pct; return rows updated in OUT. **Hint:** UPDATE hr.employees SET salary = salary * (1+p_pct/100) WHERE department_id = p_dept_id; p_rows := SQL%ROWCOUNT;
12. **H12.** Procedure with default for second parameter: p_emp_id IN, p_pct IN NUMBER DEFAULT 10. **Hint:** raise_salary(p_emp_id, p_pct DEFAULT 10);
13. **H13.** Use named notation in call: procedure_name(p_dept_id => 50, p_count => v_count). **Hint:** get_emp_count(p_dept_id => 50, p_count => v_count);
14. **H14.** Procedure that deletes employees in a department (p_dept_id); return deleted count in OUT. **Hint:** DELETE FROM hr.employees WHERE department_id = p_dept_id; p_deleted := SQL%ROWCOUNT; (use backup table in practice)
15. **H15.** Procedure with cursor OUT (SYS_REFCURSOR) for query joining employees and departments. **Hint:** OPEN p_rc FOR SELECT e.employee_id, e.first_name, d.department_name FROM hr.employees e JOIN hr.departments d ON e.department_id = d.department_id;
16. **H16.** Procedure that inserts into backup only if employee exists; return 0 or 1 in OUT. **Hint:** SELECT ... INTO ... WHERE employee_id = p_emp_id; INSERT INTO backup ...; p_ok := 1; EXCEPTION WHEN NO_DATA_FOUND THEN p_ok := 0;
17. **H17.** Procedure with IN OUT number: add 1 and return (p_counter IN OUT NUMBER). **Hint:** p_counter := p_counter + 1;
18. **H18.** Procedure list_departments that prints each department_name and its employee count (cursor over depts, count per dept). **Hint:** CURSOR c IS SELECT department_id, department_name FROM hr.departments; FOR rec IN c LOOP SELECT COUNT(*) INTO v FROM hr.employees WHERE department_id = rec.department_id; DBMS_OUTPUT.PUT_LINE(rec.department_name || ': ' || v);
19. **H19.** Procedure that gets department_name for department_id and returns it in OUT (handle NO_DATA_FOUND). **Hint:** SELECT department_name INTO p_name FROM hr.departments WHERE department_id = p_dept_id; EXCEPTION WHEN NO_DATA_FOUND THEN p_name := NULL;
20. **H20.** Procedure with three OUT parameters: total_salary, avg_salary, employee_count for a given job_id. **Hint:** SELECT SUM(salary), AVG(salary), COUNT(*) INTO p_total, p_avg, p_count FROM hr.employees WHERE job_id = p_job_id;

---

[← Back to Learning Plan](../30-day-sql-plsql-learning-plan.md) | [Tutorial](../tutorials/day22_stored_procedures.md)
