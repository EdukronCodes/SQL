# Day 4: DML – Insert, Update, Delete — Full Notes and Theory

---

## 1. What Is DML and How It Differs from DDL

**DML (Data Manipulation Language)** is the part of SQL that **changes the data** stored in tables: adding rows (**INSERT**), changing existing rows (**UPDATE**), and removing rows (**DELETE**). It does not change the structure of tables (that is DDL). In the HR schema, you will use DML on tables like **hr.employees** and **hr.departments** or on **backup/copy** tables (e.g., hr_emp_backup) so that you do not corrupt production data.

- **Transactional:** In Oracle, DML changes are **not** permanent until you **COMMIT**. Until then, you can **ROLLBACK** and undo them. This is different from DDL, which commits implicitly.
- **Row-level locks:** When you UPDATE or DELETE rows, those rows are locked so other sessions cannot modify them until you commit or roll back. This protects data integrity.
- **Safe practice:** Always test DML on a copy of the table (e.g., CREATE TABLE hr_emp_backup AS SELECT * FROM hr.employees) and use WHERE clauses so you affect only the intended rows.

---

## 2. INSERT: Adding New Rows

The **INSERT** statement adds one or more rows to a table. You specify the **table**, the **columns** you are filling, and the **values** (either explicitly in a VALUES list or from a SELECT).

**Single-row INSERT syntax:**

```sql
INSERT INTO table_name (col1, col2, col3, ...)
VALUES (val1, val2, val3, ...);
```

- The number of columns and values must match. The order of values must match the order of columns. If you omit a column, it gets **NULL** or its **DEFAULT** value (if defined).
- **Data types** must be compatible: numbers for NUMBER columns, dates for DATE, quoted strings for VARCHAR2. Use **SYSDATE** for the current date/time in Oracle.
- **Example** (using a backup table patterned on hr.employees):

```sql
INSERT INTO hr_emp_backup (
  employee_id, first_name, last_name, email, hire_date, job_id, salary, department_id
) VALUES (
  999, 'John', 'Doe', 'JDOE', SYSDATE, 'SA_REP', 5000, 50
);
```

If the backup table has a **primary key** or **unique** constraint on employee_id, ensure 999 does not already exist. If it has a **foreign key** on department_id, 50 must exist in hr.departments.

---

## 3. INSERT Multiple Rows and INSERT ALL (Oracle)

Standard SQL allows one row per INSERT. To insert multiple rows in one statement in Oracle, you can use **INSERT ALL**:

```sql
INSERT ALL
  INTO hr_emp_backup (employee_id, first_name, last_name, salary, department_id) VALUES (998, 'Jane', 'Smith', 6000, 50)
  INTO hr_emp_backup (employee_id, first_name, last_name, salary, department_id) VALUES (997, 'Bob', 'Lee', 5500, 60)
SELECT 1 FROM DUAL;
```

Each **INTO** clause defines one row; the **SELECT 1 FROM DUAL** is required syntax (it drives how many times the INSERT ALL is executed). Alternatively, you can issue multiple **INSERT INTO ... VALUES** statements or use **INSERT ... SELECT** to copy many rows from another table.

---

## 4. INSERT … SELECT: Bulk Insert from Another Table

**INSERT ... SELECT** inserts rows into a table using the result of a **SELECT** statement. This is the standard way to copy data (e.g., from hr.employees into a backup or staging table).

**Syntax:** `INSERT INTO target_table (col1, col2, ...) SELECT col1, col2, ... FROM source_table [WHERE ...];`

- The **SELECT** must return the same number of columns as the INSERT list, with **compatible types**. Column names do not need to match; position and type do.
- **Example:** Copy all employees in department 50 into hr_emp_backup:

```sql
INSERT INTO hr_emp_backup (employee_id, first_name, last_name, salary, department_id)
SELECT employee_id, first_name, last_name, salary, department_id
FROM hr.employees
WHERE department_id = 50;
```

This is useful for backups, data migration, and populating summary or staging tables from hr.employees and hr.departments.

---

## 5. UPDATE: Changing Existing Rows

The **UPDATE** statement **modifies** existing rows. You specify the **table**, the **set of column = value** (or expression), and optionally a **WHERE** clause. Only rows that match the WHERE condition are updated.

**Syntax:** `UPDATE table_name SET col1 = val1, col2 = val2, ... [WHERE condition];`

- **Always use WHERE** unless you intend to update every row in the table. Accidentally running UPDATE without WHERE can change thousands of rows.
- **Best practice:** Run a **SELECT** with the same WHERE first to see which rows will be updated, then run the UPDATE, then verify (e.g., SELECT again or check SQL%ROWCOUNT in PL/SQL).

**Example: Update one row**

```sql
UPDATE hr_emp_backup
SET salary = 5500, first_name = 'Jonathan'
WHERE employee_id = 999;
```

**Example: Update many rows**

```sql
UPDATE hr_emp_backup
SET salary = salary * 1.10
WHERE department_id = 60;
```

This gives a 10% raise to every employee in department 60 in the backup table.

---

## 6. Updating from Another Table (Subquery in SET)

Sometimes the new value comes from **another table** (e.g., sync salary from hr.employees into hr_emp_backup). You can use a **subquery** in the SET clause:

```sql
UPDATE hr_emp_backup e
SET e.salary = (SELECT salary FROM hr.employees WHERE employee_id = e.employee_id)
WHERE e.employee_id IN (SELECT employee_id FROM hr.employees WHERE department_id = 60);
```

The subquery in SET must return a **single value** per row (scalar). The WHERE restricts which rows in hr_emp_backup are updated. For more complex sync logic (insert if not exists, update if exists), use **MERGE**.

---

## 7. DELETE: Removing Rows

The **DELETE** statement **removes** rows from a table. You specify the **table** and optionally a **WHERE** clause. Rows that match the WHERE are deleted; if you omit WHERE, **all rows** are deleted (the table structure remains).

**Syntax:** `DELETE FROM table_name [WHERE condition];`

- **Always use WHERE** unless you intend to empty the table. DELETE without WHERE is a common mistake and can wipe a table.
- DELETE can be **rolled back** until you COMMIT. After COMMIT, the data is gone unless you have a backup.
- **Example:**

```sql
DELETE FROM hr_emp_backup
WHERE employee_id = 999;
```

```sql
DELETE FROM hr_emp_backup
WHERE department_id IS NULL;
```

For removing **all** rows, **TRUNCATE TABLE** is faster and does not fire row triggers, but it cannot be rolled back (DDL) and does not use WHERE.

---

## 8. MERGE (Upsert) Concept

**MERGE** (also called upsert) combines **INSERT** and **UPDATE** in one statement. You define a **source** (e.g., hr.employees) and a **target** (e.g., hr_emp_backup). For each source row, you check whether a matching row exists in the target (e.g., on employee_id). If it exists, you **UPDATE** the target row; if not, you **INSERT** a new row. This is ideal for syncing or loading data from hr.employees into a backup or staging table.

**Example pattern:**

```sql
MERGE INTO hr_emp_backup t
USING hr.employees s ON (t.employee_id = s.employee_id)
WHEN MATCHED THEN UPDATE SET t.salary = s.salary, t.hire_date = s.hire_date
WHEN NOT MATCHED THEN INSERT (employee_id, first_name, last_name, salary, department_id)
  VALUES (s.employee_id, s.first_name, s.last_name, s.salary, s.department_id);
```

- **ON** defines the join between target and source. **WHEN MATCHED** runs for rows that exist in both; **WHEN NOT MATCHED** runs for source rows with no match in the target. You can use MERGE to keep hr_emp_backup in sync with hr.employees.

---

## 9. Safe Practices and Affecting Row Count

**Safe practices:**

1. **Always use WHERE** on UPDATE and DELETE unless you really mean to affect every row.
2. Run a **SELECT** with the same WHERE first to preview which rows will change.
3. Use **transactions:** run in a test environment, verify the result, then **COMMIT** or **ROLLBACK**.
4. Prefer **INSERT ... SELECT** and **MERGE** for bulk operations from hr.employees.

**Row count:** In SQL*Plus or SQL Developer, the tool often reports "X rows updated/deleted/inserted." In **PL/SQL**, after an INSERT, UPDATE, or DELETE, **SQL%ROWCOUNT** gives the number of rows affected. Use it to validate (e.g., IF SQL%ROWCOUNT = 0 THEN RAISE_APPLICATION_ERROR(...)).

---

## 10. Summary Points

- DML (INSERT, UPDATE, DELETE) changes data; it is transactional and can be rolled back until COMMIT.
- INSERT adds rows using VALUES or SELECT; use INSERT ... SELECT for bulk copy from hr.employees.
- UPDATE modifies existing rows; use SET and WHERE; subqueries in SET can pull values from other tables.
- DELETE removes rows; use WHERE to limit which rows are removed.
- MERGE combines INSERT and UPDATE for sync/upsert from a source (e.g., hr.employees) into a target table.
- Always use WHERE on UPDATE/DELETE and verify with SELECT first; test on backup tables.

---

[← Day 3](./day03_ddl_basics.md) | [Back to Learning Plan](../30-day-sql-plsql-learning-plan.md) | [Next: Day 5 →](./day05_dcl_tcl.md)
