-- Trigger to audit employee updates
-- This trigger logs changes to employee records
CREATE OR REPLACE TRIGGER trg_audit_employee_update
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
    -- Insert a log entry into a hypothetical employee_audit table
    INSERT INTO employee_audit (audit_id, employee_id, old_position, new_position, change_date)
    VALUES (employee_audit_seq.NEXTVAL, :OLD.employee_id, :OLD.position, :NEW.position, SYSDATE);
END;
/ 