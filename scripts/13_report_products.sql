/*
====================================================================================================
Product Report
====================================================================================================
Purpose:
	-This report consolidates key products metrics and behaviors.
    
Highlights:
	1. Gathers essential fields such as names, ages, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
		- total orders
        - total sales
        - total quantity sold
        - total customers (unique)
        - lifespan (in months)
	4. Calculates valuable KPIs:
		- recency (months since last sales)
        - average order revenue (AOR)
        - average monthly revenue
====================================================================================================
*/


-- CREATE VIEW datawarehouseanalytics.repor_products_V2 AS 
CREATE VIEW datawarehouseanalytics.report_products_v2 AS 
WITH base_query AS (
/*--------------------------------------------------------------------------------------------------
1) Base Query: Retrieves core columns from tables
--------------------------------------------------------------------------------------------------*/
SELECT 
	f.order_number,
    f.order_date,
    f.customer_key,
    f.product_key,
    f.sales_amount,
    f.quantity,
    p.product_name,
    p.category,
    p.subcategory,
    p.cost
FROM datawarehouseanalytics.fact_sales AS f
LEFT JOIN datawarehouseanalytics.dim_products AS p
ON f.product_key = p.product_key
WHERE order_date IS NOT NULL -- only consider valid sales dates
)
 ,products_agegation AS (
/*--------------------------------------------------------------------------------------------------
2) Product Aggregations: Summarizes key metrics at the product level
--------------------------------------------------------------------------------------------------*/
SELECT
	product_key,
    product_name,
    category,
    subcategory,
    cost,
    TIMESTAMPDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan,
    MAX(order_date) AS last_sale_date,
    COUNT(DISTINCT order_number) AS total_orders,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS total_quantity,
    ROUND(AVG(sales_amount / NULLIF(quantity, 0)),1) AS avg_selling_price
FROM base_query
GROUP BY 	
	product_key,
	product_name,
	category,
    subcategory,
	cost
)
 /*--------------------------------------------------------------------------------------------------
3) Final Query: Combines all product results into one output
--------------------------------------------------------------------------------------------------*/   
SELECT 
	product_key,
    product_name,
    category,
    subcategory,
    cost,
    last_sale_date,
    TIMESTAMPDIFF(MONTH, last_sale_date, NOW()) AS recency_in_months,
    CASE
		WHEN total_sales > 50000 THEN 'High-Performer'
        WHEN total_sales >= 10000 THEN 'Mid-Range'
        ELSE 'Low-Performer'
    END AS product_segment,
    lifespan,
    total_orders,
    total_sales,
    total_quantity,
    total_customers,
    avg_selling_price,
-- Average Order Revenue (AOR)
	CASE 
		WHEN total_orders = 0 THEN 0
        ELSE total_sales / total_orders
    END AS avg_order_revenue,
    
-- Average Monthly Revenue
	CASE
		WHEN lifespan = 0 THEN total_sales
        ELSE total_sales / lifespan
	END AS avg_monthly_revenue
FROM products_agegation; 
