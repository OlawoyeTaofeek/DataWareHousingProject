# Data Warehouse and Analytics Project

Welcome to the **Data Warehouse and Analytics Project** repository! 🚀  
This project demonstrates a comprehensive data warehousing and analytics solution, from building a data warehouse to generating actionable insights. Designed as a portfolio project, it highlights industry best practices in data engineering and analytics.

---
## 🏗️ Data Architecture

The data architecture for this project follows Medallion Architecture **Bronze**, **Silver**, and **Gold** layers:
![Data Architecture](docs/data_architecture.png)

1. **Bronze Layer**: Stores raw data as-is from the source systems. Data is ingested from CSV Files into SQL Server Database.
2. **Silver Layer**: This layer includes data cleansing, standardization, and normalization processes to prepare data for analysis.
3. **Gold Layer**: Houses business-ready data modeled into a star schema required for reporting and analytics.

---
## 📖 Project Overview

This project involves:

1. **Data Architecture**: Designing a Modern Data Warehouse Using Medallion Architecture **Bronze**, **Silver**, and **Gold** layers.
2. **ETL Pipelines**: Extracting, transforming, and loading data from source systems into the warehouse.
3. **Data Modeling**: Developing fact and dimension tables optimized for analytical queries.
4. **Analytics & Reporting**: Creating SQL-based reports and dashboards for actionable insights.

🎯 This repository is an excellent resource for professionals and students looking to showcase expertise in:
- SQL Development
- Data Architect
- Data Engineering  
- ETL Pipeline Developer  
- Data Modeling  
- Data Analytics  

---

## 🛠️ Important Links & Tools:

Everything is for Free!
- **[Datasets](datasets/):** Access to the project dataset (csv files).
- **[SQL Server Express](https://www.microsoft.com/en-us/sql-server/sql-server-downloads):** Lightweight server for hosting your SQL database.
- **[SQL Server Management Studio (SSMS)](https://learn.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver16):** GUI for managing and interacting with databases.
- **[Git Repository](https://github.com/):** Set up a GitHub account and repository to manage, version, and collaborate on your code efficiently.
- **[DrawIO](https://www.drawio.com/):** Design data architecture, models, flows, and diagrams.
- **[Notion](https://www.notion.com/templates/sql-data-warehouse-project):** Get the Project Template from Notion
- **[Notion Project Steps](https://thankful-pangolin-2ca.notion.site/SQL-Data-Warehouse-Project-16ed041640ef80489667cfe2f380b269?pvs=4):** Access to All Project Phases and Tasks.

---

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

### BI: Analytics & Reporting (Data Analysis)

#### Objective
Develop SQL-based analytics to deliver detailed insights into:
- **Customer Behavior**
- **Product Performance**
- **Sales Trends**

These insights empower stakeholders with key business metrics, enabling strategic decision-making.  

For more details, refer to [docs/requirements.md](docs/requirements.md).

## 📂 Repository Structure
```
data-warehouse-project/
│
├── datasets/                            # Raw ERP and CRM datasets
│
├── docs/                                # Documentation & architecture diagrams
│   ├── images/                          # Screenshots, visualizations, architecture images
│   ├── etl.drawio                       # ETL design using Draw.io
│   ├── data_architecture.drawio         # High-level architecture
│   ├── data_catalog.md                  # Dataset metadata and schema definitions
│   ├── data_flow.drawio                 # Data flow diagram (bronze → silver → gold)
│   ├── data_models.drawio               # Star/snowflake schema models
│   ├── naming-conventions.md            # Naming conventions for DB, scripts, fields
│
├── warehouse_env/                       # Local environment setup files 
├── scripts/                             # ETL logic separated by language/tech
│   ├── python_scripts/                  # Python ETL and utility scripts
│   ├── pyspark_scripts/                 # PySpark transformations & jobs
│   ├── sql_scripts/                     # Raw SQL for Bronze, Silver, Gold layers
│       ├── bronze/                      # Initial loading queries
│       ├── silver/                      # Cleansing & transformation
│       ├── gold/                        # Star schema, fact & dimension models
│
├── analytics/                           # Post-warehouse data analysis & visualization
│   ├── notebooks/                       # Jupyter or Databricks notebooks
│   ├── reports/                         # Business insights, KPIs, charts
│   ├── dashboards/                      # Power BI, Tableau, Streamlit apps
│
├── tests/                               # Unit tests, data quality checks, schema validation
│
├── README.md                            # Project overview and usage guide
├── LICENSE                              # MIT License (with credit)
├── .gitignore                           # Git ignore patterns
└── requirements.txt                     # Python and PySpark dependency list
```
---

---

## 🛡️ License

This project is licensed under the [MIT License](LICENSE). You are free to use, modify, and share this project with proper attribution.

## 🌟 About Me

Hi there! I'm **Olawoye Taofeek**, also known as **ExcellentDataTutor**. I’m an a very enthusiastic person interested in transforming data into profit and a Data Analyst instrutor at GomyCode on a mission to share knowledge and make working with data enjoyable and engaging!



