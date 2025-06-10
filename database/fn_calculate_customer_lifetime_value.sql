-- Function to calculate customer lifetime value
-- Returns the total value of a customer's purchases
CREATE OR REPLACE FUNCTION fn_calculate_customer_lifetime_value(
    p_customer_id IN NUMBER
) RETURN NUMBER IS
    v_lifetime_value NUMBER;
BEGIN
    -- Calculate total purchases
    SELECT NVL(SUM(total_amount), 0)
    INTO v_lifetime_value
    FROM sales
    WHERE customer_id = p_customer_id;
    
    RETURN v_lifetime_value;
END fn_calculate_customer_lifetime_value;
/ 