-- Function to get product sales history
-- Returns a cursor with sales history for a product
CREATE OR REPLACE FUNCTION fn_get_product_sales_history(
    p_product_id IN NUMBER,
    p_start_date IN DATE,
    p_end_date IN DATE
) RETURN SYS_REFCURSOR IS
    v_sales_cursor SYS_REFCURSOR;
BEGIN
    -- Open cursor with sales history
    OPEN v_sales_cursor FOR
        SELECT 
            s.sale_date,
            s.store_id,
            si.quantity,
            si.unit_price,
            si.total_amount
        FROM sales s
        JOIN sales_items si ON s.sale_id = si.sale_id
        WHERE si.product_id = p_product_id
        AND s.sale_date BETWEEN p_start_date AND p_end_date
        ORDER BY s.sale_date;
    
    RETURN v_sales_cursor;
END fn_get_product_sales_history;
/ 