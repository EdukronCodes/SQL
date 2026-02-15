# Day 28 Assignment: Security

Assume you have privileges to create roles and grant on **hr.employees** and **hr.departments** (or describe the commands as the schema owner).

---

## Part 1: Practice Questions (With Answers and Explanations)

### Question 1
Write the SQL to **grant SELECT** on **hr.employees** to a **role** named **hr_reader** (first create the role if needed). Then grant that role to a user (use a placeholder user name if you cannot run it).

**Answer:**

```sql
CREATE ROLE hr_reader;
GRANT SELECT ON hr.employees TO hr_reader;
GRANT SELECT ON hr.departments TO hr_reader;
GRANT hr_reader TO some_user;   -- replace some_user with actual username
```

**Explanation:** The role groups object privileges. Users granted hr_reader can query the HR tables. Use principle of least privilege: only SELECT, not INSERT/UPDATE/DELETE.

---

### Question 2
Create a **procedure** that selects from hr.employees and returns data (e.g. employee count by department). Create it with **definer rights** (default). Explain: when a user calls this procedure, whose privileges are used to access hr.employees?

**Answer:** The procedure is created with **AUTHID DEFINER** (default). When any user **calls** the procedure, it runs with the **owner's** privileges. So the caller does not need direct SELECT on hr.employees; the procedure owner must have that privilege. This allows controlled access: users can only get data through the procedure, not by querying the table directly.

---

### Question 3
Write **safe dynamic SQL** that selects **first_name** from hr.employees where **employee_id = :id**. Use a **bind variable** (EXECUTE IMMEDIATE ... USING) so the value of id is not concatenated into the string. Show the PL/SQL block.

**Answer:**

```sql
DECLARE
  v_id   NUMBER := 100;
  v_name VARCHAR2(50);
BEGIN
  EXECUTE IMMEDIATE 'SELECT first_name FROM hr.employees WHERE employee_id = :1' INTO v_name USING v_id;
  DBMS_OUTPUT.PUT_LINE(v_name);
END;
/
```

**Explanation:** The placeholder :1 in the string is bound with USING v_id. The value is never concatenated, so it cannot change the query structure (prevents SQL injection). Use USING for all user or application inputs.

---

## Part 2: Self-Practice (No Answers)

1. Write **REVOKE** statements to remove SELECT on hr.employees from **hr_reader**, then **re-grant** it.
2. Create a **view** on hr.employees that **excludes** the **salary** column (and other sensitive columns). Grant SELECT on the view to a role so users can see employee data but not salary.

---

## Part 3: Additional Practice — 20 Medium + 20 Hard Questions (With Hints)

Assume you can create roles and grant on **hr.employees** and **hr.departments** (or describe commands as schema owner).

### 20 Medium Questions

1. **M1.** GRANT SELECT ON hr.employees TO user_or_role. **Hint:** GRANT SELECT ON hr.employees TO report_user;
2. **M2.** CREATE ROLE hr_reader; GRANT SELECT ON hr.employees TO hr_reader; GRANT hr_reader TO app_user. **Hint:** Role groups privileges.
3. **M3.** REVOKE SELECT ON hr.employees FROM hr_reader. **Hint:** REVOKE removes privilege from role (or user).
4. **M4.** Safe dynamic SQL: EXECUTE IMMEDIATE 'SELECT first_name FROM hr.employees WHERE employee_id = :1' INTO v USING p_id. **Hint:** :1 bound with USING p_id; no concatenation.
5. **M5.** Procedure with definer rights (default): who can access hr.employees when caller runs it? **Hint:** Owner's privileges; caller does not need SELECT on table.
6. **M6.** Create procedure with AUTHID CURRENT_USER. **Hint:** CREATE OR REPLACE PROCEDURE ... AUTHID CURRENT_USER IS ...
7. **M7.** View that selects employee_id, first_name, last_name, department_id (no salary). **Hint:** CREATE VIEW v_emp_public AS SELECT employee_id, first_name, last_name, department_id FROM hr.employees;
8. **M8.** GRANT SELECT ON view_name TO role. **Hint:** GRANT SELECT ON v_emp_public TO hr_reader;
9. **M9.** GRANT EXECUTE ON procedure_name TO user. **Hint:** GRANT EXECUTE ON list_employees TO app_user;
10. **M10.** Why concatenating user input into SQL is dangerous. **Hint:** SQL injection; attacker can change query structure.
11. **M11.** REVOKE hr_reader FROM app_user. **Hint:** REVOKE role FROM user.
12. **M12.** Grant INSERT and UPDATE on one table to a role. **Hint:** GRANT INSERT, UPDATE ON hr.employees TO hr_writer; (use backup in practice)
13. **M13.** Principle of least privilege: grant only SELECT for report user. **Hint:** Do not grant INSERT/UPDATE/DELETE or system privileges.
14. **M14.** Use :1, :2 in EXECUTE IMMEDIATE and USING v1, v2. **Hint:** EXECUTE IMMEDIATE '... WHERE id = :1 AND dept = :2' INTO v USING v1, v2;
15. **M15.** Procedure that returns employee count; caller has EXECUTE but not SELECT on hr.employees. **Hint:** Definer rights; procedure owner has SELECT.
16. **M16.** Create role hr_dept50; grant SELECT only for rows where department_id = 50 (use view). **Hint:** CREATE VIEW v_emp_50 AS SELECT * FROM hr.employees WHERE department_id = 50; GRANT SELECT ON v_emp_50 TO hr_dept50;
17. **M17.** GRANT SELECT ON hr.departments TO hr_reader. **Hint:** Same role for both tables.
18. **M18.** Document: "This procedure runs with definer rights." **Hint:** Comment in header so callers know access model.
19. **M19.** Revoke EXECUTE on procedure. **Hint:** REVOKE EXECUTE ON proc_name FROM user_or_role;
20. **M20.** Safe string for LIKE: bind the pattern. **Hint:** EXECUTE IMMEDIATE 'SELECT ... WHERE last_name LIKE :1' INTO v USING p_pattern;

### 20 Hard Questions

1. **H1.** View with CHECK OPTION so user can only insert/update rows they can "see" (e.g. department_id = 50). **Hint:** CREATE VIEW v AS SELECT * FROM hr.employees WHERE department_id = 50 WITH CHECK OPTION;
2. **H2.** Procedure that takes employee_id and returns first_name; use bind in dynamic SQL. **Hint:** EXECUTE IMMEDIATE 'SELECT first_name FROM hr.employees WHERE employee_id = :1' INTO v_name USING p_emp_id;
3. **H3.** Invoker rights procedure: it queries hr.employees. What privileges does caller need? **Hint:** Caller needs SELECT on hr.employees (in their context, or table visible to them).
4. **H4.** Create view that joins employees and departments but excludes salary and commission_pct. **Hint:** SELECT e.employee_id, e.first_name, e.last_name, e.department_id, d.department_name FROM hr.employees e JOIN hr.departments d ON e.department_id = d.department_id;
5. **H5.** Grant SELECT on multiple tables in one role; then grant role to two users. **Hint:** GRANT SELECT ON t1 TO r; GRANT SELECT ON t2 TO r; GRANT r TO u1, u2;
6. **H6.** Dynamic ORDER BY: safe way to allow user to choose column (whitelist). **Hint:** IF p_order IN ('last_name','hire_date') THEN l_sql := '... ORDER BY ' || p_order; ELSE RAISE_APPLICATION_ERROR(...); END IF; still bind other params.
7. **H7.** Audit: who has SELECT on hr.employees? **Hint:** Query DBA_TAB_PRIVS or USER_TAB_PRIVS for table and privilege.
8. **H8.** Procedure with definer rights that updates salary; caller has EXECUTE only. **Hint:** Caller can change salary through procedure but cannot UPDATE table directly.
9. **H9.** SQL injection example (unsafe): p_id := '100 OR 1=1'. Show safe version with bind. **Hint:** Unsafe: '... WHERE employee_id = ' || p_id returns all rows; safe: USING p_id.
10. **H10.** Role that can only execute specific procedures (no direct table access). **Hint:** GRANT EXECUTE ON proc1, proc2 TO role; do not GRANT SELECT on tables to role.
11. **H11.** View that shows department_name and employee count (no salary); grant SELECT to role. **Hint:** CREATE VIEW v_dept_summary AS SELECT d.department_name, COUNT(e.employee_id) cnt FROM hr.departments d LEFT JOIN hr.employees e ON e.department_id = d.department_id GROUP BY d.department_id, d.department_name;
12. **H12.** Definer rights procedure that calls another definer-rights procedure. **Hint:** Both run as owner; first procedure must have EXECUTE on second.
13. **H13.** Pass table name to procedure (dynamic): use whitelist to avoid injection. **Hint:** IF p_table IN ('EMPLOYEES','DEPARTMENTS') THEN l_sql := 'SELECT COUNT(*) FROM hr.' || p_table; EXECUTE IMMEDIATE l_sql INTO v; END IF;
14. **H14.** REVOKE SELECT ON hr.employees FROM hr_reader; then re-grant. **Hint:** REVOKE ... FROM hr_reader; GRANT SELECT ON hr.employees TO hr_reader;
15. **H15.** Create user (if allowed); grant only connect and role hr_reader. **Hint:** CREATE USER u IDENTIFIED BY ...; GRANT CONNECT TO u; GRANT hr_reader TO u;
16. **H16.** Procedure that returns REF CURSOR; grant EXECUTE. Caller gets data without seeing table. **Hint:** OPEN p_rc FOR SELECT employee_id, first_name FROM hr.employees; caller has EXECUTE only.
17. **H17.** Sensitive column (salary): grant SELECT on view without salary; keep procedure that returns salary for authorized users. **Hint:** Two interfaces: view (no salary), procedure (with salary, restricted by role/user).
18. **H18.** Use DBMS_ASSERT to validate identifier (e.g. table name) in dynamic SQL. **Hint:** l_table := DBMS_ASSERT.SQL_OBJECT_NAME(p_table); then use in EXECUTE IMMEDIATE (for object names).
19. **H19.** Document invoker vs definer for a procedure. **Hint:** "Runs with owner privileges (definer). Caller needs only EXECUTE."
20. **H20.** List all privileges granted to role hr_reader. **Hint:** SELECT * FROM DBA_ROLE_PRIVS WHERE granted_role = 'HR_READER'; and role_tab_privs or role_tab_grantees.

---

[← Back to Learning Plan](../30-day-sql-plsql-learning-plan.md) | [Tutorial](../tutorials/day28_security.md)
