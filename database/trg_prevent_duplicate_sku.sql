-- Trigger to prevent duplicate product SKUs
-- This trigger ensures no duplicate SKUs are inserted or updated
CREATE OR REPLACE TRIGGER trg_prevent_duplicate_sku
BEFORE INSERT OR UPDATE OF sku ON products
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    -- Check if SKU already exists
    SELECT COUNT(*)
    INTO v_count
    FROM products
    WHERE sku = :NEW.sku
    AND product_id != NVL(:NEW.product_id, -1);
    
    -- If SKU exists, raise error
    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20004, 'Duplicate SKU not allowed.');
    END IF;
END;
/ 