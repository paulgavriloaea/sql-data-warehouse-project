# Data Warehouse and Analytics Project

**Inspired by DataWithBaraa, the original project from Baraa was built around SQL server, I adapted it to MySQL (working on MacOS)**

Welcome to the **Data Warehouse and Analytics Project** repository! 🚀  
This project demonstrates a comprehensive data warehousing and analytics solution, from building a data warehouse to generating actionable insights. 

---
## 🏗️ Data Architecture

The data architecture for this project follows a Medallion Architecture: **Bronze**, **Silver**, and **Gold** layers:
![Data Architecture](https://github.com/paulgavriloaea/sql-data-warehouse-project/blob/main/docs/data_architecture.png)

1. **Bronze Layer**: Stores raw data as-is from the source systems. Data is ingested from CSV Files into MySQL Database.
2. **Silver Layer**: This layer includes data cleansing, standardization, and normalization processes to prepare data for analysis.
3. **Gold Layer**: Houses business-ready data modeled into a star schema required for reporting and analytics.

---
## 📖 Project Overview

This project involves:

1. **Data Architecture**: Designing a Modern Data Warehouse Using Medallion Architecture **Bronze**, **Silver**, and **Gold** layers.
2. **ETL Pipelines**: Extracting, transforming, and loading data from source systems into the warehouse.
3. **Data Modeling**: Developing fact and dimension tables optimized for analytical queries.
4. **Analytics & Reporting**: Creating SQL-based reports and dashboards for actionable insights.


## 🚀 Project Requirements

### Building the Data Warehouse (Data Engineering)

#### Objective
Develop a modern data warehouse using SQL Server to consolidate sales data, enabling analytical reporting and informed decision-making.

#### Specifications
- **Data Sources**: Import data from two source systems (ERP and CRM) provided as CSV files.
- **Data Quality**: Cleanse and resolve data quality issues prior to analysis.
- **Integration**: Combine both sources into a single, user-friendly data model designed for analytical queries.
- **Scope**: Focus on the latest dataset only; historization of data is not required.
- **Documentation**: Provide clear documentation of the data model to support both business stakeholders and analytics teams.

---

### Analytics & Reporting (Data Analysis)

#### Objective
Develop SQL-based analytics to deliver detailed insights into:
- **Customer Behavior**
- **Product Performance**
- **Sales Trends**

The data exploration and analysis is performed on the dataset available in the Data Warehouse. 

In addition, two reports are generated which gather and segment essential data +
extract valuable KPIs and aggregated metrics related to
the sales, customers and products in the DataWarehouse.


## 📂 Repository Instructions

To construct the Data Warehouse and build Data Analysis reports easily, run the create_DW_and_build_reports.py python script inside the scripts/ directory.

## 📂 Repository Structure
```
data-warehouse-project/
│
├── datasets/                           # Raw datasets used for the project (ERP and CRM data)
│   ├── source_crm/
│   │   ├── cust_info.csv
│   │   ├── prd_info.csv
│   │   └── sales_details.csv
│   ├── source_erp/
│   │   ├── CUST_AZ12.csv
│   │   ├── LOC_A101.csv
│   │   └── PX_CAT_G1V2.csv
├── docs/                               # Project documentation and architecture details
│   ├── etl.png                         # Png showing all different techniques and methods of ETL
│   ├── data_architecture.png           # Png file shows the project's architecture
│   ├── data_catalog.md                 # Catalog of datasets, including field descriptions and metadata
│   ├── data_flow.png                   # Draw.io file for the data flow diagram
│   ├── data_models.png                 # Draw.io file for data models (star schema)
│   ├── naming-conventions.md           # Consistent naming guidelines for tables, columns, and files
│   ├── data_integration.png            # shows how the tables are related
│   ├── data_layers.pdf                 # shows in more detail the medallion architecture
├── scripts/                            # SQL scripts for ETL and transformations
│   ├── init_database.sql               # SQL for creating the structure of the DataWarehouse
│   ├── create_DW_and_build_reports.py         # python script used to run all the internal SQL scripts in bronze/ silver/ gold/ and data_analysis/ directories.
│   ├── data_checks.sql                 # SQL script containing  some queries I used to test the quality of the loaded data, this script is not actively used by the DataWarehouse.
│   ├── bronze/                         # Scripts for extracting and loading raw data
│   ├── silver/                         # Scripts for cleaning and transforming data
│   ├── gold/                           # Scripts for creating analytical models
│   └── data_analysis/                  # Scripts for extracting business insights from the data warehouse
│       ├── customer_report.sql         # Reports on: total sales, total orders, quantity purchased, recency (months since last order), average order value, average monthly spend
│       └── product_report.sql          # Reports on: total orders, total customers, total products sold, recency, average order revenue (AOR), average monthly revenue
│       └── data_exploration.sql        # Performs data exploration in terms of dimensions, measures, data range, ranking and grouping data by specifid dimensions
│       └── advanced_data_analysis.sql  # Performs change/time and cummulative analysis of the data, checks the performance or metrics across dimensions and time periods, segments data
├── tests/                              # Test scripts and quality files
│
├── README.md                           # Project overview and instructions
├── LICENSE                             # License information for the repository
├── .gitignore                          # Files and directories to be ignored by Git
└── requirements.txt                    # Dependencies and requirements for the project
```
---

## 🛡️ License

This project is licensed under the [MIT License](LICENSE). You are free to use, modify, and share this project with proper attribution.

## 🌟 About Me

I am a Physicist at heart.
