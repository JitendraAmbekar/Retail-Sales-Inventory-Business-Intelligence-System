-- Retail Sales & Inventory Business Intelligence System

-- Create a new database if it does not already exist
CREATE DATABASE IF NOT EXISTS retail_analytics;
USE retail_analytics;


-- Define the table structure for storing sales data
CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    product_name VARCHAR(50) NOT NULL,
    category VARCHAR(30) NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    sale_date DATE NOT NULL,
    customer_type VARCHAR(20) NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    month VARCHAR(15),
    day_of_week VARCHAR(15)
);


-- Check the structure and confirm the table is created successfully
DESCRIBE sales;
SHOW TABLES;

USE retail_analytics;
TRUNCATE TABLE sales;

-- DATA ANALYSIS

-- Q1. Which category generates the most revenue?

USE retail_analytics;

SELECT 
    category,
    COUNT(*) AS total_transactions,
    SUM(quantity) AS total_units_sold,
    ROUND(SUM(total_amount), 2) AS total_revenue,
    ROUND(AVG(total_amount), 2) AS avg_transaction_value
FROM sales
GROUP BY category
ORDER BY total_revenue DESC;

-- Result Summary:
-- 1st: Grocery (903 transactions, 9467 units, 1,592,174.86 revenue) - Generates the highest revenue
-- 2nd: Personal Care (526 transactions, 5647 units, 597,356.85 revenue)
-- 3rd: Household (347 transactions, 3631 units, 413,177.16 revenue)
-- 4th: Dairy (506 transactions, 5512 units, 317,191.10 revenue)
-- 5th: Snacks (518 transactions, 5434 units, 214,441.37 revenue)
    
-- Q2. What is the top-performing product in each category?

WITH product_revenue AS (
    SELECT 
        category,
        product_name,
        SUM(total_amount) AS revenue,
        RANK() OVER (PARTITION BY category ORDER BY SUM(total_amount) DESC) AS rank_in_category
    FROM sales
    GROUP BY category, product_name
)
SELECT category, product_name, ROUND(revenue, 2) AS revenue
FROM product_revenue
WHERE rank_in_category = 1;

-- Result Summary:
-- Displays the highest revenue-generating product within each category.
   
-- Q3. What is the monthly sales trend?
 
SELECT 
    month,
    COUNT(*) AS total_transactions,
    ROUND(SUM(total_amount), 2) AS monthly_revenue
FROM sales
GROUP BY month
ORDER BY monthly_revenue DESC;

-- Result Summary:
-- Ranks months based on the total revenue generated.
  
-- Q4. Which day of the week has the highest sales volume?
 
SELECT 
    day_of_week,
    COUNT(*) AS total_transactions,
    ROUND(SUM(total_amount), 2) AS total_revenue,
    ROUND(AVG(total_amount), 2) AS avg_transaction_value
FROM sales
GROUP BY day_of_week
ORDER BY total_revenue DESC;

-- Result Summary:
-- Monday shows the highest sales (424 transactions, 521,927.22 revenue).


-- Q5. Analysis by Customer Type (Regular vs. Wholesale vs. Walk-in)

SELECT 
    customer_type,
    COUNT(*) AS total_transactions,
    ROUND(SUM(total_amount), 2) AS total_revenue,
    ROUND(AVG(total_amount), 2) AS avg_transaction_value,
    ROUND(AVG(quantity), 2) AS avg_quantity_per_transaction
FROM sales
GROUP BY customer_type
ORDER BY total_revenue DESC;

-- Result Summary:
-- Walk-in customers generated the most revenue (944 transactions, 1,100,652.58 revenue).

-- Q6. Sales distribution across all products (Useful for inventory monitoring)

SELECT 
    product_name,
    category,
    COUNT(*) AS times_sold,
    SUM(quantity) AS total_units_sold,
    ROUND(AVG(quantity), 2) AS avg_qty_per_sale,
    ROUND(SUM(total_amount), 2) AS total_revenue
FROM sales
GROUP BY product_name, category
ORDER BY total_units_sold DESC;

-- Result Summary:
-- Identifies best-selling products like Namkeen 200g based on total units sold.

-- Q7. Month-over-Month (MoM) Growth Analysis using CTE and Window Functions

WITH monthly_totals AS (
    SELECT 
        MONTH(sale_date) AS month_num,
        month,
        ROUND(SUM(total_amount), 2) AS monthly_revenue
    FROM sales
    GROUP BY MONTH(sale_date), month
)
SELECT 
    month,
    monthly_revenue,
    LAG(monthly_revenue) OVER (ORDER BY month_num) AS previous_month_revenue,
    ROUND(
        (monthly_revenue - LAG(monthly_revenue) OVER (ORDER BY month_num)) 
        / LAG(monthly_revenue) OVER (ORDER BY month_num) * 100, 2
    ) AS growth_percent
FROM monthly_totals
ORDER BY month_num;

-- Result Summary:
-- Calculates the percentage increase or decrease in revenue compared to the previous month.
  
-- Q8. Running Total Revenue Calculation
  
SELECT 
    month,
    MONTH(MIN(sale_date)) AS month_num,
    ROUND(SUM(total_amount), 2) AS monthly_revenue,
    ROUND(SUM(SUM(total_amount)) OVER (ORDER BY MONTH(MIN(sale_date))), 2) AS running_total_revenue
FROM sales
GROUP BY month
ORDER BY month_num;
  
-- Result Summary:
-- Computes the cumulative revenue growth across months (starts with 568,018.24 in January).