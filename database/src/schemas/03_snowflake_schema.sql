-- Snowflake Schema Tables for Detailed Data Warehousing
-- Oracle SQL Script

-- Fact Tables
CREATE TABLE fact_daily_sales (
    sale_id NUMBER PRIMARY KEY,
    date_id NUMBER,
    store_id NUMBER,
    product_id NUMBER,
    customer_id NUMBER,
    employee_id NUMBER,
    payment_method_id NUMBER,
    promotion_id NUMBER,
    quantity NUMBER,
    unit_price NUMBER(10,2),
    total_amount NUMBER(10,2),
    discount_amount NUMBER(10,2),
    tax_amount NUMBER(10,2),
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_fds_date FOREIGN KEY (date_id) 
        REFERENCES dim_date(date_id),
    CONSTRAINT fk_fds_store FOREIGN KEY (store_id) 
        REFERENCES dim_store(store_id),
    CONSTRAINT fk_fds_product FOREIGN KEY (product_id) 
        REFERENCES dim_product(product_id),
    CONSTRAINT fk_fds_customer FOREIGN KEY (customer_id) 
        REFERENCES dim_customer(customer_id),
    CONSTRAINT fk_fds_employee FOREIGN KEY (employee_id) 
        REFERENCES dim_employee(employee_id),
    CONSTRAINT fk_fds_payment FOREIGN KEY (payment_method_id) 
        REFERENCES dim_payment_method(payment_method_id),
    CONSTRAINT fk_fds_promotion FOREIGN KEY (promotion_id) 
        REFERENCES dim_promotion(promotion_id)
);

-- Detailed Dimension Tables
CREATE TABLE dim_payment_method (
    payment_method_id NUMBER PRIMARY KEY,
    payment_type VARCHAR2(50),
    payment_provider VARCHAR2(50),
    is_credit_card CHAR(1),
    is_cash CHAR(1),
    is_digital_wallet CHAR(1),
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP
);

CREATE TABLE dim_promotion (
    promotion_id NUMBER PRIMARY KEY,
    promotion_name VARCHAR2(100),
    promotion_type VARCHAR2(50),
    discount_type VARCHAR2(50),
    discount_value NUMBER(10,2),
    start_date DATE,
    end_date DATE,
    is_active CHAR(1),
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP
);

CREATE TABLE dim_product_category (
    category_id NUMBER PRIMARY KEY,
    category_name VARCHAR2(100),
    parent_category_id NUMBER,
    category_level NUMBER,
    category_path VARCHAR2(500),
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_parent_cat FOREIGN KEY (parent_category_id) 
        REFERENCES dim_product_category(category_id)
);

CREATE TABLE dim_product_brand (
    brand_id NUMBER PRIMARY KEY,
    brand_name VARCHAR2(100),
    brand_type VARCHAR2(50),
    country_of_origin VARCHAR2(50),
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP
);

CREATE TABLE dim_store_location (
    location_id NUMBER PRIMARY KEY,
    store_id NUMBER,
    address_line1 VARCHAR2(100),
    address_line2 VARCHAR2(100),
    city VARCHAR2(50),
    state VARCHAR2(50),
    country VARCHAR2(50),
    postal_code VARCHAR2(20),
    latitude NUMBER(10,6),
    longitude NUMBER(10,6),
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_loc_store FOREIGN KEY (store_id) 
        REFERENCES dim_store(store_id)
);

CREATE TABLE dim_store_type (
    store_type_id NUMBER PRIMARY KEY,
    store_type_name VARCHAR2(50),
    store_type_description VARCHAR2(500),
    target_customer_segment VARCHAR2(50),
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP
);

CREATE TABLE dim_customer_segment (
    segment_id NUMBER PRIMARY KEY,
    segment_name VARCHAR2(50),
    segment_description VARCHAR2(500),
    min_purchase_amount NUMBER(10,2),
    max_purchase_amount NUMBER(10,2),
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP
);

CREATE TABLE dim_employee_role (
    role_id NUMBER PRIMARY KEY,
    role_name VARCHAR2(50),
    role_description VARCHAR2(500),
    department VARCHAR2(50),
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP
);

CREATE TABLE dim_supplier_category (
    supplier_category_id NUMBER PRIMARY KEY,
    category_name VARCHAR2(50),
    category_description VARCHAR2(500),
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP
);

-- Add foreign key constraints for snowflake relationships
ALTER TABLE dim_store
ADD CONSTRAINT fk_store_type
FOREIGN KEY (store_type_id)
REFERENCES dim_store_type(store_type_id);

ALTER TABLE dim_customer
ADD CONSTRAINT fk_customer_segment
FOREIGN KEY (segment_id)
REFERENCES dim_customer_segment(segment_id);

ALTER TABLE dim_employee
ADD CONSTRAINT fk_employee_role
FOREIGN KEY (role_id)
REFERENCES dim_employee_role(role_id);

ALTER TABLE dim_supplier
ADD CONSTRAINT fk_supplier_category
FOREIGN KEY (category_id)
REFERENCES dim_supplier_category(supplier_category_id);

ALTER TABLE dim_product
ADD CONSTRAINT fk_product_category
FOREIGN KEY (category_id)
REFERENCES dim_product_category(category_id);

ALTER TABLE dim_product
ADD CONSTRAINT fk_product_brand
FOREIGN KEY (brand_id)
REFERENCES dim_product_brand(brand_id); 