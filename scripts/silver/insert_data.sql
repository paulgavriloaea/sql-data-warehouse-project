SET sql_mode = ''; -- temp. disables strict mode 

USE DataWarehouse_bronze;
  
-- helps me remove duplicate entries and focuses on the most recent entry for a given cst_id
-- also trims white spaces
-- changes some single lettered values to full on words

TRUNCATE TABLE DataWarehouse_silver.crm_cust_info;

INSERT INTO DataWarehouse_silver.crm_cust_info(cst_id,cst_key,cst_firstname,cst_lastname,
cst_marital_status,cst_gndr,cst_create_date)

SELECT
cst_id,
cst_key,
TRIM(cst_firstname) AS cst_firstname,
TRIM(cst_lastname) AS cst_lastname,
CASE WHEN UPPER(TRIM(cst_marital_status))='S' THEN 'Single'
	 WHEN UPPER(TRIM(cst_marital_status))='M' THEN 'Married'
	 ELSE 'n/a'
END cst_marital_status,
CASE WHEN UPPER(TRIM(cst_gndr))='M' THEN 'Male'
	 WHEN UPPER(TRIM(cst_gndr))='F' THEN 'Female'
	 ELSE 'n/a'
END cst_gndr,
cst_create_date
FROM(
SELECT
*,
ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
FROM crm_cust_info)t
WHERE flag_last=1;
