-- Gold Layer Data Ingestion and Data Checck
SELECT top 5 * from silver.crm_cust_info;
SELECT top 5 * from silver.erp_cust_az12;
SELECT top 5 * from silver.erp_loc_a101;

SELECT 
     top 100
     ci.cst_key as CustomerKey,
     ci.cst_id as CustomerId,
	 ci.cst_firstname as first_name,
	 ci.cst_lastname as last_name,
	 la.cntry as country,
	 ci.cst_marital_status as marital_status,
	 ci.cst_gndr as gender,
	 ca.bdate as birthdate,
	 ci.cst_create_date,
	 ca.gen as gender
FROM silver.crm_cust_info as ci
LEFT JOIN silver.erp_cust_az12 as ca
on ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 as la
on ci.cst_key = la.cid;

-- Check for duplicate
SELECT CustomerId, COUNT(*) FROM 
  (
	SELECT 
		 ci.cst_key as CustomerKey,
		 ci.cst_id as CustomerId,
		 ci.cst_firstname as first_name,
		 ci.cst_lastname as last_name,
		 la.cntry as country,
		 ci.cst_marital_status as marital_status,
		 ci.cst_gndr as gender,
		 ca.bdate as birthdate,
		 ci.cst_create_date
	FROM silver.crm_cust_info as ci
	LEFT JOIN silver.erp_cust_az12 as ca
	on ci.cst_key = ca.cid
	LEFT JOIN silver.erp_loc_a101 as la
	on ci.cst_key = la.cid
) as t
GROUP BY CustomerId
HAVING COUNT(*) > 1;

-- Problem of two gender columns
SELECT
     DISTINCT
	 ci.cst_gndr as gender,
	 ca.gen as gender,
	 CASE 
	     WHEN ci.cst_gndr <> 'Unknown' THEN ci.cst_gndr -- CRM is the Master source for gender info
		 ELSE COALESCE(ca.gen, 'Unknown')
	 END AS new_gen
FROM silver.crm_cust_info as ci
LEFT JOIN silver.erp_cust_az12 as ca
on ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 as la
on ci.cst_key = la.cid
order by 1, 2;

-- Testing the gold.dim_customers view created
SELECT TOP 5 * FROM gold.dim_customers;

SELECT distinct gender from gold.dim_customers;

-- Generating the product Table
SELECT 
   pn.prd_id,
   pn.cat_id,
   pn.prd_key,
   pn.prd_nm,
   pn.prd_cost,
   pn.prd_line,
   pn.prd_start_dt,
   pc.cat,
   pc.subcat,
   pc.maintenance
FROM silver.crm_prd_info as pn
Left JOIN silver.erp_px_cat_g1v2 as pc
ON pn.cat_id = pc.id
-- Filter out all historical data
WHERE prd_end_dt IS NULL; 
-- If end_dt is NULL, then it is the current info of the product!
 
-- Check if the prd_key is unique
select prd_key, COUNT(*)
from (
	SELECT 
	   pn.prd_id,
	   pn.cat_id,
	   pn.prd_key,
	   pn.prd_nm,
	   pn.prd_cost,
	   pn.prd_line,
	   pn.prd_start_dt,
	   pc.cat,
	   pc.subcat,
	   pc.maintenance
	FROM silver.crm_prd_info as pn
	Left JOIN silver.erp_px_cat_g1v2 as pc
	ON pn.cat_id = pc.id
	-- Filter out all historical data
	WHERE prd_end_dt IS NULL) as t
GROUP BY prd_key
HAVING CoUNT(*) > 1;

-- Test our products
SELECT * froM gold.dim_products;

-- Creatingt Fact Table
SELECT * FROM silver.crm_sales_details;

SELECT
    sd.sls_ord_num  AS order_number,
    pr.product_key  AS product_key,
    cu.customer_key AS customer_key,
    sd.sls_order_dt AS order_date,
    sd.sls_ship_dt  AS shipping_date,
    sd.sls_due_dt   AS due_date,
    sd.sls_sales    AS sales_amount,
    sd.sls_quantity AS quantity,
    sd.sls_price    AS price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products pr
    ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers cu
    ON sd.sls_cust_id = cu.customer_id;