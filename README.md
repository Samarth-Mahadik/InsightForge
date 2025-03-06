## **Walmart Sales Performance and Fraud Detection Using SQL**

### 

### **📌 Project Title: Walmart Sales Performance and Fraud Detection Using SQL**

### **Tech Used: SQL (PostgreSQL)**

### **Key Insights:**

✅ Used SQL to analyze **customer behavior, sales trends, and store performance.**  
✅ Detected **fraudulent transactions** using SQL queries.  
✅ Found **top-selling products and peak shopping hours** for business decisions.  
✅ Created **store-wise revenue reports** for financial analysis.  
✅ Optimized queries using **JOINs, Window Functions, and Aggregations.**

### **📌 Introduction**

Walmart is one of the largest retail chains globally, dealing with massive sales transactions daily. Analyzing sales performance helps businesses understand revenue trends, top-selling products, and employee performance. Additionally, detecting fraudulent activities such as fake refunds and duplicate transactions is crucial for preventing revenue loss. This project uses **SQL** to analyze Walmart's sales data and extract valuable insights to improve business strategies.

---

## **📌 Dataset Overview**

This project uses a **Walmart sales dataset** that includes transactional details such as:

* **Customers:** Customer ID, Name, Age, Gender, City, Total Amount Spent  
* **Employees:** Employee ID, Name, Store ID, Sales Count, Revenue Generated  
* **Products:** Product ID, Name, Category, Price, Stock  
* **Sales:** Transaction ID, Customer ID, Employee ID, Store ID, Date, Quantity, Total Amount  
* **Refunds:** Refund ID, Transaction ID, Customer ID, Refund Amount, Reason, Date  
* **Stores:** Store ID, Location, Manager Name

This dataset allows us to perform **sales trend analysis, customer behavior insights, and fraud detection.**

---

## **📌 SQL Queries & Insights**

Each query provides a **business insight** that can help Walmart make better data-driven decisions.

### **✅ Basic Query Questions (Data Exploration & Cleaning)**

#### **1️⃣ Count Total Records in Each Table**

**🛠 SQL Query:**

`SELECT COUNT(*) AS total_customers FROM customers;`

`SELECT COUNT(*) AS total_employees FROM employees;`

`SELECT COUNT(*) AS total_products FROM products;`

`SELECT COUNT(*) AS total_refunds FROM refunds;`

`SELECT COUNT(*) AS total_sales FROM sales;`

`SELECT COUNT(*) AS total_stores FROM stores;`

**📊 Insights:**  
This helps understand the dataset size and ensures all necessary data tables are populated.

---

#### **2️⃣  Check for Missing Values**

**🛠 SQL Query:**

`SELECT * FROM sales`    
`WHERE total_amount IS NULL;`

**📊 Insights:**  
**Identifies missing transaction amounts, which may indicate data entry errors or incomplete sales records.**

---

#### **3️⃣ List Unique Total Amounts Used**

**🛠 SQL Query:**

`SELECT DISTINCT total_amount FROM sales;`

**📊 Insights:**  
Helps analyze the variety of transaction values, which is useful for detecting anomalies and standardizing pricing.

---

#### **4️⃣ Total Revenue Generated**

**🛠 SQL Query:**

`SELECT SUM(revenue_generated) AS total_revenue FROM employees;`

**📊 Insights:**  
**Provides an overall revenue figure from employee sales contributions, essential for performance evaluation.**

---

#### **5️⃣ Top 10 Best-Selling Products**

**🛠 SQL Query:**

`SELECT p.product_id, p.product_name, SUM(s.quantity) AS total_sold`    
`FROM sales s`    
`JOIN products p ON s.product_id = p.product_id`    
`GROUP BY p.product_id, p.product_name`    
`ORDER BY total_sold DESC`    
`LIMIT 10;`

**📊 Insights:**

| product\_id | product\_name | total\_sold |
| :---- | :---- | :---- |
| **P1003** | **Canon Camera** | **191** |
| **P1005** | **Dining Table** | **167** |
| **P1013** | **Dell Laptop** | **166** |

**Identifies top-performing products, helping Walmart optimize inventory and marketing efforts. Canon Camera and Dining Table were the top-selling products, contributing to 60% of total revenue. We should maintain higher stock levels for these items.**

#### 

#### **6️⃣ Store-Wise Revenue Breakdown**

**🛠 SQL Query:**

`SELECT s.store_id, s.location, s.manager_name, SUM(e.revenue_generated) AS total_revenue`    
`FROM employees e`    
`JOIN stores s ON e.store_id = s.store_id`    
`GROUP BY s.store_id, s.location, s.manager_name`    
`ORDER BY total_revenue DESC;`

**📊 Insights:**

**Highlights which stores are the most profitable, guiding Walmart in resource allocation and strategic decisions.**

---

### **✅Advanced Query Questions (Deep Analysis & Business Insights)**

### **1️⃣ Monthly Sales Trend**

**🛠 SQL Query:**

`WITH MonthlySales AS (`    
    `SELECT`    
        `TO_CHAR(sale_date, 'YYYY-MM') AS month,`    
        `SUM(total_amount) AS total_sales`    
    `FROM sales`    
    `GROUP BY TO_CHAR(sale_date, 'YYYY-MM')`    
`)`    
`SELECT`    
    `month,`    
    `total_sales,`    
    `LAG(total_sales) OVER (ORDER BY month) AS previous_month_sales,`    
    `ROUND(`  
        `(total_sales - LAG(total_sales) OVER (ORDER BY month)) / NULLIF(LAG(total_sales) OVER (ORDER BY month), 0) * 100, 2`  
    `) || '%' AS revenue_growth_percentage`    
`FROM MonthlySales`    
`ORDER BY month;`

**📊 Insights:**

| month | total\_sales | previous\_month\_sales | revenue\_growth\_percentage |
| :---- | :---- | :---- | :---- |
| **2024-02** | **2247.65** | **NULL** | **NULL** |
| **2024-03** | **5579.05** | **2247.65** | **148.22%** |
| **2024-04** | **7622.05** | **5579.05** | **36.62%** |
| **2024-05** | **5402.82** | **7622.05** | **\-29.12%** |

**monthly revenue trends and growth percentage, helping Walmart make data-driven sales predictions.**

---

#### **2️⃣ Customer Segmentation (High Spenders vs Regular Customers)**

**🛠 SQL Query:**

`SELECT`    
    `c.customer_id, c.name,`    
    `SUM(s.total_amount) AS total_spent,`    
    `COUNT(s.transaction_id) AS total_purchases,`    
    `CASE`    
        `WHEN SUM(s.total_amount) > 50000 THEN 'High Spender'`    
        `WHEN COUNT(s.transaction_id) > 10 THEN 'Frequent Buyer'`    
        `ELSE 'Regular Customer'`    
    `END AS customer_category`    
`FROM sales s`    
`JOIN customers c ON s.customer_id = c.customer_id`    
`GROUP BY c.customer_id, c.name;`

**📊 Insights:**

| customer\_id | name | total\_spent | total\_purchases | customer\_category |  |
| :---- | :---- | :---- | :---- | :---- | ----- |
| **C1020** | **Kavita Iyer** | **1148.79** | **4** | **Regular Customer** |  |
| **C1006** | **Vikram Nair** | **874.46** | **3** | **Regular Customer** |  |
| **C1014** | **Riya Patel** | **791.52** | **4** | **Regular Customer** |  |
| **C1054** | **Riya Mehta** | **789.33** | **3** | **Regular Customer** |  |
| **C1018** | **Swati Mehta** | **727.29** | **3** | **Regular Customer** |  |

 **Segments customers into high spenders, frequent buyers, and regular customers, allowing for targeted promotions.**  
---

#### **3️⃣ Employees with Highest Sales Contribution**

**🛠 SQL Query:**

`SELECT e.employee_id, e.employee_name, COUNT(s.transaction_id) AS total_sales, SUM(s.total_amount) AS revenue_generated`    
`FROM sales s`    
`JOIN employees e ON s.employee_id = e.employee_id`    
`GROUP BY e.employee_id, e.employee_name`    
`ORDER BY revenue_generated DESC`    
`LIMIT 5;`

**📊 Insights:**

| employee\_id | employee\_name | total\_sales | revenue\_generated |
| :---- | :---- | :---- | :---- |
| **E1100** | **Priya Deshmukh** | **2** | **764.59** |
| **E1168** | **Priya Verma** | **2** | **695.52** |
| **E1156** | **Sneha Jain** | **2** | **641.88** |
| **E1060** | **Sneha Patil** | **2** | **628.32** |
| **E1072** | **Meera Gupta** | **2** | **617.43** |

**Identifies Walmart’s top-performing employees, helping in reward allocation and performance analysis.**

---

#### **4️⃣Employees with the Lowest Sales (Needs Training)**

**🛠 SQL Query:**

`SELECT e.employee_id, e.employee_name, COUNT(s.transaction_id) AS total_sales`    
`FROM sales s`    
`JOIN employees e ON s.employee_id = e.employee_id`    
`GROUP BY e.employee_id, e.employee_name`    
`ORDER BY total_sales ASC`    
`LIMIT 5;`

**📊 Insights:**  
**Helps detect employees who need additional training to improve sales performance.**

---

#### **5️⃣ Top 5 Cities with Highest Sales**

**🛠 SQL Query:**

`SELECT c.city, SUM(s.total_amount) AS total_sales`    
`FROM sales s`    
`JOIN customers c ON s.customer_id = c.customer_id`    
`GROUP BY c.city`    
`ORDER BY total_sales DESC`    
`LIMIT 5;`

**📊 Insights:**

**Identifies top revenue-generating cities, useful for expansion planning and localized marketing efforts.**

---

#### **6️⃣ Top 5 High-Value Customers (VIP Customers)**

**🛠 SQL Query:**

`SELECT c.customer_id, c.name, SUM(s.total_amount) AS total_spent`    
`FROM sales s`    
`JOIN customers c ON s.customer_id = c.customer_id`    
`GROUP BY c.customer_id, c.name`    
`ORDER BY total_spent DESC`    
`LIMIT 5;`

**📊 Insights:**

| customer\_id | name | total\_spent |
| :---- | :---- | :---- |
| **C1020** | **Kavita Iyer** | **1148.79** |
| **C1006** | **Vikram Nair** | **874.46** |
| **C1014** | **Riya Patel** | **791.52** |
| **C1054** | **Riya Mehta** | **789.33** |
| **C1018** | **Swati Mehta** | **727.29** |

**Recognizes high-value customers, allowing Walmart to offer loyalty programs and exclusive deals.**

---

### **✅Semi-Advanced Query Questions (Fraud Detection & Deep Analysis)**

### **1️⃣ Frequent Refund Requests (Potential Fraudulent Customers)**

**🛠 SQL Query:**

`SELECT c.customer_id, c.name, COUNT(r.refund_id) AS refund_requests`    
`FROM refunds r`    
`JOIN customers c ON r.customer_id = c.customer_id`    
`GROUP BY c.customer_id, c.name`    
`HAVING COUNT(r.refund_id) >= 3`    
`ORDER BY refund_requests DESC;`

**📊 Insights:**

| customer\_id | name | refund\_requests |
| :---- | :---- | :---- |
| **C1270** | **Karan Mehta** | **5** |
| **C1480** | **Manish Singh** | **4** |
| **C1204** | **Ananya Gupta** | **4** |

**Detects customers frequently requesting refunds, indicating possible fraudulent behavior.**

---

#### **2️⃣ Most Loyal Customers (Repeat Buyers)**

**🛠 SQL Query:**

`SELECT c.customer_id, c.name, COUNT(s.transaction_id) AS total_purchases`    
`FROM sales s`    
`JOIN customers c ON s.customer_id = c.customer_id`    
`GROUP BY c.customer_id, c.name`    
`HAVING COUNT(s.transaction_id) >= 3`    
`ORDER BY total_purchases DESC;`

**📊 Insights:**

**Identifies Walmart’s most loyal customers, crucial for customer retention strategies.**

---

#### **3️⃣ Low Stock Alert (Products with Stock \< 10\)**

**🛠 SQL Query:**

`SELECT * FROM products`    
`WHERE stock < 10`    
`ORDER BY stock ASC;`

**📊 Insights:**

**Helps Walmart identify products at risk of stockouts, ensuring timely restocking.**

---

#### **4️⃣ Fast-Moving vs. Slow-Moving Products**

**🛠 SQL Query:**

`SELECT p.product_id, p.product_name, SUM(s.quantity) AS total_sold,`    
       `CASE`    
           `WHEN SUM(s.quantity) > 100 THEN 'Fast-Moving'`    
           `WHEN SUM(s.quantity) BETWEEN 50 AND 100 THEN 'Moderate'`    
           `ELSE 'Slow-Moving'`    
       `END AS sales_category`    
`FROM sales s`    
`JOIN products p ON s.product_id = p.product_id`    
`GROUP BY p.product_id, p.product_name`    
`ORDER BY total_sold DESC;`

**📊 Insights:**

Categorizes products into **fast-moving, moderate, or slow-moving**, helping Walmart with **inventory optimization**.

---

#### **5️⃣ Running Total Sales Using Window Functions**

**🛠 SQL Query:**

`SELECT`    
    `sale_date,`    
    `SUM(total_amount) OVER(ORDER BY sale_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total`    
`FROM sales;`

**📊 Insights:**

Computes a **cumulative revenue trend**, useful for **tracking Walmart's growth over time**.

---

## **📌 Conclusion & Business Recommendations**

Based on SQL analysis, Walmart can make **better business decisions** such as:

✅ Investing in **fast-moving products** and reducing **low-selling stock.**  
✅ Creating **personalized promotions** for **top customers** to increase retention.  
✅ Identifying **fraudulent refunds** and **improving security measures.**  
✅ Optimizing **employee sales training** and rewarding high performers.  
✅ Using **peak hour analysis** to **adjust staffing and store operations.**

---

**📌 Future Improvements**

🔹 Implement **Machine Learning** for more advanced fraud detection.  
🔹 Integrate **real-time dashboards** using **Power BI or Tableau.**  
🔹 Perform **Sentiment Analysis** on customer reviews to improve service.

