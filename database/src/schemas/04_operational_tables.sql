-- Operational Tables and Indexes
-- Oracle SQL Script

-- Inventory Movement
CREATE TABLE inventory_movement (
    movement_id NUMBER PRIMARY KEY,
    product_id NUMBER,
    store_id NUMBER,
    movement_type VARCHAR2(20),
    quantity NUMBER,
    reference_id NUMBER,
    reference_type VARCHAR2(20),
    movement_date TIMESTAMP,
    created_by NUMBER,
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_im_product FOREIGN KEY (product_id) 
        REFERENCES products(product_id),
    CONSTRAINT fk_im_store FOREIGN KEY (store_id) 
        REFERENCES stores(store_id),
    CONSTRAINT fk_im_employee FOREIGN KEY (created_by) 
        REFERENCES employees(employee_id)
);

-- Product Returns
CREATE TABLE product_returns (
    return_id NUMBER PRIMARY KEY,
    sale_id NUMBER,
    product_id NUMBER,
    store_id NUMBER,
    customer_id NUMBER,
    return_date TIMESTAMP,
    return_reason VARCHAR2(200),
    quantity NUMBER,
    refund_amount NUMBER(10,2),
    status VARCHAR2(20),
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_pr_sale FOREIGN KEY (sale_id) 
        REFERENCES sales(sale_id),
    CONSTRAINT fk_pr_product FOREIGN KEY (product_id) 
        REFERENCES products(product_id),
    CONSTRAINT fk_pr_store FOREIGN KEY (store_id) 
        REFERENCES stores(store_id),
    CONSTRAINT fk_pr_customer FOREIGN KEY (customer_id) 
        REFERENCES customers(customer_id)
);

-- Product Reviews
CREATE TABLE product_reviews (
    review_id NUMBER PRIMARY KEY,
    product_id NUMBER,
    customer_id NUMBER,
    rating NUMBER,
    review_text VARCHAR2(1000),
    review_date TIMESTAMP,
    is_verified_purchase CHAR(1),
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_rev_product FOREIGN KEY (product_id) 
        REFERENCES products(product_id),
    CONSTRAINT fk_rev_customer FOREIGN KEY (customer_id) 
        REFERENCES customers(customer_id)
);

-- Store Shifts
CREATE TABLE store_shifts (
    shift_id NUMBER PRIMARY KEY,
    store_id NUMBER,
    employee_id NUMBER,
    shift_date DATE,
    start_time TIMESTAMP,
    end_time TIMESTAMP,
    status VARCHAR2(20),
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_ss_store FOREIGN KEY (store_id) 
        REFERENCES stores(store_id),
    CONSTRAINT fk_ss_employee FOREIGN KEY (employee_id) 
        REFERENCES employees(employee_id)
);

-- Product Discounts
CREATE TABLE product_discounts (
    discount_id NUMBER PRIMARY KEY,
    product_id NUMBER,
    discount_type VARCHAR2(20),
    discount_value NUMBER(10,2),
    start_date DATE,
    end_date DATE,
    is_active CHAR(1),
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_pd_product FOREIGN KEY (product_id) 
        REFERENCES products(product_id)
);

-- Create Indexes
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

CREATE INDEX idx_inventory_movement_product ON inventory_movement(product_id);
CREATE INDEX idx_inventory_movement_store ON inventory_movement(store_id);
CREATE INDEX idx_inventory_movement_date ON inventory_movement(movement_date);

CREATE INDEX idx_product_returns_sale ON product_returns(sale_id);
CREATE INDEX idx_product_returns_product ON product_returns(product_id);
CREATE INDEX idx_product_returns_customer ON product_returns(customer_id);

CREATE INDEX idx_product_reviews_product ON product_reviews(product_id);
CREATE INDEX idx_product_reviews_customer ON product_reviews(customer_id);
CREATE INDEX idx_product_reviews_rating ON product_reviews(rating);

CREATE INDEX idx_store_shifts_store ON store_shifts(store_id);
CREATE INDEX idx_store_shifts_employee ON store_shifts(employee_id);
CREATE INDEX idx_store_shifts_date ON store_shifts(shift_date);

CREATE INDEX idx_product_discounts_product ON product_discounts(product_id);
CREATE INDEX idx_product_discounts_dates ON product_discounts(start_date, end_date); 