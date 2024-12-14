-- Performing checks for inconsistencies, errors, and general data ranges.


-- 1) Null Check

SELECT SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) as nullcount_cust_id,
       SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) as nullcount_order_id,
       SUM(CASE WHEN purchase_ts IS NULL THEN 1 ELSE 0 END) as nullcount_purchase_ts,
       SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) as nullcount_product_id,
       SUM(CASE WHEN product_name IS NULL THEN 1 ELSE 0 END) as nullcount_product_name,
       SUM(CASE WHEN currency IS NULL THEN 1 ELSE 0 END) as nullcount_currency,
       SUM(CASE WHEN local_price IS NULL THEN 1 ELSE 0 END) as nullcount_local_price,
       SUM(CASE WHEN usd_price IS NULL THEN 1 ELSE 0 END) as nullcount_usd_price,
       SUM(CASE WHEN purchase_platform IS NULL THEN 1 ELSE 0 END) as nullcount_purchase_platform
FROM   orders;  




-- 2) Duplicate Orders Check

SELECT   id, COUNT(*) AS order_id_count
FROM     orders
GROUP BY id
HAVING   COUNT(*) > 1;


SELECT COUNT(DISTINCT id)
FROM   customers;

-- returns - 74904


SELECT COUNT(DISTINCT customer_id)
FROM   orders;

-- returns 74904 too
-- confirming that there are "NO" customer_ids in the orders table that ARE NOT in the customers table


SELECT COUNT(*) as unmatched_orders
FROM   orders o LEFT JOIN customers c ON o.customer_id = c.id
WHERE  c.id IS NULL;

-- confirming just one more time - this should and does return 0




-- 3) Checking Distinct Product Names, Purchase Platforms, Countries & Regions, Marketing Platforms, and Loyalty Designation For Familiarity And Finding Irregularities 

SELECT   DISTINCT product_name
FROM     orders
ORDER BY 1;


SELECT   DISTINCT purchase_platform
FROM     orders
ORDER BY 1;


SELECT *
FROM   geo_lookup
WHERE  region IS NULL;


SELECT   DISTINCT c.country_code, gl.region
FROM     customers c LEFT JOIN geo_lookup gl ON c.country_code = gl.country
ORDER BY 1;


SELECT   DISTINCT c.country_code, COUNT(c.country_code) as countnull
FROM     customers c LEFT JOIN geo_lookup gl ON c.country_code = gl.country 
WHERE    gl.region IS NULL
GROUP BY 1;


SELECT   DISTINCT marketing_channel, COUNT(marketing_channel) as count_of_marketing
FROM     customers
GROUP BY 1
ORDER BY 1;


SELECT   DISTINCT loyalty_program
FROM     customers
ORDER BY 1;




-- 4) Purchase, Shipping, Delivery, Refund, and Account Created Date Ranges To Understand Time Frames

SELECT MIN(purchase_ts) as earliest_order_date,
       MAX(purchase_ts) as latest_order_date,
       MIN(ship_ts) as earliest_ship_date,
       MAX(ship_ts) as latest_ship_date,
       MIN(delivery_ts) as earliest_delivery_date,
       MAX(delivery_ts) as latest_delivery_date,
       MIN(refund_ts) as earliest_return_date,
       MAX(refund_ts) as latest_return_date
FROM   order_status;


SELECT MIN(created_on) as earliest_created_on, MAX(created_on) as latest_created_on
FROM   customers;



-- 5) Price Ranges

SELECT MIN(usd_price) as smallest_price, MAX(usd_price) as largest_price
FROM   orders;


SELECT   COUNT(*) as count_of_orders
FROM     orders
WHERE    usd_price = 0
GROUP BY usd_price;
