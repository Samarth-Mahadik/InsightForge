DROP TABLE IF EXISTS customers;
CREATE TABLE customers (
	Customer_ID VARCHAR(10) PRIMARY KEY,
	Name VARCHAR(50),
	Age INT,
	Gender VARCHAR(10),
	City VARCHAR(50),
	Total_Spent NUMERIC(10, 2)
);

DROP TABLE IF EXISTS employees;
CREATE TABLE employees (
	Employee_ID VARCHAR(10) PRIMARY KEY,
	Employee_Name VARCHAR(50),
	Store_ID VARCHAR(10) REFERENCES stores (Store_ID),
	Sales_Count INT,
	Revenue_Generated NUMERIC(10, 2)
);

DROP TABLE IF EXISTS products;
CREATE TABLE products (
	Product_ID VARCHAR(10) PRIMARY KEY,
	Product_Name VARCHAR(100),
	Category VARCHAR(50),
	Price NUMERIC(10, 2),
	Stock INT
);

DROP TABLE IF EXISTS refunds;
CREATE TABLE refunds (
	Refund_ID VARCHAR(10) PRIMARY KEY,
	Transaction_ID INT REFERENCES sales (Transaction_ID),
	Customer_ID VARCHAR(10) REFERENCES customers (Customer_ID),
	Refund_Amount NUMERIC(10, 2),
	Reason VARCHAR(100),
	Date DATE
);

DROP TABLE IF EXISTS sales;
CREATE TABLE sales (
	Transaction_ID INT PRIMARY KEY,
	Product_ID VARCHAR(10) REFERENCES products (Product_ID),
	Customer_ID VARCHAR(10) REFERENCES customers (Customer_ID),
	Employee_ID VARCHAR(10) REFERENCES employees (Employee_ID),
	Store_ID VARCHAR(10) REFERENCES stores (Store_ID),
	Sale_Date DATE,
	Quantity INT,
	Total_Amount NUMERIC(10, 2)
);

DROP TABLE IF EXISTS stores;
CREATE TABLE stores (
	Store_ID VARCHAR(10) PRIMARY KEY,
	Location VARCHAR(50),
	Manager_Name VARCHAR(50)
);

SELECT * FROM customers;
SELECT * FROM employees;
SELECT * FROM products;
SELECT * FROM refunds;
SELECT * FROM sales;
SELECT * FROM stores;

--Import Data into customers table
COPY customers (Customer_ID, Name, Age, Gender, City, Total_Spent)
FROM 'C:\Program Files\PostgreSQL\17\data\Walmart_Customers_Dataset.csv'
CSV HEADER;

--Import Data into employees table
COPY employees (Employee_ID, Employee_Name, Store_ID, Sales_Count, Revenue_Generated)
FROM 'C:\Program Files\PostgreSQL\17\data\Walmart_Employees_Dataset.csv'
CSV HEADER;

--Import Data into products table
COPY products (Product_ID, Product_Name, Category, Price, Stock)
FROM 'C:\Program Files\PostgreSQL\17\data\Walmart_Products_Dataset.csv'
CSV HEADER;

--Import Data into refunds table
COPY refunds (Refund_ID, Transaction_ID, Customer_ID, Refund_Amount, Reason, Date)
FROM 'C:\Program Files\PostgreSQL\17\data\Walmart_Refunds_Dataset.csv'
CSV HEADER;

--Import Data into sales table
COPY sales (Transaction_ID, Product_ID, Customer_ID, Employee_ID, Store_ID, Sale_Date, Quantity, Total_Amount) 
FROM 'C:\Program Files\PostgreSQL\17\data\walmart_store_sales.csv' 
CSV HEADER;

--Import Data into stores table
COPY stores (Store_ID, Location, Manager_Name)
FROM 'C:\Program Files\PostgreSQL\17\data\Walmart_Stores_Dataset.csv'
CSV HEADER;

--Basic Query Questions (Data Exploration & Cleaning)

--1) Count Total Records in Each Table

SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM employees;
SELECT COUNT(*) FROM products;
SELECT COUNT(*) FROM refunds;
SELECT COUNT(*) FROM sales;
SELECT COUNT(*) FROM stores;

--2) Check for Missing Values

SELECT * FROM sales 
WHERE total_amount IS NULL;

--3) List Unique Total Amounts Used

SELECT DISTINCT total_amount FROM sales;

--4) Total Revenue Generated

SELECT SUM(revenue_generated) AS total_revenue FROM employees;

--5) Top 10 Best-Selling Products

SELECT p.product_id, product_name, SUM(quantity) AS total_sold
FROM sales s
JOIN products p on s.product_id = p.product_id
GROUP BY p.product_id, product_name
ORDER BY total_sold DESC
LIMIT 10;

--6) Store_Wise Revenue Breakdown

SELECT s.store_id, location, manager_name, SUM(Revenue_Generated) AS total_revenue
FROM employees e
JOIN stores s on e.store_id = s.store_id
GROUP BY s.store_id, location, manager_name
ORDER BY total_revenue DESC;

--Advanced Query Questions (Deep Analysis & Business Insights)

--1) Monthly Sales Trend

WITH MonthlySales AS (
    SELECT 
        TO_CHAR(Sale_Date, 'YYYY-MM') AS Month,  -- Extract year and month in YYYY-MM format
        SUM(Total_Amount) AS Total_Sales
    FROM sales
    GROUP BY TO_CHAR(Sale_Date, 'YYYY-MM')
)
SELECT 
    Month,
    Total_Sales,
    LAG(Total_Sales) OVER (ORDER BY Month) AS Previous_Month_Sales,
    ROUND(
        (Total_Sales - LAG(Total_Sales) OVER (ORDER BY Month)) / 
        NULLIF(LAG(Total_Sales) OVER (ORDER BY Month), 0) * 100, 2
    ) || '%' AS Revenue_Growth_Percentage
FROM MonthlySales
ORDER BY Month;

--2) Customer Segmentation (High Spenders vs Regular)

SELECT 
    c.customer_id, name, 
    SUM(total_amount) AS total_spent, 
    COUNT(transaction_id) AS total_purchases,
    CASE 
        WHEN SUM(total_amount) > 50000 THEN 'High Spender'
        WHEN COUNT(transaction_id) > 10 THEN 'Frequent Buyer'
        ELSE 'Regular Customer'
    END AS customer_category
FROM Sales s
JOIN Customers c ON s.customer_id = c.customer_id
GROUP BY c.customer_id, name;

--3) Employees with Highest Sales Contribution

SELECT e.employee_id, employee_name, COUNT(transaction_id) AS total_sales, SUM(total_amount) AS revenue_generated
FROM Sales s
JOIN employees e ON s.employee_id = e.employee_id
GROUP BY e.employee_id, employee_name
ORDER BY revenue_generated DESC
LIMIT 5;

--4) Employees with the Lowest Sales (Needs Training)

SELECT e.employee_id, employee_name, COUNT(transaction_id) AS total_sales  
FROM sales s 
JOIN employees e ON s.employee_id = e.employee_id  
GROUP BY e.employee_id, employee_name  
ORDER BY total_sales ASC  
LIMIT 5;

--5)  Top 5 Cities with Highest Sales

SELECT c.City, SUM(total_amount) AS total_sales  
FROM sales s 
JOIN customers c ON s.customer_id = c.customer_id  
GROUP BY c.City  
ORDER BY total_sales DESC  
LIMIT 5;

--6) Top 5 High-Value Customers (VIP Customers)

SELECT c.customer_id, c.name, SUM(s.total_amount) AS total_spent  
FROM sales s  
JOIN customers c ON s.customer_id = c.customer_id  
GROUP BY c.customer_id, c.name  
ORDER BY total_spent DESC  
LIMIT 5;

--Semi Advanced Query Questions (Fraud Detection & Deep Analysis)

--1 Frequent Refund Requests (Potential Fraudulent Customers)

SELECT c.customer_id, c.name, COUNT(r.refund_id) AS refund_requests  
FROM refunds r  
JOIN customers c ON r.customer_id = c.customer_id  
GROUP BY c.customer_id, c.name  
HAVING COUNT(r.refund_id) >= 3  
ORDER BY refund_requests DESC;

--2) Most Loyal Customers (Repeat Buyers) 

SELECT c.customer_id, c.name, COUNT(transaction_id) AS total_purchases  
FROM sales s  
JOIN customers c ON s.customer_id = c.customer_id  
GROUP BY c.customer_id, c.name 
HAVING COUNT(s.transaction_id) >= 3  
ORDER BY total_purchases DESC;

--4)  Low Stock Alert (Products with Stock < 10)

SELECT * FROM products  
WHERE stock < 10 
ORDER BY stock ASC;

--5)  Fast-Moving vs. Slow-Moving Products

SELECT p.product_id, product_name, SUM(quantity) AS total_sold,  
       CASE  
           WHEN SUM(quantity) > 100 THEN 'Fast-Moving'  
           WHEN SUM(quantity) BETWEEN 50 AND 100 THEN 'Moderate'  
           ELSE 'Slow-Moving'  
       END AS sales_category  
FROM sales s  
JOIN products p ON s.product_id = p.product_id  
GROUP BY p.product_id,product_name  
ORDER BY total_sold DESC;

--6) Using Window Functions – Running Total Sales

SELECT 
    sale_date, 
    SUM(total_amount) OVER(ORDER BY sale_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total
FROM Sales;


















