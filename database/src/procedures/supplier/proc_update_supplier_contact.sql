-- Procedure to update supplier contact information
-- This procedure handles supplier contact updates with validation and history tracking
CREATE OR REPLACE PROCEDURE proc_update_supplier_contact(
    p_supplier_id    IN NUMBER,      -- Supplier ID
    p_contact_name   IN VARCHAR2,    -- New contact name
    p_email          IN VARCHAR2,    -- New email
    p_phone          IN VARCHAR2,    -- New phone
    p_user_id        IN NUMBER       -- User making the change
) AS
    v_email_count NUMBER;
    v_phone_count NUMBER;
    v_old_contact_name VARCHAR2(100);
    v_old_email VARCHAR2(100);
    v_old_phone VARCHAR2(20);
BEGIN
    -- Get current contact information
    SELECT contact_name, email, phone
    INTO v_old_contact_name, v_old_email, v_old_phone
    FROM suppliers
    WHERE supplier_id = p_supplier_id;
    
    -- Validate email uniqueness if changed
    IF p_email != v_old_email THEN
        SELECT COUNT(*) INTO v_email_count
        FROM suppliers
        WHERE email = p_email;
        
        IF v_email_count > 0 THEN
            RAISE_APPLICATION_ERROR(-20012, 'Supplier email already exists');
        END IF;
    END IF;
    
    -- Validate phone uniqueness if changed
    IF p_phone != v_old_phone THEN
        SELECT COUNT(*) INTO v_phone_count
        FROM suppliers
        WHERE phone = p_phone;
        
        IF v_phone_count > 0 THEN
            RAISE_APPLICATION_ERROR(-20013, 'Supplier phone number already exists');
        END IF;
    END IF;
    
    -- Update supplier contact information
    UPDATE suppliers
    SET contact_name = p_contact_name,
        email = p_email,
        phone = p_phone,
        last_updated = SYSDATE
    WHERE supplier_id = p_supplier_id;
    
    -- Log contact information changes
    INSERT INTO supplier_contact_history (
        supplier_id,
        old_contact_name,
        new_contact_name,
        old_email,
        new_email,
        old_phone,
        new_phone,
        changed_by,
        change_date
    ) VALUES (
        p_supplier_id,
        v_old_contact_name,
        p_contact_name,
        v_old_email,
        p_email,
        v_old_phone,
        p_phone,
        p_user_id,
        SYSDATE
    );
    
    COMMIT;
END proc_update_supplier_contact;
/ 