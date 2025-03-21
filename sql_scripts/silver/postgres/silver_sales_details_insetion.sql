INSERT INTO silver.crm_sales_details (
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_sales,
    sls_quantity,
    sls_price
)
-- Code to correct any possible mistake in the crm_sales_details data
SELECT 
   sls_ord_num,
   sls_prd_key,
   sls_cust_id,
   CASE 
      WHEN sls_order_dt = 0 
	  OR LENGTH(CAST(sls_order_dt AS VARCHAR(10))) != 8 
	  OR sls_order_dt > 20500101 
      OR sls_order_dt < 19000101
	    THEN NULL 
	  ELSE CAST(CAST(sls_order_dt AS varchar) AS DATE)
   END AS sls_order_dt,
   CASE 
      WHEN sls_ship_dt = 0 
	  OR LENGTH(CAST(sls_ship_dt AS VARCHAR)) != 8 
	  OR sls_ship_dt > 20500101 
      OR sls_ship_dt < 19000101
	    THEN NULL 
	  ELSE CAST(CAST(sls_ship_dt AS varchar) AS DATE)
   END AS sls_ship_dt,
   CASE 
      WHEN sls_due_dt = 0 
	  OR LENGTH(CAST(sls_due_dt AS varchar)) != 8 
	  OR sls_due_dt > 20500101 
      OR sls_due_dt < 19000101
	    THEN NULL 
	  ELSE CAST(CAST(sls_due_dt AS varchar) AS DATE)
   END AS sls_due_dt,
   CASE 
	    WHEN sls_sales != sls_price * ABS(sls_quantity)
	      OR sls_sales is NULL  OR sls_sales <= 0
		  THEN sls_quantity * ABS(sls_price)
		ELSE sls_sales
   END AS sls_sales,
   sls_quantity,
   CASE 
	    WHEN sls_price IS NULL OR sls_price <= 0
		  THEN sls_sales / NULLIF(sls_quantity, 0)
	    ELSE sls_price
   END as sls_price
FROM bronze.crm_sales_details;

SELECT *
from silver.crm_sales_details;












