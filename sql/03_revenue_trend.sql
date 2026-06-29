SELECT
    strftime('%Y-%m', 
    order_purchase_timestamp) AS month,
    ROUND(SUM(item_total), 2) AS revenue,
    COUNT(DISTINCT order_id) AS orders
FROM delivered_items
GROUP BY month
ORDER BY month;
