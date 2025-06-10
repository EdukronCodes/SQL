-- Trigger to validate sale dates
-- This trigger ensures sale dates are not in the future
CREATE OR REPLACE TRIGGER trg_validate_sale_date
BEFORE INSERT OR UPDATE ON sales
FOR EACH ROW
BEGIN
    -- Check if sale date is in the future
    IF :NEW.sale_date > SYSDATE THEN
        RAISE_APPLICATION_ERROR(-20002, 'Sale date cannot be in the future.');
    END IF;
    
    -- Check if sale date is too old (e.g., more than 1 year)
    IF :NEW.sale_date < ADD_MONTHS(SYSDATE, -12) THEN
        RAISE_APPLICATION_ERROR(-20003, 'Sale date cannot be more than 1 year old.');
    END IF;
END;
/ 