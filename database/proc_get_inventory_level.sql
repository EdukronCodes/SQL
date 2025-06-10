-- Procedure to get inventory level
-- This procedure returns detailed inventory information for a product in a store
CREATE OR REPLACE PROCEDURE proc_get_inventory_level(
    p_product_id IN NUMBER,   -- Product ID
    p_store_id   IN NUMBER,   -- Store ID
    p_quantity   OUT NUMBER,  -- Current quantity
    p_status     OUT VARCHAR2 -- Inventory status
) AS
    v_min_stock NUMBER;
    v_max_stock NUMBER;
    v_reorder_point NUMBER;
BEGIN
    -- Get current quantity and stock parameters
    SELECT 
        i.quantity,
        p.min_stock_level,
        p.max_stock_level,
        p.reorder_point
    INTO 
        p_quantity,
        v_min_stock,
        v_max_stock,
        v_reorder_point
    FROM inventory i
    JOIN products p ON i.product_id = p.product_id
    WHERE i.product_id = p_product_id
    AND i.store_id = p_store_id;
    
    -- Determine inventory status
    p_status := CASE
        WHEN p_quantity <= v_min_stock THEN 'CRITICAL'
        WHEN p_quantity <= v_reorder_point THEN 'LOW'
        WHEN p_quantity >= v_max_stock THEN 'EXCESS'
        ELSE 'OPTIMAL'
    END;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_quantity := 0;
        p_status := 'NOT_FOUND';
END proc_get_inventory_level;
/ 