-- Star Schema Tables for Data Warehousing
-- Oracle SQL Script

-- Fact Tables
CREATE TABLE fact_sales (
    sale_id NUMBER PRIMARY KEY,
    date_id NUMBER,
    store_id NUMBER,
    product_id NUMBER,
    customer_id NUMBER,
    employee_id NUMBER,
    quantity NUMBER,
    unit_price NUMBER(10,2),
    total_amount NUMBER(10,2),
    discount_amount NUMBER(10,2),
    tax_amount NUMBER(10,2),
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_fs_date FOREIGN KEY (date_id) 
        REFERENCES dim_date(date_id),
    CONSTRAINT fk_fs_store FOREIGN KEY (store_id) 
        REFERENCES dim_store(store_id),
    CONSTRAINT fk_fs_product FOREIGN KEY (product_id) 
        REFERENCES dim_product(product_id),
    CONSTRAINT fk_fs_customer FOREIGN KEY (customer_id) 
        REFERENCES dim_customer(customer_id),
    CONSTRAINT fk_fs_employee FOREIGN KEY (employee_id) 
        REFERENCES dim_employee(employee_id)
);

CREATE TABLE fact_inventory (
    inventory_id NUMBER PRIMARY KEY,
    date_id NUMBER,
    store_id NUMBER,
    product_id NUMBER,
    beginning_quantity NUMBER,
    ending_quantity NUMBER,
    received_quantity NUMBER,
    sold_quantity NUMBER,
    damaged_quantity NUMBER,
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_fi_date FOREIGN KEY (date_id) 
        REFERENCES dim_date(date_id),
    CONSTRAINT fk_fi_store FOREIGN KEY (store_id) 
        REFERENCES dim_store(store_id),
    CONSTRAINT fk_fi_product FOREIGN KEY (product_id) 
        REFERENCES dim_product(product_id)
);

CREATE TABLE fact_purchases (
    purchase_id NUMBER PRIMARY KEY,
    date_id NUMBER,
    store_id NUMBER,
    product_id NUMBER,
    supplier_id NUMBER,
    employee_id NUMBER,
    quantity NUMBER,
    unit_cost NUMBER(10,2),
    total_cost NUMBER(10,2),
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_fp_date FOREIGN KEY (date_id) 
        REFERENCES dim_date(date_id),
    CONSTRAINT fk_fp_store FOREIGN KEY (store_id) 
        REFERENCES dim_store(store_id),
    CONSTRAINT fk_fp_product FOREIGN KEY (product_id) 
        REFERENCES dim_product(product_id),
    CONSTRAINT fk_fp_supplier FOREIGN KEY (supplier_id) 
        REFERENCES dim_supplier(supplier_id),
    CONSTRAINT fk_fp_employee FOREIGN KEY (employee_id) 
        REFERENCES dim_employee(employee_id)
);

-- Dimension Tables
CREATE TABLE dim_date (
    date_id NUMBER PRIMARY KEY,
    full_date DATE,
    day_of_week VARCHAR2(10),
    day_of_month NUMBER,
    day_of_year NUMBER,
    week_of_year NUMBER,
    month_number NUMBER,
    month_name VARCHAR2(10),
    quarter NUMBER,
    year NUMBER,
    is_holiday CHAR(1),
    holiday_name VARCHAR2(50),
    is_weekend CHAR(1),
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP
);

CREATE TABLE dim_store (
    store_id NUMBER PRIMARY KEY,
    store_name VARCHAR2(100),
    store_type VARCHAR2(50),
    city VARCHAR2(50),
    state VARCHAR2(50),
    country VARCHAR2(50),
    region VARCHAR2(50),
    store_size NUMBER,
    store_manager_id NUMBER,
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    updated_at TIMESTAMP DEFAULT SYSTIMESTAMP
);

CREATE TABLE dim_product (
    product_id NUMBER PRIMARY KEY,
    product_name VARCHAR2(100),
    sku VARCHAR2(50),
    upc VARCHAR2(50),
    brand_name VARCHAR2(100),
    category_name VARCHAR2(100),
    supplier_name VARCHAR2(100),
    unit_cost NUMBER(10,2),
    retail_price NUMBER(10,2),
    is_active CHAR(1),
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    updated_at TIMESTAMP DEFAULT SYSTIMESTAMP
);

CREATE TABLE dim_customer (
    customer_id NUMBER PRIMARY KEY,
    customer_name VARCHAR2(100),
    customer_type VARCHAR2(20),
    city VARCHAR2(50),
    state VARCHAR2(50),
    country VARCHAR2(50),
    region VARCHAR2(50),
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    updated_at TIMESTAMP DEFAULT SYSTIMESTAMP
);

CREATE TABLE dim_employee (
    employee_id NUMBER PRIMARY KEY,
    employee_name VARCHAR2(100),
    position VARCHAR2(50),
    department VARCHAR2(50),
    store_id NUMBER,
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    updated_at TIMESTAMP DEFAULT SYSTIMESTAMP
);

CREATE TABLE dim_supplier (
    supplier_id NUMBER PRIMARY KEY,
    supplier_name VARCHAR2(100),
    city VARCHAR2(50),
    state VARCHAR2(50),
    country VARCHAR2(50),
    region VARCHAR2(50),
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    updated_at TIMESTAMP DEFAULT SYSTIMESTAMP
); 