# Day 3: DDL – Create & Alter — Full Notes and Theory

---

## 1. What Is DDL and Why It Matters

**DDL (Data Definition Language)** is the subset of SQL that **defines or changes the structure** of database objects: tables, indexes, views, and so on. Unlike DML (INSERT, UPDATE, DELETE), which changes **data**, DDL changes the **schema**—the shape of your tables and their columns, types, and constraints.

- In Oracle, **DDL statements cause an implicit COMMIT**. So you cannot roll back a CREATE or ALTER TABLE; the change is permanent once the statement succeeds.
- DDL is typically executed by DBAs or developers during deployments or migrations. Understanding it is essential for creating backup tables, staging tables, and new application tables.
- Common DDL commands you will use: **CREATE TABLE**, **ALTER TABLE** (ADD, MODIFY, DROP column), **RENAME**, **TRUNCATE**, **DROP TABLE**. All of these apply to tables that you might create from or for the **hr.employees** and **hr.departments** data.

---

## 2. CREATE TABLE: Basic Syntax and Semantics

The **CREATE TABLE** statement defines a new table by specifying its name and a list of **columns**. Each column has a **name** and a **data type**; optionally you add **constraints** (e.g., NOT NULL, PRIMARY KEY), which are covered in a later day.

**Basic syntax:**

```sql
CREATE TABLE table_name (
  column1 datatype [constraints],
  column2 datatype [constraints],
  ...
);
```

- **table_name** must be unique within the schema. Use a naming convention (e.g., `hr_emp_backup`, `hr_dept_stage`) so the purpose is clear.
- **column name** must be unique within the table. **datatype** defines what values the column can hold (numbers, strings, dates). Choosing the right type and size (e.g., VARCHAR2(50) vs VARCHAR2(4000)) affects storage and application behavior.
- You can define **constraints** inline (e.g., `employee_id NUMBER(6) PRIMARY KEY`) or out of line (at the end of the CREATE TABLE). Constraints are discussed in the constraints tutorial.

---

## 3. Oracle Data Types in Detail

When you create tables (e.g., backups of hr.employees or hr.departments), you use Oracle data types. The most common are:

| Type | Description | Example |
|------|-------------|---------|
| **VARCHAR2(n)** | Variable-length character string, max n bytes (or characters with CHAR semantics). | VARCHAR2(50) for names, emails. |
| **NUMBER(p,s)** | Numeric. p = total digits (precision), s = digits after decimal (scale). | NUMBER(8,2) for salary. |
| **DATE** | Date and time (day, month, year, hour, minute, second). | hire_date DATE. |
| **TIMESTAMP** | Date and time with fractional seconds. | For audit timestamps. |

- **VARCHAR2** is preferred over CHAR in Oracle (CHAR pads with spaces; VARCHAR2 does not). Always specify a length (e.g., VARCHAR2(100)).
- **NUMBER** without precision can store large numbers but may use more space. For IDs and counts, NUMBER(6) or NUMBER(10) is typical; for money, NUMBER(10,2) or similar.
- **DATE** in Oracle always includes time; if you only care about the date, you still store it as DATE and can truncate or format when displaying.

The **hr.employees** table uses columns like employee_id NUMBER(6), first_name VARCHAR2(20), last_name VARCHAR2(25), email VARCHAR2(25), hire_date DATE, job_id VARCHAR2(10), salary NUMBER(8,2), commission_pct NUMBER(2,2), manager_id NUMBER(6), department_id NUMBER(4). The **hr.departments** table has department_id, department_name, manager_id, location_id. When you create backup or staging tables, match these types so data copies correctly.

---

## 4. CREATE TABLE AS SELECT (CTAS)

**CREATE TABLE ... AS SELECT** (often called **CTAS**) creates a new table and **populates it in one step** with the result of a query. This is extremely useful for:

- **Backups:** Copy all data from hr.employees or hr.departments into a backup table before major changes.
- **Staging:** Create a table with a subset of columns or rows for testing or reporting.
- **Empty structure:** Create a table with the same columns as another but with **no rows** by using a query that returns no rows (e.g., WHERE 1 = 0).

**Copy all columns and all rows from hr.employees:**

```sql
CREATE TABLE hr_emp_backup AS
SELECT * FROM hr.employees;
```

The new table **hr_emp_backup** has the same column names and compatible types as the query result. In Oracle, NOT NULL constraints from the source may be preserved in some versions; primary key and other constraints are generally **not** copied—you would add them with ALTER TABLE if needed.

**Copy only selected columns:**

```sql
CREATE TABLE hr_emp_short AS
SELECT employee_id, first_name, last_name, salary, department_id
FROM hr.employees;
```

**Copy structure only (no data):**

```sql
CREATE TABLE hr_emp_structure AS
SELECT * FROM hr.employees WHERE 1 = 0;
```

The condition **1 = 0** is always false, so no rows are returned. The table is created with the same columns and types but is empty.

---

## 5. ALTER TABLE: Adding a Column

**ALTER TABLE ... ADD** adds one or more new columns to an existing table. Existing rows get **NULL** in the new column(s) unless you specify a **DEFAULT** value.

**Syntax:** `ALTER TABLE table_name ADD column_name datatype [DEFAULT value];`

**Example:**

```sql
ALTER TABLE hr_emp_backup ADD notes VARCHAR2(200);
```

**Example with default:**

```sql
ALTER TABLE hr_emp_backup ADD effective_date DATE DEFAULT SYSDATE;
```

New rows will get SYSDATE in **effective_date** if no value is provided; existing rows get NULL unless you run an UPDATE. In some databases you can add a NOT NULL column only if you provide a DEFAULT (so existing rows get that default).

---

## 6. ALTER TABLE: Modifying a Column

**ALTER TABLE ... MODIFY** changes the **data type** or **size** of an existing column. The change is allowed only if existing data and constraints are compatible (e.g., you can increase VARCHAR2 size, but shrinking it may fail if any value is longer than the new size).

**Example:**

```sql
ALTER TABLE hr_emp_backup MODIFY notes VARCHAR2(400);
```

You can also add or drop NOT NULL via MODIFY (e.g., MODIFY column_name NOT NULL). Changing type (e.g., NUMBER to VARCHAR2) may require migration steps (e.g., add new column, update, drop old, rename).

---

## 7. ALTER TABLE: Dropping a Column

**ALTER TABLE ... DROP COLUMN** removes a column from the table. All data in that column is lost. Syntax:

```sql
ALTER TABLE hr_emp_backup DROP COLUMN notes;
```

Some databases support **DROP COLUMN column_name CASCADE** to drop dependent objects. In Oracle you can also mark a column as **unused** (ALTER TABLE ... SET UNUSED COLUMN) and drop it later to reduce downtime on large tables.

---

## 8. RENAME: Table and Column

**Rename a table:**

```sql
RENAME hr_emp_backup TO hr_employees_backup;
```

**Rename a column (Oracle 9i+):**

```sql
ALTER TABLE hr_emp_backup RENAME COLUMN notes TO remarks;
```

Renaming does not change data or types; it only changes identifiers. Update application code and views that reference the old name.

---

## 9. TRUNCATE vs DELETE: Critical Differences

Both **TRUNCATE** and **DELETE** can remove all rows from a table, but they behave very differently:

| Aspect | TRUNCATE | DELETE |
|--------|----------|--------|
| **Rows removed** | All rows; no WHERE clause. | Rows matching WHERE (or all if no WHERE). |
| **Structure** | Table and columns remain. | Same. |
| **Rollback** | In Oracle, DDL commits; cannot roll back. | Can be rolled back until COMMIT. |
| **Triggers** | Row triggers do not fire (Oracle). | Row triggers fire for each deleted row. |
| **Speed** | Very fast; deallocates space. | Slower; logs each row; can be rolled back. |
| **Identity/sequence** | May reset (implementation-dependent). | Does not reset. |

**When to use TRUNCATE:** When you want to empty a table quickly and do not need to roll back (e.g., staging or backup tables). **When to use DELETE:** When you need to remove only some rows (WHERE) or need transactional rollback.

**Example TRUNCATE:**

```sql
TRUNCATE TABLE hr_emp_backup;
```

**Example DELETE all rows:**

```sql
DELETE FROM hr_emp_backup;
COMMIT;
```

---

## 10. DROP TABLE

**DROP TABLE** removes the **table and all its data** from the database. The table definition and every row are deleted. This cannot be undone (unless you have a backup or the database has a recycle bin and you restore from it).

```sql
DROP TABLE hr_emp_backup;
```

In Oracle, **DROP TABLE ... PURGE** skips the recycle bin and permanently deletes the table. Use with care.

---

## 11. Naming Conventions and Best Practices

- **Table names:** Use meaningful, consistent names (e.g., `hr_emp_backup`, `hr_dept_summary`). Avoid reserved words and spaces; use underscores.
- **Column names:** Match source tables when copying (hr.employees, hr.departments) so that scripts and documentation stay clear.
- **Backups:** Use CTAS for one-off backups before risky changes. For production, use proper backup tools (RMAN, exports) as well.
- **Testing:** Create copies (e.g., hr_emp_structure with WHERE 1=0) to test DDL and DML without touching production.

---

## 12. HR Schema Table Structure (Recap)

- **hr.employees:** employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id.
- **hr.departments:** department_id, department_name, manager_id, location_id.

Understanding these structures helps when you create backup or staging tables with CREATE TABLE AS SELECT or when you design new tables that reference them (e.g., foreign keys in a later day).

---

## 13. Summary Points

- DDL defines or changes database structure; in Oracle it commits implicitly.
- CREATE TABLE defines a new table with column names and types; CTAS creates a table from a query result.
- ALTER TABLE can ADD, MODIFY, or DROP columns; RENAME changes table or column names.
- TRUNCATE removes all rows quickly and cannot be rolled back; DELETE removes rows (optionally with WHERE) and can be rolled back.
- DROP TABLE removes the table and all data. Use naming conventions and backups when working with DDL.

---

[← Day 2](./day02_filtering_sorting.md) | [Back to Learning Plan](../30-day-sql-plsql-learning-plan.md) | [Next: Day 4 →](./day04_dml_basics.md)
