/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights.
    - To identify overall trends or spot anomalies.

SQL Functions Used:
    - COUNT(), SUM(), AVG()
===============================================================================
*/

-- ====================================================================== 
-- 4) Measures Exploration
-- ======================================================================

-- Find the Total Sales
SELECT SUM(sales_amount) AS total_sales FROM datawarehouseanalytics.fact_sales;

-- Find how many items are sold
SELECT SUM(quantity) AS total_quantity FROM datawarehouseanalytics.fact_sales;

-- Find the average selling price
SELECT AVG(price) AS avg_price FROM datawarehouseanalytics.fact_sales;

-- Find the Total number of Orders
SELECT COUNT(order_number) AS total_orders FROM datawarehouseanalytics.fact_sales;
SELECT COUNT(DISTINCT order_number) AS total_orders FROM datawarehouseanalytics.fact_sales;

-- Find the Total number of products
SELECT COUNT(product_name) AS total_products FROM datawarehouseanalytics.dim_products;
SELECT COUNT(DISTINCT product_name) AS total_products FROM datawarehouseanalytics.dim_products;

-- Find the Total number of customers
SELECT COUNT(customer_key) AS total_customers FROM datawarehouseanalytics.dim_customers;

-- Find the total number of customers that has placed an order
SELECT COUNT(DISTINCT customer_key) AS total_customers FROM datawarehouseanalytics.fact_sales;

