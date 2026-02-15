# Day 17 Assignment: Normalization

All exercises refer to **hr.employees** and **hr.departments**.

---

## Part 1: Practice Questions (With Answers and Explanations)

### Question 1
Identify **functional dependencies** in **hr.employees**. For example: employee_id determines first_name, last_name, salary, department_id, etc. List at least three (e.g. employee_id -> first_name; employee_id -> department_id; department_id -> ?). Note: department_name is not in employees; it is in departments.

**Answer (conceptual):**

- employee_id -> first_name, last_name, email, hire_date, job_id, salary, commission_pct, manager_id, department_id (employee_id is the key).
- department_id (in employees) -> determines department_name only via the departments table (so in a combined table, department_id -> department_name would be a dependency).
- job_id -> could determine job title in a separate jobs table.

**Explanation:** A functional dependency A -> B means each value of A has exactly one value of B. The primary key (employee_id) determines all other attributes in the same table. department_id in employees does not hold department_name; that is in departments to avoid redundancy (3NF).

---

### Question 2
Suppose you had a single **denormalized** table with columns: employee_id, first_name, last_name, department_id, department_name, salary. Suggest a **3NF decomposition** (split into two tables and list their columns).

**Answer:**

- **Table 1 (employees):** employee_id (PK), first_name, last_name, department_id (FK), salary.
- **Table 2 (departments):** department_id (PK), department_name.

**Explanation:** department_name depends only on department_id, so it is moved to a departments table. The employees table keeps department_id as a foreign key. This removes the transitive dependency and redundancy.

---

### Question 3
Explain why **department_name** is stored in **hr.departments** and not repeated in **hr.employees**.

**Answer:** Storing department_name only in hr.departments avoids redundancy (same name repeated for every employee in that department), reduces update anomalies (change the name in one place), and follows 3NF: department_name depends on department_id, not on employee_id. Employees table only holds the key (department_id) and references departments for the name.

---

## Part 2: Self-Practice (No Answers)

1. Draw a simple **dependency diagram** for hr.employees: show employee_id as the key and arrows to other attributes. Indicate which attribute(s) depend on department_id (via reference to another table).
2. Justify why **job_id** is stored in hr.employees (and job title possibly in a separate jobs table) from a normalization perspective.

---

## Part 3: Additional Practice — 20 Medium + 20 Hard Questions (With Hints)

Conceptual/theory; refer to **hr.employees** and **hr.departments**.

### 20 Medium Questions

1. **M1.** What does 1NF require? **Hint:** Atomic values; unique rows; no repeating groups.
2. **M2.** Why is department_name not in hr.employees? **Hint:** Avoid redundancy; 3NF; department_id → department_name.
3. **M3.** Give an example of functional dependency in hr.employees. **Hint:** employee_id → first_name; department_id → (in departments) department_name.
4. **M4.** What is partial dependency? **Hint:** Non-key attribute depends on only part of composite key.
5. **M5.** What is transitive dependency? **Hint:** A → B, B → C; non-key B determines C.
6. **M6.** How does HR schema achieve 3NF for employees and departments? **Hint:** Employees have department_id; department facts in one table.
7. **M7.** What would break 1NF in an employee table? **Hint:** Repeating groups (e.g. multiple phone numbers in one column).
8. **M8.** Why store job_id in employees instead of job title? **Hint:** Job title depends on job_id; keep in jobs table for 3NF.
9. **M9.** What does 2NF require beyond 1NF? **Hint:** No partial dependency on composite key.
10. **M10.** Give an example of denormalization. **Hint:** Storing department_name in employees for faster reports.
11. **M11.** What is the primary key of hr.employees? **Hint:** employee_id.
12. **M12.** What is the primary key of hr.departments? **Hint:** department_id.
13. **M13.** Why is manager_id in employees not a violation of 3NF? **Hint:** It references another row (FK); not storing manager's name redundantly.
14. **M14.** If we added department_name to hr.employees, what anomaly could occur? **Hint:** Update anomaly; inconsistency if name changes.
15. **M15.** What does "atomic" mean in 1NF? **Hint:** Single value per cell; no multi-valued or composite values in one column.
16. **M16.** How does splitting into employees and departments reduce redundancy? **Hint:** Department name stored once per department.
17. **M17.** When might you denormalize? **Hint:** Read-heavy reporting; acceptable redundancy and update strategy.
18. **M18.** What dependency does department_id → department_name represent? **Hint:** Functional dependency (in departments table).
19. **M19.** Why not store employee names in departments? **Hint:** One department has many employees; would need repeating group or multiple columns.
20. **M20.** What is the benefit of 3NF? **Hint:** No transitive dependency; each non-key attribute depends only on the key.

### 20 Hard Questions

1. **H1.** Decompose a table with columns (emp_id, emp_name, dept_id, dept_name) into 3NF. **Hint:** employees(emp_id, emp_name, dept_id); departments(dept_id, dept_name).
2. **H2.** Explain why (employee_id, project_id, hours, project_name) might violate 3NF. **Hint:** project_name depends on project_id; transitive dependency.
3. **H3.** Design a normalized schema for employees, departments, and locations (employees in departments, departments in locations). **Hint:** employees(dept_id FK), departments(dept_id, location_id FK), locations(location_id, ...).
4. **H4.** When would 2NF matter? **Hint:** When the primary key is composite (e.g. (emp_id, project_id)) and an attribute depends only on project_id.
5. **H5.** Give an example of update anomaly if department_name were in hr.employees. **Hint:** Changing a department name requires updating many rows; risk of inconsistency.
6. **H6.** What is BCNF? (Brief) **Hint:** Every determinant is a candidate key; stronger than 3NF.
7. **H7.** Why might a reporting table be denormalized? **Hint:** Fewer joins; faster reads; reporting warehouse.
8. **H8.** Identify functional dependencies in hr.departments. **Hint:** department_id → department_name, manager_id, location_id.
9. **H9.** If we had (employee_id, skill_id, skill_name), is skill_name in 3NF? **Hint:** skill_name depends on skill_id; if skill_id is non-key, transitive dependency; split to skills(skill_id, skill_name).
10. **H10.** How does HR schema avoid insertion anomaly for departments? **Hint:** Can insert department with no employees; employees reference department_id.
11. **H11.** What is deletion anomaly? **Hint:** Deleting last employee in a department might remove department info if stored in same table.
12. **H12.** Suggest 3NF tables for (order_id, customer_id, customer_name, product_id, product_name, qty). **Hint:** orders(order_id, customer_id, ...); customers(customer_id, customer_name); products(product_id, product_name); order_items(order_id, product_id, qty).
13. **H13.** Why is manager_id in hr.employees acceptable? **Hint:** FK to employees; not storing manager name; reference only.
14. **H14.** What is multivalued dependency (4NF)? **Hint:** Two independent multi-valued attributes; split to separate tables.
15. **H15.** Trade-off: normalized vs denormalized reporting table. **Hint:** Normalized: no redundancy, more joins. Denormalized: redundancy, faster reads, update cost.
16. **H16.** In hr.employees, which attributes depend only on employee_id? **Hint:** first_name, last_name, email, hire_date, job_id, salary, commission_pct, manager_id, department_id (all depend on employee_id).
17. **H17.** If job_title were in hr.employees, what dependency would that create? **Hint:** job_id → job_title; transitive if job_id is non-key.
18. **H18.** How do you fix a table that violates 2NF? **Hint:** Remove attributes that depend on only part of the key; put them in a table with that key part.
19. **H19.** Why might a data warehouse use denormalized star schema? **Hint:** Optimized for reads and analytics; dimension and fact tables; redundancy acceptable.
20. **H20.** Draw dependency diagram for hr.departments (department_id as key). **Hint:** department_id → department_name, manager_id, location_id.

---

[← Back to Learning Plan](../30-day-sql-plsql-learning-plan.md) | [Tutorial](../tutorials/day17_normalization.md)
