-- Trigger to update inventory when a purchase order is received
-- This trigger increases inventory quantity when a purchase order is completed
CREATE OR REPLACE TRIGGER trg_update_inventory_on_purchase
AFTER UPDATE OF status ON purchase_orders
FOR EACH ROW
WHEN (NEW.status = 'RECEIVED')
BEGIN
    -- For each item in the purchase order, update inventory
    FOR po_item IN (
        SELECT product_id, quantity, store_id 
        FROM purchase_order_items 
        WHERE purchase_order_id = :NEW.purchase_order_id
    ) LOOP
        -- Update or insert inventory record
        MERGE INTO inventory i
        USING dual
        ON (i.product_id = po_item.product_id AND i.store_id = po_item.store_id)
        WHEN MATCHED THEN
            UPDATE SET quantity = quantity + po_item.quantity,
                      last_restock_date = SYSDATE
        WHEN NOT MATCHED THEN
            INSERT (product_id, store_id, quantity, last_restock_date)
            VALUES (po_item.product_id, po_item.store_id, po_item.quantity, SYSDATE);
    END LOOP;
END;
/ 