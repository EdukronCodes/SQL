-- Insert Dummy Data for Retail Inventory Management System
-- Oracle SQL Script

-- Insert into categories (parent categories first)
INSERT INTO categories (category_id, category_name, parent_category_id, description) VALUES
(1, 'Electronics', NULL, 'Electronic devices and accessories'),
(2, 'Clothing', NULL, 'Apparel and fashion items'),
(3, 'Home & Kitchen', NULL, 'Home appliances and kitchenware'),
(4, 'Smartphones', 1, 'Mobile phones and accessories'),
(5, 'Laptops', 1, 'Portable computers and accessories'),
(6, 'Men''s Clothing', 2, 'Clothing for men'),
(7, 'Women''s Clothing', 2, 'Clothing for women'),
(8, 'Kitchen Appliances', 3, 'Kitchen electronic appliances'),
(9, 'Cookware', 3, 'Cooking utensils and equipment');

-- Insert into brands
INSERT INTO brands (brand_id, brand_name, description, website, contact_email, contact_phone) VALUES
(1, 'TechGiant', 'Leading technology brand', 'www.techgiant.com', 'contact@techgiant.com', '1-800-TECH'),
(2, 'FashionForward', 'Trendy clothing brand', 'www.fashionforward.com', 'info@fashionforward.com', '1-800-FASHION'),
(3, 'HomeEssentials', 'Quality home products', 'www.homeessentials.com', 'support@homeessentials.com', '1-800-HOME'),
(4, 'SmartLife', 'Smart home solutions', 'www.smartlife.com', 'help@smartlife.com', '1-800-SMART');

-- Insert into suppliers
INSERT INTO suppliers (supplier_id, supplier_name, contact_name, email, phone, address_line1, city, state, country, postal_code, payment_terms) VALUES
(1, 'TechSupplies Inc', 'John Smith', 'john@techsupplies.com', '1-800-TECH-SUP', '123 Tech St', 'San Francisco', 'CA', 'USA', '94105', 'Net 30'),
(2, 'Fashion Distributors', 'Sarah Johnson', 'sarah@fashiondist.com', '1-800-FASHION', '456 Fashion Ave', 'New York', 'NY', 'USA', '10001', 'Net 45'),
(3, 'Home Goods Co', 'Mike Brown', 'mike@homegoods.com', '1-800-HOME', '789 Home Rd', 'Chicago', 'IL', 'USA', '60601', 'Net 30'),
(4, 'Smart Solutions', 'Lisa Chen', 'lisa@smartsolutions.com', '1-800-SMART', '321 Smart Blvd', 'Seattle', 'WA', 'USA', '98101', 'Net 60');

-- Insert into employees (managers first)
INSERT INTO employees (employee_id, first_name, last_name, email, phone, hire_date, position, department, manager_id, store_id) VALUES
(1, 'David', 'Wilson', 'david.wilson@retail.com', '555-0101', '2020-01-15', 'Store Manager', 'Management', NULL, 1),
(2, 'Emily', 'Brown', 'emily.brown@retail.com', '555-0102', '2020-02-01', 'Assistant Manager', 'Management', 1, 1),
(3, 'Michael', 'Johnson', 'michael.johnson@retail.com', '555-0103', '2020-03-15', 'Sales Associate', 'Sales', 2, 1),
(4, 'Sarah', 'Davis', 'sarah.davis@retail.com', '555-0104', '2020-04-01', 'Inventory Specialist', 'Inventory', 2, 1);

-- Insert into stores
INSERT INTO stores (store_id, store_name, store_type, address_line1, city, state, country, postal_code, phone, email, opening_date, store_size, store_manager_id) VALUES
(1, 'Downtown Store', 'Flagship', '100 Main St', 'New York', 'NY', 'USA', '10001', '555-1001', 'downtown@retail.com', '2020-01-01', 5000, 1),
(2, 'Uptown Store', 'Standard', '200 Park Ave', 'New York', 'NY', 'USA', '10002', '555-1002', 'uptown@retail.com', '2020-02-01', 3000, 2),
(3, 'Westside Store', 'Express', '300 West St', 'Los Angeles', 'CA', 'USA', '90001', '555-1003', 'westside@retail.com', '2020-03-01', 2000, 3);

-- Insert into products
INSERT INTO products (product_id, product_name, product_description, sku, upc, brand_id, category_id, supplier_id, unit_cost, retail_price, min_stock_level, max_stock_level, reorder_point, weight, dimensions, is_active) VALUES
(1, 'Smartphone X', 'Latest smartphone model', 'SP-X-001', '123456789012', 1, 4, 1, 500.00, 699.99, 10, 100, 20, 0.5, '6x3x0.3', 'Y'),
(2, 'Laptop Pro', 'Professional laptop', 'LP-P-001', '234567890123', 1, 5, 1, 800.00, 999.99, 5, 50, 10, 2.5, '14x10x1', 'Y'),
(3, 'Men''s T-Shirt', 'Cotton t-shirt', 'TS-M-001', '345678901234', 2, 6, 2, 10.00, 24.99, 20, 200, 40, 0.2, 'M', 'Y'),
(4, 'Women''s Dress', 'Summer dress', 'DR-W-001', '456789012345', 2, 7, 2, 25.00, 49.99, 15, 150, 30, 0.3, 'S', 'Y'),
(5, 'Blender Pro', 'Professional blender', 'BL-P-001', '567890123456', 3, 8, 3, 50.00, 79.99, 8, 80, 15, 3.0, '8x8x12', 'Y');

-- Insert into inventory
INSERT INTO inventory (inventory_id, store_id, product_id, quantity, last_restock_date, last_count_date) VALUES
(1, 1, 1, 50, '2024-01-15', '2024-01-20'),
(2, 1, 2, 25, '2024-01-15', '2024-01-20'),
(3, 1, 3, 100, '2024-01-15', '2024-01-20'),
(4, 1, 4, 75, '2024-01-15', '2024-01-20'),
(5, 1, 5, 30, '2024-01-15', '2024-01-20');

-- Insert into customers
INSERT INTO customers (customer_id, first_name, last_name, email, phone, address_line1, city, state, country, postal_code, customer_type) VALUES
(1, 'John', 'Doe', 'john.doe@email.com', '555-0201', '123 Customer St', 'New York', 'NY', 'USA', '10003', 'Regular'),
(2, 'Jane', 'Smith', 'jane.smith@email.com', '555-0202', '456 Customer Ave', 'New York', 'NY', 'USA', '10004', 'Premium'),
(3, 'Bob', 'Johnson', 'bob.johnson@email.com', '555-0203', '789 Customer Rd', 'Los Angeles', 'CA', 'USA', '90002', 'Regular');

-- Insert into sales
INSERT INTO sales (sale_id, store_id, customer_id, sale_date, total_amount, payment_method, status) VALUES
(1, 1, 1, SYSTIMESTAMP, 699.99, 'Credit Card', 'Completed'),
(2, 1, 2, SYSTIMESTAMP, 999.99, 'Debit Card', 'Completed'),
(3, 1, 3, SYSTIMESTAMP, 74.98, 'Cash', 'Completed');

-- Insert into sales_items
INSERT INTO sales_items (sale_item_id, sale_id, product_id, quantity, unit_price, total_price, discount_amount) VALUES
(1, 1, 1, 1, 699.99, 699.99, 0),
(2, 2, 2, 1, 999.99, 999.99, 0),
(3, 3, 3, 2, 24.99, 49.98, 0),
(4, 3, 4, 1, 24.99, 24.99, 0);

-- Insert into purchase_orders
INSERT INTO purchase_orders (po_id, supplier_id, store_id, order_date, expected_delivery_date, status, total_amount, created_by) VALUES
(1, 1, 1, SYSDATE, SYSDATE + 7, 'Pending', 1500.00, 4),
(2, 2, 1, SYSDATE, SYSDATE + 7, 'Pending', 750.00, 4),
(3, 3, 1, SYSDATE, SYSDATE + 7, 'Pending', 400.00, 4);

-- Insert into purchase_order_items
INSERT INTO purchase_order_items (po_item_id, po_id, product_id, quantity, unit_cost, total_cost) VALUES
(1, 1, 1, 2, 500.00, 1000.00),
(2, 1, 2, 1, 500.00, 500.00),
(3, 2, 3, 50, 10.00, 500.00),
(4, 2, 4, 10, 25.00, 250.00),
(5, 3, 5, 8, 50.00, 400.00);

-- Insert into inventory_movement
INSERT INTO inventory_movement (movement_id, product_id, store_id, movement_type, quantity, reference_id, reference_type, movement_date, created_by) VALUES
(1, 1, 1, 'IN', 50, 1, 'PO', SYSTIMESTAMP, 4),
(2, 2, 1, 'IN', 25, 1, 'PO', SYSTIMESTAMP, 4),
(3, 1, 1, 'OUT', 1, 1, 'SALE', SYSTIMESTAMP, 3);

-- Insert into product_returns
INSERT INTO product_returns (return_id, sale_id, product_id, store_id, customer_id, return_date, return_reason, quantity, refund_amount, status) VALUES
(1, 1, 1, 1, 1, SYSTIMESTAMP, 'Defective product', 1, 699.99, 'Completed'),
(2, 2, 2, 1, 2, SYSTIMESTAMP, 'Wrong size', 1, 999.99, 'Pending');

-- Insert into product_reviews
INSERT INTO product_reviews (review_id, product_id, customer_id, rating, review_text, review_date, is_verified_purchase) VALUES
(1, 1, 1, 5, 'Great product!', SYSTIMESTAMP, 'Y'),
(2, 2, 2, 4, 'Good laptop, but expensive', SYSTIMESTAMP, 'Y'),
(3, 3, 3, 5, 'Perfect fit and quality', SYSTIMESTAMP, 'Y');

-- Insert into store_shifts
INSERT INTO store_shifts (shift_id, store_id, employee_id, shift_date, start_time, end_time, status) VALUES
(1, 1, 1, SYSDATE, SYSTIMESTAMP, SYSTIMESTAMP + 8/24, 'Completed'),
(2, 1, 2, SYSDATE, SYSTIMESTAMP + 8/24, SYSTIMESTAMP + 16/24, 'In Progress'),
(3, 1, 3, SYSDATE, SYSTIMESTAMP, SYSTIMESTAMP + 8/24, 'Completed');

-- Insert into product_discounts
INSERT INTO product_discounts (discount_id, product_id, discount_type, discount_value, start_date, end_date, is_active) VALUES
(1, 1, 'Percentage', 10.00, SYSDATE, SYSDATE + 30, 'Y'),
(2, 2, 'Fixed', 50.00, SYSDATE, SYSDATE + 30, 'Y'),
(3, 3, 'Percentage', 20.00, SYSDATE, SYSDATE + 30, 'Y');

-- Insert into fact_sales
INSERT INTO fact_sales (sale_id, date_id, store_id, product_id, customer_id, employee_id, quantity, unit_price, total_amount, discount_amount, tax_amount) VALUES
(1, 1, 1, 1, 1, 3, 1, 699.99, 699.99, 0, 69.99),
(2, 1, 1, 2, 2, 3, 1, 999.99, 999.99, 0, 99.99),
(3, 1, 1, 3, 3, 3, 2, 24.99, 49.98, 0, 4.99);

-- Insert into fact_inventory
INSERT INTO fact_inventory (inventory_id, date_id, store_id, product_id, beginning_quantity, ending_quantity, received_quantity, sold_quantity, damaged_quantity) VALUES
(1, 1, 1, 1, 50, 49, 50, 1, 0),
(2, 1, 1, 2, 25, 24, 25, 1, 0),
(3, 1, 1, 3, 100, 98, 100, 2, 0);

-- Insert into fact_purchases
INSERT INTO fact_purchases (purchase_id, date_id, store_id, product_id, supplier_id, employee_id, quantity, unit_cost, total_cost) VALUES
(1, 1, 1, 1, 1, 4, 2, 500.00, 1000.00),
(2, 1, 1, 2, 1, 4, 1, 500.00, 500.00),
(3, 1, 1, 3, 2, 4, 50, 10.00, 500.00);

-- Insert into dim_date
INSERT INTO dim_date (date_id, full_date, day_of_week, day_of_month, day_of_year, week_of_year, month_number, month_name, quarter, year, is_holiday, holiday_name, is_weekend) VALUES
(1, SYSDATE, 'Monday', 1, 1, 1, 1, 'January', 1, 2024, 'N', NULL, 'N'),
(2, SYSDATE + 1, 'Tuesday', 2, 2, 1, 1, 'January', 1, 2024, 'N', NULL, 'N'),
(3, SYSDATE + 2, 'Wednesday', 3, 3, 1, 1, 'January', 1, 2024, 'N', NULL, 'N');

-- Insert into dim_store
INSERT INTO dim_store (store_id, store_name, store_type, city, state, country, region, store_size, store_manager_id) VALUES
(1, 'Downtown Store', 'Flagship', 'New York', 'NY', 'USA', 'Northeast', 5000, 1),
(2, 'Uptown Store', 'Standard', 'New York', 'NY', 'USA', 'Northeast', 3000, 2),
(3, 'Westside Store', 'Express', 'Los Angeles', 'CA', 'USA', 'West', 2000, 3);

-- Insert into dim_product
INSERT INTO dim_product (product_id, product_name, sku, upc, brand_name, category_name, supplier_name, unit_cost, retail_price, is_active) VALUES
(1, 'Smartphone X', 'SP-X-001', '123456789012', 'TechGiant', 'Smartphones', 'TechSupplies Inc', 500.00, 699.99, 'Y'),
(2, 'Laptop Pro', 'LP-P-001', '234567890123', 'TechGiant', 'Laptops', 'TechSupplies Inc', 800.00, 999.99, 'Y'),
(3, 'Men''s T-Shirt', 'TS-M-001', '345678901234', 'FashionForward', 'Men''s Clothing', 'Fashion Distributors', 10.00, 24.99, 'Y');

-- Insert into dim_customer
INSERT INTO dim_customer (customer_id, customer_name, customer_type, city, state, country, region) VALUES
(1, 'John Doe', 'Regular', 'New York', 'NY', 'USA', 'Northeast'),
(2, 'Jane Smith', 'Premium', 'New York', 'NY', 'USA', 'Northeast'),
(3, 'Bob Johnson', 'Regular', 'Los Angeles', 'CA', 'USA', 'West');

-- Insert into dim_employee
INSERT INTO dim_employee (employee_id, employee_name, position, department, store_id) VALUES
(1, 'David Wilson', 'Store Manager', 'Management', 1),
(2, 'Emily Brown', 'Assistant Manager', 'Management', 1),
(3, 'Michael Johnson', 'Sales Associate', 'Sales', 1);

-- Insert into dim_supplier
INSERT INTO dim_supplier (supplier_id, supplier_name, city, state, country, region) VALUES
(1, 'TechSupplies Inc', 'San Francisco', 'CA', 'USA', 'West'),
(2, 'Fashion Distributors', 'New York', 'NY', 'USA', 'Northeast'),
(3, 'Home Goods Co', 'Chicago', 'IL', 'USA', 'Midwest');

-- Insert into dim_payment_method
INSERT INTO dim_payment_method (payment_method_id, payment_type, payment_provider, is_credit_card, is_cash, is_digital_wallet) VALUES
(1, 'Credit Card', 'Visa', 'Y', 'N', 'N'),
(2, 'Debit Card', 'MasterCard', 'N', 'N', 'N'),
(3, 'Cash', 'Cash', 'N', 'Y', 'N'),
(4, 'Digital Wallet', 'PayPal', 'N', 'N', 'Y');

-- Insert into dim_promotion
INSERT INTO dim_promotion (promotion_id, promotion_name, promotion_type, discount_type, discount_value, start_date, end_date, is_active) VALUES
(1, 'Summer Sale', 'Seasonal', 'Percentage', 20.00, SYSDATE, SYSDATE + 30, 'Y'),
(2, 'Tech Clearance', 'Clearance', 'Fixed', 100.00, SYSDATE, SYSDATE + 15, 'Y'),
(3, 'Holiday Special', 'Holiday', 'Percentage', 15.00, SYSDATE, SYSDATE + 60, 'Y');

-- Insert into dim_product_category
INSERT INTO dim_product_category (category_id, category_name, parent_category_id, category_level, category_path) VALUES
(1, 'Electronics', NULL, 1, 'Electronics'),
(2, 'Smartphones', 1, 2, 'Electronics/Smartphones'),
(3, 'Laptops', 1, 2, 'Electronics/Laptops');

-- Insert into dim_product_brand
INSERT INTO dim_product_brand (brand_id, brand_name, brand_type, country_of_origin) VALUES
(1, 'TechGiant', 'Technology', 'USA'),
(2, 'FashionForward', 'Fashion', 'Italy'),
(3, 'HomeEssentials', 'Home Goods', 'Germany');

-- Insert into dim_store_location
INSERT INTO dim_store_location (location_id, store_id, address_line1, city, state, country, postal_code, latitude, longitude) VALUES
(1, 1, '100 Main St', 'New York', 'NY', 'USA', '10001', 40.7128, -74.0060),
(2, 2, '200 Park Ave', 'New York', 'NY', 'USA', '10002', 40.7589, -73.9851),
(3, 3, '300 West St', 'Los Angeles', 'CA', 'USA', '90001', 34.0522, -118.2437);

-- Insert into dim_store_type
INSERT INTO dim_store_type (store_type_id, store_type_name, store_type_description, target_customer_segment) VALUES
(1, 'Flagship', 'Large format store with full product range', 'Premium'),
(2, 'Standard', 'Medium format store with core products', 'Regular'),
(3, 'Express', 'Small format store with essential products', 'Budget');

-- Insert into dim_customer_segment
INSERT INTO dim_customer_segment (segment_id, segment_name, segment_description, min_purchase_amount, max_purchase_amount) VALUES
(1, 'Premium', 'High-value customers', 1000.00, 999999.99),
(2, 'Regular', 'Average spending customers', 100.00, 999.99),
(3, 'Budget', 'Price-sensitive customers', 0.00, 99.99);

-- Insert into dim_employee_role
INSERT INTO dim_employee_role (role_id, role_name, role_description, department) VALUES
(1, 'Store Manager', 'Manages store operations', 'Management'),
(2, 'Assistant Manager', 'Assists store manager', 'Management'),
(3, 'Sales Associate', 'Handles customer sales', 'Sales'),
(4, 'Inventory Specialist', 'Manages inventory', 'Inventory');

-- Insert into dim_supplier_category
INSERT INTO dim_supplier_category (supplier_category_id, category_name, category_description) VALUES
(1, 'Technology', 'Technology products and accessories'),
(2, 'Fashion', 'Clothing and fashion items'),
(3, 'Home Goods', 'Home and kitchen products'); 