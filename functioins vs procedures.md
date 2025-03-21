
# Functions vs Procedures in Oracle PL/SQL

| Feature                    | Function                                    | Procedure                                     |
|---------------------------|---------------------------------------------|-----------------------------------------------|
| Purpose                   | Used to return a single value               | Used to perform an action (may or may not return a value) |
| Return Type               | Must return a value using RETURN statement  | Does not need to return a value               |
| Invocation in SQL         | Can be called from SELECT, WHERE, etc.      | Cannot be called directly from SQL statements |
| Parameters                | Accept IN parameters                        | Accept IN, OUT, IN OUT parameters             |
| Usage                     | Typically used for computations             | Typically used for executing logic blocks     |
| Call Syntax               | `SELECT function_name(args) FROM DUAL;`     | `EXEC procedure_name(args);`                  |
| Exception Handling        | Supported                                   | Supported                                     |
| Compilation               | Stored in the database                      | Stored in the database                        |

## ✅ Example: Function
```plsql
CREATE OR REPLACE FUNCTION get_square(n NUMBER)
RETURN NUMBER
IS
BEGIN
   RETURN n * n;
END;
