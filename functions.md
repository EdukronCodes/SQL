-- ==========================================================
-- 30 FUNCTION EXAMPLES BASED ON HR.EMPLOYEES TABLE
-- ==========================================================
SET SERVEROUTPUT ON;

-- 1️⃣ Get Full Name
CREATE OR REPLACE FUNCTION fn_get_full_name(p_emp_id NUMBER)
RETURN VARCHAR2 IS
  v_name VARCHAR2(100);
BEGIN
  SELECT first_name || ' ' || last_name INTO v_name
  FROM employees WHERE employee_id = p_emp_id;
  RETURN v_name;
END;
/

-- 2️⃣ Get Annual Salary
CREATE OR REPLACE FUNCTION fn_annual_salary(p_emp_id NUMBER)
RETURN NUMBER IS
  v_sal NUMBER;
BEGIN
  SELECT salary*12 INTO v_sal FROM employees WHERE employee_id = p_emp_id;
  RETURN v_sal;
END;
/

-- 3️⃣ Get Department Name
CREATE OR REPLACE FUNCTION fn_department_name(p_emp_id NUMBER)
RETURN VARCHAR2 IS
  v_dname VARCHAR2(100);
BEGIN
  SELECT d.department_name INTO v_dname
  FROM employees e JOIN departments d ON e.department_id = d.department_id
  WHERE e.employee_id = p_emp_id;
  RETURN v_dname;
END;
/

-- 4️⃣ Get Job Title
CREATE OR REPLACE FUNCTION fn_job_title(p_emp_id NUMBER)
RETURN VARCHAR2 IS
  v_job VARCHAR2(100);
BEGIN
  SELECT j.job_title INTO v_job
  FROM employees e JOIN jobs j ON e.job_id=j.job_id
  WHERE e.employee_id=p_emp_id;
  RETURN v_job;
END;
/

-- 5️⃣ Calculate Experience (Years)
CREATE OR REPLACE FUNCTION fn_experience(p_emp_id NUMBER)
RETURN NUMBER IS
  v_date DATE;
BEGIN
  SELECT hire_date INTO v_date FROM employees WHERE employee_id=p_emp_id;
  RETURN TRUNC(MONTHS_BETWEEN(SYSDATE,v_date)/12);
END;
/

-- 6️⃣ Calculate Bonus (10%)
CREATE OR REPLACE FUNCTION fn_bonus(p_emp_id NUMBER)
RETURN NUMBER IS
  v_sal NUMBER;
BEGIN
  SELECT salary*0.10 INTO v_sal FROM employees WHERE employee_id=p_emp_id;
  RETURN v_sal;
END;
/

-- 7️⃣ Get Manager Name
CREATE OR REPLACE FUNCTION fn_manager_name(p_emp_id NUMBER)
RETURN VARCHAR2 IS
  v_mname VARCHAR2(100);
BEGIN
  SELECT m.first_name || ' ' || m.last_name INTO v_mname
  FROM employees e JOIN employees m ON e.manager_id=m.employee_id
  WHERE e.employee_id=p_emp_id;
  RETURN v_mname;
END;
/

-- 8️⃣ Get Commission in Percentage
CREATE OR REPLACE FUNCTION fn_commission_pct(p_emp_id NUMBER)
RETURN VARCHAR2 IS
  v_comm employees.commission_pct%TYPE;
BEGIN
  SELECT NVL(commission_pct,0) INTO v_comm FROM employees WHERE employee_id=p_emp_id;
  RETURN TO_CHAR(v_comm*100)||'%';
END;
/

-- 9️⃣ Get Salary Grade
CREATE OR REPLACE FUNCTION fn_salary_grade(p_salary NUMBER)
RETURN VARCHAR2 IS
BEGIN
  IF p_salary < 5000 THEN
    RETURN 'LOW';
  ELSIF p_salary BETWEEN 5000 AND 10000 THEN
    RETURN 'MEDIUM';
  ELSE
    RETURN 'HIGH';
  END IF;
END;
/

-- 🔟 Get Email in Uppercase
CREATE OR REPLACE FUNCTION fn_email_upper(p_emp_id NUMBER)
RETURN VARCHAR2 IS
  v_mail VARCHAR2(100);
BEGIN
  SELECT UPPER(email) INTO v_mail FROM employees WHERE employee_id=p_emp_id;
  RETURN v_mail;
END;
/

-- 11️⃣ Get Hire Year
CREATE OR REPLACE FUNCTION fn_hire_year(p_emp_id NUMBER)
RETURN NUMBER IS
  v_year NUMBER;
BEGIN
  SELECT EXTRACT(YEAR FROM hire_date) INTO v_year FROM employees WHERE employee_id=p_emp_id;
  RETURN v_year;
END;
/

-- 12️⃣ Get Salary After Hike (10%)
CREATE OR REPLACE FUNCTION fn_salary_hike(p_emp_id NUMBER)
RETURN NUMBER IS
  v_hike NUMBER;
BEGIN
  SELECT salary*1.10 INTO v_hike FROM employees WHERE employee_id=p_emp_id;
  RETURN v_hike;
END;
/

-- 13️⃣ Get Hire Month
CREATE OR REPLACE FUNCTION fn_hire_month(p_emp_id NUMBER)
RETURN VARCHAR2 IS
  v_month VARCHAR2(20);
BEGIN
  SELECT TO_CHAR(hire_date,'MONTH') INTO v_month FROM employees WHERE employee_id=p_emp_id;
  RETURN TRIM(v_month);
END;
/

-- 14️⃣ Check High Earner
CREATE OR REPLACE FUNCTION fn_is_high_earner(p_emp_id NUMBER)
RETURN VARCHAR2 IS
  v_sal NUMBER;
BEGIN
  SELECT salary INTO v_sal FROM employees WHERE employee_id=p_emp_id;
  RETURN CASE WHEN v_sal > 10000 THEN 'YES' ELSE 'NO' END;
END;
/

-- 15️⃣ Get Country Name
CREATE OR REPLACE FUNCTION fn_country_name(p_emp_id NUMBER)
RETURN VARCHAR2 IS
  v_country VARCHAR2(100);
BEGIN
  SELECT c.country_name INTO v_country
  FROM employees e
  JOIN departments d ON e.department_id=d.department_id
  JOIN locations l ON d.location_id=l.location_id
  JOIN countries c ON l.country_id=c.country_id
  WHERE e.employee_id=p_emp_id;
  RETURN v_country;
END;
/

-- 16️⃣ Get Days Worked
CREATE OR REPLACE FUNCTION fn_days_worked(p_emp_id NUMBER)
RETURN NUMBER IS
  v_hire DATE;
BEGIN
  SELECT hire_date INTO v_hire FROM employees WHERE employee_id=p_emp_id;
  RETURN TRUNC(SYSDATE - v_hire);
END;
/

-- 17️⃣ Get Initials
CREATE OR REPLACE FUNCTION fn_initials(p_emp_id NUMBER)
RETURN VARCHAR2 IS
  v_init VARCHAR2(10);
BEGIN
  SELECT SUBSTR(first_name,1,1) || SUBSTR(last_name,1,1) INTO v_init
  FROM employees WHERE employee_id=p_emp_id;
  RETURN v_init;
END;
/

-- 18️⃣ Get First Name Length
CREATE OR REPLACE FUNCTION fn_fname_length(p_emp_id NUMBER)
RETURN NUMBER IS
  v_len NUMBER;
BEGIN
  SELECT LENGTH(first_name) INTO v_len FROM employees WHERE employee_id=p_emp_id;
  RETURN v_len;
END;
/

-- 19️⃣ Get Hire Day Name
CREATE OR REPLACE FUNCTION fn_hire_day(p_emp_id NUMBER)
RETURN VARCHAR2 IS
  v_day VARCHAR2(10);
BEGIN
  SELECT TO_CHAR(hire_date,'DAY') INTO v_day FROM employees WHERE employee_id=p_emp_id;
  RETURN TRIM(v_day);
END;
/

-- 20️⃣ Get Salary Difference from Average
CREATE OR REPLACE FUNCTION fn_salary_diff(p_emp_id NUMBER)
RETURN NUMBER IS
  v_sal NUMBER; v_avg NUMBER;
BEGIN
  SELECT salary INTO v_sal FROM employees WHERE employee_id=p_emp_id;
  SELECT AVG(salary) INTO v_avg FROM employees;
  RETURN v_sal - v_avg;
END;
/

-- 21️⃣ Get Department Average Salary
CREATE OR REPLACE FUNCTION fn_dept_avg_salary(p_emp_id NUMBER)
RETURN NUMBER IS
  v_avg NUMBER; v_dept NUMBER;
BEGIN
  SELECT department_id INTO v_dept FROM employees WHERE employee_id=p_emp_id;
  SELECT AVG(salary) INTO v_avg FROM employees WHERE department_id=v_dept;
  RETURN v_avg;
END;
/

-- 22️⃣ Get Manager ID
CREATE OR REPLACE FUNCTION fn_manager_id(p_emp_id NUMBER)
RETURN NUMBER IS
  v_mid NUMBER;
BEGIN
  SELECT manager_id INTO v_mid FROM employees WHERE employee_id=p_emp_id;
  RETURN v_mid;
END;
/

-- 23️⃣ Get Department ID
CREATE OR REPLACE FUNCTION fn_dept_id(p_emp_id NUMBER)
RETURN NUMBER IS
  v_did NUMBER;
BEGIN
  SELECT department_id INTO v_did FROM employees WHERE employee_id=p_emp_id;
  RETURN v_did;
END;
/

-- 24️⃣ Get Hire Date in 'DD-MON-YYYY'
CREATE OR REPLACE FUNCTION fn_hire_date_str(p_emp_id NUMBER)
RETURN VARCHAR2 IS
  v_hd VARCHAR2(30);
BEGIN
  SELECT TO_CHAR(hire_date,'DD-MON-YYYY') INTO v_hd FROM employees WHERE employee_id=p_emp_id;
  RETURN v_hd;
END;
/

-- 25️⃣ Get Employee Age (approx)
CREATE OR REPLACE FUNCTION fn_emp_age(p_hire_date DATE)
RETURN NUMBER IS
BEGIN
  RETURN TRUNC(MONTHS_BETWEEN(SYSDATE,p_hire_date)/12);
END;
/

-- 26️⃣ Get Employees Count in Dept
CREATE OR REPLACE FUNCTION fn_emp_count_dept(p_dept_id NUMBER)
RETURN NUMBER IS
  v_cnt NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_cnt FROM employees WHERE department_id=p_dept_id;
  RETURN v_cnt;
END;
/

-- 27️⃣ Get Last Name in Reverse
CREATE OR REPLACE FUNCTION fn_reverse_lname(p_emp_id NUMBER)
RETURN VARCHAR2 IS
  v_rev VARCHAR2(100);
BEGIN
  SELECT REVERSE(last_name) INTO v_rev FROM employees WHERE employee_id=p_emp_id;
  RETURN v_rev;
END;
/

-- 28️⃣ Get Email Domain
CREATE OR REPLACE FUNCTION fn_email_domain(p_emp_id NUMBER)
RETURN VARCHAR2 IS
  v_email VARCHAR2(100);
BEGIN
  SELECT email || '@company.com' INTO v_email FROM employees WHERE employee_id=p_emp_id;
  RETURN v_email;
END;
/

-- 29️⃣ Get Hire Quarter
CREATE OR REPLACE FUNCTION fn_hire_quarter(p_emp_id NUMBER)
RETURN VARCHAR2 IS
  v_qtr VARCHAR2(10);
BEGIN
  SELECT 'Q' || TO_CHAR(hire_date,'Q') INTO v_qtr FROM employees WHERE employee_id=p_emp_id;
  RETURN v_qtr;
END;
/

-- 30️⃣ Get Formatted Employee Summary
CREATE OR REPLACE FUNCTION fn_emp_summary(p_emp_id NUMBER)
RETURN VARCHAR2 IS
  v_summary VARCHAR2(200);
BEGIN
  SELECT first_name || ' ' || last_name || ' (' || job_id || ') earns ' ||
         TO_CHAR(salary,'$999,999.00') INTO v_summary
  FROM employees WHERE employee_id=p_emp_id;
  RETURN v_summary;
END;
/

-- ==========================================================
-- ✅ SAMPLE TEST CALLS
-- ==========================================================
BEGIN
  DBMS_OUTPUT.PUT_LINE('Name: '||fn_get_full_name(101));
  DBMS_OUTPUT.PUT_LINE('Dept: '||fn_department_name(101));
  DBMS_OUTPUT.PUT_LINE('Experience: '||fn_experience(101)||' years');
  DBMS_OUTPUT.PUT_LINE('Bonus: '||fn_bonus(101));
  DBMS_OUTPUT.PUT_LINE('Manager: '||fn_manager_name(101));
  DBMS_OUTPUT.PUT_LINE('Summary: '||fn_emp_summary(101));
END;
/
