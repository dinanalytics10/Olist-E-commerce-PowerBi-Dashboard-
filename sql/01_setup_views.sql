-- Cleaning layer -- run this first to get a setup view

DROP VIEW IF EXISTS delivered_orders;
CREATE VIEW delivered_orders AS
SELECT * FROM orders
WHERE order_status = 'delivered';

DROP VIEW IF EXISTS clean_reviews;
CREATE VIEW clean_reviews AS
SELECT order_id, review_score, 
       review_creation_date, 
       review_answer_timestamp
FROM (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY order_id 
            ORDER BY review_answer_timestamp DESC
        ) AS rn
    FROM order_reviews
)
WHERE rn = 1;

DROP VIEW IF EXISTS products_clean;
CREATE VIEW products_clean AS
SELECT
    p.product_id,
    COALESCE(t.product_category_name_english, 
             p.product_category_name, 
             'unknown') AS category_en
FROM products p
LEFT JOIN product_category_name_translation t
    ON t.product_category_name = p.product_category_name;

DROP VIEW IF EXISTS delivered_items;
CREATE VIEW delivered_items AS
SELECT
    oi.order_id,
    oi.product_id,
    oi.seller_id,
    oi.price,
    oi.freight_value,
    oi.price + oi.freight_value AS item_total,
    o.order_purchase_timestamp,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date
FROM order_items oi
JOIN delivered_orders o ON o.order_id = oi.order_id;
