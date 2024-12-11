-- Cleaning, combining, and organzing data for use

-- inconsistency in the product names

WITH cleaned_product as (
	SELECT o.customer_id,
	       o.id as order_id,
	       o.purchase_ts as purchase_date,
	       o.product_id,
	       CASE 
	       	    WHEN LOWER(o.product_name) LIKE '%gaming monitor%' THEN '27 inch Gaming Monitor' 
		    WHEN LOWER(o.product_name) LIKE '%macbook%' THEN 'Apple Macbook Air Laptop'
	            WHEN LOWER(o.product_name) LIKE '%thinkpad%' THEN 'Lenovo ThinkPad Laptop'
		    WHEN LOWER(o.product_name) LIKE '%bose%' THEN 'Bose Soundsport Headphones' 
		    ELSE o.product_name 
	       END as product_name,
	       UPPER(o.currency) as currency,
	       o.local_price,
	       o.usd_price,
	       o.purchase_platform
	FROM   orders o
)

-- After cleaning product_name, adding columns for product category and brand name

,cleaned_orders as (
	SELECT *,
    	       CASE 
		     WHEN LOWER(cp.product_name) LIKE '%apple%' THEN 'Apple'
    		     WHEN LOWER(cp.product_name) LIKE '%samsung%' THEN 'Samsung'
    		     WHEN LOWER(cp.product_name) LIKE '%lenovo%' THEN 'Lenovo'
    		     WHEN LOWER(cp.product_name) LIKE '%bose%' THEN 'Bose'
    	             ELSE 'Unknown' 
	       END as brand_name,
    	       CASE 
		     WHEN LOWER(cp.product_name) LIKE '%headphones%' THEN 'Headphones'
    		     WHEN LOWER(cp.product_name) LIKE '%laptop%' THEN 'Laptop'
    		     WHEN LOWER(cp.product_name) LIKE '%iphone%' THEN 'Cell Phone'
    		     WHEN LOWER(cp.product_name) LIKE '%monitor%' THEN 'Monitor'
    		     ELSE 'Accessories' 
	      END as product_category,
		  
    	      ROW_NUMBER() OVER (PARTITION BY cp.customer_id ORDER BY cp.purchase_date) as customer_order_number,
    	      EXTRACT(YEAR FROM cp.purchase_date) as year,
		  
    	      CASE 
		     WHEN EXTRACT(MONTH FROM cp.purchase_date) = 1 THEN 'January'
    		     WHEN EXTRACT(MONTH FROM cp.purchase_date) = 2 THEN 'February'
    		     WHEN EXTRACT(MONTH FROM cp.purchase_date) = 3 THEN 'March'
    		     WHEN EXTRACT(MONTH FROM cp.purchase_date) = 4 THEN 'April'
    		     WHEN EXTRACT(MONTH FROM cp.purchase_date) = 5 THEN 'May'
    		     WHEN EXTRACT(MONTH FROM cp.purchase_date) = 6 THEN 'June'
    	             WHEN EXTRACT(MONTH FROM cp.purchase_date) = 7 THEN 'July'
    		     WHEN EXTRACT(MONTH FROM cp.purchase_date) = 8 THEN 'August'
    	             WHEN EXTRACT(MONTH FROM cp.purchase_date) = 9 THEN 'September'
    		     WHEN EXTRACT(MONTH FROM cp.purchase_date) = 10 THEN 'October'
    		     WHEN EXTRACT(MONTH FROM cp.purchase_date) = 11 THEN 'November'
    		     WHEN EXTRACT(MONTH FROM cp.purchase_date) = 12 THEN 'December'
    		     ELSE NULL 
	     END as month
    FROM     cleaned_product cp
)
	
,cleaned_customers as (
	SELECT c.id AS customer_id,
	       c.marketing_channel,
	       c.account_creation_method,
	       UPPER(c.country_code) AS country_code,
	       c.loyalty_program,
	       c.created_on
	FROM   customers c
)

-- Checks showed inconsistencies in two regions
,cleaned_geo_lookup as (
	SELECT gl.country,
	       CASE 
		    WHEN UPPER(gl.country) = 'EU' THEN 'EMEA'
		    WHEN UPPER(gl.country) = 'A1' THEN 'Unknown'
		    ELSE gl.region 
	       END as region
	FROM   geo_lookup gl
)
-- Adding metric for refunds and operation efficiency times, found negative duration so cleaned

,cleaned_order_status AS (
	SELECT os.order_id as order_id,
	       os.purchase_ts as purchase_date,
	       os.ship_ts as shipping_date,
	       os.delivery_ts as delivery_date,
	       os.refund_ts as refund_date,
	       CASE 
		    WHEN os.refund_ts IS NOT NULL THEN 1 
		    ELSE 0 
	       END as refunded,
    	       CASE 
		    WHEN os.ship_ts < os.purchase_ts THEN NULL 
         	    ELSE EXTRACT(DAY FROM AGE(os.ship_ts::timestamp, os.purchase_ts::timestamp)) 
	       END as days_to_ship,
    	       CASE 
		    WHEN os.delivery_ts < os.ship_ts THEN NULL 
         	    ELSE EXTRACT(DAY FROM AGE(os.delivery_ts::timestamp, os.ship_ts::timestamp)) 
	       END as shipping_time,
    	       CASE 
	            WHEN os.refund_ts < os.delivery_ts THEN NULL 
         	    ELSE EXTRACT(DAY FROM AGE(os.refund_ts::timestamp, os.delivery_ts::timestamp)) 
	       END as days_to_return,
    	       CASE 
		    WHEN os.purchase_ts < c.created_on THEN NULL 
         	    ELSE EXTRACT(DAY FROM AGE(os.purchase_ts::timestamp, c.created_on::timestamp)) 
	       END as days_to_order
	FROM   order_status os LEFT JOIN orders o ON os.order_id = o.id
	                       LEFT JOIN customers c ON o.customer_id = c.id
)
SELECT  co.order_id,
  	co.customer_id,
  	co.purchase_date,
  	co.product_id,
  	co.product_name, 
  	co.brand_name,
  	co.product_category,        
  	co.currency,
        co.local_price,
  	co.usd_price,
  	co.purchase_platform,
  	co.customer_order_number,
  	co.year,
  	co.month,
  	cc.marketing_channel,
  	cc.account_creation_method,
  	cc.loyalty_program,
        cc.created_on,
  	cos.shipping_date,
  	cos.delivery_date,
  	cos.refund_date,
  	cos.refunded,
  	cos.days_to_ship,
  	cos.shipping_time,
  	cos.days_to_return,
  	cos.days_to_order,
  	cgl.country,
  	cgl.region
FROM    cleaned_orders co LEFT JOIN cleaned_customers cc ON co.customer_id = cc.customer_id
			  LEFT JOIN cleaned_geo_lookup cgl ON cgl.country = cc.country_code
			  LEFT JOIN cleaned_order_status cos ON cos.order_id = co.order_id
