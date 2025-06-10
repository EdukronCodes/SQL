-- Function to calculate product discount
-- Returns the discounted price given a price and discount percent
CREATE OR REPLACE FUNCTION fn_calculate_discount(
    p_price IN NUMBER,         -- Original price
    p_discount_pct IN NUMBER   -- Discount percentage (e.g., 10 for 10%)
) RETURN NUMBER IS
    v_discounted_price NUMBER; -- Variable to hold the discounted price
BEGIN
    -- Calculate the discounted price
    v_discounted_price := p_price - (p_price * p_discount_pct / 100);
    -- Return the discounted price
    RETURN v_discounted_price;
END fn_calculate_discount;
/ 