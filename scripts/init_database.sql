/*

------------------------------------------------------------------------------------
Create Databases
------------------------------------------------------------------------------------
This script creates the databes DataWarehouse and DataWarehouse_bronze,DataWarehouse_silver
DataWarehouse_gold respectively. 

WARNING:
If the DBs exist already the script drops and recreates them.

*/

USE master;


DROP DATABASE IF EXISTS DataWarehouse;
DROP DATABASE IF EXISTS DataWarehouse_bronze;
DROP DATABASE IF EXISTS DataWarehouse_silver;
DROP DATABASE IF EXISTS DataWarehouse_gold;


CREATE DATABASE DataWarehouse;

USE DataWarehouse;

CREATE SCHEMA DataWarehouse_bronze;
CREATE SCHEMA DataWarehouse_silver;
CREATE SCHEMA DataWarehouse_gold;
