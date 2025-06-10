-- Procedure to update inventory quantity
-- This procedure handles inventory updates with validation and movement tracking
CREATE OR REPLACE PROCEDURE proc_update_inventory_quantity(
    p_product_id IN NUMBER,    -- Product ID
    p_store_id   IN NUMBER,    -- Store ID
    p_quantity   IN NUMBER,    -- New quantity
    p_reason     IN VARCHAR2,  -- Reason for update
    p_user_id    IN NUMBER     -- User performing the update
) AS
    v_old_quantity NUMBER;
    v_product_name VARCHAR2(100);
BEGIN
    -- Get current quantity and product name
    SELECT i.quantity, p.product_name
    INTO v_old_quantity, v_product_name
    FROM inventory i
    JOIN products p ON i.product_id = p.product_id
    WHERE i.product_id = p_product_id
    AND i.store_id = p_store_id;
    
    -- Validate new quantity
    IF p_quantity < 0 THEN
        RAISE_APPLICATION_ERROR(-20006, 'Quantity cannot be negative');
    END IF;
    
    -- Update inventory
    UPDATE inventory
    SET quantity = p_quantity,
        last_audit_date = SYSDATE
    WHERE product_id = p_product_id
    AND store_id = p_store_id;
    
    -- Log inventory movement
    INSERT INTO inventory_movements (
        movement_id,
        product_id,
        store_id,
        old_quantity,
        new_quantity,
        movement_date,
        movement_type,
        reason,
        user_id
    ) VALUES (
        inventory_movement_seq.NEXTVAL,
        p_product_id,
        p_store_id,
        v_old_quantity,
        p_quantity,
        SYSDATE,
        CASE 
            WHEN p_quantity > v_old_quantity THEN 'ADJUSTMENT_IN'
            ELSE 'ADJUSTMENT_OUT'
        END,
        p_reason,
        p_user_id
    );
    
    COMMIT;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20007, 'Product not found in store inventory');
END proc_update_inventory_quantity;
/ 