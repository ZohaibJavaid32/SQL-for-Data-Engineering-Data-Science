
WITH ranked_orders AS 
(
  SELECT 
  	customer_id,
  	order_date,
  	order_amount,
  	ROW_NUMBER() OVER(PARTITION BY customer_id 
                ORDER BY order_date) AS rn
  FROM orders
),
pivoted_data AS
(
  SELECT 
  	customer_id ,
  	CASE WHEN rn=1 THEN order_amount END
  	AS latest_order,
  	CASE WHEN rn=2 THEN order_amount END
  	AS second_latest
  FROM ranked_orders
  WHERE rn IN (1 , 2)
)

SELECT 
	customer_id,
    MAX(latest_order) AS latest_order,
    MAX(second_latest) AS second_latest
FROM pivoted_data
GROUP BY customer_id

