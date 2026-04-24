-- view Funnel Conversion Metrics
CREATE OR REPLACE VIEW vw_funnel_conversion AS 
WITH funnel_stages AS(
SELECT 
COUNT(DISTINCT CASE WHEN event_type ='page_view' THEN user_id END)AS stage1_view,
COUNT(DISTINCT CASE WHEN event_type ='add_to_cart' THEN user_id END)AS stage2_cart,
COUNT(DISTINCT CASE WHEN event_type ='checkout_start' THEN user_id END)AS stage3_checkout,
COUNT(DISTINCT CASE WHEN event_type ='payment_info' THEN user_id END)AS stage4_payment,
COUNT(DISTINCT CASE WHEN event_type ='purchase' THEN user_id END)AS stage5_purchase
FROM user_events
WHERE event_date >= DATE_SUB((SELECT MAX(event_date) FROM user_events),INTERVAL 30 DAY)
)
SELECT 
stage1_view,
stage2_cart,
ROUND(stage2_cart*100 /stage1_view,2)AS view_to_cart_rate,
stage3_checkout,
ROUND(stage3_checkout*100/stage2_cart,2)AS cart_to_checkout_rate,
stage4_payment,
ROUND(stage4_payment*100/stage3_checkout,2)AS checkout_payment_rate,
stage5_purchase,
ROUND(stage5_purchase *100/stage4_payment,2)AS payment_to_purchase_rate,
ROUND(stage5_purchase *100/stage1_view,2) AS overall_rate
FROM funnel_stages;


SELECT * FROM vw_funnel_conversion;

-- source Funnel
CREATE OR REPLACE VIEW vm_source_performance AS
WITH source_funnel AS(
SELECT
traffic_source,
COUNT(DISTINCT CASE WHEN event_type ='page_view' THEN user_id END)AS Views,
COUNT(DISTINCT CASE WHEN event_type='add_to_cart' THEN user_id END)AS Carts,
COUNT(DISTINCT CASE WHEN event_type='purchase' THEN user_id END)AS Purchases
FROM user_events
WHERE event_date >= DATE_SUB((SELECT MAX(event_date) FROM user_events ),INTERVAL 30 DAY)
GROUP BY traffic_source
)
SELECT 
traffic_source,
Views,
Carts,
Purchases,
ROUND(Carts*100/Views,2) AS Cart_Conversion_rate,
ROUND(Purchases*100/views,2) AS Purchase_Conversion_rate,
ROUND(Purchases*100/Carts,2)AS Cart_to_Purchase_Conversion_rate
FROM Source_funnel;

SELECT * FROM vm_source_performance;

-- view :Conversion_time
CREATE OR REPLACE VIEW vm_conversion_time AS
WITH user_journey AS(
SELECT 
user_id,
MIN(CASE WHEN event_type='page_view'THEN event_date END)AS view_time,
MIN(CASE WHEN event_type='add_to_cart' THEN event_date END)AS cart_time,
MIN(CASE WHEN event_type='purchase'THEN event_date END)AS purchase_time
FROM user_events
WHERE event_date >= DATE_SUB((SELECT MAX(event_date) FROM user_events),INTERVAL 30 DAY)
GROUP BY user_id
HAVING purchase_time IS NOT NULL
)
SELECT 
COUNT(*) AS converted_users,
ROUND(AVG(TIMESTAMPDIFF(MINUTE ,view_time, cart_time)),2) AS avg_view_to_cart_minutes,
ROUND(AVG(TIMESTAMPDIFF(MINUTE ,cart_time, purchase_time)),2) AS avg_cart_to_purchase_minutes,
ROUND(AVG(TIMESTAMPDIFF(MINUTE ,view_time, purchase_time)),2) AS avg_total_journey_minutes
FROM user_journey;

SELECT * FROM vm_conversion_time;

-- Revenue Summary 
CREATE OR REPLACE VIEW vm_revenue_summary AS
WITH funnel_revenue AS(
SELECT
COUNT(DISTINCT CASE WHEN event_type='page_view' THEN user_id END)AS total_visitors,
COUNT(DISTINCT CASE WHEN event_type='purchase' THEN user_id END)AS total_buyers,
SUM(CASE WHEN event_type='purchase' THEN amount END)AS total_revenue,
COUNT(CASE WHEN event_type='purchase' THEN  1 END)AS total_orders
FROM user_events
WHERE event_date >= DATE_SUB((SELECT MAX(event_date) FROM user_events ),INTERVAL 30 DAY)
)
SELECT 
total_visitors,
total_buyers,
total_orders,
ROUND(total_revenue,2) AS total_revenue,
ROUND(total_revenue/total_orders,2) AS avg_order_value,
ROUND(total_revenue/total_buyers,2) AS revenue_per_buyer,
ROUND(total_revenue/total_visitors,2)AS revenue_per_visitor
FROM funnel_revenue;

SELECT * FROM vm_revenue_summary;