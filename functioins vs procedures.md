# 🔍 Functions vs Procedures in Oracle PL/SQL

PL/SQL provides two main types of program units: **Functions** and **Procedures**. They allow you to encapsulate logic in reusable blocks.

---

## ✅ Key Differences Between Functions and Procedures

| Feature                        | Function                                               | Procedure                                                |
|-------------------------------|--------------------------------------------------------|-----------------------------------------------------------|
| **Purpose**                   | Perform a computation and return a value              | Perform one or more actions (logic)                      |
| **Return Type**               | Must return a value (using RETURN)                    | Does not return a value explicitly                       |
| **Use in SQL**                | Can be used in SQL (e.g., SELECT, WHERE)              | Cannot be used in SQL statements directly                |
| **Parameter Modes**           | Only IN parameters                                    | Supports IN, OUT, IN OUT                                 |
| **Return Statement**          | Mandatory                                              | Optional                                                  |
| **Invocation**                | Can be called from SQL or PL/SQL                      | Called from PL/SQL only                                  |
| **Best Use Case**             | When a value needs to be returned                     | When performing tasks such as DML operations             |
| **Exception Handling**        | Supported                                              | Supported                                                 |
| **Compilation**               | Compiled and stored in database                        | Compiled and stored in database                           |
| **Call in PL/SQL**            | `var := function_name(args);`                        | `procedure_name(args);`                                  |
| **Transaction Control**       | Cannot contain COMMIT/ROLLBACK in SQL context         | Can include COMMIT/ROLLBACK                              |

---

## 📘 Syntax of a Function

```plsql
CREATE OR REPLACE FUNCTION function_name (
    param1 IN datatype,
    param2 IN datatype
)
RETURN return_datatype
IS
   -- Variable declarations
BEGIN
   -- Function logic
   RETURN some_value;
EXCEPTION
   WHEN others THEN
      -- Exception handling
      RETURN default_value;
END;
```

---

### ✅ Example: Function to Return Square of a Number

```plsql
CREATE OR REPLACE FUNCTION get_square(n IN NUMBER)
RETURN NUMBER
IS
BEGIN
   RETURN n * n;
END;
```

📌 **Usage in SQL:**
```sql
SELECT get_square(5) FROM dual;
```

📌 **Usage in PL/SQL Block:**
```plsql
DECLARE
   result NUMBER;
BEGIN
   result := get_square(10);
   DBMS_OUTPUT.PUT_LINE('Square: ' || result);
END;
```

---

## 📕 Syntax of a Procedure

```plsql
CREATE OR REPLACE PROCEDURE procedure_name (
    param1 IN datatype,
    param2 OUT datatype,
    param3 IN OUT datatype
)
IS
   -- Variable declarations
BEGIN
   -- Procedure logic
EXCEPTION
   WHEN others THEN
      -- Exception handling
END;
```

---

### ✅ Example: Procedure to Greet a User

```plsql
CREATE OR REPLACE PROCEDURE greet_user(name IN VARCHAR2)
IS
BEGIN
   DBMS_OUTPUT.PUT_LINE('Hello, ' || name || '!');
END;
```

📌 **Usage:**
```plsql
BEGIN
   greet_user('Mamatha');
END;
```

---

## 📦 Example with OUT Parameter in Procedure

```plsql
CREATE OR REPLACE PROCEDURE get_sum (
    a IN NUMBER,
    b IN NUMBER,
    result OUT NUMBER
)
IS
BEGIN
   result := a + b;
END;
```

📌 **Usage:**
```plsql
DECLARE
   res NUMBER;
BEGIN
   get_sum(5, 10, res);
   DBMS_OUTPUT.PUT_LINE('Sum: ' || res);
END;
```

---

## 🧠 Use Case Guidelines

| Scenario                                         | Use Function         | Use Procedure           |
|--------------------------------------------------|----------------------|--------------------------|
| You need a return value in a SQL query           | ✅ Yes                | ❌ No                    |
| You want to update a table or commit a transaction | ❌ Not recommended   | ✅ Yes                   |
| Reusability for computation                     | ✅ Yes                | ✅ Yes                   |
| Call within another PL/SQL block                | ✅ Yes                | ✅ Yes                   |
| Complex processing with multiple outputs        | ❌ Difficult          | ✅ Suitable              |

---

## 🚫 SQL Usage Restrictions

- You **can call** functions in:
  - `SELECT`
  - `WHERE`
  - `ORDER BY`
  - `SET` clauses

- You **cannot call** procedures directly in SQL queries. They must be invoked in PL/SQL blocks.

---

## ✅ Summary

- Use **Functions** when you want to compute and return a single value.
- Use **Procedures** when you want to perform actions, possibly with multiple OUT results, or DML operations.
