DROP TABLE IF EXISTS zepto;

CREATE TABLE zepto(
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) not null,
mrp NUMERIC (8,2),
DISCOUNTPERCENT NUMERIC(5,2),
availablequantity INTEGER,
discountedsellingprice NUMERIC(8,2),
weightingms INTEGER,
outofstock BOOLEAN,
quantity INTEGER
);

SELECT *
FROM zepto
*


--count of rows
SELECT COUNT(*)
FROM zepto

--sample data
SELECT *
FROM zepto
LIMIT 10;

--NULL VALUES
SELECT *
FROM zepto
WHERE name is NULL
OR category is NULL OR mrp is NULL OR discountpercent is NULL OR availablequantity is NULL 
OR discountedsellingprice is NULL OR weightingms is NULL OR quantity is NULL;

-- different product categories
SELECT DISTINCT category
FROM zepto
ORDER BY category;

--product instock vs out of stock
SELECT outofstock, COUNT(sku_id)
FROM zepto
GROUP BY outofstock;

--products names present multiple times
SELECT name,count(sku_id) AS product_count
FROM zepto
GROUP BY name
HAVING COUNT(sku_id)>1
ORDER BY count(sku_id) DESC;

--data cleaning

--products with price 0
SELECT sku_id,category,name,mrp,discountedsellingprice
FROM zepto
WHERE mrp = 0 OR discountedsellingprice = 0;

DELETE FROM zepto
WHERE mrp = 0;

--conversion of price in rupees
UPDATE zepto
SET mrp = mrp/100.0,
	discountedsellingprice = discountedsellingprice/100.0;

SELECT *
FROM zepto
ORDER BY sku_id

--Found top 10 best-value products based on discount percentage
SELECT DISTINCT name,mrp,discountpercent
FROM zepto
ORDER BY discountpercent DESC
LIMIT 10;

--Identified high-MRP products that are currently out of stock
SELECT DISTINCT name,mrp,outofstock
FROM zepto
WHERE outofstock ='True'
ORDER BY mrp DESC

--Estimated potential revenue for each product category
SELECT category, SUM(discountedsellingprice * availablequantity ) AS total_revenue
FROM zepto
GROUP by category
ORDER BY total_revenue ;

--Filtered expensive products (MRP > ₹500) with  discount < 10%
SELECT DISTINCT name,mrp,discountpercent
FROM zepto
WHERE mrp>500 AND discountpercent < 10
ORDER BY mrp DESC,discountpercent DESC;

--top 5 categories offering highest average discounts
SELECT category,
	ROUND(AVG(discountpercent),2) AS avg_discount
	FROM zepto
	GROUP BY category
	ORDER BY avg_discount DESC
	LIMIT 5;

--Calculated price per gram for products above 100g and sort by best value 
SELECT DISTINCT name,weightingms,discountedsellingprice,
ROUND(discountedsellingprice/weightingms,2) AS price_per_gm
FROM zepto
WHERE weightingms>=100
ORDER by price_per_gm;

--Grouped products based on weight into Low, Medium, and Bulk categories
SELECT DISTINCT name,weightingms,
CASE WHEN weightingms < 1000 THEN 'LOW'
	 WHEN weightingms < 5000 THEN 'MEDIUM'
	 ELSE 'BULK'
	 END AS weight_category
FROM zepto;	 

--Measured total inventory weight per product category
SELECT category,
SUM(weightingms*availablequantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;