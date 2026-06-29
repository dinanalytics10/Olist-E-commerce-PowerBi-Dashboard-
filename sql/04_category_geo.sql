-- Top 10 categories
SELECT
    pc.category_en,
    ROUND(SUM(di.price), 2) AS revenue,
    COUNT(*) AS items_sold
FROM delivered_items di
JOIN products_clean pc ON pc.product_id = di.product_id
GROUP BY pc.category_en
ORDER BY revenue DESC
LIMIT 10;

-- Top 10 states
SELECT
    c.customer_state,
    ROUND(SUM(di.item_total), 2) AS revenue,
    COUNT(DISTINCT di.order_id) AS orders
FROM delivered_items di
JOIN delivered_orders o ON o.order_id = di.order_id
JOIN customers c ON c.customer_id = o.customer_id
GROUP BY c.customer_state
ORDER BY revenue DESC
LIMIT 10;
