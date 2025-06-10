-- Function to compute product discount
-- Calculates final price after applying various discount types
CREATE OR REPLACE FUNCTION fn_compute_product_discount(
    p_product_id IN NUMBER,    -- Product ID
    p_quantity   IN NUMBER,    -- Quantity purchased
    p_customer_id IN NUMBER    -- Customer ID for loyalty discounts
) RETURN NUMBER IS
    v_base_price NUMBER;
    v_discount_percent NUMBER;
    v_loyalty_discount NUMBER;
    v_quantity_discount NUMBER;
    v_final_price NUMBER;
BEGIN
    -- Get base price
    SELECT retail_price INTO v_base_price
    FROM products
    WHERE product_id = p_product_id;
    
    -- Calculate loyalty discount (if any)
    SELECT NVL(loyalty_points, 0) * 0.01 INTO v_loyalty_discount
    FROM customers
    WHERE customer_id = p_customer_id;
    
    -- Calculate quantity discount
    IF p_quantity >= 10 THEN
        v_quantity_discount := 0.10;  -- 10% for bulk purchase
    ELSIF p_quantity >= 5 THEN
        v_quantity_discount := 0.05;  -- 5% for medium purchase
    ELSE
        v_quantity_discount := 0;
    END IF;
    
    -- Calculate final price
    v_discount_percent := LEAST(v_loyalty_discount + v_quantity_discount, 0.30); -- Max 30% total discount
    v_final_price := v_base_price * (1 - v_discount_percent);
    
    RETURN v_final_price;
END fn_compute_product_discount;
/ 