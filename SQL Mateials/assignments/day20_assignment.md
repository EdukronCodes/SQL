# Day 20 Assignment: PL/SQL Basics

All exercises use **hr.employees** (and **hr.departments** if needed). Use SET SERVEROUTPUT ON before running blocks that use DBMS_OUTPUT.

---

## Part 1: Practice Questions (With Answers and Explanations)

### Question 1
Write an anonymous block that **fetches one employee** by **employee_id** (e.g. 100) and **prints** their first and last name using DBMS_OUTPUT. Use variables and SELECT INTO.

**Answer:**

```sql
SET SERVEROUTPUT ON
DECLARE
  v_first_name hr.employees.first_name%TYPE;
  v_last_name  hr.employees.last_name%TYPE;
BEGIN
  SELECT first_name, last_name INTO v_first_name, v_last_name
  FROM hr.employees WHERE employee_id = 100;
  DBMS_OUTPUT.PUT_LINE('Employee: ' || v_first_name || ' ' || v_last_name);
EXCEPTION
  WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('Employee not found');
END;
/
```

**Explanation:** %TYPE anchors variable types to the table columns. SELECT INTO populates the variables. DBMS_OUTPUT.PUT_LINE prints the result. NO_DATA_FOUND handles the case when employee_id does not exist.

---

### Question 2
Write a block that **loops** over employees in **department_id 50** and **prints** each employee_id and salary. Use a cursor FOR loop or a simple loop with a cursor.

**Answer (cursor FOR loop):**

```sql
SET SERVEROUTPUT ON
DECLARE
  CURSOR c IS SELECT employee_id, salary FROM hr.employees WHERE department_id = 50;
BEGIN
  FOR rec IN c LOOP
    DBMS_OUTPUT.PUT_LINE('ID: ' || rec.employee_id || ', Salary: ' || rec.salary);
  END LOOP;
END;
/
```

**Explanation:** The cursor FOR loop opens, fetches, and closes the cursor. Each row is available as rec; use rec.employee_id and rec.salary.

---

### Question 3
Write a block that **selects** one employee's salary (e.g. employee_id 100) into a variable. Use an **IF** to **print** a message if the salary is **greater than 15000** (e.g. "High earner").

**Answer:**

```sql
SET SERVEROUTPUT ON
DECLARE
  v_salary hr.employees.salary%TYPE;
BEGIN
  SELECT salary INTO v_salary FROM hr.employees WHERE employee_id = 100;
  IF v_salary > 15000 THEN
    DBMS_OUTPUT.PUT_LINE('High earner');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Salary: ' || v_salary);
  END IF;
END;
/
```

**Explanation:** SELECT INTO gets the salary. IF condition checks for > 15000 and prints accordingly.

---

## Part 2: Self-Practice (No Answers)

1. Write a **FOR** loop from 1 to 10 that prints each number using DBMS_OUTPUT.
2. Declare a variable of type **hr.employees%ROWTYPE**, fetch one row into it (e.g. WHERE employee_id = 101), and print two fields from the row (e.g. first_name, last_name).

---

## Part 3: Additional Practice — 20 Medium + 20 Hard Questions (With Hints)

All use **hr.employees** and **hr.departments**; PL/SQL blocks.

### 20 Medium Questions

1. **M1.** Declare v_count NUMBER; SELECT COUNT(*) INTO v_count FROM hr.employees; print v_count. **Hint:** BEGIN SELECT COUNT(*) INTO v_count FROM hr.employees; DBMS_OUTPUT.PUT_LINE(v_count); END;
2. **M2.** Declare v_name VARCHAR2(100); SELECT first_name INTO v_name FROM hr.employees WHERE employee_id = 100; print v_name. **Hint:** SELECT INTO; DBMS_OUTPUT.PUT_LINE(v_name);
3. **M3.** Use %TYPE for variable matching hr.employees.salary. **Hint:** v_sal hr.employees.salary%TYPE;
4. **M4.** Use %ROWTYPE for variable holding one row of hr.employees. **Hint:** v_emp hr.employees%ROWTYPE; SELECT * INTO v_emp FROM hr.employees WHERE employee_id = 100;
5. **M5.** IF v_salary > 10000 THEN DBMS_OUTPUT.PUT_LINE('High'); ELSE ... **Hint:** IF ... THEN ... ELSE ... END IF;
6. **M6.** FOR i IN 1..5 LOOP DBMS_OUTPUT.PUT_LINE(i); END LOOP; **Hint:** FOR loop with range.
7. **M7.** WHILE i < 10 LOOP i := i + 1; END LOOP; (declare i NUMBER := 0). **Hint:** WHILE condition LOOP ... END LOOP;
8. **M8.** SELECT first_name, last_name INTO two variables FROM hr.employees WHERE employee_id = 101. **Hint:** SELECT first_name, last_name INTO v_fname, v_lname FROM ...;
9. **M9.** Assign v_dept_id := 50; use in SELECT COUNT(*) INTO ... WHERE department_id = v_dept_id. **Hint:** Use variable in WHERE clause.
10. **M10.** LOOP with EXIT WHEN i > 3; i := i + 1; **Hint:** LOOP ... EXIT WHEN ... END LOOP;
11. **M11.** Print 'Hello' and current date (SYSDATE). **Hint:** DBMS_OUTPUT.PUT_LINE('Hello ' || TO_CHAR(SYSDATE));
12. **M12.** Declare v_emp_id NUMBER := 100; use in SELECT INTO. **Hint:** WHERE employee_id = v_emp_id;
13. **M13.** ELSIF: if salary < 5000 then 'Low', elsif salary < 10000 then 'Mid', else 'High'. **Hint:** IF ... ELSIF ... ELSE ... END IF;
14. **M14.** FOR i IN REVERSE 1..5 LOOP (count down). **Hint:** FOR i IN REVERSE 1..5 LOOP ...
15. **M15.** Select department_name INTO variable from hr.departments where department_id = 10. **Hint:** SELECT department_name INTO v_dname FROM hr.departments WHERE department_id = 10;
16. **M16.** Declare two variables; assign first with := 1, second with SELECT 2 FROM DUAL INTO. **Hint:** v1 := 1; SELECT 2 INTO v2 FROM DUAL;
17. **M17.** Print concatenation of two variables (v_fname || ' ' || v_lname). **Hint:** DBMS_OUTPUT.PUT_LINE(v_fname || ' ' || v_lname);
18. **M18.** Use v_emp.first_name and v_emp.last_name from %ROWTYPE variable. **Hint:** After SELECT * INTO v_emp; use v_emp.first_name.
19. **M19.** Simple LOOP that runs 3 times (counter and EXIT WHEN). **Hint:** i := 0; LOOP i := i+1; EXIT WHEN i > 3; ... END LOOP;
20. **M20.** IF v_count > 0 THEN ... ELSE ... **Hint:** Condition with variable.

### 20 Hard Questions

1. **H1.** Loop through employee_id 100 to 105; for each, SELECT salary INTO variable and print employee_id and salary. **Hint:** FOR id IN 100..105 LOOP SELECT salary INTO v_sal FROM hr.employees WHERE employee_id = id; DBMS_OUTPUT.PUT_LINE(id || ' ' || v_sal); END LOOP;
2. **H2.** Use EXCEPTION WHEN NO_DATA_FOUND THEN print 'Not found'. **Hint:** EXCEPTION WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('Not found');
3. **H3.** Declare record type with employee_id, first_name, last_name; select into it. **Hint:** TYPE t_emp IS RECORD (employee_id NUMBER, first_name VARCHAR2(20), last_name VARCHAR2(25)); v_rec t_emp; SELECT employee_id, first_name, last_name INTO v_rec FROM ...
4. **H4.** WHILE loop: fetch employees where department_id = 50 until no rows (use cursor or BULK COLLECT LIMIT 1). **Hint:** Use explicit cursor; OPEN; LOOP FETCH ... EXIT WHEN cursor%NOTFOUND; ... END LOOP; CLOSE;
5. **H5.** Nested IF: if dept_id = 50 then if salary > 5000 then 'A' else 'B'; else 'C'. **Hint:** IF ... THEN IF ... THEN ... ELSE ... END IF; ELSE ... END IF;
6. **H6.** Assign v_total := 0; loop 1 to 10, v_total := v_total + i; print v_total at end. **Hint:** FOR i IN 1..10 LOOP v_total := v_total + i; END LOOP;
7. **H7.** SELECT COUNT(*) INTO v_c FROM hr.employees WHERE department_id = v_dept_id; use v_dept_id from another SELECT. **Hint:** First get v_dept_id (e.g. from departments), then use in second query.
8. **H8.** Declare CONSTANT v_max NUMBER := 100; use in IF condition. **Hint:** v_max CONSTANT NUMBER := 100; IF v_salary > v_max THEN ...
9. **H9.** Use SQL%ROWCOUNT after UPDATE hr.employees SET ... WHERE ...; print number of rows updated. **Hint:** UPDATE ... ; DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT);
10. **H10.** FOR rec IN (SELECT employee_id, first_name FROM hr.employees WHERE ROWNUM <= 5) LOOP print rec.employee_id, rec.first_name. **Hint:** FOR rec IN (SELECT ... ) LOOP ... END LOOP;
11. **H11.** Declare v_date DATE := SYSDATE; print it with TO_CHAR. **Hint:** DBMS_OUTPUT.PUT_LINE(TO_CHAR(v_date, 'DD-MON-YYYY'));
12. **H12.** IF v_emp.salary IS NULL THEN ... **Hint:** Handle NULL in record field.
13. **H13.** Loop: i from 1 to 10; if i mod 2 = 0 then print i. **Hint:** IF MOD(i, 2) = 0 THEN DBMS_OUTPUT.PUT_LINE(i); END IF;
14. **H14.** Select into %ROWTYPE; then update another variable from v_emp.salary * 1.1. **Hint:** v_new_sal := v_emp.salary * 1.1;
15. **H15.** EXIT WHEN condition in the middle of LOOP (e.g. when v_count > 5). **Hint:** LOOP ... v_count := v_count + 1; EXIT WHEN v_count > 5; ... END LOOP;
16. **H16.** Declare v_result VARCHAR2(100); use CASE in PL/SQL: v_result := CASE WHEN v_sal < 5000 THEN 'Low' WHEN v_sal < 10000 THEN 'Mid' ELSE 'High' END; **Hint:** Assignment with CASE expression.
17. **H17.** Nested FOR: outer 1..2, inner 1..3; print outer and inner. **Hint:** FOR o IN 1..2 LOOP FOR i IN 1..3 LOOP DBMS_OUTPUT.PUT_LINE(o || ',' || i); END LOOP; END LOOP;
18. **H18.** SELECT department_id INTO v_did FROM hr.departments WHERE department_name = 'Sales'; then use v_did in SELECT COUNT(*) FROM hr.employees WHERE department_id = v_did. **Hint:** Two SELECT INTOs; use first result in second.
19. **H19.** Use BIND variable in PL/SQL (e.g. in EXECUTE IMMEDIATE 'SELECT salary FROM hr.employees WHERE employee_id = :1' INTO v_sal USING v_id). **Hint:** EXECUTE IMMEDIATE '...' INTO ... USING ...;
20. **H20.** Block that only runs if v_flag = 1 (IF v_flag = 1 THEN ... entire logic ... END IF). **Hint:** Wrap main logic in IF condition.

---

[← Back to Learning Plan](../30-day-sql-plsql-learning-plan.md) | [Tutorial](../tutorials/day20_plsql_basics.md)
