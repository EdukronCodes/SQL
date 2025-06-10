-- Procedure to get low stock products
-- This procedure identifies products that need reordering
CREATE OR REPLACE PROCEDURE proc_get_low_stock_products(
    p_store_id IN NUMBER,    -- Store ID (NULL for all stores)
    p_cursor   OUT SYS_REFCURSOR  -- Cursor with low stock products
) AS
BEGIN
    -- Open cursor with low stock products
    OPEN p_cursor FOR
        SELECT 
            p.product_id,
            p.product_name,
            p.sku,
            i.store_id,
            s.store_name,
            i.quantity,
            p.reorder_point,
            p.min_stock_level,
            p.max_stock_level,
            p.supplier_id,
            sup.supplier_name,
            sup.contact_phone,
            CASE 
                WHEN i.quantity <= p.min_stock_level THEN 'CRITICAL'
                WHEN i.quantity <= p.reorder_point THEN 'LOW'
                ELSE 'WARNING'
            END as stock_status,
            p.unit_cost,
            p.retail_price,
            (p.retail_price - p.unit_cost) as profit_margin
        FROM products p
        JOIN inventory i ON p.product_id = i.product_id
        JOIN stores s ON i.store_id = s.store_id
        JOIN suppliers sup ON p.supplier_id = sup.supplier_id
        WHERE (p_store_id IS NULL OR i.store_id = p_store_id)
        AND i.quantity <= p.reorder_point
        ORDER BY 
            CASE 
                WHEN i.quantity <= p.min_stock_level THEN 1
                WHEN i.quantity <= p.reorder_point THEN 2
                ELSE 3
            END,
            i.quantity;
END proc_get_low_stock_products;
/ 