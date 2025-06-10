-- Procedure to get product sales
-- This procedure returns sales statistics for a product
CREATE OR REPLACE PROCEDURE proc_get_product_sales(
    p_product_id IN NUMBER,    -- Product ID
    p_start_date IN DATE,      -- Start date for analysis
    p_end_date IN DATE,        -- End date for analysis
    p_total_sales OUT NUMBER,  -- Total sales amount
    p_total_units OUT NUMBER,  -- Total units sold
    p_avg_price OUT NUMBER     -- Average selling price
) AS
BEGIN
    -- Calculate sales statistics
    SELECT 
        NVL(SUM(total_amount), 0),
        NVL(SUM(quantity), 0),
        NVL(AVG(unit_price), 0)
    INTO 
        p_total_sales,
        p_total_units,
        p_avg_price
    FROM sales_items si
    JOIN sales s ON si.sale_id = s.sale_id
    WHERE si.product_id = p_product_id
    AND s.sale_date BETWEEN p_start_date AND p_end_date;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_total_sales := 0;
        p_total_units := 0;
        p_avg_price := 0;
END proc_get_product_sales;
/ 