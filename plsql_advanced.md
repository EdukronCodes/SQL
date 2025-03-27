## 📘 Procedures – 20 New Coding Questions

1. Write a procedure to return the highest salary from the employees table.
2. Create a procedure to insert default values if parameters are not passed.
3. Write a procedure that accepts a date and returns the day of the week.
4. Create a procedure to display all employees from a specific department.
5. Write a procedure to check whether a department exists.
6. Create a procedure that lists all tables in the current schema.
7. Write a procedure to calculate the age of an employee based on DOB.
8. Create a procedure to update department location based on department ID.
9. Write a procedure that returns a random number between 1 and 100.
10. Create a procedure to reset employee commission to 0 if null.
11. Write a procedure that finds and prints the longest employee name.
12. Create a procedure to promote all employees by a fixed salary increment.
13. Write a procedure to find the employee with the second highest salary.
14. Create a procedure to capitalize all employee first names.
15. Write a procedure that returns total number of records in any given table name.
16. Create a procedure to delete all records older than 5 years from an archive table.
17. Write a procedure to insert dummy data into a testing table.
18. Create a procedure to track failed login attempts in a log table.
19. Write a procedure that returns TRUE if an employee ID exists, otherwise FALSE.
20. Create a procedure that accepts a comma-separated string and splits it into rows.

## ⚡ Triggers – 20 New Coding Questions

1. Write a trigger to block updates to employee names after hiring.
2. Create a trigger to prevent deletion of rows from a specific table.
3. Write a trigger that logs changes to employee department history.
4. Create a BEFORE UPDATE trigger that checks salary limits.
5. Write a trigger to automatically uppercase employee last names on insert.
6. Create a trigger that logs login timestamps into an audit table.
7. Write a trigger to ensure that email addresses contain '@' symbol.
8. Create a trigger to allow only INSERT operations between 9 AM to 5 PM.
9. Write a trigger to automatically assign a department based on job title.
10. Create a trigger to prevent insertion into a table on weekends.
11. Write a trigger that validates data before update based on job role.
12. Create a trigger to store old values of updated rows in a backup table.
13. Write a trigger to prevent changing the primary key of any table.
14. Create a trigger to send a message to DBMS_OUTPUT after every insert.
15. Write a trigger that sets default values for NULL columns before insert.
16. Create a trigger that tracks the number of deletes in a session.
17. Write a trigger that rolls back a transaction if salary is reduced.
18. Create a compound trigger for performance during bulk inserts.
19. Write a trigger that restricts certain users from updating records.
20. Create a trigger that adds a timestamp when a record is updated.

## 🔁 Sequences – 20 New Coding Questions

1. Create a sequence to generate invoice numbers starting from 5000.
2. Use a sequence in a function to generate unique IDs.
3. Create a sequence with a cache size of 20 and demonstrate its usage.
4. Create a descending sequence that starts from 1000 and decrements by 5.
5. Simulate a sequence reset by dropping and recreating it.
6. Write a query to list all sequences owned by the current user.
7. Create a sequence that increments by 1 but skips even numbers.
8. Use a sequence in a trigger to populate a surrogate key.
9. Create a sequence with NOCACHE and explain its behavior.
10. Create a reusable procedure that returns a sequence's next value.
11. Combine sequence and username to create a unique identifier.
12. Create a sequence that increments based on the max ID in a table.
13. Write a block that uses a sequence to populate 100 test records.
14. Use sequence in a FORALL insert operation.
15. Dynamically create a sequence using PL/SQL block.
16. Use sequence in a merge (upsert) statement.
17. Write a trigger that logs the sequence value used in a table.
18. Generate sequence numbers with fixed length (e.g., 0001, 0002).
19. Create a sequence with MINVALUE and use it to update records.
20. Use sequence CURRVAL in a condition to prevent duplicate processing.

## ⚠️ Exception Handling – 20 New Coding Questions

1. Handle an exception when trying to open a nonexistent file using UTL_FILE.
2. Create a function that handles invalid date input and returns NULL.
3. Write a block to simulate deadlock and handle it gracefully.
4. Raise an exception if a user tries to enter a future date of birth.
5. Handle exceptions when working with nested cursors.
6. Log all exceptions into a custom error log table with timestamp.
7. Create a procedure with nested exception blocks.
8. Handle exception when fetching data from a dropped table.
9. Create a custom exception to handle empty strings in inputs.
10. Raise an exception if a string exceeds a defined character length.
11. Write a procedure that handles numeric conversion errors.
12. Use `PRAGMA EXCEPTION_INIT` to associate error codes with custom exceptions.
13. Handle exceptions during DML operations inside FORALL loop.
14. Raise a user-defined exception when a job role is invalid.
15. Implement retry logic using exception handling for failed inserts.
16. Write a procedure that records the exception and then re-raises it.
17. Handle file not found exception using UTL_FILE.
18. Simulate a constraint violation and handle the exception.
19. Catch and ignore specific exceptions but log others.
20. Create a wrapper procedure that calls another procedure and gracefully handles all exceptions.
