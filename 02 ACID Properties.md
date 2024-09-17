
# ACID Properties in Databases

The **ACID** properties ensure reliable processing of database transactions. The acronym stands for **Atomicity**, **Consistency**, **Isolation**, and **Durability**. Each property ensures that database transactions are processed reliably and correctly.

## 1. Atomicity
- **Definition**: The transaction is treated as a single unit, which either **completes entirely** or **does not happen at all**. If any part of the transaction fails, the entire transaction fails, and the database state is left unchanged.
- **Example**: Consider a bank transfer of $100 from Account A to Account B.
  - If $100 is debited from Account A but not credited to Account B (due to a system failure), the transaction must be **rolled back** so that neither account is affected.
  - **Atomicity ensures** that both debit and credit operations happen together or not at all.

## 2. Consistency
- **Definition**: A transaction must bring the database from one valid state to another, ensuring that any changes to the database adhere to defined rules (e.g., constraints, triggers).
- **Example**: In an e-commerce application, if a user places an order, the system should ensure that the inventory is updated correctly (reduce stock). If the stock goes below zero, the transaction is **inconsistent**.
  - **Consistency ensures** that after a transaction, all data will be valid according to the database rules.

## 3. Isolation
- **Definition**: Transactions should be executed independently of each other. The intermediate state of a transaction should not be visible to other transactions until it's complete.
- **Example**: Two customers simultaneously trying to buy the last item in stock:
  - If **Customer A** is in the process of purchasing, **Customer B** should not see the item as available until the transaction of **Customer A** is complete. 
  - **Isolation ensures** that one transaction doesn’t interfere with another and prevents issues like dirty reads.

## 4. Durability
- **Definition**: Once a transaction is committed, its changes are **permanent**, even in the event of a system failure (e.g., power outage).
- **Example**: After a bank transfer of $100 from Account A to Account B is successfully completed and committed:
  - Even if the server crashes immediately afterward, the changes (debit from Account A and credit to Account B) will still be saved when the system is restored.
  - **Durability ensures** that committed transactions are saved and cannot be undone due to a failure.

