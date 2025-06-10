-- Trigger to set default loyalty points for new customers
-- This trigger sets loyalty_points to 0 if not provided
CREATE OR REPLACE TRIGGER trg_default_loyalty_points
BEFORE INSERT ON customers
FOR EACH ROW
BEGIN
    -- If loyalty_points is null, set it to 0
    IF :NEW.loyalty_points IS NULL THEN
        :NEW.loyalty_points := 0;
    END IF;
END;
/ 