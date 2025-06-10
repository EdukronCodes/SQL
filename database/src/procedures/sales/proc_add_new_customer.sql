-- Procedure to add a new customer
-- This procedure handles customer creation with validation and initialization
CREATE OR REPLACE PROCEDURE proc_add_new_customer(
    p_customer_id      IN NUMBER,      -- Customer ID
    p_first_name       IN VARCHAR2,    -- First name
    p_last_name        IN VARCHAR2,    -- Last name
    p_email            IN VARCHAR2,    -- Email
    p_phone            IN VARCHAR2,    -- Phone
    p_address_line1    IN VARCHAR2,    -- Address
    p_city             IN VARCHAR2,    -- City
    p_state            IN VARCHAR2,    -- State
    p_country          IN VARCHAR2,    -- Country
    p_postal_code      IN VARCHAR2,    -- Postal code
    p_preferred_store  IN NUMBER       -- Preferred store ID
) AS
    v_email_count NUMBER;
    v_phone_count NUMBER;
BEGIN
    -- Validate email uniqueness
    SELECT COUNT(*) INTO v_email_count
    FROM customers
    WHERE email = p_email;
    
    IF v_email_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20008, 'Email already exists');
    END IF;
    
    -- Validate phone uniqueness
    SELECT COUNT(*) INTO v_phone_count
    FROM customers
    WHERE phone = p_phone;
    
    IF v_phone_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20009, 'Phone number already exists');
    END IF;
    
    -- Insert new customer
    INSERT INTO customers (
        customer_id,
        first_name,
        last_name,
        email,
        phone,
        address_line1,
        city,
        state,
        country,
        postal_code,
        customer_since,
        loyalty_points,
        preferred_store_id
    ) VALUES (
        p_customer_id,
        p_first_name,
        p_last_name,
        p_email,
        p_phone,
        p_address_line1,
        p_city,
        p_state,
        p_country,
        p_postal_code,
        SYSDATE,
        0,
        p_preferred_store
    );
    
    -- Initialize customer preferences
    INSERT INTO customer_preferences (
        customer_id,
        preference_type,
        preference_value,
        created_date
    ) VALUES (
        p_customer_id,
        'COMMUNICATION',
        'EMAIL',
        SYSDATE
    );
    
    COMMIT;
END proc_add_new_customer;
/ 