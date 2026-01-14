-- this is the second test script in continuation to data_exploration.sql
-- it focuses on advanced data analytics as described below



/*
===============================================================================
7. Change Over Time Analysis

Purpose:
    - To track trends, growth, and changes in key metrics over time.
    - For time-series analysis and identifying seasonality.
    - To measure growth or decline over specific periods.

SQL Functions Used:
    - Date Functions: MONTH(), YEAR(), DATE_FORMAT()
    - Aggregate Functions: SUM(), COUNT(), AVG()
===============================================================================
*/



-- analyse sales performance over time

-- data per year
SELECT
	YEAR(order_date) AS order_year,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM DataWarehouse_gold.fact_sales
WHERE order_date IS NOT NULL 
GROUP BY order_year 
ORDER BY order_year;

-- data per month for all years
SELECT
	MONTH(order_date) AS order_month,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM DataWarehouse_gold.fact_sales
WHERE order_date IS NOT NULL 
GROUP BY order_month
ORDER BY order_month;

-- data per month per individual years

SELECT
	YEAR(order_date) AS order_year,
	MONTH(order_date) AS order_month,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM DataWarehouse_gold.fact_sales
WHERE order_date IS NOT NULL  
GROUP BY 
	order_year,
	order_month
ORDER BY 
	order_year,
    order_month;
-- same but using date_format instead of year(), month()

SELECT
	DATE_FORMAT(order_date, '%Y-%b') AS order_date,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM DataWarehouse_gold.fact_sales
WHERE order_date IS NOT NULL  
GROUP BY order_date
ORDER BY order_date;


/*
===============================================================================
8. Cumulative Analysis

Purpose:
    - To calculate running totals or moving averages for key metrics.
    - To track performance over time cumulatively.
    - Useful for growth analysis or identifying long-term trends.

SQL Functions Used:
    - Window Functions: SUM() OVER(), AVG() OVER()
===============================================================================
*/


-- calculate the total sales per month 
-- and the running total of sales over time

-- had to use DATE_FORMAT(date, format) instead of DATE_TRUNC(month, date)
SELECT
	order_date,
    current_total,
    SUM(current_total) OVER(ORDER BY order_date) AS running_total_sales
FROM(
SELECT
	DATE_FORMAT(order_date, '%Y-%m-01') AS order_date,
    SUM(sales_amount) AS current_total
FROM DataWarehouse_gold.fact_sales
WHERE order_date IS NOT NULL 
GROUP BY DATE_FORMAT(order_date, '%Y-%m-01')) t;

-- or 
SELECT
	DATE_FORMAT(order_date, '%Y-%m-01') AS order_date,
    SUM(sales_amount) AS current_total,
    SUM(SUM(sales_amount)) OVER(ORDER BY DATE_FORMAT(order_date, '%Y-%m-01')
								ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) running_total  -- this is the default ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW, can skip it
FROM DataWarehouse_gold.fact_sales
WHERE order_date IS NOT NULL 
GROUP BY DATE_FORMAT(order_date, '%Y-%m-01');

-- partition by year 
SELECT
	DATE_FORMAT(order_date, '%Y-%m-01') AS order_date,
    SUM(sales_amount) AS current_total,
    SUM(SUM(sales_amount)) OVER(PARTITION BY DATE_FORMAT(order_date, '%Y-%m-01')
							    ORDER BY DATE_FORMAT(order_date, '%Y-%m-01')
								ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) running_total  -- this is the default ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW, can skip it
FROM DataWarehouse_gold.fact_sales
WHERE order_date IS NOT NULL 
GROUP BY DATE_FORMAT(order_date, '%Y-%m-01');

-- aggregate by years

SELECT
	DATE_FORMAT(order_date, '%Y-01-01') AS order_date,
    SUM(sales_amount) AS current_total,
    SUM(SUM(sales_amount)) OVER(PARTITION BY DATE_FORMAT(order_date, '%Y-01-01')
							    ORDER BY DATE_FORMAT(order_date, '%Y-01-01')
								ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) running_total  -- this is the default ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW, can skip it
FROM DataWarehouse_gold.fact_sales
WHERE order_date IS NOT NULL 
GROUP BY DATE_FORMAT(order_date, '%Y-01-01');

-- include the average price 

SELECT
	DATE_FORMAT(order_date, '%Y-01-01') AS order_date,
    SUM(sales_amount) AS current_total,
    SUM(SUM(sales_amount)) OVER(ORDER  BY DATE_FORMAT(order_date, '%Y-01-01')) running_total_sales,  -- this is the default ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW, can skip it
    AVG(price) AS avg_price_per_year,
	AVG(AVG(price)) OVER(ORDER BY DATE_FORMAT(order_date, '%Y-01-01')) moving_average
FROM DataWarehouse_gold.fact_sales
WHERE order_date IS NOT NULL 
GROUP BY DATE_FORMAT(order_date, '%Y-01-01');
 
/*
===============================================================================
9. Performance Analysis (Year-over-Year, Month-over-Month)

Purpose:
    - To measure the performance of products, customers, or regions over time.
    - For benchmarking and identifying high-performing entities.
    - To track yearly trends and growth.

SQL Functions Used:
    - LAG(): Accesses data from previous rows.
    - AVG() OVER(): Computes average values within partitions.
    - CASE: Defines conditional logic for trend analysis.
===============================================================================
*/


 -- analyze the performance of products by comparing each product's sales to both 
 -- its average sales performance and the previous year's sales
 
 WITH yearly_product_sales AS(
 SELECT 
	 YEAR(fs.order_date) AS order_year,	
	 dp.product_name,
     SUM(fs.sales_amount) AS current_sales
 FROM DataWarehouse_gold.fact_sales AS fs
 LEFT JOIN DataWarehouse_gold.dim_products AS dp
 ON fs.product_key = dp.product_key
 WHERE fs.order_date IS NOT NULL
 GROUP BY YEAR(fs.order_date),dp.product_name
 )
SELECT 
order_year,
product_name,
current_sales,
LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) prev_year_sales,
AVG(current_sales) OVER(PARTITION BY product_name) AS avg_sales,
current_sales-AVG(current_sales) OVER(PARTITION BY product_name) avg_diff,
CASE 
	WHEN current_sales-AVG(current_sales) OVER(PARTITION BY product_name) < 0 THEN 'Below Avg'
    WHEN current_sales-AVG(current_sales) OVER(PARTITION BY product_name) > 0 THEN 'Above Avg'
    ELSE 'Avg'
END AS avg_change,
current_sales - LAG(current_sales,1,NULL) OVER(PARTITION BY product_name) AS prev_year_diff,
CASE 
	WHEN current_sales-LAG(current_sales,1,NULL) OVER(PARTITION BY product_name) < 0 THEN 'Decrease'
    WHEN current_sales-LAG(current_sales,1,NULL) OVER(PARTITION BY product_name) > 0 THEN 'Increase'
    ELSE 'No change'
END AS prev_year_change
FROM yearly_product_sales
ORDER BY product_name, order_year;

/*
===============================================================================
10. Part-to-Whole Analysis

Purpose:
    - To compare performance or metrics across dimensions or time periods.
    - To evaluate differences between categories.
    - Useful for A/B testing or regional comparisons.

SQL Functions Used:
    - SUM(), AVG(): Aggregates values for comparison.
    - Window Functions: SUM() OVER() for total calculations.
===============================================================================
*/


-- which countries contribute the most to the overall sales?


WITH sales_per_country AS (
SELECT 
dc.country,
SUM(fs.sales_amount) AS sales
FROM DataWarehouse_gold.fact_sales AS fs
LEFT JOIN DataWarehouse_gold.dim_customers AS dc
ON dc.customer_key = fs.customer_key
GROUP BY dc.country)

SELECT
	country,
    sales,
    SUM(sales) OVER() total_sales,
    (sales/SUM(sales) OVER())*100.0 'country performance (%)'
FROM sales_per_country;


-- which categories contribute the most to the overall sales?


WITH sales_per_category AS (
SELECT 
dp.category,
SUM(fs.sales_amount) AS sales
FROM DataWarehouse_gold.fact_sales AS fs
LEFT JOIN DataWarehouse_gold.dim_products AS dp
ON dp.product_key = fs.product_key
GROUP BY dp.category)

SELECT
	category,
    sales,
    SUM(sales) OVER() total_sales,
    CONCAT(ROUND((CAST(sales AS FLOAT) /SUM(sales) OVER())*100.0,2),' %') 'category performance (%)'
FROM sales_per_category;

/*
===============================================================================
11. Data Segmentation Analysis
===============================================================================
Purpose:
    - To group data into meaningful categories for targeted insights.
    - For customer segmentation, product categorization, or regional analysis.

SQL Functions Used:
    - CASE: Defines custom segmentation logic.
    - GROUP BY: Groups data into segments.
===============================================================================
*/


-- segment products into cost ranges and count how many products fall into each segment
WITH product_segment AS(
SELECT
	product_key,
    product_name,
    cost,
    CASE WHEN cost<100 THEN 'Below 100'
		 WHEN cost BETWEEN 100 AND 500 THEN '100-500'
         WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
         ELSE 'Above 1000'
	END AS cost_range
FROM DataWarehouse_gold.dim_products)

SELECT 
cost_range,
COUNT(product_name) total_products
FROM product_segment
GROUP BY cost_range
ORDER BY total_products;

-- group customers into three segments
-- based on their spending behaviour:
-- VIP 12 months of history and spending more than 5.000 EUR
-- regular at least 12 month of history but spending 5.000 EUR or less
-- new: lifespan less than 12 months.
-- find the total number of customers for each category

WITH customer_spending AS(
SELECT 
	dc.customer_key,
    MIN(fs.order_date) first_order,
    MAX(fs.order_date) last_order,
	TIMESTAMPDIFF(MONTH, MIN(fs.order_date), MAX(fs.order_date) ) life_span,
    SUM(fs.sales_amount) AS total_sales
FROM DataWarehouse_gold.fact_sales AS fs
LEFT JOIN DataWarehouse_gold.dim_customers AS dc
ON dc.customer_key = fs.customer_key
GROUP BY dc.customer_key
ORDER BY dc.customer_key)

SELECT
segment,
COUNT(segment)
FROM (
SELECT 
customer_key,
CASE WHEN life_span>=12 AND total_sales>5000 THEN 'VIP'
     WHEN life_span>=12 AND total_sales<=5000 THEN 'Regular'
     WHEN life_span<12 THEN 'New'
END AS segment
FROM customer_spending) t
GROUP BY segment;








