/*
---------------------------------------------------------------------
This scripts creates the source tables inside the Datawarehouse_bronze
WARNING:
It also deletes them if they already exist.
---------------------------------------------------------------------
*/ 

USE DataWarehouse_bronze;

DROP TABLE IF EXISTS crm_cust_info, crm_sales_details, crm_prd_info,
erp_cust_az12, erp_loc_a101, erp_px_cat_g1v2;


CREATE TABLE crm_cust_info(
	cst_id INT,
	cst_key NVARCHAR(50),
	cst_firstname NVARCHAR(50),
	cst_lastname NVARCHAR(50),
	cst_marital_status NVARCHAR(50),
	cst_gndr NVARCHAR(50),
	cst_create_date DATE
);

-- sls_ord_num,sls_prd_key,sls_cust_id,sls_order_dt,
-- sls_ship_dt,sls_due_dt,sls_sales,sls_quantity,sls_price
CREATE TABLE crm_sales_details(
	sls_ord_num NVARCHAR(50),
    sls_prd_key NVARCHAR(50),
    sls_cust_id INT,
    sls_order_dt INT,
    sls_ship_dt INT,
    sls_due_dt INT,
    sls_sales INT,
    sls_quantity INT,
    sls_price INT
);


CREATE TABLE crm_prd_info(
	prd_id INT,
    prd_key NVARCHAR(50),
    prd_nm NVARCHAR(50),
    prd_cost INT,
    prd_line NVARCHAR(50),
    prd_start_dt DATETIME,
    prd_end_dt DATETIME
);


CREATE TABLE erp_cust_az12(
	cid NVARCHAR(50),
    bdate DATE,
    gen NVARCHAR(50)
);

CREATE TABLE erp_loc_a101(
	cid NVARCHAR(50),
    cntry NVARCHAR(50)
);

CREATE TABLE erp_px_cat_g1v2(
	id NVARCHAR(50),
    cat NVARCHAR(50),
    subcat NVARCHAR(50),
    maintenance NVARCHAR(50)
);
