-- Function to get product stock in a store
-- Returns the quantity of a product in a specific store
CREATE OR REPLACE FUNCTION fn_get_product_stock(
    p_product_id IN NUMBER,   -- Product ID
    p_store_id   IN NUMBER    -- Store ID
) RETURN NUMBER IS
    v_quantity NUMBER;        -- Variable to hold the quantity
BEGIN
    -- Select the quantity from inventory
    SELECT quantity INTO v_quantity
    FROM inventory
    WHERE product_id = p_product_id
      AND store_id = p_store_id;
    -- Return the quantity
    RETURN v_quantity;
EXCEPTION
    -- If no record found, return 0
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
END fn_get_product_stock;
/ 