# Day 30: Capstone and Best Practices — Full Notes and Theory

---

## 1. End-to-End Scenario: HR Reporting Module

Design a small **HR reporting module** using only **hr.employees** and **hr.departments** (and audit/summary tables you create):

- **Views** — Employee plus department name; department summary (headcount, total salary); salary band (Low/Medium/High). Use for security and reuse.
- **Procedure** — department_summary(p_dept_id) returning headcount, total salary, min/max hire_date; list_emp_by_dept; raise_salary.
- **Function** — get_department_name(department_id), employee_count(department_id). Use in SQL and procedures.
- **Trigger** — Audit salary or department_id changes on hr.employees (or copy table) into an audit table.

Build these so they work together: views for reports, procedures for actions, functions for lookups, triggers for audit. Document names, purpose, and main tables.

## 2. Code Style and Naming

- Parameters: **p_** (p_dept_id, p_emp_id). Local variables: **v_**. Cursors: **c_**.
- Procedures/functions: get_employee_count, raise_salary, department_summary, get_department_name.
- Indent and align blocks. Add short comments for non-obvious logic.

## 3. Error Handling

- Handle **NO_DATA_FOUND** and **TOO_MANY_ROWS** where SELECT INTO is used.
- Use **RAISE_APPLICATION_ERROR(-20000 to -20999, message)** for business rules (invalid department_id, salary out of range).
- Avoid empty WHEN OTHERS; at least log (SQLERRM) and re-raise (RAISE).

## 4. Indexing and Security Recap

- Index columns used in WHERE and JOIN (department_id, employee_id).
- Grant only required object privileges; use roles for groups.
- Expose data through views or procedures to restrict columns (e.g. hide salary). Use definer rights so callers do not need direct table access.

## 5. Documentation

- Document parameters and return values at the top of procedures/functions.
- Keep a short README or data dictionary: views, procedures, functions, triggers, purpose, main tables.

## 6. Review of 30-Day Topics

1. SQL basics and filtering/sorting  
2. DDL, DML, DCL, TCL  
3. Single-table queries, joins, aggregation, HAVING  
4. Subqueries (scalar, correlated), set operations  
5. Window functions (ranking, value, frame)  
6. Constraints, normalization, indexes, views  
7. PL/SQL blocks, cursors, procedures, functions  
8. Exception handling, triggers  
9. Transactions, performance tuning, security  
10. Advanced reporting and capstone design  

Practice by building the HR reporting module and refining queries and procedures on hr.employees and hr.departments.

---

[← Day 29](./day29_advanced_reporting.md) | [Back to Learning Plan](../30-day-sql-plsql-learning-plan.md)
