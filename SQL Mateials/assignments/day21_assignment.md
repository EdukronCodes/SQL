# Day 21 Assignment: Cursors

All exercises use **hr.employees** and **hr.departments**. Use SET SERVEROUTPUT ON where you use DBMS_OUTPUT.

---

## Part 1: Practice Questions (With Answers and Explanations)

### Question 1
Write an **explicit cursor** over employees in **department_id 60**. Open, fetch in a loop, and print each employee's first and last name. Close the cursor.

**Answer:**

```sql
SET SERVEROUTPUT ON
DECLARE
  CURSOR c_emp IS
    SELECT first_name, last_name FROM hr.employees WHERE department_id = 60;
  v_fname hr.employees.first_name%TYPE;
  v_lname hr.employees.last_name%TYPE;
BEGIN
  OPEN c_emp;
  LOOP
    FETCH c_emp INTO v_fname, v_lname;
    EXIT WHEN c_emp%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(v_fname || ' ' || v_lname);
  END LOOP;
  CLOSE c_emp;
END;
/
```

**Explanation:** Declare cursor with SELECT, open it, loop with FETCH INTO and EXIT WHEN c_emp%NOTFOUND, then close. Variables must match the select list in type and number.

---

### Question 2
Use a **cursor FOR loop** to iterate over **hr.departments** and for each department **count** how many employees it has. Print department_id, department_name, and the count. (Use a subquery in the cursor or a second query inside the loop.)

**Answer (cursor with subquery for count):**

```sql
SET SERVEROUTPUT ON
DECLARE
  CURSOR c_dept IS
    SELECT d.department_id, d.department_name,
      (SELECT COUNT(*) FROM hr.employees e WHERE e.department_id = d.department_id) AS emp_count
    FROM hr.departments d;
BEGIN
  FOR rec IN c_dept LOOP
    DBMS_OUTPUT.PUT_LINE(rec.department_id || ' - ' || rec.department_name || ': ' || rec.emp_count || ' employees');
  END LOOP;
END;
/
```

**Explanation:** The cursor selects each department and a scalar subquery for employee count. The FOR loop iterates and prints each row.

---

### Question 3
Write a **parameterized cursor** that takes **department_id** as a parameter and returns employees in that department. Call it for department 50 and print each employee's first_name and last_name.

**Answer:**

```sql
SET SERVEROUTPUT ON
DECLARE
  CURSOR c_emp(p_dept_id NUMBER) IS
    SELECT first_name, last_name FROM hr.employees WHERE department_id = p_dept_id;
BEGIN
  FOR rec IN c_emp(50) LOOP
    DBMS_OUTPUT.PUT_LINE(rec.first_name || ' ' || rec.last_name);
  END LOOP;
END;
/
```

**Explanation:** The cursor declares a parameter p_dept_id and uses it in the WHERE clause. In the FOR loop, pass 50 as c_emp(50).

---

## Part 2: Self-Practice (No Answers)

1. Write a cursor that **joins** hr.employees and hr.departments and fetches employee_id, first_name, department_name. Print each row in a loop.
2. After an **UPDATE** on hr.employees (e.g. UPDATE ... WHERE department_id = 90), use **SQL%ROWCOUNT** in the same block to print how many rows were updated.

---

## Part 3: Additional Practice — 20 Medium + 20 Hard Questions (With Hints)

All use **hr.employees** and **hr.departments**; SET SERVEROUTPUT ON where needed.

### 20 Medium Questions

1. **M1.** Declare explicit cursor for employees in department_id = 50; OPEN, FETCH, CLOSE; print first_name. **Hint:** CURSOR c IS SELECT first_name FROM hr.employees WHERE department_id = 50; OPEN c; LOOP FETCH c INTO v; EXIT WHEN c%NOTFOUND; ...
2. **M2.** Use cursor FOR loop over SELECT employee_id, last_name FROM hr.employees WHERE job_id = 'SA_REP'. **Hint:** FOR rec IN (SELECT ... ) LOOP DBMS_OUTPUT.PUT_LINE(rec.employee_id || ' ' || rec.last_name); END LOOP;
3. **M3.** After UPDATE hr.employees SET salary = salary * 1.1 WHERE department_id = 60; print SQL%ROWCOUNT. **Hint:** UPDATE ...; DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT);
4. **M4.** Parameterized cursor c(p_dept_id); open for 50 and 80; print employee count per department. **Hint:** CURSOR c(p_dept_id NUMBER) IS SELECT ... WHERE department_id = p_dept_id; count in loop or use COUNT in query.
5. **M5.** Cursor that selects department_id, department_name from hr.departments; loop and print. **Hint:** CURSOR c_dept IS SELECT department_id, department_name FROM hr.departments;
6. **M6.** Fetch cursor INTO a %ROWTYPE variable (hr.employees%ROWTYPE). **Hint:** v_emp hr.employees%ROWTYPE; FETCH c INTO v_emp; use v_emp.first_name, etc.
7. **M7.** Use c%NOTFOUND to exit loop. **Hint:** EXIT WHEN c%NOTFOUND; (after FETCH).
8. **M8.** Cursor with JOIN employees and departments; select employee_id, first_name, department_name. **Hint:** SELECT e.employee_id, e.first_name, d.department_name FROM hr.employees e JOIN hr.departments d ON e.department_id = d.department_id;
9. **M9.** After DELETE FROM hr.employees WHERE employee_id = 999; print SQL%ROWCOUNT. **Hint:** DELETE ...; DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT);
10. **M10.** Cursor FOR loop with named cursor (not inline). **Hint:** DECLARE CURSOR c IS SELECT ...; BEGIN FOR rec IN c LOOP ...
11. **M11.** Check cursor%ISOPEN before CLOSE. **Hint:** IF c%ISOPEN THEN CLOSE c; END IF;
12. **M12.** Open parameterized cursor with OPEN c_emp(90). **Hint:** OPEN c_emp(90); then FETCH loop.
13. **M13.** Loop that fetches into three variables (employee_id, first_name, last_name). **Hint:** FETCH c INTO v_id, v_fname, v_lname;
14. **M14.** Use SQL%FOUND after SELECT INTO. **Hint:** SELECT ... INTO v FROM ...; IF SQL%FOUND THEN ...
15. **M15.** Cursor for employees where salary > 10000; print employee_id and salary. **Hint:** CURSOR c IS SELECT employee_id, salary FROM hr.employees WHERE salary > 10000;
16. **M16.** Count rows processed in cursor loop (increment counter). **Hint:** v_count := 0; LOOP ... v_count := v_count + 1; END LOOP; print v_count.
17. **M17.** Cursor over departments; for each department print name and (subquery) count of employees. **Hint:** Cursor SELECT d.department_name, (SELECT COUNT(*) FROM hr.employees e WHERE e.department_id = d.department_id) FROM hr.departments d;
18. **M18.** FOR rec IN (SELECT first_name, last_name FROM hr.employees WHERE ROWNUM <= 5) — inline cursor. **Hint:** No DECLARE cursor; FOR rec IN (SELECT ...) LOOP ...
19. **M19.** Close cursor in EXCEPTION handler. **Hint:** EXCEPTION WHEN OTHERS THEN IF c%ISOPEN THEN CLOSE c; END IF; RAISE;
20. **M20.** Cursor that orders by hire_date DESC; print first 3 rows only (EXIT when counter = 3). **Hint:** v_n := 0; LOOP FETCH ... EXIT WHEN c%NOTFOUND; v_n := v_n + 1; EXIT WHEN v_n > 3; ...

### 20 Hard Questions

1. **H1.** Two cursors: first cursor departments, inner cursor employees for that department_id; nested loops. **Hint:** OPEN c_dept; LOOP FETCH c_dept INTO v_dept_id; EXIT WHEN c_dept%NOTFOUND; OPEN c_emp(v_dept_id); ... CLOSE c_emp; END LOOP; CLOSE c_dept;
2. **H2.** Cursor with FOR UPDATE; inside loop UPDATE hr.employees SET ... WHERE CURRENT OF c; **Hint:** CURSOR c IS SELECT ... FROM hr.employees WHERE ... FOR UPDATE; later UPDATE ... WHERE CURRENT OF c;
3. **H3.** Parameterized cursor returning (department_id, department_name, total_salary); use GROUP BY in cursor query. **Hint:** CURSOR c IS SELECT department_id, department_name, SUM(salary) FROM hr.employees e JOIN hr.departments d ON e.department_id = d.department_id GROUP BY d.department_id, d.department_name;
4. **H4.** Use BULK COLLECT LIMIT 100 to fetch 100 rows at a time from cursor into collection. **Hint:** OPEN c; LOOP FETCH c BULK COLLECT INTO v_ids, v_names LIMIT 100; EXIT WHEN v_ids.COUNT = 0; process collection; END LOOP;
5. **H5.** Cursor that uses a variable in WHERE (set before OPEN). **Hint:** v_dept := 50; CURSOR c IS SELECT ... WHERE department_id = v_dept; OPEN c; (variable evaluated at OPEN).
6. **H6.** REF CURSOR (weak): open for different queries (e.g. one for employees, one for departments) in same block. **Hint:** TYPE t_rc IS REF CURSOR; v_rc t_rc; OPEN v_rc FOR SELECT ... FROM hr.employees; later OPEN v_rc FOR SELECT ... FROM hr.departments;
7. **H7.** Cursor with OFFSET/FETCH (Oracle 12c+) to skip first 5 rows and take next 10. **Hint:** SELECT ... FROM hr.employees ORDER BY employee_id OFFSET 5 ROWS FETCH NEXT 10 ROWS ONLY;
8. **H8.** After cursor loop, print total rows processed using cursor%ROWCOUNT (after loop, before CLOSE). **Hint:** After LOOP ... END LOOP; DBMS_OUTPUT.PUT_LINE(c%ROWCOUNT); CLOSE c;
9. **H9.** Procedure with OUT parameter as REF CURSOR; open cursor for SELECT from hr.employees and return it to caller. **Hint:** PROCEDURE get_emps(p_rc OUT SYS_REFCURSOR) IS BEGIN OPEN p_rc FOR SELECT * FROM hr.employees; END;
10. **H10.** Cursor FOR loop that exits early when a condition is met (e.g. when salary > 20000). **Hint:** FOR rec IN c LOOP IF rec.salary > 20000 THEN EXIT; END IF; ... END LOOP;
11. **H11.** Select from cursor into record type with 5 columns; declare TYPE t_rec IS RECORD (...). **Hint:** TYPE t_rec IS RECORD (id NUMBER, fname VARCHAR2(20), ...); v_rec t_rec; FETCH c INTO v_rec;
12. **H12.** Use WHERE CURRENT OF with cursor declared with FOR UPDATE NOWAIT. **Hint:** FOR UPDATE NOWAIT; if row locked by another session, lock fails immediately.
13. **H13.** Cursor that joins employees and departments and filters by department_name = 'Sales'. **Hint:** JOIN hr.departments d ... WHERE d.department_name = 'Sales';
14. **H14.** Loop through cursor and accumulate total salary in a variable; print total at end. **Hint:** v_total := 0; FOR rec IN c LOOP v_total := v_total + rec.salary; END LOOP;
15. **H15.** Open same parameterized cursor twice (different params) in same block; process both. **Hint:** FOR rec IN c(50) LOOP ... END LOOP; FOR rec IN c(60) LOOP ... END LOOP;
16. **H16.** Cursor with ORDER BY salary DESC; fetch first row only and print (then exit). **Hint:** OPEN c; FETCH c INTO ...; (process); EXIT; or use FETCH once and EXIT WHEN c%NOTFOUND after processing.
17. **H17.** Handle NO_DATA_FOUND when opening cursor and fetching (cursor returns no rows). **Hint:** After first FETCH, if c%NOTFOUND before any processing, handle "no rows."
18. **H18.** Cursor that returns one row per department with department_name and comma-separated list of employee last_names (use LISTAGG in cursor query). **Hint:** SELECT d.department_name, LISTAGG(e.last_name, ', ') WITHIN GROUP (ORDER BY e.last_name) FROM hr.employees e JOIN hr.departments d ON e.department_id = d.department_id GROUP BY d.department_id, d.department_name;
19. **H19.** Statement that uses SQL%ROWCOUNT after INSERT...SELECT. **Hint:** INSERT INTO backup SELECT * FROM hr.employees WHERE department_id = 50; DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows inserted');
20. **H20.** Explicit cursor with ORDER BY department_id, salary DESC; process by department (change of department_id). **Hint:** Track previous department_id; when rec.department_id != v_prev_dept, print separator or do extra logic.

---

[← Back to Learning Plan](../30-day-sql-plsql-learning-plan.md) | [Tutorial](../tutorials/day21_cursors.md)
