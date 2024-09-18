
# Common SQL Operators

## 1. Arithmetic Operators
- `+` : Adds two values
- `-` : Subtracts one value from another
- `*` : Multiplies two values
- `/` : Divides one value by another
- `%` : Modulus operator, returns the remainder of a division

## 2. Comparison Operators
- `=` : Equal to
- `<>` or `!=` : Not equal to
- `>` : Greater than
- `<` : Less than
- `>=` : Greater than or equal to
- `<=` : Less than or equal to
- `BETWEEN` : Checks if a value is within a range
- `IN` : Checks if a value exists within a list of values
- `LIKE` : Pattern matching with wildcards (`%` and `_`)
- `IS NULL` : Checks if a value is `NULL`

## 3. Logical Operators
- `AND` : Combines two conditions, both must be true
- `OR` : Combines two conditions, at least one must be true
- `NOT` : Negates a condition, returns true if the condition is false

## 4. String Operators
- `||` : Concatenates two strings (in some SQL databases, `CONCAT()` function may be used)

## 5. Set Operators
- `UNION` : Combines the result sets of two or more `SELECT` queries, removing duplicates
- `UNION ALL` : Combines result sets of two or more `SELECT` queries, without removing duplicates
- `INTERSECT` : Returns only the rows common to the result sets of two `SELECT` queries
- `EXCEPT` or `MINUS` : Returns rows from the first `SELECT` query that are not present in the second query

## 6. Other Operators
- `EXISTS` : Returns true if the subquery returns any rows
- `ANY` : Compares a value to any value in a list or subquery
- `ALL` : Compares a value to all values in a list or subquery
