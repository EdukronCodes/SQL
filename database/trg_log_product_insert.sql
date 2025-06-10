-- Trigger to log product insertions
-- This trigger logs every new product added to the products table
CREATE OR REPLACE TRIGGER trg_log_product_insert
AFTER INSERT ON products
FOR EACH ROW
BEGIN
    -- Insert a log entry into a hypothetical product_log table
    INSERT INTO product_log (log_id, product_id, action, log_date)
    VALUES (product_log_seq.NEXTVAL, :NEW.product_id, 'INSERT', SYSDATE);
END;
/ 