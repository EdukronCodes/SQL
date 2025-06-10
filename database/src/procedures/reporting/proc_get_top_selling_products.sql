-- Procedure to get top selling products
-- This procedure retrieves detailed sales analysis for top selling products
CREATE OR REPLACE PROCEDURE proc_get_top_selling_products(
    p_start_date IN DATE,            -- Start date
    p_end_date IN DATE,              -- End date
    p_limit IN NUMBER,               -- Number of products to return
    p_cursor OUT SYS_REFCURSOR      -- Cursor for results
) AS
BEGIN
    OPEN p_cursor FOR
        WITH product_sales AS (
            SELECT 
                p.product_id,
                p.product_name,
                p.sku,
                p.upc,
                b.brand_name,
                c.category_name,
                s.supplier_name,
                p.unit_cost,
                p.retail_price,
                SUM(si.quantity) as total_quantity_sold,
                COUNT(DISTINCT s.sale_id) as total_transactions,
                SUM(si.total_amount) as total_revenue,
                SUM(si.quantity * p.unit_cost) as total_cost,
                SUM(si.total_amount - (si.quantity * p.unit_cost)) as total_profit,
                AVG(si.unit_price) as average_selling_price,
                COUNT(DISTINCT s.store_id) as number_of_stores,
                COUNT(DISTINCT s.customer_id) as number_of_customers
            FROM products p
            JOIN brands b ON p.brand_id = b.brand_id
            JOIN categories c ON p.category_id = c.category_id
            JOIN suppliers s ON p.supplier_id = s.supplier_id
            JOIN sales_items si ON p.product_id = si.product_id
            JOIN sales s ON si.sale_id = s.sale_id
            WHERE s.sale_date BETWEEN p_start_date AND p_end_date
            GROUP BY 
                p.product_id,
                p.product_name,
                p.sku,
                p.upc,
                b.brand_name,
                c.category_name,
                s.supplier_name,
                p.unit_cost,
                p.retail_price
        ),
        product_returns AS (
            SELECT 
                product_id,
                COUNT(*) as return_count,
                SUM(quantity) as return_quantity,
                SUM(refund_amount) as total_refund_amount
            FROM product_returns
            WHERE return_date BETWEEN p_start_date AND p_end_date
            GROUP BY product_id
        ),
        product_reviews AS (
            SELECT 
                product_id,
                COUNT(*) as review_count,
                AVG(rating) as average_rating,
                COUNT(CASE WHEN rating >= 4 THEN 1 END) as positive_reviews
            FROM product_reviews
            WHERE review_date BETWEEN p_start_date AND p_end_date
            GROUP BY product_id
        )
        SELECT 
            ps.*,
            COALESCE(pr.return_count, 0) as return_count,
            COALESCE(pr.return_quantity, 0) as return_quantity,
            COALESCE(pr.total_refund_amount, 0) as total_refund_amount,
            COALESCE(prev.review_count, 0) as review_count,
            COALESCE(prev.average_rating, 0) as average_rating,
            COALESCE(prev.positive_reviews, 0) as positive_reviews,
            -- Calculate return rate
            CASE 
                WHEN ps.total_quantity_sold > 0 
                THEN ROUND(COALESCE(pr.return_quantity, 0) / ps.total_quantity_sold * 100, 2)
                ELSE 0 
            END as return_rate,
            -- Calculate profit margin
            CASE 
                WHEN ps.total_revenue > 0 
                THEN ROUND(ps.total_profit / ps.total_revenue * 100, 2)
                ELSE 0 
            END as profit_margin,
            -- Calculate customer satisfaction
            CASE 
                WHEN prev.review_count > 0 
                THEN ROUND(prev.positive_reviews / prev.review_count * 100, 2)
                ELSE 0 
            END as customer_satisfaction
        FROM product_sales ps
        LEFT JOIN product_returns pr ON ps.product_id = pr.product_id
        LEFT JOIN product_reviews prev ON ps.product_id = prev.product_id
        ORDER BY ps.total_revenue DESC
        FETCH FIRST p_limit ROWS ONLY;
END proc_get_top_selling_products;
/ 