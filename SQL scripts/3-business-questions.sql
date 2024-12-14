-- Business Questions

/*

1. What is the average quarterly order count and total sales for Macbooks sold in North America? (i.e. “For North America Macbooks, average of X units sold per quarter and Y in dollar sales per quarter”)

2. Which region has the average highest time to deliver for website purchases made in 2022 or Samsung purchases made in 2021, expressing time to deliver in weeks.

3. What was the refund rate and refund count for each product per year?

4. Within each region, what is the most popular product? 

5. How does the time to make a purchase differ between loyalty customers vs. non-loyalty customers, per purchase plaftorm?

6. What is the median order value for each currency?

7. Return the purchase month, shipping month, time to ship (in days), and product name for each order placed in 2020. 

8. What is the average order value per year for products that are either laptops or headphones?

9. How many customers either came through an email marketing channel and created an account on mobile, or came through an affiliate marketing campaign and created an account on desktop?

10. What is the total number of orders per year for each product? Clean up product names when grouping and return in alphabetical order after sorting by months.

11. Within each region, what is the most popular product?

12. What is the average total sales over the entire range of 2019-2022?

13. What percentage of customers made more than one purchase in a year? Break it down by year.

14. For each region, what's the total number of customers and the total number of orders? Sort alphabetically by region.

15. What's the average time to deliver for each purchase platform?

16. Within each purchase platform, what are the top two marketing channels ranked by average order value (AOV)?

*/

--=============================================================================================================

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
         or (product_name ILIKE 'Samsung%' and os.purchase_ts BETWEEN '2021-01-01' and '2021-12-31')
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
	GROUP BY gl.region, o.product_name
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


-- ====================================================================

-- 7. Return the purchase month, shipping month, time to ship (in days), and product name for each order placed in 2020. 


SELECT   EXTRACT(MONTH FROM os.purchase_ts) as purchase_month,
         EXTRACT(MONTH FROM os.ship_ts) as ship_month,
	 EXTRACT(DAY FROM AGE(os.ship_ts::timestamp, os.purchase_ts::timestamp)) as time_to_ship_days,
         o.product_name as product_name
FROM     orders o JOIN order_status os ON o.id = os.order_id
WHERE    os.purchase_ts BETWEEN '2020-01-01' AND '2020-12-31'
ORDER BY 1, 2, 3


-- ====================================================================

-- 8. What is the average order value per year for products that are either laptops or headphones?


SELECT   EXTRACT(YEAR FROM os.purchase_ts) as year,
         o.product_name,
         ROUND(AVG(o.usd_price)) as aov,
	 COUNT(o.id) AS total_orders
FROM     orders o JOIN order_status os ON o.id = os.order_id
WHERE    o.product_name LIKE '%Macbook%'
         or o.product_name LIKE '%Laptop%'
         or o.product_name LIKE '%Headphones%'
GROUP BY year, product_name
ORDER BY year


-- ====================================================================

-- 9. How many customers either came through an email marketing channel and created an account on mobile, or came through an affiliate marketing campaign and created an account on desktop?


SELECT COUNT(CASE WHEN marketing_channel = 'email' 
                       and account_creation_method = 'mobile' 
                  THEN id 
             END) as email_mobile_count,
       COUNT(CASE WHEN marketing_channel = 'affiliate' 
                       and customers.account_creation_method = 'desktop' 
                  THEN id 
             END) as affiliate_desktop_count,
       COUNT(id) as total_count
FROM   customers


-- ====================================================================

-- 10. What is the total number of orders per year for each product? Clean up product names when grouping and return in alphabetical order after sorting by months.


SELECT   EXTRACT(YEAR FROM os.purchase_ts) as purchase_year,
         EXTRACT(MONTH FROM os.purchase_ts) as purchase_month,
	 TRIM(
      	      CASE 
		  WHEN o.product_name LIKE '%27in%4k gaming monitor%' 
		  THEN '27in 4K gaming monitor' 
		  ELSE o.product_name
              END) as product_name_clean,
	 COUNT(o.id) as total_orders
FROM     orders o JOIN order_status os ON o.id = os.order_id
GROUP BY 1, 2, 3
ORDER BY 1, 2, 3


-- ====================================================================

-- 11. Within each region, what is the most popular product?


WITH region_sales AS (
	SELECT   gl.region,
	         o.product_name,
	         COUNT(o.id) order_count
	FROM     orders o LEFT JOIN customers c ON o.customer_id = c.id
			  LEFT JOIN geo_lookup gl ON c.country_code = gl.country
	GROUP BY region, product_name
)
,ranked_sales as (
	SELECT region,
	       product_name,
	       order_count,
	       ROW_NUMBER() OVER(PARTITION BY region ORDER BY order_count desc) as rn
	FROM   region_sales
)
SELECT   region, product_name, order_count
FROM     ranked_sales
WHERE    rn=1
ORDER BY order_count desc


-- ====================================================================

-- 12. What is the average total sales over the entire range of 2019-2022?

WITH yearly_sales AS (
	SELECT   EXTRACT(YEAR FROM purchase_ts) as year, SUM(usd_price) as total_sales
	FROM     orders
	WHERE    EXTRACT(YEAR FROM purchase_ts) IS NOT NULL
	GROUP BY year
)
SELECT ROUND(AVG(total_sales::decimal), 2) as avg_sales_across_years
FROM   yearly_sales


-- ====================================================================

-- 13. What percentage of customers made more than one purchase in a year? Break it down by year.

WITH customer_orders AS (
  SELECT   customer_id,
           EXTRACT(YEAR from purchase_ts) as purchase_year,
	   COUNT(id) as order_count
  FROM     orders
  GROUP BY 1, 2
)
SELECT   purchase_year,
         COUNT(DISTINCT customer_id) as unique_customers,
	 COUNT(CASE WHEN order_count >= 2 THEN customer_id END) as repeat_customers,
	 ROUND(1.0 * (COUNT(CASE WHEN order_count >= 2 THEN customer_id END) / 100 * COUNT(DISTINCT customer_id)),2) as repeat_rate
FROM     customer_orders
WHERE    purchase_year IS NOT NULL
GROUP BY purchase_year
ORDER BY purchase_year


-- ====================================================================

-- 14. For each region, what's the total number of customers and the total number of orders? Sort alphabetically by region.

SELECT   gl.region,
         COUNT(DISTINCT c.id) as customer_count,
	 COUNT(DISTINCT o.id) as order_count
FROM     orders o LEFT JOIN customers c ON o.customer_id = c.id
                  LEFT JOIN geo_lookup gl ON c.country_code = gl.country
GROUP BY gl.region
ORDER BY gl.region


-- ====================================================================

-- 15. What's the average time to deliver for each purchase platform?

SELECT   o.purchase_platform,
         ROUND(AVG(EXTRACT(DAY FROM AGE(os.delivery_ts::timestamp, os.purchase_ts::timestamp))), 5) as avg_time_to_deliver
FROM     orders o LEFT JOIN order_status os ON o.id = os.order_id
GROUP BY o.purchase_platform


-- ====================================================================

-- 16. Within each purchase platform, what are the top two marketing channels ranked by average order value?

WITH marketing_sales AS (
	SELECT   o.purchase_platform,
		 c.marketing_channel,
		 ROUND(AVG(o.usd_price)::decimal, 2) as aov
	FROM     orders o LEFT JOIN customers c ON o.customer_id = c.id
	GROUP BY 1, 2
)
,ranked_platforms as (
	SELECT *, ROW_NUMBER() OVER(PARTITION BY purchase_platform ORDER BY aov desc) as rn
	FROM   marketing_sales
)
SELECT purchase_platform, marketing_channel, aov
FROM   ranked_platforms
WHERE  rn <= 2

-- ====================================================================
