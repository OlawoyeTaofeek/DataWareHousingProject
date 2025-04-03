SELECT "Product ID", "Product Name", "Product Category", Price
	FROM public.products;
-- 
SELECT COUNT(DISTINCT "Product Category") as unique_prodct_cat
FROM products;

-- INNER JOIN
SELECT *
FROM products as p 
INNER JOIN sales as s
USING ("Product ID");

SELECT p."Product ID",
       s."Sale ID",
       p."Product Name",
	   p."Product Category",
	   s.date,
	   p.price,
	   s.units
FROM products as p 
INNER JOIN sales as s
ON p."Product ID" = s."Product ID"
limit 10;


SELECT COUNT(*)
FROM products as p 
INNER JOIN sales as s
USING ("Product ID");

SELECT COUNT(*)
FROM products as p 
LEFT JOIN sales as s
USING ("Product ID");

-- Product category by sales count
SELECT p."Product Category",
       COUNT(*) AS Number_of_sales
FROM products as p 
left JOIN sales as s
ON p."Product ID" = s."Product ID"
GROUP BY p."Product Category"
ORDER BY Number_of_sales desc;

/*
Adding columns using the alter table

ALTER TABLE table_name
ADD COLUMN column_name dtype;
*/
ALTER TABLE sales
ADD COLUMN revenue NUMERIC(6, 2);

INSERT INTO sales (revenue)
SELECT price * units
from sales;

UPDATE sales 
set revenue = price * units;


SELECT p."Product Category",
       SUM(revenue) as Total_revenue
FROM products as p 
left JOIN sales as s
ON p."Product ID" = s."Product ID"
GROUP BY p."Product Category"
ORDER BY Total_revenue desc
LIMIT 2;


SELECT p."Product Name",
       SUM(revenue) as Total_revenue
FROM products as p 
left JOIN sales as s
ON p."Product ID" = s."Product ID"
GROUP BY p."Product Name"
ORDER BY Total_revenue desc
LIMIT 5;

SELECT *
FROM products
CROSS JOIN sales;


