-- Core Tables for Retail Inventory Management System
-- PostgreSQL Script

-- Store Information
CREATE TABLE stores (
    store_id SERIAL PRIMARY KEY,
    store_name VARCHAR(100) NOT NULL,
    store_type VARCHAR(50),
    address_line1 VARCHAR(100),
    address_line2 VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50),
    country VARCHAR(50),
    postal_code VARCHAR(20),
    phone VARCHAR(20),
    email VARCHAR(100),
    opening_date DATE,
    closing_date DATE,
    store_size INTEGER,
    store_manager_id INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Products
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    product_description TEXT,
    sku VARCHAR(50) UNIQUE,
    upc VARCHAR(50) UNIQUE,
    brand_id INTEGER,
    category_id INTEGER,
    supplier_id INTEGER,
    unit_cost DECIMAL(10,2),
    retail_price DECIMAL(10,2),
    min_stock_level INTEGER,
    max_stock_level INTEGER,
    reorder_point INTEGER,
    weight DECIMAL(10,2),
    dimensions VARCHAR(50),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Categories
CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    parent_category_id INTEGER,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_parent_category FOREIGN KEY (parent_category_id) 
        REFERENCES categories(category_id)
);

-- Brands
CREATE TABLE brands (
    brand_id SERIAL PRIMARY KEY,
    brand_name VARCHAR(100) NOT NULL,
    description TEXT,
    website VARCHAR(200),
    contact_email VARCHAR(100),
    contact_phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Suppliers
CREATE TABLE suppliers (
    supplier_id SERIAL PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL,
    contact_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    address_line1 VARCHAR(100),
    address_line2 VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50),
    country VARCHAR(50),
    postal_code VARCHAR(20),
    payment_terms VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Inventory
CREATE TABLE inventory (
    inventory_id SERIAL PRIMARY KEY,
    store_id INTEGER,
    product_id INTEGER,
    quantity INTEGER NOT NULL,
    last_restock_date DATE,
    last_count_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_inventory_store FOREIGN KEY (store_id) 
        REFERENCES stores(store_id),
    CONSTRAINT fk_inventory_product FOREIGN KEY (product_id) 
        REFERENCES products(product_id)
);

-- Purchase Orders
CREATE TABLE purchase_orders (
    po_id SERIAL PRIMARY KEY,
    supplier_id INTEGER,
    store_id INTEGER,
    order_date DATE NOT NULL,
    expected_delivery_date DATE,
    status VARCHAR(20),
    total_amount DECIMAL(10,2),
    created_by INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_po_supplier FOREIGN KEY (supplier_id) 
        REFERENCES suppliers(supplier_id),
    CONSTRAINT fk_po_store FOREIGN KEY (store_id) 
        REFERENCES stores(store_id)
);

-- Purchase Order Items
CREATE TABLE purchase_order_items (
    po_item_id SERIAL PRIMARY KEY,
    po_id INTEGER,
    product_id INTEGER,
    quantity INTEGER NOT NULL,
    unit_cost DECIMAL(10,2),
    total_cost DECIMAL(10,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_poi_po FOREIGN KEY (po_id) 
        REFERENCES purchase_orders(po_id),
    CONSTRAINT fk_poi_product FOREIGN KEY (product_id) 
        REFERENCES products(product_id)
);

-- Sales
CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    store_id INTEGER,
    customer_id INTEGER,
    sale_date TIMESTAMP NOT NULL,
    total_amount DECIMAL(10,2),
    payment_method VARCHAR(50),
    status VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_sale_store FOREIGN KEY (store_id) 
        REFERENCES stores(store_id)
);

-- Sales Items
CREATE TABLE sales_items (
    sale_item_id SERIAL PRIMARY KEY,
    sale_id INTEGER,
    product_id INTEGER,
    quantity INTEGER NOT NULL,
    unit_price DECIMAL(10,2),
    total_price DECIMAL(10,2),
    discount_amount DECIMAL(10,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_si_sale FOREIGN KEY (sale_id) 
        REFERENCES sales(sale_id),
    CONSTRAINT fk_si_product FOREIGN KEY (product_id) 
        REFERENCES products(product_id)
);

-- Customers
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(20),
    address_line1 VARCHAR(100),
    address_line2 VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50),
    country VARCHAR(50),
    postal_code VARCHAR(20),
    customer_type VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Employees
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(20),
    hire_date DATE,
    position VARCHAR(50),
    department VARCHAR(50),
    manager_id INTEGER,
    store_id INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
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

-- Create indexes for better performance
CREATE INDEX idx_products_sku ON products(sku);
CREATE INDEX idx_products_upc ON products(upc);
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_products_brand ON products(brand_id);
CREATE INDEX idx_products_supplier ON products(supplier_id);

CREATE INDEX idx_inventory_store_product ON inventory(store_id, product_id);
CREATE INDEX idx_inventory_product ON inventory(product_id);

CREATE INDEX idx_sales_date ON sales(sale_date);
CREATE INDEX idx_sales_store ON sales(store_id);
CREATE INDEX idx_sales_customer ON sales(customer_id);

CREATE INDEX idx_sales_items_sale ON sales_items(sale_id);
CREATE INDEX idx_sales_items_product ON sales_items(product_id);

CREATE INDEX idx_purchase_orders_supplier ON purchase_orders(supplier_id);
CREATE INDEX idx_purchase_orders_store ON purchase_orders(store_id);
CREATE INDEX idx_purchase_orders_date ON purchase_orders(order_date);

CREATE INDEX idx_purchase_order_items_po ON purchase_order_items(po_id);
CREATE INDEX idx_purchase_order_items_product ON purchase_order_items(product_id);

CREATE INDEX idx_customers_email ON customers(email);
CREATE INDEX idx_customers_phone ON customers(phone);

CREATE INDEX idx_employees_store ON employees(store_id);
CREATE INDEX idx_employees_department ON employees(department); 