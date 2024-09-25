
-- 1. Select all columns from employees table
SELECT * FROM hr.employees;

-- 2. Select employee's first and last names
SELECT first_name, last_name FROM hr.employees;

-- 3. Select distinct job titles from employees
SELECT DISTINCT job_title FROM hr.employees;

-- 4. Select employees with salary greater than 50000
SELECT * FROM hr.employees WHERE salary > 50000;

-- 5. Select employees hired after January 1, 2020
SELECT * FROM hr.employees WHERE hire_date > '2020-01-01';

-- 6. Select employees in department ID 10
SELECT * FROM hr.employees WHERE department_id = 10;

-- 7. Select employees with the first name starting with 'A'
SELECT * FROM hr.employees WHERE first_name LIKE 'A%';

-- 8. Select employee details ordered by hire date
SELECT * FROM hr.employees ORDER BY hire_date;

-- 9. Select the top 5 highest paid employees
SELECT * FROM hr.employees ORDER BY salary DESC LIMIT 5;

-- 10. Select employees with salary between 40000 and 60000
SELECT * FROM hr.employees WHERE salary BETWEEN 40000 AND 60000;

-- 11. Count the number of employees
SELECT COUNT(*) FROM hr.employees;

-- 12. Count the number of employees in department 20
SELECT COUNT(*) FROM hr.employees WHERE department_id = 20;

-- 13. Find the minimum salary in the employees table
SELECT MIN(salary) FROM hr.employees;

-- 14. Find the maximum salary in the employees table
SELECT MAX(salary) FROM hr.employees;

-- 15. Find the average salary of employees
SELECT AVG(salary) FROM hr.employees;

-- 16. Sum the total salaries of all employees
SELECT SUM(salary) FROM hr.employees;

-- 17. Count employees grouped by department_id
SELECT department_id, COUNT(*) FROM hr.employees GROUP BY department_id;

-- 18. Find the average salary per department
SELECT department_id, AVG(salary) FROM hr.employees GROUP BY department_id;

-- 19. Count employees with salary greater than 60000
SELECT COUNT(*) FROM hr.employees WHERE salary > 60000;

-- 20. Find the total salary by department
SELECT department_id, SUM(salary) FROM hr.employees GROUP BY department_id;

-- 21. Select employees with job title 'Manager'
SELECT * FROM hr.employees WHERE job_title = 'Manager';

-- 22. Select employees not in department 30
SELECT * FROM hr.employees WHERE department_id != 30;

-- 23. Select employees with salary less than 30000
SELECT * FROM hr.employees WHERE salary < 30000;

-- 24. Select employees with a NULL commission_pct
SELECT * FROM hr.employees WHERE commission_pct IS NULL;

-- 25. Select employees with a non-NULL commission_pct
SELECT * FROM hr.employees WHERE commission_pct IS NOT NULL;

-- 26. Find employees who were hired in 2015
SELECT * FROM hr.employees WHERE EXTRACT(YEAR FROM hire_date) = 2015;

-- 27. Select the first 10 employees ordered by last name
SELECT * FROM hr.employees ORDER BY last_name LIMIT 10;

-- 28. Select employees who have been hired within the last 2 years
SELECT * FROM hr.employees WHERE hire_date >= (CURRENT_DATE - INTERVAL '2 years');

-- 29. Select employees with 'Senior' in their job title
SELECT * FROM hr.employees WHERE job_title LIKE '%Senior%';

-- 30. Select employees with first name containing 'John'
SELECT * FROM hr.employees WHERE first_name LIKE '%John%';

-- 31. Select employees whose last name starts with 'S' and salary greater than 50000
SELECT * FROM hr.employees WHERE last_name LIKE 'S%' AND salary > 50000;

-- 32. Select employees ordered by department_id and salary
SELECT * FROM hr.employees ORDER BY department_id, salary DESC;

-- 33. Count the number of employees in each job title
SELECT job_title, COUNT(*) FROM hr.employees GROUP BY job_title;

-- 34. Find the maximum salary in department 50
SELECT MAX(salary) FROM hr.employees WHERE department_id = 50;

-- 35. Select employees with hire date in the last 6 months
SELECT * FROM hr.employees WHERE hire_date >= (CURRENT_DATE - INTERVAL '6 months');

-- 36. Select employees ordered by hire_date descending
SELECT * FROM hr.employees ORDER BY hire_date DESC;

-- 37. Select employees who do not have a manager
SELECT * FROM hr.employees WHERE manager_id IS NULL;

-- 38. Select employees with the highest salary in each department
SELECT department_id, MAX(salary) FROM hr.employees GROUP BY department_id;

-- 39. Select employees with salaries higher than the department average
SELECT * FROM hr.employees WHERE salary > (SELECT AVG(salary) FROM hr.employees);

-- 40. Find the total salary expenditure for department 10
SELECT SUM(salary) FROM hr.employees WHERE department_id = 10;

-- 41. Find employees with job title that contains 'Developer'
SELECT * FROM hr.employees WHERE job_title LIKE '%Developer%';

-- 42. Select employees with salary in the top 10%
SELECT * FROM hr.employees WHERE salary >= (SELECT PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY salary) FROM hr.employees);

-- 43. Select employees who have been in the company for more than 10 years
SELECT * FROM hr.employees WHERE hire_date <= (CURRENT_DATE - INTERVAL '10 years');

-- 44. Find employees whose first name is 5 characters long
SELECT * FROM hr.employees WHERE LENGTH(first_name) = 5;

-- 45. Select employees who have 'Admin' in their job title
SELECT * FROM hr.employees WHERE job_title LIKE '%Admin%';

-- 46. Find the earliest hire date in the company
SELECT MIN(hire_date) FROM hr.employees;

-- 47. Find the department with the highest average salary
SELECT department_id FROM hr.employees GROUP BY department_id ORDER BY AVG(salary) DESC LIMIT 1;

-- 48. Select employees who are managers
SELECT * FROM hr.employees WHERE employee_id IN (SELECT DISTINCT manager_id FROM hr.employees WHERE manager_id IS NOT NULL);

-- 49. Find the number of employees in each salary range
SELECT 
    CASE 
        WHEN salary < 30000 THEN 'Low'
        WHEN salary BETWEEN 30000 AND 60000 THEN 'Medium'
        ELSE 'High'
    END AS salary_range, COUNT(*)
FROM hr.employees
GROUP BY salary_range;

-- 50. Select employees with odd-numbered employee IDs
SELECT * FROM hr.employees WHERE MOD(employee_id, 2) = 1;

-- 51. Find the highest salary in each department, showing the department name and salary
SELECT d.department_name, MAX(e.salary) 
FROM hr.employees e 
JOIN hr.departments d ON e.department_id = d.department_id
GROUP BY d.department_name;

-- 52. Find employees who earn more than their managers
SELECT e.first_name, e.last_name
FROM hr.employees e
JOIN hr.employees m ON e.manager_id = m.employee_id
WHERE e.salary > m.salary;

-- 53. Find employees who have the same job title as their managers
SELECT e.first_name, e.last_name
FROM hr.employees e
JOIN hr.employees m ON e.manager_id = m.employee_id
WHERE e.job_title = m.job_title;

-- 54. Select employees who are in departments with more than 10 employees
SELECT * FROM hr.employees WHERE department_id IN (
  SELECT department_id 
  FROM hr.employees 
  GROUP BY department_id 
  HAVING COUNT(*) > 10
);

-- 55. Select employees with the highest salary in each department, without using subqueries
WITH DepartmentMaxSalaries AS (
    SELECT department_id, MAX(salary) AS max_salary 
    FROM hr.employees 
    GROUP BY department_id
)
SELECT e.*
FROM hr.employees e
JOIN DepartmentMaxSalaries dms ON e.department_id = dms.department_id AND e.salary = dms.max_salary;

-- 56. Find employees who earn more than the average salary in their department
SELECT * FROM hr.employees e
WHERE e.salary > (SELECT AVG(salary) FROM hr.employees WHERE department_id = e.department_id);

-- 57. Select employees with hire dates in the year 2021
SELECT * FROM hr.employees WHERE EXTRACT(YEAR FROM hire_date) = 2021;

-- 58. Find employees who have changed departments (have more than one department_id in their employment history)
SELECT employee_id
FROM hr.employee_history
GROUP BY employee_id
HAVING COUNT(DISTINCT department_id) > 1;

-- 59. Select employees with a salary in the 75th percentile
SELECT * 
FROM hr.employees
WHERE salary >= (SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY salary) FROM hr.employees);

-- 60. Find departments with no employees
SELECT d.department_name
FROM hr.departments d
LEFT JOIN hr.employees e ON d.department_id = e.department_id
WHERE e.employee_id IS NULL;

-- 1. Select all columns from employees table
SELECT * FROM hr.employees;

-- 2. Select employee's first and last names
SELECT first_name, last_name FROM hr.employees;

-- 3. Select distinct job titles from employees
SELECT DISTINCT job_title FROM hr.employees;

-- 4. Select employees with salary greater than 50000
SELECT * FROM hr.employees WHERE salary > 50000;

-- 5. Select employees hired after January 1, 2020
SELECT * FROM hr.employees WHERE hire_date > '2020-01-01';

-- 6. Select employees in department ID 10
SELECT * FROM hr.employees WHERE department_id = 10;

-- 7. Select employees with the first name starting with 'A'
SELECT * FROM hr.employees WHERE first_name LIKE 'A%';

-- 8. Select employee details ordered by hire date
SELECT * FROM hr.employees ORDER BY hire_date;

-- 9. Select the top 5 highest paid employees
SELECT * FROM hr.employees ORDER BY salary DESC LIMIT 5;

-- 10. Select employees with salary between 40000 and 60000
SELECT * FROM hr.employees WHERE salary BETWEEN 40000 AND 60000;

-- 11. Count the number of employees
SELECT COUNT(*) FROM hr.employees;

-- 12. Count the number of employees in department 20
SELECT COUNT(*) FROM hr.employees WHERE department_id = 20;

-- 13. Find the minimum salary in the employees table
SELECT MIN(salary) FROM hr.employees;

-- 14. Find the maximum salary in the employees table
SELECT MAX(salary) FROM hr.employees;

-- 15. Find the average salary of employees
SELECT AVG(salary) FROM hr.employees;

-- 16. Sum the total salaries of all employees
SELECT SUM(salary) FROM hr.employees;

-- 17. Count employees grouped by department_id
SELECT department_id, COUNT(*) FROM hr.employees GROUP BY department_id;

-- 18. Find the average salary per department
SELECT department_id, AVG(salary) FROM hr.employees GROUP BY department_id;

-- 19. Count employees with salary greater than 60000
SELECT COUNT(*) FROM hr.employees WHERE salary > 60000;

-- 20. Find the total salary by department
SELECT department_id, SUM(salary) FROM hr.employees GROUP BY department_id;

-- String Functions

-- 21. Convert the first name to uppercase
SELECT UPPER(first_name) FROM hr.employees;

-- 22. Convert the last name to lowercase
SELECT LOWER(last_name) FROM hr.employees;

-- 23. Concatenate first and last names
SELECT CONCAT(first_name, ' ', last_name) AS full_name FROM hr.employees;

-- 24. Find the length of first name
SELECT LENGTH(first_name) FROM hr.employees;

-- 25. Trim spaces from the first name
SELECT TRIM(first_name) FROM hr.employees;

-- 26. Find the first three characters of the last name
SELECT SUBSTRING(last_name, 1, 3) FROM hr.employees;

-- 27. Replace all instances of 'a' with 'A' in first names
SELECT REPLACE(first_name, 'a', 'A') FROM hr.employees;

-- 28. Locate the position of 'a' in the first name
SELECT POSITION('a' IN first_name) FROM hr.employees;

-- 29. Repeat the first name three times
SELECT REPEAT(first_name, 3) FROM hr.employees;

-- 30. Reverse the last name
SELECT REVERSE(last_name) FROM hr.employees;

-- Date Functions

-- 31. Get the current date
SELECT CURRENT_DATE;

-- 32. Get the current timestamp
SELECT CURRENT_TIMESTAMP;

-- 33. Extract the year from hire_date
SELECT EXTRACT(YEAR FROM hire_date) FROM hr.employees;

-- 34. Extract the month from hire_date
SELECT EXTRACT(MONTH FROM hire_date) FROM hr.employees;

-- 35. Extract the day from hire_date
SELECT EXTRACT(DAY FROM hire_date) FROM hr.employees;

-- 36. Add 1 year to hire_date
SELECT hire_date, hire_date + INTERVAL '1 year' FROM hr.employees;

-- 37. Subtract 6 months from hire_date
SELECT hire_date, hire_date - INTERVAL '6 months' FROM hr.employees;

-- 38. Find the difference in days between hire_date and current date
SELECT hire_date, CURRENT_DATE - hire_date AS days_in_company FROM hr.employees;

-- 39. Format the hire_date as 'YYYY-MM-DD'
SELECT TO_CHAR(hire_date, 'YYYY-MM-DD') FROM hr.employees;

-- 40. Find employees hired in the last 30 days
SELECT * FROM hr.employees WHERE hire_date >= (CURRENT_DATE - INTERVAL '30 days');

-- Conditional Functions

-- 41. Select employees with 'Manager' in the job title and mark them as 'Senior' or 'Junior'
SELECT first_name, last_name, 
    CASE 
        WHEN job_title LIKE '%Manager%' THEN 'Senior'
        ELSE 'Junior'
    END AS employee_level
FROM hr.employees;

-- 42. Use COALESCE to display 'No Commission' if commission_pct is NULL
SELECT first_name, last_name, COALESCE(commission_pct, 'No Commission') FROM hr.employees;

-- 43. Use NULLIF to return NULL when salary equals 50000
SELECT first_name, last_name, NULLIF(salary, 50000) FROM hr.employees;

-- 44. Use GREATEST to find the highest value among salary and commission
SELECT first_name, last_name, GREATEST(salary, commission_pct) FROM hr.employees;

-- 45. Use LEAST to find the lowest salary in a list
SELECT LEAST(50000, 60000, salary) FROM hr.employees;

-- Window Functions

-- 46. Rank employees by salary
SELECT first_name, last_name, salary, RANK() OVER (ORDER BY salary DESC) AS salary_rank FROM hr.employees;

-- 47. Find the cumulative salary sum
SELECT first_name, last_name, salary, SUM(salary) OVER (ORDER BY hire_date) AS cumulative_salary FROM hr.employees;

-- 48. Find the average salary partitioned by department
SELECT first_name, last_name, salary, AVG(salary) OVER (PARTITION BY department_id) AS avg_salary_per_dept FROM hr.employees;

-- 49. Use LAG to get the previous employee's salary
SELECT first_name, last_name, salary, LAG(salary) OVER (ORDER BY hire_date) AS previous_salary FROM hr.employees;

-- 50. Use LEAD to get the next employee's salary
SELECT first_name, last_name, salary, LEAD(salary) OVER (ORDER BY hire_date) AS next_salary FROM hr.employees;

-- Joins





