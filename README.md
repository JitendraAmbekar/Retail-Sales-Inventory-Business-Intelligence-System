# Retail Sales & Inventory Business Intelligence System

An end-to-end Business Intelligence (BI) and Data Engineering project that simulates real-world retail transactions, performs robust ETL (Extract, Transform, Load) processes, stores structured data in a MySQL relational database, and delivers actionable business insights through an interactive Power BI dashboard.

---***----

## 📊 Interactive Dashboard Preview
Below is the screenshot of the functional Power BI dashboard tracking key performance indicators (KPIs), monthly trends, and product performance:

![Retail Sales and Inventory Dashboard](Retail_sales & inventory dashborad img)

---***----

## 🛠️ Project Architecture & Workflow
1. **Data Generation (Python):** Simulates 2,800+ raw transaction records spanning 6 months (Jan 2026 - Jun 2026) with introduced inconsistencies (missing values, duplicates, and casing errors).
2. **Data Cleaning & Transformation (Pandas):** Handles missing values using statistical techniques (median/mean imputation), removes duplicates, standardizes text, and engineers new temporal and financial columns.
3. **Database Loading (SQLAlchemy):** Establishes a secure connection to load the cleaned data into a localized MySQL Server instance.
4. **Data Analytics (MySQL):** Runs advanced SQL queries (CTEs, Window Functions) to extract deeper corporate insights like Month-over-Month (MoM) growth and product ranking.
5. **Data Visualization (Power BI & DAX):** Connects to the database to create customized measures and multi-page interactive dashboards.

---***----

## 🗂️ Repository Structure
* `etl_pipeline.py` - Python script containing the automated data generation and cleaning process.
* `analysis_queries.sql` - Production-ready SQL script for business analytics queries.
* `retail_sales_raw.csv` - The initial simulated messy dataset.
* `retail_sales_cleaned.csv` - The final transformed dataset ready for database ingestion.
* `README.md` - Documentation of the project setup and specifications.

---***----

## 📊 Key Power BI DAX Measures

These are the specialized DAX formulas implemented to build the interactive dashboard report:

### 🔹 Basic Metrics
* **Total Revenue:** 
  ```dax
  Total Revenue = SUM(retail_analytics_sales[total_amount])
