-- Trigger to log price changes
-- This trigger logs any changes to product prices
CREATE OR REPLACE TRIGGER trg_log_price_changes
AFTER UPDATE OF retail_price ON products
FOR EACH ROW
WHEN (OLD.retail_price != NEW.retail_price)
BEGIN
    -- Insert a log entry into price_history table
    INSERT INTO price_history (
        history_id,
        product_id,
        old_price,
        new_price,
        change_date,
        change_percentage
    ) VALUES (
        price_history_seq.NEXTVAL,
        :NEW.product_id,
        :OLD.retail_price,
        :NEW.retail_price,
        SYSDATE,
        ((:NEW.retail_price - :OLD.retail_price) / :OLD.retail_price) * 100
    );
END;
/ 