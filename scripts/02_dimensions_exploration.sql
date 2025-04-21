/*
===============================================================================
Dimensions Exploration
===============================================================================
Purpose:
    - To explore the structure of dimension tables.
	
SQL Functions Used:
    - DISTINCT
    - ORDER BY
===============================================================================
*/

-- ====================================================================== 
-- 2) Dimensions Exploration 
-- ======================================================================

-- Explore All Countries our customers come from.
SELECT DISTINCT 
	country 
FROM datawarehouseanalytics.dim_customers
ORDER BY country;

-- Explore All Categories "The major Divisions"
SELECT DISTINCT category, subcategory, product_name 
FROM gold.dim_products 
ORDER BY category, subcategory, product_name;
