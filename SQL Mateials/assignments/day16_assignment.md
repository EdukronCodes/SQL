# Day 16 Assignment: Constraints

Use **hr.employees** and **hr.departments** as reference. Create your own tables (e.g. hr_emp_copy) to add constraints so you do not alter production.

---

## Part 1: Practice Questions (With Answers and Explanations)

### Question 1
Create a table **hr_emp_copy** with columns employee_id, first_name, last_name, department_id. Add a **PRIMARY KEY** on employee_id and a **FOREIGN KEY** on department_id referencing hr.departments(department_id).

**Answer:**

```sql
CREATE TABLE hr_emp_copy (
  employee_id   NUMBER(6),
  first_name    VARCHAR2(20),
  last_name     VARCHAR2(25),
  department_id NUMBER(4),
  PRIMARY KEY (employee_id),
  FOREIGN KEY (department_id) REFERENCES hr.departments(department_id)
);
```

**Explanation:** PRIMARY KEY ensures employee_id is unique and not null. FOREIGN KEY ensures every non-NULL department_id exists in hr.departments.

---

### Question 2
Add a **CHECK** constraint on **salary** so that salary must be greater than 0. (If your table has no salary column, add it first with ALTER TABLE ... ADD salary NUMBER(8,2); then add the check.)

**Answer:**

```sql
ALTER TABLE hr_emp_copy ADD salary NUMBER(8,2);
ALTER TABLE hr_emp_copy ADD CONSTRAINT chk_salary CHECK (salary > 0);
```

**Explanation:** CHECK (salary > 0) rejects any INSERT or UPDATE that sets salary to 0 or negative (or NULL if the column allows NULL).

---

### Question 3
Find the **constraint names** and types for table **hr.employees**. Query USER_CONSTRAINTS (or ALL_CONSTRAINTS) where table_name = 'EMPLOYEES'.

**Answer:**

```sql
SELECT constraint_name, constraint_type, table_name
FROM user_constraints
WHERE table_name = 'EMPLOYEES';
```

**Explanation:** constraint_type: P = primary key, R = foreign key, U = unique, C = check/not null. If the table is in another schema, use all_constraints and owner = 'HR'.

---

## Part 2: Self-Practice (No Answers)

1. Add a **UNIQUE** constraint on (department_id, job_id) to a **copy** of hr.employees (so the same department_id and job_id can appear, but not the same pair more than once if you intend uniqueness per pair).
2. **Disable** a constraint on your copy table, then **enable** it again. Use ALTER TABLE ... DISABLE CONSTRAINT name; and ENABLE CONSTRAINT name;

---

## Part 3: Additional Practice — 20 Medium + 20 Hard Questions (With Hints)

Use **hr_emp_copy** or similar copy tables; do not alter **hr.employees** / **hr.departments** directly unless instructed.

### 20 Medium Questions

1. **M1.** Create a table with PRIMARY KEY on employee_id. **Hint:** CREATE TABLE ... (employee_id NUMBER(6) PRIMARY KEY, ...);
2. **M2.** Add FOREIGN KEY (department_id) REFERENCES hr.departments(department_id). **Hint:** ALTER TABLE ... ADD CONSTRAINT fk_dept FOREIGN KEY (department_id) REFERENCES hr.departments(department_id);
3. **M3.** Add CHECK constraint: salary > 0. **Hint:** ADD CONSTRAINT chk_sal CHECK (salary > 0);
4. **M4.** Add NOT NULL to first_name. **Hint:** ALTER TABLE ... MODIFY first_name NOT NULL;
5. **M5.** Add UNIQUE constraint on email column. **Hint:** ADD CONSTRAINT uk_email UNIQUE (email);
6. **M6.** Name the primary key constraint pk_emp_copy. **Hint:** CONSTRAINT pk_emp_copy PRIMARY KEY (employee_id);
7. **M7.** Drop a CHECK constraint by name. **Hint:** ALTER TABLE ... DROP CONSTRAINT chk_salary;
8. **M8.** Create table with composite PRIMARY KEY (department_id, employee_id). **Hint:** PRIMARY KEY (department_id, employee_id);
9. **M9.** Add CHECK: hire_date <= SYSDATE (no future hire). **Hint:** CHECK (hire_date <= SYSDATE) — or use trigger for SYSDATE at insert time.
10. **M10.** Add FK manager_id REFERENCES hr.employees(employee_id). **Hint:** FOREIGN KEY (manager_id) REFERENCES hr.employees(employee_id);
11. **M11.** List constraint names on hr.employees. **Hint:** SELECT constraint_name, constraint_type FROM user_constraints WHERE table_name = 'EMPLOYEES';
12. **M12.** Add CHECK: commission_pct BETWEEN 0 AND 1. **Hint:** CHECK (commission_pct BETWEEN 0 AND 1);
13. **M13.** Add UNIQUE (first_name, last_name) — same full name not repeated. **Hint:** ADD CONSTRAINT uk_name UNIQUE (first_name, last_name);
14. **M14.** Modify column to NOT NULL. **Hint:** ALTER TABLE ... MODIFY column_name ... NOT NULL;
15. **M15.** Create table with PK and two FK (department_id, manager_id). **Hint:** Two ADD CONSTRAINT ... FOREIGN KEY ...
16. **M16.** Drop foreign key constraint by name. **Hint:** ALTER TABLE ... DROP CONSTRAINT fk_emp_dept;
17. **M17.** Add CHECK: employee_id > 0. **Hint:** CHECK (employee_id > 0);
18. **M18.** Find constraint type (P/R/U/C) for hr.departments. **Hint:** USER_CONSTRAINTS; P=primary, R=foreign, U=unique, C=check/not null.
19. **M19.** Add DEFAULT 0 for a numeric column and add NOT NULL. **Hint:** DEFAULT 0 and NOT NULL in column definition or MODIFY.
20. **M20.** Add named CHECK constraint. **Hint:** ADD CONSTRAINT name CHECK (condition);

### 20 Hard Questions

1. **H1.** Create table with PK, FK to departments, and CHECK salary > 0 and commission_pct BETWEEN 0 AND 1. **Hint:** All in CREATE TABLE or ADD after.
2. **H2.** Add FK with ON DELETE SET NULL (Oracle: reference option). **Hint:** REFERENCES hr.departments(department_id) ON DELETE SET NULL;
3. **H3.** Disable constraint, do DML, re-enable constraint. **Hint:** ALTER DISABLE CONSTRAINT; ...; ALTER ENABLE CONSTRAINT;
4. **H4.** Add CHECK that references two columns: salary >= commission_pct * 1000 (example). **Hint:** CHECK (salary >= NVL(commission_pct,0) * 1000);
5. **H5.** Create table with DEFERRABLE constraint (Oracle). **Hint:** CONSTRAINT ... PRIMARY KEY ... DEFERRABLE INITIALLY DEFERRED;
6. **H6.** List all constraints and their columns for hr.employees. **Hint:** Join user_constraints and user_cons_columns.
7. **H7.** Add FK from copy table to hr.employees(employee_id) for manager_id; handle NULL. **Hint:** FK allows NULL; REFERENCES hr.employees(employee_id).
8. **H8.** Add CHECK: hire_date >= DATE '1990-01-01'. **Hint:** CHECK (hire_date >= DATE '1990-01-01');
9. **H9.** Create unique constraint on (department_id, job_id) for a copy table. **Hint:** ADD CONSTRAINT uk_dept_job UNIQUE (department_id, job_id);
10. **H10.** Drop all CHECK constraints on a table (dynamic SQL or one by one). **Hint:** SELECT constraint_name FROM user_constraints WHERE table_name = 'X' AND constraint_type = 'C'; then DROP for each.
11. **H11.** Add NOT NULL to a column that has NULLs (will fail unless you update first). **Hint:** UPDATE ... SET col = value WHERE col IS NULL; then MODIFY col NOT NULL;
12. **H12.** Add FK to self (manager_id references employee_id). **Hint:** FOREIGN KEY (manager_id) REFERENCES same_table(employee_id);
13. **H13.** Create table with PK and two FKs and one CHECK. **Hint:** CREATE TABLE ... ( ... PRIMARY KEY ..., CONSTRAINT fk1 FOREIGN KEY ... CONSTRAINT fk2 FOREIGN KEY ... CONSTRAINT chk1 CHECK ... );
14. **H14.** Find tables that reference hr.departments (foreign keys). **Hint:** user_constraints WHERE r_constraint_name = (SELECT constraint_name FROM user_constraints WHERE table_name = 'DEPARTMENTS' AND constraint_type = 'P').
15. **H15.** Add CHECK using a function: LENGTH(first_name) >= 2. **Hint:** CHECK (LENGTH(first_name) >= 2);
16. **H16.** Enable constraint with VALIDATE (check existing data). **Hint:** ALTER TABLE ... ENABLE VALIDATE CONSTRAINT ...;
17. **H17.** Create composite UNIQUE (department_id, job_id) and composite FK (department_id references departments). **Hint:** UNIQUE (dept, job); FK (department_id) REFERENCES departments(department_id);
18. **H18.** Add constraint that salary must be <= (SELECT MAX(salary) FROM hr.employees) — not standard CHECK; use trigger. **Hint:** CHECK cannot subquery; use trigger to enforce.
19. **H19.** Rename a constraint. **Hint:** Oracle: ALTER TABLE ... RENAME CONSTRAINT old_name TO new_name;
20. **H20.** List constraint type and search_condition for CHECK constraints. **Hint:** user_constraints has constraint_type; search_condition in user_constraints (Oracle 12c+) or all_constraints.

---

[← Back to Learning Plan](../30-day-sql-plsql-learning-plan.md) | [Tutorial](../tutorials/day16_constraints.md)
