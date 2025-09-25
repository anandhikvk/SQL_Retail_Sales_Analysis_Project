--SQL Retail Analysis  Project
CREATE DATABASE sql_retails_project1;

--create table
DROP TABLE IF EXISTS retails_sales;
CREATE TABLE retails_sales (
	transaction_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(15),
	age INT,
	category VARCHAR(15),
	quantity FLOAT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
	);

SELECT * FROM retails_sales LIMIT 10;

SELECT COUNT(*) FROM retails_sales;

SELECT * FROM retails_sales
WHERE transaction_id is NULL;

---DATA CLEANING---
SELECT * FROM retails_sales
WHERE 
	transaction_id is NULl
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

DELETE FROM retails_sales
WHERE 
	transaction_id is NULl
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

--DATA EXPLORATION--
--HOW MANY SALES WE HAVE
SELECT COUNT(total_sale) from retails_sales;
--HOW MANY UNIQUES CUSTOMERS WE HAVE
SELECT COUNT(distinct(customer_id)) from retails_sales;
--HOW MANY UNIQUE CATEGORY WE HAVE
SELECT DISTINCT(category) from retails_sales;

--DATA ANALYSIS
--BUSINESS PROBLEMS 
--Q1.WRITE A SQL QUERY TO RETRIEVE ALL COLUMNS FOR SALES MADE ON '2022-11-05'
SELECT * FROM retails_sales 
WHERE sale_date='2022-11-05';

--Q2. WRITE A SQL QUERY TO RETRIEVE ALL TRANSACTIONS WHERE THE CATEGORY IS 'CLOTHING' AND THE 
--QUANTITY SOLD IS MORE THAN 10 IN THE MONTH OF NOV-2022
SELECT * FROM retails_sales 
WHERE category='Clothing' AND 
TO_CHAR(sale_date,'YYYY-MM')='2022-11'
AND quantity >=4;

--Q3.write a sql query to calculate the total sales for each category
select distinct(category) from retails_sales;
select sum(total_sale),category from retails_sales
group by category;

---Q4.write a sql query to find the average age of customers who purchased items from the 'beauty' category
SELECT round(avg(age)),category from retails_sales 
where category='Beauty'
group by category;

--Q5.write a SQL query to find all the transactions where the total sales is greter than 1000
select * from retails_sales 
where total_sale >= 1000;

--Q6. write a sql query to find the total number of transactions (transaction_id) made by each gender in each category
select count(transaction_id),gender,category
from retails_sales
group by gender,category
order by category;

--Q7.write a sql query to calculate the avg sales for each month. find out best selling month of the year. 
select * from (select 
EXTRACT(year from sale_date) as year,
EXTRACT(month from sale_date) as month,
round(avg(total_sale)) as total_sales,
RANK() over (partition by EXTRACT(year from sale_date) order by avg(total_sale) desc) as rank
from retails_sales
group by year,month) as t1 
where rank =1
--order by year,total_sales desc;

--Q8. write a sql query to find the  top 5 customers based on the highest total sales
select sum(total_sale) as total_sales,customer_id,
rank() over (order by sum(total_sale) desc)
from retails_sales
group by customer_id
order by total_sales desc
limit 5

--Q9. write a sql query to find the no of unique customers who purchased items from each category 
select count(distinct(customer_id)),category
from retails_sales
group by category

--Q10.write a sql query to create each shift and no of orders
--ex/;morning <=12,afternoon b/w 12&17, evening >17)
with hourly_rate
as
(
select *, 
case 
	when extract(hour from sale_time) < 12 then 'morning'
	when extract(hour from sale_time) between 12 and 17 then 'noon'
	else 'evening'
end as shift	
from retails_sales
)
select * from hourly_rate
group by shift
