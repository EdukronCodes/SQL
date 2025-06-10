-- Procedure to get supplier products
-- This procedure retrieves detailed product information for a supplier
CREATE OR REPLACE PROCEDURE proc_get_supplier_products(
    p_supplier_id IN NUMBER,         -- Supplier ID
    p_cursor OUT SYS_REFCURSOR      -- Cursor for results
) AS
BEGIN
    OPEN p_cursor FOR
        SELECT 
            p.product_id,
            p.product_name,
            p.product_description,
            p.sku,
            p.upc,
            b.brand_name,
            c.category_name,
            p.unit_cost,
            p.retail_price,
            p.min_stock_level,
            p.max_stock_level,
            p.reorder_point,
            p.weight,
            p.dimensions,
            p.is_active,
            -- Inventory summary
            (SELECT SUM(quantity) FROM inventory WHERE product_id = p.product_id) as total_quantity,
            -- Sales summary
            (SELECT COUNT(*) FROM sales_items WHERE product_id = p.product_id) as total_sales,
            (SELECT SUM(quantity) FROM sales_items WHERE product_id = p.product_id) as total_quantity_sold,
            -- Purchase order summary
            (SELECT COUNT(*) FROM purchase_order_items WHERE product_id = p.product_id) as total_orders,
            (SELECT SUM(quantity) FROM purchase_order_items WHERE product_id = p.product_id) as total_quantity_ordered,
            -- Performance metrics
            (SELECT AVG(rating) FROM product_reviews WHERE product_id = p.product_id) as average_rating,
            (SELECT COUNT(*) FROM product_reviews WHERE product_id = p.product_id) as review_count,
            -- Discount information
            (SELECT MAX(discount_percentage) FROM product_discounts 
             WHERE product_id = p.product_id 
             AND start_date <= SYSDATE 
             AND end_date >= SYSDATE) as current_discount
        FROM products p
        JOIN brands b ON p.brand_id = b.brand_id
        JOIN categories c ON p.category_id = c.category_id
        WHERE p.supplier_id = p_supplier_id
        ORDER BY p.product_name;
END proc_get_supplier_products;
/ 