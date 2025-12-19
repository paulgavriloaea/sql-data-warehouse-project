USE DataWarehouse_silver;

-- find if you have duplicates or nulls
SELECT
	prd_id,
    COUNT(*) AS count
FROM crm_prd_info
GROUP BY prd_id
HAVING count>1 OR prd_id IS NULL;

-- check for unwanted spaces

SELECT prd_nm
FROM crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- check for nulls or negative numbers

SELECT 
prd_cost
FROM crm_prd_info
WHERE prd_cost IS NULL OR prd_cost<0;

-- Data standardization and consistency
SELECT DISTINCT prd_line
FROM crm_prd_info;

-- check for invalid data orders

SELECT *
FROM crm_prd_info
WHERE prd_end_dt<prd_start_dt;
