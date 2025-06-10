-- Function to get store inventory summary
-- Returns a cursor with inventory summary for a store
CREATE OR REPLACE FUNCTION fn_get_store_inventory_summary(
    p_store_id IN NUMBER
) RETURN SYS_REFCURSOR IS
    v_inventory_cursor SYS_REFCURSOR;
BEGIN
    -- Open cursor with inventory summary
    OPEN v_inventory_cursor FOR
        SELECT 
            p.product_id,
            p.product_name,
            i.quantity,
            p.retail_price,
            (i.quantity * p.retail_price) as total_value,
            p.reorder_point,
            CASE 
                WHEN i.quantity <= p.reorder_point THEN 'LOW'
                WHEN i.quantity >= p.max_stock_level THEN 'HIGH'
                ELSE 'OK'
            END as stock_status
        FROM inventory i
        JOIN products p ON i.product_id = p.product_id
        WHERE i.store_id = p_store_id
        ORDER BY p.product_name;
    
    RETURN v_inventory_cursor;
END fn_get_store_inventory_summary;
/ 