# Day 16: Constraints — Full Notes and Theory

---

## 1. What Constraints Are and Why They Matter

**Constraints** are rules enforced by the database on table data. They ensure **integrity**: primary keys guarantee unique identity, foreign keys enforce relationships (e.g., employee.department_id must exist in departments), CHECK constraints enforce business rules (e.g., salary > 0). Use them on **copy** or **staging** tables (e.g., hr_emp_copy) patterned on **hr.employees** and **hr.departments**; do not alter production HR tables without approval.

- **PRIMARY KEY:** Uniquely identifies each row; one per table; implies NOT NULL and UNIQUE.
- **FOREIGN KEY:** References a primary or unique key in another table (e.g., department_id → hr.departments).
- **UNIQUE:** No duplicate values (NULL handling is database-specific).
- **NOT NULL:** Column cannot be NULL.
- **CHECK:** Condition that each row must satisfy.

---

## 2. PRIMARY KEY

A **PRIMARY KEY** uniquely identifies each row. It implies **NOT NULL** and **UNIQUE**. A table has at most one primary key; it can be **composite** (multiple columns).

```sql
CREATE TABLE hr_emp_copy (
  employee_id   NUMBER(6) PRIMARY KEY,
  first_name    VARCHAR2(20),
  last_name     VARCHAR2(25),
  department_id NUMBER(4)
);
```

Composite: `PRIMARY KEY (department_id, employee_id)`. Name constraints for clarity: `CONSTRAINT pk_emp_copy PRIMARY KEY (employee_id)`.

---

## 3. UNIQUE and NOT NULL

**UNIQUE** ensures values in the column(s) are unique. Use for alternate keys (e.g., email). **NOT NULL** disallows NULL.

```sql
ALTER TABLE hr_emp_copy ADD CONSTRAINT uk_emp_email UNIQUE (email);
ALTER TABLE hr_emp_copy MODIFY first_name VARCHAR2(20) NOT NULL;
```

---

## 4. CHECK

**CHECK** enforces a condition on the column or row. Any INSERT or UPDATE that violates it fails.

```sql
ALTER TABLE hr_emp_copy ADD CONSTRAINT chk_salary CHECK (salary > 0);
```

---

## 5. FOREIGN KEY

A **FOREIGN KEY** references a primary or unique key in another table. It enforces **referential integrity**: values in the column must exist in the referenced table (or be NULL if the column allows NULL).

```sql
ALTER TABLE hr_emp_copy ADD CONSTRAINT fk_emp_dept
  FOREIGN KEY (department_id) REFERENCES hr.departments(department_id);
```

So department_id in hr_emp_copy must exist in hr.departments. In the standard HR schema, hr.employees has FK to hr.departments and self-referencing FK (manager_id → employee_id).

---

## 6. Adding, Dropping, and Naming Constraints

**Add:** `ALTER TABLE ... ADD CONSTRAINT name ...`  
**Drop:** `ALTER TABLE ... DROP CONSTRAINT constraint_name;`  
**Disable/Enable:** Some databases allow DISABLE/ENABLE CONSTRAINT. Name constraints (e.g., pk_emp_copy, fk_emp_dept) for easier debugging and management.

---

## 7. DEFERRABLE and HR Schema Review

**DEFERRABLE** (Oracle) allows constraints to be deferred until COMMIT, so you can temporarily violate them within a transaction. Advanced use. In the standard HR schema, hr.employees typically has PRIMARY KEY (employee_id), FOREIGN KEY (department_id) REFERENCES hr.departments, FOREIGN KEY (manager_id) REFERENCES hr.employees, and possibly UNIQUE (email), CHECK on salary. Query **USER_CONSTRAINTS** or **ALL_CONSTRAINTS** to list constraints on a table.

---

## 8. Summary Points

- Use **PRIMARY KEY** for unique row identity; **FOREIGN KEY** for references to other tables; **CHECK** for business rules; **UNIQUE** and **NOT NULL** for data quality.
- Name constraints and add/drop them with ALTER TABLE. All examples use **hr.employees** and **hr.departments** or copies.

---

[← Day 15](./day15_window_value_frame.md) | [Back to Learning Plan](../30-day-sql-plsql-learning-plan.md) | [Next: Day 17 →](./day17_normalization.md)
