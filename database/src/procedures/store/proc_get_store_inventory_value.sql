-- Procedure to get store inventory value
-- This procedure retrieves detailed inventory value information for a store
CREATE OR REPLACE PROCEDURE proc_get_store_inventory_value(
    p_store_id IN NUMBER,            -- Store ID
    p_cursor OUT SYS_REFCURSOR      -- Cursor for results
) AS
BEGIN
    OPEN p_cursor FOR
        WITH inventory_summary AS (
            SELECT 
                i.store_id,
                COUNT(DISTINCT i.product_id) as total_products,
                SUM(i.quantity) as total_quantity,
                SUM(i.quantity * p.unit_cost) as total_cost,
                SUM(i.quantity * p.retail_price) as total_retail_value,
                SUM(i.quantity * (p.retail_price - p.unit_cost)) as potential_profit
            FROM inventory i
            JOIN products p ON i.product_id = p.product_id
            WHERE i.store_id = p_store_id
            GROUP BY i.store_id
        ),
        category_summary AS (
            SELECT 
                i.store_id,
                c.category_name,
                COUNT(DISTINCT i.product_id) as product_count,
                SUM(i.quantity) as total_quantity,
                SUM(i.quantity * p.unit_cost) as total_cost,
                SUM(i.quantity * p.retail_price) as total_retail_value
            FROM inventory i
            JOIN products p ON i.product_id = p.product_id
            JOIN categories c ON p.category_id = c.category_id
            WHERE i.store_id = p_store_id
            GROUP BY i.store_id, c.category_name
        ),
        low_stock_items AS (
            SELECT 
                i.store_id,
                COUNT(*) as low_stock_count,
                SUM(p.unit_cost * (p.reorder_point - i.quantity)) as reorder_cost
            FROM inventory i
            JOIN products p ON i.product_id = p.product_id
            WHERE i.store_id = p_store_id
            AND i.quantity < p.reorder_point
            GROUP BY i.store_id
        )
        SELECT 
            s.store_name,
            s.store_type,
            s.store_size,
            is.total_products,
            is.total_quantity,
            is.total_cost,
            is.total_retail_value,
            is.potential_profit,
            ls.low_stock_count,
            ls.reorder_cost,
            -- Category breakdown
            (SELECT JSON_ARRAYAGG(
                JSON_OBJECT(
                    'category_name' VALUE cs.category_name,
                    'product_count' VALUE cs.product_count,
                    'total_quantity' VALUE cs.total_quantity,
                    'total_cost' VALUE cs.total_cost,
                    'total_retail_value' VALUE cs.total_retail_value
                )
            ) FROM category_summary cs WHERE cs.store_id = s.store_id) as category_breakdown,
            -- Recent inventory movements
            (SELECT JSON_ARRAYAGG(
                JSON_OBJECT(
                    'movement_date' VALUE TO_CHAR(im.movement_date, 'YYYY-MM-DD'),
                    'movement_type' VALUE im.movement_type,
                    'quantity' VALUE im.quantity,
                    'product_name' VALUE p.product_name
                )
            ) FROM inventory_movements im
            JOIN products p ON im.product_id = p.product_id
            WHERE im.store_id = s.store_id
            AND im.movement_date >= TRUNC(SYSDATE) - 7) as recent_movements,
            -- Store performance
            sp.total_sales as last_30_days_sales,
            sp.total_transactions as last_30_days_transactions,
            sp.average_transaction_value,
            sp.customer_satisfaction_score
        FROM stores s
        LEFT JOIN inventory_summary is ON s.store_id = is.store_id
        LEFT JOIN low_stock_items ls ON s.store_id = ls.store_id
        LEFT JOIN store_performance sp ON s.store_id = sp.store_id
        WHERE s.store_id = p_store_id;
END proc_get_store_inventory_value;
/ 