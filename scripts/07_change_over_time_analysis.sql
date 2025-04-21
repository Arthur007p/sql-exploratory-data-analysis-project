/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    - To track trends, growth, and changes in key metrics over time.
    - For time-series analysis and identifying seasonality.
    - To measure growth or decline over specific periods.

SQL Functions Used:
    - Date Functions: DATEPART(), DATETRUNC(), FORMAT()
    - Aggregate Functions: SUM(), COUNT(), AVG()
===============================================================================
*/

-- ====================================================================== 
-- 7) Change-Over-Time
-- ======================================================================

SELECT 
	YEAR(order_date) AS order_year,
    SUM(sales_amount) AS total_sales
FROM datawarehouseanalytics.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date);

SELECT 
	YEAR(order_date) AS order_year,
	MONTH(order_date) AS order_month,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM datawarehouseanalytics.fact_sales
WHERE order_date IS NOT NULL AND order_date != 0
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date);

-- Trunk SALES for first day of month
SELECT 
    DATE_FORMAT(order_date, '%Y-%m-01') AS order_month_start,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM datawarehouseanalytics.fact_sales
WHERE order_date IS NOT NULL AND order_date != 0
GROUP BY DATE_FORMAT(order_date, '%Y-%m-01')
ORDER BY DATE_FORMAT(order_date, '%Y-%m-01');
