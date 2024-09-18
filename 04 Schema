
# Database Schema

A **schema** in a database refers to the organizational structure that defines how data is stored, organized, and managed. It includes the definition of tables, columns, data types, relationships between tables, views, indexes, and other database objects. Schemas provide a logical grouping of these objects within a database.

## Key Components of a Schema

1. **Tables**: 
   - A table is a collection of related data entries and is organized in rows and columns.
   - Each column in a table has a specific data type (e.g., INTEGER, VARCHAR).
   - Each row contains a unique record.

2. **Columns (Attributes)**: 
   - Columns define the type of data that can be stored in a table, such as `Name` (VARCHAR), `Age` (INTEGER), and `Date` (DATE).
   - Columns can have constraints like `PRIMARY KEY`, `NOT NULL`, `UNIQUE`, etc.

3. **Relationships**:
   - Schemas define how different tables are related to each other. This can be through keys like:
     - **Primary Key (PK)**: A unique identifier for each record in a table.
     - **Foreign Key (FK)**: A reference to the primary key of another table, establishing a relationship between the two.

4. **Indexes**:
   - Indexes improve the speed of data retrieval operations by creating a data structure that helps in faster searching.

5. **Views**:
   - A view is a virtual table based on the result-set of an SQL query. It provides a way to simplify complex queries.

6. **Stored Procedures**:
   - These are precompiled SQL statements that can be executed as functions, helping in repetitive tasks.

## Types of Schemas

- **Physical Schema**: Describes the actual storage of data and the physical design of the database.
- **Logical Schema**: Defines the logical design of the database, including tables, relationships, and constraints.
- **External Schema (View)**: Represents how different users view the data. Each user might have a different view of the same data.

## Example of a Simple Schema

```sql
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DepartmentID INT,
    Salary DECIMAL(10, 2)
);

CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100)
);

ALTER TABLE Employees
ADD FOREIGN KEY (DepartmentID)
REFERENCES Departments(DepartmentID);
