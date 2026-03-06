CREATE DATABASE Sales_funnel_Analysis;
SELECT * FROM user_events  LIMIT 1000;



-- DEFINE OUR SALES FUNNEL AND THE DIFFERENT STAGES:
WITH funnel_stages AS(
SELECT
	COUNT(DISTINCT CASE WHEN event_type ='page_view' THEN user_id END)AS stage_1_view,
    COUNT(DISTINCT CASE WHEN event_type ='add_to_cart' THEN user_id END)AS stage_2_cart,
    COUNT(DISTINCT CASE WHEN event_type ='checkout_start' THEN user_id END)AS stage_3_checkout,
    COUNT(DISTINCT CASE WHEN event_type ='payment_info' THEN user_id END)AS stage_4_payment,
	COUNT(DISTINCT CASE WHEN event_type ='purchase' THEN user_id END)AS stage_5_purchase
    
 FROM user_events
  WHERE event_date >= (DATE_SUB(
	(SELECT MAX(event_date) FROM user_events), INTERVAL 30 DAY))
     )
    SELECT *
    FROM funnel_stages;
    
-- USED ROLLING 30 DAY WINDOW RELATIVE TO LATEST AVAILABLE EVENT DATE TO ENSURE HISTORICAL DATASET CONSISTENCY;   
-- CONVERSION RATES THROUGH THE FUNNEL:
-- Conversion rates were calculated to measure how efficeintlu=y users moved from one funnel stage to the next stage
WITH funnel_stages AS(
SELECT
	COUNT(DISTINCT CASE WHEN event_type ='page_view' THEN user_id END)AS stage_1_view,
    COUNT(DISTINCT CASE WHEN event_type ='add_to_cart' THEN user_id END)AS stage_2_cart,
    COUNT(DISTINCT CASE WHEN event_type ='checkout_start' THEN user_id END)AS stage_3_checkout,
    COUNT(DISTINCT CASE WHEN event_type ='payment_info' THEN user_id END)AS stage_4_payment,
	COUNT(DISTINCT CASE WHEN event_type ='purchase' THEN user_id END)AS stage_5_purchase
FROM user_events
 
WHERE event_date >= (DATE_SUB(
(SELECT MAX(event_date) FROM user_events), INTERVAL 30 DAY))
 )
    SELECT
stage_1_view,
stage_2_cart,
ROUND(stage_2_cart *100/ stage_1_view) AS view_to_cart_rate,
stage_3_checkout,
ROUND(stage_3_checkout*100/stage_2_cart) AS cart_to_checkout_rate,
stage_4_payment,
ROUND(stage_4_payment *100/stage_3_checkout) AS checkout_to_payment_rate,
stage_5_purchase,
ROUND(stage_5_purchase * 100 /stage_4_payment)AS payment_to_purchase_rate,
ROUND(stage_5_purchase * 100 /stage_1_view)AS overall_rate
FROM funnel_stages;

-- FUNNEL BY SOURCE:
WITH source_funnel AS
(
  SELECT
  traffic_source,
  COUNT(DISTINCT CASE WHEN event_type='page_view' THEN user_id END) as views,
  COUNT(DISTINCT CASE WHEN event_type='add_to_cart' THEN user_id END) as carts,
  COUNT(DISTINCT CASE WHEN event_type='purchase' THEN user_id END) as purchases

FROM user_events
WHERE event_date >= (DATE_SUB(
(SELECT MAX(event_date) FROM user_events), INTERVAL 30 DAY))
GROUP BY traffic_source
)
SELECT traffic_source,
views,
carts,
purchases,
ROUND(carts *100 / views) AS cart_conversion_rate,
ROUND(purchases *100 / views) AS purchases_conversion_rate,
ROUND(purchases *100 / carts) AS cart_to_purchase_conversion_rate
FROM source_funnel
ORDER BY purchases DESC;

-- TIME TO CONVERSION ANALYSIS:
WITH user_journey AS (
    SELECT 
        user_id,
        MIN(CASE WHEN event_type = 'page_view' THEN event_date END) AS view_time,
        MIN(CASE WHEN event_type = 'add_to_cart' THEN event_date END) AS cart_time,
        MIN(CASE WHEN event_type = 'purchase' THEN event_date END) AS purchase_time
    FROM user_events
    WHERE event_date >= DATE_SUB(
        (SELECT MAX(event_date) FROM user_events), INTERVAL 30 DAY
    )
    GROUP BY user_id
    HAVING MIN(CASE WHEN event_type = 'purchase' THEN event_date END) IS NOT NULL
)

SELECT
    COUNT(*) AS converted_users,
    ROUND(AVG(TIMESTAMPDIFF(MINUTE, view_time, cart_time)), 2) AS avg_view_to_cart_minutes,
	ROUND(AVG(TIMESTAMPDIFF(MINUTE, cart_time, purchase_time)), 2) AS avg_cart_to_purchase_minutes,
	ROUND(AVG(TIMESTAMPDIFF(MINUTE, view_time, purchase_time)), 2) AS avg_total_journey_minutes
FROM user_journey;

-- REVENUE FUNNEL ANALYSIS:
WITH funnel_revenue AS
(
  SELECT
  COUNT(DISTINCT CASE WHEN event_type='page_view' THEN user_id END) as total_visitors,
  COUNT(DISTINCT CASE WHEN event_type='purchase' THEN user_id END) as total_buyers,
  SUM(CASE WHEN event_type='purchase' THEN amount END) as total_revenue,
  COUNT(CASE WHEN event_type='purchase' THEN 1 END) as total_orders
FROM user_events
WHERE event_date >= DATE_SUB(
        (SELECT MAX(event_date) FROM user_events), INTERVAL 30 DAY
    )
)
SELECT
total_visitors,
total_buyers,
total_orders,
ROUND(total_revenue,2) AS total_revenue,
ROUND((total_revenue /total_orders),2)AS avg_order_value,
ROUND((total_revenue/ total_buyers),2)AS revenue_per_buyer,
ROUND((total_revenue / total_visitors),2) AS revenue_per_vistor
FROM funnel_revenue;



 