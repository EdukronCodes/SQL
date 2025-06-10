-- Procedure to update store manager
-- This procedure handles store manager updates with validation and history tracking
CREATE OR REPLACE PROCEDURE proc_update_store_manager(
    p_store_id       IN NUMBER,      -- Store ID
    p_new_manager_id IN NUMBER,      -- New manager ID
    p_effective_date IN DATE,        -- Effective date
    p_user_id        IN NUMBER       -- User making the change
) AS
    v_old_manager_id NUMBER;
    v_manager_exists NUMBER;
    v_store_exists NUMBER;
BEGIN
    -- Validate store exists
    SELECT COUNT(*) INTO v_store_exists
    FROM stores
    WHERE store_id = p_store_id;
    
    IF v_store_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20021, 'Store ID does not exist');
    END IF;
    
    -- Get current manager
    SELECT store_manager_id
    INTO v_old_manager_id
    FROM stores
    WHERE store_id = p_store_id;
    
    -- Validate new manager exists
    SELECT COUNT(*) INTO v_manager_exists
    FROM employees
    WHERE employee_id = p_new_manager_id;
    
    IF v_manager_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20020, 'New manager ID does not exist');
    END IF;
    
    -- Update store manager
    UPDATE stores
    SET store_manager_id = p_new_manager_id,
        last_updated = SYSDATE
    WHERE store_id = p_store_id;
    
    -- Log manager changes
    INSERT INTO store_manager_history (
        store_id,
        old_manager_id,
        new_manager_id,
        effective_date,
        changed_by,
        change_date
    ) VALUES (
        p_store_id,
        v_old_manager_id,
        p_new_manager_id,
        p_effective_date,
        p_user_id,
        SYSDATE
    );
    
    -- Update employee records
    UPDATE employees
    SET manager_id = p_new_manager_id
    WHERE store_id = p_store_id
    AND manager_id = v_old_manager_id;
    
    -- Update store performance metrics
    UPDATE store_performance
    SET last_audit_date = SYSDATE
    WHERE store_id = p_store_id;
    
    COMMIT;
END proc_update_store_manager;
/ 