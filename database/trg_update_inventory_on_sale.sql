-- Trigger to update inventory after a sale
-- This trigger decreases inventory quantity when a new sales_item is inserted
CREATE OR REPLACE TRIGGER trg_update_inventory_on_sale
AFTER INSERT ON sales_items
FOR EACH ROW
BEGIN
    -- Decrease the inventory quantity for the sold product in the relevant store
    UPDATE inventory
    SET quantity = quantity - :NEW.quantity
    WHERE product_id = :NEW.product_id
      AND store_id = (SELECT store_id FROM sales WHERE sale_id = :NEW.sale_id);
END;
/ 