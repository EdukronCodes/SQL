
-- =========================
-- 1. DROP TABLES (Oracle Style)
-- =========================
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Employees';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Departments';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

-- =========================
-- 2. CREATE TABLES
-- =========================
CREATE TABLE Departments (
    dept_id NUMBER,
    dept_name VARCHAR2(50)
);

CREATE TABLE Employees (
    emp_id NUMBER,
    name VARCHAR2(50),
    dept_id NUMBER
);

-- =========================
-- 3. INSERT DATA
-- =========================
INSERT INTO Departments VALUES (10, 'HR');
INSERT INTO Departments VALUES (20, 'IT');
INSERT INTO Departments VALUES (20, 'Tech Support'); -- duplicate mapping
INSERT INTO Departments VALUES (30, NULL);           -- NULL value
INSERT INTO Departments VALUES (40, 'Finance');

INSERT INTO Employees VALUES (1, 'Alice', 10);
INSERT INTO Employees VALUES (2, 'Bob', 20);
INSERT INTO Employees VALUES (3, 'Carol', 20);
INSERT INTO Employees VALUES (4, 'David', 30);
INSERT INTO Employees VALUES (5, 'Eve', NULL);       -- NULL dept_id
INSERT INTO Employees VALUES (6, 'Frank', 50);       -- no matching dept

COMMIT;

-- =========================
-- 4. INNER JOIN
-- =========================
SELECT 'INNER JOIN' AS join_type, e.emp_id, e.name, e.dept_id, d.dept_name
FROM Employees e
INNER JOIN Departments d
ON e.dept_id = d.dept_id;

-- =========================
-- 5. LEFT OUTER JOIN
-- =========================
SELECT 'LEFT JOIN' AS join_type, e.emp_id, e.name, e.dept_id, d.dept_name
FROM Employees e
LEFT OUTER JOIN Departments d
ON e.dept_id = d.dept_id;

-- =========================
-- 6. RIGHT OUTER JOIN
-- =========================
SELECT 'RIGHT JOIN' AS join_type, e.emp_id, e.name, e.dept_id, d.dept_name
FROM Employees e
RIGHT OUTER JOIN Departments d
ON e.dept_id = d.dept_id;

-- =========================
-- 7. FULL OUTER JOIN
-- =========================
SELECT 'FULL JOIN' AS join_type, e.emp_id, e.name, e.dept_id, d.dept_name
FROM Employees e
FULL OUTER JOIN Departments d
ON e.dept_id = d.dept_id;

-- =========================
-- 8. CROSS JOIN
-- =========================
SELECT 'CROSS JOIN' AS join_type, e.name, d.dept_name
FROM Employees e
CROSS JOIN Departments d;

-- =========================
-- 9. SELF JOIN
-- =========================
SELECT 'SELF JOIN' AS join_type,
       A.name AS Emp1,
       B.name AS Emp2,
       A.dept_id
FROM Employees A
JOIN Employees B
ON A.dept_id = B.dept_id
AND A.emp_id <> B.emp_id;

-- =========================
-- 10. OLD ORACLE JOIN SYNTAX
-- =========================

-- LEFT JOIN using (+)
SELECT 'OLD LEFT JOIN' AS join_type, e.emp_id, e.name, d.dept_name
FROM Employees e, Departments d
WHERE e.dept_id = d.dept_id(+);

-- RIGHT JOIN using (+)
SELECT 'OLD RIGHT JOIN' AS join_type, e.emp_id, e.name, d.dept_name
FROM Employees e, Departments d
WHERE e.dept_id(+) = d.dept_id;
