# Database Triggers Documentation

## Overview
This document provides detailed information about the database triggers used in the Retail Inventory Management System. Triggers are organized by module and include their purpose, timing, conditions, and actions.

## Inventory Triggers

### `trg_inventory_audit`
```sql
CREATE OR REPLACE TRIGGER trg_inventory_audit
AFTER INSERT OR UPDATE OR DELETE ON inventory
FOR EACH ROW
```
- **Purpose**: Tracks all inventory changes
- **Timing**: AFTER INSERT/UPDATE/DELETE
- **Actions**:
  - Records old and new values
  - Logs user and timestamp
  - Updates audit trail
  - Maintains history

### `trg_inventory_reorder`
```sql
CREATE OR REPLACE TRIGGER trg_inventory_reorder
AFTER UPDATE OF quantity ON inventory
FOR EACH ROW
```
- **Purpose**: Automates reorder process
- **Timing**: AFTER UPDATE
- **Conditions**: Quantity below reorder point
- **Actions**:
  - Creates purchase order
  - Notifies supplier
  - Updates reorder status

## Employee Triggers

### `trg_employee_audit`
```sql
CREATE OR REPLACE TRIGGER trg_employee_audit
AFTER INSERT OR UPDATE OR DELETE ON employees
FOR EACH ROW
```
- **Purpose**: Tracks employee record changes
- **Timing**: AFTER INSERT/UPDATE/DELETE
- **Actions**:
  - Records changes
  - Maintains history
  - Updates related records

### `trg_employee_schedule`
```sql
CREATE OR REPLACE TRIGGER trg_employee_schedule
BEFORE INSERT OR UPDATE ON employee_schedule
FOR EACH ROW
```
- **Purpose**: Validates employee schedules
- **Timing**: BEFORE INSERT/UPDATE
- **Actions**:
  - Checks schedule conflicts
  - Validates working hours
  - Ensures compliance

## Store Triggers

### `trg_store_audit`
```sql
CREATE OR REPLACE TRIGGER trg_store_audit
AFTER INSERT OR UPDATE OR DELETE ON stores
FOR EACH ROW
```
- **Purpose**: Tracks store changes
- **Timing**: AFTER INSERT/UPDATE/DELETE
- **Actions**:
  - Records modifications
  - Updates audit trail
  - Maintains history

### `trg_store_performance`
```sql
CREATE OR REPLACE TRIGGER trg_store_performance
AFTER INSERT OR UPDATE ON sales
FOR EACH ROW
```
- **Purpose**: Updates store performance metrics
- **Timing**: AFTER INSERT/UPDATE
- **Actions**:
  - Updates sales metrics
  - Recalculates performance
  - Updates statistics

## Supplier Triggers

### `trg_supplier_audit`
```sql
CREATE OR REPLACE TRIGGER trg_supplier_audit
AFTER INSERT OR UPDATE OR DELETE ON suppliers
FOR EACH ROW
```
- **Purpose**: Tracks supplier changes
- **Timing**: AFTER INSERT/UPDATE/DELETE
- **Actions**:
  - Records modifications
  - Updates audit trail
  - Maintains history

### `trg_supplier_performance`
```sql
CREATE OR REPLACE TRIGGER trg_supplier_performance
AFTER INSERT OR UPDATE ON purchase_orders
FOR EACH ROW
```
- **Purpose**: Updates supplier performance metrics
- **Timing**: AFTER INSERT/UPDATE
- **Actions**:
  - Updates order metrics
  - Recalculates performance
  - Updates statistics

## Sales Triggers

### `trg_sales_audit`
```sql
CREATE OR REPLACE TRIGGER trg_sales_audit
AFTER INSERT OR UPDATE OR DELETE ON sales
FOR EACH ROW
```
- **Purpose**: Tracks sales changes
- **Timing**: AFTER INSERT/UPDATE/DELETE
- **Actions**:
  - Records modifications
  - Updates audit trail
  - Maintains history

### `trg_sales_inventory`
```sql
CREATE OR REPLACE TRIGGER trg_sales_inventory
AFTER INSERT ON sales_items
FOR EACH ROW
```
- **Purpose**: Updates inventory on sales
- **Timing**: AFTER INSERT
- **Actions**:
  - Updates inventory levels
  - Records movement
  - Updates statistics

### `trg_customer_loyalty`
```sql
CREATE OR REPLACE TRIGGER trg_customer_loyalty
AFTER INSERT ON sales
FOR EACH ROW
```
- **Purpose**: Updates customer loyalty points
- **Timing**: AFTER INSERT
- **Actions**:
  - Calculates points
  - Updates loyalty status
  - Maintains history

## Best Practices
1. Keep triggers simple and focused
2. Avoid complex business logic
3. Handle errors appropriately
4. Consider performance impact
5. Document trigger behavior
6. Test thoroughly
7. Monitor execution
8. Maintain audit trails

## Performance Considerations
1. Minimize trigger execution time
2. Avoid unnecessary operations
3. Use appropriate indexes
4. Consider bulk operations
5. Monitor trigger impact
6. Regular performance testing
7. Proper error handling
8. Efficient data access

## Security Considerations
1. Validate data changes
2. Control access rights
3. Maintain audit trails
4. Protect sensitive data
5. Monitor trigger execution
6. Regular security reviews
7. Proper error handling
8. Access control implementation 