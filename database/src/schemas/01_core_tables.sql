-- Core Tables for Retail Inventory Management System
-- Oracle SQL Script

-- Store Information
CREATE TABLE stores (
    store_id NUMBER PRIMARY KEY,
    store_name VARCHAR2(100) NOT NULL,
    store_type VARCHAR2(50),
    address_line1 VARCHAR2(100),
    address_line2 VARCHAR2(100),
    city VARCHAR2(50),
    state VARCHAR2(50),
    country VARCHAR2(50),
    postal_code VARCHAR2(20),
    phone VARCHAR2(20),
    email VARCHAR2(100),
    opening_date DATE,
    closing_date DATE,
    store_size NUMBER,
    store_manager_id NUMBER,
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    updated_at TIMESTAMP DEFAULT SYSTIMESTAMP
);

-- Products
CREATE TABLE products (
    product_id NUMBER PRIMARY KEY,
    product_name VARCHAR2(100) NOT NULL,
    product_description VARCHAR2(500),
    sku VARCHAR2(50) UNIQUE,
    upc VARCHAR2(50) UNIQUE,
    brand_id NUMBER,
    category_id NUMBER,
    supplier_id NUMBER,
    unit_cost NUMBER(10,2),
    retail_price NUMBER(10,2),
    min_stock_level NUMBER,
    max_stock_level NUMBER,
    reorder_point NUMBER,
    weight NUMBER(10,2),
    dimensions VARCHAR2(50),
    is_active CHAR(1) DEFAULT 'Y',
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    updated_at TIMESTAMP DEFAULT SYSTIMESTAMP
);

-- Categories
CREATE TABLE categories (
    category_id NUMBER PRIMARY KEY,
    category_name VARCHAR2(100) NOT NULL,
    parent_category_id NUMBER,
    description VARCHAR2(500),
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    updated_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_parent_category FOREIGN KEY (parent_category_id) 
        REFERENCES categories(category_id)
);

-- Brands
CREATE TABLE brands (
    brand_id NUMBER PRIMARY KEY,
    brand_name VARCHAR2(100) NOT NULL,
    description VARCHAR2(500),
    website VARCHAR2(200),
    contact_email VARCHAR2(100),
    contact_phone VARCHAR2(20),
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    updated_at TIMESTAMP DEFAULT SYSTIMESTAMP
);

-- Suppliers
CREATE TABLE suppliers (
    supplier_id NUMBER PRIMARY KEY,
    supplier_name VARCHAR2(100) NOT NULL,
    contact_name VARCHAR2(100),
    email VARCHAR2(100),
    phone VARCHAR2(20),
    address_line1 VARCHAR2(100),
    address_line2 VARCHAR2(100),
    city VARCHAR2(50),
    state VARCHAR2(50),
    country VARCHAR2(50),
    postal_code VARCHAR2(20),
    payment_terms VARCHAR2(100),
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    updated_at TIMESTAMP DEFAULT SYSTIMESTAMP
);

-- Inventory
CREATE TABLE inventory (
    inventory_id NUMBER PRIMARY KEY,
    store_id NUMBER,
    product_id NUMBER,
    quantity NUMBER NOT NULL,
    last_restock_date DATE,
    last_count_date DATE,
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    updated_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_inventory_store FOREIGN KEY (store_id) 
        REFERENCES stores(store_id),
    CONSTRAINT fk_inventory_product FOREIGN KEY (product_id) 
        REFERENCES products(product_id)
);

-- Purchase Orders
CREATE TABLE purchase_orders (
    po_id NUMBER PRIMARY KEY,
    supplier_id NUMBER,
    store_id NUMBER,
    order_date DATE NOT NULL,
    expected_delivery_date DATE,
    status VARCHAR2(20),
    total_amount NUMBER(10,2),
    created_by NUMBER,
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    updated_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_po_supplier FOREIGN KEY (supplier_id) 
        REFERENCES suppliers(supplier_id),
    CONSTRAINT fk_po_store FOREIGN KEY (store_id) 
        REFERENCES stores(store_id)
);

-- Purchase Order Items
CREATE TABLE purchase_order_items (
    po_item_id NUMBER PRIMARY KEY,
    po_id NUMBER,
    product_id NUMBER,
    quantity NUMBER NOT NULL,
    unit_cost NUMBER(10,2),
    total_cost NUMBER(10,2),
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    updated_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_poi_po FOREIGN KEY (po_id) 
        REFERENCES purchase_orders(po_id),
    CONSTRAINT fk_poi_product FOREIGN KEY (product_id) 
        REFERENCES products(product_id)
);

-- Sales
CREATE TABLE sales (
    sale_id NUMBER PRIMARY KEY,
    store_id NUMBER,
    customer_id NUMBER,
    sale_date TIMESTAMP NOT NULL,
    total_amount NUMBER(10,2),
    payment_method VARCHAR2(50),
    status VARCHAR2(20),
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    updated_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_sale_store FOREIGN KEY (store_id) 
        REFERENCES stores(store_id)
);

-- Sales Items
CREATE TABLE sales_items (
    sale_item_id NUMBER PRIMARY KEY,
    sale_id NUMBER,
    product_id NUMBER,
    quantity NUMBER NOT NULL,
    unit_price NUMBER(10,2),
    total_price NUMBER(10,2),
    discount_amount NUMBER(10,2),
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    updated_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_si_sale FOREIGN KEY (sale_id) 
        REFERENCES sales(sale_id),
    CONSTRAINT fk_si_product FOREIGN KEY (product_id) 
        REFERENCES products(product_id)
);

-- Customers
CREATE TABLE customers (
    customer_id NUMBER PRIMARY KEY,
    first_name VARCHAR2(50),
    last_name VARCHAR2(50),
    email VARCHAR2(100),
    phone VARCHAR2(20),
    address_line1 VARCHAR2(100),
    address_line2 VARCHAR2(100),
    city VARCHAR2(50),
    state VARCHAR2(50),
    country VARCHAR2(50),
    postal_code VARCHAR2(20),
    customer_type VARCHAR2(20),
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    updated_at TIMESTAMP DEFAULT SYSTIMESTAMP
);

-- Employees
CREATE TABLE employees (
    employee_id NUMBER PRIMARY KEY,
    first_name VARCHAR2(50),
    last_name VARCHAR2(50),
    email VARCHAR2(100),
    phone VARCHAR2(20),
    hire_date DATE,
    position VARCHAR2(50),
    department VARCHAR2(50),
    manager_id NUMBER,
    store_id NUMBER,
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    updated_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_emp_store FOREIGN KEY (store_id) 
        REFERENCES stores(store_id),
    CONSTRAINT fk_emp_manager FOREIGN KEY (manager_id) 
        REFERENCES employees(employee_id)
);

-- Add foreign key constraints
ALTER TABLE stores
ADD CONSTRAINT fk_store_manager 
FOREIGN KEY (store_manager_id) 
REFERENCES employees(employee_id);

ALTER TABLE products
ADD CONSTRAINT fk_product_brand 
FOREIGN KEY (brand_id) 
REFERENCES brands(brand_id);

ALTER TABLE products
ADD CONSTRAINT fk_product_category 
FOREIGN KEY (category_id) 
REFERENCES categories(category_id);

ALTER TABLE products
ADD CONSTRAINT fk_product_supplier 
FOREIGN KEY (supplier_id) 
REFERENCES suppliers(supplier_id);

ALTER TABLE sales
ADD CONSTRAINT fk_sale_customer 
FOREIGN KEY (customer_id) 
REFERENCES customers(customer_id); 