/*

------------------------------------------------------------------------------------
Create Databases
------------------------------------------------------------------------------------
This script creates the databes DataWarehouse and DataWarehouse_bronze,DataWarehouse_silver
DataWarehouse_gold respectively. 

WARNING:
If the DBs exist already the script drops and recreates them.

*/

DROP DATABASE IF EXISTS DataWarehouse;
DROP DATABASE IF EXISTS DataWarehouse_bronze;
DROP DATABASE IF EXISTS DataWarehouse_silver;
DROP DATABASE IF EXISTS DataWarehouse_gold;


CREATE DATABASE DataWarehouse;

USE DataWarehouse;

-- in the original project from Baraa done in SQL Server, the DataWarehouse contains three schemas bronze silver and gold
-- Here I had to make three separate DBs, since the Database-Schema architecture cannot be achieved in MySQL

CREATE SCHEMA DataWarehouse_bronze;
CREATE SCHEMA DataWarehouse_silver;
CREATE SCHEMA DataWarehouse_gold;
