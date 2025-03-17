
--------------------------------------------------
-- 1. Simple SELECT INTO Statement
--------------------------------------------------
DECLARE
    emp_name VARCHAR2(50);
BEGIN
    SELECT name INTO emp_name FROM employees WHERE id = 101;
    DBMS_OUTPUT.PUT_LINE('Employee Name: ' || emp_name);
END;
/

--------------------------------------------------
-- 2. SELECT Multiple Columns INTO Variables
--------------------------------------------------
DECLARE
    emp_name VARCHAR2(50);
    emp_salary NUMBER;
BEGIN
    SELECT name, salary INTO emp_name, emp_salary FROM employees WHERE id = 102;
    DBMS_OUTPUT.PUT_LINE('Employee: ' || emp_name || ', Salary: ' || emp_salary);
END;
/

--------------------------------------------------
-- 3. Handling No Data Found Exception
--------------------------------------------------
DECLARE
    emp_salary NUMBER;
BEGIN
    BEGIN
        SELECT salary INTO emp_salary FROM employees WHERE id = 999; -- Non-existing ID
        DBMS_OUTPUT.PUT_LINE('Salary: ' || emp_salary);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('No employee found with this ID.');
    END;
END;
/

--------------------------------------------------
-- 4. Using SELECT with CASE Statement
--------------------------------------------------
DECLARE
    emp_status VARCHAR2(20);
BEGIN
    SELECT 
        CASE 
            WHEN salary > 50000 THEN 'High Salary'
            ELSE 'Low Salary'
        END 
    INTO emp_status 
    FROM employees WHERE id = 103;
    
    DBMS_OUTPUT.PUT_LINE('Employee Status: ' || emp_status);
END;
/

--------------------------------------------------
-- 5. Using COUNT() with SELECT INTO
--------------------------------------------------
DECLARE
    total_employees NUMBER;
BEGIN
    SELECT COUNT(*) INTO total_employees FROM employees;
    DBMS_OUTPUT.PUT_LINE('Total Employees: ' || total_employees);
END;
/

--------------------------------------------------
-- 6. Fetching MAX Salary
--------------------------------------------------
DECLARE
    max_salary NUMBER;
BEGIN
    SELECT MAX(salary) INTO max_salary FROM employees;
    DBMS_OUTPUT.PUT_LINE('Highest Salary: ' || max_salary);
END;
/

--------------------------------------------------
-- 7. Fetching MIN Salary
--------------------------------------------------
DECLARE
    min_salary NUMBER;
BEGIN
    SELECT MIN(salary) INTO min_salary FROM employees;
    DBMS_OUTPUT.PUT_LINE('Lowest Salary: ' || min_salary);
END;
/

--------------------------------------------------
-- 8. Fetching AVG Salary
--------------------------------------------------
DECLARE
    avg_salary NUMBER;
BEGIN
    SELECT AVG(salary) INTO avg_salary FROM employees;
    DBMS_OUTPUT.PUT_LINE('Average Salary: ' || avg_salary);
END;
/

--------------------------------------------------
-- 9. Fetching Employee Name Using Subquery
--------------------------------------------------
DECLARE
    emp_name VARCHAR2(50);
BEGIN
    SELECT name INTO emp_name FROM employees 
    WHERE id = (SELECT MIN(id) FROM employees);
    DBMS_OUTPUT.PUT_LINE('First Employee: ' || emp_name);
END;
/

--------------------------------------------------
-- 10. Fetching Data Using EXISTS
--------------------------------------------------
DECLARE
    emp_exists VARCHAR2(10);
BEGIN
    SELECT 
        CASE 
            WHEN EXISTS (SELECT 1 FROM employees WHERE id = 105) THEN 'Yes'
            ELSE 'No'
        END 
    INTO emp_exists 
    FROM dual;
    
    DBMS_OUTPUT.PUT_LINE('Employee Exists: ' || emp_exists);
END;
/

--------------------------------------------------
-- 11. Selecting Employee with Highest Salary
--------------------------------------------------
DECLARE
    emp_name VARCHAR2(50);
BEGIN
    SELECT name INTO emp_name FROM employees 
    WHERE salary = (SELECT MAX(salary) FROM employees);
    DBMS_OUTPUT.PUT_LINE('Highest Paid Employee: ' || emp_name);
END;
/

--------------------------------------------------
-- 12. Fetching Department Name
--------------------------------------------------
DECLARE
    dept_name VARCHAR2(50);
BEGIN
    SELECT department_name INTO dept_name FROM departments WHERE department_id = 10;
    DBMS_OUTPUT.PUT_LINE('Department: ' || dept_name);
END;
/

--------------------------------------------------
-- 13. Fetching Employee Count in a Department
--------------------------------------------------
DECLARE
    emp_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO emp_count FROM employees WHERE department_id = 20;
    DBMS_OUTPUT.PUT_LINE('Employees in Department 20: ' || emp_count);
END;
/

--------------------------------------------------
-- 14. Fetching Sum of All Salaries
--------------------------------------------------
DECLARE
    total_salary NUMBER;
BEGIN
    SELECT SUM(salary) INTO total_salary FROM employees;
    DBMS_OUTPUT.PUT_LINE('Total Salaries: ' || total_salary);
END;
/

--------------------------------------------------
-- 15. Fetching Employee Joining Date
--------------------------------------------------
DECLARE
    hire_date DATE;
BEGIN
    SELECT hire_date INTO hire_date FROM employees WHERE id = 107;
    DBMS_OUTPUT.PUT_LINE('Employee Hire Date: ' || hire_date);
END;
/

--------------------------------------------------
-- 16. Selecting Second Highest Salary
--------------------------------------------------
DECLARE
    second_highest_salary NUMBER;
BEGIN
    SELECT DISTINCT salary INTO second_highest_salary FROM employees 
    WHERE salary < (SELECT MAX(salary) FROM employees) 
    ORDER BY salary DESC FETCH FIRST 1 ROW ONLY;
    
    DBMS_OUTPUT.PUT_LINE('Second Highest Salary: ' || second_highest_salary);
END;
/

--------------------------------------------------
-- 17. Selecting Employees with Same Salary as John
--------------------------------------------------
DECLARE
    emp_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO emp_count FROM employees 
    WHERE salary = (SELECT salary FROM employees WHERE name = 'John');
    
    DBMS_OUTPUT.PUT_LINE('Employees with John''s Salary: ' || emp_count);
END;
/

--------------------------------------------------
-- 18. Fetching Manager Name of an Employee
--------------------------------------------------
DECLARE
    manager_name VARCHAR2(50);
BEGIN
    SELECT name INTO manager_name FROM employees WHERE id = 
        (SELECT manager_id FROM employees WHERE id = 110);
    
    DBMS_OUTPUT.PUT_LINE('Manager: ' || manager_name);
END;
/

--------------------------------------------------
-- 19. Fetching Number of Employees Who Earn Above Average Salary
--------------------------------------------------
DECLARE
    count_above_avg NUMBER;
BEGIN
    SELECT COUNT(*) INTO count_above_avg FROM employees 
    WHERE salary > (SELECT AVG(salary) FROM employees);
    
    DBMS_OUTPUT.PUT_LINE('Employees Earning Above Average: ' || count_above_avg);
END;
/

--------------------------------------------------
-- 20. Fetching Employee Name and Role
--------------------------------------------------
DECLARE
    emp_name VARCHAR2(50);
    emp_role VARCHAR2(50);
BEGIN
    SELECT name, job_title INTO emp_name, emp_role FROM employees 
    WHERE id = 112;
    
    DBMS_OUTPUT.PUT_LINE('Employee: ' || emp_name || ', Role: ' || emp_role);
END;
/
