-- Trigger to update customer loyalty points on sale
-- This trigger updates customer loyalty points when a sale is completed
CREATE OR REPLACE TRIGGER trg_update_loyalty_on_sale
AFTER INSERT ON sales
FOR EACH ROW
BEGIN
    -- Calculate loyalty points (1 point per $10 spent)
    UPDATE customers
    SET loyalty_points = loyalty_points + FLOOR(:NEW.total_amount / 10)
    WHERE customer_id = :NEW.customer_id;
END;
/ 