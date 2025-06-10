-- Procedure to add a new product to the inventory system
-- This procedure handles the creation of new products with validation
CREATE OR REPLACE PROCEDURE proc_add_new_product(
    p_product_id      IN NUMBER,      -- Product ID
    p_product_name    IN VARCHAR2,    -- Product name
    p_product_desc    IN VARCHAR2,    -- Product description
    p_sku             IN VARCHAR2,    -- SKU
    p_upc             IN VARCHAR2,    -- UPC
    p_brand_id        IN NUMBER,      -- Brand ID (FK)
    p_category_id     IN NUMBER,      -- Category ID (FK)
    p_supplier_id     IN NUMBER,      -- Supplier ID (FK)
    p_unit_cost       IN NUMBER,      -- Unit cost
    p_retail_price    IN NUMBER,      -- Retail price
    p_min_stock       IN NUMBER,      -- Minimum stock level
    p_max_stock       IN NUMBER,      -- Maximum stock level
    p_reorder_point   IN NUMBER,      -- Reorder point
    p_weight          IN NUMBER,      -- Weight
    p_dimensions      IN VARCHAR2,    -- Dimensions
    p_is_active       IN CHAR         -- Is active (Y/N)
) AS
    v_count NUMBER;
BEGIN
    -- Validate SKU uniqueness
    SELECT COUNT(*) INTO v_count
    FROM products
    WHERE sku = p_sku;
    
    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'SKU already exists');
    END IF;
    
    -- Validate price
    IF p_retail_price <= p_unit_cost THEN
        RAISE_APPLICATION_ERROR(-20002, 'Retail price must be greater than unit cost');
    END IF;
    
    -- Insert the new product
    INSERT INTO products (
        product_id, product_name, product_description, sku, upc, 
        brand_id, category_id, supplier_id, unit_cost, retail_price,
        min_stock_level, max_stock_level, reorder_point, weight, 
        dimensions, is_active
    ) VALUES (
        p_product_id, p_product_name, p_product_desc, p_sku, p_upc,
        p_brand_id, p_category_id, p_supplier_id, p_unit_cost, p_retail_price,
        p_min_stock, p_max_stock, p_reorder_point, p_weight,
        p_dimensions, p_is_active
    );
    
    -- Initialize inventory for all stores
    FOR store_rec IN (SELECT store_id FROM stores) LOOP
        INSERT INTO inventory (
            product_id, store_id, quantity, last_restock_date
        ) VALUES (
            p_product_id, store_rec.store_id, 0, SYSDATE
        );
    END LOOP;
    
    COMMIT;
END proc_add_new_product;
/ 