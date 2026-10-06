/*==============================================================================
                ORACLE SQL - CTE COMPLETE PRACTICE FILE

 Tables Used:
   EMPLOYEE
   EMPLOYEE_PROJECT

 Topics:
   1. Basic CTE
   2. CTE with WHERE
   3. CTE with NULL
   4. CTE with NVL
   5. CTE with JOIN
   6. CTE with GROUP BY
   7. CTE with HAVING
   8. CTE with CASE
   9. Two-Level CTE
  10. Three-Level CTE
  11. Four-Level CTE
  12. Five-Level CTE
  13. Multiple Independent CTEs
  14. CTE + ROW_NUMBER
  15. CTE + RANK
  16. CTE + DENSE_RANK
  17. CTE + LAG
  18. CTE + LEAD
  19. CTE + FIRST_VALUE
  20. CTE + LAST_VALUE
==============================================================================*/


/*==============================================================================
1. BASIC CTE
==============================================================================*/

WITH employee_data AS
(
    SELECT
        emp_id,
        emp_name,
        department,
        salary
    FROM employee
)
SELECT *
FROM employee_data;


/*==============================================================================
2. CTE WITH WHERE CONDITION
Find employees earning more than 60,000.
==============================================================================*/

WITH high_salary_employees AS
(
    SELECT
        emp_id,
        emp_name,
        department,
        salary
    FROM employee
    WHERE salary > 60000
)
SELECT *
FROM high_salary_employees;


/*==============================================================================
3. CTE WITH NULL CONDITION
Find employees whose salary is NULL.
==============================================================================*/

WITH missing_salary AS
(
    SELECT
        emp_id,
        emp_name,
        department,
        salary
    FROM employee
    WHERE salary IS NULL
)
SELECT *
FROM missing_salary;


/*==============================================================================
4. CTE WITH NVL
Replace NULL salary with zero.
==============================================================================*/

WITH clean_salary AS
(
    SELECT
        emp_id,
        emp_name,
        department,
        NVL(salary, 0) AS salary
    FROM employee
)
SELECT *
FROM clean_salary;


/*==============================================================================
5. CTE WITH INNER JOIN
Get employees and their projects.
==============================================================================*/

WITH employee_projects AS
(
    SELECT
        e.emp_id,
        e.emp_name,
        e.department,
        p.project_name,
        p.project_role,
        p.hours_worked
    FROM employee e
    INNER JOIN employee_project p
        ON e.emp_id = p.emp_id
)
SELECT *
FROM employee_projects;


/*==============================================================================
6. CTE WITH LEFT JOIN
Return all employees including employees without projects.
==============================================================================*/

WITH employee_projects AS
(
    SELECT
        e.emp_id,
        e.emp_name,
        e.department,
        p.project_name,
        p.project_role
    FROM employee e
    LEFT JOIN employee_project p
        ON e.emp_id = p.emp_id
)
SELECT *
FROM employee_projects;


/*==============================================================================
7. CTE WITH GROUP BY
Count number of projects assigned to every employee.
==============================================================================*/

WITH project_count AS
(
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
)
SELECT *
FROM project_count
ORDER BY total_projects DESC;


/*==============================================================================
8. CTE WITH SUM
Calculate total project hours.
==============================================================================*/

WITH employee_hours AS
(
    SELECT
        e.emp_id,
        e.emp_name,
        SUM(NVL(p.hours_worked, 0)) AS total_hours
    FROM employee e
    LEFT JOIN employee_project p
        ON e.emp_id = p.emp_id
    GROUP BY
        e.emp_id,
        e.emp_name
)
SELECT *
FROM employee_hours
ORDER BY total_hours DESC;


/*==============================================================================
9. CTE WITH HAVING
Find employees working on more than one project.
==============================================================================*/

WITH multiple_projects AS
(
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
    HAVING COUNT(p.assignment_id) > 1
)
SELECT *
FROM multiple_projects;


/*==============================================================================
10. CTE WITH CASE
Categorize employees based on salary.
==============================================================================*/

WITH salary_category AS
(
    SELECT
        emp_id,
        emp_name,
        salary,

        CASE
            WHEN salary >= 80000 THEN 'High Salary'
            WHEN salary >= 60000 THEN 'Medium Salary'
            WHEN salary IS NULL THEN 'Salary Missing'
            ELSE 'Low Salary'
        END AS salary_category

    FROM employee
)
SELECT *
FROM salary_category;


/*==============================================================================
11. TWO-LEVEL CTE

Level 1 -> Calculate total hours
Level 2 -> Categorize workload
==============================================================================*/

WITH employee_hours AS
(
    SELECT
        e.emp_id,
        e.emp_name,
        SUM(NVL(p.hours_worked, 0)) AS total_hours
    FROM employee e
    LEFT JOIN employee_project p
        ON e.emp_id = p.emp_id
    GROUP BY
        e.emp_id,
        e.emp_name
),

workload AS
(
    SELECT
        emp_id,
        emp_name,
        total_hours,

        CASE
            WHEN total_hours >= 200 THEN 'High Workload'
            WHEN total_hours >= 100 THEN 'Medium Workload'
            ELSE 'Low Workload'
        END AS workload_category

    FROM employee_hours
)

SELECT *
FROM workload
ORDER BY total_hours DESC;


/*==============================================================================
12. TWO-LEVEL CTE

Level 1 -> Clean salary
Level 2 -> Filter high salary employees
==============================================================================*/

WITH clean_salary AS
(
    SELECT
        emp_id,
        emp_name,
        department,
        NVL(salary, 0) AS salary
    FROM employee
),

high_salary AS
(
    SELECT *
    FROM clean_salary
    WHERE salary >= 70000
)

SELECT *
FROM high_salary
ORDER BY salary DESC;


/*==============================================================================
13. TWO-LEVEL CTE

Level 1 -> Count projects
Level 2 -> Join project count with employee
==============================================================================*/

WITH project_count AS
(
    SELECT
        emp_id,
        COUNT(*) AS total_projects
    FROM employee_project
    WHERE emp_id IS NOT NULL
    GROUP BY emp_id
),

employee_summary AS
(
    SELECT
        e.emp_id,
        e.emp_name,
        e.department,
        NVL(p.total_projects, 0) AS total_projects
    FROM employee e
    LEFT JOIN project_count p
        ON e.emp_id = p.emp_id
)

SELECT *
FROM employee_summary
ORDER BY total_projects DESC;


/*==============================================================================
14. TWO-LEVEL CTE - ACTIVE PROJECTS

Level 1 -> Filter active projects
Level 2 -> Join with employees
==============================================================================*/

WITH active_projects AS
(
    SELECT
        emp_id,
        project_name,
        project_role,
        hours_worked
    FROM employee_project
    WHERE status = 'Active'
),

active_employee_projects AS
(
    SELECT
        e.emp_id,
        e.emp_name,
        e.department,
        p.project_name,
        p.project_role,
        p.hours_worked
    FROM employee e
    JOIN active_projects p
        ON e.emp_id = p.emp_id
)

SELECT *
FROM active_employee_projects;


/*==============================================================================
15. TWO-LEVEL CTE WITH RANKING

Level 1 -> Calculate hours
Level 2 -> Rank employees
==============================================================================*/

WITH employee_hours AS
(
    SELECT
        e.emp_id,
        e.emp_name,
        SUM(NVL(p.hours_worked, 0)) AS total_hours
    FROM employee e
    LEFT JOIN employee_project p
        ON e.emp_id = p.emp_id
    GROUP BY
        e.emp_id,
        e.emp_name
),

employee_ranking AS
(
    SELECT
        emp_id,
        emp_name,
        total_hours,

        DENSE_RANK() OVER
        (
            ORDER BY total_hours DESC
        ) AS employee_rank

    FROM employee_hours
)

SELECT *
FROM employee_ranking
ORDER BY employee_rank;


/*==============================================================================
16. THREE-LEVEL CTE

Level 1 -> Join employee/project
Level 2 -> Aggregate data
Level 3 -> Classify workload
==============================================================================*/

WITH employee_project_data AS
(
    SELECT
        e.emp_id,
        e.emp_name,
        e.department,
        p.project_name,
        NVL(p.hours_worked, 0) AS hours_worked
    FROM employee e
    LEFT JOIN employee_project p
        ON e.emp_id = p.emp_id
),

employee_summary AS
(
    SELECT
        emp_id,
        emp_name,
        department,
        COUNT(project_name) AS total_projects,
        SUM(hours_worked) AS total_hours
    FROM employee_project_data
    GROUP BY
        emp_id,
        emp_name,
        department
),

employee_classification AS
(
    SELECT
        emp_id,
        emp_name,
        department,
        total_projects,
        total_hours,

        CASE
            WHEN total_hours >= 200 THEN 'High'
            WHEN total_hours >= 100 THEN 'Medium'
            ELSE 'Low'
        END AS workload

    FROM employee_summary
)

SELECT *
FROM employee_classification
ORDER BY total_hours DESC;


/*==============================================================================
17. THREE-LEVEL CTE - SALARY ANALYSIS

Level 1 -> Clean employee data
Level 2 -> Calculate department average
Level 3 -> Compare employee with department average
==============================================================================*/

WITH clean_employee AS
(
    SELECT
        emp_id,
        emp_name,
        department,
        NVL(salary, 0) AS salary
    FROM employee
    WHERE department IS NOT NULL
),

department_average AS
(
    SELECT
        department,
        AVG(salary) AS avg_salary
    FROM clean_employee
    GROUP BY department
),

salary_comparison AS
(
    SELECT
        e.emp_id,
        e.emp_name,
        e.department,
        e.salary,
        d.avg_salary,

        CASE
            WHEN e.salary > d.avg_salary THEN 'Above Average'
            WHEN e.salary < d.avg_salary THEN 'Below Average'
            ELSE 'Equal to Average'
        END AS salary_status

    FROM clean_employee e
    JOIN department_average d
        ON e.department = d.department
)

SELECT *
FROM salary_comparison
ORDER BY department, salary DESC;


/*==============================================================================
18. THREE-LEVEL CTE - TOP 3 EMPLOYEES

Level 1 -> Calculate hours
Level 2 -> Rank employees
Level 3 -> Select top 3
==============================================================================*/

WITH employee_hours AS
(
    SELECT
        e.emp_id,
        e.emp_name,
        SUM(NVL(p.hours_worked, 0)) AS total_hours
    FROM employee e
    LEFT JOIN employee_project p
        ON e.emp_id = p.emp_id
    GROUP BY
        e.emp_id,
        e.emp_name
),

employee_ranking AS
(
    SELECT
        emp_id,
        emp_name,
        total_hours,

        DENSE_RANK() OVER
        (
            ORDER BY total_hours DESC
        ) AS employee_rank

    FROM employee_hours
),

top_three AS
(
    SELECT *
    FROM employee_ranking
    WHERE employee_rank <= 3
)

SELECT *
FROM top_three
ORDER BY employee_rank;


/*==============================================================================
19. THREE-LEVEL CTE - HIGHEST SALARY PER DEPARTMENT
==============================================================================*/

WITH employee_salary AS
(
    SELECT
        emp_id,
        emp_name,
        department,
        salary
    FROM employee
    WHERE department IS NOT NULL
      AND salary IS NOT NULL
),

salary_ranking AS
(
    SELECT
        emp_id,
        emp_name,
        department,
        salary,

        DENSE_RANK() OVER
        (
            PARTITION BY department
            ORDER BY salary DESC
        ) AS salary_rank

    FROM employee_salary
),

highest_salary AS
(
    SELECT *
    FROM salary_ranking
    WHERE salary_rank = 1
)

SELECT *
FROM highest_salary
ORDER BY department;


/*==============================================================================
20. THREE-LEVEL CTE - PROJECT ANALYSIS
==============================================================================*/

WITH valid_projects AS
(
    SELECT
        emp_id,
        project_name,
        NVL(hours_worked, 0) AS hours_worked
    FROM employee_project
    WHERE emp_id IS NOT NULL
),

project_summary AS
(
    SELECT
        project_name,
        COUNT(DISTINCT emp_id) AS employee_count,
        SUM(hours_worked) AS total_hours,
        AVG(hours_worked) AS avg_hours
    FROM valid_projects
    GROUP BY project_name
),

project_category AS
(
    SELECT
        project_name,
        employee_count,
        total_hours,
        avg_hours,

        CASE
            WHEN total_hours >= 200 THEN 'Large Project'
            WHEN total_hours >= 100 THEN 'Medium Project'
            ELSE 'Small Project'
        END AS project_size

    FROM project_summary
)

SELECT *
FROM project_category
ORDER BY total_hours DESC;


/*==============================================================================
21. FOUR-LEVEL CTE - EMPLOYEE PERFORMANCE

Level 1 -> Employee/project data
Level 2 -> Employee summary
Level 3 -> Performance classification
Level 4 -> Ranking
==============================================================================*/

WITH employee_project_data AS
(
    SELECT
        e.emp_id,
        e.emp_name,
        e.department,
        p.project_name,
        NVL(p.hours_worked, 0) AS hours_worked
    FROM employee e
    LEFT JOIN employee_project p
        ON e.emp_id = p.emp_id
),

employee_summary AS
(
    SELECT
        emp_id,
        emp_name,
        department,
        COUNT(project_name) AS total_projects,
        SUM(hours_worked) AS total_hours
    FROM employee_project_data
    GROUP BY
        emp_id,
        emp_name,
        department
),

performance_data AS
(
    SELECT
        emp_id,
        emp_name,
        department,
        total_projects,
        total_hours,

        CASE
            WHEN total_projects >= 2
             AND total_hours >= 150 THEN 'Excellent'

            WHEN total_hours >= 80 THEN 'Good'

            WHEN total_projects = 0 THEN 'No Project'

            ELSE 'Average'
        END AS performance

    FROM employee_summary
),

performance_ranking AS
(
    SELECT
        emp_id,
        emp_name,
        department,
        total_projects,
        total_hours,
        performance,

        DENSE_RANK() OVER
        (
            ORDER BY total_hours DESC
        ) AS performance_rank

    FROM performance_data
)

SELECT *
FROM performance_ranking
ORDER BY performance_rank;


/*==============================================================================
22. FIVE-LEVEL CTE - COMPLETE EMPLOYEE ANALYSIS

Level 1 -> Clean employees
Level 2 -> Project summary
Level 3 -> Combine data
Level 4 -> Performance calculation
Level 5 -> Final ranking
==============================================================================*/

WITH clean_employee AS
(
    SELECT
        emp_id,
        emp_name,
        NVL(department, 'Not Assigned') AS department,
        NVL(salary, 0) AS salary,
        NVL(city, 'Unknown') AS city
    FROM employee
),

project_summary AS
(
    SELECT
        emp_id,
        COUNT(*) AS total_projects,
        SUM(NVL(hours_worked, 0)) AS total_hours
    FROM employee_project
    WHERE emp_id IS NOT NULL
    GROUP BY emp_id
),

combined_data AS
(
    SELECT
        e.emp_id,
        e.emp_name,
        e.department,
        e.salary,
        e.city,
        NVL(p.total_projects, 0) AS total_projects,
        NVL(p.total_hours, 0) AS total_hours
    FROM clean_employee e
    LEFT JOIN project_summary p
        ON e.emp_id = p.emp_id
),

performance_data AS
(
    SELECT
        emp_id,
        emp_name,
        department,
        salary,
        city,
        total_projects,
        total_hours,

        CASE
            WHEN total_projects >= 2
             AND total_hours >= 180 THEN 'Excellent'

            WHEN total_hours >= 100 THEN 'Good'

            WHEN total_projects = 0 THEN 'Unallocated'

            ELSE 'Average'
        END AS performance

    FROM combined_data
),

final_ranking AS
(
    SELECT
        emp_id,
        emp_name,
        department,
        salary,
        city,
        total_projects,
        total_hours,
        performance,

        DENSE_RANK() OVER
        (
            ORDER BY total_hours DESC
        ) AS overall_rank

    FROM performance_data
)

SELECT *
FROM final_ranking
ORDER BY overall_rank;


/*==============================================================================
23. MULTIPLE INDEPENDENT CTEs

CTE 1 -> Employees
CTE 2 -> Active projects
CTE 3 -> Completed projects
Final -> Join all three
==============================================================================*/

WITH employee_data AS
(
    SELECT
        emp_id,
        emp_name,
        department
    FROM employee
),

active_projects AS
(
    SELECT
        emp_id,
        COUNT(*) AS active_projects,
        SUM(NVL(hours_worked, 0)) AS active_hours
    FROM employee_project
    WHERE status = 'Active'
    GROUP BY emp_id
),

completed_projects AS
(
    SELECT
        emp_id,
        COUNT(*) AS completed_projects,
        SUM(NVL(hours_worked, 0)) AS completed_hours
    FROM employee_project
    WHERE status = 'Completed'
    GROUP BY emp_id
)

SELECT
    e.emp_id,
    e.emp_name,
    e.department,
    NVL(a.active_projects, 0) AS active_projects,
    NVL(a.active_hours, 0) AS active_hours,
    NVL(c.completed_projects, 0) AS completed_projects,
    NVL(c.completed_hours, 0) AS completed_hours

FROM employee_data e

LEFT JOIN active_projects a
    ON e.emp_id = a.emp_id

LEFT JOIN completed_projects c
    ON e.emp_id = c.emp_id

ORDER BY e.emp_id;


/*==============================================================================
24. TWO-LEVEL CTE + ROW_NUMBER - CONTINUED

Find the highest-hours project for every employee.

Level 1 -> Employee + Project details
Level 2 -> Rank projects for each employee
==============================================================================*/

WITH employee_projects AS
(
    SELECT
        e.emp_id,
        e.emp_name,
        p.project_name,
        NVL(p.hours_worked, 0) AS hours_worked
    FROM employee e
    JOIN employee_project p
        ON e.emp_id = p.emp_id
),

ranked_projects AS
(
    SELECT
        emp_id,
        emp_name,
        project_name,
        hours_worked,

        ROW_NUMBER() OVER
        (
            PARTITION BY emp_id
            ORDER BY hours_worked DESC
        ) AS project_rank

    FROM employee_projects
)

SELECT
    emp_id,
    emp_name,
    project_name,
    hours_worked
FROM ranked_projects
WHERE project_rank = 1
ORDER BY emp_id;


/*==============================================================================
25. TWO-LEVEL CTE + RANK

Level 1 -> Calculate total project hours
Level 2 -> Rank employees based on hours
==============================================================================*/

WITH employee_hours AS
(
    SELECT
        e.emp_id,
        e.emp_name,
        SUM(NVL(p.hours_worked, 0)) AS total_hours
    FROM employee e
    LEFT JOIN employee_project p
        ON e.emp_id = p.emp_id
    GROUP BY
        e.emp_id,
        e.emp_name
),

ranked_employees AS
(
    SELECT
        emp_id,
        emp_name,
        total_hours,

        RANK() OVER
        (
            ORDER BY total_hours DESC
        ) AS employee_rank

    FROM employee_hours
)

SELECT *
FROM ranked_employees
ORDER BY employee_rank;


/*==============================================================================
26. TWO-LEVEL CTE + DENSE_RANK

DENSE_RANK does not skip ranking numbers when ties occur.
==============================================================================*/

WITH employee_hours AS
(
    SELECT
        e.emp_id,
        e.emp_name,
        SUM(NVL(p.hours_worked, 0)) AS total_hours
    FROM employee e
    LEFT JOIN employee_project p
        ON e.emp_id = p.emp_id
    GROUP BY
        e.emp_id,
        e.emp_name
),

ranked_employees AS
(
    SELECT
        emp_id,
        emp_name,
        total_hours,

        DENSE_RANK() OVER
        (
            ORDER BY total_hours DESC
        ) AS employee_rank

    FROM employee_hours
)

SELECT *
FROM ranked_employees
ORDER BY employee_rank;


/*==============================================================================
27. THREE-LEVEL CTE + ROW_NUMBER

Find the highest-hours project for every employee.

Level 1 -> Prepare project data
Level 2 -> Rank projects
Level 3 -> Filter rank 1
==============================================================================*/

WITH project_data AS
(
    SELECT
        e.emp_id,
        e.emp_name,
        e.department,
        p.project_name,
        NVL(p.hours_worked, 0) AS hours_worked
    FROM employee e
    JOIN employee_project p
        ON e.emp_id = p.emp_id
),

project_ranking AS
(
    SELECT
        emp_id,
        emp_name,
        department,
        project_name,
        hours_worked,

        ROW_NUMBER() OVER
        (
            PARTITION BY emp_id
            ORDER BY hours_worked DESC
        ) AS rn

    FROM project_data
),

top_project AS
(
    SELECT *
    FROM project_ranking
    WHERE rn = 1
)

SELECT *
FROM top_project
ORDER BY emp_id;


/*==============================================================================
28. THREE-LEVEL CTE - TOP 3 EMPLOYEES BY PROJECT HOURS

Level 1 -> Calculate hours
Level 2 -> Rank employees
Level 3 -> Filter top 3
==============================================================================*/

WITH employee_hours AS
(
    SELECT
        e.emp_id,
        e.emp_name,
        e.department,
        SUM(NVL(p.hours_worked, 0)) AS total_hours
    FROM employee e
    LEFT JOIN employee_project p
        ON e.emp_id = p.emp_id
    GROUP BY
        e.emp_id,
        e.emp_name,
        e.department
),

employee_ranking AS
(
    SELECT
        emp_id,
        emp_name,
        department,
        total_hours,

        DENSE_RANK() OVER
        (
            ORDER BY total_hours DESC
        ) AS employee_rank

    FROM employee_hours
),

top_employees AS
(
    SELECT *
    FROM employee_ranking
    WHERE employee_rank <= 3
)

SELECT *
FROM top_employees
ORDER BY employee_rank;


/*==============================================================================
29. THREE-LEVEL CTE - DEPARTMENT-WISE TOP SALARY

Level 1 -> Clean salary data
Level 2 -> Rank within each department
Level 3 -> Select rank 1
==============================================================================*/

WITH valid_salary AS
(
    SELECT
        emp_id,
        emp_name,
        department,
        salary
    FROM employee
    WHERE salary IS NOT NULL
      AND department IS NOT NULL
),

salary_ranking AS
(
    SELECT
        emp_id,
        emp_name,
        department,
        salary,

        DENSE_RANK() OVER
        (
            PARTITION BY department
            ORDER BY salary DESC
        ) AS salary_rank

    FROM valid_salary
),

highest_paid AS
(
    SELECT *
    FROM salary_ranking
    WHERE salary_rank = 1
)

SELECT *
FROM highest_paid
ORDER BY department;


/*==============================================================================
30. TWO-LEVEL CTE + LAG

Compare employee salary with previous employee salary
inside the same department.
==============================================================================*/

WITH salary_data AS
(
    SELECT
        emp_id,
        emp_name,
        department,
        salary
    FROM employee
    WHERE salary IS NOT NULL
      AND department IS NOT NULL
),

salary_comparison AS
(
    SELECT
        emp_id,
        emp_name,
        department,
        salary,

        LAG(salary) OVER
        (
            PARTITION BY department
            ORDER BY salary
        ) AS previous_salary

    FROM salary_data
)

SELECT
    emp_id,
    emp_name,
    department,
    salary,
    previous_salary,
    salary - previous_salary AS salary_difference
FROM salary_comparison
ORDER BY department, salary;


/*==============================================================================
31. TWO-LEVEL CTE + LEAD

Compare employee salary with the next employee salary
inside the department.
==============================================================================*/

WITH salary_data AS
(
    SELECT
        emp_id,
        emp_name,
        department,
        salary
    FROM employee
    WHERE salary IS NOT NULL
      AND department IS NOT NULL
),

salary_comparison AS
(
    SELECT
        emp_id,
        emp_name,
        department,
        salary,

        LEAD(salary) OVER
        (
            PARTITION BY department
            ORDER BY salary
        ) AS next_salary

    FROM salary_data
)

SELECT
    emp_id,
    emp_name,
    department,
    salary,
    next_salary,
    next_salary - salary AS salary_difference
FROM salary_comparison
ORDER BY department, salary;


/*==============================================================================
32. TWO-LEVEL CTE + FIRST_VALUE

Find highest salary in each department.
==============================================================================*/

WITH salary_data AS
(
    SELECT
        emp_id,
        emp_name,
        department,
        salary
    FROM employee
    WHERE salary IS NOT NULL
      AND department IS NOT NULL
),

salary_analysis AS
(
    SELECT
        emp_id,
        emp_name,
        department,
        salary,

        FIRST_VALUE(salary) OVER
        (
            PARTITION BY department
            ORDER BY salary DESC
        ) AS highest_department_salary

    FROM salary_data
)

SELECT *
FROM salary_analysis
ORDER BY department, salary DESC;


/*==============================================================================
33. TWO-LEVEL CTE + LAST_VALUE

Find lowest salary in each department.

Important:
ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
allows LAST_VALUE to look at the complete department.
==============================================================================*/

WITH salary_data AS
(
    SELECT
        emp_id,
        emp_name,
        department,
        salary
    FROM employee
    WHERE salary IS NOT NULL
      AND department IS NOT NULL
),

salary_analysis AS
(
    SELECT
        emp_id,
        emp_name,
        department,
        salary,

        LAST_VALUE(salary) OVER
        (
            PARTITION BY department
            ORDER BY salary DESC
            ROWS BETWEEN
                UNBOUNDED PRECEDING
                AND
                UNBOUNDED FOLLOWING
        ) AS lowest_department_salary

    FROM salary_data
)

SELECT *
FROM salary_analysis
ORDER BY department, salary DESC;


/*==============================================================================
34. TWO-LEVEL CTE - RUNNING TOTAL

Calculate cumulative project hours.
==============================================================================*/

WITH employee_hours AS
(
    SELECT
        e.emp_id,
        e.emp_name,
        SUM(NVL(p.hours_worked, 0)) AS total_hours
    FROM employee e
    LEFT JOIN employee_project p
        ON e.emp_id = p.emp_id
    GROUP BY
        e.emp_id,
        e.emp_name
),

running_total AS
(
    SELECT
        emp_id,
        emp_name,
        total_hours,

        SUM(total_hours) OVER
        (
            ORDER BY emp_id
            ROWS BETWEEN
                UNBOUNDED PRECEDING
                AND
                CURRENT ROW
        ) AS cumulative_hours

    FROM employee_hours
)

SELECT *
FROM running_total
ORDER BY emp_id;


/*==============================================================================
35. THREE-LEVEL CTE - DEPARTMENT PROJECT SUMMARY

Level 1 -> Employee/project data
Level 2 -> Employee summary
Level 3 -> Department summary
==============================================================================*/

WITH employee_project_data AS
(
    SELECT
        e.emp_id,
        e.emp_name,
        NVL(e.department, 'Not Assigned') AS department,
        p.project_name,
        NVL(p.hours_worked, 0) AS hours_worked
    FROM employee e
    LEFT JOIN employee_project p
        ON e.emp_id = p.emp_id
),

employee_summary AS
(
    SELECT
        emp_id,
        emp_name,
        department,
        COUNT(project_name) AS project_count,
        SUM(hours_worked) AS total_hours
    FROM employee_project_data
    GROUP BY
        emp_id,
        emp_name,
        department
),

department_summary AS
(
    SELECT
        department,
        COUNT(*) AS employee_count,
        SUM(project_count) AS total_projects,
        SUM(total_hours) AS total_hours
    FROM employee_summary
    GROUP BY department
)

SELECT *
FROM department_summary
ORDER BY total_hours DESC;


/*==============================================================================
36. FOUR-LEVEL CTE - DEPARTMENT RANKING

Level 1 -> Employee/project data
Level 2 -> Employee summary
Level 3 -> Department summary
Level 4 -> Rank departments
==============================================================================*/

WITH employee_project_data AS
(
    SELECT
        e.emp_id,
        e.emp_name,
        NVL(e.department, 'Not Assigned') AS department,
        p.project_name,
        NVL(p.hours_worked, 0) AS hours_worked
    FROM employee e
    LEFT JOIN employee_project p
        ON e.emp_id = p.emp_id
),

employee_summary AS
(
    SELECT
        emp_id,
        emp_name,
        department,
        COUNT(project_name) AS project_count,
        SUM(hours_worked) AS total_hours
    FROM employee_project_data
    GROUP BY
        emp_id,
        emp_name,
        department
),

department_summary AS
(
    SELECT
        department,
        COUNT(*) AS employee_count,
        SUM(project_count) AS total_projects,
        SUM(total_hours) AS total_hours
    FROM employee_summary
    GROUP BY department
),

department_ranking AS
(
    SELECT
        department,
        employee_count,
        total_projects,
        total_hours,

        DENSE_RANK() OVER
        (
            ORDER BY total_hours DESC
        ) AS department_rank

    FROM department_summary
)

SELECT *
FROM department_ranking
ORDER BY department_rank;


/*==============================================================================
37. MULTIPLE INDEPENDENT CTEs

CTE 1 -> Active projects
CTE 2 -> Completed projects
CTE 3 -> Pending projects

Final -> Combine all project statuses for each employee.
==============================================================================*/

WITH active_projects AS
(
    SELECT
        emp_id,
        COUNT(*) AS active_count
    FROM employee_project
    WHERE status = 'Active'
    GROUP BY emp_id
),

completed_projects AS
(
    SELECT
        emp_id,
        COUNT(*) AS completed_count
    FROM employee_project
    WHERE status = 'Completed'
    GROUP BY emp_id
),

pending_projects AS
(
    SELECT
        emp_id,
        COUNT(*) AS pending_count
    FROM employee_project
    WHERE status = 'Pending'
    GROUP BY emp_id
)

SELECT
    e.emp_id,
    e.emp_name,

    NVL(a.active_count, 0) AS active_projects,

    NVL(c.completed_count, 0) AS completed_projects,

    NVL(p.pending_count, 0) AS pending_projects

FROM employee e

LEFT JOIN active_projects a
    ON e.emp_id = a.emp_id

LEFT JOIN completed_projects c
    ON e.emp_id = c.emp_id

LEFT JOIN pending_projects p
    ON e.emp_id = p.emp_id

ORDER BY e.emp_id;


/*==============================================================================
38. THREE-LEVEL CTE - FIND EMPLOYEES ABOVE DEPARTMENT AVERAGE

Level 1 -> Valid salary data
Level 2 -> Department average
Level 3 -> Compare employees
==============================================================================*/

WITH employee_salary AS
(
    SELECT
        emp_id,
        emp_name,
        department,
        salary
    FROM employee
    WHERE salary IS NOT NULL
      AND department IS NOT NULL
),

department_average AS
(
    SELECT
        department,
        AVG(salary) AS avg_salary
    FROM employee_salary
    GROUP BY department
),

above_average_employees AS
(
    SELECT
        e.emp_id,
        e.emp_name,
        e.department,
        e.salary,
        d.avg_salary

    FROM employee_salary e

    JOIN department_average d
        ON e.department = d.department

    WHERE e.salary > d.avg_salary
)

SELECT *
FROM above_average_employees
ORDER BY department, salary DESC;


/*==============================================================================
39. FOUR-LEVEL CTE - PROJECT PERFORMANCE

Level 1 -> Valid project data
Level 2 -> Project summary
Level 3 -> Project classification
Level 4 -> Project ranking
==============================================================================*/

WITH valid_projects AS
(
    SELECT
        emp_id,
        project_name,
        NVL(hours_worked, 0) AS hours_worked
    FROM employee_project
    WHERE emp_id IS NOT NULL
),

project_summary AS
(
    SELECT
        project_name,
        COUNT(DISTINCT emp_id) AS employee_count,
        SUM(hours_worked) AS total_hours,
        ROUND(AVG(hours_worked), 2) AS avg_hours
    FROM valid_projects
    GROUP BY project_name
),

project_classification AS
(
    SELECT
        project_name,
        employee_count,
        total_hours,
        avg_hours,

        CASE
            WHEN total_hours >= 200 THEN 'High Effort Project'
            WHEN total_hours >= 100 THEN 'Medium Effort Project'
            ELSE 'Low Effort Project'
        END AS project_category

    FROM project_summary
),

project_ranking AS
(
    SELECT
        project_name,
        employee_count,
        total_hours,
        avg_hours,
        project_category,

        DENSE_RANK() OVER
        (
            ORDER BY total_hours DESC
        ) AS project_rank

    FROM project_classification
)

SELECT *
FROM project_ranking
ORDER BY project_rank;


/*==============================================================================
40. FIVE-LEVEL CTE - COMPLETE BUSINESS SCENARIO

Level 1 -> Clean employee data
Level 2 -> Calculate project metrics
Level 3 -> Combine employee/project data
Level 4 -> Calculate employee performance
Level 5 -> Rank employees

This demonstrates how CTEs can replace deeply nested subqueries
and make complex SQL easier to understand.
==============================================================================*/

WITH clean_employee AS
(
    SELECT
        emp_id,
        emp_name,
        NVL(department, 'Not Assigned') AS department,
        NVL(salary, 0) AS salary,
        NVL(city, 'Unknown') AS city
    FROM employee
),

project_metrics AS
(
    SELECT
        emp_id,
        COUNT(*) AS project_count,
        SUM(NVL(hours_worked, 0)) AS total_hours,
        ROUND(AVG(NVL(hours_worked, 0)), 2) AS avg_hours
    FROM employee_project
    WHERE emp_id IS NOT NULL
    GROUP BY emp_id
),

combined_data AS
(
    SELECT
        e.emp_id,
        e.emp_name,
        e.department,
        e.salary,
        e.city,

        NVL(p.project_count, 0) AS project_count,
        NVL(p.total_hours, 0) AS total_hours,
        NVL(p.avg_hours, 0) AS avg_hours

    FROM clean_employee e

    LEFT JOIN project_metrics p
        ON e.emp_id = p.emp_id
),

performance_data AS
(
    SELECT
        emp_id,
        emp_name,
        department,
        salary,
        city,
        project_count,
        total_hours,
        avg_hours,

        CASE
            WHEN project_count >= 2
             AND total_hours >= 180
                THEN 'Excellent'

            WHEN project_count >= 1
             AND total_hours >= 100
                THEN 'Good'

            WHEN project_count = 0
                THEN 'Unallocated'

            ELSE 'Average'

        END AS performance

    FROM combined_data
),

final_employee_ranking AS
(
    SELECT
        emp_id,
        emp_name,
        department,
        salary,
        city,
        project_count,
        total_hours,
        avg_hours,
        performance,

        DENSE_RANK() OVER
        (
            ORDER BY total_hours DESC
        ) AS overall_rank

    FROM performance_data
)

SELECT *
FROM final_employee_ranking
ORDER BY overall_rank;


/*==============================================================================
                     QUICK CTE CONCEPT SUMMARY

 BASIC:

 WITH cte_name AS
 (
     SELECT ...
 )
 SELECT *
 FROM cte_name;


 TWO LEVEL:

 WITH cte1 AS
 (
     SELECT ...
 ),

 cte2 AS
 (
     SELECT ...
     FROM cte1
 )

 SELECT *
 FROM cte2;


 THREE LEVEL:

 WITH cte1 AS
 (
     SELECT ...
 ),

 cte2 AS
 (
     SELECT ...
     FROM cte1
 ),

 cte3 AS
 (
     SELECT ...
     FROM cte2
 )

 SELECT *
 FROM cte3;


 MULTIPLE LEVEL:

 WITH level1 AS
 (
     SELECT ...
 ),

 level2 AS
 (
     SELECT ...
     FROM level1
 ),

 level3 AS
 (
     SELECT ...
     FROM level2
 ),

 level4 AS
 (
     SELECT ...
     FROM level3
 ),

 level5 AS
 (
     SELECT ...
     FROM level4

