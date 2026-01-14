/*
===============================================================================
Product Report
===============================================================================
Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
       - total orders
       - total sales
       - total quantity sold
       - total customers (unique)
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - recency (months since last sale)
       - average order revenue (AOR)
       - average monthly revenue
===============================================================================
*/
-- =============================================================================
-- Create Report: DataWarehouse_gold.report_products
-- =============================================================================

CREATE VIEW DataWarehouse_gold.report_products AS
WITH gather_data AS(
/*Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
*/
SELECT
	f.sales_amount,
	f.order_date,
	f.quantity,
	f.price,
	f.customer_key,
	p.product_key,
	p.product_name,
	p.category,
	p.subcategory,
	p.cost
FROM DataWarehouse_gold.fact_sales AS f
JOIN DataWarehouse_gold.dim_products AS p
ON f.product_key = p.product_key
WHERE order_date IS NOT NULL),

product_aggregation AS(
-- product aggregations: summarizes key metrics at the product level.
SELECT 
	product_key,
	product_name,
	category,
	subcategory,
	cost,
    COUNT(DISTINCT order_date) AS total_orders,
    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS total_quantity,
    COUNT(DISTINCT customer_key) AS unique_customers,
	TIMESTAMPDIFF(MONTH,MIN(order_date),MAX(order_date)) AS lifespan,
    MAX(order_date) AS last_order_date
FROM gather_data
GROUP BY 
product_key,
product_name,
category,
subcategory,
cost)

SELECT 
	product_key,
	product_name,
	category,
	subcategory,
	cost,
    total_orders,
    total_sales,
    total_quantity,
    unique_customers,
	lifespan,
    last_order_date,
    -- recency
	TIMESTAMPDIFF(MONTH, last_order_date, NOW()) AS recency,
    -- product segmentation
	CASE
		WHEN total_sales > 50000 THEN 'High-Performer'
		WHEN total_sales >= 10000 THEN 'Mid-Range'
		ELSE 'Low-Performer'
	END AS product_segment,
    -- average order revenue
   CASE WHEN total_orders=0 THEN 0
		ELSE (total_sales/total_orders) 
   END AS average_revenue,
	-- average monthly revenue
    CASE WHEN lifespan=0 THEN total_sales
		 ELSE total_sales/lifespan
    END AS average_monthly_revenue
FROM product_aggregation;
