-- Function to calculate total inventory value
-- Returns the total value of inventory across all stores
CREATE OR REPLACE FUNCTION fn_calculate_inventory_value
RETURN NUMBER IS
    v_total_value NUMBER;
BEGIN
    -- Calculate total inventory value (quantity * unit_cost)
    SELECT NVL(SUM(i.quantity * p.unit_cost), 0)
    INTO v_total_value
    FROM inventory i
    JOIN products p ON i.product_id = p.product_id;
    
    RETURN v_total_value;
END fn_calculate_inventory_value;
/ 