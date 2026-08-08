-- ============================================================
-- E-COMMERCE SALES & CUSTOMER ANALYSIS
-- Portfolio Project
-- Database: ecommerce_portfolio
-- ============================================================

USE ecommerce_portfolio;


-- ============================================================
-- 1. DATA VALIDATION
-- ============================================================

-- Row counts
SELECT 'customers' AS table_name, COUNT(*) AS row_count
FROM customers
UNION ALL
SELECT 'orders', COUNT(*)
FROM orders
UNION ALL
SELECT 'products', COUNT(*)
FROM products;


-- Overall order KPIs
SELECT
    COUNT(*) AS total_orders,
    COUNT(DISTINCT order_id) AS unique_orders,
    COUNT(DISTINCT customer_id) AS unique_customers,
    COUNT(DISTINCT product_id) AS unique_products
FROM orders;


-- Missing values in orders
SELECT
    COUNT(*) AS total_rows,
    SUM(customer_id IS NULL OR customer_id = '') AS missing_customer_id,
    SUM(product_id IS NULL OR product_id = '') AS missing_product_id,
    SUM(order_date IS NULL OR order_date = '') AS missing_order_date,
    SUM(payment_method IS NULL OR payment_method = '') AS missing_payment_method,
    SUM(order_status IS NULL OR order_status = '') AS missing_order_status,
    SUM(quantity IS NULL) AS missing_quantity,
    SUM(sales_amount IS NULL) AS missing_sales_amount
FROM orders;


-- ============================================================
-- 2. ORDER STATUS ANALYSIS
-- ============================================================

SELECT
    order_status,
    COUNT(*) AS orders
FROM orders
GROUP BY order_status
ORDER BY orders DESC;


-- Overall sales KPIs
SELECT
    COUNT(*) AS total_orders,
    SUM(order_status = 'Delivered') AS delivered_orders,
    SUM(order_status = 'Cancelled') AS cancelled_orders,
    SUM(order_status = 'Returned') AS returned_orders,
    ROUND(
        SUM(CASE WHEN order_status = 'Delivered'
                 THEN sales_amount ELSE 0 END), 2
    ) AS delivered_revenue
FROM orders;


-- ============================================================
-- 3. MONTHLY REVENUE
-- ============================================================

SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    COUNT(*) AS delivered_orders,
    ROUND(SUM(sales_amount), 2) AS revenue
FROM orders
WHERE order_status = 'Delivered'
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY month;


-- ============================================================
-- 4. MONTH-OVER-MONTH REVENUE GROWTH
-- ============================================================

WITH monthly_revenue AS (
    SELECT
        DATE_FORMAT(order_date, '%Y-%m') AS month,
        ROUND(SUM(sales_amount), 2) AS revenue
    FROM orders
    WHERE order_status = 'Delivered'
    GROUP BY DATE_FORMAT(order_date, '%Y-%m')
),
revenue_with_previous AS (
    SELECT
        month,
        revenue,
        LAG(revenue) OVER (ORDER BY month) AS previous_month_revenue
    FROM monthly_revenue
)
SELECT
    month,
    revenue,
    previous_month_revenue,
    ROUND(
        (revenue - previous_month_revenue)
        / NULLIF(previous_month_revenue, 0) * 100,
        2
    ) AS mom_growth_pct
FROM revenue_with_previous
ORDER BY month;


-- ============================================================
-- 5. TOP 10 PRODUCTS BY REVENUE
-- ============================================================

SELECT
    p.product_id,
    p.product_name,
    p.category,
    SUM(o.quantity) AS units_sold,
    ROUND(SUM(o.sales_amount), 2) AS revenue
FROM orders o
JOIN products p
    ON o.product_id = p.product_id
WHERE o.order_status = 'Delivered'
GROUP BY
    p.product_id,
    p.product_name,
    p.category
ORDER BY revenue DESC
LIMIT 10;


-- ============================================================
-- 6. CATEGORY PERFORMANCE
-- ============================================================

SELECT
    p.category,
    COUNT(DISTINCT p.product_id) AS products_sold,
    SUM(o.quantity) AS units_sold,
    COUNT(o.order_id) AS delivered_orders,
    ROUND(SUM(o.sales_amount), 2) AS revenue,
    ROUND(AVG(o.sales_amount), 2) AS avg_order_value
FROM orders o
JOIN products p
    ON o.product_id = p.product_id
WHERE o.order_status = 'Delivered'
GROUP BY p.category
ORDER BY revenue DESC;


-- ============================================================
-- 7. CUSTOMER SPENDING ANALYSIS
-- ============================================================

SELECT
    c.customer_id,
    c.customer_segment,
    c.city,
    COUNT(o.order_id) AS orders,
    SUM(o.quantity) AS units_bought,
    ROUND(SUM(o.sales_amount), 2) AS total_spend
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_status = 'Delivered'
GROUP BY
    c.customer_id,
    c.customer_segment,
    c.city
ORDER BY total_spend DESC
LIMIT 10;


-- ============================================================
-- 8. CUSTOMER SEGMENT ANALYSIS
-- ============================================================

SELECT
    c.customer_segment,
    COUNT(DISTINCT c.customer_id) AS customers,
    COUNT(o.order_id) AS orders,
    SUM(o.quantity) AS units_bought,
    ROUND(SUM(o.sales_amount), 2) AS revenue,
    ROUND(AVG(o.sales_amount), 2) AS avg_order_value
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_status = 'Delivered'
GROUP BY c.customer_segment
ORDER BY revenue DESC;


-- ============================================================
-- 9. CITY PERFORMANCE
-- ============================================================

SELECT
    c.city,
    COUNT(DISTINCT c.customer_id) AS customers,
    COUNT(o.order_id) AS orders,
    SUM(o.quantity) AS units_bought,
    ROUND(SUM(o.sales_amount), 2) AS revenue,
    ROUND(AVG(o.sales_amount), 2) AS avg_order_value
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_status = 'Delivered'
GROUP BY c.city
ORDER BY revenue DESC;


-- ============================================================
-- 10. PAYMENT METHOD ANALYSIS
-- ============================================================

SELECT
    COALESCE(NULLIF(payment_method, ''), 'Unknown') AS payment_method,
    COUNT(*) AS orders,
    ROUND(SUM(sales_amount), 2) AS revenue,
    ROUND(AVG(sales_amount), 2) AS avg_order_value
FROM orders
WHERE order_status = 'Delivered'
GROUP BY COALESCE(NULLIF(payment_method, ''), 'Unknown')
ORDER BY revenue DESC;


-- ============================================================
-- 11. CUSTOMER SEGMENT + CATEGORY ANALYSIS
-- ============================================================

SELECT
    c.customer_segment,
    p.category,
    COUNT(o.order_id) AS orders,
    SUM(o.quantity) AS units_sold,
    ROUND(SUM(o.sales_amount), 2) AS revenue
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
JOIN products p
    ON o.product_id = p.product_id
WHERE o.order_status = 'Delivered'
GROUP BY
    c.customer_segment,
    p.category
ORDER BY
    c.customer_segment,
    revenue DESC;


-- ============================================================
-- 12. REPEAT CUSTOMER ANALYSIS
-- ============================================================

WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS order_count
    FROM orders
    WHERE order_status = 'Delivered'
    GROUP BY customer_id
)
SELECT
    c.customer_segment,
    COUNT(*) AS customers,
    SUM(order_count > 1) AS repeat_customers,
    ROUND(
        SUM(order_count > 1) / COUNT(*) * 100,
        2
    ) AS repeat_customer_pct
FROM customer_orders co
JOIN customers c
    ON co.customer_id = c.customer_id
GROUP BY c.customer_segment
ORDER BY repeat_customer_pct DESC;


-- ============================================================
-- 13. CUSTOMER LIFETIME VALUE - TOP CUSTOMERS
-- ============================================================

SELECT
    c.customer_id,
    c.customer_segment,
    c.city,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(o.sales_amount), 2) AS lifetime_value
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_status = 'Delivered'
GROUP BY
    c.customer_id,
    c.customer_segment,
    c.city
ORDER BY lifetime_value DESC
LIMIT 10;


-- ============================================================
-- 14. PRODUCT CATEGORY + CUSTOMER SEGMENT
-- ============================================================

SELECT
    c.customer_segment,
    p.category,
    ROUND(SUM(o.sales_amount), 2) AS revenue,
    SUM(o.quantity) AS units_sold,
    COUNT(DISTINCT o.order_id) AS orders
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
JOIN products p
    ON o.product_id = p.product_id
WHERE o.order_status = 'Delivered'
GROUP BY
    c.customer_segment,
    p.category
ORDER BY revenue DESC;


