-- Function to retrieve product inventory details
-- Returns comprehensive inventory information for a product in a specific store
CREATE OR REPLACE FUNCTION fn_retrieve_product_inventory(
    p_product_id IN NUMBER,   -- Product ID
    p_store_id   IN NUMBER    -- Store ID
) RETURN SYS_REFCURSOR IS
    v_inventory_cursor SYS_REFCURSOR;
BEGIN
    -- Open cursor with detailed inventory information
    OPEN v_inventory_cursor FOR
        SELECT 
            i.quantity,
            i.last_restock_date,
            i.last_audit_date,
            i.location_in_store,
            i.condition,
            p.product_name,
            p.sku,
            p.retail_price,
            p.reorder_point,
            p.max_stock_level
        FROM inventory i
        JOIN products p ON i.product_id = p.product_id
        WHERE i.product_id = p_product_id
        AND i.store_id = p_store_id;
    
    RETURN v_inventory_cursor;
END fn_retrieve_product_inventory;
/ 