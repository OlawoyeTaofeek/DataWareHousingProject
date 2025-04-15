-- Data Quality Check for the gold_fact_sales 

SELECT * FROM gold.fact_sales;

-- Fact Check, Check if all dimension table can successfully join to the fact table
SELECT * FROM gold.fact_sales f
LEFT join gold.dim_customers as c
on c.customer_key = f.customer_key
left join gold.dim_products as p
on p.product_key = f.product_key
WHERE p.product_key is null or c.customer_key IS NULL;