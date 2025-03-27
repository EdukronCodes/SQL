
-- PROCEDURE 1: Print Hello World
CREATE OR REPLACE PROCEDURE print_hello IS
BEGIN
  DBMS_OUTPUT.PUT_LINE('Hello, World!');
END;
/

-- PROCEDURE 2: Add Two Numbers
CREATE OR REPLACE PROCEDURE add_numbers(a IN NUMBER, b IN NUMBER) IS
  result NUMBER;
BEGIN
  result := a + b;
  DBMS_OUTPUT.PUT_LINE('Sum: ' || result);
END;
/

-- PROCEDURE 3: Insert a Record into Employees Table
CREATE OR REPLACE PROCEDURE insert_employee(p_id IN NUMBER, p_name IN VARCHAR2) IS
BEGIN
  INSERT INTO employees (emp_id, emp_name) VALUES (p_id, p_name);
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Employee inserted successfully');
END;
/

-- PROCEDURE 4: Update Salary of an Employee
CREATE OR REPLACE PROCEDURE update_salary(p_id IN NUMBER, new_salary IN NUMBER) IS
BEGIN
  UPDATE employees SET salary = new_salary WHERE emp_id = p_id;
  COMMIT;
END;
/

-- PROCEDURE 5: Delete Employee by ID
CREATE OR REPLACE PROCEDURE delete_employee(p_id IN NUMBER) IS
BEGIN
  DELETE FROM employees WHERE emp_id = p_id;
  COMMIT;
END;
/

-- PROCEDURE 6: Fetch Employee Name by ID
CREATE OR REPLACE PROCEDURE get_employee_name(p_id IN NUMBER) IS
  v_name employees.emp_name%TYPE;
BEGIN
  SELECT emp_name INTO v_name FROM employees WHERE emp_id = p_id;
  DBMS_OUTPUT.PUT_LINE('Employee Name: ' || v_name);
END;
/

-- PROCEDURE 7: Loop Through 1 to 5
CREATE OR REPLACE PROCEDURE loop_example IS
BEGIN
  FOR i IN 1..5 LOOP
    DBMS_OUTPUT.PUT_LINE('Iteration: ' || i);
  END LOOP;
END;
/

-- PROCEDURE 8: Count Total Employees
CREATE OR REPLACE PROCEDURE count_employees IS
  total NUMBER;
BEGIN
  SELECT COUNT(*) INTO total FROM employees;
  DBMS_OUTPUT.PUT_LINE('Total Employees: ' || total);
END;
/

-- PROCEDURE 9: Raise Custom Exception
CREATE OR REPLACE PROCEDURE raise_exception_example IS
  e_custom EXCEPTION;
BEGIN
  RAISE e_custom;
EXCEPTION
  WHEN e_custom THEN
    DBMS_OUTPUT.PUT_LINE('Custom Exception Raised');
END;
/

-- PROCEDURE 10: Display Current Date
CREATE OR REPLACE PROCEDURE show_date IS
BEGIN
  DBMS_OUTPUT.PUT_LINE('Today''s Date: ' || SYSDATE);
END;
/

-- PROCEDURE 11: Use of WHILE Loop
CREATE OR REPLACE PROCEDURE while_loop_example IS
  i NUMBER := 1;
BEGIN
  WHILE i <= 5 LOOP
    DBMS_OUTPUT.PUT_LINE('Value: ' || i);
    i := i + 1;
  END LOOP;
END;
/

-- PROCEDURE 12: Use of CASE Statement
CREATE OR REPLACE PROCEDURE grade_case(marks IN NUMBER) IS
BEGIN
  CASE
    WHEN marks >= 90 THEN DBMS_OUTPUT.PUT_LINE('Grade: A');
    WHEN marks >= 75 THEN DBMS_OUTPUT.PUT_LINE('Grade: B');
    WHEN marks >= 60 THEN DBMS_OUTPUT.PUT_LINE('Grade: C');
    ELSE DBMS_OUTPUT.PUT_LINE('Grade: D');
  END CASE;
END;
/

-- PROCEDURE 13: Sum of Numbers in Table
CREATE OR REPLACE PROCEDURE sum_salaries IS
  total NUMBER;
BEGIN
  SELECT SUM(salary) INTO total FROM employees;
  DBMS_OUTPUT.PUT_LINE('Total Salary: ' || total);
END;
/

-- PROCEDURE 14: Get Department Wise Employee Count
CREATE OR REPLACE PROCEDURE dept_employee_count IS
  CURSOR dept_cursor IS SELECT dept_id FROM departments;
  v_dept_id departments.dept_id%TYPE;
  v_count NUMBER;
BEGIN
  FOR rec IN dept_cursor LOOP
    v_dept_id := rec.dept_id;
    SELECT COUNT(*) INTO v_count FROM employees WHERE dept_id = v_dept_id;
    DBMS_OUTPUT.PUT_LINE('Dept ' || v_dept_id || ' has ' || v_count || ' employees');
  END LOOP;
END;
/

-- PROCEDURE 15: Log Error Message
CREATE OR REPLACE PROCEDURE log_error(p_msg IN VARCHAR2) IS
BEGIN
  INSERT INTO error_log (log_message, log_date) VALUES (p_msg, SYSDATE);
  COMMIT;
END;
/

-- PROCEDURE 16: Validate Age Input
CREATE OR REPLACE PROCEDURE validate_age(p_age IN NUMBER) IS
BEGIN
  IF p_age < 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Invalid age provided');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Age is valid');
  END IF;
END;
/

-- PROCEDURE 17: Reverse a String
CREATE OR REPLACE PROCEDURE reverse_string(p_str IN VARCHAR2) IS
  v_rev VARCHAR2(1000) := '';
BEGIN
  FOR i IN REVERSE 1..LENGTH(p_str) LOOP
    v_rev := v_rev || SUBSTR(p_str, i, 1);
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('Reversed String: ' || v_rev);
END;
/

-- PROCEDURE 18: Find Max Salary
CREATE OR REPLACE PROCEDURE max_salary IS
  v_max NUMBER;
BEGIN
  SELECT MAX(salary) INTO v_max FROM employees;
  DBMS_OUTPUT.PUT_LINE('Max Salary: ' || v_max);
END;
/

-- PROCEDURE 19: Log Login Details
CREATE OR REPLACE PROCEDURE log_login(p_user IN VARCHAR2) IS
BEGIN
  INSERT INTO login_audit (username, login_time) VALUES (p_user, SYSDATE);
  COMMIT;
END;
/

-- PROCEDURE 20: Get Employees in a Department
CREATE OR REPLACE PROCEDURE get_employees_by_dept(p_dept_id IN NUMBER) IS
  CURSOR emp_cursor IS SELECT emp_name FROM employees WHERE dept_id = p_dept_id;
BEGIN
  FOR rec IN emp_cursor LOOP
    DBMS_OUTPUT.PUT_LINE('Employee: ' || rec.emp_name);
  END LOOP;
END;
/
-- 1. Print Hello World
EXEC print_hello;

-- 2. Add Two Numbers (5 + 10)
EXEC add_numbers(5, 10);

-- 3. Insert a new Employee (ID: 101, Name: 'Alice')
EXEC insert_employee(101, 'Alice');

-- 4. Update Salary (ID: 101, New Salary: 55000)
EXEC update_salary(101, 55000);

-- 5. Delete Employee (ID: 101)
EXEC delete_employee(101);

-- 6. Get Employee Name by ID (ID: 102)
EXEC get_employee_name(102);

-- 7. Run a Simple FOR Loop
EXEC loop_example;

-- 8. Count All Employees
EXEC count_employees;

-- 9. Raise and Catch a Custom Exception
EXEC raise_exception_example;

-- 10. Show Current Date
EXEC show_date;

-- 11. Run a WHILE Loop from 1 to 5
EXEC while_loop_example;

-- 12. Print Grade Based on Marks (e.g., 82)
EXEC grade_case(82);

-- 13. Sum of Salaries in Employees Table
EXEC sum_salaries;

-- 14. Count Employees by Department (loop through departments)
EXEC dept_employee_count;

-- 15. Log Error Message
EXEC log_error('Null pointer exception occurred');

-- 16. Validate Age (should be non-negative)
EXEC validate_age(25);      -- Valid
-- EXEC validate_age(-5);   -- Uncomment to see application error

-- 17. Reverse a String
EXEC reverse_string('PLSQL');

-- 18. Find Maximum Salary
EXEC max_salary;

-- 19. Log Login of a User
EXEC log_login('mamatha');

-- 20. Get All Employees of a Specific Department (e.g., dept_id = 10)
EXEC get_employees_by_dept(10);


-- Step 1: Drop tables if exist (safe cleanup)
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE employee_audit';
  EXECUTE IMMEDIATE 'DROP TABLE employees';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/

-- Step 2: Create base employees table
CREATE TABLE employees (
  emp_id    NUMBER PRIMARY KEY,
  emp_name  VARCHAR2(100),
  salary    NUMBER,
  dept_id   NUMBER
);

-- Step 3: Create audit table
CREATE TABLE employee_audit (
  audit_id     NUMBER GENERATED ALWAYS AS IDENTITY,
  emp_id       NUMBER,
  action       VARCHAR2(20),
  changed_by   VARCHAR2(100),
  change_time  TIMESTAMP DEFAULT SYSTIMESTAMP,
  old_salary   NUMBER,
  new_salary   NUMBER
);

-- TRIGGER 1: BEFORE INSERT (Validate Salary)
CREATE OR REPLACE TRIGGER trg_validate_salary
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
  IF :NEW.salary < 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Salary must be non-negative');
  END IF;
END;
/

-- TRIGGER 2: AFTER INSERT (Log to audit table)
CREATE OR REPLACE TRIGGER trg_after_insert
AFTER INSERT ON employees
FOR EACH ROW
BEGIN
  INSERT INTO employee_audit(emp_id, action, changed_by)
  VALUES (:NEW.emp_id, 'INSERT', USER);
END;
/

-- TRIGGER 3: BEFORE UPDATE (Track salary change)
CREATE OR REPLACE TRIGGER trg_track_salary
BEFORE UPDATE OF salary ON employees
FOR EACH ROW
BEGIN
  IF :OLD.salary <> :NEW.salary THEN
    INSERT INTO employee_audit(emp_id, action, changed_by, old_salary, new_salary)
    VALUES (:OLD.emp_id, 'SALARY UPDATE', USER, :OLD.salary, :NEW.salary);
  END IF;
END;
/

-- TRIGGER 4: AFTER DELETE (Log deletion)
CREATE OR REPLACE TRIGGER trg_log_delete
AFTER DELETE ON employees
FOR EACH ROW
BEGIN
  INSERT INTO employee_audit(emp_id, action, changed_by)
  VALUES (:OLD.emp_id, 'DELETE', USER);
END;
/

-- TRIGGER 5: BEFORE UPDATE (Prevent name change)
CREATE OR REPLACE TRIGGER trg_no_name_change
BEFORE UPDATE OF emp_name ON employees
FOR EACH ROW
BEGIN
  IF :OLD.emp_name <> :NEW.emp_name THEN
    RAISE_APPLICATION_ERROR(-20002, 'Changing name is not allowed');
  END IF;
END;
/

-- TRIGGER 6: Statement-Level BEFORE INSERT
CREATE OR REPLACE TRIGGER trg_stmt_before_insert
BEFORE INSERT ON employees
BEGIN
  DBMS_OUTPUT.PUT_LINE('Before Insert Trigger fired (Statement-Level)');
END;
/

-- TRIGGER 7: Statement-Level AFTER UPDATE
CREATE OR REPLACE TRIGGER trg_stmt_after_update
AFTER UPDATE ON employees
BEGIN
  DBMS_OUTPUT.PUT_LINE('After Update Trigger fired (Statement-Level)');
END;
/

-- TRIGGER 8: Log All Actions to Console
CREATE OR REPLACE TRIGGER trg_log_console
AFTER INSERT OR UPDATE OR DELETE ON employees
FOR EACH ROW
BEGIN
  DBMS_OUTPUT.PUT_LINE('Action on Employee ID: ' || NVL(:NEW.emp_id, :OLD.emp_id));
END;
/

-- TRIGGER 9: BEFORE DELETE (Prevent Deletion if salary > 50000)
CREATE OR REPLACE TRIGGER trg_prevent_delete_high_salary
BEFORE DELETE ON employees
FOR EACH ROW
BEGIN
  IF :OLD.salary > 50000 THEN
    RAISE_APPLICATION_ERROR(-20003, 'Cannot delete employees with high salary');
  END IF;
END;
/

-- TRIGGER 10: Conditional Trigger for Specific Department
CREATE OR REPLACE TRIGGER trg_check_dept
BEFORE INSERT ON employees
FOR EACH ROW
WHEN (NEW.dept_id = 10)
BEGIN
  DBMS_OUTPUT.PUT_LINE('Inserting into department 10');
END;
/

-- TRIGGER 11: Cascade DELETE (Example – if dept was related)
-- Placeholder: No department table created. Skip for now.

-- TRIGGER 12: Maintain audit on emp_name change
CREATE OR REPLACE TRIGGER trg_name_audit
BEFORE UPDATE OF emp_name ON employees
FOR EACH ROW
BEGIN
  INSERT INTO employee_audit(emp_id, action, changed_by)
  VALUES (:OLD.emp_id, 'NAME CHANGE', USER);
END;
/

-- TRIGGER 13: Prevent Duplicate Employee IDs (already covered by PK)
-- No separate trigger required.

-- TRIGGER 14: BEFORE UPDATE – log every update attempt
CREATE OR REPLACE TRIGGER trg_any_update
BEFORE UPDATE ON employees
FOR EACH ROW
BEGIN
  DBMS_OUTPUT.PUT_LINE('Updating record for emp_id: ' || :OLD.emp_id);
END;
/

-- TRIGGER 15: AFTER UPDATE – confirm success
CREATE OR REPLACE TRIGGER trg_confirm_update
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
  DBMS_OUTPUT.PUT_LINE('Update complete for emp_id: ' || :NEW.emp_id);
END;
/

-- TRIGGER 16: Prevent Salary Cut
CREATE OR REPLACE TRIGGER trg_no_salary_cut
BEFORE UPDATE OF salary ON employees
FOR EACH ROW
BEGIN
  IF :NEW.salary < :OLD.salary THEN
    RAISE_APPLICATION_ERROR(-20004, 'Salary cannot be decreased');
  END IF;
END;
/

-- TRIGGER 17: Maintain History Table (simulate)
-- Not implemented – would need a history table.

-- TRIGGER 18: Compound Trigger Example
CREATE OR REPLACE TRIGGER trg_compound_example
FOR INSERT ON employees
COMPOUND TRIGGER
  v_counter NUMBER := 0;
AFTER EACH ROW IS
BEGIN
  v_counter := v_counter + 1;
END AFTER EACH ROW;
AFTER STATEMENT IS
BEGIN
  DBMS_OUTPUT.PUT_LINE('Inserted ' || v_counter || ' rows in one statement.');
END AFTER STATEMENT;
END;
/

-- TRIGGER 19: BEFORE INSERT – auto uppercase name
CREATE OR REPLACE TRIGGER trg_uppercase_name
BEFORE INSERT OR UPDATE ON employees
FOR EACH ROW
BEGIN
  :NEW.emp_name := UPPER(:NEW.emp_name);
END;
/

-- TRIGGER 20: AFTER DELETE – record deletion time
CREATE OR REPLACE TRIGGER trg_record_delete_time
AFTER DELETE ON employees
FOR EACH ROW
BEGIN
  INSERT INTO employee_audit(emp_id, action, changed_by)
  VALUES (:OLD.emp_id, 'DELETED @ ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), USER);
END;
/
-- DROP TABLE AND SEQUENCE IF EXISTS
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE employees_seq_demo';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'DROP SEQUENCE emp_seq';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

-- CREATE EMPLOYEE TABLE
CREATE TABLE employees_seq_demo (
  emp_id   NUMBER PRIMARY KEY,
  emp_name VARCHAR2(100),
  salary   NUMBER,
  dept_id  NUMBER
);

-- CREATE SEQUENCE
CREATE SEQUENCE emp_seq
  START WITH 1001
  INCREMENT BY 1
  NOCACHE
  NOCYCLE;

-- 1. Basic Insert using NEXTVAL
INSERT INTO employees_seq_demo VALUES (emp_seq.NEXTVAL, 'Alice', 40000, 10);

-- 2. Insert two more employees using sequence
INSERT INTO employees_seq_demo VALUES (emp_seq.NEXTVAL, 'Bob', 42000, 20);
INSERT INTO employees_seq_demo VALUES (emp_seq.NEXTVAL, 'Charlie', 43000, 30);

-- 3. Using sequence in PL/SQL block
DECLARE
  v_id NUMBER;
BEGIN
  v_id := emp_seq.NEXTVAL;
  INSERT INTO employees_seq_demo VALUES (v_id, 'David', 44000, 40);
END;
/

-- 4. Using CURRVAL after NEXTVAL
DECLARE
  new_id NUMBER;
BEGIN
  new_id := emp_seq.NEXTVAL;
  DBMS_OUTPUT.PUT_LINE('New ID: ' || emp_seq.CURRVAL);
  INSERT INTO employees_seq_demo VALUES (emp_seq.CURRVAL, 'Eva', 45000, 50);
END;
/

-- 5. Bulk insert with sequence in loop
BEGIN
  FOR i IN 1..5 LOOP
    INSERT INTO employees_seq_demo
    VALUES (emp_seq.NEXTVAL, 'BulkEmp_' || i, 30000 + i * 1000, 60);
  END LOOP;
END;
/

-- 6. BEFORE INSERT trigger to auto-generate emp_id
CREATE OR REPLACE TRIGGER trg_auto_id_seq
BEFORE INSERT ON employees_seq_demo
FOR EACH ROW
WHEN (NEW.emp_id IS NULL)
BEGIN
  :NEW.emp_id := emp_seq.NEXTVAL;
END;
/

-- 7. Insert without emp_id, use trigger
INSERT INTO employees_seq_demo (emp_name, salary, dept_id)
VALUES ('George', 47000, 20);

-- 8. MERGE using sequence
MERGE INTO employees_seq_demo e
USING (SELECT 'Helen' AS name, 55000 AS sal FROM dual) s
ON (e.emp_name = s.name)
WHEN NOT MATCHED THEN
  INSERT (emp_id, emp_name, salary, dept_id)
  VALUES (emp_seq.NEXTVAL, s.name, s.sal, 70);

-- 9. Function to return next emp_id
CREATE OR REPLACE FUNCTION get_next_emp_id RETURN NUMBER IS
BEGIN
  RETURN emp_seq.NEXTVAL;
END;
/

-- 10. Use function in insert
INSERT INTO employees_seq_demo VALUES (get_next_emp_id(), 'Ian', 48000, 80);

-- 11. Temp table insert with sequence
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE temp_ids';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

CREATE GLOBAL TEMPORARY TABLE temp_ids (
  id NUMBER
) ON COMMIT PRESERVE ROWS;

INSERT INTO temp_ids VALUES (emp_seq.NEXTVAL);

-- 12. Show current value of sequence
BEGIN
  DBMS_OUTPUT.PUT_LINE('Current sequence value: ' || emp_seq.CURRVAL);
END;
/

-- 13. Procedure to insert employee with sequence
CREATE OR REPLACE PROCEDURE add_employee(p_name VARCHAR2, p_salary NUMBER, p_dept NUMBER) IS
BEGIN
  INSERT INTO employees_seq_demo VALUES (emp_seq.NEXTVAL, p_name, p_salary, p_dept);
END;
/

-- Call the procedure
BEGIN
  add_employee('Jack', 49000, 90);
END;
/

-- 14. SELECT INTO with sequence
DECLARE
  new_id NUMBER;
BEGIN
  SELECT emp_seq.NEXTVAL INTO new_id FROM dual;
  INSERT INTO employees_seq_demo VALUES (new_id, 'Kelly', 46000, 100);
END;
/

-- 15. Simulated order number
DECLARE
  order_id NUMBER := emp_seq.NEXTVAL;
BEGIN
  DBMS_OUTPUT.PUT_LINE('Generated Order ID: ' || order_id);
END;
/

-- 16. Pagination-style query
SELECT * FROM employees_seq_demo WHERE emp_id BETWEEN 1005 AND 1010;

-- 17. Insert from collection using sequence
DECLARE
  TYPE emp_names_t IS TABLE OF VARCHAR2(100);
  names emp_names_t := emp_names_t('Liam', 'Mia', 'Noah');
BEGIN
  FOR i IN 1 .. names.COUNT LOOP
    INSERT INTO employees_seq_demo
    VALUES (emp_seq.NEXTVAL, names(i), 50000 + i * 1000, 110);
  END LOOP;
END;
/

-- 18. Reset the sequence to a new starting point
BEGIN
  EXECUTE IMMEDIATE 'DROP SEQUENCE emp_seq';
  EXECUTE IMMEDIATE 'CREATE SEQUENCE emp_seq START WITH 2001 INCREMENT BY 1';
END;
/

-- Insert after reset
INSERT INTO employees_seq_demo VALUES (emp_seq.NEXTVAL, 'Olivia', 52000, 120);

-- 19. INSERT-SELECT with sequence
INSERT INTO employees_seq_demo (emp_id, emp_name, salary, dept_id)
SELECT emp_seq.NEXTVAL, 'Auto_' || LEVEL, 30000 + LEVEL * 1000, 130
FROM dual CONNECT BY LEVEL <= 3;

-- 20. JSON-like insert (simulate API)
DECLARE
  new_id NUMBER := emp_seq.NEXTVAL;
BEGIN
  INSERT INTO employees_seq_demo
  VALUES (new_id, 'JSON_Insert_' || new_id, 60000, 140);
END;
/

-- FINAL: View All Data
SELECT * FROM employees_seq_demo ORDER BY emp_id;
