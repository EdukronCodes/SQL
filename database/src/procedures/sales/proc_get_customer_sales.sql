-- Procedure to get customer sales history
-- This procedure returns detailed sales history for a customer
CREATE OR REPLACE PROCEDURE proc_get_customer_sales(
    p_customer_id IN NUMBER,    -- Customer ID
    p_start_date IN DATE,       -- Start date for analysis
    p_end_date IN DATE,         -- End date for analysis
    p_cursor OUT SYS_REFCURSOR  -- Cursor with sales history
) AS
BEGIN
    -- Open cursor with detailed sales history
    OPEN p_cursor FOR
        SELECT 
            s.sale_id,
            s.sale_date,
            s.store_id,
            st.store_name,
            s.total_amount,
            s.payment_method,
            s.discount_amount,
            s.tax_amount,
            s.sale_status,
            e.employee_id,
            e.first_name || ' ' || e.last_name as employee_name,
            (
                SELECT COUNT(*)
                FROM sales_items si
                WHERE si.sale_id = s.sale_id
            ) as total_items,
            (
                SELECT SUM(si.quantity)
                FROM sales_items si
                WHERE si.sale_id = s.sale_id
            ) as total_quantity,
            c.loyalty_points,
            CASE 
                WHEN c.loyalty_points < 1000 THEN 'BRONZE'
                WHEN c.loyalty_points < 5000 THEN 'SILVER'
                ELSE 'GOLD'
            END as loyalty_tier
        FROM sales s
        JOIN stores st ON s.store_id = st.store_id
        JOIN employees e ON s.employee_id = e.employee_id
        JOIN customers c ON s.customer_id = c.customer_id
        WHERE s.customer_id = p_customer_id
        AND s.sale_date BETWEEN p_start_date AND p_end_date
        ORDER BY s.sale_date DESC;
END proc_get_customer_sales;
/ 