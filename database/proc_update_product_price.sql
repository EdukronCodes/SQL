-- Procedure to update product price
-- This procedure handles price updates with validation and history tracking
CREATE OR REPLACE PROCEDURE proc_update_product_price(
    p_product_id   IN NUMBER,    -- Product ID
    p_new_price    IN NUMBER,    -- New retail price
    p_reason       IN VARCHAR2   -- Reason for price change
) AS
    v_old_price NUMBER;
    v_unit_cost NUMBER;
BEGIN
    -- Get current price and unit cost
    SELECT retail_price, unit_cost 
    INTO v_old_price, v_unit_cost
    FROM products
    WHERE product_id = p_product_id;
    
    -- Validate new price
    IF p_new_price <= v_unit_cost THEN
        RAISE_APPLICATION_ERROR(-20003, 'New price must be greater than unit cost');
    END IF;
    
    -- Update the price
    UPDATE products
    SET retail_price = p_new_price
    WHERE product_id = p_product_id;
    
    -- Log the price change
    INSERT INTO price_history (
        history_id,
        product_id,
        old_price,
        new_price,
        change_date,
        change_reason,
        change_percentage
    ) VALUES (
        price_history_seq.NEXTVAL,
        p_product_id,
        v_old_price,
        p_new_price,
        SYSDATE,
        p_reason,
        ((p_new_price - v_old_price) / v_old_price) * 100
    );
    
    COMMIT;
END proc_update_product_price;
/ 