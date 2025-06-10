-- Procedure to delete a product
-- This procedure handles product deletion with validation and cleanup
CREATE OR REPLACE PROCEDURE proc_delete_product(
    p_product_id IN NUMBER,   -- Product ID to delete
    p_force      IN BOOLEAN   -- Force delete even if product has sales history
) AS
    v_has_sales NUMBER;
    v_has_inventory NUMBER;
BEGIN
    -- Check if product has sales history
    SELECT COUNT(*) INTO v_has_sales
    FROM sales_items
    WHERE product_id = p_product_id;
    
    -- Check if product has inventory
    SELECT COUNT(*) INTO v_has_inventory
    FROM inventory
    WHERE product_id = p_product_id
    AND quantity > 0;
    
    -- Validate deletion
    IF v_has_sales > 0 AND NOT p_force THEN
        RAISE_APPLICATION_ERROR(-20004, 'Cannot delete product with sales history');
    END IF;
    
    IF v_has_inventory > 0 AND NOT p_force THEN
        RAISE_APPLICATION_ERROR(-20005, 'Cannot delete product with existing inventory');
    END IF;
    
    -- Log the deletion
    INSERT INTO product_deletion_log (
        log_id,
        product_id,
        deletion_date,
        deletion_reason,
        has_sales_history,
        has_inventory
    ) VALUES (
        product_deletion_seq.NEXTVAL,
        p_product_id,
        SYSDATE,
        CASE 
            WHEN p_force THEN 'Forced deletion'
            ELSE 'Normal deletion'
        END,
        v_has_sales > 0,
        v_has_inventory > 0
    );
    
    -- Delete the product
    DELETE FROM products
    WHERE product_id = p_product_id;
    
    COMMIT;
END proc_delete_product;
/ 