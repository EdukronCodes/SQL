# Day 9: Aggregation & GROUP BY — Full Notes and Theory

---

## 1. What Aggregation Is and Why It Matters

**Aggregation** means summarizing many rows into one (or one per group): counts, sums, averages, minimums, maximums. Reports and dashboards constantly need "total salary per department," "number of employees per job," "average salary by department." You use **aggregate functions** (COUNT, SUM, AVG, MIN, MAX) and **GROUP BY** to compute these from **hr.employees** and **hr.departments** without writing application loops.

- Aggregate functions **ignore NULL** (except COUNT(*) which counts rows). So AVG(salary) is the average of non-NULL salaries; COUNT(commission_pct) counts only rows where commission_pct is not NULL.
- **GROUP BY** splits the result into groups; each group gets one row and its own aggregate values. Every non-aggregated column in the SELECT list must appear in GROUP BY.

---

## 2. COUNT, SUM, AVG, MIN, MAX

| Function | Meaning | Example |
|----------|---------|---------|
| **COUNT(*)** | Number of rows | COUNT(*) |
| **COUNT(column)** | Number of non-NULL values in column | COUNT(commission_pct) |
| **SUM(column)** | Sum of values | SUM(salary) |
| **AVG(column)** | Average (ignores NULL) | AVG(salary) |
| **MIN(column)** | Minimum | MIN(hire_date) |
| **MAX(column)** | Maximum | MAX(salary) |

**Examples on hr.employees:**

```sql
SELECT COUNT(*) AS total_employees FROM hr.employees;
SELECT SUM(salary) AS total_salary, AVG(salary) AS avg_salary FROM hr.employees;
SELECT MIN(hire_date) AS earliest_hire, MAX(hire_date) AS latest_hire FROM hr.employees;
SELECT COUNT(commission_pct) AS employees_with_commission FROM hr.employees;
```

---

## 3. GROUP BY – Single and Multiple Columns

**GROUP BY** divides rows into groups. Each **unique combination** of the GROUP BY columns becomes one group; aggregate functions are then computed **per group**.

**Single column:**

```sql
SELECT department_id, COUNT(*) AS emp_count, SUM(salary) AS total_sal
FROM hr.employees
GROUP BY department_id;
```

**Multiple columns:** One row per unique (department_id, job_id):

```sql
SELECT department_id, job_id, COUNT(*) AS cnt, AVG(salary) AS avg_sal
FROM hr.employees
GROUP BY department_id, job_id;
```

**Rule:** Every column in the SELECT list that is not inside an aggregate function must appear in the GROUP BY clause.

---

## 4. Grouping by department_id and job_id (HR Patterns)

**Per department:** Total salary and headcount per department_id.

**Per job:** Headcount and average salary per job_id.

**Per department and job:** Headcount per (department_id, job_id). Combine with ORDER BY for readable reports.

---

## 5. NULL in Aggregates and COUNT(*) vs COUNT(column)

- **COUNT(*)** counts **all** rows in the group.
- **COUNT(column)** counts only rows where **column** is NOT NULL.
- **SUM, AVG, MIN, MAX** ignore NULL. So AVG(commission_pct) is the average among employees who have a commission; it does not include NULLs.

Use COUNT(*) for "how many rows"; use COUNT(column) when you want "how many non-NULL values."

---

## 6. HAVING Preview

**HAVING** filters **groups** after aggregation (WHERE filters **rows** before grouping). Example: departments with more than 5 employees:

```sql
SELECT department_id, COUNT(*) AS cnt
FROM hr.employees
GROUP BY department_id
HAVING COUNT(*) > 5;
```

HAVING is covered in full on Day 10.

---

## 7. Summary Points

- Use **COUNT, SUM, AVG, MIN, MAX** for summaries; they ignore NULL except COUNT(*) and COUNT(column).
- **GROUP BY** defines groups; each group produces one row. Non-aggregated SELECT columns must be in GROUP BY.
- **COUNT(*)** vs **COUNT(column):** * counts rows; column counts non-NULLs. All examples use **hr.employees** and **hr.departments** only.

---

[← Day 8](./day08_join_types.md) | [Back to Learning Plan](../30-day-sql-plsql-learning-plan.md) | [Next: Day 10 →](./day10_having_aggregation.md)
