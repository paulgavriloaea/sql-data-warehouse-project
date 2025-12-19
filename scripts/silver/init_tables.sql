/*
---------------------------------------------------------------------
This scripts creates the source tables inside the Datawarehouse_silver
WARNING:
It also deletes them if they already exist.
---------------------------------------------------------------------
*/ 

USE DataWarehouse_silver;

DROP TABLE IF EXISTS crm_cust_info, crm_sales_details, crm_prd_info,
erp_cust_az12, erp_loc_a101, erp_px_cat_g1v2;


CREATE TABLE crm_cust_info(
	cst_id INT,
	cst_key NVARCHAR(50),
	cst_firstname NVARCHAR(50),
	cst_lastname NVARCHAR(50),
	cst_marital_status NVARCHAR(50),
	cst_gndr NVARCHAR(50),
	cst_create_date DATE,
	dhw_create_datetime DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- sls_ord_num,sls_prd_key,sls_cust_id,sls_order_dt,
-- sls_ship_dt,sls_due_dt,sls_sales,sls_quantity,sls_price
CREATE TABLE crm_sales_details(
	sls_ord_num NVARCHAR(50),
    sls_prd_key NVARCHAR(50),
    sls_cust_id INT,
    sls_order_dt DATE,
    sls_ship_dt DATE,
    sls_due_dt DATE,
    sls_sales INT,
    sls_quantity INT,
    sls_price INT,
	dhw_create_datetime DATETIME DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE crm_prd_info(
	prd_id INT,
	cat_id NVARCHAR(50),
    prd_key NVARCHAR(50),
    prd_nm NVARCHAR(50),
    prd_cost INT,
    prd_line NVARCHAR(50),
    prd_start_dt DATE,
    prd_end_dt DATE,
	dhw_create_datetime DATETIME DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE erp_cust_az12(
	CID NVARCHAR(50),
    BDATE DATE,
    GEN NVARCHAR(50),
	dhw_create_datetime DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE erp_loc_a101(
	CID NVARCHAR(50),
    CNTRY NVARCHAR(50),
	dhw_create_datetime DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE erp_px_cat_g1v2(
	ID NVARCHAR(50),
    CAT NVARCHAR(50),
    SUBCAT NVARCHAR(50),
    MAINTENANCE NVARCHAR(50),
    dhw_create_datetime DATETIME DEFAULT CURRENT_TIMESTAMP
);
