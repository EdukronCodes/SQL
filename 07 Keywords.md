
# SQL Keywords Table

| **Keyword**    | **Description**                                                                 |
|----------------|---------------------------------------------------------------------------------|
| `SELECT`       | Retrieves data from one or more tables.                                          |
| `FROM`         | Specifies the table to retrieve data from.                                       |
| `WHERE`        | Filters records that meet specific conditions.                                   |
| `ORDER BY`     | Sorts the result set by one or more columns.                                     |
| `GROUP BY`     | Groups rows sharing a property so that an aggregate function can be applied.     |
| `HAVING`       | Filters groups based on aggregate conditions, used with `GROUP BY`.              |
| `INSERT INTO`  | Adds new rows of data into a table.                                              |
| `VALUES`       | Specifies the values to insert into a table.                                     |
| `UPDATE`       | Modifies existing data within a table.                                           |
| `SET`          | Specifies the column to modify when updating a table.                            |
| `DELETE`       | Removes rows from a table.                                                       |
| `JOIN`         | Combines rows from two or more tables based on a related column.                 |
| `INNER JOIN`   | Returns rows that have matching values in both tables.                           |
| `LEFT JOIN`    | Returns all rows from the left table and matching rows from the right table.      |
| `RIGHT JOIN`   | Returns all rows from the right table and matching rows from the left table.      |
| `FULL OUTER JOIN` | Returns all rows when there is a match in either left or right table.         |
| `UNION`        | Combines the result sets of two or more `SELECT` statements (removes duplicates).|
| `UNION ALL`    | Combines the result sets of two or more `SELECT` statements (includes duplicates).|
| `LIMIT`        | Limits the number of rows returned by the query.                                 |
| `DISTINCT`     | Removes duplicate rows from the result set.                                      |
| `LIKE`         | Performs pattern matching using wildcards (`%` and `_`).                         |
| `IN`           | Specifies multiple possible values for a column.                                 |
| `BETWEEN`      | Filters the result set within a certain range (inclusive).                       |
| `IS NULL`      | Checks if a column contains `NULL` values.                                       |
| `EXISTS`       | Checks whether a subquery returns any rows.                                      |
| `NOT`          | Negates a condition.                                                             |
| `AND`          | Combines multiple conditions, all must be true.                                  |
| `OR`           | Combines multiple conditions, at least one must be true.                         |
| `AS`           | Renames a column or table with an alias.                                         |
| `COUNT`        | Returns the number of rows that match a condition.                               |
| `SUM`          | Returns the total sum of a numeric column.                                       |
| `AVG`          | Returns the average value of a numeric column.                                   |
| `MAX`          | Returns the maximum value of a column.                                           |
| `MIN`          | Returns the minimum value of a column.                                           |
| `CREATE TABLE` | Creates a new table in the database.                                             |
| `DROP TABLE`   | Deletes a table from the database.                                               |
| `ALTER TABLE`  | Modifies an existing table structure (add, delete, or modify columns).           |
| `PRIMARY KEY`  | Uniquely identifies each record in a table.                                      |
| `FOREIGN KEY`  | Links one table to another based on a common column.                             |
| `AUTO_INCREMENT` | Automatically generates a unique number for a column.                          |
| `DEFAULT`      | Specifies a default value for a column when no value is provided.                |
| `CHECK`        | Ensures that a column's value satisfies a specific condition.                    |
| `INDEX`        | Improves the speed of data retrieval on a table.                                 |
