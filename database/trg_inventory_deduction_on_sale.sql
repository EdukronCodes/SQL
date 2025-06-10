-- Trigger to handle inventory deduction on sale
-- This trigger automatically reduces inventory quantity when a sale is made
CREATE OR REPLACE TRIGGER trg_inventory_deduction_on_sale
AFTER INSERT ON sales_items
FOR EACH ROW
BEGIN
    -- Decrease the inventory quantity for the sold product in the relevant store
    UPDATE inventory
    SET quantity = quantity - :NEW.quantity,
        last_audit_date = SYSDATE
    WHERE product_id = :NEW.product_id
      AND store_id = (SELECT store_id FROM sales WHERE sale_id = :NEW.sale_id);
END;
/ 