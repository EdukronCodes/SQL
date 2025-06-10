-- Trigger to audit product creation
-- This trigger maintains an audit trail of all new products added to the system
CREATE OR REPLACE TRIGGER trg_product_creation_audit
AFTER INSERT ON products
FOR EACH ROW
BEGIN
    -- Insert a detailed audit entry into the product_audit_log table
    INSERT INTO product_audit_log (
        audit_id,
        product_id,
        product_name,
        action_type,
        audit_date,
        audit_user,
        product_details
    ) VALUES (
        product_audit_seq.NEXTVAL,
        :NEW.product_id,
        :NEW.product_name,
        'CREATION',
        SYSDATE,
        USER,
        'Product created with SKU: ' || :NEW.sku || 
        ', Category: ' || :NEW.category_id ||
        ', Brand: ' || :NEW.brand_id
    );
END;
/ 