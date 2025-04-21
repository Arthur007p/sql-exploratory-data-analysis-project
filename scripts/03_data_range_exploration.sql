/*
===============================================================================
Date Range Exploration 
===============================================================================
Purpose:
    - To determine the temporal boundaries of key data points.
    - To understand the range of historical data.

SQL Functions Used:
    - MIN(), MAX(), DATEDIFF()
===============================================================================
*/

-- ====================================================================== 
-- 3) Date Exploration
-- ======================================================================

-- Find the date of the first and last order
-- How many years of sales are avaiable

SELECT
MIN(order_date) AS first_order_date,
MAX(order_date) AS last_order_date,
DATEDIFF(MAX(order_date), MIN(order_date))/365 AS order_range_years
FROM gold.fact_sales;

-- Find the youngest and the oldest customer
SELECT 
MIN(birthdate) AS oldest_birthdate,
DATEDIFF(NOW(), MIN(birthdate))/365 AS oldest_age,
MAX(birthdate) AS youngest_birhdate,
DATEDIFF(NOW(), MAX(birthdate))/365 AS youngest_age
FROM gold.dim_customers;
