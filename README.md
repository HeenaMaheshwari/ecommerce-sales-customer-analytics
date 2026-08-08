# 🛒 E-Commerce Sales & Customer Analytics

A SQL-based e-commerce analytics project focused on understanding sales performance, customer behavior, product performance, and revenue trends using **MySQL** and advanced SQL.

## 📌 Project Overview

This project analyzes an e-commerce dataset containing:

- **2,499 orders**
- **700 customers**
- **120 products**
- Order, customer, and product-level information

The objective is to transform raw transactional data into meaningful business insights that can support decisions around revenue growth, customer retention, product performance, and payment preferences.

---

## 🗂️ Dataset Structure

The analysis uses three relational tables:

### Customers
| Column | Description |
|---|---|
| customer_id | Unique customer identifier |
| customer_segment | Customer classification |
| city | Customer location |

### Products
| Column | Description |
|---|---|
| product_id | Unique product identifier |
| product_name | Product name |
| category | Product category |
| unit_price | Product selling price |

### Orders
| Column | Description |
|---|---|
| order_id | Unique order identifier |
| order_date | Date of order |
| customer_id | Customer reference |
| product_id | Product reference |
| quantity | Units purchased |
| payment_method | Payment method |
| order_status | Order status |
| unit_price | Price per unit |
| sales_amount | Total order value |

---

## 🎯 Business Questions

This project answers questions such as:

1. What is the overall sales performance?
2. How much revenue is generated each month?
3. Which months experienced the highest revenue growth?
4. Which products generate the most revenue?
5. Which product categories perform best?
6. Which customers have the highest spending?
7. Which customer segments generate the most revenue?
8. Which cities contribute the most sales?
9. Which payment methods are most popular?
10. What percentage of customers are repeat customers?
11. Which customer segments prefer specific product categories?
12. How does customer behavior vary across cities?

---

## 🔍 Key Analysis Performed

### 📊 Sales Performance
- Total orders and unique customers
- Delivered, cancelled, and returned orders
- Delivered revenue
- Order status distribution

### 📈 Revenue Analysis
- Monthly revenue trends
- Monthly delivered orders
- Month-over-month revenue growth
- Revenue performance comparison

### 🏆 Product Analysis
- Top 10 products by revenue
- Units sold by product
- Product category performance

### 👥 Customer Analysis
- Top customers by spending
- Customer lifetime value
- Customer segment performance
- Repeat customer analysis

### 🌍 Geographic Analysis
- Revenue by city
- Orders and customers by city
- Average order value by city

### 💳 Payment Analysis
- Order volume by payment method
- Revenue by payment method
- Average order value by payment method

---

## 📈 Key Insights

Based on the analysis:

- **2,499 total orders** were present in the dataset.
- **2,327 orders were delivered**, while 111 were cancelled and 61 were returned.
- Delivered revenue was approximately **₹70.14 lakh**.
- **Beauty** was the highest-revenue product category, generating approximately **₹14.57 lakh**.
- **Electronics** was the second-highest revenue category at approximately **₹14.18 lakh**.
- **UPI** was the most frequently used payment method, with **868 orders**.
- The **New customer segment** generated the highest overall revenue among customer segments.
- The **Returning customer segment** had the highest repeat-customer percentage at approximately **89.9%**.
- Monthly revenue showed fluctuations throughout 2025, with March recording one of the strongest months.
- Customer and city-level analysis highlights differences in purchasing behavior and average order value.

---

## 🧠 SQL Concepts Demonstrated

This project demonstrates practical SQL skills including:

- `SELECT`
- `WHERE`
- `GROUP BY`
- `HAVING`
- `ORDER BY`
- `JOIN`
- `INNER JOIN`
- `COUNT`
- `COUNT DISTINCT`
- `SUM`
- `AVG`
- `ROUND`
- `CASE`
- `COALESCE`
- `NULLIF`
- `WITH` / CTEs
- `LAG()`
- Window Functions
- Month-over-month calculations
- Conditional aggregation
- Customer segmentation
- Revenue analysis
- Data quality checks

---

## 🛠️ Tools & Technologies

- **MySQL**
- **MySQL Workbench**
- **SQL**
- **GitHub**

---

## 📁 Project Structure

```text
ecommerce-sales-customer-analytics/
│
├── ecommerce_analysis.sql
└── README.md
