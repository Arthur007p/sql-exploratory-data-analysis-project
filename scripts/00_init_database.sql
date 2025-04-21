/*
=============================================================
Create Database and Schemas
=============================================================
Script Purpose:
    This script creates a new database named 'DataWarehouseAnalytics' after checking if it already exists. 
    If the database exists, it is dropped and recreated.
	
WARNING:
    Running this script will drop the entire 'DataWarehouseAnalytics' database if it exists. 
    All data in the database will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this script.
*/

-- =================================================================
-- Create tables to import data from CSV files.
-- =================================================================
DROP TABLE IF EXISTS fact_sales; 
CREATE TABLE fact_sales (
	order_number VARCHAR(50),
	product_key INT,
	customer_key INT,
	order_date DATE,
    shipping_date DATE,
	due_date DATE,
	sales_amount INT,
	quantity INT,
	price INT
);

DROP TABLE IF EXISTS report_customers;
CREATE TABLE report_customers (
  customer_key INT,
  customer_number VARCHAR(20),
  customer_name VARCHAR(100),
  age INT,
  age_group VARCHAR(50),
  customer_segment VARCHAR(50),
  last_order_date DATE,
  recency INT,
  total_orders INT,
  total_sales DECIMAL(10,2),
  total_quantity INT,
  lifespan INT,
  avg_order_value DECIMAL(10,2),
  avg_monthly_spend DECIMAL(10,2)
);

DROP TABLE IF EXISTS report_products;
CREATE TABLE report_products (
  product_key INT,
  product_name VARCHAR(150),
  category VARCHAR(50),
  subcategory VARCHAR(50),
  cost DECIMAL(10,2),
  last_sale_date DATE,
  recency_in_months INT,
  product_segment VARCHAR(50),
  lifespan INT,
  total_orders INT,
  total_sales DECIMAL(15,2),
  total_quantity INT,
  total_customers INT,
  avg_selling_price DECIMAL(10,2),
  avg_order_revenue DECIMAL(10,2),
  avg_monthly_revenue DECIMAL(15,2)
);

DROP TABLE IF EXISTS dim_customers;
CREATE TABLE dim_customers (
  customer_key INT,
  customer_id INT,
  customer_number VARCHAR(20),
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  country VARCHAR(50),
  marital_status VARCHAR(20),
  gender VARCHAR(10),
  birthdate DATE,
  create_date DATE
);

DROP TABLE IF EXISTS dim_products;
CREATE TABLE dim_products (
  product_key INT,
  product_id INT,
  product_number VARCHAR(30),
  product_name VARCHAR(150),
  category_id VARCHAR(20),
  category VARCHAR(50),
  subcategory VARCHAR(50),
  maintenance VARCHAR(5),
  cost DECIMAL(10,2),
  product_line VARCHAR(50),
  start_date DATE
);

-- =================================================================
-- Upload data into the tables
-- =================================================================

TRUNCATE TABLE datawarehouseanalytics.dim_customers;
LOAD DATA LOCAL INFILE 'C:\\Users\\javi_\\Downloads\\sql-data-analytics-project\\sql-data-analytics-project\\datasets\\csv-files\\gold.dim_customers.csv'
INTO TABLE datawarehouseanalytics.dim_customers
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- ---------------------------------------------------------------
TRUNCATE TABLE datawarehouseanalytics.dim_products;
LOAD DATA LOCAL INFILE 'C:\\Users\\javi_\\Downloads\\sql-data-analytics-project\\sql-data-analytics-project\\datasets\\csv-files\\gold.dim_products.csv'
INTO TABLE datawarehouseanalytics.dim_products
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;
-- ---------------------------------------------------------------
TRUNCATE TABLE datawarehouseanalytics.fact_sales;
LOAD DATA LOCAL INFILE 'C:\\Users\\javi_\\Downloads\\sql-data-analytics-project\\sql-data-analytics-project\\datasets\\csv-files\\gold.fact_sales.csv'
INTO TABLE datawarehouseanalytics.fact_sales
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;
-- ---------------------------------------------------------------
TRUNCATE TABLE datawarehouseanalytics.report_customers;
LOAD DATA LOCAL INFILE 'C:\\Users\\javi_\\Downloads\\sql-data-analytics-project\\sql-data-analytics-project\\datasets\\csv-files\\gold.report_customers.csv'
INTO TABLE datawarehouseanalytics.report_customers
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;
-- ---------------------------------------------------------------
TRUNCATE TABLE datawarehouseanalytics.report_products;
LOAD DATA LOCAL INFILE 'C:\\Users\\javi_\\Downloads\\sql-data-analytics-project\\sql-data-analytics-project\\datasets\\csv-files\\gold.report_products.csv'
INTO TABLE datawarehouseanalytics.report_products
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;
-- ---------------------------------------------------------------
