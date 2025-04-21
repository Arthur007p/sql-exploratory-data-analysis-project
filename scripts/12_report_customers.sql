/*
====================================================================================================
Customer Report
====================================================================================================
Purpose:
	-This report consolidates key customer metrics and behaviors
    
Highlights:
	1. Gathers essential fields such as names, ages, and transation details.
    2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
		- total orders
        - total sales
        - total quantity purchased
        - total products
        - lifespan (in months)
	4. Calculates valuable KPIs:
		- recency (months since last order)
        - average order values
        - average monthly spend
====================================================================================================
*/

CREATE VIEW datawarehouseanalytics.report_customers_v1 AS 
WITH base_query AS (
/*--------------------------------------------------------------------------------------------------
1) Base Query: Retrieves core columns from tables
--------------------------------------------------------------------------------------------------*/
SELECT 
	f.order_number,
    f.product_key,
    f.order_date,
    f.sales_amount,
    f.quantity,
    c.customer_key,
    c.customer_number,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    TIMESTAMPDIFF(year, c.birthdate, NOW()) AS age
FROM datawarehouseanalytics.fact_sales AS f
LEFT JOIN datawarehouseanalytics.dim_customers AS c
ON c.customer_key = f.customer_key
WHERE order_date IS NOT NULL
)
, customer_aggregation AS (
/*--------------------------------------------------------------------------------------------------
2) Segments customers into categories (VIP, Regular, New) and age groups.
--------------------------------------------------------------------------------------------------*/
SELECT
	customer_key,
    customer_number,
    customer_name,
    age,
    COUNT(DISTINCT order_number) AS total_orders,
    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS total_quantity,
    COUNT(DISTINCT product_key) AS total_products,
    MAX(order_date) AS last_order_date,
    TIMESTAMPDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan
FROM base_query
GROUP BY
	customer_key,
    customer_number,
    customer_name,
    age
)

SELECT
	customer_key,
    customer_number,
    customer_name,
    age,
    CASE
		WHEN age < 20 THEN 'Under 20'
        WHEN age BETWEEN 20 AND 29 THEN '20-29'
        WHEN age BETWEEN 30 AND 39 THEN '30-39'
        WHEN age BETWEEN 40 AND 49 THEN '40-49'
        ELSE '50 and above'
    END AS age_group,
	CASE
		WHEN lifespan >= 12 AND total_sales> 5000 THEN 'VIP'
		WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
		ELSE 'New'
	END AS customer_segment,
    last_order_date,
    TIMESTAMPDIFF(MONTH, last_order_date, NOW()) AS recency,
    total_orders,
    total_sales,
    total_quantity,
    total_products,
    lifespan,
-- Compuate average order value (AVO)
    CASE
		WHEN total_sales = 0 THEN 0
        ELSE ROUND(total_sales / total_orders,2)
    END AS avg_order_value,
-- Compueate average monthly spend
	CASE
	WHEN lifespan = 0 THEN total_sales
    ELSE ROUND(total_sales / lifespan, 2)
	END AS avg_monthly_spend
FROM customer_aggregation;
-- ---------------------------------------------------------------------------------------
