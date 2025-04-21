/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - To group data into meaningful categories for targeted insights.
    - For customer segmentation, product categorization, or regional analysis.

SQL Functions Used:
    - CASE: Defines custom segmentation logic.
    - GROUP BY: Groups data into segments.
===============================================================================
*/

-- ====================================================================== 
-- 10) Part-to-Whole (Proportional)
-- ======================================================================

-- Which categories contribute the most to overall sales?

WITH category_sales AS (
SELECT 
	category,
    SUM(sales_amount) AS total_sales
FROM datawarehouseanalytics.fact_sales AS f
LEFT JOIN datawarehouseanalytics.dim_products AS p
ON p.product_key = f.product_key
GROUP BY category
)
SELECT 
	category,
    total_sales,
    SUM(total_sales) OVER() AS overall_sales,
    CONCAT(ROUND((total_sales / SUM(total_sales) OVER()) *100, 2), '%') AS percentage_of_total
FROM category_sales
ORDER BY total_sales DESC; 

