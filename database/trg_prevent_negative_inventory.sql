-- Trigger to prevent negative inventory
-- This trigger raises an error if an update would result in negative inventory
CREATE OR REPLACE TRIGGER trg_prevent_negative_inventory
BEFORE UPDATE ON inventory
FOR EACH ROW
BEGIN
    -- Check if the new quantity is negative
    IF :NEW.quantity < 0 THEN
        -- Raise an application error if negative
        RAISE_APPLICATION_ERROR(-20001, 'Inventory quantity cannot be negative.');
    END IF;
END;
/ 