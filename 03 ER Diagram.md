# ER (Entity-Relationship) Diagram

An **ER Diagram** is a visual representation of the entities and relationships in a database. It helps in designing the database structure based on real-world objects (entities) and the relationships between them.

## Key Components of an ER Diagram
- **Entity**: An object or thing in the real world that can be distinctly identified (e.g., `Customer`, `Product`).
- **Attributes**: The properties or details of an entity (e.g., `CustomerName`, `ProductPrice`).
- **Primary Key**: A unique identifier for each entity (e.g., `CustomerID` for a `Customer` entity).
- **Relationships**: How entities are related to each other (e.g., a `Customer` *purchases* a `Product`).

---

## Example: ER Diagram for an Online Shopping System

Let’s consider a simple example of an ER diagram for an online shopping system, which includes three entities: **Customer**, **Order**, and **Product**.

### 1. **Entities**:
- **Customer**: Has attributes like `CustomerID`, `CustomerName`, `CustomerEmail`.
- **Order**: Has attributes like `OrderID`, `OrderDate`.
- **Product**: Has attributes like `ProductID`, `ProductName`, `ProductPrice`.

### 2. **Relationships**:
- **Customer places Order**: A customer can place many orders, but each order is placed by one customer (1-to-many relationship).
- **Order contains Product**: An order can contain many products, and a product can be part of many orders (many-to-many relationship).

---

### ER Diagram Notation in Text Form:

```plaintext
Entities:
----------
Customer(CustomerID, CustomerName, CustomerEmail)
Order(OrderID, OrderDate, CustomerID)
Product(ProductID, ProductName, ProductPrice)

Relationships:
--------------
Customer 1---places---N Order
Order N---contains---M Product
[Customer]
CustomerID (PK)
CustomerName
CustomerEmail

      |
      |  places
      |
      1 ---< N

[Order]
OrderID (PK)
OrderDate
CustomerID (FK)

      |
      |  contains
      |
      N ---< M

[Product]
ProductID (PK)
ProductName
ProductPrice
