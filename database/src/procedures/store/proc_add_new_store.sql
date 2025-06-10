-- Procedure to add a new store
-- This procedure handles store creation with validation and initialization
CREATE OR REPLACE PROCEDURE proc_add_new_store(
    p_store_id       IN NUMBER,      -- Store ID
    p_store_name     IN VARCHAR2,    -- Store name
    p_store_type     IN VARCHAR2,    -- Store type
    p_address_line1  IN VARCHAR2,    -- Address
    p_city           IN VARCHAR2,    -- City
    p_state          IN VARCHAR2,    -- State
    p_country        IN VARCHAR2,    -- Country
    p_postal_code    IN VARCHAR2,    -- Postal code
    p_phone          IN VARCHAR2,    -- Phone
    p_email          IN VARCHAR2,    -- Email
    p_opening_date   IN DATE,        -- Opening date
    p_store_size     IN NUMBER,      -- Store size
    p_store_manager_id IN NUMBER     -- Store manager ID
) AS
    v_email_count NUMBER;
    v_phone_count NUMBER;
    v_manager_exists NUMBER;
BEGIN
    -- Validate email uniqueness
    SELECT COUNT(*) INTO v_email_count
    FROM stores
    WHERE email = p_email;
    
    IF v_email_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20018, 'Store email already exists');
    END IF;
    
    -- Validate phone uniqueness
    SELECT COUNT(*) INTO v_phone_count
    FROM stores
    WHERE phone = p_phone;
    
    IF v_phone_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20019, 'Store phone number already exists');
    END IF;
    
    -- Validate manager exists if provided
    IF p_store_manager_id IS NOT NULL THEN
        SELECT COUNT(*) INTO v_manager_exists
        FROM employees
        WHERE employee_id = p_store_manager_id;
        
        IF v_manager_exists = 0 THEN
            RAISE_APPLICATION_ERROR(-20020, 'Store manager ID does not exist');
        END IF;
    END IF;
    
    -- Insert new store
    INSERT INTO stores (
        store_id,
        store_name,
        store_type,
        address_line1,
        city,
        state,
        country,
        postal_code,
        phone,
        email,
        opening_date,
        store_size,
        store_manager_id,
        status,
        created_date
    ) VALUES (
        p_store_id,
        p_store_name,
        p_store_type,
        p_address_line1,
        p_city,
        p_state,
        p_country,
        p_postal_code,
        p_phone,
        p_email,
        p_opening_date,
        p_store_size,
        p_store_manager_id,
        'ACTIVE',
        SYSDATE
    );
    
    -- Initialize store performance metrics
    INSERT INTO store_performance (
        store_id,
        total_sales,
        total_transactions,
        average_transaction_value,
        customer_satisfaction_score,
        last_audit_date
    ) VALUES (
        p_store_id,
        0,
        0,
        0,
        5.0,
        NULL
    );
    
    -- Initialize store inventory
    INSERT INTO store_inventory (
        store_id,
        total_products,
        total_value,
        last_restock_date,
        last_audit_date
    ) VALUES (
        p_store_id,
        0,
        0,
        NULL,
        NULL
    );
    
    -- Initialize store operating hours
    INSERT INTO store_hours (
        store_id,
        day_of_week,
        open_time,
        close_time,
        is_closed
    )
    SELECT 
        p_store_id,
        day_name,
        TO_DATE('09:00', 'HH24:MI'),
        TO_DATE('21:00', 'HH24:MI'),
        CASE WHEN day_name IN ('Sunday') THEN 1 ELSE 0 END
    FROM (
        SELECT 'Monday' as day_name FROM dual UNION ALL
        SELECT 'Tuesday' FROM dual UNION ALL
        SELECT 'Wednesday' FROM dual UNION ALL
        SELECT 'Thursday' FROM dual UNION ALL
        SELECT 'Friday' FROM dual UNION ALL
        SELECT 'Saturday' FROM dual UNION ALL
        SELECT 'Sunday' FROM dual
    );
    
    COMMIT;
END proc_add_new_store;
/ 