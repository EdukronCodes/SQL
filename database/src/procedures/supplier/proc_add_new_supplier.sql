-- Procedure to add a new supplier
-- This procedure handles supplier creation with validation and initialization
CREATE OR REPLACE PROCEDURE proc_add_new_supplier(
    p_supplier_id    IN NUMBER,      -- Supplier ID
    p_supplier_name  IN VARCHAR2,    -- Supplier name
    p_contact_name   IN VARCHAR2,    -- Contact name
    p_email          IN VARCHAR2,    -- Email
    p_phone          IN VARCHAR2,    -- Phone
    p_address_line1  IN VARCHAR2,    -- Address
    p_city           IN VARCHAR2,    -- City
    p_state          IN VARCHAR2,    -- State
    p_country        IN VARCHAR2,    -- Country
    p_postal_code    IN VARCHAR2,    -- Postal code
    p_payment_terms  IN VARCHAR2     -- Payment terms
) AS
    v_email_count NUMBER;
    v_phone_count NUMBER;
BEGIN
    -- Validate email uniqueness
    SELECT COUNT(*) INTO v_email_count
    FROM suppliers
    WHERE email = p_email;
    
    IF v_email_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20012, 'Supplier email already exists');
    END IF;
    
    -- Validate phone uniqueness
    SELECT COUNT(*) INTO v_phone_count
    FROM suppliers
    WHERE phone = p_phone;
    
    IF v_phone_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20013, 'Supplier phone number already exists');
    END IF;
    
    -- Insert new supplier
    INSERT INTO suppliers (
        supplier_id,
        supplier_name,
        contact_name,
        email,
        phone,
        address_line1,
        city,
        state,
        country,
        postal_code,
        payment_terms,
        status,
        created_date
    ) VALUES (
        p_supplier_id,
        p_supplier_name,
        p_contact_name,
        p_email,
        p_phone,
        p_address_line1,
        p_city,
        p_state,
        p_country,
        p_postal_code,
        p_payment_terms,
        'ACTIVE',
        SYSDATE
    );
    
    -- Initialize supplier performance metrics
    INSERT INTO supplier_performance (
        supplier_id,
        total_orders,
        total_spend,
        average_delivery_time,
        quality_rating,
        last_order_date
    ) VALUES (
        p_supplier_id,
        0,
        0,
        0,
        5.0,
        NULL
    );
    
    COMMIT;
END proc_add_new_supplier;
/ 