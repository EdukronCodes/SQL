# Retail Inventory Management System Database

This repository contains the database scripts for a comprehensive Retail Inventory Management System. The system is designed to handle all aspects of retail operations, including inventory management, sales, purchasing, and customer management.

## Database Structure

The database is organized into several key components:

1. Core Tables (01_core_tables.sql)
   - Basic operational tables for day-to-day retail operations
   - Includes tables for stores, products, inventory, sales, etc.

2. Star Schema (02_star_schema.sql)
   - Data warehouse tables optimized for reporting and analytics
   - Includes fact tables and dimension tables
   - Designed for efficient querying of aggregated data

3. Snowflake Schema (03_snowflake_schema.sql)
   - Extended data warehouse schema with normalized dimensions
   - Provides more detailed analysis capabilities
   - Includes additional dimension tables for deeper insights

4. Operational Tables (04_operational_tables.sql)
   - Additional tables for specific operational needs
   - Includes tables for inventory movement, returns, reviews, etc.
   - Contains performance-optimized indexes

5. PostgreSQL Version (05_postgresql_core_tables.sql)
   - PostgreSQL-compatible version of the core tables
   - Includes PostgreSQL-specific data types and features

## Key Features

- Complete inventory tracking and management
- Multi-store support
- Customer relationship management
- Employee management
- Purchase order processing
- Sales tracking and analysis
- Product categorization and branding
- Supplier management
- Data warehousing capabilities
- Performance-optimized indexes

## Table Count

The database includes over 40 tables across different schemas:

### Core Tables (15)
- stores
- products
- categories
- brands
- suppliers
- inventory
- purchase_orders
- purchase_order_items
- sales
- sales_items
- customers
- employees

### Star Schema Tables (9)
- fact_sales
- fact_inventory
- fact_purchases
- dim_date
- dim_store
- dim_product
- dim_customer
- dim_employee
- dim_supplier

### Snowflake Schema Tables (8)
- fact_daily_sales
- dim_payment_method
- dim_promotion
- dim_product_category
- dim_product_brand
- dim_store_location
- dim_store_type
- dim_customer_segment
- dim_employee_role
- dim_supplier_category

### Operational Tables (8)
- inventory_movement
- product_returns
- product_reviews
- store_shifts
- product_discounts

## Usage

1. Choose the appropriate script based on your database system:
   - For Oracle: Use 01_core_tables.sql, 02_star_schema.sql, 03_snowflake_schema.sql, and 04_operational_tables.sql
   - For PostgreSQL: Use 05_postgresql_core_tables.sql

2. Execute the scripts in the following order:
   - Core tables first
   - Star schema tables
   - Snowflake schema tables
   - Operational tables

3. The scripts include:
   - Table creation
   - Primary key constraints
   - Foreign key constraints
   - Indexes for performance optimization

## Performance Considerations

- All tables include appropriate indexes for common query patterns
- Star and snowflake schemas are optimized for analytical queries
- Core tables are optimized for transactional operations
- Timestamps are included for auditing and tracking

## Maintenance

- Regular index maintenance is recommended
- Monitor table growth and partitioning if necessary
- Regular backup of the database is essential
- Consider implementing archiving strategies for historical data

## Security

- Implement appropriate user roles and permissions
- Secure sensitive data (customer information, financial data)
- Regular security audits recommended
- Implement data encryption where necessary 