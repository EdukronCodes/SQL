# **PL/SQL Overview**

## **What is PL/SQL?**
PL/SQL (**Procedural Language/Structured Query Language**) is Oracle’s procedural extension for SQL. It combines the power of **SQL** with procedural programming constructs, enabling the creation of **functions, procedures, triggers, and exception handling**.

PL/SQL allows developers to:
- Execute SQL queries inside procedural blocks.
- Implement **loops, conditions, and error handling**.
- Improve **code reusability** through **functions and packages**.

---

## **Difference Between SQL and PL/SQL**
| Feature          | SQL (Structured Query Language) | PL/SQL (Procedural Language SQL) |
|-----------------|--------------------------------|--------------------------------|
| **Type**        | Declarative Language          | Procedural Language            |
| **Execution**   | Executes **one statement** at a time | Executes **multiple statements** as a block |
| **Use Case**    | Used for **data manipulation (CRUD)** | Used for **business logic and procedural programming** |
| **Control Structures** | No loops or conditions | Supports **IF, CASE, LOOP, WHILE** |
| **Error Handling** | Limited error handling | Advanced **exception handling** |
| **Performance** | Executes each query separately | Uses **block processing** for better performance |

---

## **Advantages of PL/SQL**
1. **Procedural Programming**  
   - Supports **loops, conditional statements, functions, and triggers**.
   
2. **Block Structure for Better Organization**  
   - Code is structured in **blocks** (Anonymous, Procedures, Functions, Packages).

3. **Code Reusability**  
   - Reuse PL/SQL **procedures, functions, and packages** across applications.

4. **Improved Performance**  
   - Reduces **context switching** between SQL and procedural code.

5. **Exception Handling**  
   - Provides **robust error handling** mechanisms.

6. **Security Features**  
   - Supports **access controls and privileges**.

7. **Integration with SQL**  
   - Allows embedding **SQL statements within PL/SQL blocks**.

---

## **PL/SQL Block Structure**
A PL/SQL block consists of **four main sections**:

```plsql
DECLARE  -- (Optional)
    -- Variable declarations
BEGIN   -- (Mandatory)
    -- Executable statements
EXCEPTION  -- (Optional)
    -- Error handling statements
END;
/
