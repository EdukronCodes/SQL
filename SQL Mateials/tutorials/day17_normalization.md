# Day 17: Normalization — Full Notes and Theory

---

## 1. What Normalization Is and Why It Matters

**Normalization** is the process of organizing data into tables to reduce **redundancy** and **update anomalies**. By splitting data so that each fact is stored once (e.g., department name only in hr.departments), you avoid inconsistent updates and save space. The **HR schema** (hr.employees, hr.departments) is a normalized example: employees reference departments by department_id; department names and other department attributes live only in hr.departments.

- **1NF:** Atomic column values; each row unique (e.g., by primary key); no repeating groups.
- **2NF:** 1NF plus every non-key attribute depends on the **whole** primary key (no partial dependency when the key is composite).
- **3NF:** 2NF plus no **transitive** dependency: non-key attributes depend only on the primary key, not on other non-key attributes.

---

## 2. Redundancy in Employee/Department Data

If you stored **department_name** in hr.employees for every employee, the same name would be repeated many times. Changing a department name would require updating many rows and could lead to inconsistency. The normalized design stores **department_id** in employees and **department_name** only in hr.departments, so the name is updated in one place.

---

## 3. Splitting Tables and Dependency Rules

Normalization often means **splitting** one table into several: e.g., **employees** (employee_id, first_name, last_name, department_id, ...) and **departments** (department_id, department_name, manager_id, location_id). **Functional dependency:** A → B means each value of A determines one value of B (e.g., department_id → department_name). **Partial dependency:** A non-key attribute depends on only part of a composite key (violates 2NF). **Transitive dependency:** A → B and B → C; if B is non-key, storing C in the same table as A can violate 3NF.

---

## 4. Denormalization Trade-offs

**Denormalization** (e.g., storing department_name in employees for reporting) can improve **read** performance but increases redundancy and **update** cost. Use when read-heavy reporting justifies it and you manage updates carefully (e.g., triggers or application logic to keep denormalized columns in sync).

---

## 5. HR Schema as Normalized Example

- **hr.employees** holds employee data and references department via **department_id** (FK to hr.departments).
- **hr.departments** holds department data once.
- **hr.jobs** (if present) holds job_id and job title, referenced by employees. This avoids repeating department and job information in every employee row and follows 3NF for the main entities.

---

## 6. Summary Points

- **1NF, 2NF, 3NF** reduce redundancy and anomalies by storing each fact once and avoiding partial/transitive dependencies.
- **HR schema** is a practical normalized design. **Denormalization** trades off redundancy for read performance when needed.

---

[← Day 16](./day16_constraints.md) | [Back to Learning Plan](../30-day-sql-plsql-learning-plan.md) | [Next: Day 18 →](./day18_indexes.md)
