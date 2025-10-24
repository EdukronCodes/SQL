-- ==========================================
-- 🔹 SECTION A: FUNCTIONS (1–35)
-- ==========================================

1. Write a function to return the square of a number.
2. Write a function to return the factorial of a number.
3. Write a function that returns the total salary of all employees.
4. Write a function that accepts an employee ID and returns the employee’s name.
5. Write a function that returns the department name for a given department ID.
6. Write a function to check whether a number is even or odd.
7. Write a function that returns the current date and time.
8. Write a function to calculate the area of a circle given the radius.
9. Write a function that returns the number of employees in a specific department.
10. Write a function to return the maximum salary from the EMP table.
11. Write a function to convert Celsius to Fahrenheit.
12. Write a function to return the commission percentage of an employee.
13. Write a function to count how many employees have a salary above 5000.
14. Write a function to find the nth Fibonacci number.
15. Write a function that accepts a string and returns it in reverse.
16. Write a function to return the length of a given string without using LENGTH().
17. Write a function to calculate compound interest.
18. Write a function that returns the employee’s yearly salary.
19. Write a function that returns the minimum salary of a department.
20. Write a function that checks whether a given year is a leap year.
21. Write a function that counts the vowels in a string.
22. Write a function that returns the greater of two numbers.
23. Write a function to return the total number of departments.
24. Write a function that returns the last hired employee name.
25. Write a function to return the employee name in uppercase.
26. Write a function that returns the grade (‘A’, ‘B’, ‘C’) based on salary.
27. Write a function to find the sum of digits of a given number.
28. Write a function that returns the square root of a number.
29. Write a function to count employees joined in a given year.
30. Write a function to return the job title of an employee ID.
31. Write a function that accepts two numbers and returns their average.
32. Write a function to check if a string is a palindrome.
33. Write a function to return the number of days between two given dates.
34. Write a function to return the email ID domain part (after ‘@’) of a string.
35. Write a function that returns “HIGH”, “MEDIUM”, or “LOW” based on salary range.


-- ==========================================
-- ⚙️ SECTION B: PROCEDURES (36–70)
-- ==========================================

36. Write a procedure to insert a new employee record.
37. Write a procedure to update an employee’s salary.
38. Write a procedure to delete an employee by ID.
39. Write a procedure that prints all employee names.
40. Write a procedure that accepts an employee ID and prints their details.
41. Write a procedure to give a 10% salary hike to all employees in a given department.
42. Write a procedure that increases salary by a percentage given as input.
43. Write a procedure to copy data from one table to another.
44. Write a procedure that deletes all employees with salary less than 3000.
45. Write a procedure to display total salary per department.
46. Write a procedure to log the count of rows in a table.
47. Write a procedure that accepts a department name and returns its ID via OUT parameter.
48. Write a procedure that truncates a specific table dynamically.
49. Write a procedure to display employees whose name starts with ‘A’.
50. Write a procedure that fetches the highest-paid employee.
51. Write a procedure that updates job title based on salary range.
52. Write a procedure to insert multiple records using a loop.
53. Write a procedure to print all department names.
54. Write a procedure to find employees without commission.
55. Write a procedure that accepts two dates and shows employees hired in between.
56. Write a procedure that transfers employees from one department to another.
57. Write a procedure that logs audit data in a separate table.
58. Write a procedure to delete duplicate employee records.
59. Write a procedure to print even numbers from 1 to 50.
60. Write a procedure that generates Fibonacci series up to N terms.
61. Write a procedure that reverses a given string.
62. Write a procedure to print all prime numbers between 1 and 100.
63. Write a procedure to calculate and print the factorial of a given number.
64. Write a procedure that accepts a table name and prints row count dynamically.
65. Write a procedure to find employees with NULL manager IDs.
66. Write a procedure to update salaries of all employees hired before 2010.
67. Write a procedure to delete rows older than 30 days from a log table.
68. Write a procedure that accepts an employee ID and displays their department and job.
69. Write a procedure that inserts today’s date and username into a log table.
70. Write a procedure that prints the number of days in the current month.

    -- ==========================================
-- 🔥 SECTION C: TRIGGERS (71–100)
-- ==========================================

71. Write a BEFORE INSERT trigger on EMP table to automatically set CREATED_DATE = SYSDATE.
72. Write an AFTER INSERT trigger to log new records into an AUDIT table.
73. Write a BEFORE UPDATE trigger to prevent salary reduction.
74. Write an AFTER DELETE trigger to record deleted rows in another table.
75. Write a BEFORE INSERT trigger to assign an employee ID from a sequence.
76. Write an AFTER UPDATE trigger to log old and new salary values.
77. Write a BEFORE DELETE trigger to prevent deletion of managers.
78. Write a trigger that prevents updates on weekends.
79. Write a trigger to set LAST_UPDATED_BY = USER on update.
80. Write a trigger to prevent insertion of duplicate email IDs.
81. Write a trigger that calculates annual salary after each salary update.
82. Write a trigger to allow inserts only during office hours (9–5).
83. Write a trigger that logs login attempts in a LOGIN_LOG table.
84. Write a trigger that sets DEFAULT department to ‘GENERAL’ if NULL.
85. Write a trigger that prevents deletion of rows from the DEPARTMENT table.
86. Write a trigger to prevent updating the primary key of EMP.
87. Write a trigger that updates audit columns (UPDATED_BY, UPDATED_ON) automatically.
88. Write a trigger that restricts inserting records if total count exceeds 1000.
89. Write a trigger that fires when a table is truncated.
90. Write a trigger to stop inserts if salary > 1,00,000.
91. Write a trigger that automatically populates full name column (first + last name).
92. Write a trigger that records the time difference between insert and update.
93. Write a trigger that prevents inserting rows with NULL email.
94. Write a trigger that copies deleted employee data into a HISTORY table.
95. Write a trigger that fires before an UPDATE on DEPT table and raises an error if dept_name changes.
96. Write a trigger to maintain a row count in another table after each insert/delete.
97. Write a trigger that prevents modification of system admin accounts.
98. Write a trigger that sets BONUS = 0 if salary < 5000.
99. Write a trigger that logs username and date whenever salary is modified.
100. Write a trigger that disables inserts into EMP table on Sundays.


