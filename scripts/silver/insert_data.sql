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

TRUNCATE TABLE DataWarehouse_silver.crm_prd_info;

INSERT INTO DataWarehouse_silver.crm_prd_info(prd_id,cat_id,prd_key,prd_nm,
prd_cost,prd_line,prd_start_dt,prd_end_dt)

SELECT
	prd_id,
    REPLACE(SUBSTRING(prd_key, 1, 5), '-','_') AS cat_id,
    SUBSTRING(prd_key, 7, LENGTH(prd_key)) AS prd_key, 
    prd_nm,
    IFNULL(prd_cost,0) AS prd_cost,
    CASE WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
         WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
         WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'other Sales'
         WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
         ELSE 'n/a'
	END AS prd_line,
    CAST(prd_start_dt AS DATE) AS prd_start_dt,
    CAST(
    DATE_SUB(
        LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt),
        INTERVAL 1 DAY
    ) AS DATE
) AS prd_end_dt
FROM crm_prd_info;

