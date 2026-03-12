 CREATE DATABASE ecommerce_sql_project;
 USE ecommerce_sql_project;
 SELECT * FROM orders;
 
-- Total number of orders-- 
SELECT COUNT(order_id) FROM orders;

-- Total revenue
SELECT SUM(final_amount) AS Total_revenue FROM orders;

-- Average order value

SELECT AVG(final_amount) AS Total_Average FROM orders;

-- Top 5 cities by revenue
SELECT city , ROUND(SUM(final_amount),2) AS revenue
FROM orders
GROUP BY city  
ORDER BY revenue DESC
LIMIT 5;

-- Orders per product category

SELECT product_category , COUNT(order_id)
FROM orders
GROUP BY product_category ;

-- Monthly revenue trend

SELECT MONTH(order_date) AS Month ,
 ROUND(SUM(final_amount),2) AS revenue
FROM orders
GROUP BY MONTH(order_date)
ORDER BY MONTH(order_date);

-- Year & Monthly revenue trend

SELECT YEAR(order_date) AS Year,
       MONTH(order_date) AS Month,
       ROUND(SUM(final_amount),2) AS revenue
FROM orders
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY Year, Month;

-- Revenue by payment method

SELECT payment_method,
SUM(final_amount) AS revenue 
FROM orders
GROUP BY payment_method;

-- Find Repeat Customers

SELECT customer_id, COUNT(*) AS Order_Count
FROM orders
GROUP BY customer_id
HAVING COUNT(*) > 1; 

-- TOP 10 loyal customers

SELECT customer_id, COUNT(*) AS Order_Count
FROM orders
GROUP BY customer_id
HAVING COUNT(*) > 5
ORDER BY COUNT(*) > 5 DESC
LIMIT 10 ; 

-- Monthly Growth Rate
SELECT 
    YEAR(order_date) AS year,
    MONTH(order_date) AS month,
    SUM(final_amount) AS revenue,
    LAG(SUM(final_amount)) OVER (ORDER BY YEAR(order_date), MONTH(order_date)) AS previous_month,
    (SUM(final_amount) - LAG(SUM(final_amount)) OVER (ORDER BY YEAR(order_date), MONTH(order_date)))
    / LAG(SUM(final_amount)) OVER (ORDER BY YEAR(order_date), MONTH(order_date)) * 100 AS growth_percent
FROM orders
GROUP BY year, month;

-- Category Contribution Percentage
SELECT product_category,
      ROUND(SUM(final_amount) * 100 / (SELECT SUM(final_amount) FROM orders),2) AS contribution_percent
FROM orders
GROUP BY product_category;

-- Rank Customers by Spending
SELECT customer_id,
       ROUND(SUM(final_amount),2) AS total_spent,
       RANK() OVER (ORDER BY SUM(final_amount) DESC) AS ranking
FROM orders
GROUP BY customer_id;


-- Most Profitable City

SELECT city,
       ROUND(SUM(final_amount),2) AS total_revenue,
       RANK() OVER (ORDER BY SUM(final_amount) DESC) AS city_rank
FROM orders
GROUP BY city;


SELECT *
FROM (
      SELECT YEAR(order_date) AS year,
             MONTH(order_date) AS month,
             product_category,
             SUM(final_amount) AS revenue,
             RANK() OVER(
                    PARTITION BY YEAR(order_date), MONTH(order_date)
                    ORDER BY SUM(final_amount) DESC
             ) AS rnk
      FROM orders
      GROUP BY YEAR(order_date), MONTH(order_date), product_category
) t
WHERE rnk <= 2;




SELECT *
FROM (
        SELECT product_category,
               SUM(final_amount) AS category_revenue,
               ROUND(AVG(SUM(final_amount)) OVER(),2) AS avg_revenue
        FROM orders
        GROUP BY product_category
     ) t
WHERE category_revenue > avg_revenue;



