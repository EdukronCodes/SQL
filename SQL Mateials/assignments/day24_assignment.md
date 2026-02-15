# Day 24 Assignment: Exception Handling

All exercises use **hr.employees** and **hr.departments**.

---

## Part 1: Practice Questions (With Answers and Explanations)

### Question 1
Write a block that **selects** an employee by **employee_id** (use a variable, e.g. 99999) into first_name and last_name. **Handle NO_DATA_FOUND** and print a message like "Employee not found."

**Answer:**

```sql
DECLARE
  v_id NUMBER := 99999;
  v_fname hr.employees.first_name%TYPE;
  v_lname hr.employees.last_name%TYPE;
BEGIN
  SELECT first_name, last_name INTO v_fname, v_lname FROM hr.employees WHERE employee_id = v_id;
  DBMS_OUTPUT.PUT_LINE(v_fname || ' ' || v_lname);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Employee not found.');
END;
/
```

**Explanation:** SELECT INTO raises NO_DATA_FOUND when no row is returned. The EXCEPTION section catches it and prints a message instead of propagating the error.

---

### Question 2
Write a block that **fetches** one employee's salary. If the salary is **greater than 50000**, raise a **custom exception** (declare it in DECLARE) and handle it by printing "Salary exceeds limit." Otherwise print the salary.

**Answer:**

```sql
DECLARE
  v_salary hr.employees.salary%TYPE;
  e_high_salary EXCEPTION;
BEGIN
  SELECT salary INTO v_salary FROM hr.employees WHERE employee_id = 100;
  IF v_salary > 50000 THEN
    RAISE e_high_salary;
  END IF;
  DBMS_OUTPUT.PUT_LINE('Salary: ' || v_salary);
EXCEPTION
  WHEN e_high_salary THEN
    DBMS_OUTPUT.PUT_LINE('Salary exceeds limit.');
END;
/
```

**Explanation:** Declare EXCEPTION e_high_salary. After SELECT INTO, IF salary > 50000 THEN RAISE e_high_salary. In EXCEPTION, WHEN e_high_salary THEN handle with a message.

---

### Question 3
In a block, use **RAISE_APPLICATION_ERROR(-20001, 'Your message')** when a condition is met (e.g. when department_id from a SELECT is NULL). Pass a clear error message.

**Answer:**

```sql
DECLARE
  v_dept_id hr.employees.department_id%TYPE;
BEGIN
  SELECT department_id INTO v_dept_id FROM hr.employees WHERE employee_id = 178;
  IF v_dept_id IS NULL THEN
    RAISE_APPLICATION_ERROR(-20001, 'Employee has no department assigned.');
  END IF;
  DBMS_OUTPUT.PUT_LINE('Department: ' || v_dept_id);
END;
/
```

**Explanation:** RAISE_APPLICATION_ERROR stops execution and returns error code -20001 (in range -20000 to -20999) and the message to the client. No handler is required; the error propagates.

---

## Part 2: Self-Practice (No Answers)

1. Write a block that does SELECT INTO for a query that can return **more than one row** (e.g. by job_id). **Handle TOO_MANY_ROWS** and print a message.
2. In an exception handler, **re-raise** the exception after logging (e.g. DBMS_OUTPUT or INSERT into a log table) using RAISE; so the caller still sees the error.

---

## Part 3: Additional Practice — 20 Medium + 20 Hard Questions (With Hints)

All use **hr.employees** and **hr.departments**.

### 20 Medium Questions

1. **M1.** SELECT first_name INTO v FROM hr.employees WHERE employee_id = 99999; handle NO_DATA_FOUND. **Hint:** EXCEPTION WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('Not found');
2. **M2.** IF v_salary > 50000 THEN RAISE_APPLICATION_ERROR(-20001, 'Too high'); **Hint:** RAISE_APPLICATION_ERROR in range -20000 to -20999.
3. **M3.** Declare e_my_err EXCEPTION; raise it in block; handle WHEN e_my_err. **Hint:** DECLARE e_my_err EXCEPTION; BEGIN ... RAISE e_my_err; EXCEPTION WHEN e_my_err THEN ...
4. **M4.** Handle TOO_MANY_ROWS when SELECT INTO by job_id. **Hint:** SELECT ... INTO v FROM hr.employees WHERE job_id = 'SA_REP'; EXCEPTION WHEN TOO_MANY_ROWS THEN ...
5. **M5.** In OTHERS handler print SQLERRM. **Hint:** WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM);
6. **M6.** RAISE_APPLICATION_ERROR when department_id from SELECT is NULL. **Hint:** IF v_dept_id IS NULL THEN RAISE_APPLICATION_ERROR(-20001, 'No department');
7. **M7.** Handle DUP_VAL_ON_INDEX in block that inserts. **Hint:** EXCEPTION WHEN DUP_VAL_ON_INDEX THEN ...
8. **M8.** After handling exception, re-raise with RAISE; **Hint:** WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE(SQLERRM); RAISE;
9. **M9.** Handle ZERO_DIVIDE. **Hint:** WHEN ZERO_DIVIDE THEN DBMS_OUTPUT.PUT_LINE('Division by zero');
10. **M10.** Custom exception e_no_emp; raise when SELECT COUNT(*) = 0 for department. **Hint:** IF v_count = 0 THEN RAISE e_no_emp;
11. **M11.** PRAGMA EXCEPTION_INIT for -2291 (foreign key violation). **Hint:** e_fk EXCEPTION; PRAGMA EXCEPTION_INIT(e_fk, -2291);
12. **M12.** In function, WHEN NO_DATA_FOUND THEN RETURN NULL. **Hint:** EXCEPTION WHEN NO_DATA_FOUND THEN RETURN NULL;
13. **M13.** Nested block: inner block raises; outer block handles. **Hint:** BEGIN BEGIN ... RAISE e; END; EXCEPTION WHEN e THEN ... END;
14. **M14.** Handle VALUE_ERROR (e.g. string to number conversion). **Hint:** WHEN VALUE_ERROR THEN ...
15. **M15.** RAISE_APPLICATION_ERROR with user message including variable: 'Employee ' || v_id || ' not found'. **Hint:** RAISE_APPLICATION_ERROR(-20001, 'Employee ' || v_id || ' not found');
16. **M16.** Two handlers: first NO_DATA_FOUND, then OTHERS. **Hint:** WHEN NO_DATA_FOUND THEN ... WHEN OTHERS THEN ...
17. **M17.** In procedure, if SQL%ROWCOUNT = 0 then RAISE_APPLICATION_ERROR. **Hint:** IF SQL%ROWCOUNT = 0 THEN RAISE_APPLICATION_ERROR(-20001, 'No rows updated');
18. **M18.** Handle INVALID_CURSOR (e.g. fetch from closed cursor). **Hint:** WHEN INVALID_CURSOR THEN ...
19. **M19.** Log error then re-raise: INSERT INTO log_table (err_msg) VALUES (SQLERRM); RAISE; **Hint:** Use autonomous transaction if inserting in same table context.
20. **M20.** Custom exception with PRAGMA for ORA-01403 (NO_DATA_FOUND). **Hint:** e_none EXCEPTION; PRAGMA EXCEPTION_INIT(e_none, -1403);

### 20 Hard Questions

1. **H1.** Chain exceptions: in OTHERS get SQLCODE/SQLERRM, raise with RAISE_APPLICATION_ERROR(-20002, SQLERRM) to preserve message. **Hint:** WHEN OTHERS THEN RAISE_APPLICATION_ERROR(-20002, SQLERRM);
2. **H2.** Autonomous transaction procedure to log errors: log_err(p_msg); COMMIT in log_err so main transaction can roll back but log persists. **Hint:** PRAGMA AUTONOMOUS_TRANSACTION; INSERT INTO log_table ...; COMMIT;
3. **H3.** Handle multiple Oracle errors with one PRAGMA each: -1 (unique), -2291 (FK), -1407 (cannot insert NULL). **Hint:** Declare three exceptions with three PRAGMA EXCEPTION_INIT.
4. **H4.** In loop, continue on NO_DATA_FOUND (fetch next), exit on others. **Hint:** BEGIN ... FETCH ... EXCEPTION WHEN NO_DATA_FOUND THEN EXIT; WHEN OTHERS THEN RAISE; END;
5. **H5.** Function that returns VARCHAR2: on NO_DATA_FOUND return 'N/A', else return department_name. **Hint:** EXCEPTION WHEN NO_DATA_FOUND THEN RETURN 'N/A';
6. **H6.** Save exception in variable: e EXCEPTION; v_code NUMBER; v_msg VARCHAR2(4000); in OTHERS: v_code := SQLCODE; v_msg := SQLERRM; then process. **Hint:** Store in variables for later use (e.g. log).
7. **H7.** RAISE_APPLICATION_ERROR when salary < 0 in trigger or procedure. **Hint:** IF :NEW.salary < 0 THEN RAISE_APPLICATION_ERROR(-20002, 'Salary cannot be negative');
8. **H8.** Handle CURSOR_ALREADY_OPEN (open same cursor twice without close). **Hint:** WHEN CURSOR_ALREADY_OPEN THEN CLOSE c; then re-open or skip.
9. **H9.** Nested block: inner raises OTHERS and re-raises; outer catches and logs. **Hint:** Outer EXCEPTION WHEN OTHERS THEN log; (inner already re-raised).
10. **H10.** Create custom error codes -20001 to -20005 for different business rules; document. **Hint:** RAISE_APPLICATION_ERROR(-20001, 'Rule 1'); etc.
11. **H11.** In trigger, RAISE_APPLICATION_ERROR to abort DML. **Hint:** IF :NEW.salary < :OLD.salary THEN RAISE_APPLICATION_ERROR(-20002, 'No decrease');
12. **H12.** Procedure with OUT parameter for error message; on exception set p_err := SQLERRM and don't re-raise. **Hint:** EXCEPTION WHEN OTHERS THEN p_err := SQLERRM; (no RAISE)
13. **H13.** Handle ROWTYPE_MISMATCH (fetch into wrong type). **Hint:** WHEN ROWTYPE_MISMATCH THEN ...
14. **H14.** Retry logic: on deadlock (ORA-00060) retry 3 times. **Hint:** FOR i IN 1..3 LOOP BEGIN ... EXIT; EXCEPTION WHEN OTHERS THEN IF SQLCODE = -60 AND i < 3 THEN ... ELSE RAISE; END IF; END; END LOOP;
15. **H15.** Exception that carries a number: custom record type with (code NUMBER, msg VARCHAR2); raise with that. **Hint:** Use RAISE_APPLICATION_ERROR with code and message; or custom record in package.
16. **H16.** In OTHERS, check SQLCODE and handle only -1 (unique), else RAISE. **Hint:** WHEN OTHERS THEN IF SQLCODE = -1 THEN ... ELSE RAISE; END IF;
17. **H17.** Procedure that returns success/failure in OUT; on any exception set success := 0 and err_msg := SQLERRM. **Hint:** p_ok OUT NUMBER, p_err OUT VARCHAR2; EXCEPTION WHEN OTHERS THEN p_ok := 0; p_err := SQLERRM;
18. **H18.** PRAGMA EXCEPTION_INIT for ORA-02292 (child record exists). **Hint:** e_child EXCEPTION; PRAGMA EXCEPTION_INIT(e_child, -2292);
19. **H19.** Block that handles NO_DATA_FOUND and sets default value then continues (e.g. v_name := 'Unknown'). **Hint:** WHEN NO_DATA_FOUND THEN v_name := 'Unknown'; (then use v_name below — need structure so execution continues).
20. **H20.** Raise custom exception from nested block; outer handles and raises different RAISE_APPLICATION_ERROR with custom message. **Hint:** Inner RAISE e_custom; outer WHEN e_custom THEN RAISE_APPLICATION_ERROR(-20003, 'Business rule failed');

---

[← Back to Learning Plan](../30-day-sql-plsql-learning-plan.md) | [Tutorial](../tutorials/day24_exception_handling.md)
