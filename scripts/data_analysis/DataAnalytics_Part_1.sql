-- This is a test script used to follow the DataWithBaraa course on Data Analytics here: https://www.youtube.com/watch?v=SSKVgrwhzus&t=106643s described at 27:41:51 

-- the queries here are related to the Bronze/Silver/Gold Datawarehouse built within the same project.
 
-- Data Analysis consists in distinct steps hereon performed and described:

/* 
===============================================================================
1. Database Exploration
Purpose:
    - To explore the structure of the database, including the list of tables and their schemas.
    - To inspect the columns and metadata for specific tables.
    
    Table Used:
    - INFORMATION_SCHEMA.TABLES
    - INFORMATION_SCHEMA.COLUMNS
    - DataWarehouse_gold.fact_sales
===============================================================================
*/


USE DataWarehouse_gold;
SELECT DISTINCT
sales_amount
FROM DataWarehouse_gold.fact_sales;

-- Database exploration
SELECT * FROM INFORMATION_SCHEMA.TABLES;

SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers';


/* 
===============================================================================
2. Dimensions Exploration
Purpose:
    - To explore the structure of dimension tables.
	
SQL Functions Used:
    - DISTINCT
    - ORDER BY
===============================================================================
*/
SELECT DISTINCT country FROM DataWarehouse_gold.dim_customers;

-- Explore all categories "The major divisions"alter
SELECT DISTINCT category,subcategory,product_name FROM DataWarehouse_gold.dim_products
ORDER BY 1,2,3;



/* 
===============================================================================
3. Data Range Exploration
Purpose:
    - To determine the temporal boundaries of key data points.
    - To understand the range of historical data.

SQL Functions Used:
    - MIN(), MAX(), TIMESTAMPDIFF()
===============================================================================
*/
SELECT 
MIN(order_date) AS first_order_date,
MAX(order_date) AS last_order_date,
TIMESTAMPDIFF(year, MIN(order_date), MAX(order_date)) AS order_range_years,
YEAR(MAX(order_date)) - YEAR(MIN(order_date)) AS order_range_years
FROM DataWarehouse_gold.fact_sales;

-- find the youngest and oldest customer
SELECT
MIN(birthdate) AS oldest_birthdate,
MAX(birthdate) AS youngest_birthdate,
TIMESTAMPDIFF(year, MIN(birthdate), NOW()) AS oldest_age,
TIMESTAMPDIFF(year, MAX(birthdate), NOW()) AS youngest_age
FROM DataWarehouse_gold.dim_customers;

/*

4. Measures exploration
===============================================================================
Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights.
    - To identify overall trends or spot anomalies.

SQL Functions Used:
    - COUNT(), SUM(), AVG()
===============================================================================
*/


-- find the total sales

SELECT SUM(sales_amount) AS total_sales FROM DataWarehouse_gold.fact_sales;
-- show how many items are sold
SELECT SUM(quantity) AS total_quantity FROM DataWarehouse_gold.fact_sales;
-- find the average selling price
SELECT AVG(price) AS average_price FROM DataWarehouse_gold.fact_sales;
-- find the total number of orders
SELECT COUNT(DISTINCT order_number) AS total_orders FROM DataWarehouse_gold.fact_sales;
-- find the total number of products
SELECT COUNT(DISTINCT product_key) AS total_products FROM DataWarehouse_gold.dim_products;
-- find the total number of customers
SELECT COUNT(customer_key) AS total_customers FROM DataWarehouse_gold.dim_customers;
-- find the total number of customers that has placed an order
 SELECT COUNT(DISTINCT customer_key) AS total_customers FROM DataWarehouse_gold.fact_sales;


-- Generate a report that shows all key metrics of the business
SELECT 'Total Sales' AS measure_name, SUM(sales_amount) AS measure_value FROM DataWarehouse_gold.fact_sales
UNION ALL 
SELECT 'Total Quantity' AS measure_name, SUM(quantity) AS measure_value FROM DataWarehouse_gold.fact_sales
UNION ALL 
SELECT 'Average Price' AS measure_name, AVG(price) AS average_price FROM DataWarehouse_gold.fact_sales
UNION ALL 
SELECT 'Total Orders' AS measure_name, COUNT(DISTINCT order_number) AS total_orders FROM DataWarehouse_gold.fact_sales
UNION ALL 
SELECT 'Total Products' AS measure_name, COUNT(DISTINCT product_key) AS total_products FROM DataWarehouse_gold.dim_products
UNION ALL 
SELECT 'Total Customers' AS measure_name, COUNT(customer_key) AS total_customers FROM DataWarehouse_gold.dim_customers;

/*
===============================================================================
5. Magnitude Analysis

Purpose:
    - To quantify data and group results by specific dimensions.
    - For understanding data distribution across categories.

SQL Functions Used:
    - Aggregate Functions: SUM(), COUNT(), AVG()
    - GROUP BY, ORDER BY
===============================================================================
*/
-- Find total customers by countries 
SELECT 
	country,
    COUNT(customer_key) AS total_customers 
FROM DataWarehouse_gold.dim_customers
GROUP BY country
ORDER BY total_customers DESC;
-- Find total customers by gender
SELECT
	gender,
    COUNT(customer_key) AS total_customers 
FROM DataWarehouse_gold.dim_customers
GROUP BY gender
ORDER BY total_customers DESC;
-- Find total products by category 
SELECT
	category,
	COUNT(DISTINCT product_key) AS total_products 
FROM DataWarehouse_gold.dim_products
GROUP BY category
ORDER BY total_products DESC;
-- What is the average costs in each category?
SELECT
	category,
    AVG(cost) AS average_cost
FROM DataWarehouse_gold.dim_products
GROUP BY category
ORDER BY average_cost DESC;
-- What is the total revenue generated for each category?
SELECT
category,
SUM(sales_amount) AS total_revenue
FROM(
SELECT 
	fs.order_number,
    fs.product_key,
    fs.sales_amount AS sales_amount,
    dp.category AS category
FROM DataWarehouse_gold.fact_sales AS fs
LEFT JOIN DataWarehouse_gold.dim_products AS dp
ON fs.product_key = dp.product_key) t
GROUP BY category
ORDER BY total_revenue DESC;
-- Find total revenue generated by each customer

SELECT 
    dc.customer_key,
	dc.first_name,
	dc.last_name,
    SUM(fs.sales_amount) AS total_sales
FROM DataWarehouse_gold.fact_sales AS fs
LEFT JOIN DataWarehouse_gold.dim_customers AS dc
ON fs.customer_key = dc.customer_key
GROUP BY 
	dc.customer_key,
    dc.first_name,
    dc.last_name
ORDER BY total_sales DESC;
-- What is the distribution of sold items across countries?

SELECT 
	dc.country,
	SUM(fs.quantity) sold_items_total
FROM DataWarehouse_gold.fact_sales AS fs 
LEFT JOIN DataWarehouse_gold.dim_customers AS dc
ON fs.customer_key = dc.customer_key
GROUP BY dc.country
ORDER BY sold_items_total DESC;

/*
===============================================================================
6. Ranking Analysis

Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK()
    - Clauses: GROUP BY, ORDER BY, LIMIT
===============================================================================
*/

-- which 5 products generate the highest revenue

SELECT
*
FROM(
SELECT 
	RANK() OVER(ORDER BY SUM(fs.sales_amount) DESC) AS position,
    dp.product_name,
    SUM(fs.sales_amount) total_sales_per_product
FROM DataWarehouse_gold.fact_sales AS fs
LEFT JOIN DataWarehouse_gold.dim_products AS dp
ON fs.product_key = dp.product_key
GROUP BY dp.product_name)t
WHERE position<=5;


-- or simpler
SELECT
    dp.product_name,
    SUM(fs.sales_amount) total_sales_per_product
FROM DataWarehouse_gold.fact_sales AS fs
LEFT JOIN DataWarehouse_gold.dim_products AS dp
ON fs.product_key = dp.product_key
GROUP BY dp.product_name
ORDER BY total_sales_per_product DESC
LIMIT 5;

-- What are the 5-worst performing products in terms of sales
SELECT
*
FROM(
SELECT 
	RANK() OVER(ORDER BY SUM(fs.sales_amount) ASC) AS position,
    dp.product_name,
    SUM(fs.sales_amount) total_sales_per_product
FROM DataWarehouse_gold.fact_sales AS fs
LEFT JOIN DataWarehouse_gold.dim_products AS dp
ON fs.product_key = dp.product_key
GROUP BY dp.product_name)t
WHERE position<=5;

-- or simpler
SELECT
    dp.product_name,
    SUM(fs.sales_amount) total_sales_per_product
FROM DataWarehouse_gold.fact_sales AS fs
LEFT JOIN DataWarehouse_gold.dim_products AS dp
ON fs.product_key = dp.product_key
GROUP BY dp.product_name
ORDER BY total_sales_per_product ASC
LIMIT 5;

-- find the top 10 customers who have generated the highest revenue


SELECT 
    dc.customer_key,
	dc.first_name,
	dc.last_name,
    SUM(fs.sales_amount) AS total_sales
FROM DataWarehouse_gold.fact_sales AS fs
LEFT JOIN DataWarehouse_gold.dim_customers AS dc
ON fs.customer_key = dc.customer_key
GROUP BY 
	dc.customer_key,
    dc.first_name,
    dc.last_name
ORDER BY total_sales DESC
LIMIT 10;

-- and 3 customers with the fewest orders placed
SELECT 
    dc.customer_key,
	dc.first_name,
	dc.last_name,
    COUNT(DISTINCT order_number) AS total_orders
FROM DataWarehouse_gold.fact_sales AS fs
LEFT JOIN DataWarehouse_gold.dim_customers AS dc
ON fs.customer_key = dc.customer_key
GROUP BY 
	dc.customer_key,
    dc.first_name,
    dc.last_name
ORDER BY total_orders ASC
LIMIT 3;