/*==============================================================================
 ORACLE SQL + PL/SQL JOINS COMPLETE HANDS-ON
 Tables:
   1. EMPLOYEE
   2. EMPLOYEE_PROJECT

 Relationship:
   One Employee -> Many Project Assignments

 Topics:
   - INNER JOIN
   - LEFT JOIN
   - RIGHT JOIN
   - FULL OUTER JOIN
   - CROSS JOIN
   - SELF JOIN
   - NULL handling
   - One-to-many relationships
   - Multiple conditions
   - Aggregate functions
   - GROUP BY
   - HAVING
   - CASE
   - NVL
   - Subqueries
   - Analytic functions
   - PL/SQL SELECT INTO
   - Cursor
   - FOR LOOP
   - Procedure
   - Exception handling
==============================================================================*/


/*==============================================================================
 STEP 1: DROP TABLES IF THEY ALREADY EXIST
==============================================================================*/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE employee_project';
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE employee';
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;
/


/*==============================================================================
 STEP 2: CREATE EMPLOYEE TABLE
==============================================================================*/

CREATE TABLE employee
(
    emp_id       NUMBER PRIMARY KEY,
    emp_name     VARCHAR2(50),
    department   VARCHAR2(30),
    manager_id   NUMBER,
    salary       NUMBER(10,2),
    city         VARCHAR2(30)
);


/*==============================================================================
 STEP 3: CREATE EMPLOYEE_PROJECT TABLE
==============================================================================*/

CREATE TABLE employee_project
(
    assignment_id NUMBER PRIMARY KEY,
    emp_id        NUMBER,
    project_name  VARCHAR2(50),
    project_role  VARCHAR2(30),
    hours_worked  NUMBER,
    status        VARCHAR2(20)
);


/*==============================================================================
 STEP 4: INSERT EMPLOYEE DATA

 Important:
 - Some manager_id values are NULL
 - Kiran's salary is NULL
 - Ravi's department is NULL
 - Sneha and Deepa have NULL city
 - Some employees will intentionally have no project
==============================================================================*/

INSERT INTO employee
VALUES (101, 'Arun', 'IT', NULL, 90000, 'Bangalore');

INSERT INTO employee
VALUES (102, 'Priya', 'IT', 101, 65000, 'Hyderabad');

INSERT INTO employee
VALUES (103, 'Rahul', 'HR', NULL, 55000, 'Chennai');

INSERT INTO employee
VALUES (104, 'Sneha', 'Finance', 106, 70000, NULL);

INSERT INTO employee
VALUES (105, 'Kiran', 'IT', 101, NULL, 'Bangalore');

INSERT INTO employee
VALUES (106, 'Meena', 'Finance', NULL, 95000, 'Mumbai');

INSERT INTO employee
VALUES (107, 'Ravi', NULL, 101, 60000, 'Pune');

INSERT INTO employee
VALUES (108, 'Anjali', 'HR', 103, 50000, 'Bangalore');

INSERT INTO employee
VALUES (109, 'Vijay', 'Sales', NULL, 75000, 'Delhi');

INSERT INTO employee
VALUES (110, 'Deepa', 'Sales', 109, 58000, NULL);

COMMIT;


/*==============================================================================
 STEP 5: INSERT PROJECT DATA

 One-to-many examples:
 101 -> 2 projects
 102 -> 2 projects
 104 -> 2 projects

 NULL examples:
 assignment 7  -> NULL project_role
 assignment 9  -> NULL hours_worked
 assignment 11 -> NULL emp_id

 Unmatched example:
 emp_id 999 does not exist in EMPLOYEE
==============================================================================*/

INSERT INTO employee_project
VALUES (1, 101, 'ERP Migration', 'Manager', 120, 'Active');

INSERT INTO employee_project
VALUES (2, 101, 'Cloud Migration', 'Architect', 80, 'Active');

INSERT INTO employee_project
VALUES (3, 102, 'ERP Migration', 'Developer', 150, 'Active');

INSERT INTO employee_project
VALUES (4, 102, 'AI Platform', 'Developer', 100, 'Completed');

INSERT INTO employee_project
VALUES (5, 103, 'HR Automation', 'Lead', 90, 'Active');

INSERT INTO employee_project
VALUES (6, 104, 'Finance Portal', 'Analyst', 110, 'Active');

INSERT INTO employee_project
VALUES (7, 104, 'Audit System', NULL, 60, 'Completed');

INSERT INTO employee_project
VALUES (8, 106, 'Finance Portal', 'Manager', 130, 'Active');

INSERT INTO employee_project
VALUES (9, 108, 'HR Automation', 'Analyst', NULL, 'Active');

INSERT INTO employee_project
VALUES (10, 999, 'External Project', 'Consultant', 50, 'Active');

INSERT INTO employee_project
VALUES (11, NULL, 'Unassigned Project', 'Developer', 40, 'Pending');

COMMIT;


/*==============================================================================
 DISPLAY ORIGINAL TABLES
==============================================================================*/

SELECT *
FROM employee
ORDER BY emp_id;


SELECT *
FROM employee_project
ORDER BY assignment_id;


/*==============================================================================
 JOIN 1: BASIC INNER JOIN

 INNER JOIN returns only matching records from both tables.
==============================================================================*/

SELECT
    e.emp_id,
    e.emp_name,
    e.department,
    p.project_name
FROM employee e
INNER JOIN employee_project p
    ON e.emp_id = p.emp_id
ORDER BY e.emp_id;


/*==============================================================================
 JOIN 2: INNER JOIN WITH MORE COLUMNS
==============================================================================*/

SELECT
    e.emp_id,
    e.emp_name,
    e.department,
    e.salary,
    p.project_name,
    p.project_role,
    p.hours_worked,
    p.status
FROM employee e
JOIN employee_project p
    ON e.emp_id = p.emp_id
ORDER BY e.emp_id;


/*==============================================================================
 JOIN 3: ONE-TO-MANY JOIN

 Arun has two projects.
 Therefore Arun appears twice.
==============================================================================*/

SELECT
    e.emp_id,
    e.emp_name,
    p.project_name,
    p.project_role
FROM employee e
JOIN employee_project p
    ON e.emp_id = p.emp_id
WHERE e.emp_id = 101;


/*==============================================================================
 JOIN 4: INNER JOIN WITH WHERE CONDITION

 Find only IT employees and their projects.
==============================================================================*/

SELECT
    e.emp_name,
    e.department,
    p.project_name
FROM employee e
JOIN employee_project p
    ON e.emp_id = p.emp_id
WHERE e.department = 'IT';


/*==============================================================================
 JOIN 5: INNER JOIN FOR ACTIVE PROJECTS
==============================================================================*/

SELECT
    e.emp_name,
    p.project_name,
    p.status
FROM employee e
JOIN employee_project p
    ON e.emp_id = p.emp_id
WHERE p.status = 'Active';


/*==============================================================================
 JOIN 6: LEFT OUTER JOIN

 Returns ALL employees.
 If employee has no project, project columns become NULL.
==============================================================================*/

SELECT
    e.emp_id,
    e.emp_name,
    p.project_name,
    p.status
FROM employee e
LEFT OUTER JOIN employee_project p
    ON e.emp_id = p.emp_id
ORDER BY e.emp_id;


/*==============================================================================
 JOIN 7: FIND EMPLOYEES WITHOUT PROJECTS

 Very important interview query.
==============================================================================*/

SELECT
    e.emp_id,
    e.emp_name,
    e.department
FROM employee e
LEFT JOIN employee_project p
    ON e.emp_id = p.emp_id
WHERE p.emp_id IS NULL;


/*==============================================================================
 JOIN 8: LEFT JOIN + NVL

 Replace NULL project names with "No Project".
==============================================================================*/

SELECT
    e.emp_id,
    e.emp_name,
    NVL(p.project_name, 'No Project') AS project_name
FROM employee e
LEFT JOIN employee_project p
    ON e.emp_id = p.emp_id
ORDER BY e.emp_id;


/*==============================================================================
 JOIN 9: RIGHT OUTER JOIN

 Returns every project assignment.
==============================================================================*/

SELECT
    e.emp_id,
    e.emp_name,
    p.assignment_id,
    p.emp_id AS project_emp_id,
    p.project_name
FROM employee e
RIGHT OUTER JOIN employee_project p
    ON e.emp_id = p.emp_id
ORDER BY p.assignment_id;


/*==============================================================================
 JOIN 10: FIND PROJECTS WITHOUT VALID EMPLOYEE

 This identifies:
 - emp_id = 999
 - emp_id = NULL
==============================================================================*/

SELECT
    p.assignment_id,
    p.emp_id,
    p.project_name
FROM employee e
RIGHT JOIN employee_project p
    ON e.emp_id = p.emp_id
WHERE e.emp_id IS NULL;


/*==============================================================================
 JOIN 11: FULL OUTER JOIN

 Returns:
 - matching employees/projects
 - employees without projects
 - projects without employees
==============================================================================*/

SELECT
    e.emp_id AS employee_id,
    e.emp_name,
    p.emp_id AS project_employee_id,
    p.project_name
FROM employee e
FULL OUTER JOIN employee_project p
    ON e.emp_id = p.emp_id
ORDER BY e.emp_id;


/*==============================================================================
 JOIN 12: FULL JOIN WITH NVL
==============================================================================*/

SELECT
    NVL(TO_CHAR(e.emp_id), 'NO EMPLOYEE') AS employee_id,
    NVL(e.emp_name, 'UNKNOWN EMPLOYEE') AS employee_name,
    NVL(p.project_name, 'NO PROJECT') AS project_name
FROM employee e
FULL OUTER JOIN employee_project p
    ON e.emp_id = p.emp_id;


/*==============================================================================
 JOIN 13: CROSS JOIN

 Every employee is combined with every project assignment.

 10 employees x 11 assignments = 110 rows
==============================================================================*/

SELECT
    e.emp_name,
    p.project_name
FROM employee e
CROSS JOIN employee_project p;


/*==============================================================================
 JOIN 14: COUNT CROSS JOIN RECORDS
==============================================================================*/

SELECT COUNT(*) AS total_combinations
FROM employee e
CROSS JOIN employee_project p;


/*==============================================================================
 JOIN 15: SELF JOIN - EMPLOYEE AND MANAGER

 EMPLOYEE table joins to itself.
==============================================================================*/

SELECT
    e.emp_id,
    e.emp_name AS employee_name,
    m.emp_name AS manager_name
FROM employee e
LEFT JOIN employee m
    ON e.manager_id = m.emp_id
ORDER BY e.emp_id;


/*==============================================================================
 JOIN 16: FIND EMPLOYEES HAVING MANAGERS
==============================================================================*/

SELECT
    e.emp_name AS employee_name,
    m.emp_name AS manager_name
FROM employee e
INNER JOIN employee m
    ON e.manager_id = m.emp_id;


/*==============================================================================
 JOIN 17: FIND EMPLOYEES WITHOUT MANAGERS
==============================================================================*/

SELECT
    e.emp_id,
    e.emp_name
FROM employee e
LEFT JOIN employee m
    ON e.manager_id = m.emp_id
WHERE m.emp_id IS NULL;


/*==============================================================================
 JOIN 18: JOIN WITH MULTIPLE CONDITIONS

 Match employee/project AND return only active projects.
==============================================================================*/

SELECT
    e.emp_name,
    p.project_name,
    p.status
FROM employee e
JOIN employee_project p
    ON e.emp_id = p.emp_id
   AND p.status = 'Active';


/*==============================================================================
 JOIN 19: IMPORTANT LEFT JOIN CONDITION EXAMPLE

 Putting condition inside ON preserves employees without active projects.
==============================================================================*/

SELECT
    e.emp_name,
    p.project_name,
    p.status
FROM employee e
LEFT JOIN employee_project p
    ON e.emp_id = p.emp_id
   AND p.status = 'Active'
ORDER BY e.emp_id;


/*==============================================================================
 JOIN 20: LEFT JOIN CONDITION IN WHERE

 Notice the difference from JOIN 19.

 The WHERE condition removes NULL rows, so this behaves similarly
 to an INNER JOIN for this condition.
==============================================================================*/

SELECT
    e.emp_name,
    p.project_name,
    p.status
FROM employee e
LEFT JOIN employee_project p
    ON e.emp_id = p.emp_id
WHERE p.status = 'Active';


/*==============================================================================
 JOIN 21: COUNT PROJECTS PER EMPLOYEE

 COUNT(p.assignment_id) is important.
 Do NOT use COUNT(*) if you want employees without projects to show 0.
==============================================================================*/

SELECT
    e.emp_id,
    e.emp_name,
    COUNT(p.assignment_id) AS total_projects
FROM employee e
LEFT JOIN employee_project p
    ON e.emp_id = p.emp_id
GROUP BY
    e.emp_id,
    e.emp_name
ORDER BY e.emp_id;


/*==============================================================================
 JOIN 22: TOTAL HOURS WORKED BY EACH EMPLOYEE
==============================================================================*/

SELECT
    e.emp_id,
    e.emp_name,
    SUM(p.hours_worked) AS total_hours
FROM employee e
LEFT JOIN employee_project p
    ON e.emp_id = p.emp_id
GROUP BY
    e.emp_id,
    e.emp_name
ORDER BY e.emp_id;


/*==============================================================================
 JOIN 23: HANDLE NULL HOURS USING NVL
==============================================================================*/

SELECT
    e.emp_id,
    e.emp_name,
    NVL(SUM(p.hours_worked), 0) AS total_hours
FROM employee e
LEFT JOIN employee_project p
    ON e.emp_id = p.emp_id
GROUP BY
    e.emp_id,
    e.emp_name
ORDER BY e.emp_id;


/*==============================================================================
 JOIN 24: EMPLOYEES WORKING ON MORE THAN ONE PROJECT

 GROUP BY + HAVING
==============================================================================*/

SELECT
    e.emp_id,
    e.emp_name,
    COUNT(p.assignment_id) AS total_projects
FROM employee e
JOIN employee_project p
    ON e.emp_id = p.emp_id
GROUP BY
    e.emp_id,
    e.emp_name
HAVING COUNT(p.assignment_id) > 1;


/*==============================================================================
 JOIN 25: PROJECT-WISE EMPLOYEE COUNT
==============================================================================*/

SELECT
    p.project_name,
    COUNT(DISTINCT e.emp_id) AS employee_count
FROM employee_project p
LEFT JOIN employee e
    ON p.emp_id = e.emp_id
GROUP BY p.project_name
ORDER BY employee_count DESC;


/*==============================================================================
 JOIN 26: JOIN + CASE

 Categorize workload based on project hours.
==============================================================================*/

SELECT
    e.emp_name,
    p.project_name,
    p.hours_worked,
    CASE
        WHEN p.hours_worked >= 120 THEN 'High Workload'
        WHEN p.hours_worked >= 80 THEN 'Medium Workload'
        WHEN p.hours_worked IS NULL THEN 'Hours Not Available'
        ELSE 'Low Workload'
    END AS workload
FROM employee e
JOIN employee_project p
    ON e.emp_id = p.emp_id;


/*==============================================================================
 JOIN 27: JOIN + SALARY CONDITION
==============================================================================*/

SELECT
    e.emp_name,
    e.salary,
    p.project_name
FROM employee e
JOIN employee_project p
    ON e.emp_id = p.emp_id
WHERE e.salary > 60000;


/*==============================================================================
 JOIN 28: JOIN + SUBQUERY

 Find employees working on projects whose hours are above the
 average project-assignment hours.
==============================================================================*/

SELECT
    e.emp_name,
    p.project_name,
    p.hours_worked
FROM employee e
JOIN employee_project p
    ON e.emp_id = p.emp_id
WHERE p.hours_worked >
(
    SELECT AVG(hours_worked)
    FROM employee_project
);


/*==============================================================================
 JOIN 29: JOIN + ANALYTIC FUNCTION

 Rank employees based on project hours.
==============================================================================*/

SELECT
    e.emp_name,
    p.project_name,
    p.hours_worked,
    RANK() OVER
    (
        ORDER BY p.hours_worked DESC NULLS LAST
    ) AS hours_rank
FROM employee e
JOIN employee_project p
    ON e.emp_id = p.emp_id;


/*==============================================================================
 JOIN 30: RANK PROJECTS WITHIN EACH EMPLOYEE

 ROW_NUMBER() gives numbering for each employee's projects.
==============================================================================*/

SELECT
    e.emp_id,
    e.emp_name,
    p.project_name,
    p.hours_worked,

    ROW_NUMBER() OVER
    (
        PARTITION BY e.emp_id
        ORDER BY p.hours_worked DESC NULLS LAST
    ) AS project_rank

FROM employee e
JOIN employee_project p
    ON e.emp_id = p.emp_id
ORDER BY e.emp_id, project_rank;


/*==============================================================================
 EXTRA JOIN 31: HIGHEST-HOURS PROJECT FOR EACH EMPLOYEE
==============================================================================*/

SELECT
    emp_id,
    emp_name,
    project_name,
    hours_worked
FROM
(
    SELECT
        e.emp_id,
        e.emp_name,
        p.project_name,
        p.hours_worked,

        ROW_NUMBER() OVER
        (
            PARTITION BY e.emp_id
            ORDER BY p.hours_worked DESC NULLS LAST
        ) AS rn

    FROM employee e
    JOIN employee_project p
        ON e.emp_id = p.emp_id
)
WHERE rn = 1;


/*==============================================================================
 EXTRA JOIN 32: EMPLOYEE + MANAGER + PROJECT

 Three logical entities using employee table twice.
==============================================================================*/

SELECT
    e.emp_name AS employee_name,
    m.emp_name AS manager_name,
    p.project_name
FROM employee e

LEFT JOIN employee m
    ON e.manager_id = m.emp_id

LEFT JOIN employee_project p
    ON e.emp_id = p.emp_id

ORDER BY e.emp_id;


/*==============================================================================
 EXTRA JOIN 33: FIND NULL VALUES AFTER JOIN
==============================================================================*/

SELECT
    e.emp_name,
    e.salary,
    e.city,
    p.project_name,
    p.project_role,
    p.hours_worked
FROM employee e
LEFT JOIN employee_project p
    ON e.emp_id = p.emp_id
WHERE e.salary IS NULL
   OR e.city IS NULL
   OR p.project_role IS NULL
   OR p.hours_worked IS NULL;


/*==============================================================================
 EXTRA JOIN 34: NVL FOR MULTIPLE NULL COLUMNS
==============================================================================*/

SELECT
    e.emp_name,

    NVL(e.department, 'Department Not Assigned')
        AS department,

    NVL(e.city, 'City Not Available')
        AS city,

    NVL(p.project_name, 'No Project')
        AS project_name,

    NVL(p.project_role, 'Role Not Assigned')
        AS project_role,

    NVL(p.hours_worked, 0)
        AS hours_worked

FROM employee e
LEFT JOIN employee_project p
    ON e.emp_id = p.emp_id;


/*==============================================================================
 EXTRA JOIN 35: DEPARTMENT-WISE PROJECT ASSIGNMENTS
==============================================================================*/

SELECT
    e.department,
    COUNT(p.assignment_id) AS project_assignments,
    SUM(NVL(p.hours_worked,0)) AS total_hours
FROM employee e
LEFT JOIN employee_project p
    ON e.emp_id = p.emp_id
GROUP BY e.department
ORDER BY project_assignments DESC;


/*==============================================================================
 EXTRA JOIN 36: PROJECTS HAVING MORE THAN ONE EMPLOYEE
==============================================================================*/

SELECT
    p.project_name,
    COUNT(DISTINCT p.emp_id) AS employee_count
FROM employee_project p
JOIN employee e
