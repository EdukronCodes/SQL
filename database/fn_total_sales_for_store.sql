-- Function to calculate total sales for a store
-- Returns the total sales amount for a given store
CREATE OR REPLACE FUNCTION fn_total_sales_for_store(
    p_store_id IN NUMBER   -- Store ID
) RETURN NUMBER IS
    v_total_sales NUMBER;  -- Variable to hold the total sales
BEGIN
    -- Calculate the sum of total_amount from sales for the store
    SELECT NVL(SUM(total_amount), 0) INTO v_total_sales
    FROM sales
    WHERE store_id = p_store_id;
    -- Return the total sales
    RETURN v_total_sales;
END fn_total_sales_for_store;
/ 