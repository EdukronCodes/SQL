-- Function to get customer full name
-- Returns the full name of a customer given their ID
CREATE OR REPLACE FUNCTION fn_get_customer_full_name(
    p_customer_id IN NUMBER   -- Customer ID
) RETURN VARCHAR2 IS
    v_full_name VARCHAR2(200); -- Variable to hold the full name
BEGIN
    -- Select the full name from customers
    SELECT first_name || ' ' || last_name INTO v_full_name
    FROM customers
    WHERE customer_id = p_customer_id;
    -- Return the full name
    RETURN v_full_name;
EXCEPTION
    -- If no record found, return NULL
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
END fn_get_customer_full_name;
/ 