# Day 6 Assignment: Single-Table Queries Deep Dive

All exercises use **hr.employees** (and **hr.departments** only if specified).

---

## Part 1: Practice Questions (With Answers and Explanations)

### Question 1  
List employees hired in the year **2005**.

**Answer:**

```sql
SELECT employee_id, first_name, last_name, hire_date
FROM hr.employees
WHERE hire_date >= DATE '2005-01-01' AND hire_date < DATE '2006-01-01';
```

Alternative using EXTRACT:

```sql
SELECT employee_id, first_name, last_name, hire_date
FROM hr.employees
WHERE EXTRACT(YEAR FROM hire_date) = 2005;
```

**Explanation:** Either filter by a date range (recommended for index use) or extract the year and compare to 2005.

---

### Question 2  
For each employee, show tenure in years using **MONTHS_BETWEEN** (and divide by 12). Use alias `tenure_years`, rounded to 1 decimal.

**Answer:**

```sql
SELECT employee_id, first_name, last_name, hire_date,
  ROUND(MONTHS_BETWEEN(SYSDATE, hire_date) / 12, 1) AS tenure_years
FROM hr.employees;
```

**Explanation:** MONTHS_BETWEEN(SYSDATE, hire_date) gives months since hire. Divide by 12 and ROUND(..., 1) for years with one decimal.

---

### Question 3  
Add a column **salary_band** using CASE: Low (salary < 5000), Medium (5000–11999), High (>= 12000). Show employee_id, first_name, salary, salary_band.

**Answer:**

```sql
SELECT employee_id, first_name, salary,
  CASE
    WHEN salary < 5000 THEN 'Low'
    WHEN salary < 12000 THEN 'Medium'
    ELSE 'High'
  END AS salary_band
FROM hr.employees;
```

**Explanation:** CASE evaluates conditions in order; the first match determines the result. ELSE catches all remaining (>= 12000).

---

## Part 2: Self-Practice (No Answers)

1. Show the **first 3 characters** of `last_name` for each employee (use SUBSTR).
2. List employees with **tenure greater than 15 years** (use MONTHS_BETWEEN as above).
3. In the SELECT list, use **NVL(commission_pct, 0)** in an expression that computes something like total compensation (e.g. salary + salary * commission). Give the expression an alias.

---

## Part 3: Additional Practice — 20 Medium + 20 Hard Questions (With Hints)

All use **hr.employees** and **hr.departments** only.

### 20 Medium Questions

1. **M1.** Show employee_id, first_name, and LENGTH(last_name) as last_name_length.  
   **Hint:** SELECT employee_id, first_name, LENGTH(last_name) AS last_name_length FROM hr.employees;

2. **M2.** List employees hired in 2004 using EXTRACT(YEAR FROM hire_date).  
   **Hint:** WHERE EXTRACT(YEAR FROM hire_date) = 2004;

3. **M3.** Add a column job_type: 'Sales' if job_id like 'SA%', else 'Other'. Use CASE.  
   **Hint:** CASE WHEN job_id LIKE 'SA%' THEN 'Sales' ELSE 'Other' END AS job_type;

4. **M4.** Show first_name, last_name, and tenure in months (MONTHS_BETWEEN(SYSDATE, hire_date)).  
   **Hint:** MONTHS_BETWEEN(SYSDATE, hire_date) AS tenure_months;

5. **M5.** List employees with salary between 4000 and 8000 and department_id 50 or 60. Use parentheses.  
   **Hint:** WHERE salary BETWEEN 4000 AND 8000 AND (department_id = 50 OR department_id = 60);

6. **M6.** Display employee_id, salary, and salary_level: 'Tier1' if salary < 5000, 'Tier2' if < 10000, else 'Tier3'.  
   **Hint:** CASE WHEN salary < 5000 THEN 'Tier1' WHEN salary < 10000 THEN 'Tier2' ELSE 'Tier3' END;

7. **M7.** Show last_name and INITCAP(last_name).  
   **Hint:** SELECT last_name, INITCAP(last_name) FROM hr.employees;

8. **M8.** List employees where department_id is in the set (10, 20, 30) from hr.departments (use subquery IN).  
   **Hint:** WHERE department_id IN (SELECT department_id FROM hr.departments WHERE department_id IN (10,20,30));

9. **M9.** Add column hire_month as EXTRACT(MONTH FROM hire_date).  
   **Hint:** EXTRACT(MONTH FROM hire_date) AS hire_month;

10. **M10.** Show phone_number and COALESCE(phone_number, 'No Phone').  
    **Hint:** COALESCE(phone_number, 'No Phone') AS contact;

11. **M11.** List employees with (department_id = 50 AND salary > 5000) OR (department_id = 60).  
    **Hint:** WHERE (department_id = 50 AND salary > 5000) OR department_id = 60;

12. **M12.** Display hire_date and ADD_MONTHS(hire_date, 12) as one_year_later.  
    **Hint:** ADD_MONTHS(hire_date, 12) AS one_year_later;

13. **M13.** Show first_name, last_name, and SUBSTR(first_name, 1, 1) || SUBSTR(last_name, 1, 1) as initials.  
    **Hint:** SUBSTR(first_name,1,1) || SUBSTR(last_name,1,1) AS initials;

14. **M14.** List employees hired after 2006-01-01.  
    **Hint:** WHERE hire_date > DATE '2006-01-01';

15. **M15.** Add column has_commission: 'Yes' if commission_pct is not null, 'No' otherwise. Use NVL2 or CASE.  
    **Hint:** NVL2(commission_pct, 'Yes', 'No') AS has_commission;

16. **M16.** Show salary and ROUND(salary, -2) (rounded to nearest hundred).  
    **Hint:** ROUND(salary, -2) AS salary_rounded;

17. **M17.** List employees where job_id is SA_REP or SA_MAN and salary > 8000.  
    **Hint:** WHERE job_id IN ('SA_REP','SA_MAN') AND salary > 8000;

18. **M18.** Display employee_id, hire_date, and TRUNC(hire_date) (same day at midnight).  
    **Hint:** TRUNC(hire_date) AS hire_day;

19. **M19.** Show last_name and LOWER(last_name).  
    **Hint:** LOWER(last_name) AS last_lower;

20. **M20.** List employees with tenure (MONTHS_BETWEEN/12) >= 10 years.  
    **Hint:** WHERE MONTHS_BETWEEN(SYSDATE, hire_date)/12 >= 10;

### 20 Hard Questions

1. **H1.** Show employee_id, salary, and a band: 'A' if salary in top 25%, 'B' if next 25%, etc. Use NTILE(4) over salary order or CASE with subquery for percentiles.  
   **Hint:** Use subquery for AVG/percentiles or NTILE(4) OVER (ORDER BY salary DESC) and map 1->'A', 2->'B', etc.

2. **H2.** List employees whose hire_date is in the same year as their manager's hire_date (need self-join on manager_id; compare EXTRACT(YEAR FROM e.hire_date) = EXTRACT(YEAR FROM m.hire_date)).  
   **Hint:** Self-join hr.employees e and m on e.manager_id = m.employee_id; WHERE EXTRACT(YEAR FROM e.hire_date) = EXTRACT(YEAR FROM m.hire_date).

3. **H3.** Add column salary_vs_avg: (salary - (SELECT AVG(salary) FROM hr.employees)). Round to 2 decimals.  
   **Hint:** ROUND(salary - (SELECT AVG(salary) FROM hr.employees), 2) AS salary_vs_avg;

4. **H4.** List employees with exactly 5 characters in first_name.  
   **Hint:** WHERE LENGTH(first_name) = 5;

5. **H5.** Show first_name, last_name, and full_name with last_name first: last_name || ', ' || first_name.  
   **Hint:** last_name || ', ' || first_name AS full_name;

6. **H6.** For each employee show hire_date and the day of week (use TO_CHAR(hire_date, 'Day') or similar).  
   **Hint:** TO_CHAR(hire_date, 'Day') AS day_of_week;

7. **H7.** List employees where department_id is in (SELECT department_id FROM hr.departments).  
   **Hint:** WHERE department_id IN (SELECT department_id FROM hr.departments);

8. **H8.** Add column years_until_10: years until 10 years tenure (10 - tenure_years), only for people with < 10 years.  
   **Hint:** CASE WHEN MONTHS_BETWEEN(SYSDATE, hire_date)/12 < 10 THEN ROUND(10 - MONTHS_BETWEEN(SYSDATE, hire_date)/12, 1) END;

9. **H9.** Show salary and commission_pct and total_comp as salary + salary*NVL(commission_pct,0), rounded to 2 decimals.  
   **Hint:** ROUND(salary * (1 + NVL(commission_pct,0)), 2) AS total_comp;

10. **H10.** List employees hired on the first day of any month (EXTRACT(DAY FROM hire_date) = 1).  
    **Hint:** WHERE EXTRACT(DAY FROM hire_date) = 1;

11. **H11.** Display employee_id, salary, and salary rank within department (use RANK() OVER (PARTITION BY department_id ORDER BY salary DESC)).  
    **Hint:** RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS sal_rank;

12. **H12.** List employees whose last_name contains the letter 'a' at least twice.  
    **Hint:** WHERE (LENGTH(last_name) - LENGTH(REPLACE(LOWER(last_name),'a',''))) >= 2;

13. **H13.** Show hire_date and LAST_DAY(hire_date) (last day of that month).  
    **Hint:** LAST_DAY(hire_date) AS month_end;

14. **H14.** Add column comp_category: 'Salary only' if commission_pct is null, 'Salary+Commission' otherwise.  
    **Hint:** CASE WHEN commission_pct IS NULL THEN 'Salary only' ELSE 'Salary+Commission' END;

15. **H15.** List employees with tenure (years) between 5 and 15.  
    **Hint:** WHERE MONTHS_BETWEEN(SYSDATE, hire_date)/12 BETWEEN 5 AND 15;

16. **H16.** Show first_name reversed (use REVERSE or loop in PL/SQL; in Oracle no REVERSE—use SUBSTR in a custom way or simple: list as-is and add a note). For Oracle use: list first_name and perhaps SUBSTR from end.  
   **Hint:** In Oracle 11g+: use LISTAGG trick or recursive SUBSTR; or skip reverse and use LENGTH/SUBSTR to build reversed string.

17. **H17.** List employees where department_id exists in hr.departments and salary > (SELECT AVG(salary) FROM hr.employees).  
    **Hint:** WHERE department_id IN (SELECT department_id FROM hr.departments) AND salary > (SELECT AVG(salary) FROM hr.employees);

18. **H18.** Display salary and salary with 15% bonus: salary * 1.15.  
    **Hint:** salary * 1.15 AS salary_with_bonus;

19. **H19.** Add column hire_decade: '2000s' if hire_date in 2000-2009, '1990s' if 1990-1999, else 'Other'.  
    **Hint:** CASE WHEN EXTRACT(YEAR FROM hire_date) BETWEEN 2000 AND 2009 THEN '2000s' WHEN EXTRACT(YEAR FROM hire_date) BETWEEN 1990 AND 1999 THEN '1990s' ELSE 'Other' END;

20. **H20.** List employees with first_name starting with 'A' or 'B' and salary > 6000.  
    **Hint:** WHERE (first_name LIKE 'A%' OR first_name LIKE 'B%') AND salary > 6000;

---

[← Back to Learning Plan](../30-day-sql-plsql-learning-plan.md) | [Tutorial](../tutorials/day06_single_table_queries.md)
