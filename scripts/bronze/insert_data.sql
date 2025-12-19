/*
---------------------------------------------------------------------
this script inserts data into the DataWarehouse_bronzes' tables.

I had to do it via the terminal using the command mysql --local-infile=1 -u root -p
for some reason the MySQL workbench wouldnt allow me to load data in this manner.

Alternatively:
mysql --local-infile=1 -u root -p

---------------------------------------------------------------------
*/

USE DataWarehouse_bronze;


TRUNCATE TABLE crm_sales_details;
TRUNCATE TABLE crm_cust_info;
TRUNCATE TABLE crm_prd_info;
TRUNCATE TABLE erp_cust_az12;
TRUNCATE TABLE erp_loc_a101;
TRUNCATE TABLE erp_px_cat_g1v2;
  
LOAD DATA LOCAL INFILE '/Users/paul/Desktop/MyMLandDataScienceJourney/DataAnalyst-course/Baraa_SQL_Ultimate_course/sql-data-warehouse-project/datasets/source_crm/sales_details.csv'
INTO TABLE crm_sales_details
FIELDS TERMINATED BY ',' -- column separator
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(sls_ord_num, sls_prd_key, sls_cust_id, sls_order_dt, sls_ship_dt, 
sls_due_dt, sls_sales, sls_quantity, sls_price);


LOAD DATA LOCAL INFILE '/Users/paul/Desktop/MyMLandDataScienceJourney/DataAnalyst-course/Baraa_SQL_Ultimate_course/sql-data-warehouse-project/datasets/source_crm/cust_info.csv'
INTO TABLE crm_cust_info
FIELDS TERMINATED BY ',' -- column separator
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(cst_id,cst_key,cst_firstname,cst_lastname,
cst_marital_status,cst_gndr,cst_create_date);


LOAD DATA LOCAL INFILE '/Users/paul/Desktop/MyMLandDataScienceJourney/DataAnalyst-course/Baraa_SQL_Ultimate_course/sql-data-warehouse-project/datasets/source_crm/prd_info.csv'
INTO TABLE crm_prd_info
FIELDS TERMINATED BY ',' -- column separator
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(prd_id,prd_key,prd_nm,prd_cost,prd_line,prd_start_dt,prd_end_dt);


LOAD DATA LOCAL INFILE '/Users/paul/Desktop/MyMLandDataScienceJourney/DataAnalyst-course/Baraa_SQL_Ultimate_course/sql-data-warehouse-project/datasets/source_erp/CUST_AZ12.csv'
INTO TABLE erp_cust_az12
FIELDS TERMINATED BY ',' -- column separator
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(CID,BDATE,GEN);

LOAD DATA LOCAL INFILE '/Users/paul/Desktop/MyMLandDataScienceJourney/DataAnalyst-course/Baraa_SQL_Ultimate_course/sql-data-warehouse-project/datasets/source_erp/LOC_A101.csv'
INTO TABLE erp_loc_a101
FIELDS TERMINATED BY ',' -- column separator
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(CID,CNTRY);

LOAD DATA LOCAL INFILE '/Users/paul/Desktop/MyMLandDataScienceJourney/DataAnalyst-course/Baraa_SQL_Ultimate_course/sql-data-warehouse-project/datasets/source_erp/PX_CAT_G1V2.csv'
INTO TABLE erp_px_cat_g1v2
FIELDS TERMINATED BY ',' -- column separator
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(ID,CAT,SUBCAT,MAINTENANCE);
