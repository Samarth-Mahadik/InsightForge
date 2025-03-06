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



















