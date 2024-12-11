-- Business Questions


-- 1. What is the average quarterly order count and total sales for Macbooks sold in North America? (i.e. “For North America Macbooks, average of X units sold per quarter and Y in dollar sales per quarter”)

WITH quarterly_metrics as (
	SELECT   EXTRACT(QUARTER FROM purchase_ts) as quarter, 
	         COUNT(o.id) as order_count,
	         ROUND(SUM(usd_price)::integer, 2) as sales_volume,
			 ROUND(AVG(usd_price)::integer, 2) as AOV
	FROM     orders o LEFT JOIN customers c ON o.customer_id = c.id
	                  LEFT JOIN geo_lookup gl ON c.country_code = gl.country
	WHERE    product_name ILIKE '%macbook%'
	         and region = 'NA'
	GROUP BY quarter
	ORDER BY quarter
)
SELECT ROUND(AVG(order_count), 2) as avg_quarterly_orders,
       ROUND(AVG(sales_volume), 2) as avg_quarterly_sales
FROM   quarterly_metrics



-- ====================================================================


-- 2. Which region has the average highest time to deliver for website purchases made in 2022 or Samsung purchases made in 2021, expressing time to deliver in weeks.


SELECT   region,
         AVG(EXTRACT(DAY FROM AGE(os.delivery_ts::timestamp, os.purchase_ts::timestamp)) / 7) as weeks_to_deliver
FROM     orders o LEFT JOIN order_status os ON o.id = os.order_id
                  LEFT JOIN customers c ON o.customer_id = c.id
                  LEFT JOIN geo_lookup gl ON c.country_code = gl.country
WHERE    (purchase_platform='website' and os.purchase_ts BETWEEN '2022-01-01' and '2022-12-31')
         OR (product_name ILIKE 'Samsung%' and os.purchase_ts BETWEEN '2021-01-01' and '2021-12-31')
GROUP BY region
ORDER BY weeks_to_deliver desc
-- LIMIT    1



-- ====================================================================


-- 3. What was the refund rate and refund count for each product per year?


SELECT   EXTRACT(YEAR FROM o.purchase_ts) as purchase_year,
         o.product_name,
         SUM(CASE WHEN os.refund_ts IS NOT NULL THEN 1 ELSE 0 END) as refund_count,
         ROUND(AVG(CASE WHEN os.refund_ts IS NOT NULL THEN 1 ELSE 0 END), 5) as refund_rate
FROM     orders o LEFT JOIN order_status os ON o.id = os.order_id
GROUP BY purchase_year, product_name
ORDER BY purchase_year



-- ====================================================================


-- 4. Within each region, what is the most popular product? 


WITH sales_by_product_by_region AS (
	SELECT   gl.region,
	         o.product_name,
	         COUNT(o.id) as order_count,
		     RANK() OVER(PARTITION BY gl.region ORDER BY COUNT(o.id) desc) as rank
	FROM     orders o LEFT JOIN order_status os ON o.id = os.order_id
	                  LEFT JOIN customers c ON o.customer_id = c.id
	                  LEFT JOIN geo_lookup gl ON c.country_code = gl.country
	GROUP BY 1, 2
)
SELECT   region, product_name, order_count
FROM     sales_by_product_by_region
WHERE    rank=1
ORDER BY order_count desc
       


-- ====================================================================


-- 5. How does the time to make a purchase differ between loyalty customers vs. non-loyalty customers, per purchase plaftorm?


SELECT   o.purchase_platform,
         CASE WHEN c.loyalty_program = 1 THEN 'Loyalty' ELSE 'Non-Loyalty' END as loyalty_status,
         ROUND(AVG(EXTRACT(DAY FROM AGE(o.purchase_ts::timestamp, c.created_on::timestamp))), 2) as avg_days_to_order,
         COUNT(*) as order_count
FROM     customers c LEFT JOIN orders o ON o.customer_id = c.id
GROUP BY 1, 2




-- ====================================================================


-- 6. What is the median order value for each currency?


WITH median_cte AS (
   SELECT usd_price,
          currency,
          ROW_NUMBER() OVER (PARTITION BY currency ORDER BY usd_price, id) as rn,
          ROW_NUMBER() OVER (PARTITION BY currency ORDER BY usd_price desc, id desc) as rn_desc
   FROM   orders
   WHERE  usd_price IS NOT NULL
)
SELECT   currency, ROUND(AVG(usd_price::integer), 2) as median_order_value
FROM     median_cte
WHERE    rn IN (rn_desc, rn_desc - 1, rn_desc + 1)
GROUP BY currency
ORDER BY median_order_value desc









